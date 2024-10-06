# ---------------------------------------------------------------
# AWS Provider Configuration
# ---------------------------------------------------------------
# The primary AWS provider, used for interacting with resources in the region specified by 'var.region'.
provider "aws" {
  region = local.region
}

# Secondary AWS provider for ECR (Elastic Container Registry) authentication.
# ECR public authentication requires the 'us-east-1' region, which is hardcoded here.
# If your main region is 'us-east-1', you can remove this second provider and use the primary one.
provider "aws" {
  alias  = "ecr"
  region = "us-east-1"
}

# ---------------------------------------------------------------
# Helm Provider Configuration
# ---------------------------------------------------------------
# The Helm provider is used to manage Kubernetes applications, relying on the EKS cluster.
provider "helm" {
  kubernetes {
    # The EKS cluster API endpoint and certificate are retrieved from the EKS module.
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      # Retrieves an authentication token for Kubernetes API using the AWS CLI.
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      # Note: The AWS CLI must be installed locally where Terraform is executed.
    }
  }
}

# ---------------------------------------------------------------
# Local Variables
# ---------------------------------------------------------------
# These locals store reusable values for the project, such as the name, region, and tags.
locals {
  # Name and region variables for naming consistency across resources.
  name   = var.name
  region = var.region

  # Limiting Availability Zones to two for resource allocation.
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  # Project tags for tracking and referencing the GitHub repository.
  tags = {
    GithubRepo = "github.com/KubedAI/spark-rapids-on-kubernetes"
  }
}

# ---------------------------------------------------------------
# AWS Data Sources
# ---------------------------------------------------------------
# Data sources used to retrieve AWS-specific information such as current identity, region, and session context.

# EKS cluster authentication data
# data "aws_eks_cluster_auth" "this" {
#   name = module.eks.cluster_name
# }

# Retrieves an authorization token for public ECR registry to authenticate image pulls.
data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.ecr
}

# Retrieves all available AWS availability zones in the selected region.
data "aws_availability_zones" "available" {}

# Retrieves the current AWS region.
# data "aws_region" "current" {}

# Retrieves the AWS account and caller identity details for the session.
data "aws_caller_identity" "current" {}

# Retrieves the current AWS partition (useful for AWS GovCloud or China regions).
# data "aws_partition" "current" {}

# Retrieves the IAM session context, including the ARN of the currently logged-in user/role.
data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

# ---------------------------------------------------------------
# IAM Policy Document for Spark Operator
# ---------------------------------------------------------------
# This IAM policy document allows the Spark operator to interact with S3 and CloudWatch Logs for logging and object storage.

# Policy granting permissions for S3 operations required by Spark jobs.
# data "aws_iam_policy_document" "spark_operator" {
#   statement {
#     sid    = "AllowS3AccessForSparkJobs"
#     effect = "Allow"
#     # Grants access to all S3 resources in the current AWS partition.
#     resources = ["arn:${data.aws_partition.current.partition}:s3:::*"]

#     actions = [
#       "s3:DeleteObject",
#       "s3:DeleteObjectVersion",
#       "s3:GetObject",
#       "s3:ListBucket",
#       "s3:PutObject",
#     ]
#   }

#   # Policy granting permissions for CloudWatch Logs operations.
#   statement {
#     sid    = "AllowCloudWatchLogsAccessForSpark"
#     effect = "Allow"
#     # Grants access to all CloudWatch Log Groups in the current AWS region and account.
#     resources = [
#       "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:*"
#     ]

#     actions = [
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:DescribeLogGroups",
#       "logs:DescribeLogStreams",
#       "logs:PutLogEvents",
#     ]
#   }
# }
