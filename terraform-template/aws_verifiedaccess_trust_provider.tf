#-----------------------------------------------------------------------
# AWS Verified Access 信頼プロバイダー (aws_verifiedaccess_trust_provider)
#-----------------------------------------------------------------------
#
# AWS Verified Access の信頼プロバイダーを管理するリソースです。
# ユーザーIDベースまたはデバイスベースの信頼プロバイダーを設定し、
# Verified Access グループやエンドポイントのアクセス制御ポリシーに利用します。
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/verifiedaccess_trust_provider
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
#
# NOTE:
#   - trust_provider_type が "user" の場合は user_trust_provider_type を指定してください
#   - trust_provider_type が "device" の場合は device_trust_provider_type と device_options を指定してください
#   - oidc_options は trust_provider_type = "user" かつ user_trust_provider_type = "oidc" の場合に使用します
#   - native_application_oidc_options は user_trust_provider_type = "native-application-oidc" の場合に使用します
#   - oidc_options.client_secret および native_application_oidc_options.client_secret は機密情報です
#-----------------------------------------------------------------------

resource "aws_verifiedaccess_trust_provider" "example" {
  #-----------------------------------------------------------------------
  # 基本設定
  #-----------------------------------------------------------------------

  # 設定内容: ポリシールールで使用する識別子
  # 設定可能な値: 任意の文字列（例: "example"）
  # 省略時: 必須項目のため省略不可
  policy_reference_name = "example"

  # 設定内容: 信頼プロバイダーの種類
  # 設定可能な値: "user"（ユーザーIDベース）/ "device"（デバイスベース）
  # 省略時: 必須項目のため省略不可
  trust_provider_type = "user"

  # 設定内容: ユーザーIDベースの信頼プロバイダーの種類
  # 設定可能な値: "iam-identity-center" / "oidc" / "native-application-oidc"
  # 省略時: trust_provider_type = "user" の場合は指定が必要
  user_trust_provider_type = "iam-identity-center"

  # 設定内容: デバイスベースの信頼プロバイダーの種類
  # 設定可能な値: "jamf" / "crowdstrike"
  # 省略時: trust_provider_type = "device" の場合は指定が必要
  device_trust_provider_type = null

  # 設定内容: 信頼プロバイダーの説明
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = null

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: "us-east-1"）
  # 省略時: プロバイダー設定のリージョンが使用される
  region = null

  #-----------------------------------------------------------------------
  # デバイスオプション設定
  #-----------------------------------------------------------------------

  # 設定内容: デバイスIDベースの信頼プロバイダーのオプション設定
  # 省略時: デバイスオプションなし（trust_provider_type = "device" の場合に使用）
  # device_options {
  #   # 設定内容: Microsoft Entra ID（Azure AD）のテナントID
  #   # 設定可能な値: テナントID（UUIDフォーマット）
  #   # 省略時: テナントID未設定
  #   tenant_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  # }

  #-----------------------------------------------------------------------
  # OIDC オプション設定
  #-----------------------------------------------------------------------

  # 設定内容: OIDCタイプのユーザーIDベース信頼プロバイダーのOpenID Connect設定
  # 省略時: OIDCオプションなし（user_trust_provider_type = "oidc" の場合に使用）
  # oidc_options {
  #   # 設定内容: OIDCプロバイダーのIssuer URL
  #   # 設定可能な値: HTTPS URL（例: "https://issuer.example.com"）
  #   # 省略時: Issuer未設定
  #   issuer = "https://issuer.example.com"
  #
  #   # 設定内容: OIDCプロバイダーの認可エンドポイントURL
  #   # 設定可能な値: HTTPS URL
  #   # 省略時: 認可エンドポイント未設定
  #   authorization_endpoint = "https://issuer.example.com/oauth2/authorize"
  #
  #   # 設定内容: OIDCプロバイダーのトークンエンドポイントURL
  #   # 設定可能な値: HTTPS URL
  #   # 省略時: トークンエンドポイント未設定
  #   token_endpoint = "https://issuer.example.com/oauth2/token"
  #
  #   # 設定内容: OIDCプロバイダーのユーザー情報エンドポイントURL
  #   # 設定可能な値: HTTPS URL
  #   # 省略時: ユーザー情報エンドポイント未設定
  #   user_info_endpoint = "https://issuer.example.com/oauth2/userinfo"
  #
  #   # 設定内容: OIDCクライアントID
  #   # 設定可能な値: 任意の文字列
  #   # 省略時: クライアントID未設定
  #   client_id = "example-client-id"
  #
  #   # 設定内容: OIDCクライアントシークレット（機密情報）
  #   # 設定可能な値: 任意の文字列
  #   # 省略時: 必須項目のため省略不可
  #   client_secret = "example-client-secret"
  #
  #   # 設定内容: OIDCスコープ（要求するクレームの範囲）
  #   # 設定可能な値: スペース区切りのスコープ文字列（例: "openid email profile"）
  #   # 省略時: スコープ未設定
  #   scope = "openid email profile"
  # }

  #-----------------------------------------------------------------------
  # ネイティブアプリケーション OIDC オプション設定
  #-----------------------------------------------------------------------

  # 設定内容: ネイティブアプリケーションOIDCタイプの信頼プロバイダーのOpenID Connect設定
  # 省略時: ネイティブアプリケーションOIDCオプションなし（user_trust_provider_type = "native-application-oidc" の場合に使用）
  # native_application_oidc_options {
  #   # 設定内容: OIDCプロバイダーのIssuer URL
  #   # 設定可能な値: HTTPS URL（例: "https://issuer.example.com"）
  #   # 省略時: Issuer未設定
  #   issuer = "https://issuer.example.com"
  #
  #   # 設定内容: OIDCプロバイダーの認可エンドポイントURL
  #   # 設定可能な値: HTTPS URL
  #   # 省略時: 認可エンドポイント未設定
  #   authorization_endpoint = "https://issuer.example.com/oauth2/authorize"
  #
  #   # 設定内容: OIDCプロバイダーのトークンエンドポイントURL
  #   # 設定可能な値: HTTPS URL
  #   # 省略時: トークンエンドポイント未設定
  #   token_endpoint = "https://issuer.example.com/oauth2/token"
  #
  #   # 設定内容: OIDCプロバイダーのユーザー情報エンドポイントURL
  #   # 設定可能な値: HTTPS URL
  #   # 省略時: ユーザー情報エンドポイント未設定
  #   user_info_endpoint = "https://issuer.example.com/oauth2/userinfo"
  #
  #   # 設定内容: パブリック署名キーのエンドポイントURL（JWKSエンドポイント）
  #   # 設定可能な値: HTTPS URL
  #   # 省略時: 署名キーエンドポイント未設定
  #   public_signing_key_endpoint = "https://issuer.example.com/.well-known/jwks.json"
  #
  #   # 設定内容: OIDCクライアントID
  #   # 設定可能な値: 任意の文字列
  #   # 省略時: クライアントID未設定
  #   client_id = "example-client-id"
  #
  #   # 設定内容: OIDCクライアントシークレット（機密情報）
  #   # 設定可能な値: 任意の文字列
  #   # 省略時: 必須項目のため省略不可
  #   client_secret = "example-client-secret"
  #
  #   # 設定内容: OIDCスコープ（要求するクレームの範囲）
  #   # 設定可能な値: スペース区切りのスコープ文字列（例: "openid email profile"）
  #   # 省略時: スコープ未設定
  #   scope = "openid email profile"
  # }

  #-----------------------------------------------------------------------
  # 暗号化設定
  #-----------------------------------------------------------------------

  # 設定内容: サーバーサイド暗号化（SSE）の設定
  # 省略時: SSE設定なし（デフォルト暗号化が使用される）
  # sse_specification {
  #   # 設定内容: カスタマーマネージドキー（CMK）による暗号化を有効にするかどうか
  #   # 設定可能な値: true / false
  #   # 省略時: false（CMK暗号化無効）
  #   customer_managed_key_enabled = true
  #
  #   # 設定内容: 暗号化に使用するKMSキーのARN
  #   # 設定可能な値: KMSキーARN（例: "arn:aws:kms:us-east-1:123456789012:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"）
  #   # 省略時: AWSマネージドキーが使用される
  #   kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  # }

  #-----------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------

  # 設定内容: リソース操作のタイムアウト設定
  # 省略時: デフォルトのタイムアウト値が使用される
  # timeouts {
  #   # 設定内容: リソース作成のタイムアウト時間
  #   # 設定可能な値: "30m"、"1h" などの時間文字列
  #   # 省略時: デフォルトのタイムアウト値
  #   create = "30m"
  #
  #   # 設定内容: リソース更新のタイムアウト時間
  #   # 設定可能な値: "30m"、"1h" などの時間文字列
  #   # 省略時: デフォルトのタイムアウト値
  #   update = "30m"
  #
  #   # 設定内容: リソース削除のタイムアウト時間
  #   # 設定可能な値: "30m"、"1h" などの時間文字列
  #   # 省略時: デフォルトのタイムアウト値
  #   delete = "30m"
  # }

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------

  # 設定内容: リソースに付与するタグのマップ
  # 設定可能な値: キーと値のペア（例: { Name = "example" }）
  # 省略時: タグなし
  tags = {
    Name = "example"
  }
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
#
# id - 信頼プロバイダーのID
# tags_all - プロバイダーレベルのdefault_tagsを含む全タグのマップ
#-----------------------------------------------------------------------
