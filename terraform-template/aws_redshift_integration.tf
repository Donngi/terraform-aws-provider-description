################################################################################
# AWS Redshift Integration
################################################################################
# Manages a zero-ETL integration between DynamoDB/S3 and Amazon Redshift.
# Zero-ETL integrations enable automatic data replication from operational
# databases to Redshift without building and maintaining ETL pipelines.
#
# Supported integration types:
# - DynamoDB zero-ETL: Replicates DynamoDB tables to Redshift (min latency: 15 min)
# - S3 event integration: Loads data from S3 events into Redshift
#
# Key features:
# - Automatic data replication from source to target
# - No impact on production workloads
# - Built-in monitoring and health checks
# - Optional KMS encryption with custom keys
# - Supports Redshift Serverless and RA3 provisioned clusters
#
# Prerequisites:
# - DynamoDB source: Point-in-time recovery (PITR) must be enabled
# - Redshift target: Must use Serverless or RA3 instance types
# - Redshift target: Must have case sensitivity enabled
# - Tables: Must have primary keys defined
#
# Related services:
# - Amazon DynamoDB (source)
# - Amazon S3 (source)
# - Amazon Redshift (target)
# - Amazon Redshift Serverless (target)
# - AWS KMS (optional encryption)
#
# Terraform documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_integration
#
# AWS documentation:
# https://docs.aws.amazon.com/redshift/latest/mgmt/zero-etl-using.html
# https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/RedshiftforDynamoDB-zero-etl.html
################################################################################

resource "aws_redshift_integration" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # Name of the integration
  # Must be unique within your AWS account and region
  # Used to identify the integration in AWS console and APIs
  # Example: "my-dynamodb-redshift-integration"
  integration_name = "example-integration"

  # ARN of the source database for replication
  # FORCES NEW RESOURCE - cannot be changed after creation
  #
  # Supported sources:
  # - DynamoDB table: arn:aws:dynamodb:REGION:ACCOUNT:table/TABLE_NAME
  # - S3 bucket: arn:aws:s3:::BUCKET_NAME
  #
  # Requirements for DynamoDB source:
  # - Point-in-time recovery (PITR) must be enabled
  # - Table must have primary key defined
  # - Table name must be 127 characters or less
  #
  # Example: aws_dynamodb_table.source.arn
  source_arn = "arn:aws:dynamodb:us-east-1:123456789012:table/source-table"

  # ARN of the Redshift data warehouse target
  # FORCES NEW RESOURCE - cannot be changed after creation
  #
  # Supported targets:
  # - Redshift Serverless namespace: arn:aws:redshift-serverless:REGION:ACCOUNT:namespace/NAMESPACE_ID
  # - Redshift provisioned cluster: arn:aws:redshift:REGION:ACCOUNT:cluster:CLUSTER_NAME
  #
  # Requirements:
  # - Must use Redshift Serverless or RA3 instance types
  # - Must be encrypted (for provisioned clusters)
  # - Must have case sensitivity enabled
  # - Maximum 50 zero-ETL integrations per data warehouse
  #
  # Example: aws_redshiftserverless_namespace.target.arn
  target_arn = "arn:aws:redshift-serverless:us-east-1:123456789012:namespace/target-namespace"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # Description of the integration purpose
  # Helps document the integration's business purpose
  # Example: "Replicates customer orders from DynamoDB to Redshift for analytics"
  description = "Zero-ETL integration for data analytics"

  # AWS region where the integration will be managed
  # Defaults to the provider's configured region if not specified
  # The source and target resources do not need to be in the same region
  # Example: "us-east-1"
  # region = "us-east-1"

  # KMS key ARN for encrypting the integration
  # FORCES NEW RESOURCE - cannot be changed after creation
  #
  # Encryption behavior:
  # - If not specified: Uses AWS owned default key
  # - If specified: Uses your customer managed key
  # - Only supported for DynamoDB sources (not S3)
  #
  # KMS key policy requirements:
  # - Must allow kms:Decrypt for redshift.amazonaws.com service
  # - Must allow kms:CreateGrant for redshift.amazonaws.com service
  # - Condition: aws:SourceAccount must match your account ID
  # - Condition: aws:SourceArn must match integration ARN pattern
  #
  # Example: aws_kms_key.integration.arn
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # Additional encryption context for KMS operations
  # FORCES NEW RESOURCE - cannot be changed after creation
  #
  # Encryption context is a set of key-value pairs that provide
  # additional contextual information about encrypted data.
  # Used for audit logging and access control in CloudTrail.
  #
  # Requirements:
  # - Can only be used if kms_key_id is specified
  # - Keys and values must be non-secret
  # - Used for logging and access control, not for encryption strength
  #
  # Amazon Redshift automatically adds these encryption context pairs:
  # - aws:redshift:arn: The integration ARN
  # - aws:redshift:integrationname: The integration name
  #
  # Example:
  # additional_encryption_context = {
  #   "environment" = "production"
  #   "project"     = "analytics"
  #   "team"        = "data-engineering"
  # }

  # Resource tags for organization and cost tracking
  # Supports AWS provider default_tags configuration
  # Tags are applied to the integration resource
  #
  # Common tag patterns:
  # - Environment: dev, staging, production
  # - Owner: team or individual responsible
  # - Cost Center: for chargeback and billing
  # - Project: business initiative or application
  #
  # Example:
  tags = {
    Name        = "example-integration"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  ################################################################################
  # Lifecycle Considerations
  ################################################################################
  # - Integration creation triggers initial data load from source to target
  # - Data replication continues automatically after initial load
  # - Minimum latency for DynamoDB: 15 minutes (can be increased)
  # - If source is deleted, integration enters "FAILED" state
  # - Previously replicated data remains in Redshift after integration deletion
  # - Destination database in Redshift is read-only
  # - Use REFRESH_INTERVAL parameter to control replication frequency
  #
  # Monitoring:
  # - Create EventBridge rules for integration events
  # - Query Amazon Redshift system views for integration status
  # - Monitor CloudWatch metrics for replication lag
  ################################################################################
}

