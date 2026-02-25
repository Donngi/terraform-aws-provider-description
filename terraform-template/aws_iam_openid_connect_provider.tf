#---------------------------------------------------------------
# AWS IAM OpenID Connect Provider
#---------------------------------------------------------------
#
# IAM OpenID Connect (OIDC) プロバイダーをプロビジョニングするリソースです。
# IAM OIDCプロバイダーは、OpenID Connect標準をサポートする外部アイデンティティ
# プロバイダー (IdP) との信頼関係を確立するために使用されます。
# Google、GitHub、Auth0 等の外部IdPや Amazon EKS のサービスアカウント連携
# (IRSA) に活用されます。
#
# AWS公式ドキュメント:
#   - IAM OIDC IDプロバイダーの作成: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html
#   - CreateOpenIDConnectProvider API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateOpenIDConnectProvider.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # url (Required, Forces new resource)
  # 設定内容: OIDCアイデンティティプロバイダーのURLを指定します。
  #           ロールの信頼ポリシーにおける `iss` クレームの値に対応します。
  # 設定可能な値: `https://` で始まるOIDCプロバイダーのURL。最大255文字。
  #              各AWSアカウントで一意である必要があります。
  # 注意: このURLはリソース作成後に変更できません（変更時は再作成が必要）。
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html
  url = "https://accounts.google.com"

  # client_id_list (Required)
  # 設定内容: OIDCプロバイダーに登録されたクライアントIDのリストを指定します。
  #           OAuthリクエストの `client_id` パラメーターとして送信される値（オーディエンス）です。
  # 設定可能な値: 文字列のセット。各クライアントIDは最大255文字。
  # 参考: https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateOpenIDConnectProvider.html
  client_id_list = [
    "sts.amazonaws.com",
  ]

  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # thumbprint_list (Optional)
  # 設定内容: OIDCアイデンティティプロバイダーのサーバー証明書サムプリントのリストを指定します。
  # 設定可能な値: 40桁の16進数文字列のリスト（SHA-1サムプリント）。最大5件。
  # 省略時: IAMがOIDC IdPサーバー証明書から上位中間CA証明書のサムプリントを
  #         自動的に取得して使用します。
  # 注意: Auth0、GitHub、GitLab、Google、またはAmazon S3ホスト型JWKSエンドポイントを
  #       使用するOIDC IdPの場合、AWSは信頼済みルートCA証明書の独自ライブラリを
  #       使用して検証するため、設定されたサムプリントリストは保持されますが検証には
  #       使用されません。
  #       thumbprint_listを初期設定後に削除した場合、Terraformはサムプリントを
  #       再取得せず、初期設定のサムプリントリストを引き続き使用します。
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html
  thumbprint_list = ["cf23df2207d99a74fbe169e3eba035e633b65d94"]

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-oidc-provider"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AWSが割り当てたOIDCプロバイダーのARN
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
