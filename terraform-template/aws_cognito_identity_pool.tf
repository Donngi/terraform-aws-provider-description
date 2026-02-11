#---------------------------------------------------------------
# AWS Cognito Identity Pool
#---------------------------------------------------------------
#
# Amazon Cognito Identity Poolをプロビジョニングするリソースです。
# Identity Poolは、認証済みおよび未認証のユーザーに対してAWSの一時的な
# 認証情報を提供し、他のAWSサービスへのアクセスを可能にします。
# 複数の外部アイデンティティプロバイダー（Cognito User Pool、SAML、
# OpenID Connect、ソーシャルログインなど）からのIDを統合できます。
#
# AWS公式ドキュメント:
#   - Identity Pool概要: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-identity.html
#   - Identity Poolの開始方法: https://docs.aws.amazon.com/cognito/latest/developerguide/getting-started-with-identity-pools.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cognito_identity_pool" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # identity_pool_name (Required)
  # 設定内容: Identity Poolの名前を指定します。
  # 設定可能な値: 1-128文字の文字列
  # 注意: この名前はAWSアカウント内で一意である必要があります。
  identity_pool_name = "my_identity_pool"

  # allow_unauthenticated_identities (Optional)
  # 設定内容: 未認証のユーザーに対してアクセスを許可するかを指定します。
  # 設定可能な値:
  #   - true: 未認証ユーザーにもIdentity Poolへのアクセスを許可
  #   - false (デフォルト): 認証済みユーザーのみアクセス可能
  # 関連機能: 未認証アクセス
  #   未認証ユーザーに一時的なAWS認証情報を発行し、制限されたリソースへの
  #   アクセスを可能にします。ゲストアクセスやパブリックコンテンツの
  #   配信などに使用されます。
  #   - https://docs.aws.amazon.com/cognito/latest/developerguide/identity-pools.html
  allow_unauthenticated_identities = false

  # allow_classic_flow (Optional)
  # 設定内容: クラシック（シンプル）認証フローを許可するかを指定します。
  # 設定可能な値:
  #   - true: クラシック認証フローを有効化
  #   - false (デフォルト): クラシック認証フローを無効化（拡張フローを使用）
  # 注意: クラシックフローは後方互換性のために提供されています。
  #       新規実装では拡張認証フロー（enhanced flow）の使用が推奨されます。
  allow_classic_flow = false

  #-------------------------------------------------------------
  # デベロッパー認証設定
  #-------------------------------------------------------------

  # developer_provider_name (Optional)
  # 設定内容: カスタムデベロッパー認証プロバイダーの名前を指定します。
  # 設定可能な値: 1-128文字の文字列（ドメイン形式推奨、例: login.mycompany.com）
  # 関連機能: デベロッパー認証ID
  #   独自の認証システムを使用してユーザーを認証し、Cognito Identity Poolと
  #   統合できます。カスタム認証バックエンドを持つ場合に使用します。
  #   - https://docs.aws.amazon.com/cognito/latest/developerguide/developer-authenticated-identities.html
  # 注意: 設定後の変更は新しいリソースの作成を強制します。
  developer_provider_name = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ソーシャルログインプロバイダー設定
  #-------------------------------------------------------------

  # supported_login_providers (Optional)
  # 設定内容: サポートするログインプロバイダーとそのアプリケーションIDのマップを指定します。
  # 設定可能な値: プロバイダードメインをキー、アプリIDを値とするマップ
  # OpenID Connectプロバイダー設定
  #-------------------------------------------------------------

  # openid_connect_provider_arns (Optional)
  # 設定内容: サポートするOpenID Connect (OIDC) プロバイダーのARNのセットを指定します。
  # 設定可能な値: IAMで作成したOIDCプロバイダーのARN文字列のセット
  # SAMLプロバイダー設定
  #-------------------------------------------------------------

  # saml_provider_arns (Optional)
  # 設定内容: サポートするSAMLプロバイダーのARNのリストを指定します。
  # 設定可能な値: IAMで作成したSAMLプロバイダーのARN文字列のリスト
  # Cognito User Poolプロバイダー設定
  #-------------------------------------------------------------

  # cognito_identity_providers (Optional)
  # 設定内容: Cognito User Poolをアイデンティティプロバイダーとして統合します。
  # 注意: 複数のCognito User Poolを統合可能です。
  # 関連機能: User Pool統合
  #   Cognito User Poolで認証されたユーザーに対して、Identity Poolを
  #   通じてAWSリソースへのアクセス権限を付与できます。
  #   - https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-identity-federation.html
  cognito_identity_providers {
    # client_id (Optional)
    # 設定内容: Cognito User PoolアプリクライアントのIDを指定します。
    # 設定可能な値: アプリクライアントID（例: 6lhlkkfbfb4q5kpp90urffae）
    # 注意: User Poolで作成したアプリクライアントのIDを指定します。
    client_id = "6lhlkkfbfb4q5kpp90urffae"

    # provider_name (Optional)
    # 設定内容: Cognito User Poolのプロバイダー名を指定します。
    # 設定可能な値: cognito-idp.<region>.amazonaws.com/<user-pool-id> の形式
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-identity-pool"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsから継承されたタグを含む、
  #           リソースに割り当てられたすべてのタグのマップ。
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動的に管理します。
  # 関連機能: デフォルトタグ
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null

  # id (Optional)
  # 設定内容: Identity PoolのID。
  # 注意: 通常は自動生成されるため、明示的に設定する必要はありません。
  #       フォーマット: us-west-2:1a234567-8901-234b-5cde-f6789g01h2i3
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Identity PoolのAmazon Resource Name (ARN)
#        フォーマット: arn:aws:cognito-identity:region:account-id:identitypool/pool-id
#
# - id: Identity PoolのID
#       フォーマット: us-west-2:1a234567-8901-234b-5cde-f6789g01h2i3
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
