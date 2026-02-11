################################################################################
# AWS EC2 Transit Gateway Multicast Group Source
# Terraform Resource: aws_ec2_transit_gateway_multicast_group_source
# AWS Provider Version: 6.28.0
# Generated: 2026-01-26
################################################################################

# Overview:
# This resource registers sources (network interfaces) with a transit gateway
# multicast group. A multicast source is a network interface attached to a
# supported EC2 instance that sends multicast traffic. This resource is used
# when the Static sources support attribute is enabled on the multicast domain.
#
# Key Concepts:
# - Multicast Source: An elastic network interface associated with a supported
#   EC2 instance that is statically configured to send multicast traffic
# - Multicast Group: A set of hosts identified by a group IP address that will
#   send and receive the same multicast traffic
# - Static Source Configuration: A configuration where you manually register
#   sources using the AWS API rather than using IGMP protocol
#
# Important Notes:
# - Transit gateway must be created with multicast support enabled
# - A subnet can only be in one multicast domain
# - Non-Nitro instances cannot be multicast senders
# - Static multicast supports both IPv4 and IPv6
# - AWS automatically removes static sources for ENIs that no longer exist
#
# AWS Documentation:
# - Transit Gateway Multicast Overview:
#   https://docs.aws.amazon.com/vpc/latest/tgw/tgw-multicast-overview.html
# - Register Sources:
#   https://docs.aws.amazon.com/vpc/latest/tgw/add-source-multicast-group.html
# - API Reference:
#   https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_RegisterTransitGatewayMulticastGroupSources.html

resource "aws_ec2_transit_gateway_multicast_group_source" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # group_ip_address - (Required, Forces new resource)
  # Type: string
  # The IP address assigned to the transit gateway multicast group.
  #
  # This identifies the multicast group where the source will send traffic.
  # The IP address must be within the multicast IP range:
  # - IPv4: 224.0.0.0 to 239.255.255.255
  # - IPv6: ff00::/8
  #
  # Example IPv4: "224.0.0.1"
  # Example IPv6: "ff05::1"
  #
  # AWS API Mapping: GroupIpAddress parameter in RegisterTransitGatewayMulticastGroupSources
  group_ip_address = "224.0.0.1"

  # network_interface_id - (Required, Forces new resource)
  # Type: string
  # The ID of the network interface to register as a source with the transit
  # gateway multicast group.
  #
  # This network interface must be:
  # - Attached to a supported EC2 instance (Nitro instances required for sending)
  # - In a subnet that is associated with the multicast domain
  # - In the same VPC attachment associated with the multicast domain
  #
  # The network interface will send multicast traffic to the specified group.
  # For non-Nitro instances used as receivers (not sources), the Source/Dest
  # check must be disabled.
  #
  # AWS API Mapping: NetworkInterfaceIds parameter in RegisterTransitGatewayMulticastGroupSources
  network_interface_id = "eni-1234567890abcdef0"

  # transit_gateway_multicast_domain_id - (Required, Forces new resource)
  # Type: string
  # The ID of the transit gateway multicast domain.
  #
  # The multicast domain must:
  # - Be created with "Static sources support" enabled
  # - Have the subnet containing the network interface associated with it
  # - Be attached to a VPC containing the source network interface
  #
  # The domain determines which subnets can participate in multicast routing
  # and acts as a segmentation boundary for multicast traffic.
  #
  # AWS API Mapping: TransitGatewayMulticastDomainId parameter in RegisterTransitGatewayMulticastGroupSources
  transit_gateway_multicast_domain_id = "tgw-mcast-domain-1234567890abcdef0"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # region - (Optional)
  # Type: string
  # Default: Provider region
  # The AWS region where this resource will be managed.
  #
  # If not specified, defaults to the region set in the provider configuration.
  # Use this to explicitly manage resources in a different region than the
  # provider default.
  #
  # Example: "us-west-2"
  #
  # AWS Documentation: Regional endpoints
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  ################################################################################
  # Attributes Reference
  ################################################################################

  # In addition to all arguments above, the following attributes are exported:

  # id - (Computed)
  # Type: string
  # EC2 Transit Gateway Multicast Group Member identifier.
  #
  # This is a unique identifier for the registered source within the multicast
  # group. The format combines the domain ID, group IP, and network interface ID.
  # This identifier is used for tracking and managing the source registration.
}

