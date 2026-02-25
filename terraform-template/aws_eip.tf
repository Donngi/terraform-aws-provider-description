#-----------------------------------------------------------------------
# AWS Elastic IP (EIP)
#-----------------------------------------------------------------------
#
# Elastic IPアドレスを作成・管理するリソースです。
# EC2インスタンス、ネットワークインターフェース、NAT Gatewayなどに関連付けて使用します。
# VPC内での使用にはdomain = "vpc"の指定が必要です。
#
# AWS公式ドキュメント:
#   - Elastic IP アドレス: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html
#   - AssociateAddress API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AssociateAddress.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
#
# NOTE:
#   - EIPの関連付けにはInternet Gatewayが必要な場合があるため、depends_onで明示的な依存関係を設定すること
#   - aws_lbやaws_nat_gatewayへの関連付けにはnetwork_interfaceを使わず、それらのリソースのallocation_idを使用すること
#   - instanceとnetwork_interfaceは同時に指定できない（同時指定するとエラーにはならないが動作が不定）
#   - public_ipv4_poolとaddressを同時に指定した場合、addressのみが使用される
#-----------------------------------------------------------------------

resource "aws_eip" "example" {
  #-----------------------------------------------------------------------
  # リソース識別・配置
  #-----------------------------------------------------------------------

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダーで設定されたリージョンが使用される
  region = null

  #-----------------------------------------------------------------------
  # IPアドレス割り当て
  #-----------------------------------------------------------------------

  # 設定内容: BYOIPプールから割り当てる特定のIPアドレス
  # 設定可能な値: EC2 BYOIPプールに登録済みのIPアドレス
  # 省略時: プールから自動的に新しいIPアドレスが割り当てられる
  # 備考: VPC EIPでのみ使用可能
  address = null

  # 設定内容: IPアドレスを割り当てるIPv4プールのID
  # 設定可能な値: IPAMプールID（例: ipam-pool-xxxxxxxxx）
  # 省略時: 使用されない
  # 備考: IPAMを使用してIPアドレスを管理する場合に指定
  ipam_pool_id = null

  # 設定内容: EC2 IPv4アドレスプールの識別子
  # 設定可能な値: BYOIPプールID（例: ipv4pool-ec2-xxxxxx）または "amazon"
  # 省略時: AWSの標準パブリックIPv4プールが使用される
  # 備考: VPC EIPでのみ使用可能。addressとの併用時はaddressが優先される
  public_ipv4_pool = null

  # 設定内容: カスタマー所有のIPv4プールID
  # 設定可能な値: カスタマー所有IPプールのID
  # 省略時: 使用されない
  # 備考: AWS Outpostsでカスタマー所有IPアドレスを使用する場合に指定
  customer_owned_ipv4_pool = null

  #-----------------------------------------------------------------------
  # ネットワークドメイン設定
  #-----------------------------------------------------------------------

  # 設定内容: EIPをVPCで使用するかどうかを指定
  # 設定可能な値: "vpc"
  # 省略時: 計算される（EC2-Classicが使用可能な場合を除き、通常は"vpc"）
  # 備考: VPC内でのEIP使用時は明示的に"vpc"を指定することを推奨
  domain = "vpc"

  # 設定内容: IPアドレスをアドバタイズする場所（ネットワーク境界グループ）
  # 設定可能な値: ネットワーク境界グループ名（例: us-west-2-lax-1）
  # 省略時: リージョンのデフォルトネットワーク境界グループが使用される
  # 備考: Wavelengthゾーンなど特定の場所でIPを使用する場合に指定
  network_border_group = null

  #-----------------------------------------------------------------------
  # リソース関連付け
  #-----------------------------------------------------------------------

  # 設定内容: 関連付けるEC2インスタンスID
  # 設定可能な値: EC2インスタンスID（例: i-xxxxxxxxx）
  # 省略時: EIPのみ割り当てられ、インスタンスとは関連付けられない
  # 備考: network_interfaceと同時に指定できない
  instance = null

  # 設定内容: 関連付けるネットワークインターフェースID
  # 設定可能な値: ネットワークインターフェースID（例: eni-xxxxxxxxx）
  # 省略時: EIPのみ割り当てられ、ネットワークインターフェースとは関連付けられない
  # 備考: instanceと同時に指定できない。aws_lbやaws_nat_gatewayへの関連付けには使用しない
  network_interface = null

  # 設定内容: EIPを関連付けるプライベートIPアドレス
  # 設定可能な値: プライマリまたはセカンダリプライベートIPアドレス
  # 省略時: プライマリプライベートIPアドレスに関連付けられる
  # 備考: 1つのネットワークインターフェースに複数のEIPを関連付ける場合に使用
  associate_with_private_ip = null

  #-----------------------------------------------------------------------
  # タグ
  #-----------------------------------------------------------------------

  # 設定内容: リソースに割り当てるタグのマップ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されない
  # 備考: VPC EIPにのみタグを適用可能
  tags = {
    Name        = "example-eip"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-----------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------

  # 設定内容: 削除操作のタイムアウト時間
  # 設定可能な値: 時間文字列（例: "5m", "1h"）
  # 省略時: デフォルトのタイムアウト設定が使用される
  # timeouts {
  #   delete = "5m"
  # }

  # 設定内容: 読み取り操作のタイムアウト時間
  # 設定可能な値: 時間文字列（例: "5m", "1h"）
  # 省略時: デフォルトのタイムアウト設定が使用される
  # timeouts {
  #   read = "5m"
  # }

  # 設定内容: 更新操作のタイムアウト時間
  # 設定可能な値: 時間文字列（例: "5m", "1h"）
  # 省略時: デフォルトのタイムアウト設定が使用される
  # timeouts {
  #   update = "5m"
  # }
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# このリソースが公開する属性の参照方法
#
# - allocation_id: VPC内のインスタンスで使用するためのEIP割り当てID
#   aws_eip.example.allocation_id
#
# - association_id: VPC内のインスタンスとの関連付けを表すID
#   aws_eip.example.association_id
#
# - carrier_ip: キャリアIPアドレス
#   aws_eip.example.carrier_ip
#
# - customer_owned_ip: カスタマー所有IPアドレス
#   aws_eip.example.customer_owned_ip
#
# - id: EIP割り当てIDを含む
#   aws_eip.example.id
#
# - private_dns: プライベートDNS（VPC内の場合）
#   aws_eip.example.private_dns
#
# - private_ip: プライベートIPアドレス（VPC内の場合）
#   aws_eip.example.private_ip
#
# - ptr_record: IPアドレスのDNSポインタ（PTR）レコード
#   aws_eip.example.ptr_record
#
# - public_dns: パブリックDNS
#   aws_eip.example.public_dns
#
# - public_ip: パブリックIPアドレス
#   aws_eip.example.public_ip
