#---------------------------------------------------------------
# AWS Egress Only Internet Gateway
#---------------------------------------------------------------
#
# VPC用のEgress Only Internet Gateway（出力専用インターネットゲートウェイ）を
# プロビジョニングするリソースです。Egress Only Internet Gatewayは、
# IPv6トラフィック専用のゲートウェイで、VPC内のインスタンスからインターネットへの
# アウトバウンド通信を許可しつつ、インターネットからのインバウンド接続を
# 開始することはできません。
#
# AWS公式ドキュメント:
#   - Egress Only Internet Gateway: https://docs.aws.amazon.com/vpc/latest/userguide/egress-only-internet-gateway.html
#   - VPC and Subnets: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_egress_only_internet_gateway" "example" {
  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: Egress Only Internet Gatewayを関連付けるVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-xxxxxxxxxxxxxxxxx）
  # 関連機能: VPC IPv6サポート
  #   IPv6が有効化されたVPCで使用されます。VPC内のリソースが
  #   インターネットへアウトバウンド通信を行う際に使用されますが、
  #   インターネットからのインバウンド接続の開始はブロックされます。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/egress-only-internet-gateway.html
  vpc_id = "vpc-0123456789abcdef0"

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
  #   リソースの管理、コスト配分、アクセス制御などに使用できます。
  tags = {
    Name        = "example-egress-only-igw"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Egress Only Internet GatewayのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
