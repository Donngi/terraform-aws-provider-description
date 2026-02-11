#---------------------------------------------------------------
# AWS Network Manager Transit Gateway Connect Peer Association
#---------------------------------------------------------------
#
# Transit Gateway Connect Peerをデバイス（およびオプションでリンク）に
# 関連付けるNetwork Managerリソースです。
#
# Transit Gateway Connect Peerは、Transit Gateway Connectアタッチメントを
# 通じてSD-WANアプライアンスやサードパーティルーターとの接続を確立するために
# 使用されます。この関連付けにより、Network Managerでネットワークトポロジーを
# 可視化・管理できるようになります。
#
# リンクを指定する場合は、そのリンクが指定されたデバイスに関連付けられている
# 必要があります。
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_transit_gateway_connect_peer_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_transit_gateway_connect_peer_association" "this" {
  #---------------------------------------------------------------
  # 必須パラメータ (Required)
  #---------------------------------------------------------------

  # global_network_id (Required, Forces new resource)
  # 関連付け先のグローバルネットワークのID。
  # グローバルネットワークはNetwork Managerで管理する全体的なネットワーク
  # トポロジーを表す論理的なコンテナです。
  # Type: string
  global_network_id = var.global_network_id

  # device_id (Required, Forces new resource)
  # Transit Gateway Connect Peerを関連付けるデバイスのID。
  # デバイスはカスタマーゲートウェイデバイスやSD-WANアプライアンスなど、
  # オンプレミスまたはリモートロケーションにある物理/仮想ネットワーク機器を
  # 表します。
  # Type: string
  device_id = var.device_id

  # transit_gateway_connect_peer_arn (Required, Forces new resource)
  # 関連付けるTransit Gateway Connect PeerのARN。
  # Connect Peerは、Transit Gateway Connectアタッチメントを介した
  # GRE/BGPトンネルのエンドポイントを表します。
  # Format: arn:aws:ec2:<region>:<account-id>:transit-gateway-connect-peer/<peer-id>
  # Type: string
  transit_gateway_connect_peer_arn = var.transit_gateway_connect_peer_arn

  #---------------------------------------------------------------
  # オプションパラメータ (Optional)
  #---------------------------------------------------------------

  # link_id (Optional, Forces new resource)
  # デバイスに関連付けられたリンクのID。
  # リンクはサイトとデバイス間のネットワーク接続（ISP回線、専用線など）を
  # 表します。指定する場合、このリンクは上記で指定したデバイスに
  # 既に関連付けられている必要があります。
  # Type: string
  # Default: null（リンクなしで関連付け）
  link_id = null

  #---------------------------------------------------------------
  # タイムアウト設定 (Timeouts)
  #---------------------------------------------------------------

  # timeouts ブロック
  # リソースの作成・削除操作のタイムアウトを設定します。
  # Network Manager APIのレスポンスが遅い場合やネットワーク状態の
  # 伝播に時間がかかる場合に調整が必要になることがあります。
  timeouts {
    # create (Optional)
    # 関連付けの作成が完了するまでの最大待機時間。
    # Transit Gateway Connect Peerの状態が「available」になり、
    # 関連付けが確立されるまでの時間を考慮して設定します。
    # Format: 数値 + 単位（s=秒, m=分, h=時間）
    # Default: (プロバイダーのデフォルト値)
    # Example: "10m"
    create = null

    # delete (Optional)
    # 関連付けの削除が完了するまでの最大待機時間。
    # 関連付けの解除と状態の伝播に必要な時間を考慮して設定します。
    # Format: 数値 + 単位（s=秒, m=分, h=時間）
    # Default: (プロバイダーのデフォルト値)
    # Example: "10m"
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (出力専用属性)
#---------------------------------------------------------------
#
# このリソースは追加のcomputed only属性をエクスポートしません。
# 上記の引数として指定された属性のみが参照可能です。
#
# 利用可能な属性:
#   - id: リソースの識別子
#         （global_network_id,transit_gateway_connect_peer_arn の組み合わせ）
#   - global_network_id: グローバルネットワークID
#   - device_id: デバイスID
#   - transit_gateway_connect_peer_arn: Connect Peer ARN
#   - link_id: リンクID（設定されている場合）
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例 (Example Usage)
#---------------------------------------------------------------
#
# # 前提となるリソースの作成
# resource "aws_networkmanager_global_network" "example" {
#   description = "Example Global Network"
# }
#
# resource "aws_networkmanager_site" "example" {
#   global_network_id = aws_networkmanager_global_network.example.id
#   description       = "Example Site"
# }
#
# resource "aws_networkmanager_device" "example" {
#   global_network_id = aws_networkmanager_global_network.example.id
#   site_id           = aws_networkmanager_site.example.id
#   description       = "Example Device"
# }
#
# # Transit Gateway Connect Peer関連
# resource "aws_ec2_transit_gateway" "example" {
#   description = "Example Transit Gateway"
# }
#
# resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
#   subnet_ids         = [aws_subnet.example.id]
#   transit_gateway_id = aws_ec2_transit_gateway.example.id
#   vpc_id             = aws_vpc.example.id
# }
#
# resource "aws_ec2_transit_gateway_connect" "example" {
#   transport_attachment_id = aws_ec2_transit_gateway_vpc_attachment.example.id
#   transit_gateway_id      = aws_ec2_transit_gateway.example.id
# }
#
# resource "aws_ec2_transit_gateway_connect_peer" "example" {
#   peer_address                  = "10.1.2.3"
#   inside_cidr_blocks            = ["169.254.100.0/29"]
#   transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.example.id
# }
#
# # Transit Gateway登録
# resource "aws_networkmanager_transit_gateway_registration" "example" {
#   global_network_id   = aws_networkmanager_global_network.example.id
#   transit_gateway_arn = aws_ec2_transit_gateway.example.arn
# }
#
# # Connect Peer関連付け
# resource "aws_networkmanager_transit_gateway_connect_peer_association" "example" {
#   global_network_id                = aws_networkmanager_global_network.example.id
#   device_id                        = aws_networkmanager_device.example.id
#   transit_gateway_connect_peer_arn = aws_ec2_transit_gateway_connect_peer.example.arn
#
#   depends_on = [
#     aws_networkmanager_transit_gateway_registration.example
#   ]
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
#
# - aws_networkmanager_global_network
#     グローバルネットワークの作成
#
# - aws_networkmanager_device
#     デバイスの作成
#
# - aws_networkmanager_link
#     リンクの作成
#
# - aws_networkmanager_link_association
#     デバイスとリンクの関連付け
#
# - aws_networkmanager_transit_gateway_registration
#     Transit GatewayをNetwork Managerに登録
#
# - aws_ec2_transit_gateway_connect
#     Transit Gateway Connectアタッチメントの作成
#
# - aws_ec2_transit_gateway_connect_peer
#     Transit Gateway Connect Peerの作成
#
#---------------------------------------------------------------
