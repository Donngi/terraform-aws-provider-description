################################################################################
# AWS Network ACL
# Resource: aws_network_acl
# Provider Version: 6.28.0
#
# Description:
# Provides a network ACL resource. Network ACLs provide an additional layer of
# security to your VPC by controlling traffic at the subnet level. You might set
# up network ACLs with rules similar to your security groups to add an extra
# layer of security.
#
# Important Notes:
# - Terraform provides both standalone Network ACL Rule resources and Network ACL
#   resources with inline rules. Do not use both approaches simultaneously as they
#   will conflict and overwrite rules.
# - Terraform also provides standalone network ACL association resources. Do not
#   use the same subnet ID in both a network ACL resource's subnet_ids attribute
#   and a network ACL association resource.
#
# AWS Documentation:
# https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html
#
# Terraform Registry Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl
################################################################################

resource "aws_network_acl" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # vpc_id - (Required) The ID of the associated VPC
  # Type: string
  # Example: "vpc-12345678"
  vpc_id = "vpc-12345678"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # region - (Optional) Region where this resource will be managed
  # Type: string
  # Default: Defaults to the Region set in the provider configuration
  # Constraints: Must be a valid AWS region code
  # Example: "us-east-1"
  # region = "us-east-1"

  # subnet_ids - (Optional) A list of Subnet IDs to apply the ACL to
  # Type: set of strings
  # Default: null (computed)
  # Important: Do not use the same subnet ID in both this attribute and a
  #            network ACL association resource to avoid conflicts
  # Example: ["subnet-12345678", "subnet-87654321"]
  # subnet_ids = ["subnet-12345678", "subnet-87654321"]

  # tags - (Optional) A map of tags to assign to the resource
  # Type: map of strings
  # Default: null
  # Note: If configured with a provider default_tags configuration block,
  #       tags with matching keys will overwrite those defined at the provider-level
  # Example: { Name = "main-nacl", Environment = "production" }
  tags = {
    Name        = "example-network-acl"
    Environment = "production"
  }

  ################################################################################
  # Ingress Rules (Optional)
  ################################################################################
  # ingress - (Optional) Specifies an ingress rule
  # Type: set of objects
  # This argument is processed in attribute-as-blocks mode
  # Each ingress block supports the following attributes:

  ingress {
    # rule_no - (Required) The rule number. Used for ordering
    # Type: number
    # Constraints: Must be between 1 and 32766
    # Lower numbers are evaluated first
    rule_no = 100

    # action - (Required) The action to take
    # Type: string
    # Valid values: "allow", "deny"
    action = "allow"

    # protocol - (Required) The protocol to match
    # Type: string
    # Valid values: Protocol number (e.g., "6" for TCP, "17" for UDP, "1" for ICMP)
    #               or "-1" for all protocols
    # Note: When using "-1" (all protocols), you must specify from_port and to_port as 0
    protocol = "tcp"

    # from_port - (Required) The from port to match
    # Type: number
    # Constraints: Must be 0 when protocol is "-1"
    from_port = 80

    # to_port - (Required) The to port to match
    # Type: number
    # Constraints: Must be 0 when protocol is "-1"
    to_port = 80

    # cidr_block - (Optional) The CIDR block to match
    # Type: string
    # Constraints: Must be a valid network mask
    # Note: Must specify either cidr_block or ipv6_cidr_block
    cidr_block = "10.0.0.0/16"

    # ipv6_cidr_block - (Optional) The IPv6 CIDR block
    # Type: string
    # Note: Must specify either cidr_block or ipv6_cidr_block
    # ipv6_cidr_block = "2001:db8::/64"

    # icmp_type - (Optional) The ICMP type to be used
    # Type: number
    # Default: 0
    # Note: Only applicable when protocol is "1" (ICMP)
    # Reference: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
    # icmp_type = 0

    # icmp_code - (Optional) The ICMP type code to be used
    # Type: number
    # Default: 0
    # Note: Only applicable when protocol is "1" (ICMP)
    # Reference: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
    # icmp_code = 0
  }

  ingress {
    rule_no    = 110
    action     = "allow"
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
    cidr_block = "10.0.0.0/16"
  }

  # Example: Allow all traffic (use with caution)
  # ingress {
  #   rule_no    = 200
  #   action     = "allow"
  #   protocol   = "-1"
  #   from_port  = 0
  #   to_port    = 0
  #   cidr_block = "0.0.0.0/0"
  # }

  # Example: ICMP rule
  # ingress {
  #   rule_no    = 300
  #   action     = "allow"
  #   protocol   = "1"
  #   from_port  = 0
  #   to_port    = 0
  #   cidr_block = "10.0.0.0/16"
  #   icmp_type  = 8
  #   icmp_code  = 0
  # }

  ################################################################################
  # Egress Rules (Optional)
  ################################################################################
  # egress - (Optional) Specifies an egress rule
  # Type: set of objects
  # This argument is processed in attribute-as-blocks mode
  # Each egress block supports the following attributes (same as ingress):

  egress {
    # rule_no - (Required) The rule number. Used for ordering
    rule_no = 200

    # action - (Required) The action to take
    # Valid values: "allow", "deny"
    action = "allow"

    # protocol - (Required) The protocol to match
    protocol = "tcp"

    # from_port - (Required) The from port to match
    from_port = 443

    # to_port - (Required) The to port to match
    to_port = 443

    # cidr_block - (Optional) The CIDR block to match
    cidr_block = "0.0.0.0/0"

    # ipv6_cidr_block - (Optional) The IPv6 CIDR block
    # ipv6_cidr_block = "::/0"

    # icmp_type - (Optional) The ICMP type to be used
    # icmp_type = 0

    # icmp_code - (Optional) The ICMP type code to be used
    # icmp_code = 0
  }

  egress {
    rule_no    = 210
    action     = "allow"
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
  }

  # Example: Allow all outbound traffic
  # egress {
  #   rule_no    = 300
  #   action     = "allow"
  #   protocol   = "-1"
  #   from_port  = 0
  #   to_port    = 0
  #   cidr_block = "0.0.0.0/0"
  # }
}

