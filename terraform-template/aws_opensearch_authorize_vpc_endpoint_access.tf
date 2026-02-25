#---------------------------------------------------------------
# AWS OpenSearch Service VPC エンドポイントアクセス認可
#---------------------------------------------------------------
#
# Amazon OpenSearch Service ドメインへのインターフェース VPC エンドポイント
# 経由のアクセスを特定の AWS アカウントに対して認可するリソースです。
# VPC 内のリソースがインターネットを経由せずに OpenSearch Service ドメインに
# アクセスできるよう、クロスアカウントの VPC エンドポイントアクセスを管理します。
#
# AWS公式ドキュメント:
#   - OpenSearch Service VPC エンドポイントアクセス: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/vpc-interface-endpoints.html
#   - AuthorizeVpcEndpointAccess API リファレンス: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_AuthorizeVpcEndpointAccess.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_authorize_vpc_endpoint_access
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearch_authorize_vpc_endpoint_access" "example" {
  #-------------------------------------------------------------
  # ドメイン設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: アクセスを提供する OpenSearch Service ドメインの名前を指定します。
  # 設定可能な値: 既存の OpenSearch Service ドメイン名（文字列）
  domain_name = "example-domain"

  #-------------------------------------------------------------
  # アクセス認可設定
  #-------------------------------------------------------------

  # account (Required)
  # 設定内容: VPC エンドポイント経由でドメインへのアクセスを認可する AWS アカウント ID を指定します。
  # 設定可能な値: 12 桁の AWS アカウント ID（文字列）
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/vpc-interface-endpoints.html
  account = "123456789012"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - authorized_principal: アクセスを認可された AWS アカウントまたはサービスの情報。
#                         以下の属性を含むオブジェクトのリスト:
#   - principal:      アクセスを許可された IAM プリンシパル（アカウント ID 等）
#   - principal_type: プリンシパルの種別（AWS アカウントまたは AWS サービス）
#---------------------------------------------------------------
