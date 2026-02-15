#---------------------------------------------------------------
# Amazon Bedrock AgentCore Workload Identity
#---------------------------------------------------------------
#
# AIエージェントやワークロードが外部リソースにアクセスする際の
# OAuth2ベースの認証・認可を管理するリソースです。
# ワークロードアイデンティティは、AIエージェントがサードパーティサービスに
# 安全にアクセスするための一貫したデジタルアイデンティティを提供します。
#
# AWS公式ドキュメント:
#   - AgentCore Identity: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity.html
#   - Workload Identities: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/understanding-agent-identities.html
#   - OAuth 2.0 Support: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/key-features-and-benefits.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_workload_identity
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_workload_identity" "example" {
  #-------------------------------------------------------------
  # ワークロードアイデンティティ名 (必須)
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ワークロードアイデンティティを識別する名前を指定します。
  # 設定可能な値: 3〜255文字の英数字、ハイフン、ピリオド、アンダースコア
  # 注意: ワークロードアイデンティティはAgentCore RuntimeやGatewayによって
  #       自動作成される場合と、カスタムデプロイのために手動作成される場合があります。
  # 参考: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/understanding-agent-identities.html
  name = "example-workload-identity"

  #-------------------------------------------------------------
  # OAuth2認証設定 (オプション)
  #-------------------------------------------------------------

  # allowed_resource_oauth2_return_urls (Optional)
  # 設定内容: このワークロードアイデンティティに関連するリソースのOAuth2認証フロー時に
  #           許可されるリダイレクトURLのセットを指定します。
  # 設定可能な値: 有効なHTTPS URLのセット
  # 省略時: リダイレクトURLなしで作成されます
  # 用途: OAuth2認証後のコールバックURLを指定することで、
  #       認証フローの完了時に安全なエンドポイントにリダイレクトされます。
  # 注意: セキュリティ上、信頼できるURLのみを設定してください。
  # 関連機能: OAuth 2.0 Authorization URL Session Binding
  #   - https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/oauth2-authorization-url-session-binding.html
  allowed_resource_oauth2_return_urls = null

  #-------------------------------------------------------------
  # リージョン設定 (オプション)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#-------------------------------------------------------------
# Attributes Reference
#-------------------------------------------------------------
# このリソースでは以下の属性が参照可能です:
#
# workload_identity_arn
#   - ワークロードアイデンティティのARN
#   - 参照例: aws_bedrockagentcore_workload_identity.example.workload_identity_arn
#
# name
#   - ワークロードアイデンティティの名前
#
# region
#   - リソースが管理されているリージョン