################################################################################
# Outputs
################################################################################

# Output the Network ACL ID
output "network_acl_id" {
  description = "The ID of the network ACL"
  value       = aws_network_acl.example.id
}

# Output the Network ACL ARN
output "network_acl_arn" {
  description = "The ARN of the network ACL"
  value       = aws_network_acl.example.arn
}

# Output the Network ACL Owner ID
output "network_acl_owner_id" {
  description = "The ID of the AWS account that owns the network ACL"
  value       = aws_network_acl.example.owner_id
}

# Output the tags including provider default tags
output "network_acl_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_network_acl.example.tags_all
}

################################################################################
# Additional Examples
################################################################################

# Example: Network ACL with IPv6 rules
# resource "aws_network_acl" "ipv6_example" {
#   vpc_id = aws_vpc.main.id
#
#   ingress {
#     rule_no         = 100
#     action          = "allow"
#     protocol        = "tcp"
#     from_port       = 443
#     to_port         = 443
#     ipv6_cidr_block = "2001:db8::/64"
#   }
#
#   egress {
#     rule_no         = 100
#     action          = "allow"
#     protocol        = "tcp"
#     from_port       = 443
#     to_port         = 443
#     ipv6_cidr_block = "::/0"
#   }
#
#   tags = {
#     Name = "ipv6-nacl"
#   }
# }

# Example: Network ACL with subnet associations
# resource "aws_network_acl" "with_subnets" {
#   vpc_id     = aws_vpc.main.id
#   subnet_ids = [
#     aws_subnet.private_1.id,
#     aws_subnet.private_2.id
#   ]
#
#   ingress {
#     rule_no    = 100
#     action     = "allow"
#     protocol   = "-1"
#     from_port  = 0
#     to_port    = 0
#     cidr_block = "0.0.0.0/0"
#   }
#
#   egress {
#     rule_no    = 100
#     action     = "allow"
#     protocol   = "-1"
#     from_port  = 0
#     to_port    = 0
#     cidr_block = "0.0.0.0/0"
#   }
#
#   tags = {
#     Name = "private-subnets-nacl"
#   }
# }

# Example: Restrictive Network ACL with deny rules
# resource "aws_network_acl" "restrictive" {
#   vpc_id = aws_vpc.main.id
#
#   # Allow HTTP
#   ingress {
#     rule_no    = 100
#     action     = "allow"
#     protocol   = "tcp"
#     from_port  = 80
#     to_port    = 80
#     cidr_block = "0.0.0.0/0"
#   }
#
#   # Allow HTTPS
#   ingress {
#     rule_no    = 110
#     action     = "allow"
#     protocol   = "tcp"
#     from_port  = 443
#     to_port    = 443
#     cidr_block = "0.0.0.0/0"
#   }
#
#   # Deny all other traffic from specific CIDR
#   ingress {
#     rule_no    = 200
#     action     = "deny"
#     protocol   = "-1"
#     from_port  = 0
#     to_port    = 0
#     cidr_block = "192.0.2.0/24"
#   }
#
#   # Allow all other traffic
#   ingress {
#     rule_no    = 300
#     action     = "allow"
#     protocol   = "-1"
#     from_port  = 0
#     to_port    = 0
#     cidr_block = "0.0.0.0/0"
#   }
#
#   egress {
#     rule_no    = 100
#     action     = "allow"
#     protocol   = "-1"
#     from_port  = 0
#     to_port    = 0
#     cidr_block = "0.0.0.0/0"
#   }
#
#   tags = {
#     Name = "restrictive-nacl"
#   }
# }

################################################################################
# Common Protocol Numbers Reference
################################################################################
# -1  = All protocols
# 1   = ICMP
# 6   = TCP
# 17  = UDP
# 47  = GRE
# 50  = ESP (IPSec)
# 51  = AH (IPSec)
# 58  = ICMPv6
#
# For a complete list, see:
# https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml

################################################################################
# Best Practices
################################################################################
# 1. Rule Numbering: Use increments of 10 or 100 to allow for future rule insertions
# 2. Evaluation Order: Rules are evaluated in order from lowest to highest rule number
# 3. Default Deny: Network ACLs have implicit deny rules; explicitly allow required traffic
# 4. Stateless: Unlike security groups, network ACLs are stateless; you need both
#    ingress and egress rules for bidirectional traffic
# 5. Ephemeral Ports: Remember to allow ephemeral ports (typically 1024-65535) for
#    return traffic in stateless ACLs
# 6. Conflict Avoidance: Don't mix inline rules with standalone aws_network_acl_rule resources
# 7. Association Management: Don't use both subnet_ids attribute and
#    aws_network_acl_association resources for the same subnet
