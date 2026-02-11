################################################################################
# Amazon S3 Tables - Table Bucket
################################################################################
# Amazon S3 Tables is a new feature of Amazon S3 designed for optimized
# analytics workloads. It provides higher transactions per second (TPS) and
# better query throughput compared to self-managed tables in S3 general purpose
# buckets. Table buckets support storing tables in the Apache Iceberg format,
# which is optimized for query performance and data consistency.
#
# Key Features:
# - Up to 10x higher transactions per second compared to Iceberg tables in
#   general-purpose S3 buckets
# - Up to 3x faster query throughput
# - Built-in Apache Iceberg support for seamless querying
# - Automated table optimization (compaction, snapshot management, unreferenced
#   file removal)
# - Integration with AWS analytics services (Athena, Redshift, Quick Suite,
#   AWS Lake Formation)
# - Support for Apache Spark (AWS Glue, Amazon EMR, SageMaker Unified Studio)
# - Automatic cost optimization with Intelligent-Tiering storage class
# - IAM and Service Control Policies for access management
#
# Use Cases:
# - Analytics workloads requiring high query performance
# - Tabular data storage with Apache Iceberg format
# - Large-scale data lakes requiring automatic maintenance
# - Multi-engine analytics environments (Athena, Redshift, Spark)
#
# Terraform Resource Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3tables_table_bucket
#
# AWS Service Documentation:
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables.html
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-buckets.html
################################################################################

