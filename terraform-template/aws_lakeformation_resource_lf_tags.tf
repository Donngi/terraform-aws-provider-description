# ==============================================================================
# AWS Lake Formation Resource LF-Tags
# ==============================================================================
# Manages an attachment between one or more existing LF-tags and an existing
# Lake Formation resource. This allows you to apply tag-based access control to
# databases, tables, or table columns.
#
# Provider Version: 6.28.0
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_resource_lf_tags
# ==============================================================================

resource "aws_lakeformation_resource_lf_tags" "example" {
  # ----------------------------------------------------------------------------
  # LF-Tag Configuration (Required)
  # ----------------------------------------------------------------------------
  # Set of LF-tags to attach to the resource. At least one lf_tag block is required.
  # Each block specifies a key-value pair that must reference an existing LF-tag.

  lf_tag {
    # key - (Required) Key name for an existing LF-tag
    # Must reference an LF-tag that has been previously created
    key = "right"

    # value - (Required) Value from the possible values for the LF-tag
    # Must be one of the allowed values defined for the specified LF-tag key
    value = "stowe"

    # catalog_id - (Optional) Identifier for the Data Catalog
    # Default: Account ID of the caller
    # catalog_id = "123456789012"
  }

  # You can attach multiple LF-tags to the same resource
  # lf_tag {
  #   key   = "left"
  #   value = "aintree"
  # }

  # ----------------------------------------------------------------------------
  # Resource Configuration (One Required)
  # ----------------------------------------------------------------------------
  # Exactly ONE of the following resource types must be specified:
  # - database
  # - table
  # - table_with_columns

  # Option 1: Database Resource
  # Attaches LF-tags to an entire database
  database {
    # name - (Required) Name of the database resource
    # Must be unique to the Data Catalog
    name = "example_database"

    # catalog_id - (Optional) Identifier for the Data Catalog
    # Default: Account ID of the caller
    # catalog_id = "123456789012"
  }

  # Option 2: Table Resource
  # Attaches LF-tags to a table or all tables in a database using wildcard
  # table {
  #   # database_name - (Required) Name of the database for the table
  #   # Must be unique to a Data Catalog
  #   database_name = "example_database"
  #
  #   # name - (Required, at least one of name or wildcard)
  #   # Name of the specific table
  #   name = "example_table"
  #
  #   # wildcard - (Required, at least one of name or wildcard)
  #   # Whether to use a wildcard representing every table under a database
  #   # Default: false
  #   # wildcard = false
  #
  #   # catalog_id - (Optional) Identifier for the Data Catalog
  #   # Default: Account ID of the caller
  #   # catalog_id = "123456789012"
  #
  #   # region - (Optional) Region where this resource will be managed
  #   # Default: Region set in the provider configuration
  #   # region = "us-east-1"
  # }

  # Option 3: Table with Columns Resource
  # Attaches LF-tags to specific columns or all columns in a table
  # table_with_columns {
  #   # database_name - (Required) Name of the database for the table
  #   # Must be unique to the Data Catalog
  #   database_name = "example_database"
  #
  #   # name - (Required) Name of the table resource
  #   name = "example_table"
  #
  #   # column_names - (Required, at least one of column_names or wildcard)
  #   # Set of column names for the table
  #   # column_names = ["column1", "column2", "column3"]
  #
  #   # wildcard - (Required, at least one of column_names or wildcard)
  #   # Whether to use a column wildcard
  #   # If excluded_column_names is included, wildcard must be set to true
  #   # wildcard = false
  #
  #   # excluded_column_names - (Optional) Set of column names to exclude
  #   # If excluded_column_names is included, wildcard must be set to true
  #   # excluded_column_names = ["sensitive_column"]
  #
  #   # catalog_id - (Optional) Identifier for the Data Catalog
  #   # Default: Account ID of the caller
  #   # catalog_id = "123456789012"
  #
  #   # region - (Optional) Region where this resource will be managed
  #   # Default: Region set in the provider configuration
  #   # region = "us-east-1"
  # }

  # ----------------------------------------------------------------------------
  # Optional Configuration
  # ----------------------------------------------------------------------------

  # catalog_id - (Optional) Identifier for the Data Catalog
  # The persistent metadata store containing database and table definitions
  # Default: Account ID of the caller
  # catalog_id = "123456789012"

  # region - (Optional) Region where this resource will be managed
  # Default: Region set in the provider configuration
  # Documentation: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ----------------------------------------------------------------------------
  # Timeouts Configuration
  # ----------------------------------------------------------------------------
  # Optional timeouts for resource operations

  # timeouts {
  #   # create - (Optional) Maximum time to wait for resource creation
  #   # Default: Not specified (uses provider default)
  #   create = "5m"
  #
  #   # delete - (Optional) Maximum time to wait for resource deletion
  #   # Default: Not specified (uses provider default)
  #   delete = "5m"
  # }
}

# ==============================================================================
# Example: Database with Single LF-Tag
# ==============================================================================

# resource "aws_lakeformation_lf_tag" "example" {
#   key    = "right"
#   values = ["abbey", "village", "luffield", "woodcote", "copse", "chapel", "stowe", "club"]
# }
#
# resource "aws_glue_catalog_database" "example" {
#   name = "example_database"
# }
#
# resource "aws_lakeformation_resource_lf_tags" "example" {
#   database {
#     name = aws_glue_catalog_database.example.name
#   }
#
#   lf_tag {
#     key   = aws_lakeformation_lf_tag.example.key
#     value = "stowe"
#   }
# }

