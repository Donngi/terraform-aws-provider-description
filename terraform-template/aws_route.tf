################################################################################
# AWS Route
################################################################################
# Provider Version: 6.28.0
# Resource: aws_route
#
# Description:
# Provides a resource to create a routing table entry (a route) in a VPC routing table.
#
# Important Notes:
# - Terraform currently provides both a standalone Route resource (aws_route) and
#   a Route Table resource with routes defined in-line (aws_route_table). You cannot
#   use aws_route_table inline route blocks in conjunction with any aws_route resources.
#   Doing so will cause a conflict of rule settings and will overwrite rules.
#
# - The AWS API is very forgiving with the resource ID passed in the gateway_id attribute.
#   For example, an aws_route resource can be created with an aws_nat_gateway or
#   aws_egress_only_internet_gateway ID specified for the gateway_id attribute.
#   Specifying anything other than an aws_internet_gateway or aws_vpn_gateway ID
#   will lead to Terraform reporting a permanent diff between your configuration
#   and recorded state, as the AWS API returns the more-specific attribute.
#
# - To associate a Gateway VPC Endpoint (such as S3) with destination prefix list,
#   use the aws_vpc_endpoint_route_table_association resource instead of combining
#   vpc_endpoint_id and destination_prefix_list_id attributes.
#
# AWS Documentation:
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
################################################################################

