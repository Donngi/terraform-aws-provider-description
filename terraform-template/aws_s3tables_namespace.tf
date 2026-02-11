# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AWS S3 Tables Namespace
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Terraform resource for managing an Amazon S3 Tables Namespace.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3tables_namespace
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Example: Basic S3 Tables Namespace                                      │
# │                                                                          │
# │ This example demonstrates a basic S3 Tables namespace setup with        │
# │ minimum required configuration.                                         │
# └─────────────────────────────────────────────────────────────────────────┘

# Table Bucket (prerequisite resource)
resource "aws_s3tables_table_bucket" "example" {
  name = "example-bucket"
}

# S3 Tables Namespace
resource "aws_s3tables_namespace" "example" {
  # ─────────────────────────────────────────────────────────────────────────
  # Required Arguments
  # ─────────────────────────────────────────────────────────────────────────

  # [REQUIRED] Name of the namespace
  # - Forces new resource (changing this will destroy and recreate)
  # - Must be between 1 and 255 characters in length
  # - Can consist of lowercase letters, numbers, and underscores
  # - Must begin and end with a lowercase letter or number
  # Type: string
  namespace = "example_namespace"

  # [REQUIRED] ARN referencing the Table Bucket that contains this Namespace
  # - Forces new resource (changing this will destroy and recreate)
  # Type: string
  table_bucket_arn = aws_s3tables_table_bucket.example.arn

  # ─────────────────────────────────────────────────────────────────────────
  # Optional Arguments
  # ─────────────────────────────────────────────────────────────────────────

  # Region where this resource will be managed
  # - Defaults to the Region set in the provider configuration
  # - Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Type: string
  # Default: Provider region
  # region = "us-east-1"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Outputs
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

output "namespace_created_at" {
  description = "Date and time when the namespace was created"
  value       = aws_s3tables_namespace.example.created_at
}

output "namespace_created_by" {
  description = "Account ID of the account that created the namespace"
  value       = aws_s3tables_namespace.example.created_by
}

output "namespace_owner_account_id" {
  description = "Account ID of the account that owns the namespace"
  value       = aws_s3tables_namespace.example.owner_account_id
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Computed Attributes Reference
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# created_at          - Date and time when the namespace was created
#                       Type: string
#
# created_by          - Account ID of the account that created the namespace
#                       Type: string
#
# owner_account_id    - Account ID of the account that owns the namespace
#                       Type: string
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Import Example
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# S3 Tables Namespace can be imported using the combination of table_bucket_arn
# and namespace, separated by a comma (,):
#
# terraform import aws_s3tables_namespace.example \
#   "arn:aws:s3tables:us-west-2:123456789012:bucket/example-bucket,example_namespace"
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
