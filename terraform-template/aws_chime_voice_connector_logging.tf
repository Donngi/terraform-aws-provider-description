# ================================================================================
# Terraform AWS Provider Resource Template
# ================================================================================
# Resource: aws_chime_voice_connector_logging
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# 注意:
# このテンプレートは生成時点(2026-01-18)の情報に基づいています。
# 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chime_voice_connector_logging
# ================================================================================

# ================================================================================
# リソース概要
# ================================================================================
# Amazon Chime Voice Connectorのロギング設定を追加します。
# このリソースは、SIPメッセージログやメディアメトリクスログを
# Amazon CloudWatch Logsに送信するかどうかを設定します。
#
# AWS公式ドキュメント:
# - Monitoring Amazon Chime SDK with CloudWatch:
#   https://docs.aws.amazon.com/chime-sdk/latest/ag/monitoring-cloudwatch.html
# - LoggingConfiguration API:
#   https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_LoggingConfiguration.html
# ================================================================================

resource "aws_chime_voice_connector_logging" "example" {
  # ================================================================================
  # 必須パラメータ
  # ================================================================================

  # voice_connector_id - (Required) Amazon Chime Voice ConnectorのID
  #
  # ロギング設定を適用するVoice ConnectorのIDを指定します。
  # 通常、aws_chime_voice_connectorリソースのidを参照します。
  #
  # 型: string
  # 例: "abcdef1ghij2klmno3pqr4"
  voice_connector_id = "your-voice-connector-id"


  # ================================================================================
  # オプションパラメータ - ロギング設定
  # ================================================================================

  # enable_sip_logs - (Optional) SIPメッセージログの有効化
  #
  # trueに設定すると、SIPメッセージログをAmazon CloudWatch Logsに送信します。
  # SIPメッセージログには、インバウンドおよびアウトバウンドのSIPメッセージが
  # キャプチャされます。
  # ログは `/aws/ChimeVoiceConnectorLogs/{VoiceConnectorID}` という名前の
  # CloudWatch Logsロググループに送信されます。
  #
  # デフォルト: false (未設定の場合)
  # 型: bool
  #
  # 参考:
  # - https://docs.aws.amazon.com/chime-sdk/latest/ag/monitoring-cloudwatch.html
  enable_sip_logs = true

  # enable_media_metric_logs - (Optional) メディアメトリクスログの有効化
  #
  # trueに設定すると、Voice Connectorの詳細なメディアメトリクスログを
  # Amazon CloudWatch Logsに送信します。
  # メディア品質メトリクスログには、すべてのAmazon Chime Voice Connector
  # 通話の詳細な1分ごとのメトリクス(パケット数、バイト数、ジッター、
  # ラウンドトリップタイムなど)が含まれます。
  #
  # デフォルト: false (未設定の場合)
  # 型: bool
  #
  # 参考:
  # - https://docs.aws.amazon.com/chime-sdk/latest/ag/monitoring-cloudwatch.html
  enable_media_metric_logs = true


  # ================================================================================
  # オプションパラメータ - リージョン設定
  # ================================================================================

  # region - (Optional) リソースが管理されるリージョン
  #
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定で設定されたリージョンがデフォルトで使用されます。
  #
  # デフォルト: プロバイダー設定のリージョン
  # 型: string
  # 例: "us-east-1", "us-west-2"
  #
  # 参考:
  # - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # region = "us-east-1"
}


# ================================================================================
# 属性リファレンス
# ================================================================================
# このリソースは以下の属性をエクスポートします:
#
# - id - Amazon Chime Voice ConnectorのID (voice_connector_idと同じ値)
#
# 使用例:
# output "voice_connector_logging_id" {
#   value = aws_chime_voice_connector_logging.example.id
# }
# ================================================================================


# ================================================================================
# 使用例: Voice Connectorとロギング設定の作成
# ================================================================================
# resource "aws_chime_voice_connector" "example" {
#   name               = "example-voice-connector"
#   require_encryption = true
# }
#
# resource "aws_chime_voice_connector_logging" "example" {
#   voice_connector_id       = aws_chime_voice_connector.example.id
#   enable_sip_logs          = true
#   enable_media_metric_logs = true
# }
# ================================================================================
