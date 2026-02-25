#---------------------------------------------------------------
# AWS Load Balancer (ALB / NLB / GWLB)
#---------------------------------------------------------------
#
# Application Load Balancer (ALB)、Network Load Balancer (NLB)、
# または Gateway Load Balancer (GWLB) をプロビジョニングするリソースです。
# aws_alb は aws_lb の別名であり、機能は同一です。
#
# AWS公式ドキュメント:
#   - Application Load Balancer とは: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html
#   - Network Load Balancer とは: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html
#   - Gateway Load Balancer とは: https://docs.aws.amazon.com/elasticloadbalancing/latest/gateway/introduction.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: ロードバランサーの名前を指定します。
  # 設定可能な値: 最大32文字の英数字またはハイフン。ハイフンで始まったり終わったりすることはできません。
  # 省略時: Terraform が "tf-lb" で始まる名前を自動生成します。
  # 注意: name_prefix と排他的（どちらか一方のみ指定可能）
  name = "example-lb"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: 指定したプレフィックスで始まる一意な名前を生成します。
  # 設定可能な値: 文字列プレフィックス
  # 注意: name と排他的（どちらか一方のみ指定可能）
  name_prefix = null

  # load_balancer_type (Optional, Forces new resource)
  # 設定内容: 作成するロードバランサーの種類を指定します。
  # 設定可能な値:
  #   - "application" (デフォルト): HTTP/HTTPS トラフィック向け ALB
  #   - "network": TCP/UDP/TLS トラフィック向け NLB
  #   - "gateway": サードパーティの仮想アプライアンス向け GWLB
  load_balancer_type = "application"

  # internal (Optional)
  # 設定内容: ロードバランサーを内部向け（プライベート）にするかを指定します。
  # 設定可能な値:
  #   - true: 内部向け LB（VPC 内からのみアクセス可能）
  #   - false (デフォルト): インターネット向け LB
  # 注意: 内部 LB は ip_address_type として "ipv4" のみ使用可能です。
  internal = false

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnets (Optional)
  # 設定内容: ロードバランサーをアタッチするサブネット ID のリストを指定します。
  # 設定可能な値: 有効なサブネット ID のセット
  # 注意: subnets または subnet_mapping のどちらか一方が必須です。
  #       NLB の場合、サブネットの追加のみ可能で削除するとリソースが再作成されます。
  subnets = ["subnet-12345678", "subnet-87654321"]

  # security_groups (Optional)
  # 設定内容: LB に割り当てるセキュリティグループ ID のリストを指定します。
  # 設定可能な値: 有効なセキュリティグループ ID のセット
  # 注意: ALB および NLB タイプでのみ有効です。
  #       NLB の場合、セキュリティグループが存在しない状態での追加、
  #       または全て削除する操作を行うとリソースが再作成されます。
  security_groups = ["sg-12345678"]

  # ip_address_type (Optional)
  # 設定内容: サブネットで使用する IP アドレスの種類を指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4 アドレス（全ロードバランサータイプで使用可能）
  #   - "dualstack": IPv4 と IPv6 の両方（全ロードバランサータイプで使用可能）
  #   - "dualstack-without-public-ipv4": パブリック IPv4 なしのデュアルスタック（ALB のみ）
  # 注意: 内部 LB は "ipv4" のみ使用可能。"dualstack" への変更はサブネットが
  #       IPv6 対応の場合のみ可能です。
  ip_address_type = "ipv4"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 削除保護設定
  #-------------------------------------------------------------

  # enable_deletion_protection (Optional)
  # 設定内容: AWS API を通じたロードバランサーの削除を無効にするかを指定します。
  # 設定可能な値:
  #   - true: 削除保護を有効化。Terraform による削除も防止されます。
  #   - false (デフォルト): 削除保護を無効化
  enable_deletion_protection = false

  #-------------------------------------------------------------
  # HTTP 設定（ALB 専用）
  #-------------------------------------------------------------

  # idle_timeout (Optional)
  # 設定内容: 接続がアイドル状態を維持できる秒数を指定します。ALB のみ有効です。
  # 設定可能な値: 秒数（数値）
  # 省略時: 60（秒）
  idle_timeout = 60

  # client_keep_alive (Optional)
  # 設定内容: クライアントキープアライブの値（秒単位）を指定します。
  # 設定可能な値: 60〜604800 秒の範囲
  # 省略時: 3600（秒）
  client_keep_alive = 3600

  # drop_invalid_header_fields (Optional)
  # 設定内容: 無効なヘッダーフィールドを持つ HTTP ヘッダーをロードバランサーが
  #   削除する（true）か、ターゲットにルーティングする（false）かを指定します。
  # 設定可能な値:
  #   - true: 無効なヘッダーフィールドを削除
  #   - false (デフォルト): ターゲットにルーティング
  # 注意: ALB のみ有効です。
  drop_invalid_header_fields = false

  # enable_http2 (Optional)
  # 設定内容: ALB で HTTP/2 を有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): HTTP/2 を有効化
  #   - false: HTTP/2 を無効化
  # 注意: ALB のみ有効です。
  enable_http2 = true

  # preserve_host_header (Optional)
  # 設定内容: ALB が HTTP リクエストの Host ヘッダーを変更せずターゲットに
  #   送信するかを指定します。
  # 設定可能な値:
  #   - true: Host ヘッダーを保持してターゲットに送信
  #   - false (デフォルト): Host ヘッダーを変更
  # 注意: ALB のみ有効です。
  preserve_host_header = false

  # desync_mitigation_mode (Optional)
  # 設定内容: HTTP デシンクによりアプリケーションにセキュリティリスクをもたらす可能性のある
  #   リクエストをロードバランサーが処理する方法を指定します。
  # 設定可能な値:
  #   - "monitor": リクエストを監視のみ。ターゲットへのルーティングは継続
  #   - "defensive" (デフォルト): リスクのあるリクエストを拒否
  #   - "strictest": 最も厳格なポリシーを適用
  desync_mitigation_mode = "defensive"

  # enable_tls_version_and_cipher_suite_headers (Optional)
  # 設定内容: ネゴシエートされた TLS バージョンと暗号スイートに関する情報を含む
  #   2 つのヘッダー（x-amzn-tls-version および x-amzn-tls-cipher-suite）を
  #   ターゲットに送信する前にリクエストに追加するかを指定します。
  # 設定可能な値:
  #   - true: ヘッダーを追加
  #   - false (デフォルト): ヘッダーを追加しない
  # 注意: ALB のみ有効です。
  enable_tls_version_and_cipher_suite_headers = false

  # enable_xff_client_port (Optional)
  # 設定内容: X-Forwarded-For ヘッダーがクライアントの接続元ポートを保持するかを指定します。
  # 設定可能な値:
  #   - true: クライアントのポートを保持
  #   - false (デフォルト): ポートを保持しない
  # 注意: ALB のみ有効です。
  enable_xff_client_port = false

  # enable_waf_fail_open (Optional)
  # 設定内容: WAF 対応ロードバランサーが AWS WAF へのリクエスト転送が失敗した場合に
  #   ターゲットへルーティングを許可するかを指定します。
  # 設定可能な値:
  #   - true: WAF 障害時にターゲットへのルーティングを許可（フェイルオープン）
  #   - false (デフォルト): WAF 障害時にリクエストを拒否
  enable_waf_fail_open = false

  # xff_header_processing_mode (Optional)
  # 設定内容: ロードバランサーがリクエストをターゲットに送信する前に
  #   X-Forwarded-For ヘッダーを変更する方法を指定します。
  # 設定可能な値:
  #   - "append" (デフォルト): クライアントの IP アドレスを既存のヘッダーに追記
  #   - "preserve": ヘッダーをそのまま保持
  #   - "remove": ヘッダーを削除
  # 注意: ALB のみ有効です。
  xff_header_processing_mode = "append"

  #-------------------------------------------------------------
  # クロスゾーン負荷分散設定
  #-------------------------------------------------------------

  # enable_cross_zone_load_balancing (Optional)
  # 設定内容: ロードバランサーのクロスゾーン負荷分散を有効にするかを指定します。
  # 設定可能な値:
  #   - true: クロスゾーン負荷分散を有効化
  #   - false (デフォルト): クロスゾーン負荷分散を無効化
  # 注意: ALB の場合、この機能は常に有効（true）であり無効にすることはできません。
  #       NLB および GWLB ではデフォルトで無効（false）です。
  enable_cross_zone_load_balancing = false

  # enable_zonal_shift (Optional)
  # 設定内容: ゾーナルシフトを有効にするかを指定します。
  # 設定可能な値:
  #   - true: ゾーナルシフトを有効化
  #   - false (デフォルト): ゾーナルシフトを無効化
  enable_zonal_shift = false

  # dns_record_client_routing_policy (Optional)
  # 設定内容: ロードバランサーのアベイラビリティゾーン間でトラフィックを分散する方法を指定します。
  # 設定可能な値:
  #   - "any_availability_zone" (デフォルト): 任意の AZ に分散
  #   - "availability_zone_affinity": クライアントと同じ AZ のターゲットを優先
  #   - "partial_availability_zone_affinity": クライアントの AZ を一部優先し残りを分散
  # 注意: NLB のみ有効です。
  # 参考: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/network-load-balancers.html#zonal-dns-affinity
  dns_record_client_routing_policy = "any_availability_zone"

  #-------------------------------------------------------------
  # NLB 専用設定
  #-------------------------------------------------------------

  # enforce_security_group_inbound_rules_on_private_link_traffic (Optional)
  # 設定内容: PrivateLink からのトラフィックに対してインバウンドセキュリティグループルールを
  #   適用するかを指定します。
  # 設定可能な値:
  #   - "on": セキュリティグループのインバウンドルールを適用
  #   - "off": セキュリティグループのインバウンドルールを適用しない
  # 注意: NLB のみ有効です。
  enforce_security_group_inbound_rules_on_private_link_traffic = "on"

  # secondary_ips_auto_assigned_per_subnet (Optional)
  # 設定内容: ロードバランサーノードに設定するセカンダリ IP アドレスの数を指定します。
  # 設定可能な値: 0〜7 の整数
  # 省略時: 0
  # 注意: NLB のみ有効です。値を減らすとリソースが再作成されます。
  secondary_ips_auto_assigned_per_subnet = 0

  # customer_owned_ipv4_pool (Optional)
  # 設定内容: このロードバランサーに使用するカスタマー所有 IPv4 プールの ID を指定します。
  # 設定可能な値: 有効なカスタマー所有 IPv4 プール ID（coip-XXXXXXXX 形式）
  customer_owned_ipv4_pool = null

  #-------------------------------------------------------------
  # アクセスログ設定
  #-------------------------------------------------------------

  # access_logs (Optional)
  # 設定内容: ロードバランサーのアクセスログを S3 に保存するための設定ブロックです。
  # 関連機能: Elastic Load Balancing アクセスログ
  #   各リクエストの詳細情報（リクエスト時刻、クライアント IP、レイテンシー等）を記録します。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html
  access_logs {
    # bucket (Required)
    # 設定内容: ログを保存する S3 バケット名を指定します。
    # 設定可能な値: 有効な S3 バケット名
    bucket = "my-lb-access-logs"

    # prefix (Optional)
    # 設定内容: S3 バケット内のログのプレフィックスを指定します。
    # 設定可能な値: 文字列プレフィックス
    # 省略時: バケットのルートにログが保存されます。
    prefix = "my-lb"

    # enabled (Optional)
    # 設定内容: アクセスログを有効にするかを指定します。
    # 設定可能な値:
    #   - true: アクセスログを有効化
    #   - false (デフォルト): アクセスログを無効化（bucket を指定していても無効）
    enabled = false
  }

  #-------------------------------------------------------------
  # 接続ログ設定（ALB 専用）
  #-------------------------------------------------------------

  # connection_logs (Optional)
  # 設定内容: ロードバランサーの接続ログを S3 に保存するための設定ブロックです。ALB のみ有効です。
  # 関連機能: Elastic Load Balancing 接続ログ
  #   クライアントとロードバランサー間の TLS 接続の詳細情報を記録します。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-connection-logs.html
  connection_logs {
    # bucket (Required)
    # 設定内容: ログを保存する S3 バケット名を指定します。
    # 設定可能な値: 有効な S3 バケット名
    bucket = "my-lb-connection-logs"

    # prefix (Optional)
    # 設定内容: S3 バケット内のログのプレフィックスを指定します。
    # 設定可能な値: 文字列プレフィックス
    # 省略時: バケットのルートにログが保存されます。
    prefix = "my-lb"

    # enabled (Optional)
    # 設定内容: 接続ログを有効にするかを指定します。
    # 設定可能な値:
    #   - true: 接続ログを有効化
    #   - false (デフォルト): 接続ログを無効化（bucket を指定していても無効）
    enabled = false
  }

  #-------------------------------------------------------------
  # ヘルスチェックログ設定（ALB 専用）
  #-------------------------------------------------------------

  # health_check_logs (Optional)
  # 設定内容: ロードバランサーのヘルスチェックログを S3 に保存するための設定ブロックです。ALB のみ有効です。
  health_check_logs {
    # bucket (Required)
    # 設定内容: ログを保存する S3 バケット名を指定します。
    # 設定可能な値: 有効な S3 バケット名
    bucket = "my-lb-health-check-logs"

    # prefix (Optional)
    # 設定内容: S3 バケット内のログのプレフィックスを指定します。
    # 設定可能な値: 文字列プレフィックス
    # 省略時: バケットのルートにログが保存されます。
    prefix = "my-lb"

    # enabled (Optional)
    # 設定内容: ヘルスチェックログを有効にするかを指定します。
    # 設定可能な値:
    #   - true: ヘルスチェックログを有効化
    #   - false (デフォルト): ヘルスチェックログを無効化（bucket を指定していても無効）
    enabled = false
  }

  #-------------------------------------------------------------
  # IPAM プール設定
  #-------------------------------------------------------------

  # ipam_pools (Optional)
  # 設定内容: IPAM プールからの IP アドレス割り当てを設定するブロックです。
  # 関連機能: Amazon VPC IP Address Manager (IPAM)
  #   VPC の IP アドレスを一元管理する機能。
  #   - https://docs.aws.amazon.com/vpc/latest/ipam/what-it-is-ipam.html
  ipam_pools {
    # ipv4_ipam_pool_id (Required)
    # 設定内容: IPv4 IPAM プールの ID を指定します。
    # 設定可能な値: 有効な IPAM プール ID（ipam-pool-XXXXXXXXXXXXXXXX 形式）
    ipv4_ipam_pool_id = "ipam-pool-12345678901234567"
  }

  #-------------------------------------------------------------
  # 最小キャパシティ設定（ALB / NLB 専用）
  #-------------------------------------------------------------

  # minimum_load_balancer_capacity (Optional)
  # 設定内容: ロードバランサーの最小キャパシティを設定するブロックです。
  # 注意: ALB および NLB のみ有効です。
  minimum_load_balancer_capacity {
    # capacity_units (Required)
    # 設定内容: キャパシティユニット数を指定します。
    # 設定可能な値: 正の整数
    capacity_units = 1
  }

  #-------------------------------------------------------------
  # サブネットマッピング設定
  #-------------------------------------------------------------

  # subnet_mapping (Optional)
  # 設定内容: サブネットと Elastic IP や固定 IP アドレスを紐付ける設定ブロックです。
  # 注意: subnets または subnet_mapping のどちらか一方が必須です。
  #       NLB ではサブネットマッピングの追加のみ可能です。
  subnet_mapping {
    # subnet_id (Required)
    # 設定内容: ロードバランサーにアタッチするサブネットの ID を指定します。
    # 設定可能な値: 有効なサブネット ID
    # 注意: アベイラビリティゾーンごとに 1 つのサブネットのみ指定可能です。
    subnet_id = "subnet-12345678"

    # allocation_id (Optional)
    # 設定内容: インターネット向けロードバランサーに割り当てる Elastic IP のアロケーション ID を指定します。
    # 設定可能な値: 有効な Elastic IP アロケーション ID（eipalloc-XXXXXXXXXXXXXXXX 形式）
    allocation_id = null

    # private_ipv4_address (Optional)
    # 設定内容: 内部向けロードバランサーのプライベート IPv4 アドレスを指定します。
    # 設定可能な値: サブネット CIDR 範囲内の有効な IPv4 アドレス
    private_ipv4_address = null

    # ipv6_address (Optional)
    # 設定内容: サブネットに関連付ける IPv6 アドレスを指定します。
    # 設定可能な値: 有効な IPv6 アドレス
    # 注意: VPC と選択したサブネットが IPv6 CIDR ブロックに対応している必要があります。
    ipv6_address = null
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新・削除操作のタイムアウト時間を設定するブロックです。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの Go duration 形式の文字列
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの Go duration 形式の文字列
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの Go duration 形式の文字列
    delete = "30m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-lb"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ロードバランサーの ARN
# - arn_suffix: CloudWatch Metrics で使用する ARN サフィックス
# - dns_name: ロードバランサーの DNS 名
# - vpc_id: ロードバランサーが配置されている VPC の ID
# - zone_id: Route 53 エイリアスレコードで使用するカノニカルホストゾーン ID
# - subnet_mapping[*].outpost_id: ロードバランサーを含む Outpost の ID
# - tags_all: プロバイダーの default_tags から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
