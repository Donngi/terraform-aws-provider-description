#---------------------------------------------------------------
# Elastic Load Balancer (Application/Network/Gateway)
#---------------------------------------------------------------
#
# Application Load Balancer (ALB)、Network Load Balancer (NLB)、
# Gateway Load Balancer (GWLB) を提供するリソース。
# 複数のターゲット（EC2インスタンス、コンテナ、IPアドレス、Lambdaなど）
# にトラフィックを分散し、アプリケーションの可用性を向上させる。
#
# AWS公式ドキュメント:
#   - Elastic Load Balancing: https://docs.aws.amazon.com/elasticloadbalancing/
#   - Application Load Balancer: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/
#   - Network Load Balancer: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/
#   - Gateway Load Balancer: https://docs.aws.amazon.com/elasticloadbalancing/latest/gateway/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # (Optional) ロードバランサーの名前
  # 32文字以内の英数字またはハイフンのみ使用可能。先頭・末尾はハイフンNG。
  # 指定しない場合、Terraformが "tf-lb" で始まる名前を自動生成する。
  # name と name_prefix は排他的な関係。
  name = "example-lb"

  # (Optional) 名前のプレフィックス
  # 指定したプレフィックスで始まる一意な名前を生成する。
  # name と排他的な関係。どちらか一方のみ指定可能。
  # name_prefix = "example-"

  # (Optional) ロードバランサーのタイプ
  # 可能な値: "application" (デフォルト), "network", "gateway"
  # - application: HTTP/HTTPS トラフィック（Layer 7）
  # - network: TCP/UDP/TLS トラフィック（Layer 4）
  # - gateway: Layer 3 Gateway + Layer 4 Load Balancing
  load_balancer_type = "application"

  # (Optional) 内部ロードバランサーとして作成するか
  # true の場合、VPC内部からのみアクセス可能なロードバランサーを作成。
  # false の場合、インターネット向けロードバランサーを作成（デフォルト）。
  internal = false

  #---------------------------------------------------------------
  # ネットワーク設定
  #---------------------------------------------------------------

  # (Optional) アタッチするサブネットIDのリスト
  # Network Load Balancerの場合、サブネットは追加のみ可能で削除は再作成が必要。
  # subnet_mapping と排他的な関係。どちらか一方は必須。
  subnets = ["subnet-12345678", "subnet-87654321"]

  # (Optional) サブネットマッピングブロック
  # Elastic IPやプライベートIPv4アドレスを指定する場合に使用。
  # subnets と排他的な関係。どちらか一方は必須。
  # Network Load Balancerの場合、マッピングは追加のみ可能。
  # subnet_mapping {
  #   subnet_id            = "subnet-12345678"
  #   allocation_id        = "eipalloc-12345678"  # Elastic IP
  #   ipv6_address         = "2001:db8::1"        # IPv6アドレス
  #   private_ipv4_address = "10.0.1.15"          # プライベートIPv4
  # }

  # (Optional) セキュリティグループIDのリスト
  # application または network タイプのロードバランサーでのみ有効。
  # network タイプの場合、セキュリティグループが存在しない状態から追加はできず、
  # すべてのセキュリティグループを削除することもできない（再作成が必要）。
  security_groups = ["sg-12345678"]

  # (Optional) IPアドレスタイプ
  # 可能な値: "ipv4" (全タイプ), "dualstack" (全タイプ),
  #          "dualstack-without-public-ipv4" (application のみ)
  # 内部ロードバランサーは ipv4 のみ使用可能。
  # dualstack に変更する場合、選択したサブネットがIPv6有効化されている必要がある。
  ip_address_type = "ipv4"

  # (Optional) カスタマー所有IPv4プールのID
  # customer_owned_ipv4_pool = "pool-12345678"

  # (Optional) サブネットごとに自動割り当てされるセカンダリIPアドレスの数
  # network タイプのロードバランサーでのみ有効。
  # 有効範囲: 0-7（デフォルト: 0）
  # 値を減らす場合、リソースの再作成が必要。
  # secondary_ips_auto_assigned_per_subnet = 0

  #---------------------------------------------------------------
  # 可用性とゾーン設定
  #---------------------------------------------------------------

  # (Optional) クロスゾーンロードバランシングを有効化するか
  # - network/gateway タイプ: デフォルトで無効 (false)
  # - application タイプ: 常に有効 (true)、無効化不可
  enable_cross_zone_load_balancing = false

  # (Optional) DNS レコードのクライアントルーティングポリシー
  # network タイプのロードバランサーでのみ有効。
  # 可能な値: "any_availability_zone" (デフォルト),
  #          "availability_zone_affinity",
  #          "partial_availability_zone_affinity"
  # Availability Zone DNS affinity の設定。
  # dns_record_client_routing_policy = "any_availability_zone"

  # (Optional) ゾーナルシフトを有効化するか
  # デフォルト: false
  # enable_zonal_shift = false

  #---------------------------------------------------------------
  # Application Load Balancer 固有設定
  #---------------------------------------------------------------

  # (Optional) HTTP/2 を有効化するか
  # application タイプでのみ有効。デフォルト: true
  enable_http2 = true

  # (Optional) アイドルタイムアウト（秒）
  # application タイプでのみ有効。
  # 接続がアイドル状態を許容する時間。デフォルト: 60秒
  idle_timeout = 60

  # (Optional) クライアントキープアライブ値（秒）
  # 有効範囲: 60-604800秒。デフォルト: 3600秒
  # client_keep_alive = 3600

  # (Optional) 無効なヘッダーフィールドを削除するか
  # application タイプでのみ有効。
  # true の場合、ロードバランサーが無効なHTTPヘッダーを削除する。
  # false の場合、無効なヘッダーもターゲットにルーティングされる（デフォルト）。
  drop_invalid_header_fields = false

  # (Optional) HTTP desync 緩和モード
  # application タイプでのみ有効。
  # 可能な値: "monitor", "defensive" (デフォルト), "strictest"
  # HTTP desync によるセキュリティリスクへの対処方法を設定。
  desync_mitigation_mode = "defensive"

  # (Optional) Host ヘッダーを保持するか
  # application タイプでのみ有効。デフォルト: false
  # true の場合、HTTPリクエストのHostヘッダーを変更せずにターゲットに送信。
  preserve_host_header = false

  # (Optional) X-Forwarded-For ヘッダーの処理モード
  # application タイプでのみ有効。
  # 可能な値: "append" (デフォルト), "preserve", "remove"
  # リクエストをターゲットに送信する前の X-Forwarded-For ヘッダーの変更方法。
  xff_header_processing_mode = "append"

  # (Optional) X-Forwarded-For ヘッダーにクライアントポートを保持するか
  # application タイプでのみ有効。デフォルト: false
  # true の場合、クライアントが使用したソースポートを保持。
  enable_xff_client_port = false

  # (Optional) TLS バージョンと暗号スイートのヘッダーを有効化するか
  # application タイプでのみ有効。デフォルト: false
  # true の場合、x-amzn-tls-version と x-amzn-tls-cipher-suite ヘッダーを追加。
  enable_tls_version_and_cipher_suite_headers = false

  # (Optional) WAF フェイルオープンを有効化するか
  # application タイプでのみ有効。デフォルト: false
  # true の場合、AWS WAFにリクエストを転送できない場合でもターゲットにルーティング。
  enable_waf_fail_open = false

  #---------------------------------------------------------------
  # Network Load Balancer 固有設定
  #---------------------------------------------------------------

  # (Optional) PrivateLink トラフィックに対するセキュリティグループルールの適用
  # network タイプでのみ有効。
  # 可能な値: "on", "off"
  # PrivateLink から発生するトラフィックに対してインバウンドセキュリティグループルールを適用するか。
  # enforce_security_group_inbound_rules_on_private_link_traffic = "off"

  #---------------------------------------------------------------
  # ログとモニタリング
  #---------------------------------------------------------------

  # (Optional) アクセスログ設定
  # S3バケットにアクセスログを保存する設定。
  # access_logs {
  #   bucket  = "my-lb-logs-bucket"  # (Required) ログを保存するS3バケット名
  #   prefix  = "my-app"             # (Optional) S3バケット内のプレフィックス
  #   enabled = true                 # (Optional) アクセスログの有効化（デフォルト: false）
  # }

  # (Optional) コネクションログ設定
  # application タイプでのみ有効。
  # connection_logs {
  #   bucket  = "my-lb-logs-bucket"  # (Required) ログを保存するS3バケット名
  #   prefix  = "my-app"             # (Optional) S3バケット内のプレフィックス
  #   enabled = true                 # (Optional) コネクションログの有効化（デフォルト: false）
  # }

  # (Optional) ヘルスチェックログ設定
  # application タイプでのみ有効。
  # health_check_logs {
  #   bucket  = "my-lb-logs-bucket"  # (Required) ログを保存するS3バケット名
  #   prefix  = "my-app"             # (Optional) S3バケット内のプレフィックス
  #   enabled = true                 # (Optional) ヘルスチェックログの有効化（デフォルト: false）
  # }

  #---------------------------------------------------------------
  # 容量とキャパシティ
  #---------------------------------------------------------------

  # (Optional) 最小ロードバランサー容量
  # application または network タイプでのみ有効。
  # minimum_load_balancer_capacity {
  #   capacity_units = 1  # (Required) 容量ユニット数
  # }

  #---------------------------------------------------------------
  # IPAM設定
  #---------------------------------------------------------------

  # (Optional) IPAMプール設定
  # ipam_pools {
  #   ipv4_ipam_pool_id = "ipam-pool-12345678"  # (Required) IPv4 IPAMプールのID
  # }

  #---------------------------------------------------------------
  # 保護とセキュリティ
  #---------------------------------------------------------------

  # (Optional) 削除保護を有効化するか
  # true の場合、AWS APIを通じてロードバランサーの削除が無効化される。
  # Terraformからの削除も防ぐ。デフォルト: false
  enable_deletion_protection = false

  #---------------------------------------------------------------
  # タグとメタデータ
  #---------------------------------------------------------------

  # (Optional) リソースに割り当てるタグのマップ
  # プロバイダーのdefault_tagsと併用可能。
  tags = {
    Name        = "example-lb"
    Environment = "production"
  }

  # (Optional) プロバイダーのdefault_tagsを含む全タグのマップ
  # Terraform管理用の属性。通常は明示的に設定不要。
  # tags_all = {}

  # (Optional) リソースが管理されるリージョン
  # 指定しない場合、プロバイダー設定のリージョンを使用。
  # region = "us-east-1"

  # (Optional) リソースID
  # Terraform管理用の属性。通常は明示的に設定不要。
  # id = null

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # (Optional) リソース操作のタイムアウト設定
  # timeouts {
  #   create = "10m"  # 作成タイムアウト
  #   update = "10m"  # 更新タイムアウト
  #   delete = "10m"  # 削除タイムアウト
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Computed Values)
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします（読み取り専用）:
#
# - arn                    : ロードバランサーのARN
# - arn_suffix             : CloudWatch Metricsで使用するARNサフィックス
# - dns_name               : ロードバランサーのDNS名
# - vpc_id                 : ロードバランサーが所属するVPCのID
# - zone_id                : Route 53 Aliasレコードで使用するCanonical hosted zone ID
# - subnet_mapping[].outpost_id : Outpost上のロードバランサーの場合、OutpostのID
# - tags_all               : プロバイダーのdefault_tagsを含む全タグのマップ
#
#---------------------------------------------------------------
