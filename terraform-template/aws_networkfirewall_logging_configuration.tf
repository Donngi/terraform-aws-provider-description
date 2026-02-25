#######################################################################
# Network Firewall Logging Configuration
#######################################################################
# AWS Network Firewallのログ記録設定を管理するリソース。
# ファイアウォールのトラフィックログ（フローログ、アラートログ、TLS検査ログ）を
# CloudWatch Logs、S3、またはKinesis Data Firehoseへ送信する設定を行う。
#
# 主な用途:
# - ファイアウォールのトラフィックフローの可視化と監査
# - セキュリティアラートの収集と分析
# - TLS/SSL通信の検査ログの保管
# - コンプライアンス要件への対応
#
# 参考: https://docs.aws.amazon.com/network-firewall/latest/developerguide/firewall-logging.html
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/networkfirewall_logging_configuration
#
# NOTE: このテンプレートの属性は実際の要件に応じてコメントを外して使用してください
#-----------------------------------------------------------------------

resource "aws_networkfirewall_logging_configuration" "example" {
  #-----------------------------------------------------------------------
  # ファイアウォールの指定
  #-----------------------------------------------------------------------

  # ログ設定を適用するファイアウォールのARN
  # 設定内容: 対象となるNetwork FirewallリソースのARN
  # 用途: どのファイアウォールにログ設定を適用するかを特定する
  firewall_arn = aws_networkfirewall_firewall.example.arn

  #-----------------------------------------------------------------------
  # ログ送信先の設定
  #-----------------------------------------------------------------------

  # ログ記録設定ブロック（必須、1つのみ指定可能）
  logging_configuration {
    # ログ送信先の設定（1〜3件指定可能、同じlog_typeは1件のみ）
    log_destination_config {
      # ログタイプ
      # 設定内容: 収集するログの種類
      # 設定可能な値:
      #   - FLOW: ネットワークフロートラフィックのログ
      #   - ALERT: ファイアウォールルールによるアラートのログ
      #   - TLS: TLS検査ログ（TLSインスペクション設定が必要）
      log_type = "ALERT"

      # ログ送信先タイプ
      # 設定内容: ログの転送先となるAWSサービス
      # 設定可能な値:
      #   - CloudWatchLogs: Amazon CloudWatch Logsへ送信
      #   - S3: Amazon S3バケットへ送信
      #   - KinesisDataFirehose: Amazon Kinesis Data Firehoseへ送信
      log_destination_type = "CloudWatchLogs"

      # ログ送信先の詳細設定
      # 設定内容: 送信先タイプに応じたキー・バリューのマップ
      # CloudWatchLogs の場合:
      #   logGroup: ロググループ名（必須）
      # S3 の場合:
      #   bucketName: バケット名（必須）
      #   prefix: オブジェクトキーのプレフィックス（省略可）
      # KinesisDataFirehose の場合:
      #   deliveryStream: 配信ストリーム名（必須）
      log_destination = {
        logGroup = aws_cloudwatch_log_group.example.name
      }
    }

    # フローログの送信先設定例（コメントを外して追加可能）
    # log_destination_config {
    #   log_type             = "FLOW"
    #   log_destination_type = "S3"
    #   log_destination = {
    #     bucketName = aws_s3_bucket.example.id
    #     prefix     = "network-firewall-flow-logs"
    #   }
    # }

    # TLSログの送信先設定例（コメントを外して追加可能）
    # log_destination_config {
    #   log_type             = "TLS"
    #   log_destination_type = "KinesisDataFirehose"
    #   log_destination = {
    #     deliveryStream = aws_kinesis_firehose_delivery_stream.example.name
    #   }
    # }
  }

  #-----------------------------------------------------------------------
  # モニタリングダッシュボードの設定
  #-----------------------------------------------------------------------

  # モニタリングダッシュボードの有効化
  # 設定内容: Network Firewallのモニタリングダッシュボードを有効にするか
  # 設定可能な値: true / false
  # 省略時: AWSデフォルト値（自動計算）
  enable_monitoring_dashboard = true

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # リソース管理リージョン
  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  region = "us-east-1"
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id
#   ロギング設定のID（対象ファイアウォールのARNと同じ値）
#-----------------------------------------------------------------------
