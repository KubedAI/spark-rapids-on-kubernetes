# Name of the VPC and EKS Cluster
variable "name" {
  description = "Name of the VPC and EKS Cluster. This will be used as a prefix for all resources created in this project."
  type        = string
  default     = "spark-rapids-eks"
}

# AWS region where the infrastructure will be deployed
variable "region" {
  description = "AWS region where the EKS cluster and associated infrastructure will be deployed. Ensure that the selected region supports the required services (e.g., EKS, EC2 with GPU, etc.)."
  type        = string
  default     = "us-west-2"
}

# EKS Cluster version
variable "eks_cluster_version" {
  description = "Version of the EKS Kubernetes cluster to be deployed. Ensure this is compatible with the desired workload and add-ons (e.g., Spark, JupyterHub)."
  type        = string
  default     = "1.31"
}

# VPC CIDR block for the primary network
variable "vpc_cidr" {
  description = "The primary CIDR block for the VPC, defining the IP address range. This should be a valid private (RFC 1918) CIDR block, typically used for internal networks."
  type        = string
  default     = "10.1.0.0/21"
}

# Secondary CIDR blocks for extended networking capabilities
variable "secondary_cidr_blocks" {
  description = <<EOT
A list of secondary CIDR blocks to attach to the VPC. These CIDR blocks are typically used for extending the available IP address space within the VPC for additional networking needs (e.g., large-scale workloads or isolated subnet designs).
Example: "100.64.0.0/16" is commonly used for carrier-grade NAT or internal network ranges.
EOT
  type        = list(string)
  default     = ["100.64.0.0/16"]
}

# KMS Key Admin Roles
variable "kms_key_admin_roles" {
  description = <<EOT
A list of AWS IAM Role ARNs to be added to the KMS (Key Management Service) policy. These roles will have administrative permissions to manage encryption keys used for securing sensitive data within the cluster.
Ensure that these roles are trusted and have the necessary access to manage encryption keys.
EOT
  type        = list(string)
  default     = []
}

# Access Entries for Cluster Access Control
variable "access_entries" {
  description = <<EOT
Map of access entries to be added to the EKS cluster. This can include IAM users, roles, or groups that require specific access permissions (e.g., admin access, developer access) to the cluster.
The map should follow the structure:
{
  "role_arn": "arn:aws:iam::123456789012:role/AdminRole",
  "username": "admin"
}
EOT
  type        = any
  default     = {}
}

variable "enable_yunikorn" {
  description = "Flag to enable the Apache Yunikorn batch scheduler on the Kubernetes cluster."
  type        = bool
  default     = false
}

variable "enable_volcano" {
  description = "Flag to enable the Volcano batch scheduler on the Kubernetes cluster."
  type        = bool
  default     = false
}
