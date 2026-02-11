################################################################################
# AWS Inspector2 Member Association
# Resource: aws_inspector2_member_association
# Provider Version: 6.28.0
################################################################################
# Description:
# Terraform resource for associating accounts to existing Inspector instances.
# This resource allows you to associate member accounts with an Amazon Inspector
# delegated administrator account for centralized security scanning management.
#
# Use Cases:
# - Associate member accounts to a delegated administrator account in AWS Inspector
# - Manage multi-account Inspector deployments
# - Centralize vulnerability scanning across AWS accounts
#
# Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_member_association
################################################################################

resource "aws_inspector2_member_association" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # account_id - (Required) ID of the account to associate
  # Type: string
  # The AWS account ID of the member account to be associated with the
  # delegated administrator account for Amazon Inspector.
  # Example: "123456789012"
  account_id = "123456789012"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # region - (Optional) Region where this resource will be managed
  # Type: string
  # Default: Defaults to the Region set in the provider configuration
  # The AWS region where the member association will be managed.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Uncomment to specify:
  # region = "us-east-1"

  ################################################################################
  # Timeouts Configuration
  ################################################################################
  # Optional timeouts block to customize operation timeouts
  # Uncomment and adjust as needed:
  # timeouts {
  #   # create - (Optional) How long to wait for member association creation
  #   # Default: Typically 5 minutes
  #   create = "5m"
  #
  #   # delete - (Optional) How long to wait for member association deletion
  #   # Default: Typically 5 minutes
  #   delete = "5m"
  # }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# The following attributes are exported and available after resource creation:
#
# - id: Unique identifier for the resource (computed)
#   Type: string
#
# - delegated_admin_account_id: Account ID of the delegated administrator account
#   Type: string
#   The AWS account ID that serves as the delegated administrator
#
# - relationship_status: Status of the member relationship
#   Type: string
#   Current status of the association (e.g., "ENABLED", "DISABLED")
#
# - updated_at: Date and time of the last update of the relationship
#   Type: string
#   Timestamp of when the member association was last updated
#
# These can be referenced as:
# - aws_inspector2_member_association.example.id
# - aws_inspector2_member_association.example.delegated_admin_account_id
# - aws_inspector2_member_association.example.relationship_status
# - aws_inspector2_member_association.example.updated_at
################################################################################

################################################################################
# Example Outputs
################################################################################
# Uncomment to export useful values:
#
# output "inspector_member_association_id" {
#   description = "The ID of the Inspector member association"
#   value       = aws_inspector2_member_association.example.id
# }
#
# output "inspector_delegated_admin_account_id" {
#   description = "The delegated administrator account ID"
#   value       = aws_inspector2_member_association.example.delegated_admin_account_id
# }
#
# output "inspector_relationship_status" {
#   description = "The status of the member relationship"
#   value       = aws_inspector2_member_association.example.relationship_status
# }
#
# output "inspector_updated_at" {
#   description = "When the member association was last updated"
#   value       = aws_inspector2_member_association.example.updated_at
# }
################################################################################

################################################################################
# Additional Notes
################################################################################
# Prerequisites:
# - Amazon Inspector must be enabled in the delegated administrator account
# - The delegated administrator account must be configured
# - Appropriate IAM permissions must be in place for member association
#
# Important Considerations:
# - Only one delegated administrator per organization is allowed
# - Member accounts must be part of the same AWS Organization
# - Member association enables centralized vulnerability scanning
# - Removing the association will disable Inspector scanning for the member account
#
# Common Use Cases:
# 1. Multi-account security posture management
# 2. Centralized vulnerability and compliance scanning
# 3. Organization-wide security findings aggregation
#
# Best Practices:
# - Use AWS Organizations for centralized account management
# - Configure appropriate IAM roles and policies
# - Monitor relationship_status for association health
# - Use lifecycle management for automated association handling
#
# Related Resources:
# - aws_inspector2_organization_configuration
# - aws_inspector2_delegated_admin_account
# - aws_organizations_organization
################################################################################
