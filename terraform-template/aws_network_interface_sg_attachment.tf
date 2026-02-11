################################################################################
# AWS Network Interface Security Group Attachment
################################################################################
# This resource attaches a security group to an Elastic Network Interface (ENI).
# It can be used to attach a security group to any existing ENI, be it a
# secondary ENI or one attached as the primary interface on an instance.
#
# IMPORTANT NOTES:
# - Do not use this resource in conjunction with security groups provided inline
#   in aws_instance or aws_network_interface resources, as it will cause conflicts
#   and spurious diffs
# - Uses the EC2 ModifyNetworkInterfaceAttribute API operation
# - The attachment is immediate and does not require instance restart
#
# AWS Documentation:
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/modify-network-interface-attributes.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface_sg_attachment
#
# Provider Version: 6.28.0
################################################################################

resource "aws_network_interface_sg_attachment" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # The ID of the security group to attach to the network interface
  # Type: string (required)
  #
  # Notes:
  # - Must be a valid security group ID in the same VPC as the network interface
  # - Security group must exist before attachment
  # - Can reference security groups created in the same Terraform configuration
  #
  # Example values:
  # - "sg-0123456789abcdef0" (existing security group)
  # - aws_security_group.example.id (from Terraform resource)
  security_group_id = "sg-0123456789abcdef0"

  # The ID of the network interface to attach the security group to
  # Type: string (required)
  #
  # Notes:
  # - Must be a valid network interface ID
  # - Can be the primary network interface of an EC2 instance
  # - Can be a standalone network interface
  # - The network interface can be attached or detached from an instance
  #
  # Example values:
  # - "eni-0123456789abcdef0" (standalone ENI)
  # - aws_instance.example.primary_network_interface_id (instance primary ENI)
  # - aws_network_interface.example.id (from Terraform resource)
  # - data.aws_instance.example.network_interface_id (from data source)
  network_interface_id = "eni-0123456789abcdef0"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # Region where this resource will be managed
  # Type: string (optional, computed)
  #
  # Notes:
  # - Defaults to the region set in the provider configuration
  # - Useful for multi-region deployments
  # - Must match the region of the network interface
  #
  # Example: "us-east-1"
  # region = "us-east-1"

  ################################################################################
  # Timeouts Configuration
  ################################################################################
  # Configure operation timeouts for this resource
  #
  # timeouts {
  #   # Maximum time to wait for security group attachment
  #   # Default: Not specified (uses AWS API default)
  #   # Example: "10m" (10 minutes)
  #   create = "10m"
  #
  #   # Maximum time to wait for reading the attachment status
  #   # Default: Not specified (uses AWS API default)
  #   # Example: "5m" (5 minutes)
  #   read = "5m"
  #
  #   # Maximum time to wait for security group detachment
  #   # Default: Not specified (uses AWS API default)
  #   # Example: "10m" (10 minutes)
  #   delete = "10m"
  # }

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################
  # These attributes are exported and can be referenced in other resources:
  #
  # - id: The ID of the attachment (format: security_group_id-network_interface_id)
}

################################################################################
# Example Usage Scenarios
################################################################################

# Example 1: Attach security group to an EC2 instance's primary network interface
# resource "aws_instance" "web" {
#   instance_type = "t2.micro"
#   ami           = data.aws_ami.ubuntu.id
#
#   tags = {
#     Name = "web-server"
#   }
# }
#
# resource "aws_security_group" "web_sg" {
#   name_prefix = "web-"
#   description = "Security group for web server"
#   vpc_id      = aws_vpc.main.id
#
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = {
#     Name = "web-security-group"
#   }
# }
#
# resource "aws_network_interface_sg_attachment" "web_sg_attach" {
#   security_group_id    = aws_security_group.web_sg.id
#   network_interface_id = aws_instance.web.primary_network_interface_id
# }

# Example 2: Attach security group to an existing instance via data source
# data "aws_instance" "existing" {
#   instance_id = "i-1234567890abcdef0"
# }
#
# resource "aws_security_group" "additional_sg" {
#   name_prefix = "additional-"
#   description = "Additional security group for existing instance"
#   vpc_id      = data.aws_instance.existing.vpc_id
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
#
# resource "aws_network_interface_sg_attachment" "additional_attach" {
#   security_group_id    = aws_security_group.additional_sg.id
#   network_interface_id = data.aws_instance.existing.network_interface_id
# }

# Example 3: Attach security group to a standalone network interface
# resource "aws_network_interface" "standalone" {
#   subnet_id = aws_subnet.main.id
#
#   tags = {
#     Name = "standalone-eni"
#   }
# }
#
# resource "aws_security_group" "standalone_sg" {
#   name_prefix = "standalone-"
#   vpc_id      = aws_vpc.main.id
# }
#
# resource "aws_network_interface_sg_attachment" "standalone_attach" {
#   security_group_id    = aws_security_group.standalone_sg.id
#   network_interface_id = aws_network_interface.standalone.id
# }

# Example 4: Multiple security group attachments to the same network interface
# resource "aws_network_interface" "multi_sg" {
#   subnet_id = aws_subnet.main.id
# }
#
# resource "aws_security_group" "sg1" {
#   name_prefix = "sg1-"
#   vpc_id      = aws_vpc.main.id
# }
#
# resource "aws_security_group" "sg2" {
#   name_prefix = "sg2-"
#   vpc_id      = aws_vpc.main.id
# }
#
# resource "aws_network_interface_sg_attachment" "attach1" {
#   security_group_id    = aws_security_group.sg1.id
#   network_interface_id = aws_network_interface.multi_sg.id
# }
#
# resource "aws_network_interface_sg_attachment" "attach2" {
#   security_group_id    = aws_security_group.sg2.id
#   network_interface_id = aws_network_interface.multi_sg.id
# }

################################################################################
# Important Considerations
################################################################################
# 1. CONFLICT AVOIDANCE:
#    - Do not use this resource if security groups are already specified in:
#      * aws_instance resource (vpc_security_group_ids argument)
#      * aws_network_interface resource (security_groups argument)
#    - This will cause Terraform to constantly try to reconcile differences
#
# 2. SECURITY GROUP LIMITS:
#    - EC2 network interfaces can have up to 5 security groups attached
#    - Plan your security group strategy accordingly
#
# 3. VPC REQUIREMENTS:
#    - Security groups and network interfaces must be in the same VPC
#    - Cross-VPC attachments are not supported
#
# 4. DEPENDENCIES:
#    - The network interface must exist before attaching security groups
#    - The security group must exist before attachment
#    - Terraform handles these dependencies automatically when using references
#
# 5. INSTANCE STATE:
#    - Security group attachments can be modified without stopping the instance
#    - Changes take effect immediately
#
# 6. DELETION BEHAVIOR:
#    - Destroying this resource removes the security group from the network interface
#    - The security group and network interface themselves are not deleted
#    - If the network interface has no security groups, the default security group is applied
#
# 7. IMPORT:
#    - Existing attachments can be imported using: security_group_id/network_interface_id
#    - Example: terraform import aws_network_interface_sg_attachment.example sg-12345/eni-67890
#
# 8. USE CASES:
#    - Adding security groups to instances created outside Terraform
#    - Dynamically managing security groups on running instances
#    - Separating security group lifecycle from instance lifecycle
#    - Managing security groups on secondary network interfaces
