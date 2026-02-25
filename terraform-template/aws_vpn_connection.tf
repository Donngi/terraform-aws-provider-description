#---------------------------------------------------------------
# AWS Site-to-Site VPN Connection
#---------------------------------------------------------------
#
# オンプレミスネットワークとAWS VPC間のIPsec VPN接続をプロビジョニングするリソースです。
# 各VPN接続は冗長性確保のために2本のトンネルを持ちます。
# 仮想プライベートゲートウェイまたはEC2 Transit Gatewayに接続できます。
#
# AWS公式ドキュメント:
#   - Site-to-Site VPN概要: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html
#   - トンネルオプション: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNTunnels.html
#   - トンネルオプションの設定: https://docs.aws.amazon.com/vpn/latest/s2svpn/tunnel-configure.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpn_connection" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # customer_gateway_id (Required)
  # 設定内容: VPN接続に関連付けるカスタマーゲートウェイのIDを指定します。
  # 設定可能な値: 有効なカスタマーゲートウェイID（例: cgw-xxxxxxxxxxxxxxxxx）
  customer_gateway_id = "cgw-xxxxxxxxxxxxxxxxx"

  # type (Required)
  # 設定内容: VPN接続のタイプを指定します。
  # 設定可能な値: "ipsec.1" （AWSが現在サポートしている唯一のタイプ）
  type = "ipsec.1"

  #-------------------------------------------------------------
  # ゲートウェイ設定
  #-------------------------------------------------------------

  # vpn_gateway_id (Optional)
  # 設定内容: VPN接続を関連付ける仮想プライベートゲートウェイのIDを指定します。
  # 設定可能な値: 有効な仮想プライベートゲートウェイID（例: vgw-xxxxxxxxxxxxxxxxx）
  # 注意: transit_gateway_id または vpn_gateway_id のいずれか一方を指定します。
  vpn_gateway_id = null

  # transit_gateway_id (Optional)
  # 設定内容: VPN接続を関連付けるEC2 Transit GatewayのIDを指定します。
  # 設定可能な値: 有効なTransit Gateway ID（例: tgw-xxxxxxxxxxxxxxxxx）
  # 注意: transit_gateway_id または vpn_gateway_id のいずれか一方を指定します。
  transit_gateway_id = null

  # vpn_concentrator_id (Optional)
  # 設定内容: VPN接続に関連付けるVPNコンセントレーターのIDを指定します。
  # 設定可能な値: 有効なVPNコンセントレーターID
  vpn_concentrator_id = null

  #-------------------------------------------------------------
  # ルーティング設定
  #-------------------------------------------------------------

  # static_routes_only (Optional)
  # 設定内容: VPN接続が静的ルートのみを使用するかどうかを指定します。
  # 設定可能な値:
  #   - true: 静的ルートのみ使用（BGPをサポートしていないデバイス向け）
  #   - false (デフォルト): 動的ルーティング（BGP）も使用可能
  # 省略時: false
  static_routes_only = false

  #-------------------------------------------------------------
  # ネットワークCIDR設定
  #-------------------------------------------------------------

  # local_ipv4_network_cidr (Optional)
  # 設定内容: VPN接続のカスタマーゲートウェイ（オンプレミス）側のIPv4 CIDRを指定します。
  # 設定可能な値: 有効なIPv4 CIDRブロック
  # 省略時: "0.0.0.0/0"
  local_ipv4_network_cidr = null

  # local_ipv6_network_cidr (Optional)
  # 設定内容: VPN接続のカスタマーゲートウェイ（オンプレミス）側のIPv6 CIDRを指定します。
  # 設定可能な値: 有効なIPv6 CIDRブロック
  # 省略時: "::/0"
  local_ipv6_network_cidr = null

  # remote_ipv4_network_cidr (Optional)
  # 設定内容: VPN接続のAWS側のIPv4 CIDRを指定します。
  # 設定可能な値: 有効なIPv4 CIDRブロック
  # 省略時: "0.0.0.0/0"
  remote_ipv4_network_cidr = null

  # remote_ipv6_network_cidr (Optional)
  # 設定内容: VPN接続のAWS側のIPv6 CIDRを指定します。
  # 設定可能な値: 有効なIPv6 CIDRブロック
  # 省略時: "::/0"
  remote_ipv6_network_cidr = null

  #-------------------------------------------------------------
  # 接続モード設定
  #-------------------------------------------------------------

  # outside_ip_address_type (Optional)
  # 設定内容: パブリックS2S VPNかAWS Direct Connect経由のプライベートS2S VPNかを指定します。
  # 設定可能な値:
  #   - "PublicIpv4" (デフォルト): パブリックIPv4アドレスを使用するVPN接続
  #   - "PrivateIpv4": AWS Direct Connect経由のプライベートIPv4アドレスを使用するVPN接続
  # 省略時: "PublicIpv4"
  # 参考: https://docs.aws.amazon.com/vpn/latest/s2svpn/tunnel-configure.html
  outside_ip_address_type = null

  # transport_transit_gateway_attachment_id (Optional)
  # 設定内容: Direct Connect GatewayへのTransit Gateway AttachmentのIDを指定します。
  # 設定可能な値: 有効なTransit Gateway Attachment ID
  # 注意: outside_ip_address_type が "PrivateIpv4" の場合は必須です。
  #       データソースからのみ取得可能です。
  transport_transit_gateway_attachment_id = null

  # enable_acceleration (Optional)
  # 設定内容: VPN接続のAccelerated VPNを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: AWS Global Acceleratorを使用してVPNを高速化
  #   - false (デフォルト): 高速化なし
  # 省略時: false
  # 注意: EC2 Transit Gatewayのみサポート。vpn_gateway_id 指定時は使用不可。
  enable_acceleration = false

  # tunnel_inside_ip_version (Optional)
  # 設定内容: VPNトンネルがIPv4またはIPv6トラフィックを処理するかを指定します。
  # 設定可能な値:
  #   - "ipv4" (デフォルト): IPv4トラフィック
  #   - "ipv6": IPv6トラフィック（EC2 Transit Gatewayのみ）
  # 省略時: "ipv4"
  tunnel_inside_ip_version = null

  # tunnel_bandwidth (Optional)
  # 設定内容: VPNトンネルの帯域幅仕様を指定します。
  # 設定可能な値:
  #   - "standard" (デフォルト): トンネルあたり最大1.25 Gbps
  #   - "large": トンネルあたり最大5 Gbps（Transit GatewayまたはCloud WANへのVPN接続のみ）
  # 省略時: "standard"
  # 注意: vpn_gateway_id 指定時や enable_acceleration が true の場合はサポートされません。
  # 参考: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNTunnels.html
  tunnel_bandwidth = null

  #-------------------------------------------------------------
  # 事前共有キー管理設定
  #-------------------------------------------------------------

  # preshared_key_storage (Optional)
  # 設定内容: 事前共有キー（PSK）のストレージモードを指定します。
  # 設定可能な値:
  #   - "Standard": Site-to-Site VPNサービスに保存
  #   - "SecretsManager": AWS Secrets Managerに保存
  # 注意: 全引数（tunnel1_preshared_key, tunnel2_preshared_keyを含む）はプレーンテキストとして
  #       Terraform stateに保存されます。センシティブデータの取り扱いに注意してください。
  preshared_key_storage = null

  #-------------------------------------------------------------
  # トンネル1 基本設定
  #-------------------------------------------------------------

  # tunnel1_inside_cidr (Optional)
  # 設定内容: 1本目のVPNトンネルのインサイドIPアドレスのCIDRブロックを指定します。
  # 設定可能な値: 169.254.0.0/16 の範囲から /30 サイズの CIDRブロック
  # 注意: tunnel1_preshared_key, tunnel2_preshared_key はプレーンテキストとして state に保存されます。
  tunnel1_inside_cidr = null

  # tunnel1_inside_ipv6_cidr (Optional)
  # 設定内容: 1本目のVPNトンネルのインサイドIPv6アドレスの範囲を指定します。
  # 設定可能な値: ローカルの fd00::/8 の範囲から /126 サイズのCIDRブロック
  # 注意: EC2 Transit Gatewayのみサポート。
  tunnel1_inside_ipv6_cidr = null

  # tunnel1_preshared_key (Optional)
  # 設定内容: 1本目のVPNトンネルの事前共有キーを指定します。
  # 設定可能な値: 8〜64文字の英数字、ピリオド(.)、アンダースコア(_)。先頭に0は使用不可。
  # 注意: この値はプレーンテキストとしてTerraform stateに保存されます。
  tunnel1_preshared_key = null

  #-------------------------------------------------------------
  # トンネル1 IKE設定
  #-------------------------------------------------------------

  # tunnel1_ike_versions (Optional)
  # 設定内容: 1本目のVPNトンネルで許可されるIKEバージョンのリストを指定します。
  # 設定可能な値: "ikev1", "ikev2"（複数指定可）
  # 参考: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNTunnels.html
  tunnel1_ike_versions = null

  # tunnel1_phase1_dh_group_numbers (Optional)
  # 設定内容: 1本目のVPNトンネルのフェーズ1 IKEネゴシエーションで許可される
  #           Diffie-Hellmanグループ番号のリストを指定します。
  # 設定可能な値: 2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24
  tunnel1_phase1_dh_group_numbers = null

  # tunnel1_phase1_encryption_algorithms (Optional)
  # 設定内容: 1本目のVPNトンネルのフェーズ1 IKEネゴシエーションで許可される
  #           暗号化アルゴリズムのリストを指定します。
  # 設定可能な値: "AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"
  tunnel1_phase1_encryption_algorithms = null

  # tunnel1_phase1_integrity_algorithms (Optional)
  # 設定内容: 1本目のVPNトンネルのフェーズ1 IKEネゴシエーションで許可される
  #           整合性アルゴリズムのリストを指定します。
  # 設定可能な値: "SHA1", "SHA2-256", "SHA2-384", "SHA2-512"
  tunnel1_phase1_integrity_algorithms = null

  # tunnel1_phase1_lifetime_seconds (Optional)
  # 設定内容: 1本目のVPNトンネルのフェーズ1 IKEネゴシエーションのライフタイム（秒）を指定します。
  # 設定可能な値: 900〜28800 の数値
  # 省略時: 28800
  tunnel1_phase1_lifetime_seconds = null

  # tunnel1_phase2_dh_group_numbers (Optional)
  # 設定内容: 1本目のVPNトンネルのフェーズ2 IKEネゴシエーションで許可される
  #           Diffie-Hellmanグループ番号のリストを指定します。
  # 設定可能な値: 2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24
  tunnel1_phase2_dh_group_numbers = null

  # tunnel1_phase2_encryption_algorithms (Optional)
  # 設定内容: 1本目のVPNトンネルのフェーズ2 IKEネゴシエーションで許可される
  #           暗号化アルゴリズムのリストを指定します。
  # 設定可能な値: "AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"
  tunnel1_phase2_encryption_algorithms = null

  # tunnel1_phase2_integrity_algorithms (Optional)
  # 設定内容: 1本目のVPNトンネルのフェーズ2 IKEネゴシエーションで許可される
  #           整合性アルゴリズムのリストを指定します。
  # 設定可能な値: "SHA1", "SHA2-256", "SHA2-384", "SHA2-512"
  tunnel1_phase2_integrity_algorithms = null

  # tunnel1_phase2_lifetime_seconds (Optional)
  # 設定内容: 1本目のVPNトンネルのフェーズ2 IKEネゴシエーションのライフタイム（秒）を指定します。
  # 設定可能な値: 900〜3600 の数値
  # 省略時: 3600
  tunnel1_phase2_lifetime_seconds = null

  #-------------------------------------------------------------
  # トンネル1 再接続・DPD設定
  #-------------------------------------------------------------

  # tunnel1_dpd_timeout_seconds (Optional)
  # 設定内容: 1本目のVPNトンネルのDPD（Dead Peer Detection）タイムアウトまでの秒数を指定します。
  # 設定可能な値: 30以上の数値
  # 省略時: 30
  # 参考: https://docs.aws.amazon.com/vpn/latest/s2svpn/initiate-vpn-tunnels.html
  tunnel1_dpd_timeout_seconds = null

  # tunnel1_dpd_timeout_action (Optional)
  # 設定内容: 1本目のVPNトンネルでDPDタイムアウト発生後のアクションを指定します。
  # 設定可能な値:
  #   - "clear" (デフォルト): IKEセッションを終了し、トンネルをダウンさせてルートを削除
  #   - "none": アクションなし
  #   - "restart": IKEイニシエーションを再起動
  # 省略時: "clear"
  # 参考: https://docs.aws.amazon.com/vpn/latest/s2svpn/initiate-vpn-tunnels.html
  tunnel1_dpd_timeout_action = null

  # tunnel1_startup_action (Optional)
  # 設定内容: 1本目のVPNトンネル確立時のアクションを指定します。
  # 設定可能な値:
  #   - "add" (デフォルト): カスタマーゲートウェイデバイスがIKEネゴシエーションを開始
  #   - "start": AWSがIKEネゴシエーションを開始（IKEv2のみサポート）
  # 省略時: "add"
  # 参考: https://docs.aws.amazon.com/vpn/latest/s2svpn/initiate-vpn-tunnels.html
  tunnel1_startup_action = null

  # tunnel1_rekey_margin_time_seconds (Optional)
  # 設定内容: フェーズ2ライフタイム期限前に、AWSがIKEリキーを実行し始めるマージン時間（秒）を指定します。
  # 設定可能な値: 60〜(tunnel1_phase2_lifetime_seconds / 2) の数値
  # 省略時: 540
  tunnel1_rekey_margin_time_seconds = null

  # tunnel1_rekey_fuzz_percentage (Optional)
  # 設定内容: リキーウィンドウのうち、リキー時刻がランダムに選択される割合（%）を指定します。
  # 設定可能な値: 0〜100 の数値
  # 省略時: 100
  tunnel1_rekey_fuzz_percentage = null

  # tunnel1_replay_window_size (Optional)
  # 設定内容: 1本目のVPNトンネルのIKEリプレイウィンドウのパケット数を指定します。
  # 設定可能な値: 64〜2048 の数値
  # 省略時: 1024
  tunnel1_replay_window_size = null

  # tunnel1_enable_tunnel_lifecycle_control (Optional)
  # 設定内容: 1本目のVPNトンネルのトンネルエンドポイントライフサイクル制御機能を有効にするかを指定します。
  # 設定可能な値:
  #   - true: トンネルエンドポイントライフサイクル制御を有効化
  #   - false (デフォルト): 無効
  # 省略時: false
  tunnel1_enable_tunnel_lifecycle_control = null

  #-------------------------------------------------------------
  # トンネル1 ログ設定
  #-------------------------------------------------------------

  # tunnel1_log_options (Optional)
  # 設定内容: 1本目のVPNトンネルのアクティビティログのオプションを指定します。
  tunnel1_log_options {
    #-----------------------------------------------------------
    # CloudWatch ログオプション
    #-----------------------------------------------------------

    # cloudwatch_log_options (Optional)
    # 設定内容: CloudWatch LogsへのVPNトンネルログ送信のオプションを指定します。
    cloudwatch_log_options {
      # log_enabled (Optional)
      # 設定内容: VPNトンネルのログ記録機能を有効にするかどうかを指定します。
      # 設定可能な値:
      #   - true: ログを有効化
      #   - false (デフォルト): ログを無効化
      # 省略時: false
      log_enabled = false

      # log_group_arn (Optional)
      # 設定内容: ログを送信するCloudWatch LogsロググループのARNを指定します。
      # 設定可能な値: 有効なCloudWatch LogsロググループのARN
      log_group_arn = null

      # log_output_format (Optional)
      # 設定内容: ログのフォーマットを指定します。
      # 設定可能な値:
      #   - "json" (デフォルト): JSON形式
      #   - "text": テキスト形式
      # 省略時: "json"
      log_output_format = null

      # bgp_log_enabled (Optional)
      # 設定内容: BGPログ記録機能を有効にするかどうかを指定します。
      # 設定可能な値:
      #   - true: BGPログを有効化
      #   - false (デフォルト): BGPログを無効化
      # 省略時: false
      bgp_log_enabled = false

      # bgp_log_group_arn (Optional)
      # 設定内容: BGPログを送信するCloudWatch LogsロググループのARNを指定します。
      # 設定可能な値: 有効なCloudWatch LogsロググループのARN
      bgp_log_group_arn = null

      # bgp_log_output_format (Optional)
      # 設定内容: BGPログのフォーマットを指定します。
      # 設定可能な値:
      #   - "json" (デフォルト): JSON形式
      #   - "text": テキスト形式
      # 省略時: "json"
      bgp_log_output_format = null
    }
  }

  #-------------------------------------------------------------
  # トンネル2 基本設定
  #-------------------------------------------------------------

  # tunnel2_inside_cidr (Optional)
  # 設定内容: 2本目のVPNトンネルのインサイドIPアドレスのCIDRブロックを指定します。
  # 設定可能な値: 169.254.0.0/16 の範囲から /30 サイズのCIDRブロック
  tunnel2_inside_cidr = null

  # tunnel2_inside_ipv6_cidr (Optional)
  # 設定内容: 2本目のVPNトンネルのインサイドIPv6アドレスの範囲を指定します。
  # 設定可能な値: ローカルの fd00::/8 の範囲から /126 サイズのCIDRブロック
  # 注意: EC2 Transit Gatewayのみサポート。
  tunnel2_inside_ipv6_cidr = null

  # tunnel2_preshared_key (Optional)
  # 設定内容: 2本目のVPNトンネルの事前共有キーを指定します。
  # 設定可能な値: 8〜64文字の英数字、ピリオド(.)、アンダースコア(_)。先頭に0は使用不可。
  # 注意: この値はプレーンテキストとしてTerraform stateに保存されます。
  tunnel2_preshared_key = null

  #-------------------------------------------------------------
  # トンネル2 IKE設定
  #-------------------------------------------------------------

  # tunnel2_ike_versions (Optional)
  # 設定内容: 2本目のVPNトンネルで許可されるIKEバージョンのリストを指定します。
  # 設定可能な値: "ikev1", "ikev2"（複数指定可）
  tunnel2_ike_versions = null

  # tunnel2_phase1_dh_group_numbers (Optional)
  # 設定内容: 2本目のVPNトンネルのフェーズ1 IKEネゴシエーションで許可される
  #           Diffie-Hellmanグループ番号のリストを指定します。
  # 設定可能な値: 2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24
  tunnel2_phase1_dh_group_numbers = null

  # tunnel2_phase1_encryption_algorithms (Optional)
  # 設定内容: 2本目のVPNトンネルのフェーズ1 IKEネゴシエーションで許可される
  #           暗号化アルゴリズムのリストを指定します。
  # 設定可能な値: "AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"
  tunnel2_phase1_encryption_algorithms = null

  # tunnel2_phase1_integrity_algorithms (Optional)
  # 設定内容: 2本目のVPNトンネルのフェーズ1 IKEネゴシエーションで許可される
  #           整合性アルゴリズムのリストを指定します。
  # 設定可能な値: "SHA1", "SHA2-256", "SHA2-384", "SHA2-512"
  tunnel2_phase1_integrity_algorithms = null

  # tunnel2_phase1_lifetime_seconds (Optional)
  # 設定内容: 2本目のVPNトンネルのフェーズ1 IKEネゴシエーションのライフタイム（秒）を指定します。
  # 設定可能な値: 900〜28800 の数値
  # 省略時: 28800
  tunnel2_phase1_lifetime_seconds = null

  # tunnel2_phase2_dh_group_numbers (Optional)
  # 設定内容: 2本目のVPNトンネルのフェーズ2 IKEネゴシエーションで許可される
  #           Diffie-Hellmanグループ番号のリストを指定します。
  # 設定可能な値: 2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24
  tunnel2_phase2_dh_group_numbers = null

  # tunnel2_phase2_encryption_algorithms (Optional)
  # 設定内容: 2本目のVPNトンネルのフェーズ2 IKEネゴシエーションで許可される
  #           暗号化アルゴリズムのリストを指定します。
  # 設定可能な値: "AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"
  tunnel2_phase2_encryption_algorithms = null

  # tunnel2_phase2_integrity_algorithms (Optional)
  # 設定内容: 2本目のVPNトンネルのフェーズ2 IKEネゴシエーションで許可される
  #           整合性アルゴリズムのリストを指定します。
  # 設定可能な値: "SHA1", "SHA2-256", "SHA2-384", "SHA2-512"
  tunnel2_phase2_integrity_algorithms = null

  # tunnel2_phase2_lifetime_seconds (Optional)
  # 設定内容: 2本目のVPNトンネルのフェーズ2 IKEネゴシエーションのライフタイム（秒）を指定します。
  # 設定可能な値: 900〜3600 の数値
  # 省略時: 3600
  tunnel2_phase2_lifetime_seconds = null

  #-------------------------------------------------------------
  # トンネル2 再接続・DPD設定
  #-------------------------------------------------------------

  # tunnel2_dpd_timeout_seconds (Optional)
  # 設定内容: 2本目のVPNトンネルのDPD（Dead Peer Detection）タイムアウトまでの秒数を指定します。
  # 設定可能な値: 30以上の数値
  # 省略時: 30
  tunnel2_dpd_timeout_seconds = null

  # tunnel2_dpd_timeout_action (Optional)
  # 設定内容: 2本目のVPNトンネルでDPDタイムアウト発生後のアクションを指定します。
  # 設定可能な値:
  #   - "clear" (デフォルト): IKEセッションを終了し、トンネルをダウンさせてルートを削除
  #   - "none": アクションなし
  #   - "restart": IKEイニシエーションを再起動
  # 省略時: "clear"
  tunnel2_dpd_timeout_action = null

  # tunnel2_startup_action (Optional)
  # 設定内容: 2本目のVPNトンネル確立時のアクションを指定します。
  # 設定可能な値:
  #   - "add" (デフォルト): カスタマーゲートウェイデバイスがIKEネゴシエーションを開始
  #   - "start": AWSがIKEネゴシエーションを開始（IKEv2のみサポート）
  # 省略時: "add"
  tunnel2_startup_action = null

  # tunnel2_rekey_margin_time_seconds (Optional)
  # 設定内容: フェーズ2ライフタイム期限前に、AWSがIKEリキーを実行し始めるマージン時間（秒）を指定します。
  # 設定可能な値: 60〜(tunnel2_phase2_lifetime_seconds / 2) の数値
  # 省略時: 540
  tunnel2_rekey_margin_time_seconds = null

  # tunnel2_rekey_fuzz_percentage (Optional)
  # 設定内容: リキーウィンドウのうち、リキー時刻がランダムに選択される割合（%）を指定します。
  # 設定可能な値: 0〜100 の数値
  # 省略時: 100
  tunnel2_rekey_fuzz_percentage = null

  # tunnel2_replay_window_size (Optional)
  # 設定内容: 2本目のVPNトンネルのIKEリプレイウィンドウのパケット数を指定します。
  # 設定可能な値: 64〜2048 の数値
  # 省略時: 1024
  tunnel2_replay_window_size = null

  # tunnel2_enable_tunnel_lifecycle_control (Optional)
  # 設定内容: 2本目のVPNトンネルのトンネルエンドポイントライフサイクル制御機能を有効にするかを指定します。
  # 設定可能な値:
  #   - true: トンネルエンドポイントライフサイクル制御を有効化
  #   - false (デフォルト): 無効
  # 省略時: false
  tunnel2_enable_tunnel_lifecycle_control = null

  #-------------------------------------------------------------
  # トンネル2 ログ設定
  #-------------------------------------------------------------

  # tunnel2_log_options (Optional)
  # 設定内容: 2本目のVPNトンネルのアクティビティログのオプションを指定します。
  tunnel2_log_options {
    #-----------------------------------------------------------
    # CloudWatch ログオプション
    #-----------------------------------------------------------

    # cloudwatch_log_options (Optional)
    # 設定内容: CloudWatch LogsへのVPNトンネルログ送信のオプションを指定します。
    cloudwatch_log_options {
      # log_enabled (Optional)
      # 設定内容: VPNトンネルのログ記録機能を有効にするかどうかを指定します。
      # 設定可能な値:
      #   - true: ログを有効化
      #   - false (デフォルト): ログを無効化
      # 省略時: false
      log_enabled = false

      # log_group_arn (Optional)
      # 設定内容: ログを送信するCloudWatch LogsロググループのARNを指定します。
      # 設定可能な値: 有効なCloudWatch LogsロググループのARN
      log_group_arn = null

      # log_output_format (Optional)
      # 設定内容: ログのフォーマットを指定します。
      # 設定可能な値:
      #   - "json" (デフォルト): JSON形式
      #   - "text": テキスト形式
      # 省略時: "json"
      log_output_format = null

      # bgp_log_enabled (Optional)
      # 設定内容: BGPログ記録機能を有効にするかどうかを指定します。
      # 設定可能な値:
      #   - true: BGPログを有効化
      #   - false (デフォルト): BGPログを無効化
      # 省略時: false
      bgp_log_enabled = false

      # bgp_log_group_arn (Optional)
      # 設定内容: BGPログを送信するCloudWatch LogsロググループのARNを指定します。
      # 設定可能な値: 有効なCloudWatch LogsロググループのARN
      bgp_log_group_arn = null

      # bgp_log_output_format (Optional)
      # 設定内容: BGPログのフォーマットを指定します。
      # 設定可能な値:
      #   - "json" (デフォルト): JSON形式
      #   - "text": テキスト形式
      # 省略時: "json"
      bgp_log_output_format = null
    }
  }

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
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
# - id: AWSが割り当てるVPN接続のID
# - core_network_arn: Core NetworkのARN
# - core_network_attachment_arn: Core Network AttachmentのARN
# - customer_gateway_configuration: カスタマーゲートウェイの設定情報（ネイティブXML形式）
# - preshared_key_arn: VPN接続の事前共有キーを保存するSecrets ManagerシークレットのARN
# - transit_gateway_attachment_id: EC2 Transit Gateway接続時のAttachment ID
# - routes: VPN接続に関連付けられた静的ルートのセット
# - vgw_telemetry: VPNトンネルのテレメトリ情報のセット
# - tunnel1_address: 1本目のVPNトンネルのパブリックIPアドレス
# - tunnel1_cgw_inside_address: 1本目のVPNトンネルのインサイドアドレス（カスタマーゲートウェイ側）
# - tunnel1_vgw_inside_address: 1本目のVPNトンネルのインサイドアドレス（VPNゲートウェイ側）
# - tunnel1_bgp_asn: 1本目のVPNトンネルのBGP AS番号
# - tunnel1_bgp_holdtime: 1本目のVPNトンネルのBGPホールドタイム
# - tunnel2_address: 2本目のVPNトンネルのパブリックIPアドレス
# - tunnel2_cgw_inside_address: 2本目のVPNトンネルのインサイドアドレス（カスタマーゲートウェイ側）
# - tunnel2_vgw_inside_address: 2本目のVPNトンネルのインサイドアドレス（VPNゲートウェイ側）
# - tunnel2_bgp_asn: 2本目のVPNトンネルのBGP AS番号
# - tunnel2_bgp_holdtime: 2本目のVPNトンネルのBGPホールドタイム
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
