# =============================================================================
# AWS Network Manager Transit Gateway Registration
# =============================================================================
# This resource registers a transit gateway with a global network in AWS Network Manager.
#
# Use Case:
#   - Connect transit gateways to a centralized global network for unified management
#   - Enable Network Manager to visualize and monitor transit gateway networks
#   - Support multi-region transit gateway architectures
#
# Important Considerations:
#   - Transit gateway must be created in Amazon VPC before registration
#   - A transit gateway can only be registered to one global network
#   - Transit gateway must be in the same AWS account as the global network
#   - Transit gateway can be in any AWS Region
#   - Multi-account access requires AWS Organizations configuration
#   - Transit gateway management (create/delete/modify) must be done via Amazon VPC
#
# Regional Availability:
#   - Available in all regions where AWS Network Manager is available
#   - Transit gateway can be in any region, but must be same account
#
# References:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/networkmanager_transit_gateway_registration
#   - https://docs.aws.amazon.com/network-manager/latest/tgwnm/register-tgw.html
#   - https://docs.aws.amazon.com/network-manager/latest/tgwnm/tgw-registrations.html
# =============================================================================

# -----------------------------------------------------------------------------
# Prerequisites
# -----------------------------------------------------------------------------
# Before creating this resource, ensure:
#   1. A global network exists (aws_networkmanager_global_network)
#   2. A transit gateway exists (aws_ec2_transit_gateway)
#   3. The transit gateway is in the same AWS account as the global network
#   4. The transit gateway is not already registered to another global network

resource "aws_networkmanager_transit_gateway_registration" "example" {
  # ---------------------------------------------------------------------------
  # REQUIRED PARAMETERS
  # ---------------------------------------------------------------------------

  # global_network_id - (Required) ID of the Global Network to register to.
  # Type: string
  #
  # Description:
  #   - Identifies the global network where the transit gateway will be registered
  #   - Must reference an existing global network in the same account
  #   - Used by Network Manager to organize and visualize network topology
  #
  # Example values:
  #   global_network_id = aws_networkmanager_global_network.example.id
  #   global_network_id = "global-network-0123456789abcdef0"
  global_network_id = aws_networkmanager_global_network.example.id

  # transit_gateway_arn - (Required) ARN of the Transit Gateway to register.
  # Type: string
  #
  # Description:
  #   - Amazon Resource Name (ARN) of the transit gateway to register
  #   - Transit gateway must exist in Amazon VPC
  #   - Can be in any AWS Region
  #   - Must be owned by the same AWS account as the global network
  #   - Cannot be registered to multiple global networks simultaneously
  #
  # Format: arn:aws:ec2:region:account-id:transit-gateway/tgw-id
  #
  # Example values:
  #   transit_gateway_arn = aws_ec2_transit_gateway.example.arn
  #   transit_gateway_arn = "arn:aws:ec2:us-west-2:123456789012:transit-gateway/tgw-0123456789abcdef0"
  transit_gateway_arn = aws_ec2_transit_gateway.example.arn

  # ---------------------------------------------------------------------------
  # OPTIONAL PARAMETERS
  # ---------------------------------------------------------------------------

  # timeouts - (Optional) Configuration block for operation timeouts.
  # Type: object
  #
  # Description:
  #   - Controls timeout duration for create and delete operations
  #   - Useful for large-scale deployments or slower network conditions
  #   - Prevents premature timeout failures
  #
  # Attributes:
  #   - create: Maximum time to wait for registration (default: 10m)
  #   - delete: Maximum time to wait for deregistration (default: 10m)
  #
  # Example:
  #   timeouts {
  #     create = "15m"
  #     delete = "15m"
  #   }
  timeouts {
    create = "10m"
    delete = "10m"
  }

  # ---------------------------------------------------------------------------
  # COMPUTED ATTRIBUTES (Read-only)
  # ---------------------------------------------------------------------------

  # id - The identifier of the transit gateway registration.
  # Type: string
  # Format: global-network-id,transit-gateway-arn
  #
  # Description:
  #   - Automatically generated unique identifier for the registration
  #   - Composite ID combining global network ID and transit gateway ARN
  #   - Used for importing existing registrations
  #
  # Example: global-network-0123456789abcdef0,arn:aws:ec2:us-west-2:123456789012:transit-gateway/tgw-0123456789abcdef0
}

# =============================================================================
# USAGE EXAMPLES
# =============================================================================

# Example 1: Basic transit gateway registration
# -----------------------------------------------------------------------------
# resource "aws_networkmanager_global_network" "main" {
#   description = "Main corporate global network"
#
#   tags = {
#     Name        = "main-global-network"
#     Environment = "production"
#   }
# }
#
# resource "aws_ec2_transit_gateway" "main" {
#   description = "Main transit gateway"
#
#   tags = {
#     Name = "main-tgw"
#   }
# }
#
# resource "aws_networkmanager_transit_gateway_registration" "main" {
#   global_network_id   = aws_networkmanager_global_network.main.id
#   transit_gateway_arn = aws_ec2_transit_gateway.main.arn
# }

