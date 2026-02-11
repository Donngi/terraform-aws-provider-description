################################################################################
# AWS SNS SMS Preferences
################################################################################
# Resource: aws_sns_sms_preferences
# Provider Version: 6.28.0
#
# Description:
#   Provides a way to set SNS SMS preferences for your AWS account.
#   This resource configures global SMS settings including spending limits,
#   delivery status logging, and default message types.
#
# Important Notes:
#   - This is a global resource that affects SMS settings across the account/region
#   - All attributes are optional and will use AWS defaults if not specified
#   - Only one instance of this resource should exist per region
#   - Changes to SMS preferences may take a few minutes to propagate
#
# AWS Documentation:
#   https://docs.aws.amazon.com/sns/latest/dg/sms_preferences.html
################################################################################

resource "aws_sns_sms_preferences" "example" {
  #=============================================================================
  # Region Configuration
  #=============================================================================
  # region - (Optional) Region where this resource will be managed
  # Type: string
  # Default: Region set in provider configuration
  #
  # Description:
  #   Specifies the AWS region where SMS preferences will be configured.
  #   If not specified, uses the region from the provider configuration.
  #
  # Regional Endpoints Reference:
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # Example:
  #   region = "us-east-1"
  #-----------------------------------------------------------------------------
  # region = null

  #=============================================================================
  # Spending Limits
  #=============================================================================
  # monthly_spend_limit - (Optional) Monthly spending limit for SMS messages
  # Type: number
  # Default: AWS default (varies by account type)
  # Computed: true
  #
  # Description:
  #   The maximum amount in USD that you are willing to spend each month
  #   to send SMS messages. When this limit is reached, Amazon SNS stops
  #   sending SMS messages for the remainder of the month.
  #
  # Important:
  #   - Must be a positive number
  #   - Default limit varies based on account type and region
  #   - Changing this limit may require AWS support verification
  #   - New accounts typically have lower default limits
  #
  # Example:
  #   monthly_spend_limit = 100.00  # $100 USD per month
  #-----------------------------------------------------------------------------
  # monthly_spend_limit = null

  #=============================================================================
  # Delivery Status Logging Configuration
  #=============================================================================
  # delivery_status_iam_role_arn - (Optional) IAM role for CloudWatch logging
  # Type: string
  #
  # Description:
  #   The ARN of the IAM role that allows Amazon SNS to write logs about
  #   SMS deliveries to CloudWatch Logs. This role must have a trust policy
  #   that allows SNS to assume it, and permissions to write to CloudWatch.
  #
  # Required IAM Permissions:
  #   - logs:CreateLogGroup
  #   - logs:CreateLogStream
  #   - logs:PutLogEvents
  #   - logs:PutMetricFilter
  #   - logs:PutRetentionPolicy
  #
  # Trust Policy Example:
  #   {
  #     "Version": "2012-10-17",
  #     "Statement": [{
  #       "Effect": "Allow",
  #       "Principal": { "Service": "sns.amazonaws.com" },
  #       "Action": "sts:AssumeRole"
  #     }]
  #   }
  #
  # Example:
  #   delivery_status_iam_role_arn = "arn:aws:iam::123456789012:role/SNSSMSLogsRole"
  #-----------------------------------------------------------------------------
  # delivery_status_iam_role_arn = null

  # delivery_status_success_sampling_rate - (Optional) Success log sampling rate
  # Type: string (represents percentage as string)
  # Valid Range: 0-100
  #
  # Description:
  #   The percentage of successful SMS deliveries for which Amazon SNS will
  #   write logs in CloudWatch Logs. This helps control logging costs by
  #   sampling successful deliveries.
  #
  # Important:
  #   - Value must be between 0 and 100
  #   - "0" means no success logs (only failures logged)
  #   - "100" means all successful deliveries are logged
  #   - Failed deliveries are always logged regardless of this setting
  #   - Requires delivery_status_iam_role_arn to be configured
  #
  # Cost Considerations:
  #   Higher sampling rates generate more CloudWatch Logs data and may
  #   increase costs. Consider your monitoring needs vs. logging costs.
  #
  # Example:
  #   delivery_status_success_sampling_rate = "10"  # Log 10% of successes
  #-----------------------------------------------------------------------------
  # delivery_status_success_sampling_rate = null

  #=============================================================================
  # Default Sender Configuration
  #=============================================================================
  # default_sender_id - (Optional) Default sender ID for SMS messages
  # Type: string
  # Max Length: 11 characters (alphanumeric)
  #
  # Description:
  #   A string, such as your business brand, that is displayed as the sender
  #   on the receiving device. This provides recipients with context about
  #   who sent the message.
  #
  # Important Restrictions:
  #   - Not supported in all countries/regions
  #   - Some countries require sender ID registration
  #   - Maximum 11 alphanumeric characters
  #   - Some carriers may override this setting
  #   - China, India, and USA do not support sender IDs
  #
  # Supported Countries:
  #   Check AWS documentation for current list of supported countries:
  #   https://docs.aws.amazon.com/sns/latest/dg/channels-sms-countries.html
  #
  # Example:
  #   default_sender_id = "MyCompany"
  #-----------------------------------------------------------------------------
  # default_sender_id = null

  #=============================================================================
  # Message Type Configuration
  #=============================================================================
  # default_sms_type - (Optional) Default type of SMS messages
  # Type: string
  # Valid Values: "Promotional" | "Transactional"
  #
  # Description:
  #   The type of SMS message that you will send by default. This affects
  #   message routing, delivery priority, and cost.
  #
  # Value Options:
  #   - "Promotional": Marketing messages, newsletters, special offers
  #     • Lower cost per message
  #     • May be subject to carrier filtering
  #     • Lower delivery priority
  #     • Not time-critical
  #
  #   - "Transactional": Critical messages like OTPs, alerts, confirmations
  #     • Higher cost per message
  #     • Higher delivery priority
  #     • Less likely to be filtered
  #     • Time-critical delivery
  #
  # Cost Implications:
  #   Transactional messages cost more but have better deliverability.
  #   Choose based on your message importance and time sensitivity.
  #
  # Best Practices:
  #   - Use "Transactional" for: OTPs, account alerts, security notifications
  #   - Use "Promotional" for: Marketing, newsletters, non-urgent updates
  #   - Can override per-message using SNS publish attributes
  #
  # Example:
  #   default_sms_type = "Transactional"
  #-----------------------------------------------------------------------------
  # default_sms_type = null

  #=============================================================================
  # Usage Reporting Configuration
  #=============================================================================
  # usage_report_s3_bucket - (Optional) S3 bucket for daily usage reports
  # Type: string
  #
  # Description:
  #   The name of the Amazon S3 bucket to receive daily SMS usage reports
  #   from Amazon SNS. Reports contain details about SMS message deliveries,
  #   costs, and usage statistics.
  #
  # Requirements:
  #   - Bucket must exist before configuring this setting
  #   - Bucket must be in the same region as the SMS preferences
  #   - Bucket policy must grant SNS permissions to write objects
  #
  # Required Bucket Policy:
  #   {
  #     "Version": "2012-10-17",
  #     "Statement": [{
  #       "Effect": "Allow",
  #       "Principal": { "Service": "sns.amazonaws.com" },
  #       "Action": "s3:PutObject",
  #       "Resource": "arn:aws:s3:::bucket-name/*",
  #       "Condition": {
  #         "StringEquals": {
  #           "aws:SourceAccount": "123456789012"
  #         }
  #       }
  #     }]
  #   }
  #
  # Report Contents:
  #   - Daily SMS usage statistics
  #   - Delivery status by destination
  #   - Cost breakdown
  #   - Message type distribution
  #
  # Report Format:
  #   CSV files delivered daily to the specified bucket
  #   Path format: YYYY/MM/DD/usage-report.csv
  #
  # Example:
  #   usage_report_s3_bucket = "my-sms-usage-reports"
  #-----------------------------------------------------------------------------
  # usage_report_s3_bucket = null

  #=============================================================================
  # Computed Attributes
  #=============================================================================
  # The following attributes are computed and exported by this resource:
  #
  # - id (string)
  #   Unique identifier for the SMS preferences resource.
  #   Typically the region identifier.
  #
  # All configured attributes are also exported and can be referenced
  # in other resources or outputs.
  #=============================================================================
}

