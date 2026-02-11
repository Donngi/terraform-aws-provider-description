# ================================================================================
# AWS S3 Tables Table Policy - Terraform Configuration Template
# ================================================================================
# Purpose:
#   Manages a resource-based policy for an Amazon S3 Tables table, controlling
#   table-level API access permissions for individual tables within a table bucket.
#
# Provider Version: 6.28.0
# Resource: aws_s3tables_table_policy
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3tables_table_policy
#
# Key Features:
#   - Grant table-level access permissions using IAM policy language
#   - Control access to specific tables within a table bucket
#   - Support for cross-account access to S3 Tables
#   - Integration with aws_iam_policy_document data source
#
# Common Use Cases:
#   - Grant IAM roles permission to read or write table data
#   - Allow cross-account access to specific tables
#   - Provide data stewards with table management permissions
#   - Implement attribute-based access control (ABAC) using table tags
#   - Grant table deletion permissions to specific roles
#   - Enable table metadata access for analytics workloads
#
# Important Notes:
#   - Table policies apply at the individual table level
#   - For bucket-wide permissions, use aws_s3tables_table_bucket_policy
#   - Policies granting table modification must include GetTableMetadataLocation
#   - Write/delete operations require UpdateTableMetadataLocation permission
#   - S3 Tables evaluates all relevant access policies (user, role, bucket, table)
#   - Table names must be 1-255 chars: lowercase letters, numbers, underscores
#
# Related Resources:
#   - aws_s3tables_table: Create the S3 Tables table
#   - aws_s3tables_namespace: Create the namespace for tables
#   - aws_s3tables_table_bucket: Create the table bucket
#   - aws_s3tables_table_bucket_policy: Manage bucket-level policies
#   - aws_iam_policy_document: Generate IAM policy JSON
#
# Best Practices:
#   - Use table bucket policies for bucket-level actions
#   - Use table policies for table-specific access control
#   - Include GetTableMetadataLocation for any table modification permissions
#   - Include UpdateTableMetadataLocation for write/delete operations
#   - Apply least privilege principle when granting permissions
#   - Use aws_iam_policy_document for maintainable policy definitions
#   - Consider table bucket policies when same permissions apply to multiple tables
# ================================================================================

# Example Table Bucket Resource (dependency)
resource "aws_s3tables_table_bucket" "example" {
  name = "example-table-bucket"

  tags = {
    Name        = "Example Table Bucket"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# Example Namespace Resource (dependency)
resource "aws_s3tables_namespace" "example" {
  namespace        = ["example-namespace"]
  table_bucket_arn = aws_s3tables_table_bucket.example.arn

  tags = {
    Name        = "Example Namespace"
    Environment = "Development"
  }
}

# Example Table Resource (dependency)
resource "aws_s3tables_table" "example" {
  name             = "example_table"
  namespace        = aws_s3tables_namespace.example.namespace[0]
  table_bucket_arn = aws_s3tables_table_bucket.example.arn
  format           = "ICEBERG"

  tags = {
    Name        = "Example Table"
    Environment = "Development"
    DataOwner   = "Analytics Team"
  }
}

# Example IAM Policy Document for Table Policy
data "aws_iam_policy_document" "table_access" {
  # Statement 1: Allow data steward role to delete table
  statement {
    sid    = "AllowDataStewardTableDeletion"
    effect = "Allow"

    # Define who can perform the actions
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::123456789012:role/datasteward" # Replace with actual role ARN
      ]
    }

    # Actions required for table deletion
    actions = [
      "s3tables:DeleteTable",                # Delete the table
      "s3tables:GetTableMetadataLocation",   # Required for any table modification
      "s3tables:UpdateTableMetadataLocation" # Required for delete operations
    ]

    # Define which resources the actions apply to
    resources = [
      aws_s3tables_table.example.arn
    ]
  }

  # Statement 2: Allow analytics role to read and write table data
  statement {
    sid    = "AllowAnalyticsReadWrite"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::123456789012:role/analytics" # Replace with actual role ARN
      ]
    }

    # Actions for reading and writing table data
    actions = [
      "s3tables:GetTableData",               # Read table data
      "s3tables:PutTableData",               # Write table data
      "s3tables:GetTableMetadataLocation",   # Required for table access
      "s3tables:UpdateTableMetadataLocation" # Required for write operations
    ]

    resources = [
      aws_s3tables_table.example.arn
    ]
  }

  # Statement 3: Example - Tag-based access control (ABAC)
  # Uncomment to allow access only when user's department tag matches table's tag
  # statement {
  #   sid    = "AllowDepartmentBasedAccess"
  #   effect = "Allow"
  #
  #   principals {
  #     type        = "AWS"
  #     identifiers = ["*"]
  #   }
  #
  #   actions = [
  #     "s3tables:GetTableData",
  #     "s3tables:GetTableMetadataLocation",
  #   ]
  #
  #   resources = [
  #     aws_s3tables_table.example.arn
  #   ]
  #
  #   condition {
  #     test     = "StringEquals"
  #     variable = "s3tables:ResourceTag/Department"
  #     values   = ["${aws:PrincipalTag/Department}"]
  #   }
  # }
}