# ==============================================================================
# Example: Database with Multiple LF-Tags
# ==============================================================================

# resource "aws_lakeformation_lf_tag" "right" {
#   key    = "right"
#   values = ["abbey", "village", "luffield", "woodcote", "copse", "chapel", "stowe", "club"]
# }
#
# resource "aws_lakeformation_lf_tag" "left" {
#   key    = "left"
#   values = ["farm", "theloop", "aintree", "brooklands", "maggotts", "becketts", "vale"]
# }
#
# resource "aws_glue_catalog_database" "example" {
#   name = "example_database"
# }
#
# resource "aws_lakeformation_resource_lf_tags" "example" {
#   database {
#     name = aws_glue_catalog_database.example.name
#   }
#
#   lf_tag {
#     key   = "right"
#     value = "luffield"
#   }
#
#   lf_tag {
#     key   = "left"
#     value = "aintree"
#   }
# }

# ==============================================================================
# Example: Table with Wildcard
# ==============================================================================

# resource "aws_lakeformation_lf_tag" "example" {
#   key    = "environment"
#   values = ["dev", "staging", "prod"]
# }
#
# resource "aws_lakeformation_resource_lf_tags" "all_tables" {
#   table {
#     database_name = "example_database"
#     wildcard      = true
#   }
#
#   lf_tag {
#     key   = "environment"
#     value = "prod"
#   }
# }

# ==============================================================================
# Example: Table with Columns (Specific Columns)
# ==============================================================================

# resource "aws_lakeformation_lf_tag" "sensitive" {
#   key    = "data_classification"
#   values = ["public", "internal", "confidential", "restricted"]
# }
#
# resource "aws_lakeformation_resource_lf_tags" "sensitive_columns" {
#   table_with_columns {
#     database_name = "example_database"
#     name          = "customer_table"
#     column_names  = ["ssn", "credit_card", "email"]
#   }
#
#   lf_tag {
#     key   = "data_classification"
#     value = "restricted"
#   }
# }

# ==============================================================================
# Example: Table with Columns (Wildcard with Exclusions)
# ==============================================================================

# resource "aws_lakeformation_lf_tag" "example" {
#   key    = "data_classification"
#   values = ["public", "internal", "confidential"]
# }
#
# resource "aws_lakeformation_resource_lf_tags" "most_columns" {
#   table_with_columns {
#     database_name        = "example_database"
#     name                 = "user_table"
#     wildcard             = true
#     excluded_column_names = ["password_hash", "api_key"]
#   }
#
#   lf_tag {
#     key   = "data_classification"
#     value = "internal"
#   }
# }

# ==============================================================================
# Computed Attributes
# ==============================================================================
# The following attributes are exported:
#
# - id - Identifier of the resource, format varies based on resource type:
#        - Database: catalog_id:database_name
#        - Table: catalog_id:database_name:table_name
#        - Table with Columns: catalog_id:database_name:table_name:column_names
#
# - catalog_id - Identifier for the Data Catalog (computed if not specified)

# ==============================================================================
# Important Notes
# ==============================================================================
# 1. LF-Tag Prerequisites:
#    - LF-tags must be created using aws_lakeformation_lf_tag before they can be attached
#    - The specified value must be one of the allowed values for the LF-tag key
#
# 2. Resource Selection:
#    - Exactly ONE resource type (database, table, or table_with_columns) must be specified
#    - You cannot tag multiple resource types in a single resource block
#
# 3. Table Resource:
#    - Use 'name' to tag a specific table
#    - Use 'wildcard = true' to tag all tables in a database
#    - At least one of 'name' or 'wildcard' must be specified
#
# 4. Table with Columns Resource:
#    - Use 'column_names' to tag specific columns
#    - Use 'wildcard = true' to tag all columns (optionally with 'excluded_column_names')
#    - If 'excluded_column_names' is used, 'wildcard' must be set to true
#    - At least one of 'column_names' or 'wildcard' must be specified
#
# 5. Multiple LF-Tags:
#    - Multiple lf_tag blocks can be specified to attach multiple tags to the same resource
#    - Each lf_tag block represents one key-value pair
#
# 6. Catalog ID:
#    - Can be specified at multiple levels (resource level, database/table level, lf_tag level)
#    - If not specified, defaults to the account ID of the caller
#
# 7. Regional Considerations:
#    - The 'region' parameter can be specified for table and table_with_columns resources
#    - Useful for cross-region Lake Formation configurations
#
# 8. Tag-Based Access Control:
#    - LF-tags enable fine-grained access control based on tag values
#    - Users can be granted permissions based on LF-tag expressions
#    - Supports both positive (include) and negative (exclude) matching
#
# 9. Terraform State:
#    - Changes to LF-tag attachments will trigger resource updates
#    - Removing an lf_tag block will detach that tag from the resource
#
# 10. Best Practices:
#     - Use descriptive LF-tag keys and values that align with your access control policies
#     - Document which tags are used for access control vs. organizational purposes
#     - Consider using separate resource blocks for different access control requirements
#     - Validate that LF-tag values exist before applying to avoid runtime errors
