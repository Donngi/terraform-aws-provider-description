################################################################################
# AWS S3 Tables Table Bucket Policy
# Terraform resource for managing an Amazon S3 Tables Table Bucket Policy
# Provider Version: 6.28.0
################################################################################

# S3 Tables Table Bucket Policies are resource-based policies that control access
# to table buckets, namespaces, and tables within Amazon S3 Tables. They allow
# you to grant permissions at the table bucket, namespace, or table level and
# can apply to all tables in the bucket or specific tables.
#
# Key Security Features:
# - Table bucket policies control API access permissions at multiple levels
# - Can be combined with IAM identity-based policies for comprehensive access control
# - S3 Tables evaluates all relevant policies to authorize requests
# - Supports AWS global condition context keys and S3 Tables-specific condition keys
#
# Policy Evaluation:
# When S3 Tables receives a request, it verifies permissions by evaluating:
# - IAM user policies
# - IAM role policies
# - Table bucket policies
# - Table policies
#
# Best Practices:
# - Use table bucket policies for governing access to bucket-level actions
# - Use table policies for governing access to table-level actions
# - Include GetTableMetadataLocation permissions for policies that modify tables
# - Include UpdateTableMetadataLocation permissions for write/delete activities
# - For the same permissions across multiple tables, use a table bucket policy
#
# AWS Documentation:
# - Resource-based policies: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-resource-based-policies.html
# - Managing bucket policies: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-bucket-policy.html
# - Security overview: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-security-overview.html

resource "aws_s3tables_table_bucket_policy" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # table_bucket_arn - ARN referencing the Table Bucket that owns this policy
  # Type: string (Forces new resource)
  #
  # The Amazon Resource Name (ARN) of the S3 Tables table bucket to which this
  # policy will be attached. Table bucket policies grant access to the tables
  # stored in the bucket and do not apply to tables owned by other accounts.
  #
  # ARN Format: arn:aws:s3tables:region:account-id:bucket/table-bucket-name
  #
  # Important Notes:
  # - Changing this value forces recreation of the resource
  # - The table bucket must exist before applying the policy
  # - Each table bucket can have only one bucket policy
  #
  # Example Values:
  # - "arn:aws:s3tables:us-east-1:123456789012:bucket/my-table-bucket"
  # - "arn:aws:s3tables:eu-west-1:123456789012:bucket/analytics-tables"
  table_bucket_arn = aws_s3tables_table_bucket.example.arn

  # resource_policy - Amazon Web Services resource-based policy document in JSON format
  # Type: string (Required)
  #
  # The JSON-formatted policy document that defines permissions for the table bucket.
  # This policy controls access to table bucket-level, namespace-level, and table-level
  # API operations.
  #
  # Policy Structure:
  # - Version: Policy language version (typically "2012-10-17")
  # - Statement: Array of policy statements
  #   - Effect: "Allow" or "Deny"
  #   - Principal: AWS principal (user, role, account, service)
  #   - Action: S3 Tables API actions (e.g., s3tables:GetTable, s3tables:PutTableData)
  #   - Resource: ARN of the table bucket, namespace, or table
  #   - Condition (optional): Additional conditions for the policy
  #
  # Common S3 Tables Actions:
  # Bucket-level:
  # - s3tables:GetTableBucket
  # - s3tables:PutBucketMaintenanceConfiguration
  # - s3tables:GetBucketMaintenanceConfiguration
  #
  # Namespace-level:
  # - s3tables:CreateNamespace
  # - s3tables:GetNamespace
  # - s3tables:ListNamespaces
  # - s3tables:DeleteNamespace
  #
  # Table-level:
  # - s3tables:CreateTable
  # - s3tables:GetTable
  # - s3tables:ListTables
  # - s3tables:DeleteTable
  # - s3tables:GetTableMetadataLocation
  # - s3tables:UpdateTableMetadataLocation
  # - s3tables:PutTableData
  # - s3tables:GetTableData
  #
  # S3 Tables Condition Keys:
  # - s3tables:tableName - Filter by table name
  # - s3tables:namespace - Filter by namespace
  # - s3tables:SSEAlgorithm - Restrict encryption algorithm
  # - s3tables:KMSKeyArn - Restrict KMS key ARN
  #
  # Best Practice: Use data sources like aws_iam_policy_document to generate
  # policy JSON for better readability and validation
  #
  # Important Notes:
  # - Every policy that modifies tables should include GetTableMetadataLocation
  # - Write/delete operations should include UpdateTableMetadataLocation
  # - Changes to table names, namespaces, or encryption keys can impact policies
  #   using corresponding condition keys
  #
  # Example Policy Scenarios:
  # 1. Allow role to delete unreferenced objects:
  #    Action: s3tables:PutBucketMaintenanceConfiguration
  # 2. Allow user to access tables in specific namespace:
  #    Resource: arn:aws:s3tables:region:account:bucket/name/namespace/hr/*
  # 3. Allow role to delete specific table:
  #    Action: s3tables:DeleteTable
  #    Resource: arn:aws:s3tables:region:account:bucket/name/table/uuid
  resource_policy = data.aws_iam_policy_document.example.json

  ################################################################################
  # Optional Arguments
  ################################################################################

  # region - Region where this resource will be managed
  # Type: string (Optional)
  # Default: Provider region configuration
  #
  # The AWS region where this table bucket policy will be managed. If not specified,
  # it defaults to the region set in the provider configuration.
  #
  # Important Notes:
  # - S3 Tables are regional resources
  # - Each AWS account has one AWS managed table bucket per region
  # - Table buckets and their policies must be in the same region
  #
  # Example Values:
  # - "us-east-1"
  # - "eu-west-1"
  # - "ap-northeast-1"
  # region = "us-east-1"
}

