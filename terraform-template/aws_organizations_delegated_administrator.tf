# AWS Organizations Delegated Administrator
# Terraform Resource: aws_organizations_delegated_administrator
# Provider Version: 6.28.0
#
# Description:
# Provides a resource to manage an AWS Organizations Delegated Administrator.
# This resource allows you to register a member account in your organization as a
# delegated administrator for a specific AWS service. Delegated administrators can
# perform administrative tasks for the service on behalf of the organization's
# management account.
#
# Common Use Cases:
# - Delegate AWS Security Hub administration to a security account
# - Delegate AWS GuardDuty administration to a centralized security operations account
# - Delegate AWS CloudFormation StackSets administration to a deployment account
# - Delegate AWS Config administration for multi-account compliance
# - Delegate AWS Firewall Manager administration to a security account
#
# Prerequisites:
# - Must be run from the organization's management account
# - The target account must be a member of the organization
# - The service must support delegated administration
# - The account must not already be a delegated administrator for the service
#
# Important Notes:
# - Each service can have only one delegated administrator account
# - Removing this resource will deregister the delegated administrator
# - Some services require additional setup after delegation
# - Not all AWS services support delegated administration
#
# AWS Documentation:
# - API Reference: https://docs.aws.amazon.com/organizations/latest/APIReference/API_RegisterDelegatedAdministrator.html
# - User Guide: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_delegate_policies.html
# - Service List: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrated-services-list.html
#
# Terraform Documentation:
# - Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator

resource "aws_organizations_delegated_administrator" "example" {
  # ====================
  # Required Arguments
  # ====================

  # account_id (Required)
  # Type: string
  # The 12-digit account ID number of the member account in the organization to
  # register as a delegated administrator.
  #
  # Requirements:
  # - Must be a valid 12-digit AWS account ID
  # - Account must be a member of the organization
  # - Account cannot be the management account
  # - Account must be in ACTIVE status
  #
  # Example Values:
  # - "123456789012" (security operations account)
  # - "987654321098" (compliance audit account)
  # - "555666777888" (centralized logging account)
  #
  # Related AWS Service Principals:
  # - GuardDuty: guardduty.amazonaws.com
  # - Security Hub: securityhub.amazonaws.com
  # - CloudFormation StackSets: member.org.stacksets.cloudformation.amazonaws.com
  # - Config: config.amazonaws.com
  # - Firewall Manager: fms.amazonaws.com
  # - Macie: macie.amazonaws.com
  # - Detective: detective.amazonaws.com
  # - Access Analyzer: access-analyzer.amazonaws.com
  # - Audit Manager: auditmanager.amazonaws.com
  #
  # Important:
  # - Changing this value forces recreation of the resource
  # - Verify the account is ready to assume delegated administrator responsibilities
  # - Ensure the account has appropriate IAM permissions for the service
  account_id = "123456789012"

  # service_principal (Required)
  # Type: string
  # The service principal of the AWS service for which you want to make the member
  # account a delegated administrator. This identifies which AWS service will allow
  # the specified account to perform delegated administration.
  #
  # Format: <service-name>.amazonaws.com
  #
  # Common Service Principals:
  # Security Services:
  # - guardduty.amazonaws.com          - Amazon GuardDuty (threat detection)
  # - securityhub.amazonaws.com        - AWS Security Hub (security posture management)
  # - fms.amazonaws.com                - AWS Firewall Manager (firewall policies)
  # - macie.amazonaws.com              - Amazon Macie (data security)
  # - detective.amazonaws.com          - Amazon Detective (security investigations)
  # - access-analyzer.amazonaws.com    - IAM Access Analyzer
  # - inspector2.amazonaws.com         - Amazon Inspector (vulnerability management)
  #
  # Compliance & Governance:
  # - config.amazonaws.com                                    - AWS Config
  # - config-multiaccountsetup.amazonaws.com                 - AWS Config Multi-Account Setup
  # - member.org.stacksets.cloudformation.amazonaws.com      - CloudFormation StackSets
  # - auditmanager.amazonaws.com                             - AWS Audit Manager
  # - cloudtrail.amazonaws.com                               - AWS CloudTrail
  #
  # Compute & Networking:
  # - compute-optimizer.amazonaws.com  - AWS Compute Optimizer
  # - ipam.amazonaws.com              - VPC IPAM
  # - ram.amazonaws.com               - AWS Resource Access Manager
  #
  # Storage & Backup:
  # - backup.amazonaws.com            - AWS Backup
  # - storage-lens.s3.amazonaws.com   - Amazon S3 Storage Lens
  #
  # Requirements:
  # - Must be a valid AWS service principal
  # - Service must support delegated administration
  # - Only one delegated admin per service per organization
  #
  # Validation:
  # - Check AWS documentation for supported services
  # - Verify the service is available in your region
  # - Confirm the service supports your organization type
  #
  # Important:
  # - Changing this value forces recreation of the resource
  # - Some services require additional configuration after delegation
  # - Deregistering may require cleanup in the service console
  service_principal = "securityhub.amazonaws.com"

  # ====================
  # Computed Attributes
  # ====================
  # These attributes are set by AWS after the resource is created and cannot be
  # configured. They are available for reference in other resources or outputs.
  #
  # - id: The unique identifier (ID) of the delegated administrator
  #       Format: account_id/service_principal
  #       Example: "123456789012/securityhub.amazonaws.com"
  #
  # - arn: The Amazon Resource Name (ARN) of the delegated administrator's account
  #        Example: "arn:aws:organizations::111122223333:account/o-exampleorgid/123456789012"
  #
  # - delegation_enabled_date: The date when the account was made a delegated administrator
  #                           Format: RFC3339 timestamp
  #                           Example: "2024-01-15T10:30:00Z"
  #
  # - email: The email address associated with the delegated administrator's AWS account
  #          Example: "security-team@example.com"
  #
  # - joined_method: The method by which the delegated administrator's account joined the organization
  #                  Values: "INVITED" | "CREATED"
  #                  Example: "INVITED"
  #
  # - joined_timestamp: The date when the delegated administrator's account became part of the organization
  #                    Format: RFC3339 timestamp
  #                    Example: "2023-06-01T08:00:00Z"
  #
  # - name: The friendly name of the delegated administrator's account
  #         Example: "Security Operations Account"
  #
  # - status: The status of the delegated administrator's account in the organization
  #           Values: "ACTIVE" | "SUSPENDED" | "PENDING_CLOSURE"
  #           Example: "ACTIVE"
}

