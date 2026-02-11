#---------------------------------------------------------------
# VPC Subnet
#---------------------------------------------------------------
#
# Amazon VPCのサブネットをプロビジョニングするリソースです。
# サブネットは、VPC内のIPアドレス範囲であり、EC2インスタンスなどのAWSリソースを
# 起動するために使用されます。各サブネットは単一のアベイラビリティゾーン内に
# 完全に存在する必要があります。
#
# AWS公式ドキュメント:
#   - Subnets for your VPC: https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
#   - Subnet CIDR blocks: https://docs.aws.amazon.com/vpc/latest/userguide/subnet-sizing.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_subnet" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: サブネットを作成するVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-12345678）
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
  vpc_id = "vpc-12345678"

  #-------------------------------------------------------------
  # IPv4 CIDR設定
  #-------------------------------------------------------------

  # cidr_block (Optional)
  # 設定内容: サブネットのIPv4 CIDRブロックを指定します。
  # 設定可能な値: VPCのCIDRブロックと同じか、そのサブセット。
  #              サイズは/28～/16のネットマスク（16～65,536個のIPアドレス）
  # 注意: VPC内の他のサブネットと重複できません。
  #      各サブネットで5個のIPアドレスが予約されます（ネットワークアドレス、
  #      VPCルーター用、DNS用、将来の利用用2個）
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/subnet-sizing.html
  cidr_block = "10.0.1.0/24"

  #-------------------------------------------------------------
  # IPv6 CIDR設定
  #-------------------------------------------------------------

  # ipv6_cidr_block (Optional)
  # 設定内容: サブネットのIPv6ネットワーク範囲をCIDR表記で指定します。
  # 設定可能な値: /64プレフィックス長を使用するIPv6 CIDR
  # 注意: 既存のIPv6サブネットが assign_ipv6_address_on_creation = true で
  #      作成されている場合、この値を変更するとリソースが再作成されます。
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/subnet-sizing.html
  ipv6_cidr_block = null

  # ipv6_native (Optional)
  # 設定内容: IPv6専用サブネットを作成するかを指定します。
  # 設定可能な値:
  #   - true: IPv6専用サブネットを作成
  #   - false (デフォルト): IPv4またはデュアルスタックサブネット
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
  ipv6_native = false

  # assign_ipv6_address_on_creation (Optional)
  # 設定内容: サブネット内に作成されたネットワークインターフェースに
  #          IPv6アドレスを自動割り当てするかを指定します。
  # 設定可能な値:
  #   - true: IPv6アドレスを自動割り当て
  #   - false (デフォルト): 自動割り当てしない
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
  assign_ipv6_address_on_creation = false

  #-------------------------------------------------------------
  # アベイラビリティゾーン設定
  #-------------------------------------------------------------

  # availability_zone (Optional)
  # 設定内容: サブネットを配置するアベイラビリティゾーン（AZ）を指定します。
  # 設定可能な値: 有効なAZ名（例: ap-northeast-1a, us-east-1b）
  # 注意: availability_zone_idとは排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
  availability_zone = "ap-northeast-1a"

  # availability_zone_id (Optional)
  # 設定内容: サブネットを配置するアベイラビリティゾーンのIDを指定します。
  # 設定可能な値: 有効なAZ ID（例: apne1-az1）
  # 注意: すべてのリージョンやパーティションでサポートされていません。
  #      必要に応じて availability_zone を使用してください。
  #      availability_zoneとは排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
  availability_zone_id = null

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
  # パブリックIP設定
  #-------------------------------------------------------------

  # map_public_ip_on_launch (Optional)
  # 設定内容: サブネット内に起動されたインスタンスにパブリックIPアドレスを
  #          自動的に割り当てるかを指定します。
  # 設定可能な値:
  #   - true: パブリックIPを自動割り当て（パブリックサブネット用）
  #   - false (デフォルト): 自動割り当てしない（プライベートサブネット用）
  # 用途: インターネットゲートウェイへの直接ルートを持つパブリックサブネットで使用
  # 参考: https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
  map_public_ip_on_launch = false

  #-------------------------------------------------------------
  # DNS設定
  #-------------------------------------------------------------

  # enable_dns64 (Optional)
  # 設定内容: このサブネット内のAmazon提供DNSリゾルバーへのDNSクエリが、
  #          IPv4専用の宛先に対して合成IPv6アドレスを返すかを指定します。
  # 設定可能な値:
  #   - true: DNS64を有効化（IPv6からIPv4リソースへのアクセスを可能に）
  #   - false (デフォルト): DNS64を無効化
  # 関連機能: DNS64
  #   IPv6専用サブネット内のリソースがIPv4専用サービスと通信できるようにします。
  #   参考: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html#nat-gateway-nat64-dns64
  enable_dns64 = false

  # private_dns_hostname_type_on_launch (Optional)
  # 設定内容: サブネット内に起動されたインスタンスに割り当てるホスト名のタイプを指定します。
  # 設定可能な値:
  #   - "ip-name": インスタンスのIPv4アドレスに基づくDNS名
  #   - "resource-name": インスタンスIDに基づくDNS名
  # 注意: IPv6専用サブネットの場合、インスタンスDNS名は必ずインスタンスIDに基づきます。
  #      デュアルスタックおよびIPv4専用サブネットの場合、DNS名にIPv4アドレスまたは
  #      インスタンスIDのどちらを使用するかを選択できます。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_PrivateDnsNameOptionsOnLaunch.html
  private_dns_hostname_type_on_launch = null

  # enable_resource_name_dns_a_record_on_launch (Optional)
  # 設定内容: インスタンスホスト名に対するDNSクエリにDNS Aレコードで応答するかを指定します。
  # 設定可能な値:
  #   - true: DNS Aレコードで応答（IPv4アドレスを返す）
  #   - false (デフォルト): DNS Aレコードで応答しない
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_PrivateDnsNameOptionsOnLaunch.html
  enable_resource_name_dns_a_record_on_launch = false

  # enable_resource_name_dns_aaaa_record_on_launch (Optional)
  # 設定内容: インスタンスホスト名に対するDNSクエリにDNS AAAAレコードで応答するかを指定します。
  # 設定可能な値:
  #   - true: DNS AAAAレコードで応答（IPv6アドレスを返す）
  #   - false (デフォルト): DNS AAAAレコードで応答しない
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_PrivateDnsNameOptionsOnLaunch.html
  enable_resource_name_dns_aaaa_record_on_launch = false

  #-------------------------------------------------------------
  # AWS Outposts設定
  #-------------------------------------------------------------

  # outpost_arn (Optional)
  # 設定内容: AWS OutpostsのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なOutpost ARN
  # 用途: Outpost上にサブネットを作成する場合に指定します。
  # 参考: https://docs.aws.amazon.com/outposts/latest/userguide/what-is-outposts.html
  outpost_arn = null

  # enable_lni_at_device_index (Optional)
  # 設定内容: このサブネット内のローカルネットワークインターフェース（LNI）の
  #          デバイス位置を示す番号を指定します。
  # 設定可能な値: 数値（例: 1はセカンダリネットワークインターフェース(eth1)を示す）
  # 注意: ローカルネットワークインターフェースは、プライマリネットワーク
  #      インターフェース（eth0）にはなれません。
  # 関連機能: Local Network Interfaces for Outposts
  #   Outpostsサーバー上のEC2インスタンスをオンプレミスネットワークに
  #   直接接続するための論理ネットワークコンポーネント。
  #   参考: https://docs.aws.amazon.com/outposts/latest/server-userguide/local-network-interface.html
  enable_lni_at_device_index = null

  # customer_owned_ipv4_pool (Optional)
  # 設定内容: カスタマー所有のIPv4アドレスプールを指定します。
  # 設定可能な値: 有効なカスタマー所有IPプールID
  # 用途: map_customer_owned_ip_on_launch引数と組み合わせて使用します。
  # 注意: outpost_arn引数が指定されている必要があります。
  # 関連機能: Customer-owned IP addresses (CoIP)
  #   Outpost上のリソースに対してカスタマー所有のIPアドレスを割り当て、
  #   オンプレミスネットワークとの通信を可能にします。
  #   参考: https://docs.aws.amazon.com/outposts/latest/network-userguide/outposts-rack2ndgen-local-rack.html
  customer_owned_ipv4_pool = null

  # map_customer_owned_ip_on_launch (Optional)
  # 設定内容: サブネット内に作成されたネットワークインターフェースに
  #          カスタマー所有のIPアドレスを割り当てるかを指定します。
  # 設定可能な値:
  #   - true: カスタマー所有IPを割り当て
  #   - false (デフォルト): 割り当てない
  # 注意: customer_owned_ipv4_poolとoutpost_arn引数が指定されている必要があります。
  # 参考: https://docs.aws.amazon.com/outposts/latest/network-userguide/outposts-rack2ndgen-local-rack.html
  map_customer_owned_ip_on_launch = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   参考: https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
  tags = {
    Name        = "example-subnet"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除のタイムアウト時間を指定します。
  # 注意: AWS Lambdaに関連付けられたサブネットは、削除に最大45分かかる場合があります。
  #      2019年9月以降のLambda VPCネットワーク改善により、サブネット削除に時間が
  #      かかる場合があります。
  #      参考: https://aws.amazon.com/blogs/compute/announcing-improved-vpc-networking-for-aws-lambda-functions/
  timeouts {
    # create (Optional)
    # 設定内容: サブネット作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を示す文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    create = null

    # delete (Optional)
    # 設定内容: サブネット削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間を示す文字列（例: "45m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    # 推奨: Lambda関連サブネットの場合は "45m" を設定
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サブネットのID
#
# - arn: サブネットのAmazon Resource Name (ARN)
#
# - ipv6_cidr_block_association_id: IPv6 CIDRブロックの関連付けID
#
# - owner_id: サブネットを所有するAWSアカウントのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
