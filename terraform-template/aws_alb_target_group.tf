#---------------------------------------------------------------
# AWS ALB Target Group (aws_alb_target_group)
#---------------------------------------------------------------
#
# Elastic Load Balancing (ELB) のターゲットグループをプロビジョニングするリソースです。
# ターゲットグループは、Application Load Balancer (ALB)、Network Load Balancer (NLB)、
# または Gateway Load Balancer (GWLB) がリクエストをルーティングする先のターゲット
# （EC2インスタンス、IPアドレス、Lambda関数など）を定義します。
#
# NOTE: aws_alb_target_group は aws_lb_target_group のエイリアスであり、
#       機能は完全に同一です。
#
# AWS公式ドキュメント:
#   - ALB ターゲットグループ: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
#   - NLB ターゲットグループ: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html
#   - GWLB ターゲットグループ: https://docs.aws.amazon.com/elasticloadbalancing/latest/gateway/target-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_alb_target_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: ターゲットグループの名前を指定します。
  # 設定可能な値: 最大32文字。英数字とハイフンのみ使用可能。
  #   先頭と末尾にハイフンを使用することはできません。
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  #       リージョン内・アカウント内で一意である必要があります。
  name = "example-target-group"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: ターゲットグループ名のプレフィックスを指定します。
  # 設定可能な値: 最大6文字の文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

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
  # ターゲット設定
  #-------------------------------------------------------------

  # target_type (Optional, Forces new resource)
  # 設定内容: ターゲットグループに登録するターゲットの種類を指定します。
  # 設定可能な値:
  #   - "instance" (デフォルト): EC2インスタンスID。インスタンスIDとポートで登録。
  #   - "ip": IPアドレス。VPCサブネットのIPまたはRFC 1918/6598範囲のIP。
  #   - "lambda": Lambda関数。ALBのみサポート。
  #   - "alb": Application Load Balancer。NLBのみサポート。
  # 注意:
  #   - NLBではlambdaターゲットタイプはサポートされません。
  #   - ALBではalbターゲットタイプはサポートされません。
  #   - ipの場合、パブリックにルーティング可能なIPアドレスは指定できません。
  # 参考: https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateTargetGroup.html
  target_type = "instance"

  # vpc_id (Optional, Forces new resource)
  # 設定内容: ターゲットグループを作成するVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID
  # 必須条件: target_typeが"instance"、"ip"、または"alb"の場合は必須です。
  # 注意: target_typeが"lambda"の場合は適用されません。
  vpc_id = "vpc-12345678"

  # port (Optional, Forces new resource)
  # 設定内容: ターゲットがトラフィックを受信するポート番号を指定します。
  # 設定可能な値: 1-65535の整数
  # 必須条件: target_typeが"instance"、"ip"、または"alb"の場合は必須です。
  # 注意: target_typeが"lambda"の場合は適用されません。
  #       個々のターゲット登録時にオーバーライド可能です。
  port = 80

  # protocol (Optional, Forces new resource)
  # 設定内容: ターゲットへのトラフィックルーティングに使用するプロトコルを指定します。
  # 設定可能な値:
  #   - "HTTP": ALB用
  #   - "HTTPS": ALB用
  #   - "TCP": NLB/GWLB用
  #   - "TLS": NLB用
  #   - "UDP": NLB用
  #   - "TCP_UDP": NLB用
  #   - "GENEVE": GWLB用
  #   - "QUIC": ALB用
  #   - "TCP_QUIC": NLB用
  # 必須条件: target_typeが"instance"、"ip"、または"alb"の場合は必須です。
  # 注意: target_typeが"lambda"の場合は適用されません。
  protocol = "HTTP"

  # protocol_version (Optional, Forces new resource)
  # 設定内容: プロトコルバージョンを指定します。
  # 設定可能な値:
  #   - "HTTP1" (デフォルト): HTTP/1.1を使用してターゲットにリクエストを送信
  #   - "HTTP2": HTTP/2を使用してターゲットにリクエストを送信
  #   - "GRPC": gRPCを使用してターゲットにリクエストを送信
  # 注意: protocolが"HTTP"または"HTTPS"の場合のみ適用されます。
  protocol_version = "HTTP1"

  # ip_address_type (Optional)
  # 設定内容: ターゲットグループで使用するIPアドレスタイプを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4アドレスのみ
  #   - "ipv6": IPv6アドレスのみ
  # 省略時: ターゲットグループのプロトコルとVPC設定に基づいて自動決定
  ip_address_type = "ipv4"

  # target_control_port (Optional)
  # 設定内容: ターゲット制御エージェントとALB間で管理トラフィックを
  #           交換するために使用するポートを指定します。
  # 設定可能な値: 有効なポート番号
  # 注意: ALBターゲットグループでtarget_typeが"instance"または"ip"の場合のみ適用。
  #       ターゲットオプティマイザー機能用です。
  target_control_port = null

  #-------------------------------------------------------------
  # 登録解除設定
  #-------------------------------------------------------------

  # deregistration_delay (Optional)
  # 設定内容: 登録解除中のターゲットの状態を「draining」から「unused」に
  #           変更するまでのELBの待機時間（秒）を指定します。
  # 設定可能な値: "0"～"3600"（秒）の文字列
  # デフォルト: "300"秒（5分）
  # 関連機能: 登録解除遅延
  #   ターゲットの登録解除時に進行中のリクエストを完了させるための待機時間。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#deregistration-delay
  deregistration_delay = "300"

  # connection_termination (Optional)
  # 設定内容: NLBで登録解除タイムアウト終了時に接続を終了するかを指定します。
  # 設定可能な値:
  #   - true: 登録解除タイムアウト終了時に既存の接続を終了
  #   - false (デフォルト): 接続を終了しない
  # 注意: Network Load Balancerでのみ適用されます。
  # 参考: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#deregistration-delay
  connection_termination = false

  #-------------------------------------------------------------
  # ロードバランシング設定
  #-------------------------------------------------------------

  # load_balancing_algorithm_type (Optional)
  # 設定内容: ロードバランサーがリクエストをルーティングする際の
  #           ターゲット選択アルゴリズムを指定します。
  # 設定可能な値:
  #   - "round_robin" (デフォルト): ラウンドロビン方式
  #   - "least_outstanding_requests": 未処理リクエストが最も少ないターゲットを選択
  #   - "weighted_random": 重み付きランダム方式（異常検出軽減で使用）
  # 注意: Application Load Balancerターゲットグループでのみ適用されます。
  load_balancing_algorithm_type = "round_robin"

  # load_balancing_anomaly_mitigation (Optional)
  # 設定内容: ターゲット異常検出軽減を有効にするかを指定します。
  # 設定可能な値:
  #   - "on": 異常検出軽減を有効化
  #   - "off" (デフォルト): 異常検出軽減を無効化
  # 注意: load_balancing_algorithm_typeが"weighted_random"の場合のみサポート。
  # 関連機能: 自動ターゲット重み付け (ATW)
  #   異常なターゲットへのトラフィックを自動的に減少させる機能。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#automatic-target-weights
  load_balancing_anomaly_mitigation = "off"

  # load_balancing_cross_zone_enabled (Optional)
  # 設定内容: クロスゾーンロードバランシングを有効にするかを指定します。
  # 設定可能な値:
  #   - "true": クロスゾーンロードバランシングを有効化
  #   - "false": クロスゾーンロードバランシングを無効化
  #   - "use_load_balancer_configuration" (デフォルト): ロードバランサーの設定に従う
  # 関連機能: クロスゾーンロードバランシング
  #   複数のアベイラビリティゾーンにまたがってトラフィックを均等に分散する機能。
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"

  #-------------------------------------------------------------
  # スロースタート設定
  #-------------------------------------------------------------

  # slow_start (Optional)
  # 設定内容: ターゲットがウォームアップするまでの時間（秒）を指定します。
  # 設定可能な値: 30～900秒、または0（無効化）
  # デフォルト: 0（無効）
  # 関連機能: スロースタートモード
  #   新しく登録されたターゲットに対して、ロードバランサーがフルシェアの
  #   リクエストを送信する前にウォームアップ時間を設ける機能。
  slow_start = 0

  #-------------------------------------------------------------
  # クライアントIP保持設定
  #-------------------------------------------------------------

  # preserve_client_ip (Optional)
  # 設定内容: クライアントIPアドレスの保持を有効にするかを指定します。
  # 設定可能な値:
  #   - "true": クライアントIPを保持（ターゲットはクライアントの実際のIPを確認可能）
  #   - "false": クライアントIPを保持しない
  # 省略時: ターゲットグループの種類とプロトコルに応じたデフォルト値
  # 関連機能: クライアントIP保持
  #   ターゲットがリクエスト元のクライアントIPアドレスを確認できる機能。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#client-ip-preservation
  preserve_client_ip = null

  # proxy_protocol_v2 (Optional)
  # 設定内容: プロキシプロトコルv2のサポートを有効にするかを指定します。
  # 設定可能な値:
  #   - true: プロキシプロトコルv2を有効化
  #   - false (デフォルト): プロキシプロトコルv2を無効化
  # 注意: Network Load Balancerでのみ適用されます。
  # 関連機能: プロキシプロトコルv2
  #   接続元のIPアドレスやポートなどの接続情報をターゲットに渡す機能。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#proxy-protocol
  proxy_protocol_v2 = false

  #-------------------------------------------------------------
  # Lambda設定
  #-------------------------------------------------------------

  # lambda_multi_value_headers_enabled (Optional)
  # 設定内容: ロードバランサーとLambda関数間でやり取りされるリクエスト/レスポンス
  #           ヘッダーに配列を含めるかを指定します。
  # 設定可能な値:
  #   - true: 複数値ヘッダーを有効化（ヘッダー値を配列として扱う）
  #   - false (デフォルト): 複数値ヘッダーを無効化（ヘッダー値を文字列として扱う）
  # 注意: target_typeが"lambda"の場合のみ適用されます。
  lambda_multi_value_headers_enabled = false

  #-------------------------------------------------------------
  # ヘルスチェック設定
  #-------------------------------------------------------------

  # health_check (Optional, Maximum of 1)
  # 設定内容: ターゲットのヘルスチェック設定を指定します。
  health_check {
    # enabled (Optional)
    # 設定内容: ヘルスチェックを有効にするかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): ヘルスチェックを有効化
    #   - false: ヘルスチェックを無効化
    enabled = true

    # protocol (Optional)
    # 設定内容: ヘルスチェックに使用するプロトコルを指定します。
    # 設定可能な値:
    #   - "HTTP" (デフォルト): HTTPでヘルスチェック
    #   - "HTTPS": HTTPSでヘルスチェック
    #   - "TCP": TCPでヘルスチェック
    # 注意: ターゲットグループのプロトコルがHTTPまたはHTTPSの場合、
    #       TCPプロトコルはヘルスチェックでサポートされません。
    #       target_typeが"lambda"の場合は指定できません。
    protocol = "HTTP"

    # port (Optional)
    # 設定内容: ヘルスチェックを実行するポートを指定します。
    # 設定可能な値:
    #   - "traffic-port" (デフォルト): ターゲットグループと同じポートを使用
    #   - "1"～"65536": 特定のポート番号
    port = "traffic-port"

    # path (Optional)
    # 設定内容: ヘルスチェックリクエストの宛先パスを指定します。
    # 設定可能な値: 有効なURIパス
    # デフォルト:
    #   - HTTP/HTTPSヘルスチェック: "/"
    #   - gRPCヘルスチェック: "/AWS.ALB/healthcheck"
    # 注意: HTTP/HTTPS ALBおよびHTTP NLBでは必須です。
    #       HTTP/HTTPSプロトコルにのみ適用されます。
    path = "/"

    # matcher (Optional)
    # 設定内容: ターゲットからの正常なレスポンスを判定するためのコードを指定します。
    # 設定可能な値:
    #   - HTTP/HTTPS: HTTPステータスコード（例: "200", "200-299", "200,202"）
    #   - gRPC: gRPCステータスコード（例: "0-99"）
    # デフォルト:
    #   - HTTP: "200"
    #   - gRPC: "12"
    matcher = "200"

    # interval (Optional)
    # 設定内容: 個々のターゲットのヘルスチェック間のおおよその間隔（秒）を指定します。
    # 設定可能な値: 5～300秒
    # デフォルト: 30秒
    # 注意: Lambdaターゲットグループの場合、基盤となるLambdaのタイムアウトより
    #       大きい値を設定する必要があります。
    interval = 30

    # timeout (Optional)
    # 設定内容: ターゲットからのレスポンスがない場合にヘルスチェックが
    #           失敗したと判断するまでの時間（秒）を指定します。
    # 設定可能な値: 2～120秒
    # デフォルト:
    #   - HTTP: 6秒
    #   - TCP/TLS/HTTPS: 10秒
    #   - GENEVE: 5秒
    #   - Lambda: 30秒
    timeout = 6

    # healthy_threshold (Optional)
    # 設定内容: ターゲットを正常と判断するために必要な連続成功回数を指定します。
    # 設定可能な値: 2～10回
    # デフォルト: 3回
    healthy_threshold = 3

    # unhealthy_threshold (Optional)
    # 設定内容: ターゲットを異常と判断するために必要な連続失敗回数を指定します。
    # 設定可能な値: 2～10回
    # デフォルト: 3回
    unhealthy_threshold = 3
  }

  #-------------------------------------------------------------
  # スティッキネス設定
  #-------------------------------------------------------------

  # stickiness (Optional, Maximum of 1)
  # 設定内容: セッションスティッキネス（セッション維持）の設定を指定します。
  # 関連機能: スティッキーセッション
  #   同じクライアントからのリクエストを同じターゲットにルーティングする機能。
  stickiness {
    # type (Required)
    # 設定内容: スティッキーセッションの種類を指定します。
    # 設定可能な値:
    #   - "lb_cookie": ALB用。ロードバランサー生成のCookieを使用。
    #   - "app_cookie": ALB用。アプリケーション生成のCookieを使用。
    #   - "source_ip": NLB用。送信元IPアドレスを使用。
    #   - "source_ip_dest_ip": GWLB用。送信元IPと宛先IPを使用。
    #   - "source_ip_dest_ip_proto": GWLB用。送信元IP、宛先IP、プロトコルを使用。
    type = "lb_cookie"

    # enabled (Optional)
    # 設定内容: スティッキネスを有効にするかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): スティッキネスを有効化
    #   - false: スティッキネスを無効化
    enabled = true

    # cookie_duration (Optional)
    # 設定内容: ロードバランサー生成のCookieの有効期間（秒）を指定します。
    # 設定可能な値: 1～604800秒（1秒～1週間）
    # デフォルト: 86400秒（1日）
    # 注意: typeが"lb_cookie"の場合のみ適用されます。
    cookie_duration = 86400

    # cookie_name (Optional)
    # 設定内容: アプリケーションベースのCookie名を指定します。
    # 設定可能な値: 任意の文字列。ただし、AWSALB、AWSALBAPP、AWSALBTGプレフィックスは
    #               予約されており使用できません。
    # 注意: typeが"app_cookie"の場合のみ必要です。
    cookie_name = null
  }

  #-------------------------------------------------------------
  # ターゲットフェイルオーバー設定 (GWLB用)
  #-------------------------------------------------------------

  # target_failover (Optional)
  # 設定内容: Gateway Load Balancerターゲットグループのフェイルオーバー動作を指定します。
  # 注意: Gateway Load Balancerターゲットグループでのみ適用されます。
  # target_failover {
  #   # on_deregistration (Required)
  #   # 設定内容: ターゲットが登録解除された際の既存フローの処理方法を指定します。
  #   # 設定可能な値:
  #   #   - "rebalance": 既存フローを残りの正常なターゲットに再分散
  #   #   - "no_rebalance" (デフォルト): 既存フローを再分散しない
  #   # 注意: on_unhealthyと同じ値を設定する必要があります。
  #   on_deregistration = "no_rebalance"
  #
  #   # on_unhealthy (Required)
  #   # 設定内容: ターゲットが異常になった際の既存フローの処理方法を指定します。
  #   # 設定可能な値:
  #   #   - "rebalance": 既存フローを残りの正常なターゲットに再分散
  #   #   - "no_rebalance" (デフォルト): 既存フローを再分散しない
  #   # 注意: on_deregistrationと同じ値を設定する必要があります。
  #   on_unhealthy = "no_rebalance"
  # }

  #-------------------------------------------------------------
  # ターゲットヘルス状態設定 (NLB用)
  #-------------------------------------------------------------

  # target_health_state (Optional)
  # 設定内容: Network Load Balancerターゲットグループのヘルス状態に関する動作を指定します。
  # 注意: NLBターゲットグループでprotocolが"TCP"または"TLS"の場合のみ適用されます。
  # target_health_state {
  #   # enable_unhealthy_connection_termination (Required)
  #   # 設定内容: ロードバランサーが異常なターゲットへの接続を終了するかを指定します。
  #   # 設定可能な値:
  #   #   - true (デフォルト): 異常なターゲットへの接続を終了
  #   #   - false: 異常なターゲットへの接続を終了しない
  #   enable_unhealthy_connection_termination = true
  #
  #   # unhealthy_draining_interval (Optional)
  #   # 設定内容: ターゲットが異常になった際に進行中のリクエストが完了するまで
  #   #           待機する時間（秒）を指定します。
  #   # 設定可能な値: 0～360000秒
  #   # デフォルト: 0
  #   # 注意: enable_unhealthy_connection_terminationがfalseの場合のみ設定する必要があります。
  #   unhealthy_draining_interval = 0
  # }

  #-------------------------------------------------------------
  # ターゲットグループヘルス設定
  #-------------------------------------------------------------

  # target_group_health (Optional, Maximum of 1)
  # 設定内容: ターゲットグループのヘルス要件を指定します。
  # 関連機能: ターゲットグループヘルス
  #   DNSフェイルオーバーとルーティング動作を制御するための正常ターゲット要件。
  # target_group_health {
  #   # dns_failover (Optional, Maximum of 1)
  #   # 設定内容: DNSフェイルオーバーの要件を指定します。
  #   dns_failover {
  #     # minimum_healthy_targets_count (Optional)
  #     # 設定内容: 正常でなければならないターゲットの最小数を指定します。
  #     # 設定可能な値:
  #     #   - "off" (デフォルト): この要件を無効化
  #     #   - "1"～最大ターゲット数: 必要な正常ターゲット数
  #     # 動作: 正常なターゲット数がこの値を下回ると、DNSでゾーンを異常とマークし、
  #     #       トラフィックは正常なゾーンにのみルーティングされます。
  #     minimum_healthy_targets_count = "off"
  #
  #     # minimum_healthy_targets_percentage (Optional)
  #     # 設定内容: 正常でなければならないターゲットの最小割合を指定します。
  #     # 設定可能な値:
  #     #   - "off" (デフォルト): この要件を無効化
  #     #   - "1"～"100": 必要な正常ターゲットの割合（%）
  #     minimum_healthy_targets_percentage = "off"
  #   }
  #
  #   # unhealthy_state_routing (Optional, Maximum of 1)
  #   # 設定内容: 異常状態時のルーティング要件を指定します。
  #   unhealthy_state_routing {
  #     # minimum_healthy_targets_count (Optional)
  #     # 設定内容: 正常でなければならないターゲットの最小数を指定します。
  #     # 設定可能な値: 1～最大ターゲット数
  #     # デフォルト: 1
  #     # 動作: 正常なターゲット数がこの値を下回ると、異常なターゲットを含む
  #     #       全ターゲットにトラフィックを送信します。
  #     minimum_healthy_targets_count = 1
  #
  #     # minimum_healthy_targets_percentage (Optional)
  #     # 設定内容: 正常でなければならないターゲットの最小割合を指定します。
  #     # 設定可能な値:
  #     #   - "off" (デフォルト): この要件を無効化
  #     #   - "1"～"100": 必要な正常ターゲットの割合（%）
  #     minimum_healthy_targets_percentage = "off"
  #   }
  # }

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
    Name        = "example-target-group"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグ。
  # 注意: 通常は直接設定せず、tagsとdefault_tagsの組み合わせで管理します。
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ターゲットグループのAmazon Resource Name (ARN)。idと同じ値。
#
# - arn_suffix: CloudWatch Metricsで使用するためのARNサフィックス。
#               例: "targetgroup/my-tg/50dc6c495c0c9188"
#
# - id: ターゲットグループのARN（arnと同じ値）。
#
# - load_balancer_arns: ターゲットグループに関連付けられたロードバランサーのARNセット。
#
# - name: ターゲットグループの名前。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
