################################################################################
# Amazon Redshift Serverless Workgroup
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/redshiftserverless_workgroup
################################################################################

# Creates a new Amazon Redshift Serverless Workgroup.
# A workgroup is a collection of compute resources that allows you to run queries
# and access data in a Redshift Serverless namespace.

resource "aws_redshiftserverless_workgroup" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # (Required) The name of the namespace.
  # The namespace must already exist before creating the workgroup.
  namespace_name = "example-namespace"

  # (Required) The name of the workgroup.
  # Must be unique within your AWS account and region.
  workgroup_name = "example-workgroup"

  # ============================================================================
  # Optional Arguments - Capacity and Performance
  # ============================================================================

  # (Optional) The base data warehouse capacity of the workgroup in Redshift Processing Units (RPUs).
  # Default: 128 RPUs
  # Valid values: 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 128, 136, 144, 152, 160, 168, 176, 184, 192, 200, 208, 216, 224, 232, 240, 248, 256, 264, 272, 280, 288, 296, 304, 312, 320, 328, 336, 344, 352, 360, 368, 376, 384, 392, 400, 408, 416, 424, 432, 440, 448, 456, 464, 472, 480, 488, 496, 504, 512
  base_capacity = 128

  # (Optional) The maximum data-warehouse capacity Amazon Redshift Serverless uses to serve queries,
  # specified in Redshift Processing Units (RPUs).
  # If not specified, workgroup can scale up to the account limit.
  max_capacity = 512

  # (Optional) Price-performance scaling for the workgroup.
  # This feature automatically optimizes performance based on your price-performance preference.
  price_performance_target {
    # (Required) Whether to enable price-performance scaling.
    enabled = true

    # (Required) The price-performance scaling level.
    # Valid values:
    #   1   - LOW_COST: Optimize for cost
    #   25  - ECONOMICAL: Balance cost with some performance
    #   50  - BALANCED: Equal balance of cost and performance
    #   75  - RESOURCEFUL: Optimize for performance with some cost consideration
    #   100 - HIGH_PERFORMANCE: Optimize for maximum performance
    level = 50
  }

  # ============================================================================
  # Optional Arguments - Network Configuration
  # ============================================================================

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # region = "us-east-1"

  # (Optional) The port number on which the cluster accepts incoming connections.
  # Default: 5439
  port = 5439

  # (Optional) A value that specifies whether the workgroup can be accessed from a public network.
  # Default: false
  # WARNING: Setting this to true makes your workgroup accessible from the internet.
  # Ensure proper security group rules are in place.
  publicly_accessible = false

  # (Optional) The value that specifies whether to turn on enhanced virtual private cloud (VPC) routing,
  # which forces Amazon Redshift Serverless to route traffic through your VPC instead of over the internet.
  # Default: false
  # When enabled, you must have appropriate VPC configurations including NAT gateway for internet access.
  enhanced_vpc_routing = false

  # (Optional) An array of VPC subnet IDs to associate with the workgroup.
  # When set, must contain at least three subnets spanning three Availability Zones.
  # A minimum number of IP addresses is required and scales with the Base Capacity.
  # For more information: https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-known-issues.html
  subnet_ids = [
    "subnet-12345678",
    "subnet-23456789",
    "subnet-34567890"
  ]

  # (Optional) An array of security group IDs to associate with the workgroup.
  # These security groups control inbound and outbound traffic to the workgroup.
  security_group_ids = [
    "sg-12345678"
  ]

  # ============================================================================
  # Optional Arguments - Configuration Parameters
  # ============================================================================

  # (Optional) An array of parameters to set for more control over a serverless database.
  # These parameters control various database behaviors and query monitoring.

  # Example: Enable case-sensitive identifier
  config_parameter {
    # (Required) The key of the parameter.
    # Available options:
    #   - auto_mv: Automatic materialized views
    #   - datestyle: Date display format
    #   - enable_case_sensitive_identifier: Enable case-sensitive identifiers
    #   - enable_user_activity_logging: Log user activity
    #   - query_group: Query group label
    #   - search_path: Schema search path
    #   - require_ssl: Require SSL connections
    #   - use_fips_ssl: Use FIPS-compliant SSL
    #
    # Query monitoring metrics (for performance boundaries):
    #   - max_query_cpu_time: Maximum CPU time per query
    #   - max_query_blocks_read: Maximum blocks read per query
    #   - max_scan_row_count: Maximum rows scanned per query
    #   - max_query_execution_time: Maximum execution time per query
    #   - max_query_queue_time: Maximum queue wait time per query
    #   - max_query_cpu_usage_percent: Maximum CPU usage percentage per query
    #   - max_query_temp_blocks_to_disk: Maximum temp blocks written to disk per query
    #   - max_join_row_count: Maximum rows in join operations
    #   - max_nested_loop_join_row_count: Maximum rows in nested loop joins
    parameter_key = "enable_user_activity_logging"

    # (Required) The value of the parameter to set.
    parameter_value = "true"
  }

  # Example: Set maximum query execution time (in milliseconds)
  config_parameter {
    parameter_key   = "max_query_execution_time"
    parameter_value = "300000" # 5 minutes
  }

  # Example: Set search path for schemas
  config_parameter {
    parameter_key   = "search_path"
    parameter_value = "$user, public"
  }

  # ============================================================================
  # Optional Arguments - Other
  # ============================================================================

  # (Optional) The name of the track for the workgroup.
  # Tracks determine which version of Amazon Redshift Serverless you're using:
  #   - "current": Most up-to-date certified release with latest features, security updates, and performance enhancements
  #   - "trailing": Previous certified release (for conservative upgrade approach)
  # Default: "current"
  # For more information: https://docs.aws.amazon.com/redshift/latest/mgmt/tracks.html
  # track_name = "current"

  # (Optional) A map of tags to assign to the resource.
  # Tags are useful for resource organization, cost tracking, and access control.
  tags = {
    Name        = "example-workgroup"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

################################################################################
# Outputs
################################################################################

# Amazon Resource Name (ARN) of the Redshift Serverless Workgroup
output "workgroup_arn" {
  description = "The ARN of the Redshift Serverless Workgroup"
  value       = aws_redshiftserverless_workgroup.example.arn
}

# The Redshift Workgroup Name (same as workgroup_name input)
output "workgroup_id" {
  description = "The ID of the Redshift Serverless Workgroup"
  value       = aws_redshiftserverless_workgroup.example.id
}

# The Redshift Workgroup ID (unique identifier)
output "workgroup_guid" {
  description = "The unique identifier of the Redshift Serverless Workgroup"
  value       = aws_redshiftserverless_workgroup.example.workgroup_id
}

# The endpoint information for connecting to the workgroup
output "workgroup_endpoint" {
  description = "The endpoint that is created from the workgroup"
  value = {
    # The DNS address of the VPC endpoint
    address = aws_redshiftserverless_workgroup.example.endpoint[0].address
    # The port that Amazon Redshift Serverless listens on
    port = aws_redshiftserverless_workgroup.example.endpoint[0].port
    # VPC endpoint details (if applicable)
    vpc_endpoint = try(aws_redshiftserverless_workgroup.example.endpoint[0].vpc_endpoint, null)
  }
}

# Connection string for JDBC/ODBC clients
output "workgroup_jdbc_url" {
  description = "JDBC connection URL for the workgroup"
  value       = "jdbc:redshift://${aws_redshiftserverless_workgroup.example.endpoint[0].address}:${aws_redshiftserverless_workgroup.example.endpoint[0].port}/dev"
}

# All tags including those inherited from provider default_tags
output "workgroup_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider"
  value       = aws_redshiftserverless_workgroup.example.tags_all
}

