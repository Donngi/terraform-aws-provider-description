#---------------------------------------------------------------
# AWS Chime Voice Connector Termination Credentials
#---------------------------------------------------------------
#
# Amazon Chime Voice ConnectorにSIP終端認証情報を追加するリソースです。
# SIP認証情報は、Voice Connectorを通じた音声通話の終端処理を行う際に
# 外部SIPホストの認証に使用されます。
#
# AWS公式ドキュメント:
#   - PutVoiceConnectorTerminationCredentials API: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_PutVoiceConnectorTerminationCredentials.html
#   - Voice Connector Termination設定: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_Termination.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chime_voice_connector_termination_credentials
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 重要: Voice Connector Termination Credentialsリソースは、
#       Voice Connector Terminationリソースが存在することが前提です。
#       depends_onを使用して依存関係を明示することを推奨します。
#
#---------------------------------------------------------------

resource "aws_chime_voice_connector_termination_credentials" "example" {
  #-------------------------------------------------------------
  # Voice Connector設定
  #-------------------------------------------------------------

  # voice_connector_id (Required)
  # 設定内容: 認証情報を追加する対象のAmazon Chime Voice Connector IDを指定します。
  # 設定可能な値: 有効なVoice Connector ID
  voice_connector_id = aws_chime_voice_connector.example.id

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
  # SIP認証情報設定
  #-------------------------------------------------------------

  # credentials (Required)
  # 設定内容: SIP終端認証情報のリストを指定します。
  # 最小: 1個
  # 最大: 10個
  # 関連機能: Amazon Chime SDK Voice Connector Termination
  #   SIPホストがVoice Connectorを通じて発信通話を行う際の認証に使用されます。
  #   - https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_PutVoiceConnectorTerminationCredentials.html

  credentials {
    # username (Required)
    # 設定内容: SIP認証情報に関連付けるユーザー名を指定します。
    # 設定可能な値: RFC2617準拠のユーザー名
    username = "sip-user-1"

    # password (Required, Sensitive)
    # 設定内容: SIP認証情報に関連付けるパスワードを指定します。
    # 設定可能な値: RFC2617準拠のパスワード
    # 注意: この値はTerraform stateファイルに保存されます。
    #       機密情報の管理にはAWS Secrets Managerやvault等の利用を推奨します。
    password = "secure-password-1"
  }

  # 複数の認証情報を設定する場合の例
  # credentials {
  #   username = "sip-user-2"
  #   password = "secure-password-2"
  # }

  #-------------------------------------------------------------
  # 依存関係
  #-------------------------------------------------------------
  # Voice Connector Termination Credentialsは、Voice Connector Terminationが
  # 存在することが前提です。レースコンディションを避けるため、
  # depends_onの使用を推奨します。

  depends_on = [aws_chime_voice_connector_termination.example]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Amazon Chime Voice Connector ID
#---------------------------------------------------------------
