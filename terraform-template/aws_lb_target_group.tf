#---------------------------------------------------------------
# Elastic Load Balancing Target Group
#---------------------------------------------------------------
#
# Application Load Balancer、Network Load Balancer、Gateway Load Balancerで
# 使用するターゲットグループを作成します。ターゲットグループは、
# ロードバランサーからのトラフィックを登録されたターゲット（EC2インスタンス、
# IPアドレス、Lambda関数、別のALB）に分散するために使用されます。
#
# AWS公式ドキュメント:
#   - Target groups for your Application Load Balancers: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
#   - Target groups for your Network Load Balancers: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html
#   - CreateTargetGroup API Reference: https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateTargetGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_target_group" "example" {
  # ターゲットグループの名前
  # 32文字以内の英数字とハイフンのみ使用可能。先頭または末尾にハイフンは不可。
  # リージョンごとのアカウントごとに一意である必要があります。
  # 省略するとTerraformがランダムな一意の名前を割り当てます。
  # name と name_prefix は競合するため、どちらか一方のみを指定してください。
  name = "example-target-group"

  # ターゲットグループ名のプレフィックス
  # 指定したプレフィックスで始まる一意の名前を作成します。
  # name と競合するため、どちらか一方のみを指定してください。
  # 6文字以内である必要があります。
  # name_prefix = "tg-"

  # ターゲットがトラフィックを受信するポート番号
  # target_type が instance、ip、alb の場合は必須です。
  # target_type が lambda の場合は適用されません。
  # 1-65535の範囲で指定します。
  port = 80

  # ターゲットへのトラフィックのルーティングに使用するプロトコル
  # GENEVE、HTTP、HTTPS、TCP、TCP_UDP、TLS、UDP、QUIC、TCP_QUIC のいずれかを指定します。
  # target_type が instance、ip、alb の場合は必須です。
  # target_type が lambda の場合は適用されません。
  protocol = "HTTP"

  # プロトコルバージョン
  # protocol が HTTP または HTTPS の場合のみ適用されます。
  # HTTP1（デフォルト）: HTTP/1.1を使用してリクエストを送信
  # HTTP2: HTTP/2を使用してリクエストを送信
  # GRPC: gRPCを使用してリクエストを送信
  # リソースの作成後は変更できません（Forces new resource）。
  # protocol_version = "HTTP1"

  # ターゲットグループを作成するVPCの識別子
  # target_type が instance、ip、alb の場合は必須です。
  # target_type が lambda の場合は適用されません。
  vpc_id = "vpc-12345678"

  # ターゲットタイプ
  # instance: EC2インスタンスIDでターゲットを指定
  # ip: IPアドレスでターゲットを指定
  # lambda: Lambda関数ARNでターゲットを指定
  # alb: Application Load BalancerのARNでターゲットを指定
  # デフォルトは instance です。
  # リソースの作成後は変更できません（Forces new resource）。
  # Network Load Balancerはlambdaターゲットタイプをサポートしていません。
  # Application Load Balancerはalbターゲットタイプをサポートしていません。
  # target_type = "instance"

  # IPアドレスタイプ
  # IPv4またはIPv6を指定します。
  # IPv6ターゲットグループはデュアルスタックロードバランサーでのみ使用できます。
  # IPv4ターゲットグループは、デュアルスタックロードバランサーのUDPリスナー、
  # またはQUIC/TCP_QUICプロトコルでは使用できません。
  # ip_address_type = "ipv4"

  # 登録解除遅延時間（秒）
  # Elastic Load Balancingが登録解除中のターゲットの状態をdrainingから
  # unusedに変更するまでの待機時間。
  # 0-3600秒の範囲で指定します。デフォルトは300秒です。
  # deregistration_delay = "300"

  # Network Load Balancerでの接続終了設定
  # 登録解除タイムアウトの終了時に接続を終了するかどうかを指定します。
  # デフォルトはfalseです。
  # connection_termination = false

  # スロースタート期間（秒）
  # ターゲットがロードバランサーから完全な割合のリクエストを受信する前に
  # ウォームアップする時間。30-900秒の範囲、または0で無効化します。
  # デフォルトは0秒（無効）です。
  # slow_start = 0

  # ロードバランシングアルゴリズムタイプ
  # Application Load Balancerターゲットグループにのみ適用されます。
  # round_robin: ラウンドロビン（デフォルト）
  # least_outstanding_requests: 最小未処理リクエスト数
  # weighted_random: 重み付きランダム
  # load_balancing_algorithm_type = "round_robin"

  # ターゲット異常緩和機能
  # ターゲットの異常を検出して緩和する機能を有効にするかどうかを指定します。
  # weighted_random ロードバランシングアルゴリズムタイプでのみサポートされます。
  # "on" または "off" を指定します。デフォルトは "off" です。
  # load_balancing_anomaly_mitigation = "off"

  # クロスゾーンロードバランシング設定
  # クロスゾーンロードバランシングを有効にするかどうかを指定します。
  # "true": 有効
  # "false": 無効
  # "use_load_balancer_configuration": ロードバランサーの設定を使用（デフォルト）
  # load_balancing_cross_zone_enabled = "use_load_balancer_configuration"

  # クライアントIP保持設定
  # クライアントIPアドレスの保持が有効かどうかを指定します。
  # Network Load Balancerでのみ適用されます。
  # preserve_client_ip = null

  # Proxy Protocol v2サポート
  # Network Load BalancerでProxy Protocol v2のサポートを有効にするかどうかを指定します。
  # デフォルトはfalseです。
  # proxy_protocol_v2 = false

  # Lambda関数のマルチバリューヘッダー
  # ロードバランサーとLambda関数間で交換されるリクエスト/レスポンスヘッダーに
  # 配列の値または文字列を含めるかどうかを指定します。
  # target_type が lambda の場合のみ適用されます。デフォルトはfalseです。
  # lambda_multi_value_headers_enabled = false

  # ターゲット制御ポート
  # ターゲット最適化機能のために、ターゲット制御エージェントとアプリケーション
  # ロードバランサーが管理トラフィックを交換するポート番号。
  # Application Load Balancerターゲットグループで、target_type が instance または ip の場合のみ適用されます。
  # target_control_port = null

  # リソースのリージョン
  # このリソースが管理されるリージョンを指定します。
  # 省略するとプロバイダー設定のリージョンがデフォルトとして使用されます。
  # region = "us-east-1"

  # タグ
  # リソースに割り当てるタグのマップ。
  # プロバイダーの default_tags 設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたタグを上書きします。
  tags = {
    Name        = "example-target-group"
    Environment = "production"
  }

  # すべてのタグ（tags_allは通常設定不要）
  # リソースとプロバイダーdefault_tagsの両方からのタグを含むマップ。
  # 通常はTerraformが自動的に管理するため、明示的に設定する必要はありません。
  # tags_all = {}

  # リソースID（idは通常設定不要）
  # Terraformが自動的に生成するリソースの一意識別子。
  # 通常は明示的に設定する必要はありません。設定した場合はARNとして扱われます。
  # id = null

  #---------------------------------------------------------------
  # ヘルスチェック設定
  #---------------------------------------------------------------
  health_check {
    # ヘルスチェックの有効化
    # デフォルトはtrueです。
    enabled = true

    # ヘルスチェックのプロトコル
    # TCP、HTTP、HTTPSのいずれかを指定します。
    # ターゲットグループのプロトコルがHTTPまたはHTTPSの場合、TCPプロトコルは
    # ヘルスチェックではサポートされません。
    # デフォルトはHTTPです。
    # target_type が lambda の場合は指定できません。
    protocol = "HTTP"

    # ヘルスチェックのパス
    # HTTP/HTTPS ALBおよびHTTP NLBの場合は必須です。
    # HTTP/HTTPSにのみ適用されます。
    # 一度設定すると、削除しても効果はありません。設定を解除するには空文字列 "" を設定します。
    # HTTP/HTTPSヘルスチェックのデフォルトは / です。
    # gRPCヘルスチェックのデフォルトは /AWS.ALB/healthcheck です。
    path = "/"

    # ヘルスチェックのポート
    # traffic-port: ターゲットグループと同じポートを使用
    # 1-65536の範囲の有効なポート番号
    # デフォルトは traffic-port です。
    port = "traffic-port"

    # ヘルスチェック間隔（秒）
    # 個々のターゲットのヘルスチェック間のおおよその時間。
    # 5-300秒の範囲で指定します。
    # lambda ターゲットグループの場合、基盤となる lambda のタイムアウトより
    # 大きい必要があります。デフォルトは30秒です。
    interval = 30

    # ヘルスチェックタイムアウト（秒）
    # ターゲットからの応答がない場合にヘルスチェックが失敗したと見なされるまでの時間。
    # 2-120秒の範囲で指定します。
    # HTTPプロトコルのターゲットグループのデフォルトは6秒です。
    # TCP、TLS、HTTPSプロトコルのターゲットグループのデフォルトは10秒です。
    # GENEVEプロトコルのターゲットグループのデフォルトは5秒です。
    # lambdaターゲットタイプの場合のデフォルトは30秒です。
    timeout = 5

    # 正常しきい値
    # ターゲットを正常と見なすために必要な連続したヘルスチェック成功回数。
    # 2-10の範囲で指定します。デフォルトは3です。
    healthy_threshold = 3

    # 異常しきい値
    # ターゲットを異常と見なすために必要な連続したヘルスチェック失敗回数。
    # 2-10の範囲で指定します。デフォルトは3です。
    unhealthy_threshold = 3

    # ヘルスチェックマッチャー
    # ターゲットからの正常な応答を確認するために使用するHTTPまたはgRPCコード。
    # HTTP/HTTPSヘルスチェックの場合、200-499の範囲のHTTPコード（例: "200" または "200-299"）
    # gRPCヘルスチェックの場合、0-99の範囲のgRPCコード（例: "0" または "0,1"）
    # matcher = "200"
  }

  #---------------------------------------------------------------
  # スティッキネス設定
  #---------------------------------------------------------------
  # セッションの永続性（スティッキー セッション）を設定します。
  # 同じクライアントからのリクエストを同じターゲットにルーティングします。
  # stickiness {
  #   # スティッキネスタイプ（必須）
  #   # lb_cookie: ロードバランサー生成Cookie（ALB用）
  #   # app_cookie: アプリケーション生成Cookie（ALB用）
  #   # source_ip: 送信元IPアドレス（NLB用）
  #   # source_ip_dest_ip: 送信元IPと宛先IP（GWLB用）
  #   # source_ip_dest_ip_proto: 送信元IP、宛先IP、プロトコル（GWLB用）
  #   type = "lb_cookie"
  #
  #   # スティッキネスの有効化
  #   # デフォルトはtrueです。
  #   enabled = true
  #
  #   # Cookie有効期間（秒）
  #   # type が lb_cookie の場合のみ使用されます。
  #   # クライアントからのリクエストを同じターゲットにルーティングする期間。
  #   # 1秒から1週間（604800秒）の範囲で指定します。デフォルトは1日（86400秒）です。
  #   cookie_duration = 86400
  #
  #   # アプリケーションベースのCookie名
  #   # type が app_cookie の場合のみ必要です。
  #   # AWSALB、AWSALBAPP、AWSTALBTGプレフィックスは予約されており使用できません。
  #   # cookie_name = "my-app-cookie"
  # }

  #---------------------------------------------------------------
  # ターゲットフェイルオーバー設定
  #---------------------------------------------------------------
  # Gateway Load Balancerターゲットグループにのみ適用されます。
  # target_failover {
  #   # 登録解除時のフェイルオーバー動作
  #   # ターゲットが登録解除されたときにGWLBが既存のフローをどのように処理するかを指定します。
  #   # rebalance: フローを再分散
  #   # no_rebalance: フローを再分散しない（デフォルト）
  #   # on_unhealthy の値と一致する必要があります。
  #   on_deregistration = "no_rebalance"
  #
  #   # 異常時のフェイルオーバー動作
  #   # ターゲットが異常になったときにGWLBが既存のフローをどのように処理するかを指定します。
  #   # rebalance: フローを再分散
  #   # no_rebalance: フローを再分散しない（デフォルト）
  #   # on_deregistration の値と一致する必要があります。
  #   on_unhealthy = "no_rebalance"
  # }

  #---------------------------------------------------------------
  # ターゲットヘルス状態設定
  #---------------------------------------------------------------
  # Network Load Balancerターゲットグループで、protocol が TCP または TLS の場合のみ適用されます。
  # target_health_state {
  #   # 異常なターゲットへの接続終了の有効化
  #   # ロードバランサーが異常なターゲットへの接続を終了するかどうかを指定します。
  #   # デフォルトはtrueです。
  #   enable_unhealthy_connection_termination = true
  #
  #   # 異常なドレイン間隔（秒）
  #   # ターゲットが異常になったときに、進行中のリクエストが完了するまで待機する時間。
  #   # 0-360000秒の範囲で指定します。
  #   # enable_unhealthy_connection_termination が false の場合のみ設定する必要があります。
  #   # デフォルトは0です。
  #   # unhealthy_draining_interval = 0
  # }

  #---------------------------------------------------------------
  # ターゲットグループヘルス設定
  #---------------------------------------------------------------
  # DNSフェイルオーバーと異常状態ルーティングの要件を設定します。
  # target_group_health {
  #   # DNSフェイルオーバー設定
  #   dns_failover {
  #     # 最小正常ターゲット数
  #     # この値を下回る正常なターゲット数の場合、DNSでゾーンを異常としてマークします。
  #     # "off" または1からターゲットの最大数までの整数を指定します。
  #     # デフォルトは "off" です。
  #     minimum_healthy_targets_count = "off"
  #
  #     # 最小正常ターゲット割合
  #     # この値を下回る正常なターゲットの割合の場合、DNSでゾーンを異常としてマークします。
  #     # "off" または1から100までの整数を指定します。
  #     # デフォルトは "off" です。
  #     minimum_healthy_targets_percentage = "off"
  #   }
  #
  #   # 異常状態ルーティング設定
  #   unhealthy_state_routing {
  #     # 最小正常ターゲット数
  #     # この値を下回る正常なターゲット数の場合、異常なターゲットを含む
  #     # すべてのターゲットにトラフィックを送信します。
  #     # 1からターゲットの最大数までの整数を指定します。
  #     # デフォルトは1です。
  #     minimum_healthy_targets_count = 1
  #
  #     # 最小正常ターゲット割合
  #     # この値を下回る正常なターゲットの割合の場合、異常なターゲットを含む
  #     # すべてのターゲットにトラフィックを送信します。
  #     # "off" または1から100までの整数を指定します。
  #     # デフォルトは "off" です。
  #     minimum_healthy_targets_percentage = "off"
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用の属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能ですが、設定はできません。
#
# - id
#   ターゲットグループのARN（arn と同じ値）
#
# - arn
#   ターゲットグループのARN
#
# - arn_suffix
#   CloudWatch Metricsで使用するためのARNサフィックス
#
# - load_balancer_arns
#   ターゲットグループに関連付けられているロードバランサーのARNのセット
#
# - tags_all
#   リソースに割り当てられたタグのマップ。
#   プロバイダーの default_tags 設定ブロックから継承されたタグを含みます。
