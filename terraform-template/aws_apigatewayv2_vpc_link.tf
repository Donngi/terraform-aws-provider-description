#---------------------------------------------------------------
# AWS API Gateway V2 VPC Link
#---------------------------------------------------------------
#
# Amazon API Gateway Version 2のVPCリンクをプロビジョニングするリソースです。
# VPCリンクは、HTTP APIからVPC内のプライベートリソース（Application Load Balancer、
# Network Load Balancer、Amazon ECSコンテナベースアプリケーションなど）への
# プライベート統合を可能にします。
#
# 注: API Gateway Version 2のVPCリンク（VPC Link V2）はHTTP API向けです。
#     REST API向けのプライベート統合には、API Gateway Version 1のVPCリンク
#     （aws_api_gateway_vpc_link）を使用してください。
#
# AWS公式ドキュメント:
#   - HTTP APIのプライベート統合: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-private.html
#   - VPC Link V2のセットアップ: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-vpc-links-v2.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_vpc_link
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apigatewayv2_vpc_link" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: VPCリンクの名前を指定します。
  # 設定可能な値: 1〜128文字の文字列
  # 注意: この名前はAWSコンソールやAPIで識別に使用されます。
  name = "my-vpc-link"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # security_group_ids (Required)
  # 設定内容: VPCリンクに関連付けるセキュリティグループのIDを指定します。
  # 設定可能な値: VPC内の有効なセキュリティグループIDのセット
  # 関連機能: VPCセキュリティグループ
  #   セキュリティグループは、VPCリンクを通過するトラフィックの
  #   インバウンド/アウトバウンドルールを制御します。
  #   バックエンドリソース（ALB/NLB）への通信を許可するルールが必要です。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html
  security_group_ids = [
    "sg-0123456789abcdef0"
  ]

  # subnet_ids (Required)
  # 設定内容: VPCリンクを配置するサブネットのIDを指定します。
  # 設定可能な値: VPC内の有効なサブネットIDのセット
  # 関連機能: VPCサブネット
  #   VPCリンクはこれらのサブネット内にENI（Elastic Network Interface）を作成し、
  #   VPC内のプライベートリソースへの接続を確立します。
  #   高可用性のため、複数のアベイラビリティゾーンにまたがるサブネットを
  #   指定することを推奨します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
  subnet_ids = [
    "subnet-0123456789abcdef0",
    "subnet-0123456789abcdef1"
  ]

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
    Name        = "my-vpc-link"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPCリンクの識別子
#
# - arn: VPCリンクのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