# ====================
# Example Configurations
# ====================

# Example 1: GuardDuty Delegated Administrator
resource "aws_organizations_delegated_administrator" "guardduty" {
  account_id        = "123456789012"
  service_principal = "guardduty.amazonaws.com"
}

# Example 2: Security Hub Delegated Administrator
resource "aws_organizations_delegated_administrator" "securityhub" {
  account_id        = "123456789012"
  service_principal = "securityhub.amazonaws.com"
}

# Example 3: AWS Config Delegated Administrator
resource "aws_organizations_delegated_administrator" "config" {
  account_id        = "987654321098"
  service_principal = "config.amazonaws.com"
}

# Example 4: CloudFormation StackSets Delegated Administrator
resource "aws_organizations_delegated_administrator" "stacksets" {
  account_id        = "555666777888"
  service_principal = "member.org.stacksets.cloudformation.amazonaws.com"
}

# Example 5: Firewall Manager Delegated Administrator
resource "aws_organizations_delegated_administrator" "fms" {
  account_id        = "123456789012"
  service_principal = "fms.amazonaws.com"
}

# Example 6: Multiple Services for Same Account
# Note: One account can be delegated admin for multiple services
resource "aws_organizations_delegated_administrator" "security_account_guardduty" {
  account_id        = "123456789012"
  service_principal = "guardduty.amazonaws.com"
}

resource "aws_organizations_delegated_administrator" "security_account_securityhub" {
  account_id        = "123456789012"
  service_principal = "securityhub.amazonaws.com"
}

resource "aws_organizations_delegated_administrator" "security_account_macie" {
  account_id        = "123456789012"
  service_principal = "macie.amazonaws.com"
}

# ====================
# Output Examples
# ====================

# Output the delegated administrator details
output "delegated_admin_id" {
  description = "The unique identifier of the delegated administrator"
  value       = aws_organizations_delegated_administrator.example.id
}

output "delegated_admin_arn" {
  description = "The ARN of the delegated administrator's account"
  value       = aws_organizations_delegated_administrator.example.arn
}

