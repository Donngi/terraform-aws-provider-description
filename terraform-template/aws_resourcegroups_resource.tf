################################################################################
# Resource: aws_resourcegroups_resource
################################################################################
# Terraform resource for managing an AWS Resource Groups Resource.
#
# This resource allows you to add individual resources to an AWS Resource Group.
# Resource Groups help you organize and manage your AWS resources. You can use
# resource groups to organize resources by application, environment, or other
# criteria.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_resource
################################################################################

resource "aws_resourcegroups_resource" "example" {
  ##############################################################################
  # Required Arguments
  ##############################################################################

  # group_arn - (Required) Name or ARN of the resource group to add resources to.
  # Type: string
  # Example: "arn:aws:resource-groups:us-east-1:123456789012:group/example-group"
  group_arn = aws_resourcegroups_group.example.arn

  # resource_arn - (Required) ARN of the resource to be added to the group.
  # Type: string
  # Example: "arn:aws:ec2:us-east-1:123456789012:instance/i-1234567890abcdef0"
  # Note: The resource must exist before being added to the group.
  resource_arn = aws_ec2_host.example.arn

  ##############################################################################
  # Optional Arguments
  ##############################################################################

  # region - (Optional) Region where this resource will be managed.
  # Type: string (computed)
  # Default: Region set in the provider configuration
  # Example: "us-east-1"
  # Documentation: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  ##############################################################################
  # Timeouts Configuration
  ##############################################################################
  # Optional timeouts block to customize timeout durations for specific operations.
  # All timeout values are strings with time units (e.g., "5m", "1h", "30s").

  # timeouts {
  #   # create - (Optional) Timeout for creating the resource group resource association.
  #   # Type: string
  #   # Default: Varies by AWS service
  #   # create = "5m"
  #
  #   # delete - (Optional) Timeout for deleting the resource group resource association.
  #   # Type: string
  #   # Default: Varies by AWS service
  #   # delete = "5m"
  # }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# These attributes are exported by the resource and can be referenced in other
# resources or outputs using: aws_resourcegroups_resource.example.<attribute_name>
#
# - id
#   Type: string
#   Description: A comma-delimited string combining group_arn and resource_arn.
#   Example: "arn:aws:resource-groups:us-east-1:123456789012:group/example,arn:aws:ec2:us-east-1:123456789012:instance/i-1234567890abcdef0"
#
# - resource_type
#   Type: string (computed)
#   Description: The resource type of a resource, such as AWS::EC2::Instance.
#   Example: "AWS::EC2::Host"
#
# - region
#   Type: string (computed)
#   Description: The AWS region where the resource is managed.
################################################################################

################################################################################
# Example Usage - Basic
################################################################################
# This example demonstrates how to add an EC2 Dedicated Host to a Resource Group.

# # Create an EC2 Dedicated Host
# resource "aws_ec2_host" "example" {
#   instance_family   = "t3"
#   availability_zone = "us-east-1a"
#   host_recovery     = "off"
#   auto_placement    = "on"
# }
#
# # Create a Resource Group
# resource "aws_resourcegroups_group" "example" {
#   name = "example-group"
#
#   resource_query {
#     query = jsonencode({
#       ResourceTypeFilters = ["AWS::AllSupported"]
#       TagFilters = [{
#         Key = "Environment"
#         Values = ["Production"]
#       }]
#     })
#   }
# }
#
# # Add the EC2 Host to the Resource Group
# resource "aws_resourcegroups_resource" "example" {
#   group_arn    = aws_resourcegroups_group.example.arn
#   resource_arn = aws_ec2_host.example.arn
# }

################################################################################
# Example Usage - Multiple Resources
################################################################################
# Add multiple AWS resources to a single Resource Group.

# resource "aws_resourcegroups_group" "project" {
#   name = "project-resources"
# }
#
# resource "aws_instance" "web" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t3.micro"
# }
#
# resource "aws_db_instance" "database" {
#   allocated_storage = 20
#   engine           = "mysql"
#   instance_class   = "db.t3.micro"
#   identifier       = "mydb"
# }
#
# # Add EC2 instance to the group
# resource "aws_resourcegroups_resource" "web" {
#   group_arn    = aws_resourcegroups_group.project.arn
#   resource_arn = aws_instance.web.arn
# }
#
# # Add RDS instance to the group
# resource "aws_resourcegroups_resource" "database" {
#   group_arn    = aws_resourcegroups_group.project.arn
#   resource_arn = aws_db_instance.database.arn
# }

################################################################################
# Important Notes
################################################################################
# 1. The resource being added must exist before it can be added to a group.
# 2. The resource group must exist before resources can be added to it.
# 3. Not all AWS resource types support being added to resource groups manually.
# 4. This resource is typically used for resources that don't match tag-based
#    or CloudFormation stack-based queries.
# 5. Removing this resource from Terraform will remove the resource from the
#    group but will not delete the actual AWS resource.
# 6. The resource_arn must be a valid ARN format for the specific AWS service.
#
# Resource Group Use Cases:
# - Organize resources by application, environment, or project
# - Manage and monitor groups of related resources
# - Apply operations to multiple resources at once
# - Implement cost allocation and tracking
# - Simplify resource management and automation
################################################################################