# Example 2: Multi-region transit gateway registration
# -----------------------------------------------------------------------------
# resource "aws_networkmanager_global_network" "global" {
#   description = "Global network spanning multiple regions"
# }
#
# resource "aws_ec2_transit_gateway" "us_east" {
#   provider    = aws.us_east_1
#   description = "US East transit gateway"
# }
#
# resource "aws_ec2_transit_gateway" "eu_west" {
#   provider    = aws.eu_west_1
#   description = "EU West transit gateway"
# }
#
# resource "aws_networkmanager_transit_gateway_registration" "us_east" {
#   global_network_id   = aws_networkmanager_global_network.global.id
#   transit_gateway_arn = aws_ec2_transit_gateway.us_east.arn
# }
#
# resource "aws_networkmanager_transit_gateway_registration" "eu_west" {
#   global_network_id   = aws_networkmanager_global_network.global.id
#   transit_gateway_arn = aws_ec2_transit_gateway.eu_west.arn
# }

# Example 3: Registration with custom timeouts
# -----------------------------------------------------------------------------
# resource "aws_networkmanager_transit_gateway_registration" "with_timeouts" {
#   global_network_id   = aws_networkmanager_global_network.example.id
#   transit_gateway_arn = aws_ec2_transit_gateway.example.arn
#
#   timeouts {
#     create = "15m"
#     delete = "15m"
#   }
#
#   depends_on = [
#     aws_ec2_transit_gateway.example,
#     aws_networkmanager_global_network.example
#   ]
# }

# =============================================================================
# IMPORT
# =============================================================================
# Existing transit gateway registrations can be imported using the format:
# global-network-id,transit-gateway-arn
#
# Example:
# terraform import aws_networkmanager_transit_gateway_registration.example \
#   global-network-0123456789abcdef0,arn:aws:ec2:us-west-2:123456789012:transit-gateway/tgw-0123456789abcdef0

# =============================================================================
# COMMON PATTERNS AND BEST PRACTICES
# =============================================================================

# 1. Dependency Management
# -----------------------------------------------------------------------------
# Always ensure the transit gateway and global network exist before registration:
# resource "aws_networkmanager_transit_gateway_registration" "example" {
#   global_network_id   = aws_networkmanager_global_network.example.id
#   transit_gateway_arn = aws_ec2_transit_gateway.example.arn
#
#   depends_on = [
#     aws_ec2_transit_gateway.example,
#     aws_networkmanager_global_network.example
#   ]
# }

# 2. Multi-Region Architecture
# -----------------------------------------------------------------------------
# For global networks spanning multiple regions, register transit gateways
# from each region to the same global network for unified management:
# - Use provider aliases for multi-region resources
# - Register each regional transit gateway to the global network
# - Transit gateway peering can connect different regions

# 3. Naming and Tagging
# -----------------------------------------------------------------------------
# Use consistent naming conventions and tags for easier management:
# - Tag global networks and transit gateways with environment, purpose, region
# - Use descriptive names for identification in the Network Manager console
# - Consider using terraform workspaces for multi-environment deployments

# 4. Monitoring and Observability
# -----------------------------------------------------------------------------
# After registration, use Network Manager console to:
# - Visualize network topology
# - Monitor transit gateway connections
# - Perform route analysis
# - Track network events and changes

# 5. Security Considerations
# -----------------------------------------------------------------------------
# - Ensure IAM permissions for networkmanager:RegisterTransitGateway
# - Limit access to global network and transit gateway resources
# - Use AWS Organizations for multi-account setups
# - Review transit gateway attachment policies

# 6. Cost Optimization
# -----------------------------------------------------------------------------
# - Network Manager itself has no additional cost
# - Standard transit gateway charges apply
# - Monitor data transfer costs across transit gateways
# - Review and optimize transit gateway attachments

# =============================================================================
# RELATED RESOURCES
# =============================================================================
# - aws_networkmanager_global_network: Creates the global network
# - aws_ec2_transit_gateway: Creates the transit gateway
# - aws_ec2_transit_gateway_peering_attachment: Peers transit gateways
# - aws_networkmanager_site: Defines on-premises sites
# - aws_networkmanager_link: Defines network links
# - aws_networkmanager_device: Defines network devices
# - aws_networkmanager_connection: Associates devices with links
# - aws_networkmanager_customer_gateway_association: Associates customer gateways

# =============================================================================
# TROUBLESHOOTING
# =============================================================================

# Error: Transit gateway already registered
# Solution: A transit gateway can only be registered to one global network.
#           Deregister from the existing global network first.

# Error: Transit gateway not found
# Solution: Ensure the transit gateway exists and the ARN is correct.
#           Verify you have permissions to access the transit gateway.

# Error: Global network not found
# Solution: Ensure the global network exists and the ID is correct.
#           Verify the global network is in the same AWS account.

# Error: Access denied
# Solution: Ensure your IAM role/user has the following permissions:
#           - networkmanager:RegisterTransitGateway
#           - networkmanager:GetTransitGatewayRegistrations
#           - ec2:DescribeTransitGateways

# Error: Timeout during creation
# Solution: Increase the timeout value in the timeouts block.
#           Check for network connectivity issues.
#           Verify AWS service health status.
