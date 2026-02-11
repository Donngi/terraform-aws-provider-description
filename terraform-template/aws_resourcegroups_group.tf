################################################################################
# AWS Resource Groups Group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group
#
# Provides a Resource Group for organizing and managing AWS resources based on
# tags or CloudFormation stacks.
################################################################################

resource "aws_resourcegroups_group" "example" {
  # (Required) The resource group's name.
  # A resource group name can have a maximum of 127 characters, including letters,
  # numbers, hyphens, dots, and underscores.
  # The name cannot start with `AWS` or `aws`.
  name = "example-resource-group"

  # (Optional) A description of the resource group.
  description = "Resource group for managing application resources"

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # region = "us-east-1"

  # (Required) A resource_query block defines how resources are selected for the group.
  # Resources can be filtered based on tags or resource types.
  resource_query {
    # (Required) The resource query as a JSON string.
    # This example filters EC2 instances with Stage=Test tag.
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "Stage",
      "Values": ["Test"]
    }
  ]
}
JSON

    # (Optional) The type of the resource query.
    # Valid values: TAG_FILTERS_1_0, CLOUDFORMATION_STACK_1_0
    # Default: TAG_FILTERS_1_0
    # type = "TAG_FILTERS_1_0"
  }

  # (Optional) A configuration block associates the resource group with an AWS service
  # and specifies how the service can interact with the resources in the group.
  # configuration {
  #   # (Required) Specifies the type of group configuration item.
  #   # Example: AWS::EC2::CapacityReservationPool, AWS::EC2::HostManagement
  #   type = "AWS::EC2::CapacityReservationPool"
  #
  #   # (Optional) A collection of parameters for this group configuration item.
  #   parameters {
  #     # (Required) The name of the group configuration parameter.
  #     name = "allowed-resource-types"
  #
  #     # (Required) The value or values to be used for the specified parameter.
  #     values = ["AWS::EC2::CapacityReservation"]
  #   }
  # }

  # (Optional) Key-value map of resource tags.
  # If configured with a provider default_tags configuration block,
  # tags with matching keys will overwrite those defined at the provider-level.
  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
  }

  # Optional timeouts configuration
  # timeouts {
  #   create = "5m"
  #   update = "5m"
  # }
}

################################################################################
# Computed Attributes Reference
################################################################################
# arn      - The ARN assigned by AWS for this resource group
# tags_all - A map of tags assigned to the resource, including those inherited
#            from the provider default_tags configuration block

################################################################################
# Example: Resource Query with Multiple Tag Filters
################################################################################
# resource "aws_resourcegroups_group" "multi_tag" {
#   name = "multi-tag-group"
#
#   resource_query {
#     query = <<JSON
# {
#   "ResourceTypeFilters": [
#     "AWS::AllSupported"
#   ],
#   "TagFilters": [
#     {
#       "Key": "Environment",
#       "Values": ["production", "staging"]
#     },
#     {
#       "Key": "Application",
#       "Values": ["web-app"]
#     }
#   ]
# }
# JSON
#   }
# }

################################################################################
# Example: CloudFormation Stack-based Resource Group
################################################################################
# resource "aws_resourcegroups_group" "cloudformation" {
#   name = "cloudformation-stack-group"
#
#   resource_query {
#     type = "CLOUDFORMATION_STACK_1_0"
#     query = <<JSON
# {
#   "ResourceTypeFilters": [
#     "AWS::AllSupported"
#   ],
#   "StackIdentifier": "arn:aws:cloudformation:us-east-1:123456789012:stack/my-stack/guid"
# }
# JSON
#   }
# }

################################################################################
# Example: Resource Group with Configuration
################################################################################
# resource "aws_resourcegroups_group" "with_config" {
#   name = "capacity-reservation-pool"
#
#   resource_query {
#     query = <<JSON
# {
#   "ResourceTypeFilters": [
#     "AWS::EC2::CapacityReservation"
#   ],
#   "TagFilters": [
#     {
#       "Key": "Pool",
#       "Values": ["production"]
#     }
#   ]
# }
# JSON
#   }
#
#   configuration {
#     type = "AWS::EC2::CapacityReservationPool"
#
#     parameters {
#       name   = "allowed-resource-types"
#       values = ["AWS::EC2::CapacityReservation"]
#     }
#   }
#
#   tags = {
#     Purpose = "Capacity Management"
#   }
# }
