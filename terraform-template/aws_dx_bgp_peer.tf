#---------------------------------------------------------------
# AWS Direct Connect BGP Peer
#---------------------------------------------------------------
#
# Direct Connect仮想インターフェース上にBGP (Border Gateway Protocol) ピアを
# 作成するリソースです。BGPピアは、オンプレミスネットワークとAWSの間で
# ルーティング情報を交換するために使用されます。
#
# 仮想インターフェースは最大で1つのIPv4と1つのIPv6のBGPピアリングセッションを
# サポートします。IPv6ピアリングセッションの場合、IPアドレスはAmazonのプールから
# 自動的に割り当てられます。
#
# AWS公式ドキュメント:
#   - Direct Connect BGPピアの追加: https://docs.aws.amazon.com/directconnect/latest/UserGuide/add-peer-to-vif.html
#   - CreateBGPPeer API: https://docs.aws.amazon.com/directconnect/latest/APIReference/API_CreateBGPPeer.html
#   - Direct Connect 概要: https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_bgp_peer
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_bgp_peer" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # virtual_interface_id (Required)
  # 設定内容: BGPピアを作成するDirect Connect仮想インターフェースのIDを指定します。
  # 設定可能な値: 有効なDirect Connect仮想インターフェースID (dxvif-xxxxxxxxx形式)
  # 用途: プライベート、パブリック、またはトランジット仮想インターフェース上にBGPピアを作成
  # 関連機能: Direct Connect 仮想インターフェース
  #   仮想インターフェースはDirect Connect接続を通じてVPCやAWSパブリックサービスへのアクセスを提供。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  virtual_interface_id = aws_dx_private_virtual_interface.example.id

  # address_family (Required)
  # 設定内容: BGPピアのアドレスファミリーを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4アドレスファミリー
  #   - "ipv6": IPv6アドレスファミリー (IPアドレスはAmazonのプールから自動割当)
  # 注意: IPv4/IPv6それぞれのアドレスファミリーでBGPピアを作成する必要があります。
  #       同じアドレスファミリーを使用するAWSリソースにアクセスするために必要。
  # 関連機能: BGP アドレスファミリー
  #   デュアルスタック構成の場合、IPv4とIPv6両方のBGPピアを作成可能。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/add-peer-to-vif.html
  address_family = "ipv4"

  # bgp_asn (Required)
  # 設定内容: オンプレミスルーターのBGP設定に使用する自律システム番号 (ASN) を指定します。
  # 設定可能な値: 1 ~ 4294967294 の整数
  #   - プライベートASN: 64512 ~ 65534 または 4200000000 ~ 4294967294 (推奨)
  #   - パブリックASN: 既に所有しているASN、または許可リストに登録済みのASN
  # 注意: パブリック仮想インターフェースの場合、ASNはプライベートであるか、
  #       仮想インターフェースの許可リストに登録されている必要があります。
  # 関連機能: BGP 自律システム番号
  #   オンプレミスネットワークを識別するための一意の番号。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/set-jumbo-frames-vif.html
  bgp_asn = 65000

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # amazon_address (Optional, Computed)
  # 設定内容: Amazonにトラフィックを送信するために使用するIPv4 CIDRアドレスを指定します。
  # 設定可能な値:
  #   - IPv4 BGPピア: /30 または /31 のCIDR表記のIPv4アドレス
  #   - 例: "169.254.255.1/30" (リンクローカルアドレス)
  # 省略時: AWSが自動的に169.254.0.0/16から /30 CIDRを割り当てます。
  #         ただし、トラフィックの送信元・宛先としてカスタマールーターのIPアドレスを
  #         使用する場合は、RFC 1918アドレスを自分で指定することを推奨。
  # 注意: パブリック仮想インターフェースのIPv4 BGPピアには必須
  # 関連機能: Amazon ピアIPアドレス
  #   BGPセッションのAmazon側のエンドポイントIPアドレス。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/add-peer-to-vif.html
  amazon_address = "169.254.255.1/30"

  # customer_address (Optional, Computed)
  # 設定内容: Amazonがトラフィックを送信する宛先となるIPv4 CIDRアドレスを指定します。
  # 設定可能な値:
  #   - IPv4 BGPピア: /30 または /31 のCIDR表記のIPv4アドレス
  #   - 例: "169.254.255.2/30" (リンクローカルアドレス)
  # 省略時: AWSが自動的に割り当てます。
  # 注意: パブリック仮想インターフェースのIPv4 BGPピアには必須
  #       amazon_addressと同じサブネット内である必要があります。
  # 関連機能: カスタマー ピアIPアドレス
  #   BGPセッションのカスタマー側（オンプレミスルーター）のエンドポイントIPアドレス。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/add-peer-to-vif.html
  customer_address = "169.254.255.2/30"

  # bgp_auth_key (Optional, Computed)
  # 設定内容: BGP設定の認証キー (MD5パスワード) を指定します。
  # 設定可能な値:
  #   - 6文字以上80文字以下の文字列
  #   - 英数字と特定の特殊文字を使用可能
  # 省略時: AWSが自動的に認証キーを生成します。
  # 用途: BGPセッションのセキュリティを強化し、不正なルーティング更新を防止
  # 関連機能: BGP MD5認証
  #   BGPセッションの認証にMD5ハッシュを使用。オンプレミスルーターにも同じキーを設定必要。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/add-peer-to-vif.html
  bgp_auth_key = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1, eu-west-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Direct Connect接続が存在するリージョンを指定する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  # 用途: BGPピアの作成や削除に時間がかかる場合にタイムアウトを延長
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "10m", "30m", "1h")
    # 省略時: デフォルトのタイムアウト値を使用
    # 用途: BGPピアの作成と状態確認に十分な時間を確保
    create = "10m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "10m", "30m", "1h")
    # 省略時: デフォルトのタイムアウト値を使用
    # 用途: BGPピアの削除完了確認に十分な時間を確保
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: BGPピアリソースのID
#
# - bgp_peer_id: BGPピアのID
#
# - bgp_status: BGPピアのUp/Down状態
#   (例: "up", "down", "unknown")
#
# - aws_device: BGPピアが終端するDirect Connectエンドポイント
#
# - amazon_address: BGPピアに割り当てられたAmazon側のIPアドレス
#   (明示的に指定しなかった場合、自動割り当てされた値)
#
# - customer_address: BGPピアに割り当てられたカスタマー側のIPアドレス
#   (明示的に指定しなかった場合、自動割り当てされた値)
#
# - bgp_auth_key: BGPピアに設定された認証キー
#   (明示的に指定しなかった場合、自動生成された値)
#---------------------------------------------------------------

#---------------------------------------------------------------
#---------------------------------------------------------------
