################################################################################
# aws_config_delivery_channel
################################################################################
# Generated: 2026-01-19
# Provider version: 6.28.0
# Note: このテンプレートは生成時点の情報です。最新の仕様は公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_delivery_channel
################################################################################

resource "aws_config_delivery_channel" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # s3_bucket_name - (Required) The name of the S3 bucket used to store the
  # configuration history.
  # AWS Config uses this bucket to deliver configuration snapshots and
  # configuration history files.
  # The bucket must have appropriate permissions granted to AWS Config.
  # https://docs.aws.amazon.com/config/latest/APIReference/API_DeliveryChannel.html
  s3_bucket_name = "example-awsconfig-bucket"

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # name - (Optional) The name of the delivery channel.
  # Defaults to `default`. Changing it recreates the resource.
  # Each AWS account can have only one delivery channel per Region.
  # To rename a delivery channel, you must delete the current channel and
  # create a new one with the desired name.
  # https://docs.aws.amazon.com/config/latest/APIReference/API_DeliveryChannel.html
  name = "example"

  # id - (Optional) The ID of the delivery channel.
  # If not specified, Terraform will assign a computed value.
  # Typically, you should omit this and let Terraform manage it automatically.
  # id = "example"

  # region - (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # s3_key_prefix - (Optional) The prefix for the specified S3 bucket.
  # AWS Config uses this prefix to organize configuration history and
  # snapshot files within the bucket.
  # Example: "config/" will result in files being stored at
  # s3://bucket-name/config/...
  # https://docs.aws.amazon.com/config/latest/APIReference/API_DeliveryChannel.html
  s3_key_prefix = "config/"

  # s3_kms_key_arn - (Optional) The ARN of the AWS KMS key used to encrypt
  # objects delivered by AWS Config.
  # Must belong to the same Region as the destination S3 bucket.
  # By default, AWS Config encrypts data at rest using S3 AES-256 server-side
  # encryption, but you can provide a KMS key ARN to use KMS encryption instead.
  # Example: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  # https://docs.aws.amazon.com/config/latest/developerguide/manage-delivery-channel.html
  # s3_kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/..."

  # sns_topic_arn - (Optional) The ARN of the SNS topic that AWS Config
  # delivers notifications to.
  # AWS Config sends notifications about configuration changes to this topic.
  # When a configuration change notification exceeds the maximum size allowed
  # by Amazon SNS, a brief summary is included in the notification, and the
  # complete notification can be viewed in the S3 bucket.
  # Example: "arn:aws:sns:us-east-1:123456789012:config-topic"
  # https://docs.aws.amazon.com/config/latest/developerguide/manage-delivery-channel.html
  # sns_topic_arn = "arn:aws:sns:us-east-1:123456789012:config-topic"

  # ============================================================================
  # Nested Blocks
  # ============================================================================

  # snapshot_delivery_properties - (Optional) Options for how AWS Config
  # delivers configuration snapshots.
  # Configuration snapshots are collections of configuration items for all
  # supported resources at a specific point in time.
  # https://docs.aws.amazon.com/config/latest/APIReference/API_ConfigSnapshotDeliveryProperties.html
  snapshot_delivery_properties {
    # delivery_frequency - (Optional) The frequency with which AWS Config
    # recurringly delivers configuration snapshots.
    # Valid values:
    #   - One_Hour
    #   - Three_Hours
    #   - Six_Hours
    #   - Twelve_Hours
    #   - TwentyFour_Hours
    #
    # Note: If you have Config Rules with MaximumExecutionFrequency set,
    # ensure the delivery_frequency is at least as frequent as the
    # MaximumExecutionFrequency to ensure rule evaluations are invoked
    # at the expected frequency.
    # https://docs.aws.amazon.com/config/latest/APIReference/API_ConfigSnapshotDeliveryProperties.html
    delivery_frequency = "TwentyFour_Hours"
  }
}

################################################################################
# Important Notes
################################################################################
# 1. Delivery Channel requires a Configuration Recorder to be present.
#    Use depends_on to avoid race conditions:
#    depends_on = [aws_config_configuration_recorder.example]
#
# 2. Each AWS account can have only one delivery channel per Region.
#
# 3. The S3 bucket must have appropriate permissions granted to AWS Config.
#    Required permissions: s3:GetBucketVersioning, s3:PutObject,
#    s3:GetBucketLocation
#
# 4. If using s3_kms_key_arn, the KMS key must be in the same region as
#    the S3 bucket and have appropriate permissions for AWS Config.
#
# 5. AWS Config does not support delivery channels to S3 buckets where
#    object lock is enabled with default retention enabled.
#
# 6. Configuration items are created whenever a change is detected to a
#    resource being monitored by AWS Config.
################################################################################

################################################################################
# Outputs (Computed Attributes)
################################################################################
# The following attributes are exported by this resource:
#
# - id: The name of the delivery channel
################################################################################
