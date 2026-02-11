#---------------------------------------------------------------
# AWS Application Load Balancer (ALB)
#---------------------------------------------------------------
#
# Elastic Load Balancing の Application Load Balancer をプロビジョニングするリソースです。
# ALB はアプリケーション層（Layer 7）で動作し、HTTP/HTTPS トラフィックを
# コンテンツベースでルーティングします。マイクロサービスやコンテナベースの
# アプリケーションに最適化されています。
#
# NOTE: aws_alb は aws_lb のエイリアスです。機能は同一です。
#
# AWS公式ドキュメント:
#   - Application Load Balancer 概要: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html
#   - ALB コンポーネント: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_alb" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: ロードバランサーの名前を指定します。
  # 設定可能な値: 最大32文字の英数字とハイフンのみ。先頭・末尾にハイフン不可。
  # 省略時: Terraform が "tf-lb" で始まる一意の名前を自動生成します。
  # 注意: name_prefix と排他的（どちらか一方のみ指定可能）
  name = "my-application-lb"

  # name_prefix (Optional)
  # 設定内容: ロードバランサー名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraform が後ろにランダムなサフィックスを追加します。
  # 注意: name と排他的（どちらか一方のみ指定可能）
  name_prefix = null

  #-------------------------------------------------------------
  # ロードバランサータイプ設定
  #-------------------------------------------------------------

  # load_balancer_type (Optional)
  # 設定内容: 作成するロードバランサーのタイプを指定します。
  # 設定可能な値:
  #   - "application" (デフォルト): Application Load Balancer (ALB)。Layer 7 で動作。
  #   - "network": Network Load Balancer (NLB)。Layer 4 で動作。
  #   - "gateway": Gateway Load Balancer (GWLB)。サードパーティ仮想アプライアンス向け。
  load_balancer_type = "application"

  # internal (Optional)
  # 設定内容: ロードバランサーを内部用にするかを指定します。
  # 設定可能な値:
  #   - true: 内部ロードバランサー（プライベートサブネット向け）
  #   - false (デフォルト): インターネット向けロードバランサー
  # 注意: 内部 LB は ip_address_type で "ipv4" のみ使用可能です。
  internal = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnets (Optional)
  # 設定内容: ロードバランサーにアタッチするサブネット ID のリストを指定します。
  # 設定可能な値: サブネット ID のリスト
  # 注意:
  #   - subnets または subnet_mapping のどちらかを指定する必要があります。
  #   - network タイプの場合、サブネットは追加のみ可能で、削除するとリソース再作成が必要です。
  # 参考: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/network-load-balancers.html#availability-zones
  subnets = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]

  # security_groups (Optional)
  # 設定内容: ロードバランサーに割り当てるセキュリティグループ ID のリストを指定します。
  # 設定可能な値: セキュリティグループ ID のリスト
  # 対象: application または network タイプのロードバランサーのみ有効
  # 注意: network タイプの場合、セキュリティグループが未設定の状態から追加、
  #       または全削除するとリソース再作成が必要です。
  security_groups = ["sg-xxxxxxxxxxxxxxxxx"]

  # ip_address_type (Optional)
  # 設定内容: サブネットで使用する IP アドレスタイプを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4 アドレスのみ（全タイプ対応）
  #   - "dualstack": IPv4 と IPv6 の両方（全タイプ対応）
  #   - "dualstack-without-public-ipv4": パブリック IPv4 なしのデュアルスタック（application のみ）
  # 注意: 内部 LB は "ipv4" のみ使用可能。dualstack に変更するには IPv6 対応サブネットが必要。
  ip_address_type = "ipv4"

  # customer_owned_ipv4_pool (Optional)
  # 設定内容: AWS Outposts で使用するカスタマー所有 IPv4 プールの ID を指定します。
  # 設定可能な値: カスタマー所有 IPv4 プール ID
  # 関連機能: AWS Outposts
  #   オンプレミス環境でカスタマー所有の IP アドレスプールを使用する場合に指定します。
  customer_owned_ipv4_pool = null

  # secondary_ips_auto_assigned_per_subnet (Optional)
  # 設定内容: ロードバランサーノードごとに構成するセカンダリ IP アドレスの数を指定します。
  # 設定可能な値: 0〜7 の整数
  # 省略時: 0
  # 対象: network タイプのロードバランサーのみ有効
  # 注意: 減少させるとリソース再作成が必要です。
  secondary_ips_auto_assigned_per_subnet = null

  #-------------------------------------------------------------
  # タイムアウト・接続設定
  #-------------------------------------------------------------

  # idle_timeout (Optional)
  # 設定内容: 接続がアイドル状態でいられる時間（秒）を指定します。
  # 設定可能な値: 1〜4000 秒
  # 省略時: 60 秒
  # 対象: application タイプのロードバランサーのみ有効
  idle_timeout = 60

  # client_keep_alive (Optional)
  # 設定内容: クライアントキープアライブの値（秒）を指定します。
  # 設定可能な値: 60〜604800 秒
  # 省略時: 3600 秒
  # 関連機能: HTTP キープアライブ
  #   クライアントとの HTTP 接続を再利用する期間を制御します。
  client_keep_alive = 3600

  #-------------------------------------------------------------
  # HTTP/2 設定
  #-------------------------------------------------------------

  # enable_http2 (Optional)
  # 設定内容: HTTP/2 を有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): HTTP/2 を有効化
  #   - false: HTTP/2 を無効化
  # 対象: application タイプのロードバランサーのみ有効
  enable_http2 = true

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # enable_deletion_protection (Optional)
  # 設定内容: AWS API 経由での削除を防止するかを指定します。
  # 設定可能な値:
  #   - true: 削除保護を有効化。Terraform からの削除もブロックされます。
  #   - false (デフォルト): 削除保護を無効化
  enable_deletion_protection = false

  # drop_invalid_header_fields (Optional)
  # 設定内容: 無効なヘッダーフィールドを持つ HTTP リクエストを削除するかを指定します。
  # 設定可能な値:
  #   - true: 無効なヘッダーを持つリクエストを削除
  #   - false (デフォルト): 無効なヘッダーを持つリクエストをターゲットにルーティング
  # 対象: application タイプのロードバランサーのみ有効
  # 注意: ELB はヘッダー名に英数字とハイフンのみを許可します。
  drop_invalid_header_fields = false

  # desync_mitigation_mode (Optional)
  # 設定内容: HTTP desync によるセキュリティリスクへの対処方法を指定します。
  # 設定可能な値:
  #   - "monitor": 疑わしいリクエストを監視のみ
  #   - "defensive" (デフォルト): RFC 7230 に準拠しないリクエストを拒否
  #   - "strictest": 最も厳格なモード
  # 関連機能: HTTP Desync 緩和
  #   HTTP リクエストスマグリング攻撃からアプリケーションを保護します。
  desync_mitigation_mode = "defensive"

  # enforce_security_group_inbound_rules_on_private_link_traffic (Optional)
  # 設定内容: PrivateLink からのトラフィックにセキュリティグループルールを適用するかを指定します。
  # 設定可能な値:
  #   - "on": セキュリティグループルールを適用
  #   - "off": セキュリティグループルールを適用しない
  # 対象: network タイプのロードバランサーのみ有効
  enforce_security_group_inbound_rules_on_private_link_traffic = null

  #-------------------------------------------------------------
  # クロスゾーン負荷分散設定
  #-------------------------------------------------------------

  # enable_cross_zone_load_balancing (Optional)
  # 設定内容: クロスゾーン負荷分散を有効にするかを指定します。
  # 設定可能な値:
  #   - true: クロスゾーン負荷分散を有効化
  #   - false: クロスゾーン負荷分散を無効化
  # 省略時:
  #   - application: 常に有効（true）で変更不可
  #   - network/gateway: 無効（false）
  # 関連機能: クロスゾーン負荷分散
  #   すべてのアベイラビリティーゾーンのターゲット間でトラフィックを均等に分散します。
  enable_cross_zone_load_balancing = null

  #-------------------------------------------------------------
  # WAF 設定
  #-------------------------------------------------------------

  # enable_waf_fail_open (Optional)
  # 設定内容: WAF がリクエストを処理できない場合にターゲットへルーティングするかを指定します。
  # 設定可能な値:
  #   - true: WAF 障害時もターゲットにルーティング（フェイルオープン）
  #   - false (デフォルト): WAF 障害時はリクエストを拒否
  # 関連機能: AWS WAF フェイルオープン
  #   WAF との統合時の可用性とセキュリティのトレードオフを制御します。
  enable_waf_fail_open = false

  #-------------------------------------------------------------
  # X-Forwarded-For ヘッダー設定
  #-------------------------------------------------------------

  # xff_header_processing_mode (Optional)
  # 設定内容: X-Forwarded-For ヘッダーの処理方法を指定します。
  # 設定可能な値:
  #   - "append" (デフォルト): クライアント IP をヘッダーに追加
  #   - "preserve": 既存のヘッダーをそのまま保持
  #   - "remove": ヘッダーを削除
  # 対象: application タイプのロードバランサーのみ有効
  xff_header_processing_mode = "append"

  # enable_xff_client_port (Optional)
  # 設定内容: X-Forwarded-For ヘッダーにクライアントポートを含めるかを指定します。
  # 設定可能な値:
  #   - true: クライアントポートを含める
  #   - false (デフォルト): クライアントポートを含めない
  # 対象: application タイプのロードバランサーのみ有効
  enable_xff_client_port = false

  # preserve_host_header (Optional)
  # 設定内容: Host ヘッダーを変更せずにターゲットに送信するかを指定します。
  # 設定可能な値:
  #   - true: Host ヘッダーを保持
  #   - false (デフォルト): Host ヘッダーを変更
  # 対象: application タイプのロードバランサーのみ有効
  preserve_host_header = false

  #-------------------------------------------------------------
  # TLS ヘッダー設定
  #-------------------------------------------------------------

  # enable_tls_version_and_cipher_suite_headers (Optional)
  # 設定内容: TLS バージョンと暗号スイートの情報をヘッダーに追加するかを指定します。
  # 設定可能な値:
  #   - true: x-amzn-tls-version と x-amzn-tls-cipher-suite ヘッダーを追加
  #   - false (デフォルト): ヘッダーを追加しない
  # 対象: application タイプのロードバランサーのみ有効
  enable_tls_version_and_cipher_suite_headers = false

  #-------------------------------------------------------------
  # Zonal Shift 設定
  #-------------------------------------------------------------

  # enable_zonal_shift (Optional)
  # 設定内容: ゾーンシフトを有効にするかを指定します。
  # 設定可能な値:
  #   - true: ゾーンシフトを有効化
  #   - false (デフォルト): ゾーンシフトを無効化
  # 関連機能: Amazon Application Recovery Controller (ARC) ゾーンシフト
  #   AZ 障害発生時にトラフィックを別の AZ にシフトする機能です。
  enable_zonal_shift = false

  #-------------------------------------------------------------
  # DNS ルーティングポリシー設定
  #-------------------------------------------------------------

  # dns_record_client_routing_policy (Optional)
  # 設定内容: ロードバランサーの AZ 間でのトラフィック分散方法を指定します。
  # 設定可能な値:
  #   - "any_availability_zone" (デフォルト): 任意の AZ にルーティング
  #   - "availability_zone_affinity": クライアントに最も近い AZ を優先
  #   - "partial_availability_zone_affinity": 部分的な AZ アフィニティ
  # 対象: network タイプのロードバランサーのみ有効
  # 参考: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/network-load-balancers.html#zonal-dns-affinity
  dns_record_client_routing_policy = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-application-lb"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されたタグを含む全タグのマップです。
  # 注意: 通常は明示的に設定せず、Terraform が自動計算します。
  # tags_all = {}

  #-------------------------------------------------------------
  # アクセスログ設定
  #-------------------------------------------------------------

  # access_logs (Optional)
  # 設定内容: アクセスログの S3 バケットへの出力設定を指定します。
  # 関連機能: ELB アクセスログ
  #   ロードバランサーに送信されたリクエストの詳細を S3 に記録します。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html
  access_logs {
    # bucket (Required)
    # 設定内容: ログを保存する S3 バケット名を指定します。
    bucket = "my-lb-access-logs-bucket"

    # prefix (Optional)
    # 設定内容: S3 バケット内のログプレフィックスを指定します。
    # 省略時: ルートに保存されます。
    prefix = "alb-logs"

    # enabled (Optional)
    # 設定内容: アクセスログを有効にするかを指定します。
    # 設定可能な値:
    #   - true: アクセスログを有効化
    #   - false (デフォルト): アクセスログを無効化（bucket を指定しても）
    enabled = true
  }

  #-------------------------------------------------------------
  # 接続ログ設定
  #-------------------------------------------------------------

  # connection_logs (Optional)
  # 設定内容: 接続ログの S3 バケットへの出力設定を指定します。
  # 対象: application タイプのロードバランサーのみ有効
  # 関連機能: ELB 接続ログ
  #   TLS 接続に関する詳細情報を S3 に記録します。
  connection_logs {
    # bucket (Required)
    # 設定内容: ログを保存する S3 バケット名を指定します。
    bucket = "my-lb-connection-logs-bucket"

    # prefix (Optional)
    # 設定内容: S3 バケット内のログプレフィックスを指定します。
    # 省略時: ルートに保存されます。
    prefix = "connection-logs"

    # enabled (Optional)
    # 設定内容: 接続ログを有効にするかを指定します。
    # 設定可能な値:
    #   - true: 接続ログを有効化
    #   - false (デフォルト): 接続ログを無効化（bucket を指定しても）
    enabled = false
  }

  #-------------------------------------------------------------
  # ヘルスチェックログ設定
  #-------------------------------------------------------------

  # health_check_logs (Optional)
  # 設定内容: ヘルスチェックログの S3 バケットへの出力設定を指定します。
  # 対象: application タイプのロードバランサーのみ有効
  # 関連機能: ELB ヘルスチェックログ
  #   ターゲットのヘルスチェック結果を S3 に記録します。
  health_check_logs {
    # bucket (Required)
    # 設定内容: ログを保存する S3 バケット名を指定します。
    bucket = "my-lb-health-check-logs-bucket"

    # prefix (Optional)
    # 設定内容: S3 バケット内のログプレフィックスを指定します。
    # 省略時: ルートに保存されます。
    prefix = "health-check-logs"

    # enabled (Optional)
    # 設定内容: ヘルスチェックログを有効にするかを指定します。
    # 設定可能な値:
    #   - true: ヘルスチェックログを有効化
    #   - false (デフォルト): ヘルスチェックログを無効化（bucket を指定しても）
    enabled = false
  }

  #-------------------------------------------------------------
  # サブネットマッピング設定
  #-------------------------------------------------------------

  # subnet_mapping (Optional)
  # 設定内容: サブネットごとの詳細な設定を指定します。
  # 注意:
  #   - subnets または subnet_mapping のどちらかを指定する必要があります。
  #   - network タイプの場合、サブネットマッピングは追加のみ可能です。
  #   - 各 AZ につき 1 つのサブネットのみ指定可能です。
  subnet_mapping {
    # subnet_id (Required)
    # 設定内容: ロードバランサーにアタッチするサブネット ID を指定します。
    subnet_id = "subnet-xxxxxxxxxxxxxxxxx"

    # allocation_id (Optional)
    # 設定内容: インターネット向けロードバランサー用の Elastic IP のアロケーション ID を指定します。
    # 対象: network タイプのロードバランサーのインターネット向け設定
    allocation_id = null

    # private_ipv4_address (Optional)
    # 設定内容: 内部ロードバランサー用のプライベート IPv4 アドレスを指定します。
    # 対象: 内部ロードバランサー
    private_ipv4_address = null

    # ipv6_address (Optional)
    # 設定内容: IPv6 アドレスを指定します。
    # 注意: VPC に IPv6 CIDR ブロックを関連付け、IPv6 対応サブネットを選択する必要があります。
    ipv6_address = null
  }

  #-------------------------------------------------------------
  # IPAM プール設定
  #-------------------------------------------------------------

  # ipam_pools (Optional)
  # 設定内容: IPAM プールの設定を指定します。
  # 関連機能: Amazon VPC IP Address Manager (IPAM)
  #   IP アドレスの計画、追跡、モニタリングを行うサービスです。
  ipam_pools {
    # ipv4_ipam_pool_id (Required)
    # 設定内容: IPv4 IPAM プールの ID を指定します。
    ipv4_ipam_pool_id = "ipam-pool-xxxxxxxxxxxxxxxxx"
  }

  #-------------------------------------------------------------
  # 最小容量設定
  #-------------------------------------------------------------

  # minimum_load_balancer_capacity (Optional)
  # 設定内容: ロードバランサーの最小容量を指定します。
  # 対象: application または network タイプのロードバランサーのみ有効
  # 関連機能: ELB 容量予約
  #   予測可能な負荷に備えて事前に容量を確保できます。
  minimum_load_balancer_capacity {
    # capacity_units (Required)
    # 設定内容: 容量ユニットの数を指定します。
    capacity_units = 1
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: "10m" などの duration 文字列
    create = "10m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウトを指定します。
    # 設定可能な値: "10m" などの duration 文字列
    update = "10m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: "10m" などの duration 文字列
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ロードバランサーの Amazon Resource Name (ARN)
#
# - arn_suffix: CloudWatch メトリクスで使用する ARN サフィックス
#
# - dns_name: ロードバランサーの DNS 名
#
# - vpc_id: ロードバランサーが属する VPC の ID
#
# - zone_id: ロードバランサーの正規ホストゾーン ID
#            （Route 53 エイリアスレコードで使用）
#
# - subnet_mapping.*.outpost_id: ロードバランサーを含む Outpost の ID
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
