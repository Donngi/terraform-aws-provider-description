#---------------------------------------------------------------
# AWS OpenSearch Authorize VPC Endpoint Access
#---------------------------------------------------------------
#
# OpenSearch Service ドメインへの VPC エンドポイントアクセスを他の AWS アカウントに
# 許可するためのリソース。
#
# このリソースを使用すると、別の AWS アカウントの VPC から OpenSearch Service ドメイン
# への接続を許可できます。VPC エンドポイント（AWS PrivateLink 経由）を使用した
# クロスアカウントアクセスを実現する際に必要です。
#
# 主なユースケース：
#   - 別の AWS アカウントから VPC ドメインへのプライベート接続を許可
#   - マルチアカウント環境での OpenSearch Service の共有
#   - AWS PrivateLink を使用したセキュアなクロスアカウントアクセス
#
# 注意事項：
#   - VPC エンドポイントは VPC ドメインにのみ接続可能（パブリックドメインは非対応）
#   - 1 ドメインあたり最大 10 の authorized principals を設定可能
#   - 1 アカウントあたり最大 50 エンドポイント、1 ドメインあたり最大 10 エンドポイント
#
# AWS公式ドキュメント:
#   - VPC エンドポイントを使用した OpenSearch Service へのアクセス:
#     https://docs.aws.amazon.com/opensearch-service/latest/developerguide/vpc-interface-endpoints.html
#   - AuthorizeVpcEndpointAccess API:
#     https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_AuthorizeVpcEndpointAccess.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_authorize_vpc_endpoint_access
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearch_authorize_vpc_endpoint_access" "example" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # account - (必須) アクセスを許可する AWS アカウント ID
  #
  # VPC エンドポイントを作成してこのドメインに接続することを許可する
  # AWS アカウントの 12 桁のアカウント ID を指定します。
  # この設定により、指定したアカウントが VPC エンドポイントを通じて
  # ドメインにアクセスできるようになります。
  #
  # 例: "123456789012"
  #
  account = "REPLACE_WITH_AWS_ACCOUNT_ID"

  # domain_name - (必須) アクセスを許可する OpenSearch Service ドメインの名前
  #
  # VPC エンドポイントアクセスを許可する OpenSearch Service ドメインの
  # 名前を指定します。ドメインは VPC 内にデプロイされている必要があります
  # （パブリックドメインは VPC エンドポイントに対応していません）。
  #
  # 例: "my-opensearch-domain"
  #
  domain_name = "REPLACE_WITH_DOMAIN_NAME"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # region - (オプション) リソースを管理する AWS リージョン
  #
  # このリソースを管理する AWS リージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # VPC エンドポイントは同一リージョン内のドメインにのみ接続可能です。
  #
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # 例: "ap-northeast-1"
  #
  # region = "ap-northeast-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします：
#
# authorized_principal - アクセスが許可されたプリンシパル情報のリスト
#   各要素は以下の属性を含むオブジェクト:
#     - principal      : ドメインへのアクセスが許可された IAM プリンシパル
#     - principal_type : プリンシパルのタイプ
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: 現在のアカウント ID を使用して自身のアカウントを許可
#
# data "aws_caller_identity" "current" {}
#
# resource "aws_opensearch_authorize_vpc_endpoint_access" "self" {
#   domain_name = aws_opensearch_domain.example.domain_name
#   account     = data.aws_caller_identity.current.account_id
# }

# 例2: 特定の外部アカウントを許可
#
# resource "aws_opensearch_authorize_vpc_endpoint_access" "external" {
#   domain_name = aws_opensearch_domain.example.domain_name
#   account     = "123456789012"
# }

# 例3: 複数のアカウントを許可（1ドメインあたり最大10アカウント）
#
# locals {
#   authorized_accounts = [
#     "111111111111",
#     "222222222222",
#     "333333333333",
#   ]
# }
#
# resource "aws_opensearch_authorize_vpc_endpoint_access" "multiple" {
#   for_each    = toset(local.authorized_accounts)
#   domain_name = aws_opensearch_domain.example.domain_name
#   account     = each.value
# }
