#---------------------------------------------------------------
# AWS VPC (Virtual Private Cloud)
#---------------------------------------------------------------
#
# Amazon VPC（仮想プライベートクラウド）をプロビジョニングするリソースです。
# VPCはAWSクラウド内の論理的に分離されたネットワーク空間であり、
# EC2インスタンスやその他のAWSリソースを配置する基盤となります。
# IPv4およびIPv6 CIDRブロックの割り当て、DNSサポート、
# インスタンステナンシー等の設定が可能です。
#
# AWS公式ドキュメント:
#   - Amazon VPC ユーザーガイド: https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
#   - VPC CIDR ブロック: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html
#   - VPC 設定オプション: https://docs.aws.amazon.com/vpc/latest/userguide/create-vpc-options.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc" "example" {
  #-------------------------------------------------------------
  # IPv4 CIDR 設定
  #-------------------------------------------------------------

  # cidr_block (Optional)
  # 設定内容: VPCのIPv4 CIDRブロックを指定します。
  #           明示的に指定するか、ipv4_ipam_pool_idを使用してIPAMから割り当てることができます。
  # 設定可能な値: RFCl 918に準拠したプライベートIPv4アドレス範囲
  #   - /16 ネットマスク（65,536 IPアドレス）から /28 ネットマスク（16 IPアドレス）の範囲
  #   例: "10.0.0.0/16", "172.16.0.0/12", "192.168.0.0/16"
  # 省略時: ipv4_ipam_pool_idとipv4_netmask_lengthで指定する場合は省略可能
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html
  cidr_block = "10.0.0.0/16"

  # ipv4_ipam_pool_id (Optional)
  # 設定内容: VPCのCIDRを割り当てるIPv4 IPAMプールのIDを指定します。
  #           IPAMを使用してIPアドレス管理を自動化する場合に使用します。
  # 設定可能な値: 有効なIPAMプールID（例: "ipam-pool-0123456789abcdef0"）
  # 省略時: cidr_blockで直接CIDRを指定します。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/tracking-ip-addresses-ipam.html
  ipv4_ipam_pool_id = null

  # ipv4_netmask_length (Optional)
  # 設定内容: IPAMプールから割り当てるIPv4 CIDRのネットマスク長を指定します。
  #           ipv4_ipam_pool_idと合わせて使用します。
  # 設定可能な値: 整数値（/16 〜 /28 の範囲）
  # 省略時: IPAMプールにデフォルトのnetmask_lengthが設定されている場合は省略可能
  # 注意: ipv4_ipam_pool_idの指定が必要です。
  ipv4_netmask_length = null

  #-------------------------------------------------------------
  # IPv6 CIDR 設定
  #-------------------------------------------------------------

  # assign_generated_ipv6_cidr_block (Optional)
  # 設定内容: Amazonが提供するIPv6 CIDRブロック（/56プレフィックス長）を
  #           VPCに割り当てるかどうかを指定します。
  # 設定可能な値:
  #   - true: AmazonがIPv6 CIDRブロックを自動割り当て
  #   - false (デフォルト): IPv6 CIDRブロックを自動割り当てしない
  # 注意: ipv6_ipam_pool_idと競合します（同時指定不可）
  assign_generated_ipv6_cidr_block = false

  # ipv6_cidr_block (Optional)
  # 設定内容: IPAMプールからリクエストするIPv6 CIDRブロックを指定します。
  #           明示的に指定するか、ipv6_netmask_lengthを使用してIPAMから割り当てることができます。
  # 設定可能な値: 有効なIPv6 CIDRブロック
  # 省略時: assign_generated_ipv6_cidr_blockまたはipv6_ipam_pool_idで指定する場合は省略可能
  ipv6_cidr_block = null

  # ipv6_ipam_pool_id (Optional)
  # 設定内容: VPCのIPv6 CIDRを割り当てるIPAMプールのIDを指定します。
  # 設定可能な値: 有効なIPv6 IPAMプールID
  # 省略時: assign_generated_ipv6_cidr_blockを使用するか、IPv6を使用しない場合は省略可能
  # 注意: assign_generated_ipv6_cidr_blockと競合します（同時指定不可）
  ipv6_ipam_pool_id = null

  # ipv6_netmask_length (Optional)
  # 設定内容: IPAMプールから割り当てるIPv6 CIDRのネットマスク長を指定します。
  #           ipv6_ipam_pool_idと合わせて使用します。
  # 設定可能な値: 44から60までの整数（4の倍数）
  #   例: 44, 48, 52, 56, 60
  # 省略時: IPAMプールにallocation_default_netmask_lengthが設定されている場合は省略可能
  # 注意: ipv6_cidr_blockと競合します（同時指定不可）
  ipv6_netmask_length = null

  # ipv6_cidr_block_network_border_group (Optional)
  # 設定内容: IPv6 CIDRブロックのネットワーク境界グループを指定します。
  #           パブリックアドレスのアドバタイズを特定のネットワーク境界グループ
  #           （ローカルゾーン等）に制限する場合に使用します。
  # 設定可能な値: 有効なネットワーク境界グループ名（例: "ap-northeast-1", "us-east-1-nyc-1"）
  # 省略時: VPCのリージョンがデフォルトとして使用されます。
  ipv6_cidr_block_network_border_group = null

  #-------------------------------------------------------------
  # テナンシー設定
  #-------------------------------------------------------------

  # instance_tenancy (Optional)
  # 設定内容: VPC内で起動するEC2インスタンスのテナンシーオプションを指定します。
  # 設定可能な値:
  #   - "default" (デフォルト): EC2インスタンスは起動時に指定されたテナンシー属性を使用。
  #               共有ハードウェア上で実行されます。
  #   - "dedicated": このVPC内のEC2インスタンスは起動時のテナンシー属性に関わらず、
  #               常に専用ハードウェア上で実行されます。
  #               リージョンごとに $2/時間 の固定費用に加えてインスタンス使用料が発生します。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/create-vpc-options.html
  instance_tenancy = "default"

  #-------------------------------------------------------------
  # DNS 設定
  #-------------------------------------------------------------

  # enable_dns_support (Optional)
  # 設定内容: VPC内でのDNSサポートを有効にするかどうかを指定します。
  #           有効にすると、Route 53 ResolverサーバーへのDNSクエリが解決されます。
  # 設定可能な値:
  #   - true (デフォルト): DNS サポートを有効化
  #   - false: DNS サポートを無効化
  # 注意: enable_dns_hostnamesをtrueにする場合はenable_dns_supportもtrueである必要があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/create-vpc-options.html
  enable_dns_support = true

  # enable_dns_hostnames (Optional)
  # 設定内容: VPC内でのDNSホスト名を有効にするかどうかを指定します。
  #           有効にすると、パブリックIPv4アドレスを持つEC2インスタンスに
  #           パブリックDNSホスト名が割り当てられます。
  # 設定可能な値:
  #   - true: DNS ホスト名を有効化
  #   - false (デフォルト): DNS ホスト名を無効化
  # 注意: enable_dns_supportがtrueである必要があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/create-vpc-options.html
  enable_dns_hostnames = true

  #-------------------------------------------------------------
  # ネットワークアドレス使用状況メトリクス設定
  #-------------------------------------------------------------

  # enable_network_address_usage_metrics (Optional)
  # 設定内容: VPCのネットワークアドレス使用状況（NAU）メトリクスを有効にするかどうかを指定します。
  #           有効にすると、VPCのサイズ（使用中のIPアドレス数）を計測するメトリクスが
  #           Amazon CloudWatchに送信されます。
  # 設定可能な値:
  #   - true: NAU メトリクスを有効化
  #   - false (デフォルト): NAU メトリクスを無効化
  # 関連機能: Network Address Usage (NAU)
  #   EC2インスタンス、NLB、GLB、VPCエンドポイント、TGWアタッチメント、
  #   Lambda関数、NATゲートウェイ等に割り当てられたIPアドレスを計測します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/network-address-usage.html
  enable_network_address_usage_metrics = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: "ap-northeast-1", "us-east-1"）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなしでリソースが作成されます。
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-vpc"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: VPCのAmazon Resource Name (ARN)
# - id: VPCのID
# - default_network_acl_id: VPC作成時にデフォルトで作成されるネットワークACLのID
# - default_route_table_id: VPC作成時にデフォルトで作成されるルートテーブルのID
# - default_security_group_id: VPC作成時にデフォルトで作成されるセキュリティグループのID
# - dhcp_options_id: VPCに関連付けられているDHCPオプションセットのID
# - ipv6_association_id: IPv6 CIDRブロックの関連付けID
# - main_route_table_id: VPCのメインルートテーブルのID
# - owner_id: VPCを所有するAWSアカウントのID
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
