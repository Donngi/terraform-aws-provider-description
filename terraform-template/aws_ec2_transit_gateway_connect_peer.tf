#---------------------------------------------------------------
# AWS EC2 Transit Gateway Connect Peer
#---------------------------------------------------------------
#
# EC2 Transit Gateway Connect Peerをプロビジョニングするリソースです。
# Transit Gateway Connect PeerはTransit Gateway Connectアタッチメントに関連付けられ、
# BGPを使用してSD-WAN/サードパーティネットワークアプライアンスと
# Transit Gateway間の動的ルーティングを確立します。
#
# Connect Peerは、GRE (Generic Routing Encapsulation) トンネルを使用して
# Transit Gatewayとサードパーティ製仮想アプライアンス間の接続を提供します。
# これにより、SD-WANソリューションやその他のネットワークアプライアンスを
# AWS Transit Gatewayと統合することができます。
#
# 前提条件:
#   - Transit Gateway Connect アタッチメント (aws_ec2_transit_gateway_connect) が必要です
#   - Transit Gateway VPC アタッチメントが必要です
#
# AWS公式ドキュメント:
#   - Transit Gateway Connect: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-connect.html
#   - Connect Attachments and Connect Peers: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-connect-attachments.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_connect_peer
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_transit_gateway_connect_peer" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # transit_gateway_attachment_id (Required)
  # 設定内容: Transit Gateway ConnectアタッチメントのIDを指定します。
  # 設定可能な値: 有効なTransit Gateway Connect アタッチメントID
  # 関連機能: Transit Gateway Connect
  #   Connect PeerはConnect アタッチメントに関連付けられます。
  #   aws_ec2_transit_gateway_connect リソースで作成したアタッチメントIDを指定します。
  transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.example.id

  #-------------------------------------------------------------
  # ピア設定
  #-------------------------------------------------------------

  # peer_address (Required)
  # 設定内容: カスタマーデバイスに割り当てられるIPアドレスを指定します。
  #           トンネルエンドポイントとして使用されます。
  # 設定可能な値: IPv4またはIPv6アドレス
  # 注意: transit_gateway_addressと同じアドレスファミリー (IPv4/IPv6) である必要があります
  # 関連機能: GREトンネル
  #   このアドレスはTransit Gatewayとカスタマーデバイス間のGREトンネルの
  #   カスタマー側エンドポイントとして使用されます。
  peer_address = "10.1.2.3"

  #-------------------------------------------------------------
  # BGP設定
  #-------------------------------------------------------------

  # bgp_asn (Optional)
  # 設定内容: カスタマーデバイスに割り当てるBGP ASN番号を指定します。
  # 設定可能な値: 1〜4294967295の整数
  # 省略時: Transit Gatewayに関連付けられたBGP ASNと同じ値が使用されます
  # 関連機能: BGPルーティング
  #   カスタマーデバイスとTransit Gateway間でBGPセッションを確立し、
  #   動的ルーティング情報を交換します。
  bgp_asn = null

  #-------------------------------------------------------------
  # Inside CIDR設定
  #-------------------------------------------------------------

  # inside_cidr_blocks (Required)
  # 設定内容: トンネル内でのアドレッシングに使用されるCIDRブロックを指定します。
  # 設定可能な値:
  #   - IPv4の場合: /29サイズで169.254.0.0/16範囲内のCIDRブロック（1つ必須）
  #     ただし以下のCIDRブロックは除外:
  #     - 169.254.0.0/29
  #     - 169.254.1.0/29
  #     - 169.254.2.0/29
  #     - 169.254.3.0/29
  #     - 169.254.4.0/29
  #     - 169.254.5.0/29
  #     - 169.254.169.248/29
  #   - IPv6の場合: /125サイズでfd00::/8範囲内のCIDRブロック（最大1つ）
  # 注意:
  #   - 正確に1つのIPv4 CIDRブロックと、最大1つのIPv6 CIDRブロックを含む必要があります
  #   - 各CIDRブロックの最初のIPはカスタマーゲートウェイに割り当てられます
  #   - 2番目と3番目のIPはTransit Gatewayに割り当てられます
  #   - 例: 169.254.100.0/29の場合
  #     - .1: カスタマーゲートウェイ
  #     - .2, .3: Transit Gateway
  # 関連機能: BGPピアリング
  #   これらのIPアドレスはBGPセッションの確立に使用されます。
  inside_cidr_blocks = ["169.254.100.0/29"]

  #-------------------------------------------------------------
  # Transit Gateway設定
  #-------------------------------------------------------------

  # transit_gateway_address (Optional)
  # 設定内容: Transit Gatewayに割り当てられるIPアドレスを指定します。
  #           トンネルエンドポイントとして使用されます。
  # 設定可能な値: Transit Gateway CIDRブロックからのIPアドレス
  # 省略時: 関連するTransit Gateway CIDRブロックから自動的に選択されます
  # 注意:
  #   - peer_addressと同じアドレスファミリーである必要があります
  #   - 関連するTransit Gateway CIDRブロックのアドレス範囲内である必要があります
  # 関連機能: GREトンネル
  #   このアドレスはTransit Gateway側のトンネルエンドポイントとして使用されます。
  transit_gateway_address = null

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
  # 設定内容: EC2 Transit Gateway Connect Peerに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-tgw-connect-peer"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: EC2 Transit Gateway Connect Peer 識別子
