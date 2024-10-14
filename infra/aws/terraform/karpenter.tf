
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.24"

  cluster_name          = module.eks.cluster_name
  enable_v1_permissions = true

  enable_pod_identity             = true
  create_pod_identity_association = true

  # Used to attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = local.tags

  depends_on = [
    module.eks
  ]
}

# Deploy Karpenter using Helm
resource "helm_release" "karpenter" {
  namespace           = "kube-system"
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "1.0.6"
  wait                = false

  values = [
    <<-EOT
    serviceAccount:
      name: ${module.karpenter.service_account}
    settings:
      clusterName: ${module.eks.cluster_name}
      clusterEndpoint: ${module.eks.cluster_endpoint}
      interruptionQueue: ${module.karpenter.queue_name}
    EOT
  ]
  depends_on = [
    module.karpenter
  ]
}

# Define an EC2NodeClass for AL2023 node instances
resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1
    kind: EC2NodeClass
    metadata:
      name: al2023
    spec:
      role: ${module.karpenter.node_iam_role_name}
      subnetSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${module.eks.cluster_name}
      securityGroupSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${module.eks.cluster_name}
      tags:
        karpenter.sh/discovery: ${module.eks.cluster_name}
      blockDeviceMappings:
        - deviceName: /dev/xvda
          ebs:
            volumeSize: 100Gi
            volumeType: gp3
      amiSelectorTerms:
        - alias: al2023@latest # Amazon Linux 2023
      instanceStorePolicy: RAID0
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}

# Create a Karpenter NodePool using the AL2023 NodeClass
resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1
    kind: NodePool
    metadata:
      name: default
    spec:
      template:
        metadata:
          labels:
            node-type: default
        spec:
          nodeClassRef:
            group: karpenter.k8s.aws
            kind: EC2NodeClass
            name: al2023
          expireAfter: 720h # 30 * 24h = 720h
          requirements:
            - key: "karpenter.k8s.aws/instance-category"
              operator: In
              values: ["c", "m", "r"]
            - key: "karpenter.k8s.aws/instance-cpu"
              operator: In
              values: ["4", "8", "16", "32"]
            - key: "karpenter.k8s.aws/instance-hypervisor"
              operator: In
              values: ["nitro"]
            - key: "karpenter.k8s.aws/instance-generation"
              operator: Gt
              values: ["2"]
      limits:
        cpu: 1000
      disruption:
        consolidationPolicy: WhenEmptyOrUnderutilized
        consolidateAfter: 5m
  YAML

  depends_on = [
    kubectl_manifest.karpenter_node_class
  ]
}

# NVMe SSD Nodepool using the AL2023 NodeClass
resource "kubectl_manifest" "nvme_ssd_x86" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1
    kind: NodePool
    metadata:
      name: ssd-x86
    spec:
      template:
        metadata:
          labels:
            node-type: ssd-x86
        spec:
          nodeClassRef:
            group: karpenter.k8s.aws
            kind: EC2NodeClass
            name: al2023
          expireAfter: 720h # 30 * 24h = 720h
          requirements:
            - key: "karpenter.k8s.aws/instance-family"
              operator: In
              values: ["c5d", "m5d", "r5d"]
            - key: "karpenter.k8s.aws/instance-cpu"
              operator: In
              values: ["4", "8"]
            - key: "karpenter.k8s.aws/instance-hypervisor"
              operator: In
              values: ["nitro"]
            - key: "karpenter.k8s.aws/instance-generation"
              operator: Gt
              values: ["2"]
      limits:
        cpu: 1000
      disruption:
        consolidationPolicy: WhenEmptyOrUnderutilized
        consolidateAfter: 5m
  YAML

  depends_on = [
    kubectl_manifest.karpenter_node_class
  ]
}

# Define an EC2NodeClass for GPU instances
resource "kubectl_manifest" "gpu" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1
    kind: EC2NodeClass
    metadata:
      name: gpu
    spec:
      role: ${module.karpenter.node_iam_role_name}
      subnetSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${module.eks.cluster_name}
      securityGroupSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${module.eks.cluster_name}
      tags:
        karpenter.sh/discovery: ${module.eks.cluster_name}
      amiSelectorTerms:
        - alias: al2023@latest # Amazon Linux 2023
      instanceStorePolicy: RAID0
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}

# Create a default NodePool referencing the GPU NodeClass
# Create GPU instances with 1 GPU. e.g., g5x.large to g5.16xlarge
resource "kubectl_manifest" "g_a10g_single" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1
    kind: NodePool
    metadata:
      name: g-a10g-single
    spec:
      template:
        metadata:
          labels:
            node-type: g-a10g-single
        spec:
          nodeClassRef:
            group: karpenter.k8s.aws
            kind: EC2NodeClass
            name: gpu
          expireAfter: 720h # 30 * 24h = 720h
          requirements:
            - key: "karpenter.k8s.aws/instance-gpu-count"
              operator: In
              values: ["1"]
            - key: "karpenter.k8s.aws/instance-category"
              operator: In
              values: ["g"]
            - key: "karpenter.k8s.aws/instance-cpu"
              operator: In
              values: ["4", "8"]
            - key: "karpenter.k8s.aws/instance-hypervisor"
              operator: In
              values: ["nitro"]
            - key: "karpenter.k8s.aws/instance-family"
              operator: In
              values: ["g5", "g6"]
          taints:
            - key: nvidia.com/gpu
              value: "true"
              effect: NoSchedule
      limits:
        cpu: 1000
        nvidia.com/gpu: 10
      disruption:
        consolidationPolicy: WhenEmptyOrUnderutilized
        consolidateAfter: 5m
  YAML

  depends_on = [
    kubectl_manifest.gpu
  ]
}

# Create a GPU Nodepool for MultiGPU Node
resource "kubectl_manifest" "g_a10g_multigpu" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1
    kind: NodePool
    metadata:
      name: g-a10g-multigpu
    spec:
      template:
        metadata:
          labels:
            node-type: g-a10g-multigpu
        spec:
          nodeClassRef:
            group: karpenter.k8s.aws
            kind: EC2NodeClass
            name: gpu
          expireAfter: 720h # 30 * 24h = 720h
          requirements:
            - key: "karpenter.k8s.aws/instance-gpu-count"
              operator: Gt
              values: ["1"]
            - key: "karpenter.k8s.aws/instance-category"
              operator: In
              values: ["g"]
            - key: "karpenter.k8s.aws/instance-cpu"
              operator: In
              values: ["48", "96", "192"]
            - key: "karpenter.k8s.aws/instance-hypervisor"
              operator: In
              values: ["nitro"]
            - key: "karpenter.k8s.aws/instance-family"
              operator: In
              values: ["g5", "g6"]
          taints:
            - key: nvidia.com/gpu
              value: "true"
              effect: NoSchedule
      limits:
        cpu: 1000
        nvidia.com/gpu: 16
      disruption:
        consolidationPolicy: WhenEmptyOrUnderutilized
        consolidateAfter: 5m
  YAML

  depends_on = [
    kubectl_manifest.gpu
  ]
}
