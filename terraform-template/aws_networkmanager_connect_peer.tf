#---------------------------------------------------------------
# AWS Network Manager Connect Peer
#---------------------------------------------------------------
#
# AWS Cloud WAN Connect AttachmentにおけるConnect Peer（BGPピア）を管理します。
# Connect Peerは、Cloud WANのコアネットワークとサードパーティSD-WANアプライアンスや
# VPN接続などの外部デバイスとの間でBGPベースの通信を確立するために使用されます。
#
# AWS公式ドキュメント:
#   - AWS Cloud WAN: https://docs.aws.amazon.com/vpc/latest/cloudwan/what-is-cloudwan.html
#   - Connect Attachments: https://docs.aws.amazon.com/vpc/latest/cloudwan/cloudwan-attachments-connect.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_connect_peer
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_connect_peer" "example" {
  #-------------------------------------------------------------
  # 接続設定
  #-------------------------------------------------------------

  # connect_attachment_id (Required)
  # 設定内容: このConnect PeerをアタッチするConnect AttachmentのIDを指定します。
  # 設定可能な値: 有効なConnect Attachment ID（"attachment-" で始まる文字列）
  # 省略時: 省略不可
  connect_attachment_id = "attachment-0123456789abcdef0"

  # peer_address (Required)
  # 設定内容: ピアデバイス（外部アプライアンスなど）のIPアドレスを指定します。
  # 設定可能な値: 有効なIPv4またはIPv6アドレス
  # 省略時: 省略不可
  peer_address = "192.0.2.10"

  # core_network_address (Optional)
  # 設定内容: コアネットワーク側のIPアドレスを指定します。
  # 設定可能な値: 有効なIPv4またはIPv6アドレス
  # 省略時: コアネットワーク側で自動的にアドレスが選択されます。
  core_network_address = "192.0.2.1"

  # inside_cidr_blocks (Optional)
  # 設定内容: Connect Peer間のトンネル通信に使用する内部CIDRブロックのリストを指定します。
  # 設定可能な値: IPv4またはIPv6 CIDRブロックのリスト（例: ["169.254.100.0/29"]）
  # 省略時: subnet_arn が指定されている場合は省略可能
  inside_cidr_blocks = ["169.254.100.0/29"]

  # subnet_arn (Optional)
  # 設定内容: Connect PeerをVPCのサブネットに関連付ける場合に、そのサブネットのARNを指定します。
  # 設定可能な値: 有効なサブネットARN
  # 省略時: サブネットへの関連付けを行わない場合は省略します。
  subnet_arn = "arn:aws:ec2:ap-northeast-1:123456789012:subnet/subnet-0123456789abcdef0"

  #-------------------------------------------------------------
  # BGP設定
  #-------------------------------------------------------------

  # bgp_options (Optional)
  # 設定内容: BGPプロトコルのオプション設定を行います。
  # 省略時: BGPオプションはデフォルト設定で動作します。
  bgp_options {
    # peer_asn (Optional)
    # 設定内容: ピアデバイスのBGP自律システム番号（ASN）を指定します。
    # 設定可能な値: 1〜4294967295の整数を文字列で指定
    # 省略時: コアネットワーク側でASNが自動割り当てされます。
    peer_asn = "65000"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: Connect Peerに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されません。
  tags = {
    Name        = "example-connect-peer"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定します。
  # 省略時: Terraformのデフォルトタイムアウトが適用されます。
  timeouts {
    # create (Optional)
    # 設定内容: Connect Peerの作成完了を待機する最大時間を指定します。
    # 設定可能な値: "30m", "1h" などのGoの時間フォーマット文字列
    # 省略時: デフォルトのタイムアウトが適用されます。
    create = "30m"

    # delete (Optional)
    # 設定内容: Connect Peerの削除完了を待機する最大時間を指定します。
    # 設定可能な値: "30m", "1h" などのGoの時間フォーマット文字列
    # 省略時: デフォルトのタイムアウトが適用されます。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Connect PeerのAmazon Resource Name (ARN)
#
# - configuration: Connect Peerの設定情報（bgp_configurations, core_network_address,
#                  inside_cidr_blocks, peer_address, protocolを含むオブジェクトのリスト）
#
# - connect_peer_id: Connect PeerのID
#
# - core_network_id: Connect PeerをホストするコアネットワークのID
#
# - created_at: Connect Peerが作成された日時（ISO 8601形式）
#
# - edge_location: Connect Peerが配置されているエッジロケーション（AWSリージョン）
#
# - id: Connect PeerのID（connect_peer_idと同じ値）
#
# - state: Connect Peerの現在の状態（CREATING, FAILED, AVAILABLE, DELETING など）
#
# - tags_all: プロバイダーのdefault_tags設定から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
