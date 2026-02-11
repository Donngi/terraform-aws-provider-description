# ==========================================
# Terraform Resource Template
# ==========================================
# Resource: aws_ec2_transit_gateway_default_route_table_propagation
# Provider: hashicorp/aws
# Version: 6.28.0
# Generated: 2026-01-22
#
# Purpose:
#   Manages the default route table propagation setting for an AWS EC2 Transit Gateway.
#   This resource allows you to set a specific route table as the default propagation
#   route table for a transit gateway, controlling which route table automatically
#   receives routes from transit gateway attachments when route propagation is enabled.
#
# Note:
#   This template is generated based on the AWS Provider schema and documentation
#   available at the time of generation. Always refer to the official Terraform
#   AWS Provider documentation for the most up-to-date information:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_default_route_table_propagation
#
# AWS Documentation:
#   - Transit Gateway Route Tables: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html
#   - Enable Route Propagation: https://docs.aws.amazon.com/vpc/latest/tgw/enable-tgw-route-propagation.html
# ==========================================

resource "aws_ec2_transit_gateway_default_route_table_propagation" "example" {
  # ==========================================
  # Required Arguments
  # ==========================================

  # transit_gateway_id - (Required) ID of the Transit Gateway to change the default propagation route table on.
  # Type: string
  #
  # This specifies the Transit Gateway resource for which you want to set the default propagation route table.
  # The Transit Gateway must exist before setting its default propagation route table.
  #
  # Example: "tgw-12345678901234567"
  transit_gateway_id = "tgw-12345678901234567"

  # transit_gateway_route_table_id - (Required) ID of the Transit Gateway Route Table to be made the default propagation route table.
  # Type: string
  #
  # This specifies which route table should be set as the default propagation route table for the transit gateway.
  # When enabled, transit gateway attachments will automatically propagate their routes to this route table.
  # The route table must be associated with the same transit gateway specified in transit_gateway_id.
  #
  # Example: "tgw-rtb-12345678901234567"
  transit_gateway_route_table_id = "tgw-rtb-12345678901234567"

  # ==========================================
  # Optional Arguments
  # ==========================================

  # region - (Optional) Region where this resource will be managed.
  # Type: string
  # Default: Uses the region set in the provider configuration
  #
  # Allows you to explicitly specify the AWS region where this resource will be managed.
  # If not specified, it defaults to the region configured in the AWS provider.
  # This is useful for multi-region deployments or when you need to manage resources
  # in a different region than the provider's default.
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # Example: "us-west-2"
  # region = "us-west-2"

  # ==========================================
  # Timeouts Configuration
  # ==========================================

  # timeouts - (Optional) Configuration block for operation timeouts.
  #
  # This nested block allows you to customize the timeout durations for create, update,
  # and delete operations. If not specified, default timeout values will be used.
  # Timeout values should be specified as a string that can be parsed as a duration,
  # consisting of numbers and unit suffixes such as "30s" or "2h45m".
  # Valid time units are "s" (seconds), "m" (minutes), "h" (hours).
  #
  # timeouts {
  #   # create - (Optional) Timeout for create operations.
  #   # Type: string
  #   # Default: Varies by resource (typically 10 minutes)
  #   # Example: "10m"
  #   create = "10m"
  #
  #   # update - (Optional) Timeout for update operations.
  #   # Type: string
  #   # Default: Varies by resource (typically 10 minutes)
  #   # Example: "10m"
  #   update = "10m"
  #
  #   # delete - (Optional) Timeout for delete operations.
  #   # Type: string
  #   # Default: Varies by resource (typically 10 minutes)
  #   # Note: Setting a timeout for Delete is only applicable if changes are saved
  #   #       into state before the destroy operation occurs.
  #   # Example: "10m"
  #   delete = "10m"
  # }
}

# ==========================================
# Computed Attributes (Read-Only)
# ==========================================
# The following attributes are exported by this resource and can be referenced
# in other resources or outputs, but cannot be set in the configuration:
#
# - id (string)
#   The Transit Gateway identifier.
#
# - original_default_route_table_id (string)
#   The ID of the original default propagation route table before this resource
#   made changes. This can be useful for tracking the previous configuration.
#
# Example usage in outputs:
# output "transit_gateway_id" {
#   value = aws_ec2_transit_gateway_default_route_table_propagation.example.id
# }
#
# output "previous_default_route_table" {
#   value = aws_ec2_transit_gateway_default_route_table_propagation.example.original_default_route_table_id
# }
# ==========================================

# ==========================================
# Usage Notes
# ==========================================
#
# 1. Default Propagation Behavior:
#    When you enable default route table propagation on a transit gateway, all new
#    attachments (VPC, VPN, Direct Connect Gateway, etc.) will automatically propagate
#    their routes to the specified default propagation route table.
#
# 2. Route Propagation vs. Route Association:
#    - Route Association: Determines which route table an attachment uses for routing decisions.
#    - Route Propagation: Determines which route tables receive routes from an attachment.
#    These are independent settings and can be configured separately.
#
# 3. Impact on Existing Attachments:
#    Changing the default propagation route table does not affect existing attachments.
#    It only affects new attachments created after the change.
#
# 4. Relationship with Transit Gateway:
#    This resource modifies a setting on an existing transit gateway. The transit gateway
#    itself must be created separately using the aws_ec2_transit_gateway resource.
#
# 5. Best Practices:
#    - Use this resource when you want centralized control over route propagation defaults.
#    - Consider using specific route table propagations (aws_ec2_transit_gateway_route_table_propagation)
#      for more granular control over individual attachments.
#    - Document your transit gateway routing strategy to ensure team members understand
#      the default propagation behavior.
#
# ==========================================
