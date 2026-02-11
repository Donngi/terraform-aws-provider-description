# ================================================================================
# aws_rds_cluster_endpoint - RDS Aurora Cluster Custom Endpoint
# ================================================================================
# Provider Version: 6.28.0
#
# Description:
#   Manages an RDS Aurora Cluster Custom Endpoint. Custom endpoints allow you to
#   create specialized connection points for your Aurora cluster that can route
#   connections to specific instances or types of instances.
#
# Use Cases:
#   - Create read-only endpoints that exclude specific instances
#   - Route analytics workloads to specific cluster instances
#   - Separate OLTP and OLAP workloads within the same cluster
#   - Create custom load balancing strategies
#
# Related Resources:
#   - aws_rds_cluster (Required) - The Aurora cluster to create endpoint for
#   - aws_rds_cluster_instance (Optional) - Instances to include/exclude
#
# Documentation:
#   AWS: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Overview.Endpoints.html
#   Terraform: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/rds_cluster_endpoint
# ================================================================================

resource "aws_rds_cluster_endpoint" "example" {
  # ================================================================================
  # Required Arguments
  # ================================================================================

  # ------------------------------------------------------------------------------
  # cluster_identifier (Required, Forces New Resource)
  # ------------------------------------------------------------------------------
  # Type: string
  # Description: The cluster identifier of the Aurora cluster
  # Notes:
  #   - Forces new resource if changed
  #   - Must be a valid Aurora cluster identifier
  #   - The cluster must already exist
  # Examples:
  #   cluster_identifier = "aurora-cluster-demo"
  #   cluster_identifier = aws_rds_cluster.main.id
  # ------------------------------------------------------------------------------
  cluster_identifier = "aurora-cluster-demo"

  # ------------------------------------------------------------------------------
  # cluster_endpoint_identifier (Required, Forces New Resource)
  # ------------------------------------------------------------------------------
  # Type: string
  # Description: The identifier to use for the new endpoint
  # Notes:
  #   - Forces new resource if changed
  #   - Stored as lowercase string
  #   - Must be unique within the cluster
  #   - Maximum 63 alphanumeric characters or hyphens
  #   - Must start with a letter
  #   - Cannot end with a hyphen or contain two consecutive hyphens
  # Examples:
  #   cluster_endpoint_identifier = "analytics-reader"
  #   cluster_endpoint_identifier = "reporting-endpoint"
  # ------------------------------------------------------------------------------
  cluster_endpoint_identifier = "reader"

  # ------------------------------------------------------------------------------
  # custom_endpoint_type (Required)
  # ------------------------------------------------------------------------------
  # Type: string
  # Description: The type of the endpoint
  # Valid Values:
  #   - "READER" - Routes connections to read replicas
  #   - "ANY"    - Routes connections to any available instance
  # Notes:
  #   - READER endpoints only route to read replicas
  #   - ANY endpoints can route to primary or read replicas
  #   - Cannot create WRITER type endpoints via Terraform
  # Examples:
  #   custom_endpoint_type = "READER"
  #   custom_endpoint_type = "ANY"
  # ------------------------------------------------------------------------------
  custom_endpoint_type = "READER"

  # ================================================================================
  # Optional Arguments - Instance Selection (Mutually Exclusive)
  # ================================================================================

  # ------------------------------------------------------------------------------
  # static_members (Optional)
  # ------------------------------------------------------------------------------
  # Type: set(string)
  # Description: List of DB instance identifiers that are part of the custom endpoint group
  # Notes:
  #   - Conflicts with excluded_members
  #   - Use this for explicit instance selection
  #   - Instances must be part of the same cluster
  #   - If an instance is removed from the cluster, endpoint behavior may be affected
  # Examples:
  #   static_members = [
  #     "aurora-instance-1",
  #     "aurora-instance-3"
  #   ]
  #   static_members = [
  #     aws_rds_cluster_instance.test1.id,
  #     aws_rds_cluster_instance.test3.id
  #   ]
  # ------------------------------------------------------------------------------
  # static_members = []

  # ------------------------------------------------------------------------------
  # excluded_members (Optional)
  # ------------------------------------------------------------------------------
  # Type: set(string)
  # Description: List of DB instance identifiers to exclude from the custom endpoint group
  # Notes:
  #   - Conflicts with static_members
  #   - All other eligible instances are reachable through the custom endpoint
  #   - Only relevant if static_members is empty
  #   - Useful for excluding specific instances from read traffic
  # Examples:
  #   excluded_members = [
  #     "aurora-instance-2"
  #   ]
  #   excluded_members = [
  #     aws_rds_cluster_instance.test1.id,
  #     aws_rds_cluster_instance.test2.id
  #   ]
  # ------------------------------------------------------------------------------
  excluded_members = [
    # "aurora-instance-1",
    # "aurora-instance-2"
  ]

  # ================================================================================
  # Optional Arguments - General
  # ================================================================================

  # ------------------------------------------------------------------------------
  # region (Optional, Computed)
  # ------------------------------------------------------------------------------
  # Type: string
  # Description: Region where this resource will be managed
  # Notes:
  #   - Defaults to the region set in the provider configuration
  #   - Usually not necessary to set explicitly
  #   - Must match the region of the Aurora cluster
  # Examples:
  #   region = "us-west-2"
  #   region = "eu-central-1"
  # Documentation:
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # ------------------------------------------------------------------------------
  # region = "us-west-2"

  # ------------------------------------------------------------------------------
  # tags (Optional)
  # ------------------------------------------------------------------------------
  # Type: map(string)
  # Description: Key-value map of resource tags
  # Notes:
  #   - Tags are case-sensitive
  #   - Maximum 50 tags per resource
  #   - Keys can have a maximum of 128 characters
  #   - Values can have a maximum of 256 characters
  #   - Inherited from provider default_tags if configured
  # Examples:
  #   tags = {
  #     Environment = "production"
  #     Purpose     = "analytics"
  #     Team        = "data-engineering"
  #   }
  # ------------------------------------------------------------------------------
  tags = {
    Name        = "example-cluster-endpoint"
    Environment = "development"
  }
}

