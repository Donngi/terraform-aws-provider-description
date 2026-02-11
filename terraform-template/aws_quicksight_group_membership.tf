# ==============================================================================
# Terraform Resource: aws_quicksight_group_membership
# Provider Version: 6.28.0
# ==============================================================================
# Resource for managing Amazon QuickSight Group Membership
#
# Amazon QuickSight group memberships allow you to add users to groups for
# managing permissions and access control. Groups provide a way to organize
# users and assign permissions collectively rather than individually.
#
# Documentation:
# - Terraform: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/quicksight_group_membership
# - AWS API: https://docs.aws.amazon.com/quicksight/latest/developerguide/create-group-membership.html
# ==============================================================================

resource "aws_quicksight_group_membership" "example" {
  # --------------------------------------------------------------------------
  # REQUIRED PARAMETERS
  # --------------------------------------------------------------------------

  # (Required) The name of the group in which the member will be added.
  #
  # The group must already exist in the specified namespace. To find available
  # groups, you can use the ListGroups API operation or reference an existing
  # aws_quicksight_group resource.
  #
  # Example values:
  # - "all-access-users"
  # - "business-analysts"
  # - "dashboard-viewers"
  group_name = "all-access-users"

  # (Required) The name of the member to add to the group.
  #
  # This is the username of the QuickSight user that will be added to the
  # specified group. The user must already exist in the same namespace before
  # adding them to a group. You can reference an existing aws_quicksight_user
  # resource or provide the username directly.
  #
  # Example values:
  # - "john_smith"
  # - "admin/john.smith@example.com"
  # - "user@example.com"
  member_name = "john_smith"

  # --------------------------------------------------------------------------
  # OPTIONAL PARAMETERS
  # --------------------------------------------------------------------------

  # (Optional, Forces new resource) AWS account ID.
  # Defaults to automatically determined account ID of the Terraform AWS provider.
  #
  # Specifying this parameter forces the creation of a new resource if changed.
  # Leave this unset to use the AWS account ID from the provider configuration.
  #
  # Example: "123456789012"
  # aws_account_id = "123456789012"

  # (Optional) The namespace that you want the user to be a part of.
  # Defaults to "default".
  #
  # Namespaces provide isolation for QuickSight resources. The "default"
  # namespace is used for standard QuickSight deployments. Custom namespaces
  # are typically used in multi-tenant scenarios or for organizational separation.
  #
  # Example values:
  # - "default" (default)
  # - "production"
  # - "development"
  # namespace = "default"

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  #
  # Specify this to manage the group membership in a different region than
  # the provider default. See AWS Regional Endpoints documentation:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # Example: "us-west-2"
  # region = "us-west-2"

  # --------------------------------------------------------------------------
  # COMPUTED ATTRIBUTES (Read-Only)
  # --------------------------------------------------------------------------
  # These attributes are computed by AWS and cannot be set directly:
  #
  # - arn (string)
  #   The Amazon Resource Name (ARN) of the group membership.
  #
  # - id (string)
  #   The ID of the resource, computed as:
  #   <aws_account_id>/<namespace>/<group_name>/<member_name>
  #
  # Access computed attributes:
  # - aws_quicksight_group_membership.example.arn
  # - aws_quicksight_group_membership.example.id
  # --------------------------------------------------------------------------
}

# ==============================================================================
# USAGE EXAMPLES
# ==============================================================================

# Example 1: Basic group membership with defaults
# Uses the default namespace and provider AWS account ID
resource "aws_quicksight_group_membership" "basic" {
  group_name  = "analysts"
  member_name = "jane.doe"
}

# Example 2: Group membership with custom namespace
# Useful for multi-tenant or organizational separation
resource "aws_quicksight_group_membership" "custom_namespace" {
  group_name  = "data-engineers"
  member_name = "john.doe"
  namespace   = "production"
}

# Example 3: Group membership with explicit AWS account ID
# Useful when managing resources across multiple AWS accounts
resource "aws_quicksight_group_membership" "explicit_account" {
  aws_account_id = "123456789012"
  group_name     = "administrators"
  member_name    = "admin.user"
  namespace      = "default"
}

# Example 4: Group membership referencing other resources
# Best practice: Use resource references for dynamic configurations
resource "aws_quicksight_group_membership" "from_resources" {
  group_name  = aws_quicksight_group.analysts.group_name
  member_name = aws_quicksight_user.analyst.user_name
  namespace   = aws_quicksight_group.analysts.namespace
}

# Example 5: Multiple memberships for the same user
# Add a user to multiple groups for different permission sets
resource "aws_quicksight_group_membership" "user_viewers" {
  group_name  = "dashboard-viewers"
  member_name = "bob.smith"
}

resource "aws_quicksight_group_membership" "user_authors" {
  group_name  = "content-authors"
  member_name = "bob.smith"
}

# ==============================================================================
# IMPORTANT NOTES
# ==============================================================================
#
# 1. Prerequisites:
#    - The QuickSight group must exist before adding members
#    - The QuickSight user must be registered before being added to a group
#    - Both group and user must be in the same namespace
#
# 2. Force New Resource:
#    - Changing aws_account_id will force creation of a new resource
#    - All other parameter changes may also force replacement
#
# 3. Namespaces:
#    - The default namespace is "default" (lowercase)
#    - Custom namespaces are case-sensitive
#    - Namespaces must match between group, user, and membership resources
#
# 4. Resource Dependencies:
#    - Use depends_on or resource references to ensure proper creation order
#    - Example: depends_on = [aws_quicksight_group.example, aws_quicksight_user.example]
#
# 5. Group Management:
#    - Groups can have multiple members
#    - Users can belong to multiple groups
#    - Use aws_quicksight_group to create groups
#    - Use aws_quicksight_user to register users
#
# 6. Related AWS API Operations:
#    - CreateGroupMembership: Adds a user to a group
#    - DeleteGroupMembership: Removes a user from a group
#    - ListGroupMemberships: Lists members in a group
#    - DescribeGroupMembership: Checks if a user is in a group
#
# 7. Permissions Required:
#    - quicksight:CreateGroupMembership
#    - quicksight:DescribeGroupMembership
#    - quicksight:DeleteGroupMembership
#
# 8. Regional Considerations:
#    - QuickSight is available in specific AWS regions
#    - Group memberships are region-specific resources
#    - Ensure QuickSight is enabled in your target region
#
# ==============================================================================
# TERRAFORM OUTPUT EXAMPLES
# ==============================================================================

# Output the ARN of the group membership
output "group_membership_arn" {
  description = "The ARN of the QuickSight group membership"
  value       = aws_quicksight_group_membership.example.arn
}

# Output the ID of the group membership
output "group_membership_id" {
  description = "The ID of the QuickSight group membership"
  value       = aws_quicksight_group_membership.example.id
}

# ==============================================================================
# IMPORT
# ==============================================================================
# Existing QuickSight group memberships can be imported using the format:
# <aws_account_id>/<namespace>/<group_name>/<member_name>
#
# Example:
# terraform import aws_quicksight_group_membership.example 123456789012/default/all-access-users/john_smith
#
# ==============================================================================
# RELATED RESOURCES
# ==============================================================================
#
# - aws_quicksight_group: Create and manage QuickSight groups
# - aws_quicksight_user: Register and manage QuickSight users
# - aws_quicksight_namespace: Manage QuickSight namespaces (Enterprise edition)
# - aws_quicksight_data_source: Configure data sources for QuickSight
# - aws_quicksight_data_set: Create data sets for analysis
#
# ==============================================================================
