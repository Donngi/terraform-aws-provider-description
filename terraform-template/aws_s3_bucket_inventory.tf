################################################################################
# AWS S3 Bucket Inventory Configuration
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3_bucket_inventory
################################################################################

# Provides a S3 bucket inventory configuration resource.
# S3 Inventory provides scheduled reports about the objects in your S3 bucket.
#
# NOTE: This resource cannot be used with S3 directory buckets.
#
# Example Use Cases:
# - Audit and report on replication and encryption status
# - Simplify and speed up business workflows and big data jobs
# - Track object age for lifecycle management

resource "aws_s3_bucket_inventory" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # Name of the source bucket that inventory lists the objects for
  # Must be an existing S3 bucket name
  # Example: "my-source-bucket"
  bucket = "REPLACE_WITH_SOURCE_BUCKET_NAME"

  # Unique identifier of the inventory configuration for the bucket
  # Must be unique within the bucket
  # Example: "EntireBucketDaily", "DocumentsWeekly"
  name = "REPLACE_WITH_INVENTORY_NAME"

  # Object versions to include in the inventory list
  # Valid values: "All", "Current"
  # - All: Include all versions of each object
  # - Current: Include only current versions
  included_object_versions = "All"

  ################################################################################
  # Schedule Configuration (Required)
  ################################################################################

  # Specifies how frequently inventory results are produced
  schedule {
    # Valid values: "Daily", "Weekly"
    # Daily: Generate inventory once per day
    # Weekly: Generate inventory once per week
    frequency = "Daily"
  }

  ################################################################################
  # Destination Configuration (Required)
  ################################################################################

  # Contains information about where to publish the inventory results
  destination {
    bucket {
      # Amazon S3 bucket ARN where inventory results will be published
      # Must be a valid S3 bucket ARN
      # Example: "arn:aws:s3:::my-inventory-bucket"
      bucket_arn = "REPLACE_WITH_DESTINATION_BUCKET_ARN"

      # Output format of the inventory results
      # Valid values: "CSV", "ORC", "Parquet"
      # - CSV: Comma-separated values format
      # - ORC: Apache ORC columnar format (efficient for analytics)
      # - Parquet: Apache Parquet columnar format (efficient for analytics)
      format = "ORC"

      # (Optional) ID of the account that owns the destination bucket
      # Recommended to prevent problems if destination bucket ownership changes
      # Example: "123456789012"
      # account_id = "REPLACE_WITH_DESTINATION_ACCOUNT_ID"

      # (Optional) Prefix prepended to all inventory results
      # Helps organize inventory files within the destination bucket
      # Example: "inventory", "reports/inventory"
      # prefix = "REPLACE_WITH_DESTINATION_PREFIX"

      # (Optional) Server-side encryption configuration for inventory files
      # encryption {
      #   # Option 1: Use Amazon S3-managed keys (SSE-S3)
      #   # Simple encryption without key management
      #   sse_s3 {}
      #
      #   # Option 2: Use AWS KMS-managed keys (SSE-KMS)
      #   # Provides additional control and audit capabilities
      #   sse_kms {
      #     # ARN of the KMS customer master key (CMK)
      #     # Example: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
      #     key_id = "REPLACE_WITH_KMS_KEY_ARN"
      #   }
      # }
    }
  }

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Specifies whether the inventory is enabled or disabled
  # Default: true
  # Set to false to disable inventory generation without deleting the configuration
  # enabled = true

  # (Optional) Filter to limit which objects are included in the inventory
  # filter {
  #   # Prefix that an object must have to be included in inventory results
  #   # Example: "documents/", "logs/2024/"
  #   # Objects not matching this prefix will be excluded
  #   prefix = "REPLACE_WITH_FILTER_PREFIX"
  # }

  # (Optional) List of optional fields to include in the inventory results
  # These provide additional metadata about each object
  # Valid values include:
  # - "Size": Object size in bytes
  # - "LastModifiedDate": Last modified timestamp
  # - "StorageClass": Storage class (STANDARD, GLACIER, etc.)
  # - "ETag": Entity tag (object hash)
  # - "IsMultipartUploaded": Whether object was multipart uploaded
  # - "ReplicationStatus": Replication status (if applicable)
  # - "EncryptionStatus": Encryption status (SSE-S3, SSE-KMS, etc.)
  # - "ObjectLockRetainUntilDate": Object Lock retain until date
  # - "ObjectLockMode": Object Lock mode (GOVERNANCE, COMPLIANCE)
  # - "ObjectLockLegalHoldStatus": Legal hold status
  # - "IntelligentTieringAccessTier": Intelligent-Tiering access tier
  # - "BucketKeyStatus": Bucket Key status for SSE-KMS
  # - "ChecksumAlgorithm": Checksum algorithm used
  # - "ObjectAccessControlList": Object ACL
  # - "ObjectOwner": Object owner
  #
  # Example:
  # optional_fields = [
  #   "Size",
  #   "LastModifiedDate",
  #   "StorageClass",
  #   "ETag",
  #   "ReplicationStatus",
  #   "EncryptionStatus"
  # ]

  # (Optional) Region where this resource will be managed
  # Defaults to the region set in the provider configuration
  # Example: "us-east-1", "eu-west-1"
  # region = "REPLACE_WITH_REGION"

  ################################################################################
  # Resource Lifecycle
  ################################################################################

  # Example lifecycle configuration
  # lifecycle {
  #   # Prevent accidental deletion of inventory configuration
  #   prevent_destroy = true
  #
  #   # Ignore changes to specific attributes
  #   ignore_changes = [
  #     # Example: ignore changes to optional_fields
  #     optional_fields,
  #   ]
  # }
}

