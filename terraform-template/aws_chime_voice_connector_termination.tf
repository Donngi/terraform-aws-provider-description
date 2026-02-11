#---------------------------------------------------------------
# AWS Chime Voice Connector Termination
#---------------------------------------------------------------
#
# Amazon Chime Voice Connectorの終端設定（Termination）をプロビジョニングする
# リソースです。終端設定を有効にすることで、SIPインフラストラクチャからの
# アウトバウンドコールを制御できます。
#
# Voice Connectorは、既存の電話システムをAmazon Chime SDKと統合するための
# SIPトランキングサービスです。終端設定により、アウトバウンドコールの
# 発信元IP制限、発信先国の制限、CPS（Calls Per Second）制限などを行います。
#
# AWS公式ドキュメント:
#   - Amazon Chime SDK Voice Connector管理: https://docs.aws.amazon.com/chime-sdk/latest/ag/voice-connectors.html
#   - Termination API Reference: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_Termination.html
#   - PutVoiceConnectorTermination API: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_PutVoiceConnectorTermination.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chime_voice_connector_termination
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_chime_voice_connector_termination" "example" {
  #-------------------------------------------------------------
  # Voice Connector設定
  #-------------------------------------------------------------

  # voice_connector_id (Required)
  # 設定内容: Amazon Chime Voice ConnectorのIDを指定します。
  # 設定可能な値: 有効なVoice Connector ID
  # 注意: 事前にaws_chime_voice_connectorリソースで作成したIDを参照します。
  voice_connector_id = aws_chime_voice_connector.example.id

  #-------------------------------------------------------------
  # 発信先制御設定
  #-------------------------------------------------------------

  # calling_regions (Required)
  # 設定内容: コールを許可する国をISO 3166-1 alpha-2形式で指定します。
  # 設定可能な値: ISO 3166-1 alpha-2の国コードのセット
  #   例: "US"（アメリカ）, "CA"（カナダ）, "JP"（日本）, "GB"（イギリス）
  # 関連機能: アウトバウンドコールの発信先国制限
  #   指定された国以外への発信はブロックされます。
  calling_regions = ["US", "CA"]

  # cidr_allow_list (Required)
  # 設定内容: コール発信を許可するIPアドレスをCIDR形式で指定します。
  # 設定可能な値: 有効なCIDR表記のIPアドレスのセット
  #   例: "50.35.78.96/31", "10.0.0.0/24"
  # 関連機能: IPベースのアクセス制御
  #   許可リストに含まれないIPアドレスからのアウトバウンドコールはブロックされます。
  cidr_allow_list = ["50.35.78.96/31"]

  #-------------------------------------------------------------
  # アウトバウンドコール制御設定
  #-------------------------------------------------------------

  # cps_limit (Optional)
  # 設定内容: 1秒あたりのコール数（CPS: Calls Per Second）の上限を指定します。
  # 設定可能な値: 正の整数（アカウントのサービスクォータに基づく上限あり）
  # 省略時: 1
  # 注意: 大量のアウトバウンドコールを処理する場合は、アカウントの
  #       サービスクォータに応じて適切な値を設定してください。
  cps_limit = 1

  # default_phone_number (Optional)
  # 設定内容: デフォルトの発信者番号（Caller ID）の電話番号を指定します。
  # 設定可能な値: E.164形式の電話番号（例: "+15551234567"）
  # 省略時: 設定なし
  # 注意: Voice Connectorにプロビジョニングされた電話番号を使用してください。
  default_phone_number = null

  # disabled (Optional)
  # 設定内容: 終端設定を無効にするかを指定します。
  # 設定可能な値:
  #   - true: 終端設定を無効化。アウトバウンドコールが発信できなくなります
  #   - false: 終端設定を有効化
  # 省略時: 設定なし
  # 用途: アウトバウンドコールを一時的に停止したい場合に使用
  disabled = false

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
#---------------------------------------------------------------
