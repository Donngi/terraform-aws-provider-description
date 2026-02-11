################################################################################
# AWS RDS Export Task
# Terraform resource for managing an AWS RDS (Relational Database) Export Task.
#
# This resource allows you to export RDS snapshots to Amazon S3 in Parquet format.
# Useful for data analysis, archiving, or migration purposes.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/rds_export_task
# AWS API Reference: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_StartExportTask.html
################################################################################

resource "aws_rds_export_task" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # Unique identifier for the snapshot export task
  # - Must be unique within your AWS account and region
  # - Used to identify and track the export task
  # - Cannot be changed after creation
  export_task_identifier = "example-export-task"

  # Amazon Resource Name (ARN) of the snapshot to export
  # - Can be a DB snapshot ARN or DB cluster snapshot ARN
  # - Format: arn:aws:rds:region:account-id:snapshot:snapshot-name
  # - The snapshot must be in the 'available' state
  # - Snapshot can be from RDS instances or Aurora clusters
  source_arn = "arn:aws:rds:us-east-1:123456789012:snapshot:my-snapshot"

  # Name of the Amazon S3 bucket to export the snapshot to
  # - The bucket must exist and be in the same region as the snapshot
  # - Must have appropriate bucket policies for RDS export service
  # - Required permissions: s3:PutObject*, s3:GetObject*, s3:DeleteObject*
  s3_bucket_name = "my-export-bucket"

  # ARN of the IAM role to use for writing to the Amazon S3 bucket
  # - Must have trust relationship with export.rds.amazonaws.com
  # - Requires permissions to write to S3 bucket and use KMS key
  # - See example IAM role configuration in Complete Usage section
  # - Format: arn:aws:iam::account-id:role/role-name
  iam_role_arn = "arn:aws:iam::123456789012:role/rds-export-role"

  # ID of the Amazon Web Services KMS key to use to encrypt the snapshot
  # - Can be key ID, key ARN, alias name, or alias ARN
  # - The key must be in the same region as the export task
  # - Must grant the IAM role permission to use the key
  # - Format examples:
  #   - Key ID: 1234abcd-12ab-34cd-56ef-1234567890ab
  #   - Key ARN: arn:aws:kms:region:account-id:key/1234abcd-12ab-34cd-56ef-1234567890ab
  #   - Alias name: alias/my-key
  #   - Alias ARN: arn:aws:kms:region:account-id:alias/my-key
  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # Data to be exported from the snapshot
  # - If not provided, all snapshot data is exported
  # - List of database names, schema names, or table names to export
  # - Reduces export time and storage costs by exporting only needed data
  # - Format varies by database engine (MySQL, PostgreSQL, etc.)
  # - Example for MySQL: ["database1", "database2"]
  # - Example for PostgreSQL: ["database1.schema1.table1", "database1.schema1.table2"]
  # - Refer to AWS StartExportTask API documentation for engine-specific formats
  export_only = ["database1", "database2"]

  # Amazon S3 bucket prefix to use as the file name and path of the exported snapshot
  # - Creates organized directory structure in S3 bucket
  # - Helpful for managing multiple exports
  # - Do not include leading slash
  # - Example: "exports/2024/january" creates s3://bucket/exports/2024/january/
  # - Default: exports are placed in bucket root
  s3_prefix = "rds-exports/production/2024"

  # Region where this resource will be managed
  # - Defaults to the region set in the provider configuration
  # - Explicit region specification useful for multi-region setups
  # - Must match the region of the source snapshot
  # region = "us-east-1"

  ################################################################################
  # Read-Only Attributes (Available after creation)
  ################################################################################

  # These attributes are computed by AWS and available after the resource is created:
  #
  # - id                  : Unique identifier for the snapshot export task (same as export_task_identifier)
  # - status              : Status of the export task (STARTING, IN_PROGRESS, COMPLETE, CANCELING, CANCELED, FAILED)
  # - percent_progress    : Progress of the snapshot export task as a percentage (0-100)
  # - snapshot_time       : Time that the snapshot was created (RFC3339 format)
  # - source_type         : Type of source for the export (SNAPSHOT or CLUSTER)
  # - task_start_time     : Time that the snapshot export task started (RFC3339 format)
  # - task_end_time       : Time that the snapshot export task completed (RFC3339 format)
  # - warning_message     : Warning about the snapshot export task, if any
  # - failure_cause       : Reason the export failed, if it failed
  #
  # Access these attributes using: aws_rds_export_task.example.status
  ################################################################################
}

################################################################################
# Outputs - Common attributes to reference in other resources
################################################################################

# output "rds_export_task_id" {
#   description = "The ID of the RDS export task"
#   value       = aws_rds_export_task.example.id
# }

# output "rds_export_task_status" {
#   description = "The status of the RDS export task"
#   value       = aws_rds_export_task.example.status
# }

# output "rds_export_task_progress" {
#   description = "The progress percentage of the export task"
#   value       = aws_rds_export_task.example.percent_progress
# }

################################################################################
# Example Usage - Basic
################################################################################
#
# resource "aws_rds_export_task" "basic" {
#   export_task_identifier = "my-export"
#   source_arn             = aws_db_snapshot.example.db_snapshot_arn
#   s3_bucket_name         = aws_s3_bucket.example.id
#   iam_role_arn           = aws_iam_role.example.arn
#   kms_key_id             = aws_kms_key.example.arn
# }
#
################################################################################