################################################################################
# Outputs
################################################################################

# Output the inventory configuration ID
# Format: bucket:name
output "inventory_id" {
  description = "ID of the S3 bucket inventory configuration"
  value       = aws_s3_bucket_inventory.example.id
}

output "inventory_bucket" {
  description = "Source bucket name for inventory"
  value       = aws_s3_bucket_inventory.example.bucket
}

output "inventory_name" {
  description = "Name of the inventory configuration"
  value       = aws_s3_bucket_inventory.example.name
}

################################################################################
# Example Configurations
################################################################################

# Example 1: Basic daily inventory with all versions
# resource "aws_s3_bucket_inventory" "daily_all_versions" {
#   bucket = aws_s3_bucket.source.id
#   name   = "EntireBucketDaily"
#
#   included_object_versions = "All"
#
#   schedule {
#     frequency = "Daily"
#   }
#
#   destination {
#     bucket {
#       format     = "ORC"
#       bucket_arn = aws_s3_bucket.inventory.arn
#     }
#   }
# }

# Example 2: Weekly inventory with prefix filter and custom fields
# resource "aws_s3_bucket_inventory" "weekly_documents" {
#   bucket = aws_s3_bucket.source.id
#   name   = "DocumentsWeekly"
#
#   included_object_versions = "Current"
#
#   schedule {
#     frequency = "Weekly"
#   }
#
#   filter {
#     prefix = "documents/"
#   }
#
#   destination {
#     bucket {
#       format     = "Parquet"
#       bucket_arn = aws_s3_bucket.inventory.arn
#       prefix     = "inventory/documents"
#     }
#   }
#
#   optional_fields = [
#     "Size",
#     "LastModifiedDate",
#     "StorageClass",
#     "ReplicationStatus",
#     "EncryptionStatus"
#   ]
# }

# Example 3: Inventory with KMS encryption
# resource "aws_s3_bucket_inventory" "encrypted" {
#   bucket = aws_s3_bucket.source.id
#   name   = "EncryptedInventory"
#
#   included_object_versions = "All"
#
#   schedule {
#     frequency = "Daily"
#   }
#
#   destination {
#     bucket {
#       format     = "ORC"
#       bucket_arn = aws_s3_bucket.inventory.arn
#       account_id = data.aws_caller_identity.current.account_id
#
#       encryption {
#         sse_kms {
#           key_id = aws_kms_key.inventory.arn
#         }
#       }
#     }
#   }
# }

################################################################################
# Related Resources
################################################################################

# The source bucket being inventoried
# resource "aws_s3_bucket" "source" {
#   bucket = "my-source-bucket"
# }

# The destination bucket for inventory reports
# resource "aws_s3_bucket" "inventory" {
#   bucket = "my-inventory-bucket"
# }

# Bucket policy to allow S3 to write inventory reports
# resource "aws_s3_bucket_policy" "inventory" {
#   bucket = aws_s3_bucket.inventory.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "InventoryPolicy"
#         Effect = "Allow"
#         Principal = {
#           Service = "s3.amazonaws.com"
#         }
#         Action = "s3:PutObject"
#         Resource = "${aws_s3_bucket.inventory.arn}/*"
#         Condition = {
#           StringEquals = {
#             "s3:x-amz-acl" = "bucket-owner-full-control"
#           }
#           ArnLike = {
#             "aws:SourceArn" = aws_s3_bucket.source.arn
#           }
#         }
#       }
#     ]
#   })
# }

# KMS key for encrypting inventory files (if using SSE-KMS)
# resource "aws_kms_key" "inventory" {
#   description             = "KMS key for S3 inventory encryption"
#   deletion_window_in_days = 10
#   enable_key_rotation     = true
# }

# resource "aws_kms_alias" "inventory" {
#   name          = "alias/s3-inventory"
#   target_key_id = aws_kms_key.inventory.key_id
# }

################################################################################
# Important Notes
################################################################################

# 1. Inventory reports are published to the destination bucket within 24-48 hours
#    after the configured frequency time
#
# 2. The destination bucket must have a bucket policy allowing S3 to write
#    inventory reports (see example above)
#
# 3. Inventory configurations can take up to 48 hours to start delivering reports
#
# 4. You can have up to 1,000 inventory configurations per bucket
#
# 5. When using SSE-KMS encryption, ensure the KMS key policy allows S3 to use
#    the key for encryption operations
#
# 6. Inventory reports include all objects in the bucket, or filtered objects
#    if a prefix filter is configured
#
# 7. The format choice affects cost and query performance:
#    - CSV: Easy to read but less efficient for large datasets
#    - ORC/Parquet: Columnar formats optimized for analytics queries
#
# 8. Optional fields increase the size of inventory reports but provide
#    valuable metadata for analysis
#
# 9. Cross-account inventory delivery requires appropriate bucket policies
#    and optionally account_id specification
#
# 10. Inventory does not capture real-time changes; it's a periodic snapshot
