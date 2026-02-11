# ============================================================
# Terraform Template: aws_ec2_managed_prefix_list_entry
# ============================================================
# Generated: 2026-01-22
# Provider: hashicorp/aws
# Version: 6.28.0
#
# Description:
#   AWS EC2マネージドプレフィックスリストエントリの全プロパティを網羅した
#   解説付きサンプルテンプレート
#
# Note:
#   このテンプレートは生成時点の情報です。最新の仕様については
#   公式ドキュメントをご確認ください。
#
# AWS Documentation:
#   - Managed Prefix Lists:
#     https://docs.aws.amazon.com/vpc/latest/userguide/managed-prefix-lists.html
#   - API Reference - PrefixListEntry:
#     https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_PrefixListEntry.html
#
# Terraform Registry:
#   https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_managed_prefix_list_entry
# ============================================================

# マネージドプレフィックスリストエントリリソースの定義
resource "aws_ec2_managed_prefix_list_entry" "example" {
  # ============================================================
  # 必須パラメータ
  # ============================================================

  # cidr - (必須) このエントリのCIDRブロック
  # Type: string
  #
  # 説明:
  #   マネージドプレフィックスリストに追加するIPアドレス範囲をCIDR表記で指定します。
  #   IPv4の場合は例えば "10.0.0.0/16"、IPv6の場合は "2001:db8::/32" のように指定します。
  #   プレフィックスリストのaddress_familyに応じてIPv4またはIPv6を指定する必要があります。
  #
  # 例:
  #   - IPv4: "10.0.0.0/16", "192.168.1.0/24"
  #   - IPv6: "2001:db8::/32", "fd00::/8"
  #
  # AWS API Reference:
  #   https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_PrefixListEntry.html
  cidr = "10.0.0.0/16"

  # prefix_list_id - (必須) プレフィックスリストのID
  # Type: string
  #
  # 説明:
  #   このエントリを追加するマネージドプレフィックスリストのIDを指定します。
  #   通常は "pl-" で始まる形式のIDです。
  #   aws_ec2_managed_prefix_listリソースまたはデータソースから取得できます。
  #
  # 例:
  #   - "pl-0123456abcabcabc1"
  #   - aws_ec2_managed_prefix_list.example.id
  #
  # AWS API Reference:
  #   https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyManagedPrefixList.html
  prefix_list_id = "pl-0123456abcabcabc1"

  # ============================================================
  # オプションパラメータ
  # ============================================================

  # description - (オプション) このエントリの説明
  # Type: string
  # Default: null
  #
  # 説明:
  #   プレフィックスリストエントリの用途や目的を説明するテキストです。
  #
  # 重要な注意事項:
  #   APIの制限により、エントリの説明のみを更新する場合、エントリの再作成が必要になります。
  #   これは、CIDRやprefix_list_idを変更せず、descriptionのみを変更する場合に該当します。
  #   再作成中は一時的にエントリが削除されるため、プレフィックスリストを使用している
  #   セキュリティグループルールやルートテーブルに影響が出る可能性があります。
  #
  # 例:
  #   - "Primary VPC CIDR"
  #   - "Production environment subnet"
  #   - "Office network range"
  #
  # AWS API Reference:
  #   https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_PrefixListEntry.html
  description = "Example VPC CIDR block"

  # region - (オプション) このリソースが管理されるリージョン
  # Type: string
  # Default: プロバイダー設定のリージョン
  #
  # 説明:
  #   このリソースを作成・管理するAWSリージョンを明示的に指定します。
  #   指定しない場合は、プロバイダー設定で指定されたリージョンが使用されます。
  #
  #   このパラメータは、マルチリージョン構成やリージョン固有のリソース管理が
  #   必要な場合に使用します。
  #
  # 例:
  #   - "us-east-1"
  #   - "ap-northeast-1"
  #   - "eu-west-1"
  #
  # AWS Documentation:
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # Terraform Provider Documentation:
  #   https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # region = "us-east-1"
}

# ============================================================
# Computed属性（読み取り専用）
# ============================================================
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能です:
#
# - id (string):
#     マネージドプレフィックスリストエントリのID
#     このIDは、Terraform内でリソースを一意に識別するために使用されます。
# ============================================================

# ============================================================
# 使用上の重要な注意事項
# ============================================================
#
# 1. リソースの競合について:
#    - aws_ec2_managed_prefix_listリソースのインラインentryブロックと
#      aws_ec2_managed_prefix_list_entryスタンドアロンリソースを
#      同じプレフィックスリストに対して併用することはできません。
#    - 併用するとエントリの競合が発生し、予期しない上書きが発生します。
#    - どちらか一方の方法でエントリを管理してください。
#
# 2. 大量エントリの場合の推奨事項:
#    - 100エントリ以上を作成する場合は、実行時間を改善するため、
#      aws_ec2_managed_prefix_listリソースのインラインentryブロックを
#      使用することが推奨されます。
#
# 3. descriptionの更新について:
#    - descriptionのみを変更する場合、APIの制限によりエントリが再作成されます。
#    - 再作成中は一時的にエントリが削除されるため、セキュリティグループや
#      ルートテーブルなど、このプレフィックスリストを参照しているリソースに
#      影響が出る可能性があります。
#    - 本番環境では、メンテナンスウィンドウでの実行を検討してください。
#
# 4. プレフィックスリストの容量:
#    - エントリを追加する前に、プレフィックスリストのmax_entriesに
#      十分な空きがあることを確認してください。
#    - max_entriesを超えてエントリを追加しようとするとエラーになります。
# ============================================================

# ============================================================
# 使用例
# ============================================================
#
# Example 1: VPCのCIDRをプレフィックスリストに追加
#
# resource "aws_ec2_managed_prefix_list" "vpc_cidrs" {
#   name           = "All VPC CIDRs"
#   address_family = "IPv4"
#   max_entries    = 5
#
#   tags = {
#     Environment = "Production"
#   }
# }
#
# resource "aws_ec2_managed_prefix_list_entry" "vpc_primary" {
#   cidr           = "10.0.0.0/16"
#   description    = "Primary VPC"
#   prefix_list_id = aws_ec2_managed_prefix_list.vpc_cidrs.id
# }
#
# resource "aws_ec2_managed_prefix_list_entry" "vpc_secondary" {
#   cidr           = "10.1.0.0/16"
#   description    = "Secondary VPC"
#   prefix_list_id = aws_ec2_managed_prefix_list.vpc_cidrs.id
# }
#
# Example 2: 複数のVPCからエントリを動的に追加
#
# resource "aws_ec2_managed_prefix_list" "all_vpcs" {
#   name           = "All VPC CIDRs"
#   address_family = "IPv4"
#   max_entries    = 10
# }
#
# resource "aws_ec2_managed_prefix_list_entry" "vpc_entries" {
#   for_each = { for idx, vpc in aws_vpc.environments : idx => vpc }
#
#   cidr           = each.value.cidr_block
#   description    = "VPC ${each.key}"
#   prefix_list_id = aws_ec2_managed_prefix_list.all_vpcs.id
# }
#
# Example 3: IPv6プレフィックスリストエントリ
#
# resource "aws_ec2_managed_prefix_list" "ipv6_ranges" {
#   name           = "IPv6 Ranges"
#   address_family = "IPv6"
#   max_entries    = 5
# }
#
# resource "aws_ec2_managed_prefix_list_entry" "ipv6_entry" {
#   cidr           = "2001:db8::/32"
#   description    = "IPv6 documentation range"
#   prefix_list_id = aws_ec2_managed_prefix_list.ipv6_ranges.id
# }
# ============================================================
