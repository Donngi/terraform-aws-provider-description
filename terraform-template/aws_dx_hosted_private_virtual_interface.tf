#---------------------------------------------------------------
# AWS Direct Connect Hosted Private Virtual Interface
#---------------------------------------------------------------
#
# Direct Connect のホステッドプライベート仮想インターフェースをプロビジョニングする
# リソースです。このリソースはホステッド仮想インターフェースの「割り当て元」側を
# 表します。
#
# ホステッド仮想インターフェースとは、他の AWS アカウントが所有する仮想
# インターフェースです。Direct Connect パートナーやサービスプロバイダーが
# 顧客アカウントに対して仮想インターフェースを割り当てる際に使用されます。
#
# AWS公式ドキュメント:
#   - Direct Connect 仮想インターフェース: https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
#   - プライベート仮想インターフェースの作成: https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-vif.html
#   - BGP ピアリング: https://docs.aws.amazon.com/directconnect/latest/UserGuide/add-peer-to-vif.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_hosted_private_virtual_interface
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_hosted_private_virtual_interface" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 仮想インターフェースの名前を指定します。
  # 設定可能な値: 文字列
  name = "vif-example"

  # connection_id (Required)
  # 設定内容: 仮想インターフェースを作成する Direct Connect 接続（または LAG）の ID を指定します。
  # 設定可能な値: "dxcon-xxxxxxxx" または "dxlag-xxxxxxxx" 形式の ID
  connection_id = "dxcon-zzzzzzzz"

  # owner_account_id (Required)
  # 設定内容: 新しい仮想インターフェースを所有する AWS アカウント ID を指定します。
  # 設定可能な値: 12桁の AWS アカウント ID
  # 注意: このアカウントが仮想インターフェースを承認する必要があります。
  owner_account_id = "123456789012"

  # vlan (Required)
  # 設定内容: VLAN ID を指定します。
  # 設定可能な値: 1〜4094 の整数
  # 注意: 同じ Direct Connect 接続上の他の仮想インターフェースと重複不可。
  vlan = 4094

  # address_family (Required)
  # 設定内容: BGP ピアのアドレスファミリーを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4 アドレスを使用
  #   - "ipv6": IPv6 アドレスを使用
  address_family = "ipv4"

  # bgp_asn (Required)
  # 設定内容: BGP 設定用の自律システム番号（ASN）を指定します。
  # 設定可能な値: 1〜4294967294 の整数
  # 注意: オンプレミスルーターの ASN を指定します。プライベート ASN の範囲は
  #       64512〜65534（16ビット）または 4200000000〜4294967294（32ビット）です。
  bgp_asn = 65352

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # amazon_address (Optional)
  # 設定内容: Amazon へのトラフィック送信に使用する IPv4 CIDR アドレスを指定します。
  # 設定可能な値: CIDR 形式の IPv4 アドレス（例: "169.254.0.1/30"）
  # 省略時: Amazon が自動的に割り当てます。
  # 注意: IPv4 BGP ピアには必須です。/30 または /31 サブネットを使用します。
  amazon_address = null

  # customer_address (Optional)
  # 設定内容: Amazon がトラフィックを送信する宛先の IPv4 CIDR アドレスを指定します。
  # 設定可能な値: CIDR 形式の IPv4 アドレス（例: "169.254.0.2/30"）
  # 省略時: Amazon が自動的に割り当てます。
  # 注意: IPv4 BGP ピアには必須です。amazon_address と同じサブネット内である必要があります。
  customer_address = null

  # bgp_auth_key (Optional)
  # 設定内容: BGP 設定の認証キーを指定します。
  # 設定可能な値: MD5 認証キー文字列
  # 省略時: Amazon が自動的に生成します。
  # 注意: MD5 認証はデフォルトで有効になっています。
  bgp_auth_key = null

  # mtu (Optional)
  # 設定内容: 最大伝送単位（MTU）をバイト単位で指定します。
  # 設定可能な値:
  #   - 1500 (デフォルト): 標準 MTU
  #   - 9001: ジャンボフレーム対応
  # 注意: ジャンボフレームを使用するには、Direct Connect 接続がジャンボフレームを
  #       サポートしている必要があります。jumbo_frame_capable 属性で確認できます。
  mtu = 1500

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: "10m" などの duration 文字列
    # 省略時: デフォルトのタイムアウト値が使用されます。
    create = "10m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: "10m" などの duration 文字列
    # 省略時: デフォルトのタイムアウト値が使用されます。
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 仮想インターフェースの ID
#
# - arn: 仮想インターフェースの Amazon Resource Name (ARN)
#
# - jumbo_frame_capable: ジャンボフレーム（9001 MTU）がサポートされているかを示す
#                        ブール値
#
# - aws_device: 仮想インターフェースが終端する Direct Connect エンドポイント
#
# - amazon_side_asn: Amazon 側の BGP ASN
#---------------------------------------------------------------
