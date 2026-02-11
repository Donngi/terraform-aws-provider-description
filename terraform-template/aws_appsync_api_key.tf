#---------------------------------------------------------------
# AWS AppSync APIキー
#---------------------------------------------------------------
#
# AWS AppSync GraphQL APIへのアクセスを認証するためのAPIキーを作成します。
# APIキー認証は、開発環境やパブリックAPIなど、簡易的な認証が必要な
# 場合に使用します。本番環境では、Cognito User PoolsやIAM認証の
# 使用を推奨します。
#
# AWS公式ドキュメント:
#   - AppSync 認証と承認: https://docs.aws.amazon.com/appsync/latest/devguide/security-authz.html
#   - API Key リファレンス: https://docs.aws.amazon.com/appsync/latest/APIReference/API_ApiKey.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_api_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appsync_api_key" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: APIキーを関連付けるAppSync GraphQL APIのID
  # 補足: aws_appsync_graphql_apiリソースのIDを指定します
  api_id = aws_appsync_graphql_api.example.id

  # description (Optional)
  # 設定内容: APIキーの説明
  # 省略時: "Managed by Terraform"
  # 補足: APIキーの用途や環境を識別するための説明文を記載します
  description = "API Key for mobile application"

  #-------------------------------------------------------------
  # 有効期限設定
  #-------------------------------------------------------------

  # expires (Optional)
  # 設定内容: APIキーの有効期限（RFC3339形式のタイムスタンプ）
  # 省略時: 作成日時から7日後
  # 補足: 最も近い1時間単位に切り下げられます
  #       有効期限後60日間は更新可能で、その後完全に削除されます
  #       形式例: "2026-12-31T23:59:59Z"
  expires = "2026-12-31T23:59:59Z"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  # 補足: マルチリージョン構成でリージョンを明示的に指定する場合に使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 識別子設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: APIキーの一意識別子
  # 省略時: 自動生成される
  # 補足: 通常は省略し、Terraformに自動生成させます
  #       形式: "ApiId:Key"
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: APIキーID（形式: ApiId:Key）
# - api_key_id: APIキーのID部分のみ
# - key: 実際のAPIキー文字列（センシティブ情報）
#---------------------------------------------------------------
