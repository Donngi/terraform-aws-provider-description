################################################################################
# aws_securityhub_configuration_policy_association
################################################################################
# Manages Security Hub configuration policy associations.
#
# NOTE: This resource requires `aws_securityhub_organization_configuration` to be
# configured with type `CENTRAL`. More information about Security Hub central
# configuration and configuration policies can be found in the How Security Hub
# configuration policies work documentation.
#
# Provider Version: 6.28.0
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_configuration_policy_association
################################################################################

resource "aws_securityhub_configuration_policy_association" "this" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) The universally unique identifier (UUID) of the configuration policy.
  # Type: string
  # Example: aws_securityhub_configuration_policy.example.id
  policy_id = null

  # (Required, Forces new resource) The identifier of the target account,
  # organizational unit, or the root to associate with the specified configuration.
  # Type: string
  # Valid values:
  #   - AWS Account ID (e.g., "123456789012")
  #   - Organizational Unit ID (e.g., "ou-abcd-12345678")
  #   - Root ID (e.g., "r-abcd")
  target_id = null

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string
  # Example: "us-east-1"
  # region = null

  ################################################################################
  # Read-Only Attributes (Computed)
  ################################################################################

  # id - The identifier of the target account, organizational unit, or the root
  #      that is associated with the configuration.
}

################################################################################
# Example Usage
################################################################################

# Example: Associate configuration policy with an AWS account
# resource "aws_securityhub_configuration_policy_association" "account_example" {
#   target_id = "123456789012"
#   policy_id = aws_securityhub_configuration_policy.example.id
# }

# Example: Associate configuration policy with organization root
# resource "aws_securityhub_configuration_policy_association" "root_example" {
#   target_id = "r-abcd"
#   policy_id = aws_securityhub_configuration_policy.example.id
# }

# Example: Associate configuration policy with organizational unit
# resource "aws_securityhub_configuration_policy_association" "ou_example" {
#   target_id = "ou-abcd-12345678"
#   policy_id = aws_securityhub_configuration_policy.example.id
# }

################################################################################
# Complete Example with Dependencies
################################################################################

# resource "aws_securityhub_finding_aggregator" "example" {
#   linking_mode = "ALL_REGIONS"
# }
#
# resource "aws_securityhub_organization_configuration" "example" {
#   auto_enable           = false
#   auto_enable_standards = "NONE"
#   organization_configuration {
#     configuration_type = "CENTRAL"
#   }
#
#   depends_on = [aws_securityhub_finding_aggregator.example]
# }
#
# resource "aws_securityhub_configuration_policy" "example" {
#   name        = "Example"
#   description = "This is an example configuration policy"
#
#   configuration_policy {
#     service_enabled = true
#     enabled_standard_arns = [
#       "arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0",
#       "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0",
#     ]
#     security_controls_configuration {
#       disabled_control_identifiers = []
#     }
#   }
#
#   depends_on = [aws_securityhub_organization_configuration.example]
# }
#
# resource "aws_securityhub_configuration_policy_association" "account_example" {
#   target_id = "123456789012"
#   policy_id = aws_securityhub_configuration_policy.example.id
# }
