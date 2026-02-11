#---------------------------------------------------------------
# AWS Direct Connect Hosted Transit Virtual Interface
#---------------------------------------------------------------
#
# AWS Direct Connect のホスト型トランジット仮想インターフェイスを提供するリソースです。
# このリソースは割り当て側(アロケーター)のホスト型仮想インターフェイスを表します。
# ホスト型仮想インターフェイスは、別のAWSアカウントが所有する仮想インターフェイスです。
#
# トランジット仮想インターフェイスは、Direct Connect ゲートウェイに関連付けられた
# 1つ以上のトランジットゲートウェイにアクセスするために使用され、
# 複数のVPCをDirect Connectゲートウェイに接続できるようにします。
#
# AWS公式ドキュメント:
#   - Direct Connect 概要: https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html
#   - ホスト型仮想インターフェイス: https://docs.aws.amazon.com/directconnect/latest/UserGuide/hosted-vif.html
#   - トランジット仮想インターフェイス作成: https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-hosted-transit-vif.html
#   - Direct Connect API リファレンス: https://docs.aws.amazon.com/directconnect/latest/APIReference/API_AllocateTransitVirtualInterface.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_hosted_transit_virtual_interface
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_hosted_transit_virtual_interface" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # connection_id (Required)
  # 設定内容: 仮想インターフェイスを作成するDirect Connect接続(またはLAG)のIDを指定します。
  # 設定可能な値: 有効なDirect Connect接続IDまたはLAG ID
  # 用途: このホスト型仮想インターフェイスが関連付けられるDirect Connect接続を識別
  # 関連機能: Direct Connect 接続
  #   専用接続またはホスト型接続のいずれかを指定できます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithConnections.html
  connection_id = "dxcon-xxxxxxxx"

  # name (Required)
  # 設定内容: 仮想インターフェイスの名前を指定します。
  # 設定可能な値: 最大100文字の文字列
  # 用途: 仮想インターフェイスを識別するための名前
  # 注意: カスタマーネットワークによって割り当てられる名前です
  name = "tf-transit-vif-example"

  # vlan (Required)
  # 設定内容: VLAN IDを指定します。
  # 設定可能な値: 1-4094の整数値
  # 用途: 仮想インターフェイスのVLANタグを設定
  # 注意: 接続上で一意である必要があります
  # 関連機能: VLAN タグ付け
  #   トラフィックを分離するために802.1Q VLANタグを使用します。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  vlan = 4094

  # address_family (Required)
  # 設定内容: BGPピアのアドレスファミリを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4アドレスファミリ
  #   - "ipv6": IPv6アドレスファミリ
  # 用途: BGPセッションで使用するIPプロトコルバージョンを決定
  # 関連機能: BGP ピアリング
  #   BGPセッションの確立に使用されるIPバージョンを指定します。
  address_family = "ipv4"

  # bgp_asn (Required)
  # 設定内容: Border Gateway Protocol (BGP) 設定用の自律システム番号 (ASN) を指定します。
  # 設定可能な値: 1-2147483647の整数値
  # 用途: オンプレミス側のBGP ASNを設定
  # 注意: トランジットゲートウェイとDirect Connectゲートウェイで使用されるASNは異なる必要があります
  # 関連機能: BGP ASN
  #   BGPルーティングプロトコルで使用される自律システム番号。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-transit-vif-for-gateway.html
  bgp_asn = 65352

  # owner_account_id (Required)
  # 設定内容: 新しい仮想インターフェイスを所有するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 用途: ホスト型仮想インターフェイスの所有者を指定
  # 注意: 異なるアカウントに仮想インターフェイスを割り当てる場合に必須
  # 関連機能: クロスアカウント仮想インターフェイス
  #   他のAWSアカウントが仮想インターフェイスを使用できるようにします。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/hosted-vif.html
  owner_account_id = "123456789012"

  #-------------------------------------------------------------
  # オプションパラメータ - BGP設定
  #-------------------------------------------------------------

  # amazon_address (Optional)
  # 設定内容: Amazonに送信するトラフィックに使用するIPv4 CIDRアドレスを指定します。
  # 設定可能な値: /30または/31のIPv4 CIDRブロック
  # 用途: IPv4 BGPピアの場合に必須
  # 省略時: AWSが自動的にアドレスを割り当てます
  # 注意: IPv4アドレスファミリを使用する場合に必要
  # 関連機能: BGP ピアIP
  #   AWS側のBGPピアIPアドレスを設定します。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  amazon_address = "169.254.0.1/30"

  # customer_address (Optional)
  # 設定内容: Amazonが送信するトラフィックの宛先となるIPv4 CIDRアドレスを指定します。
  # 設定可能な値: /30または/31のIPv4 CIDRブロック
  # 用途: IPv4 BGPピアの場合に必須
  # 省略時: AWSが自動的にアドレスを割り当てます
  # 注意: IPv4アドレスファミリを使用する場合に必要
  # 関連機能: BGP ピアIP
  #   カスタマー側のBGPピアIPアドレスを設定します。
  customer_address = "169.254.0.2/30"

  # bgp_auth_key (Optional)
  # 設定内容: BGP設定の認証キーを指定します。
  # 設定可能な値: 6-80文字の文字列
  # 省略時: AWSが自動的にキーを生成します
  # 用途: BGPセッションのMD5認証に使用
  # 関連機能: BGP 認証
  #   BGPセッションのセキュリティを強化するためのMD5認証キー。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
  bgp_auth_key = null

  #-------------------------------------------------------------
  # オプションパラメータ - ネットワーク設定
  #-------------------------------------------------------------

  # mtu (Optional)
  # 設定内容: 接続上で渡すことができる最大許容パケットサイズ(バイト単位)を指定します。
  # 設定可能な値:
  #   - 1500: 標準フレームサイズ (デフォルト)
  #   - 8500: ジャンボフレーム
  # 省略時: 1500が使用されます
  # 用途: トランジット仮想インターフェイスのMTUサイズを設定
  # 注意: トランジット仮想インターフェイスのMTUは1500または8500である必要があります
  # 関連機能: MTU (Maximum Transmission Unit)
  #   大きなフレームを許可することでスループットを向上できます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/set-jumbo-frames-vif.html
  mtu = 1500

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: リージョン管理
  #   リソースが作成されるAWSリージョンを制御します。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
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
  # 設定内容: リソースのID
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 仮想インターフェイスのID
#
# - arn: 仮想インターフェイスのAmazon Resource Name (ARN)
#
# - aws_device: 仮想インターフェイスが終端するDirect Connectエンドポイント
#
# - jumbo_frame_capable: ジャンボフレーム(8500 MTU)がサポートされているかどうか
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用上の注意事項
#---------------------------------------------------------------
# 1. ホスト型仮想インターフェイスの受け入れ:
#    - このリソースで作成されたホスト型仮想インターフェイスは、
#      owner_account_idで指定されたアカウントによって受け入れられる必要があります
#    - 受け入れには aws_dx_hosted_transit_virtual_interface_accepter リソースを使用します
#
# 2. トランジットゲートウェイとの接続:
#    - トランジット仮想インターフェイスをトランジットゲートウェイに接続するには、
#      Direct Connectゲートウェイとトランジットゲートウェイの関連付けが必要です
#    - トランジットゲートウェイのASNとDirect ConnectゲートウェイのASNは異なる必要があります
#
# 3. ジャンボフレーム:
#    - トランジット仮想インターフェイスはMTU 1500または8500をサポート
#    - エンドツーエンドでジャンボフレームをサポートする必要があります
#
# 4. BGP設定:
#    - BGP ASNはトランジットゲートウェイのASNと異なる必要があります
#    - IPv4を使用する場合、amazon_addressとcustomer_addressの両方を指定する必要があります
#    - IPv6を使用する場合、AWSが自動的にアドレスを割り当てます
#---------------------------------------------------------------
