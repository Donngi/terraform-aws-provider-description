################################################################################
# AWS SESv2 Configuration Set Event Destination
# Resource Type: aws_sesv2_configuration_set_event_destination
# Provider Version: 6.28.0
################################################################################
# Description:
# Terraform resource for managing an AWS SESv2 (Simple Email V2) Configuration
# Set Event Destination. This resource allows you to configure where email
# events (such as sends, bounces, complaints, etc.) should be sent for a
# specific configuration set.
#
# Supported Destination Types:
# - CloudWatch: Send metrics to Amazon CloudWatch
# - EventBridge: Send events to Amazon EventBridge (default event bus only)
# - Kinesis Firehose: Stream events to Amazon Kinesis Data Firehose
# - Pinpoint: Send events to Amazon Pinpoint projects
# - SNS: Publish events to Amazon SNS topics
#
# Use Cases:
# - Monitor email sending metrics and performance
# - Track email delivery and engagement events
# - Build automated workflows based on email events
# - Analyze email campaign effectiveness
# - Integrate email events with other AWS services
################################################################################

################################################################################
# Basic Configuration
################################################################################

resource "aws_sesv2_configuration_set_event_destination" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # configuration_set_name - (Required)
  # The name of the configuration set to which this event destination belongs.
  # Must reference an existing SESv2 configuration set.
  # Type: string
  # Example: "my-email-config-set"
  configuration_set_name = "example-configuration-set"

  # event_destination_name - (Required)
  # A unique name that identifies the event destination within the configuration set.
  # Must be unique within the configuration set.
  # Type: string
  # Example: "cloudwatch-events"
  event_destination_name = "example-destination"

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # region - (Optional)
  # Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string
  # Example: "us-east-1", "eu-west-1"
  # region = "us-east-1"

  # ============================================================================
  # Event Destination Block (Required)
  # ============================================================================
  # Defines the event destination configuration including destination type,
  # event types to track, and destination-specific settings.
  # Note: You must specify exactly ONE destination type per event destination.
  # ============================================================================

  event_destination {
    # --------------------------------------------------------------------------
    # Required Arguments (event_destination block)
    # --------------------------------------------------------------------------

    # matching_event_types - (Required)
    # An array specifying which email events should be sent to the destination.
    # Type: set of strings
    # Valid values:
    #   - SEND: Email send events
    #   - REJECT: Email rejection events
    #   - BOUNCE: Email bounce events
    #   - COMPLAINT: Email complaint events
    #   - DELIVERY: Email delivery events
    #   - OPEN: Email open events
    #   - CLICK: Email click events
    #   - RENDERING_FAILURE: Email rendering failure events
    #   - DELIVERY_DELAY: Email delivery delay events
    #   - SUBSCRIPTION: Email subscription events
    matching_event_types = [
      "SEND",
      "BOUNCE",
      "COMPLAINT",
      "DELIVERY",
    ]

    # --------------------------------------------------------------------------
    # Optional Arguments (event_destination block)
    # --------------------------------------------------------------------------

    # enabled - (Optional)
    # When true, the specified event types are sent to the destination.
    # Type: bool
    # Default: false
    enabled = true

    # ==========================================================================
    # Destination Type Configuration
    # ==========================================================================
    # Choose ONE of the following destination types:
    # - cloud_watch_destination
    # - event_bridge_destination
    # - kinesis_firehose_destination
    # - pinpoint_destination
    # - sns_destination
    # ==========================================================================

    # --------------------------------------------------------------------------
    # CloudWatch Destination (Optional)
    # --------------------------------------------------------------------------
    # Send email events as metrics to Amazon CloudWatch for monitoring and
    # analysis. Useful for creating dashboards and alarms based on email metrics.
    # --------------------------------------------------------------------------

    cloud_watch_destination {
      # dimension_configuration - (Required for cloud_watch_destination)
      # Defines custom dimensions for CloudWatch metrics.
      # At least one dimension configuration is required.
      # Type: list of objects

      dimension_configuration {
        # default_dimension_value - (Required)
        # The default value used if the dimension value is not provided when
        # sending an email.
        # Type: string
        # Example: "default", "unknown"
        default_dimension_value = "default"

        # dimension_name - (Required)
        # The name of the CloudWatch dimension.
        # Type: string
        # Example: "campaign", "emailType", "environment"
        dimension_name = "campaign"

        # dimension_value_source - (Required)
        # The location where SESv2 finds the dimension value.
        # Type: string
        # Valid values:
        #   - MESSAGE_TAG: From message tags
        #   - EMAIL_HEADER: From email headers
        #   - LINK_TAG: From link tags
        dimension_value_source = "MESSAGE_TAG"
      }

      # Example: Additional dimension configuration
      # dimension_configuration {
      #   default_dimension_value = "production"
      #   dimension_name          = "environment"
      #   dimension_value_source  = "MESSAGE_TAG"
      # }
    }

    # --------------------------------------------------------------------------
    # EventBridge Destination (Optional)
    # --------------------------------------------------------------------------
    # Send email events to Amazon EventBridge for building event-driven
    # applications. Only the default event bus is supported.
    # --------------------------------------------------------------------------

    # event_bridge_destination {
    #   # event_bus_arn - (Required)
    #   # The ARN of the Amazon EventBridge event bus.
    #   # Must be the default event bus ARN.
    #   # Type: string
    #   # Format: arn:aws:events:region:account-id:event-bus/default
    #   event_bus_arn = "arn:aws:events:us-east-1:123456789012:event-bus/default"
    # }

    # --------------------------------------------------------------------------
    # Kinesis Firehose Destination (Optional)
    # --------------------------------------------------------------------------
    # Stream email events to Amazon Kinesis Data Firehose for real-time
    # analytics, data lakes, or custom processing pipelines.
    # --------------------------------------------------------------------------

    # kinesis_firehose_destination {
    #   # delivery_stream_arn - (Required)
    #   # The ARN of the Kinesis Data Firehose delivery stream.
    #   # Type: string
    #   # Format: arn:aws:firehose:region:account-id:deliverystream/stream-name
    #   delivery_stream_arn = "arn:aws:firehose:us-east-1:123456789012:deliverystream/email-events"
    #
    #   # iam_role_arn - (Required)
    #   # The ARN of the IAM role that grants SESv2 permission to write to
    #   # the Firehose stream.
    #   # Type: string
    #   # Format: arn:aws:iam::account-id:role/role-name
    #   iam_role_arn = "arn:aws:iam::123456789012:role/SESFirehoseRole"
    # }

    # --------------------------------------------------------------------------
    # Pinpoint Destination (Optional)
    # --------------------------------------------------------------------------
    # Send email events to Amazon Pinpoint for campaign management and
    # customer engagement analytics.
    # --------------------------------------------------------------------------

    # pinpoint_destination {
    #   # application_arn - (Required)
    #   # The ARN of the Amazon Pinpoint application.
    #   # Type: string
    #   # Format: arn:aws:mobiletargeting:region:account-id:apps/application-id
    #   application_arn = "arn:aws:mobiletargeting:us-east-1:123456789012:apps/abc123"
    # }

    # --------------------------------------------------------------------------
    # SNS Destination (Optional)
    # --------------------------------------------------------------------------
    # Publish email events to Amazon SNS topics for fan-out to multiple
    # subscribers or integration with other systems.
    # --------------------------------------------------------------------------

    # sns_destination {
    #   # topic_arn - (Required)
    #   # The ARN of the Amazon SNS topic.
    #   # Type: string
    #   # Format: arn:aws:sns:region:account-id:topic-name
    #   topic_arn = "arn:aws:sns:us-east-1:123456789012:email-events"
    # }
  }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# The following attributes are exported and can be referenced in other resources:
