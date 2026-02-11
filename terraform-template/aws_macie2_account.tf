# ============================================================
# Amazon Macie Account Configuration
# ============================================================
# Amazon Macie is a data security service that discovers sensitive data
# using machine learning and pattern matching, provides visibility into
# data security risks, and enables automated protection against those risks.
#
# This resource manages the Macie account configuration, including:
# - Enabling/disabling Macie for the AWS account
# - Configuring finding publication frequency to EventBridge and Security Hub
# - Managing the account status (ENABLED or PAUSED)
#
# Key Concepts:
# - Macie creates a service-linked role to monitor and analyze S3 data
# - Findings are automatically published to Amazon EventBridge
# - Optional publication to AWS Security Hub for centralized security monitoring
# - When enabled, Macie starts discovering sensitive data in S3 buckets
# - When paused, Macie retains findings but stops active monitoring
#
# Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_account
# https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html
# ============================================================

resource "aws_macie2_account" "example" {
  # ============================================================
  # Finding Publication Frequency
  # ============================================================
  # Specifies how often Macie publishes updates to policy findings.
  # Updates are sent to AWS Security Hub and Amazon EventBridge.
  #
  # Valid values:
  # - FIFTEEN_MINUTES: Publish every 15 minutes (most responsive)
  # - ONE_HOUR: Publish hourly (balanced approach)
  # - SIX_HOURS: Publish every 6 hours (reduced noise)
  #
  # Use cases:
  # - FIFTEEN_MINUTES: Real-time security monitoring, compliance requirements
  # - ONE_HOUR: Standard security operations with moderate alert frequency
  # - SIX_HOURS: Low-priority environments, cost optimization
  #
  # Note: This only affects policy findings. Sensitive data findings are
  # published immediately after processing, regardless of this setting.
  #
  # Default: Not set (uses AWS default behavior)
  # ============================================================
  finding_publishing_frequency = "FIFTEEN_MINUTES"

  # ============================================================
  # Account Status
  # ============================================================
  # Controls whether Macie is enabled and actively monitoring resources.
  #
  # Valid values:
  # - ENABLED: Activate Macie and start all monitoring activities
  # - PAUSED: Suspend Macie activities while retaining configuration
  #
  # When ENABLED:
  # - Macie discovers and classifies sensitive data in S3 buckets
  # - Policy findings are generated for security configuration issues
  # - Findings are published to EventBridge and optionally Security Hub
  # - Service-linked role performs automated data analysis
  # - Costs are incurred for active monitoring and data processing
  #
  # When PAUSED:
  # - All Macie activities are suspended
  # - No new findings are generated
  # - Existing findings are retained for 90 days (policy) or 30 days (sensitive data)
  # - Automated sensitive data discovery jobs are cancelled
  # - Configuration settings are preserved
  # - Reduced costs (only storage of existing data)
  #
  # Use cases for PAUSED:
  # - Temporary suspension during maintenance windows
  # - Cost optimization for non-production environments
  # - Troubleshooting or testing scenarios
  #
  # Default: Not set (Macie must be explicitly enabled)
  # ============================================================
  status = "ENABLED"

  # ============================================================
  # Region Configuration (Optional)
  # ============================================================
  # Specifies the AWS region where Macie will be managed.
  # If not specified, uses the region from provider configuration.
  #
  # Note: Macie is a regional service. Each region requires separate
  # configuration. For multi-region deployments, create separate
  # aws_macie2_account resources with different region settings.
  #
  # Example for explicit region:
  # region = "us-east-1"
  # ============================================================
  # region = "us-east-1"  # Uncomment to override provider region
}

# ============================================================
# Exported Attributes
# ============================================================
# The following attributes are exported and can be referenced:
#
# - id: Unique identifier of the Macie account
#   Example: "123456789012"
#
# - service_role: ARN of the service-linked role used by Macie
#   Example: "arn:aws:iam::123456789012:role/aws-service-role/macie.amazonaws.com/AWSServiceRoleForAmazonMacie"
#   This role allows Macie to monitor and analyze S3 data
#
# - created_at: Timestamp when the Macie account was created
#   Format: RFC 3339 (e.g., "2024-01-15T10:30:00Z")
#
# - updated_at: Timestamp of the most recent status change
#   Format: RFC 3339 (e.g., "2024-02-04T14:45:00Z")
#
# Usage example:
# output "macie_service_role" {
#   value       = aws_macie2_account.example.service_role
#   description = "ARN of the Macie service-linked role"
# }
# ============================================================

# ============================================================
# Integration with Other AWS Services
# ============================================================
# Amazon EventBridge:
# - Macie automatically publishes all findings to EventBridge
# - Create EventBridge rules to trigger automated responses
# - Example: Lambda function to remediate findings, SNS notifications
#
# AWS Security Hub:
# - Configure publication settings to send findings to Security Hub
# - Centralize security findings across multiple AWS services
# - Use Security Hub for compliance reporting and security posture management
#
# AWS Organizations:
# - Use aws_macie2_organization_admin_account to designate administrator
# - Manage Macie for up to 10,000 member accounts
# - Centralized configuration and finding aggregation
#
# Example EventBridge integration:
# resource "aws_cloudwatch_event_rule" "macie_findings" {
#   name        = "macie-findings"
#   description = "Capture Macie findings"
#
#   event_pattern = jsonencode({
#     source      = ["aws.macie"]
#     detail-type = ["Macie Finding"]
#   })
# }
# ============================================================

