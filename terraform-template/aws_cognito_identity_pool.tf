# Terraform リソース定義: aws_cognito_identity_pool
# 資料: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cognito_identity_pool
# Provider Version: 6.28.0
# Generated: 2026-02-13
# 目的: Amazon Cognito Identity Pool（IDプール）を作成・管理
# 説明: Web/モバイルアプリのユーザーに対して、一時的なAWS認証情報を発行するためのIDプールを定義します
#       認証済み/未認証ユーザーの両方に対応可能で、複数の認証プロバイダー（Cognito User Pool、SAML、OpenID Connect、ソーシャルログイン等）を統合できます
# NOTE: IDプールは認証情報の発行のみを担当します。実際のユーザー認証はCognito User Poolや外部IDプロバイダーで行います

resource "aws_cognito_identity_pool" "example" {
  #---------------------------------------
  # 必須設定
  #---------------------------------------
  # 設定内容: IDプール名
  # 設定可能な値: 128文字以内の文字列（英数字、スペース、._-が使用可能）
  identity_pool_name = "example_identity_pool"

  #---------------------------------------
  # 認証設定
  #---------------------------------------
  # 設定内容: 未認証ユーザーのIDプール利用を許可するかどうか
  # 設定可能な値: true（許可）, false（不許可）
  # 省略時: false（未認証アクセスは許可されない）
  allow_unauthenticated_identities = false

  # 設定内容: Classic（基本）フローの有効化
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: false（拡張フローのみ使用）
  # 補足: 後方互換性のため、古いSDKとの統合に必要な場合に有効化
  allow_classic_flow = false

  #---------------------------------------
  # 外部認証プロバイダー統合
  #---------------------------------------
  # 設定内容: ソーシャルログインプロバイダーとアプリIDのマッピング
  # 設定可能な値: プロバイダードメイン（例: accounts.google.com, graph.facebook.com, www.amazon.com）をキー、アプリIDを値とするマップ
  # 省略時: ソーシャルログインプロバイダーを使用しない
  supported_login_providers = {
    # "accounts.google.com"   = "123456789012.apps.googleusercontent.com"
    # "graph.facebook.com"    = "1234567890123456"
    # "www.amazon.com"        = "amzn1.application.1234567890abcdef"
    # "api.twitter.com"       = "twitter_app_id"
  }

  # 設定内容: OpenID Connect（OIDC）プロバイダーのARNリスト
  # 設定可能な値: OIDCプロバイダーのARN配列（例: arn:aws:iam::123456789012:oidc-provider/oidc.example.com）
  # 省略時: OIDCプロバイダーを使用しない
  openid_connect_provider_arns = [
    # "arn:aws:iam::123456789012:oidc-provider/oidc.example.com",
  ]

  # 設定内容: SAMLプロバイダーのARNリスト
  # 設定可能な値: SAMLプロバイダーのARN配列（例: arn:aws:iam::123456789012:saml-provider/ExampleProvider）
  # 省略時: SAMLプロバイダーを使用しない
  saml_provider_arns = [
    # "arn:aws:iam::123456789012:saml-provider/ExampleProvider",
  ]

  #---------------------------------------
  # 開発者認証プロバイダー
  #---------------------------------------
  # 設定内容: 開発者認証IDプロバイダー名
  # 設定可能な値: 1-128文字の文字列（英数字、._-=のみ使用可能）
  # 省略時: 開発者認証プロバイダーを使用しない
  # 補足: カスタム認証バックエンドを構築する場合に指定（通常は不要）
  developer_provider_name = "login.example.com"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "ap-northeast-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キー・バリューペアのマップ（キー・バリューともに256文字以内）
  # 省略時: タグを設定しない
  tags = {
    Name        = "example-identity-pool"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #---------------------------------------
  # Cognito User Pool統合
  #---------------------------------------
  # 設定内容: Cognito User Pool認証プロバイダーの設定
  # 補足: 複数のUser Poolを認証プロバイダーとして登録可能
  cognito_identity_providers {
    # 設定内容: Cognito User PoolのクライアントID
    # 設定可能な値: User Poolアプリクライアントの26文字の英数字ID
    # 省略時: クライアントIDを指定しない（provider_nameのみで識別）
    client_id = "7lhlkkfbfb4q5kpp90urffao"

    # 設定内容: Cognito User Poolのプロバイダー名
    # 設定可能な値: "cognito-idp.{region}.amazonaws.com/{user_pool_id}" 形式の文字列
    # 省略時: プロバイダー名を指定しない（client_idのみで識別）
    provider_name = "cognito-idp.ap-northeast-1.amazonaws.com/ap-northeast-1_Zr7BZao8r"

    # 設定内容: サーバーサイドトークン検証の有効化
    # 設定可能な値: true（有効）, false（無効）
    # 省略時: false（トークン検証を行わない）
    # 補足: trueに設定すると、IDプールがトークンの有効性を検証（セキュリティ強化、パフォーマンスに影響）
    server_side_token_check = false
  }

  # 複数のUser Poolを統合する場合の例
  # cognito_identity_providers {
  #   client_id               = "another_client_id"
  #   provider_name           = "cognito-idp.us-west-2.amazonaws.com/us-west-2_XXXXXXXXX"
  #   server_side_token_check = true
  # }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# 生成後に参照可能な属性:
# - id: IDプールID（例: ap-northeast-1:12345678-1234-1234-1234-123456789012）
# - arn: IDプールのARN（例: arn:aws:cognito-identity:ap-northeast-1:123456789012:identitypool/ap-northeast-1:12345678-1234-1234-1234-123456789012）
# - tags_all: 全てのタグ（デフォルトタグ含む）

# 参照例:
# output "identity_pool_id" {
#   value = aws_cognito_identity_pool.example.id
# }
