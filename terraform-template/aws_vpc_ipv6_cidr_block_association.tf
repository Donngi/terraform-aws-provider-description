#---------------------------------------------------------------
# AWS VPC IPv6 CIDR Block Association
#---------------------------------------------------------------
#
# VPCに追加のIPv6 CIDRブロックを関連付けるリソースです。
# Amazon提供のIPv6 CIDRブロック、IPAM（IP Address Manager）プール、
# またはIPv6アドレスプールを使用してVPCにIPv6アドレス空間を割り当てます。
#
# AWS公式ドキュメント:
#   - VPCへのIPv6 CIDRブロックの追加: https://docs.aws.amazon.com/vpc/latest/userguide/working-with-vpcs.html#vpc-associate-ipv6-cidr
#   - Amazon VPC IPAM: https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv6_cidr_block_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_ipv6_cidr_block_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: IPv6 CIDRブロックを関連付けるVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-xxxxxxxx）
  vpc_id = "vpc-12345678"

  #-------------------------------------------------------------
  # IPv6 CIDRブロック取得方法設定
  #-------------------------------------------------------------

  # assign_generated_ipv6_cidr_block (Optional)
  # 設定内容: Amazonが提供するIPv6 CIDRブロック（/56プレフィックス長）を自動でリクエストするかを指定します。
  # 設定可能な値:
  #   - true: Amazon提供のIPv6 CIDRブロックを自動割り当て
  #   - false (デフォルト): Amazon提供の自動割り当てを行わない
  # 省略時: false
  # 注意: ipv6_ipam_pool_id, ipv6_pool, ipv6_cidr_block, ipv6_netmask_lengthと同時指定不可
  assign_generated_ipv6_cidr_block = false

  # ipv6_cidr_block (Optional)
  # 設定内容: VPCに割り当てるIPv6 CIDRブロックを明示的に指定します。
  # 設定可能な値: 有効なIPv6 CIDRブロック（例: 2001:db8::/56）
  # 省略時: ipv6_netmask_lengthを指定するか、IPAMプールにデフォルトネットマスクが設定されている場合は省略可能
  # 注意: assign_generated_ipv6_cidr_blockおよびipv6_netmask_lengthと同時指定不可
  #       ipv6_netmask_lengthが未指定でIPAMプールにallocation_default_netmaskが設定されていない場合は必須
  ipv6_cidr_block = null

  # ipv6_ipam_pool_id (Optional)
  # 設定内容: このVPCのCIDR割り当てに使用するIPv6 IPAMプールのIDを指定します。
  # 設定内容: IPAMはAWSリージョンおよびアカウントをまたぐIPアドレス管理ワークフローを自動化する機能です。
  # 設定可能な値: 有効なIPAMプールID（例: ipam-pool-xxxxxxxx）
  # 注意: assign_generated_ipv6_cidr_blockおよびipv6_poolと同時指定不可
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
  ipv6_ipam_pool_id = null

  # ipv6_netmask_length (Optional)
  # 設定内容: このVPCに割り当てるIPv6 CIDRのネットマスク長を指定します。
  # 設定可能な値: 数値（例: 56）
  # 省略時: IPAMプールにallocation_default_netmaskが設定されている場合は省略可能。設定されていない場合はipv6_cidr_blockが必須
  # 注意: ipv6_ipam_pool_idと同時に指定する必要があります。ipv6_cidr_blockと同時指定不可
  ipv6_netmask_length = null

  # ipv6_pool (Optional)
  # 設定内容: IPv6 CIDRブロックを割り当てるIPv6アドレスプールのIDを指定します。
  # 設定可能な値: 有効なIPv6アドレスプールID
  # 注意: assign_generated_ipv6_cidr_blockおよびipv6_ipam_pool_idと同時指定不可
  ipv6_pool = null

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
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのduration文字列（例: "10m", "1h30m"）
    # 省略時: デフォルトのタイムアウト時間を使用
    create = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goのduration文字列（例: "10m", "1h30m"）
    # 省略時: デフォルトのタイムアウト時間を使用
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPC CIDR関連付けのID
#
# - ip_source: IPアドレス空間を割り当てたソース
#              設定可能な値: "amazon"（Amazon提供）, "byoip"（持ち込みIP）, "none"
#
# - ipv6_address_attribute: IPv6アドレスのパブリック/プライベート属性
#                           設定可能な値: "public"（インターネットにアドバタイズ）, "private"（非アドバタイズ）
#---------------------------------------------------------------
