terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

#---------------------------------------------------------------
# AWS Direct Connect Private Virtual Interface
#---------------------------------------------------------------
#
# AWS Direct Connectのプライベート仮想インターフェース（Private Virtual Interface）
# をプロビジョニングするリソースです。プライベート仮想インターフェースは、
# Direct Connect接続を介してVPCまたはDirect Connect Gatewayにプライベート
# 接続を確立するために使用されます。
#
# AWS公式ドキュメント:
#   - Direct Connect プライベート仮想インターフェースの作成: https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-private-vif.html
#   - Direct Connect 仮想インターフェース: https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-vif.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_private_virtual_interface
#
# Provider Version: 6.28.0
# Generated: 2026-01-25
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_private_virtual_interface" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # connection_id (Required)
  # 設定内容: 仮想インターフェースを作成するDirect Connect接続（またはLAG）のIDを指定します。
  # 設定可能な値: 有効なDirect Connect接続ID（例: dxcon-xxxxxxxx）またはLAG ID
  # 関連機能: Direct Connect 接続
  #   物理的なDirect Connect接続または論理的なLink Aggregation Group (LAG)に
  #   仮想インターフェースを関連付けます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithConnections.html
  connection_id = "dxcon-xxxxxxxx"

  # name (Required)
  # 設定内容: 仮想インターフェースの名前を指定します。
  # 設定可能な値: 1-255文字の文字列
  # 注意: わかりやすく識別可能な名前を設定することを推奨します。
  name = "vif-example-private"

  # vlan (Required)
  # 設定内容: 仮想ローカルエリアネットワーク（VLAN）のIDを指定します。
  # 設定可能な値: 1-4094の整数
  # 関連機能: VLAN タグ
  #   802.1Qタグを使用してトラフィックを分離します。VLAN IDはDirect Connect接続上で
  #   一意である必要があります。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-vif.html
  vlan = 4094

  # address_family (Required)
  # 設定内容: BGPピアのアドレスファミリを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4アドレスファミリを使用
  #   - "ipv6": IPv6アドレスファミリを使用
  # 注意: IPv4を使用する場合、amazon_addressとcustomer_addressの指定が必須です。
  #       IPv6の場合、AWSが自動的にIPv6アドレスを割り当てます。
  address_family = "ipv4"

  # bgp_asn (Required)
  # 設定内容: BGP（Border Gateway Protocol）設定で使用する自律システム番号（ASN）を指定します。
  # 設定可能な値: 1-4294967294の整数
  #   - 1-2147483647: 標準ASN
  #   - 1-4294967294: 長形式ASN（Long ASN）のサポート
  # 関連機能: BGP ASN
  #   オンプレミスのピアルーターのASN番号を指定します。AWSとのBGPピアリングを
  #   確立するために使用されます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/long-asn-support.html
  bgp_asn = 65352

  #-------------------------------------------------------------
  # ゲートウェイ設定（いずれか一方を指定）
  #-------------------------------------------------------------

  # dx_gateway_id (Optional)
  # 設定内容: 接続先のDirect Connect GatewayのIDを指定します。
  # 設定可能な値: 有効なDirect Connect Gateway ID
  # 関連機能: Direct Connect Gateway
  #   複数のVPCやリージョンにまたがるプライベート接続を実現するためのゲートウェイ。
  #   Direct Connect GatewayまたはVPN Gatewayのいずれか一方のみを指定可能です。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-gateways.html
  # 注意: vpn_gateway_idと排他的（どちらか一方のみ指定可能）
  dx_gateway_id = null

  # vpn_gateway_id (Optional)
  # 設定内容: 接続先の仮想プライベートゲートウェイのIDを指定します。
  # 設定可能な値: 有効なVirtual Private Gateway ID
  # 関連機能: Virtual Private Gateway
  #   VPCに接続されたVPN Gatewayを指定します。同じリージョン内のVPCとの
  #   プライベート接続に使用されます。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/VPC_VPN.html
  # 注意: dx_gateway_idと排他的（どちらか一方のみ指定可能）
  vpn_gateway_id = null

  #-------------------------------------------------------------
  # BGPピアリング設定（IPv4）
  #-------------------------------------------------------------

  # amazon_address (Optional)
  # 設定内容: AWSへトラフィックを送信するために使用するIPv4 CIDRアドレスを指定します。
  # 設定可能な値: 有効なIPv4 CIDR（例: 169.254.255.1/30）
  # 省略時: address_familyが"ipv4"の場合は指定が必須です。
  # 関連機能: BGP Peering IPv4アドレス
  #   RFC 1918プライベートアドレス、他のアドレススキーム、またはAWSが割り当てる
  #   RFC 3927 169.254.0.0/16範囲のIPv4リンクローカルアドレスを使用できます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-private-vif.html
  # 注意: address_familyが"ipv4"の場合、customer_addressと共に必須です。
  #       IPv6の場合、AWSが自動的にアドレスを割り当てるため指定不要です。
  amazon_address = "169.254.255.1/30"

  # customer_address (Optional)
  # 設定内容: Amazonがトラフィックを送信する宛先IPv4 CIDRアドレスを指定します。
  # 設定可能な値: 有効なIPv4 CIDR（例: 169.254.255.2/30）
  # 省略時: address_familyが"ipv4"の場合は指定が必須です。
  # 関連機能: BGP Peering IPv4アドレス
  #   オンプレミスのルーター側のIPv4アドレスを指定します。
  #   amazon_addressと同じサブネット内である必要があります。
  # 注意: address_familyが"ipv4"の場合、amazon_addressと共に必須です。
  customer_address = "169.254.255.2/30"

  #-------------------------------------------------------------
  # BGP認証設定
  #-------------------------------------------------------------

  # bgp_auth_key (Optional)
  # 設定内容: BGP設定の認証キーを指定します。
  # 設定可能な値: MD5ハッシュ用の認証キー文字列
  # 省略時: BGP認証は無効化されます。
  # 関連機能: BGP MD5認証
  #   BGPピアリングのセキュリティを強化するためのMD5認証キー。
  #   オンプレミスルーターにも同じキーを設定する必要があります。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-vif.html
  bgp_auth_key = null

  #-------------------------------------------------------------
  # MTU設定
  #-------------------------------------------------------------

  # mtu (Optional)
  # 設定内容: 接続上で渡すことができる最大許容パケットのサイズ（バイト単位）を指定します。
  # 設定可能な値:
  #   - 1500: 標準フレーム（デフォルト）
  #   - 9001: ジャンボフレーム
  # 省略時: 1500（標準MTU）
  # 関連機能: Maximum Transmission Unit (MTU)
  #   プライベート仮想インターフェースのMTUは1500または9001（ジャンボフレーム）を
  #   指定できます。MTUを8500または9001に設定すると、基盤となる物理接続の更新が
  #   発生する場合があり、その接続に関連付けられた全ての仮想インターフェースの
  #   ネットワーク接続が最大30秒間中断されます。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/create-vif.html
  mtu = 1500

  #-------------------------------------------------------------
  # SiteLink設定
  #-------------------------------------------------------------

  # sitelink_enabled (Optional)
  # 設定内容: SiteLinkを有効または無効にするかを指定します。
  # 設定可能な値:
  #   - true: SiteLinkを有効化
  #   - false: SiteLinkを無効化（デフォルト）
  # 省略時: false
  # 関連機能: AWS Direct Connect SiteLink
  #   Direct Connectロケーション間で直接接続を確立し、データをAWSリージョンを
  #   経由せずにサイト間で転送できるようにする機能です。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/cross-connect-sitelink.html
  sitelink_enabled = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
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
  #   一致するキーを持つタグは、ここで定義されたものがプロバイダーレベルを上書きします。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/using-tags.html
  tags = {
    Name        = "example-private-vif"
    Environment = "production"
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
# - jumbo_frame_capable: ジャンボフレーム（9001 MTU）がサポートされているかを示すブール値
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

