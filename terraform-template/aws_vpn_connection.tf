#---------------------------------------------------------------
# AWS VPN Connection
#---------------------------------------------------------------
#
# AWS Site-to-Site VPN接続をプロビジョニングするリソースです。
# Site-to-Site VPN接続は、VPCとオンプレミスネットワーク間のIPsec VPN接続を提供します。
# Transit GatewayまたはVirtual Private Gatewayを使用して接続できます。
#
# AWS公式ドキュメント:
#   - Site-to-Site VPN概要: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html
#   - VPNトンネルオプション: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNTunnels.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpn_connection" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # customer_gateway_id (Required)
  # 設定内容: カスタマーゲートウェイのIDを指定します。
  # 設定可能な値: 有効なカスタマーゲートウェイID（例: cgw-xxxxxxxxxxxxxxxxx）
  # 関連機能: カスタマーゲートウェイ
  #   オンプレミス側のVPNデバイスを表すAWSリソースです。
  #   - https://docs.aws.amazon.com/vpn/latest/s2svpn/cgw-options.html
  customer_gateway_id = "cgw-xxxxxxxxxxxxxxxxx"

  # type (Required)
  # 設定内容: VPN接続のタイプを指定します。
  # 設定可能な値:
  #   - "ipsec.1": 現在AWSがサポートする唯一のタイプ
  type = "ipsec.1"

  #-------------------------------------------------------------
  # 接続先設定
  #-------------------------------------------------------------

  # transit_gateway_id (Optional)
  # 設定内容: EC2 Transit GatewayのIDを指定します。
  # 設定可能な値: 有効なTransit Gateway ID（例: tgw-xxxxxxxxxxxxxxxxx）
  # 注意: vpn_gateway_idと排他的（どちらか一方のみ指定）
  # 関連機能: Transit Gateway
  #   複数のVPCやオンプレミスネットワークを接続するための中央ハブ。
  #   - https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html
  transit_gateway_id = null

  # vpn_gateway_id (Optional)
  # 設定内容: Virtual Private GatewayのIDを指定します。
  # 設定可能な値: 有効なVPN Gateway ID（例: vgw-xxxxxxxxxxxxxxxxx）
  # 注意: transit_gateway_idと排他的（どちらか一方のみ指定）
  # 関連機能: Virtual Private Gateway
  #   VPCにアタッチするVPNコンセントレータ。
  #   - https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html
  vpn_gateway_id = null

  # vpn_concentrator_id (Optional)
  # 設定内容: VPNコンセントレータのIDを指定します。
  # 設定可能な値: 有効なVPNコンセントレータID
  vpn_concentrator_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ルーティング設定
  #-------------------------------------------------------------

  # static_routes_only (Optional)
  # 設定内容: VPN接続で静的ルートのみを使用するかを指定します。
  # 設定可能な値:
  #   - true: 静的ルートのみを使用（BGPをサポートしないデバイス向け）
  #   - false (デフォルト): BGPを使用した動的ルーティング
  # 関連機能: Site-to-Site VPNルーティングオプション
  #   - https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNRoutingTypes.html
  static_routes_only = false

  #-------------------------------------------------------------
  # ネットワークCIDR設定
  #-------------------------------------------------------------

  # local_ipv4_network_cidr (Optional)
  # 設定内容: カスタマーゲートウェイ（オンプレミス）側のIPv4 CIDRを指定します。
  # 設定可能な値: 有効なIPv4 CIDRブロック
  # 省略時: "0.0.0.0/0"
  local_ipv4_network_cidr = "0.0.0.0/0"

  # local_ipv6_network_cidr (Optional)
  # 設定内容: カスタマーゲートウェイ（オンプレミス）側のIPv6 CIDRを指定します。
  # 設定可能な値: 有効なIPv6 CIDRブロック
  # 省略時: "::/0"
  local_ipv6_network_cidr = null

  # remote_ipv4_network_cidr (Optional)
  # 設定内容: AWS側のIPv4 CIDRを指定します。
  # 設定可能な値: 有効なIPv4 CIDRブロック
  # 省略時: "0.0.0.0/0"
  remote_ipv4_network_cidr = "0.0.0.0/0"

  # remote_ipv6_network_cidr (Optional)
  # 設定内容: AWS側のIPv6 CIDRを指定します。
  # 設定可能な値: 有効なIPv6 CIDRブロック
  # 省略時: "::/0"
  remote_ipv6_network_cidr = null

  #-------------------------------------------------------------
  # IPアドレスタイプ設定
  #-------------------------------------------------------------

  # outside_ip_address_type (Optional)
  # 設定内容: パブリックS2S VPNまたはAWS Direct Connect経由のプライベートS2S VPNを指定します。
  # 設定可能な値:
  #   - "PublicIpv4" (デフォルト): パブリックインターネット経由のVPN
  #   - "PrivateIpv4": AWS Direct Connect経由のプライベートVPN
  # 注意: PrivateIpv4を使用する場合、transport_transit_gateway_attachment_idが必須
  # 関連機能: プライベートIPサイト間VPN
  #   - https://docs.aws.amazon.com/vpn/latest/s2svpn/private-ip-dx.html
  outside_ip_address_type = "PublicIpv4"

  # tunnel_inside_ip_version (Optional)
  # 設定内容: VPNトンネルがIPv4またはIPv6トラフィックを処理するかを指定します。
  # 設定可能な値:
  #   - "ipv4" (デフォルト): IPv4トラフィックを処理
  #   - "ipv6": IPv6トラフィックを処理（EC2 Transit Gatewayのみサポート）
  tunnel_inside_ip_version = "ipv4"

  # transport_transit_gateway_attachment_id (Optional)
  # 設定内容: Direct Connect GatewayへのTransit Gatewayアタッチメントのアタッチメントを指定します。
  # 設定可能な値: 有効なTransit Gatewayアタッチメント ID
  # 注意: outside_ip_address_typeが"PrivateIpv4"の場合に必須。データソースから取得が必要。
  transport_transit_gateway_attachment_id = null

  #-------------------------------------------------------------
  # アクセラレーション設定
  #-------------------------------------------------------------

  # enable_acceleration (Optional)
  # 設定内容: VPN接続のアクセラレーションを有効にするかを指定します。
  # 設定可能な値:
  #   - true: AWS Global Acceleratorを使用してVPN接続を高速化
  #   - false (デフォルト): アクセラレーション無効
  # 注意: EC2 Transit Gatewayのみサポート。tunnel_bandwidthが"large"の場合は使用不可。
  # 関連機能: 高速VPN接続
  #   - https://docs.aws.amazon.com/vpn/latest/s2svpn/accelerated-vpn.html
  enable_acceleration = false

  #-------------------------------------------------------------
  # 帯域幅設定
  #-------------------------------------------------------------

  # tunnel_bandwidth (Optional)
  # 設定内容: VPNトンネルの帯域幅仕様を指定します。
  # 設定可能な値:
  #   - "standard" (デフォルト): トンネルあたり最大1.25 Gbps
  #   - "large": トンネルあたり最大5 Gbps
  # 注意: vpn_gateway_id指定時またはenable_accelerationがtrueの場合は使用不可
  tunnel_bandwidth = "standard"

  #-------------------------------------------------------------
  # 事前共有キー保存設定
  #-------------------------------------------------------------

  # preshared_key_storage (Optional)
  # 設定内容: 事前共有キー（PSK）の保存モードを指定します。
  # 設定可能な値:
  #   - "Standard": Site-to-Site VPNサービスに保存
  #   - "SecretsManager": AWS Secrets Managerに保存
  preshared_key_storage = null

  #-------------------------------------------------------------
  # トンネル1 - 基本設定
  #-------------------------------------------------------------

  # tunnel1_inside_cidr (Optional)
  # 設定内容: 最初のVPNトンネルの内部IPアドレスのCIDRブロックを指定します。
  # 設定可能な値: 169.254.0.0/16範囲から/30のCIDRブロック
  # 注意: 特定の範囲は予約済み
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VpnTunnelOptionsSpecification.html
  tunnel1_inside_cidr = null

  # tunnel1_inside_ipv6_cidr (Optional)
  # 設定内容: 最初のVPNトンネルの内部IPv6アドレスの範囲を指定します。
  # 設定可能な値: ローカルfd00::/8範囲から/126のCIDRブロック
  # 注意: EC2 Transit Gatewayのみサポート
  tunnel1_inside_ipv6_cidr = null

  # tunnel1_preshared_key (Optional, Sensitive)
  # 設定内容: 最初のVPNトンネルの事前共有キーを指定します。
  # 設定可能な値: 8-64文字の英数字、ピリオド(.)、アンダースコア(_)。ゼロ(0)で開始不可。
  # 注意: 機密情報のためTerraform stateに平文で保存される
  tunnel1_preshared_key = null

  #-------------------------------------------------------------
  # トンネル1 - DPD（Dead Peer Detection）設定
  #-------------------------------------------------------------

  # tunnel1_dpd_timeout_action (Optional)
  # 設定内容: 最初のVPNトンネルでDPDタイムアウト発生後のアクションを指定します。
  # 設定可能な値:
  #   - "clear" (デフォルト): IKEセッションを終了
  #   - "none": アクションなし
  #   - "restart": IKEイニシエーションを再開
  tunnel1_dpd_timeout_action = "clear"

  # tunnel1_dpd_timeout_seconds (Optional)
  # 設定内容: 最初のVPNトンネルでDPDタイムアウトが発生するまでの秒数を指定します。
  # 設定可能な値: 30以上の整数
  # 省略時: 30
  tunnel1_dpd_timeout_seconds = 30

  #-------------------------------------------------------------
  # トンネル1 - ライフサイクル制御設定
  #-------------------------------------------------------------

  # tunnel1_enable_tunnel_lifecycle_control (Optional)
  # 設定内容: 最初のVPNトンネルのエンドポイントライフサイクル制御機能を有効にするかを指定します。
  # 設定可能な値:
  #   - true: ライフサイクル制御を有効化
  #   - false (デフォルト): ライフサイクル制御を無効化
  # 関連機能: トンネルエンドポイントライフサイクル制御
  #   - https://docs.aws.amazon.com/vpn/latest/s2svpn/tunnel-endpoint-lifecycle.html
  tunnel1_enable_tunnel_lifecycle_control = false

  # tunnel1_startup_action (Optional)
  # 設定内容: 最初のVPNトンネル確立時のアクションを指定します。
  # 設定可能な値:
  #   - "add" (デフォルト): カスタマーゲートウェイデバイスがIKEネゴシエーションを開始
  #   - "start": AWSがIKEネゴシエーションを開始
  tunnel1_startup_action = "add"

  #-------------------------------------------------------------
  # トンネル1 - IKE設定
  #-------------------------------------------------------------

  # tunnel1_ike_versions (Optional)
  # 設定内容: 最初のVPNトンネルで許可するIKEバージョンを指定します。
  # 設定可能な値: ["ikev1"], ["ikev2"], ["ikev1", "ikev2"]
  tunnel1_ike_versions = null

  #-------------------------------------------------------------
  # トンネル1 - Phase 1 IKE設定
  #-------------------------------------------------------------

  # tunnel1_phase1_dh_group_numbers (Optional)
  # 設定内容: 最初のVPNトンネルのPhase 1 IKEネゴシエーションで許可するDiffie-Hellmanグループ番号を指定します。
  # 設定可能な値: [2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]から1つ以上
  tunnel1_phase1_dh_group_numbers = null

  # tunnel1_phase1_encryption_algorithms (Optional)
  # 設定内容: 最初のVPNトンネルのPhase 1 IKEネゴシエーションで許可する暗号化アルゴリズムを指定します。
  # 設定可能な値: ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]から1つ以上
  tunnel1_phase1_encryption_algorithms = null

  # tunnel1_phase1_integrity_algorithms (Optional)
  # 設定内容: 最初のVPNトンネルのPhase 1 IKEネゴシエーションで許可する整合性アルゴリズムを指定します。
  # 設定可能な値: ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]から1つ以上
  tunnel1_phase1_integrity_algorithms = null

  # tunnel1_phase1_lifetime_seconds (Optional)
  # 設定内容: 最初のVPNトンネルのPhase 1 IKEネゴシエーションのライフタイム（秒）を指定します。
  # 設定可能な値: 900〜28800
  # 省略時: 28800
  tunnel1_phase1_lifetime_seconds = 28800

  #-------------------------------------------------------------
  # トンネル1 - Phase 2 IKE設定
  #-------------------------------------------------------------

  # tunnel1_phase2_dh_group_numbers (Optional)
  # 設定内容: 最初のVPNトンネルのPhase 2 IKEネゴシエーションで許可するDiffie-Hellmanグループ番号を指定します。
  # 設定可能な値: [2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]から1つ以上
  tunnel1_phase2_dh_group_numbers = null

  # tunnel1_phase2_encryption_algorithms (Optional)
  # 設定内容: 最初のVPNトンネルのPhase 2 IKEネゴシエーションで許可する暗号化アルゴリズムを指定します。
  # 設定可能な値: ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]から1つ以上
  tunnel1_phase2_encryption_algorithms = null

  # tunnel1_phase2_integrity_algorithms (Optional)
  # 設定内容: 最初のVPNトンネルのPhase 2 IKEネゴシエーションで許可する整合性アルゴリズムを指定します。
  # 設定可能な値: ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]から1つ以上
  tunnel1_phase2_integrity_algorithms = null

  # tunnel1_phase2_lifetime_seconds (Optional)
  # 設定内容: 最初のVPNトンネルのPhase 2 IKEネゴシエーションのライフタイム（秒）を指定します。
  # 設定可能な値: 900〜3600
  # 省略時: 3600
  tunnel1_phase2_lifetime_seconds = 3600

  #-------------------------------------------------------------
  # トンネル1 - リキー設定
  #-------------------------------------------------------------

  # tunnel1_rekey_fuzz_percentage (Optional)
  # 設定内容: 最初のVPNトンネルのリキーウィンドウにおけるランダム選択の割合を指定します。
  # 設定可能な値: 0〜100
  # 省略時: 100
  tunnel1_rekey_fuzz_percentage = 100

  # tunnel1_rekey_margin_time_seconds (Optional)
  # 設定内容: Phase 2ライフタイム終了前にAWS側がIKEリキーを実行するマージン時間（秒）を指定します。
  # 設定可能な値: 60〜tunnel1_phase2_lifetime_secondsの半分
  # 省略時: 540
  tunnel1_rekey_margin_time_seconds = 540

  #-------------------------------------------------------------
  # トンネル1 - リプレイウィンドウ設定
  #-------------------------------------------------------------

  # tunnel1_replay_window_size (Optional)
  # 設定内容: 最初のVPNトンネルのIKEリプレイウィンドウ内のパケット数を指定します。
  # 設定可能な値: 64〜2048
  # 省略時: 1024
  tunnel1_replay_window_size = 1024

  #-------------------------------------------------------------
  # トンネル1 - ログ設定
  #-------------------------------------------------------------

  # tunnel1_log_options (Optional)
  # 設定内容: 最初のVPNトンネルアクティビティのロギングオプションを指定します。
  tunnel1_log_options {
    cloudwatch_log_options {
      # log_enabled (Optional)
      # 設定内容: VPNトンネルロギング機能を有効にするかを指定します。
      # 設定可能な値:
      #   - true: ロギングを有効化
      #   - false (デフォルト): ロギングを無効化
      log_enabled = false

      # log_group_arn (Optional)
      # 設定内容: ログ送信先のCloudWatch Logsロググループのを指定します。
      # 設定可能な値: 有効なCloudWatch Logsロググループ ARN
      log_group_arn = null

      # log_output_format (Optional)
      # 設定内容: ログ出力フォーマットを指定します。
      # 設定可能な値:
      #   - "json" (デフォルト): JSON形式
      #   - "text": テキスト形式
      log_output_format = "json"

      # bgp_log_enabled (Optional)
      # 設定内容: BGPロギング機能を有効にするかを指定します。
      # 設定可能な値:
      #   - true: BGPロギングを有効化
      #   - false (デフォルト): BGPロギングを無効化
      bgp_log_enabled = false

      # bgp_log_group_arn (Optional)
      # 設定内容: BGPログ送信先のCloudWatch Logsロググループの指定します。
      # 設定可能な値: 有効なCloudWatch Logsロググループ ARN
      bgp_log_group_arn = null

      # bgp_log_output_format (Optional)
      # 設定内容: BGPログ出力フォーマットを指定します。
      # 設定可能な値:
      #   - "json" (デフォルト): JSON形式
      #   - "text": テキスト形式
      bgp_log_output_format = "json"
    }
  }

  #-------------------------------------------------------------
  # トンネル2 - 基本設定
  #-------------------------------------------------------------

  # tunnel2_inside_cidr (Optional)
  # 設定内容: 2番目のVPNトンネルの内部IPアドレスのCIDRブロックを指定します。
  # 設定可能な値: 169.254.0.0/16範囲から/30のCIDRブロック
  # 注意: 特定の範囲は予約済み
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VpnTunnelOptionsSpecification.html
  tunnel2_inside_cidr = null

  # tunnel2_inside_ipv6_cidr (Optional)
  # 設定内容: 2番目のVPNトンネルの内部IPv6アドレスの範囲を指定します。
  # 設定可能な値: ローカルfd00::/8範囲から/126のCIDRブロック
  # 注意: EC2 Transit Gatewayのみサポート
  tunnel2_inside_ipv6_cidr = null

  # tunnel2_preshared_key (Optional, Sensitive)
  # 設定内容: 2番目のVPNトンネルの事前共有キーを指定します。
  # 設定可能な値: 8-64文字の英数字、ピリオド(.)、アンダースコア(_)。ゼロ(0)で開始不可。
  # 注意: 機密情報のためTerraform stateに平文で保存される
  tunnel2_preshared_key = null

  #-------------------------------------------------------------
  # トンネル2 - DPD（Dead Peer Detection）設定
  #-------------------------------------------------------------

  # tunnel2_dpd_timeout_action (Optional)
  # 設定内容: 2番目のVPNトンネルでDPDタイムアウト発生後のアクションを指定します。
  # 設定可能な値:
  #   - "clear" (デフォルト): IKEセッションを終了
  #   - "none": アクションなし
  #   - "restart": IKEイニシエーションを再開
  tunnel2_dpd_timeout_action = "clear"

  # tunnel2_dpd_timeout_seconds (Optional)
  # 設定内容: 2番目のVPNトンネルでDPDタイムアウトが発生するまでの秒数を指定します。
  # 設定可能な値: 30以上の整数
  # 省略時: 30
  tunnel2_dpd_timeout_seconds = 30

  #-------------------------------------------------------------
  # トンネル2 - ライフサイクル制御設定
  #-------------------------------------------------------------

  # tunnel2_enable_tunnel_lifecycle_control (Optional)
  # 設定内容: 2番目のVPNトンネルのエンドポイントライフサイクル制御機能を有効にするかを指定します。
  # 設定可能な値:
  #   - true: ライフサイクル制御を有効化
  #   - false (デフォルト): ライフサイクル制御を無効化
  # 関連機能: トンネルエンドポイントライフサイクル制御
  #   - https://docs.aws.amazon.com/vpn/latest/s2svpn/tunnel-endpoint-lifecycle.html
  tunnel2_enable_tunnel_lifecycle_control = false

  # tunnel2_startup_action (Optional)
  # 設定内容: 2番目のVPNトンネル確立時のアクションを指定します。
  # 設定可能な値:
  #   - "add" (デフォルト): カスタマーゲートウェイデバイスがIKEネゴシエーションを開始
  #   - "start": AWSがIKEネゴシエーションを開始
  tunnel2_startup_action = "add"

  #-------------------------------------------------------------
  # トンネル2 - IKE設定
  #-------------------------------------------------------------

  # tunnel2_ike_versions (Optional)
  # 設定内容: 2番目のVPNトンネルで許可するIKEバージョンを指定します。
  # 設定可能な値: ["ikev1"], ["ikev2"], ["ikev1", "ikev2"]
  tunnel2_ike_versions = null

  #-------------------------------------------------------------
  # トンネル2 - Phase 1 IKE設定
  #-------------------------------------------------------------

  # tunnel2_phase1_dh_group_numbers (Optional)
  # 設定内容: 2番目のVPNトンネルのPhase 1 IKEネゴシエーションで許可するDiffie-Hellmanグループ番号を指定します。
  # 設定可能な値: [2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]から1つ以上
  tunnel2_phase1_dh_group_numbers = null

  # tunnel2_phase1_encryption_algorithms (Optional)
  # 設定内容: 2番目のVPNトンネルのPhase 1 IKEネゴシエーションで許可する暗号化アルゴリズムを指定します。
  # 設定可能な値: ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]から1つ以上
  tunnel2_phase1_encryption_algorithms = null

  # tunnel2_phase1_integrity_algorithms (Optional)
  # 設定内容: 2番目のVPNトンネルのPhase 1 IKEネゴシエーションで許可する整合性アルゴリズムを指定します。
  # 設定可能な値: ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]から1つ以上
  tunnel2_phase1_integrity_algorithms = null

  # tunnel2_phase1_lifetime_seconds (Optional)
  # 設定内容: 2番目のVPNトンネルのPhase 1 IKEネゴシエーションのライフタイム（秒）を指定します。
  # 設定可能な値: 900〜28800
  # 省略時: 28800
  tunnel2_phase1_lifetime_seconds = 28800

  #-------------------------------------------------------------
  # トンネル2 - Phase 2 IKE設定
  #-------------------------------------------------------------

  # tunnel2_phase2_dh_group_numbers (Optional)
  # 設定内容: 2番目のVPNトンネルのPhase 2 IKEネゴシエーションで許可するDiffie-Hellmanグループ番号を指定します。
  # 設定可能な値: [2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]から1つ以上
  tunnel2_phase2_dh_group_numbers = null

  # tunnel2_phase2_encryption_algorithms (Optional)
  # 設定内容: 2番目のVPNトンネルのPhase 2 IKEネゴシエーションで許可する暗号化アルゴリズムを指定します。
  # 設定可能な値: ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]から1つ以上
  tunnel2_phase2_encryption_algorithms = null

  # tunnel2_phase2_integrity_algorithms (Optional)
  # 設定内容: 2番目のVPNトンネルのPhase 2 IKEネゴシエーションで許可する整合性アルゴリズムを指定します。
  # 設定可能な値: ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]から1つ以上
  tunnel2_phase2_integrity_algorithms = null

  # tunnel2_phase2_lifetime_seconds (Optional)
  # 設定内容: 2番目のVPNトンネルのPhase 2 IKEネゴシエーションのライフタイム（秒）を指定します。
  # 設定可能な値: 900〜3600
  # 省略時: 3600
  tunnel2_phase2_lifetime_seconds = 3600

  #-------------------------------------------------------------
  # トンネル2 - リキー設定
  #-------------------------------------------------------------

  # tunnel2_rekey_fuzz_percentage (Optional)
  # 設定内容: 2番目のVPNトンネルのリキーウィンドウにおけるランダム選択の割合を指定します。
  # 設定可能な値: 0〜100
  # 省略時: 100
  tunnel2_rekey_fuzz_percentage = 100

  # tunnel2_rekey_margin_time_seconds (Optional)
  # 設定内容: Phase 2ライフタイム終了前にAWS側がIKEリキーを実行するマージン時間（秒）を指定します。
  # 設定可能な値: 60〜tunnel2_phase2_lifetime_secondsの半分
  # 省略時: 540
  tunnel2_rekey_margin_time_seconds = 540

  #-------------------------------------------------------------
  # トンネル2 - リプレイウィンドウ設定
  #-------------------------------------------------------------

  # tunnel2_replay_window_size (Optional)
  # 設定内容: 2番目のVPNトンネルのIKEリプレイウィンドウ内のパケット数を指定します。
  # 設定可能な値: 64〜2048
  # 省略時: 1024
  tunnel2_replay_window_size = 1024

  #-------------------------------------------------------------
  # トンネル2 - ログ設定
  #-------------------------------------------------------------

  # tunnel2_log_options (Optional)
  # 設定内容: 2番目のVPNトンネルアクティビティのロギングオプションを指定します。
  tunnel2_log_options {
    cloudwatch_log_options {
      # log_enabled (Optional)
      # 設定内容: VPNトンネルロギング機能を有効にするかを指定します。
      # 設定可能な値:
      #   - true: ロギングを有効化
      #   - false (デフォルト): ロギングを無効化
      log_enabled = false

      # log_group_arn (Optional)
      # 設定内容: ログ送信先のCloudWatch Logsロググループのを指定します。
      # 設定可能な値: 有効なCloudWatch Logsロググループ ARN
      log_group_arn = null

      # log_output_format (Optional)
      # 設定内容: ログ出力フォーマットを指定します。
      # 設定可能な値:
      #   - "json" (デフォルト): JSON形式
      #   - "text": テキスト形式
      log_output_format = "json"

      # bgp_log_enabled (Optional)
      # 設定内容: BGPロギング機能を有効にするかを指定します。
      # 設定可能な値:
      #   - true: BGPロギングを有効化
      #   - false (デフォルト): BGPロギングを無効化
      bgp_log_enabled = false

      # bgp_log_group_arn (Optional)
      # 設定内容: BGPログ送信先のCloudWatch Logsロググループの指定します。
      # 設定可能な値: 有効なCloudWatch Logsロググループ ARN
      bgp_log_group_arn = null

      # bgp_log_output_format (Optional)
      # 設定内容: BGPログ出力フォーマットを指定します。
      # 設定可能な値:
      #   - "json" (デフォルト): JSON形式
      #   - "text": テキスト形式
      bgp_log_output_format = "json"
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-vpn-connection"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: VPN接続のAmazon Resource Name (ARN)
#
# - id: VPN接続のAWS割り当てID
#
# - core_network_arn: コアネットワークのARN
#
# - core_network_attachment_arn: コアネットワークアタッチメントのARN
#
# - customer_gateway_configuration: カスタマーゲートウェイのVPN接続設定情報
#   （ネイティブXML形式、機密情報を含む）
#
# - preshared_key_arn: VPN接続の事前共有キーを保存するSecrets ManagerシークレットのARN
#   （preshared_key_storageがSecretsManagerの場合のみ有効）
#
# - routes: VPN接続に関連付けられた静的ルート
#   - destination_cidr_block: カスタマーデータセンターのローカルサブネットに関連付けられたCIDRブロック
#   - source: ルートの提供方法
#   - state: 静的ルートの現在の状態
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - transit_gateway_attachment_id: Transit Gatewayに関連付けられている場合のアタッチメントID
#
# - vgw_telemetry: VPNトンネルのテレメトリ情報
#   - accepted_route_count: 受け入れられたルートの数
#   - certificate_arn: VPNトンネルエンドポイント証明書のARN
#   - last_status_change: 最後のステータス変更の日時
#   - outside_ip_address: VPN GatewayのパブリックIPアドレス
#   - status: VPNトンネルのステータス
#   - status_message: エラー発生時の説明
#
# トンネル1の読み取り専用属性:
# - tunnel1_address: 最初のVPNトンネルのパブリックIPアドレス
# - tunnel1_bgp_asn: 最初のVPNトンネルのBGP ASN番号
# - tunnel1_bgp_holdtime: 最初のVPNトンネルのBGPホールドタイム
# - tunnel1_cgw_inside_address: 最初のVPNトンネルの内部IPアドレス（カスタマーゲートウェイ側）
# - tunnel1_vgw_inside_address: 最初のVPNトンネルの内部IPアドレス（VPN Gateway側）
#
# トンネル2の読み取り専用属性:
# - tunnel2_address: 2番目のVPNトンネルのパブリックIPアドレス
# - tunnel2_bgp_asn: 2番目のVPNトンネルのBGP ASN番号
# - tunnel2_bgp_holdtime: 2番目のVPNトンネルのBGPホールドタイム
# - tunnel2_cgw_inside_address: 2番目のVPNトンネルの内部IPアドレス（カスタマーゲートウェイ側）
# - tunnel2_vgw_inside_address: 2番目のVPNトンネルの内部IPアドレス（VPN Gateway側）
#---------------------------------------------------------------