# ================================================================================
# Main Resource: AWS S3 Tables Table Policy
# ================================================================================

resource "aws_s3tables_table_policy" "example" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Required Arguments
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # resource_policy - (Required) Amazon Web Services resource-based policy document in JSON format
  # Type: string (JSON)
  # The policy document defines who can access the table and what actions they can perform.
  # Use aws_iam_policy_document data source to generate the policy JSON.
  #
  # Policy Structure:
  # - Version: IAM policy language version (usually "2012-10-17")
  # - Statement: Array of policy statements with Effect, Principal, Action, Resource
  # - Condition: Optional conditions for when the policy applies
  #
  # Common Actions for S3 Tables:
  # - s3tables:GetTableData: Read data from the table
  # - s3tables:PutTableData: Write data to the table
  # - s3tables:DeleteTable: Delete the table
  # - s3tables:GetTableMetadataLocation: Access table root file (required for modifications)
  # - s3tables:UpdateTableMetadataLocation: Update table metadata (required for writes/deletes)
  # - s3tables:GetTableMaintenanceConfiguration: Get maintenance settings
  # - s3tables:PutTableMaintenanceConfiguration: Update maintenance settings
  #
  # Principal Types:
  # - AWS: AWS account ID or IAM role/user ARN
  # - Service: AWS service (e.g., "s3tables.amazonaws.com")
  # - Federated: Web identity or SAML provider
  # - "*": All users (use with caution)
  resource_policy = data.aws_iam_policy_document.table_access.json

  # name - (Required, Forces new resource) Name of the table
  # Type: string
  # Must be between 1 and 255 characters in length.
  # Can consist of lowercase letters, numbers, and underscores.
  # Must begin and end with a lowercase letter or number.
  # Examples: "sales_data", "user_events_2024", "inventory_snapshot"
  name = aws_s3tables_table.example.name

  # namespace - (Required, Forces new resource) Name of the namespace for this table
  # Type: string
  # Must be between 1 and 255 characters in length.
  # Can consist of lowercase letters, numbers, and underscores.
  # Must begin and end with a lowercase letter or number.
  # The namespace organizes tables within a table bucket.
  # Examples: "production", "analytics", "data_warehouse"
  namespace = aws_s3tables_table.example.namespace

  # table_bucket_arn - (Required, Forces new resource) ARN referencing the Table Bucket that contains this Namespace
  # Type: string (ARN)
  # Format: arn:aws:s3tables:region:account-id:bucket/bucket-name
  # The table bucket is the top-level container for namespaces and tables.
  # This value is immutable - changing it forces a new resource to be created.
  table_bucket_arn = aws_s3tables_table.example.table_bucket_arn

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Optional Arguments
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # region - (Optional) Region where this resource will be managed
  # Type: string (computed)
  # Defaults to the Region set in the provider configuration.
  # Useful for managing resources in specific regions or for multi-region deployments.
  # Example: "us-east-1", "eu-west-1", "ap-northeast-1"
  # region = "us-east-1"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Resource Dependencies
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # Implicit dependencies:
  # - aws_s3tables_table.example: Must exist before policy can be attached
  # - aws_s3tables_namespace.example: Must exist as parent of the table
  # - aws_s3tables_table_bucket.example: Must exist as parent of the namespace
  # - data.aws_iam_policy_document.table_access: Must be evaluated before policy creation
}

