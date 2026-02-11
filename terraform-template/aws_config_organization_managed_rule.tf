# =============================================================================
# AWS Config Organization Managed Rule - Annotated Template
# =============================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# NOTE: This template was generated at a specific point in time and may not
# reflect the latest specifications. Always refer to the official Terraform
# AWS Provider documentation for the most up-to-date information:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_organization_managed_rule
# =============================================================================

# Manages a Config Organization Managed Rule. These rules enable centralized
# compliance monitoring across all accounts in your AWS Organization.
#
# IMPORTANT NOTES:
# - This resource must be created in the Organization management account
# - Rules will include the management account unless its ID is added to excluded_accounts
# - Every Organization account (except excluded ones) must have a Configuration Recorder
#   with proper IAM permissions before the rule will successfully create or update
#
# AWS Documentation:
# - Multi-account deployment: https://docs.aws.amazon.com/config/latest/developerguide/config-rule-multi-account-deployment.html
# - AWS Config Managed Rules: https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_use-managed-rules.html
# - List of available managed rules: https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html

resource "aws_config_organization_managed_rule" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # (Required) The name of the rule
  # - Must be unique within your organization
  # - Used to identify and manage the rule
  name = "example-org-managed-rule"

  # (Required) Identifier of an available AWS Config Managed Rule to call
  # - Specifies which AWS managed rule to deploy across the organization
  # - For available values, see: https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html
  # - Examples: "IAM_PASSWORD_POLICY", "S3_BUCKET_PUBLIC_READ_PROHIBITED", "EC2_INSTANCE_MANAGED_BY_SSM"
  rule_identifier = "IAM_PASSWORD_POLICY"

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # (Optional) Description of the rule
  # - Human-readable explanation of what the rule evaluates
  # - Helps team members understand the rule's purpose
  description = "Ensures IAM password policies meet organizational security requirements"

  # (Optional) List of AWS account identifiers to exclude from the rule
  # - Accounts specified here will not have this rule applied
  # - Useful for test accounts or accounts with special requirements
  # - Format: List of 12-digit AWS account IDs
  # - Note: The management account is included by default unless excluded here
  excluded_accounts = [
    # "123456789012",
    # "234567890123"
  ]

  # (Optional) A string in JSON format that is passed to the AWS Config Rule Lambda Function
  # - Provides parameters specific to the managed rule
  # - Each managed rule has different parameter requirements
  # - Must be valid JSON format
  # - Refer to the specific rule's documentation for required/optional parameters
  # - Example for IAM_PASSWORD_POLICY:
  #   {"RequireUppercaseCharacters":"true","RequireLowercaseCharacters":"true","RequireSymbols":"true","RequireNumbers":"true","MinimumPasswordLength":"14","PasswordReusePrevention":"24","MaxPasswordAge":"90"}
  input_parameters = jsonencode({
    RequireUppercaseCharacters = "true"
    RequireLowercaseCharacters = "true"
    RequireSymbols             = "true"
    RequireNumbers             = "true"
    MinimumPasswordLength      = "14"
    PasswordReusePrevention    = "24"
    MaxPasswordAge             = "90"
  })

  # (Optional) The maximum frequency with which AWS Config runs evaluations for a rule
  # - Only applies if the rule is triggered at a periodic frequency
  # - Defaults to "TwentyFour_Hours" for periodic frequency triggered rules
  # - Valid values:
  #   - "One_Hour"          : Evaluate every hour
  #   - "Three_Hours"       : Evaluate every 3 hours
  #   - "Six_Hours"         : Evaluate every 6 hours
  #   - "Twelve_Hours"      : Evaluate every 12 hours
  #   - "TwentyFour_Hours"  : Evaluate every 24 hours (default)
  # - Not all managed rules support all frequencies; check rule documentation
  # maximum_execution_frequency = "TwentyFour_Hours"

  # (Optional) Identifier of the AWS resource to evaluate
  # - Limits the rule to evaluate only a specific resource by its ID
  # - Use when you want to target a single resource instance
  # - Example: "i-1234567890abcdef0" for an EC2 instance
  # - Cannot be used with resource_types_scope
  # resource_id_scope = "i-1234567890abcdef0"

  # (Optional) List of types of AWS resources to evaluate
  # - Limits the rule to evaluate only specific resource types
  # - Format: AWS resource type identifiers (e.g., "AWS::EC2::Instance", "AWS::S3::Bucket")
  # - Cannot be used with resource_id_scope
  # - Example:
  resource_types_scope = [
    # "AWS::IAM::User",
    # "AWS::IAM::Role"
  ]

  # (Optional) Tag key of AWS resources to evaluate
  # - Filters evaluation to resources with a specific tag key
  # - Required if tag_value_scope is configured
  # - Use to target resources based on tagging strategy
  # - Example: "Environment", "CostCenter", "Owner"
  # tag_key_scope = "Environment"

  # (Optional) Tag value of AWS resources to evaluate
  # - Further filters evaluation to resources with a specific tag key-value pair
  # - Must be used in conjunction with tag_key_scope
  # - Example: "Production", "Development", "Staging"
  # tag_value_scope = "Production"

  # (Optional) Region where this resource will be managed
  # - Specifies the AWS region for rule deployment
  # - Defaults to the region set in the provider configuration
  # - Useful for multi-region organizations
  # - See: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ============================================================================
  # Timeouts Block (Optional)
  # ============================================================================
  # Configure custom timeouts for resource operations
  # Useful for organizations with many accounts where propagation takes longer

  # timeouts {
  #   # (Optional) Timeout for creating the rule (default: 5 minutes)
  #   create = "10m"
  #
  #   # (Optional) Timeout for updating the rule (default: 5 minutes)
  #   update = "10m"
  #
  #   # (Optional) Timeout for deleting the rule (default: 5 minutes)
  #   delete = "10m"
  # }
}

# =============================================================================
# Attributes Reference
# =============================================================================
# In addition to all arguments above, the following attributes are exported:
#
# - arn: Amazon Resource Name (ARN) of the rule
#        Format: arn:aws:config:region:account-id:organization-config-rule/rule-name
#
# Example usage of exported attributes:
# output "rule_arn" {
#   description = "The ARN of the Config Organization Managed Rule"
#   value       = aws_config_organization_managed_rule.example.arn
# }

# =============================================================================
# Import
# =============================================================================
# Config Organization Managed Rules can be imported using the rule name:
# terraform import aws_config_organization_managed_rule.example example-org-managed-rule

# =============================================================================
# Additional Resources
# =============================================================================
# Related Terraform Resources:
# - aws_config_organization_custom_rule: For custom Lambda-based rules
# - aws_config_configuration_recorder: Required in each account for rules to work
# - aws_organizations_organization: Organization must have config-multiaccountsetup.amazonaws.com enabled
#
# AWS Config API Reference:
# - PutOrganizationConfigRule: https://docs.aws.amazon.com/config/latest/APIReference/API_PutOrganizationConfigRule.html
# - OrganizationManagedRuleMetadata: https://docs.aws.amazon.com/config/latest/APIReference/API_OrganizationManagedRuleMetadata.html
