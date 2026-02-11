################################################################################
# AWS Network Interface
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface
#
# Network interface resource for attaching to EC2 instances or other AWS resources.
# Provides an Elastic Network Interface (ENI) that can be attached to instances.
################################################################################

resource "aws_network_interface" "example" {
  # Required Arguments
  #-----------------------------------------------------------------------------
  # subnet_id - (Required) Subnet ID to create the ENI in
  # Type: string
  subnet_id = "subnet-12345678"

  # Optional Arguments - Basic Configuration
  #-----------------------------------------------------------------------------
  # description - (Optional) Description for the network interface
  # Type: string
  # description = "Example network interface"

  # interface_type - (Optional, Computed) Type of network interface to create
  # Type: string
  # Valid values: interface, efa, trunk
  # Default: interface
  # interface_type = "interface"

  # source_dest_check - (Optional) Enable or disable source/destination checking
  # Type: bool
  # Default: true
  # Set to false for NAT instances
  # source_dest_check = true

  # security_groups - (Optional, Computed) List of security group IDs to assign
  # Type: set(string)
  # security_groups = ["sg-12345678", "sg-87654321"]

  # Optional Arguments - IPv4 Configuration
  #-----------------------------------------------------------------------------
  # private_ip - (Optional, Computed) Private IPv4 address to assign
  # Type: string
  # If not specified, an address will be automatically assigned from the subnet
  # private_ip = "10.0.1.50"

  # private_ips - (Optional, Computed) List of private IPv4 addresses to assign
  # Type: set(string)
  # Cannot be used with private_ip_list
  # private_ips = ["10.0.1.50", "10.0.1.51"]

  # private_ips_count - (Optional, Computed) Number of secondary private IPv4 addresses
  # Type: number
  # AWS will automatically assign this many additional IPs
  # private_ips_count = 2

  # private_ip_list - (Optional, Computed) Ordered list of private IPv4 addresses
  # Type: list(string)
  # Requires private_ip_list_enabled = true
  # Cannot be used with private_ips
  # private_ip_list = ["10.0.1.50", "10.0.1.51"]

  # private_ip_list_enabled - (Optional) Enable private_ip_list mode
  # Type: bool
  # When true, use private_ip_list instead of private_ips
  # private_ip_list_enabled = false

  # ipv4_prefixes - (Optional, Computed) IPv4 prefixes assigned to the network interface
  # Type: set(string)
  # ipv4_prefixes = ["10.0.1.48/28"]

  # ipv4_prefix_count - (Optional, Computed) Number of IPv4 prefixes to auto-assign
  # Type: number
  # ipv4_prefix_count = 1

  # Optional Arguments - IPv6 Configuration
  #-----------------------------------------------------------------------------
  # ipv6_addresses - (Optional, Computed) IPv6 addresses to assign
  # Type: set(string)
  # Cannot be used with ipv6_address_list
  # ipv6_addresses = ["2001:db8::/64"]

  # ipv6_address_count - (Optional, Computed) Number of IPv6 addresses to assign
  # Type: number
  # AWS will automatically assign this many IPv6 addresses
  # ipv6_address_count = 1

  # ipv6_address_list - (Optional, Computed) Ordered list of IPv6 addresses
  # Type: list(string)
  # Requires ipv6_address_list_enabled = true
  # Cannot be used with ipv6_addresses
  # ipv6_address_list = ["2001:db8::1", "2001:db8::2"]

  # ipv6_address_list_enabled - (Optional) Enable ipv6_address_list mode
  # Type: bool
  # When true, use ipv6_address_list instead of ipv6_addresses
  # ipv6_address_list_enabled = false

  # enable_primary_ipv6 - (Optional, Computed) Enable primary IPv6 address
  # Type: bool
  # enable_primary_ipv6 = false

  # ipv6_prefixes - (Optional, Computed) IPv6 prefixes assigned to the network interface
  # Type: set(string)
  # ipv6_prefixes = ["2001:db8::/80"]

  # ipv6_prefix_count - (Optional, Computed) Number of IPv6 prefixes to auto-assign
  # Type: number
  # ipv6_prefix_count = 1

  # Optional Arguments - Region & Tags
  #-----------------------------------------------------------------------------
  # region - (Optional, Computed) Region where this resource will be managed
  # Type: string
  # Defaults to the provider region
  # region = "us-east-1"

  # tags - (Optional) Map of tags to assign to the resource
  # Type: map(string)
  # tags = {
  #   Name        = "example-eni"
  #   Environment = "production"
  # }

  # tags_all - (Optional, Computed) Map of tags assigned to the resource
  # Type: map(string)
  # Includes default tags configured in the provider
  # Computed automatically

  # Nested Block - Attachment Configuration
  #-----------------------------------------------------------------------------
  # attachment - (Optional) Configuration block to attach ENI to an instance
  # Can be specified multiple times for multiple attachments
  # attachment {
  #   # instance - (Required) ID of the instance to attach to
  #   # Type: string
  #   instance = "i-1234567890abcdef0"
  #
  #   # device_index - (Required) Integer index of the network device on the instance
  #   # Type: number
  #   # device_index = 1
  #
  #   # network_card_index - (Optional, Computed) Integer index of the network card
  #   # Type: number
  #   # For instances that support multiple network cards
  #   # network_card_index = 0
  #
  #   # attachment_id - (Computed) ID of the network interface attachment
  #   # Type: string (read-only)
  # }

  # Computed Attributes (Read-Only)
  #-----------------------------------------------------------------------------
  # arn - ARN of the network interface
  # Type: string (computed)

  # id - ID of the network interface
  # Type: string (computed)

  # mac_address - MAC address of the network interface
  # Type: string (computed)

  # outpost_arn - ARN of the Outpost
  # Type: string (computed)

  # owner_id - AWS account ID of the owner
  # Type: string (computed)

  # private_dns_name - Private DNS name of the network interface
  # Type: string (computed)
}

