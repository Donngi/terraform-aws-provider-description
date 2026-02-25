#---------------------------------------------------------------
# AWS WorkSpaces Web Identity Provider（アイデンティティプロバイダー）
#---------------------------------------------------------------
#
# AWS WorkSpaces Web のアイデンティティプロバイダーを管理するリソースです。
# SAML 2.0、OIDC、およびソーシャルログイン（Google、Facebook、
# Login with Amazon、Sign in with Apple）に対応しており、
# WorkSpaces Web ポータルへのシングルサインオン（SSO）を実現します。
#
# AWS公式ドキュメント:
#   - WorkSpaces Web ユーザーガイド: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/what-is.html
#   - アイデンティティプロバイダー設定: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/identity-providers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_identity_provider
#
# Provider Version: 6.28.0
# Generated: 2026-02-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_identity_provider" "example" {

  #-------------------------------------------------------------
  # ポータル設定
  #-------------------------------------------------------------

  # portal_arn (Required)
  # 設定内容: アイデンティティプロバイダーを関連付ける WorkSpaces Web ポータルの ARN
  # 設定可能な値: aws_workspacesweb_portal リソースの portal_arn 属性
  # 省略時: 必須項目のため省略不可（変更時はリソースの再作成が発生）
  portal_arn = aws_workspacesweb_portal.example.portal_arn

  #-------------------------------------------------------------
  # アイデンティティプロバイダー設定
  #-------------------------------------------------------------

  # identity_provider_name (Required)
  # 設定内容: アイデンティティプロバイダーの名前
  # 設定可能な値: 任意の文字列
  # 省略時: 必須項目のため省略不可
  identity_provider_name = "example-saml"

  # identity_provider_type (Required)
  # 設定内容: アイデンティティプロバイダーの種別
  # 設定可能な値:
  #   "SAML"            - SAML 2.0 プロバイダー
  #   "OIDC"            - OpenID Connect プロバイダー
  #   "Facebook"        - Facebook ログイン
  #   "Google"          - Google ログイン
  #   "LoginWithAmazon" - Amazon でログイン
  #   "SignInWithApple" - Apple でサインイン
  # 省略時: 必須項目のため省略不可
  identity_provider_type = "SAML"

  # identity_provider_details (Required)
  # 設定内容: アイデンティティプロバイダーの詳細設定（プロバイダー種別によりキーが異なる）
  # 省略時: 必須項目のため省略不可
  #
  # --- SAML の場合 ---
  #   MetadataURL               - SAML メタデータの URL（MetadataFile と排他）
  #   MetadataFile              - SAML メタデータの XML ファイル内容（MetadataURL と排他）
  #   IDPSignout                - (省略可) IdP 起点サインアウトを有効化するか（"true"/"false"）
  #   IDPInit                   - (省略可) IdP 起点ログインを有効化するか（"true"/"false"）
  #   RequestSigningAlgorithm   - (省略可) リクエスト署名アルゴリズム（"rsa-sha256" のみ）
  #   EncryptedResponses        - (省略可) レスポンスの暗号化を要求するか（"true"/"false"）
  #
  # --- OIDC の場合 ---
  #   client_id                 - OIDC クライアント ID
  #   client_secret             - OIDC クライアントシークレット
  #   oidc_issuer               - OIDC イシュアー URL（ディスカバリードキュメント取得に使用）
  #   attributes_request_method - 属性取得メソッド（"GET" または "POST"）
  #   authorize_scopes          - 認可スコープ（カンマ区切り、例: "openid, email"）
  #   authorize_url             - (省略可) 認可エンドポイント URL（oidc_issuer から取得不可の場合）
  #   token_url                 - (省略可) トークンエンドポイント URL（oidc_issuer から取得不可の場合）
  #   attributes_url            - (省略可) 属性エンドポイント URL（oidc_issuer から取得不可の場合）
  #   jwks_uri                  - (省略可) JWKS URI（oidc_issuer から取得不可の場合）
  #
  # --- Google / LoginWithAmazon の場合 ---
  #   client_id                 - OAuth クライアント ID
  #   client_secret             - OAuth クライアントシークレット
  #   authorize_scopes          - 認可スコープ
  #
  # --- Facebook の場合 ---
  #   client_id                 - Facebook アプリ ID
  #   client_secret             - Facebook アプリシークレット
  #   authorize_scopes          - 認可スコープ
  #   api_version               - Facebook API バージョン（例: "v17.0"）
  #
  # --- SignInWithApple の場合 ---
  #   client_id                 - Apple サービス ID
  #   team_id                   - Apple チーム ID
  #   key_id                    - Apple 秘密鍵 ID
  #   private_key               - Apple 秘密鍵の内容
  #   authorize_scopes          - 認可スコープ
  identity_provider_details = {
    MetadataURL = "https://example.com/metadata"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: "ap-northeast-1", "us-east-1"）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグのマップ
  # 設定可能な値: キーと値の文字列マップ
  # 省略時: タグなし（プロバイダーの default_tags が設定されている場合はそれを継承）
  tags = {
    Name = "example-identity-provider"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# identity_provider_arn - アイデンティティプロバイダーの ARN
# tags_all              - プロバイダーの default_tags を含む全タグのマップ
