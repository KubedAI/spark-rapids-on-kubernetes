# TODO: Add FluentBit, Prometheus & Grafana and Spark History Server

#---------------------------------------------------------------
# Data on EKS Kubernetes Addons
#---------------------------------------------------------------
module "eks_data_addons" {
  source  = "aws-ia/eks-data-addons/aws"
  version = "1.34" # ensure to update this to the latest/desired version

  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_nvidia_device_plugin = true
  nvidia_device_plugin_helm_config = {
    version = "v0.16.2"
    name    = "nvidia-device-plugin"
    values = [
      <<-EOT
        gfd:
          enabled: true
        nfd:
          worker:
            tolerations:
              - key: nvidia.com/gpu
                operator: Exists
                effect: NoSchedule
              - operator: "Exists"
      EOT
    ]
  }

  enable_spark_operator = true
  spark_operator_helm_config = {
    version = "2.0.2"
    values = [
      <<-EOT
        spark:
          # -- List of namespaces where to run spark jobs.
          # If empty string is included, all namespaces will be allowed.
          # Make sure the namespaces have already existed.
          jobNamespaces:
            - default
            - data-eng-team
            - data-science-team
          serviceAccount:
            # -- Specifies whether to create a service account for the controller.
            create: false
          rbac:
            # -- Specifies whether to create RBAC resources for the controller.
            create: false
      EOT
    ]
  }

  enable_yunikorn = var.enable_yunikorn
  yunikorn_helm_config = {
    version = "1.6.0"
  }

  enable_volcano = var.enable_volcano

  enable_spark_history_server = true
  spark_history_server_helm_config = {
    values = [
      <<-EOT
      sparkHistoryOpts: "-Dspark.history.fs.logDirectory=s3a://${module.s3_bucket.s3_bucket_id}/${aws_s3_object.this.key}"
      EOT
    ]
  }

}
