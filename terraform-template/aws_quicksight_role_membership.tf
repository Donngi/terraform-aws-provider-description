################################################################################
# AWS QuickSight Role Membership
# Terraform resource for managing an AWS QuickSight Role Membership.
#
# Resource: aws_quicksight_role_membership
# Provider Version: 6.28.0
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/quicksight_role_membership
#
# IMPORTANT NOTES:
# - The role membership APIs are disabled for identities managed by QuickSight
# - This resource can only be used when the QuickSight account subscription uses
#   the Active Directory or IAM Identity Center authentication method
# - Cannot be used with QuickSight-managed identities
#
# Valid Role Values:
# - ADMIN        : Administrator role
# - AUTHOR       : Author role (can create analyses and dashboards)
# - READER       : Reader role (view-only access)
# - ADMIN_PRO    : Administrator Pro role (with additional permissions)
# - AUTHOR_PRO   : Author Pro role (with additional permissions)
# - READER_PRO   : Reader Pro role (with additional permissions)
################################################################################

resource "aws_quicksight_role_membership" "example" {
  #-----------------------------------------------------------------------------
  # Required Arguments
  #-----------------------------------------------------------------------------

  # (Required) Name of the group to be added to the role
  # - This must be an existing group in your QuickSight account
  # - Cannot be used with QuickSight-managed identities
  # - Must be a valid Active Directory or IAM Identity Center group
  member_name = "example-group"

  # (Required) Role to add the group to
  # Valid values: ADMIN, AUTHOR, READER, ADMIN_PRO, AUTHOR_PRO, READER_PRO
  # - ADMIN: Full administrative access to QuickSight
  # - AUTHOR: Can create and publish analyses and dashboards
  # - READER: View-only access to dashboards
  # - *_PRO variants: Include additional enterprise features
  role = "READER"

  #-----------------------------------------------------------------------------
  # Optional Arguments
  #-----------------------------------------------------------------------------

  # (Optional, Forces new resource) AWS account ID
  # - Defaults to automatically determined account ID of the Terraform AWS provider
  # - If specified, forces creation of a new resource if changed
  # - Use when managing QuickSight in a different account than the provider
  # aws_account_id = "123456789012"

  # (Optional) Name of the namespace
  # - Defaults to "default" if not specified
  # - QuickSight namespaces provide logical isolation of resources
  # - Must be a valid existing namespace in your QuickSight account
  # namespace = "default"

  # (Optional) Region where this resource will be managed
  # - Defaults to the Region set in the provider configuration
  # - Allows managing QuickSight resources in a specific region
  # - Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

################################################################################
# Example: Multiple Role Memberships for Different Groups
################################################################################

# resource "aws_quicksight_role_membership" "admin_group" {
#   member_name = "admin-team"
#   role        = "ADMIN"
#   namespace   = "default"
# }
#
# resource "aws_quicksight_role_membership" "author_group" {
#   member_name = "data-analysts"
#   role        = "AUTHOR_PRO"
#   namespace   = "default"
# }
#
# resource "aws_quicksight_role_membership" "reader_group" {
#   member_name = "business-users"
#   role        = "READER"
#   namespace   = "default"
# }

################################################################################
# Example: Role Membership with Specific Account and Region
################################################################################

# resource "aws_quicksight_role_membership" "cross_account" {
#   member_name    = "external-analysts"
#   role           = "AUTHOR"
#   aws_account_id = "123456789012"
#   namespace      = "production"
#   region         = "us-west-2"
# }

################################################################################
# Attributes Reference
################################################################################
# This resource does not export any additional attributes beyond the arguments.
# The ID is set to a combination of aws_account_id/namespace/role/member_name

################################################################################
# Import
################################################################################
# QuickSight Role Membership can be imported using the format:
# aws_account_id/namespace/role/member_name
#
# Example:
# terraform import aws_quicksight_role_membership.example 123456789012/default/READER/example-group
