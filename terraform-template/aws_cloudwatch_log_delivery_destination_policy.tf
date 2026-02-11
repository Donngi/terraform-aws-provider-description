#---------------------------------------------------------------
# AWS CloudWatch Logs Delivery Destination Policy
#---------------------------------------------------------------
#
# CloudWatch Logsの配信先（Delivery Destination）に対するIAMポリシーを
# プロビジョニングするリソースです。
#
# このリソースは、クロスアカウントでのログ配信を設定する際に使用します。
# 配信先アカウントで、送信元アカウントからのログ配信を許可するポリシーを
# 配信先に割り当てます。
#
# クロスアカウントログ配信の設定手順:
#   1. 送信元アカウントでDelivery Sourceを作成
#   2. 配信先アカウントでDelivery Destinationを作成
#   3. 配信先アカウントで本リソースを使用してポリシーを割り当て
#   4. 送信元アカウントでDeliveryを作成（SourceとDestinationをペアリング）
#
# AWS公式ドキュメント:
#   - CloudWatch Logs V2配信設定: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AWS-vended-logs-permissions-V2.html
#   - クロスアカウント配信例: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/vended-logs-crossaccount-example.html
#   - PutDeliveryDestinationPolicy API: https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutDeliveryDestinationPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_delivery_destination_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_log_delivery_destination_policy" "example" {
  #-------------------------------------------------------------
  # 配信先設定
  #-------------------------------------------------------------

  # delivery_destination_name (Required)
  # 設定内容: ポリシーを割り当てる配信先（Delivery Destination）の名前を指定します。
  # 設定可能な値: 1-60文字の文字列（英数字、ハイフン、アンダースコア）
  # 注意: 事前にaws_cloudwatch_log_delivery_destinationリソースで
  #       配信先を作成しておく必要があります。
  delivery_destination_name = aws_cloudwatch_log_delivery_destination.example.name

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # delivery_destination_policy (Required)
  # 設定内容: 配信先に割り当てるIAMポリシーの内容を指定します。
  # 設定可能な値: 1-51200文字のJSON形式のIAMポリシードキュメント
  # 関連機能: CloudWatch Logs クロスアカウント配信ポリシー
  #   クロスアカウントでのログ配信を許可するために、配信先に割り当てるポリシー。
  #   ポリシーには通常、logs:CreateDeliveryアクションを許可するステートメントを含めます。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AWS-vended-logs-permissions-V2.html
  # 注意: ポリシーには送信元アカウントに対してlogs:CreateDeliveryを許可する
  #       ステートメントを含める必要があります。
  delivery_destination_policy = data.aws_iam_policy_document.example.json

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# IAMポリシードキュメント例
#---------------------------------------------------------------
# クロスアカウントでのログ配信を許可するポリシーの例です。
# 送信元アカウント（SENDER_ACCOUNT_ID）からのlogs:CreateDeliveryアクションを
# 許可します。
#---------------------------------------------------------------

data "aws_iam_policy_document" "example" {
  statement {
    sid    = "AllowLogDeliveryActions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::SENDER_ACCOUNT_ID:root"]
    }

    actions = ["logs:CreateDelivery"]

    resources = [
      "arn:aws:logs:ap-northeast-1:DESTINATION_ACCOUNT_ID:delivery-source:*",
      "arn:aws:logs:ap-northeast-1:DESTINATION_ACCOUNT_ID:delivery:*",
      "arn:aws:logs:ap-northeast-1:DESTINATION_ACCOUNT_ID:delivery-destination:*"
    ]
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースはスキーマ上、追加の読み取り専用属性をエクスポートしません。
#
# Terraform標準の属性:
# - id: リソースの識別子（通常はdelivery_destination_nameと同じ）
#---------------------------------------------------------------
