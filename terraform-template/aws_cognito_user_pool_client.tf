#---------------------------------------
# aws_cognito_user_pool_client
#---------------------------------------
# 用途: Amazon Cognito User PoolのApp Client（アプリケーションクライアント）を作成します
# カテゴリ: Security, Identity, & Compliance > Amazon Cognito
# 関連ドキュメント: https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-client-apps.html
# Terraform ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client
# Provider Version: 6.28.0
# Generated: 2026-02-13
#
# App Clientは、Cognito User Poolと対話するアプリケーションの認証設定を管理します。
# OAuth 2.0フロー、認証フロー、トークン有効期限、コールバックURLなどを設定できます。
# 各User Poolには複数のApp Clientを作成でき、Web/モバイル/バックエンドなど用途別に分けて管理できます。
#
# NOTE: このテンプレートはリファレンス目的で全てのパラメータを記載しています。
#       実際の使用時は不要な設定をコメントアウトまたは削除してください。

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_cognito_user_pool_client" "example" {
  # 設定内容: App Clientの名前
  # 制約事項: 必須項目
  name = "example-client"

  # 設定内容: このApp Clientが属するUser PoolのID
  # 制約事項: 必須項目
  user_pool_id = aws_cognito_user_pool.example.id

  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "ap-northeast-1"

  #---------------------------------------
  # クライアントシークレット設定
  #---------------------------------------

  # 設定内容: クライアントシークレットを生成するかどうか
  # 設定可能な値: true（秘密鍵を生成）、false（生成しない、デフォルト）
  # 注意事項: パブリッククライアント（SPAやモバイルアプリ）ではfalseを推奨、バックエンドサーバーではtrueを推奨
  generate_secret = false

  #---------------------------------------
  # 認証フロー設定
  #---------------------------------------

  # 設定内容: 有効にする認証フローのリスト
  # 設定可能な値:
  #   - ADMIN_NO_SRP_AUTH: サーバーサイド認証（SRPなし）
  #   - ALLOW_ADMIN_USER_PASSWORD_AUTH: 管理者ユーザー名パスワード認証
  #   - ALLOW_CUSTOM_AUTH: カスタム認証フロー
  #   - ALLOW_USER_PASSWORD_AUTH: ユーザー名パスワード認証
  #   - ALLOW_USER_SRP_AUTH: SRP（Secure Remote Password）認証
  #   - ALLOW_REFRESH_TOKEN_AUTH: リフレッシュトークン認証
  # 省略時: デフォルトの認証フローが適用される
  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  # 設定内容: 認証セッションの有効期間（分単位）
  # 設定可能な値: 3〜15の整数
  # 省略時: 3分（Managed Login）または8分（パスワードリセット）
  auth_session_validity = 3

  #---------------------------------------
  # OAuth 2.0設定
  #---------------------------------------

  # 設定内容: 許可するOAuth 2.0フローのリスト
  # 設定可能な値:
  #   - code: 認可コードグラント
  #   - implicit: インプリシットグラント
  #   - client_credentials: クライアントクレデンシャルグラント
  # 省略時: OAuthフローは無効
  allowed_oauth_flows = ["code", "implicit"]

  # 設定内容: OAuth 2.0フローをUser Pool Clientで有効にするかどうか
  # 設定可能な値: true（有効）、false（無効、デフォルト）
  # 注意事項: allowed_oauth_flowsを設定する場合はtrueにする必要がある
  allowed_oauth_flows_user_pool_client = true

  # 設定内容: 許可するOAuth 2.0スコープのリスト
  # 設定可能な値:
  #   - phone: 電話番号へのアクセス
  #   - email: メールアドレスへのアクセス
  #   - openid: OpenID Connectサポート
  #   - profile: ユーザープロファイルへのアクセス
  #   - aws.cognito.signin.user.admin: 全ユーザー属性へのアクセス
  #   - カスタムスコープ（Resource Server定義が必要）
  # 省略時: スコープ制限なし
  allowed_oauth_scopes = ["openid", "email", "phone", "profile"]

  # 設定内容: 認証成功後のリダイレクト先URLリスト
  # 制約事項: OAuth 2.0フローを使用する場合は必須
  # 注意事項: URLは完全修飾形式（https://example.com/callback）で指定
  callback_urls = ["https://example.com/callback"]

  # 設定内容: コールバックURLリストのうち、デフォルトで使用するURL
  # 制約事項: callback_urlsに含まれるURLである必要がある
  # 省略時: callback_urlsの最初のURLが使用される
  default_redirect_uri = "https://example.com/callback"

  # 設定内容: ログアウト後のリダイレクト先URLリスト
  # 注意事項: OAuth 2.0フローでログアウト機能を使用する場合に設定
  logout_urls = ["https://example.com/logout"]

  #---------------------------------------
  # Identity Provider設定
  #---------------------------------------

  # 設定内容: サポートする外部Identity Providerのリスト
  # 設定可能な値:
  #   - COGNITO: Cognito User Pool（ネイティブ認証）
  #   - Facebook: Facebook認証
  #   - Google: Google認証
  #   - LoginWithAmazon: Amazon認証
  #   - SignInWithApple: Apple認証
  #   - SAML: SAMLベースのIdP
  #   - OIDC: OpenID ConnectベースのIdP
  # 省略時: 全てのプロバイダーが許可される
  supported_identity_providers = ["COGNITO"]

  #---------------------------------------
  # トークン有効期限設定
  #---------------------------------------

  # 設定内容: アクセストークンの有効期間
  # 設定可能な値: 5分〜24時間（token_validity_unitsで単位を指定）
  # 省略時: 60分
  access_token_validity = 60

  # 設定内容: IDトークンの有効期間
  # 設定可能な値: 5分〜24時間（token_validity_unitsで単位を指定）
  # 省略時: 60分
  id_token_validity = 60

  # 設定内容: リフレッシュトークンの有効期間
  # 設定可能な値: 60分〜3650日（token_validity_unitsで単位を指定）
  # 省略時: 30日
  refresh_token_validity = 30

  # 設定内容: 各トークンの有効期間の単位を設定
  token_validity_units {
    # 設定内容: アクセストークンの時間単位
    # 設定可能な値: seconds、minutes、hours、days
    # 省略時: hours
    access_token = "minutes"

    # 設定内容: IDトークンの時間単位
    # 設定可能な値: seconds、minutes、hours、days
    # 省略時: hours
    id_token = "minutes"

    # 設定内容: リフレッシュトークンの時間単位
    # 設定可能な値: seconds、minutes、hours、days
    # 省略時: days
    refresh_token = "days"
  }

  #---------------------------------------
  # トークン失効設定
  #---------------------------------------

  # 設定内容: トークン失効機能を有効にするかどうか
  # 設定可能な値: true（有効、デフォルト）、false（無効）
  # 注意事項: trueの場合、RevokeToken APIでトークンを無効化できる
  enable_token_revocation = true

  # 設定内容: リフレッシュトークンのローテーション設定
  refresh_token_rotation {
    # 設定内容: トークンローテーション機能の有効/無効
    # 設定可能な値: enabled、disabled
    # 制約事項: 必須項目
    feature = "enabled"

    # 設定内容: トークンローテーション後の猶予期間（秒）
    # 設定可能な値: 0〜3,153,600秒（0〜約1年）
    # 省略時: 0秒（猶予期間なし）
    # 注意事項: この期間内は古いリフレッシュトークンも有効
    retry_grace_period_seconds = 300
  }

  #---------------------------------------
  # 属性アクセス制御
  #---------------------------------------

  # 設定内容: App Clientが読み取り可能なユーザー属性のリスト
  # 設定可能な値: User Poolで定義された標準属性またはカスタム属性の名前
  # 省略時: 全ての属性にアクセス可能
  # 注意事項: セキュリティ強化のため、必要最小限の属性のみ許可することを推奨
  read_attributes = ["email", "email_verified", "name"]

  # 設定内容: App Clientが書き込み可能なユーザー属性のリスト
  # 設定可能な値: User Poolで定義された標準属性またはカスタム属性の名前
  # 省略時: 全ての属性に書き込み可能
  # 注意事項: セキュリティ強化のため、必要最小限の属性のみ許可することを推奨
  write_attributes = ["email", "name"]

  #---------------------------------------
  # セキュリティ設定
  #---------------------------------------

  # 設定内容: ユーザー存在エラーの防止設定
  # 設定可能な値:
  #   - ENABLED: ユーザーの存在を隠蔽し、汎用エラーメッセージを返す
  #   - LEGACY: ユーザーの存在を示すエラーメッセージを返す
  # 省略時: LEGACY
  # 注意事項: セキュリティ向上のためENABLEDを推奨（ユーザー列挙攻撃を防止）
  prevent_user_existence_errors = "ENABLED"

  # 設定内容: 追加のユーザーコンテキストデータを伝播するかどうか
  # 設定可能な値: true（有効）、false（無効、デフォルト）
  # 注意事項: 高度なセキュリティ機能（リスクベース認証）で使用
  enable_propagate_additional_user_context_data = false

  #---------------------------------------
  # 分析設定
  #---------------------------------------

  # 設定内容: Amazon Pinpoint分析の設定
  analytics_configuration {
    # 設定内容: Amazon PinpointアプリケーションのARN
    # 注意事項: application_idまたはapplication_arnのいずれか一方を指定
    application_arn = "arn:aws:mobiletargeting:ap-northeast-1:123456789012:apps/abc123"

    # 設定内容: Amazon PinpointアプリケーションのID
    # 注意事項: application_idまたはapplication_arnのいずれか一方を指定
    # application_id = "abc123"

    # 設定内容: 外部ID（クロスアカウントアクセス用）
    # 省略時: 外部IDなし
    external_id = "my-external-id"

    # 設定内容: Pinpointへのアクセスに使用するIAMロールのARN
    # 省略時: 自動的に生成されるロールが使用される
    role_arn = "arn:aws:iam::123456789012:role/CognitoPinpointRole"

    # 設定内容: ユーザーデータをPinpointと共有するかどうか
    # 設定可能な値: true（共有する）、false（共有しない、デフォルト）
    # 省略時: false
    user_data_shared = true
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースでは以下の属性を参照できます（変更は上記設定項目で行います）
#
# id                 : App ClientのID（自動生成）
# client_secret      : クライアントシークレット（generate_secret = trueの場合のみ）、機密情報のため注意
# region             : リソースが管理されているリージョン
#
# ※ 上記以外のcomputed属性は基本的に設定値と同一のため省略しています
