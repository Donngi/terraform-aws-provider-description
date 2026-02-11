#---------------------------------------------------------------
# AWS AppSync API Key
#---------------------------------------------------------------
#
# AWS AppSyncのAPIキーをプロビジョニングするリソースです。
# APIキーは、AppSync GraphQL APIに対するシンプルな認証方法を提供します。
# 認証されていないAPIアクセスに対する簡易的なセキュリティオプションとして使用され、
# スロットリング制御が可能です。
#
# AWS公式ドキュメント:
#   - AppSync認証と認可: https://docs.aws.amazon.com/appsync/latest/devguide/security-authz.html
#   - AppSync APIキー仕様: https://docs.aws.amazon.com/appsync/latest/APIReference/API_ApiKey.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_api_key
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appsync_api_key" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: 関連付けるAppSync GraphQL APIのIDを指定します。
  # 設定可能な値: 有効なAppSync GraphQL APIのID
  # 注意: APIキーを使用するには、対象のGraphQL APIの認証タイプに
  #       "API_KEY" が含まれている必要があります。
  api_id = aws_appsync_graphql_api.example.id

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: APIキーの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: "Managed by Terraform" がデフォルト値として設定されます。
  # 用途: APIキーの目的や用途を識別するために使用します。
  description = "API key for mobile application access"

  # expires (Optional)
  # 設定内容: APIキーの有効期限を指定します。
  # 設定可能な値: RFC3339形式の日時文字列（例: "2024-12-31T23:59:59Z"）
  # 省略時: 作成日から7日後が自動設定されます。
  # 注意:
  #   - 有効期限は最も近い時間に切り捨てられます。
  #   - APIキーには2つのバージョン（da1/da2）があり、現在はda2が使用されます。
  #   - da2キーは有効期限の延長が可能で、期限切れ後も60日間は保持されます。
  #   - 期限切れ後は認証に失敗しますが、削除されるまでは再有効化が可能です。
  # 参考: https://docs.aws.amazon.com/appsync/latest/APIReference/API_ApiKey.html
  expires = "2025-12-31T23:59:59Z"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: APIキーID（フォーマット: ApiId:Key）
#
# - api_key_id: APIキーの一意の識別子
#
# - key: 生成されたAPIキーの値（機密情報として扱われます）
#        このキーはAppSync GraphQL APIへのリクエストヘッダー
#        "x-api-key" に設定して使用します。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: AppSync GraphQL APIと組み合わせた設定
#---------------------------------------------------------------
# resource "aws_appsync_graphql_api" "example" {
#   authentication_type = "API_KEY"
#   name                = "example-api"
# }
#
# resource "aws_appsync_api_key" "example" {
#   api_id  = aws_appsync_graphql_api.example.id
#   expires = "2025-12-31T23:59:59Z"
# }
#---------------------------------------------------------------