################################################################################
# Example Usage - Complete with Supporting Resources
################################################################################
#
# # S3 Bucket for exports
# resource "aws_s3_bucket" "exports" {
#   bucket        = "my-rds-exports"
#   force_destroy = true
# }
#
# resource "aws_s3_bucket_acl" "exports" {
#   bucket = aws_s3_bucket.exports.id
#   acl    = "private"
# }
#
# # IAM Role for RDS Export
# resource "aws_iam_role" "rds_export" {
#   name = "rds-export-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "export.rds.amazonaws.com"
#         }
#       },
#     ]
#   })
# }
#
# # IAM Policy for S3 access
# data "aws_iam_policy_document" "rds_export" {
#   statement {
#     actions = [
#       "s3:ListAllMyBuckets",
#     ]
#     resources = [
#       "*"
#     ]
#   }
#   statement {
#     actions = [
#       "s3:GetBucketLocation",
#       "s3:ListBucket",
#     ]
#     resources = [
#       aws_s3_bucket.exports.arn,
#     ]
#   }
#   statement {
#     actions = [
#       "s3:GetObject",
#       "s3:PutObject",
#       "s3:DeleteObject",
#     ]
#     resources = [
#       "${aws_s3_bucket.exports.arn}/*"
#     ]
#   }
# }
#
# resource "aws_iam_policy" "rds_export" {
#   name   = "rds-export-policy"
#   policy = data.aws_iam_policy_document.rds_export.json
# }
#
# resource "aws_iam_role_policy_attachment" "rds_export" {
#   role       = aws_iam_role.rds_export.name
#   policy_arn = aws_iam_policy.rds_export.arn
# }
#
# # KMS Key for encryption
# resource "aws_kms_key" "rds_export" {
#   deletion_window_in_days = 10
#   description             = "KMS key for RDS export encryption"
# }
#
# # DB Instance and Snapshot
# resource "aws_db_instance" "source" {
#   identifier           = "source-db"
#   allocated_storage    = 20
#   db_name              = "mydb"
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t3.micro"
#   username             = "admin"
#   password             = "changeme123"
#   parameter_group_name = "default.mysql8.0"
#   skip_final_snapshot  = true
# }
#
# resource "aws_db_snapshot" "source" {
#   db_instance_identifier = aws_db_instance.source.identifier
#   db_snapshot_identifier = "source-snapshot"
# }
#
# # RDS Export Task
# resource "aws_rds_export_task" "complete" {
#   export_task_identifier = "complete-export"
#   source_arn             = aws_db_snapshot.source.db_snapshot_arn
#   s3_bucket_name         = aws_s3_bucket.exports.id
#   iam_role_arn           = aws_iam_role.rds_export.arn
#   kms_key_id             = aws_kms_key.rds_export.arn
#
#   export_only = ["mydb"]
#   s3_prefix   = "exports/production/2024-01"
# }
#
################################################################################

################################################################################
# Important Notes and Best Practices
################################################################################
#
# 1. Export Format:
#    - Snapshots are exported in Apache Parquet format
#    - Optimized for analytics and compatible with AWS services like Athena
#    - Each table is exported to a separate directory
#
# 2. IAM Permissions:
#    - The IAM role must trust the export.rds.amazonaws.com service
#    - Role needs S3 permissions: PutObject, GetObject, DeleteObject
#    - Role needs KMS permissions: Encrypt, Decrypt, GenerateDataKey
#
# 3. Snapshot State:
#    - Source snapshot must be in 'available' state
#    - Cannot export snapshots that are being created or deleted
#
# 4. Cost Considerations:
#    - Charges apply for S3 storage of exported data
#    - Data transfer charges may apply
#    - Use export_only to reduce costs by exporting only needed data
#
# 5. Regional Constraints:
#    - Export task, snapshot, S3 bucket, and KMS key must be in same region
#    - Cross-region exports are not supported
#
# 6. Timeouts and Monitoring:
#    - Large databases may take hours to export
#    - Monitor progress using percent_progress attribute
#    - Check status attribute for task state
#    - Review warning_message and failure_cause on errors
#
# 7. S3 Bucket Policy:
#    - Ensure bucket policy allows export.rds.amazonaws.com to write
#    - Consider enabling versioning for data protection
#    - Set lifecycle policies to manage storage costs
#
# 8. Encryption:
#    - Exported data is encrypted using the specified KMS key
#    - Cannot export unencrypted data
#    - KMS key must allow the IAM role to use it
#
# 9. Data Consistency:
#    - Export represents a point-in-time snapshot
#    - No data changes occur during export
#    - Safe to use for analytics without impacting production
#
# 10. Terraform Lifecycle:
#     - Export task is a one-time operation
#     - Destroying the resource does not delete exported S3 data
#     - Re-creating with same identifier may fail if previous task exists
#
################################################################################

################################################################################
# Additional Resources
################################################################################
#
# AWS Documentation:
# - RDS Snapshot Export: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ExportSnapshot.html
# - StartExportTask API: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_StartExportTask.html
# - Working with Parquet Data: https://docs.aws.amazon.com/athena/latest/ug/columnar-storage.html
#
# Related Terraform Resources:
# - aws_db_snapshot: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_snapshot
# - aws_db_cluster_snapshot: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_cluster_snapshot
# - aws_s3_bucket: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
# - aws_iam_role: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# - aws_kms_key: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
#
################################################################################
