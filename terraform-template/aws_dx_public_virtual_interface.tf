#---------------------------------------------------------------
# AWS Direct Connect Public Virtual Interface
#---------------------------------------------------------------
#
# AWS Direct Connect のパブリック仮想インターフェース (VIF) を作成・管理するリソースです。
# パブリック仮想インターフェースは、Amazon S3、DynamoDB、その他の AWS パブリック
# サービスへの Direct Connect 経由でのアクセスを可能にします。
#
# パブリック仮想インターフェースを使用すると、インターネットを経由せずに
# AWS のパブリックエンドポイントに直接接続できます。
#
# AWS公式ドキュメント:
#   - Direct Connect 概要: https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html
#   - パブリック仮想インターフェース: https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
#   - Direct Connect API リファレンス: https://docs.aws.amazon.com/directconnect/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_public_virtual_interface
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_public_virtual_interface" "example" {
  #-------------------------------------------------------------
  # 必須属性
  #-------------------------------------------------------------

  # connection_id (Required)
  # 設定内容: 仮想インターフェースを作成する Direct Connect 接続 (またはLAG) のIDを指定します。
  # 設定可能な値: 有効な Direct Connect 接続ID (例: dxcon-zzzzzzzz) またはLAG ID
  # 用途: パブリック仮想インターフェースを関連付ける物理的な Direct Connect 接続を指定
  # 関連機能: Direct Connect 接続
  #   物理的な専用回線接続。パートナー経由またはAWSロケーションで直接確立。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithConnections.html
  connection_id = "dxcon-zzzzzzzz"

  # name (Required)
  # 設定内容: 仮想インターフェースの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: 仮想インターフェースを識別するための名前
  name = "vif-public-example"

  # vlan (Required)
  # 設定内容: 仮想インターフェースで使用するVLAN IDを指定します。
  # 設定可能な値: 1-4094 の範囲の整数
  # 用途: 802.1Q VLANタグによるトラフィックの識別
  # 注意: 同一接続内でVLAN IDは一意である必要があります
  # 関連機能: VLAN タギング
  #   Direct Connect では VLAN を使用して複数の仮想インターフェースを分離。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  vlan = 4094

  # address_family (Required)
  # 設定内容: BGPピアのアドレスファミリーを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4 BGPセッション
  #   - "ipv6": IPv6 BGPセッション
  # 用途: BGPピアリングで使用するIPバージョンを指定
  # 関連機能: BGP ピアリング
  #   Direct Connect では BGP を使用してルートを交換。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  address_family = "ipv4"

  # bgp_asn (Required)
  # 設定内容: BGP設定で使用する自律システム番号 (AS番号) を指定します。
  # 設定可能な値: 有効なASN (例: 65000-65534 のプライベートASN、またはパブリックASN)
  # 用途: BGPピアリングでお客様側のルーターを識別
  # 注意: パブリック仮想インターフェースでは、所有するパブリックASNを使用することを推奨
  # 関連機能: BGP AS番号
  #   BGP セッション確立に必要。プライベートASNまたは公式に割り当てられたASNを使用。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  bgp_asn = 65352

  # route_filter_prefixes (Required)
  # 設定内容: AWS ネットワークにアドバタイズするルートプレフィックスのリストを指定します。
  # 設定可能な値: CIDR形式のIPアドレスプレフィックスのセット
  # 用途: お客様ネットワークからAWSに到達可能なIPアドレス範囲を定義
  # 注意: パブリック仮想インターフェースでは、お客様が所有するパブリックIPプレフィックスを指定
  # 関連機能: ルートフィルタリング
  #   Direct Connect では許可されたプレフィックスのみがアドバタイズ可能。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  route_filter_prefixes = [
    "210.52.109.0/24",
    "175.45.176.0/22",
  ]

  #-------------------------------------------------------------
  # オプション属性
  #-------------------------------------------------------------

  # amazon_address (Optional, Computed)
  # 設定内容: Amazon側に割り当てるIPv4 CIDRアドレスを指定します。
  # 設定可能な値: /30 または /31 サブネットのIPv4 CIDRアドレス (例: "175.45.176.2/30")
  # 用途: BGPピアリングでのAmazon側のIPアドレス
  # 省略時: AWSが自動的に割り当てます
  # 注意: IPv4 BGPピアの場合に必須。お客様所有のパブリックIPを使用。
  # 関連機能: BGP ピアリングアドレス
  #   Direct Connect BGP セッションで使用するIPアドレス。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  amazon_address = "175.45.176.2/30"

  # customer_address (Optional, Computed)
  # 設定内容: お客様側に割り当てるIPv4 CIDRアドレスを指定します。
  # 設定可能な値: /30 または /31 サブネットのIPv4 CIDRアドレス (例: "175.45.176.1/30")
  # 用途: BGPピアリングでのお客様側のIPアドレス
  # 省略時: AWSが自動的に割り当てます
  # 注意: IPv4 BGPピアの場合に必須。お客様所有のパブリックIPを使用。
  # 関連機能: BGP ピアリングアドレス
  #   Direct Connect BGP セッションで使用するIPアドレス。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  customer_address = "175.45.176.1/30"

  # bgp_auth_key (Optional, Computed)
  # 設定内容: BGP認証で使用するMD5認証キーを指定します。
  # 設定可能な値: 任意の文字列 (MD5認証キー)
  # 省略時: AWSが自動的に生成します
  # 用途: BGPセッションのセキュリティを強化
  # 関連機能: BGP MD5認証
  #   BGP セッションハイジャックを防止するためのセキュリティ機能。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  bgp_auth_key = null

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
    Name        = "public-vif-example"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "10m", "1h")
    # 省略時: デフォルトのタイムアウトが適用されます
    create = "10m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "10m", "1h")
    # 省略時: デフォルトのタイムアウトが適用されます
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 仮想インターフェースのID
#
# - arn: 仮想インターフェースのAmazon Resource Name (ARN)
#
# - aws_device: 仮想インターフェースが終端する Direct Connect エンドポイント
#
# - amazon_side_asn: AWS側の自律システム番号 (ASN)
#   BGPセッションでAWSを識別するために使用されます
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
