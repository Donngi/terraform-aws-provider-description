################################################################################
# AWS SES Identity Notification Topic
# Terraform Resource: aws_ses_identity_notification_topic
# Provider Version: 6.28.0
#
# Description:
#   Provides a resource to configure Amazon Simple Notification Service (SNS) topics
#   for receiving Amazon SES email sending notifications. This resource allows you to
#   set up notification topics for bounces, complaints, and delivery notifications
#   for a verified SES identity (email address or domain).
#
#   When you configure SNS notifications, Amazon SES publishes notifications to the
#   specified SNS topic whenever specific email events occur, enabling automated
#   processing and monitoring of email sending activity.
#
# Resource Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ses_identity_notification_topic
#
# AWS Service Documentation:
#   https://docs.aws.amazon.com/ses/latest/dg/configure-sns-notifications.html
#   https://docs.aws.amazon.com/ses/latest/APIReference/API_SetIdentityNotificationTopic.html
################################################################################

resource "aws_ses_identity_notification_topic" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # identity - (Required) The identity for which to set the SNS topic
  # Type: string
  #
  # The identity for which the Amazon SNS topic will be set. You can specify
  # an identity by using its name or by using its Amazon Resource Name (ARN).
  # The identity must be a verified SES identity (domain or email address).
  #
  # Examples:
  #   - Domain identity: "example.com" or "arn:aws:ses:us-east-1:123456789012:identity/example.com"
  #   - Email identity: "user@example.com"
  #
  # Note: The identity must already be verified in Amazon SES.
  identity = "example.com"

  # notification_type - (Required) The type of notifications to publish
  # Type: string
  # Valid Values: "Bounce", "Complaint", "Delivery"
  #
  # Specifies the type of notifications that will be published to the SNS topic:
  #   - "Bounce": Notifications about bounced emails (hard and soft bounces)
  #   - "Complaint": Notifications about recipient complaints (spam reports)
  #   - "Delivery": Notifications about successful email deliveries
  #
  # You need to create separate resources for each notification type you want
  # to configure for the same identity.
  notification_type = "Bounce"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # topic_arn - (Optional) The Amazon Resource Name (ARN) of the Amazon SNS topic
  # Type: string
  # Default: null (notifications are disabled)
  #
  # The ARN of the SNS topic to which notifications will be published.
  # Can be set to an empty string ("") to disable publishing notifications.
  #
  # Important:
  #   - The SNS topic must be in the same AWS region as the SES identity
  #   - SES must have permission to publish to the SNS topic
  #   - If the topic is encrypted with AWS KMS, the key policy must allow SES access
  #
  # Example: "arn:aws:sns:us-east-1:123456789012:ses-bounce-notifications"
  topic_arn = aws_sns_topic.ses_bounces.arn

  # include_original_headers - (Optional) Include original email headers
  # Type: bool
  # Default: false
  #
  # Whether Amazon SES should include the original email headers in the
  # notification messages sent to the SNS topic.
  #
  # When set to true:
  #   - Notification messages will include the "mail.headers" field
  #   - Headers include: From, To, Subject, Date, Message-ID, etc.
  #   - Useful for tracking and debugging email delivery issues
  #
  # Note: Including headers increases the size of notification messages.
  include_original_headers = true

  # region - (Optional) Region where this resource will be managed
  # Type: string
  # Default: Uses the region from the provider configuration
  #
  # Specifies the AWS region where this resource will be managed.
  # The SNS topic must be in the same region as the SES identity.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################

  # These attributes are computed by AWS and available after resource creation:
  #
  # - id : A unique identifier combining identity and notification type (string)
  #        Format: <identity>|<notification_type>
  #        Example: example.com|Bounce

  ################################################################################
  # Notes and Best Practices
  ################################################################################

  # 1. Prerequisites:
  #    - The SES identity (domain or email) must be verified
  #    - The SNS topic must exist in the same region as the SES identity
  #    - SES must have permission to publish to the SNS topic
  #
  # 2. Multiple Notification Types:
  #    - Create separate resources for each notification type (Bounce, Complaint, Delivery)
  #    - You can use the same SNS topic for multiple notification types
  #    - Or use different topics for different notification types
  #
  # 3. SNS Topic Permissions:
  #    - Ensure the SNS topic policy allows SES to publish messages
  #    - Example principal: "ses.amazonaws.com"
  #
  # 4. Encrypted SNS Topics (KMS):
  #    - If using KMS-encrypted SNS topics, update the KMS key policy
  #    - The key policy must allow SES to use the key for encryption
  #
  # 5. Notification Format:
  #    - Notifications are published in JSON format
  #    - See AWS documentation for the complete notification structure
  #    - Reference: https://docs.aws.amazon.com/ses/latest/dg/notification-contents.html
  #
  # 6. Cost Considerations:
  #    - Standard Amazon SNS pricing applies for notifications
  #    - High-volume senders should consider SNS costs
  #
  # 7. Disabling Notifications:
  #    - Set topic_arn to empty string ("") to disable notifications
  #    - Or destroy the resource to remove the configuration
  #
  # 8. Monitoring and Alerting:
  #    - Use SNS subscriptions to send notifications to email, Lambda, SQS, etc.
  #    - Set up CloudWatch alarms based on bounce and complaint metrics
  #
  # 9. Email Feedback Forwarding:
  #    - When SNS notifications are configured, email feedback forwarding is disabled
  #    - Use aws_ses_identity_feedback_forwarding_enabled to control this behavior
  #
  # 10. Regional Availability:
  #     - SES is available in limited AWS regions
  #     - Ensure your region supports SES before configuring notifications
}