resource "aws_s3tables_table_bucket" "example" {
  ############################################################################
  # Required Arguments
  ############################################################################

  # Name of the table bucket
  # - Must be between 3 and 63 characters in length
  # - Can consist of lowercase letters, numbers, and hyphens
  # - Must begin and end with a lowercase letter or number
  # - Must be unique across all table buckets in your AWS account in the region
  # - Forces new resource if changed
  # Reference: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-buckets-naming.html#table-buckets-naming-rules
  name = "example-analytics-table-bucket"

  ############################################################################
  # Optional Arguments
  ############################################################################

  # Encryption Configuration
  # Defines the encryption settings for the table bucket. All data in S3 Tables
  # is encrypted at rest. You can choose between AWS-managed encryption (AES256)
  # or customer-managed KMS keys (aws:kms).
  # - Default: AWS-managed encryption (AES256) if not specified
  encryption_configuration {
    # SSE Algorithm
    # - "AES256": AWS-managed encryption using Amazon S3-managed keys (SSE-S3)
    # - "aws:kms": Server-side encryption using AWS KMS keys (SSE-KMS)
    # - Required field when encryption_configuration is specified
    sse_algorithm = "aws:kms"

    # KMS Key ARN
    # - Required when sse_algorithm is "aws:kms"
    # - Omit this field when using "AES256"
    # - Must be a valid KMS key ARN in the same region
    # - The key policy must allow the S3 Tables service to use the key
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  # Force Destroy
  # Controls whether all tables and namespaces within the table bucket should
  # be deleted when the table bucket is destroyed.
  # - Default: false
  # - When true: All tables and namespaces are deleted with the bucket
  # - Warning: Deleted tables and namespaces are NOT recoverable
  # - Important: Requires successful terraform apply after setting to true
  #   before the destroy operation will respect this flag
  # - Does not work when set in the same operation that destroys the bucket
  # - Must be set and applied before importing a table bucket for it to take effect
  force_destroy = false

  # Maintenance Configuration
  # Defines automated maintenance operations for tables in the bucket.
  # S3 Tables performs automated optimization to improve query performance and
  # reduce storage costs through operations like compaction, snapshot management,
  # and unreferenced file removal.
  maintenance_configuration {
    # Iceberg Unreferenced File Removal
    # Manages the automatic deletion of data files that are no longer referenced
    # by any table metadata. This helps reduce storage costs by cleaning up
    # orphaned files left by failed writes, updates, or deletes.
    iceberg_unreferenced_file_removal {
      # Status
      # - "enabled": Automatic unreferenced file removal is active
      # - "disabled": No automatic file removal
      # - Required field
      status = "enabled"

      # Settings
      # Defines the retention periods for unreferenced file removal.
      settings {
        # Unreferenced Days
        # Number of days a file must be unreferenced before being marked for deletion.
        # - Must be at least 1
        # - Recommended: Set to at least 3-7 days to allow for delayed read operations
        # - Files become eligible for deletion marking after this period
        # - Required field
        unreferenced_days = 3

        # Non-Current Days
        # Number of days after being marked for deletion before the file is
        # actually deleted.
        # - Must be at least 1
        # - Recommended: Set to at least 1-3 days as a safety buffer
        # - Total retention = unreferenced_days + non_current_days
        # - Required field
        non_current_days = 1
      }
    }
  }

  # Region
  # Specifies the AWS region where the table bucket will be created.
  # - Optional: Defaults to the provider region if not specified
  # - S3 Tables is available in specific regions (check availability)
  # - Available regions (as of Dec 2024): us-east-1, us-east-2, us-west-2
  # - Once created, the table bucket cannot be moved to a different region
  # region = "us-east-1"

  # Tags
  # Key-value map of resource tags for organization and cost tracking.
  # - Tags are inherited by tables created in this bucket
  # - Can be overridden by provider default_tags
  # - Maximum 50 tags per resource
  # - Tag keys and values are case-sensitive
  tags = {
    Environment = "production"
    Project     = "analytics"
    ManagedBy   = "terraform"
    Purpose     = "iceberg-tables"
    CostCenter  = "data-engineering"
  }
}

################################################################################
# Outputs
################################################################################

# Table Bucket ARN
# The Amazon Resource Name (ARN) uniquely identifies the table bucket.
# Format: arn:aws:s3tables:region:account-id:bucket/table-bucket-name
# Used for IAM policies, resource-based policies, and cross-service integrations.
output "table_bucket_arn" {
  description = "ARN of the S3 Tables table bucket"
  value       = aws_s3tables_table_bucket.example.arn
}

# Table Bucket Name
# The name of the table bucket, useful for referencing in other resources.
output "table_bucket_name" {
  description = "Name of the S3 Tables table bucket"
  value       = aws_s3tables_table_bucket.example.name
}

# Creation Time
# The date and time when the table bucket was created (RFC3339 format).
# Useful for auditing and tracking resource lifecycle.
output "table_bucket_created_at" {
  description = "Creation timestamp of the table bucket"
  value       = aws_s3tables_table_bucket.example.created_at
}

# Owner Account ID
# The AWS account ID that owns the table bucket.
# Useful for cross-account access scenarios and auditing.
output "table_bucket_owner_account_id" {
  description = "AWS account ID of the table bucket owner"
  value       = aws_s3tables_table_bucket.example.owner_account_id
}

# All Tags
# A map of all tags assigned to the resource, including those inherited from
# the provider default_tags configuration block.
output "table_bucket_tags_all" {
  description = "All tags assigned to the table bucket (including default tags)"
  value       = aws_s3tables_table_bucket.example.tags_all
}

################################################################################
# Additional Configuration Examples
################################################################################

# Example 1: Minimal Configuration with AWS-Managed Encryption
# This is the simplest configuration for a table bucket using AWS-managed
# encryption (AES256). Suitable for development or non-sensitive workloads.
/*
resource "aws_s3tables_table_bucket" "minimal" {
  name = "minimal-table-bucket"

  tags = {
    Environment = "development"
  }
}
*/

# Example 2: Production Configuration with KMS Encryption
# This configuration uses customer-managed KMS keys for encryption and
# enables automated maintenance with conservative retention settings.
# Suitable for production workloads with compliance requirements.
/*
resource "aws_s3tables_table_bucket" "production" {
  name = "production-analytics-bucket"

  encryption_configuration {
    sse_algorithm = "aws:kms"
    kms_key_arn   = aws_kms_key.table_bucket_key.arn
  }

  maintenance_configuration {
    iceberg_unreferenced_file_removal {
      status = "enabled"
      settings {
        unreferenced_days = 7  # 7 days before marking for deletion
        non_current_days  = 3  # 3 days safety buffer before actual deletion
      }
    }
  }

  force_destroy = false  # Prevent accidental deletion of tables

  tags = {
    Environment        = "production"
    SecurityLevel      = "high"
    ComplianceRequired = "true"
  }
}
*/

# Example 3: Development/Testing Configuration with Force Destroy
# This configuration is suitable for development or testing environments where
# you may need to frequently create and destroy table buckets with their contents.
/*
resource "aws_s3tables_table_bucket" "development" {
  name = "dev-testing-table-bucket"

  encryption_configuration {
    sse_algorithm = "AES256"  # AWS-managed encryption for simplicity
  }

  maintenance_configuration {
    iceberg_unreferenced_file_removal {
      status = "enabled"
      settings {
        unreferenced_days = 1  # Aggressive cleanup for cost savings
        non_current_days  = 1
      }
    }
  }

  force_destroy = true  # Allow easy cleanup in dev environments

  tags = {
    Environment = "development"
    AutoDelete  = "true"
  }
}
*/

# Example 4: Multi-Region Configuration
# When deploying table buckets in multiple regions for disaster recovery
# or regional data processing.
/*
resource "aws_s3tables_table_bucket" "us_east" {
  name   = "multi-region-east-bucket"
  region = "us-east-1"

  encryption_configuration {
    sse_algorithm = "aws:kms"
    kms_key_arn   = aws_kms_key.us_east_key.arn
  }

  maintenance_configuration {
    iceberg_unreferenced_file_removal {
      status = "enabled"
      settings {
        unreferenced_days = 5
        non_current_days  = 2
      }
    }
  }

  tags = {
    Region = "us-east-1"
    Role   = "primary"
  }
}

resource "aws_s3tables_table_bucket" "us_west" {
  name   = "multi-region-west-bucket"
  region = "us-west-2"

  encryption_configuration {
    sse_algorithm = "aws:kms"
    kms_key_arn   = aws_kms_key.us_west_key.arn
  }

  maintenance_configuration {
    iceberg_unreferenced_file_removal {
      status = "enabled"
      settings {
        unreferenced_days = 5
        non_current_days  = 2
      }
    }
  }

  tags = {
    Region = "us-west-2"
    Role   = "secondary"
  }
}
*/

################################################################################
# Important Notes and Best Practices
################################################################################

# Quota Limits:
# - Default limit: 10 table buckets per region per account
# - Can request quota increase via AWS Service Quotas
# - Maximum 10,000 tables per bucket
# - Plan your table bucket strategy accordingly for large-scale deployments

# Naming Considerations:
# - Table bucket names must be globally unique within your AWS account and region
# - Use descriptive names that reflect the purpose or data type
# - Consider including environment (dev/staging/prod) in the name
# - Cannot be changed after creation (forces replacement)

# Encryption Best Practices:
# - Use aws:kms for production workloads requiring audit trails
# - Ensure KMS key policy grants S3 Tables service permissions
# - Consider using different KMS keys for different environments
# - Monitor KMS costs as encryption/decryption operations incur charges

# Maintenance Configuration Recommendations:
# - Enable unreferenced file removal to reduce storage costs
# - Set unreferenced_days to at least 3-7 days for production (allows recovery time)
# - Balance between storage costs and data retention requirements
# - Monitor table maintenance jobs in CloudWatch

# Access Control:
# - Use IAM policies to control who can create, delete, and manage table buckets
# - Implement table-level access controls via table policies
# - Leverage AWS Lake Formation for fine-grained access control
# - Use Service Control Policies in AWS Organizations for multi-account governance

# Cost Optimization:
# - Enable automatic unreferenced file removal to clean up orphaned data
# - Tables automatically use S3 Intelligent-Tiering for cost optimization
# - Monitor storage metrics via CloudWatch to track costs
# - Set appropriate retention periods based on your compliance requirements

# Integration with Analytics Services:
# - Connect to AWS Glue Data Catalog for automatic table discovery
# - Query tables using Amazon Athena for serverless SQL analytics
# - Use Amazon Redshift for data warehousing workloads
# - Process data with Apache Spark on EMR, Glue, or SageMaker

# Monitoring and Logging:
# - Enable CloudTrail logging for API calls to table buckets
# - Monitor CloudWatch metrics for table operations
# - Set up alarms for unusual access patterns
# - Track maintenance job completion and failures

# Disaster Recovery:
# - Table buckets cannot be replicated across regions (no cross-region replication)
# - Consider deploying separate table buckets in multiple regions
# - Implement data synchronization strategies if multi-region is required
# - Backup critical table metadata and configurations

# Migration Considerations:
# - Moving from general-purpose S3 buckets with Iceberg requires data migration
# - Use AWS Data Migration tools or custom ETL processes
# - Test thoroughly in non-production environments first
# - Plan for downtime or dual-write periods during migration

# Deletion and Cleanup:
# - force_destroy must be set to true and applied before destroying buckets with tables
# - Deleted tables and namespaces cannot be recovered
# - Consider implementing backup strategies before enabling force_destroy
# - Document table bucket dependencies to prevent accidental deletion
