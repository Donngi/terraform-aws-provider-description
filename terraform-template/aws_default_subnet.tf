#---------------------------------------------------------------
# AWS Default Subnet
#---------------------------------------------------------------
#
# 指定したアベイラビリティゾーンのデフォルトサブネットを管理するリソースです。
#
# このリソースは高度な使用を想定しており、特別な注意事項があります:
# - 指定されたアベイラビリティゾーンにデフォルトサブネットが既に存在する場合、
#   Terraformはそれを「採用」して管理下に置きます（新規作成ではありません）
# - デフォルトサブネットが存在しない場合、Terraformは新しいデフォルトサブネットを作成します
# - デフォルトでは、terraform destroyはデフォルトサブネットを削除せず、
#   Terraformの状態から削除するだけです
# - force_destroy引数をtrueに設定すると、デフォルトサブネットを削除します
#
# AWS公式ドキュメント:
#   - Default VPC: https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html
#   - Subnets: https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
#   - DNS64/NAT64: https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-nat64-dns64.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_subnet
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_default_subnet" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # availability_zone (Required)
  # 設定内容: デフォルトサブネットを管理するアベイラビリティゾーンを指定します。
  # 設定可能な値: 有効なアベイラビリティゾーン名（例: us-west-2a, ap-northeast-1a）
  # 注意: リソース作成後の変更はできません（Forces new resource）
  availability_zone = "ap-northeast-1a"

  #-------------------------------------------------------------
  # IPv4設定
  #-------------------------------------------------------------

  # map_public_ip_on_launch (Optional)
  # 設定内容: このサブネットで起動されたインスタンスにパブリックIPアドレスを自動割り当てするかを指定します。
  # 設定可能な値: true | false
  # 省略時: デフォルトVPCサブネットのデフォルト値（通常true）
  # 関連機能: EC2インスタンスのパブリックIPアドレス
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ip-addressing.html
  map_public_ip_on_launch = true

  # customer_owned_ipv4_pool (Optional)
  # 設定内容: カスタマー所有のIPv4アドレスプールを指定します。
  # 設定可能な値: カスタマー所有IPv4プールのID（例: ipv4pool-coip-xxxxxxxx）
  # 注意: AWS OutpostsまたはLocal Zones環境でのみ使用可能
  # 関連機能: Customer-owned IP addresses
  #   - https://docs.aws.amazon.com/outposts/latest/userguide/outposts-networking-components.html
  customer_owned_ipv4_pool = null

  # map_customer_owned_ip_on_launch (Optional)
  # 設定内容: このサブネットで起動されたインスタンスにカスタマー所有IPアドレスを自動割り当てするかを指定します。
  # 設定可能な値: true | false
  # 省略時: false
  # 注意: customer_owned_ipv4_poolと一緒に使用します。AWS OutpostsまたはLocal Zones環境でのみ使用可能。
  map_customer_owned_ip_on_launch = null

  #-------------------------------------------------------------
  # IPv6設定
  #-------------------------------------------------------------

  # assign_ipv6_address_on_creation (Optional)
  # 設定内容: このサブネットで作成されたネットワークインターフェースにIPv6アドレスを自動割り当てするかを指定します。
  # 設定可能な値: true | false
  # 省略時: false
  # 関連機能: IPv6 on AWS
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ip-addressing.html
  assign_ipv6_address_on_creation = null

  # ipv6_cidr_block (Optional)
  # 設定内容: サブネットに関連付けるIPv6 CIDRブロックを指定します。
  # 設定可能な値: /64プレフィックスのIPv6 CIDRブロック（例: 2001:db8:1234:1a00::/64）
  # 注意: VPCにIPv6 CIDRブロックが関連付けられている必要があります
  # 関連機能: VPC CIDR blocks
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html
  ipv6_cidr_block = null

  # ipv6_native (Optional)
  # 設定内容: IPv6専用サブネットとして作成するかを指定します。
  # 設定可能な値: true | false
  # 省略時: false
  # 注意: trueに設定すると、このサブネット内のインスタンスはIPv6アドレスのみを持ちます
  # 関連機能: IPv6-only subnets
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/how-it-works.html#vpc-ip-addressing
  ipv6_native = null

  # enable_dns64 (Optional)
  # 設定内容: DNS64を有効にするかを指定します。
  # 設定可能な値: true | false
  # 省略時: false
  # 関連機能: DNS64 and NAT64
  #   DNS64はIPv6専用ワークロードがIPv4リソースと通信できるようにするDNS拡張機能です。
  #   Route 53 ResolverがIPv4アドレスをIPv6アドレスに変換し、NAT64経由でトラフィックをルーティングします。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-nat64-dns64.html
  enable_dns64 = null

  #-------------------------------------------------------------
  # DNSホスト名設定
  #-------------------------------------------------------------

  # enable_resource_name_dns_a_record_on_launch (Optional)
  # 設定内容: このサブネットで起動されたEC2インスタンスのリソース名DNSにAレコードを作成するかを指定します。
  # 設定可能な値: true | false
  # 省略時: false
  # 関連機能: EC2 Instance hostname types
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-naming.html
  enable_resource_name_dns_a_record_on_launch = null

  # enable_resource_name_dns_aaaa_record_on_launch (Optional)
  # 設定内容: このサブネットで起動されたEC2インスタンスのリソース名DNSにAAAAレコードを作成するかを指定します。
  # 設定可能な値: true | false
  # 省略時: false
  # 関連機能: EC2 Instance hostname types
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-naming.html
  enable_resource_name_dns_aaaa_record_on_launch = null

  # private_dns_hostname_type_on_launch (Optional)
  # 設定内容: このサブネットで起動されたEC2インスタンスのプライベートDNSホスト名タイプを指定します。
  # 設定可能な値:
  #   - "ip-name": IPベースの名前（例: ip-10-24-34-0.ec2.internal）
  #   - "resource-name": リソースベースの名前（例: i-0123456789abcdef.ec2.internal）
  # 省略時: VPCのデフォルト設定に従う
  # 関連機能: EC2 Instance hostname types
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-naming.html
  private_dns_hostname_type_on_launch = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # リソース管理設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: terraform destroyの実行時にデフォルトサブネットを削除するかを指定します。
  # 設定可能な値: true | false
  # 省略時: false
  # 注意:
  #   - false（デフォルト）: terraform destroyはTerraformの状態からリソースを削除するだけで、
  #     実際のデフォルトサブネットは削除されません
  #   - true: terraform destroy実行時に実際のデフォルトサブネットを削除します
  force_destroy = false

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
    Name        = "Default subnet for ap-northeast-1a"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #          リソースに割り当てるすべてのタグのマップです。
  # 注意: 通常は直接設定せず、tagsとdefault_tagsから自動計算されます。
  #       明示的に設定する場合は、default_tagsとの競合に注意してください。
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: サブネットのID
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します。
  id = null

  #-------------------------------------------------------------
  # Timeouts設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を設定します。
  # 関連: Terraform timeouts
  #   - https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    create = "10m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "20m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: サブネットのAmazon Resource Name (ARN)
#
# - availability_zone_id: サブネットのアベイラビリティゾーンID（例: apne1-az1）
#
# - cidr_block: サブネットに割り当てられたIPv4 CIDRブロック
#
# - enable_lni_at_device_index: ローカルネットワークインターフェースが有効なデバイスインデックス
#
# - existing_default_subnet: Terraformがこのリソースを管理する際に、
#                            既存のデフォルトサブネットを採用したかどうかを示します
#
# - id: サブネットID
#
# - ipv6_cidr_block_association_id: IPv6 CIDRブロックとサブネットの関連付けID
#
# - outpost_arn: サブネットが配置されているOutpostのARN（Outpostsの場合）
#
# - owner_id: サブネットを所有するAWSアカウントID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - vpc_id: サブネットが属するVPCのID
#---------------------------------------------------------------
