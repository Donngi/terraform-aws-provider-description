################################################################################
# AWS Lake Formation Resource LF Tag
################################################################################
# Terraform resource for managing an AWS Lake Formation Resource LF Tag.
#
# Lake Formation LF-Tags (Label-based Access Control tags) allow you to attach
# metadata tags to Lake Formation resources like databases, tables, and columns.
# These tags enable fine-grained access control policies based on tag-based
# permissions rather than resource-level permissions.
#
# Common use cases:
# - Implementing attribute-based access control (ABAC) for data lakes
# - Categorizing data by sensitivity level (e.g., public, internal, confidential)
# - Organizing resources by department, project, or environment
# - Simplifying permission management across multiple resources
#
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_resource_lf_tag
# API Reference: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_AddLFTagsToResource.html
################################################################################

resource "aws_lakeformation_resource_lf_tag" "example" {
  # Required: Set of LF-tags to attach to the resource.
  # Each lf_tag block associates an existing LF-tag key-value pair with the resource.
  # The tag key and possible values must be created beforehand using aws_lakeformation_lf_tag.
  lf_tag {
    # (Required) Key name for an existing LF-tag.
    # This must reference a tag key that already exists in Lake Formation.
    # Example: "Environment", "DataClassification", "Department"
    key = aws_lakeformation_lf_tag.example.key

    # (Required) Value from the possible values for the LF-tag.
    # This value must be one of the allowed values defined in the tag's configuration.
    # Example: "Production", "Development", "Confidential", "Public"
    value = "stowe"

    # (Optional) Identifier for the Data Catalog.
    # By default, it is the account ID of the caller.
    # Specify this when working with a shared Data Catalog or cross-account access.
    # catalog_id = "123456789012"
  }

  # Additional LF-tags can be attached to the same resource by adding more lf_tag blocks.
  # Example:
  # lf_tag {
  #   key   = aws_lakeformation_lf_tag.classification.key
  #   value = "Confidential"
  # }

  ################################################################################
  # Resource Type Selection
  ################################################################################
  # Exactly ONE of the following resource types must be specified:
  # - database: For attaching tags to a Glue database
  # - table: For attaching tags to a specific table or all tables in a database
  # - table_with_columns: For attaching tags to specific columns within a table

  # Option 1: Database Resource
  # Attach LF-tags to an entire Glue Catalog database.
  database {
    # (Required) Name of the database resource. Unique to the Data Catalog.
    # This should reference an existing Glue database.
    name = aws_glue_catalog_database.example.name

    # (Optional) Identifier for the Data Catalog.
    # By default, it is the account ID of the caller.
    # Use this when the database exists in a different account or shared catalog.
    # catalog_id = "123456789012"
  }

  # Option 2: Table Resource
  # Attach LF-tags to a specific table or all tables in a database using wildcards.
  # table {
  #   # (Required) Name of the database containing the table.
  #   database_name = aws_glue_catalog_database.example.name
  #
  #   # (Required, at least one of name or wildcard) Name of the specific table.
  #   # Use this for attaching tags to a single table.
  #   name = aws_glue_catalog_table.example.name
  #
  #   # (Required, at least one of name or wildcard) Whether to use a wildcard
  #   # representing every table under a database. Defaults to false.
  #   # Set to true to attach tags to all tables in the database.
  #   # wildcard = true
  #
  #   # (Optional) Identifier for the Data Catalog.
  #   # By default, it is the account ID of the caller.
  #   # catalog_id = "123456789012"
  # }

  # Option 3: Table With Columns Resource
  # Attach LF-tags to specific columns within a table for column-level access control.
  # table_with_columns {
  #   # (Required) Name of the database containing the table.
  #   database_name = aws_glue_catalog_database.example.name
  #
  #   # (Required) Name of the table resource.
  #   name = aws_glue_catalog_table.example.name
  #
  #   # (Required, at least one of column_names or column_wildcard)
  #   # Set of specific column names to tag.
  #   # Example: ["customer_id", "email", "phone_number"]
  #   # column_names = ["column1", "column2", "column3"]
  #
  #   # (Optional) Option to add column wildcard for selecting all columns.
  #   # Use this to tag all columns or all columns except specific ones.
  #   # column_wildcard {
  #   #   # (Optional) Set of column names to exclude from tagging.
  #   #   # If excluded_column_names is included, wildcard must be set to true.
  #   #   # This allows you to tag all columns except sensitive ones.
  #   #   excluded_column_names = ["internal_id", "password_hash"]
  #   # }
  #
  #   # (Optional) Identifier for the Data Catalog.
  #   # By default, it is the account ID of the caller.
  #   # catalog_id = "123456789012"
  # }

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Identifier for the Data Catalog.
  # By default, the account ID of the caller.
  # The Data Catalog is the persistent metadata store containing database
  # definitions, table definitions, and control information for Lake Formation.
  # Specify this when working with shared catalogs or cross-account scenarios.
  # catalog_id = "123456789012"

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Useful for multi-region Lake Formation setups.
  # Note: Not all resource types support the region argument (check documentation).
  # region = "us-west-2"
}

