#---------------------------------------------------------------
# Amazon MSK VPC 接続
#---------------------------------------------------------------
#
# Amazon MSK (Managed Streaming for Apache Kafka) の VPC 接続リソースです。
# 別の VPC から MSK クラスターへの接続を確立するために使用します。
# MSK Multi-VPC 接続機能により、異なる VPC 内のクライアントが
# プライベートネットワーク経由で MSK ブローカーに接続できます。
#
# AWS公式ドキュメント:
#   - MSK Multi-VPC 接続: https://docs.aws.amazon.com/msk/latest/developerguide/aws-access-mult-vpc.html
#   - VPC 接続の管理: https://docs.aws.amazon.com/msk/latest/developerguide/mvpc-cross-account.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_vpc_connection
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_msk_vpc_connection" "example" {
  #-------------------------------------------------------------
  # 接続対象設定
  #-------------------------------------------------------------

  # target_cluster_arn (Required)
  # 設定内容: VPC 接続先の MSK クラスターの ARN を指定します。
  # 設定可能な値: 有効な MSK クラスターの ARN
  # 注意: 対象クラスターで Multi-VPC 接続が有効化されている必要があります
  target_cluster_arn = "arn:aws:kafka:ap-northeast-1:123456789012:cluster/example-cluster/abcd1234-1234-1234-1234-abcdef123456-1"

  # authentication (Required)
  # 設定内容: VPC 接続で使用するクライアント認証の種類を指定します。
  # 設定可能な値:
  #   - "SASL_IAM": IAM ロールベースの認証を使用
  #   - "SASL_SCRAM": SASL/SCRAM 認証を使用
  #   - "TLS": TLS クライアント証明書による認証を使用
  # 注意: 指定する認証方式はクラスター側で有効化されている必要があります
  authentication = "SASL_IAM"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: 接続元となるクライアント VPC の ID を指定します。
  # 設定可能な値: 有効な VPC ID（例: vpc-12345678）
  vpc_id = "vpc-12345678"

  # client_subnets (Required)
  # 設定内容: VPC 接続のエンドポイントを配置するサブネット ID のセットを指定します。
  # 設定可能な値: 有効なサブネット ID のセット
  # 注意: 高可用性のため、異なるアベイラビリティーゾーンのサブネットを指定することを推奨します
  client_subnets = [
    "subnet-11111111",
    "subnet-22222222",
    "subnet-33333333",
  ]

  # security_groups (Required)
  # 設定内容: VPC 接続に関連付けるセキュリティグループ ID のセットを指定します。
  # 設定可能な値: 有効なセキュリティグループ ID のセット
  # 注意: セキュリティグループは vpc_id で指定した VPC に属している必要があります
  security_groups = ["sg-12345678"]

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "example-msk-vpc-connection"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn / id: MSK VPC 接続の ARN
# - tags_all: プロバイダーの default_tags から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
