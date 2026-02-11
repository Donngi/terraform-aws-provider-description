#================================================
# AWS EC2 Transit Gateway Route
#================================================
# Manages an EC2 Transit Gateway Route.
# Transit Gateway routes enable network traffic to be routed between different
# VPCs, VPN connections, Direct Connect gateways, and peering connections
# attached to a Transit Gateway.
#
# Provider Version: 6.28.0
# Official Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route
#================================================

resource "aws_ec2_transit_gateway_route" "example" {
  #================================================
  # Required Parameters
  #================================================

  # IPv4 or IPv6 RFC1924 CIDR used for destination matches
  # Routing decisions are based on the most specific match
  # 宛先のIPv4またはIPv6 CIDR
  # ルーティング決定は最も具体的な一致に基づいて行われます
  # Type: string
  # Example: "10.0.0.0/16", "0.0.0.0/0", "2001:db8::/32"
  destination_cidr_block = "0.0.0.0/0"

  # Identifier of EC2 Transit Gateway Route Table
  # The route table where this route will be created
  # このルートが作成されるTransit Gatewayルートテーブルの識別子
  # Type: string
  # Example: "tgw-rtb-1234567890abcdef0"
  transit_gateway_route_table_id = aws_ec2_transit_gateway.example.association_default_route_table_id

  #================================================
  # Optional Parameters
  #================================================

  # Identifier of EC2 Transit Gateway Attachment
  # Required if blackhole is set to false
  # The attachment through which traffic matching this route will be routed
  # Transit Gatewayアタッチメントの識別子
  # blackholeがfalseの場合は必須です
  # Type: string
  # Example: "tgw-attach-1234567890abcdef0"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.example.id

  # Indicates whether to drop traffic that matches this route
  # When true, traffic matching this route will be discarded (blackhole route)
  # When false, traffic will be forwarded to the specified attachment
  # このルートに一致するトラフィックをドロップするかどうかを示します
  # trueの場合、トラフィックは破棄されます（ブラックホールルート）
  # falseの場合、指定されたアタッチメントに転送されます
  # Type: bool
  # Default: false
  # Example: true (for blackhole routes)
  # blackhole = false

  # Region where this resource will be managed
  # Defaults to the Region set in the provider configuration
  # このリソースが管理されるリージョン
  # プロバイダー設定で設定されたリージョンがデフォルトとなります
  # Type: string
  # Example: "us-west-2"
  # region = null

  #================================================
  # Read-Only Attributes
  #================================================
  # id: EC2 Transit Gateway Route Table identifier combined with destination
  #     Format: "<transit_gateway_route_table_id>_<destination_cidr_block>"
  #     Example: "tgw-rtb-1234567890abcdef0_10.0.0.0/16"
}

#================================================
# Example: Standard Route Configuration
#================================================
# This example creates a standard route that forwards traffic
# to a specific Transit Gateway VPC attachment
#
# resource "aws_ec2_transit_gateway_route" "standard_route" {
#   destination_cidr_block         = "10.1.0.0/16"
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc1.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
# }

#================================================
# Example: Blackhole Route Configuration
#================================================
# This example creates a blackhole route that drops all traffic
# matching the destination CIDR
#
# resource "aws_ec2_transit_gateway_route" "blackhole_route" {
#   destination_cidr_block         = "10.2.0.0/16"
#   blackhole                      = true
#   transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
# }

#================================================
# Example: Default Route to Internet
#================================================
# This example creates a default route (0.0.0.0/0) that forwards
# internet-bound traffic through a specific attachment
#
# resource "aws_ec2_transit_gateway_route" "internet_route" {
#   destination_cidr_block         = "0.0.0.0/0"
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress_vpc.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
# }

#================================================
# Example: IPv6 Route Configuration
#================================================
# This example creates an IPv6 route
#
# resource "aws_ec2_transit_gateway_route" "ipv6_route" {
#   destination_cidr_block         = "2001:db8::/32"
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.ipv6_vpc.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
# }

#================================================
# Important Notes
#================================================
# 1. Route Priority: Routing decisions are based on the most specific match
#    (longest prefix match). More specific CIDR blocks take precedence over
#    less specific ones.
#
# 2. Blackhole Routes: When blackhole is set to true, the
#    transit_gateway_attachment_id parameter must not be specified.
#    Conversely, when blackhole is false (or not set),
#    transit_gateway_attachment_id is required.
#
# 3. Attachment Types: The transit_gateway_attachment_id can reference:
#    - VPC attachments (aws_ec2_transit_gateway_vpc_attachment)
#    - VPN attachments (aws_vpn_connection)
#    - Direct Connect Gateway attachments (aws_dx_gateway_association)
#    - Transit Gateway peering attachments (aws_ec2_transit_gateway_peering_attachment)
#
# 4. Route Table Association: Before creating routes, ensure that the
#    attachments are properly associated with the Transit Gateway route table.
#
# 5. CIDR Overlap: You cannot create multiple routes with the exact same
#    destination_cidr_block in the same route table. Each destination must
#    be unique within a route table.
#
# 6. IPv4 and IPv6: This resource supports both IPv4 (e.g., "10.0.0.0/16")
#    and IPv6 (e.g., "2001:db8::/32") CIDR blocks.
#
# 7. Default Routes: You can create a default route using "0.0.0.0/0" for
#    IPv4 or "::/0" for IPv6, which will match all traffic not matched by
#    more specific routes.
#
# 8. Route Propagation: This resource creates static routes. For dynamic
#    route propagation, use aws_ec2_transit_gateway_route_table_propagation
#    instead.
#
# 9. Deletion: When destroying this resource, the route will be removed
#    from the Transit Gateway route table. Ensure no critical traffic
#    depends on this route before deletion.
#
# 10. Cross-Region: Transit Gateway routes are region-specific. For
#     cross-region routing, you need to use Transit Gateway peering
#     attachments.

#================================================
# Related Resources
#================================================
# - aws_ec2_transit_gateway: The Transit Gateway itself
# - aws_ec2_transit_gateway_route_table: Route tables for Transit Gateway
# - aws_ec2_transit_gateway_vpc_attachment: Attach VPCs to Transit Gateway
# - aws_ec2_transit_gateway_route_table_association: Associate attachments with route tables
# - aws_ec2_transit_gateway_route_table_propagation: Enable dynamic route propagation
# - aws_vpn_connection: VPN attachments for Transit Gateway
# - aws_ec2_transit_gateway_peering_attachment: Peering between Transit Gateways