# ============================================================
# Cost Considerations
# ============================================================
# Macie pricing includes:
#
# 1. S3 Bucket Inventory:
#    - Charged per S3 bucket per month
#    - Continuous evaluation of bucket metadata and configurations
#
# 2. Sensitive Data Discovery:
#    - Charged per GB of data processed
#    - Applies to automated discovery and on-demand jobs
#    - Tiered pricing (lower cost for higher volumes)
#
# 3. Finding Events:
#    - No additional cost for publishing to EventBridge
#    - Standard EventBridge pricing applies for event processing
#
# Cost optimization tips:
# - Use PAUSED status for non-production environments when not needed
# - Configure finding_publishing_frequency to SIX_HOURS to reduce noise
# - Use S3 bucket filters to exclude non-sensitive data from discovery
# - Monitor usage in AWS Cost Explorer with service filter "Amazon Macie"
#
# Free trial:
# - 30-day free trial for new Macie accounts
# - Includes bucket inventory and automated sensitive data discovery
# ============================================================

# ============================================================
# Security Best Practices
# ============================================================
# 1. Enable Macie in all regions where S3 buckets contain sensitive data
# 2. Use finding_publishing_frequency = "FIFTEEN_MINUTES" for compliance environments
# 3. Integrate with Security Hub for centralized security monitoring
# 4. Create EventBridge rules to automate remediation of findings
# 5. Review and action on findings regularly
# 6. Use automated sensitive data discovery for comprehensive coverage
# 7. Configure suppression rules to reduce noise from expected findings
# 8. Enable Macie for all accounts in AWS Organizations for complete visibility
# 9. Monitor service-linked role permissions (managed by AWS)
# 10. Export findings to S3 for long-term retention and analysis
#
# Compliance frameworks supported:
# - PCI DSS (Payment Card Industry Data Security Standard)
# - HIPAA (Health Insurance Portability and Accountability Act)
# - GDPR (General Data Protection Regulation)
# - CCPA (California Consumer Privacy Act)
# ============================================================

# ============================================================
# Troubleshooting
# ============================================================
# Common issues and solutions:
#
# 1. "ConflictException: Macie is already enabled"
#    - Macie is already active in the account/region
#    - Import existing Macie account: terraform import aws_macie2_account.example <account-id>
#
# 2. "AccessDeniedException"
#    - IAM permissions missing for macie2:EnableMacie or macie2:UpdateMacieSession
#    - Ensure IAM role/user has appropriate Macie permissions
#
# 3. Findings not appearing in Security Hub
#    - Check finding publication settings in Macie console
#    - Verify Security Hub is enabled in the region
#    - Confirm EventBridge is not filtered or disabled
#
# 4. High costs
#    - Review automated sensitive data discovery settings
#    - Consider reducing finding_publishing_frequency
#    - Use PAUSED status when not actively monitoring
#    - Apply S3 bucket exclusions for non-sensitive data
#
# 5. Service-linked role issues
#    - Role is automatically created by Macie
#    - Do not manually delete or modify the role
#    - If deleted, disable and re-enable Macie to recreate
# ============================================================

# ============================================================
# Example: Complete Macie Setup with EventBridge Integration
# ============================================================
# resource "aws_macie2_account" "main" {
#   finding_publishing_frequency = "FIFTEEN_MINUTES"
#   status                       = "ENABLED"
# }
#
# # EventBridge rule to capture Macie findings
# resource "aws_cloudwatch_event_rule" "macie_findings" {
#   name        = "macie-high-severity-findings"
#   description = "Capture high severity Macie findings"
#
#   event_pattern = jsonencode({
#     source      = ["aws.macie"]
#     detail-type = ["Macie Finding"]
#     detail = {
#       severity = {
#         description = ["High"]
#       }
#     }
#   })
#
#   depends_on = [aws_macie2_account.main]
# }
#
# # SNS topic for notifications
# resource "aws_sns_topic" "macie_alerts" {
#   name = "macie-high-severity-alerts"
# }
#
# # EventBridge target to send to SNS
# resource "aws_cloudwatch_event_target" "sns" {
#   rule      = aws_cloudwatch_event_rule.macie_findings.name
#   target_id = "SendToSNS"
#   arn       = aws_sns_topic.macie_alerts.arn
# }
# ============================================================

# ============================================================
# Import Existing Macie Account
# ============================================================
# If Macie is already enabled in your AWS account, import it:
#
# terraform import aws_macie2_account.example <account-id>
#
# Example:
# terraform import aws_macie2_account.example 123456789012
#
# Note: The account ID must match the AWS account where Terraform is running
# ============================================================
