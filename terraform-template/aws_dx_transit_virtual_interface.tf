#---------------------------------------------------------------
# AWS Direct Connect Transit Virtual Interface
#---------------------------------------------------------------
#
# Direct Connect Transit Virtual Interface を作成するリソースです。
# Transit Virtual Interface は Direct Connect Gateway から1つ以上の
# Transit Gateway へトラフィックを転送するVLANです。
#
# Transit Virtual Interface の主な用途:
#   - 複数のVPCへの接続をTransit Gateway経由で集約
#   - 大規模なネットワーク構成での効率的なルーティング
#   - オンプレミス環境とAWSの複数VPC間の接続
#
# AWS公式ドキュメント:
#   - Direct Connect 概要: https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html
#   - Transit Virtual Interface: https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-hosted-transit-vif.html
#   - BGP設定: https://docs.aws.amazon.com/directconnect/latest/UserGuide/routing-and-bgp.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_transit_virtual_interface
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_transit_virtual_interface" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Virtual Interface の名前を指定します。
  # 設定可能な値: 最大100文字の文字列
  # 用途: Virtual Interface を識別するための名前
  # 関連機能: Direct Connect Virtual Interface
  #   コンソールやCLIでの識別に使用されます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  name = "example-transit-vif"

  # connection_id (Required)
  # 設定内容: Virtual Interface を作成する Direct Connect 接続 (またはLAG) のIDを指定します。
  # 設定可能な値: dxcon-xxxxxxxx 形式のConnection ID、または dxlag-xxxxxxxx 形式のLAG ID
  # 用途: 物理的な Direct Connect 接続を指定
  # 関連機能: Direct Connect Connection
  #   物理的な専用線接続上にVirtual Interfaceを作成します。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithConnections.html
  connection_id = "dxcon-xxxxxxxxx"

  # dx_gateway_id (Required)
  # 設定内容: Virtual Interface を接続する Direct Connect Gateway のIDを指定します。
  # 設定可能な値: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx 形式のGateway ID
  # 用途: Transit Gateway への接続を仲介するDirect Connect Gatewayを指定
  # 関連機能: Direct Connect Gateway
  #   複数のリージョンや複数のVPCへの接続を集約するゲートウェイ。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-gateways.html
  dx_gateway_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # vlan (Required)
  # 設定内容: Virtual Interface で使用するVLAN IDを指定します。
  # 設定可能な値: 1 から 4094 の整数
  # 用途: 物理接続上で複数のVirtual Interfaceを分離するために使用
  # 関連機能: VLAN タギング
  #   同一の物理接続上で複数のVirtual Interfaceを作成する際にトラフィックを分離します。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  vlan = 4094

  # address_family (Required)
  # 設定内容: BGPピアのアドレスファミリーを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4アドレスを使用
  #   - "ipv6": IPv6アドレスを使用
  # 用途: BGPセッションで使用するIPアドレスの種類を決定
  # 関連機能: BGP アドレスファミリー
  #   ルーティング情報の交換に使用するIPバージョンを指定します。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/routing-and-bgp.html
  address_family = "ipv4"

  # bgp_asn (Required)
  # 設定内容: BGP設定のための自律システム番号 (ASN) を指定します。
  # 設定可能な値: 1 から 4294967294 の整数
  #   - プライベートASN: 64512-65534, 4200000000-4294967294
  #   - パブリックASN: その他の有効なASN範囲
  # 注意: Transit GatewayとDirect Connect Gatewayで使用するASNとは異なる値を設定する必要があります
  # 用途: オンプレミスルーターを識別するためのASN
  # 関連機能: BGP Autonomous System Number
  #   BGPピアリングでお客様のルーターを識別するために使用されます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/routing-and-bgp.html
  bgp_asn = 65352

  #-------------------------------------------------------------
  # BGP設定 (オプション)
  #-------------------------------------------------------------

  # amazon_address (Optional, Computed)
  # 設定内容: Amazon側のBGPピアIPアドレス (CIDR形式) を指定します。
  # 設定可能な値: CIDR形式のIPv4アドレス (例: "169.254.255.1/30")
  # 省略時: AWSが自動的にアドレスを割り当てます
  # 用途: IPv4 BGPピアの場合に必須。BGPセッションのAmazon側エンドポイントを指定
  # 関連機能: BGP ピアリング
  #   169.254.0.0/16 の範囲からアドレスを割り当てることが一般的です。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/add-peer-to-vif.html
  amazon_address = null

  # customer_address (Optional, Computed)
  # 設定内容: お客様側のBGPピアIPアドレス (CIDR形式) を指定します。
  # 設定可能な値: CIDR形式のIPv4アドレス (例: "169.254.255.2/30")
  # 省略時: AWSが自動的にアドレスを割り当てます
  # 用途: IPv4 BGPピアの場合に必須。BGPセッションのお客様側エンドポイントを指定
  # 関連機能: BGP ピアリング
  #   amazon_addressと同じサブネット内のアドレスを指定する必要があります。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/add-peer-to-vif.html
  customer_address = null

  # bgp_auth_key (Optional, Computed)
  # 設定内容: BGP認証キー (MD5認証) を指定します。
  # 設定可能な値: 6文字以上80文字以下の文字列
  # 省略時: AWSが自動的にキーを生成します
  # 用途: BGPセッションのセキュリティを強化するためのMD5認証
  # 関連機能: BGP MD5 認証
  #   不正なBGPピアリングを防止するためのセキュリティ機能です。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/add-peer-to-vif.html
  bgp_auth_key = null

  #-------------------------------------------------------------
  # MTU設定
  #-------------------------------------------------------------

  # mtu (Optional)
  # 設定内容: 最大伝送単位 (MTU) をバイト単位で指定します。
  # 設定可能な値:
  #   - 1500: 標準MTU (デフォルト)
  #   - 8500: ジャンボフレーム (接続がジャンボフレームをサポートしている場合)
  # 省略時: 1500 (標準MTU)
  # 用途: ネットワークパフォーマンスの最適化
  # 関連機能: ジャンボフレーム
  #   大きなパケットサイズにより、オーバーヘッドを削減しスループットを向上させます。
  #   jumbo_frame_capable属性でサポート状況を確認できます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/set-jumbo-frames-vif.html
  mtu = 1500

  #-------------------------------------------------------------
  # SiteLink設定
  #-------------------------------------------------------------

  # sitelink_enabled (Optional)
  # 設定内容: SiteLink機能の有効/無効を指定します。
  # 設定可能な値:
  #   - true: SiteLinkを有効化
  #   - false: SiteLinkを無効化
  # 省略時: false
  # 用途: 複数のDirect Connectロケーション間でAWSバックボーンネットワークを介した直接通信を実現
  # 関連機能: AWS Direct Connect SiteLink
  #   AWSリージョンを経由せずに、Direct Connectロケーション間でデータを送受信できます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-site-link.html
  sitelink_enabled = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/using-tags.html
  tags = {
    Name        = "example-transit-vif"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: Virtual Interface のID
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 用途: Virtual Interface の作成・更新・削除に時間がかかる場合のタイムアウト調整
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間
    # 設定可能な値: 時間文字列 (例: "10m", "1h")
    # 省略時: デフォルトのタイムアウト値
    create = "10m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間
    # 設定可能な値: 時間文字列 (例: "10m", "1h")
    # 省略時: デフォルトのタイムアウト値
    update = "10m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間
    # 設定可能な値: 時間文字列 (例: "10m", "1h")
    # 省略時: デフォルトのタイムアウト値
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Virtual Interface のID (dxvif-xxxxxxxx 形式)
#
# - arn: Virtual Interface のAmazon Resource Name (ARN)
#
# - aws_device: Virtual Interface が終端するDirect Connectエンドポイント
#   (AWS側のネットワークデバイス)
#
# - jumbo_frame_capable: ジャンボフレーム (8500 MTU) がサポートされているかどうか
#   true の場合、mtu を 8500 に設定可能
#
# - amazon_side_asn: Amazon側のBGP ASN
#   Direct Connect Gateway に設定されたASNが使用されます
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
