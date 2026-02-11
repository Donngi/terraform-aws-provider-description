#==============================================================================
# AWS CloudTrail Resource Template
#==============================================================================
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# This template provides comprehensive configuration options for aws_cloudtrail.
# It includes all available properties based on the Terraform AWS Provider schema.
#
# Note: This template reflects the schema at the time of generation.
# Always refer to the official documentation for the latest specifications:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail
#==============================================================================

resource "aws_cloudtrail" "example" {
  #----------------------------------------------------------------------------
  # Required Arguments
  #----------------------------------------------------------------------------

  # (Required) Name of the trail.
  # A unique name for the CloudTrail trail within the AWS account/region.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-concepts.html#cloudtrail-concepts-trails
  name = "example-trail"

  # (Required) Name of the S3 bucket designated for publishing log files.
  # The bucket must have appropriate bucket policy to allow CloudTrail to write logs.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-s3-bucket-policy-for-cloudtrail.html
  s3_bucket_name = "my-cloudtrail-bucket"

  #----------------------------------------------------------------------------
  # Optional Arguments
  #----------------------------------------------------------------------------

  # (Optional) S3 key prefix that follows the name of the bucket designated for log file delivery.
  # Allows organizing CloudTrail logs into a specific folder structure within the S3 bucket.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-find-log-files.html
  s3_key_prefix = "cloudtrail-logs"

  # (Optional) Whether the trail is publishing events from global services such as IAM to the log files.
  # Defaults to true. Global service events include IAM, AWS STS, and CloudFront.
  # Only one trail per region should have this enabled to avoid duplicate events.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-concepts.html#cloudtrail-concepts-global-service-events
  include_global_service_events = true

  # (Optional) Whether the trail is created in the current region or in all regions.
  # Defaults to false. When true, CloudTrail records events in all AWS regions.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-concepts.html#cloudtrail-concepts-trails-multi-region
  is_multi_region_trail = false

  # (Optional) Whether the trail is an AWS Organizations trail.
  # Organization trails log events for the master account and all member accounts.
  # Can only be created in the organization master account. Defaults to false.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/creating-trail-organization.html
  is_organization_trail = false

  # (Optional) Enables logging for the trail.
  # When set to true, logging is started by calling the StartLogging API.
  # When set to false, logging is stopped by calling the StopLogging API.
  # Defaults to true.
  # https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_StartLogging.html
  enable_logging = true

  # (Optional) Whether log file integrity validation is enabled.
  # When enabled, CloudTrail creates a hash of the log file for validation.
  # Defaults to false.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-log-file-validation-intro.html
  enable_log_file_validation = false

  # (Optional) KMS key ARN to use to encrypt the logs delivered by CloudTrail.
  # Enables server-side encryption of CloudTrail log files with AWS KMS.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/encrypting-cloudtrail-log-files-with-aws-kms.html
  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # (Optional) Log group name using an ARN that represents the log group to which CloudTrail logs will be delivered.
  # Note that CloudTrail requires the Log Stream wildcard (e.g., arn:aws:logs:region:account-id:log-group:log-group-name:*)
  # Allows sending CloudTrail events to CloudWatch Logs for real-time monitoring and alerting.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/send-cloudtrail-events-to-cloudwatch-logs.html
  cloud_watch_logs_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs:*"

  # (Optional) Role for the CloudWatch Logs endpoint to assume to write to a user's log group.
  # The IAM role must have permissions to create log streams and put log events.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-required-policy-for-cloudwatch-logs.html
  cloud_watch_logs_role_arn = "arn:aws:iam::123456789012:role/CloudTrailRoleForCloudWatchLogs"

  # (Optional) Name of the Amazon SNS topic defined for notification of log file delivery.
  # Specify the SNS topic ARN if it resides in another region.
  # Enables notifications when log files are delivered to S3.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/configure-sns-notifications-for-cloudtrail.html
  sns_topic_name = "cloudtrail-notifications"

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # For multi-region trails, this should be the home region of the trail.
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # (Optional) Map of tags to assign to the trail.
  # If configured with a provider default_tags configuration block, tags with matching keys
  # will overwrite those defined at the provider-level.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-tagging.html
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #----------------------------------------------------------------------------
  # Event Selector Configuration (Basic)
  #----------------------------------------------------------------------------
  # Note: event_selector and advanced_event_selector are mutually exclusive.
  # Use event_selector for basic data event logging.
  # Maximum of 5 event selectors per trail.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-data-events-with-cloudtrail.html

  event_selector {
    # (Optional) Whether to include management events for your trail.
    # Management events include control plane operations like CreateBucket, TerminateInstances.
    # Defaults to true.
    # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-management-events-with-cloudtrail.html
    include_management_events = true

    # (Optional) Type of events to log.
    # Valid values: "ReadOnly", "WriteOnly", "All"
    # Default value is "All".
    # ReadOnly includes operations that read resources (e.g., GetObject, DescribeInstances)
    # WriteOnly includes operations that modify resources (e.g., PutObject, TerminateInstances)
    read_write_type = "All"

    # (Optional) Set of AWS management event sources to exclude.
    # Useful for reducing log volume by excluding high-frequency event sources.
    # Common values: "kms.amazonaws.com", "rdsdata.amazonaws.com"
    # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-management-events-with-cloudtrail.html#logging-management-events-excluding-services
    exclude_management_event_sources = ["kms.amazonaws.com"]

    # (Optional) Configuration block for data events.
    # Data events provide visibility into resource operations performed on or within a resource.
    # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-data-events-with-cloudtrail.html
    data_resource {
      # (Required) Resource type in which you want to log data events.
      # Valid values: "AWS::S3::Object", "AWS::Lambda::Function", "AWS::DynamoDB::Table"
      type = "AWS::S3::Object"

      # (Required) List of ARN strings or partial ARN strings to specify selectors for data events.
      # For S3: "arn:aws:s3:::bucket-name/" for all objects, "arn:aws:s3:::bucket-name/key" for specific objects
      # For Lambda: "arn:aws:lambda" for all functions, or specific function ARN
      # For DynamoDB: "arn:aws:dynamodb" for all tables, or specific table ARN
      # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-data-events-with-cloudtrail.html#logging-data-events-examples
      values = ["arn:aws:s3:::my-bucket/"]
    }
  }

  #----------------------------------------------------------------------------
  # Advanced Event Selector Configuration
  #----------------------------------------------------------------------------
  # Note: advanced_event_selector and event_selector are mutually exclusive.
  # Use advanced_event_selector for fine-grained filtering of data events.
  # Supports filtering on eventName, resources.ARN, readOnly, and other fields.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-data-events-with-cloudtrail.html#creating-data-event-selectors-advanced

  # advanced_event_selector {
  #   # (Optional) Name of the advanced event selector.
  #   # Descriptive name to identify the purpose of this selector.
  #   name = "Log all S3 data events"
  #
  #   # (Required) Configuration block for field selectors.
  #   # At least one field_selector block is required per advanced_event_selector.
  #   # Multiple field_selector blocks create AND conditions.
  #   # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/filtering-data-events.html
  #   field_selector {
  #     # (Required) Field to match against.
  #     # Common values: "eventCategory", "resources.type", "resources.ARN", "eventName", "readOnly"
  #     # eventCategory: "Data" for data events, "Management" for management events
  #     field = "eventCategory"
  #
  #     # (Optional) List of values that must exactly match the field.
  #     # For eventCategory: ["Data"] or ["Management"]
  #     equals = ["Data"]
  #
  #     # (Optional) List of values where the field must start with one of these values.
  #     # Useful for filtering by event name patterns (e.g., ["Delete"] for all delete operations)
  #     starts_with = []
  #
  #     # (Optional) List of values where the field must end with one of these values.
  #     # Useful for filtering by file extensions or ARN patterns.
  #     ends_with = []
  #
  #     # (Optional) List of values where the field must NOT exactly match.
  #     # Inverse of equals, used for excluding specific values.
  #     not_equals = []
  #
  #     # (Optional) List of values where the field must NOT start with.
  #     # Useful for excluding specific ARN prefixes or event name patterns.
  #     not_starts_with = []
  #
  #     # (Optional) List of values where the field must NOT end with.
  #     # Inverse of ends_with, used for exclusion patterns.
  #     not_ends_with = []
  #   }
  #
  #   field_selector {
  #     field  = "resources.type"
  #     equals = ["AWS::S3::Object"]
  #   }
  # }

  #----------------------------------------------------------------------------
  # Insight Selector Configuration
  #----------------------------------------------------------------------------
  # CloudTrail Insights helps identify unusual operational activity.
  # Insights events are logged when CloudTrail detects unusual activity.
  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-insights-events-with-cloudtrail.html

  # insight_selector {
  #   # (Required) Type of insights to log on a trail.
  #   # Valid values:
  #   #   - "ApiCallRateInsight": Identifies unusual API call rate patterns
  #   #   - "ApiErrorRateInsight": Identifies unusual API error rate patterns
  #   # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-insights-events-with-cloudtrail.html#logging-insights-events-with-cloudtrail-insight-types
  #   insight_type = "ApiCallRateInsight"
  # }

  # insight_selector {
  #   insight_type = "ApiErrorRateInsight"
  # }
}

#==============================================================================
# Computed Attributes (Read-Only)
#==============================================================================
# The following attributes are computed by AWS and cannot be set in configuration:
#
# - arn: ARN of the trail
# - home_region: Region in which the trail was created
# - id: ARN of the trail (same as arn)
# - sns_topic_arn: ARN of the SNS topic that CloudTrail uses to send notifications
# - tags_all: Map of tags including those inherited from provider default_tags
#
# These can be referenced in other resources using:
# aws_cloudtrail.example.arn
# aws_cloudtrail.example.home_region
#==============================================================================
