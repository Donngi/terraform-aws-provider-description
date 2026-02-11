/**
 * Terraform Template: aws_ec2_local_gateway_route_table_vpc_association
 *
 * Generated: 2026-01-22
 * Provider Version: 6.28.0
 *
 * NOTE: This template is generated based on the schema and documentation available at the time of generation.
 * Please refer to the official Terraform AWS Provider documentation for the latest specifications:
 * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_local_gateway_route_table_vpc_association
 *
 * Description:
 * Manages an EC2 Local Gateway Route Table VPC Association. This resource is used with AWS Outposts to
 * connect a VPC to a local gateway route table, enabling communication between Outpost subnets and
 * on-premises networks through the local gateway.
 *
 * Local gateways are components of AWS Outposts racks that enable connectivity between Outpost subnets
 * and on-premises networks. The local gateway route table and VPC associations allow connecting VPCs to
 * local gateway route tables, enabling communication between Outpost subnet resources and the on-premises
 * network through the local gateway.
 *
 * AWS Official Documentation:
 * - Local Gateways for Outposts: https://docs.aws.amazon.com/outposts/latest/userguide/outposts-local-gateways.html
 * - API Reference: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_LocalGatewayRouteTableVpcAssociation.html
 */

resource "aws_ec2_local_gateway_route_table_vpc_association" "example" {
  # ================================
  # Required Arguments
  # ================================

  # local_gateway_route_table_id - (Required) Identifier of EC2 Local Gateway Route Table.
  # The local gateway route table must exist in the same account and be available for association.
  # You can use the aws_ec2_local_gateway_route_table data source to retrieve this ID.
  # Type: string
  # Example: "lgw-rtb-059615ef7dEXAMPLE"
  local_gateway_route_table_id = "lgw-rtb-XXXXXXXXXXXXXXXXX"

  # vpc_id - (Required) Identifier of EC2 VPC.
  # The VPC must exist in the same region and account as the local gateway route table.
  # This VPC will be associated with the local gateway route table to enable communication
  # between resources in the VPC and the on-premises network through the local gateway.
  # Type: string
  # Example: "vpc-0efe9bde08EXAMPLE"
  vpc_id = "vpc-XXXXXXXXXXXXXXXXX"

  # ================================
  # Optional Arguments
  # ================================

  # id - (Optional) Identifier of EC2 Local Gateway Route Table VPC Association.
  # This is typically computed by AWS, but can be optionally specified for import purposes.
  # If not specified, AWS will auto-generate this ID upon creation.
  # Type: string
  # Computed: true (if not provided)
  # Example: "lgw-vpc-assoc-0e0f27af15EXAMPLE"
  # id = "lgw-vpc-assoc-XXXXXXXXXXXXXXXXX"

  # region - (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # This allows you to override the default region for this specific resource.
  # The region must match the region of the local gateway and VPC.
  # Type: string
  # Computed: true (defaults to provider region if not specified)
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  # tags - (Optional) Key-value map of resource tags.
  # Tags are metadata that you can assign to the association for organization and cost tracking.
  # If configured with a provider default_tags configuration block, tags with matching keys
  # will overwrite those defined at the provider-level.
  # Type: map(string)
  # Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-lgw-vpc-association"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all - (Optional/Computed) A map of tags assigned to the resource, including those
  # inherited from the provider default_tags configuration block.
  # This is typically computed by Terraform and includes both the tags defined here and
  # any default tags from the provider configuration.
  # Type: map(string)
  # Computed: true
  # Note: This attribute is managed by Terraform and usually should not be set explicitly.
  # tags_all = {}

  # ================================
  # Computed Attributes (Read-Only)
  # ================================
  # The following attributes are exported and can be referenced but cannot be set:
  #
  # - local_gateway_id: The ID of the local gateway.
  #   Type: string
  #   Example: "lgw-09b493aa7cEXAMPLE"
}

# ================================
# Example Usage Scenarios
# ================================

# Example 1: Basic association using data source to find local gateway route table
# data "aws_ec2_local_gateway_route_table" "example" {
#   outpost_arn = "arn:aws:outposts:us-west-2:123456789012:outpost/op-1234567890abcdef"
# }
#
# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
# }
#
# resource "aws_ec2_local_gateway_route_table_vpc_association" "example" {
#   local_gateway_route_table_id = data.aws_ec2_local_gateway_route_table.example.id
#   vpc_id                       = aws_vpc.example.id
#
#   tags = {
#     Name = "outpost-vpc-association"
#   }
# }

# Example 2: Association with specific region override
# resource "aws_ec2_local_gateway_route_table_vpc_association" "regional" {
#   local_gateway_route_table_id = "lgw-rtb-059615ef7dEXAMPLE"
#   vpc_id                       = "vpc-0efe9bde08EXAMPLE"
#   region                       = "us-west-2"
#
#   tags = {
#     Name        = "regional-lgw-association"
#     Environment = "staging"
#   }
# }