# ================================================================================
# Computed Attributes (Read-Only)
# ================================================================================
# The following attributes are exported and can be referenced:
#
# - arn
#   Type: string
#   Description: Amazon Resource Name (ARN) of the cluster endpoint
#   Example: arn:aws:rds:us-west-2:123456789012:cluster-endpoint:reader
#
# - id
#   Type: string
#   Description: The RDS Cluster Endpoint Identifier
#   Example: reader
#
# - endpoint
#   Type: string
#   Description: The custom endpoint DNS name for the Aurora cluster
#   Example: reader.cluster-custom-aurora-cluster-demo.us-west-2.rds.amazonaws.com
#
# - tags_all
#   Type: map(string)
#   Description: Map of tags assigned to the resource, including provider default_tags
#
# Usage Example:
#   output "endpoint_arn" {
#     value = aws_rds_cluster_endpoint.example.arn
#   }
#   output "connection_string" {
#     value = aws_rds_cluster_endpoint.example.endpoint
#   }
# ================================================================================

# ================================================================================
# Example Configurations
# ================================================================================

# Example 1: Reader Endpoint with Static Members
# ================================================================================
# resource "aws_rds_cluster_endpoint" "analytics" {
#   cluster_identifier          = aws_rds_cluster.main.id
#   cluster_endpoint_identifier = "analytics-reader"
#   custom_endpoint_type        = "READER"
#
#   static_members = [
#     aws_rds_cluster_instance.large_reader_1.id,
#     aws_rds_cluster_instance.large_reader_2.id,
#   ]
#
#   tags = {
#     Name    = "Analytics Reader Endpoint"
#     Purpose = "Heavy analytical queries"
#   }
# }