output "delegated_admin_email" {
  description = "The email address of the delegated administrator's account"
  value       = aws_organizations_delegated_administrator.example.email
}

output "delegation_enabled_date" {
  description = "When the delegation was enabled"
  value       = aws_organizations_delegated_administrator.example.delegation_enabled_date
}

output "account_status" {
  description = "The status of the delegated administrator's account"
  value       = aws_organizations_delegated_administrator.example.status
}

# ====================
# Data Source Usage
# ====================

# Query the account details using data source
data "aws_organizations_account" "delegated_account" {
  account_id = aws_organizations_delegated_administrator.example.account_id
}

# Use account information in other resources
resource "aws_iam_role" "delegated_admin_role" {
  name = "delegated-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.aws_organizations_account.delegated_account.arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# ====================
# Import Example
# ====================

# Import existing delegated administrator
# Format: account_id/service_principal
#
# Command:
# terraform import aws_organizations_delegated_administrator.example 123456789012/securityhub.amazonaws.com

# ====================
# Best Practices
# ====================

# 1. Centralize Security Services
#    Designate a dedicated security account as the delegated administrator
#    for all security-related services (GuardDuty, Security Hub, etc.)

# 2. Separate Concerns
#    Use different accounts for different domains:
#    - Security account for security services
#    - Audit account for compliance services (Config, Audit Manager)
#    - Operations account for operational services

# 3. Implement Proper IAM Permissions
#    Ensure delegated administrator accounts have appropriate IAM roles
#    and permissions to manage the delegated services

# 4. Document Service Principals
#    Maintain clear documentation of which accounts are delegated
#    administrators for which services

# 5. Monitor Delegation Changes
#    Use CloudTrail to track RegisterDelegatedAdministrator and
#    DeregisterDelegatedAdministrator API calls

# 6. Plan for Disaster Recovery
#    Consider how delegated administration affects disaster recovery
#    and account closure procedures

# 7. Test Before Production
#    Test delegation in a non-production organization first to
#    understand the implications

# ====================
# Common Errors
# ====================

# Error: ACCOUNT_NOT_FOUND
# Solution: Verify the account_id exists and is a member of the organization

# Error: INVALID_INPUT_EXCEPTION
# Solution: Check that the service_principal is valid and supports delegation

# Error: ACCOUNT_ALREADY_REGISTERED
# Solution: The account is already registered as a delegated administrator
#          for this service. Check existing registrations.

# Error: ACCESS_DENIED
# Solution: Ensure you're running from the organization's management account
#          and have organizations:RegisterDelegatedAdministrator permission

# Error: TOO_MANY_REQUESTS
# Solution: Implement rate limiting and exponential backoff in automation

# Error: CONSTRAINT_VIOLATION_EXCEPTION
# Solution: Check service-specific requirements and organization policies

# ====================
# Terraform Lifecycle
# ====================

# Prevent accidental deletion of critical delegated administrators
resource "aws_organizations_delegated_administrator" "protected" {
  account_id        = "123456789012"
  service_principal = "securityhub.amazonaws.com"

  lifecycle {
    prevent_destroy = true
  }
}

# Recreate when account changes (default behavior)
resource "aws_organizations_delegated_administrator" "recreate_on_change" {
  account_id        = "123456789012"
  service_principal = "guardduty.amazonaws.com"

  lifecycle {
    create_before_destroy = false
  }
}

# ====================
# Related Resources
# ====================

# Organizations Account
# resource "aws_organizations_account" "security"
#   - Create member accounts that will become delegated administrators

# Organizations Organization
# resource "aws_organizations_organization"
#   - Manage the organization itself
#   - Enable service access for delegation

# Organizations Policy
# resource "aws_organizations_policy"
#   - Service Control Policies (SCPs) affecting delegated administrators

# Organizations Organizational Unit
# resource "aws_organizations_organizational_unit"
#   - Organize accounts including delegated administrators

# Service-Specific Resources
# resource "aws_guardduty_organization_admin_account"
#   - Alternative resource for GuardDuty (deprecated in favor of this resource)
# resource "aws_securityhub_organization_admin_account"
#   - Alternative resource for Security Hub (deprecated in favor of this resource)

# ====================
# Tags
# ====================

# Note: This resource does not support tags directly.
# To tag related resources, use the delegated administrator's account ID:

# Tag the account itself (if using aws_organizations_account)
# resource "aws_organizations_account" "security" {
#   name  = "Security Operations"
#   email = "security@example.com"
#
#   tags = {
#     Role        = "DelegatedAdministrator"
#     Services    = "GuardDuty,SecurityHub,Macie"
#     Environment = "Production"
#     Team        = "Security"
#   }
# }

# ====================
# Advanced Patterns
# ====================

# Pattern 1: Dynamic Delegation Based on Variables
variable "security_services" {
  description = "List of AWS security services to delegate"
  type        = list(string)
  default = [
    "guardduty.amazonaws.com",
    "securityhub.amazonaws.com",
    "macie.amazonaws.com",
    "detective.amazonaws.com"
  ]
}

variable "security_account_id" {
  description = "Account ID for security operations"
  type        = string
}

resource "aws_organizations_delegated_administrator" "security_services" {
  for_each = toset(var.security_services)

  account_id        = var.security_account_id
  service_principal = each.value
}

# Pattern 2: Conditional Delegation
variable "enable_guardduty_delegation" {
  description = "Whether to enable GuardDuty delegation"
  type        = bool
  default     = true
}

resource "aws_organizations_delegated_administrator" "guardduty_conditional" {
  count = var.enable_guardduty_delegation ? 1 : 0

  account_id        = var.security_account_id
  service_principal = "guardduty.amazonaws.com"
}

# Pattern 3: Map-based Multi-Service Delegation
variable "delegated_services" {
  description = "Map of services to their delegated administrator account IDs"
  type        = map(string)
  default = {
    "guardduty.amazonaws.com"    = "123456789012"
    "securityhub.amazonaws.com"  = "123456789012"
    "config.amazonaws.com"       = "987654321098"
    "backup.amazonaws.com"       = "555666777888"
  }
}

resource "aws_organizations_delegated_administrator" "services_map" {
  for_each = var.delegated_services

  service_principal = each.key
  account_id        = each.value
}

# ====================
# Monitoring & Alerts
# ====================

# CloudWatch Event Rule for Delegation Changes
resource "aws_cloudwatch_event_rule" "delegation_changes" {
  name        = "organizations-delegation-changes"
  description = "Capture delegated administrator registration/deregistration"

  event_pattern = jsonencode({
    source      = ["aws.organizations"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventName = [
        "RegisterDelegatedAdministrator",
        "DeregisterDelegatedAdministrator"
      ]
    }
  })
}

# SNS Topic for Alerts
resource "aws_sns_topic" "delegation_alerts" {
  name = "organizations-delegation-alerts"
}

# EventBridge Target
resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.delegation_changes.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.delegation_alerts.arn
}

