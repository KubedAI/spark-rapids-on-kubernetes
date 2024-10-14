---
sidebar_position: 1
sidebar_label: Installation
---

# 🚀 Deploying Apache Spark RAPIDS on Amazon EKS

This guide provides instructions to deploy Apache Spark RAPIDS on an Amazon EKS Cluster using Terraform. The Terraform configuration will provision an EKS cluster, install necessary add-ons, and configure Karpenter for autoscaling. Spark RAPIDS will be installed for GPU acceleration on the cluster.

## Prerequisites 📋

Before deploying, ensure the following prerequisites are met.

- Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- Install [Terraform](https://developer.hashicorp.com/terraform/install)

- Install [kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html) to interact with the Kubernetes cluster

- Install [Helm](https://helm.sh/docs/intro/install/)


## Deployment Steps 🖥️

Follow the below steps to create your EKS cluster with all the necessary addons.

**Step 1**: Clone the Repository 📂

```
git clone https://github.com/KubedAI/spark-rapids-on-kubernetes.git
cd spark-rapids-on-kubernetes/infra/aws/terraform
```

**Step 2**: Configure Terraform Backend ⚙️

By default, the blueprint uses the latest and greatest EKS version and `us-west-2` as the default region.

You can customize the terraform configuration that comes pre-built with this blueprint. Update the `variables.tf` file to use a different EKS version, AWS region and other parameters.

**Step 3**: Initialize and Apply Terraform 🚀

To install the EKS cluster with all the addons in one step, run the below commands. The `install.sh` script wraps the `terraform init` and deploys the terraform modules as targets with `terraform apply`.

```
cd spark-rapids-on-kubernetes/scripts
chmod +x install.sh
./install.sh
```

## Verifying the Deployment ✅

To verify the status of the EKS cluster and the resources, run the below commands.

    
```
kubectl get nodes

kubectl get po -A

```

