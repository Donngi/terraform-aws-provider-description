#---------------------------------------------------------------
# Amazon EFS Mount Target
#---------------------------------------------------------------
#
# Provides an Elastic File System (EFS) mount target. Mount targets
# enable EC2 instances in a VPC to access an EFS file system.
# Each mount target is associated with a specific subnet and has
# a corresponding network interface created by Amazon EFS.
#
# Key Concepts:
# - Mount targets allow EFS file systems to be accessed from EC2 instances
# - One mount target per Availability Zone is recommended
# - Can only create mount targets in one VPC at a time
# - IP address type must match the subnet's IP configuration
#
# AWS公式ドキュメント:
#   - Creating mount targets: https://docs.aws.amazon.com/efs/latest/ug/manage-fs-access-create-delete-mount-targets.html
#   - Managing security groups: https://docs.aws.amazon.com/efs/latest/ug/manage-fs-access-update-mount-target-config-sg.html
#   - API Reference: https://docs.aws.amazon.com/efs/latest/ug/API_CreateMountTarget.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_efs_mount_target" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # (Required) The ID of the file system for which the mount target is intended.
  # The file system's lifecycle state must be "available" for mount target creation.
  # Example: "fs-0123456789abcdef1"
  file_system_id = "fs-XXXXXXXXXXXXXXXXX"

  # (Required) The ID of the subnet to add the mount target in.
  # - If the VPC has multiple subnets in an Availability Zone, you can create 
  #   a mount target in only one of those subnets
  # - All EC2 instances in the Availability Zone can share the single mount target
  # - For One Zone file systems, the subnet must be in the same AZ as the file system
  # Example: "subnet-b3983dc4"
  subnet_id = "subnet-XXXXXXXXXXXXXXXXX"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # (Optional) The address (within the address range of the specified subnet) 
  # at which the file system may be mounted via the mount target.
  # - If not specified, Amazon EFS assigns an available address from the subnet
  # - The IP address cannot be changed after the mount target is created
  # - To change an IP address, delete the mount target and create a new one
  # Example: "10.0.1.24"
  # ip_address = "10.0.1.24"

  # (Optional) IP address type for the mount target.
  # Valid values:
  # - "IPV4_ONLY" (default): Only IPv4 addresses
  # - "IPV6_ONLY": Only IPv6 addresses
  # - "DUAL_STACK": Both IPv4 and IPv6 addresses
  # 
  # Important Notes:
  # - The IP address type must match the IP type of the subnet
  # - This overrides the IP addressing attribute of the subnet
  # - For example, if set to "IPV4_ONLY" and the subnet has IPv6 enabled,
  #   the network interface will receive an IPv4 address only
  # ip_address_type = "IPV4_ONLY"

  # (Optional) IPv6 address to use for the mount target.
  # - Valid only when ip_address_type is set to "IPV6_ONLY" or "DUAL_STACK"
  # - If not specified with DUAL_STACK, Amazon EFS assigns an available IPv4 address
  # Example: "2001:0db8:85a3:0000:0000:8a2e:0370:7334"
  # ipv6_address = "2001:0db8:85a3:0000:0000:8a2e:0370:7334"

  # (Optional) A list of up to 5 VPC security group IDs in effect for the mount target.
  # - All security groups must be for the same VPC as the subnet specified
  # - Security groups control inbound and outbound access to the mount target
  # - You can modify security groups after the mount target is created
  # Example: ["sg-01234567", "sg-89abcdef"]
  # security_groups = ["sg-XXXXXXXXXXXXXXXXX"]

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # See: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Timeouts (Optional)
  #---------------------------------------------------------------

  # timeouts {
  #   # (Optional) How long to wait for the mount target to be created.
  #   # Default: 30 minutes
  #   create = "30m"
  #
  #   # (Optional) How long to wait for the mount target to be deleted.
  #   # Default: 30 minutes
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# In addition to all arguments above, the following attributes are exported:
#
# - id                      - The ID of the mount target
# - dns_name                - The DNS name for the EFS file system
#                            (only useful if VPC has DNS hostnames enabled)
# - mount_target_dns_name   - The DNS name for the given subnet/AZ
#                            (only useful if VPC has DNS hostnames enabled)
# - file_system_arn         - Amazon Resource Name of the file system
# - network_interface_id    - The ID of the network interface that Amazon EFS 
#                            created when it created the mount target
# - availability_zone_name  - The name of the Availability Zone (AZ) that the 
#                            mount target resides in
# - availability_zone_id    - The unique and consistent identifier of the 
#                            Availability Zone (AZ) that the mount target resides in
# - owner_id                - AWS account ID that owns the resource
#
# Note: The dns_name and mount_target_dns_name attributes are only useful if 
# the mount target is in a VPC that has support for DNS hostnames enabled.
# See: http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-dns.html
#---------------------------------------------------------------

#---------------------------------------------------------------
# Usage Example
#---------------------------------------------------------------
# resource "aws_efs_mount_target" "alpha" {
#   file_system_id = aws_efs_file_system.foo.id
#   subnet_id      = aws_subnet.alpha.id
# }
#
# resource "aws_vpc" "foo" {
#   cidr_block = "10.0.0.0/16"
# }
#
# resource "aws_subnet" "alpha" {
#   vpc_id            = aws_vpc.foo.id
#   availability_zone = "us-west-2a"
#   cidr_block        = "10.0.1.0/24"
# }
#---------------------------------------------------------------
