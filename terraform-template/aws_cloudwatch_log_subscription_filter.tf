# ================================================================================
# Terraform AWS Resource Template: aws_cloudwatch_log_subscription_filter
# ================================================================================
#
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# ⚠️ NOTE:
# This template was generated based on the provider schema and documentation
# available at the time of generation. Always refer to the official documentation
# for the most up-to-date information and best practices:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter
#
# ================================================================================

# CloudWatch Logs subscription filter resource
# Provides the ability to stream log events from a CloudWatch Logs log group to
# destinations such as Amazon Kinesis Data Streams, Amazon Kinesis Data Firehose,
# or AWS Lambda functions for real-time processing and analysis.
#
# AWS Documentation:
# - Subscription Concepts: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/subscription-concepts.html
# - Subscriptions Overview: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Subscriptions.html
# - API Reference: https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutSubscriptionFilter.html

resource "aws_cloudwatch_log_subscription_filter" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # (Required) Name for the subscription filter.
  # This is a unique identifier for the subscription filter within the log group.
  #
  # Type: string
  name = "example-subscription-filter"

  # (Required) Name of the log group to associate the subscription filter with.
  # The log group must exist before creating the subscription filter.
  #
  # Type: string
  # Example: "/aws/lambda/my-function" or "my-application-logs"
  log_group_name = "/aws/lambda/example-function"

  # (Required) ARN of the destination to deliver matching log events to.
  # Supported destinations:
  # - Amazon Kinesis Data Stream ARN
  # - Amazon Kinesis Data Firehose delivery stream ARN
  # - AWS Lambda function ARN
  #
  # Type: string
  # Example: "arn:aws:kinesis:us-east-1:123456789012:stream/my-stream"
  # Example: "arn:aws:lambda:us-east-1:123456789012:function:my-function"
  # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/subscription-concepts.html
  destination_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/example-stream"

  # (Required) Valid CloudWatch Logs filter pattern for subscribing to a filtered
  # stream of log events. Use empty string "" to match everything (all log events).
  #
  # Filter pattern syntax allows you to extract and filter log data based on
  # specific fields and values. Common patterns include:
  # - "" (empty string) - matches all log events
  # - "ERROR" - matches log events containing "ERROR"
  # - "[time, request_id, event_type = Error*]" - structured pattern
  #
  # Type: string
  # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html
  filter_pattern = ""

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # (Optional) ARN of an IAM role that grants CloudWatch Logs permissions to
  # deliver ingested log events to the destination stream.
  #
  # Important notes:
  # - Required for Kinesis Data Streams and Kinesis Data Firehose destinations
  # - NOT required for Lambda destinations (use aws_lambda_permission instead)
  # - Not needed when working with a logical destination for cross-account delivery
  #
  # The IAM role must have a trust policy allowing logs.amazonaws.com to assume
  # the role and permissions to write to the destination resource.
  #
  # Type: string (computed if not specified)
  # Example: "arn:aws:iam::123456789012:role/CloudWatchLogsRole"
  # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/subscription-concepts.html
  role_arn = "arn:aws:iam::123456789012:role/example-cloudwatch-logs-role"

  # (Optional) Method used to distribute log data to the destination.
  # Only applicable when the destination is an Amazon Kinesis Data Stream.
  #
  # Valid values:
  # - "Random" - Distributes log events randomly across shards for even distribution
  # - "ByLogStream" (default) - Groups log events by log stream
  #
  # Type: string
  # Default: "ByLogStream"
  # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/subscription-concepts.html
  distribution = "Random"

  # (Optional) List of system fields to include in the log events sent to the
  # subscription destination. These fields provide source information for
  # centralized log data in the forwarded payload.
  #
  # Valid values:
  # - "@aws.account" - AWS account ID where the log originated
  # - "@aws.region" - AWS region where the log originated
  #
  # To remove this argument after it has been set, specify an empty list []
  # explicitly to avoid perpetual differences.
  #
  # Type: set of strings
  # Example: ["@aws.account", "@aws.region"]
  # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/subscription-concepts.html
  emit_system_fields = ["@aws.account", "@aws.region"]

  # (Optional) Boolean to indicate whether to apply the subscription filter on
  # the transformed version of the log events instead of the original ingested
  # log events.
  #
  # This is valid only for log groups that have an active log transformer.
  # If your log group uses log transformation, set this to true to filter the
  # transformed logs rather than the raw logs.
  #
  # Type: bool (computed if not specified)
  # Default: false
  apply_on_transformed_logs = false

  # (Optional) Region where this resource will be managed.
  # Defaults to the region set in the provider configuration.
  #
  # Type: string (computed if not specified)
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # (Optional) The ID of the subscription filter.
  # This is computed by Terraform and typically not needed to be set manually.
  #
  # Type: string (computed if not specified)
  # id = "example-id"
}

# ================================================================================
# Computed Attributes (Read-Only)
# ================================================================================
#
# The following attributes are exported by this resource but cannot be configured:
#
# - id: The subscription filter ID (typically the same as the name)
#
# ================================================================================
# Important Notes
# ================================================================================
#
# 1. Subscription Limits:
#    - Each account can have one account-level subscription filter per Region
#    - Each log group can have up to two subscription filters
#
# 2. Log Event Delivery:
#    - Log events are base64 encoded and compressed with gzip
#    - Delivery occurs soon after ingestion, usually within three minutes
#    - CloudWatch Logs will retry delivery for up to 24 hours on retryable errors
#
# 3. IAM Permissions:
#    - For Kinesis destinations: role_arn must grant kinesis:PutRecord(s) permissions
#    - For Lambda destinations: use aws_lambda_permission resource instead of role_arn
#    - For cross-account delivery: additional trust policies may be required
#
# 4. Filter Pattern:
#    - Use empty string "" to capture all log events
#    - Complex patterns can extract specific fields from structured logs
#    - Pattern syntax supports JSON, space-delimited, and other formats
#
# 5. Supported Log Classes:
#    - Subscriptions are supported for log groups in the Standard log class
#    - Not supported for Insights-Ready or Archive log classes
#
# References:
# - Filter Pattern Syntax: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html
# - Subscription Filter Concepts: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/subscription-concepts.html
# - Real-time Log Processing: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Subscriptions.html
#
# ================================================================================
