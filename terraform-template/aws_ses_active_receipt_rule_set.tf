################################################################################
# AWS SES Active Receipt Rule Set
# Terraform Resource: aws_ses_active_receipt_rule_set
# Provider Version: 6.28.0
#
# Description:
#   Provides a resource to designate the active SES receipt rule set. This resource
#   sets which receipt rule set should be active for processing incoming emails.
#   Only one receipt rule set can be active at a time.
#
# Resource Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ses_active_receipt_rule_set
#
# AWS Service Documentation:
#   https://docs.aws.amazon.com/ses/latest/dg/receiving-email-receipt-rules.html
################################################################################

resource "aws_ses_active_receipt_rule_set" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # rule_set_name - (Required) The name of the rule set
  # Type: string
  #
  # The name of the receipt rule set to activate. This must be an existing
  # receipt rule set that has already been created in the account.
  rule_set_name = "primary-rules"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # region - (Optional) Region where this resource will be managed
  # Type: string
  # Default: Uses the region from the provider configuration
  #
  # Specifies the AWS region where this resource will be managed.
  # Defaults to the region set in the provider configuration.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################

  # These attributes are computed by AWS and available after resource creation:
  #
  # - id  : The SES receipt rule set name (string)
  # - arn : The SES receipt rule set ARN (string)
  #         Example: arn:aws:ses:us-east-1:123456789012:receipt-rule-set/primary-rules

  ################################################################################
  # Notes and Best Practices
  ################################################################################

  # 1. Prerequisites:
  #    - The receipt rule set specified in rule_set_name must already exist
  #    - Create rule sets using aws_ses_receipt_rule_set resource
  #
  # 2. Active Rule Set:
  #    - Only one receipt rule set can be active at a time
  #    - Setting a new active rule set will automatically deactivate the previous one
  #
  # 3. Email Receiving:
  #    - SES must be configured to receive emails in the specified region
  #    - Verify that MX records are properly configured for your domain
  #
  # 4. Region Considerations:
  #    - SES email receiving is only available in certain regions
  #    - Check AWS documentation for supported regions
  #
  # 5. Lifecycle:
  #    - Destroying this resource deactivates the rule set but doesn't delete it
  #    - The underlying rule set remains available for reactivation
}

################################################################################
# Example Usage Patterns
################################################################################

# Example 1: Basic active receipt rule set
# resource "aws_ses_active_receipt_rule_set" "main" {
#   rule_set_name = "production-rules"
# }

# Example 2: With explicit region specification
# resource "aws_ses_active_receipt_rule_set" "regional" {
#   rule_set_name = "eu-production-rules"
#   region        = "eu-west-1"
# }

# Example 3: With dependent rule set creation
# resource "aws_ses_receipt_rule_set" "main" {
#   rule_set_name = "my-rule-set"
# }
#
# resource "aws_ses_active_receipt_rule_set" "main" {
#   rule_set_name = aws_ses_receipt_rule_set.main.rule_set_name
# }

################################################################################
# Related Resources
################################################################################

# - aws_ses_receipt_rule_set    : Create and manage receipt rule sets
# - aws_ses_receipt_rule        : Define individual receipt rules
# - aws_ses_receipt_filter      : Create IP address filters
# - aws_ses_domain_identity     : Verify domains for SES
# - aws_ses_email_identity      : Verify email addresses for SES

################################################################################
# Outputs Example
################################################################################

# output "active_rule_set_id" {
#   description = "The name of the active receipt rule set"
#   value       = aws_ses_active_receipt_rule_set.example.id
# }
#
# output "active_rule_set_arn" {
#   description = "The ARN of the active receipt rule set"
#   value       = aws_ses_active_receipt_rule_set.example.arn
# }
