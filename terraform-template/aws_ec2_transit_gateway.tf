#----------------------------------------------------------------------------------------------------
# aws_ec2_transit_gateway
# Manages an EC2 Transit Gateway.
#
# Provider Version: 6.28.0
# Generated: 2026-02-15
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway
#
# リソース: AWS::EC2::TransitGateway
# 用途: VPC間、VPCとオンプレミスネットワーク間のトラフィックルーティングを一元管理するTransit Gatewayを作成
#      複数VPCを単一のゲートウェイに接続してハブ&スポークアーキテクチャを構築
#
# NOTE: BGPセッションがアクティブな状態でamazon_side_asnを変更することはできません
#----------------------------------------------------------------------------------------------------

#-------
# 基本設定
#-------
resource "aws_ec2_transit_gateway" "example" {
  # 設定内容: Transit Gatewayの説明
  # 補足: わかりやすい名前や用途を記述
  description = "Central transit gateway for multi-VPC connectivity"

  #-------
  # リージョン設定
  #-------
  # 設定内容: このリソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-east-1"

  #-------
  # BGP設定
  #-------
  # 設定内容: BGPセッション用のAmazon側のプライベート自律システム番号(ASN)
  # 設定可能な値:
  #   - 16ビットASN: 64512 ~ 65534
  #   - 32ビットASN: 4200000000 ~ 4294967294
  # 省略時: 64512が使用される
  # 注意: BGPセッションがアクティブなTransit Gatewayでの変更は不可
  #       変更する場合は、事前にBGP設定済みのアタッチメントをすべて削除する必要がある
  amazon_side_asn = 64512

  #-------
  # VPN設定
  #-------
  # 設定内容: VPN Equal Cost Multipath Protocol(ECMP)サポートの有効/無効
  # 設定可能な値: enable, disable
  # 省略時: enable
  # 補足: ECMPを有効にすると、複数VPN接続間で負荷分散が可能
  vpn_ecmp_support = "enable"

  #-------
  # アタッチメント自動受け入れ設定
  #-------
  # 設定内容: 他のAWSアカウントからのアタッチメント要求の自動承認
  # 設定可能な値: enable, disable
  # 省略時: disable
  # 補足: enableにすると、共有されたVPCアタッチメント要求を自動的に承認
  auto_accept_shared_attachments = "disable"

  #-------
  # ルートテーブル関連付け設定
  #-------
  # 設定内容: リソースアタッチメントのデフォルトアソシエーションルートテーブルへの自動関連付け
  # 設定可能な値: enable, disable
  # 省略時: enable
  # 補足: disableにすると、アタッチメント作成時に手動でルートテーブルを関連付ける必要がある
  default_route_table_association = "enable"

  #-------
  # ルート伝播設定
  #-------
  # 設定内容: リソースアタッチメントのデフォルト伝播ルートテーブルへのルート自動伝播
  # 設定可能な値: enable, disable
  # 省略時: enable
  # 補足: disableにすると、アタッチメントのルートを手動で伝播する必要がある
  default_route_table_propagation = "enable"

  #-------
  # DNS設定
  #-------
  # 設定内容: DNS名前解決サポートの有効/無効
  # 設定可能な値: enable, disable
  # 省略時: enable
  # 補足: enableにすると、VPC間でDNS名前解決が可能
  dns_support = "enable"

  #-------
  # マルチキャスト設定
  #-------
  # 設定内容: マルチキャストサポートの有効/無効
  # 設定可能な値: enable, disable
  # 省略時: disable
  # 補足: ec2_transit_gateway_multicast_domainを使用する場合は必須
  multicast_support = "disable"

  #-------
  # 暗号化設定
  #-------
  # 設定内容: VPC暗号化制御の暗号化サポート有効/無効
  # 設定可能な値: enable, disable
  # 省略時: disable
  # 注意: 一度設定した後にdisableに切り替える場合は、明示的にdisableを指定する必要がある
  encryption_support = "disable"

  #-------
  # セキュリティグループ参照設定
  #-------
  # 設定内容: セキュリティグループ参照サポートの有効/無効
  # 設定可能な値: enable, disable
  # 省略時: disable
  # 補足: enableにすると、VPC間でセキュリティグループを参照可能
  security_group_referencing_support = "disable"

  #-------
  # CIDRブロック設定
  #-------
  # 設定内容: Transit Gateway用のIPv4またはIPv6 CIDRブロック
  # 設定可能な値:
  #   - IPv4: /24以上のサイズのCIDRブロック
  #   - IPv6: /64以上のサイズのCIDRブロック
  # 補足: 複数のCIDRブロックを指定可能
  transit_gateway_cidr_blocks = ["10.0.0.0/24"]

  #-------
  # タグ設定
  #-------
  # 設定内容: Transit Gatewayに付与するキーバリュー形式のタグ
  # 補足: プロバイダーのdefault_tagsと併用可能
  tags = {
    Name        = "central-tgw"
    Environment = "production"
    Purpose     = "multi-vpc-routing"
  }

  #-------
  # タイムアウト設定
  #-------
  timeouts {
    # 設定内容: Transit Gateway作成のタイムアウト時間
    # 省略時: 10m
    create = "10m"

    # 設定内容: Transit Gateway更新のタイムアウト時間
    # 省略時: 10m
    update = "10m"

    # 設定内容: Transit Gateway削除のタイムアウト時間
    # 省略時: 10m
    delete = "10m"
  }
}

#----------------------------------------------------------------------------------------------------
# Attributes Reference (参照可能な属性)
#
# 以下の属性がリソース作成後に参照可能:
#
# - arn: Transit GatewayのARN
# - id: Transit Gatewayの識別子
# - owner_id: Transit Gatewayを所有するAWSアカウントID
# - association_default_route_table_id: デフォルトアソシエーションルートテーブルの識別子
# - propagation_default_route_table_id: デフォルト伝播ルートテーブルの識別子
# - tags_all: リソースに割り当てられたすべてのタグ(プロバイダーのdefault_tagsを含む)
#
# 参照例:
#   aws_ec2_transit_gateway.example.id
#   aws_ec2_transit_gateway.example.arn
#   aws_ec2_transit_gateway.example.association_default_route_table_id
#----------------------------------------------------------------------------------------------------
