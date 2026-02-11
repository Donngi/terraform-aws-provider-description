#---------------------------------------------------------------
# IAM OpenID Connect (OIDC) Provider
#---------------------------------------------------------------
#
# IAM OIDC identity providerは、OpenID Connect (OIDC) 標準をサポートする
# 外部アイデンティティプロバイダー（IdP）サービス（Google、Salesforceなど）を
# 記述するIAMのエンティティです。OIDC互換IdPとAWSアカウント間の信頼関係を
# 確立するために使用され、カスタムサインインコードの作成やユーザーIDの
# 管理なしに、モバイルアプリやWebアプリケーションがAWSリソースにアクセス
# できるようになります。
#
# AWS公式ドキュメント:
#   - Create an OpenID Connect (OIDC) identity provider in IAM:
#     https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html
#   - CreateOpenIDConnectProvider API:
#     https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateOpenIDConnectProvider.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # url - (Required) アイデンティティプロバイダーのURL（`iss`クレームに対応）
  #
  # 要件:
  # - https:// で始まる必要があります
  # - 大文字小文字を区別します
  # - ポート番号を含めることはできません
  # - OIDC標準に従い、パスコンポーネントは許可されますが、クエリパラメータは許可されません
  # - 通常はホスト名のみで構成されます（例: https://server.example.org または https://example.com）
  # - AWSアカウント内で、各IAM OIDCアイデンティティプロバイダーは一意のURLを使用する必要があります
  #
  # 例:
  # - Google: "https://accounts.google.com"
  # - Auth0: "https://your-tenant.auth0.com"
  # - カスタムIdP: "https://example.com"
  url = "https://accounts.google.com"

  # client_id_list - (Required) OpenID Connectプロバイダーに登録されたアプリケーションを
  # 識別するクライアントID（オーディエンス）のリスト
  #
  # これはOAuthリクエストで`client_id`パラメータとして送信される値です。
  # IdPにアプリケーションを登録すると発行される一意の識別子で、JWT tokenの`aud`クレームと
  # 一致する必要があります。
  #
  # 注意:
  # - 少なくとも1つのクライアントIDが必要です
  # - 最大100個のオーディエンスを設定できます
  # - IdPのJWT tokenに`azp`クレームが含まれている場合、AWSはSTSで`azp`の値を
  #   `aud`クレームとして使用します
  #
  # 例: ["266362248691-342342xasdasdasda-apps.googleusercontent.com"]
  client_id_list = [
    "266362248691-example-apps.googleusercontent.com",
  ]

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # thumbprint_list - (Optional) OpenID Connect (OIDC) アイデンティティプロバイダーの
  # サーバー証明書のサムプリントのリスト
  #
  # 動作:
  # - 特定のOIDC IdP（Auth0、GitHub、GitLab、Google、またはAmazon S3ホストのJWKSエンドポイントを
  #   使用するもの）の場合、AWSは検証のために信頼されたルート認証局（CA）の独自ライブラリに
  #   依存し、設定されたサムプリントは使用されません
  # - その他のIdPの場合、thumbprint_listが提供されていない場合、IAMは自動的にOIDC IdP
  #   サーバー証明書から最上位の中間CAサムプリントを取得して使用します
  # - thumbprint_listが最初に設定され、後で削除された場合、Terraformは新しいサムプリントを
  #   取得するようIAMに指示せず、初期設定からの元のサムプリントリストを使用し続けます
  #
  # 注意:
  # - AWSはJWKSエンドポイントのTLS証明書を検証するために、信頼されたルートCAのライブラリを使用して
  #   OIDC IdPとの通信を保護します
  # - OIDC IdPがこれらの信頼されたCAの1つによって署名されていない証明書に依存している場合のみ、
  #   IdP設定で設定されたサムプリントを使用して通信を保護します
  # - TLS証明書を取得できない場合、またはTLS v1.3が必要な場合、AWSはサムプリント検証に
  #   フォールバックします
  # - 少なくとも1つ、最大5つのサムプリントを設定できます
  #
  # サムプリントの取得方法については以下を参照:
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
  #
  # 例: ["cf23df2207d99a74fbe169e3eba035e633b65d94"]
  thumbprint_list = []

  # tags - (Optional) IAM OIDCプロバイダーのリソースタグのマップ
  #
  # プロバイダーのdefault_tags設定ブロックが存在する場合、一致するキーを持つタグは
  # プロバイダーレベルで定義されたものを上書きします。
  #
  # 例:
  # tags = {
  #   Environment = "production"
  #   Project     = "web-app"
  #   ManagedBy   = "terraform"
  # }
  tags = {}

  # tags_all - (Optional) プロバイダーのdefault_tags設定ブロックから継承されたものを含む、
  # リソースに割り当てられたタグのマージされたマップ
  #
  # 注意:
  # - この属性はTerraformプロバイダーによって自動的に管理されます
  # - 通常、この属性を直接設定する必要はありません
  # - プロバイダーレベルのdefault_tagsとリソースレベルのtagsが自動的にマージされます
  # - 明示的に設定する必要がある特殊なケースでのみ使用してください
  # tags_all = {}

  # id - (Optional) リソースの一意識別子
  #
  # 注意:
  # - この属性はTerraformによって自動的に計算されます（ARNと同じ値）
  # - 通常、この属性を明示的に設定する必要はありません
  # - Terraformのimport機能を使用する場合など、特殊なケースでのみ使用します
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed-only）:
#
# - arn
#   タイプ: string
#   説明: AWSによってこのプロバイダーに割り当てられたARN
#   使用例: IAMロールの信頼ポリシーでプリンシパルとして使用
#
# 以下の属性はoptional + computedですが、主にTerraformによって自動管理されます:
#
# - id
#   タイプ: string
#   説明: リソースの一意識別子（ARNと同じ）
#
# - tags_all
#   タイプ: map(string)
#   説明: プロバイダーのdefault_tags設定ブロックから継承されたものを含む、
#         リソースに割り当てられたタグのマップ
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# OIDC プロバイダー作成後の一般的な使用パターン:
#
# 1. IAMロールの作成（OIDC連携用）:
#
# resource "aws_iam_role" "oidc_role" {
#   name = "oidc-federated-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Federated = aws_iam_openid_connect_provider.example.arn
#         }
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Condition = {
#           StringEquals = {
#             "${replace(aws_iam_openid_connect_provider.example.url, "https://", "")}:aud" = "example-client-id"
#           }
#         }
#       }
#     ]
#   })
# }
#
# 2. EKS クラスター用のOIDCプロバイダー:
#
# data "tls_certificate" "eks" {
#   url = aws_eks_cluster.example.identity[0].oidc[0].issuer
# }
#
# resource "aws_iam_openid_connect_provider" "eks" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
#   url             = aws_eks_cluster.example.identity[0].oidc[0].issuer
# }
#
# 3. GitHub Actions用のOIDCプロバイダー:
#
# resource "aws_iam_openid_connect_provider" "github" {
#   url             = "https://token.actions.githubusercontent.com"
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
#
# 1. プロバイダー設定の検証:
#    - OIDCプロバイダーを作成する前に、IdPの設定を検証してください
#    - {url}/.well-known/openid-configuration にアクセスして、設定ドキュメントが
#      適切に構成されているか確認してください
#    - 必須フィールド: issuer, jwks_uri, claims_supported
#
# 2. JWKSエンドポイントの制限:
#    - JSON Web Key Set (JWKS) には少なくとも1つのキーが含まれている必要があります
#    - 最大100個のRSAキーと100個のECキーを持つことができます
#    - この制限を超えると、AssumeRoleWithWebIdentity API呼び出し時に
#      InvalidIdentityToken例外が発生します
#
# 3. 証明書チェーンの順序:
#    - OIDC IdPの証明書チェーンは、ドメインまたは発行者URL、中間証明書、
#      ルート証明書の順序で開始する必要があります
#    - 証明書チェーンの順序が異なる場合や、重複または追加の証明書が含まれている場合、
#      署名の不一致エラーが発生し、STSがJSON Web Token (JWT) の検証に失敗します
#
# 4. サムプリントについて:
#    - Google、Auth0、GitHub、GitLabなどの一般的なIdPの場合、サムプリントは
#      検証には使用されません（AWSの信頼されたCAライブラリが使用されます）
#    - カスタムIdPの場合、サムプリントを明示的に設定するか、IAMに自動取得させることができます
#
# 5. クロスアカウント使用:
#    - ロールの信頼ポリシーで使用されるOIDC IdPは、そのロールと同じアカウントに
#      存在する必要があります
#
# 6. IAMポリシーでの使用:
#    - oidc-providerリソースをサポートするアクションのアイデンティティベースポリシーを
#      設定する場合、IAMは完全なOIDC IdP URL（指定されたパスを含む）を評価します
#    - OIDC IdP URLにパスがある場合、Resourceエレメントのoidc-provider ARNにそのパスを
#      含める必要があります
#
#---------------------------------------------------------------