################################################################################
# Additional Information
################################################################################

# Endpoint Block Structure:
# The endpoint block contains the following nested attributes:
#   - address: The DNS address of the VPC endpoint
#   - port: The port that Amazon Redshift Serverless listens on
#   - vpc_endpoint: The VPC endpoint details (if configured)
#     - vpc_endpoint_id: The DNS address of the VPC endpoint
#     - vpc_id: The VPC ID
#     - network_interface: Array of network interfaces
#       - availability_zone: The availability zone
#       - network_interface_id: The unique identifier of the network interface
#       - private_ip_address: The IPv4 address of the network interface
#       - subnet_id: The unique identifier of the subnet

# Best Practices:
# 1. Capacity Planning:
#    - Start with base_capacity of 128 RPUs and adjust based on workload
#    - Set max_capacity to prevent unexpected scaling costs
#    - Monitor RPU usage and adjust as needed
#
# 2. Network Security:
#    - Keep publicly_accessible = false for production workloads
#    - Use security groups to restrict access to known IP ranges
#    - Consider using enhanced_vpc_routing for better network control
#    - Deploy across multiple AZs for high availability
#
# 3. Performance Optimization:
#    - Use price_performance_target to balance cost and performance
#    - Set query monitoring parameters to prevent runaway queries
#    - Enable user activity logging for audit and troubleshooting
#
# 4. Maintenance:
#    - Use "current" track for latest features and security updates
#    - Plan for maintenance windows when changing tracks
#    - Monitor AWS announcements for track updates
#
# 5. Cost Management:
#    - Tag resources appropriately for cost allocation
#    - Set max_capacity to control maximum spend
#    - Use price_performance_target level based on workload requirements

# Common Use Cases:
# 1. Development/Testing Environment:
#    - Lower base_capacity (8-32 RPUs)
#    - No max_capacity limit for flexibility
#    - Price-performance level: 1-25 (cost-optimized)
#
# 2. Production Analytics:
#    - Higher base_capacity (128+ RPUs)
#    - Set max_capacity to prevent runaway costs
#    - Price-performance level: 50-75 (balanced to performance)
#
# 3. Mission-Critical Applications:
#    - High base_capacity (256+ RPUs)
#    - Higher max_capacity for scaling
#    - Price-performance level: 75-100 (performance-optimized)
#    - Enhanced VPC routing enabled
#    - Multiple AZs with proper subnet configuration

# Related Resources:
# - aws_redshiftserverless_namespace: Required before creating workgroup
# - aws_redshiftserverless_endpoint_access: For custom VPC endpoint configuration
# - aws_redshiftserverless_usage_limit: To set usage limits for cost control
# - aws_security_group: For network access control
# - aws_subnet: For VPC network configuration
