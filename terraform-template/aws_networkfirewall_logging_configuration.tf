#---------------------------------------------------------------
# AWS Network Firewall Logging Configuration
#---------------------------------------------------------------
#
# AWS Network Firewallのログ設定を管理するリソース。
# ファイアウォールのステートフルエンジンからのログを、
# S3バケット、CloudWatch Logs、Kinesis Data Firehoseに送信できる。
#
# ログタイプ:
#   - FLOW: 標準的なネットワークトラフィックフローログ
#   - ALERT: ステートフルルールに一致したトラフィック（DROP/ALERT/REJECTアクション）
#   - TLS: TLSインスペクションに関連するイベント
#
# AWS公式ドキュメント:
#   - Logging network traffic from AWS Network Firewall: https://docs.aws.amazon.com/network-firewall/latest/developerguide/firewall-logging.html
#   - LoggingConfiguration API Reference: https://docs.aws.amazon.com/network-firewall/latest/APIReference/API_LoggingConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_logging_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_logging_configuration" "this" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # (Required) Network FirewallのARN
  # ログ設定を関連付けるファイアウォールを指定する。
  # このリソースを新規作成する場合、変更すると再作成される（Forces new resource）。
  firewall_arn = aws_networkfirewall_firewall.example.arn

  # (Optional) 詳細ファイアウォール監視ダッシュボードの有効化
  # trueに設定すると、ファイアウォールの詳細な監視ダッシュボードが有効になる。
  # デフォルト: false
  # 型: bool
  enable_monitoring_dashboard = false

  # (Optional) リソースを管理するAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用される。
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 型: string
  # region = "ap-northeast-1"

  #---------------------------------------------------------------
  # logging_configuration ブロック (Required)
  #---------------------------------------------------------------
  # ファイアウォールのログ出力先を定義するブロック。
  # 最大1つのlogging_configurationブロックを指定できる。

  logging_configuration {

    #---------------------------------------------------------------
    # log_destination_config ブロック (Required)
    #---------------------------------------------------------------
    # ログの出力先を設定するブロック。
    # 最小1つ、最大3つのブロックを指定できる（FLOW、ALERT、TLSログそれぞれに1つずつ）。

    # 例1: S3バケットへのFLOWログ出力
    log_destination_config {
      # (Required) ログの出力先を指定するマップ
      # 出力先タイプに応じて異なるキーを使用:
      #   - S3の場合: bucketName（必須）、prefix（オプション、先頭に/を付けない）
      #   - CloudWatch Logsの場合: logGroup
      #   - Kinesis Data Firehoseの場合: deliveryStream
      # 型: map(string)
      log_destination = {
        bucketName = "example-firewall-logs-bucket"
        prefix     = "flow-logs"
      }

      # (Required) ログの出力先タイプ
      # 有効な値: "S3", "CloudWatchLogs", "KinesisDataFirehose"
      # 型: string
      log_destination_type = "S3"

      # (Required) 記録するログのタイプ
      # 有効な値:
      #   - "FLOW": 標準的なネットワークトラフィックフローログ
      #   - "ALERT": ステートフルルールに一致したトラフィック（DROP/ALERT/REJECTアクション）
      #   - "TLS": TLSインスペクションに関連するイベント（TLSインスペクション設定が必要）
      # 型: string
      log_type = "FLOW"
    }

    # 例2: CloudWatch LogsへのALERTログ出力
    log_destination_config {
      log_destination = {
        logGroup = "/aws/network-firewall/alerts"
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }

    # 例3: Kinesis Data FirehoseへのTLSログ出力
    # log_destination_config {
    #   log_destination = {
    #     deliveryStream = "example-firewall-tls-stream"
    #   }
    #   log_destination_type = "KinesisDataFirehose"
    #   log_type             = "TLS"
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能。
#
# id
#   - 関連付けられたファイアウォールのARN
#   - 型: string
#---------------------------------------------------------------
