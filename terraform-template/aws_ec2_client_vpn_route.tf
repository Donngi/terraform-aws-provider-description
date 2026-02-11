#---------------------------------------------------------------
# AWS Client VPN Route
#---------------------------------------------------------------
#
# Client VPNエンドポイントに追加のルートを提供します。
# Client VPNエンドポイントにはルートテーブルがあり、特定のリソースや
# ネットワークへのトラフィックの経路を定義します。
#
# AWS公式ドキュメント:
#   - Create an AWS Client VPN endpoint route: https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-working-routes-create.html
#   - CreateClientVpnRoute API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateClientVpnRoute.html
#   - How AWS Client VPN works: https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/how-it-works.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_client_vpn_route" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # Client VPNエンドポイントのID
  # ルートを追加するClient VPNエンドポイントを指定します。
  # 例: "cvpn-endpoint-00c5d11fc4EXAMPLE"
  client_vpn_endpoint_id = "cvpn-endpoint-xxxxxxxxx"

  # 宛先CIDRブロック (IPv4またはIPv6)
  # ルートの宛先となるIPv4またはIPv6アドレス範囲をCIDR表記で指定します。
  #
  # 一般的な使用例:
  #   - インターネットアクセス用: "0.0.0.0/0" (IPv4) または "::/0" (IPv6)
  #   - ピアリングVPC用: ピアリングVPCのCIDR範囲
  #   - オンプレミスネットワーク用: Site-to-Site VPN接続のCIDR範囲
  #   - ローカルネットワーク用: クライアントCIDR範囲
  destination_cidr_block = "0.0.0.0/0"

  # ターゲットVPCサブネットID
  # トラフィックをルーティングするサブネットのIDを指定します。
  # 指定するサブネットは、Client VPNエンドポイントに既に関連付けられている
  # 必要があります。
  #
  # 注意: ローカルネットワークへのルートを追加する場合は "local" を指定します。
  # 例: "subnet-057fa0918fEXAMPLE"
  target_vpc_subnet_id = aws_ec2_client_vpn_network_association.example.subnet_id

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # ルートの説明
  # ルートの簡潔な説明を指定します。
  # 例: "Route to the Internet" または "Route to on-premises network"
  description = null

  # リージョン
  # このリソースが管理されるリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 例: "us-east-1", "ap-northeast-1"
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です:
#
# - id: Client VPNエンドポイントのID
#
# - origin: Client VPNルートが追加された方法を示します。
#          このリソースによって作成されたルートの場合は "add-route" になります。
#
# - type: ルートのタイプ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# 1. インターネットアクセス用のルート
#
# resource "aws_ec2_client_vpn_route" "internet" {
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.example.id
#   destination_cidr_block = "0.0.0.0/0"
#   target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.example.subnet_id
#   description            = "Route to the Internet"
# }
#
# 2. 特定のVPCへのルート
#
# resource "aws_ec2_client_vpn_route" "vpc" {
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.example.id
#   destination_cidr_block = "10.0.0.0/16"
#   target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.example.subnet_id
#   description            = "Route to VPC"
# }
#
# 3. オンプレミスネットワークへのルート
#
# resource "aws_ec2_client_vpn_route" "on_premises" {
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.example.id
#   destination_cidr_block = "192.168.0.0/16"
#   target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.example.subnet_id
#   description            = "Route to on-premises network via Site-to-Site VPN"
# }
#---------------------------------------------------------------
