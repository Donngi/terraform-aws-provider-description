#-------
# AWS Direct Connect プライベート仮想インターフェース
#-------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# 用途: AWS Direct Connect接続上でプライベートVIFを作成し、VPCやDirect Connect
#       ゲートウェイへのプライベート接続を確立
# 関連ドキュメント: https://docs.aws.amazon.com/directconnect/latest/UserGuide/WorkingWithVirtualInterfaces.html
# Terraform公式ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_private_virtual_interface
#
# NOTE: 重要な注意事項
# - 作成後、AWSによる接続確認が完了するまで利用不可（通常72時間以内）
# - VLANタグは同一接続内で一意である必要あり
# - BGP ASNは既存のピアリングと重複不可
# - MTUは1500または9001（ジャンボフレーム）のみ選択可能
# - IPv4/IPv6で異なるアドレスファミリーが必要な場合は別々のVIFを作成
#-------

#-------
# 基本設定
#-------
resource "aws_dx_private_virtual_interface" "example" {
  # 設定内容: 仮想インターフェースの識別名
  # 省略時: 不可（必須）
  name = "example-private-vif"

  # 設定内容: 親となるDirect Connect接続のID
  # 省略時: 不可（必須）
  # 備考: dx-xxxxxxxx形式のID
  connection_id = "dx-abc12345"

  # 設定内容: VLAN IDタグ（802.1Q）
  # 設定可能な値: 1-4094の整数
  # 省略時: 不可（必須）
  # 備考: 同一接続内で一意である必要あり
  vlan = 100

  # 設定内容: IPアドレスファミリー
  # 設定可能な値: ipv4 / ipv6
  # 省略時: 不可（必須）
  address_family = "ipv4"

  # 設定内容: カスタマー側のBGP ASN（自律システム番号）
  # 設定可能な値: 1-2147483647の整数
  # 省略時: 不可（必須）
  # 備考: パブリックASNまたはプライベートASN（64512-65534, 4200000000-4294967294）
  bgp_asn = 65000

  #-------
  # 接続先設定
  #-------
  # 設定内容: 接続先のVirtual Private Gateway ID
  # 省略時: null（Direct Connect Gatewayを使用する場合）
  # 備考: vpn_gateway_idとdx_gateway_idは排他的（どちらか一方のみ指定）
  vpn_gateway_id = "vgw-abc12345"

  # 設定内容: 接続先のDirect Connect Gateway ID
  # 省略時: null（Virtual Private Gatewayを使用する場合）
  # 備考: vpn_gateway_idとdx_gateway_idは排他的（どちらか一方のみ指定）
  dx_gateway_id = "dx-gw-abc12345"

  #-------
  # BGPピアリング設定
  #-------
  # 設定内容: カスタマー側のピアリングIPアドレス（BGPセッション用）
  # 省略時: 自動割り当て
  # 備考: /30 CIDR（IPv4）または/125 CIDR（IPv6）から選択
  customer_address = "169.254.255.1/30"

  # 設定内容: AWS側のピアリングIPアドレス（BGPセッション用）
  # 省略時: 自動割り当て
  # 備考: /30 CIDR（IPv4）または/125 CIDR（IPv6）から選択
  amazon_address = "169.254.255.2/30"

  # 設定内容: BGP認証キー（MD5パスワード）
  # 省略時: 自動生成
  # 備考: BGPセッション確立時の認証に使用
  bgp_auth_key = "example-bgp-auth-key"

  #-------
  # ネットワーク設定
  #-------
  # 設定内容: Maximum Transmission Unit（最大転送単位）
  # 設定可能な値: 1500 / 9001
  # 省略時: 1500（標準フレーム）
  # 備考: 9001を設定する場合はjumbo_frame_capableがtrueである必要あり
  mtu = 1500

  # 設定内容: SiteLink機能の有効化
  # 設定可能な値: true / false
  # 省略時: false
  # 備考: 有効化すると複数のDirect Connect接続間で直接通信が可能
  sitelink_enabled = false

  #-------
  # リージョン設定
  #-------
  # 設定内容: リソースが管理されるAWSリージョン
  # 省略時: プロバイダーのデフォルトリージョン
  # 備考: 明示的なリージョン指定が必要な場合に使用
  region = "us-east-1"

  #-------
  # タグ設定
  #-------
  # 設定内容: リソースに付与するタグ
  # 省略時: タグなし
  tags = {
    Name        = "example-private-vif"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------
  # タイムアウト設定
  #-------
  timeouts {
    # 設定内容: リソース作成時のタイムアウト時間
    # 省略時: 10m（10分）
    create = "10m"

    # 設定内容: リソース更新時のタイムアウト時間
    # 省略時: 10m（10分）
    update = "10m"

    # 設定内容: リソース削除時のタイムアウト時間
    # 省略時: 10m（10分）
    delete = "10m"
  }
}

#-------
# Outputs（参照用の出力値）
#-------

# output "vif_id" {
#   description = "プライベート仮想インターフェースのID"
#   value       = aws_dx_private_virtual_interface.example.id
# }

# output "vif_arn" {
#   description = "プライベート仮想インターフェースのARN"
#   value       = aws_dx_private_virtual_interface.example.arn
# }

# output "amazon_side_asn" {
#   description = "AWS側のBGP ASN"
#   value       = aws_dx_private_virtual_interface.example.amazon_side_asn
# }

# output "aws_device" {
#   description = "AWS Direct Connectデバイスのエンドポイント"
#   value       = aws_dx_private_virtual_interface.example.aws_device
# }

# output "jumbo_frame_capable" {
#   description = "ジャンボフレームサポートの有無"
#   value       = aws_dx_private_virtual_interface.example.jumbo_frame_capable
# }

#-------
# Attributes Reference（参照可能な属性）
#-------
# id                  - 仮想インターフェースID
# arn                 - 仮想インターフェースのARN
# amazon_side_asn     - AWS側のBGP ASN（自動割り当て）
# aws_device          - AWS Direct Connectデバイスのエンドポイント
# jumbo_frame_capable - ジャンボフレーム（MTU 9001）のサポート可否
# amazon_address      - AWS側ピアリングIPアドレス（自動割り当て時）
# customer_address    - カスタマー側ピアリングIPアドレス（自動割り当て時）
# bgp_auth_key        - BGP認証キー（自動生成時）
# tags_all            - デフォルトタグを含むすべてのタグ
