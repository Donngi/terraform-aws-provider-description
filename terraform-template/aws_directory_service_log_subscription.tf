#---------------------------------------------------------------
# AWS Directory Service Log Subscription
#---------------------------------------------------------------
#
# AWS Directory Serviceのログサブスクリプションをプロビジョニングするリソースです。
# ドメインコントローラーのセキュリティイベントログをAmazon CloudWatch Logsに
# 転送するための設定を管理します。
#
# ログ転送を有効にすることで、セキュリティ監視、監査、ログ保持ポリシー要件を
# 満たすのに役立ちます。ディレクトリ内のセキュリティイベントの透明性が向上します。
#
# 重要: 1つのディレクトリにつき1つのログサブスクリプションのみ設定可能です。
#       ログ転送はリージョン機能であり、マルチリージョンレプリケーション使用時は
#       各リージョンで個別に設定が必要です。
#
# AWS公式ドキュメント:
#   - Directory Serviceログ転送: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_enable_log_forwarding.html
#   - CloudWatch Logsロググループ: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Working-with-log-groups-and-streams.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_log_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_directory_service_log_subscription" "example" {
  #-------------------------------------------------------------
  # 基本設定 (Required)
  #-------------------------------------------------------------

  # directory_id (Required)
  # 設定内容: ログサブスクリプションを設定するディレクトリのIDを指定します。
  # 設定可能な値: AWS Managed Microsoft ADまたはAD ConnectorのディレクトリID
  #              （例: "d-1234567890"）
  # 注意: リソース作成後の変更はできません（Forces new resource）
  directory_id = aws_directory_service_directory.example.id

  # log_group_name (Required)
  # 設定内容: ログを発行するCloudWatch Logsロググループの名前を指定します。
  # 設定可能な値: 既存のCloudWatch Logsロググループ名
  #              推奨形式: "/aws/directoryservice/${directory_id}"
  # 注意:
  #   - ロググループは事前に作成しておく必要があります
  #   - Directory Service（ds.amazonaws.com）プリンシパルに対して、
  #     ログストリームの作成とログの発行権限を付与する必要があります
  #   - この値を変更すると、現在のサブスクリプションが削除され新規作成されます
  #   - 1つのディレクトリには1つのログサブスクリプションのみ設定可能です
  log_group_name = aws_cloudwatch_log_group.example.name

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# 関連リソースの設定例
#---------------------------------------------------------------
# 以下は、ログサブスクリプションを設定するために必要な関連リソースの例です。

# CloudWatch Logsロググループ
# Directory Serviceのログを受信するためのロググループを作成します。
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/directoryservice/${aws_directory_service_directory.example.id}"
  retention_in_days = 14
}

# CloudWatch Logsリソースポリシー
# Directory Serviceにログ発行権限を付与するポリシーを設定します。
data "aws_iam_policy_document" "directory_service_log_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    principals {
      identifiers = ["ds.amazonaws.com"]
      type        = "Service"
    }

    resources = ["${aws_cloudwatch_log_group.example.arn}:*"]

    effect = "Allow"
  }
}

resource "aws_cloudwatch_log_resource_policy" "directory_service_log_policy" {
  policy_document = data.aws_iam_policy_document.directory_service_log_policy.json
  policy_name     = "directory-service-log-policy"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ディレクトリIDと同じ値
#
#---------------------------------------------------------------
