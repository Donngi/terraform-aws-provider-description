################################################################################
# AWS NAT Gateway EIP Association
################################################################################
# Terraform resource for managing an AWS VPC NAT Gateway EIP Association.
#
# This resource associates an Elastic IP address with a public NAT Gateway.
# NAT Gateways provide Network Address Translation (NAT) for instances in
# private subnets to access the internet. Public NAT Gateways require at least
# one Elastic IP, and this resource can be used to associate secondary EIPs.
#
# WARNING: You should not use the aws_nat_gateway_eip_association resource in
# conjunction with an aws_nat_gateway resource that has secondary_allocation_ids
# configured. Doing so may cause perpetual differences, and result in
# associations being overwritten.
#
# AWS Official Documentation:
#   - AssociateNatGatewayAddress API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AssociateNatGatewayAddress.html
#   - NAT Gateway Troubleshooting: https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-troubleshooting.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway_eip_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: This template is AI-generated based on information available at the time
#       of generation. Information may be outdated or contain errors. Please refer
#       to official documentation for accurate and up-to-date specifications.
#
################################################################################

resource "aws_nat_gateway_eip_association" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # allocation_id (Required, Forces new resource)
  # The ID of the Elastic IP Allocation to associate with the NAT Gateway.
  # Reference the id attribute of an aws_eip resource or provide an existing
  # EIP allocation ID. The EIP's network border group must belong to the same
  # Availability Zone as the NAT Gateway.
  # Public NAT Gateways can have up to 2 EIPs associated by default.
  # You can request a quota increase to raise this limit.
  # Type: string
  # Example: "eipalloc-0123456789abcdef0"
  allocation_id = aws_eip.example.id

  # nat_gateway_id (Required, Forces new resource)
  # The ID of the NAT Gateway to associate the Elastic IP Allocation to.
  # Reference the id attribute of an aws_nat_gateway resource or provide an
  # existing NAT Gateway ID. The target must be a public NAT Gateway (private
  # NAT Gateways cannot have EIPs associated).
  # Type: string
  # Example: "nat-0123456789abcdef0"
  nat_gateway_id = aws_nat_gateway.example.id


  ################################################################################
  # Optional Arguments
  ################################################################################

  # region (Optional)
  # Region where this resource will be managed.
  # If not specified, defaults to the Region set in the provider configuration.
  # Specify this when cross-region resource management is required.
  # Type: string, optional, computed
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Example: "us-east-1", "ap-northeast-1", "eu-west-1"
  # region = "us-east-1"


  ################################################################################
  # Timeouts Configuration
  ################################################################################

  # timeouts block (Optional)
  # Configure timeout durations for resource create and delete operations.
  # Values are specified in duration format: "30s" (seconds), "5m" (minutes),
  # "2h" (hours).
  # timeouts {
  #   # create (Optional)
  #   # Timeout for creating the association.
  #   # EIP association typically completes in seconds, but network conditions
  #   # may cause delays.
  #   # Type: string, optional
  #   # Format: Duration string (e.g., "30s", "5m", "1h")
  #   # Default: Provider default value
  #   create = "30m"
  #
  #   # delete (Optional)
  #   # Timeout for deleting the association.
  #   # Maximum wait time for EIP disassociation to complete.
  #   # Type: string, optional
  #   # Format: Duration string (e.g., "30s", "5m", "1h")
  #   # Default: Provider default value
  #   # Note: Setting a timeout for Delete operation is only applicable if
  #   #       changes are saved into state before the destroy operation occurs.
  #   delete = "30m"
  # }
}


################################################################################
# Computed Attributes (Read-Only)
################################################################################
# The following attributes are exported by the resource and can be referenced
# elsewhere:
#
# - association_id (string)
#   The ID of the NAT Gateway EIP Association.
#   Format: eipassoc-xxxxxxxxxxxxxxxxx
#   This uniquely identifies the association.
#   Example usage: aws_nat_gateway_eip_association.example.association_id
#
# - region (string)
#   The AWS region where the association is managed.
#   Example usage: aws_nat_gateway_eip_association.example.region
################################################################################


