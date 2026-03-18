#---------------------------------------------------------------
# AWS VPC Subnet
#---------------------------------------------------------------
#
# Amazon VPCのサブネットをプロビジョニングするリソースです。
# サブネットはVPC内のIPアドレス範囲であり、各サブネットは1つの
# アベイラビリティゾーン内に完全に収まる必要があります。
# IPv4のみ、デュアルスタック（IPv4 + IPv6）、IPv6のみの
# 3種類の構成をサポートします。
#
# AWS公式ドキュメント:
#   - サブネットの概要: https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
#   - IPアドレス設定: https://docs.aws.amazon.com/vpc/latest/userguide/subnet-public-ip.html
#   - IPv6 CIDRブロックの追加: https://docs.aws.amazon.com/vpc/latest/userguide/subnet-associate-ipv6-cidr.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_subnet" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: サブネットを作成するVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-12345678）
  vpc_id = "vpc-12345678901234567"

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
  # アベイラビリティゾーン設定
  #-------------------------------------------------------------

  # availability_zone (Optional)
  # 設定内容: サブネットを作成するアベイラビリティゾーンを指定します。
  # 設定可能な値: 有効なAZコード（例: ap-northeast-1a, us-east-1a）
  # 省略時: AWSがランダムに選択します。availability_zone_idとは排他的
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
  availability_zone = "ap-northeast-1a"

  # availability_zone_id (Optional)
  # 設定内容: サブネットを作成するアベイラビリティゾーンのIDを指定します。
  # 設定可能な値: 有効なAZ ID（例: apne1-az1）
  # 省略時: availability_zoneで指定する方法を推奨。全リージョン・パーティションで利用できない場合があります
  # 注意: availability_zoneと排他的（どちらか一方のみ指定可能）
  availability_zone_id = null

  #-------------------------------------------------------------
  # IPv4 CIDR設定
  #-------------------------------------------------------------

  # cidr_block (Optional)
  # 設定内容: サブネットのIPv4 CIDRブロックを指定します。
  # 設定可能な値: VPCのCIDRブロック内の有効なCIDR表記（例: 10.0.1.0/24）
  # 省略時: ipv4_ipam_pool_idを使用してIPAMプールから割り当てる場合は省略可能
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html#subnet-ip-address-range
  cidr_block = "10.0.1.0/24"

  # ipv4_ipam_pool_id (Optional)
  # 設定内容: サブネットのCIDRを割り当てるIPv4 IPAMプールのIDを指定します。
  #           IPAMを使用してIPアドレス管理を自動化する場合に使用します。
  # 設定可能な値: 有効なIPAMプールID（例: "ipam-pool-0123456789abcdef0"）
  # 省略時: cidr_blockで直接CIDRを指定します。
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/tracking-ip-addresses-ipam.html
  ipv4_ipam_pool_id = null

  # ipv4_netmask_length (Optional)
  # 設定内容: IPAMプールから割り当てるIPv4 CIDRのネットマスク長を指定します。
  #           ipv4_ipam_pool_idと合わせて使用します。
  # 設定可能な値: 整数値（VPCのCIDR範囲内の有効なネットマスク長）
  # 省略時: cidr_blockで直接指定する場合は省略可能
  # 注意: ipv4_ipam_pool_idの指定が必要です。
  ipv4_netmask_length = null

  #-------------------------------------------------------------
  # IPv6 CIDR設定
  #-------------------------------------------------------------

  # ipv6_cidr_block (Optional)
  # 設定内容: サブネットのIPv6 CIDRブロックを指定します（/64プレフィックス長が必須）。
  # 設定可能な値: VPCのIPv6 CIDRブロック内の/64 CIDR表記（例: 2001:db8::/64）
  # 省略時: IPv6が無効。IPv6を有効にする場合はVPCに先にIPv6 CIDRブロックを関連付ける必要あり
  # 注意: assign_ipv6_address_on_creation = true でこの値を変更するとリソースが再作成されます
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/subnet-associate-ipv6-cidr.html
  ipv6_cidr_block = null

  # ipv6_ipam_pool_id (Optional)
  # 設定内容: サブネットのIPv6 CIDRを割り当てるIPAMプールのIDを指定します。
  # 設定可能な値: 有効なIPv6 IPAMプールID
  # 省略時: ipv6_cidr_blockで直接CIDRを指定するか、IPv6を使用しない場合は省略可能
  # 参考: https://docs.aws.amazon.com/vpc/latest/ipam/tracking-ip-addresses-ipam.html
  ipv6_ipam_pool_id = null

  # ipv6_netmask_length (Optional)
  # 設定内容: IPAMプールから割り当てるIPv6 CIDRのネットマスク長を指定します。
  #           ipv6_ipam_pool_idと合わせて使用します。
  # 設定可能な値: 44から64までの整数（4の倍数）
  # 省略時: ipv6_cidr_blockで直接指定する場合は省略可能
  # 注意: ipv6_ipam_pool_idの指定が必要です。
  ipv6_netmask_length = null

  # ipv6_native (Optional)
  # 設定内容: IPv6専用サブネットを作成するかを指定します。
  # 設定可能な値:
  #   - true: IPv6のみのサブネットを作成（IPv4 CIDRブロックなし）
  #   - false (デフォルト): IPv4またはデュアルスタックのサブネットを作成
  # 注意: trueに設定する場合、cidr_blockは指定不可
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html#subnet-ip-address-range
  ipv6_native = false

  #-------------------------------------------------------------
  # IPアドレス自動割り当て設定
  #-------------------------------------------------------------

  # map_public_ip_on_launch (Optional)
  # 設定内容: このサブネットで起動するインスタンスにパブリックIPv4アドレスを自動割り当てするかを指定します。
  # 設定可能な値:
  #   - true: インスタンス起動時にパブリックIPv4を自動割り当て（パブリックサブネット向け）
  #   - false (デフォルト): パブリックIPv4を自動割り当てしない
  # 注意: インスタンス起動時の個別設定でこの動作を上書きすることが可能
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/subnet-public-ip.html
  map_public_ip_on_launch = false

  # assign_ipv6_address_on_creation (Optional)
  # 設定内容: このサブネットで作成されるネットワークインターフェースにIPv6アドレスを自動割り当てするかを指定します。
  # 設定可能な値:
  #   - true: ネットワークインターフェース作成時にIPv6アドレスを自動割り当て
  #   - false (デフォルト): IPv6アドレスを自動割り当てしない
  assign_ipv6_address_on_creation = false

  #-------------------------------------------------------------
  # DNS設定
  #-------------------------------------------------------------

  # enable_dns64 (Optional)
  # 設定内容: AmazonのDNSリゾルバーがIPv4専用の宛先にIPv6合成アドレスを返すかを指定します。
  # 設定可能な値:
  #   - true: DNS64を有効化。IPv6専用ワークロードからIPv4サービスへの通信を可能にする
  #   - false (デフォルト): DNS64を無効化
  # 関連機能: DNS64とNAT64
  #   IPv6専用ワークロードがIPv4リソースと通信するためのNAT64と組み合わせて使用。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-nat64-dns64.html
  enable_dns64 = false

  # enable_resource_name_dns_a_record_on_launch (Optional)
  # 設定内容: インスタンスのホスト名に対するDNSクエリにAレコード（IPv4）で応答するかを指定します。
  # 設定可能な値:
  #   - true: インスタンスのホスト名のDNSクエリにAレコードで応答
  #   - false (デフォルト): AレコードによるDNS応答を無効化
  # 注意: private_dns_hostname_type_on_launch の設定と組み合わせて使用
  enable_resource_name_dns_a_record_on_launch = false

  # enable_resource_name_dns_aaaa_record_on_launch (Optional)
  # 設定内容: インスタンスのホスト名に対するDNSクエリにAAAAレコード（IPv6）で応答するかを指定します。
  # 設定可能な値:
  #   - true: インスタンスのホスト名のDNSクエリにAAAAレコードで応答
  #   - false (デフォルト): AAAAレコードによるDNS応答を無効化
  enable_resource_name_dns_aaaa_record_on_launch = false

  # private_dns_hostname_type_on_launch (Optional)
  # 設定内容: 起動時にサブネットのインスタンスに割り当てるホスト名の種類を指定します。
  # 設定可能な値:
  #   - "ip-name": インスタンスのIPv4アドレスに基づくホスト名（例: ip-10-0-1-5.ap-northeast-1.compute.internal）
  #   - "resource-name": インスタンスIDに基づくホスト名（例: i-1234567890abcdef0.ap-northeast-1.compute.internal）
  # 省略時: AWSがサブネットの設定に基づいてデフォルト値を決定
  # 注意: IPv6専用サブネットではresource-nameのみ使用可能
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-naming.html
  private_dns_hostname_type_on_launch = null

  #-------------------------------------------------------------
  # Outpost設定
  #-------------------------------------------------------------

  # outpost_arn (Optional)
  # 設定内容: Outpostのサブネットを作成する場合のOutpostのARNを指定します。
  # 設定可能な値: 有効なAWS OutpostのARN
  # 省略時: Outpostを使用しない通常のサブネットを作成
  # 参考: https://docs.aws.amazon.com/outposts/latest/userguide/what-is-outposts.html
  outpost_arn = null

  # customer_owned_ipv4_pool (Optional)
  # 設定内容: カスタマー所有のIPv4アドレスプールを指定します（Outpost用）。
  # 設定可能な値: 有効なカスタマー所有IPv4アドレスプールID
  # 注意: outpost_arn と map_customer_owned_ip_on_launch = true の指定が必要
  customer_owned_ipv4_pool = null

  # map_customer_owned_ip_on_launch (Optional)
  # 設定内容: サブネットで作成されるネットワークインターフェースにカスタマー所有のIPv4アドレスを割り当てるかを指定します。
  # 設定可能な値:
  #   - true: カスタマー所有のIPv4アドレスを自動割り当て
  #   - false (デフォルト): カスタマー所有のIPv4アドレスを自動割り当てしない
  # 注意: customer_owned_ipv4_pool と outpost_arn の指定が必要
  map_customer_owned_ip_on_launch = false

  #-------------------------------------------------------------
  # ローカルネットワークインターフェース設定
  #-------------------------------------------------------------

  # enable_lni_at_device_index (Optional)
  # 設定内容: このサブネット内のローカルネットワークインターフェースのデバイス位置を指定します。
  # 設定可能な値: デバイスインデックスを示す数値（例: 1はセカンダリネットワークインターフェース eth1 を示す）
  # 省略時: ローカルネットワークインターフェース機能を使用しない
  # 注意: ローカルネットワークインターフェースはプライマリネットワークインターフェース（eth0）にはなれない
  enable_lni_at_device_index = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-subnet"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  # 注意: Lambda関数が関連付けられているサブネットの削除には最大45分かかる場合があります
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html
  timeouts {

    # create (Optional)
    # 設定内容: サブネット作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "10m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "10m"

    # delete (Optional)
    # 設定内容: サブネット削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "20m", "45m"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    # 注意: Lambda関数が関連付けられている場合、削除に最大45分かかることがあるため "45m" の設定を推奨
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サブネットのID
# - arn: サブネットのAmazon Resource Name (ARN)
# - ipv6_cidr_block_association_id: IPv6 CIDRブロックの関連付けID
# - owner_id: サブネットを所有するAWSアカウントのID
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
