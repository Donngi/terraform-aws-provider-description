#############################################
# Cognito Managed User Pool Client
#############################################
# AWS Cognitoユーザープール内の管理されたアプリケーションクライアント
# Cognitoが内部的に管理する特殊なクライアントで、名前パターンによる自動生成が可能
#
# 主な用途:
# - Cognitoマネージドアプリケーションのクライアント設定
# - OAuthフロー設定とトークン有効期限の管理
# - アプリケーションレベルの認証設定
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cognito_managed_user_pool_client
# NOTE: 通常のcognito_user_pool_clientと異なり、Cognitoが管理する特殊なクライアント用リソース

#---------------------------------------
# 基本設定
#---------------------------------------
resource "aws_cognito_managed_user_pool_client" "example" {
  # 設定内容: 管理対象のCognitoユーザープールID
  # 設定可能な値: 有効なユーザープールのID (例: us-east-1_aBcDeFgH)
  # 省略時: エラー (必須パラメータ)
  user_pool_id = "us-east-1_example"

  # 設定内容: クライアント名の正規表現パターン
  # 設定可能な値: 正規表現パターン文字列
  # 省略時: null (name_prefixまたはこの属性が必要)
  name_pattern = null

  # 設定内容: クライアント名のプレフィックス
  # 設定可能な値: 任意の文字列 (Terraformが自動的にユニークな名前を生成)
  # 省略時: null (name_patternまたはこの属性が必要)
  name_prefix = null

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  #---------------------------------------
  # 認証フロー設定
  #---------------------------------------
  # 設定内容: 有効化する明示的な認証フロー
  # 設定可能な値:
  #   - ALLOW_ADMIN_USER_PASSWORD_AUTH (管理者による認証)
  #   - ALLOW_CUSTOM_AUTH (カスタム認証フロー)
  #   - ALLOW_USER_PASSWORD_AUTH (ユーザー名とパスワードによる認証)
  #   - ALLOW_USER_SRP_AUTH (SRPプロトコル認証)
  #   - ALLOW_REFRESH_TOKEN_AUTH (リフレッシュトークン認証)
  # 省略時: Cognitoのデフォルト設定
  explicit_auth_flows = []

  # 設定内容: 認証セッションの有効期限 (分)
  # 設定可能な値: 3-15の整数
  # 省略時: デフォルト値を使用
  auth_session_validity = null

  # 設定内容: ユーザーの存在エラーを防ぐための設定
  # 設定可能な値:
  #   - ENABLED (ユーザー存在エラーを隠す)
  #   - LEGACY (従来の動作)
  # 省略時: デフォルト動作
  prevent_user_existence_errors = null

  # 設定内容: 追加のユーザーコンテキストデータの伝播を有効化
  # 設定可能な値: true (有効), false (無効)
  # 省略時: デフォルト設定
  enable_propagate_additional_user_context_data = null

  #---------------------------------------
  # OAuth設定
  #---------------------------------------
  # 設定内容: 許可するOAuthフロー
  # 設定可能な値:
  #   - code (認可コードフロー)
  #   - implicit (インプリシットフロー)
  #   - client_credentials (クライアント認証情報フロー)
  # 省略時: OAuthフローなし
  allowed_oauth_flows = []

  # 設定内容: ユーザープールクライアントでのOAuthフローの有効化
  # 設定可能な値: true (有効), false (無効)
  # 省略時: デフォルト設定
  allowed_oauth_flows_user_pool_client = null

  # 設定内容: 許可するOAuthスコープ
  # 設定可能な値:
  #   - phone, email, openid, profile
  #   - aws.cognito.signin.user.admin
  #   - カスタムスコープ
  # 省略時: スコープなし
  allowed_oauth_scopes = []

  # 設定内容: 認証後のコールバックURL
  # 設定可能な値: 有効なURL (https://またはカスタムスキーム)
  # 省略時: コールバックURLなし
  callback_urls = []

  # 設定内容: デフォルトのリダイレクトURI
  # 設定可能な値: callback_urlsに含まれる有効なURL
  # 省略時: null
  default_redirect_uri = null

  # 設定内容: ログアウト後のリダイレクトURL
  # 設定可能な値: 有効なURL
  # 省略時: ログアウトURLなし
  logout_urls = []

  #---------------------------------------
  # トークン設定
  #---------------------------------------
  # 設定内容: アクセストークンの有効期限
  # 設定可能な値: 1-86400 (単位はtoken_validity_unitsで指定)
  # 省略時: デフォルト値 (60分)
  access_token_validity = null

  # 設定内容: IDトークンの有効期限
  # 設定可能な値: 1-86400 (単位はtoken_validity_unitsで指定)
  # 省略時: デフォルト値 (60分)
  id_token_validity = null

  # 設定内容: リフレッシュトークンの有効期限
  # 設定可能な値: 1-315360000 (単位はtoken_validity_unitsで指定)
  # 省略時: デフォルト値 (30日)
  refresh_token_validity = null

  # 設定内容: トークンの失効を有効化
  # 設定可能な値: true (有効), false (無効)
  # 省略時: デフォルト設定
  enable_token_revocation = null

  #---------------------------------------
  # トークン有効期限の単位
  #---------------------------------------
  token_validity_units {
    # 設定内容: アクセストークンの有効期限単位
    # 設定可能な値: seconds, minutes, hours, days
    # 省略時: minutes
    access_token = null

    # 設定内容: IDトークンの有効期限単位
    # 設定可能な値: seconds, minutes, hours, days
    # 省略時: minutes
    id_token = null

    # 設定内容: リフレッシュトークンの有効期限単位
    # 設定可能な値: seconds, minutes, hours, days
    # 省略時: days
    refresh_token = null
  }

  #---------------------------------------
  # リフレッシュトークンのローテーション
  #---------------------------------------
  refresh_token_rotation {
    # 設定内容: トークンローテーション機能の設定
    # 設定可能な値:
    #   - ENABLED (有効)
    #   - DISABLED (無効)
    # 省略時: エラー (このブロック使用時は必須)
    feature = "ENABLED"

    # 設定内容: トークンローテーションのリトライ猶予期間 (秒)
    # 設定可能な値: 0-86400の整数
    # 省略時: null
    retry_grace_period_seconds = null
  }

  #---------------------------------------
  # 属性アクセス制御
  #---------------------------------------
  # 設定内容: アプリケーションが読み取り可能なユーザー属性
  # 設定可能な値: Cognitoユーザー属性名のリスト
  #   (例: email, name, phone_number, custom:attribute_name)
  # 省略時: すべての属性が読み取り可能
  read_attributes = []

  # 設定内容: アプリケーションが書き込み可能なユーザー属性
  # 設定可能な値: Cognitoユーザー属性名のリスト
  # 省略時: すべての属性が書き込み可能
  write_attributes = []

  #---------------------------------------
  # IDプロバイダー設定
  #---------------------------------------
  # 設定内容: サポートするIDプロバイダー
  # 設定可能な値:
  #   - COGNITO (Cognitoユーザープール)
  #   - Facebook, Google, LoginWithAmazon, SignInWithApple
  #   - SAML, OIDC プロバイダー名
  # 省略時: すべてのプロバイダーをサポート
  supported_identity_providers = []

  #---------------------------------------
  # Analytics設定
  #---------------------------------------
  analytics_configuration {
    # 設定内容: Pinpointアプリケーションのアプリケーションリソース名 (ARN)
    # 設定可能な値: 有効なPinpointアプリケーションARN
    # 省略時: null (application_idまたはこの属性のいずれかが必要)
    application_arn = null

    # 設定内容: PinpointアプリケーションID
    # 設定可能な値: 有効なPinpointアプリケーションID
    # 省略時: null (application_arnまたはこの属性のいずれかが必要)
    application_id = null

    # 設定内容: Pinpointに送信するユーザーの外部ID
    # 設定可能な値: 任意の文字列
    # 省略時: null
    external_id = null

    # 設定内容: CognitoがPinpointにデータを送信するために使用するIAMロールARN
    # 設定可能な値: 有効なIAMロールARN
    # 省略時: 計算された値を使用
    role_arn = null

    # 設定内容: ユーザーデータをPinpointと共有するかどうか
    # 設定可能な値: true (共有), false (非共有)
    # 省略時: デフォルト設定
    user_data_shared = null
  }
}

#############################################
# Attributes Reference
#############################################
# id               - クライアントID (自動生成)
# name             - 生成されたクライアント名
# client_secret    - クライアントシークレット (sensitive、該当する場合のみ)
