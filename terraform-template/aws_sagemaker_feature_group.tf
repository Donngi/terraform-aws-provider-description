################################################################################
# AWS SageMaker Feature Group
################################################################################
# Resource: aws_sagemaker_feature_group
# Provider Version: 6.28.0
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sagemaker_feature_group
#
# AWS SageMaker Feature Store is a fully managed, purpose-built repository to store,
# share, and manage features for machine learning (ML) models. A Feature Group is
# a logical grouping of features in Feature Store, similar to a table in a database.
#
# Key Concepts:
# - Online Store: Provides low-latency, real-time feature retrieval (millisecond latency)
#   for inference workloads. Only keeps the latest record per identifier.
# - Offline Store: S3-based historical feature store for training and batch inference.
#   Maintains all historical records with timestamps.
# - Record Identifier: Unique identifier for each record (row) in the feature group
# - Event Time: Timestamp feature that tracks when the feature values were observed
# - Feature Definition: Schema defining each feature's name, type, and optional collection config
#
# Feature Types:
# - Integral: Integer numbers
# - Fractional: Floating point numbers
# - String: Text values
#
# Storage Types (Online Store):
# - Standard: Cost-effective storage with sub-second latency
# - InMemory: Ultra-low latency with higher cost
#
# Use Cases:
# - Real-time ML inference with consistent feature access
# - Feature sharing across multiple ML models and teams
# - Point-in-time correct training data for model training
# - Feature versioning and lineage tracking
################################################################################

