# ================================================================================
# AWS Route Table
# ================================================================================
# Provider Version: 6.28.0
# Resource: aws_route_table
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
#
# Description:
# Provides a resource to create a VPC routing table.
#
# Important Notes:
# - NOTE on gateway_id and nat_gateway_id: The AWS API is very forgiving with
#   these two attributes and the aws_route_table resource can be created with a
#   NAT ID specified as a Gateway ID attribute. This will lead to a permanent
#   diff between your configuration and statefile, as the API returns the correct
#   parameters in the returned route table. If you're experiencing constant diffs
#   in your aws_route_table resources, the first thing to check is whether or not
#   you're specifying a NAT ID instead of a Gateway ID, or vice-versa.
#
# - NOTE on propagating_vgws and aws_vpn_gateway_route_propagation resource:
#   If the propagating_vgws argument is present, it's not supported to also
#   define route propagations using aws_vpn_gateway_route_propagation, since
#   this resource will delete any propagating gateways not explicitly listed in
#   propagating_vgws. Omit this argument when defining route propagation using
#   the separate resource.
#
# - NOTE on Route Tables and Routes: Terraform currently provides both a
#   standalone Route resource (aws_route) and a Route Table resource with routes
#   defined in-line (aws_route_table). At this time you cannot use a
#   aws_route_table inline route blocks in conjunction with any aws_route
#   resources. Doing so will cause a conflict of rule settings and will overwrite
#   rules.
#
# - The default route, mapping the VPC's CIDR block to "local", is created
#   implicitly and cannot be specified.
#
# ================================================================================

resource "aws_route_table" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # (Required) The VPC ID.
  # Type: string
  vpc_id = aws_vpc.example.id

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # (Optional) A list of route objects. Their keys are documented below.
  # This argument is processed in attribute-as-blocks mode.
  # This means that omitting this argument is interpreted as ignoring any
  # existing routes. To remove all managed routes an empty list should be
  # specified.
  # Type: set of objects
  # Default: computed
  route {
    # ----------------------------------------------------------------------------
    # Route Destination (choose one)
    # ----------------------------------------------------------------------------

    # (Required) The CIDR block of the route.
    # Type: string
    cidr_block = "10.0.1.0/24"

    # (Optional) The Ipv6 CIDR block of the route.
    # Type: string
    # ipv6_cidr_block = "::/0"

    # (Optional) The ID of a managed prefix list destination of the route.
    # Type: string
    # destination_prefix_list_id = "pl-12345678"

    # ----------------------------------------------------------------------------
    # Route Target (choose one)
    # ----------------------------------------------------------------------------

    # (Optional) Identifier of a VPC internet gateway, virtual private gateway,
    # or "local". "local" routes cannot be created but can be adopted or imported.
    # Type: string
    gateway_id = aws_internet_gateway.example.id

    # (Optional) Identifier of a carrier gateway. This attribute can only be
    # used when the VPC contains a subnet which is associated with a Wavelength
    # Zone.
    # Type: string
    # carrier_gateway_id = aws_ec2_carrier_gateway.example.id

    # (Optional) The Amazon Resource Name (ARN) of a core network.
    # Type: string
    # core_network_arn = "arn:aws:networkmanager::123456789012:core-network/core-network-12345678"

    # (Optional) Identifier of a VPC Egress Only Internet Gateway.
    # Type: string
    # egress_only_gateway_id = aws_egress_only_internet_gateway.example.id

    # (Optional) Identifier of a Outpost local gateway.
    # Type: string
    # local_gateway_id = aws_ec2_local_gateway.example.id

    # (Optional) Identifier of a VPC NAT gateway.
    # Type: string
    # nat_gateway_id = aws_nat_gateway.example.id

    # (Optional) Identifier of an EC2 network interface.
    # Type: string
    # network_interface_id = aws_network_interface.example.id

    # (Optional) Identifier of an EC2 Transit Gateway.
    # Type: string
    # transit_gateway_id = aws_ec2_transit_gateway.example.id

    # (Optional) Identifier of a VPC Endpoint.
    # Type: string
    # vpc_endpoint_id = aws_vpc_endpoint.example.id

    # (Optional) Identifier of a VPC peering connection.
    # Type: string
    # vpc_peering_connection_id = aws_vpc_peering_connection.example.id
  }

  # Example: IPv6 route with egress-only gateway
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  }

  # (Optional) A list of virtual gateways for propagation.
  # Type: set of strings
  # Default: computed
  # propagating_vgws = [aws_vpn_gateway.example.id]

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string
  # Default: computed (provider region)
  # region = "us-east-1"

  # (Optional) A map of tags to assign to the resource.
  # If configured with a provider default_tags configuration block present,
  # tags with matching keys will overwrite those defined at the provider-level.
  # Type: map of strings
  tags = {
    Name        = "example-route-table"
    Environment = "production"
  }

  # ============================================================================
  # Timeouts
  # ============================================================================

  timeouts {
    # (Optional) How long to wait for route table creation.
    # Default: 5m
    # create = "5m"

    # (Optional) How long to wait for route table updates.
    # Default: 2m
    # update = "2m"

    # (Optional) How long to wait for route table deletion.
    # Default: 5m
    # delete = "5m"
  }
}

# ================================================================================
# Attribute Reference
# ================================================================================
# In addition to all arguments above, the following attributes are exported:
#
# - id: The ID of the routing table.
# - arn: The ARN of the route table.
# - owner_id: The ID of the AWS account that owns the route table.
# - tags_all: A map of tags assigned to the resource, including those inherited
#   from the provider default_tags configuration block.
#
# Note: Only the target that is entered is exported as a readable attribute once
# the route resource is created.
# ================================================================================

# ================================================================================
# Example: Adopting an existing local route
# ================================================================================
# resource "aws_vpc" "example" {
#   cidr_block = "10.1.0.0/16"
# }
#
# resource "aws_route_table" "example" {
#   vpc_id = aws_vpc.example.id
#
#   # Since this is exactly the route AWS will create, the route will be adopted
#   route {
#     cidr_block = "10.1.0.0/16"
#     gateway_id = "local"
#   }
# }
# ================================================================================

# ================================================================================
# Output Examples
# ================================================================================
# output "route_table_id" {
#   description = "The ID of the route table"
#   value       = aws_route_table.example.id
# }
#
# output "route_table_arn" {
#   description = "The ARN of the route table"
#   value       = aws_route_table.example.arn
# }
#
# output "route_table_owner_id" {
#   description = "The ID of the AWS account that owns the route table"
#   value       = aws_route_table.example.owner_id
# }
# ================================================================================