################################################################################
# Common Configuration Examples
################################################################################

# Example 1: Basic SMS preferences with spending limit
# resource "aws_sns_sms_preferences" "basic" {
#   monthly_spend_limit = 50.00
#   default_sms_type    = "Transactional"
# }

# Example 2: Full configuration with logging and reporting
# resource "aws_sns_sms_preferences" "full" {
#   monthly_spend_limit                   = 100.00
#   default_sms_type                      = "Transactional"
#   default_sender_id                     = "MyApp"
#   delivery_status_iam_role_arn          = aws_iam_role.sns_sms_logging.arn
#   delivery_status_success_sampling_rate = "10"
#   usage_report_s3_bucket                = aws_s3_bucket.sms_reports.id
# }

# Example 3: Development environment with minimal cost
# resource "aws_sns_sms_preferences" "dev" {
#   monthly_spend_limit                   = 10.00
#   default_sms_type                      = "Promotional"
#   delivery_status_success_sampling_rate = "0"  # Only log failures
# }

################################################################################
# Related Resources
################################################################################
# The following resources are commonly used together with SMS preferences:
#
# - aws_iam_role: IAM role for SNS to write CloudWatch Logs
# - aws_iam_role_policy: Attach logging permissions to the role
# - aws_s3_bucket: Store daily usage reports
# - aws_s3_bucket_policy: Grant SNS write permissions to the bucket
# - aws_cloudwatch_log_group: Destination for delivery status logs
# - aws_sns_topic: SNS topics that will send SMS messages
# - aws_sns_topic_subscription: Subscribe endpoints to receive SMS

################################################################################
# Additional Resources
################################################################################
# AWS SNS SMS Best Practices:
#   https://docs.aws.amazon.com/sns/latest/dg/sms_best-practices.html
#
# SMS Pricing:
#   https://aws.amazon.com/sns/sms-pricing/
#
# Supported Regions and Countries:
#   https://docs.aws.amazon.com/sns/latest/dg/sns-supported-regions-countries.html
#
# Terraform AWS Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_sms_preferences
################################################################################
