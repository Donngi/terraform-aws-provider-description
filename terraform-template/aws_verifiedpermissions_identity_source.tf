#---------------------------------------------------------------
# Amazon Verified Permissions Identity Source
#---------------------------------------------------------------
#
# Amazon Verified Permissions のアイデンティティソース（ID プロバイダー）を作成します。
# Amazon Cognito ユーザープールまたは OpenID Connect (OIDC) プロバイダーを
# アイデンティティソースとして設定し、認証されたユーザー情報を
# Verified Permissions のポリシー評価で使用できるようにします。
#
# AWS公式ドキュメント:
#   - Secure your applications with identity sources and tokens: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/identity-sources.html
#   - CreateIdentitySource API: https://docs.aws.amazon.com/verifiedpermissions/latest/apireference/API_CreateIdentitySource.html
#   - Working with Amazon Cognito identity sources: https://docs.aws.amazon.com/verifiedpermissions/latest/userguide/identity-sources-cognito.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/verifiedpermissions_identity_source
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_verifiedpermissions_identity_source" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (Required) アイデンティティソースを保存するポリシーストアの ID
  # Verified Permissions のポリシーストア ID を指定します
  policy_store_id = "PSEXAMPLEabcdefg111111"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # (Optional) プリンシパル（主体）のエンティティタイプ
  # ポリシーで使用するプリンシパルのエンティティタイプを指定します
  # 例: "MyCorp::User", "MyApp::Employee"
  # 指定しない場合、デフォルト値が使用されます
  principal_entity_type = null

  # (Optional) このリソースを管理するAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  region = null

  #---------------------------------------------------------------
  # configuration ブロック
  # アイデンティティソースの設定（Cognito または OIDC）
  # cognito_user_pool_configuration または open_id_connect_configuration のいずれか一方を指定します
  #---------------------------------------------------------------

  configuration {

    #---------------------------------------------------------------
    # cognito_user_pool_configuration ブロック
    # Amazon Cognito ユーザープールをアイデンティティソースとして使用する場合の設定
    #---------------------------------------------------------------

    cognito_user_pool_configuration {

      # (Required) Amazon Cognito ユーザープールの ARN
      # 認証に使用する Cognito ユーザープールの ARN を指定します
      user_pool_arn = "arn:aws:cognito-idp:us-east-1:123456789012:userpool/us-east-1_EXAMPLE"

      # (Optional) 関連付けるクライアント ID のリスト
      # Cognito ユーザープールに関連付けられたアプリクライアント ID のリストです
      # 指定すると、これらのクライアント ID からのトークンのみが受け入れられます
      client_ids = null

      #---------------------------------------------------------------
      # group_configuration ブロック (Optional)
      # Cognito ユーザープールのグループをエンティティタイプにマッピングする設定
      #---------------------------------------------------------------

      # group_configuration {
      #
      #   # (Required) グループにマッピングするエンティティタイプ名
      #   # Cognito ユーザープールのグループにマッピングするスキーマエンティティタイプです
      #   # デフォルトは "AWS::CognitoGroup"
      #   # 例: "MyCorp::UserGroup"
      #   group_entity_type = "AWS::CognitoGroup"
      # }
    }

    #---------------------------------------------------------------
    # open_id_connect_configuration ブロック
    # OpenID Connect (OIDC) プロバイダーをアイデンティティソースとして使用する場合の設定
    #---------------------------------------------------------------

    # open_id_connect_configuration {
    #
    #   # (Required) OIDC アイデンティティプロバイダーの Issuer URL
    #   # この URL は .well-known/openid-configuration パスに OIDC ディスカバリエンドポイントが必要です
    #   # 例: "https://auth.example.com"
    #   issuer = "https://auth.example.com"
    #
    #   # (Optional) ユーザーエンティティに付加するプレフィックス
    #   # OIDC プロバイダーからのユーザーエンティティに付けるプレフィックスです
    #   # 例: "MyOIDCProvider"
    #   entity_id_prefix = null
    #
    #   #---------------------------------------------------------------
    #   # token_selection ブロック (Required)
    #   # OIDC プロバイダーから処理するトークンタイプの選択
    #   # access_token_only または identity_token_only のいずれか一方を指定します
    #   #---------------------------------------------------------------
    #
    #   token_selection {
    #
    #     #---------------------------------------------------------------
    #     # access_token_only ブロック (Optional)
    #     # アクセストークンを処理する OIDC 設定
    #     #---------------------------------------------------------------
    #
    #     access_token_only {
    #
    #       # (Optional) 受け入れるアクセストークンの aud クレーム値
    #       # ポリシーストアで受け入れるアクセストークンの audience クレーム値のリストです
    #       # 例: ["https://myapp.example.com"]
    #       audiences = null
    #
    #       # (Optional) プリンシパルを決定するクレーム
    #       # OIDC アクセストークン内でプリンシパルを決定するクレームです
    #       # 例: "sub", "username"
    #       principal_id_claim = null
    #     }
    #
    #     #---------------------------------------------------------------
    #     # identity_token_only ブロック (Optional)
    #     # ID トークンを処理する OIDC 設定
    #     #---------------------------------------------------------------
    #
    #     # identity_token_only {
    #     #
    #     #   # (Optional) 受け入れる ID トークンのクライアント ID のリスト
    #     #   # ポリシーストアで受け入れる ID トークンの audience (client ID) クレーム値のリストです
    #     #   client_ids = null
    #     #
    #     #   # (Optional) プリンシパルを決定するクレーム
    #     #   # OIDC ID トークン内でプリンシパルを決定するクレームです
    #     #   # 例: "sub", "email"
    #     #   principal_id_claim = null
    #     # }
    #   }
    #
    #   #---------------------------------------------------------------
    #   # group_configuration ブロック (Optional)
    #   # OIDC プロバイダーのグループをエンティティタイプにマッピングする設定
    #   #---------------------------------------------------------------
    #
    #   # group_configuration {
    #   #
    #   #   # (Required) グループメンバーシップとして解釈するトークンクレーム
    #   #   # Verified Permissions がグループメンバーシップとして解釈するクレームです
    #   #   # 例: "groups"
    #   #   group_claim = "groups"
    #   #
    #   #   # (Required) グループクレームにマッピングするエンティティタイプ
    #   #   # ユーザーのグループクレームにマッピングするポリシーストアのエンティティタイプです
    #   #   # グループエンティティタイプはユーザーエンティティタイプをメンバーとして持つことができます
    #   #   # 例: "MyCorp::UserGroup"
    #   #   group_entity_type = "MyCorp::UserGroup"
    #   # }
    # }
  }

  #---------------------------------------------------------------
  # 注意事項:
  # - configuration ブロック内では cognito_user_pool_configuration または
  #   open_id_connect_configuration のいずれか一方のみを指定してください
  # - token_selection ブロック内では access_token_only または
  #   identity_token_only のいずれか一方のみを指定してください
  # - トークンの有効期限が切れるまでユーザーは有効であり、取り消しやリソース削除は
  #   トークンの有効性に影響しません
  # - セキュリティのため、トークンの有効期限は可能な限り短く設定することを推奨します
  #---------------------------------------------------------------
}

#---------------------------------------------------------------
# Attributes Reference
# このリソースが提供する読み取り専用の属性
#---------------------------------------------------------------
#
# 以下の属性がエクスポートされます（参照のみ可能）:
#
# - id: アイデンティティソースの ID
#
#---------------------------------------------------------------
