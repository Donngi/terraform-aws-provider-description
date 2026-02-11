# =====================================================================================================================
# Terraform AWS Resource Template: aws_ecr_repository_policy
# =====================================================================================================================
# Generated: 2026-01-22
# Provider Version: hashicorp/aws 6.28.0
#
# Note: This template represents the configuration available at the time of generation.
#       Always refer to the official documentation for the most up-to-date specifications.
#
# AWS Provider Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy
#
# AWS Service Documentation:
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policies.html
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policy-examples.html
# =====================================================================================================================

# ---------------------------------------------------------------------------------------------------------------------
# Resource: aws_ecr_repository_policy
# ---------------------------------------------------------------------------------------------------------------------
# Provides an Elastic Container Registry Repository Policy.
#
# IMPORTANT:
# - Currently only one policy may be applied to a repository
# - Users must have permission to call ecr:GetAuthorizationToken API through an IAM policy
#   before they can authenticate and interact with any Amazon ECR repository
# - Repository policies are resource-based permissions that control access to individual repositories
# - Both repository policies and IAM policies work together to determine access permissions
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecr_repository_policy" "example" {
  # ===================================================================================================================
  # REQUIRED ARGUMENTS
  # ===================================================================================================================

  # -------------------------------------------------------------------------------------------------------------------
  # repository - (Required, string)
  # -------------------------------------------------------------------------------------------------------------------
  # Name of the repository to apply the policy.
  #
  # This should match the name of an existing ECR repository where you want to attach this policy.
  # Only one policy can be applied per repository.
  #
  # Example: "my-app-repository"
  # -------------------------------------------------------------------------------------------------------------------
  repository = "example-repo"

  # -------------------------------------------------------------------------------------------------------------------
  # policy - (Required, string)
  # -------------------------------------------------------------------------------------------------------------------
  # The policy document in JSON format.
  #
  # This is a JSON formatted string that defines the resource-based permissions for the repository.
  # Repository policies control what actions users, roles, or AWS services can perform on the repository.
  #
  # Common use cases:
  # - Grant cross-account access to pull/push images
  # - Allow specific AWS services (e.g., CodeBuild, Lambda) to access the repository
  # - Restrict access based on IP addresses or VPC endpoints
  #
  # For building IAM policy documents with Terraform, use the aws_iam_policy_document data source.
  # See: https://learn.hashicorp.com/terraform/aws/iam-policy
  #
  # Common ECR actions:
  # - ecr:GetDownloadUrlForLayer
  # - ecr:BatchGetImage
  # - ecr:BatchCheckLayerAvailability
  # - ecr:PutImage
  # - ecr:InitiateLayerUpload
  # - ecr:UploadLayerPart
  # - ecr:CompleteLayerUpload
  # - ecr:DescribeRepositories
  # - ecr:GetRepositoryPolicy
  # - ecr:ListImages
  # - ecr:DeleteRepository
  # - ecr:BatchDeleteImage
  # - ecr:SetRepositoryPolicy
  # - ecr:DeleteRepositoryPolicy
  #
  # Example policy structure:
  # {
  #   "Version": "2012-10-17",
  #   "Statement": [
  #     {
  #       "Sid": "AllowPull",
  #       "Effect": "Allow",
  #       "Principal": {
  #         "AWS": "arn:aws:iam::123456789012:root"
  #       },
  #       "Action": [
  #         "ecr:GetDownloadUrlForLayer",
  #         "ecr:BatchGetImage",
  #         "ecr:BatchCheckLayerAvailability"
  #       ]
  #     }
  #   ]
  # }
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policy-examples.html
  # -------------------------------------------------------------------------------------------------------------------
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ExamplePolicy"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
        ]
      }
    ]
  })

  # ===================================================================================================================
  # OPTIONAL ARGUMENTS
  # ===================================================================================================================

  # -------------------------------------------------------------------------------------------------------------------
  # region - (Optional, string)
  # -------------------------------------------------------------------------------------------------------------------
  # Region where this resource will be managed.
  #
  # By default, this resource will be created in the region specified in the provider configuration.
  # Use this argument to override the default region for this specific resource.
  #
  # This is useful for multi-region deployments or when you need to manage resources in a region
  # different from your default provider configuration.
  #
  # Example: "us-east-1", "eu-west-1", "ap-northeast-1"
  #
  # AWS Regional Endpoints Documentation:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # Provider Configuration Reference:
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # -------------------------------------------------------------------------------------------------------------------
  # region = "us-east-1"

  # -------------------------------------------------------------------------------------------------------------------
  # id - (Optional, string)
  # -------------------------------------------------------------------------------------------------------------------
  # Resource identifier.
  #
  # While this is technically an optional attribute, it is automatically computed by Terraform.
  # In most cases, you should not need to set this explicitly as Terraform will manage it automatically.
  # The ID is typically computed as the repository name.
  # -------------------------------------------------------------------------------------------------------------------
  # id = null

  # ===================================================================================================================
  # COMPUTED ATTRIBUTES (Read-Only)
  # ===================================================================================================================
  # The following attributes are exported by this resource but cannot be set in the configuration:
  #
  # - registry_id (string): The registry ID where the repository was created.
  #                         This is the AWS account ID that owns the registry.
  # ===================================================================================================================
}

# ---------------------------------------------------------------------------------------------------------------------
# USAGE EXAMPLE WITH DATA SOURCE
# ---------------------------------------------------------------------------------------------------------------------
# Best practice: Use aws_iam_policy_document data source to build the policy instead of hardcoding JSON
# ---------------------------------------------------------------------------------------------------------------------

# data "aws_iam_policy_document" "example" {
#   statement {
#     sid    = "AllowCrossAccountAccess"
#     effect = "Allow"
#
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::123456789012:root"]
#     }
#
#     actions = [
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:BatchGetImage",
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:PutImage",
#       "ecr:InitiateLayerUpload",
#       "ecr:UploadLayerPart",
#       "ecr:CompleteLayerUpload",
#     ]
#   }
# }
#
# resource "aws_ecr_repository" "example" {
#   name = "example-repo"
# }
#
# resource "aws_ecr_repository_policy" "example" {
#   repository = aws_ecr_repository.example.name
#   policy     = data.aws_iam_policy_document.example.json
# }