################################################################################
# Additional Configuration Examples
################################################################################

# Example 1: Complete static multicast configuration with source
# This example shows how to set up a complete static multicast environment
# with a transit gateway, multicast domain, VPC attachment, and source.
/*
resource "aws_ec2_transit_gateway" "example" {
  description                     = "Multicast-enabled transit gateway"
  multicast_support              = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "multicast-tgw"
  }
}

resource "aws_ec2_transit_gateway_multicast_domain" "example" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id

  static_sources_support = "enable"
  igmpv2_support        = "disable"

  tags = {
    Name = "static-multicast-domain"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  subnet_ids         = [aws_subnet.example.id]
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = aws_vpc.example.id

  tags = {
    Name = "multicast-vpc-attachment"
  }
}

resource "aws_ec2_transit_gateway_multicast_domain_association" "example" {
  subnet_id                           = aws_subnet.example.id
  transit_gateway_attachment_id       = aws_ec2_transit_gateway_vpc_attachment.example.id
  transit_gateway_multicast_domain_id = aws_ec2_transit_gateway_multicast_domain.example.id
}

resource "aws_network_interface" "source" {
  subnet_id = aws_subnet.example.id

  tags = {
    Name = "multicast-source-eni"
  }
}

resource "aws_ec2_transit_gateway_multicast_group_source" "example" {
  group_ip_address                    = "224.0.0.1"
  network_interface_id                = aws_network_interface.source.id
  transit_gateway_multicast_domain_id = aws_ec2_transit_gateway_multicast_domain.example.id

  depends_on = [aws_ec2_transit_gateway_multicast_domain_association.example]
}
*/

# Example 2: Multiple sources for the same multicast group
# You can register multiple network interfaces as sources for the same group.
/*
resource "aws_ec2_transit_gateway_multicast_group_source" "source1" {
  group_ip_address                    = "224.0.0.10"
  network_interface_id                = aws_network_interface.source1.id
  transit_gateway_multicast_domain_id = aws_ec2_transit_gateway_multicast_domain.example.id
}

resource "aws_ec2_transit_gateway_multicast_group_source" "source2" {
  group_ip_address                    = "224.0.0.10"
  network_interface_id                = aws_network_interface.source2.id
  transit_gateway_multicast_domain_id = aws_ec2_transit_gateway_multicast_domain.example.id
}
*/

# Example 3: IPv6 multicast source
# Static multicast supports IPv6 (dynamic multicast does not).
/*
resource "aws_ec2_transit_gateway_multicast_group_source" "ipv6_source" {
  group_ip_address                    = "ff05::1"
  network_interface_id                = aws_network_interface.ipv6_source.id
  transit_gateway_multicast_domain_id = aws_ec2_transit_gateway_multicast_domain.example.id
}
*/

# Example 4: Source in a specific region
# Explicitly manage the source in a specific region.
/*
resource "aws_ec2_transit_gateway_multicast_group_source" "regional" {
  region                              = "us-west-2"
  group_ip_address                    = "224.0.0.1"
  network_interface_id                = aws_network_interface.west_source.id
  transit_gateway_multicast_domain_id = aws_ec2_transit_gateway_multicast_domain.west.id
}
*/

################################################################################
# Import
################################################################################

# The transit gateway multicast group source can be imported using the transit
# gateway multicast domain ID, group IP address, and network interface ID,
# separated by underscores (_).
#
# Format: <transit_gateway_multicast_domain_id>_<group_ip_address>_<network_interface_id>
#
# Example:
# terraform import aws_ec2_transit_gateway_multicast_group_source.example \
#   tgw-mcast-domain-12345678_224.0.0.1_eni-12345678
#
# Note: When importing, ensure the imported resource configuration matches
# the actual AWS resource state to avoid unexpected changes on the next apply.

