#---------------------------------------
# Customer Gateway
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/customer_gateway
#
# NOTE:
# Customer Gatewayリソースは、VPN接続においてAWS側から見た顧客側のゲートウェイ機器を表すリソースです。
# VPN接続を確立する際の顧客側エンドポイント情報（IPアドレス、BGP ASN番号など）を定義します。
#
# 主な用途:
# - Site-to-Site VPN接続の構成
# - オンプレミスネットワークとVPC間の接続設定
# - BGPルーティングを使用した動的ルーティングの実装
#
# 関連リソース:
# - aws_vpn_connection: Customer Gatewayを使用してVPN接続を確立
# - aws_vpn_gateway: AWS側のVPNゲートウェイ
#
# 公式ドキュメント: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html

#---------------------------------------
# Customer Gateway基本設定
#---------------------------------------
resource "aws_customer_gateway" "example" {
  #---------------------------------------
  # 必須パラメータ
  #---------------------------------------
  # 設定内容: Customer Gatewayのタイプ
  # 設定可能な値: "ipsec.1"（現在サポートされている唯一のタイプ）
  type = "ipsec.1"

  #---------------------------------------
  # 接続情報設定
  #---------------------------------------
  # 設定内容: Customer GatewayのパブリックIPv4アドレス
  # 省略時: bgp_asnまたはbgp_asn_extendedと相互排他的に使用可能
  # 注意: IPSecベースのVPN接続では必須、証明書ベースの接続では不要
  ip_address = "203.0.113.12"

  #---------------------------------------
  # BGP設定
  #---------------------------------------
  # 設定内容: BGP自律システム番号（2バイトASN形式）
  # 設定可能な値: 1～65534の範囲（65535は予約済み）
  # 省略時: 動的ルーティングを使用しない場合は不要
  # 注意: bgp_asn_extendedと相互排他的
  bgp_asn = "65000"

  # 設定内容: BGP自律システム番号（4バイトASN形式）
  # 設定可能な値: 1～2147483647の範囲
  # 省略時: 2バイトASNで十分な場合はbgp_asnを使用
  # 注意: bgp_asnと相互排他的、32ビットASN番号が必要な場合に使用
  bgp_asn_extended = "4200000000"

  #---------------------------------------
  # 証明書ベース認証設定
  #---------------------------------------
  # 設定内容: 証明書ベース認証に使用するACM証明書のARN
  # 省略時: IPアドレスベースの認証を使用
  # 注意: 証明書ベース認証の場合はip_addressの代わりに使用
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  #---------------------------------------
  # デバイス情報設定
  #---------------------------------------
  # 設定内容: Customer Gatewayデバイスの識別名
  # 省略時: デバイス名は設定されない
  # 用途: 複数のCustomer Gatewayを管理する際の識別に使用
  device_name = "office-firewall-01"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  # 注意: 通常は明示的に指定する必要はない
  region = "us-east-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: Customer Gatewayに付与するタグ
  # 省略時: タグは付与されない
  tags = {
    Name        = "office-cgw-01"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Customer GatewayのID
# - arn: Customer GatewayのAmazon Resource Name
# - bgp_asn: BGP自律システム番号（2バイト形式）
# - bgp_asn_extended: BGP自律システム番号（4バイト形式）
# - certificate_arn: ACM証明書のARN
# - device_name: Customer Gatewayデバイスの名前
# - ip_address: Customer GatewayのパブリックIPアドレス
# - type: Customer Gatewayのタイプ
# - tags_all: リソースに割り当てられた全てのタグ（デフォルトタグを含む）
# - region: リソースが管理されているAWSリージョン
#
# 参照例:
# - VPN接続での使用: aws_vpn_connection.main.customer_gateway_id = aws_customer_gateway.example.id
# - ARNの参照: aws_customer_gateway.example.arn
# - タグの参照: aws_customer_gateway.example.tags_all
