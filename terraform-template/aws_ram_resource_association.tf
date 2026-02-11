################################################################################
# AWS RAM Resource Association
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ram_resource_association
#
# Manages a Resource Access Manager (RAM) Resource Association.
# Associates a resource with a RAM Resource Share, enabling the resource to be
# shared with principals associated with the share.
################################################################################

resource "aws_ram_resource_association" "example" {
  #------------------------------------------------------------------------------
  # Required Arguments
  #------------------------------------------------------------------------------

  # Amazon Resource Name (ARN) of the resource to associate with the
  # RAM Resource Share.
  # Type: string
  # Example: "arn:aws:ec2:us-east-1:123456789012:subnet/subnet-12345678"
  resource_arn = aws_subnet.example.arn

  # Amazon Resource Name (ARN) of the RAM Resource Share.
  # Type: string
  # Example: "arn:aws:ram:us-east-1:123456789012:resource-share/12345678-1234-1234-1234-123456789012"
  resource_share_arn = aws_ram_resource_share.example.arn

  #------------------------------------------------------------------------------
  # Optional Arguments
  #------------------------------------------------------------------------------

  # Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string
  # Default: null (computed - provider region)
  # region = "us-east-1"
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################

# id - The Amazon Resource Name (ARN) of the resource share

################################################################################
# Outputs Example
################################################################################

# output "resource_association_id" {
#   description = "The ID of the RAM resource association (resource share ARN)"
#   value       = aws_ram_resource_association.example.id
# }

################################################################################
# Common Sharable Resources
################################################################################

# EC2 and Networking:
# - VPC Subnets (aws_subnet)
# - Transit Gateways (aws_ec2_transit_gateway)
# - Capacity Reservations (aws_ec2_capacity_reservation)
# - Prefix Lists (aws_ec2_managed_prefix_list)
# - IPAM Pools (aws_vpc_ipam_pool)
#
# Route 53:
# - Resolver Rules (aws_route53_resolver_rule)
# - Resolver Query Log Configs (aws_route53_resolver_query_log_config)
#
# Database:
# - Aurora DB Clusters (aws_rds_cluster)
#
# Certificate Management:
# - ACM Private CA Certificate Authorities (aws_acmpca_certificate_authority)
#
# License Management:
# - License Manager License Configurations (aws_licensemanager_license_configuration)
#
# Image Management:
# - EC2 Image Builder Images (aws_imagebuilder_image)
# - EC2 Image Builder Components (aws_imagebuilder_component)
#
# Other Services:
# - Resource Groups (aws_resourcegroups_group)
# - Outposts (aws_outposts_outpost)
# - Service Catalog Portfolios (aws_servicecatalog_portfolio)

################################################################################
# Example Usage - VPC Subnet Sharing
################################################################################

# resource "aws_ram_resource_share" "vpc_share" {
#   name                      = "vpc-subnet-share"
#   allow_external_principals = false
# }
#
# resource "aws_ram_resource_association" "subnet" {
#   resource_arn       = aws_subnet.private.arn
#   resource_share_arn = aws_ram_resource_share.vpc_share.arn
# }
#
# resource "aws_ram_principal_association" "org" {
#   principal          = "arn:aws:organizations::123456789012:organization/o-xxxxxxxxxx"
#   resource_share_arn = aws_ram_resource_share.vpc_share.arn
# }

################################################################################
# Example Usage - Transit Gateway Sharing
################################################################################

# resource "aws_ram_resource_share" "tgw_share" {
#   name                      = "transit-gateway-share"
#   allow_external_principals = false
# }
#
# resource "aws_ram_resource_association" "tgw" {
#   resource_arn       = aws_ec2_transit_gateway.main.arn
#   resource_share_arn = aws_ram_resource_share.tgw_share.arn
# }
#
# resource "aws_ram_principal_association" "network_account" {
#   principal          = "123456789012"  # AWS account ID
#   resource_share_arn = aws_ram_resource_share.tgw_share.arn
# }

################################################################################
# Example Usage - Route 53 Resolver Rule Sharing
################################################################################

# resource "aws_ram_resource_share" "resolver_share" {
#   name                      = "resolver-rule-share"
#   allow_external_principals = false
# }
#
# resource "aws_ram_resource_association" "resolver_rule" {
#   resource_arn       = aws_route53_resolver_rule.forward.arn
#   resource_share_arn = aws_ram_resource_share.resolver_share.arn
# }

################################################################################
# Notes
################################################################################

# 1. Organization Requirements:
#    - Certain AWS resources (e.g., EC2 Subnets) can only be shared in an AWS
#      account that is a member of an AWS Organizations organization
#    - Organization-wide Resource Access Manager functionality must be enabled
#    - Enable RAM sharing in AWS Organizations console or via CLI
#
# 2. Resource Lifecycle:
#    - The resource association creates a link between a resource and a share
#    - Destroying the association removes the resource from the share
#    - The underlying resource itself is not affected
#
# 3. Sharing Limitations:
#    - Not all AWS resources support RAM sharing
#    - Some resources have specific requirements for sharing
#    - Check AWS documentation for resource-specific limitations
#
# 4. Multi-Account Architecture:
#    - Commonly used for sharing VPC subnets in hub-and-spoke architectures
#    - Transit Gateways are often shared from a central networking account
#    - Resolver rules enable centralized DNS management
#
# 5. Permissions:
#    - The resource share must have appropriate permissions configured
#    - Default permissions are automatically attached for most resource types
#    - Custom permissions can be specified at the resource share level
#
# 6. Cross-Region Considerations:
#    - Some resources support cross-region sharing
#    - The region parameter can be used to manage resources in specific regions
#    - Verify resource type support for cross-region sharing
#
# 7. Best Practices:
#    - Tag resource shares for better organization and cost allocation
#    - Use descriptive names for resource shares
#    - Document sharing relationships in your infrastructure diagrams
#    - Monitor shared resource usage across accounts
#
# 8. Dependency Management:
#    - Ensure the resource exists before creating the association
#    - Ensure the resource share exists before creating the association
#    - Principal associations can be created independently

################################################################################
# Related Resources
################################################################################

# - aws_ram_resource_share - Creates the resource share
# - aws_ram_principal_association - Associates principals with the share
# - aws_ram_resource_share_accepter - Accepts a resource share invitation

################################################################################
# References
################################################################################

# - Resource Access Manager User Guide: https://docs.aws.amazon.com/ram/latest/userguide/what-is.html
# - Shareable Resources: https://docs.aws.amazon.com/ram/latest/userguide/shareable.html
# - Working with Shared Resources: https://docs.aws.amazon.com/ram/latest/userguide/working-with-shared.html
