# ==============================================================================
# Terraform AWS Provider Resource: aws_s3tables_table
# ==============================================================================
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3tables_table
# Provider Version: 6.28.0
#
# Description:
# Terraform resource for managing an Amazon S3 Tables Table.
# Amazon S3 Tables provides a fully managed table storage solution for Apache
# Iceberg format, allowing you to store and query large-scale analytical data.
#
# Table Format Support: Currently only supports ICEBERG format
# Schema Support: Supports all Apache Iceberg primitive types
# ==============================================================================

resource "aws_s3tables_table" "example" {
  # --------------------------------------------------------------------------
  # REQUIRED ARGUMENTS
  # --------------------------------------------------------------------------

  # (Required) Name of the table.
  # Constraints:
  #   - Must be between 1 and 255 characters in length
  #   - Can consist of lowercase letters, numbers, and underscores
  #   - Must begin and end with a lowercase letter or number
  # Reference: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-buckets-naming.html#naming-rules-table
  name = "example_table"

  # (Required) Name of the namespace for this table.
  # Constraints:
  #   - Must be between 1 and 255 characters in length
  #   - Can consist of lowercase letters, numbers, and underscores
  #   - Must begin and end with a lowercase letter or number
  # Reference: Use aws_s3tables_namespace.example.namespace
  namespace = aws_s3tables_namespace.example.namespace

  # (Required, Forces new resource) ARN referencing the Table Bucket that contains this Namespace.
  # Reference: Use aws_s3tables_table_bucket.example.arn
  # Note: Changing this attribute forces replacement of the resource
  table_bucket_arn = aws_s3tables_namespace.example.table_bucket_arn

  # (Required) Format of the table.
  # Valid values: "ICEBERG" (currently only ICEBERG is supported)
  format = "ICEBERG"

  # --------------------------------------------------------------------------
  # OPTIONAL ARGUMENTS
  # --------------------------------------------------------------------------

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # (Optional) Key-value map of resource tags.
  # If configured with a provider default_tags configuration block present,
  # tags with matching keys will overwrite those defined at the provider-level.
  tags = {
    Environment = "production"
    Project     = "data-analytics"
    ManagedBy   = "terraform"
  }

  # --------------------------------------------------------------------------
  # OPTIONAL: ENCRYPTION CONFIGURATION
  # --------------------------------------------------------------------------
  # (Optional) A single table bucket encryption configuration object.
  # Defines server-side encryption settings for the table.

  encryption_configuration {
    # (Required) Server-side encryption algorithm.
    # Valid values: "aws:kms" or "AES256"
    sse_algorithm = "aws:kms"

    # (Optional) The ARN of a KMS Key to be used with aws:kms sse_algorithm.
    # Required when sse_algorithm is "aws:kms"
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  # --------------------------------------------------------------------------
  # OPTIONAL: MAINTENANCE CONFIGURATION
  # --------------------------------------------------------------------------
  # (Optional) A single table bucket maintenance configuration object.
  # Configures automatic maintenance operations for Iceberg tables.

  maintenance_configuration {
    # (Required) A single Iceberg compaction settings object.
    # Compaction combines small data objects to improve query performance.
    iceberg_compaction {
      # (Required) Whether the configuration is enabled.
      # Valid values: "enabled" or "disabled"
      status = "enabled"

      # (Required) Settings object for compaction.
      settings {
        # (Required) Data objects smaller than this size may be combined with others.
        # Constraints: Must be between 64 and 512 (MB)
        target_file_size_mb = 128
      }
    }

    # (Required) A single Iceberg snapshot management settings object.
    # Manages the lifecycle of table snapshots.
    iceberg_snapshot_management {
      # (Required) Whether the configuration is enabled.
      # Valid values: "enabled" or "disabled"
      status = "enabled"

      # (Required) Settings object for snapshot management.
      settings {
        # (Required) Snapshots older than this will be marked for deletion.
        # Constraints: Must be at least 1 (hours)
        max_snapshot_age_hours = 168 # 7 days

        # (Required) Minimum number of snapshots to keep.
        # Constraints: Must be at least 1
        min_snapshots_to_keep = 3
      }
    }
  }

  # --------------------------------------------------------------------------
  # OPTIONAL: METADATA CONFIGURATION
  # --------------------------------------------------------------------------
  # (Optional) Contains details about the table metadata.
  # This configuration specifies the metadata format and schema for the table.
  # Currently only supports Iceberg format.

  metadata {
    # (Optional) Contains details about the metadata for an Iceberg table.
    # This block defines the schema structure for the Apache Iceberg table format.
    iceberg {
      # (Required) Schema configuration for the Iceberg table.
      # Defines the structure of your table's columns.
      schema {
        # (Required) List of schema fields for the Iceberg table.
        # Each field defines a column in the table schema.

        # Example: ID field (long integer type)
        field {
          # (Required) The name of the field.
          name = "id"

          # (Required) The field type.
          # Supported Apache Iceberg primitive types:
          #   - boolean
          #   - int
          #   - long
          #   - float
          #   - double
          #   - decimal(precision,scale)  e.g., decimal(10,2)
          #   - date
          #   - time
          #   - timestamp
          #   - timestamptz
          #   - string
          #   - uuid
          #   - fixed(length)  e.g., fixed(16)
          #   - binary
          type = "long"

          # (Optional) A Boolean value that specifies whether values are required
          # for each row in this field.
          # Default: false
          required = true
        }

        # Example: Name field (string type)
        field {
          name     = "name"
          type     = "string"
          required = true
        }

        # Example: Created timestamp field
        field {
          name     = "created_at"
          type     = "timestamp"
          required = false
        }

        # Example: Price field (decimal with precision 10, scale 2)
        field {
          name     = "price"
          type     = "decimal(10,2)"
          required = false
        }
      }
    }
  }
}

# ==============================================================================
# COMPUTED ATTRIBUTES (Read-Only)
# ==============================================================================
# The following attributes are exported and can be referenced in other resources
# using aws_s3tables_table.example.<attribute_name>:
#
# - arn                  : ARN of the table
# - created_at           : Date and time when the namespace was created
# - created_by           : Account ID of the account that created the namespace
# - metadata_location    : Location of table metadata
# - modified_at          : Date and time when the namespace was last modified
# - modified_by          : Account ID of the account that last modified the namespace
# - owner_account_id     : Account ID of the account that owns the namespace
# - tags_all             : A map of tags assigned to the resource, including those
#                          inherited from the provider default_tags configuration block
# - type                 : Type of the table (One of "customer" or "aws")
# - version_token        : Identifier for the current version of table data
# - warehouse_location   : S3 URI pointing to the S3 Bucket that contains the table data
# ==============================================================================

# ==============================================================================
# OUTPUT EXAMPLES
# ==============================================================================
# Example outputs to reference this resource's attributes:

# output "table_arn" {
#   description = "The ARN of the S3 Tables table"
#   value       = aws_s3tables_table.example.arn
# }
#
# output "table_warehouse_location" {
#   description = "S3 URI pointing to the S3 Bucket that contains the table data"
#   value       = aws_s3tables_table.example.warehouse_location
# }
#
# output "table_metadata_location" {
#   description = "Location of table metadata"
#   value       = aws_s3tables_table.example.metadata_location
# }
#
# output "table_version_token" {
#   description = "Identifier for the current version of table data"
#   value       = aws_s3tables_table.example.version_token
# }

# ==============================================================================
# DEPENDENCIES AND RELATED RESOURCES
# ==============================================================================
# This resource typically requires:
# - aws_s3tables_table_bucket : The S3 Tables bucket that will contain this table
# - aws_s3tables_namespace    : The namespace within the table bucket
#
# Related resources:
# - aws_s3tables_table_policy       : Manage table-level access policies
# - aws_s3tables_table_replication  : Configure table replication
# - aws_kms_key                     : For encryption with customer-managed keys
#
# Example dependency setup:

resource "aws_s3tables_table_bucket" "example" {
  name = "example-table-bucket"
}

resource "aws_s3tables_namespace" "example" {
  namespace        = "example_namespace"
  table_bucket_arn = aws_s3tables_table_bucket.example.arn
}

# Then reference in the main resource:
#   table_bucket_arn = aws_s3tables_table_bucket.example.arn
#   namespace        = aws_s3tables_namespace.example.namespace

# ==============================================================================
# IMPORTANT NOTES
# ==============================================================================
# 1. Table Bucket ARN is a force-new attribute. Changing it requires resource replacement.
# 2. Table names must follow strict naming conventions (lowercase, numbers, underscores only).
# 3. Currently only ICEBERG format is supported.
# 4. The metadata schema can define complex structures using Apache Iceberg types.
# 5. Maintenance configuration helps optimize query performance and manage storage costs.
# 6. Encryption can be configured with AWS-managed (AES256) or customer-managed (KMS) keys.
# 7. Snapshot management helps control the number and age of table snapshots.
# 8. Compaction settings help optimize storage by combining small data files.
# ==============================================================================

# ==============================================================================
# TERRAFORM IMPORT
# ==============================================================================
# Import using the table bucket ARN, namespace, and table name separated by a comma:
#
# terraform import aws_s3tables_table.example \
#   "arn:aws:s3tables:us-east-1:123456789012:bucket/example-bucket,example_namespace,example_table"
# ==============================================================================