#
# - arn: EC2 Transit Gateway Connect PeerのARN
#   形式: arn:aws:ec2:<region>:<account-id>:transit-gateway-connect-peer/<id>
#
# - bgp_peer_address: カスタマーデバイスに割り当てられたIPアドレス。
#                     BGP IPアドレスとして使用されます。
#                     inside_cidr_blocksで指定されたCIDRブロックの最初のIPアドレスです。
#
# - bgp_transit_gateway_addresses: Transit Gatewayに割り当てられたIPアドレスのリスト。
#                                  BGP IPアドレスとして使用されます。
#                                  inside_cidr_blocksで指定されたCIDRブロックの
#                                  2番目と3番目のIPアドレスです。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 完全なTransit Gateway Connect構成
#---------------------------------------------------------------
# 以下は、Transit Gateway Connect Peerを使用するための
# 完全な構成例です（コメントアウトしています）。

# # Transit Gateway
# resource "aws_ec2_transit_gateway" "example" {
#   description = "Example Transit Gateway"
#   tags = {
#     Name = "example-tgw"
#   }
# }
#
# # VPCアタッチメント
# resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
#   subnet_ids         = [aws_subnet.example.id]
#   transit_gateway_id = aws_ec2_transit_gateway.example.id
#   vpc_id             = aws_vpc.example.id
#   tags = {
#     Name = "example-tgw-vpc-attachment"
#   }
# }
#
# # Transit Gateway Connectアタッチメント
# resource "aws_ec2_transit_gateway_connect" "example" {
#   transport_attachment_id = aws_ec2_transit_gateway_vpc_attachment.example.id
#   transit_gateway_id      = aws_ec2_transit_gateway.example.id
#   tags = {
#     Name = "example-tgw-connect"
#   }
# }
#
# # Connect Peer
# resource "aws_ec2_transit_gateway_connect_peer" "example" {
#   peer_address                  = "10.1.2.3"
#   inside_cidr_blocks            = ["169.254.100.0/29"]
#   transit_gateway_attachment_id = aws_ec2_transit_gateway_connect.example.id
#   bgp_asn                       = 65000
#   tags = {
#     Name = "example-tgw-connect-peer"
#   }
# }

#---------------------------------------------------------------
# ベストプラクティス
#---------------------------------------------------------------
# 1. Inside CIDR Blocks:
#    - 169.254.0.0/16範囲内の予約されていないCIDRブロックを使用してください
#    - 複数のConnect Peerを作成する場合、各Peerに一意のCIDRブロックを割り当ててください
#
# 2. BGP ASN:
#    - カスタマーデバイスのBGP ASNを正確に設定してください
#    - プライベートASN (64512-65534) またはパブリックASNが使用できます
#
# 3. 高可用性:
#    - 冗長性のために複数のConnect Peerを作成することを検討してください
#    - 異なるアベイラビリティゾーンにTransit Gateway VPCアタッチメントを配置してください
#
# 4. セキュリティ:
#    - Transit GatewayルートテーブルでBGPで学習したルートを適切にフィルタリングしてください
#    - ピアアドレスへのアクセスを制限するセキュリティグループルールを設定してください
#
# 5. モニタリング:
#    - CloudWatch メトリクスでBGPセッションの状態を監視してください
#    - Connect Peerの接続性とパフォーマンスを定期的に確認してください
#---------------------------------------------------------------
