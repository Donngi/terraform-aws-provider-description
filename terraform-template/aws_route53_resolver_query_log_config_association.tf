################################################################################
# Resource: aws_route53_resolver_query_log_config_association
# Purpose: Route 53 Resolver Query Logging Configuration Association
# Provider Version: hashicorp/aws 6.28.0
################################################################################
#
# OVERVIEW:
#   Provides a Route 53 Resolver query logging configuration association resource.
#   Associates an Amazon VPC with a specified query logging configuration.
#   Route 53 Resolver logs DNS queries originating from the associated VPCs.
#
# KEY FEATURES:
#   - Associates VPCs with Resolver query logging configurations
#   - Enables DNS query logging for VPCs to CloudWatch Logs, S3, or Firehose
#   - Supports regional resource management
#   - Provides unique association ID for each VPC-to-config association
#
# COMMON USE CASES:
#   1. Security and Compliance Monitoring
#      - Track and audit DNS queries from VPCs for compliance requirements
#      - Monitor DNS traffic patterns for security analysis
#      - Investigate DNS-based threats or anomalies
#
#   2. Troubleshooting and Diagnostics
#      - Debug DNS resolution issues in VPCs
#      - Analyze DNS query patterns for application performance
#      - Identify misconfigured DNS queries
#
#   3. Multi-VPC Logging Architecture
#      - Associate multiple VPCs with a single query logging configuration
#      - Centralize DNS query logs for cross-VPC analysis
#      - Standardize logging across organizational VPCs
#
# IMPORTANT NOTES:
#   - VPCs and query logging configuration must be in the same Region
#   - To associate multiple VPCs, submit one association resource per VPC
#   - VPC log delivery can only be enabled once for a specific destination type
#   - DNS queries should appear in logs within a few minutes after configuration
#   - Requires proper IAM permissions for Route 53 Resolver and destination service
#   - Association deletion stops query logging for the VPC but doesn't delete the config
#
# DEPENDENCIES:
#   - Requires: aws_route53_resolver_query_log_config (query logging configuration)
#   - Requires: aws_vpc (VPC to associate)
#   - Optional: CloudWatch Log Group, S3 Bucket, or Firehose Delivery Stream
#
# RELATED RESOURCES:
#   - aws_route53_resolver_query_log_config: The query logging configuration
#   - aws_vpc: The VPC to associate with the logging configuration
#   - aws_cloudwatch_log_group: Optional destination for query logs
#   - aws_s3_bucket: Optional destination for query logs
#   - aws_kinesis_firehose_delivery_stream: Optional destination for query logs
#
# AWS DOCUMENTATION:
#   - API Reference:
#     https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53resolver_AssociateResolverQueryLogConfig.html
#   - Managing Query Logging Configurations:
#     https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-query-logging-configurations-managing.html
#
# EXAMPLE ARCHITECTURE:
#   [VPC] --association--> [Query Log Config] --> [CloudWatch Logs / S3 / Firehose]
#     |                         |
#     |                         +-- Multiple VPCs can share one config
#     +-- DNS queries logged from VPC resources
#
################################################################################

resource "aws_route53_resolver_query_log_config_association" "example" {
  #-----------------------------------------------------------------------------
  # REQUIRED ARGUMENTS
  #-----------------------------------------------------------------------------

  # resolver_query_log_config_id - (Required) string
  #   The ID of the Route 53 Resolver query logging configuration that you
  #   want to associate a VPC with.
  #
  # This is the configuration that defines where DNS query logs will be sent
  # (CloudWatch Logs, S3, or Firehose).
  #
  # Example values:
  #   - "rqlc-1234567890abcdef0"
  #   - aws_route53_resolver_query_log_config.example.id
  #
  # API Mapping: ResolverQueryLogConfigId
  resolver_query_log_config_id = aws_route53_resolver_query_log_config.example.id

  # resource_id - (Required) string
  #   The ID of a VPC that you want this query logging configuration to log
  #   queries for.
  #
  # Route 53 Resolver will log all DNS queries originating from resources
  # within this VPC to the destination specified in the query logging
  # configuration.
  #
  # Example values:
  #   - "vpc-1234567890abcdef0"
  #   - aws_vpc.example.id
  #
  # API Mapping: ResourceId
  resource_id = aws_vpc.example.id

  #-----------------------------------------------------------------------------
  # OPTIONAL ARGUMENTS
  #-----------------------------------------------------------------------------

  # region - (Optional) string | Computed
  #   Region where this resource will be managed.
  #
  # Defaults to the Region set in the provider configuration. The VPC and
  # query logging configuration must be in the same Region.
  #
  # Example values:
  #   - "us-east-1"
  #   - "eu-west-1"
  #   - "ap-northeast-1"
  #
  # When to use:
  #   - When managing resources in a specific region different from provider
  #   - For explicit regional resource management in multi-region setups
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #-----------------------------------------------------------------------------
  # COMPUTED ATTRIBUTES (Read-Only)
  #-----------------------------------------------------------------------------
  # These attributes are populated by AWS after creation and cannot be set:
  #
  # id - string
  #   The ID of the Route 53 Resolver query logging configuration association.
  #   This is a unique identifier for this specific VPC-to-config association.
  #   Example: "rqlca-1234567890abcdef0"
  #   API Mapping: Id
  #
  #-----------------------------------------------------------------------------
}

