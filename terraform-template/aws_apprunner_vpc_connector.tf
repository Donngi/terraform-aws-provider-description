#---------------------------------------------------------------
# AWS App Runner VPC Connector
#---------------------------------------------------------------
#
# AWS App Runner VPC Connectorをプロビジョニングするリソースです。
# VPC Connectorを使用することで、App RunnerサービスからVPC内のプライベート
# リソース（Amazon RDS、ElastiCache等）へのアウトバウンド通信が可能になります。
#
# VPC ConnectorはAWS Hyperplane技術を基盤としており、指定したサブネットに
# Hyperplane ENI（Elastic Network Interface）を作成してトラフィックをルーティングします。
#
# AWS公式ドキュメント:
#   - App Runner VPCネットワーキング: https://docs.aws.amazon.com/apprunner/latest/dg/network-vpc.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_vpc_connector
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apprunner_vpc_connector" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # vpc_connector_name (Required)
  # 設定内容: VPC Connectorの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: この名前はVPC Connectorを識別するために使用されます。
  vpc_connector_name = "my-vpc-connector"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnets (Required)
  # 設定内容: App RunnerがVPCリソースにアクセスするために使用するサブネットIDのリストを指定します。
  # 設定可能な値: サブネットIDの集合（set）
  # 注意:
  #   - プライベートサブネットを使用してください
  #   - 高可用性のため、複数のアベイラビリティゾーンにまたがる3つ以上のサブネットを推奨
  #   - すべてのサブネットは同じIPアドレスタイプ（IPv4またはデュアルスタック）である必要があります
  # 関連機能: AWS Hyperplane ENI
  #   VPC Connectorを作成すると、指定したサブネットにHyperplane ENIが作成されます。
  #   これらのENIはプライベートIPアドレスのみを持ち、AWSAppRunnerManagedキーでタグ付けされます。
  #   - https://docs.aws.amazon.com/apprunner/latest/dg/network-vpc.html
  subnets = [
    "subnet-xxxxxxxxxxxxxxxxx",
    "subnet-yyyyyyyyyyyyyyyyy",
    "subnet-zzzzzzzzzzzzzzzzz"
  ]

  # security_groups (Required)
  # 設定内容: App RunnerがVPCリソースへのアクセスに使用するセキュリティグループIDのリストを指定します。
  # 設定可能な値: セキュリティグループIDの集合（set）
  # 省略時: 指定しない場合、VPCのデフォルトセキュリティグループが使用されます。
  #         デフォルトセキュリティグループはすべてのアウトバウンドトラフィックを許可します。
  # 注意: セキュリティグループのアウトバウンドルールで、接続先リソースへの通信を許可してください。
  security_groups = [
    "sg-xxxxxxxxxxxxxxxxx",
    "sg-yyyyyyyyyyyyyyyyy"
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
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-vpc-connector"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: VPC ConnectorのAmazon Resource Name (ARN)
#
# - status: VPC Connectorの現在の状態。
#           コネクタリビジョンのステータスがINACTIVEの場合、削除されており
#           使用できません。非アクティブなコネクタリビジョンは削除後しばらくして
#           永久に削除されます。
#
# - vpc_connector_revision: VPC Connectorのリビジョン番号。
#                           同じ名前を共有するすべてのアクティブなコネクタ
#                           （Status: ACTIVE）の中で一意です。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