################################################################################
# Example: Basic Table Bucket Policy
################################################################################

# Create a table bucket policy that grants comprehensive permissions to a specific role

resource "aws_s3tables_table_bucket" "example" {
  name = "example-table-bucket"
}

data "aws_iam_policy_document" "example" {
  # Allow the data steward role to manage table metadata
  statement {
    sid    = "AllowDataStewardTableMetadataAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:role/datasteward"]
    }

    actions = [
      "s3tables:GetTableMetadataLocation",
      "s3tables:UpdateTableMetadataLocation",
    ]

    resources = [
      "${aws_s3tables_table_bucket.example.arn}/*",
    ]
  }

  # Allow the data steward role to manage maintenance configuration
  statement {
    sid    = "AllowDataStewardMaintenanceConfig"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:role/datasteward"]
    }

    actions = [
      "s3tables:PutBucketMaintenanceConfiguration",
      "s3tables:GetBucketMaintenanceConfiguration",
    ]

    resources = [
      aws_s3tables_table_bucket.example.arn,
    ]
  }
}

################################################################################
# Example: Namespace-Specific Access Policy
################################################################################

# Create a table bucket policy that grants access to tables in a specific namespace

data "aws_iam_policy_document" "namespace_specific" {
  # Allow user Jane to access tables in the HR namespace
  statement {
    sid    = "AllowJaneHRNamespaceAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:user/Jane"]
    }

    actions = [
      "s3tables:GetTable",
      "s3tables:ListTables",
      "s3tables:GetTableData",
      "s3tables:GetTableMetadataLocation",
    ]

    resources = [
      "${aws_s3tables_table_bucket.example.arn}/namespace/hr/*",
    ]
  }

  # Conditionally allow access based on namespace
  statement {
    sid    = "ConditionalNamespaceAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:role/analytics-team"]
    }

    actions = [
      "s3tables:GetTable",
      "s3tables:ListTables",
      "s3tables:GetTableData",
    ]

    resources = [
      "${aws_s3tables_table_bucket.example.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3tables:namespace"
      values   = ["analytics", "reporting"]
    }
  }
}

################################################################################
# Example: Write and Delete Permissions Policy
################################################################################

# Create a table bucket policy that includes proper permissions for write/delete operations

data "aws_iam_policy_document" "write_delete_permissions" {
  # Allow role to perform write and delete operations on tables
  statement {
    sid    = "AllowWriteDeleteOperations"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:role/data-engineer"]
    }

    actions = [
      # Required for all table modifications
      "s3tables:GetTableMetadataLocation",
      # Required for write/delete activities
      "s3tables:UpdateTableMetadataLocation",
      # Table management actions
      "s3tables:CreateTable",
      "s3tables:DeleteTable",
      "s3tables:PutTableData",
      "s3tables:GetTable",
    ]

    resources = [
      "${aws_s3tables_table_bucket.example.arn}/*",
    ]
  }
}