#
# - id: A pipe-delimited string combining configuration_set_name and
#       event_destination_name.
#       Format: "configuration-set-name|event-destination-name"
#       Example: aws_sesv2_configuration_set_event_destination.example.id
################################################################################

################################################################################
# Example Usage: CloudWatch Destination
################################################################################

# resource "aws_sesv2_configuration_set" "cloudwatch_example" {
#   configuration_set_name = "cloudwatch-config-set"
# }
#
# resource "aws_sesv2_configuration_set_event_destination" "cloudwatch_example" {
#   configuration_set_name = aws_sesv2_configuration_set.cloudwatch_example.configuration_set_name
#   event_destination_name = "cloudwatch-destination"
#
#   event_destination {
#     cloud_watch_destination {
#       dimension_configuration {
#         default_dimension_value = "campaign1"
#         dimension_name          = "campaign"
#         dimension_value_source  = "MESSAGE_TAG"
#       }
#
#       dimension_configuration {
#         default_dimension_value = "production"
#         dimension_name          = "environment"
#         dimension_value_source  = "MESSAGE_TAG"
#       }
#     }
#
#     enabled              = true
#     matching_event_types = ["SEND", "BOUNCE", "COMPLAINT", "DELIVERY"]
#   }
# }

################################################################################
# Example Usage: EventBridge Destination
################################################################################

