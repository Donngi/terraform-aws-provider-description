#---------------------------------------------------------------
# AWS Chime Voice Connector Logging
#---------------------------------------------------------------
#
# Amazon Chime Voice Connectorのログ記録設定を構成するリソースです。
# SIPメッセージログやメディアメトリクスログの有効化・無効化を行い、
# Amazon CloudWatch Logsへのログ送信を制御します。
#
# AWS公式ドキュメント:
#   - Voice Connector概要: https://docs.aws.amazon.com/chime-sdk/latest/ag/voice-connectors.html
#   - Voice Connector設定編集: https://docs.aws.amazon.com/chime-sdk/latest/ag/edit-voicecon.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chime_voice_connector_logging
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_chime_voice_connector_logging" "example" {
  #-------------------------------------------------------------
  # Voice Connector識別子
  #-------------------------------------------------------------

  # voice_connector_id (Required)
  # 設定内容: ログ記録設定を適用するAmazon Chime Voice ConnectorのIDを指定します。
  # 設定可能な値: 有効なVoice Connector ID
  # 注意: aws_chime_voice_connectorリソースの出力から取得できます
  voice_connector_id = aws_chime_voice_connector.example.id

  #-------------------------------------------------------------
  # SIPログ設定
  #-------------------------------------------------------------

  # enable_sip_logs (Optional)
  # 設定内容: SIPメッセージログのAmazon CloudWatch Logsへの送信を有効化するかを指定します。
  # 設定可能な値:
  #   - true: SIPメッセージログを有効化
  #   - false: SIPメッセージログを無効化
  # 関連機能: SIPメッセージログ
  #   有効化すると、Voice Connectorを通過するSIPメッセージの
  #   詳細なログがCloudWatch Logsに送信されます。
  #   トラブルシューティングやコール品質の分析に活用できます。
  enable_sip_logs = true

  #-------------------------------------------------------------
  # メディアメトリクスログ設定
  #-------------------------------------------------------------

  # enable_media_metric_logs (Optional)
  # 設定内容: 詳細なメディアメトリクスログのAmazon CloudWatch Logsへの送信を有効化するかを指定します。
  # 設定可能な値:
  #   - true: メディアメトリクスログを有効化
  #   - false: メディアメトリクスログを無効化
  # 関連機能: メディアメトリクスログ
  #   有効化すると、Voice Connectorのメディアストリームに関する
  #   詳細なメトリクス（パケットロス、ジッター、レイテンシー等）が
  #   CloudWatch Logsに記録されます。
  enable_media_metric_logs = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Amazon Chime Voice Connector ID
#       voice_connector_idと同じ値がエクスポートされます。
#---------------------------------------------------------------
