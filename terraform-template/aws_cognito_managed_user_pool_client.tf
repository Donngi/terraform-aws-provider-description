################################################################################
# aws_cognito_managed_user_pool_client
################################################################################
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-19)の情報に基づいています。
#       最新の仕様については公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_managed_user_pool_client
#
# このリソースは特殊なユースケース向けです:
# aws_cognito_managed_user_pool_client は、他のAWSサービス(OpenSearchなど)によって
# 自動的に作成されたCognito User Pool Clientを管理するための「高度な」リソースです。
# 通常のユースケースでは aws_cognito_user_pool_client を使用してください。
#
# AWS公式ドキュメント:
# - CreateUserPoolClient API: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_CreateUserPoolClient.html
# - UpdateUserPoolClient API: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolClient.html
# - OAuth 2.0 Grants: https://docs.aws.amazon.com/cognito/latest/developerguide/federation-endpoints-oauth-grants.html
################################################################################

resource "aws_cognito_managed_user_pool_client" "example" {
  # ============================================================================
  # 必須パラメータ (Required)
  # ============================================================================

  # user_pool_id - (必須) このクライアントが属するUser PoolのID
  # 管理対象のUser Pool ClientがどのUser Poolに属するかを指定します。
  user_pool_id = "us-east-1_XXXXXXXXX"

  # name_pattern または name_prefix のいずれか一方が必須
  #
  # name_pattern - (条件付き必須) 管理対象とする既存User Pool Clientの名前に
  # マッチする正規表現パターン。1つのUser Pool Clientにのみマッチする必要があります。
  # 例: "^AmazonOpenSearchService-example-(\\w+)$"
  name_pattern = "^AmazonOpenSearchService-.*$"

  # name_prefix - (条件付き必須) 管理対象とする既存User Pool Clientの名前の
  # 先頭にマッチする文字列。1つのUser Pool Clientにのみマッチする必要があります。
  # 例: "AmazonOpenSearchService-example-"
  # name_prefix = "AmazonOpenSearchService-"

  # ============================================================================
  # オプションパラメータ (Optional)
  # ============================================================================

  # region - (オプション) このリソースが管理されるAWSリージョン
  # デフォルトではプロバイダー設定のリージョンが使用されます。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ----------------------------------------------------------------------------
  # トークン有効期限設定
  # ----------------------------------------------------------------------------

  # access_token_validity - (オプション) アクセストークンの有効期限
  # 5分から1日の範囲で指定。デフォルトの単位は時間(hours)。
  # token_validity_units.access_token で単位を変更可能。
  # アクセストークンは、ユーザーのアクセス権限を付与するために使用されます。
  # access_token_validity = 60

  # id_token_validity - (オプション) IDトークンの有効期限
  # 5分から1日の範囲で指定。デフォルトの単位は時間(hours)。
  # token_validity_units.id_token で単位を変更可能。
  # IDトークンは、ユーザーのID情報を含みます。
  # id_token_validity = 60

  # refresh_token_validity - (オプション) リフレッシュトークンの有効期限
  # 60分から10年の範囲で指定。デフォルトの単位は日(days)。
  # token_validity_units.refresh_token で単位を変更可能。
  # リフレッシュトークンは、アクセストークンとIDトークンの更新に使用されます。
  # refresh_token_validity = 30

  # auth_session_validity - (オプション) 認証フローにおけるセッショントークンの有効期限(分)
  # 3〜15分の範囲で指定可能。デフォルトは3分。
  # ネイティブユーザーは、セッショントークンの有効期限が切れる前に応答する必要があります。
  # auth_session_validity = 3

  # ----------------------------------------------------------------------------
  # OAuth 2.0 設定
  # ----------------------------------------------------------------------------

  # allowed_oauth_flows_user_pool_client - (オプション) クライアントがOAuth 2.0機能を
  # 使用できるかどうかを指定するブール値。
  # trueに設定すると、callback_urls, logout_urls, allowed_oauth_scopes,
  # allowed_oauth_flows の設定が可能になります。
  # allowed_oauth_flows_user_pool_client = true

  # allowed_oauth_flows - (オプション) 許可するOAuthフローのリスト
  # 指定可能な値: "code" (認可コードグラント), "implicit" (インプリシットグラント),
  # "client_credentials" (クライアントクレデンシャルグラント)
  # allowed_oauth_flows_user_pool_client = true の設定が必要です。
  # https://docs.aws.amazon.com/cognito/latest/developerguide/federation-endpoints-oauth-grants.html
  # allowed_oauth_flows = ["code"]

  # allowed_oauth_scopes - (オプション) 許可するOAuthスコープのリスト
  # 指定可能な値: "phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"
  # allowed_oauth_flows_user_pool_client = true の設定が必要です。
  # allowed_oauth_scopes = ["openid", "email", "profile"]

  # callback_urls - (オプション) IDプロバイダーからの認証後にリダイレクトされる
  # 許可されたコールバックURLのリスト。
  # allowed_oauth_flows_user_pool_client = true の設定が必要です。
  # callback_urls = ["https://example.com/callback"]

  # logout_urls - (オプション) ログアウト後にリダイレクトされる許可されたURLのリスト
  # allowed_oauth_flows_user_pool_client = true の設定が必要です。
  # logout_urls = ["https://example.com/logout"]

  # default_redirect_uri - (オプション) デフォルトのリダイレクトURI
  # callback_urlsのリストに含まれている必要があります。
  # default_redirect_uri = "https://example.com/callback"

  # supported_identity_providers - (オプション) このクライアントでサポートされる
  # IDプロバイダーのリスト。
  # aws_cognito_identity_provider リソースの provider_name 属性、または
  # 同等の文字列を使用します。
  # supported_identity_providers = ["COGNITO"]

  # ----------------------------------------------------------------------------
  # 認証フロー設定
  # ----------------------------------------------------------------------------

  # explicit_auth_flows - (オプション) 認証フローのリスト
  # 指定可能な値:
  # - ADMIN_NO_SRP_AUTH: SRPなしの管理者認証
  # - CUSTOM_AUTH_FLOW_ONLY: カスタム認証フローのみ
  # - USER_PASSWORD_AUTH: ユーザー名とパスワードによる認証
  # - ALLOW_ADMIN_USER_PASSWORD_AUTH: 管理者によるユーザー名/パスワード認証を許可
  # - ALLOW_CUSTOM_AUTH: カスタム認証を許可
  # - ALLOW_USER_PASSWORD_AUTH: ユーザー名/パスワード認証を許可
  # - ALLOW_USER_SRP_AUTH: SRP認証を許可
  # - ALLOW_REFRESH_TOKEN_AUTH: リフレッシュトークン認証を許可
  # explicit_auth_flows = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  # ----------------------------------------------------------------------------
  # セキュリティ設定
  # ----------------------------------------------------------------------------

  # enable_token_revocation - (オプション) トークン取り消しを有効にするかどうか
  # trueに設定すると、トークンの取り消しが可能になります。
  # enable_token_revocation = true

  # prevent_user_existence_errors - (オプション) ユーザーが存在しない場合の
  # エラーとレスポンスの動作を決定する設定
  # 認証、アカウント確認、パスワード回復時にユーザーがUser Poolに存在しない場合に、
  # Cognito APIが返すエラーとレスポンスを制御します。
  # prevent_user_existence_errors = "ENABLED"

  # ----------------------------------------------------------------------------
  # 属性アクセス権限
  # ----------------------------------------------------------------------------

  # read_attributes - (オプション) アプリケーションクライアントが読み取り可能な
  # User Pool属性のリスト
  # 例: ["email", "email_verified", "name", "phone_number"]
  # read_attributes = ["email", "name"]

  # write_attributes - (オプション) アプリケーションクライアントが書き込み可能な
  # User Pool属性のリスト
  # 例: ["email", "name", "phone_number"]
  # write_attributes = ["email", "name"]

  # ----------------------------------------------------------------------------
  # その他の設定
  # ----------------------------------------------------------------------------

  # enable_propagate_additional_user_context_data - (オプション)
  # 追加のユーザーコンテキストデータの伝播を有効にするかどうか
  # enable_propagate_additional_user_context_data = false

  # ============================================================================
  # ネストブロック (Nested Blocks)
  # ============================================================================

  # ----------------------------------------------------------------------------
  # analytics_configuration - Amazon Pinpoint分析設定
  # ----------------------------------------------------------------------------
  # Amazon Pinpointアプリケーションと連携して、このUser Poolのメトリクスを
  # 収集するための設定ブロック。
  # https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AnalyticsConfigurationType.html
  #
  # analytics_configuration {
  #   # application_id - (オプション) Amazon PinpointアプリケーションのユニークID
  #   application_id = "example-app-id"
  #
  #   # application_arn - (オプション) Amazon PinpointアプリケーションのARN
  #   # external_id および role_arn と競合します(同時に使用不可)。
  #   # application_arn = "arn:aws:mobiletargeting:us-east-1:123456789012:apps/example"
  #
  #   # external_id - (オプション) 分析設定のID
  #   # application_arn と競合します(同時に使用不可)。
  #   # external_id = "example-external-id"
  #
  #   # role_arn - (オプション) Amazon PinpointへのイベントPublishを許可するIAMロールのARN
  #   # application_arn と競合します(同時に使用不可)。
  #   # role_arn = "arn:aws:iam::123456789012:role/CognitoPinpointRole"
  #
  #   # user_data_shared - (オプション) user_data_shared が true の場合、
  #   # Amazon CognitoはユーザーデータをAmazon Pinpoint分析に含めます。
  #   # user_data_shared = true
  # }

  # ----------------------------------------------------------------------------
  # token_validity_units - トークン有効期限の単位設定
  # ----------------------------------------------------------------------------
  # access_token_validity, id_token_validity, refresh_token_validity で
  # 指定した値の単位を設定するブロック。
  #
  # token_validity_units {
  #   # access_token - (オプション) access_token_validity の時間単位
  #   # 指定可能な値: "seconds", "minutes", "hours", "days"
  #   # デフォルト: "hours"
  #   # access_token = "hours"
  #
  #   # id_token - (オプション) id_token_validity の時間単位
  #   # 指定可能な値: "seconds", "minutes", "hours", "days"
  #   # デフォルト: "hours"
  #   # id_token = "hours"
  #
  #   # refresh_token - (オプション) refresh_token_validity の時間単位
  #   # 指定可能な値: "seconds", "minutes", "hours", "days"
  #   # デフォルト: "days"
  #   # refresh_token = "days"
  # }

  # ----------------------------------------------------------------------------
  # refresh_token_rotation - リフレッシュトークンローテーション設定
  # ----------------------------------------------------------------------------
  # リフレッシュトークンのローテーション動作を指定するブロック。
  #
  # refresh_token_rotation {
  #   # feature - (必須) 現在のアプリクライアントに対するリフレッシュトークン
  #   # ローテーションの状態。
  #   # 指定可能な値: "ENABLED" または "DISABLED"
  #   # feature = "ENABLED"
  #
  #   # retry_grace_period_seconds - (オプション) ユーザーが古いリフレッシュトークンを
  #   # 使用できる期間(秒)。この期間を過ぎると古いトークンは無効化されます。
  #   # 0〜60秒の範囲で指定可能。
  #   # retry_grace_period_seconds = 0
  # }
}

################################################################################
# 出力例 (Outputs)
################################################################################

# output "user_pool_client_id" {
#   description = "The ID of the user pool client"
#   value       = aws_cognito_managed_user_pool_client.example.id
# }
#
# output "user_pool_client_name" {
#   description = "The name of the user pool client"
#   value       = aws_cognito_managed_user_pool_client.example.name
# }
#
# output "client_secret" {
#   description = "The client secret of the user pool client"
#   value       = aws_cognito_managed_user_pool_client.example.client_secret
#   sensitive   = true
# }