################################################################################
# Example Usage Patterns
################################################################################

# Example 1: Basic bounce notification configuration
# resource "aws_ses_identity_notification_topic" "bounce" {
#   identity          = "example.com"
#   notification_type = "Bounce"
#   topic_arn         = aws_sns_topic.ses_bounces.arn
# }

# Example 2: Complaint notification with original headers
# resource "aws_ses_identity_notification_topic" "complaint" {
#   identity                 = "example.com"
#   notification_type        = "Complaint"
#   topic_arn                = aws_sns_topic.ses_complaints.arn
#   include_original_headers = true
# }

# Example 3: Delivery notification
# resource "aws_ses_identity_notification_topic" "delivery" {
#   identity          = "example.com"
#   notification_type = "Delivery"
#   topic_arn         = aws_sns_topic.ses_deliveries.arn
# }

# Example 4: Email identity (instead of domain)
# resource "aws_ses_identity_notification_topic" "email_bounce" {
#   identity          = "user@example.com"
#   notification_type = "Bounce"
#   topic_arn         = aws_sns_topic.ses_bounces.arn
# }

# Example 5: Disable notifications by setting empty topic_arn
# resource "aws_ses_identity_notification_topic" "disabled" {
#   identity          = "example.com"
#   notification_type = "Bounce"
#   topic_arn         = ""
# }

# Example 6: Complete setup with all notification types
# resource "aws_ses_domain_identity" "example" {
#   domain = "example.com"
# }
#
# resource "aws_sns_topic" "ses_bounces" {
#   name = "ses-bounce-notifications"
# }
#
# resource "aws_sns_topic" "ses_complaints" {
#   name = "ses-complaint-notifications"
# }
#
# resource "aws_sns_topic" "ses_deliveries" {
#   name = "ses-delivery-notifications"
# }
#
# resource "aws_ses_identity_notification_topic" "bounce" {
#   identity                 = aws_ses_domain_identity.example.domain
#   notification_type        = "Bounce"
#   topic_arn                = aws_sns_topic.ses_bounces.arn
#   include_original_headers = true
# }
#
# resource "aws_ses_identity_notification_topic" "complaint" {
#   identity                 = aws_ses_domain_identity.example.domain
#   notification_type        = "Complaint"
#   topic_arn                = aws_sns_topic.ses_complaints.arn
#   include_original_headers = true
# }
#
# resource "aws_ses_identity_notification_topic" "delivery" {
#   identity          = aws_ses_domain_identity.example.domain
#   notification_type = "Delivery"
#   topic_arn         = aws_sns_topic.ses_deliveries.arn
# }

# Example 7: SNS topic with policy for SES
# resource "aws_sns_topic" "ses_notifications" {
#   name = "ses-notifications"
# }
#
# data "aws_iam_policy_document" "ses_sns_policy" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["ses.amazonaws.com"]
#     }
#     actions   = ["SNS:Publish"]
#     resources = [aws_sns_topic.ses_notifications.arn]
#     condition {
#       test     = "StringEquals"
#       variable = "AWS:SourceAccount"
#       values   = [data.aws_caller_identity.current.account_id]
#     }
#   }
# }
#
# resource "aws_sns_topic_policy" "ses_notifications" {
#   arn    = aws_sns_topic.ses_notifications.arn
#   policy = data.aws_iam_policy_document.ses_sns_policy.json
# }
#
# resource "aws_ses_identity_notification_topic" "with_policy" {
#   identity          = "example.com"
#   notification_type = "Bounce"
#   topic_arn         = aws_sns_topic.ses_notifications.arn
#   depends_on        = [aws_sns_topic_policy.ses_notifications]
# }

