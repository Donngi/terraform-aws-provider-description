################################################################################
# AWS Organizations Organization
################################################################################
# Provides a resource to create an AWS organization.
#
# Important Notes:
# - When migrating from feature_set "CONSOLIDATED_BILLING" to "ALL", the
#   Organization account owner will receive an email, and all invited member
#   accounts must approve the change. The owner must finalize changes via AWS
#   Console. Until complete, Terraform will show perpetual differences.
# - AWS recommends enabling service integration via the console or service-specific
#   commands to ensure proper resource creation for integration.
#
# Use Cases:
# - Creating and managing AWS Organizations for consolidated billing
# - Enabling all features for advanced organization management
# - Integrating AWS services with Organizations (CloudTrail, Config, etc.)
# - Managing organization-wide policies (SCPs, Tag Policies, Backup Policies)
#
# Terraform Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/organizations_organization
################################################################################

resource "aws_organizations_organization" "example" {
  ################################################################################
  # Service Access Principals
  ################################################################################
  # (Optional) List of AWS service principal names for integration with your
  # organization. This is typically in the form of a URL, such as
  # service-abbreviation.amazonaws.com.
  #
  # Requirements:
  # - Organization must have feature_set set to "ALL"
  # - Some services don't support enablement via this endpoint
  # - For INSPECTOR_POLICY: must include "inspector2.amazonaws.com"
  # - For SECURITYHUB_POLICY: must include "securityhub.amazonaws.com"
  #
  # Common service principals:
  # - cloudtrail.amazonaws.com
  # - config.amazonaws.com
  # - sso.amazonaws.com
  # - guardduty.amazonaws.com
  # - ram.amazonaws.com
  # - macie.amazonaws.com
  # - servicecatalog.amazonaws.com
  # - access-analyzer.amazonaws.com
  # - compute-optimizer.amazonaws.com
  # - health.amazonaws.com
  # - license-manager.amazonaws.com
  # - member.org.stacksets.cloudformation.amazonaws.com
  # - securityhub.amazonaws.com
  # - inspector2.amazonaws.com
  # - backup.amazonaws.com
  #
  # Type: list(string)
  # Default: none
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  ################################################################################
  # Enabled Policy Types
  ################################################################################
  # (Optional) List of Organizations policy types to enable in the Organization Root.
  #
  # Requirements:
  # - Organization must have feature_set set to "ALL"
  # - For INSPECTOR_POLICY: aws_service_access_principals must include
  #   "inspector2.amazonaws.com"
  # - For SECURITYHUB_POLICY: aws_service_access_principals must include
  #   "securityhub.amazonaws.com"
  #
  # Valid policy types:
  # - AISERVICES_OPT_OUT_POLICY: Control AI service opt-out preferences
  # - BACKUP_POLICY: Centralized backup policies
  # - BEDROCK_POLICY: Amazon Bedrock governance policies
  # - CHATBOT_POLICY: AWS Chatbot policies
  # - DECLARATIVE_POLICY_EC2: EC2 declarative policies
  # - INSPECTOR_POLICY: Amazon Inspector policies (requires service access)
  # - RESOURCE_CONTROL_POLICY: Resource-level control policies
  # - S3_POLICY: S3-specific policies
  # - SECURITYHUB_POLICY: Security Hub policies (requires service access)
  # - SERVICE_CONTROL_POLICY: Service control policies (SCPs)
  # - TAG_POLICY: Tag enforcement policies
  # - UPGRADE_ROLLOUT_POLICY: Upgrade rollout control policies
  #
  # Type: list(string)
  # Default: none
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY",
  ]

  ################################################################################
  # Feature Set
  ################################################################################
  # (Optional) Specify the feature set for the organization.
  #
  # Options:
  # - "ALL": Enable all features (recommended for full management capabilities)
  #   - Allows service control policies (SCPs)
  #   - Enables consolidated billing
  #   - Supports all policy types
  #   - Requires member approval when migrating from CONSOLIDATED_BILLING
  #
  # - "CONSOLIDATED_BILLING": Basic billing consolidation only
  #   - Limited to billing features
  #   - Cannot use SCPs or other advanced policies
  #   - Simpler setup with no approval needed
  #
  # Migration Warning:
  # - Changing from CONSOLIDATED_BILLING to ALL requires:
  #   1. Member account approval for invited accounts
  #   2. Manual finalization in AWS Console
  #   3. Terraform will show differences until complete
  #
  # Type: string
  # Valid values: "ALL", "CONSOLIDATED_BILLING"
  # Default: "ALL"
  feature_set = "ALL"

  ################################################################################
  # Return Organization Only
  ################################################################################
  # (Optional) Return only the results of the DescribeOrganization API to avoid
  # API rate limits.
  #
  # When set to true:
  # - Only returns: arn, feature_set, master_account_arn, master_account_email,
  #   and master_account_id
  # - All other attributes will be empty (accounts, non_master_accounts, roots)
  # - Useful for avoiding API throttling in large organizations
  # - Reduces API calls and speeds up Terraform operations
  #
  # When to use:
  # - Large organizations with many accounts
  # - Hitting AWS Organizations API rate limits
  # - Don't need full account/root details in state
  #
  # Type: bool
  # Default: false
  # return_organization_only = false

  ################################################################################
  # Computed Attributes (Outputs)
  ################################################################################
  # The following attributes are exported and can be referenced:
  #
  # - id: Identifier of the organization
  # - arn: ARN of the organization
  # - master_account_arn: ARN of the master (management) account
  # - master_account_email: Email address of the master account
  # - master_account_id: Identifier of the master account
  # - master_account_name: Name of the master account
  #
  # - accounts: List of ALL organization accounts including master account
  #   Each account contains:
  #   - arn: ARN of the account
  #   - email: Email of the account
  #   - id: Identifier of the account
  #   - joined_method: Method by which account joined (INVITED or CREATED)
  #   - joined_timestamp: Date the account became part of organization
  #   - name: Name of the account
  #   - state: Current state of the account (ACTIVE, SUSPENDED, etc.)
  #   - status: (Deprecated - use state instead)
  #
  # - non_master_accounts: List of organization accounts EXCLUDING master account
  #   Contains same attributes as accounts list
  #
  # - roots: List of organization roots (typically one root)
  #   Each root contains:
  #   - arn: ARN of the root
  #   - id: Identifier of the root
  #   - name: Name of the root
  #   - policy_types: List of enabled policy types for this root
  #     Each policy type contains:
  #     - name: Name of the policy type
  #     - status: Status of the policy type (ENABLED or DISABLED)
  #
  # Note: Most attributes are empty when return_organization_only = true
  ################################################################################
}

