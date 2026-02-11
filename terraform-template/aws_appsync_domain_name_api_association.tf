#---------------------------------------------------------------
# AWS AppSync Domain Name API Association
#---------------------------------------------------------------
#
# AWS AppSyncのカスタムドメイン名とGraphQL APIを関連付けるリソースです。
# カスタムドメイン名を使用することで、シンプルで覚えやすいエンドポイントURL
# （例: api.example.com）でGraphQLおよびリアルタイムAPIにアクセスできます。
#
# AWS公式ドキュメント:
#   - カスタムドメイン名の設定: https://docs.aws.amazon.com/appsync/latest/devguide/custom-domain-name.html
#   - AssociateApi API: https://docs.aws.amazon.com/appsync/latest/APIReference/API_AssociateApi.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_domain_name_api_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appsync_domain_name_api_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: 関連付けるAppSync GraphQL APIのIDを指定します。
  # 設定可能な値: aws_appsync_graphql_api リソースから取得したAPI ID
  # 関連機能: AppSyncカスタムドメイン名
  #   カスタムドメイン名をAPIに関連付けることで、api.example.comのような
  #   覚えやすいURLでGraphQL/リアルタイムエンドポイントにアクセス可能になります。
  #   - https://docs.aws.amazon.com/appsync/latest/devguide/custom-domain-name.html
  api_id = aws_appsync_graphql_api.example.id

  # domain_name (Required)
  # 設定内容: 関連付けるAppSyncカスタムドメイン名を指定します。
  # 設定可能な値: aws_appsync_domain_name リソースで作成したドメイン名
  # 注意: カスタムドメイン名を使用するには、事前にaws_appsync_domain_nameリソースで
  #       ドメイン名を作成し、ACM証明書を設定しておく必要があります。
  #       証明書はus-east-1リージョンで発行されたものを使用する必要があります。
  domain_name = aws_appsync_domain_name.example.domain_name

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AppSyncドメイン名（domain_nameと同じ値）
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース例
#---------------------------------------------------------------
#
# # カスタムドメイン名の作成
# resource "aws_appsync_domain_name" "example" {
#   domain_name     = "api.example.com"
#   certificate_arn = aws_acm_certificate.example.arn
# }
#
# # GraphQL APIの作成
# resource "aws_appsync_graphql_api" "example" {
#   name                = "example-api"
#   authentication_type = "API_KEY"
# }
#
#---------------------------------------------------------------
