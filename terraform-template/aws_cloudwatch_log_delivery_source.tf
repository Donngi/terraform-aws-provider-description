#---------------------------------------------------------------
# AWS CloudWatch Log Delivery Source
#---------------------------------------------------------------
#
# Amazon CloudWatch Logsの配信ソース（Delivery Source）をプロビジョニングするリソースです。
# 配信ソースは、ログを配信先（CloudWatch Logs、Amazon S3、またはFirehose）に送信する
# AWSリソースを論理的に表現するオブジェクトです。
#
# ログ配信を設定するには以下が必要です:
#   1. 配信ソース（Delivery Source）- ログを送信するAWSリソース
#   2. 配信先（Delivery Destination）- ログの送信先
#   3. 配信（Delivery）- 配信ソースと配信先のペアリング
#
# AWS公式ドキュメント:
#   - CloudWatch Logs配信ソース: https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_DeliverySource.html
#   - AWSサービスからのログ記録の有効化: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AWS-logs-and-resource-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_delivery_source
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_log_delivery_source" "example" {
  #-------------------------------------------------------------
  # 基本設定（Required）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 配信ソースの名前を指定します。
  # 設定可能な値: 1-60文字の文字列（英数字、ハイフン、アンダースコア）
  # 注意: アカウント内で一意である必要があります。
  name = "example-delivery-source"

  # log_type (Required)
  # 設定内容: ソースが送信するログのタイプを指定します。
  # 設定可能な値: ソースサービスによって異なります。
  #   - Amazon Bedrock Knowledge Bases: "APPLICATION_LOGS"
  #   - Amazon CodeWhisperer: "EVENT_LOGS"
  #   - IAM Identity Center: "ERROR_LOGS"
  #   - Amazon WorkMail:
  #       - "ACCESS_CONTROL_LOGS"
  #       - "AUTHENTICATION_LOGS"
  #       - "WORKMAIL_AVAILABILITY_PROVIDER_LOGS"
  #       - "WORKMAIL_MAILBOX_ACCESS_LOGS"
  # 注意: 有効な値はソースサービスのドキュメントを参照してください。
  log_type = "APPLICATION_LOGS"

  # resource_arn (Required)
  # 設定内容: ログを生成して送信するAWSリソースのARNを指定します。
  # 設定可能な値: 有効なAWSリソースARN
  # 注意: 配信ソースとして設定可能なサービスは限られています。
  #       対応サービスは「Enabling logging from AWS services」を参照してください。
  #       https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AWS-logs-and-resource-policy.html
  resource_arn = "arn:aws:bedrock:ap-northeast-1:123456789012:knowledge-base/XXXXXXXXXX"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  #   - キー: 最大128文字
  #   - 値: 最大256文字
  #   - 最大50個のタグ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-delivery-source"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 配信ソースのAmazon Resource Name (ARN)
#
# - service: ログを送信しているAWSサービス名
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
