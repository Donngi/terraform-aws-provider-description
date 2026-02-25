#---------------------------------------------------------------
# Amazon QuickSight VPC Connection
#---------------------------------------------------------------
#
# Amazon QuickSight の VPC接続をプロビジョニングするリソースです。
# VPC接続により、QuickSightからVPC内のプライベートデータソース（RDS、
# Redshift、Aurora等）にセキュアにアクセスできます。
# QuickSightはVPC内にElastic Network Interfaceを作成し、
# VPC内のリソースとネットワークトラフィックを交換します。
#
# AWS公式ドキュメント:
#   - QuickSight VPC接続の設定: https://docs.aws.amazon.com/quicksight/latest/user/working-with-aws-vpc.html
#   - VPCConnection APIリファレンス: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_VPCConnection.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_vpc_connection
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_vpc_connection" "example" {
  #-------------------------------------------------------------
  # 識別子設定
  #-------------------------------------------------------------

  # vpc_connection_id (Required)
  # 設定内容: VPC接続の一意なIDを指定します。
  # 設定可能な値: 文字列
  vpc_connection_id = "example-vpc-connection"

  # name (Required)
  # 設定内容: VPC接続の表示名を指定します。
  # 設定可能な値: 文字列
  name = "Example VPC Connection"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # role_arn (Required)
  # 設定内容: VPC接続に関連付けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: このIAMロールには以下のEC2権限が必要です:
  #       ec2:CreateNetworkInterface, ec2:ModifyNetworkInterfaceAttribute,
  #       ec2:DeleteNetworkInterface, ec2:DescribeSubnets, ec2:DescribeSecurityGroups
  #       信頼ポリシーには quicksight.amazonaws.com を指定してください。
  # 参考: https://docs.aws.amazon.com/quicksight/latest/user/vpc-creating-a-connection-in-quicksight-cli.html
  role_arn = "arn:aws:iam::123456789012:role/quicksight-vpc-connection-role"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # security_group_ids (Required)
  # 設定内容: VPC接続に関連付けるセキュリティグループIDのセットを指定します。
  # 設定可能な値: 有効なセキュリティグループIDのセット
  # 注意: セキュリティグループはデータソースへのアウトバウンドトラフィックを
  #       許可するルールを含む必要があります。
  security_group_ids = [
    "sg-00000000000000001",
  ]

  # subnet_ids (Required)
  # 設定内容: VPC接続に使用するサブネットIDのセットを指定します。
  # 設定可能な値: 有効なサブネットIDのセット
  # 注意: 高可用性のため、複数のアベイラビリティゾーンにわたる
  #       2つ以上のサブネットを指定することを推奨します。
  #       QuickSightは各サブネットにElastic Network Interfaceを作成します。
  subnet_ids = [
    "subnet-00000000000000001",
    "subnet-00000000000000002",
  ]

  # dns_resolvers (Optional)
  # 設定内容: VPC接続のDNSリゾルバーエンドポイントのIPアドレスのリストを指定します。
  # 設定可能な値: IPアドレス文字列のセット（例: ["192.168.1.1", "192.168.1.2"]）
  # 省略時: カスタムDNSリゾルバーを使用しません
  # 注意: Route 53 Resolver インバウンドエンドポイントのIPアドレスを指定することで、
  #       VPC内のプライベートDNS名を解決できます。
  dns_resolvers = null

  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: VPC接続を作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーが自動的に判定したアカウントIDを使用します
  aws_account_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-vpc-connection"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定する設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" 等の期間文字列
    #               使用可能な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: デフォルトのタイムアウト値を使用します
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" 等の期間文字列
    #               使用可能な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: デフォルトのタイムアウト値を使用します
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" 等の期間文字列
    #               使用可能な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: デフォルトのタイムアウト値を使用します
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: VPC接続のAmazon Resource Name (ARN)
# - availability_status: VPC接続の可用性ステータス。
#                        有効な値: "AVAILABLE", "UNAVAILABLE", "PARTIALLY_AVAILABLE"
# - id: AWSアカウントIDとVPC接続IDをカンマ区切りで結合した文字列
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