# data "aws_cloudwatch_event_bus" "default" {
#   name = "default"
# }
#
# resource "aws_sesv2_configuration_set" "eventbridge_example" {
#   configuration_set_name = "eventbridge-config-set"
# }
#
# resource "aws_sesv2_configuration_set_event_destination" "eventbridge_example" {
#   configuration_set_name = aws_sesv2_configuration_set.eventbridge_example.configuration_set_name
#   event_destination_name = "eventbridge-destination"
#
#   event_destination {
#     event_bridge_destination {
#       event_bus_arn = data.aws_cloudwatch_event_bus.default.arn
#     }
#
#     enabled              = true
#     matching_event_types = ["SEND", "OPEN", "CLICK"]
#   }
# }

################################################################################
# Example Usage: Kinesis Firehose Destination
################################################################################

# resource "aws_kinesis_firehose_delivery_stream" "email_events" {
#   name        = "email-events-stream"
#   destination = "extended_s3"
#
#   extended_s3_configuration {
#     role_arn   = aws_iam_role.firehose_role.arn
#     bucket_arn = aws_s3_bucket.email_logs.arn
#   }
# }
#
# resource "aws_iam_role" "ses_firehose_role" {
#   name = "ses-firehose-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ses.amazonaws.com"
#         }
#       }
#     ]
#   })
# }
#
# resource "aws_iam_role_policy" "ses_firehose_policy" {
#   name = "ses-firehose-policy"
#   role = aws_iam_role.ses_firehose_role.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "firehose:PutRecord",
#           "firehose:PutRecordBatch"
#         ]
#         Effect   = "Allow"
#         Resource = aws_kinesis_firehose_delivery_stream.email_events.arn
#       }
#     ]
#   })
# }
#
# resource "aws_sesv2_configuration_set" "firehose_example" {
#   configuration_set_name = "firehose-config-set"
# }
#
# resource "aws_sesv2_configuration_set_event_destination" "firehose_example" {
#   configuration_set_name = aws_sesv2_configuration_set.firehose_example.configuration_set_name
#   event_destination_name = "firehose-destination"
#
#   event_destination {
#     kinesis_firehose_destination {
#       delivery_stream_arn = aws_kinesis_firehose_delivery_stream.email_events.arn
#       iam_role_arn        = aws_iam_role.ses_firehose_role.arn
#     }
#
#     enabled              = true
#     matching_event_types = ["SEND", "BOUNCE", "COMPLAINT", "DELIVERY", "OPEN", "CLICK"]
#   }
# }

################################################################################
# Example Usage: SNS Destination
################################################################################

# resource "aws_sns_topic" "email_events" {
#   name = "email-events-topic"
# }
#
# resource "aws_sns_topic_policy" "email_events_policy" {
#   arn = aws_sns_topic.email_events.arn
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ses.amazonaws.com"
#         }
#         Action   = "SNS:Publish"
#         Resource = aws_sns_topic.email_events.arn
#       }
#     ]
#   })
# }
#
# resource "aws_sesv2_configuration_set" "sns_example" {
#   configuration_set_name = "sns-config-set"
# }
#
# resource "aws_sesv2_configuration_set_event_destination" "sns_example" {
#   configuration_set_name = aws_sesv2_configuration_set.sns_example.configuration_set_name
#   event_destination_name = "sns-destination"
#
#   event_destination {
#     sns_destination {
#       topic_arn = aws_sns_topic.email_events.arn
#     }
#
#     enabled              = true
#     matching_event_types = ["SEND", "BOUNCE", "COMPLAINT"]
#   }
# }

################################################################################
# Example Usage: Pinpoint Destination
################################################################################

# resource "aws_pinpoint_app" "email_analytics" {
#   name = "email-analytics-app"
# }
#
# resource "aws_sesv2_configuration_set" "pinpoint_example" {
#   configuration_set_name = "pinpoint-config-set"
# }
#
# resource "aws_sesv2_configuration_set_event_destination" "pinpoint_example" {
#   configuration_set_name = aws_sesv2_configuration_set.pinpoint_example.configuration_set_name
#   event_destination_name = "pinpoint-destination"
#
#   event_destination {
#     pinpoint_destination {
#       application_arn = aws_pinpoint_app.email_analytics.arn
#     }
#
#     enabled              = true
#     matching_event_types = ["SEND", "OPEN", "CLICK", "DELIVERY"]
#   }
# }

