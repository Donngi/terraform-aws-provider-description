#---------------------------------------------------------------
# AWS API Gateway VPC Link
#---------------------------------------------------------------
#
# Amazon API Gateway VPC Linkをプロビジョニングするリソースです。
# VPC Linkは、REST APIからVPC内のプライベートリソースへの
# プライベート統合（Private Integration）を可能にします。
#
# 注意: このリソースはAPI Gateway Version 1（REST API）用のVPC Linkです。
# HTTP API用のプライベート統合には、aws_apigatewayv2_vpc_linkを使用してください。
#
# AWS公式ドキュメント:
#   - Private integrations for REST APIs: https://docs.aws.amazon.com/apigateway/latest/developerguide/private-integration.html
#   - VPC links V1 (legacy): https://docs.aws.amazon.com/apigateway/latest/developerguide/vpc-links-v1.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_vpc_link
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_vpc_link" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: VPC Linkを識別するための名前を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: API Gatewayコンソールやプライベート統合設定時にVPC Linkを識別するために使用
  name = "example-vpc-link"

  # description (Optional)
  # 設定内容: VPC Linkの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "VPC Link for private integration with internal NLB"

  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # target_arns (Required, Forces new resource)
  # 設定内容: VPC Link経由でアクセスするNetwork Load BalancerのARNリストを指定します。
  # 設定可能な値: Network Load BalancerのARN文字列のリスト
  # 注意:
  #   - 現在AWSは1つのターゲットのみをサポートしています
  #   - Network Load Balancerは内部向け（internal）である必要があります
  #   - Network Load BalancerとAPI Gatewayは同じAWSアカウントに属している必要があります
  # 関連機能: API Gateway Private Integration
  #   VPC Linkを介してREST APIからVPC内のプライベートリソースにアクセス可能。
  #   Network Load BalancerがVPC内のリソースへのトラフィックを分散します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/private-integration.html
  target_arns = ["arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:loadbalancer/net/example-nlb/1234567890abcdef"]

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
    Name        = "example-vpc-link"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPC LinkのID
#
# - arn: VPC LinkのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
