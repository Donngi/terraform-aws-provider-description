################################################################################
# AWS Neptune Parameter Group
################################################################################
# Resource: aws_neptune_parameter_group
# Provider Version: 6.28.0
# Description: Manages a Neptune Parameter Group
#
# Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_parameter_group
#
# Neptune parameter groups are used to manage engine configuration values for
# Neptune DB cluster and DB instances. They allow you to customize database
# engine settings for your Neptune deployment.
################################################################################

resource "aws_neptune_parameter_group" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # family - (Required, string)
  # The family of the Neptune parameter group.
  # The parameter group family defines which Neptune engine version this group
  # is compatible with. Common values include:
  # - neptune1: Neptune 1.x engine versions
  # - neptune1.2: Neptune 1.2.x engine versions
  # - neptune1.3: Neptune 1.3.x engine versions
  family = "neptune1.3"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # name - (Optional, Forces new resource, string, computed)
  # The name of the Neptune parameter group.
  # If omitted, Terraform will assign a random, unique name.
  # Must contain only alphanumeric characters, hyphens, or underscores.
  # Conflicts with name_prefix.
  name = "example-neptune-parameter-group"

  # name_prefix - (Optional, Forces new resource, string, computed)
  # Creates a unique name beginning with the specified prefix.
  # Conflicts with name.
  # Useful when you want Terraform to generate unique names while maintaining
  # a consistent naming pattern.
  # name_prefix = "example-"

  # description - (Optional, string)
  # The description of the Neptune parameter group.
  # Defaults to "Managed by Terraform" if not specified.
  # Provides human-readable information about the purpose of this parameter group.
  description = "Neptune parameter group for example cluster"

  # region - (Optional, string, computed)
  # Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Explicitly setting this can be useful for multi-region configurations.
  # region = "us-west-2"

  # tags - (Optional, map of strings)
  # A map of tags to assign to the resource.
  # Tags with matching keys will overwrite those defined at the provider-level
  # via default_tags configuration block.
  # Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-neptune-parameter-group"
    Environment = "development"
    ManagedBy   = "terraform"
  }

  ################################################################################
  # Nested Blocks
  ################################################################################

  # parameter - (Optional, set of objects)
  # A list of Neptune parameters to apply to the parameter group.
  # Each parameter block configures a specific Neptune engine setting.
  # Parameters can be found in the Neptune documentation.
  # Reference: https://docs.aws.amazon.com/neptune/latest/userguide/parameters.html

  parameter {
    # name - (Required, string)
    # The name of the Neptune parameter.
    # Must be a valid Neptune parameter name for the specified family.
    # Example parameters:
    # - neptune_query_timeout: Maximum query execution time
    # - neptune_enable_audit_log: Enable audit logging
    # - neptune_result_cache_enabled: Enable result caching
    name = "neptune_query_timeout"

    # value - (Required, string)
    # The value of the Neptune parameter.
    # Must be a valid value for the specified parameter name.
    # Even numeric values should be specified as strings.
    value = "120000"

    # apply_method - (Optional, string)
    # The apply method of the Neptune parameter.
    # Valid values:
    # - "immediate": Apply changes immediately to all associated instances
    # - "pending-reboot": Apply changes after the next instance reboot
    # Defaults to "pending-reboot" if not specified.
    # Some parameters can only use pending-reboot method.
    apply_method = "immediate"
  }

  parameter {
    name         = "neptune_enable_audit_log"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "neptune_result_cache_enabled"
    value        = "1"
    apply_method = "pending-reboot"
  }
}

################################################################################
# Outputs
################################################################################
# The following attributes are exported and can be referenced in other resources
# or output blocks:
#
# - id: The Neptune parameter group name
# - arn: The Neptune parameter group Amazon Resource Name (ARN)
# - tags_all: A map of tags assigned to the resource, including those inherited
#   from the provider default_tags configuration block

output "neptune_parameter_group_id" {
  description = "The Neptune parameter group name"
  value       = aws_neptune_parameter_group.example.id
}

output "neptune_parameter_group_arn" {
  description = "The Neptune parameter group ARN"
  value       = aws_neptune_parameter_group.example.arn
}

output "neptune_parameter_group_tags_all" {
  description = "All tags assigned to the parameter group"
  value       = aws_neptune_parameter_group.example.tags_all
}

################################################################################
# Additional Notes
################################################################################
#
# 1. Parameter Group Family:
#    - The family must match the Neptune engine version you intend to use
#    - Check AWS documentation for the latest available families
#
# 2. Parameter Application:
#    - Parameters with apply_method = "immediate" take effect right away
#    - Parameters with apply_method = "pending-reboot" require instance restart
#    - Some parameters can only be applied using pending-reboot
#
# 3. Best Practices:
#    - Use descriptive names and tags for easier identification
#    - Test parameter changes in non-production environments first
#    - Review Neptune parameter documentation before modifying values
#    - Monitor Neptune metrics after applying parameter changes
#
# 4. Common Parameters:
#    - neptune_query_timeout: Controls maximum query execution time (milliseconds)
#    - neptune_enable_audit_log: Enables audit logging (0=disabled, 1=enabled)
#    - neptune_result_cache_enabled: Enables result caching (0=disabled, 1=enabled)
#    - neptune_lab_mode: Enables experimental features
#
# 5. Relationship with Other Resources:
#    - Parameter groups are associated with Neptune DB clusters
#    - Use aws_neptune_cluster.parameter_group_name to reference this group
#    - Changes to parameter groups may require cluster or instance modifications
#
# 6. Import:
#    - Neptune Parameter Groups can be imported using the name
#    - Example: terraform import aws_neptune_parameter_group.example example-neptune-parameter-group
#
################################################################################
