################################################################################
# RDS Integration
################################################################################
# Terraform resource for managing an AWS RDS (Relational Database) zero-ETL integration.
# You can refer to the User Guide: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/zero-etl.setting-up.html
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_integration

resource "aws_rds_integration" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required, Forces new resource) Name of the integration.
  integration_name = "example-integration"

  # (Required, Forces new resource) ARN of the database to use as the source for replication.
  # Example: arn:aws:rds:us-east-1:123456789012:cluster:my-aurora-cluster
  source_arn = "arn:aws:rds:us-east-1:123456789012:cluster:my-aurora-cluster"

  # (Required, Forces new resource) ARN of the Redshift data warehouse to use as the target for replication.
  # Example: arn:aws:redshift-serverless:us-east-1:123456789012:namespace/my-namespace
  target_arn = "arn:aws:redshift-serverless:us-east-1:123456789012:namespace/my-namespace"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # (Optional, Forces new resource) Set of non-secret key-value pairs that contains additional
  # contextual information about the data.
  # User Guide: https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#encrypt_context
  # Note: You can only include this parameter if you specify the kms_key_id parameter.
  # additional_encryption_context = {
  #   "example" = "test"
  # }

  # (Optional, Forces new resource) Data filters for the integration.
  # These filters determine which tables from the source database are sent to the target
  # Amazon Redshift data warehouse.
  # The value should match the syntax from the AWS CLI which includes an "include:" or "exclude:"
  # prefix before a filter expression. Multiple expressions are separated by a comma.
  # Reference: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/zero-etl.filtering.html
  # Examples:
  #   - "include:schema1.table1,schema2.table2"
  #   - "exclude:schema1.table1"
  # data_filter = "include:schema1.table1"

  # (Optional, Forces new resource) KMS key identifier for the key to use to encrypt the integration.
  # If you don't specify an encryption key, RDS uses a default AWS owned key.
  # If you use the default AWS owned key, you should ignore kms_key_id parameter by using
  # lifecycle parameter to avoid unintended change after the first creation.
  # Example: arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # (Optional) Key-value map of resource tags.
  # If configured with a provider default_tags configuration block present, tags with matching
  # keys will overwrite those defined at the provider-level.
  tags = {
    Name        = "example-integration"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  ################################################################################
  # Lifecycle Configuration
  ################################################################################

  # If using the default AWS owned KMS key, ignore kms_key_id changes
  # lifecycle {
  #   ignore_changes = [
  #     kms_key_id
  #   ]
  # }

  ################################################################################
  # Timeouts
  ################################################################################

  timeouts {
    # (Optional) A string that can be parsed as a duration consisting of numbers and unit suffixes,
    # such as "30s" or "2h45m". Valid time units are "s" (seconds), "m" (minutes), "h" (hours).
    # create = "40m"

    # (Optional) A string that can be parsed as a duration consisting of numbers and unit suffixes,
    # such as "30s" or "2h45m". Valid time units are "s" (seconds), "m" (minutes), "h" (hours).
    # delete = "40m"
  }
}

################################################################################
# Outputs
################################################################################

# ARN of the Integration.
output "rds_integration_arn" {
  description = "ARN of the RDS Integration"
  value       = aws_rds_integration.example.arn
}

# Computed KMS key ID (if using default AWS owned key)
output "rds_integration_kms_key_id" {
  description = "KMS key ID used for the integration"
  value       = aws_rds_integration.example.kms_key_id
}

# Computed data filter
output "rds_integration_data_filter" {
  description = "Data filter applied to the integration"
  value       = aws_rds_integration.example.data_filter
}

# Computed region
output "rds_integration_region" {
  description = "Region where the integration is managed"
  value       = aws_rds_integration.example.region
}

# Map of tags assigned to the resource, including those inherited from the provider
output "rds_integration_tags_all" {
  description = "Map of tags assigned to the resource, including provider default_tags"
  value       = aws_rds_integration.example.tags_all
}

################################################################################
# Example Usage Scenarios
################################################################################

# Example 1: Basic Usage with Redshift Serverless
# resource "aws_redshiftserverless_namespace" "example" {
#   namespace_name = "redshift-example"
# }
#
# resource "aws_redshiftserverless_workgroup" "example" {
#   namespace_name      = aws_redshiftserverless_namespace.example.namespace_name
#   workgroup_name      = "example-workspace"
#   base_capacity       = 8
#   publicly_accessible = false
#
#   subnet_ids = [aws_subnet.example1.id, aws_subnet.example2.id, aws_subnet.example3.id]
#
#   config_parameter {
#     parameter_key   = "enable_case_sensitive_identifier"
#     parameter_value = "true"
#   }
# }
#
# resource "aws_rds_integration" "example" {
#   integration_name = "example"
#   source_arn       = aws_rds_cluster.example.arn
#   target_arn       = aws_redshiftserverless_namespace.example.arn
#
#   lifecycle {
#     ignore_changes = [
#       kms_key_id
#     ]
#   }
# }

# Example 2: Use own KMS key
# data "aws_caller_identity" "current" {}
#
# resource "aws_kms_key" "example" {
#   deletion_window_in_days = 10
#   policy                  = data.aws_iam_policy_document.key_policy.json
# }
#
# data "aws_iam_policy_document" "key_policy" {
#   statement {
#     actions   = ["kms:*"]
#     resources = ["*"]
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
#     }
#   }
#
#   statement {
#     actions   = ["kms:CreateGrant"]
#     resources = ["*"]
#     principals {
#       type        = "Service"
#       identifiers = ["redshift.amazonaws.com"]
#     }
#   }
# }
#
# resource "aws_rds_integration" "example" {
#   integration_name = "example"
#   source_arn       = aws_rds_cluster.example.arn
#   target_arn       = aws_redshiftserverless_namespace.example.arn
#   kms_key_id       = aws_kms_key.example.arn
#
#   additional_encryption_context = {
#     "example" = "test"
#   }
# }

################################################################################
# Notes
################################################################################
# 1. This resource creates a zero-ETL integration between an Aurora database and
#    Amazon Redshift for near real-time analytics.
#
# 2. The integration_name, source_arn, target_arn, additional_encryption_context,
#    data_filter, and kms_key_id are all forces new resource arguments.
#
# 3. If you use the default AWS owned KMS key, you should ignore kms_key_id changes
#    using lifecycle.ignore_changes to avoid unintended updates after first creation.
#
# 4. The id attribute is deprecated; use arn instead.
#
# 5. For more detailed documentation about each argument, refer to the AWS official documentation:
#    https://docs.aws.amazon.com/cli/latest/reference/rds/create-integration.html
#
# 6. Supported source databases include Aurora MySQL and Aurora PostgreSQL.
#
# 7. Supported targets include Amazon Redshift provisioned clusters and Redshift Serverless.