################################################################################
# Example Usage Scenarios
################################################################################

# Example 1: Basic Usage - Add a secondary EIP to an existing NAT Gateway
# resource "aws_eip" "secondary" {
#   domain = "vpc"
#
#   tags = {
#     Name = "nat-gateway-secondary-eip"
#   }
# }
#
# resource "aws_nat_gateway_eip_association" "secondary" {
#   allocation_id  = aws_eip.secondary.id
#   nat_gateway_id = aws_nat_gateway.main.id
# }

# Example 2: Multiple secondary EIP associations
# resource "aws_eip" "nat_secondary" {
#   count  = 2
#   domain = "vpc"
#
#   tags = {
#     Name = "nat-gateway-secondary-eip-${count.index + 1}"
#   }
# }
#
# resource "aws_nat_gateway_eip_association" "secondary" {
#   count          = 2
#   allocation_id  = aws_eip.nat_secondary[count.index].id
#   nat_gateway_id = aws_nat_gateway.main.id
# }

# Example 3: With explicit region configuration
# resource "aws_nat_gateway_eip_association" "regional" {
#   allocation_id  = aws_eip.secondary.id
#   nat_gateway_id = aws_nat_gateway.main.id
#   region         = "us-west-2"
# }

# Example 4: With custom timeouts
# resource "aws_nat_gateway_eip_association" "with_timeouts" {
#   allocation_id  = aws_eip.secondary.id
#   nat_gateway_id = aws_nat_gateway.main.id
#
#   timeouts {
#     create = "45m"
#     delete = "45m"
#   }
# }


################################################################################
# Important Notes
################################################################################
# 1. Use Case:
#    This resource is used to associate additional Elastic IPs to an existing
#    NAT Gateway for secondary IP addresses. This can be useful for scenarios
#    requiring multiple public IPs for outbound traffic.
#
# 2. Conflict Warning:
#    Do NOT use this resource if your aws_nat_gateway has secondary_allocation_ids
#    configured. Using both will cause conflicts and may result in associations
#    being overwritten with perpetual differences.
#
# 3. EIP Requirements:
#    - The allocation_id must reference a valid Elastic IP allocation
#    - The EIP must not be already associated with another resource
#    - The EIP's network border group must match the NAT Gateway's AZ
#
# 4. NAT Gateway Requirements:
#    - The nat_gateway_id must reference an existing NAT Gateway
#    - Only public NAT Gateways support EIP associations
#    - Private NAT Gateways cannot have EIPs associated
#
# 5. Quota Limits:
#    By default, public NAT Gateways can have up to 2 EIPs associated.
#    You can request a quota increase through AWS Service Quotas if you need more.
#
# 6. Lifecycle:
#    - Both allocation_id and nat_gateway_id force new resource creation if changed
#    - Deleting this resource disassociates the EIP from the NAT Gateway
#    - The Elastic IP itself is not deleted when this resource is destroyed
#
# 7. Association ID:
#    The association_id is automatically generated by AWS and can be used to
#    reference this specific association in other resources or for API operations.
#
# 8. High Availability:
#    For multi-AZ deployments, create separate NAT Gateways in each AZ, each
#    with their own EIP associations for maximum availability.
#
# 9. Cost Considerations:
#    - Each NAT Gateway incurs hourly charges
#    - Each associated EIP incurs charges
#    - Data processing charges apply for traffic through NAT Gateway
#
# 10. Monitoring:
#     Monitor NAT Gateway metrics in CloudWatch, including:
#     - BytesInFromSource, BytesOutToDestination
#     - PacketsInFromSource, PacketsOutToDestination
#     - ActiveConnectionCount, ConnectionEstablishedCount
################################################################################