################################################################################
# Outputs
################################################################################

output "redshift_integration_arn" {
  description = "ARN of the Redshift integration"
  value       = aws_redshift_integration.example.arn
}

output "redshift_integration_id" {
  description = "ID of the Redshift integration"
  value       = aws_redshift_integration.example.id
}

output "redshift_integration_tags_all" {
  description = "Map of tags assigned to the resource, including provider default_tags"
  value       = aws_redshift_integration.example.tags_all
}

################################################################################
# Example Configurations
################################################################################

# Example 1: DynamoDB to Redshift Serverless with default encryption
/*
resource "aws_dynamodb_table" "source" {
  name           = "source-table"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  # REQUIRED: Point-in-time recovery must be enabled
  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "source-dynamodb-table"
  }
}

resource "aws_redshiftserverless_namespace" "target" {
  namespace_name = "target-namespace"

  tags = {
    Name = "target-redshift-namespace"
  }
}

resource "aws_redshiftserverless_workgroup" "target" {
  namespace_name      = aws_redshiftserverless_namespace.target.namespace_name
  workgroup_name      = "target-workgroup"
  base_capacity       = 8
  publicly_accessible = false

  # REQUIRED: Case sensitivity must be enabled
  config_parameter {
    parameter_key   = "enable_case_sensitive_identifier"
    parameter_value = "true"
  }

  tags = {
    Name = "target-redshift-workgroup"
  }
}

resource "aws_redshift_integration" "dynamodb_to_redshift" {
  integration_name = "dynamodb-to-redshift"
  source_arn       = aws_dynamodb_table.source.arn
  target_arn       = aws_redshiftserverless_namespace.target.arn
  description      = "Zero-ETL integration from DynamoDB to Redshift Serverless"

  tags = {
    Name        = "dynamodb-redshift-integration"
    Environment = "production"
  }
}
*/

