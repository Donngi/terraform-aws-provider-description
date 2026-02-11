################################################################################
# AWS Security Hub Finding Aggregator
################################################################################
# Manages a Security Hub finding aggregator. Security Hub needs to be enabled
# in a region in order for the aggregator to pull through findings.
#
# This resource allows you to configure cross-region aggregation of Security Hub
# findings, enabling centralized security monitoring across multiple AWS regions.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/securityhub_finding_aggregator
################################################################################

resource "aws_securityhub_finding_aggregator" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) Indicates whether to aggregate findings from all of the available
  # Regions or from a specified list.
  #
  # Valid values:
  # - "ALL_REGIONS": Aggregate findings from all AWS regions
  # - "ALL_REGIONS_EXCEPT_SPECIFIED": Aggregate from all regions except those
  #   specified in specified_regions
  # - "SPECIFIED_REGIONS": Only aggregate from regions specified in specified_regions
  # - "NO_REGIONS": Do not aggregate findings from any regions
  #
  # Note: When using ALL_REGIONS_EXCEPT_SPECIFIED or SPECIFIED_REGIONS, you must
  # also provide the specified_regions argument.
  linking_mode = "ALL_REGIONS"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) A set of Regions to include or exclude from finding aggregation,
  # based on the linking_mode value.
  #
  # - Required when linking_mode is "ALL_REGIONS_EXCEPT_SPECIFIED" or "SPECIFIED_REGIONS"
  # - Not used when linking_mode is "ALL_REGIONS" or "NO_REGIONS"
  #
  # Type: set(string)
  # Example: ["eu-west-1", "eu-west-2", "us-west-2"]
  #
  # specified_regions = ["eu-west-1", "eu-west-2"]

  # (Optional) Region where this resource will be managed.
  #
  # If not specified, defaults to the Region set in the provider configuration.
  # The aggregator must be created in the Security Hub delegated administrator
  # account or in the organization management account.
  #
  # Type: string
  # Example: "us-east-1"
  #
  # region = "us-east-1"

  ################################################################################
  # Dependencies
  ################################################################################

  # Ensure Security Hub is enabled before creating the aggregator
  # depends_on = [aws_securityhub_account.example]
}

################################################################################
# Attribute Reference
################################################################################
# In addition to all arguments above, the following attributes are exported:
#
# - id: AWS Region where the finding aggregator is configured
# - arn: Amazon Resource Name (ARN) of the Security Hub finding aggregator

################################################################################
# Example Configurations
################################################################################

# Example 1: All Regions Aggregation
# resource "aws_securityhub_account" "example" {}
#
# resource "aws_securityhub_finding_aggregator" "all_regions" {
#   linking_mode = "ALL_REGIONS"
#
#   depends_on = [aws_securityhub_account.example]
# }

# Example 2: All Regions Except Specified
# resource "aws_securityhub_account" "example" {}
#
# resource "aws_securityhub_finding_aggregator" "except_eu" {
#   linking_mode      = "ALL_REGIONS_EXCEPT_SPECIFIED"
#   specified_regions = ["eu-west-1", "eu-west-2"]
#
#   depends_on = [aws_securityhub_account.example]
# }

# Example 3: Specified Regions Only
# resource "aws_securityhub_account" "example" {}
#
# resource "aws_securityhub_finding_aggregator" "eu_only" {
#   linking_mode      = "SPECIFIED_REGIONS"
#   specified_regions = ["eu-west-1", "eu-west-2"]
#
#   depends_on = [aws_securityhub_account.example]
# }

# Example 4: No Regions (Disable Aggregation)
# resource "aws_securityhub_account" "example" {}
#
# resource "aws_securityhub_finding_aggregator" "disabled" {
#   linking_mode = "NO_REGIONS"
#
#   depends_on = [aws_securityhub_account.example]
# }

################################################################################
# Important Notes
################################################################################
# 1. Security Hub must be enabled in the region where you create the aggregator
#    before the aggregator can pull findings
#
# 2. The finding aggregator must be created in the Security Hub delegated
#    administrator account or in the organization management account
#
# 3. When you create a finding aggregator, it immediately starts aggregating
#    findings from the linked regions
#
# 4. Only one finding aggregator can exist per region in an account
#
# 5. When changing linking_mode from ALL_REGIONS to SPECIFIED_REGIONS or
#    ALL_REGIONS_EXCEPT_SPECIFIED, you must also provide specified_regions
#
# 6. Cross-region data transfer charges may apply when aggregating findings
#    across regions

################################################################################
# Related Resources
################################################################################
# - aws_securityhub_account: Enable Security Hub in an account
# - aws_securityhub_organization_admin_account: Designate Security Hub admin account
# - aws_securityhub_organization_configuration: Configure Security Hub org settings
# - aws_securityhub_standards_subscription: Subscribe to Security Hub standards
