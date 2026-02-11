#---------------------------------------------------------------
# AWS App Runner VPC Ingress Connection
#---------------------------------------------------------------
#
# AWS App Runner VPC Ingress Connection リソースをプロビジョニングします。
# VPC Ingress Connection は、App Runner サービスへの受信トラフィックを
# Amazon VPC からのみアクセス可能にするプライベートエンドポイント接続を
# 提供するリソースです。
#
# VPC インターフェイスエンドポイント（AWS PrivateLink）を介して、
# VPC 内からのみ App Runner サービスにアクセスできるようになります。
# これにより、インターネットからのアクセスを遮断し、セキュリティを強化できます。
#
# AWS公式ドキュメント:
#   - Private endpoint for incoming traffic: https://docs.aws.amazon.com/apprunner/latest/dg/network-pl.html
#   - Managing Private endpoints: https://docs.aws.amazon.com/apprunner/latest/dg/network-pl-manage.html
#   - CreateVpcIngressConnection API: https://docs.aws.amazon.com/apprunner/latest/api/API_CreateVpcIngressConnection.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_vpc_ingress_connection
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apprunner_vpc_ingress_connection" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: VPC Ingress Connection リソースの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: AWS アカウントおよび AWS リージョン内のすべてのアクティブな
  #       VPC Ingress Connection において一意である必要があります。
  name = "example-vpc-ingress-connection"

  # service_arn (Required, Forces new resource)
  # 設定内容: VPC Ingress Connection を作成する App Runner サービスの ARN を指定します。
  # 設定可能な値: 有効な App Runner サービスの ARN
  # 注意: 1 つの App Runner サービスに対して作成できる VPC Ingress Connection は 1 つのみです。
  service_arn = "arn:aws:apprunner:ap-northeast-1:123456789012:service/my-app-runner-service/1234567890abcdef"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Ingress VPC Configuration
  #-------------------------------------------------------------
  # App Runner サービスへの受信トラフィックを許可する VPC とエンドポイントの設定です。
  # VPC インターフェイスエンドポイント（AWS PrivateLink）を事前に作成し、
  # そのエンドポイント ID と VPC ID を指定します。
  #
  # 関連機能: AWS PrivateLink / VPC Interface Endpoint
  #   VPC インターフェイスエンドポイントを作成することで、VPC 内のリソースから
  #   App Runner サービスへのプライベート接続が可能になります。
  #   - https://docs.aws.amazon.com/apprunner/latest/dg/network-pl.html

  ingress_vpc_configuration {
    # vpc_id (Required)
    # 設定内容: VPC エンドポイントが存在する VPC の ID を指定します。
    # 設定可能な値: 有効な VPC ID（例: vpc-xxxxxxxxxxxxxxxxx）
    # 注意: VPC インターフェイスエンドポイントが作成されている VPC を指定してください。
    vpc_id = "vpc-0123456789abcdef0"

    # vpc_endpoint_id (Required)
    # 設定内容: App Runner サービスに接続する VPC インターフェイスエンドポイントの ID を指定します。
    # 設定可能な値: 有効な VPC エンドポイント ID（例: vpce-xxxxxxxxxxxxxxxxx）
    # 注意: エンドポイントは com.amazonaws.<region>.apprunner.requests サービス用に
    #       作成されている必要があります。
    #       高可用性のため、少なくとも 2 つの Availability Zone にまたがるサブネットを
    #       選択することが推奨されます。
    vpc_endpoint_id = "vpce-0123456789abcdef0"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-vpc-ingress-connection"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: VPC Ingress Connection の Amazon Resource Name (ARN)
#
# - domain_name: VPC Ingress Connection リソースに関連付けられたドメイン名
#                プライベートエンドポイント経由でアクセスする際に使用します。
#
# - status: VPC Ingress Connection の現在のステータス
#           有効な値: AVAILABLE, PENDING_CREATION, PENDING_UPDATE,
#                    PENDING_DELETION, FAILED_CREATION, FAILED_UPDATE,
#                    FAILED_DELETION, DELETED
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
