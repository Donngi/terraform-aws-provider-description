################################################################################
# AWS Route 53 Recovery Control Config Cluster
################################################################################
# Description:
#   Provides an AWS Route 53 Recovery Control Config Cluster.
#   Route 53 Application Recovery Controller is a service that helps manage
#   application recovery across AWS Regions. The cluster is a set of redundant
#   regional endpoints used for recovery control configuration.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/route53recoverycontrolconfig_cluster
#
# Example Usage:
#   resource "aws_route53recoverycontrolconfig_cluster" "example" {
#     name = "georgefitzgerald"
#   }
################################################################################

resource "aws_route53recoverycontrolconfig_cluster" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # name - (Required) Unique name describing the cluster.
  # Type: string
  # Example: "my-recovery-cluster"
  name = "example-cluster"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # network_type - (Optional) Network type of cluster.
  # Type: string
  # Valid values: "IPV4", "DUALSTACK"
  # Default: "IPV4"
  # Example: "DUALSTACK"
  network_type = "IPV4"

  # tags - (Optional) A map of tags to assign to the resource.
  # Type: map(string)
  # Example: { Environment = "production", Team = "platform" }
  # Note: If configured with a provider default_tags configuration block,
  #       tags with matching keys will overwrite those defined at the provider-level.
  tags = {
    Name        = "example-cluster"
    Environment = "production"
  }

  ################################################################################
  # Read-Only Attributes (Computed)
  ################################################################################

  # The following attributes are exported in addition to the arguments above:
  #
  # arn - ARN of the cluster
  # Type: string
  # Example: "arn:aws:route53-recovery-control::123456789012:cluster/abc123"
  #
  # cluster_endpoints - List of 5 endpoints in 5 regions that can be used to talk to the cluster
  # Type: list(object({ endpoint = string, region = string }))
  # Example:
  #   [
  #     {
  #       endpoint = "https://abc123.route53-recovery-cluster.us-east-1.amazonaws.com"
  #       region   = "us-east-1"
  #     },
  #     {
  #       endpoint = "https://abc123.route53-recovery-cluster.us-west-2.amazonaws.com"
  #       region   = "us-west-2"
  #     },
  #     ...
  #   ]
  #
  # status - Status of cluster
  # Type: string
  # Values: "PENDING" (being created), "PENDING_DELETION" (being deleted), "DEPLOYED" (ready)
  # Example: "DEPLOYED"
  #
  # tags_all - A map of tags assigned to the resource, including those inherited
  #            from the provider default_tags configuration block
  # Type: map(string)
  #
  # id - Unique identifier for the cluster (automatically computed)
  # Type: string
}

################################################################################
# Outputs (Example)
################################################################################

# output "cluster_arn" {
#   description = "The ARN of the Route 53 Recovery Control Config Cluster"
#   value       = aws_route53recoverycontrolconfig_cluster.example.arn
# }
#
# output "cluster_endpoints" {
#   description = "The regional endpoints for the cluster"
#   value       = aws_route53recoverycontrolconfig_cluster.example.cluster_endpoints
# }
#
# output "cluster_status" {
#   description = "The status of the cluster"
#   value       = aws_route53recoverycontrolconfig_cluster.example.status
# }

################################################################################
# Additional Notes
################################################################################
#
# - The cluster provides 5 regional endpoints for high availability
# - Clusters are used as the foundation for routing controls and control panels
# - The cluster must be in DEPLOYED status before creating other recovery control resources
# - Network type cannot be changed after cluster creation
# - Deletion protection is handled at the routing control level, not the cluster level
#
################################################################################
