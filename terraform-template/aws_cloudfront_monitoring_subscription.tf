# ================================================================================
# Terraform AWS Provider Resource Template
# ================================================================================
# Resource: aws_cloudfront_monitoring_subscription
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# NOTE: This template is generated based on the schema at the time of creation.
#       Always refer to the official documentation for the latest specifications:
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_monitoring_subscription
# ================================================================================

# CloudFront Monitoring Subscription
# Provides a CloudFront monitoring subscription resource to enable additional CloudWatch metrics for a CloudFront distribution.
# This resource allows you to enable real-time metrics for more detailed monitoring of your CloudFront distribution's performance.
#
# AWS Documentation:
# - API Reference: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_MonitoringSubscription.html
# - CloudWatch Monitoring: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/monitoring-using-cloudwatch.html

resource "aws_cloudfront_monitoring_subscription" "example" {
  # ================================================================================
  # Required Arguments
  # ================================================================================

  # distribution_id (Required)
  # The ID of the CloudFront distribution for which you want to enable monitoring subscription.
  # This is the unique identifier of your CloudFront distribution.
  #
  # Type: string
  # Example: "E1A2B3C4D5E6F7"
  distribution_id = "E1A2B3C4D5E6F7"

  # ================================================================================
  # Optional Arguments
  # ================================================================================

  # Note: The 'id' attribute is computed and should not be set explicitly.
  # It will be automatically set to the distribution_id after creation.

  # ================================================================================
  # Nested Blocks
  # ================================================================================

  # monitoring_subscription (Required)
  # A monitoring subscription configuration block that contains information about whether
  # additional CloudWatch metrics are enabled for the CloudFront distribution.
  # This block is required and can only have one instance.
  #
  # AWS Documentation: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_MonitoringSubscription.html
  monitoring_subscription {

    # realtime_metrics_subscription_config (Required)
    # A subscription configuration for additional CloudWatch metrics.
    # This enables real-time metrics that provide more granular monitoring data for your distribution.
    # Additional charges apply when enabling this feature.
    #
    # AWS Documentation: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_RealtimeMetricsSubscriptionConfig.html
    realtime_metrics_subscription_config {

      # realtime_metrics_subscription_status (Required)
      # A flag that indicates whether additional CloudWatch metrics are enabled for the CloudFront distribution.
      # When enabled, CloudFront publishes additional metrics to CloudWatch at one-minute granularity,
      # including cache hit rate, origin latency, and error rate by status code.
      #
      # Type: string
      # Valid Values: "Enabled" | "Disabled"
      # Default: None (must be explicitly set)
      # Note: Enabling additional metrics incurs additional charges. See CloudWatch pricing for details.
      #
      # AWS Documentation: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_RealtimeMetricsSubscriptionConfig.html
      realtime_metrics_subscription_status = "Enabled"
    }
  }
}

# ================================================================================
# Computed Attributes (Read-only)
# ================================================================================
# The following attributes are exported by this resource but cannot be set in configuration:
#
# - id: The ID of the CloudFront monitoring subscription, which corresponds to the distribution_id.

# ================================================================================
# Example Usage
# ================================================================================
# resource "aws_cloudfront_distribution" "example" {
#   # ... distribution configuration ...
# }
#
# resource "aws_cloudfront_monitoring_subscription" "example" {
#   distribution_id = aws_cloudfront_distribution.example.id
#
#   monitoring_subscription {
#     realtime_metrics_subscription_config {
#       realtime_metrics_subscription_status = "Enabled"
#     }
#   }
# }

# ================================================================================
# Important Notes
# ================================================================================
# 1. Enabling real-time metrics incurs additional charges beyond standard CloudWatch metrics.
# 2. CloudFront metrics are sent to the US East (N. Virginia) Region (us-east-1).
# 3. Standard CloudFront metrics are available at no additional cost; this resource enables
#    additional metrics that provide more detailed monitoring capabilities.
# 4. The additional metrics include cache hit rate, origin latency, and detailed error rates.
# 5. Metrics are published at one-minute granularity when enabled.
