#---------------------------------------------------------------
# AWS Application Load Balancer (ALB)
#---------------------------------------------------------------
#
# Application Load Balancer (ALB) を作成します。
# aws_alb は aws_lb のエイリアスであり、機能は完全に同一です。
#
# ALB は HTTP/HTTPS トラフィックのルーティングに最適化されたロードバランサーで、
# リクエストレベルでのルーティング、コンテンツベースのルーティング、
# WebSocket サポートなどの高度な機能を提供します。
#
# ロードバランサータイプ:
#   - application: レイヤー7（HTTP/HTTPS）ロードバランサー
#   - network: レイヤー4（TCP/UDP/TLS）ロードバランサー
#   - gateway: レイヤー3（IP）ゲートウェイロードバランサー
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       最新情報は公式ドキュメントを参照してください。
# ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_alb" "example" {
  # ロードバランサーの識別名
  # 設定内容: ALBの名前（AWS アカウント内で一意、最大32文字、英数字とハイフンのみ、ハイフンで開始・終了不可）
  # 省略時: Terraform が tf-lb で始まる名前を自動生成
  name = "example-alb"

  # ロードバランサーのタイプ
  # 設定内容: ロードバランサーのタイプを指定
  # 設定可能な値: application / network / gateway
  # 省略時: application
  load_balancer_type = "application"

  # 内部向けロードバランサー設定
  # 設定内容: true の場合、内部向けロードバランサーとして作成
  # 省略時: false（インターネット向け）
  internal = false

  # リージョン設定
  # 設定内容: リソースを管理するリージョンを指定
  # 省略時: プロバイダー設定のリージョン
  region = "ap-northeast-1"
}

#---------------------------------------
# 名前プレフィックスを使用した設定例
#---------------------------------------

resource "aws_alb" "prefix_example" {
  # 名前プレフィックス（name と排他）
  # 設定内容: 指定されたプレフィックスで始まる一意の名前を生成
  name_prefix = "example-"

  load_balancer_type = "application"
  subnets            = ["subnet-12345678", "subnet-87654321"]
}

#---------------------------------------
# ネットワーク設定
#---------------------------------------

resource "aws_alb" "network_example" {
  name               = "network-example"
  load_balancer_type = "application"

  # サブネット設定（subnet_mapping と排他）
  # 設定内容: ロードバランサーをアタッチするサブネットIDのリスト
  # 注意: network タイプの場合、サブネットの追加のみ可能（削除は再作成が必要）
  subnets = ["subnet-12345678", "subnet-87654321"]

  # または subnet_mapping を使用（詳細な設定が必要な場合）
  # 注意: subnets と subnet_mapping のいずれかが必須
  # subnet_mapping {
  #   # サブネットID（必須）
  #   # 設定内容: アタッチするサブネットのID（アベイラビリティゾーンごとに1つのみ指定可能）
  #   subnet_id = "subnet-12345678"
  #
  #   # Elastic IP のアロケーションID（オプション）
  #   # 設定内容: インターネット向けロードバランサー用の Elastic IP アロケーションID
  #   # allocation_id = "eipalloc-12345678"
  #
  #   # プライベート IPv4 アドレス（オプション）
  #   # 設定内容: 内部向けロードバランサー用のプライベートIPv4アドレス
  #   # private_ipv4_address = "10.0.1.15"
  #
  #   # IPv6 アドレス（オプション）
  #   # 設定内容: IPv6アドレスを指定
  #   # ipv6_address = "2001:db8::1"
  # }

  # IP アドレスタイプ
  # 設定内容: サブネットで使用するIPアドレスのタイプ
  # 設定可能な値: ipv4（全タイプ） / dualstack（全タイプ） / dualstack-without-public-ipv4（applicationのみ）
  # 注意: 内部ロードバランサーは ipv4 のみ使用可能。dualstack への変更は IPv6 対応サブネットが必要
  ip_address_type = "ipv4"

  # セキュリティグループ
  # 設定内容: ロードバランサーに割り当てるセキュリティグループIDのリスト
  # 注意: application または network タイプでのみ有効
  # 注意: network タイプの場合、セキュリティグループが未設定の状態では追加不可、全削除すると再作成が必要
  security_groups = ["sg-12345678"]

  # カスタマー所有 IPv4 プール
  # 設定内容: ロードバランサーで使用するカスタマー所有 IPv4 プール ID
  customer_owned_ipv4_pool = "ipv4pool-coip-12345678"

  # セカンダリ IP の自動割り当て数
  # 設定内容: ロードバランサーノードごとに設定するセカンダリIPアドレスの数（0-7）
  # 注意: network タイプでのみ有効。減少時は再作成が必要
  # 省略時: 0
  secondary_ips_auto_assigned_per_subnet = 0

  # IPAM プール設定
  # ipam_pools {
  #   # IPv4 IPAM プール ID（必須）
  #   # 設定内容: IPv4 IPAM プールのID
  #   ipv4_ipam_pool_id = "ipam-pool-12345678"
  # }

  # DNS レコードクライアントルーティングポリシー
  # 設定内容: ロードバランサーのアベイラビリティゾーン間のトラフィック分散方法
  # 設定可能な値: any_availability_zone / availability_zone_affinity / partial_availability_zone_affinity
  # 注意: network タイプでのみ有効
  # 省略時: any_availability_zone
  dns_record_client_routing_policy = "any_availability_zone"

  # ゾーンシフト有効化
  # 設定内容: ゾーンシフトを有効にするかどうか
  # 省略時: false
  enable_zonal_shift = false
}

