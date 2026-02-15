#---------------------------------------------------------------
# ALB (Application Load Balancer) ターゲットグループ
#---------------------------------------------------------------
#
# ALB/NLB/GWLB用のターゲットグループをプロビジョニングするリソースです。
# ターゲットグループは、登録されたターゲット(EC2インスタンス、IPアドレス、
# Lambda関数、ALB)へのトラフィックをルーティングします。
#
# 注意: aws_alb_target_groupはaws_lb_target_groupの別名です。機能は同一です。
#
# AWS公式ドキュメント:
#   - ALBターゲットグループ: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
#   - ターゲットグループの作成: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-target-group.html
#   - ヘルスチェック: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-health-checks.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_alb_target_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: ターゲットグループの名前を指定します。
  # 設定可能な値: 最大32文字の英数字またはハイフン（先頭と末尾はハイフン不可）
  # 省略時: Terraformがランダムで一意な名前を自動生成
  # 注意: リソース作成後の変更はできません（Forces new resource）
  # 関連機能: name_prefixと競合します
  name = "example-target-group"

  # name_prefix (Optional)
  # 設定内容: 指定したプレフィックスで始まる一意な名前を生成します。
  # 設定可能な値: 最大6文字の文字列
  # 注意: リソース作成後の変更はできません（Forces new resource）
  # 関連機能: nameと競合します
  name_prefix = null

  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # target_type (Optional)
  # 設定内容: ターゲットグループに登録するターゲットのタイプを指定します。
  # 設定可能な値:
  #   - "instance": EC2インスタンスIDで登録
  #   - "ip": IPアドレスで登録（VPC内、RFC1918、RFC6598範囲）
  #   - "lambda": Lambda関数で登録
  #   - "alb": Application Load Balancerで登録
  # 省略時: "instance"
  # 注意: リソース作成後の変更はできません（Forces new resource）
  # 関連機能: NLBはlambdaをサポートせず、ALBはalbをサポートしません
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateTargetGroup.html
  target_type = "instance"

  # vpc_id (Optional)
  # 設定内容: ターゲットグループを作成するVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID
  # 省略時: 指定なし
  # 注意: target_typeが"instance"、"ip"、"alb"の場合は必須
  #       target_typeが"lambda"の場合は不要
  #       リソース作成後の変更はできません（Forces new resource）
  vpc_id = "vpc-12345678"

  #-------------------------------------------------------------
  # プロトコル・ポート設定
  #-------------------------------------------------------------

  # protocol (Optional)
  # 設定内容: ターゲットへのトラフィックルーティングに使用するプロトコルを指定します。
  # 設定可能な値: GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, UDP, QUIC, TCP_QUIC
  # 省略時: 指定なし
  # 注意: target_typeが"instance"、"ip"、"alb"の場合は必須
  #       target_typeが"lambda"の場合は不要
  #       リソース作成後の変更はできません（Forces new resource）
  protocol = "HTTP"

  # port (Optional)
  # 設定内容: ターゲットがトラフィックを受信するポート番号を指定します。
  # 設定可能な値: 1〜65536の整数
  # 省略時: 指定なし
  # 注意: target_typeが"instance"、"ip"、"alb"の場合は必須
  #       target_typeが"lambda"の場合は不要
  #       リソース作成後の変更はできません（Forces new resource）
  port = 80

  # protocol_version (Optional)
  # 設定内容: プロトコルバージョンを指定します。
  # 設定可能な値:
  #   - "HTTP1": HTTP/1.1でリクエストを送信（デフォルト）
  #   - "HTTP2": HTTP/2でリクエストを送信
  #   - "GRPC": gRPCでリクエストを送信
  # 省略時: "HTTP1"
  # 注意: protocolが"HTTP"または"HTTPS"の場合のみ適用
  #       リソース作成後の変更はできません（Forces new resource）
  protocol_version = "HTTP1"

  #-------------------------------------------------------------
  # IPアドレス設定
  #-------------------------------------------------------------

  # ip_address_type (Optional)
  # 設定内容: ターゲットグループがサポートするIPアドレスのタイプを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4アドレスのみ
  #   - "ipv6": IPv6アドレスのみ
  # 省略時: プロトコルとターゲットタイプに基づいて自動決定
  # 注意: リソース作成後の変更はできません
  ip_address_type = null

  #-------------------------------------------------------------
  # 負荷分散設定
  #-------------------------------------------------------------

  # load_balancing_algorithm_type (Optional)
  # 設定内容: ロードバランサーがリクエストをルーティングする際のターゲット選択アルゴリズムを指定します。
  # 設定可能な値:
  #   - "round_robin": ラウンドロビン（デフォルト）
  #   - "least_outstanding_requests": 最少未処理リクエスト数
  #   - "weighted_random": 重み付きランダム
  # 省略時: "round_robin"
  # 注意: Application Load Balancerのターゲットグループにのみ適用
  load_balancing_algorithm_type = null

  # load_balancing_anomaly_mitigation (Optional)
  # 設定内容: ターゲット異常緩和機能を有効にするかを指定します。
  # 設定可能な値: "on", "off"
  # 省略時: "off"
  # 注意: load_balancing_algorithm_typeが"weighted_random"の場合のみサポート
  # 関連機能: ターゲット異常の自動重み付け調整
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#automatic-target-weights
  load_balancing_anomaly_mitigation = null

  # load_balancing_cross_zone_enabled (Optional)
  # 設定内容: クロスゾーン負荷分散を有効にするかを指定します。
  # 設定可能な値: "true", "false", "use_load_balancer_configuration"
  # 省略時: "use_load_balancer_configuration"
  load_balancing_cross_zone_enabled = null

  # slow_start (Optional)
  # 設定内容: ターゲットがウォームアップするまでの時間（秒）を指定します。
  # 設定可能な値: 30〜900秒、または0で無効化
  # 省略時: 0（無効）
  # 注意: この期間中、ロードバランサーは段階的にリクエストを送信します
  slow_start = 0

  #-------------------------------------------------------------
  # 登録解除設定
  #-------------------------------------------------------------

  # deregistration_delay (Optional)
  # 設定内容: ターゲットの登録解除時に、状態がdrainingからunusedに変わるまでの待機時間（秒）を指定します。
  # 設定可能な値: 0〜3600秒
  # 省略時: 300秒
  deregistration_delay = "300"

  # connection_termination (Optional)
  # 設定内容: 登録解除タイムアウト終了時に、Network Load Balancerで接続を終了するかを指定します。
  # 設定可能な値: true, false
  # 省略時: false
  # 関連機能: Network Load Balancerの登録解除遅延
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#deregistration-delay
  connection_termination = null

  #-------------------------------------------------------------
  # クライアントIP保持設定
  #-------------------------------------------------------------

  # preserve_client_ip (Optional)
  # 設定内容: クライアントIPの保持を有効にするかを指定します。
  # 設定可能な値: "true", "false"
  # 省略時: プロトコルとターゲットタイプに基づいて自動決定
  # 関連機能: Network Load BalancerのクライアントIP保持
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#client-ip-preservation
  preserve_client_ip = null

  # proxy_protocol_v2 (Optional)
  # 設定内容: Network Load BalancerでProxy Protocol v2のサポートを有効にするかを指定します。
  # 設定可能な値: true, false
  # 省略時: false
  # 関連機能: Proxy Protocol v2
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#proxy-protocol
  proxy_protocol_v2 = false

  #-------------------------------------------------------------
  # Lambda設定
  #-------------------------------------------------------------

  # lambda_multi_value_headers_enabled (Optional)
  # 設定内容: ロードバランサーとLambda関数間で交換されるリクエスト/レスポンスヘッダーに
  #          配列値または文字列を含めるかを指定します。
  # 設定可能な値: true, false
  # 省略時: false
  # 注意: target_typeが"lambda"の場合のみ適用
  lambda_multi_value_headers_enabled = null

  #-------------------------------------------------------------
  # Target Optimizer設定
  #-------------------------------------------------------------

  # target_control_port (Optional)
  # 設定内容: Target Optimizer機能でターゲット制御エージェントとアプリケーションロードバランサーが
  #          管理トラフィックを交換するポートを指定します。
  # 設定可能な値: 1〜65536の整数
  # 省略時: 指定なし
  # 注意: target_typeが"instance"または"ip"のApplication Load Balancerターゲットグループでのみ適用
  target_control_port = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
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
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-target-group"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # ヘルスチェック設定
  #-------------------------------------------------------------

  # health_check (Optional)
  # 設定内容: ターゲットのヘルスチェック設定を指定するブロックです。
  # 注意: 最大1ブロックまで指定可能
  health_check {
    # enabled (Optional)
    # 設定内容: ヘルスチェックを有効にするかを指定します。
    # 設定可能な値: true, false
    # 省略時: true
    enabled = true

    # protocol (Optional)
    # 設定内容: ヘルスチェック実行時に使用するプロトコルを指定します。
    # 設定可能な値: TCP, HTTP, HTTPS
    # 省略時: HTTP
    # 注意: ターゲットグループのプロトコルがHTTPまたはHTTPSの場合、TCPは使用不可
    #       target_typeが"lambda"の場合は指定不可
    protocol = "HTTP"

    # port (Optional)
    # 設定内容: ヘルスチェック実行時に使用するポートを指定します。
    # 設定可能な値: "traffic-port"またはターゲットグループと同じポート、1〜65536の整数
    # 省略時: "traffic-port"
    port = "traffic-port"

    # path (Optional)
    # 設定内容: ヘルスチェックリクエストの送信先パスを指定します。
    # 設定可能な値: 有効なURLパス
    # 省略時: HTTP/HTTPSの場合は"/"、gRPCの場合は"/AWS.ALB/healthcheck"
    # 注意: HTTP/HTTPS ALBおよびHTTP NLBでは必須
    #       値を設定後、削除しても効果はありません。未設定にする場合は空文字列""を指定
    path = "/"

    # interval (Optional)
    # 設定内容: 個別ターゲットのヘルスチェック間隔（秒）を指定します。
    # 設定可能な値: 5〜300秒
    # 省略時: 30秒
    # 注意: lambdaターゲットグループの場合、基盤となるlambdaのタイムアウトより大きい必要あり
    interval = 30

    # timeout (Optional)
    # 設定内容: ターゲットからの応答がない場合にヘルスチェックを失敗とみなすまでの時間（秒）を指定します。
    # 設定可能な値: 2〜120秒
    # 省略時: HTTPの場合6秒、TCP/TLS/HTTPSの場合10秒、GENEVEの場合5秒、lambdaの場合30秒
    timeout = null

    # healthy_threshold (Optional)
    # 設定内容: ターゲットを正常とみなすために必要な連続成功回数を指定します。
    # 設定可能な値: 2〜10回
    # 省略時: 3回
    healthy_threshold = 3

    # unhealthy_threshold (Optional)
    # 設定内容: ターゲットを異常とみなすために必要な連続失敗回数を指定します。
    # 設定可能な値: 2〜10回
    # 省略時: 3回
    unhealthy_threshold = 3

    # matcher (Optional)
    # 設定内容: ターゲットからの成功レスポンスを確認する際に使用するHTTPコードまたはgRPCコードを指定します。
    # 設定可能な値: HTTPの場合は"200"や"200-299"などのHTTPステータスコード範囲
    #              gRPCの場合はgRPCコード（例: "0", "12"）
    # 省略時: HTTPの場合は"200"
    # 注意: HTTP/HTTPSヘルスチェックでのみ適用
    matcher = null
  }

  #-------------------------------------------------------------
  # スティッキネス設定
  #-------------------------------------------------------------

  # stickiness (Optional)
  # 設定内容: セッションの持続性（スティッキネス）設定を指定するブロックです。
  # 注意: 最大1ブロックまで指定可能
  stickiness {
    # type (Required)
    # 設定内容: スティッキーセッションのタイプを指定します。
    # 設定可能な値:
    #   - "lb_cookie": ALB用ロードバランサー生成Cookie
    #   - "app_cookie": ALB用アプリケーション生成Cookie
    #   - "source_ip": NLB用ソースIP
    #   - "source_ip_dest_ip": GWLB用ソースIP・送信先IP
    #   - "source_ip_dest_ip_proto": GWLB用ソースIP・送信先IP・プロトコル
    type = "lb_cookie"

    # enabled (Optional)
    # 設定内容: スティッキネスを有効にするかを指定します。
    # 設定可能な値: true, false
    # 省略時: true
    enabled = true

    # cookie_duration (Optional)
    # 設定内容: クライアントからのリクエストを同じターゲットにルーティングする期間（秒）を指定します。
    # 設定可能な値: 1秒〜1週間（604800秒）
    # 省略時: 1日（86400秒）
    # 注意: typeが"lb_cookie"の場合のみ使用
    cookie_duration = null

    # cookie_name (Optional)
    # 設定内容: アプリケーション生成Cookieの名前を指定します。
    # 設定可能な値: AWSALB、AWSALBAPP、AWSALBTGプレフィックスは予約済みのため使用不可
    # 注意: typeが"app_cookie"の場合のみ必要
    cookie_name = null
  }

  #-------------------------------------------------------------
  # ターゲットフェイルオーバー設定
  #-------------------------------------------------------------

  # target_failover (Optional)
  # 設定内容: ターゲットフェイルオーバー動作を指定するブロックです。
  # 注意: Gateway Load Balancerターゲットグループでのみ適用
  # target_failover {
  #   # on_deregistration (Required)
  #   # 設定内容: ターゲットの登録解除時にGWLBが既存フローをどう処理するかを指定します。
  #   # 設定可能な値: "rebalance", "no_rebalance"
  #   # 省略時: "no_rebalance"
  #   # 注意: on_unhealthyの値と一致する必要あり
  #   on_deregistration = "no_rebalance"
  #
  #   # on_unhealthy (Required)
  #   # 設定内容: ターゲットが異常時にGWLBが既存フローをどう処理するかを指定します。
  #   # 設定可能な値: "rebalance", "no_rebalance"
  #   # 省略時: "no_rebalance"
  #   # 注意: on_deregistrationの値と一致する必要あり
  #   on_unhealthy = "no_rebalance"
  # }

  #-------------------------------------------------------------
  # ターゲットヘルス状態設定
  #-------------------------------------------------------------

  # target_health_state (Optional)
  # 設定内容: ターゲットヘルス状態の動作を指定するブロックです。
  # 注意: protocolが"TCP"または"TLS"のNetwork Load Balancerターゲットグループでのみ適用
  # target_health_state {
  #   # enable_unhealthy_connection_termination (Required)
  #   # 設定内容: ロードバランサーが異常なターゲットへの接続を終了するかを指定します。
  #   # 設定可能な値: true, false
  #   # 省略時: true
  #   enable_unhealthy_connection_termination = true
  #
  #   # unhealthy_draining_interval (Optional)
  #   # 設定内容: ターゲットが異常になった際に、処理中のリクエスト完了を待つ時間（秒）を指定します。
  #   # 設定可能な値: 0〜360000秒
  #   # 省略時: 0
  #   # 注意: enable_unhealthy_connection_terminationがfalseの場合のみ設定可能
  #   unhealthy_draining_interval = null
  # }

  #-------------------------------------------------------------
  # ターゲットグループヘルス設定
  #-------------------------------------------------------------

  # target_group_health (Optional)
  # 設定内容: ターゲットグループのヘルス要件を指定するブロックです。
  # 注意: 最大1ブロックまで指定可能
  # target_group_health {
  #   #-----------------------------------------------------------
  #   # DNSフェイルオーバー設定
  #   #-----------------------------------------------------------
  #
  #   # dns_failover (Optional)
  #   # 設定内容: DNSフェイルオーバー要件を指定するブロックです。
  #   # 注意: 最大1ブロックまで指定可能
  #   dns_failover {
  #     # minimum_healthy_targets_count (Optional)
  #     # 設定内容: 正常である必要がある最小ターゲット数を指定します。
  #     # 設定可能な値: "off"または1〜最大ターゲット数の整数
  #     # 省略時: "off"
  #     # 注意: この値を下回る場合、DNSでゾーンを異常としてマークし、正常なゾーンのみにトラフィックをルーティング
  #     minimum_healthy_targets_count = "off"
  #
  #     # minimum_healthy_targets_percentage (Optional)
  #     # 設定内容: 正常である必要がある最小ターゲット割合（%）を指定します。
  #     # 設定可能な値: "off"または1〜100の整数
  #     # 省略時: "off"
  #     # 注意: この値を下回る場合、DNSでゾーンを異常としてマークし、正常なゾーンのみにトラフィックをルーティング
  #     minimum_healthy_targets_percentage = "off"
  #   }
  #
  #   #-----------------------------------------------------------
  #   # 異常状態ルーティング設定
  #   #-----------------------------------------------------------
  #
  #   # unhealthy_state_routing (Optional)
  #   # 設定内容: 異常状態ルーティング要件を指定するブロックです。
  #   # 注意: 最大1ブロックまで指定可能
  #   unhealthy_state_routing {
  #     # minimum_healthy_targets_count (Optional)
  #     # 設定内容: 正常である必要がある最小ターゲット数を指定します。
  #     # 設定可能な値: 1〜最大ターゲット数の整数
  #     # 省略時: 1
  #     # 注意: この値を下回る場合、異常なターゲットを含むすべてのターゲットにトラフィックを送信
  #     minimum_healthy_targets_count = 1
  #
  #     # minimum_healthy_targets_percentage (Optional)
  #     # 設定内容: 正常である必要がある最小ターゲット割合（%）を指定します。
  #     # 設定可能な値: "off"または1〜100の整数
  #     # 省略時: "off"
  #     # 注意: この値を下回る場合、異常なターゲットを含むすべてのターゲットにトラフィックを送信
  #     minimum_healthy_targets_percentage = "off"
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ターゲットグループのARN（idと同一）
#
# - arn_suffix: CloudWatch Metricsで使用するARNサフィックス
#
# - id: ターゲットグループのARN（arnと同一）
#
# - name: ターゲットグループの名前
#
# - load_balancer_arns: ターゲットグループに関連付けられたロードバランサーのARNリスト
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
