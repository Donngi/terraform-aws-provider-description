#---------------------------------------------------------------
# AWS SSO Admin Trusted Token Issuer
#---------------------------------------------------------------
#
# AWS IAM Identity Center（旧 AWS SSO）の信頼済みトークン発行者を管理するリソースです。
# 信頼済みトークン発行者とは、IAM Identity Center の外部で認証を行うアプリケーションが
# AWS サービスにアクセスするために使用する OAuth 2.0 認可サーバーです。
# 外部 IdP が発行した JWT トークンを IAM Identity Center のトークンと交換することで、
# アプリケーションが IAM Identity Center のユーザー情報を使ってアクセス制御を行えます。
#
# 主なユースケース:
#   - IAM Identity Center の外部 OIDC プロバイダー（例: Okta、Azure AD）の JWT を信頼する
#   - 外部 IdP で認証されたアプリケーションが AWS サービスにアクセスする際の仲介設定
#   - 信頼済みアイデンティティ伝播（Trusted Identity Propagation）の設定
#   - 最大 10 件の信頼済みトークン発行者を IAM Identity Center インスタンスに登録する
#
# 重要な注意事項:
#   - trusted_token_issuer_type は現在 "OIDC_JWT" のみサポートされています。
#   - issuer_url は `.well-known/openid-configuration` を除いたベース URL を指定します。
#     （例: "https://example.okta.com" ← 末尾に /.well-known/openid-configuration を付けない）
#   - issuer_url は変更不可の場合があるため、慎重に設定してください。
#   - claim_attribute_path と identity_store_attribute_path の組み合わせで
#     外部 IdP のユーザーと IAM Identity Center のユーザーを 1:1 でマッチングします。
#   - identity_store_attribute_path に指定できる属性は userName / email /
#     externalIds[issuer eq '<URL>'].id のいずれかです（ユーザーごとに一意である必要があります）。
#
# AWS公式ドキュメント:
#   - 信頼済みトークン発行者の設定:
#       https://docs.aws.amazon.com/singlesignon/latest/userguide/setuptrustedtokenissuer.html
#   - 信頼済みトークン発行者の設定項目:
#       https://docs.aws.amazon.com/singlesignon/latest/userguide/trusted-token-issuer-configuration-settings.html
#   - 信頼済みトークン発行者を使ったアプリケーション:
#       https://docs.aws.amazon.com/singlesignon/latest/userguide/using-apps-with-trusted-token-issuer.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ssoadmin_trusted_token_issuer
#
# Provider Version: 6.28.0
# Generated: 2026-02-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_trusted_token_issuer" "example" {
  #---------------------------------------------------------------
  # SSO インスタンス設定
  #---------------------------------------------------------------

  # instance_arn (Required)
  # 設定内容: 信頼済みトークン発行者を登録する IAM Identity Center インスタンスの ARN を指定します。
  # 設定可能な値: IAM Identity Center インスタンスの ARN 文字列
  # 省略時: 設定必須
  #
  # 取得方法: data "aws_ssoadmin_instances" を使用して ARN を取得できます。
  #   例: tolist(data.aws_ssoadmin_instances.example.arns)[0]
  instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef"

  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # name (Required)
  # 設定内容: 信頼済みトークン発行者の名前を指定します。
  # 設定可能な値: 英数字・+、=、.、,、@、- を含む 1〜255 文字の文字列
  # 省略時: 設定必須
  name = "example-trusted-token-issuer"

  # trusted_token_issuer_type (Required)
  # 設定内容: 信頼済みトークン発行者のタイプを指定します。
  #           現在サポートされているタイプは OIDC_JWT のみです。
  # 設定可能な値: "OIDC_JWT"
  # 省略時: 設定必須
  trusted_token_issuer_type = "OIDC_JWT"

  #---------------------------------------------------------------
  # 信頼済みトークン発行者の詳細設定
  #---------------------------------------------------------------

  trusted_token_issuer_configuration {
    #---------------------------------------------------------------
    # OIDC JWT 設定
    #---------------------------------------------------------------

    oidc_jwt_configuration {
      # claim_attribute_path (Required)
      # 設定内容: 信頼済みトークン発行者が発行する JWT クレーム内の属性パスを指定します。
      #           IAM Identity Center はここで指定したパスの値を使って、
      #           identity_store_attribute_path で指定した IAM Identity Center 側の属性と照合します。
      #           JMESPath 形式で記述します。
      # 設定可能な値: 1〜255 文字のパス文字列（例: "email" / "sub" / "custom_claim"）
      # 省略時: 設定必須
      claim_attribute_path = "email"

      # identity_store_attribute_path (Required)
      # 設定内容: IAM Identity Center の Identity Store 内のユーザー属性パスを指定します。
      #           claim_attribute_path の値と照合して、対応するユーザーを特定します。
      #           JMESPath 形式で記述します。指定する属性の値はユーザーごとに一意である必要があります。
      # 設定可能な値: 以下のいずれかのパス文字列（1〜255 文字）
      #               "userName"
      #               "emails[primary eq true].value"（プライマリメールアドレス）
      #               "externalIds[issuer eq '<IssuerURL>'].id"（外部 ID）
      # 省略時: 設定必須
      identity_store_attribute_path = "emails[primary eq true].value"

      # issuer_url (Required)
      # 設定内容: 外部 OIDC プロバイダー（信頼済みトークン発行者）の発行者 URL を指定します。
      #           IAM Identity Center はこの URL を使って OpenID Connect Discovery ドキュメントを取得し、
      #           トークンの検証に必要な情報を入手します。
      #           URL の末尾に "/.well-known/openid-configuration" を含めないでください。
      #           ポート 80 および 443 でアクセス可能な URL である必要があります。
      # 設定可能な値: HTTPS 形式の URL 文字列（1〜255 文字）
      #               例: "https://example.okta.com" / "https://login.microsoftonline.com/<tenant-id>/v2.0"
      # 省略時: 設定必須
      issuer_url = "https://example.okta.com"

      # jwks_retrieval_option (Required)
      # 設定内容: OIDC プロバイダーから JWKS（JSON Web Key Set）を取得する方法を指定します。
      #           JWKS は JWT の署名検証に使用される公開鍵の集合です。
      # 設定可能な値: "OPEN_ID_DISCOVERY"（OpenID Connect Discovery ドキュメントから自動取得）
      # 省略時: 設定必須
      jwks_retrieval_option = "OPEN_ID_DISCOVERY"
    }
  }

  #---------------------------------------------------------------
  # クライアントトークン設定
  #---------------------------------------------------------------

  # client_token (Optional)
  # 設定内容: リクエストの冪等性を確保するためのクライアントトークンを指定します。
  #           同一トークンで複数回リクエストを送信しても、同じリソースが作成されます。
  # 設定可能な値: 任意の文字列
  # 省略時: 省略可能（冪等性が不要な場合は省略できます）
  # client_token = null

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: AWS リージョンコード文字列（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンが使用されます
  # region = null

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグのマップを指定します。
  # 設定可能な値: キーと値が文字列のマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-trusted-token-issuer"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id
#     信頼済みトークン発行者の ARN。
#
# - arn
#     信頼済みトークン発行者の ARN。
#     例: "arn:aws:sso:::trustedTokenIssuer/ssoins-1234567890abcdef/tti-1234567890abcdef"
#
# - tags_all
#     プロバイダーの default_tags と tags を統合したタグのマップ。
#