# ================================================================================
# Additional Examples
# ================================================================================

# Example 1: Cross-Account Table Access Policy
# Uncomment to allow another AWS account to read table data
#
# data "aws_iam_policy_document" "cross_account_read" {
#   statement {
#     sid    = "AllowCrossAccountRead"
#     effect = "Allow"
#
#     principals {
#       type = "AWS"
#       identifiers = [
#         "arn:aws:iam::987654321098:root" # Replace with trusted account ID
#       ]
#     }
#
#     actions = [
#       "s3tables:GetTableData",
#       "s3tables:GetTableMetadataLocation",
#     ]
#
#     resources = [
#       aws_s3tables_table.example.arn
#     ]
#   }
# }
#
# resource "aws_s3tables_table_policy" "cross_account" {
#   resource_policy  = data.aws_iam_policy_document.cross_account_read.json
#   name             = aws_s3tables_table.example.name
#   namespace        = aws_s3tables_table.example.namespace
#   table_bucket_arn = aws_s3tables_table.example.table_bucket_arn
# }

# Example 2: Read-Only Access Policy
# Grant read-only access to a specific IAM role
#
# data "aws_iam_policy_document" "read_only" {
#   statement {
#     sid    = "AllowReadOnlyAccess"
#     effect = "Allow"
#
#     principals {
#       type = "AWS"
#       identifiers = [
#         "arn:aws:iam::123456789012:role/readonly-role"
#       ]
#     }
#
#     actions = [
#       "s3tables:GetTableData",
#       "s3tables:GetTableMetadataLocation",
#       "s3tables:GetTableMaintenanceConfiguration",
#     ]
#
#     resources = [
#       aws_s3tables_table.example.arn
#     ]
#   }
# }
#
# resource "aws_s3tables_table_policy" "read_only" {
#   resource_policy  = data.aws_iam_policy_document.read_only.json
#   name             = aws_s3tables_table.example.name
#   namespace        = aws_s3tables_table.example.namespace
#   table_bucket_arn = aws_s3tables_table.example.table_bucket_arn
# }

# Example 3: Full Table Management Policy
# Grant complete control over the table to administrators
#
# data "aws_iam_policy_document" "admin_access" {
#   statement {
#     sid    = "AllowFullTableManagement"
#     effect = "Allow"
#
#     principals {
#       type = "AWS"
#       identifiers = [
#         "arn:aws:iam::123456789012:role/table-admin"
#       ]
#     }
#
#     actions = [
#       "s3tables:GetTableData",
#       "s3tables:PutTableData",
#       "s3tables:DeleteTable",
#       "s3tables:GetTableMetadataLocation",
#       "s3tables:UpdateTableMetadataLocation",
#       "s3tables:GetTableMaintenanceConfiguration",
#       "s3tables:PutTableMaintenanceConfiguration",
#     ]
#
#     resources = [
#       aws_s3tables_table.example.arn
#     ]
#   }
# }
#
# resource "aws_s3tables_table_policy" "admin" {
#   resource_policy  = data.aws_iam_policy_document.admin_access.json
#   name             = aws_s3tables_table.example.name
#   namespace        = aws_s3tables_table.example.namespace
#   table_bucket_arn = aws_s3tables_table.example.table_bucket_arn
# }