################################################################################
# EXAMPLE: Basic Route 53 Resolver Query Log Config Association
################################################################################

# Example: Associate a VPC with a query logging configuration
#
# resource "aws_route53_resolver_query_log_config_association" "production" {
#   resolver_query_log_config_id = aws_route53_resolver_query_log_config.main.id
#   resource_id                  = aws_vpc.production.id
# }

################################################################################
# EXAMPLE: Multi-VPC Association
################################################################################

# Example: Associate multiple VPCs with a single query logging configuration
#
# resource "aws_route53_resolver_query_log_config_association" "vpc_a" {
#   resolver_query_log_config_id = aws_route53_resolver_query_log_config.shared.id
#   resource_id                  = aws_vpc.vpc_a.id
# }
#
# resource "aws_route53_resolver_query_log_config_association" "vpc_b" {
#   resolver_query_log_config_id = aws_route53_resolver_query_log_config.shared.id
#   resource_id                  = aws_vpc.vpc_b.id
# }

################################################################################
# EXAMPLE: Regional Association
################################################################################

# Example: Explicitly specify region for cross-region management
#
# resource "aws_route53_resolver_query_log_config_association" "regional" {
#   resolver_query_log_config_id = aws_route53_resolver_query_log_config.regional.id
#   resource_id                  = aws_vpc.regional.id
#   region                       = "eu-central-1"
# }

################################################################################
# TERRAFORM RESOURCE REFERENCES
################################################################################
#
# You can reference attributes from this resource in other resources:
#
# resource "some_resource" "example" {
#   # Reference the association ID
#   association_id = aws_route53_resolver_query_log_config_association.example.id
# }
#
################################################################################

################################################################################
# BEST PRACTICES
################################################################################
#
# 1. IAM Permissions
#    - Ensure proper IAM permissions for Route 53 Resolver service
#    - Grant permissions to write to the destination (CloudWatch, S3, Firehose)
#
# 2. Regional Considerations
#    - Always deploy VPC and query logging config in the same Region
#    - Use explicit region parameter for multi-region architectures
#
# 3. Association Management
#    - Use separate association resources for each VPC
#    - Consider using for_each for managing multiple associations
#    - Tag query logging configs for easier association management
#
# 4. Monitoring and Logging
#    - Monitor association status for failures or errors
#    - Set up alerts for association state changes
#    - Verify DNS queries appear in destination within expected timeframe
#
# 5. Cost Optimization
#    - Consider log retention policies for cost management
#    - Use S3 lifecycle policies if logging to S3
#    - Monitor query volume to estimate logging costs
#
# 6. Security
#    - Implement least privilege access to query logs
#    - Encrypt logs at rest and in transit
#    - Use VPC endpoint policies to restrict log access
#
################################################################################

################################################################################
# TROUBLESHOOTING
################################################################################
#
# Common issues and solutions:
#
# Issue: Association fails with "Access Denied"
# Solution: Verify IAM permissions for Route 53 Resolver service role to
#           write to the destination (CloudWatch Logs, S3, or Firehose)
#
# Issue: Association status shows "FAILED"
# Solution: Check if the destination (log group, S3 bucket, or delivery stream)
#           exists and is accessible in the same Region
#
# Issue: DNS queries not appearing in logs
# Solution: Wait a few minutes (typically 2-5 minutes) for logs to appear
#           Verify VPC resources are generating DNS queries
#           Check destination permissions and configuration
#
# Issue: "Resource Not Found" error
# Solution: Verify both VPC and query logging config exist in the same Region
#           Check that resource IDs are correct
#
# Issue: "Limit Exceeded" error
# Solution: Check Route 53 Resolver service quotas
#           Verify number of associations per query logging config
#
################################################################################

################################################################################
# RELATED TERRAFORM RESOURCES
################################################################################
#
# Typically used together with:
#
# resource "aws_route53_resolver_query_log_config" "example" {
#   name            = "example-query-log-config"
#   destination_arn = aws_cloudwatch_log_group.example.arn
# }
#
# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = "example-vpc"
#   }
# }
#
# resource "aws_cloudwatch_log_group" "example" {
#   name              = "/aws/route53/example"
#   retention_in_days = 7
# }
#
################################################################################
