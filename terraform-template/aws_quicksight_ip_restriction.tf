################################################################################
# AWS QuickSight IP Restriction
################################################################################
# Manages the content and status of IP rules for QuickSight.
#
# Important Notes:
# - Deletion of this resource clears all IP restrictions from a QuickSight account
# - IP restrictions help control access to QuickSight dashboards and analyses
# - Can restrict by IP CIDR ranges, VPC IDs, or VPC endpoint IDs
#
# Use Cases:
# - Enforce IP-based access control for QuickSight dashboards
# - Allow access only from corporate networks or specific VPCs
# - Comply with security policies requiring network-level access restrictions
#
# References:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_ip_restriction
# - https://docs.aws.amazon.com/quicksight/latest/user/restrict-access-to-a-namespace-by-ip-address.html
################################################################################

resource "aws_quicksight_ip_restriction" "example" {
  # ====================
  # Required Arguments
  # ====================

  # enabled - (Required) Whether IP rules are turned on
  # Type: bool
  #
  # When set to true, IP restriction rules are enforced for QuickSight access.
  # When set to false, IP restrictions are disabled but rules are preserved.
  #
  # Example values:
  # - true  (enforce IP restrictions)
  # - false (disable IP restrictions but keep rules)
  enabled = true

  # ====================
  # Optional Arguments
  # ====================

  # aws_account_id - (Optional, Forces new resource) AWS account ID
  # Type: string
  # Default: Automatically determined from Terraform AWS provider configuration
  #
  # The AWS account ID where QuickSight IP restrictions are managed.
  # Changing this value forces creation of a new resource.
  #
  # Example: "123456789012"
  # aws_account_id = "123456789012"

  # region - (Optional) Region where this resource will be managed
  # Type: string
  # Default: Region set in the provider configuration
  #
  # The AWS region where QuickSight IP restrictions are applied.
  # Must be a region where QuickSight is available.
  #
  # Example: "us-east-1"
  # region = "us-east-1"

  # ip_restriction_rule_map - (Optional) Map of allowed IPv4 CIDR ranges and descriptions
  # Type: map(string)
  #
  # Defines IP CIDR ranges that are allowed to access QuickSight.
  # Each key is a CIDR block, and each value is a description.
  #
  # Format: CIDR block must be valid IPv4 CIDR notation (e.g., "1.2.3.4/32")
  #
  # Examples:
  # - Single IP: "203.0.113.42/32" (allows only one specific IP)
  # - IP range: "198.51.100.0/24" (allows entire subnet)
  # - Corporate network: "10.0.0.0/8" (allows entire private network)
  ip_restriction_rule_map = {
    "108.56.166.202/32" = "Allow self"
    # "203.0.113.0/24"    = "Corporate office network"
    # "198.51.100.0/24"   = "Remote office"
  }

  # vpc_id_restriction_rule_map - (Optional) Map of VPC IDs and descriptions
  # Type: map(string)
  #
  # Allows traffic from all VPC endpoints present in the specified VPC.
  # Each key is a VPC ID, and each value is a description.
  #
  # This is useful when you want to allow access from any endpoint within
  # a specific VPC without listing individual endpoint IDs.
  #
  # Examples:
  # - vpc-0123456789abcdef0 (main application VPC)
  # - vpc-abcdef0123456789 (data analytics VPC)
  vpc_id_restriction_rule_map = {
    # aws_vpc.example.id = "Main VPC"
    # aws_vpc.data.id    = "Data Analytics VPC"
  }

  # vpc_endpoint_id_restriction_rule_map - (Optional) Map of allowed VPC endpoint IDs and descriptions
  # Type: map(string)
  #
  # Allows traffic from specific VPC endpoints only.
  # Each key is a VPC endpoint ID, and each value is a description.
  #
  # This provides more granular control compared to vpc_id_restriction_rule_map,
  # as it allows specific endpoints rather than all endpoints in a VPC.
  #
  # Examples:
  # - vpce-0123456789abcdef0 (QuickSight endpoint in main VPC)
  # - vpce-abcdef0123456789 (QuickSight endpoint in data VPC)
  vpc_endpoint_id_restriction_rule_map = {
    # "vpce-0123456789abcdef0" = "Main VPC QuickSight endpoint"
    # "vpce-abcdef0123456789"  = "Data VPC QuickSight endpoint"
  }

  # ====================
  # Exported Attributes
  # ====================
  # This resource does not export any additional attributes beyond the arguments.
  # The following attributes are available via references:
  # - aws_quicksight_ip_restriction.example.enabled
  # - aws_quicksight_ip_restriction.example.aws_account_id
  # - aws_quicksight_ip_restriction.example.region
  # - aws_quicksight_ip_restriction.example.ip_restriction_rule_map
  # - aws_quicksight_ip_restriction.example.vpc_id_restriction_rule_map
  # - aws_quicksight_ip_restriction.example.vpc_endpoint_id_restriction_rule_map

  # ====================
  # Tags
  # ====================
  # Note: This resource does not support tags.
}