################################################################################
# Output Examples
################################################################################

# output "organization_id" {
#   description = "The ID of the AWS organization"
#   value       = aws_organizations_organization.example.id
# }

# output "organization_arn" {
#   description = "The ARN of the AWS organization"
#   value       = aws_organizations_organization.example.arn
# }

# output "master_account_id" {
#   description = "The ID of the organization's master account"
#   value       = aws_organizations_organization.example.master_account_id
# }

# output "master_account_email" {
#   description = "The email address of the master account"
#   value       = aws_organizations_organization.example.master_account_email
# }

# output "all_account_ids" {
#   description = "List of all account IDs in the organization"
#   value       = [for account in aws_organizations_organization.example.accounts : account.id]
# }

# output "member_account_ids" {
#   description = "List of member account IDs (excluding master)"
#   value       = [for account in aws_organizations_organization.example.non_master_accounts : account.id]
# }

# output "organization_root_id" {
#   description = "The ID of the organization root"
#   value       = aws_organizations_organization.example.roots[0].id
# }

# output "enabled_policy_types" {
#   description = "List of enabled policy types in the organization root"
#   value       = [for pt in aws_organizations_organization.example.roots[0].policy_types : pt.name if pt.status == "ENABLED"]
# }

################################################################################
# Additional Notes
################################################################################
# 1. Organization Creation:
#    - Only one organization can exist per AWS account
#    - The creating account becomes the master (management) account
#    - Cannot be moved to another account after creation
#
# 2. Feature Set Migration:
#    - Migration from CONSOLIDATED_BILLING to ALL is one-way (cannot revert)
#    - Requires member account approval for invited accounts
#    - Must be finalized manually in AWS Console
#    - Terraform will show differences until finalization is complete
#
# 3. Service Integration:
#    - AWS recommends using service consoles for integration
#    - Ensures proper resource creation for integration
#    - Some services may not support API-based enablement
#    - Check service documentation for specific requirements
#
# 4. Policy Types:
#    - Require feature_set = "ALL"
#    - Some policy types have service access prerequisites
#    - Policy types can be managed independently after organization creation
#    - Check AWS Organizations API reference for latest policy types
#
# 5. API Rate Limits:
#    - Large organizations may hit API throttling limits
#    - Use return_organization_only = true to reduce API calls
#    - Consider using data sources for read-only operations
#    - Implement exponential backoff for API operations
#
# 6. Deletion:
#    - Cannot delete organization with member accounts
#    - Must remove all member accounts first
#    - Master account remains and organization is closed
#    - Some service integrations must be disabled before deletion
#
# 7. Common Use Cases:
#    - Multi-account strategy implementation
#    - Centralized billing and cost management
#    - Organization-wide security policies (SCPs)
#    - Service integration across accounts (CloudTrail, Config)
#    - Tag enforcement and governance
#    - Backup policies across accounts
#
# 8. Security Best Practices:
#    - Enable CloudTrail for organization-wide logging
#    - Use SCPs to prevent privilege escalation
#    - Implement tag policies for resource governance
#    - Enable AWS Config for compliance monitoring
#    - Use resource control policies for fine-grained permissions
#    - Regular review of member accounts and their status
#
# 9. Related Resources:
#    - aws_organizations_account: Create member accounts
#    - aws_organizations_organizational_unit: Organize accounts
#    - aws_organizations_policy: Create and manage policies
#    - aws_organizations_policy_attachment: Attach policies to OUs/accounts
#    - aws_organizations_delegated_administrator: Delegate admin rights
#
# 10. Terraform State Considerations:
#     - Organization resource is sensitive (contains account info)
#     - State may contain email addresses and account details
#     - Secure your Terraform state appropriately
#     - Consider remote state with encryption
################################################################################