################################################################################
# Additional Examples
################################################################################

# Example 1: Network interface with multiple private IPs
resource "aws_network_interface" "multi_ip" {
  subnet_id = "subnet-12345678"

  private_ips = [
    "10.0.1.50",
    "10.0.1.51",
    "10.0.1.52"
  ]

  security_groups = ["sg-12345678"]

  tags = {
    Name = "multi-ip-eni"
  }
}

# Example 2: Network interface with attachment to an instance
resource "aws_network_interface" "attached" {
  subnet_id       = "subnet-12345678"
  private_ip      = "10.0.1.100"
  security_groups = ["sg-12345678"]

  attachment {
    instance     = aws_instance.example.id
    device_index = 1
  }

  tags = {
    Name = "attached-eni"
  }
}

# Example 3: Network interface for NAT instance
resource "aws_network_interface" "nat" {
  subnet_id         = "subnet-12345678"
  private_ip        = "10.0.1.10"
  source_dest_check = false
  security_groups   = ["sg-12345678"]

  tags = {
    Name = "nat-eni"
  }
}

# Example 4: Network interface with IPv6
resource "aws_network_interface" "ipv6" {
  subnet_id            = "subnet-12345678"
  private_ip           = "10.0.1.50"
  ipv6_address_count   = 2
  enable_primary_ipv6  = true
  security_groups      = ["sg-12345678"]

  tags = {
    Name = "ipv6-eni"
  }
}

# Example 5: Network interface with IPv4 prefixes
resource "aws_network_interface" "prefix" {
  subnet_id        = "subnet-12345678"
  ipv4_prefix_count = 1
  security_groups  = ["sg-12345678"]

  tags = {
    Name = "prefix-eni"
  }
}

################################################################################
# Outputs
################################################################################

output "network_interface_id" {
  description = "ID of the network interface"
  value       = aws_network_interface.example.id
}

output "network_interface_arn" {
  description = "ARN of the network interface"
  value       = aws_network_interface.example.arn
}

output "network_interface_private_ip" {
  description = "Primary private IPv4 address"
  value       = aws_network_interface.example.private_ip
}

output "network_interface_mac_address" {
  description = "MAC address of the network interface"
  value       = aws_network_interface.example.mac_address
}

output "network_interface_private_dns_name" {
  description = "Private DNS name of the network interface"
  value       = aws_network_interface.example.private_dns_name
}