################################################################################
# Example: Encryption-Based Access Control
################################################################################

# Create a table bucket policy with encryption-specific conditions

data "aws_iam_policy_document" "encryption_based" {
  # Require specific encryption algorithm
  statement {
    sid    = "RequireSSEKMS"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:role/secure-data-role"]
    }

    actions = [
      "s3tables:CreateTable",
      "s3tables:PutTableData",
    ]

    resources = [
      "${aws_s3tables_table_bucket.example.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3tables:SSEAlgorithm"
      values   = ["aws:kms"]
    }
  }

  # Require specific KMS key
  statement {
    sid    = "RequireSpecificKMSKey"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:role/compliance-role"]
    }

    actions = [
      "s3tables:CreateTable",
      "s3tables:PutTableData",
    ]

    resources = [
      "${aws_s3tables_table_bucket.example.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3tables:KMSKeyArn"
      values   = ["arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"]
    }
  }
}

################################################################################
# Example: Cross-Account Access Policy
################################################################################

# Create a table bucket policy that grants access to another AWS account

data "aws_iam_policy_document" "cross_account" {
  # Allow another AWS account to read tables
  statement {
    sid    = "AllowCrossAccountRead"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::987654321098:root"]
    }

    actions = [
      "s3tables:GetTable",
      "s3tables:ListTables",
      "s3tables:GetTableData",
      "s3tables:GetTableMetadataLocation",
    ]

    resources = [
      "${aws_s3tables_table_bucket.example.arn}/*",
    ]
  }
}

################################################################################
# Important Considerations
################################################################################

# 1. Policy Scope:
#    - Table bucket policies do not apply to tables owned by other accounts
#    - Policies can target bucket-level, namespace-level, or table-level resources
#    - Use the appropriate resource ARN pattern for the desired scope
#
# 2. Permission Requirements:
#    - GetTableMetadataLocation: Required for any policy that modifies tables
#    - UpdateTableMetadataLocation: Required for write/delete operations
#    - These permissions ensure proper metadata management
#
# 3. Policy Strategy:
#    - Use table bucket policies for permissions across multiple tables
#    - Use table policies for permissions on individual tables
#    - Combine with IAM identity-based policies for comprehensive access control
#
# 4. Condition Keys:
#    - Changes to table names, namespaces, encryption, or KMS keys can impact policies
#    - Review policies when making configuration changes
#    - Test policies thoroughly before applying in production
#
# 5. AWS Managed Table Buckets:
#    - Each AWS account has one AWS managed table bucket per region
#    - AWS managed table buckets are read-only and managed by AWS services
#    - Customer-managed table buckets allow full control and custom policies
#
# 6. Encryption:
#    - Default encryption: SSE-S3 (Amazon S3 managed keys)
#    - Optional: SSE-KMS (AWS KMS keys) for enhanced security
#    - Use condition keys to enforce encryption requirements
#
# 7. Regional Considerations:
#    - S3 Tables are regional resources
#    - Table buckets and policies must be in the same region
#    - Plan multi-region deployments carefully
#
# 8. Integration with Lake Formation:
#    - AWS Lake Formation can be used for fine-grained access control
#    - Combine Lake Formation with table bucket policies for comprehensive governance
#    - Consider Lake Formation for data lake use cases
#
# 9. Policy Updates:
#    - Policy changes take effect immediately
#    - Test changes in non-production environments first
#    - Monitor CloudTrail logs for policy-related API calls
#
# 10. Troubleshooting:
#     - Use CloudTrail to audit access attempts
#     - Check both identity-based and resource-based policies
#     - Verify principal ARNs are correct and active
#     - Ensure actions match the intended operations

################################################################################
# Additional Resources
################################################################################

# AWS Documentation:
# - S3 Tables Security Overview: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-security-overview.html
# - Resource-based Policies: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-resource-based-policies.html
# - Managing Table Bucket Policies: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-bucket-policy.html
# - Access Management: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-setting-up.html
# - AWS Managed Table Buckets: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-tables-aws-managed-buckets.html
#
# Terraform Documentation:
# - aws_s3tables_table_bucket_policy: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3tables_table_bucket_policy
# - aws_s3tables_table_bucket: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3tables_table_bucket
# - aws_iam_policy_document: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