################################################################################
# Best Practices and Recommendations
################################################################################

# 1. Network Interface Requirements:
#    - Use Nitro-based instances for multicast sources (senders)
#    - Ensure the network interface is in a subnet associated with the domain
#    - For non-Nitro instances (receivers only), disable Source/Dest check
#
# 2. IP Address Selection:
#    - Use organization-local scope (239.0.0.0/8) for private multicast
#    - Avoid well-known multicast addresses (e.g., 224.0.0.1 is all hosts)
#    - Document your multicast address allocation strategy
#
# 3. Static vs. IGMP:
#    - Use static sources when you need full control over group membership
#    - Static sources are required when hosts cannot use IGMP protocol
#    - Static multicast supports IPv6, while IGMP does not
#
# 4. Security Considerations:
#    - Configure security groups to allow multicast traffic from source IPs
#    - Update network ACLs to permit multicast protocol traffic
#    - For static sources, allow UDP traffic to the multicast group IP
#
# 5. Dependencies:
#    - Always create the multicast domain association before registering sources
#    - Use depends_on to ensure proper resource ordering
#    - Register sources before registering group members
#
# 6. Monitoring and Verification:
#    - Use SearchTransitGatewayMulticastGroups API to verify source registration
#    - Monitor CloudWatch metrics for multicast traffic patterns
#    - Test multicast connectivity before production deployment
#
# 7. Cleanup:
#    - AWS automatically removes sources for deleted ENIs
#    - Deregister sources before deleting the multicast domain
#    - Remove domain associations before deleting VPC attachments

################################################################################
# Troubleshooting
################################################################################

# Common Issues:
#
# 1. Source Not Sending Traffic:
#    - Verify the instance is Nitro-based
#    - Check that the subnet is associated with the multicast domain
#    - Ensure the VPC attachment exists and is available
#    - Verify security group rules allow outbound multicast traffic
#
# 2. Cannot Register Source:
#    - Confirm "Static sources support" is enabled on the domain
#    - Check that the network interface exists and is in the correct subnet
#    - Verify the multicast domain is in "available" state
#    - Ensure the group IP is valid (224.0.0.0-239.255.255.255 or ff00::/8)
#
# 3. Import Failures:
#    - Verify the import format includes all three components separated by underscores
#    - Check that the source is actually registered in AWS
#    - Ensure you have proper IAM permissions for DescribeTransitGatewayMulticastGroups
#
# 4. Terraform State Issues:
#    - If the source was manually deleted, use terraform refresh
#    - For stuck states, consider removing from state and re-importing
#    - Check AWS console to verify actual resource state

################################################################################
# Performance Considerations
################################################################################

# Transit Gateway Multicast Limitations:
# - Not suitable for high-frequency trading or ultra-low latency applications
# - Multicast packets cannot be fragmented (they will be dropped)
# - Review multicast quotas and limits for your use case
# - Consider maximum transmission unit (MTU) when designing multicast applications
# - Consult AWS Solution Architects for performance-sensitive workloads
#
# Scaling Considerations:
# - Each multicast domain supports multiple groups and sources
# - Plan your multicast domain topology based on traffic patterns
# - Consider subnet placement for optimal multicast routing
# - Monitor bandwidth consumption on transit gateway attachments

################################################################################
# Related Resources
################################################################################

# - aws_ec2_transit_gateway: Create a transit gateway with multicast support
# - aws_ec2_transit_gateway_multicast_domain: Create a multicast domain
# - aws_ec2_transit_gateway_vpc_attachment: Attach VPC to transit gateway
# - aws_ec2_transit_gateway_multicast_domain_association: Associate subnet with domain
# - aws_ec2_transit_gateway_multicast_group_member: Register group members (receivers)
# - aws_network_interface: Create network interfaces for sources and members
# - aws_instance: Launch EC2 instances for multicast traffic