#---------------------------------------
# トラフィック設定（Application LB）
#---------------------------------------

resource "aws_alb" "traffic_example" {
  name               = "traffic-example"
  load_balancer_type = "application"
  subnets            = ["subnet-12345678", "subnet-87654321"]

  # アイドルタイムアウト
  # 設定内容: 接続がアイドル状態でいられる時間（秒）
  # 注意: application タイプでのみ有効
  # 省略時: 60
  idle_timeout = 60

  # クライアントキープアライブ
  # 設定内容: クライアントキープアライブ値（秒）（60-604800）
  # 省略時: 3600
  client_keep_alive = 3600

  # HTTP/2 有効化
  # 設定内容: application ロードバランサーで HTTP/2 を有効にするかどうか
  # 省略時: true
  enable_http2 = true

  # クロスゾーン負荷分散
  # 設定内容: クロスゾーン負荷分散を有効にするかどうか
  # 注意: network/gateway タイプは省略時 false、application タイプは常に true（変更不可）
  # 省略時: false
  enable_cross_zone_load_balancing = false

  # 最小ロードバランサー容量
  # 注意: application または network タイプでのみ有効
  # minimum_load_balancer_capacity {
  #   # 容量ユニット数（必須）
  #   # 設定内容: 容量ユニット数
  #   capacity_units = 100
  # }
}

#---------------------------------------
# セキュリティ設定
#---------------------------------------

resource "aws_alb" "security_example" {
  name               = "security-example"
  load_balancer_type = "application"
  subnets            = ["subnet-12345678", "subnet-87654321"]

  # 削除保護
  # 設定内容: true の場合、AWS API 経由でのロードバランサー削除を無効化
  # 省略時: false
  enable_deletion_protection = true

  # 無効なヘッダーフィールドのドロップ
  # 設定内容: 無効な HTTP ヘッダーをロードバランサーが削除するか（true）、ターゲットにルーティングするか（false）
  # 注意: application タイプでのみ有効
  # 省略時: false
  drop_invalid_header_fields = false

  # Desync 緩和モード
  # 設定内容: HTTP desync による潜在的なセキュリティリスクの処理方法
  # 設定可能な値: monitor / defensive / strictest
  # 省略時: defensive
  desync_mitigation_mode = "defensive"

  # WAF フェイルオープン有効化
  # 設定内容: WAF にリクエストを転送できない場合にターゲットへのルーティングを許可するかどうか
  # 省略時: false
  enable_waf_fail_open = false

  # PrivateLink トラフィックのセキュリティグループインバウンドルール適用
  # 設定内容: PrivateLink からのトラフィックにセキュリティグループのインバウンドルールを適用するかどうか
  # 設定可能な値: on / off
  # 注意: network タイプでのみ有効
  enforce_security_group_inbound_rules_on_private_link_traffic = "off"
}

#---------------------------------------
# ヘッダー処理設定（Application LB）
#---------------------------------------

