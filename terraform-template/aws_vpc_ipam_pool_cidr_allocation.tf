#---------------------------------------------------------------
# VPC IPAM Pool CIDR Allocation
#---------------------------------------------------------------
# IPAMプールからCIDRを予約（割り当て）し、IPAMによる使用を防ぐリソース
# プライベートIPv4専用の機能で、将来の利用や既存オンプレミスネットワークを
# 表現するためのIP空間を確保する目的で使用します。
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/vpc/latest/ipam/manually-allocate-ipam.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpc_ipam_pool_cidr_allocation
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
#
# NOTE: このファイルは自動生成されたテンプレートです。
# 実際の使用前に、環境に応じた適切な値への変更と検証が必要です。
#---------------------------------------------------------------

resource "aws_vpc_ipam_pool_cidr_allocation" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # ipam_pool_id (Required, Forces new resource)
  # 設定内容: CIDRを割り当てる先のIPAMプールID
  # 設定可能な値: 有効なIPAMプールリソースのID
  # 関連機能: AWS VPC IPAM
  #   IPアドレス管理を一元化し、IPアドレス空間の重複を防ぐサービス
  #   https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
  ipam_pool_id = "ipam-pool-0123456789abcdef0"

  #-------------------------------------------------------------
  # CIDR指定方法（cidr または netmask_length のいずれか）
  #-------------------------------------------------------------

  # cidr (Optional, Forces new resource)
  # 設定内容: プールに割り当てる特定のCIDR範囲
  # 設定可能な値: 有効なIPv4 CIDR表記（例: "172.20.0.0/24"）
  # 省略時: netmask_lengthが指定されている場合、プールから自動選択
  # 関連機能: 手動CIDR割り当て
  #   特定のアドレス範囲を明示的に予約する場合に使用
  #   https://docs.aws.amazon.com/vpc/latest/ipam/manually-allocate-ipam.html
  cidr = "172.20.0.0/24"

  # netmask_length (Optional, Forces new resource)
  # 設定内容: IPAMプールに割り当てるCIDRのネットマスク長
  # 設定可能な値: 0-128（IPv4の場合は通常0-32）
  # 省略時: cidrが指定されている場合は不要
  # NOTE: cidrとnetmask_lengthは排他的。netmask_lengthを使うと
  #       IPAMが自動的に利用可能な範囲から適切なCIDRを選択します
  # netmask_length = 28

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional, Forces new resource)
  # 設定内容: この割り当ての説明文
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  # NOTE: 管理上の目的を明確にするため記載を推奨
  description = "Reserved CIDR for production VPC subnet expansion"

  # disallowed_cidrs (Optional, Forces new resource)
  # 設定内容: プールからの自動選択時に除外する特定のCIDR範囲
  # 設定可能な値: CIDRのセット（文字列のリスト）
  # 省略時: 除外なし
  # NOTE: netmask_lengthと併用時のみ有効。特定の範囲を避けて
  #       自動割り当てする場合に使用します
  # disallowed_cidrs = [
  #   "172.20.0.0/28",
  #   "172.20.0.16/28"
  # ]

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョン
  # 関連機能: リージョナルエンドポイント
  #   リージョン固有のリソース管理
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（設定不可）:
#
# - id: 割り当てのID
#   output "allocation_id" {
#     value = aws_vpc_ipam_pool_cidr_allocation.example.id
#   }
#
# - ipam_pool_allocation_id: IPAMプール割り当ての一意な識別子
#   output "ipam_pool_allocation_id" {
#     value = aws_vpc_ipam_pool_cidr_allocation.example.ipam_pool_allocation_id
#   }
#
# - resource_id: この割り当てに関連付けられたリソースのID
#   output "resource_id" {
#     value = aws_vpc_ipam_pool_cidr_allocation.example.resource_id
#   }
#
# - resource_owner: リソースの所有者（AWSアカウントID）
#   output "resource_owner" {
#     value = aws_vpc_ipam_pool_cidr_allocation.example.resource_owner
#   }
#
# - resource_type: リソースのタイプ
#   output "resource_type" {
#     value = aws_vpc_ipam_pool_cidr_allocation.example.resource_type
#   }
#---------------------------------------------------------------
