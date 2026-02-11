#---------------------------------------------------------------
# AWS Bedrock AgentCore Workload Identity
#---------------------------------------------------------------
#
# Amazon Bedrock AgentCore Identityのワークロードアイデンティティを
# プロビジョニングするリソースです。
# ワークロードアイデンティティは、AIエージェントや自動化ワークロードに対して
# OAuth2ベースの認証・認可を提供し、外部リソースへの安全なアクセスを可能にします。
#
# AWS公式ドキュメント:
#   - AgentCore Identity概要: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity.html
#   - ワークロードアイデンティティの理解: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/understanding-agent-identities.html
#   - ワークロードアイデンティティの作成と管理: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/creating-agent-identities.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_workload_identity
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_workload_identity" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: ワークロードアイデンティティの名前を指定します。
  # 設定可能な値: 3-255文字の文字列。英数字、ハイフン、ピリオド、アンダースコアのみ使用可能。
  # 用途: AIエージェントや自動化ワークロードを一意に識別するための名前
  name = "example-workload-identity"

  #-------------------------------------------------------------
  # OAuth2リダイレクトURL設定
  #-------------------------------------------------------------

  # allowed_resource_oauth2_return_urls (Optional)
  # 設定内容: このワークロードアイデンティティに関連付けられたリソースに対して
  #          許可するOAuth2リダイレクト（コールバック）URLのセットを指定します。
  # 設定可能な値: 有効なURLの文字列セット
  # 用途: OAuth2認証フローにおいて、認証完了後のリダイレクト先として許可するURLを定義。
  #       複数のURLを指定することで、異なるアプリケーションやエンドポイントからの
  #       認証フローをサポートできます。
  # 関連機能: AgentCore Identity OAuth 2.0フローサポート
  #   AgentCore Identityは、クライアントクレデンシャルグラント（2LO）と
  #   認可コードグラント（3LO）の両方のOAuth 2.0フローをサポートします。
  #   - https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/key-features-and-benefits.html
  allowed_resource_oauth2_return_urls = [
    "https://app.example.com/oauth/callback",
    "https://api.example.com/auth/return"
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - workload_identity_arn: ワークロードアイデンティティのAmazon Resource Name (ARN)
#---------------------------------------------------------------