# ====================
# Security Considerations
# ====================

# 1. Least Privilege
#    Grant only necessary permissions to delegated administrator accounts
#
# 2. Regular Audits
#    Periodically review delegated administrators and their permissions
#
# 3. Account Isolation
#    Use separate accounts for different administrative domains
#
# 4. Multi-Factor Authentication
#    Enforce MFA for all delegated administrator accounts
#
# 5. CloudTrail Logging
#    Enable CloudTrail in all accounts, especially delegated administrators
#
# 6. Service Control Policies
#    Use SCPs to limit what delegated administrators can do
#
# 7. Access Reviews
#    Regularly review who has access to delegated administrator accounts

# ====================
# Compliance & Governance
# ====================

# Document delegation for compliance purposes
# Required for: SOC 2, ISO 27001, PCI DSS, HIPAA, FedRAMP

# Example Documentation Output
output "compliance_documentation" {
  description = "Delegation details for compliance documentation"
  value = {
    account_id            = aws_organizations_delegated_administrator.example.account_id
    account_name          = aws_organizations_delegated_administrator.example.name
    account_email         = aws_organizations_delegated_administrator.example.email
    service_principal     = aws_organizations_delegated_administrator.example.service_principal
    delegation_date       = aws_organizations_delegated_administrator.example.delegation_enabled_date
    account_status        = aws_organizations_delegated_administrator.example.status
    account_arn           = aws_organizations_delegated_administrator.example.arn
  }
}
