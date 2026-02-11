#---------------------------------------------------------------
# AWS Elastic Load Balancer (Classic Load Balancer)
#---------------------------------------------------------------
#
# Classic Load Balancer（CLB）をプロビジョニングするリソースです。
# Classic Load Balancerは、EC2インスタンスに対してリクエストレベルおよび
# 接続レベルでの負荷分散を提供します。Layer 4（TCP/SSL）および
# Layer 7（HTTP/HTTPS）の両方をサポートします。
#
# 注意: Application/Network Load Balancerのリリース後、このロードバランサーは
# "Classic Load Balancer"として知られています。VPC環境では、Layer 7トラフィックには
# Application Load Balancer、Layer 4トラフィックにはNetwork Load Balancerの
# 使用が推奨されます。
#
# AWS公式ドキュメント:
#   - Classic Load Balancer とは: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/introduction.html
#   - Classic Load Balancer の設定: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-configure-load-balancer.html
#   - リスナーの設定: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-listener-config.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elb" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: ELBの名前を指定します。
  # 設定可能な値: 1-32文字の英数字とハイフン
  # 省略時: Terraformが自動的に一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "my-classic-load-balancer"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: ELB名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

  # internal (Optional)
  # 設定内容: 内部向けELBとして作成するかを指定します。
  # 設定可能な値:
  #   - true: 内部向けELBとして作成（VPC内部からのみアクセス可能）
  #   - false (デフォルト): インターネット向けELBとして作成
  # 省略時: false（インターネット向けELB）
  internal = false

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
  # ネットワーク設定
  #-------------------------------------------------------------
  # 注意: availability_zones または subnets のいずれか一方を指定する必要があります。
  #       availability_zones: EC2-Classic環境用
  #       subnets: VPC環境用

  # availability_zones (Optional)
  # 設定内容: トラフィックを処理するアベイラビリティゾーンを指定します。
  # 設定可能な値: アベイラビリティゾーン名の集合（例: ["us-west-2a", "us-west-2b"]）
  # 必須条件: EC2-Classic環境でELBを作成する場合に必須
  # 注意: VPC環境ではsubnetを使用します
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]

  # subnets (Optional)
  # 設定内容: ELBにアタッチするサブネットIDのリストを指定します。
  # 設定可能な値: サブネットIDの集合
  # 必須条件: VPC環境でELBを作成する場合に必須
  # 注意: サブネットの更新時、すべての現在のサブネットが削除される場合は新しいリソースが作成されます
  # 関連機能: サブネット管理
  #   複数のアベイラビリティゾーンにまたがるサブネットを指定することで、
  #   ELBの可用性を向上させることができます。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-manage-subnets.html
  subnets = null

  # security_groups (Optional)
  # 設定内容: ELBに割り当てるセキュリティグループIDのリストを指定します。
  # 設定可能な値: セキュリティグループIDの集合
  # 注意: VPC内でELBを作成する場合のみ有効
  # 関連機能: セキュリティグループ設定
  #   セキュリティグループは、リスナーポートとヘルスチェックポートでの
  #   トラフィックを許可する必要があります。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-vpc-security-groups.html
  security_groups = ["sg-12345678"]

  # source_security_group (Optional)
  # 設定内容: ソースセキュリティグループの名前を指定します。
  # 設定可能な値: セキュリティグループ名
  # 注意: 通常は自動的に計算されるため、明示的に指定する必要はありません
  #       Classic VPCまたはDefault VPCでのみ使用可能
  #       バックエンドインスタンスのインバウンドルールで使用できます
  source_security_group = null

  #-------------------------------------------------------------
  # インスタンス設定
  #-------------------------------------------------------------

  # instances (Optional)
  # 設定内容: ELBプールに配置するインスタンスIDのリストを指定します。
  # 設定可能な値: EC2インスタンスIDの集合
  # 注意: ELB Attachmentリソースと併用しないでください。
  #       併用すると競合が発生し、アタッチメントが上書きされます。
  instances = []

  #-------------------------------------------------------------
  # リスナー設定 (必須)
  #-------------------------------------------------------------

  # listener (Required)
  # 設定内容: リスナーの設定を定義します。少なくとも1つ必須です。
  # 関連機能: リスナー設定
  #   リスナーは接続リクエストをチェックし、フロントエンド（クライアントから
  #   ロードバランサー）およびバックエンド（ロードバランサーからインスタンス）の
  #   接続に対するプロトコルとポートで構成されます。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-listener-config.html

  # HTTPリスナーの例
  listener {
    # instance_port (Required)
    # 設定内容: インスタンスへルーティングする際のポート番号を指定します。
    # 設定可能な値: 1-65535の整数
    instance_port = 80

    # instance_protocol (Required)
    # 設定内容: インスタンスへの通信に使用するプロトコルを指定します。
    # 設定可能な値: "HTTP", "HTTPS", "TCP", "SSL"
    instance_protocol = "http"

    # lb_port (Required)
    # 設定内容: ロードバランサーがリッスンするポート番号を指定します。
    # 設定可能な値: 1-65535の整数
    lb_port = 80

    # lb_protocol (Required)
    # 設定内容: ロードバランサーがリッスンするプロトコルを指定します。
    # 設定可能な値: "HTTP", "HTTPS", "TCP", "SSL"
    lb_protocol = "http"

    # ssl_certificate_id (Optional)
    # 設定内容: AWS IAMにアップロード済みのSSL証明書のARNを指定します。
    # 設定可能な値: SSL証明書のARN
    # 注意: lb_protocolがHTTPSまたはSSLの場合のみ有効
    #       ECDSA証明書には特定の制限があります
    ssl_certificate_id = null
  }

  # HTTPSリスナーの例（複数のリスナーを定義可能）
  # listener {
  #   instance_port      = 443
  #   instance_protocol  = "https"
  #   lb_port            = 443
  #   lb_protocol        = "https"
  #   ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  # }

  #-------------------------------------------------------------
  # ヘルスチェック設定
  #-------------------------------------------------------------

  # health_check (Optional)
  # 設定内容: ヘルスチェックの設定を定義します。
  # 関連機能: ヘルスチェック
  #   ロードバランサーは、登録されたインスタンスの状態を定期的にチェックし、
  #   正常なインスタンスにのみトラフィックをルーティングします。
  health_check {
    # healthy_threshold (Required)
    # 設定内容: インスタンスが正常と判定されるまでの連続成功チェック回数を指定します。
    # 設定可能な値: 2-10の整数
    healthy_threshold = 2

    # unhealthy_threshold (Required)
    # 設定内容: インスタンスが異常と判定されるまでの連続失敗チェック回数を指定します。
    # 設定可能な値: 2-10の整数
    unhealthy_threshold = 2

    # timeout (Required)
    # 設定内容: ヘルスチェックがタイムアウトするまでの時間（秒）を指定します。
    # 設定可能な値: 2-60の整数（秒）
    # 注意: timeoutはintervalより小さい値である必要があります
    timeout = 3

    # target (Required)
    # 設定内容: チェック対象を指定します。
    # 設定可能な値: "${PROTOCOL}:${PORT}${PATH}" の形式
    #   プロトコル別の要件:
    #   - HTTP, HTTPS: PORTとPATHが必須（例: "HTTP:80/health"）
    #   - TCP, SSL: PORTが必須、PATHは不要（例: "TCP:80"）
    target = "HTTP:80/health"

    # interval (Required)
    # 設定内容: ヘルスチェックの間隔（秒）を指定します。
    # 設定可能な値: 5-300の整数（秒）
    interval = 30
  }

  #-------------------------------------------------------------
  # アクセスログ設定
  #-------------------------------------------------------------

  # access_logs (Optional)
  # 設定内容: アクセスログの設定を定義します。
  # 関連機能: アクセスログ
  #   ロードバランサーに送信されたリクエストの詳細情報をキャプチャし、
  #   S3バケットにログファイルとして保存します。トラフィックパターンの
  #   分析やバックエンドアプリケーションのトラブルシューティングに使用できます。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/access-log-collection.html
  access_logs {
    # bucket (Required)
    # 設定内容: ログを保存するS3バケット名を指定します。
    # 設定可能な値: 既存のS3バケット名
    # 注意: バケットはELBと同じリージョンに存在する必要があります
    #       バケットにはElastic Load Balancingに対する適切な権限が必要です
    bucket = "my-elb-logs-bucket"

    # bucket_prefix (Optional)
    # 設定内容: S3バケット内のプレフィックス（ディレクトリパス）を指定します。
    # 設定可能な値: 文字列
    # 省略時: バケットのルートに保存されます
    bucket_prefix = "elb-logs"

    # interval (Optional)
    # 設定内容: ログの公開間隔（分）を指定します。
    # 設定可能な値: 5 または 60
    # 省略時: 60分
    interval = 60

    # enabled (Optional)
    # 設定内容: アクセスログを有効/無効にするかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): アクセスログを有効化
    #   - false: アクセスログを無効化
    # 省略時: true
    enabled = true
  }

  #-------------------------------------------------------------
  # ロードバランサー属性設定
  #-------------------------------------------------------------

  # cross_zone_load_balancing (Optional)
  # 設定内容: クロスゾーン負荷分散を有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): すべてのアベイラビリティゾーンのインスタンスに
  #                        均等にリクエストをルーティング
  #   - false: 各アベイラビリティゾーン内でのみ負荷分散
  # 省略時: true
  # 関連機能: クロスゾーン負荷分散
  #   有効にすると、ロードバランサーはアベイラビリティゾーンに関係なく、
  #   すべてのインスタンスに均等にトラフィックをルーティングします。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-disable-crosszone-lb.html
  cross_zone_load_balancing = true

  # idle_timeout (Optional)
  # 設定内容: 接続がアイドル状態を保持できる時間（秒）を指定します。
  # 設定可能な値: 1-4000の整数（秒）
  # 省略時: 60秒
  # 関連機能: アイドルタイムアウト
  #   この時間内にデータが送信されない場合、ロードバランサーは接続を閉じます。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/config-idle-timeout.html
  idle_timeout = 60

  # connection_draining (Optional)
  # 設定内容: コネクションドレイニングを有効にするかを指定します。
  # 設定可能な値:
  #   - true: コネクションドレイニングを有効化
  #   - false (デフォルト): コネクションドレイニングを無効化
  # 省略時: false
  # 関連機能: コネクションドレイニング
  #   有効にすると、ロードバランサーは登録解除または異常なインスタンスから
  #   トラフィックを移行する前に、既存のリクエストを完了させます。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/config-conn-drain.html
  connection_draining = true

  # connection_draining_timeout (Optional)
  # 設定内容: コネクションドレイニングのタイムアウト時間（秒）を指定します。
  # 設定可能な値: 1-3600の整数（秒）
  # 省略時: 300秒
  # 注意: connection_drainingが有効な場合のみ意味を持ちます
  connection_draining_timeout = 300

  # desync_mitigation_mode (Optional)
  # 設定内容: HTTPデシンクによるセキュリティリスクを処理する方法を指定します。
  # 設定可能な値:
  #   - "monitor": リスクのあるリクエストを許可し、CloudWatchメトリクスに記録
  #   - "defensive" (デフォルト): 中程度のセキュリティルールを適用
  #   - "strictest": 最も厳格なセキュリティルールを適用
  # 省略時: "defensive"
  # 関連機能: デシンク軽減モード
  #   HTTPデシンク攻撃からアプリケーションを保護するための設定です。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/config-desync-mitigation-mode.html
  desync_mitigation_mode = "defensive"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/add-remove-tags.html
  tags = {
    Name        = "my-classic-load-balancer"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: リソースに割り当てられたすべてのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: 通常は自動的に計算されるため、明示的に指定する必要はありません
  #       プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます
  # 非推奨: tags属性を使用し、tags_allは読み取り専用として扱うことが推奨されます
  tags_all = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定します。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "10m", "1h"）
  #   create = "10m"
  #
  #   # update (Optional)
  #   # 設定内容: リソース更新のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "10m", "1h"）
  #   update = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ELBの名前
#
# - arn: ELBのAmazon Resource Name (ARN)
#
# - name: ELBの名前
#
# - dns_name: ELBのDNS名。クライアントからのアクセスに使用します。
#
# - instances: ELBに登録されているインスタンスのリスト
#
# - source_security_group: ロードバランサーのバックエンドアプリケーション
#                          インスタンスのインバウンドルールの一部として使用できる
#                          セキュリティグループの名前。Classic VPCまたは
#                          Default VPCでのみ使用可能。
#
# - source_security_group_id: ロードバランサーのバックエンドアプリケーション
#                             インスタンスのインバウンドルールの一部として使用できる
#                             セキュリティグループのID。VPCで起動されたELBでのみ使用可能。
#
# - zone_id: ELBの正規ホストゾーンID（Route 53 Aliasレコードで使用）
#---------------------------------------------------------------