resource "aws_sagemaker_feature_group" "this" {
  #------------------------------------------------------------------------------
  # Required Arguments
  #------------------------------------------------------------------------------

  # The name of the Feature Group (must be unique within AWS Region/Account)
  # - Must be between 1-64 characters
  # - Alphanumeric and hyphens allowed
  # - Cannot be changed after creation (forces new resource)
  # Example: "customer-features", "product-embeddings-v1"
  feature_group_name = "example-feature-group"

  # The name of the feature that uniquely identifies each record
  # - This feature must be defined in feature_definition block
  # - Only the latest record per identifier is stored in Online Store
  # - Common examples: "customer_id", "product_id", "transaction_id"
  # - Cannot be named "is_deleted", "write_time", or "api_invocation_time"
  record_identifier_feature_name = "record_id"

  # The name of the feature that stores the event timestamp
  # - This feature must be defined in feature_definition block
  # - Used for point-in-time correctness in offline store queries
  # - Format: Unix epoch time (seconds since 1970-01-01) as fractional or string
  # - Cannot be named "is_deleted", "write_time", or "api_invocation_time"
  event_time_feature_name = "event_time"

  # IAM role ARN that SageMaker assumes to access resources
  # - Required permissions: S3 write for offline store, KMS if encryption enabled
  # - Trust policy must allow sagemaker.amazonaws.com to assume the role
  # - Example managed policy: AmazonSageMakerFeatureStoreAccess
  role_arn = "arn:aws:iam::123456789012:role/service-role/AmazonSageMaker-ExecutionRole"

  #------------------------------------------------------------------------------
  # Optional Arguments
  #------------------------------------------------------------------------------

  # Free-form text description of the feature group
  # - Helps with discoverability when searching feature groups
  # - Best practice: Document feature definitions, update frequency, data sources
  # - Supports markdown formatting
  description = "Feature group for customer attributes including demographics and behavioral metrics"

  # AWS region where this feature group will be managed
  # - Defaults to provider region if not specified
  # - Feature groups cannot be moved between regions after creation
  # - Choose region close to your data sources and inference endpoints
  # region = "us-east-1"

  # Tags for resource organization and cost allocation
  # - Inherited by underlying resources (S3 buckets, Glue tables)
  # - Useful for cost tracking, access control, and automation
  # - Merged with provider default_tags if configured
  tags = {
    Environment = "production"
    Team        = "ml-platform"
    Purpose     = "customer-features"
    CostCenter  = "ml-ops"
  }

  #------------------------------------------------------------------------------
  # Feature Definition Block (Required, min: 1, max: 2500)
  #------------------------------------------------------------------------------
  # Defines the schema for features in the feature group
  # - At least one feature_definition is required
  # - Can have up to 2500 features per feature group
  # - Features can be added after creation using UpdateFeatureGroup API
  # - Features cannot be removed once added

  # Record identifier feature definition
  feature_definition {
    feature_name = "record_id"
    feature_type = "String" # Valid: "Integral", "Fractional", "String"
  }

  # Event time feature definition
  feature_definition {
    feature_name = "event_time"
    feature_type = "Fractional" # Unix timestamp as float
  }

  # Standard feature definitions
  feature_definition {
    feature_name = "customer_age"
    feature_type = "Integral"
  }

  feature_definition {
    feature_name = "account_balance"
    feature_type = "Fractional"
  }

  feature_definition {
    feature_name = "customer_tier"
    feature_type = "String"
  }

  # Vector embedding feature with collection config (for ML embeddings)
  # - Use collection_type = "Vector" for embedding features
  # - vector_config specifies the dimension of the embedding
  # - Enables vector similarity search capabilities
  # feature_definition {
  #   feature_name    = "product_embedding"
  #   collection_type = "Vector"
  #
  #   collection_config {
  #     vector_config {
  #       dimension = 768 # Size of embedding vector (e.g., 768 for BERT)
  #     }
  #   }
  # }

  # List/Set collection type example
  # feature_definition {
  #   feature_name    = "product_categories"
  #   feature_type    = "String"
  #   collection_type = "List" # or "Set"
  # }

  #------------------------------------------------------------------------------
  # Online Store Configuration (Optional)
  #------------------------------------------------------------------------------
  # Enables real-time feature retrieval with low latency
  # - GetRecord API provides millisecond latency access
  # - Only stores the most recent record per identifier
  # - Automatically updated when new records are ingested

  online_store_config {
    # Enable or disable the online store
    # - Set to true for real-time inference use cases
    # - Set to false or omit block for training-only use cases
    # - Default: false
    enable_online_store = true

    # Storage tier for online store
    # - "Standard": Cost-effective, sub-second latency (default)
    # - "InMemory": Ultra-low latency (<10ms), higher cost
    # - InMemory recommended for high-throughput, latency-critical applications
    storage_type = "Standard"

    # Security configuration for at-rest encryption
    # - Encrypts data in the online store using AWS KMS
    # - If not specified, uses default SageMaker encryption
    # security_config {
    #   kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    # }

    # Time-to-live (TTL) configuration for automatic record expiration
    # - Records are soft-deleted after: EventTime + TTL duration
    # - Hard deletion happens asynchronously after soft delete
    # - Useful for GDPR compliance and cost optimization
    # ttl_duration {
    #   unit  = "Days"    # Valid: "Seconds", "Minutes", "Hours", "Days", "Weeks"
    #   value = 90        # Number of units
    # }
  }

  #------------------------------------------------------------------------------
  # Offline Store Configuration (Optional)
  #------------------------------------------------------------------------------
  # Enables historical feature storage in S3 for training and batch inference
  # - Stores all records with timestamps for point-in-time correctness
  # - Data stored in Apache Parquet or Iceberg format
  # - Queryable via Amazon Athena or SageMaker Data Wrangler

  offline_store_config {
    # S3 storage configuration (required if offline_store_config is specified)
    s3_storage_config {
      # S3 URI where offline store data will be written
      # - Format: s3://bucket-name/prefix/
      # - SageMaker creates subdirectories: /data, /metadata, /resolved
      # - Role must have s3:PutObject permission on this location
      s3_uri = "s3://my-sagemaker-bucket/feature-store/customer-features/"

      # KMS key for S3 server-side encryption (optional)
      # - Encrypts data written to S3
      # - Role must have kms:GenerateDataKey permission
      # - If omitted, uses S3 default encryption (SSE-S3)
      # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

      # Resolved output S3 URI (optional, computed)
      # - Full S3 path where resolved data is written
      # - Typically used to verify the actual write location
      # - Usually auto-computed, rarely needs manual setting
      # resolved_output_s3_uri = "s3://my-sagemaker-bucket/feature-store/customer-features/resolved/"
    }

    # Disable automatic Glue Data Catalog table creation
    # - Default: false (Glue table is created)
    # - Set to true if you want to manually manage the Glue catalog
    # - When false, SageMaker creates a Glue database and table for Athena queries
    disable_glue_table_creation = false

    # Table format for offline store
    # - "Glue" (default): Traditional Glue table format
    # - "Iceberg": Apache Iceberg format for advanced table management
    # - Iceberg supports ACID transactions, time travel, schema evolution
    # - Cannot be changed after creation
    # table_format = "Iceberg"

    # Data Catalog configuration for AWS Glue (optional)
    # - Auto-populated if disable_glue_table_creation = false
    # - Manually specify to use custom Glue catalog/database/table names
    # data_catalog_config {
    #   catalog    = "AwsDataCatalog"           # Default Glue catalog
    #   database   = "sagemaker_featurestore"   # Glue database name
    #   table_name = "customer_features"        # Glue table name
    # }
  }

  #------------------------------------------------------------------------------
  # Throughput Configuration (Optional)
  #------------------------------------------------------------------------------
  # Configure provisioned throughput for online store (Provisioned mode only)
  # - Only applies when storage_type = "Standard"
  # - Not used with InMemory storage type
  # - Auto-scaling can be configured via Application Auto Scaling

  # throughput_config {
  #   # Throughput mode
  #   # - "OnDemand" (default): Pay per request, automatic scaling
  #   # - "Provisioned": Fixed capacity, lower cost at high volume
  #   throughput_mode = "Provisioned"
  #
  #   # Provisioned capacity units (required if throughput_mode = "Provisioned")
  #   # - Each unit provides specific read/write throughput
  #   # - Read capacity: consistent reads per second
  #   # - Write capacity: writes per second
  #   provisioned_read_capacity_units  = 10
  #   provisioned_write_capacity_units = 5
  # }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# These attributes are set by AWS and can be referenced after creation:
#
# - id: Feature group name (same as feature_group_name)
# - arn: Amazon Resource Name (ARN) of the feature group
#   Format: arn:aws:sagemaker:region:account-id:feature-group/feature-group-name
# - tags_all: Map of tags including provider default_tags
#
# Usage examples:
# - resource.aws_sagemaker_feature_group.this.arn
# - resource.aws_sagemaker_feature_group.this.id

################################################################################
# Feature Ingestion Guide
################################################################################
# After creating a feature group, ingest data using:
#
# 1. Real-time ingestion (PutRecord API):
#    - Synchronous API call for single record
#    - Updates both online and offline stores (if configured)
#    - Use for streaming data sources and real-time updates
#
# 2. Batch ingestion (SageMaker Data Wrangler or Processing Jobs):
#    - Asynchronous batch processing
#    - More efficient for large datasets
#    - Can write directly to offline store S3 location
#
# 3. SDK Example (Python Boto3):
#    ```python
#    import boto3
#    import time
#
#    sm_runtime = boto3.client('sagemaker-featurestore-runtime')
#
#    record = [
#        {'FeatureName': 'record_id', 'ValueAsString': 'customer-001'},
#        {'FeatureName': 'event_time', 'ValueAsString': str(int(time.time()))},
#        {'FeatureName': 'customer_age', 'ValueAsString': '35'},
#        {'FeatureName': 'account_balance', 'ValueAsString': '5000.50'},
#        {'FeatureName': 'customer_tier', 'ValueAsString': 'gold'}
#    ]
#
#    sm_runtime.put_record(
#        FeatureGroupName='example-feature-group',
#        Record=record
#    )
#    ```

################################################################################
# Querying Features
################################################################################
# Online Store (Real-time retrieval):
#   - GetRecord API: Retrieve latest record by identifier
#   - BatchGetRecord API: Retrieve multiple records efficiently
#
# Offline Store (Historical queries):
#   - Amazon Athena: SQL queries on Glue table
#   - SageMaker Data Wrangler: Visual data exploration
#   - AWS Glue: ETL jobs for feature engineering
#
# Athena Query Example:
#   SELECT * FROM "sagemaker_featurestore"."customer_features"
#   WHERE event_time BETWEEN '2024-01-01' AND '2024-01-31'

################################################################################
# Best Practices
################################################################################
# 1. Schema Design:
#    - Include record_identifier and event_time in every feature group
#    - Use consistent naming conventions across feature groups
#    - Group related features together logically
#    - Consider feature cardinality and update frequency
#
# 2. Naming Conventions:
#    - Use descriptive names: "customer_lifetime_value" not "clv"
#    - Version feature groups: "features-v1", "features-v2"
#    - Prefix by domain: "customer-", "product-", "transaction-"
#
# 3. Storage Optimization:
#    - Enable only the stores you need (online vs offline)
#    - Use TTL to automatically expire old online store records
#    - Choose Iceberg format for large offline stores with frequent updates
#    - Partition offline store data by date for query performance
#
# 4. Security:
#    - Use KMS encryption for sensitive features
#    - Implement least-privilege IAM policies
#    - Use VPC endpoints for private network access
#    - Tag feature groups for access control policies
#
# 5. Cost Optimization:
#    - Use Standard storage for most workloads
#    - Reserve InMemory for ultra-low latency requirements
#    - Implement TTL to reduce online store costs
#    - Use Provisioned mode with auto-scaling for predictable workloads
#    - Monitor S3 costs for offline store growth
#
# 6. Monitoring:
#    - Set up CloudWatch alarms for ingestion errors
#    - Monitor GetRecord latency and throttling
#    - Track offline store S3 storage growth
#    - Use AWS CloudTrail for audit logging

################################################################################
# Common Issues and Troubleshooting
################################################################################
# 1. "ValidationException: Feature name cannot be..." error:
#    - Reserved names: is_deleted, write_time, api_invocation_time
#    - Cannot use these as feature_name values
#
# 2. Role permission errors:
#    - Ensure IAM role has S3 write permissions
#    - Verify KMS key policy allows sagemaker.amazonaws.com
#    - Check trust relationship allows AssumeRole
#
# 3. Ingestion failures:
#    - Verify all defined features are present in PutRecord call
#    - Check data types match feature definitions
#    - Ensure event_time is valid Unix epoch timestamp
#
# 4. Query performance issues:
#    - Partition offline store by date
#    - Use Iceberg format for better query performance
#    - Consider using AWS Glue for complex transformations
#
# 5. Online store latency:
#    - Switch to InMemory storage for sub-10ms latency
#    - Ensure application is in same AWS region
#    - Use BatchGetRecord for multiple records

################################################################################
# Related Resources
################################################################################
# - aws_iam_role: IAM role for SageMaker Feature Store access
# - aws_kms_key: KMS key for encryption
# - aws_s3_bucket: S3 bucket for offline store
# - aws_glue_catalog_database: Glue database for offline store queries
# - aws_sagemaker_feature_group data source: Reference existing feature groups

################################################################################
# Output Examples
################################################################################
output "feature_group_arn" {
  description = "ARN of the SageMaker Feature Group"
  value       = aws_sagemaker_feature_group.this.arn
}

output "feature_group_name" {
  description = "Name of the SageMaker Feature Group"
  value       = aws_sagemaker_feature_group.this.feature_group_name
}

output "feature_group_id" {
  description = "ID of the SageMaker Feature Group (same as name)"
  value       = aws_sagemaker_feature_group.this.id
}

# output "offline_store_s3_uri" {
#   description = "S3 URI where offline store data is written"
#   value       = aws_sagemaker_feature_group.this.offline_store_config[0].s3_storage_config[0].s3_uri
# }
