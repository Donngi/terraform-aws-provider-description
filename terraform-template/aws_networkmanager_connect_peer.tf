#---------------------------------------------------------------
# AWS Network Manager Connect Peer
#---------------------------------------------------------------
#
# AWS Cloud WANまたはTransit Gateway Network ManagerのConnectピアを作成する。
# Connect PeerはConnect Attachment上でBGPセッションを確立し、
# オンプレミスネットワークとコアネットワーク間の動的ルーティングを実現する。
#
# Connect Peerには2種類のタイプがある：
# - GRE Connect Peer: GREトンネルを使用してカプセル化
# - Tunnel-less Connect Peer (NO_ENCAP): トンネルなしで直接接続
#
# AWS公式ドキュメント:
#   - Create an AWS Cloud WAN Connect peer for a core network:
#     https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-connect-peer-attachment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_connect_peer
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_connect_peer" "this" {
  #---------------------------------------------------------------
  # 必須引数
  #---------------------------------------------------------------

  # connect_attachment_id (必須, string)
  # ------------------------------------------------
  # Connect AttachmentのID。
  # Connect PeerはこのConnect Attachmentに関連付けられる。
  # Connect Attachmentは事前にaws_networkmanager_connect_attachmentで作成する必要がある。
  #
  # 例: "attachment-0123456789abcdef0"
  connect_attachment_id = null # 必須: Connect AttachmentのIDを指定

  # peer_address (必須, string)
  # ------------------------------------------------
  # Connect PeerのIPアドレス。
  # GRE Connect Peerの場合: アプライアンス側のGRE外部IPアドレス
  # Tunnel-less Connect Peerの場合: アプライアンスのプライベートIPv4アドレス
  #
  # IPv4またはIPv6アドレスを指定可能だが、
  # Transit Gatewayアドレスと同じIPアドレスファミリーである必要がある。
  #
  # 例: "10.0.0.1" または "192.168.1.100"
  peer_address = null # 必須: PeerのIPアドレスを指定

  #---------------------------------------------------------------
  # オプション引数
  #---------------------------------------------------------------

  # core_network_address (オプション, string)
  # ------------------------------------------------
  # コアネットワークエッジのGRE外部IPアドレス。
  # GRE Connect Peerでのみ使用される。
  # 指定しない場合、inside_cidr_blocksから最初の利用可能なアドレスが使用される。
  #
  # 例: "10.0.0.2"
  core_network_address = null

  # inside_cidr_blocks (オプション, list(string))
  # ------------------------------------------------
  # BGPピアリングに使用する内部CIDRブロックのリスト。
  # Connect Attachmentのプロトコルが「GRE」の場合に必須。
  #
  # IPv4の場合: 169.254.0.0/16 範囲から /29 CIDRブロックを使用
  # IPv6の場合: fd00::/8 範囲から /125 CIDRブロックを使用
  #
  # 例: ["169.254.100.0/29"] または ["172.16.0.0/16"]
  inside_cidr_blocks = null

  # subnet_arn (オプション, string)
  # ------------------------------------------------
  # Connect Peerが配置されるサブネットのARN。
  # Connect Attachmentのプロトコルが「NO_ENCAP」（Tunnel-less）の場合に必須。
  #
  # アプライアンスはトランスポートVPCアタッチメントと同じサブネットで
  # 実行することが推奨される。
  #
  # 例: "arn:aws:ec2:us-east-1:123456789012:subnet/subnet-0123456789abcdef0"
  subnet_arn = null

  # tags (オプション, map(string))
  # ------------------------------------------------
  # リソースに付与するタグ。
  # providerレベルのdefault_tags設定ブロックで定義されたタグと
  # マッチするキーを持つタグは、providerレベルの値を上書きする。
  #
  # 例:
  # tags = {
  #   Name        = "my-connect-peer"
  #   Environment = "production"
  # }
  tags = null

  #---------------------------------------------------------------
  # bgp_options ブロック (オプション, 最大1つ)
  #---------------------------------------------------------------
  # BGPセッションの設定オプション。
  #
  # bgp_options {
  #   # peer_asn (オプション, string)
  #   # ------------------------------------------------
  #   # アプライアンスのBGP自律システム番号（ASN）。
  #   # 2バイトおよび4バイトのASNをサポート（1～4294967295）。
  #   #
  #   # ネットワークに割り当てられた既存のASNを使用可能。
  #   # 指定しない場合、コアネットワークエッジと同じASNが使用される。
  #   #
  #   # コアネットワークエッジのASNと異なるASN（eBGP）を設定する場合、
  #   # TTL値2でebgp-multihopを設定する必要がある。
  #   #
  #   # 例: "65000" または "4294967294"
  #   peer_asn = null
  # }

  #---------------------------------------------------------------
  # timeouts ブロック (オプション)
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定。
  #
  # timeouts {
  #   # create (オプション, string)
  #   # ------------------------------------------------
  #   # リソース作成のタイムアウト時間。
  #   # Connect Peerの作成には時間がかかる場合がある。
  #   #
  #   # 形式: 数値 + 単位（s=秒, m=分, h=時間）
  #   # 例: "30m"（30分）
  #   create = null
  #
  #   # delete (オプション, string)
  #   # ------------------------------------------------
  #   # リソース削除のタイムアウト時間。
  #   #
  #   # 形式: 数値 + 単位（s=秒, m=分, h=時間）
  #   # 例: "30m"（30分）
  #   delete = null
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能。
#
# arn             - Connect PeerのARN
#                   例: "arn:aws:networkmanager::123456789012:connect-peer/connect-peer-0123456789abcdef0"
#
# configuration   - Connect Peerの設定情報（オブジェクトのリスト）
#                   - bgp_configurations: BGP設定のリスト
#                     - core_network_address: コアネットワークのBGPアドレス
#                     - core_network_asn: コアネットワークのASN
#                     - peer_address: ピアのBGPアドレス
#                     - peer_asn: ピアのASN
#                   - core_network_address: コアネットワークアドレス
#                   - inside_cidr_blocks: 内部CIDRブロック
#                   - peer_address: ピアアドレス
#                   - protocol: プロトコル（GREまたはNO_ENCAP）
#
# connect_peer_id - Connect PeerのID
#                   例: "connect-peer-0123456789abcdef0"
#
# core_network_id - コアネットワークのID
#                   例: "core-network-0123456789abcdef0"
#
# created_at      - Connect Peerが作成された日時（ISO 8601形式）
#                   例: "2024-01-15T10:30:00Z"
#
# edge_location   - ピアが配置されているリージョン
#                   例: "us-east-1"
#
# state           - Connect Peerの状態
#                   可能な値: CREATING, AVAILABLE, DELETING, FAILED
#
# tags_all        - providerのdefault_tagsで設定されたタグを含む
#                   全てのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 例1: GRE Connect Peer（基本的な使用方法）
# -----------------------------------------
# resource "aws_networkmanager_connect_peer" "gre_example" {
#   connect_attachment_id = aws_networkmanager_connect_attachment.example.id
#   peer_address          = "10.0.0.1"
#   inside_cidr_blocks    = ["169.254.100.0/29"]
#
#   bgp_options {
#     peer_asn = "65000"
#   }
#
#   tags = {
#     Name = "gre-connect-peer"
#   }
# }
#
# 例2: Tunnel-less Connect Peer（NO_ENCAP）
# -----------------------------------------
# resource "aws_networkmanager_connect_peer" "tunnel_less_example" {
#   connect_attachment_id = aws_networkmanager_connect_attachment.no_encap.id
#   peer_address          = "192.168.1.100"
#   subnet_arn            = aws_subnet.appliance.arn
#
#   bgp_options {
#     peer_asn = "65500"
#   }
#
#   tags = {
#     Name = "tunnel-less-connect-peer"
#   }
# }
#
# 例3: Attachment Accepterとの連携
# -----------------------------------------
# resource "aws_networkmanager_attachment_accepter" "connect" {
#   attachment_id   = aws_networkmanager_connect_attachment.example.id
#   attachment_type = aws_networkmanager_connect_attachment.example.attachment_type
# }
#
# resource "aws_networkmanager_connect_peer" "with_accepter" {
#   connect_attachment_id = aws_networkmanager_connect_attachment.example.id
#   peer_address          = "10.0.0.1"
#   inside_cidr_blocks    = ["172.16.0.0/16"]
#
#   bgp_options {
#     peer_asn = "65000"
#   }
#
#   depends_on = [aws_networkmanager_attachment_accepter.connect]
# }
#---------------------------------------------------------------
