#---------------------------------------------------------------
# AWS API Gateway Domain Name Access Association
#---------------------------------------------------------------
#
# プライベートカスタムドメイン名とアクセスアソシエーションソース（VPCエンドポイント等）
# 間のドメイン名アクセスアソシエーションリソースを作成します。
#
# このリソースにより、VPCエンドポイントからプライベートカスタムドメイン名を
# 介してプライベートAPIを呼び出すことが可能になります。
#
# AWS公式ドキュメント:
#   - プライベートカスタムドメイン名チュートリアル: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-private-custom-domains-tutorial.html
#   - APIプロバイダーとコンシューマーのタスク: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-private-custom-domains-associations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name_access_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_domain_name_access_association" "example" {
  #-------------------------------------------------------------
  # ドメイン名設定
  #-------------------------------------------------------------

  # domain_name_arn (Required)
  # 設定内容: アクセスアソシエーションを作成する対象のプライベートカスタムドメイン名のARNを指定します。
  # 設定可能な値: 有効なAPI Gatewayプライベートカスタムドメイン名のARN
  # 例: arn:aws:apigateway:ap-northeast-1::/domainnames/api.example.com+abcd1234
  domain_name_arn = aws_api_gateway_domain_name.example.arn

  #-------------------------------------------------------------
  # アクセスアソシエーションソース設定
  #-------------------------------------------------------------

  # access_association_source (Required)
  # 設定内容: ドメイン名アクセスアソシエーションソースの識別子を指定します。
  # 設定可能な値: VPCエンドポイントの場合はVPCエンドポイントID
  # 例: vpce-1234567890abcdef0
  # 関連機能: VPCエンドポイント
  #   execute-api VPCエンドポイントを使用して、VPC内からプライベートAPIに
  #   アクセスできます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-private-api-test-invoke-url.html
  access_association_source = aws_vpc_endpoint.example.id

  # access_association_source_type (Required)
  # 設定内容: ドメイン名アクセスアソシエーションソースのタイプを指定します。
  # 設定可能な値:
  #   - "VPCE": VPCエンドポイント
  access_association_source_type = "VPCE"

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-domain-access-association"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ドメイン名アクセスアソシエーションのAmazon Resource Name (ARN)
#
# - id: (非推奨、代わりにarnを使用) このドメイン名アクセスアソシエーションに
#       割り当てられた内部識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
