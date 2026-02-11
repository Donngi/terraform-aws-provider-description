# ============================================================================
# AWS EC2 Transit Gateway Route Table Association
# ============================================================================
# Manages an EC2 Transit Gateway Route Table association.
#
# This resource associates a transit gateway attachment with a transit gateway
# route table, controlling how traffic is routed between VPCs, VPNs, Direct
# Connect gateways, and other attachments connected to the transit gateway.
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
#
# NOTE: This template represents the available configuration options as of the
# generation date. Always refer to the official documentation for the most
# up-to-date specifications:
# - Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association
# - AWS Transit Gateway: https://docs.aws.amazon.com/vpc/latest/tgw/
# ============================================================================

resource "aws_ec2_transit_gateway_route_table_association" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # transit_gateway_attachment_id (Required)
  # Identifier of the EC2 Transit Gateway Attachment to associate with the route table.
  # This can be a VPC attachment, VPN attachment, Direct Connect gateway attachment,
  # peering attachment, or Connect attachment.
  #
  # Example values:
  # - VPC attachment: aws_ec2_transit_gateway_vpc_attachment.example.id
  # - Direct Connect gateway: aws_dx_gateway_association.example.transit_gateway_attachment_id
  # - VPN attachment: aws_vpn_connection.example.transit_gateway_attachment_id
  # - Peering attachment: aws_ec2_transit_gateway_peering_attachment.example.id
  #
  # Reference: https://docs.aws.amazon.com/vpc/latest/tgw/associate-tgw-route-table.html
  transit_gateway_attachment_id = "tgw-attach-0123456789abcdef0"

  # transit_gateway_route_table_id (Required)
  # Identifier of the EC2 Transit Gateway Route Table to associate with the attachment.
  # The route table determines how traffic from the attachment is routed to other
  # attachments connected to the transit gateway.
  #
  # Example: aws_ec2_transit_gateway_route_table.example.id
  #
  # Reference: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html
  transit_gateway_route_table_id = "tgw-rtb-0123456789abcdef0"

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # replace_existing_association (Optional)
  # Boolean whether the Gateway Attachment should remove any current Route Table
  # association before associating with the specified Route Table.
  # Default: false
  #
  # Use this argument when working with EC2 Transit Gateways shared into the
  # current account. For transit gateways owned by the current account, use the
  # transit_gateway_default_route_table_association argument of the
  # aws_ec2_transit_gateway_vpc_attachment resource instead.
  #
  # Setting this to true is useful when:
  # - You need to reassociate an attachment from one route table to another
  # - The attachment is already associated with a different route table
  # - You're working with shared transit gateways where you can't modify the
  #   attachment's default association settings
  #
  # Type: bool
  # Default: false
  # replace_existing_association = false

  # region (Optional)
  # Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  #
  # Specify this when you need to create the association in a specific region
  # different from the provider's default region. This is particularly useful
  # in multi-region deployments or when managing cross-region resources.
  #
  # Type: string
  # Default: Provider's configured region
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # id (Optional, Computed)
  # The resource identifier. This is computed automatically as a combination of
  # the transit gateway route table ID and the transit gateway attachment ID.
  # You typically don't need to set this manually.
  #
  # Format: "<transit_gateway_route_table_id>_<transit_gateway_attachment_id>"
  #
  # Type: string
  # Computed: true
  # id = null
}

# ============================================================================
# Exported Attributes (Read-Only)
# ============================================================================
# These attributes are exported by the resource and can be referenced in other
# resources or outputs, but cannot be set directly in the configuration.
#
# - id: EC2 Transit Gateway Route Table identifier combined with EC2 Transit
#       Gateway Attachment identifier
#       Format: "tgw-rtb-xxx_tgw-attach-yyy"
#
# - resource_id: Identifier of the resource associated with the attachment
#       Example: VPC ID (vpc-xxx) for VPC attachments
#
# - resource_type: Type of the resource associated with the attachment
#       Possible values: vpc, vpn, vpn-concentrator, direct-connect-gateway,
#       connect, peering, tgw-peering
#
# Reference: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_TransitGatewayAssociation.html
# ============================================================================

# ============================================================================
# Usage Examples
# ============================================================================

# Example 1: VPC Attachment Association
# Associates a transit gateway VPC attachment with a route table
/*
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_ec2_transit_gateway" "example" {
  description = "example"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  subnet_ids         = [aws_subnet.example.id]
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = aws_vpc.example.id
}

resource "aws_ec2_transit_gateway_route_table" "example" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id
}

resource "aws_ec2_transit_gateway_route_table_association" "example" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.example.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
}
*/

# Example 2: Direct Connect Gateway Association
# Associates a Direct Connect gateway attachment with a route table
/*
resource "aws_dx_gateway" "example" {
  name            = "example"
  amazon_side_asn = 64512
}

resource "aws_ec2_transit_gateway" "example" {
  description = "example"
}

resource "aws_dx_gateway_association" "example" {
  dx_gateway_id         = aws_dx_gateway.example.id
  associated_gateway_id = aws_ec2_transit_gateway.example.id

  allowed_prefixes = [
    "10.0.0.0/16",
  ]
}

resource "aws_ec2_transit_gateway_route_table" "example" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id
}

resource "aws_ec2_transit_gateway_route_table_association" "example" {
  transit_gateway_attachment_id  = aws_dx_gateway_association.example.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
}
*/

# ============================================================================
# Important Notes
# ============================================================================
# 1. Each transit gateway attachment can be associated with only one route table
#    at a time. Attempting to create multiple associations for the same attachment
#    will result in an error unless replace_existing_association is set to true.
#
# 2. The association controls which route table is used to route traffic from
#    the attachment. Different attachments can be associated with different
#    route tables, enabling flexible routing scenarios.
#
# 3. For transit gateways created with default_route_table_association_enabled
#    set to true (the default), attachments are automatically associated with
#    the default route table. Use this resource to override that behavior.
#
# 4. When working with shared transit gateways (cross-account), you may need
#    to use replace_existing_association = true to change the route table
#    association, as you won't have permission to modify the attachment's
#    default association settings.
#
# 5. The resource_id and resource_type attributes provide information about
#    the underlying resource (e.g., VPC ID and "vpc" for VPC attachments),
#    which can be useful for tracking and auditing purposes.
#
# Reference: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html
# ============================================================================