resource "aws_route" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) The ID of the routing table.
  # Type: string
  # Example: "rtb-12345678"
  route_table_id = "rtb-example123"

  ################################################################################
  # Destination Arguments (One Required)
  ################################################################################
  # You must specify exactly ONE of the following destination arguments:
  # - destination_cidr_block
  # - destination_ipv6_cidr_block
  # - destination_prefix_list_id

  # (Optional) The destination CIDR block.
  # Type: string
  # Example: "10.0.1.0/24"
  # Use this for IPv4 traffic routing
  destination_cidr_block = "10.0.1.0/22"

  # (Optional) The destination IPv6 CIDR block.
  # Type: string
  # Example: "2001:db8::/64"
  # Use this for IPv6 traffic routing
  # destination_ipv6_cidr_block = "2001:db8::/64"

  # (Optional) The ID of a managed prefix list destination.
  # Type: string
  # Example: "pl-12345678"
  # Note: When combining this with vpc_endpoint_id, use aws_vpc_endpoint_route_table_association instead
  # destination_prefix_list_id = "pl-example123"

  ################################################################################
  # Target Arguments (One Required)
  ################################################################################
  # You must specify exactly ONE of the following target arguments:
  # - carrier_gateway_id
  # - core_network_arn
  # - egress_only_gateway_id
  # - gateway_id
  # - nat_gateway_id
  # - local_gateway_id
  # - network_interface_id
  # - transit_gateway_id
  # - vpc_endpoint_id
  # - vpc_peering_connection_id

  # (Optional) Identifier of a carrier gateway.
  # Type: string
  # This attribute can only be used when the VPC contains a subnet which is
  # associated with a Wavelength Zone.
  # Example: "cagw-12345678"
  # carrier_gateway_id = "cagw-example123"

  # (Optional) The Amazon Resource Name (ARN) of a core network.
  # Type: string
  # Example: "arn:aws:networkmanager::123456789012:core-network/core-network-12345678"
  # core_network_arn = "arn:aws:networkmanager::123456789012:core-network/core-network-example"

  # (Optional) Identifier of a VPC Egress Only Internet Gateway.
  # Type: string
  # Use this for IPv6-only egress traffic
  # Example: "eigw-12345678"
  # egress_only_gateway_id = "eigw-example123"

  # (Optional) Identifier of a VPC internet gateway or a virtual private gateway.
  # Type: string
  # Specify "local" when updating a previously imported local route.
  # WARNING: Only use aws_internet_gateway or aws_vpn_gateway IDs.
  # Using other gateway types (NAT, egress-only) will cause permanent diffs.
  # Example: "igw-12345678" or "vgw-12345678" or "local"
  # gateway_id = "igw-example123"

  # (Optional) Identifier of a VPC NAT gateway.
  # Type: string
  # Example: "nat-12345678"
  # nat_gateway_id = "nat-example123"

  # (Optional) Identifier of a Outpost local gateway.
  # Type: string
  # Example: "lgw-12345678"
  # local_gateway_id = "lgw-example123"

  # (Optional) Identifier of an EC2 network interface.
  # Type: string
  # Example: "eni-12345678"
  # network_interface_id = "eni-example123"

  # (Optional) Identifier of an EC2 Transit Gateway.
  # Type: string
  # Example: "tgw-12345678"
  # transit_gateway_id = "tgw-example123"

  # (Optional) Identifier of a VPC Endpoint.
  # Type: string
  # Example: "vpce-12345678"
  # Note: Do not combine with destination_prefix_list_id
  # vpc_endpoint_id = "vpce-example123"

  # (Optional) Identifier of a VPC peering connection.
  # Type: string
  # Example: "pcx-12345678"
  vpc_peering_connection_id = "pcx-45ff3dc1"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Region where this resource will be managed.
  # Type: string
  # Defaults to the Region set in the provider configuration.
  # Example: "us-east-1"
  # region = "us-east-1"

  ################################################################################
  # Timeouts Configuration
  ################################################################################

  # timeouts {
  #   # (Optional) How long to wait for a route to be created.
  #   # Default: 5 minutes
  #   # Example: "10m"
  #   create = "5m"
  #
  #   # (Optional) How long to wait for a route to be updated.
  #   # Default: 2 minutes
  #   # Example: "5m"
  #   update = "2m"
  #
  #   # (Optional) How long to wait for a route to be deleted.
  #   # Default: 5 minutes
  #   # Example: "10m"
  #   delete = "5m"
  # }

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################
  # The following attributes are exported and available after resource creation:
  #
  # id - Route identifier computed from the routing table identifier and route destination.
  #      Format: "rtb-xxxxx_destination"
  #
  # instance_id - Identifier of an EC2 instance (computed when network_interface_id is used).
  #
  # instance_owner_id - The AWS account ID of the owner of the EC2 instance.
  #
  # origin - How the route was created.
  #          Values: "CreateRouteTable", "CreateRoute", or "EnableVgwRoutePropagation"
  #
  # state - The state of the route.
  #         Values: "active" or "blackhole"
  #
  # network_interface_id - Can be set explicitly or computed from instance_id
  #
  # region - Will be computed if not explicitly set
  ################################################################################

  ################################################################################
  # Import
  ################################################################################
  # Routes can be imported using the route table ID and destination:
  #
  # For IPv4:
  # terraform import aws_route.example rtb-12345678_10.0.1.0/24
  #
  # For IPv6:
  # terraform import aws_route.example rtb-12345678_2001:db8::/64
  #
  # For prefix list:
  # terraform import aws_route.example rtb-12345678_pl-12345678
  ################################################################################

  ################################################################################
  # Common Usage Patterns
  ################################################################################
  # 1. Internet Gateway Route (Public Subnet):
  #    destination_cidr_block = "0.0.0.0/0"
  #    gateway_id            = aws_internet_gateway.main.id
  #
  # 2. NAT Gateway Route (Private Subnet):
  #    destination_cidr_block = "0.0.0.0/0"
  #    nat_gateway_id        = aws_nat_gateway.main.id
  #
  # 3. VPC Peering Route:
  #    destination_cidr_block    = "10.1.0.0/16"
  #    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  #
  # 4. Transit Gateway Route:
  #    destination_cidr_block = "10.0.0.0/8"
  #    transit_gateway_id     = aws_ec2_transit_gateway.main.id
  #
  # 5. IPv6 Egress-Only Gateway Route:
  #    destination_ipv6_cidr_block = "::/0"
  #    egress_only_gateway_id      = aws_egress_only_internet_gateway.main.id
  ################################################################################

  ################################################################################
  # Best Practices
  ################################################################################
  # 1. Route Conflicts: Never mix aws_route resources with inline routes in aws_route_table
  # 2. Gateway Types: Always use the correct gateway_id type (IGW or VGW only)
  # 3. Destinations: Specify exactly one destination type per route
  # 4. Targets: Specify exactly one target type per route
  # 5. Default Route: The local route (VPC CIDR) is created implicitly, don't create it
  # 6. Dependencies: Ensure target resources (NAT GW, IGW, etc.) are created first
  # 7. VPC Endpoints: Use aws_vpc_endpoint_route_table_association for prefix lists
  # 8. Region Consistency: Keep routes in the same region as the route table
  ################################################################################

  ################################################################################
  # Related Resources
  ################################################################################
  # - aws_route_table: Route table containing this route
  # - aws_internet_gateway: Internet gateway for public internet access
  # - aws_nat_gateway: NAT gateway for private subnet internet access
  # - aws_vpc_peering_connection: VPC peering connection
  # - aws_ec2_transit_gateway: Transit gateway for multi-VPC connectivity
  # - aws_egress_only_internet_gateway: Egress-only gateway for IPv6
  # - aws_vpc_endpoint: VPC endpoint for AWS services
  # - aws_vpn_gateway: Virtual private gateway for VPN connections
  # - aws_ec2_carrier_gateway: Carrier gateway for Wavelength Zones
  # - aws_networkmanager_core_network: Core network for Cloud WAN
  ################################################################################
}
