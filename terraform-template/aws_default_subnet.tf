#---------------------------------------------------------------
# AWS Default Subnet
#---------------------------------------------------------------
#
# VPCのデフォルトサブネットを管理するリソースです。
# VPC作成時に自動生成されるデフォルトサブネットを明示的に管理し、設定を変更します。
# デフォルトサブネットは削除してもVPCが再作成されるまで残るため、force_destroyで削除可能です。
#
# 主な用途:
#   - デフォルトVPCのデフォルトサブネット設定の明示的な管理
#   - パブリックIPアドレス自動割り当ての制御
#   - IPv6設定の追加
#   - DNS設定のカスタマイズ
#
# 注意事項:
#   - デフォルトサブネットは各アベイラビリティゾーンに1つのみ存在
#   - 通常のサブネット作成とは異なり、既存のデフォルトサブネットをTerraformで管理下に置く
#   - デフォルトVPCが削除されている場合は使用不可
#   - CIDRブロックは変更不可（デフォルト値が使用される）
#
# AWS公式ドキュメント:
#   - デフォルトVPCとデフォルトサブネット: https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html
#   - サブネットの基本: https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_subnet
#
# Provider Version: 6.28.0
# Generated: 2026-02-14
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
  # 設定可能な値: ap-northeast-1a, ap-northeast-1c, ap-northeast-1d など
  # 注意: デフォルトVPC内の各AZに対して1つのデフォルトサブネットが存在します。
  #       リソース作成後の変更はできません（Forces new resource）
  availability_zone = "ap-northeast-1a"

  #-------------------------------------------------------------
  # IPアドレス設定
  #-------------------------------------------------------------

  # assign_ipv6_address_on_creation (Optional)
  # 設定内容: サブネット内で起動するインスタンスにIPv6アドレスを自動的に割り当てるかどうかを指定します。
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: false
  # 関連機能: IPv6アドレス割り当て
  #   VPC内で起動するインスタンスにIPv6アドレスを自動的に割り当てる機能です。
  #   IPv6通信を有効にする場合に設定します。
  assign_ipv6_address_on_creation = false

  # map_public_ip_on_launch (Optional)
  # 設定内容: サブネット内で起動するインスタンスにパブリックIPv4アドレスを自動的に割り当てるかどうかを指定します。
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: true（デフォルトサブネットの場合）
  # 関連機能: パブリックIPアドレス自動割り当て
  #   デフォルトサブネットはデフォルトでパブリックIPアドレスを自動割り当てします。
  #   プライベートサブネットとして使用する場合はfalseに設定します。
  map_public_ip_on_launch = true

  # ipv6_cidr_block (Optional)
  # 設定内容: サブネットに関連付けるIPv6 CIDRブロックを指定します。
  # 設定可能な値: VPCのIPv6 CIDRブロックの/64サブネット
  # 省略時: 割り当てなし
  # 関連機能: IPv6 CIDRブロック
  #   IPv6通信を有効にする場合に設定します。
  #   VPCにIPv6 CIDRブロックが割り当てられている必要があります。
  ipv6_cidr_block = null

  #-------------------------------------------------------------
  # DNS設定
  #-------------------------------------------------------------

  # enable_dns64 (Optional)
  # 設定内容: DNS64変換を有効にするかどうかを指定します。
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: false
  # 関連機能: DNS64変換
  #   IPv6専用サブネットでIPv4リソースへのアクセスを可能にする機能です。
  #   IPv6専用サブネット（ipv6_native=true）で使用します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html#nat-gateway-nat64-dns64
  enable_dns64 = false

  # enable_resource_name_dns_a_record_on_launch (Optional)
  # 設定内容: リソース名のDNS Aレコードを自動作成するかどうかを指定します。
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: false
  # 関連機能: リソース名DNS自動登録
  #   EC2インスタンスのホスト名からIPv4アドレスを解決可能にする機能です。
  #   Private Hosted Zoneへの自動DNS登録を有効にします。
  enable_resource_name_dns_a_record_on_launch = false

  # enable_resource_name_dns_aaaa_record_on_launch (Optional)
  # 設定内容: リソース名のDNS AAAAレコードを自動作成するかどうかを指定します。
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: false
  # 関連機能: リソース名DNS自動登録（IPv6）
  #   EC2インスタンスのホスト名からIPv6アドレスを解決可能にする機能です。
  #   IPv6環境でPrivate Hosted Zoneへの自動DNS登録を有効にします。
  enable_resource_name_dns_aaaa_record_on_launch = false

  # private_dns_hostname_type_on_launch (Optional)
  # 設定内容: 起動時に割り当てるプライベートDNSホスト名のタイプを指定します。
  # 設定可能な値:
  #   - "ip-name": IPアドレスベースのホスト名（例: ip-10-0-1-5.ec2.internal）
  #   - "resource-name": リソース名ベースのホスト名（例: i-0123456789abcdef0.ec2.internal）
  # 省略時: "ip-name"
  # 関連機能: プライベートDNSホスト名
  #   インスタンスに割り当てられるプライベートDNSホスト名の形式を指定します。
  #   リソース名ベースのホスト名は、インスタンスIDからDNS解決が可能になります。
  private_dns_hostname_type_on_launch = "ip-name"

  #-------------------------------------------------------------
  # Outposts設定
  #-------------------------------------------------------------

  # customer_owned_ipv4_pool (Optional)
  # 設定内容: カスタマー所有IPv4プールを指定します。
  # 設定可能な値: カスタマー所有IPプールのID（例: ipv4pool-coip-xxxxxxxx）
  # 省略時: 使用しない
  # 関連機能: AWS Outposts カスタマー所有IP
  #   AWS Outposts環境でカスタマー所有のIPアドレスを使用する場合に指定します。
  #   Outpostsサブネットでのみ使用可能です。
  #   - https://docs.aws.amazon.com/outposts/latest/userguide/how-outposts-works.html
  customer_owned_ipv4_pool = null

  # map_customer_owned_ip_on_launch (Optional)
  # 設定内容: カスタマー所有IPアドレスを自動的に割り当てるかどうかを指定します。
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: false
  # 関連機能: Outposts カスタマー所有IP自動割り当て
  #   Outposts環境でカスタマー所有IPアドレスを自動的に割り当てる機能です。
  #   customer_owned_ipv4_poolと組み合わせて使用します。
  map_customer_owned_ip_on_launch = false

  #-------------------------------------------------------------
  # IPv6専用設定
  #-------------------------------------------------------------

  # ipv6_native (Optional)
  # 設定内容: IPv6専用サブネットとして設定するかどうかを指定します。
  # 設定可能な値: true（IPv6のみ）, false（デュアルスタック）
  # 省略時: false
  # 関連機能: IPv6専用サブネット
  #   IPv4アドレスを使用せず、IPv6のみで動作するサブネットとして構成します。
  #   IPv6ネイティブVPCで使用します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ipv6.html
  ipv6_native = false

  #-------------------------------------------------------------
  # リソース管理設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: デフォルトサブネットを強制的に削除するかどうかを指定します。
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: false
  # 関連機能: デフォルトサブネット削除
  #   Terraform destroyでデフォルトサブネットを実際に削除します。
  #   falseの場合は、Terraformの管理下から削除されるのみで、サブネット自体は残ります。
  #   注意: デフォルトサブネットの削除は慎重に行ってください。
  force_destroy = false

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
    Name        = "default-subnet-ap-northeast-1a"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: サブネット作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: 10m
    create = "10m"

    # delete (Optional)
    # 設定内容: サブネット削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "20m", "1h"）
    # 省略時: 20m
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サブネットID（subnet-xxxxx形式）
# - arn: サブネットのARN
# - vpc_id: 所属するVPCのID
# - cidr_block: サブネットのIPv4 CIDRブロック
# - availability_zone_id: アベイラビリティゾーンのID
# - ipv6_cidr_block_association_id: IPv6 CIDRブロックの関連付けID
# - outpost_arn: OutpostsのARN（Outposts環境の場合）
# - owner_id: サブネットを所有するAWSアカウントID
# - enable_lni_at_device_index: LNI（Local Network Interface）のデバイスインデックス
# - existing_default_subnet: 既存のデフォルトサブネットかどうか
# - tags_all: リソースに割り当てられた全タグ（デフォルトタグを含む）