################################################################################
# Best Practices
################################################################################
# 1. Event Type Selection:
#    - Track only the events you need to reduce costs and complexity
#    - SEND and DELIVERY are essential for monitoring email success rates
#    - BOUNCE and COMPLAINT are critical for maintaining sender reputation
#    - OPEN and CLICK are useful for engagement tracking (requires tracking pixels/links)
#
# 2. Destination Choice:
#    - CloudWatch: Best for real-time monitoring and alerting
#    - EventBridge: Ideal for event-driven workflows and serverless architectures
#    - Kinesis Firehose: Suitable for high-volume streaming and data lakes
#    - SNS: Good for simple notifications and fan-out patterns
#    - Pinpoint: Perfect for integrated email campaign analytics
#
# 3. IAM Permissions:
#    - Ensure proper IAM roles and policies for destination access
#    - Use least-privilege principles when granting permissions
#    - For Firehose, SES needs PutRecord and PutRecordBatch permissions
#    - For SNS, SES needs Publish permissions on the topic
#
# 4. Performance and Cost:
#    - Consider event volume when choosing destinations
#    - CloudWatch custom metrics may incur additional costs
#    - Firehose provides cost-effective streaming for high volumes
#    - Monitor your CloudWatch Logs usage to avoid unexpected charges
#
# 5. Naming Conventions:
#    - Use descriptive names that indicate the destination type and purpose
#    - Examples: "cloudwatch-campaign-metrics", "sns-bounce-alerts"
#
# 6. Multiple Destinations:
#    - You can create multiple event destinations for the same configuration set
#    - Different destinations can track different event types
#    - Useful for separating operational monitoring from analytics
#
# 7. CloudWatch Dimensions:
#    - Use meaningful dimension names that match your tracking needs
#    - MESSAGE_TAG is the most flexible option for custom dimensions
#    - Keep dimension cardinality reasonable to avoid CloudWatch costs
#
# 8. EventBridge Integration:
#    - Only the default event bus is supported
#    - Use EventBridge rules to route events to specific targets
#    - Consider using event patterns to filter events at the EventBridge level
################################################################################

################################################################################
# Important Notes
################################################################################
# - Each configuration set can have multiple event destinations
# - Each event destination must specify exactly ONE destination type
# - The same event types can be sent to multiple destinations
# - Event destinations can be enabled/disabled without deletion
# - The resource ID is a pipe-delimited combination: "config_set|destination_name"
# - Only the default EventBridge event bus is supported
# - CloudWatch dimensions are powerful but can impact costs if not used carefully
# - Ensure destination resources (SNS topics, Firehose streams, etc.) exist
#   before creating the event destination
################################################################################

################################################################################
# Troubleshooting
################################################################################
# Common Issues:
#
# 1. Events Not Appearing:
#    - Verify enabled = true in the event_destination block
#    - Check IAM permissions for the destination service
#    - Ensure the configuration set is attached to your email sending
#    - Verify event types match your email sending scenarios
#
# 2. Permission Errors:
#    - For Firehose: Check IAM role has necessary PutRecord permissions
#    - For SNS: Ensure topic policy allows SES to publish
#    - For EventBridge: Verify event bus permissions
#
# 3. CloudWatch Metrics Not Working:
#    - Verify dimension_value_source matches how you're tagging emails
#    - Check that dimension names are correctly configured
#    - Ensure emails include the required tags/headers
#
# 4. High Costs:
#    - Review CloudWatch custom metrics usage
#    - Consider reducing the number of dimensions
#    - Use Firehose for high-volume scenarios instead of CloudWatch
#    - Filter events at the matching_event_types level
################################################################################

################################################################################
# Related Resources
################################################################################
# - aws_sesv2_configuration_set: The configuration set this destination belongs to
# - aws_cloudwatch_log_group: For storing detailed CloudWatch logs
# - aws_cloudwatch_event_bus: For EventBridge integration
# - aws_kinesis_firehose_delivery_stream: For Firehose streaming
# - aws_sns_topic: For SNS notifications
# - aws_pinpoint_app: For Pinpoint analytics
# - aws_iam_role: For granting SES permissions to access destinations
# - aws_iam_role_policy: For defining specific permissions
################################################################################

################################################################################
# References
################################################################################
# - AWS Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_configuration_set_event_destination
#
# - AWS SESv2 API Documentation:
#   https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_EventDestination.html
#
# - AWS SES Event Publishing:
#   https://docs.aws.amazon.com/ses/latest/dg/monitor-using-event-publishing.html
#
# - AWS SES Configuration Sets:
#   https://docs.aws.amazon.com/ses/latest/dg/using-configuration-sets.html
################################################################################
