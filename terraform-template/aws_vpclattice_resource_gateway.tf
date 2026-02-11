#---------------------------------------------------------------
# VPC Lattice Resource Gateway
#
# VPC Lattice リソースゲートウェイを管理します。
# VPC内のリソースへのインバウンドトラフィックのエントリーポイントとなり、
# 複数のアベイラビリティゾーンにまたがって展開されます。他のVPCやアカウントから
# リソースへのアクセスを可能にします。
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-gateway.html
#
# Terraform AWS Provider Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpclattice_resource_gateway
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
#
# NOTE: このテンプレートはリソースの理解を助けるためのものです。
# 実際の使用時は、環境に応じて適切な値を設定してください。
#---------------------------------------------------------------

resource "aws_vpclattice_resource_gateway" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: リソースゲートウェイの名前
  # 設定可能な値: 任意の文字列（リソースを識別するための名前）
  # 省略時: 省略不可
  # 関連機能: VPC Lattice Resource Gateway - https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-gateway.html
  name = "production-resource-gateway"

  # vpc_id (Required)
  # 設定内容: リソースゲートウェイを作成するVPCのID
  # 設定可能な値: 有効なVPC ID
  # 省略時: 省略不可
  # 関連機能: Amazon VPC - https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
  vpc_id = "vpc-0a1b2c3d4e5f6g7h8"

  # subnet_ids (Required)
  # 設定内容: リソースゲートウェイを作成するサブネットのIDリスト
  # 設定可能な値: VPC内のサブネットIDのリスト（可能な限り多くのアベイラビリティゾーンをカバーすることを推奨）
  # 省略時: 省略不可
  # 関連機能: VPC Subnets - https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
  subnet_ids = [
    "subnet-0a1b2c3d4e5f6g7h8",
    "subnet-1a2b3c4d5e6f7g8h9",
    "subnet-2a3b4c5d6e7f8g9h0"
  ]

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # ip_address_type (Optional)
  # 設定内容: リソースゲートウェイが使用するIPアドレスタイプ
  # 設定可能な値: IPV4、IPV6、DUALSTACK
  # 省略時: IPV4（デフォルト）
  # 関連機能: IP Address Configuration - https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-gateway.html
  ip_address_type = "IPV4"

  # ipv4_addresses_per_eni (Optional)
  # 設定内容: リソースゲートウェイの各ENIあたりのIPv4アドレス数
  # 設定可能な値: 1〜62の整数（IPv4およびDUALSTACKアドレスタイプにのみ適用）
  # 省略時: 16（デフォルト）
  # 関連機能: Network Address Translation - https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-gateway.html
  ipv4_addresses_per_eni = 16

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # security_group_ids (Optional)
  # 設定内容: リソースゲートウェイに関連付けるセキュリティグループIDのリスト
  # 設定可能な値: 同じVPC内のセキュリティグループID（最大5つ）
  # 省略時: セキュリティグループなし
  # 関連機能: Security Groups - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html
  security_group_ids = [
    "sg-0a1b2c3d4e5f6g7h8"
  ]

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のマップ
  # 省略時: タグなし
  # 関連機能: Tagging AWS Resources - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "production-resource-gateway"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # region (Optional)
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョン
  # 関連機能: AWS Regions - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です:
#
# arn
#   リソースゲートウェイのARN
#   例: arn:aws:vpc-lattice:us-east-1:123456789012:resourcegateway/rgw-0a1b2c3d4e5f6g7h8
#
# id
#   リソースゲートウェイのID
#   例: rgw-0a1b2c3d4e5f6g7h8
#
# status
#   リソースゲートウェイのステータス
#   例: ACTIVE、CREATING、DELETING、UPDATE_IN_PROGRESS、DELETE_FAILED、CREATE_FAILED
#
# tags_all
#   プロバイダーのdefault_tagsとリソースのtagsをマージしたすべてのタグ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 補足情報
#---------------------------------------------------------------
# リソースゲートウェイの考慮事項:
#
# 1. 可用性の最大化
#    - 可能な限り多くのアベイラビリティゾーンにまたがるサブネットを指定
#    - VPCエンドポイントとリソースゲートウェイで少なくとも1つのAZが重複する必要がある
#
# 2. VPCあたりの制限
#    - 1つのVPCに最大100個のリソースゲートウェイを作成可能
#
# 3. IPv4アドレス数の選択
#    - 各IPv4アドレスは宛先IPあたり最大55,000の同時接続をサポート
#    - 同時接続数の要件に応じてipv4_addresses_per_eniを調整
#    - デフォルトの16アドレスで大半のユースケースに対応可能
#
# 4. IPv6の自動設定
#    - IPV6またはDUALSTACKタイプの場合、ENIあたり/80 CIDRが自動割り当て
#    - MTUは接続あたり8500バイト
#
# 5. セキュリティグループの推奨設定
#    - リソースゲートウェイからリソースへのアウトバウンドトラフィックを制御
#    - リソースのCIDR範囲、プロトコル、ポート範囲を使用してルールを定義
#---------------------------------------------------------------