################################################################################
# Example: IP Restriction with Multiple Network Sources
################################################################################

# resource "aws_quicksight_ip_restriction" "multi_source" {
#   enabled = true
#
#   # Allow access from corporate office networks
#   ip_restriction_rule_map = {
#     "203.0.113.0/24"  = "Corporate HQ"
#     "198.51.100.0/24" = "Regional Office"
#     "192.0.2.42/32"   = "VPN Gateway"
#   }
#
#   # Allow access from application VPCs
#   vpc_id_restriction_rule_map = {
#     aws_vpc.application.id = "Application VPC"
#     aws_vpc.analytics.id   = "Analytics VPC"
#   }
#
#   # Allow access from specific VPC endpoints for fine-grained control
#   vpc_endpoint_id_restriction_rule_map = {
#     aws_vpc_endpoint.quicksight_main.id = "Main QuickSight endpoint"
#   }
# }

################################################################################
# Example: Temporary Disable IP Restrictions
################################################################################

# resource "aws_quicksight_ip_restriction" "temporary_disable" {
#   # Disable IP restrictions while keeping the rules configured
#   enabled = false
#
#   ip_restriction_rule_map = {
#     "203.0.113.0/24" = "Corporate network"
#   }
#
#   # When enabled is set back to true, these restrictions will be enforced again
# }

################################################################################
# Example: IP Restriction with VPC Endpoint
################################################################################

# # Create a VPC endpoint for QuickSight
# resource "aws_vpc_endpoint" "quicksight" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.${data.aws_region.current.name}.quicksight"
#   vpc_endpoint_type = "Interface"
#
#   subnet_ids = [
#     aws_subnet.private_a.id,
#     aws_subnet.private_b.id,
#   ]
#
#   security_group_ids = [
#     aws_security_group.quicksight_endpoint.id,
#   ]
#
#   private_dns_enabled = true
#
#   tags = {
#     Name = "quicksight-vpc-endpoint"
#   }
# }
#
# # Restrict QuickSight access to the VPC endpoint
# resource "aws_quicksight_ip_restriction" "vpc_only" {
#   enabled = true
#
#   vpc_endpoint_id_restriction_rule_map = {
#     aws_vpc_endpoint.quicksight.id = "Private QuickSight access"
#   }
# }

################################################################################
# Outputs
################################################################################

# output "quicksight_ip_restriction_enabled" {
#   description = "Whether IP restrictions are enabled"
#   value       = aws_quicksight_ip_restriction.example.enabled
# }
#
# output "quicksight_ip_restriction_account_id" {
#   description = "AWS account ID where IP restrictions are applied"
#   value       = aws_quicksight_ip_restriction.example.aws_account_id
# }
#
# output "quicksight_ip_restriction_region" {
#   description = "AWS region where IP restrictions are applied"
#   value       = aws_quicksight_ip_restriction.example.region
# }

################################################################################
# Important Considerations
################################################################################
#
# 1. Deletion Behavior:
#    - Destroying this resource clears ALL IP restrictions from the QuickSight account
#    - Consider carefully before destroying in production environments
#    - No way to preserve restrictions when removing this resource from Terraform
#
# 2. IP CIDR Format:
#    - Must use valid IPv4 CIDR notation
#    - /32 for single IP addresses
#    - Broader ranges like /24, /16 for subnets
#    - Invalid CIDR blocks will cause apply failures
#
# 3. VPC vs VPC Endpoint Restrictions:
#    - vpc_id_restriction_rule_map: Allows all endpoints in the VPC
#    - vpc_endpoint_id_restriction_rule_map: Allows specific endpoints only
#    - Use vpc_endpoint_id for more granular control
#
# 4. Multiple Restriction Types:
#    - Can combine IP CIDR, VPC ID, and VPC endpoint ID restrictions
#    - Access is allowed if ANY of the conditions match (OR logic)
#    - No priority or ordering between restriction types
#
# 5. Regional Considerations:
#    - QuickSight IP restrictions are account-level settings
#    - The region parameter determines where the restriction is managed
#    - Check QuickSight availability in your target region
#
# 6. Testing:
#    - Test IP restrictions carefully to avoid locking out legitimate users
#    - Consider starting with enabled = false and testing rules before enabling
#    - Maintain alternative access methods during initial setup
#
# 7. Monitoring:
#    - Monitor QuickSight access logs for blocked access attempts
#    - Set up alerts for unexpected access denials
#    - Review and update IP restrictions periodically
#
# 8. Account ID Changes:
#    - Changing aws_account_id forces resource replacement
#    - Plan carefully when managing cross-account scenarios
#    - Use separate resources for separate accounts
#
################################################################################
