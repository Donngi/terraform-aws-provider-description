#---------------------------------------------------------------
# AWS Cognito Identity Provider
#---------------------------------------------------------------
#
# Amazon Cognito ユーザープールに外部 ID プロバイダーを統合するリソースです。
# SAML、OIDC、Facebook、Google、Amazon、Apple などの外部 ID プロバイダーと
# Cognito ユーザープールを連携させることができます。
# ユーザーは外部 ID プロバイダーで認証後、Cognito ユーザープールに
# マッピングされます。
#
# AWS公式ドキュメント:
#   - Cognito ID プロバイダー概要: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-identity-provider.html
#   - SAML プロバイダー: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-saml-idp.html
#   - OIDC プロバイダー: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-oidc-idp.html
#   - ソーシャルログイン: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-social-idp.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_provider
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cognito_identity_provider" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # user_pool_id (Required)
  # 設定内容: ID プロバイダーを追加する Cognito ユーザープールの ID を指定します。
  # 設定可能な値: 有効な Cognito ユーザープール ID（例: us-east-1_XXXXXXXXX）
  # 関連機能: Cognito ユーザープール
  #   ユーザープールは、ユーザーディレクトリとして機能します。
  #   - https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-identity-pools.html
  user_pool_id = "us-east-1_XXXXXXXXX"

  # provider_name (Required)
  # 設定内容: ID プロバイダーの名前を指定します。
  # 設定可能な値: プロバイダーを識別する一意の名前（32文字以内、英数字とアンダースコアのみ）
  # 注意: 一部のプロバイダータイプでは予約名が使用されます
  #   - Facebook: "Facebook"
  #   - Google: "Google"
  #   - LoginWithAmazon: "LoginWithAmazon"
  #   - SignInWithApple: "SignInWithApple"
  provider_name = "ExampleProvider"

  # provider_type (Required)
  # 設定内容: ID プロバイダーのタイプを指定します。
  # 設定可能な値:
  #   - "SAML": SAML 2.0 ベースの ID プロバイダー
  #   - "Facebook": Facebook ソーシャルログイン
  #   - "Google": Google ソーシャルログイン
  #   - "LoginWithAmazon": Amazon ソーシャルログイン
  #   - "SignInWithApple": Apple でサインイン
  #   - "OIDC": OpenID Connect プロバイダー
  # 関連機能: 各プロバイダータイプには異なる設定が必要です
  #   - https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-identity-provider.html
  provider_type = "SAML"

  # provider_details (Required)
  # 設定内容: プロバイダータイプに応じた固有の詳細設定を指定します。
  # 設定可能な値: プロバイダータイプごとに異なるキーと値のマップ
  #   - SAML: {"MetadataURL" = "https://..." または "MetadataFile" = "..."}
  #   - OIDC: {
  #       "client_id" = "クライアント ID",
  #       "client_secret" = "クライアントシークレット",
  #       "attributes_request_method" = "GET" or "POST",
  #       "oidc_issuer" = "https://...",
  #       "authorize_scopes" = "openid profile email"
  #     }
  #   - Facebook/Google/LoginWithAmazon/SignInWithApple: {
  #       "client_id" = "クライアント ID",
  #       "client_secret" = "クライアントシークレット",
  #       "authorize_scopes" = "email profile"
  #     }
  # 関連機能: プロバイダー固有の設定
  #   各プロバイダーには異なるメタデータや認証情報が必要です。
  #   - https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-identity-provider.html
  provider_details = {
    MetadataURL = "https://example.com/saml/metadata"
  }

  #-------------------------------------------------------------
  # 属性マッピング設定
  #-------------------------------------------------------------

  # attribute_mapping (Optional)
  # 設定内容: 外部プロバイダーの属性と Cognito ユーザー属性のマッピングを指定します。
  # 設定可能な値: マップ形式
  #   - キー: Cognito ユーザープール属性名（例: email, name, given_name, family_name, custom:attribute_name）
  #   - 値: 外部プロバイダーの属性名
  #     - SAML: クレーム URI（例: http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress）
  #     - OIDC/ソーシャル: 属性名（例: email, name）
  # 省略時: マッピングなし（外部属性が Cognito 属性に自動マッピングされない）
  # 注意: username 属性は必須です
  # 関連機能: 属性マッピング
  #   外部プロバイダーの属性を Cognito ユーザープール属性にマッピングします。
  #   - https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-specifying-attribute-mapping.html
  attribute_mapping = {
    email      = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
    username   = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
    given_name = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
  }

  #-------------------------------------------------------------
  # ID プロバイダー識別子設定
  #-------------------------------------------------------------

  # idp_identifiers (Optional)
  # 設定内容: プロバイダー識別子のリストを指定します。
  # 設定可能な値: 文字列のリスト（最大50個、各識別子は1〜40文字）
  # 省略時: 識別子なし
  # 関連機能: SAML Entity ID
  #   SAML プロバイダーの Entity ID など、プロバイダーを識別する追加の識別子を設定できます。
  #   - https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-saml-idp.html
  idp_identifiers = [
    "urn:example:provider:entity-id"
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Attributes Reference（読み取り専用属性）
  #-------------------------------------------------------------
  # id - リソース ID（形式: user_pool_id:provider_name）
}
