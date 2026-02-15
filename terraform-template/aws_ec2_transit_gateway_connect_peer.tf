#-----------------------------------------------------------------------
# Transit Gateway Connect Peer
#-----------------------------------------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-15
#
# 用途: Transit Gateway Connect AttachmentにBGPピアを作成し、
#       サードパーティ製仮想アプライアンス（SD-WAN等）との
#       GREトンネル接続を確立します。
#
# 主な機能:
# - GREトンネルによるTransit Gatewayとアプライアンス間の接続
# - BGPを使用した動的ルーティングとヘルスチェック
# - IPv4/IPv6両対応のBGPピアリング
# - Transit Gateway CIDR BlockからのGREアドレス自動割り当て
#
# 関連リソース:
# - aws_ec2_transit_gateway_connect: Connect Attachment（親リソース）
# - aws_ec2_transit_gateway: Transit Gateway本体
# - aws_ec2_transit_gateway_vpc_attachment: VPCアタッチメント（Connect Attachmentの基盤）
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_transit_gateway_connect_peer
#
# NOTE: Connect Attachment 1つにつき最大4つのConnect Peerを作成可能。
#       Transit Gatewayに事前にCIDRブロックを設定する必要があります。
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

resource "aws_ec2_transit_gateway_connect_peer" "example" {
  # 設定内容: Connect PeerのBGP Autonomous System Number（ASN）
  # 設定可能な値: 1-4294967295の整数（文字列形式）
  # 省略時: Transit GatewayのASNと同じ値が使用されます
  # 備考: アプライアンス側のBGP ASN。プライベートASN範囲（64512-65534, 4200000000-4294967294）推奨
  bgp_asn = "64512"

  # 設定内容: BGPピアリングに使用するインサイドCIDRブロック
  # 設定可能な値:
  #   - IPv4: 169.254.0.0/16範囲内の/29 CIDRブロック
  #   - IPv6: fd00::/8範囲内の/125 CIDRブロック
  # 備考: 複数指定可能（IPv4とIPv6の組み合わせ）。BGPピアアドレスとして使用されます
  inside_cidr_blocks = ["169.254.6.0/29"]

  # 設定内容: アプライアンス側のGREトンネル外部IPアドレス
  # 設定可能な値: 有効なIPv4またはIPv6アドレス
  # 備考: サードパーティアプライアンスの物理IPアドレス。VPC内またはDirect Connect経由でアクセス可能である必要があります
  peer_address = "172.31.1.11"

  # 設定内容: このConnect Peerが所属するTransit Gateway Connect AttachmentのID
  # 設定可能な値: 既存のConnect Attachment ID（tgw-attach-xxxxxxxxxxxxxxxxx形式）
  # 備考: Connect AttachmentはVPCまたはDirect Connectアタッチメント上に構築される必要があります
  transit_gateway_attachment_id = "tgw-attach-0123456789abcdef0"

  # 設定内容: Transit Gateway側のGREトンネル外部IPアドレス
  # 設定可能な値: Transit Gateway CIDR Block内の有効なIPアドレス
  # 省略時: Transit Gateway CIDR Blockから自動的に最初の利用可能なアドレスが割り当てられます
  # 備考: 明示的に指定する場合、Transit Gatewayに事前にCIDRブロックを設定しておく必要があります
  transit_gateway_address = "10.0.0.234"

  #-----------------------------------------------------------------------
  # リージョン設定（マルチリージョン構成時のみ）
  #-----------------------------------------------------------------------

  # 設定内容: リソースが管理されるAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（us-east-1, ap-northeast-1等）
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 備考: Transit Gatewayと同じリージョンである必要があります
  region = "ap-northeast-1"

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------

  # 設定内容: リソースに付与するタグのキーと値のマップ
  # 設定可能な値: キーと値の文字列ペア
  # 備考: コスト配分、リソース管理、自動化に使用します
  tags = {
    Name        = "example-connect-peer"
    Environment = "production"
    Purpose     = "sd-wan-integration"
  }

  #-----------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------

  # 設定内容: リソース作成・削除時のタイムアウト時間
  # 設定可能な値: Goのtime.Duration形式の文字列（例: "10m", "1h"）
  # 省略時: 作成10分、削除10分
  timeouts {
    create = "10m"
    delete = "10m"
  }
}

#-----------------------------------------------------------------------
# 補足事項
#-----------------------------------------------------------------------
# 前提条件: Transit GatewayにCIDR Block設定、Connect Attachment作成済み、
#           アプライアンスがGREトンネルとBGPサポート必須
# BGP設定: デュアルスタック対応、Graceful Restart/BFD未サポート、
#          冗長性のため自動的に2つのBGPピアを作成
# Inside CIDR: IPv4は169.254.0.0/16から/29、IPv6はfd00::/8から/125
# セキュリティ: GREプロトコル（IP 47）とBGP（TCP 179）通信許可必須
# 制限: Connect Attachment当たり最大4ピア、Transit Gateway当たり最大5000ピア
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-----------------------------------------------------------------------
# - arn: Connect PeerのARN
# - id: Connect PeerのID（tgw-connect-peer-xxxxxxxxxxxxxxxxx形式）
# - bgp_peer_address: BGPピアのIPアドレス（Inside CIDR Blocksから割り当て）
# - bgp_transit_gateway_addresses: Transit Gateway側のBGPアドレスのセット
# - tags_all: デフォルトタグを含む全タグのマップ
#-----------------------------------------------------------------------
