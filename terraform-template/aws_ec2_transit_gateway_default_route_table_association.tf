# ==============================================================================
# Terraform AWS Provider Resource Template
# ==============================================================================
# Resource: aws_ec2_transit_gateway_default_route_table_association
# Provider Version: 6.28.0
# Generated: 2026-01-22
#
# Description:
#   Terraform resource for managing an AWS EC2 (Elastic Compute Cloud) Transit
#   Gateway Default Route Table Association. This resource manages the default
#   association route table for a Transit Gateway.
#
# Important Notes:
#   - This template is generated based on the AWS Provider version 6.28.0
#   - Always refer to the official documentation for the latest specifications
#   - Computed-only attributes (id, original_default_route_table_id) are
#     excluded from this template as they cannot be set
#
# AWS Documentation:
#   - Transit Gateway: https://docs.aws.amazon.com/vpc/latest/tgw/how-transit-gateways-work.html
#   - Route Table Association: https://docs.aws.amazon.com/vpc/latest/tgw/how-transit-gateways-work.html#tgw-route-table-association-overview
#
# Terraform Registry:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_default_route_table_association
# ==============================================================================

resource "aws_ec2_transit_gateway_default_route_table_association" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # transit_gateway_id - (Required) ID of the Transit Gateway to change the
  # default association route table on.
  #
  # The Transit Gateway acts as a Regional virtual router for traffic flowing
  # between your VPCs and on-premises networks. By default, a Transit Gateway
  # comes with a default route table. This resource allows you to change which
  # route table is used as the default association route table.
  #
  # Type: string
  # Example: "tgw-0123456789abcdef0"
  transit_gateway_id = "tgw-0123456789abcdef0"

  # transit_gateway_route_table_id - (Required) ID of the Transit Gateway Route
  # Table to be made the default association route table.
  #
  # When you create a Transit Gateway, it automatically comes with a default
  # route table. You can create additional route tables to isolate subsets of
  # attachments. This argument specifies which route table should be used as
  # the default association route table for new attachments.
  #
  # Each attachment can be associated with one route table. When an attachment
  # is created without specifying a route table association, it will be
  # associated with the default association route table.
  #
  # Type: string
  # Example: "tgw-rtb-0123456789abcdef0"
  transit_gateway_route_table_id = "tgw-rtb-0123456789abcdef0"

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # region - (Optional) Region where this resource will be managed. Defaults
  # to the Region set in the provider configuration.
  #
  # This allows you to explicitly specify the AWS region for this resource,
  # overriding the provider-level region setting. This is useful when managing
  # resources across multiple regions.
  #
  # Type: string
  # Example: "us-west-2"
  # Default: Provider region configuration
  # AWS Regional Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  # ============================================================================
  # Timeouts Block (Optional)
  # ============================================================================
  # Configures custom timeout values for resource operations. All timeout
  # values are strings that can be parsed as durations consisting of numbers
  # and unit suffixes such as "30s" or "2h45m". Valid time units are "s"
  # (seconds), "m" (minutes), "h" (hours).
  # ============================================================================

  # timeouts {
  #   # create - (Optional) Maximum time to wait for the default route table
  #   # association to be created.
  #   # Default: Terraform's default timeout
  #   # Example: "10m"
  #   create = "10m"
  #
  #   # update - (Optional) Maximum time to wait for the default route table
  #   # association to be updated.
  #   # Default: Terraform's default timeout
  #   # Example: "10m"
  #   update = "10m"
  #
  #   # delete - (Optional) Maximum time to wait for the default route table
  #   # association to be deleted. Setting a timeout for a Delete operation is
  #   # only applicable if changes are saved into state before the destroy
  #   # operation occurs.
  #   # Default: Terraform's default timeout
  #   # Example: "10m"
  #   delete = "10m"
  # }
}

# ==============================================================================
# Computed Attributes (Read-Only)
# ==============================================================================
# The following attributes are exported by this resource but cannot be set:
#
# - id: Resource identifier in the format:
#       <transit_gateway_id>_<transit_gateway_route_table_id>
#
# - original_default_route_table_id: ID of the original default association
#       route table before this resource was applied
#
# These can be referenced in other resources using:
#   aws_ec2_transit_gateway_default_route_table_association.example.id
#   aws_ec2_transit_gateway_default_route_table_association.example.original_default_route_table_id
# ==============================================================================

# ==============================================================================
# Usage Notes
# ==============================================================================
# 1. This resource changes the default association route table for a Transit
#    Gateway. When attachments are created without specifying a route table
#    association, they will use this default route table.
#
# 2. The original_default_route_table_id attribute contains the ID of the
#    previous default route table, which can be useful for restoration or
#    reference purposes.
#
# 3. Each Transit Gateway can have only one default association route table
#    at a time. Creating this resource will change the current default.
#
# 4. If you destroy this resource, Terraform will attempt to revert the
#    default association route table to the original default route table that
#    was in place when the resource was created.
#
# 5. Route table association is different from route propagation:
#    - Association: Determines which route table an attachment uses to route
#      traffic
#    - Propagation: Allows routes from an attachment to be installed in a
#      route table
#
# 6. For more information about Transit Gateway routing, see:
#    https://docs.aws.amazon.com/vpc/latest/tgw/how-transit-gateways-work.html#tgw-routing-overview
# ==============================================================================

# ==============================================================================
# Example: Basic Usage
# ==============================================================================
# resource "aws_ec2_transit_gateway" "example" {
#   description = "example"
# }
#
# resource "aws_ec2_transit_gateway_route_table" "example" {
#   transit_gateway_id = aws_ec2_transit_gateway.example.id
# }
#
# resource "aws_ec2_transit_gateway_default_route_table_association" "example" {
#   transit_gateway_id             = aws_ec2_transit_gateway.example.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
# }
# ==============================================================================