resource "aws_alb" "header_example" {
  name               = "header-example"
  load_balancer_type = "application"
  subnets            = ["subnet-12345678", "subnet-87654321"]

  # Host ヘッダー保持
  # 設定内容: HTTP リクエストの Host ヘッダーを変更せずにターゲットに送信するかどうか
  # 省略時: false
  preserve_host_header = false

  # X-Forwarded-For ヘッダー処理モード
  # 設定内容: ターゲットにリクエストを送信する前の X-Forwarded-For ヘッダーの変更方法
  # 設定可能な値: append / preserve / remove
  # 省略時: append
  xff_header_processing_mode = "append"

  # X-Forwarded-For クライアントポート有効化
  # 設定内容: X-Forwarded-For ヘッダーでクライアントがロードバランサーへの接続に使用したポートを保持するかどうか
  # 省略時: false
  enable_xff_client_port = false

  # TLS バージョンと暗号スイートヘッダー有効化
  # 設定内容: ネゴシエートされた TLS バージョンと暗号スイート情報を含む2つのヘッダーを追加するかどうか
  # 注意: application タイプでのみ有効
  # 省略時: false
  enable_tls_version_and_cipher_suite_headers = false
}

#---------------------------------------
# ログ設定
#---------------------------------------

resource "aws_alb" "logging_example" {
  name               = "logging-example"
  load_balancer_type = "application"
  subnets            = ["subnet-12345678", "subnet-87654321"]

  # アクセスログ
  access_logs {
    # S3 バケット名（必須）
    # 設定内容: ログを保存する S3 バケット名
    bucket = "example-alb-logs"

    # ログ有効化（オプション）
    # 設定内容: アクセスログを有効化/無効化
    # 省略時: false（bucket 指定時でも無効）
    enabled = true

    # S3 バケットプレフィックス（オプション）
    # 設定内容: ログの保存先プレフィックス
    # 省略時: ルートに保存
    prefix = "alb-logs"
  }

  # 接続ログ
  # 注意: application タイプでのみ有効
  # connection_logs {
  #   # S3 バケット名（必須）
  #   # 設定内容: ログを保存する S3 バケット名
  #   bucket = "example-connection-logs"
  #
  #   # ログ有効化（オプション）
  #   # 設定内容: 接続ログを有効化/無効化
  #   # 省略時: false（bucket 指定時でも無効）
  #   enabled = true
  #
  #   # S3 バケットプレフィックス（オプション）
  #   # 設定内容: ログの保存先プレフィックス
  #   # 省略時: ルートに保存
  #   prefix = "connection-logs"
  # }

  # ヘルスチェックログ
  # 注意: application タイプでのみ有効
  # health_check_logs {
  #   # S3 バケット名（必須）
  #   # 設定内容: ログを保存する S3 バケット名
  #   bucket = "example-health-check-logs"
  #
  #   # ログ有効化（オプション）
  #   # 設定内容: ヘルスチェックログを有効化/無効化
  #   # 省略時: false（bucket 指定時でも無効）
  #   enabled = true
  #
  #   # S3 バケットプレフィックス（オプション）
  #   # 設定内容: ログの保存先プレフィックス
  #   # 省略時: ルートに保存
  #   prefix = "health-check-logs"
  # }
}

#---------------------------------------
# タグ設定
#---------------------------------------

resource "aws_alb" "tags_example" {
  name               = "tags-example"
  load_balancer_type = "application"
  subnets            = ["subnet-12345678", "subnet-87654321"]

  # タグ
  # 設定内容: リソースに割り当てるタグのマップ
  # 注意: プロバイダーの default_tags と重複するキーは上書きされる
  tags = {
    Name        = "example-alb"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------
# タイムアウト設定
#---------------------------------------

resource "aws_alb" "timeout_example" {
  name               = "timeout-example"
  load_balancer_type = "application"
  subnets            = ["subnet-12345678", "subnet-87654321"]

  timeouts {
    # 作成タイムアウト
    # 設定内容: リソース作成のタイムアウト時間
    create = "10m"

    # 更新タイムアウト
    # 設定内容: リソース更新のタイムアウト時間
    update = "10m"

    # 削除タイムアウト
    # 設定内容: リソース削除のタイムアウト時間
    delete = "10m"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# arn - ロードバランサーのARN
# arn_suffix - CloudWatch Metrics で使用するARNサフィックス
# dns_name - ロードバランサーのDNS名
# id - ロードバランサーのARN（arnと同じ）
# internal - ロードバランサーが内部向けかどうか
# ip_address_type - IPアドレスタイプ
# region - リソースが管理されているリージョン
# security_groups - セキュリティグループIDのセット
# subnet_mapping.*.outpost_id - ロードバランサーを含むOutpostのID
# subnets - サブネットIDのセット
# tags_all - プロバイダーの default_tags を含む全タグのマップ
# vpc_id - VPC ID
# zone_id - Route 53 Alias レコードで使用する正規ホストゾーンID
