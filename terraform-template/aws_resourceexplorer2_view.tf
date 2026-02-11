################################################################################
# AWS Resource Explorer 2 View
# Resource: aws_resourceexplorer2_view
# Provider Version: 6.28.0
#
# Description:
# Provides a resource to manage a Resource Explorer view.
#
# Official Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourceexplorer2_view
# https://docs.aws.amazon.com/resource-explorer/latest/userguide/manage-views.html
################################################################################

resource "aws_resourceexplorer2_view" "example" {
  #==============================================================================
  # REQUIRED PARAMETERS
  #==============================================================================

  # name - (Required)
  # The name of the view. The name must be no more than 64 characters long,
  # and can include letters, digits, and the dash (-) character.
  # The name must be unique within its AWS Region.
  #
  # Type: string
  # Constraints: Max 64 characters, alphanumeric and dash (-) only
  name = "exampleview"

  #==============================================================================
  # OPTIONAL PARAMETERS
  #==============================================================================

  # region - (Optional)
  # Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  #
  # Type: string
  # Example: "us-east-1", "eu-west-1"
  # region = "us-east-1"

  # default_view - (Optional)
  # Specifies whether the view is the default view for the AWS Region.
  # Default: false
  #
  # Type: bool
  # Reference: https://docs.aws.amazon.com/resource-explorer/latest/userguide/manage-views-about.html#manage-views-about-default
  # default_view = false

  # scope - (Optional, Computed)
  # The scope of the view. This is a computed value that represents
  # the root of the resource hierarchy that this view can search.
  #
  # Type: string
  # Note: This is typically computed by AWS
  # scope = null

  # tags - (Optional)
  # Key-value map of resource tags.
  # If configured with a provider default_tags configuration block,
  # tags with matching keys will overwrite those defined at the provider-level.
  #
  # Type: map(string)
  # tags = {
  #   Environment = "production"
  #   Project     = "resource-discovery"
  # }

  #==============================================================================
  # NESTED BLOCKS - filters
  #==============================================================================

  # filters - (Optional)
  # Specifies which resources are included in the results of queries
  # made using this view.
  #
  # Note: This is a list block that can be specified once.
  filters {
    # filter_string - (Required)
    # The string that contains the search keywords, prefixes, and operators
    # to control the results that can be returned by a search operation.
    #
    # Type: string
    # Reference: https://docs.aws.amazon.com/resource-explorer/latest/userguide/using-search-query-syntax.html
    # Examples:
    #   - "resourcetype:ec2:instance"
    #   - "resourcetype:s3:bucket tag.key:Environment tag.value:Production"
    #   - "region:us-east-1 resourcetype:ec2:*"
    filter_string = "resourcetype:ec2:instance"
  }

  #==============================================================================
  # NESTED BLOCKS - included_property
  #==============================================================================

  # included_property - (Optional)
  # Optional fields to be included in search results from this view.
  #
  # Note: Multiple blocks can be specified to include different properties.
  included_property {
    # name - (Required)
    # The name of the property that is included in this view.
    #
    # Type: string
    # Valid values: "tags"
    # Note: Currently, only "tags" is supported as a valid value.
    name = "tags"
  }

  #==============================================================================
  # DEPENDENCIES
  #==============================================================================

  # Resource Explorer views require an index to be created first
  # in the same region. Use depends_on to ensure proper order.
  #
  # depends_on = [aws_resourceexplorer2_index.example]
}

################################################################################
# COMPUTED ATTRIBUTES (Read-Only)
################################################################################

# arn - (Computed)
# Amazon Resource Name (ARN) of the Resource Explorer view.
# Type: string
# Output: aws_resourceexplorer2_view.example.arn

# tags_all - (Computed)
# A map of tags assigned to the resource, including those inherited
# from the provider default_tags configuration block.
# Type: map(string)
# Output: aws_resourceexplorer2_view.example.tags_all

################################################################################
# EXAMPLE OUTPUTS
################################################################################

# output "view_arn" {
#   description = "ARN of the Resource Explorer view"
#   value       = aws_resourceexplorer2_view.example.arn
# }

# output "view_name" {
#   description = "Name of the Resource Explorer view"
#   value       = aws_resourceexplorer2_view.example.name
# }

# output "view_scope" {
#   description = "Scope of the Resource Explorer view"
#   value       = aws_resourceexplorer2_view.example.scope
# }

################################################################################
# USAGE NOTES
################################################################################

# 1. Prerequisites:
#    - A Resource Explorer index must be created in the region before
#      creating a view. Use aws_resourceexplorer2_index resource.
#    - Resource Explorer must be enabled in your AWS account.

# 2. Filter Syntax:
#    - Filters use a search query syntax with keywords and operators
#    - Common patterns:
#      * resourcetype:<service>:<resource-type>
#      * tag.key:<key-name> tag.value:<value>
#      * region:<region-code>
#      * Multiple conditions can be combined with spaces (AND logic)

# 3. Default View:
#    - Only one view per region can be marked as default
#    - The default view is used when searching without specifying a view
#    - Setting default_view = true will make this the default view

# 4. Included Properties:
#    - Currently, only "tags" can be included as an additional property
#    - Including tags in the view allows tag information to be returned
#      in search results without additional API calls

# 5. Regional Considerations:
#    - Views are region-specific resources
#    - Each view can only search resources indexed in its region
#    - For multi-region search, create aggregator indexes and views

# 6. Import:
#    - Resource Explorer views can be imported using the ARN:
#      terraform import aws_resourceexplorer2_view.example arn:aws:resource-explorer-2:us-east-1:123456789012:view/exampleview/1234abcd-5678-efgh-9012-ijklmnopqrst

################################################################################
# ADVANCED EXAMPLE - Multi-Resource Type View
################################################################################

# resource "aws_resourceexplorer2_view" "multi_resource" {
#   name         = "multi-resource-view"
#   default_view = true
#
#   filters {
#     filter_string = "resourcetype:ec2:* OR resourcetype:s3:bucket OR resourcetype:lambda:function"
#   }
#
#   included_property {
#     name = "tags"
#   }
#
#   tags = {
#     Purpose     = "Multi-resource discovery"
#     ManagedBy   = "Terraform"
#     Environment = "production"
#   }
#
#   depends_on = [aws_resourceexplorer2_index.main]
# }

################################################################################
# ADVANCED EXAMPLE - Tagged Resources View
################################################################################

# resource "aws_resourceexplorer2_view" "tagged_resources" {
#   name = "production-tagged-view"
#
#   filters {
#     filter_string = "tag.key:Environment tag.value:Production"
#   }
#
#   included_property {
#     name = "tags"
#   }
#
#   tags = {
#     ViewType    = "EnvironmentFilter"
#     Environment = "production"
#   }
#
#   depends_on = [aws_resourceexplorer2_index.main]
# }
