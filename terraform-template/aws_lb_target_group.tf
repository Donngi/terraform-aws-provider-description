#---------------------------------------------------------------
# AWS LB Target Group (ALB / NLB / GWLB ターゲットグループ)
#---------------------------------------------------------------
#
# Application Load Balancer (ALB)、Network Load Balancer (NLB)、
# または Gateway Load Balancer (GWLB) のターゲットグループを管理するリソースです。
# aws_alb_target_group は aws_lb_target_group の別名であり、機能は同一です。
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
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_target_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: ターゲットグループの名前を指定します。
  # 設定可能な値: 最大32文字の英数字またはハイフン。ハイフンで始まったり終わったりすることはできません。
  # 省略時: Terraform が "tf-" で始まる名前を自動生成します。
  # 注意: name_prefix と排他的（どちらか一方のみ指定可能）
  name = "example-tg"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: 指定したプレフィックスで始まる一意な名前を生成します。
  # 設定可能な値: 最大6文字の文字列プレフィックス
  # 注意: name と排他的（どちらか一方のみ指定可能）
  name_prefix = null

  # target_type (Optional, Forces new resource)
  # 設定内容: ターゲットの登録方法（タイプ）を指定します。
  # 設定可能な値:
  #   - "instance" (デフォルト): EC2 インスタンスをターゲットに指定（インスタンス ID で登録）
  #   - "ip": IP アドレスをターゲットに指定（VPC 内の IP またはオンプレ接続）
  #   - "lambda": Lambda 関数をターゲットに指定（ALB のみ）
  #   - "alb": ALB をターゲットに指定（NLB のみ）
  # 注意: "lambda" を指定する場合、port、protocol、vpc_id は設定不要です。
  target_type = "instance"

  # protocol (Optional, Forces new resource)
  # 設定内容: ターゲットへのトラフィックのルーティングに使用するプロトコルを指定します。
  # 設定可能な値:
  #   - "HTTP": HTTP プロトコル（ALB）
  #   - "HTTPS": HTTPS プロトコル（ALB）
  #   - "TCP": TCP プロトコル（NLB）
  #   - "TCP_UDP": TCP と UDP の両方（NLB）
  #   - "TLS": TLS プロトコル（NLB）
  #   - "UDP": UDP プロトコル（NLB）
  #   - "GENEVE": GENEVE プロトコル（GWLB、ポートは必ず 6081）
  # 注意: target_type が "lambda" の場合は不要です。
  protocol = "HTTP"

  # protocol_version (Optional, Forces new resource)
  # 設定内容: HTTP/HTTPS プロトコル使用時のプロトコルバージョンを指定します。
  # 設定可能な値:
  #   - "HTTP1" (デフォルト): HTTP/1.1 を使用
  #   - "HTTP2": HTTP/2 を使用
  #   - "GRPC": gRPC を使用
  # 注意: protocol が "HTTP" または "HTTPS" の場合のみ有効です。
  protocol_version = "HTTP1"

  # port (Optional, Forces new resource)
  # 設定内容: ターゲットがトラフィックを受信するポート番号を指定します。
  # 設定可能な値: 1〜65535 の整数
  # 注意: target_type が "lambda" の場合は不要です。
  port = 80

  # vpc_id (Optional, Forces new resource)
  # 設定内容: ターゲットグループを作成する VPC の ID を指定します。
  # 設定可能な値: 有効な VPC ID
  # 省略時: target_type が "lambda" の場合は不要です。
  vpc_id = "vpc-12345678"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # トラフィック処理設定
  #-------------------------------------------------------------

  # deregistration_delay (Optional)
  # 設定内容: ターゲットの登録解除前に Elastic Load Balancing が待機する秒数を指定します。
  # 設定可能な値: 0〜3600 の文字列（例: "300"）
  # 省略時: "300"（5分）
  deregistration_delay = "300"

  # slow_start (Optional)
  # 設定内容: スロースタート期間（秒）を指定します。この期間中はターゲットへのリクエスト数を
  #   徐々に増やし、急激なトラフィック増加を防ぎます。
  # 設定可能な値: 0（無効）または 30〜900 の整数（秒）
  # 省略時: 0（無効）
  # 注意: ALB の HTTP/HTTPS プロトコル使用時のみ有効です。
  slow_start = 0

  # ip_address_type (Optional, Forces new resource)
  # 設定内容: ターゲットグループの IP アドレスタイプを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4 アドレス
  #   - "ipv6": IPv6 アドレス（target_type が "ip" の場合のみ有効）
  ip_address_type = "ipv4"

  # target_control_port (Optional)
  # 設定内容: ターゲット制御ポートを指定します。GWLB の GENEVE プロトコル使用時に
  #   ターゲットのコントロールプレーン通信に使用するポートです。
  # 設定可能な値: 1〜65535 の整数
  target_control_port = null

  #-------------------------------------------------------------
  # 負荷分散アルゴリズム設定（ALB 専用）
  #-------------------------------------------------------------

  # load_balancing_algorithm_type (Optional)
  # 設定内容: ロードバランサーがターゲットを選択する際に使用するアルゴリズムを指定します。
  # 設定可能な値:
  #   - "round_robin" (デフォルト): ラウンドロビン方式
  #   - "least_outstanding_requests": 処理中リクエスト数が最も少ないターゲットを選択
  #   - "weighted_random": 重み付きランダム方式
  # 注意: ALB の HTTP/HTTPS プロトコル使用時のみ有効です。
  load_balancing_algorithm_type = "round_robin"

  # load_balancing_anomaly_mitigation (Optional)
  # 設定内容: 異常軽減を有効にするかを指定します。
  #   異常があるターゲットへのリクエストを減らし、正常なターゲットを優先します。
  # 設定可能な値:
  #   - "on": 異常軽減を有効化
  #   - "off" (デフォルト): 異常軽減を無効化
  # 注意: load_balancing_algorithm_type が "weighted_random" の場合のみ有効です。
  load_balancing_anomaly_mitigation = "off"

  # load_balancing_cross_zone_enabled (Optional)
  # 設定内容: ターゲットグループレベルでのクロスゾーン負荷分散を設定します。
  # 設定可能な値:
  #   - "true": クロスゾーン負荷分散を有効化
  #   - "false": クロスゾーン負荷分散を無効化
  #   - "use_load_balancer_configuration" (デフォルト): ロードバランサーの設定に従う
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"

  #-------------------------------------------------------------
  # NLB 専用設定
  #-------------------------------------------------------------

  # connection_termination (Optional)
  # 設定内容: 登録解除タイムアウト経過後に接続を終了するかを指定します。
  # 設定可能な値:
  #   - true: タイムアウト後に接続を強制終了
  #   - false (デフォルト): 接続を強制終了しない
  # 注意: NLB の TCP および TLS プロトコル使用時のみ有効です。
  connection_termination = false

  # proxy_protocol_v2 (Optional)
  # 設定内容: Proxy Protocol v2 のサポートを有効にするかを指定します。
  #   有効にすると、ターゲットへの接続情報（クライアント IP、ポート等）をヘッダーに含めます。
  # 設定可能な値:
  #   - true: Proxy Protocol v2 を有効化
  #   - false (デフォルト): Proxy Protocol v2 を無効化
  # 注意: NLB のみ有効です。
  proxy_protocol_v2 = false

  # preserve_client_ip (Optional)
  # 設定内容: クライアント IP アドレスの保持を有効にするかを指定します。
  # 設定可能な値:
  #   - "true": クライアント IP を保持
  #   - "false": クライアント IP を保持しない
  # 省略時: target_type が "instance" または "ip" の場合、プロトコルによりデフォルト値が異なります。
  # 注意: NLB のみ有効です。target_type が "alb" の場合は使用不可です。
  preserve_client_ip = null

  #-------------------------------------------------------------
  # Lambda 専用設定
  #-------------------------------------------------------------

  # lambda_multi_value_headers_enabled (Optional)
  # 設定内容: Lambda 関数との間でリクエストおよびレスポンスのヘッダーを複数値として
  #   交換するかを指定します。
  # 設定可能な値:
  #   - true: 複数値ヘッダーを有効化
  #   - false (デフォルト): 複数値ヘッダーを無効化
  # 注意: target_type が "lambda" の場合のみ有効です。
  lambda_multi_value_headers_enabled = false

  #-------------------------------------------------------------
  # ヘルスチェック設定
  #-------------------------------------------------------------

  # health_check (Optional)
  # 設定内容: ターゲットグループのヘルスチェック設定ブロックです。
  # 関連機能: Elastic Load Balancing ヘルスチェック
  #   ターゲットの正常性を定期的に確認し、正常なターゲットのみにトラフィックを送信します。
  health_check {
    # enabled (Optional)
    # 設定内容: ヘルスチェックを有効にするかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): ヘルスチェックを有効化
    #   - false: ヘルスチェックを無効化
    # 注意: target_type が "lambda" の場合のみ無効化可能です。
    enabled = true

    # protocol (Optional)
    # 設定内容: ヘルスチェックに使用するプロトコルを指定します。
    # 設定可能な値: "HTTP", "HTTPS", "TCP"
    # 省略時: ターゲットグループの protocol が使用されます（GENEVE の場合は "HTTP"）。
    protocol = "HTTP"

    # port (Optional)
    # 設定内容: ヘルスチェックに使用するポートを指定します。
    # 設定可能な値:
    #   - "traffic-port": ターゲットグループのポートを使用（デフォルト）
    #   - 数値文字列（例: "8080"）: 指定ポートを使用
    port = "traffic-port"

    # path (Optional)
    # 設定内容: ヘルスチェックリクエストの送信先パスを指定します。
    # 設定可能な値: スラッシュで始まるパス文字列（最大1024文字）
    # 省略時: "/" が使用されます。
    # 注意: protocol が "HTTP" または "HTTPS" の場合のみ有効です。
    path = "/"

    # matcher (Optional)
    # 設定内容: ヘルスチェック成功と判断するレスポンスコードを指定します。
    # 設定可能な値:
    #   - HTTP/HTTPS: "200"、"200-299"、"200,201" 等の HTTP ステータスコード
    #   - GRPC: "0"、"0-5"、"0,12" 等の gRPC ステータスコード
    # 省略時: "200"（HTTP/HTTPS）または "12"（gRPC）が使用されます。
    matcher = "200"

    # interval (Optional)
    # 設定内容: ヘルスチェックの間隔（秒）を指定します。
    # 設定可能な値: 5〜300 の整数（秒）
    # 省略時: 30
    interval = 30

    # timeout (Optional)
    # 設定内容: ヘルスチェックのタイムアウト時間（秒）を指定します。
    # 設定可能な値: 2〜120 の整数（秒）
    # 省略時: protocol に応じてデフォルト値が設定されます（HTTP/HTTPS は5秒）。
    timeout = 5

    # healthy_threshold (Optional)
    # 設定内容: ターゲットが正常と判断されるまでに必要な連続成功ヘルスチェック数を指定します。
    # 設定可能な値: 2〜10 の整数
    # 省略時: 5
    healthy_threshold = 3

    # unhealthy_threshold (Optional)
    # 設定内容: ターゲットが異常と判断されるまでに必要な連続失敗ヘルスチェック数を指定します。
    # 設定可能な値: 2〜10 の整数
    # 省略時: 2
    unhealthy_threshold = 3
  }

  #-------------------------------------------------------------
  # スティッキーセッション設定
  #-------------------------------------------------------------

  # stickiness (Optional)
  # 設定内容: スティッキーセッション（セッション保持）の設定ブロックです。
  # 関連機能: Elastic Load Balancing スティッキーセッション
  #   同一クライアントからのリクエストを同一ターゲットにルーティングします。
  stickiness {
    # type (Required)
    # 設定内容: スティッキーセッションのタイプを指定します。
    # 設定可能な値:
    #   - "lb_cookie": ALB が生成する Cookie を使用（ALB の HTTP/HTTPS のみ）
    #   - "app_cookie": アプリケーションが生成する Cookie を使用（ALB の HTTP/HTTPS のみ）
    #   - "source_ip": クライアントの送信元 IP を使用（NLB の TCP/UDP のみ）
    #   - "source_ip_dest_ip": 送信元 IP と宛先 IP を使用（GWLB のみ）
    #   - "source_ip_dest_ip_proto": 送信元 IP、宛先 IP、プロトコルを使用（GWLB のみ）
    type = "lb_cookie"

    # enabled (Optional)
    # 設定内容: スティッキーセッションを有効にするかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): スティッキーセッションを有効化
    #   - false: スティッキーセッションを無効化
    enabled = true

    # cookie_duration (Optional)
    # 設定内容: Cookie の有効期間（秒）を指定します。
    # 設定可能な値: 1〜604800 の整数（秒）
    # 省略時: 86400（1日）
    # 注意: type が "lb_cookie" の場合のみ有効です。
    cookie_duration = 86400

    # cookie_name (Optional)
    # 設定内容: スティッキーセッションに使用するアプリケーション Cookie の名前を指定します。
    # 設定可能な値: Cookie 名の文字列
    # 注意: type が "app_cookie" の場合のみ有効です。
    cookie_name = null
  }

  #-------------------------------------------------------------
  # フェイルオーバー設定（NLB 専用）
  #-------------------------------------------------------------

  # target_failover (Optional)
  # 設定内容: ターゲットのフェイルオーバー動作を設定するブロックです。
  #   NLB のターゲットが登録解除または異常になった場合の既存接続の扱いを制御します。
  # 注意: NLB の TCP および TLS プロトコルで connection_termination が false の場合のみ有効です。
  target_failover {
    # on_deregistration (Required)
    # 設定内容: ターゲット登録解除時の既存フロー（接続）の扱いを指定します。
    # 設定可能な値:
    #   - "no_rebalance": 既存フローをリバランスしない
    #   - "rebalance": 既存フローを残りのターゲットにリバランス
    on_deregistration = "no_rebalance"

    # on_unhealthy (Required)
    # 設定内容: ターゲットが異常になった場合の既存フロー（接続）の扱いを指定します。
    # 設定可能な値:
    #   - "no_rebalance": 既存フローをリバランスしない
    #   - "rebalance": 既存フローを残りのターゲットにリバランス
    on_unhealthy = "no_rebalance"
  }

  #-------------------------------------------------------------
  # ターゲットグループヘルス設定
  #-------------------------------------------------------------

  # target_group_health (Optional)
  # 設定内容: ターゲットグループ全体のヘルス状態に基づくルーティング動作を設定するブロックです。
  # 関連機能: ターゲットグループのヘルス要件
  #   正常なターゲットの割合が閾値を下回った場合の DNS フェイルオーバーや
  #   アンヘルシー状態のルーティングを制御します。
  target_group_health {
    # dns_failover (Optional)
    # 設定内容: DNS フェイルオーバーの設定ブロックです。
    #   正常なターゲットが閾値以下になった場合に DNS レベルでフェイルオーバーします。
    dns_failover {
      # minimum_healthy_targets_count (Optional)
      # 設定内容: DNS フェイルオーバーを発動する最小正常ターゲット数を指定します。
      # 設定可能な値: "off"（無効）または正の整数文字列（例: "1"）
      # 省略時: "off"
      minimum_healthy_targets_count = "off"

      # minimum_healthy_targets_percentage (Optional)
      # 設定内容: DNS フェイルオーバーを発動する最小正常ターゲット割合を指定します。
      # 設定可能な値: "off"（無効）または 0〜100 の数値文字列（例: "50"）
      # 省略時: "off"
      minimum_healthy_targets_percentage = "off"
    }

    # unhealthy_state_routing (Optional)
    # 設定内容: アンヘルシー状態のルーティング設定ブロックです。
    #   正常なターゲットが閾値以下になった場合でもルーティングを継続するかを制御します。
    unhealthy_state_routing {
      # minimum_healthy_targets_count (Optional)
      # 設定内容: アンヘルシー状態ルーティングを維持する最小正常ターゲット数を指定します。
      # 設定可能な値: 1 以上の整数
      # 省略時: 1
      minimum_healthy_targets_count = 1

      # minimum_healthy_targets_percentage (Optional)
      # 設定内容: アンヘルシー状態ルーティングを維持する最小正常ターゲット割合を指定します。
      # 設定可能な値: "off"（無効）または 0〜100 の数値文字列（例: "50"）
      # 省略時: "off"
      minimum_healthy_targets_percentage = "off"
    }
  }

  #-------------------------------------------------------------
  # ターゲットヘルス状態設定（NLB 専用）
  #-------------------------------------------------------------

  # target_health_state (Optional)
  # 設定内容: NLB における異常ターゲットの接続処理を制御するブロックです。
  # 注意: NLB の TCP および TLS プロトコル使用時のみ有効です。
  target_health_state {
    # enable_unhealthy_connection_termination (Required)
    # 設定内容: 異常なターゲットへの既存 TCP 接続を終了するかを指定します。
    # 設定可能な値:
    #   - true: 異常ターゲットへの接続を終了
    #   - false: 異常ターゲットへの接続を終了しない
    enable_unhealthy_connection_termination = true

    # unhealthy_draining_interval (Optional)
    # 設定内容: 異常ターゲットへの接続を終了する前の待機時間（秒）を指定します。
    # 設定可能な値: 0〜360000 の整数（秒）
    # 省略時: 0
    # 注意: enable_unhealthy_connection_termination が false の場合のみ有効です。
    unhealthy_draining_interval = 0
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
    Name        = "example-tg"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ターゲットグループの ARN
# - arn_suffix: CloudWatch Metrics で使用する ARN サフィックス
# - load_balancer_arns: ターゲットグループにアタッチされているロードバランサー ARN のセット
# - id: ターゲットグループの ARN（arn と同一）
# - tags_all: プロバイダーの default_tags から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
