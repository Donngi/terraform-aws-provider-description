################################################################################
# AWS IVS Chat Logging Configuration
################################################################################

# Terraform resource for managing an AWS IVS (Interactive Video) Chat Logging Configuration.
#
# This resource allows you to configure logging for Amazon Interactive Video Service (IVS) Chat.
# Chat logs can be sent to three destinations: CloudWatch Logs, Kinesis Data Firehose, or S3.
#
# Reference: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ivschat_logging_configuration

resource "aws_ivschat_logging_configuration" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # destination_configuration - (Required) Object containing destination configuration
  # for where chat activity will be logged. This object must contain exactly one of the
  # following children arguments: cloudwatch_logs, firehose, or s3.
  destination_configuration {
    # --------------------------------------------------------------------------
    # Option 1: CloudWatch Logs
    # --------------------------------------------------------------------------
    # An Amazon CloudWatch Logs destination configuration where chat activity
    # will be logged.
    cloudwatch_logs {
      # log_group_name - (Required) Name of the Amazon CloudWatch Logs destination
      # where chat activity will be logged.
      log_group_name = "example-log-group"
    }

    # --------------------------------------------------------------------------
    # Option 2: Kinesis Data Firehose
    # --------------------------------------------------------------------------
    # Uncomment to use Kinesis Data Firehose instead of CloudWatch Logs
    # An Amazon Kinesis Data Firehose destination configuration where chat activity
    # will be logged.
    # firehose {
    #   # delivery_stream_name - (Required) Name of the Amazon Kinesis Firehose
    #   # delivery stream where chat activity will be logged.
    #   delivery_stream_name = "example-delivery-stream"
    # }

    # --------------------------------------------------------------------------
    # Option 3: S3
    # --------------------------------------------------------------------------
    # Uncomment to use S3 instead of CloudWatch Logs
    # An Amazon S3 destination configuration where chat activity will be logged.
    # s3 {
    #   # bucket_name - (Required) Name of the Amazon S3 bucket where chat activity
    #   # will be logged.
    #   bucket_name = "example-bucket"
    # }
  }

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # name - (Optional) Logging Configuration name.
  # If not specified, AWS will generate a unique name for the configuration.
  name = "example-logging-configuration"

  # region - (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - (Optional) A map of tags to assign to the resource.
  # If configured with a provider default_tags configuration block present,
  # tags with matching keys will overwrite those defined at the provider-level.
  # Reference: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    Service     = "ivs-chat"
    ManagedBy   = "terraform"
  }

  # ============================================================================
  # Computed Attributes (Read-Only)
  # ============================================================================
  # The following attributes are exported and available after resource creation:
  #
  # - arn         : ARN of the Logging Configuration
  # - id          : ID of the Logging Configuration
  # - state       : State of the Logging Configuration
  # - tags_all    : Map of tags assigned to the resource, including those inherited
  #                 from the provider default_tags configuration block
}

################################################################################
# Example 1: CloudWatch Logs Configuration
################################################################################

# resource "aws_cloudwatch_log_group" "ivschat_logs" {
#   name              = "/aws/ivschat/example"
#   retention_in_days = 7
#
#   tags = {
#     Environment = "production"
#     Service     = "ivs-chat"
#   }
# }
#
# resource "aws_ivschat_logging_configuration" "cloudwatch" {
#   name = "ivschat-cloudwatch-logging"
#
#   destination_configuration {
#     cloudwatch_logs {
#       log_group_name = aws_cloudwatch_log_group.ivschat_logs.name
#     }
#   }
#
#   tags = {
#     Environment = "production"
#     Service     = "ivs-chat"
#   }
# }

################################################################################
# Example 2: Kinesis Firehose Configuration with S3
################################################################################

# resource "aws_s3_bucket" "ivschat_logs" {
#   bucket_prefix = "tf-ivschat-logging-bucket"
# }
#
# resource "aws_s3_bucket_acl" "ivschat_logs" {
#   bucket = aws_s3_bucket.ivschat_logs.id
#   acl    = "private"
# }
#
# data "aws_iam_policy_document" "firehose_assume_role" {
#   statement {
#     effect = "Allow"
#
#     principals {
#       type        = "Service"
#       identifiers = ["firehose.amazonaws.com"]
#     }
#
#     actions = ["sts:AssumeRole"]
#   }
# }
#
# resource "aws_iam_role" "firehose_role" {
#   name               = "ivschat-firehose-role"
#   assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
# }
#
# data "aws_iam_policy_document" "firehose_s3" {
#   statement {
#     effect = "Allow"
#
#     actions = [
#       "s3:AbortMultipartUpload",
#       "s3:GetBucketLocation",
#       "s3:GetObject",
#       "s3:ListBucket",
#       "s3:ListBucketMultipartUploads",
#       "s3:PutObject",
#     ]
#
#     resources = [
#       aws_s3_bucket.ivschat_logs.arn,
#       "${aws_s3_bucket.ivschat_logs.arn}/*",
#     ]
#   }
# }
#
# resource "aws_iam_role_policy" "firehose_s3" {
#   name   = "ivschat-firehose-s3-policy"
#   role   = aws_iam_role.firehose_role.id
#   policy = data.aws_iam_policy_document.firehose_s3.json
# }
#
# resource "aws_kinesis_firehose_delivery_stream" "ivschat_logs" {
#   name        = "ivschat-delivery-stream"
#   destination = "extended_s3"
#
#   extended_s3_configuration {
#     role_arn   = aws_iam_role.firehose_role.arn
#     bucket_arn = aws_s3_bucket.ivschat_logs.arn
#
#     compression_format = "GZIP"
#     prefix             = "ivschat-logs/"
#     error_output_prefix = "ivschat-logs-error/"
#   }
#
#   tags = {
#     LogDeliveryEnabled = "true"
#     Environment        = "production"
#   }
# }
#
# resource "aws_ivschat_logging_configuration" "firehose" {
#   name = "ivschat-firehose-logging"
#
#   destination_configuration {
#     firehose {
#       delivery_stream_name = aws_kinesis_firehose_delivery_stream.ivschat_logs.name
#     }
#   }
#
#   tags = {
#     Environment = "production"
#     Service     = "ivs-chat"
#   }
# }

################################################################################
# Example 3: S3 Direct Configuration
################################################################################

# resource "aws_s3_bucket" "ivschat_logs_direct" {
#   bucket        = "ivschat-logs-direct"
#   force_destroy = true
# }
#
# resource "aws_s3_bucket_acl" "ivschat_logs_direct" {
#   bucket = aws_s3_bucket.ivschat_logs_direct.id
#   acl    = "private"
# }
#
# resource "aws_ivschat_logging_configuration" "s3" {
#   name = "ivschat-s3-logging"
#
#   destination_configuration {
#     s3 {
#       bucket_name = aws_s3_bucket.ivschat_logs_direct.id
#     }
#   }
#
#   tags = {
#     Environment = "production"
#     Service     = "ivs-chat"
#   }
# }

################################################################################
# Output Examples
################################################################################

# output "logging_configuration_arn" {
#   description = "The ARN of the IVS Chat Logging Configuration"
#   value       = aws_ivschat_logging_configuration.example.arn
# }
#
# output "logging_configuration_id" {
#   description = "The ID of the IVS Chat Logging Configuration"
#   value       = aws_ivschat_logging_configuration.example.id
# }
#
# output "logging_configuration_state" {
#   description = "The state of the IVS Chat Logging Configuration"
#   value       = aws_ivschat_logging_configuration.example.state
# }
