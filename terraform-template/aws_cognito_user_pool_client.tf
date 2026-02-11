# ================================================================================
# Terraform AWS Resource Template: aws_cognito_user_pool_client
# ================================================================================
#
# 生成日: 2026-01-19
# Provider Version: 6.28.0
#
# 注意:
# このテンプレートは生成時点(Provider version 6.28.0)の情報に基づいています。
# 最新の仕様や詳細については、必ず公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client
# ================================================================================

resource "aws_cognito_user_pool_client" "example" {
  # ================================================================================
  # 必須パラメータ
  # ================================================================================

  # name - (Required) アプリケーションクライアントの名前
  # アプリクライアントはユーザープールに対する認証要求を行うアプリケーションを表します。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_CreateUserPoolClient.html
  name = "example-client"

  # user_pool_id - (Required) クライアントが属するユーザープールのID
  # ユーザープールのIDを指定します。通常は aws_cognito_user_pool リソースの id 属性を参照します。
  # 参考: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pool-updating.html
  user_pool_id = "us-east-1_example"

  # ================================================================================
  # オプションパラメータ - トークン有効期限設定
  # ================================================================================

  # access_token_validity - (Optional) アクセストークンの有効期限
  # 5分から1日の間で設定可能。デフォルトの単位は時間(hours)。
  # token_validity_units.access_token で単位を上書き可能。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  access_token_validity = 1

  # id_token_validity - (Optional) IDトークンの有効期限
  # 5分から1日の間で設定可能。デフォルトの単位は時間(hours)。
  # token_validity_units.id_token で単位を上書き可能。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  id_token_validity = 1

  # refresh_token_validity - (Optional) リフレッシュトークンの有効期限
  # 60分から10年の間で設定可能。デフォルトの単位は日(days)。
  # token_validity_units.refresh_token で単位を上書き可能。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  refresh_token_validity = 30

  # auth_session_validity - (Optional) 認証フローにおけるセッショントークンの有効期限(分単位)
  # 3〜15分の間で設定可能。デフォルトは3分。
  # ネイティブユーザーがこのトークンに応答する必要がある期間を指定します。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  auth_session_validity = 3

  # ================================================================================
  # オプションパラメータ - OAuth 2.0 設定
  # ================================================================================

  # allowed_oauth_flows_user_pool_client - (Optional) OAuth 2.0機能の使用を許可するかどうか
  # true に設定することで、callback_urls、logout_urls、allowed_oauth_scopes、allowed_oauth_flows を構成可能になります。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  allowed_oauth_flows_user_pool_client = false

  # allowed_oauth_flows - (Optional) 許可されるOAuthフローのリスト
  # 設定可能な値: "code"(認可コード)、"implicit"(暗黙的フロー)、"client_credentials"(クライアント認証情報)
  # allowed_oauth_flows_user_pool_client を true に設定する必要があります。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  allowed_oauth_flows = ["code"]

  # allowed_oauth_scopes - (Optional) 許可されるOAuthスコープのリスト
  # 設定可能な値: "phone"、"email"、"openid"、"profile"、"aws.cognito.signin.user.admin"
  # allowed_oauth_flows_user_pool_client を true に設定する必要があります。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  allowed_oauth_scopes = ["openid", "email"]

  # callback_urls - (Optional) アイデンティティプロバイダーで許可されるコールバックURLのリスト
  # 認証後にユーザーをリダイレクトするURLを指定します。
  # allowed_oauth_flows_user_pool_client を true に設定する必要があります。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  callback_urls = ["https://example.com/callback"]

  # logout_urls - (Optional) アイデンティティプロバイダーで許可されるログアウトURLのリスト
  # ログアウト後にユーザーをリダイレクトするURLを指定します。
  # allowed_oauth_flows_user_pool_client を true に設定する必要があります。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  logout_urls = ["https://example.com/logout"]

  # default_redirect_uri - (Optional) デフォルトのリダイレクトURI
  # callback_urls のリストに含まれている必要があります。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  default_redirect_uri = "https://example.com/callback"

  # ================================================================================
  # オプションパラメータ - 認証設定
  # ================================================================================

  # explicit_auth_flows - (Optional) 認証フローのリスト
  # 設定可能な値:
  # - ADMIN_NO_SRP_AUTH: 管理者ベースのユーザーパスワード認証(SRPなし)
  # - CUSTOM_AUTH_FLOW_ONLY: カスタム認証フローのみ
  # - USER_PASSWORD_AUTH: ユーザーパスワード認証
  # - ALLOW_ADMIN_USER_PASSWORD_AUTH: 管理者ユーザーパスワード認証を許可
  # - ALLOW_CUSTOM_AUTH: カスタム認証を許可
  # - ALLOW_USER_PASSWORD_AUTH: ユーザーパスワード認証を許可
  # - ALLOW_USER_SRP_AUTH: SRPベースのユーザー認証を許可
  # - ALLOW_REFRESH_TOKEN_AUTH: リフレッシュトークン認証を許可
  # - ALLOW_USER_AUTH: ユーザー認証を許可
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  # supported_identity_providers - (Optional) このクライアントでサポートされるアイデンティティプロバイダーのリスト
  # aws_cognito_identity_provider リソースの provider_name 属性、または同等の文字列を使用します。
  # "COGNITO" を指定すると、Cognito自体をIDプロバイダーとして使用します。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  supported_identity_providers = ["COGNITO"]

  # ================================================================================
  # オプションパラメータ - セキュリティとプライバシー設定
  # ================================================================================

  # generate_secret - (Optional) アプリケーションシークレットを生成するかどうか
  # true に設定すると、クライアントシークレットが生成されます。
  # サーバーサイドアプリケーションで使用する場合に推奨されます。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  generate_secret = false

  # prevent_user_existence_errors - (Optional) ユーザー存在エラーの処理方法を決定
  # 設定可能な値: "ENABLED"(有効)、"LEGACY"(レガシー)
  # 認証、アカウント確認、パスワード回復時にユーザーがユーザープールに存在しない場合のエラーと応答を制御します。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  prevent_user_existence_errors = "ENABLED"

  # enable_token_revocation - (Optional) トークン失効を有効にするかどうか
  # true に設定すると、トークンの失効が有効になります。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  enable_token_revocation = true

  # enable_propagate_additional_user_context_data - (Optional) 追加のユーザーコンテキストデータの伝播を有効にするかどうか
  # 高度なセキュリティ機能で使用される追加のコンテキストデータを伝播します。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  enable_propagate_additional_user_context_data = false

  # ================================================================================
  # オプションパラメータ - 属性アクセス設定
  # ================================================================================

  # read_attributes - (Optional) アプリケーションクライアントが読み取り可能なユーザープール属性のリスト
  # 指定しない場合、すべての属性へのアクセスが許可されます。
  # 例: ["email", "name", "phone_number"]
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  read_attributes = []

  # write_attributes - (Optional) アプリケーションクライアントが書き込み可能なユーザープール属性のリスト
  # 指定しない場合、すべての属性への書き込みが許可されます。
  # 例: ["email", "name", "phone_number"]
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
  write_attributes = []

  # ================================================================================
  # オプションパラメータ - リージョン設定
  # ================================================================================

  # region - (Optional) このリソースが管理されるリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ================================================================================
  # ネストブロック: analytics_configuration
  # ================================================================================
  # Amazon Pinpoint 分析の構成ブロック
  # このユーザープールのメトリクスを収集します。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AnalyticsConfigurationType.html

  # analytics_configuration {
  #   # application_id - (Optional) Amazon Pinpoint アプリケーションのID
  #   # application_id = "your-pinpoint-app-id"

  #   # application_arn - (Optional) Amazon Pinpoint アプリケーションのARN
  #   # external_id および role_arn と競合します。
  #   # application_arn = "arn:aws:mobiletargeting:us-east-1:123456789012:apps/your-app-id"

  #   # external_id - (Optional) 分析構成のID
  #   # application_arn と競合します。
  #   # external_id = "some_id"

  #   # role_arn - (Optional) Amazon Cognito が Amazon Pinpoint にイベントを公開することを許可するIAMロールのARN
  #   # application_arn と競合します。
  #   # role_arn = "arn:aws:iam::123456789012:role/service-role/Cognito-UserPool-Role"

  #   # user_data_shared - (Optional) ユーザーデータを Amazon Pinpoint と共有するかどうか
  #   # user_data_shared = true
  # }

  # ================================================================================
  # ネストブロック: refresh_token_rotation
  # ================================================================================
  # リフレッシュトークンローテーションの構成ブロック
  # トークンローテーションによりセキュリティが向上します。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_TokenValidityUnitsType.html

  # refresh_token_rotation {
  #   # feature - (Required) リフレッシュトークンローテーションの状態
  #   # 設定可能な値: "ENABLED"(有効)、"DISABLED"(無効)
  #   # feature = "ENABLED"

  #   # retry_grace_period_seconds - (Optional) ユーザーが古いリフレッシュトークンを使用できる期間(秒単位)
  #   # 0〜60秒の間で設定可能。古いトークンが無効化されるまでの猶予期間です。
  #   # retry_grace_period_seconds = 10
  # }

  # ================================================================================
  # ネストブロック: token_validity_units
  # ================================================================================
  # トークン有効期限の単位を表す構成ブロック
  # 各トークンタイプの有効期限の単位を指定します。
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_TokenValidityUnitsType.html

  # token_validity_units {
  #   # access_token - (Optional) access_token_validity の時間単位
  #   # デフォルト値: "hours"
  #   # 設定可能な値: "seconds"、"minutes"、"hours"、"days"
  #   # access_token = "hours"

  #   # id_token - (Optional) id_token_validity の時間単位
  #   # デフォルト値: "hours"
  #   # 設定可能な値: "seconds"、"minutes"、"hours"、"days"
  #   # id_token = "hours"

  #   # refresh_token - (Optional) refresh_token_validity の時間単位
  #   # デフォルト値: "days"
  #   # 設定可能な値: "seconds"、"minutes"、"hours"、"days"
  #   # refresh_token = "days"
  # }
}

# ================================================================================
# 出力値
# ================================================================================
# 以下の属性は computed であり、リソース作成後に参照可能です。

# output "client_id" {
#   description = "ユーザープールクライアントのID"
#   value       = aws_cognito_user_pool_client.example.id
# }

# output "client_secret" {
#   description = "ユーザープールクライアントのシークレット(generate_secret=trueの場合のみ)"
#   value       = aws_cognito_user_pool_client.example.client_secret
#   sensitive   = true
# }
