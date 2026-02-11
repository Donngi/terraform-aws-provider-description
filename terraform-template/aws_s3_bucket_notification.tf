# ==============================================================================
# aws_s3_bucket_notification - S3 Bucket Notification Configuration
# ==============================================================================
# Manages S3 Bucket Notification Configuration for triggering events on S3
# object operations to Lambda, SQS, SNS, or EventBridge.
#
# Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3_bucket_notification
# https://docs.aws.amazon.com/AmazonS3/latest/dev/NotificationHowTo.html
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# ==============================================================================

# IMPORTANT NOTES:
# ------------------------------------------------------------------------------
# - S3 Buckets only support a single notification configuration resource
# - Declaring multiple aws_s3_bucket_notification resources for the same bucket
#   will cause perpetual differences in configuration
# - This resource will overwrite any existing event notifications configured
# - Cannot be used with S3 directory buckets
# - When configuring Lambda notifications, ensure lambda_permission is set
#   before the notification configuration
# ------------------------------------------------------------------------------

resource "aws_s3_bucket_notification" "example" {
  # ==============================================================================
  # REQUIRED PARAMETERS
  # ==============================================================================

  # bucket - (Required) Name of the bucket for notification configuration
  # Type: string
  # The S3 bucket name or ID to configure notifications for.
  # Can reference an existing aws_s3_bucket resource.
  bucket = aws_s3_bucket.example.id # or "your-bucket-name"

  # ==============================================================================
  # OPTIONAL PARAMETERS
  # ==============================================================================

  # eventbridge - (Optional) Whether to enable Amazon EventBridge notifications
  # Type: bool
  # Default: false
  # When enabled, all S3 events will be sent to EventBridge, allowing you to
  # create event rules without additional S3 notification configuration.
  # This is mutually compatible with lambda_function, queue, and topic blocks.
  # eventbridge = true

  # region - (Optional) AWS region where this resource will be managed
  # Type: string
  # Default: Provider region
  # Explicitly specifies the region for the notification configuration.
  # Defaults to the Region set in the provider configuration.
  # region = "us-east-1"

  # ==============================================================================
  # LAMBDA FUNCTION NOTIFICATIONS
  # ==============================================================================
  # Configure notifications to Lambda Function(s).
  # Multiple lambda_function blocks can be defined for different filters.
  # Requires proper IAM permissions (lambda:InvokeFunction) for s3.amazonaws.com.

  # lambda_function {
  #   # lambda_function_arn - (Required) Lambda function ARN
  #   # Type: string
  #   # The ARN of the Lambda function to invoke when events occur.
  #   lambda_function_arn = aws_lambda_function.example.arn
  #
  #   # events - (Required) Event types for which to send notifications
  #   # Type: set(string)
  #   # S3 event types that trigger the notification.
  #   # Common values:
  #   #   - s3:ObjectCreated:* (all object creation events)
  #   #   - s3:ObjectCreated:Put (object created via PUT)
  #   #   - s3:ObjectCreated:Post (object created via POST)
  #   #   - s3:ObjectCreated:Copy (object created via copy)
  #   #   - s3:ObjectCreated:CompleteMultipartUpload (multipart upload completed)
  #   #   - s3:ObjectRemoved:* (all object removal events)
  #   #   - s3:ObjectRemoved:Delete (object deleted)
  #   #   - s3:ObjectRemoved:DeleteMarkerCreated (delete marker created)
  #   #   - s3:ObjectRestore:* (all object restore events)
  #   #   - s3:ObjectRestore:Post (restore initiated)
  #   #   - s3:ObjectRestore:Completed (restore completed)
  #   #   - s3:ReducedRedundancyLostObject (RRS object lost)
  #   #   - s3:Replication:* (all replication events)
  #   events = ["s3:ObjectCreated:*"]
  #
  #   # filter_prefix - (Optional) Object key name prefix filter
  #   # Type: string
  #   # Only send notifications for objects with keys that start with this prefix.
  #   # Useful for organizing notifications by folder structure.
  #   # Example: "uploads/", "logs/", "images/"
  #   filter_prefix = "AWSLogs/"
  #
  #   # filter_suffix - (Optional) Object key name suffix filter
  #   # Type: string
  #   # Only send notifications for objects with keys that end with this suffix.
  #   # Commonly used for file extensions.
  #   # Example: ".log", ".jpg", ".json"
  #   filter_suffix = ".log"
  #
  #   # id - (Optional) Unique identifier for this notification configuration
  #   # Type: string
  #   # Computed: true
  #   # Unique identifier for this specific notification configuration.
  #   # Useful when multiple notification configurations exist.
  #   # id = "lambda-notification-1"
  # }

  # Example: Multiple Lambda functions with different filters
  # lambda_function {
  #   lambda_function_arn = aws_lambda_function.image_processor.arn
  #   events              = ["s3:ObjectCreated:*"]
  #   filter_prefix       = "images/"
  #   filter_suffix       = ".jpg"
  #   id                  = "image-processing"
  # }
  #
  # lambda_function {
  #   lambda_function_arn = aws_lambda_function.video_processor.arn
  #   events              = ["s3:ObjectCreated:*"]
  #   filter_prefix       = "videos/"
  #   filter_suffix       = ".mp4"
  #   id                  = "video-processing"
  # }

  # ==============================================================================
  # SQS QUEUE NOTIFICATIONS
  # ==============================================================================
  # Configure notifications to SQS Queue(s).
  # Multiple queue blocks can be defined for different filters.
  # Requires proper IAM policy on the SQS queue allowing sqs:SendMessage from S3.

  # queue {
  #   # queue_arn - (Required) SQS queue ARN
  #   # Type: string
  #   # The ARN of the SQS queue to send notifications to.
  #   queue_arn = aws_sqs_queue.example.arn
  #
  #   # events - (Required) Event types for which to send notifications
  #   # Type: set(string)
  #   # See lambda_function.events for complete list of available event types.
  #   events = ["s3:ObjectCreated:*"]
  #
  #   # filter_prefix - (Optional) Object key name prefix filter
  #   # Type: string
  #   # Only send notifications for objects with keys that start with this prefix.
  #   filter_prefix = "uploads/"
  #
  #   # filter_suffix - (Optional) Object key name suffix filter
  #   # Type: string
  #   # Only send notifications for objects with keys that end with this suffix.
  #   filter_suffix = ".json"
  #
  #   # id - (Optional) Unique identifier for this notification configuration
  #   # Type: string
  #   # Computed: true
  #   # Unique identifier for this specific notification configuration.
  #   # id = "queue-notification-1"
  # }

  # Example: Multiple queues with different filters
  # queue {
  #   id            = "image-upload-event"
  #   queue_arn     = aws_sqs_queue.image_queue.arn
  #   events        = ["s3:ObjectCreated:*"]
  #   filter_prefix = "images/"
  # }
  #
  # queue {
  #   id            = "video-upload-event"
  #   queue_arn     = aws_sqs_queue.video_queue.arn
  #   events        = ["s3:ObjectCreated:*"]
  #   filter_prefix = "videos/"
  # }

  # ==============================================================================
  # SNS TOPIC NOTIFICATIONS
  # ==============================================================================
  # Configure notifications to SNS Topic(s).
  # Multiple topic blocks can be defined for different filters.
  # Requires proper IAM policy on the SNS topic allowing SNS:Publish from S3.

  # topic {
  #   # topic_arn - (Required) SNS topic ARN
  #   # Type: string
  #   # The ARN of the SNS topic to publish notifications to.
  #   topic_arn = aws_sns_topic.example.arn
  #
  #   # events - (Required) Event types for which to send notifications
  #   # Type: set(string)
  #   # See lambda_function.events for complete list of available event types.
  #   events = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
  #
  #   # filter_prefix - (Optional) Object key name prefix filter
  #   # Type: string
  #   # Only send notifications for objects with keys that start with this prefix.
  #   filter_prefix = "important/"
  #
  #   # filter_suffix - (Optional) Object key name suffix filter
  #   # Type: string
  #   # Only send notifications for objects with keys that end with this suffix.
  #   filter_suffix = ".log"
  #
  #   # id - (Optional) Unique identifier for this notification configuration
  #   # Type: string
  #   # Computed: true
  #   # Unique identifier for this specific notification configuration.
  #   # id = "topic-notification-1"
  # }

  # ==============================================================================
  # DEPENDENCIES
  # ==============================================================================
  # When using Lambda notifications, ensure the Lambda permission is created
  # before the notification configuration to avoid errors.
  # Example:
  # depends_on = [
  #   aws_lambda_permission.allow_bucket
  # ]
}

