################################################################################
# AWS FinSpace Kx User
################################################################################
# Terraform resource for managing an AWS FinSpace Kx User.
#
# FinSpace is Amazon's managed service for financial data analysis using kdb+.
# This resource creates a user in a FinSpace kdb environment and associates it
# with an IAM role for authentication and authorization.
#
# IMPORTANT: Amazon FinSpace will no longer be available after October 7, 2026.
# Existing customers can continue to use the service until then, but will not be
# able to create new users or access the service after that date.
#
# AWS Documentation:
# - FinSpace User Guide: https://docs.aws.amazon.com/finspace/latest/userguide/
# - CreateKxUser API: https://docs.aws.amazon.com/finspace/latest/management-api/API_CreateKxUser.html
# - UpdateKxUser API: https://docs.aws.amazon.com/finspace/latest/management-api/API_UpdateKxUser.html
# - KxUser Structure: https://docs.aws.amazon.com/finspace/latest/management-api/API_KxUser.html
#
# Terraform Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/finspace_kx_user
#
# Generated: 2026-01-23
# Provider Version: 6.28.0
#
# NOTE: This template was generated at a specific point in time and may not reflect
# the latest resource specifications. Always refer to the official Terraform and AWS
# documentation for the most up-to-date information.
################################################################################

resource "aws_finspace_kx_user" "example" {
  ##############################################################################
  # Required Arguments
  ##############################################################################

  # A unique identifier for the user
  # - Must be between 1 and 50 characters
  # - Valid characters: alphanumeric, underscore, and hyphen (0-9A-Za-z_-)
  # - Pattern: ^[0-9A-Za-z_-]{1,50}$
  # - This name is used to identify the user within the FinSpace environment
  name = "my-tf-kx-user"

  # Unique identifier for the KX environment
  # - This is the ID of the FinSpace kdb environment where the user will be created
  # - Must reference an existing aws_finspace_kx_environment resource
  # - The environment must be in an active state
  environment_id = aws_finspace_kx_environment.example.id

  # IAM role ARN to be associated with the user
  # - This IAM role is used for authentication when the user connects to kdb clusters
  # - The role must have a trust policy that allows FinSpace to assume it
  # - Minimum length: 20 characters
  # - Maximum length: 2048 characters
  # - Pattern: arn:aws[a-z\-]*:iam::\d{12}:role/?[a-zA-Z_0-9+=,.@\-_/]+$
  # - The role should include permissions needed to interact with kdb clusters
  # - When connecting to a cluster, users must federate into this IAM role
  #
  # AWS Documentation:
  # - Interacting with kdb clusters: https://docs.aws.amazon.com/finspace/latest/userguide/interacting-with-kdb-clusters.html
  iam_role = aws_iam_role.example.arn

  ##############################################################################
  # Optional Arguments
  ##############################################################################

  # Region where this resource will be managed
  # - Defaults to the Region set in the provider configuration if not specified
  # - Useful for multi-region deployments or when the provider is configured
  #   for a different region than where you want to create this resource
  #
  # AWS Documentation:
  # - Regional Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - Provider Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # region = "us-east-1"

  # Key-value mapping of resource tags
  # - Use tags to organize and identify your FinSpace users
  # - Common use cases: cost allocation, access control, automation
  # - If configured with a provider default_tags configuration block,
  #   tags with matching keys will overwrite those defined at the provider-level
  #
  # AWS Documentation:
  # - Tagging Best Practices: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  # - Provider default_tags: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-tf-kx-user"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # Map of tags assigned to the resource, including those inherited from the provider
  # - This is typically computed and merged with provider-level default_tags
  # - In most cases, you should use the 'tags' argument instead
  # - Only set this if you need to explicitly override the tag merging behavior
  # tags_all = {}

  ##############################################################################
  # Timeouts Configuration
  ##############################################################################

  # Customize timeout durations for resource operations
  # - Useful for environments with longer-than-usual API response times
  # - Default values are typically sufficient for most use cases
  # timeouts {
  #   # Maximum time to wait for user creation (default: typically 30m)
  #   create = "30m"
  #
  #   # Maximum time to wait for user update (default: typically 30m)
  #   update = "30m"
  #
  #   # Maximum time to wait for user deletion (default: typically 30m)
  #   delete = "30m"
  # }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# These attributes are automatically set by AWS and can be referenced but not configured:
#
# - arn: Amazon Resource Name (ARN) identifier of the KX user
#   Format: arn:aws:finspace:[region]:[account-id]:kxEnvironment/[environment-id]/kxUser/[user-name]
#   Example: aws_finspace_kx_user.example.arn
#
# - id: A comma-delimited string joining environment ID and user name
#   Format: [environment-id],[user-name]
#   Example: aws_finspace_kx_user.example.id
#
# - tags_all: Map of tags assigned to the resource, including those inherited
#   from the provider default_tags configuration block
#   Example: aws_finspace_kx_user.example.tags_all
################################################################################

################################################################################
# Example: Complete Setup with Dependencies
################################################################################
# This example shows a complete FinSpace Kx User setup including all dependencies

# KMS key for FinSpace environment encryption
resource "aws_kms_key" "example" {
  description             = "Example KMS Key for FinSpace"
  deletion_window_in_days = 7
}

# FinSpace Kx Environment
resource "aws_finspace_kx_environment" "example" {
  name       = "my-tf-kx-environment"
  kms_key_id = aws_kms_key.example.arn
}

# IAM role for the FinSpace user
resource "aws_iam_role" "example" {
  name = "finspace-kx-user-role"

  # Trust policy allowing FinSpace to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "finspace.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name      = "finspace-kx-user-role"
    ManagedBy = "terraform"
  }
}

# Optional: Attach policies to the IAM role for cluster access
# resource "aws_iam_role_policy" "example" {
#   name = "finspace-kx-user-policy"
#   role = aws_iam_role.example.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "finspace:*",
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }

################################################################################
# Usage Notes
################################################################################
# 1. Environment Setup:
#    - Ensure the FinSpace Kx environment is created and in AVAILABLE state
#    - The environment must have a valid KMS key configured
#
# 2. IAM Role Configuration:
#    - The IAM role must have a trust policy allowing FinSpace to assume it
#    - Configure appropriate permissions for the user's intended operations
#    - Consider using the principle of least privilege
#
# 3. User Connection:
#    - To connect to a kdb cluster, users must obtain a signed connection string
#    - Users must federate into the associated IAM role
#    - Connection handles have an idle timeout of 350 seconds
#
# 4. Service Deprecation:
#    - FinSpace will be discontinued after October 7, 2026
#    - Plan migration strategies if using this service
#    - New customers cannot be onboarded after October 7, 2025
#
# 5. Identifier Format:
#    - The resource ID is a comma-delimited string: environment_id,user_name
#    - Use this format when importing existing resources
#
# 6. Import:
#    terraform import aws_finspace_kx_user.example environment_id,user_name
################################################################################
