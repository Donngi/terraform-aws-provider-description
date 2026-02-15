#---------------------------------------
# AWS Direct Connect ホステッド Transit 仮想インターフェイス
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_hosted_transit_virtual_interface
#
# ユースケース:
# - パートナーが提供する Direct Connect 接続上に Transit 仮想インターフェイスを作成
# - 複数の VPC を Transit Gateway 経由で接続するための仮想インターフェイス
# - 他の AWS アカウントのために仮想インターフェイスを割り当て
#
# NOTE:
# - ホステッド仮想インターフェイスは別の AWS アカウントによって受け入れられる必要がある
# - Transit Gateway と Direct Connect Gateway は異なる ASN を持つ必要がある
# - VLAN ID は Direct Connect 接続内で一意である必要がある
# - MTU は 1500 または 8500（ジャンボフレーム）をサポート
#---------------------------------------

resource "aws_dx_hosted_transit_virtual_interface" "example" {
  #---------------------------------------
  # 接続設定
  #---------------------------------------
  # 設定内容: このホステッド仮想インターフェイスを作成する Direct Connect 接続の ID
  # 必須項目: この接続上に仮想インターフェイスが作成される
  # 形式: dxcon-xxxxxxxx
  connection_id = "dxcon-12345678"

  #---------------------------------------
  # 所有者設定
  #---------------------------------------
  # 設定内容: この仮想インターフェイスを所有する AWS アカウント ID
  # 必須項目: 仮想インターフェイスを割り当てる先のアカウント
  # 形式: 12桁の数字
  owner_account_id = "123456789012"

  #---------------------------------------
  # 仮想インターフェイス基本設定
  #---------------------------------------
  # 設定内容: 仮想インターフェイスの名前
  # 必須項目: 識別のための名前
  name = "example-transit-vif"

  # 設定内容: VLAN ID
  # 必須項目: 802.1Q タグ付けに使用される VLAN 番号
  # 設定可能な値: 1-4094
  # 注意: Direct Connect 接続内で一意である必要がある
  vlan = 100

  #---------------------------------------
  # BGP 設定
  #---------------------------------------
  # 設定内容: Border Gateway Protocol の Autonomous System Number
  # 必須項目: オンプレミスルーターの BGP ASN
  # 設定可能な値: 1-2147483647（パブリック ASN）または 64512-65534（プライベート ASN）
  # 注意: Transit Gateway および Direct Connect Gateway と異なる ASN を使用する必要がある
  bgp_asn = 65000

  # 設定内容: BGP ピア接続で使用する IP アドレスファミリー
  # 必須項目: IPv4 または IPv6 を選択
  # 設定可能な値: ipv4 | ipv6
  address_family = "ipv4"

  # 設定内容: BGP セッションの認証キー
  # 省略時: AWS が自動生成
  # 形式: MD5 ハッシュキー
  bgp_auth_key = null

  #---------------------------------------
  # IP アドレス設定（IPv4）
  #---------------------------------------
  # 設定内容: AWS 側の BGP ピア IP アドレス
  # 省略時: address_family が ipv4 の場合は AWS が自動割り当て
  # 形式: IPv4 CIDR（/30 または /31）
  amazon_address = null

  # 設定内容: カスタマー側の BGP ピア IP アドレス
  # 省略時: address_family が ipv4 の場合は AWS が自動割り当て
  # 形式: IPv4 CIDR（/30 または /31）
  customer_address = null

  #---------------------------------------
  # ネットワーク設定
  #---------------------------------------
  # 設定内容: 最大伝送単位（Maximum Transmission Unit）
  # 省略時: 1500
  # 設定可能な値: 1500 | 8500（ジャンボフレーム）
  # 注意: MTU を変更すると最大30秒間ネットワーク接続が中断される
  mtu = null

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: このリソースを管理するリージョン
  # 省略時: プロバイダー設定のリージョン
  # 注意: Direct Connect リソースはグローバルリソースだがリージョン指定が可能
  region = null

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------
  timeouts {
    # 設定内容: 仮想インターフェイス作成のタイムアウト時間
    # 省略時: 10分
    # create = "10m"

    # 設定内容: 仮想インターフェイス削除のタイムアウト時間
    # 省略時: 10分
    # delete = "10m"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースから参照できる属性:
# - id                  : 仮想インターフェイスの ID（例: dxvif-xxxxxxxx）
# - arn                 : 仮想インターフェイスの ARN
# - amazon_address      : AWS 側の BGP ピア IP アドレス
# - amazon_side_asn     : AWS 側の BGP ASN
# - aws_device          : Direct Connect エンドポイントのデバイス ID
# - bgp_auth_key        : BGP 認証キー（設定された場合）
# - customer_address    : カスタマー側の BGP ピア IP アドレス
# - jumbo_frame_capable : ジャンボフレーム（8500 MTU）のサポート有無
# - region              : リソースが管理されているリージョン
