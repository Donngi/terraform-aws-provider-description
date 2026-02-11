#---------------------------------------------------------------
# AWS Chime Voice Connector Group
#---------------------------------------------------------------
#
# Amazon Chime SDK Voice Connector Groupをプロビジョニングするリソースです。
# Voice Connector Groupは、異なるAWSリージョンにある複数のVoice Connectorを
# グループ化し、可用性イベント発生時のフォールバック機構を提供します。
# インバウンドPSTN通話のフォールトトレラントなクロスリージョンルーティングを実現します。
#
# AWS公式ドキュメント:
#   - Voice Connector Groups管理: https://docs.aws.amazon.com/chime-sdk/latest/ag/voice-connector-groups.html
#   - CreateVoiceConnectorGroup API: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_CreateVoiceConnectorGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chime_voice_connector_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_chime_voice_connector_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Voice Connector Groupの名前を指定します。
  # 設定可能な値: 1-256文字の文字列（英数字、スペース、アンダースコア、ハイフン、ピリオドが使用可能）
  # パターン: [a-zA-Z0-9 _.-]+
  name = "example-voice-connector-group"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Voice Connector設定
  #-------------------------------------------------------------

  # connector (Optional)
  # 設定内容: インバウンド通話をルーティングするVoice Connectorを指定します。
  # 最大3つまでのconnectorブロックを定義できます。
  # 関連機能: Voice Connector Group
  #   異なるAWSリージョンのVoice Connectorをグループ化し、
  #   可用性イベント発生時にフォールバックするフォールトトレラントな機構を構築できます。
  #   - https://docs.aws.amazon.com/chime-sdk/latest/ag/voice-connector-groups.html

  connector {
    # voice_connector_id (Required)
    # 設定内容: Voice ConnectorのIDを指定します。
    # 設定可能な値: 有効なVoice Connector ID文字列
    voice_connector_id = "voice-connector-id-1"

    # priority (Required)
    # 設定内容: Voice Connectorの優先度を指定します。
    # 設定可能な値: 1-99の整数
    #   - 1: 最高優先度（最初に試行されます）
    #   - 数値が小さいほど優先度が高い
    # 注意: 同じ優先度のVoice Connectorがある場合、通話は相対的な重みに基づいて分散されます。
    priority = 1
  }

  connector {
    voice_connector_id = "voice-connector-id-2"
    priority           = 2
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Voice Connector GroupのID
#---------------------------------------------------------------