# ==============================================================================
# EXAMPLE CONFIGURATIONS
# ==============================================================================

# Example 1: EventBridge notifications (simplest)
# ------------------------------------------------------------------------------
# Enables EventBridge notifications for all S3 events without additional config.
# resource "aws_s3_bucket_notification" "eventbridge" {
#   bucket      = aws_s3_bucket.example.id
#   eventbridge = true
# }

# Example 2: Lambda function notification with permissions
# ------------------------------------------------------------------------------
# resource "aws_lambda_permission" "allow_bucket" {
#   statement_id  = "AllowExecutionFromS3Bucket"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.example.arn
#   principal     = "s3.amazonaws.com"
#   source_arn    = aws_s3_bucket.example.arn
# }
#
# resource "aws_s3_bucket_notification" "lambda" {
#   bucket = aws_s3_bucket.example.id
#
#   lambda_function {
#     lambda_function_arn = aws_lambda_function.example.arn
#     events              = ["s3:ObjectCreated:*"]
#     filter_prefix       = "uploads/"
#     filter_suffix       = ".jpg"
#   }
#
#   depends_on = [aws_lambda_permission.allow_bucket]
# }

# Example 3: SQS queue notification with IAM policy
# ------------------------------------------------------------------------------
# data "aws_iam_policy_document" "queue" {
#   statement {
#     effect = "Allow"
#
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#
#     actions   = ["sqs:SendMessage"]
#     resources = [aws_sqs_queue.example.arn]
#
#     condition {
#       test     = "ArnEquals"
#       variable = "aws:SourceArn"
#       values   = [aws_s3_bucket.example.arn]
#     }
#   }
# }
#
# resource "aws_sqs_queue" "example" {
#   name   = "s3-event-notification-queue"
#   policy = data.aws_iam_policy_document.queue.json
# }
#
# resource "aws_s3_bucket_notification" "queue" {
#   bucket = aws_s3_bucket.example.id
#
#   queue {
#     queue_arn     = aws_sqs_queue.example.arn
#     events        = ["s3:ObjectCreated:*"]
#     filter_suffix = ".log"
#   }
# }

