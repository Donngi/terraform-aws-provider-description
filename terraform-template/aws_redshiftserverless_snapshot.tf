################################################################################
# AWS Redshift Serverless Snapshot
################################################################################
# Creates a new Amazon Redshift Serverless Snapshot.
#
# Official Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_snapshot
#
# Provider Version: 6.28.0
################################################################################

resource "aws_redshiftserverless_snapshot" "example" {
  #------------------------------------------------------------------------------
  # Required Arguments
  #------------------------------------------------------------------------------

  # (Required) The namespace to create a snapshot for.
  # Must reference an existing Redshift Serverless namespace.
  namespace_name = aws_redshiftserverless_workgroup.example.namespace_name

  # (Required) The name of the snapshot.
  # This name must be unique within your AWS account and region.
  snapshot_name = "example"

  #------------------------------------------------------------------------------
  # Optional Arguments
  #------------------------------------------------------------------------------

  # (Optional) How long to retain the created snapshot.
  # Default value is -1 (indefinite retention).
  # Specify a positive integer to set retention in days.
  # Type: number
  # Default: -1
  # retention_period = -1

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Type: string
  # region = "us-east-1"

  #------------------------------------------------------------------------------
  # Computed Attributes (Read-Only)
  #------------------------------------------------------------------------------
  # The following attributes are automatically computed by AWS and cannot be set:
  #
  # - accounts_with_provisioned_restore_access (set of strings)
  #   All of the Amazon Web Services accounts that have access to restore
  #   a snapshot to a provisioned cluster.
  #
  # - accounts_with_restore_access (set of strings)
  #   All of the Amazon Web Services accounts that have access to restore
  #   a snapshot to a namespace.
  #
  # - admin_username (string)
  #   The username of the database within a snapshot.
  #
  # - arn (string)
  #   The Amazon Resource Name (ARN) of the snapshot.
  #
  # - id (string)
  #   The name of the snapshot.
  #
  # - kms_key_id (string)
  #   The unique identifier of the KMS key used to encrypt the snapshot.
  #
  # - namespace_arn (string)
  #   The Amazon Resource Name (ARN) of the namespace the snapshot was created from.
  #
  # - owner_account (string)
  #   The owner Amazon Web Services account of the snapshot.
  #------------------------------------------------------------------------------
}

################################################################################
# Example Usage: Manual Snapshot Creation
################################################################################

# resource "aws_redshiftserverless_snapshot" "manual_backup" {
#   namespace_name   = aws_redshiftserverless_namespace.production.name
#   snapshot_name    = "production-manual-backup-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
#   retention_period = 7  # Retain for 7 days
# }

################################################################################
# Example Usage: Long-term Retention Snapshot
################################################################################

# resource "aws_redshiftserverless_snapshot" "long_term" {
#   namespace_name   = aws_redshiftserverless_namespace.production.name
#   snapshot_name    = "production-monthly-${formatdate("YYYY-MM", timestamp())}"
#   retention_period = 365  # Retain for 1 year
# }

################################################################################
# Outputs Example
################################################################################

# output "snapshot_arn" {
#   description = "The ARN of the Redshift Serverless snapshot"
#   value       = aws_redshiftserverless_snapshot.example.arn
# }
#
# output "snapshot_id" {
#   description = "The ID (name) of the snapshot"
#   value       = aws_redshiftserverless_snapshot.example.id
# }
#
# output "namespace_arn" {
#   description = "The ARN of the namespace the snapshot was created from"
#   value       = aws_redshiftserverless_snapshot.example.namespace_arn
# }