################################################################################
# Example: Multiple Resource Types
################################################################################

# Example 1: Tag a database
resource "aws_lakeformation_resource_lf_tag" "database_tag" {
  database {
    name = aws_glue_catalog_database.sales.name
  }

  lf_tag {
    key   = "Department"
    value = "Sales"
  }

  lf_tag {
    key   = "Environment"
    value = "Production"
  }
}

# Example 2: Tag all tables in a database using wildcard
resource "aws_lakeformation_resource_lf_tag" "all_tables_tag" {
  table {
    database_name = aws_glue_catalog_database.sales.name
    wildcard      = true
  }

  lf_tag {
    key   = "DataClassification"
    value = "Internal"
  }
}

# Example 3: Tag a specific table
resource "aws_lakeformation_resource_lf_tag" "specific_table_tag" {
  table {
    database_name = aws_glue_catalog_database.sales.name
    name          = aws_glue_catalog_table.customers.name
  }

  lf_tag {
    key   = "DataClassification"
    value = "Confidential"
  }
}

# Example 4: Tag specific columns in a table
resource "aws_lakeformation_resource_lf_tag" "column_level_tag" {
  table_with_columns {
    database_name = aws_glue_catalog_database.sales.name
    name          = aws_glue_catalog_table.customers.name
    column_names  = ["ssn", "credit_card", "bank_account"]
  }

  lf_tag {
    key   = "DataClassification"
    value = "HighlySensitive"
  }
}

# Example 5: Tag all columns except specific ones
resource "aws_lakeformation_resource_lf_tag" "column_wildcard_tag" {
  table_with_columns {
    database_name = aws_glue_catalog_database.sales.name
    name          = aws_glue_catalog_table.customers.name

    column_wildcard {
      excluded_column_names = ["internal_id", "created_at", "updated_at"]
    }
  }

  lf_tag {
    key   = "Accessible"
    value = "Analytics"
  }
}

# Example 6: Cross-account or shared catalog tagging
resource "aws_lakeformation_resource_lf_tag" "shared_catalog_tag" {
  catalog_id = "999888777666" # Different AWS account ID

  database {
    name       = "shared_database"
    catalog_id = "999888777666"
  }

  lf_tag {
    key        = "Owner"
    value      = "DataEngineering"
    catalog_id = "999888777666"
  }
}

################################################################################
# Related Resources
################################################################################

# Before using aws_lakeformation_resource_lf_tag, you need to create the LF-tag itself:
# resource "aws_lakeformation_lf_tag" "example" {
#   key    = "Environment"
#   values = ["Development", "Staging", "Production"]
# }

# You also need the Glue resources to tag:
# resource "aws_glue_catalog_database" "example" {
#   name = "my_database"
# }
#
# resource "aws_glue_catalog_table" "example" {
#   name          = "my_table"
#   database_name = aws_glue_catalog_database.example.name
#   # ... other table configuration
# }

################################################################################
# Important Notes
################################################################################
# 1. LF-tags must be created (aws_lakeformation_lf_tag) before they can be attached
# 2. The specified tag value must be one of the allowed values in the tag definition
# 3. Only one resource type (database, table, or table_with_columns) can be used per resource
# 4. For table_with_columns, either column_names or column_wildcard must be specified
# 5. When using excluded_column_names in column_wildcard, you must set wildcard = true
# 6. Tag-based permissions (LF-Tag expressions) must be configured separately using
#    aws_lakeformation_permissions with lf_tag_policy
# 7. The caller must have appropriate Lake Formation permissions to attach tags
# 8. Changes to tags may affect existing access patterns if using tag-based permissions

################################################################################
# Best Practices
################################################################################
# 1. Plan your tagging strategy before implementation:
#    - Define consistent tag keys (e.g., Environment, DataClassification, Department)
#    - Establish allowed values for each tag key
#    - Document the meaning and usage of each tag
#
# 2. Use hierarchical tagging:
#    - Start with broader tags on databases
#    - Add more specific tags on tables
#    - Use column-level tags only for sensitive data
#
# 3. Combine with Lake Formation permissions:
#    - Use aws_lakeformation_permissions with lf_tag_policy
#    - Create reusable permission templates based on tags
#    - Test access before deploying to production
#
# 4. Monitor and audit:
#    - Track who applies tags using CloudTrail
#    - Regularly review tag assignments
#    - Ensure tags align with data governance policies
#
# 5. For sensitive columns:
#    - Use table_with_columns to tag PII or regulated data
#    - Combine with row-level security and cell-level filtering
#    - Document why specific columns are tagged
