#---------------------------------------------------------------
# AWS Chime Voice Connector
#---------------------------------------------------------------
#
# Amazon Chime SDK Voice Connectorをプロビジョニングするリソースです。
# Voice Connectorは、既存の電話システムをAWSの電話ネットワークに接続し、
# SIPトランキングを通じて大幅なコスト削減でコール送受信を可能にします。
#
# AWS公式ドキュメント:
#   - Voice Connector概要: https://docs.aws.amazon.com/chime-sdk/latest/ag/voice-connectors.html
#   - Voice Connector作成: https://docs.aws.amazon.com/chime-sdk/latest/ag/create-voicecon.html
#   - SIPトランキング ホワイトペーパー: https://docs.aws.amazon.com/whitepapers/latest/real-time-communication-on-aws/highly-available-sip-trunking-with-amazon-chime-voice-connector.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chime_voice_connector
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_chime_voice_connector" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Amazon Chime Voice Connectorの名前を指定します。
  # 設定可能な値: 一意の文字列
  # 注意: Voice Connectorを識別するための名前
  name = "my-voice-connector"

  # require_encryption (Required)
  # 設定内容: Voice Connectorで暗号化を必須にするかを指定します。
  # 設定可能な値:
  #   - true: 暗号化を有効化。SIPシグナリングにTLSトランスポート、メディアにSecure RTP (SRTP) を使用
  #   - false: 暗号化を無効化
  # 関連機能: Voice Connector暗号化
  #   暗号化を有効にすると、インバウンドコールはTLSトランスポートを使用し、
  #   暗号化されていないアウトバウンドコールはブロックされます。
  #   - https://docs.aws.amazon.com/chime-sdk/latest/ag/create-voicecon.html
  require_encryption = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # aws_region (Optional)
  # 設定内容: Amazon Chime Voice Connectorを作成するAWSリージョンを指定します。
  # 設定可能な値:
  #   - "us-east-1": 米国東部（バージニア北部）
  #   - "us-west-2": 米国西部（オレゴン）
  # 省略時: "us-east-1"
  # 注意: Voice Connectorは現在、us-east-1またはus-west-2リージョンでのみ利用可能です。
  #   - https://docs.aws.amazon.com/chime-sdk/latest/dg/mtgs-sdk-cvc.html
  aws_region = "us-east-1"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-voice-connector"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Amazon Chime Voice ConnectorのAmazon Resource Name (ARN)
#
# - outbound_host_name: Amazon Chime Voice Connectorのアウトバウンドホスト名。
#        SIPリクエストを作成する際にこのホスト名を使用します。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