# Example 4: SNS topic notification with IAM policy
# ------------------------------------------------------------------------------
# data "aws_iam_policy_document" "topic" {
#   statement {
#     effect = "Allow"
#
#     principals {
#       type        = "Service"
#       identifiers = ["s3.amazonaws.com"]
#     }
#
#     actions   = ["SNS:Publish"]
#     resources = [aws_sns_topic.example.arn]
#
#     condition {
#       test     = "ArnLike"
#       variable = "aws:SourceArn"
#       values   = [aws_s3_bucket.example.arn]
#     }
#   }
# }
#
# resource "aws_sns_topic" "example" {
#   name   = "s3-event-notification-topic"
#   policy = data.aws_iam_policy_document.topic.json
# }
#
# resource "aws_s3_bucket_notification" "topic" {
#   bucket = aws_s3_bucket.example.id
#
#   topic {
#     topic_arn     = aws_sns_topic.example.arn
#     events        = ["s3:ObjectCreated:*"]
#     filter_suffix = ".log"
#   }
# }

# Example 5: Multiple notification types combined
# ------------------------------------------------------------------------------
# resource "aws_s3_bucket_notification" "combined" {
#   bucket      = aws_s3_bucket.example.id
#   eventbridge = true
#
#   lambda_function {
#     lambda_function_arn = aws_lambda_function.image_processor.arn
#     events              = ["s3:ObjectCreated:*"]
#     filter_prefix       = "images/"
#   }
#
#   queue {
#     queue_arn     = aws_sqs_queue.logs.arn
#     events        = ["s3:ObjectCreated:*"]
#     filter_suffix = ".log"
#   }
#
#   topic {
#     topic_arn = aws_sns_topic.alerts.arn
#     events    = ["s3:ObjectRemoved:*"]
#   }
# }

