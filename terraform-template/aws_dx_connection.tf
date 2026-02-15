#-------------------------------------------------------------------------------
# AWS Direct Connect 接続
#-------------------------------------------------------------------------------
# AWS Direct Connectの物理的な専用接続を作成するリソースです。
# オンプレミスのデータセンターやコロケーション施設とAWSリージョン間の
# 専用ネットワーク接続を確立します。
#
# 主な用途:
# - オンプレミスとAWS間の安定した低レイテンシ接続
# - インターネット経由よりも一貫性のあるネットワークパフォーマンス
# - 大容量データ転送やハイブリッドクラウド環境の構築
# - MACsec暗号化による高速セキュア通信
#
# 前提条件:
# - Direct Connectロケーションとの物理的な接続手配
# - シングルモードファイバー対応の機器
# - BGPおよびBGP MD5認証のサポート
# - 802.1Q VLANカプセル化のサポート
#
# 関連リソース:
# - aws_dx_gateway: 複数リージョンのVPCへの接続
# - aws_dx_hosted_connection: パートナー経由のホスト接続
# - aws_dx_private_virtual_interface: プライベートVIF
# - aws_dx_public_virtual_interface: パブリックVIF
# - aws_dx_transit_virtual_interface: Transit VIF
# - aws_dx_lag: リンクアグリゲーショングループ
# - aws_dx_connection_association: LAGへの接続関連付け
#
# Terraform ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/dx_connection
#
# Provider Version: 6.28.0
# Generated: 2026-02-14
#
# NOTE: request_macsecを変更するとリソースが再作成されます。
# NOTE: MACsec暗号化は専用接続でのみ利用可能です。
#-------------------------------------------------------------------------------

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_dx_connection" "example" {
  # 設定内容: 接続の名前
  # 必須項目です。Direct Connect接続を識別するための名前を指定します。
  name = "prod-datacenter-connection"

  # 設定内容: 接続の帯域幅
  # 必須項目です。接続タイプに応じた帯域幅を指定します。
  # 設定可能な値:
  #   - 専用接続: 1Gbps, 10Gbps, 100Gbps, 400Gbps
  #   - ホスト接続: 50Mbps, 100Mbps, 200Mbps, 300Mbps, 400Mbps, 500Mbps, 1Gbps, 2Gbps, 5Gbps, 10Gbps, 25Gbps
  # 大文字小文字を区別します(例: "1Gbps"は有効、"1gbps"は無効)。
  bandwidth = "10Gbps"

  # 設定内容: Direct Connectロケーションコード
  # 必須項目です。接続を確立するAWS Direct Connectロケーションを指定します。
  # DescribeLocations APIで取得できるlocationCodeを使用してください。
  # 例: EqDC2(東京)、EqDA2(大阪)、EqSe2(シンガポール)など
  location = "EqDC2"

#---------------------------------------
# 暗号化設定
#---------------------------------------

  # 設定内容: MACsec暗号化対応の接続をリクエスト
  # MACsec(Media Access Control Security)による暗号化をサポートする接続を要求します。
  # 専用接続でのみ利用可能です。10Gbps以上の帯域幅が推奨されます。
  # 設定可能な値: true, false
  # 省略時: false
  # 注意: この値を変更するとリソースが削除・再作成されます。
  request_macsec = true

  # 設定内容: MACsec暗号化モード
  # MACsec対応接続の暗号化動作を制御します。
  # 設定可能な値:
  #   - no_encrypt: 暗号化を行わない
  #   - should_encrypt: 暗号化を推奨(可能な場合に暗号化)
  #   - must_encrypt: 暗号化を必須(暗号化できない場合は接続を拒否)
  # 省略時: AWSのデフォルト設定が適用されます
  # MACsec対応接続(request_macsec = true)でのみ有効です。
  encryption_mode = "must_encrypt"

#---------------------------------------
# プロバイダー設定
#---------------------------------------

  # 設定内容: サービスプロバイダー名
  # 接続に関連付けられたサービスプロバイダーの名前を指定します。
  # Direct Connectパートナー経由で接続を確立する場合に使用します。
  # 省略時: プロバイダー名は設定されません
  provider_name = "Example Telecom"

#---------------------------------------
# リージョン設定
#---------------------------------------

  # 設定内容: 接続を管理するAWSリージョン
  # このリソースを管理するAWSリージョンを指定します。
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 通常はDirect Connectロケーションに最も近いリージョンを指定します。
  region = "ap-northeast-1"

#---------------------------------------
# ライフサイクル管理
#---------------------------------------

  # 設定内容: 削除時にリソースを保持
  # trueに設定すると、terraform destroyを実行してもDirect Connect接続は削除されず、
  # Terraformの状態からのみ削除されます。
  # 設定可能な値: true, false
  # 省略時: false
  # 本番環境の重要な接続を誤って削除することを防ぐために有効にすることを推奨します。
  skip_destroy = true

#---------------------------------------
# タグ設定
#---------------------------------------

  # 設定内容: リソースに付与するタグ
  # 接続を分類・管理するためのタグをキーと値のマップで指定します。
  # プロバイダーのdefault_tagsと重複するキーがある場合、こちらの値が優先されます。
  tags = {
    Name        = "prod-datacenter-connection"
    Environment = "production"
    ManagedBy   = "terraform"
    CostCenter  = "networking"
  }
}

#-------------------------------------------------------------------------------
# 参照可能な属性 (Attributes Reference)
#-------------------------------------------------------------------------------
# arn                      : 接続のARN
# id                       : 接続ID
# aws_device               : 物理接続が終端するDirect Connectエンドポイント
# owner_account_id         : 接続を所有するAWSアカウントID
# partner_name             : 関連付けられたDirect Connectパートナー名
# vlan_id                  : VLAN ID
# has_logical_redundancy   : セカンダリBGPピアのサポート状況(IPv4/IPv6)
# jumbo_frame_capable      : ジャンボフレームのサポート状況
# macsec_capable           : MACsec暗号化のサポート状況
# port_encryption_status   : MACsecポートリンクの暗号化ステータス
# tags_all                 : default_tagsを含む全てのタグ
#-------------------------------------------------------------------------------
