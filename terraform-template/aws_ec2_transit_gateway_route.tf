#-----------------------------------------------------------------------
# AWS EC2 Transit Gateway Route
#-----------------------------------------------------------------------
# Transit Gateway間・VPC・VPN接続へのルーティングを定義するリソース
# Static Route方式でTransit Gateway Route Tableに経路を登録する
# blackhole指定でトラフィックをドロップするルート設定も可能
#
# 主な用途:
# - Transit Gateway経由のVPC間ルーティング設定
# - VPN/Direct Connect経由のオンプレミスへの経路登録
# - Internet Gatewayへのデフォルトルート設定
# - Blackhole Routeによる特定宛先のトラフィック遮断
#
# 注意事項:
# - destination_cidr_blockは既存ルートと重複不可（最長一致で評価される）
# - blackhole=falseの場合はtransit_gateway_attachment_idが必須
# - ルート変更時は既存ルートが削除されてから新規ルートが作成される
# - Propagated Routeとは別管理（本リソースはStatic Route専用）
#
# Provider Version: 6.28.0
# Generated: 2026-02-16
# NOTE: blackhole=trueの場合はtransit_gateway_attachment_id不要
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

resource "aws_ec2_transit_gateway_route" "example" {
  # 設定内容: 宛先CIDR（IPv4またはIPv6 RFC1924形式）
  # 設定可能な値: 有効なCIDR表記（例: 10.0.0.0/8, 192.168.0.0/16, 0.0.0.0/0など）
  # 省略時: 設定必須
  destination_cidr_block = "10.1.0.0/16"

  # 設定内容: Transit Gateway Route TableのID
  # 設定可能な値: 既存のTransit Gateway Route TableのリソースID
  # 省略時: 設定必須
  transit_gateway_route_table_id = aws_ec2_transit_gateway.example.association_default_route_table_id

  #-----------------------------------------------------------------------
  # ルート先設定
  #-----------------------------------------------------------------------

  # 設定内容: 転送先となるTransit Gateway AttachmentのID
  # 設定可能な値: VPC Attachment / VPN Attachment / Peering AttachmentなどのID
  # 省略時: blackhole=trueの場合は不要、false（デフォルト）の場合は必須
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.example.id

  #-----------------------------------------------------------------------
  # トラフィック制御設定
  #-----------------------------------------------------------------------

  # 設定内容: Blackhole Route（トラフィック破棄）として設定するかどうか
  # 設定可能な値: true（破棄） / false（通常転送）
  # 省略時: false（通常転送）
  blackhole = false

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1など）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-west-2"
}

#-----------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-----------------------------------------------------------------------
# このリソースから参照可能な属性:
#
# - id
#   Transit Gateway Route Table IDと宛先CIDRを組み合わせた一意の識別子
#   形式: <transit_gateway_route_table_id>_<destination_cidr_block>
#
#-----------------------------------------------------------------------