# Example 4: Time-Based Access Policy
# Restrict access to specific time periods
#
# data "aws_iam_policy_document" "time_based_access" {
#   statement {
#     sid    = "AllowAccessDuringBusinessHours"
#     effect = "Allow"
#
#     principals {
#       type = "AWS"
#       identifiers = [
#         "arn:aws:iam::123456789012:role/business-hours-role"
#       ]
#     }
#
#     actions = [
#       "s3tables:GetTableData",
#       "s3tables:GetTableMetadataLocation",
#     ]
#
#     resources = [
#       aws_s3tables_table.example.arn
#     ]
#
#     condition {
#       test     = "DateGreaterThan"
#       variable = "aws:CurrentTime"
#       values   = ["2024-01-01T09:00:00Z"]
#     }
#
#     condition {
#       test     = "DateLessThan"
#       variable = "aws:CurrentTime"
#       values   = ["2024-12-31T17:00:00Z"]
#     }
#   }
# }
#
# resource "aws_s3tables_table_policy" "time_based" {
#   resource_policy  = data.aws_iam_policy_document.time_based_access.json
#   name             = aws_s3tables_table.example.name
#   namespace        = aws_s3tables_table.example.namespace
#   table_bucket_arn = aws_s3tables_table.example.table_bucket_arn
# }

# Example 5: Conditional Access Based on Source IP
# Restrict access to requests from specific IP addresses
#
# data "aws_iam_policy_document" "ip_restricted" {
#   statement {
#     sid    = "AllowFromSpecificIP"
#     effect = "Allow"
#
#     principals {
#       type = "AWS"
#       identifiers = [
#         "arn:aws:iam::123456789012:role/ip-restricted-role"
#       ]
#     }
#
#     actions = [
#       "s3tables:GetTableData",
#       "s3tables:PutTableData",
#       "s3tables:GetTableMetadataLocation",
#       "s3tables:UpdateTableMetadataLocation",
#     ]
#
#     resources = [
#       aws_s3tables_table.example.arn
#     ]
#
#     condition {
#       test     = "IpAddress"
#       variable = "aws:SourceIp"
#       values = [
#         "192.0.2.0/24",   # Replace with your IP range
#         "203.0.113.0/24", # Replace with your IP range
#       ]
#     }
#   }
# }
#
# resource "aws_s3tables_table_policy" "ip_restricted" {
#   resource_policy  = data.aws_iam_policy_document.ip_restricted.json
#   name             = aws_s3tables_table.example.name
#   namespace        = aws_s3tables_table.example.namespace
#   table_bucket_arn = aws_s3tables_table.example.table_bucket_arn
# }

# ================================================================================
# Outputs
# ================================================================================

output "table_policy_id" {
  description = "The identifier of the table policy (format: table_bucket_arn,namespace,name)"
  value       = aws_s3tables_table_policy.example.id
}

output "table_name" {
  description = "The name of the table with the attached policy"
  value       = aws_s3tables_table_policy.example.name
}

output "table_namespace" {
  description = "The namespace of the table"
  value       = aws_s3tables_table_policy.example.namespace
}

output "table_bucket_arn" {
  description = "The ARN of the table bucket"
  value       = aws_s3tables_table_policy.example.table_bucket_arn
}

output "table_arn" {
  description = "The ARN of the table"
  value       = aws_s3tables_table.example.arn
}

# ================================================================================
# Attributes Reference
# ================================================================================
# In addition to the arguments above, the following attributes are exported:
#
# - id: The identifier of the table policy (composed of table_bucket_arn, namespace, and name)
# - resource_policy: The resource-based policy document (as applied)
# - name: The name of the table
# - namespace: The namespace of the table
# - table_bucket_arn: The ARN of the table bucket
# - region: The region where the table policy is managed
#
# ================================================================================
# Import
# ================================================================================
# S3 Tables table policies can be imported using the format:
# table_bucket_arn,namespace,name
#
# Example:
# terraform import aws_s3tables_table_policy.example \
#   arn:aws:s3tables:us-east-1:123456789012:bucket/example-table-bucket,example-namespace,example_table
#
# ================================================================================
