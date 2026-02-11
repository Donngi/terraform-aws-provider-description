#---------------------------------------------------------------
# AWS SSO Admin Trusted Token Issuer
#---------------------------------------------------------------
#
# AWS IAM Identity Center（旧AWS SSO）の信頼されたトークン発行者（Trusted Token Issuer）を
# プロビジョニングするリソースです。
# 信頼されたトークン発行者は、外部のOAuth 2.0認可サーバーがトークンを発行し、
# AWSサービスへのアクセスを信頼されたID伝播（Trusted Identity Propagation）を通じて
# 可能にする仕組みです。
#
# AWS公式ドキュメント:
#   - 信頼されたトークン発行者の設定: https://docs.aws.amazon.com/singlesignon/latest/userguide/setuptrustedtokenissuer.html
#   - 信頼されたトークン発行者の構成設定: https://docs.aws.amazon.com/singlesignon/latest/userguide/trusted-token-issuer-configuration-settings.html
#   - 信頼されたトークン発行者を使用するアプリケーション: https://docs.aws.amazon.com/singlesignon/latest/userguide/using-apps-with-trusted-token-issuer.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_trusted_token_issuer
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_trusted_token_issuer" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 信頼されたトークン発行者の名前を指定します。
  # 設定可能な値: 文字列
  name = "example-trusted-token-issuer"

  # instance_arn (Required)
  # 設定内容: IAM Identity CenterインスタンスのARNを指定します。
  # 設定可能な値: 有効なIAM Identity CenterインスタンスARN
  # 参考: data.aws_ssoadmin_instances を使用して取得可能
  instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]

  # trusted_token_issuer_type (Required)
  # 設定内容: 信頼されたトークン発行者のタイプを指定します。
  # 設定可能な値:
  #   - "OIDC_JWT": OpenID Connect (OIDC) とJSON Web Token (JWT) を使用するトークン発行者
  trusted_token_issuer_type = "OIDC_JWT"

  #-------------------------------------------------------------
  # トークン発行者設定
  #-------------------------------------------------------------

  # trusted_token_issuer_configuration (Required)
  # 設定内容: 信頼されたトークン発行者に適用する設定を指定します。
  # 注意: trusted_token_issuer_type で指定したタイプに応じた設定ブロックを含めます。
  trusted_token_issuer_configuration {

    # oidc_jwt_configuration (Optional)
    # 設定内容: OpenID Connect (OIDC) とJSON Web Token (JWT) を使用する
    #           信頼されたトークン発行者の設定を指定します。
    # 関連機能: OIDC JWT トークン発行者
    #   IAM Identity Centerは、RS256アルゴリズムで署名されたJWT形式のトークンを
    #   使用する信頼されたトークン発行者をサポートします。
    #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/using-apps-with-trusted-token-issuer.html
    oidc_jwt_configuration {

      # claim_attribute_path (Required)
      # 設定内容: 信頼されたトークン発行者からのJWT内のソース属性のパスを指定します。
      # 設定可能な値: JMESPath式（1-255文字）
      # 注意: この式で指定された属性は、identity_store_attribute_path で指定された属性と
      #       比較され、トークン交換時にユーザーを照合します。
      # 参考: https://docs.aws.amazon.com/singlesignon/latest/APIReference/API_OidcJwtConfiguration.html
      claim_attribute_path = "email"

      # identity_store_attribute_path (Required)
      # 設定内容: IAM Identity CenterのJWT内の宛先属性のパスを指定します。
      # 設定可能な値: JMESPath式（1-255文字）
      #   - "emails.value": メールアドレスで照合
      #   - "userName": ユーザー名で照合
      #   - "externalId": 外部IDで照合
      # 注意: claim_attribute_path で指定された属性と比較してユーザーを照合します。
      # 参考: https://docs.aws.amazon.com/singlesignon/latest/userguide/trusted-token-issuer-configuration-settings.html
      identity_store_attribute_path = "emails.value"

      # issuer_url (Required)
      # 設定内容: IAM Identity CenterがOpenID Discoveryに使用するURLを指定します。
      # 設定可能な値: URL文字列（1-255文字）
      # 注意: OpenID Discoveryは、信頼されたトークン発行者が生成したトークンを
      #       検証するために必要な情報を取得するために使用されます。
      #       URLはポート80および443で到達可能である必要があり、
      #       ".well-known/openid-configuration" サフィックスを含めてはいけません。
      # 参考: https://docs.aws.amazon.com/singlesignon/latest/userguide/trusted-token-issuer-configuration-settings.html
      issuer_url = "https://example.com"

      # jwks_retrieval_option (Required)
      # 設定内容: 信頼されたトークン発行者がJWTの検証に使用するJSON Web Key Setを
      #           取得する方法を指定します。
      # 設定可能な値:
      #   - "OPEN_ID_DISCOVERY": OpenID Discoveryを使用してJWKSを取得
      jwks_retrieval_option = "OPEN_ID_DISCOVERY"
    }
  }

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
  # 冪等性設定
  #-------------------------------------------------------------

  # client_token (Optional)
  # 設定内容: リクエストの冪等性を保証するための一意のケースセンシティブなIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: AWSがランダムな値を生成します。
  client_token = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-trusted-token-issuer"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 信頼されたトークン発行者のAmazon Resource Name (ARN)
#
# - id: 信頼されたトークン発行者のARN
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