# Example 2: Reader Endpoint with Excluded Members
# ================================================================================
# resource "aws_rds_cluster_endpoint" "general_read" {
#   cluster_identifier          = aws_rds_cluster.main.id
#   cluster_endpoint_identifier = "general-reader"
#   custom_endpoint_type        = "READER"
#
#   excluded_members = [
#     aws_rds_cluster_instance.reserved_reader.id,
#   ]
#
#   tags = {
#     Name    = "General Purpose Reader"
#     Purpose = "Application read traffic"
#   }
# }

# Example 3: ANY Type Endpoint for Multi-Purpose Workload
# ================================================================================
# resource "aws_rds_cluster_endpoint" "mixed_workload" {
#   cluster_identifier          = aws_rds_cluster.main.id
#   cluster_endpoint_identifier = "mixed-workload"
#   custom_endpoint_type        = "ANY"
#
#   static_members = [
#     aws_rds_cluster_instance.instance_1.id,
#     aws_rds_cluster_instance.instance_2.id,
#   ]
#
#   tags = {
#     Name    = "Mixed Workload Endpoint"
#     Purpose = "Testing and development"
#   }
# }

# ================================================================================
# Important Notes and Best Practices
# ================================================================================
#
# 1. Endpoint Types:
#    - Use READER endpoints for read-only workloads
#    - Use ANY endpoints when you need flexibility in instance selection
#    - Cannot create WRITER type custom endpoints
#
# 2. Instance Selection Strategy:
#    - Use static_members when you want explicit control over which instances serve traffic
#    - Use excluded_members when you want most instances to serve traffic except specific ones
#    - These two options are mutually exclusive
#
# 3. Load Balancing:
#    - Custom endpoints provide basic round-robin load balancing
#    - Connections are distributed across the specified instances
#    - No health checking beyond Aurora's built-in mechanism
#
# 4. High Availability:
#    - If all instances in a custom endpoint fail, connections will fail
#    - Consider having multiple instances in your endpoint configuration
#    - Monitor endpoint health using CloudWatch metrics
#
# 5. Performance Considerations:
#    - Custom endpoints add minimal latency (typically <1ms)
#    - Ideal for workload isolation (e.g., analytics vs. OLTP)
#    - Consider instance class when selecting members
#
# 6. Cost Optimization:
#    - No additional charge for custom endpoints
#    - Pay only for the underlying cluster instances
#    - Can help optimize costs by routing workloads to appropriate instance sizes
#
# 7. Security:
#    - Custom endpoints use the same security groups as the cluster
#    - IAM database authentication works with custom endpoints
#    - Encryption in transit is supported
#
# 8. Limitations:
#    - Maximum 5 custom endpoints per cluster
#    - Endpoint identifier must be unique within the cluster
#    - Cannot modify endpoint type after creation
#
# 9. Monitoring:
#    - Use CloudWatch to monitor endpoint connections
#    - Track DatabaseConnections metric per endpoint
#    - Set up alarms for connection failures
#
# 10. Dependencies:
#     - Ensure aws_rds_cluster exists before creating endpoint
#     - Ensure all referenced instances exist if using static_members or excluded_members
#     - Use depends_on if explicit dependency ordering is needed
#
# ================================================================================
# Troubleshooting
# ================================================================================
#
# Common Issues:
#
# 1. "Cluster not found" error:
#    - Verify cluster_identifier is correct
#    - Ensure the cluster exists in the same region
#    - Check if cluster is in available state
#
# 2. "Invalid endpoint identifier" error:
#    - Identifier must start with a letter
#    - Can only contain alphanumeric characters and hyphens
#    - Cannot end with hyphen or contain consecutive hyphens
#
# 3. "Instance not found" error:
#    - Verify instance identifiers in static_members or excluded_members
#    - Ensure instances are part of the specified cluster
#    - Check instance state is available
#
# 4. Connection failures:
#    - Check security group rules
#    - Verify network connectivity
#    - Ensure instances in the endpoint are healthy
#
# 5. "Maximum endpoints reached" error:
#    - Each cluster can have maximum 5 custom endpoints
#    - Remove unused endpoints before creating new ones
#
# ================================================================================
