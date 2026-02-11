#---------------------------------------------------------------
# AWS Chime Voice Connector Origination
#---------------------------------------------------------------
#
# Amazon Chime Voice Connectorの発信元設定（Origination）をプロビジョニングする
# リソースです。発信元設定を有効にすることで、SIPインフラストラクチャへの
# インバウンドコールを制御できます。
#
# Voice Connectorは、既存の電話システムをAmazon Chime SDKと統合するための
# SIPトランキングサービスです。発信元設定により、インバウンドコールの
# ルーティングと配信を制御します。
#
# AWS公式ドキュメント:
#   - Amazon Chime SDK Voice Connector管理: https://docs.aws.amazon.com/chime-sdk/latest/ag/voice-connectors.html
#   - Origination API Reference: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_Origination.html
#   - OriginationRoute API Reference: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_OriginationRoute.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chime_voice_connector_origination
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_chime_voice_connector_origination" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # voice_connector_id (Required)
  # 設定内容: Amazon Chime Voice ConnectorのIDを指定します。
  # 設定可能な値: 有効なVoice Connector ID
  # 注意: 事前にaws_chime_voice_connectorリソースで作成したIDを参照します。
  voice_connector_id = aws_chime_voice_connector.example.id

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # disabled (Optional)
  # 設定内容: 発信元設定を無効にするかを指定します。
  # 設定可能な値:
  #   - true: 発信元設定を無効化。Amazon Chime Voice Connectorへのインバウンドコールが無効になります
  #   - false: 発信元設定を有効化（デフォルト）
  # 用途: インバウンドコールを一時的に停止したい場合に使用
  disabled = false

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ルート設定（必須、1〜20個）
  #-------------------------------------------------------------
  # route (Required)
  # 設定内容: SIPホストへのコール配信プロパティを定義するルートのセットを指定します。
  # 制約: 最小1個、最大20個のルートを設定可能
  # 関連機能: Origination Routes
  #   発信元ルートは、Amazon Chime SDK Voice Connectorを使用してインバウンドコールを
  #   受信するためのSIPホストへのコール配信プロパティを定義します。
  #   - https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_OriginationRoute.html

  # プライマリルート（優先度1）
  route {
    # host (Required)
    # 設定内容: 発信元トラフィックの接続先となるFQDNまたはIPアドレスを指定します。
    # 設定可能な値: 有効なFQDNまたはIPアドレス
    host = "sip-primary.example.com"

    # port (Optional)
    # 設定内容: 発信元ルートのポート番号を指定します。
    # 設定可能な値: 0〜65535の整数
    # 省略時: 5060（SIPのデフォルトポート）
    port = 5060

    # priority (Required)
    # 設定内容: ホストの優先度を指定します（1が最高優先度）。
    # 設定可能な値: 1〜100の整数
    # 動作: 優先度の高いホストが最初に試行されます。
    priority = 1

    # protocol (Required)
    # 設定内容: 発信元ルートで使用するプロトコルを指定します。
    # 設定可能な値:
    #   - "TCP": TCPプロトコル（暗号化が有効なVoice Connectorのデフォルト）
    #   - "UDP": UDPプロトコル
    # 注意: 暗号化が有効なAmazon Chime SDK Voice ConnectorではTCPがデフォルトで使用されます。
    protocol = "TCP"

    # weight (Required)
    # 設定内容: ホストに割り当てる重みを指定します。
    # 設定可能な値: 1〜100の整数
    # 動作: 同じ優先度を持つホスト間で、相対的な重みに基づいてコールが分配されます。
    weight = 50
  }

  # セカンダリルート（優先度2 - フェイルオーバー用）
  route {
    host     = "sip-secondary.example.com"
    port     = 5060
    priority = 2
    protocol = "TCP"
    weight   = 50
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Amazon Chime Voice Connector ID
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 依存リソース例
#---------------------------------------------------------------
# aws_chime_voice_connector_originationは、事前にVoice Connectorが
# 作成されている必要があります。

resource "aws_chime_voice_connector" "example" {
  name               = "example-voice-connector"
  require_encryption = true
  # aws_region = "us-east-1"  # Voice Connectorを作成するリージョン
}
