################################################################################
# AWS Config Configuration Recorder Status
# Terraform Resource: aws_config_configuration_recorder_status
#
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-19)の AWS Provider 6.28.0 仕様に
# 基づいています。最新の仕様や詳細については、必ず公式ドキュメントをご確認ください。
#
# Description:
# AWS Config Configuration Recorder の状態（記録中 / 停止中）を管理するリソース。
# Configuration Recorder を開始するには、Delivery Channel が必要です。
# 競合状態を避けるため、depends_on の使用が推奨されます。
#
# AWS公式ドキュメント:
# - Configuration Recorder Status API: https://docs.aws.amazon.com/config/latest/APIReference/API_ConfigurationRecorderStatus.html
# - Viewing Configuration Recorders: https://docs.aws.amazon.com/config/latest/developerguide/configuration-recorder-view.html
# - Recording AWS Resources: https://docs.aws.amazon.com/config/latest/developerguide/select-resources.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder_status
################################################################################

resource "aws_config_configuration_recorder_status" "example" {
  # ========================================
  # Required Parameters
  # ========================================

  # name - (Required) Configuration Recorder の名前
  # AWS Config Configuration Recorder リソースの名前を指定します。
  # このレコーダーは事前に作成されている必要があります。
  # Type: string
  # Example: "example-recorder"
  # AWS Doc: https://docs.aws.amazon.com/config/latest/APIReference/API_ConfigurationRecorderStatus.html
  name = "example-recorder"

  # is_enabled - (Required) Configuration Recorder を有効化するか無効化するか
  # true: レコーダーを開始し、リソース設定の記録を開始します
  # false: レコーダーを停止し、リソース設定の記録を停止します
  # Type: bool
  # Example: true
  # AWS Doc: https://docs.aws.amazon.com/config/latest/APIReference/API_ConfigurationRecorderStatus.html
  is_enabled = true

  # ========================================
  # Optional Parameters
  # ========================================

  # id - (Optional) リソースの一意識別子
  # 通常は自動的に設定されます。明示的に設定する必要はありません。
  # Type: string (Computed)
  # id = "example-recorder"

  # region - (Optional) このリソースを管理するリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # マルチリージョン構成で特定のリージョンを明示的に指定したい場合に使用します。
  # Type: string (Computed)
  # Example: "us-east-1"
  # AWS Doc: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ========================================
  # Dependencies
  # ========================================
  # Configuration Recorder を開始するには Delivery Channel が必要です。
  # 競合状態を避けるため、depends_on を使用してください。
  # depends_on = [aws_config_delivery_channel.example]
}

################################################################################
# Complete Example with Dependencies
################################################################################
/*
# IAM Role for AWS Config
resource "aws_iam_role" "config" {
  name = "example-awsconfig-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach AWS managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "config" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

# S3 bucket for AWS Config
resource "aws_s3_bucket" "config" {
  bucket = "example-awsconfig-bucket"
}

# IAM policy for S3 access
resource "aws_iam_role_policy" "config" {
  name = "example-awsconfig-policy"
  role = aws_iam_role.config.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetBucketVersioning"
        ]
        Resource = [
          aws_s3_bucket.config.arn,
          "${aws_s3_bucket.config.arn}/*"
        ]
      }
    ]
  })
}

# AWS Config Delivery Channel
resource "aws_config_delivery_channel" "example" {
  name           = "example-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config.bucket

  depends_on = [aws_config_configuration_recorder.example]
}

# AWS Config Configuration Recorder
resource "aws_config_configuration_recorder" "example" {
  name     = "example-recorder"
  role_arn = aws_iam_role.config.arn

  recording_group {
    all_supported = true
  }
}

# AWS Config Configuration Recorder Status
resource "aws_config_configuration_recorder_status" "example" {
  name       = aws_config_configuration_recorder.example.name
  is_enabled = true

  # Delivery Channel が先に作成されている必要があります
  depends_on = [aws_config_delivery_channel.example]
}
*/
