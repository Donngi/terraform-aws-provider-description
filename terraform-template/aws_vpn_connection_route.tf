#---------------------------------------------------------------
# AWS VPN Connection Route
#---------------------------------------------------------------
#
# AWS Site-to-Site VPN接続に対して静的ルートをプロビジョニングするリソースです。
# カスタマーゲートウェイとVPN接続の間に静的ルートを設定し、
# 指定したCIDRブロックへのトラフィックをVPN経由でルーティングします。
# なお、このリソースはstatic_routes_only = trueのVPN接続でのみ使用できます。
#
# AWS公式ドキュメント:
#   - AWS Site-to-Site VPN概要: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html
#   - VPN静的ルート: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNRoutingTypes.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection_route
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpn_connection_route" "example" {
  #-------------------------------------------------------------
  # ルーティング設定
  #-------------------------------------------------------------

  # destination_cidr_block (Required, Forces new resource)
  # 設定内容: カスタマーネットワークのローカルサブネットに関連付けるCIDRブロックを指定します。
  # 設定可能な値: 有効なCIDR表記の文字列（例: "192.168.10.0/24"）
  # 参考: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNRoutingTypes.html
  destination_cidr_block = "192.168.10.0/24"

  # vpn_connection_id (Required, Forces new resource)
  # 設定内容: 静的ルートを追加するVPN接続のIDを指定します。
  # 設定可能な値: 有効なVPN接続ID（例: "vpn-12345678"）
  # 注意: 対象のVPN接続はstatic_routes_only = trueで作成されている必要があります。
  vpn_connection_id = "vpn-12345678"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: "ap-northeast-1", "us-east-1"）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - destination_cidr_block: カスタマーネットワークのローカルサブネットに関連付けられたCIDRブロック
# - vpn_connection_id: 静的ルートが追加されたVPN接続のID
#---------------------------------------------------------------
