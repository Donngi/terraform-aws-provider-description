#---------------------------------------------------------------
# AWS AppSync API Key
#---------------------------------------------------------------
#
# AWS AppSync GraphQL APIへのアクセス認証に使用するAPIキーを管理するリソースです。
# APIキーは、シンプルな認証方式として、公開APIや開発環境での使用に適しています。
# 有効期限を設定でき、定期的なローテーションをサポートします。
#
# AWS公式ドキュメント:
#   - AppSync認証と認可: https://docs.aws.amazon.com/appsync/latest/devguide/security-authz.html
#   - APIキー認証: https://docs.aws.amazon.com/appsync/latest/devguide/security-authz.html#api-key-authorization
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
  # 設定内容: APIキーを適用するAppSync GraphQL APIのIDを指定します。
  # 設定可能な値: 有効なAppSync GraphQL APIのID
  # 用途: aws_appsync_graphql_apiリソースのIDを参照して、どのAPIに対してキーを発行するかを指定
  # 関連機能: AppSync API Key Association
  #   APIキーは特定のGraphQL APIに紐付けられ、そのAPIへのアクセス認証に使用されます。
  #   - https://docs.aws.amazon.com/appsync/latest/APIReference/API_CreateApiKey.html
  api_id = aws_appsync_graphql_api.example.id

  #-------------------------------------------------------------
  # APIキー設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: APIキーの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  # 用途: APIキーの用途や管理情報を記載することで、複数のキーを管理しやすくなります
  #      （例: "Production API key for mobile app", "Development API key"）
  # 関連機能: API Key Management
  #   管理コンソールやAPIリストで表示される説明文として使用されます。
  #   - https://docs.aws.amazon.com/appsync/latest/APIReference/API_ApiKey.html
  description = "Example API key for AppSync GraphQL API"

  # expires (Optional)
  # 設定内容: APIキーの有効期限を指定します。
  # 設定可能な値:
  #   - RFC3339形式のタイムスタンプ（例: "2025-12-31T23:59:59Z"）
  #   - Unixエポック秒（例: "1735689599"）
  # 制限事項:
  #   - 作成または更新時点から1～365日後の範囲で指定可能
  #   - 秒単位の値は時間単位に丸められます（切り捨て）
  # 省略時: 作成または更新時点から7日後
  # 用途: セキュリティ要件に応じてAPIキーの有効期間を制御
  # 関連機能: APIキーローテーション
  #   有効期限が近づいたら新しいAPIキーを作成し、古いキーを無効化することで
  #   セキュリティを強化できます。
  #   - https://docs.aws.amazon.com/appsync/latest/APIReference/API_UpdateApiKey.html
  expires = "2025-12-31T23:59:59Z"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 用途: マルチリージョン構成でリソースのリージョンを明示的に指定する場合に使用
  # 関連機能: Regional Resource Management
  #   プロバイダー設定と異なるリージョンでリソースを作成する場合に指定します。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------------------------------
# このリソースが作成された後に参照できる属性:
#
# - id: AppSync APIのIDとAPIキーIDを結合した識別子
#       形式: "<api_id>:<api_key_id>"
#
# - api_key_id: AppSyncが生成したAPIキーの一意識別子
#
# - key: 実際のAPIキー文字列（機密情報）
#       注意: この値は作成時のみ取得可能です。後から再取得することはできません。
#            安全な場所に保存する必要があります。
#
# - region: リソースが作成されたAWSリージョン
#---------------------------------------------------------------
