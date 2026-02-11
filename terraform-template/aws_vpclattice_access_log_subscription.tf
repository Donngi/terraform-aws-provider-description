#---------------------------------------------------------------
# Amazon VPC Lattice Access Log Subscription
#
# VPC Lattice のサービスネットワークまたはサービスに対する
# アクセスログサブスクリプションを管理するリソースです。
# アクセスログを Amazon S3、CloudWatch Logs、または
# Kinesis Data Firehose に送信して、監査や分析に使用できます。
#
# AWS Documentation:
# https://docs.aws.amazon.com/vpc-lattice/latest/ug/monitoring-access-logs.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpclattice_access_log_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
#
# NOTE: このテンプレートは参考例です。実際の環境に応じて
# 設定値を調整してください。
#---------------------------------------------------------------

resource "aws_vpclattice_access_log_subscription" "example" {
  #-------------------------------------------------------------
  # Required Settings
  #-------------------------------------------------------------

  # destination_arn (Required, Forces new resource)
  # 設定内容: ログの送信先となる AWS リソースの ARN
  # 設定可能な値: S3 バケット、CloudWatch Logs ロググループ、または Kinesis Data Firehose 配信ストリームの ARN
  # 関連機能: CloudWatch Logs - https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html
  # 関連機能: Amazon S3 - https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html
  # 関連機能: Kinesis Data Firehose - https://docs.aws.amazon.com/firehose/latest/dev/what-is-this-service.html
  destination_arn = "arn:aws:s3:::my-vpclattice-logs-bucket"

  # resource_identifier (Required, Forces new resource)
  # 設定内容: ログを収集するサービスネットワークまたはサービスの ID または ARN
  # 設定可能な値: VPC Lattice サービスネットワークまたはサービスの ID または ARN（異なるアカウントのリソースを指定する場合は ARN を使用）
  # 省略時: 必須のため省略不可
  resource_identifier = "sn-0123456789abcdef0"

  #-------------------------------------------------------------
  # Optional Settings
  #-------------------------------------------------------------

  # service_network_log_type (Optional, Forces new resource)
  # 設定内容: サービスネットワークの監視対象となるログのタイプ
  # 設定可能な値: SERVICE（サービスレベルのログ）、RESOURCE（リソースレベルのログ）
  # 省略時: SERVICE
  # 関連機能: VPC Lattice Logging - https://docs.aws.amazon.com/vpc-lattice/latest/ug/monitoring-access-logs.html
  service_network_log_type = "SERVICE"

  # region (Optional)
  # 設定内容: リソースを管理するリージョン
  # 設定可能な値: AWS リージョンコード（us-east-1、ap-northeast-1 など）
  # 省略時: プロバイダー設定のリージョン
  # 関連機能: AWS Regions - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "ap-northeast-1"

  #-------------------------------------------------------------
  # Tagging
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし（プロバイダーの default_tags は適用される）
  # 関連機能: AWS Resource Tagging - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-access-log-subscription"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all は computed なので設定不要
  # provider の default_tags と tags がマージされた結果
}

#---------------------------------------------------------------
# Attributes Reference
#
# 以下の属性は Terraform によって自動的に設定されます（computed-only）
#
# - id: アクセスログサブスクリプションの ID
# - arn: アクセスログサブスクリプションの ARN
#   例: arn:aws:vpc-lattice:ap-northeast-1:123456789012:accesslogsubscription/als-0123456789abcdef0
# - resource_arn: ログを収集するサービスネットワークまたはサービスの ARN
#   例: arn:aws:vpc-lattice:ap-northeast-1:123456789012:servicenetwork/sn-0123456789abcdef0
#
# 参照例:
# output "access_log_subscription_arn" {
#   value = aws_vpclattice_access_log_subscription.example.arn
# }
#---------------------------------------------------------------