# Example 8: SNS topic subscription to Lambda for processing
# resource "aws_sns_topic" "ses_bounces" {
#   name = "ses-bounce-notifications"
# }
#
# resource "aws_sns_topic_subscription" "ses_bounce_lambda" {
#   topic_arn = aws_sns_topic.ses_bounces.arn
#   protocol  = "lambda"
#   endpoint  = aws_lambda_function.process_bounces.arn
# }
#
# resource "aws_lambda_permission" "ses_bounce_sns" {
#   statement_id  = "AllowExecutionFromSNS"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.process_bounces.function_name
#   principal     = "sns.amazonaws.com"
#   source_arn    = aws_sns_topic.ses_bounces.arn
# }
#
# resource "aws_ses_identity_notification_topic" "bounce_to_lambda" {
#   identity                 = "example.com"
#   notification_type        = "Bounce"
#   topic_arn                = aws_sns_topic.ses_bounces.arn
#   include_original_headers = true
# }

################################################################################
# Related Resources
################################################################################

# - aws_ses_domain_identity                  : Verify a domain for SES
# - aws_ses_email_identity                   : Verify an email address for SES
# - aws_ses_identity_feedback_forwarding_enabled : Control email feedback forwarding
# - aws_sns_topic                            : Create SNS topics for notifications
# - aws_sns_topic_policy                     : Define SNS topic access policies
# - aws_sns_topic_subscription               : Subscribe endpoints to SNS topics

################################################################################
# Sample Notification JSON Structure
################################################################################

# Bounce Notification Example:
# {
#   "notificationType": "Bounce",
#   "bounce": {
#     "bounceType": "Permanent",
#     "bounceSubType": "General",
#     "bouncedRecipients": [
#       {
#         "emailAddress": "recipient@example.com",
#         "action": "failed",
#         "status": "5.1.1",
#         "diagnosticCode": "smtp; 550 5.1.1 user unknown"
#       }
#     ],
#     "timestamp": "2024-01-15T12:34:56.000Z",
#     "feedbackId": "00000000-1111-2222-3333-444444444444"
#   },
#   "mail": {
#     "timestamp": "2024-01-15T12:34:56.000Z",
#     "source": "sender@example.com",
#     "sourceArn": "arn:aws:ses:us-east-1:123456789012:identity/example.com",
#     "sendingAccountId": "123456789012",
#     "messageId": "00000000-1111-2222-3333-444444444444",
#     "destination": ["recipient@example.com"],
#     "headersTruncated": false,
#     "headers": [...]  // Only included if include_original_headers is true
#   }
# }

# Complaint Notification Example:
# {
#   "notificationType": "Complaint",
#   "complaint": {
#     "complainedRecipients": [
#       {
#         "emailAddress": "recipient@example.com"
#       }
#     ],
#     "timestamp": "2024-01-15T12:34:56.000Z",
#     "feedbackId": "00000000-1111-2222-3333-444444444444",
#     "complaintFeedbackType": "abuse"
#   },
#   "mail": { ... }
# }

# Delivery Notification Example:
# {
#   "notificationType": "Delivery",
#   "delivery": {
#     "timestamp": "2024-01-15T12:34:56.000Z",
#     "processingTimeMillis": 1234,
#     "recipients": ["recipient@example.com"],
#     "smtpResponse": "250 2.0.0 OK 1234567890 abcdefghij",
#     "reportingMTA": "a1-234.smtp-out.amazonses.com"
#   },
#   "mail": { ... }
# }

################################################################################
# Outputs Example
################################################################################

# output "notification_topic_id" {
#   description = "The ID of the SES identity notification topic configuration"
#   value       = aws_ses_identity_notification_topic.example.id
# }
#
# output "notification_identity" {
#   description = "The SES identity configured for notifications"
#   value       = aws_ses_identity_notification_topic.example.identity
# }
#
# output "notification_type" {
#   description = "The type of notifications configured"
#   value       = aws_ses_identity_notification_topic.example.notification_type
# }
#
# output "notification_topic_arn" {
#   description = "The ARN of the SNS topic receiving notifications"
#   value       = aws_ses_identity_notification_topic.example.topic_arn
# }
