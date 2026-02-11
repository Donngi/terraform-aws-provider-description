# ================================================================================
# Terraform AWS Resource: aws_ecr_replication_configuration
# ================================================================================
#
# Generated: 2026-01-22
# Provider Version: 6.28.0
#
# Description:
#   Provides an Elastic Container Registry Replication Configuration.
#   This resource manages the replication configuration for an Amazon ECR registry,
#   allowing you to replicate container images across AWS regions and accounts.
#
# Note:
#   This template reflects the resource schema at the time of generation.
#   For the latest specifications and updates, refer to the official documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_replication_configuration
#
# ================================================================================

resource "aws_ecr_replication_configuration" "example" {
  # ==============================================================================
  # Optional Attributes
  # ==============================================================================

  # region - (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # ==============================================================================
  # Replication Configuration Block
  # ==============================================================================
  # (Required) Replication configuration for a registry.
  # Maximum: 1 block

  replication_configuration {
    # ============================================================================
    # Rule Block (Required)
    # ============================================================================
    # The replication rules for a replication configuration.
    # Minimum: 1 block
    # Maximum: 10 blocks

    rule {
      # ==========================================================================
      # Destination Block (Required)
      # ==========================================================================
      # The details of a replication destination.
      # Minimum: 1 block
      # Maximum: 25 blocks per rule

      destination {
        # region - (Required) A Region to replicate to.
        # Type: string
        # Example: "us-west-2", "eu-west-1", "ap-northeast-1"
        region = "us-west-2"

        # registry_id - (Required) The account ID of the destination registry to replicate to.
        # Type: string
        # This is the AWS account ID where the replicated images will be stored.
        # Can be the same account (cross-region) or a different account (cross-account).
        registry_id = "123456789012"
      }

      # Additional destination blocks can be added (up to 25 total)
      destination {
        region      = "eu-west-1"
        registry_id = "123456789012"
      }

      # ==========================================================================
      # Repository Filter Block (Optional)
      # ==========================================================================
      # Filters for a replication rule.
      # Maximum: 100 blocks per rule
      # If not specified, all repositories will be replicated.

      repository_filter {
        # filter - (Required) The repository filter details.
        # Type: string
        # Specifies a repository name prefix to match.
        # Example: "prod/" will match repositories like "prod/app1", "prod/app2"
        filter = "prod/"

        # filter_type - (Required) The repository filter type.
        # Type: string
        # The only supported value is "PREFIX_MATCH", which is a repository name
        # prefix specified with the filter parameter.
        filter_type = "PREFIX_MATCH"
      }

      # Additional repository_filter blocks can be added to specify multiple filters
      # repository_filter {
      #   filter      = "backend/"
      #   filter_type = "PREFIX_MATCH"
      # }
    }

    # Additional rule blocks can be added (up to 10 total)
    # rule {
    #   destination {
    #     region      = "ap-northeast-1"
    #     registry_id = "123456789012"
    #   }
    # }
  }
}

# ================================================================================
# Computed Attributes (Read-Only)
# ================================================================================
# These attributes are computed by AWS and cannot be set directly:
#
# - id: The registry ID (computed)
# - registry_id: The registry ID where the replication configuration was created (computed)
#
# ================================================================================

# ================================================================================
# Output Examples
# ================================================================================

output "registry_id" {
  description = "The registry ID where the replication configuration was created"
  value       = aws_ecr_replication_configuration.example.registry_id
}

# ================================================================================
# Important Notes
# ================================================================================
#
# 1. Replication Limits:
#    - Maximum 10 rules per replication_configuration
#    - Maximum 25 destinations per rule
#    - Maximum 100 repository_filter blocks per rule
#
# 2. Only one replication_configuration block is allowed per resource.
#
# 3. The filter_type only supports "PREFIX_MATCH" at this time.
#
# 4. Cross-region replication requires appropriate IAM permissions in both
#    the source and destination registries.
#
# 5. Cross-account replication requires additional registry permissions policy
#    in the destination account to allow the source account to replicate.
#
# 6. Data transfer charges may apply for cross-region replication.
#
# References:
# - AWS ECR Replication: https://docs.aws.amazon.com/AmazonECR/latest/userguide/replication.html
# - Terraform Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_replication_configuration
#
# ================================================================================