# ==============================================================================
# COMMON EVENT TYPES REFERENCE
# ==============================================================================
# Object Created Events:
#   - s3:ObjectCreated:*                      (all creation events)
#   - s3:ObjectCreated:Put                    (PUT operation)
#   - s3:ObjectCreated:Post                   (POST operation)
#   - s3:ObjectCreated:Copy                   (copy operation)
#   - s3:ObjectCreated:CompleteMultipartUpload (multipart upload completed)
#
# Object Removed Events:
#   - s3:ObjectRemoved:*                      (all removal events)
#   - s3:ObjectRemoved:Delete                 (permanent delete)
#   - s3:ObjectRemoved:DeleteMarkerCreated    (versioned delete)
#
# Object Restore Events:
#   - s3:ObjectRestore:*                      (all restore events)
#   - s3:ObjectRestore:Post                   (restore initiated)
#   - s3:ObjectRestore:Completed              (restore completed)
#
# Other Events:
#   - s3:ReducedRedundancyLostObject          (RRS object lost)
#   - s3:Replication:*                        (all replication events)
#   - s3:Replication:OperationFailedReplication
#   - s3:Replication:OperationMissedThreshold
#   - s3:Replication:OperationReplicatedAfterThreshold
#   - s3:Replication:OperationNotTracked

# ==============================================================================
# IAM PERMISSIONS REQUIREMENTS
# ==============================================================================
# Lambda Function Permissions:
# - The Lambda function must have a resource-based policy allowing
#   s3.amazonaws.com to invoke it (aws_lambda_permission)
# - Example permission:
#     {
#       "Effect": "Allow",
#       "Principal": {"Service": "s3.amazonaws.com"},
#       "Action": "lambda:InvokeFunction",
#       "Resource": "arn:aws:lambda:region:account:function:function-name",
#       "Condition": {
#         "ArnLike": {"AWS:SourceArn": "arn:aws:s3:::bucket-name"}
#       }
#     }
#
# SQS Queue Policy:
# - The SQS queue must have a policy allowing sqs:SendMessage from S3
# - Example policy condition:
#     {
#       "Effect": "Allow",
#       "Principal": {"AWS": "*"},
#       "Action": "sqs:SendMessage",
#       "Resource": "arn:aws:sqs:region:account:queue-name",
#       "Condition": {
#         "ArnEquals": {"aws:SourceArn": "arn:aws:s3:::bucket-name"}
#       }
#     }
#
# SNS Topic Policy:
# - The SNS topic must have a policy allowing SNS:Publish from S3
# - Example policy condition:
#     {
#       "Effect": "Allow",
#       "Principal": {"Service": "s3.amazonaws.com"},
#       "Action": "SNS:Publish",
#       "Resource": "arn:aws:sns:region:account:topic-name",
#       "Condition": {
#         "ArnLike": {"aws:SourceArn": "arn:aws:s3:::bucket-name"}
#       }
#     }

# ==============================================================================
# COMPUTED ATTRIBUTES
# ==============================================================================
# id - Unique identifier for the notification configuration (bucket name)
