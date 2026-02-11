#---------------------------------------------------------------
# AWS Direct Connect Hosted Public Virtual Interface
#---------------------------------------------------------------
#
# Direct Connect のホスト型パブリック仮想インターフェースリソースです。
# このリソースはホスト型仮想インターフェースの割り当て側（アロケーター）を表します。
# ホスト型仮想インターフェースは、別のAWSアカウントが所有する仮想インターフェースです。
#
# パブリック仮想インターフェースは、Amazon S3やDynamoDBなどの
# AWSパブリックサービスへのアクセスに使用されます。
#
# AWS公式ドキュメント:
#   - Direct Connect 仮想インターフェース: https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
#   - パブリック仮想インターフェース: https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-vif.html
#   - BGP ピアリング: https://docs.aws.amazon.com/directconnect/latest/UserGuide/set-jumbo-frames-vif.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_hosted_public_virtual_interface
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_hosted_public_virtual_interface" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # connection_id (Required)
  # 設定内容: Direct Connect接続またはLAGのIDを指定します。
  # 設定可能な値: 有効なDirect Connect接続ID (dxcon-xxxxxxxx形式) またはLAG ID
  # 用途: 仮想インターフェースを作成する物理接続を指定
  # 関連機能: Direct Connect 接続
  #   仮想インターフェースは既存のDirect Connect接続上に作成されます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithConnections.html
  connection_id = "dxcon-zzzzzzzz"

  # name (Required)
  # 設定内容: 仮想インターフェースの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: 仮想インターフェースを識別するための名前
  name = "example-hosted-public-vif"

  # vlan (Required)
  # 設定内容: VLAN IDを指定します。
  # 設定可能な値: 1-4094 の整数値
  # 用途: 802.1Qタグ付けに使用されるVLAN識別子
  # 注意: Direct Connect接続内で一意である必要があります
  # 関連機能: VLAN タグ付け
  #   仮想インターフェースのトラフィックを分離するために使用されます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  vlan = 4094

  # address_family (Required)
  # 設定内容: BGPピアのアドレスファミリーを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4アドレスファミリー
  #   - "ipv6": IPv6アドレスファミリー
  # 用途: BGPセッションで使用するIPバージョンを指定
  address_family = "ipv4"

  # bgp_asn (Required)
  # 設定内容: BGP設定の自律システム番号 (ASN) を指定します。
  # 設定可能な値:
  #   - プライベートASN: 64512-65534 (推奨)
  #   - パブリックASN: お客様が所有する有効なASN
  # 用途: BGPピアリングに使用されるASN
  # 関連機能: BGP AS番号
  #   オンプレミスルーターとの BGP ピアリングを確立するために必要です。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  bgp_asn = 65352

  # owner_account_id (Required)
  # 設定内容: 新しい仮想インターフェースを所有するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 用途: ホスト型仮想インターフェースの所有者を指定
  # 注意: これはホスト型VIFの特徴で、別のアカウントに仮想インターフェースを提供します
  owner_account_id = "123456789012"

  # route_filter_prefixes (Required)
  # 設定内容: このリージョンのAWSネットワークにアドバタイズするルートのリストを指定します。
  # 設定可能な値: CIDRプレフィックスの文字列セット
  # 用途: パブリック仮想インターフェース経由でアドバタイズするプレフィックスを指定
  # 関連機能: ルートフィルタリング
  #   パブリックVIFではAWSから受信するルートをフィルタリングするために使用されます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  route_filter_prefixes = [
    "210.52.109.0/24",
    "175.45.176.0/22",
  ]

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # amazon_address (Optional, Computed)
  # 設定内容: Amazonにトラフィックを送信するためのIPv4 CIDRアドレスを指定します。
  # 設定可能な値: IPv4 CIDRアドレス (例: "175.45.176.2/30")
  # 省略時: AWSが自動的にアドレスを割り当てます
  # 用途: IPv4 BGPピアに必須。BGPセッションのAmazon側のIPアドレス
  # 注意: customer_addressと同じサブネット内である必要があります
  amazon_address = "175.45.176.2/30"

  # customer_address (Optional, Computed)
  # 設定内容: Amazonがトラフィックを送信する宛先のIPv4 CIDRアドレスを指定します。
  # 設定可能な値: IPv4 CIDRアドレス (例: "175.45.176.1/30")
  # 省略時: AWSが自動的にアドレスを割り当てます
  # 用途: IPv4 BGPピアに必須。BGPセッションのお客様側（オンプレミス）のIPアドレス
  # 注意: amazon_addressと同じサブネット内である必要があります
  customer_address = "175.45.176.1/30"

  # bgp_auth_key (Optional, Computed)
  # 設定内容: BGP設定の認証キーを指定します。
  # 設定可能な値: BGP MD5認証キー文字列
  # 省略時: AWSが自動的に生成します
  # 用途: BGPセッションのMD5認証に使用
  # 関連機能: BGP MD5認証
  #   BGPセッションのセキュリティを強化するために使用されます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  bgp_auth_key = null

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: 仮想インターフェースのID
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウトを設定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: 時間文字列 (例: "10m", "1h")
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = "10m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: 時間文字列 (例: "10m", "1h")
    # 省略時: デフォルトのタイムアウト値が使用されます
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
# - aws_device: 仮想インターフェースが終端するDirect Connectエンドポイント
#
# - amazon_side_asn: BGPピアリングセッションのAmazon側のASN
#   (Amazonが使用する自律システム番号)
#---------------------------------------------------------------
