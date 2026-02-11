################################################################################
# AWS CodeCommit Repository - Annotated Template
################################################################################
# Generated: 2026-01-19
# Provider: hashicorp/aws v6.28.0
# Resource: aws_codecommit_repository
#
# NOTE: This template was generated at a specific point in time.
#       Always refer to the official documentation for the latest specifications:
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_repository
################################################################################

resource "aws_codecommit_repository" "example" {
  ################################################################################
  # Required Attributes
  ################################################################################

  # (Required) The name for the repository.
  # - Must be less than 100 characters
  # - Repository names must be unique within an AWS account
  # Reference: https://docs.aws.amazon.com/codecommit/latest/userguide/how-to-create-repository.html
  repository_name = "example-repository"

  ################################################################################
  # Optional Attributes
  ################################################################################

  # (Optional) The default branch of the repository.
  # - The branch specified here must exist in the repository
  # - If not specified, no default branch is set until the first commit is made
  # - Commonly set to "main" or "master"
  # Reference: https://docs.aws.amazon.com/codecommit/latest/userguide/how-to-change-branch.html
  default_branch = "main"

  # (Optional) The description of the repository.
  # - Must be less than 1000 characters
  # - Useful for documenting the purpose of the repository
  description = "This is an example CodeCommit repository"

  # (Optional) Terraform resource ID.
  # - Typically managed automatically by Terraform
  # - Can be set explicitly for import scenarios or custom resource identification
  # - If not specified, Terraform will auto-generate this value
  id = null

  # (Optional) The ARN of the AWS KMS encryption key.
  # - If not specified, the default AWS managed key (aws/codecommit) is used
  # - CodeCommit encrypts all data at rest using AWS KMS
  # - Must be a symmetric key with key usage type "Encrypt and decrypt"
  # - The key must be in the same AWS region as the repository
  # - Supports AES-GCM-256 for Git objects under 6 MB and AES-CBC-256 for objects 6 MB to 2 GB
  # Reference: https://docs.aws.amazon.com/codecommit/latest/userguide/encryption.html
  kms_key_id = null

  # (Optional) Region where this resource will be managed.
  # - Defaults to the region set in the provider configuration
  # - Allows explicit region specification for multi-region setups
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # (Optional) Key-value map of resource tags.
  # - Used for resource organization, cost tracking, and access control
  # - If configured with a provider default_tags configuration block,
  #   tags with matching keys will overwrite those defined at the provider-level
  # - Maximum of 50 tags per repository
  # Reference: https://docs.aws.amazon.com/codecommit/latest/userguide/how-to-tag-repository.html
  tags = {
    Environment = "production"
    Project     = "example-project"
    ManagedBy   = "terraform"
  }

  # (Optional) Map of tags assigned to the resource, including those inherited
  # from the provider default_tags configuration block.
  # - This is a computed attribute that merges provider-level and resource-level tags
  # - Typically managed automatically by Terraform
  # - Only set this explicitly if you need to override the automatic merge behavior
  tags_all = null

  ################################################################################
  # Computed Attributes (Read-Only - Not configurable in this resource block)
  ################################################################################
  # The following attributes are automatically computed by AWS and cannot be set:
  #
  # - arn: The ARN of the repository
  #   Format: arn:aws:codecommit:region:account-id:repository-name
  #
  # - clone_url_http: The URL to use for cloning the repository over HTTPS
  #   Format: https://git-codecommit.region.amazonaws.com/v1/repos/repository-name
  #
  # - clone_url_ssh: The URL to use for cloning the repository over SSH
  #   Format: ssh://git-codecommit.region.amazonaws.com/v1/repos/repository-name
  #
  # - repository_id: The unique ID of the repository (UUID format)
  #
  # Reference: https://docs.aws.amazon.com/codecommit/latest/APIReference/API_RepositoryMetadata.html
  ################################################################################
}

################################################################################
# Example Usage - AWS KMS Customer Managed Key
################################################################################
# resource "aws_codecommit_repository" "encrypted" {
#   repository_name = "encrypted-repository"
#   description     = "Repository with customer managed encryption key"
#   kms_key_id      = aws_kms_key.codecommit.arn
# }
#
# resource "aws_kms_key" "codecommit" {
#   description             = "KMS key for CodeCommit repository encryption"
#   deletion_window_in_days = 7
#   enable_key_rotation     = true
#
#   tags = {
#     Purpose = "CodeCommit-Encryption"
#   }
# }
################################################################################

################################################################################
# Outputs (Examples)
################################################################################
# output "repository_arn" {
#   description = "The ARN of the CodeCommit repository"
#   value       = aws_codecommit_repository.example.arn
# }
#
# output "clone_url_http" {
#   description = "HTTPS clone URL for the repository"
#   value       = aws_codecommit_repository.example.clone_url_http
# }
#
# output "clone_url_ssh" {
#   description = "SSH clone URL for the repository"
#   value       = aws_codecommit_repository.example.clone_url_ssh
# }
#
# output "repository_id" {
#   description = "The unique ID of the repository"
#   value       = aws_codecommit_repository.example.repository_id
# }
################################################################################
