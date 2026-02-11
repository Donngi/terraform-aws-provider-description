################################################################################
# Resource: aws_redshift_subnet_group
# Provider Version: 6.28.0
# Description: Creates a new Amazon Redshift subnet group. You must provide a list
#              of one or more subnets in your existing Amazon Virtual Private Cloud
#              (Amazon VPC) when creating Amazon Redshift subnet group.
#
# Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_subnet_group
################################################################################

resource "aws_redshift_subnet_group" "example" {
  ##############################################################################
  # Required Arguments
  ##############################################################################

  # name - (Required) The name of the Redshift Subnet group.
  # Type: string
  name = "example-redshift-subnet-group"

  # subnet_ids - (Required) An array of VPC subnet IDs.
  # Type: set(string)
  # Note: You must provide a list of one or more subnets in your existing VPC
  subnet_ids = [
    "subnet-12345678",
    "subnet-87654321"
  ]

  ##############################################################################
  # Optional Arguments
  ##############################################################################

  # description - (Optional) The description of the Redshift Subnet group.
  # Type: string
  # Default: "Managed by Terraform"
  description = "Example Redshift subnet group for production cluster"

  # region - (Optional) Region where this resource will be managed.
  # Type: string
  # Default: Region set in the provider configuration
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  # tags - (Optional) A map of tags to assign to the resource.
  # Type: map(string)
  # Note: If configured with a provider default_tags configuration block,
  #       tags with matching keys will overwrite those defined at the provider-level
  tags = {
    Name        = "example-redshift-subnet-group"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }

  # tags_all - (Optional, Computed) A map of tags assigned to the resource,
  # including those inherited from the provider default_tags configuration block.
  # Type: map(string)
  # Note: This is typically computed and managed automatically

  ##############################################################################
  # Computed Attributes (Read-Only)
  ##############################################################################

  # arn - Amazon Resource Name (ARN) of the Redshift Subnet group name
  # Type: string
  # Example: arn:aws:redshift:us-west-2:123456789012:subnetgroup:example-redshift-subnet-group

  # id - The Redshift Subnet group ID.
  # Type: string
  # Example: example-redshift-subnet-group
}

################################################################################
# Example Usage with VPC and Subnets
################################################################################

# resource "aws_vpc" "example" {
#   cidr_block = "10.1.0.0/16"
#
#   tags = {
#     Name = "redshift-vpc"
#   }
# }
#
# resource "aws_subnet" "subnet_a" {
#   cidr_block        = "10.1.1.0/24"
#   availability_zone = "us-west-2a"
#   vpc_id            = aws_vpc.example.id
#
#   tags = {
#     Name = "redshift-subnet-a"
#   }
# }
#
# resource "aws_subnet" "subnet_b" {
#   cidr_block        = "10.1.2.0/24"
#   availability_zone = "us-west-2b"
#   vpc_id            = aws_vpc.example.id
#
#   tags = {
#     Name = "redshift-subnet-b"
#   }
# }
#
# resource "aws_redshift_subnet_group" "example" {
#   name       = "example-redshift-subnet-group"
#   subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
#
#   tags = {
#     Environment = "Production"
#   }
# }

################################################################################
# Output Examples
################################################################################

# output "redshift_subnet_group_id" {
#   description = "The ID of the Redshift subnet group"
#   value       = aws_redshift_subnet_group.example.id
# }
#
# output "redshift_subnet_group_arn" {
#   description = "The ARN of the Redshift subnet group"
#   value       = aws_redshift_subnet_group.example.arn
# }

################################################################################
# Important Notes
################################################################################

# 1. Subnet Requirements:
#    - At least one subnet is required, but multiple subnets are recommended
#    - Subnets should be in different Availability Zones for high availability
#    - All subnets must be in the same VPC
#
# 2. Naming Constraints:
#    - The name must be unique within your AWS account
#    - Must contain only lowercase letters, numbers, and hyphens
#    - Cannot end with a hyphen or contain two consecutive hyphens
#
# 3. High Availability:
#    - For production workloads, distribute subnets across multiple AZs
#    - Amazon Redshift can automatically failover to a different subnet
#
# 4. Modification Impact:
#    - Changing the name forces a new resource to be created
#    - Adding or removing subnet IDs can be done without recreating the resource
#
# 5. Security Considerations:
#    - Ensure subnets have appropriate network ACLs configured
#    - Use private subnets for Redshift clusters when possible
#    - Configure security groups separately on the Redshift cluster resource
#
# 6. Cost Considerations:
#    - The subnet group itself does not incur charges
#    - Charges apply to the Redshift cluster resources using this subnet group
#
# 7. Region Management:
#    - If region is not specified, the provider's default region is used
#    - Subnets must be in the same region as the Redshift cluster

################################################################################
# Related Resources
################################################################################

# - aws_redshift_cluster: Amazon Redshift cluster resource
# - aws_vpc: VPC containing the subnets
# - aws_subnet: Individual subnets in the subnet group
# - aws_security_group: Security groups for network access control
# - aws_redshift_parameter_group: Parameter group for cluster configuration