# Example 2: DynamoDB to Redshift with customer managed KMS key
/*
data "aws_caller_identity" "current" {}

resource "aws_kms_key" "integration" {
  description             = "KMS key for Redshift integration encryption"
  deletion_window_in_days = 10

  tags = {
    Name = "redshift-integration-key"
  }
}

resource "aws_kms_key_policy" "integration" {
  key_id = aws_kms_key.integration.id

  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Redshift to use the key"
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:CreateGrant"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnEquals = {
            "aws:SourceArn" = "arn:aws:redshift:*:${data.aws_caller_identity.current.account_id}:integration:*"
          }
        }
      }
    ]
  })
}

resource "aws_redshift_integration" "encrypted" {
  integration_name = "encrypted-integration"
  source_arn       = aws_dynamodb_table.source.arn
  target_arn       = aws_redshiftserverless_namespace.target.arn
  kms_key_id       = aws_kms_key.integration.arn

  additional_encryption_context = {
    "environment" = "production"
    "purpose"     = "analytics"
  }

  description = "Encrypted zero-ETL integration with customer managed key"

  tags = {
    Name        = "encrypted-redshift-integration"
    Environment = "production"
    Encrypted   = "true"
  }

  depends_on = [aws_kms_key_policy.integration]
}
*/

# Example 3: Multiple DynamoDB tables to single Redshift data warehouse
/*
resource "aws_dynamodb_table" "orders" {
  name           = "orders"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "order_id"

  attribute {
    name = "order_id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "orders-table"
  }
}

resource "aws_dynamodb_table" "customers" {
  name           = "customers"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "customer_id"

  attribute {
    name = "customer_id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "customers-table"
  }
}

resource "aws_redshift_integration" "orders_integration" {
  integration_name = "orders-to-redshift"
  source_arn       = aws_dynamodb_table.orders.arn
  target_arn       = aws_redshiftserverless_namespace.target.arn
  description      = "Replicate orders data for analytics"

  tags = {
    Name       = "orders-integration"
    SourceType = "orders"
  }
}

resource "aws_redshift_integration" "customers_integration" {
  integration_name = "customers-to-redshift"
  source_arn       = aws_dynamodb_table.customers.arn
  target_arn       = aws_redshiftserverless_namespace.target.arn
  description      = "Replicate customers data for analytics"

  tags = {
    Name       = "customers-integration"
    SourceType = "customers"
  }
}
*/

################################################################################
# Important Notes
################################################################################
# 1. Initial Setup:
#    - DynamoDB tables must have PITR enabled before creating integration
#    - Redshift target must have case sensitivity enabled
#    - All tables must have primary keys defined
#
# 2. Encryption:
#    - KMS key policy must allow Redshift service principal
#    - additional_encryption_context requires kms_key_id
#    - AWS owned keys are used by default if kms_key_id not specified
#
# 3. Data Replication:
#    - Initial load exports full DynamoDB table to Redshift
#    - Incremental updates use DynamoDB incremental exports
#    - Minimum replication latency is 15 minutes
#    - Use REFRESH_INTERVAL to control update frequency
#
# 4. Limitations:
#    - Maximum 50 integrations per Redshift data warehouse
#    - DynamoDB table names must be 127 characters or less
#    - DynamoDB data maps to SUPER data type in Redshift
#    - Redshift VARCHAR max length is 65,535 bytes
#    - Destination database is read-only in Redshift
#
# 5. Cost Considerations:
#    - DynamoDB export costs apply for data replication
#    - Redshift storage costs for replicated data
#    - KMS key costs if using customer managed keys
#    - Data transfer costs may apply across regions
#
# 6. Monitoring:
#    - Use EventBridge for integration event notifications
#    - Query Redshift system views for integration status
#    - Monitor CloudWatch metrics for replication lag
#    - Check integration health in AWS console
#
# 7. Disaster Recovery:
#    - If source is deleted, integration enters FAILED state
#    - Previously replicated data remains in Redshift
#    - Re-create integration to resume replication
#    - Consider backup strategies for source and target
################################################################################
