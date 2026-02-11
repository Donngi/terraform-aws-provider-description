# =============================================================================
# AWS Route 53 Health Check
# =============================================================================
# Terraform AWS Provider Version: 6.28.0
# Resource: aws_route53_health_check
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/route53_health_check
#
# Route 53 ヘルスチェックは、エンドポイントの可用性と正常性を監視します。
# DNS フェイルオーバー、CloudWatch アラーム監視、複数のヘルスチェックの集約など、
# さまざまなヘルスチェックタイプをサポートしています。
# =============================================================================

# -----------------------------------------------------------------------------
# Example 1: 基本的な HTTP ヘルスチェック（接続とステータスコードチェック）
# -----------------------------------------------------------------------------
# このヘルスチェックは、指定されたエンドポイントに HTTP リクエストを送信し、
# HTTP ステータスコードが 2xx または 3xx であることを確認します。
# -----------------------------------------------------------------------------

resource "aws_route53_health_check" "http_basic" {
  # --------------------------------------------------------------------------
  # 必須パラメータ
  # --------------------------------------------------------------------------

  # type: ヘルスチェックのプロトコルタイプ
  # 有効な値: HTTP, HTTPS, HTTP_STR_MATCH, HTTPS_STR_MATCH, TCP,
  #          CALCULATED, CLOUDWATCH_METRIC, RECOVERY_CONTROL
  type = "HTTP"

  # request_interval: ヘルスチェック間隔（秒）
  # 有効な値: 30（標準）または 10（高速）
  # 高速チェックは追加料金が発生します
  request_interval = "30"

  # --------------------------------------------------------------------------
  # エンドポイント指定パラメータ
  # --------------------------------------------------------------------------

  # fqdn: ヘルスチェック対象の完全修飾ドメイン名（FQDN）
  # ip_address が設定されている場合、fqdn は Host ヘッダーに渡されます
  fqdn = "example.com"

  # ip_address: ヘルスチェック対象の IP アドレス（オプション）
  # fqdn と併用すると、IP に直接接続しつつ Host ヘッダーに fqdn を設定
  # ip_address = "203.0.113.1"

  # port: ヘルスチェック対象のポート番号
  # HTTP のデフォルトは 80、HTTPS のデフォルトは 443
  port = 80

  # resource_path: ヘルスチェック時にリクエストするパス
  # 例: "/health", "/status", "/" など
  resource_path = "/"

  # --------------------------------------------------------------------------
  # ヘルスチェック動作設定
  # --------------------------------------------------------------------------

  # failure_threshold: 異常と判定するまでの連続失敗回数
  # 有効な値: 1〜10（デフォルトは 3）
  # 値が小さいほど迅速に障害を検出しますが、誤検知のリスクも増加します
  failure_threshold = "5"

  # measure_latency: レイテンシー測定を有効化
  # true に設定すると、Route 53 が複数のリージョンからエンドポイントへの
  # レイテンシーを測定し、CloudWatch メトリクスとして表示します
  measure_latency = false

  # invert_healthcheck: ヘルスチェック結果を反転
  # true に設定すると、正常なチェックを異常、異常なチェックを正常として扱います
  # DNS フェイルオーバーで「異常時に別のエンドポイントへルーティング」する際に使用
  invert_healthcheck = false

  # disabled: ヘルスチェックを無効化
  # true に設定すると、Route 53 はヘルスチェックを実行せず、常に正常とみなします
  # トラフィックのルーティングを停止したい場合は invert_healthcheck を使用してください
  disabled = false

  # enable_sni: SNI（Server Name Indication）を有効化
  # HTTPS ヘルスチェック時に fqdn を SNI ホスト名として送信します
  # type が "HTTPS" の場合はデフォルトで true、それ以外は false
  # enable_sni = true

  # --------------------------------------------------------------------------
  # ヘルスチェッカーのリージョン設定
  # --------------------------------------------------------------------------

  # regions: ヘルスチェックを実行する AWS リージョンのリスト
  # 指定しない場合は、すべての利用可能なリージョンから実行されます
  # 有効な値: us-east-1, us-west-1, us-west-2, eu-west-1,
  #          ap-southeast-1, ap-southeast-2, ap-northeast-1, sa-east-1
  # regions = ["us-east-1", "eu-west-1", "ap-northeast-1"]

  # --------------------------------------------------------------------------
  # メタデータ
  # --------------------------------------------------------------------------

  # reference_name: Caller Reference で使用する参照名
  # 複数のヘルスチェックを識別しやすくするためのラベル
  # reference_name = "example-http-check"

  # tags: ヘルスチェックに割り当てるタグ
  tags = {
    Name        = "example-http-health-check"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# -----------------------------------------------------------------------------
# Example 2: 文字列マッチング HTTPS ヘルスチェック
# -----------------------------------------------------------------------------
# このヘルスチェックは、HTTPS エンドポイントへ接続し、レスポンスボディの
# 最初の 5120 バイト内に指定された文字列が含まれているかを確認します。
# アプリケーションレベルの詳細なヘルスチェックに有効です。
# -----------------------------------------------------------------------------

resource "aws_route53_health_check" "https_string_match" {
  type             = "HTTPS_STR_MATCH"
  request_interval = "30"

  fqdn          = "api.example.com"
  port          = 443
  resource_path = "/health"

  # search_string: レスポンスボディ内で検索する文字列
  # HTTP_STR_MATCH または HTTPS_STR_MATCH タイプでのみ有効
  # レスポンスの最初の 5120 バイト内でこの文字列が見つかれば正常とみなされます
  search_string = "OK"

  failure_threshold = "3"
  enable_sni        = true

  tags = {
    Name = "api-https-string-match"
    Type = "StringMatch"
  }
}

# -----------------------------------------------------------------------------
# Example 3: TCP ヘルスチェック
# -----------------------------------------------------------------------------
# TCP 接続の確立のみを確認するシンプルなヘルスチェック。
# HTTP/HTTPS 以外のプロトコル（データベース、SSH など）の監視に使用します。
# -----------------------------------------------------------------------------

resource "aws_route53_health_check" "tcp_connection" {
  type             = "TCP"
  request_interval = "30"

  ip_address = "10.0.1.100"
  port       = 3306 # MySQL

  failure_threshold = "3"

  tags = {
    Name     = "database-tcp-check"
    Protocol = "MySQL"
  }
}

# -----------------------------------------------------------------------------
# Example 4: 集約ヘルスチェック（CALCULATED タイプ）
# -----------------------------------------------------------------------------
# 複数の子ヘルスチェックの結果を集約し、指定された数以上の子が正常であれば
# 親ヘルスチェックも正常とみなします。複数のエンドポイントやサービスの
# 総合的な可用性を監視する際に有効です。
# -----------------------------------------------------------------------------

resource "aws_route53_health_check" "child_check_1" {
  type             = "HTTP"
  request_interval = "30"
  fqdn             = "endpoint1.example.com"
  port             = 80
  resource_path    = "/"

  tags = {
    Name = "child-check-1"
  }
}

resource "aws_route53_health_check" "child_check_2" {
  type             = "HTTP"
  request_interval = "30"
  fqdn             = "endpoint2.example.com"
  port             = 80
  resource_path    = "/"

  tags = {
    Name = "child-check-2"
  }
}

resource "aws_route53_health_check" "calculated_parent" {
  type = "CALCULATED"

  # child_healthchecks: 集約する子ヘルスチェックの ID リスト
  child_healthchecks = [
    aws_route53_health_check.child_check_1.id,
    aws_route53_health_check.child_check_2.id,
  ]

  # child_health_threshold: 親を正常とみなすために必要な正常な子の最小数
  # 有効な値: 0〜256（child_healthchecks の数以下が推奨）
  # この例では、2 つの子のうち 1 つ以上が正常であれば親も正常とみなされます
  child_health_threshold = 1

  tags = {
    Name = "calculated-aggregate-check"
    Type = "Aggregate"
  }
}

# -----------------------------------------------------------------------------
# Example 5: CloudWatch アラームヘルスチェック
# -----------------------------------------------------------------------------
# CloudWatch アラームの状態を監視するヘルスチェック。
# アラームが ALARM 状態の場合はヘルスチェックが異常となり、
# OK 状態の場合は正常となります。
# -----------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "example-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggered when CPU exceeds 80%"

  # この例では EC2 インスタンスの CPU 使用率を監視
  # dimensions = {
  #   InstanceId = "i-1234567890abcdef0"
  # }
}

resource "aws_route53_health_check" "cloudwatch_alarm" {
  type = "CLOUDWATCH_METRIC"

  # cloudwatch_alarm_name: 監視する CloudWatch アラームの名前
  cloudwatch_alarm_name = aws_cloudwatch_metric_alarm.cpu_high.alarm_name

  # cloudwatch_alarm_region: CloudWatch アラームが作成されたリージョン
  cloudwatch_alarm_region = "us-west-2"

  # insufficient_data_health_status: CloudWatch のデータが不十分な場合のステータス
  # 有効な値: Healthy, Unhealthy, LastKnownStatus
  # - Healthy: データ不足時に正常とみなす
  # - Unhealthy: データ不足時に異常とみなす
  # - LastKnownStatus: 最後に確認された状態を維持
  insufficient_data_health_status = "Healthy"

  tags = {
    Name = "cloudwatch-alarm-health-check"
    Type = "CloudWatchMetric"
  }
}

# -----------------------------------------------------------------------------
# Example 6: CloudWatch アラームヘルスチェック（トリガー付き）
# -----------------------------------------------------------------------------
# triggers パラメータを使用することで、アラームのパラメータ変更時に
# ヘルスチェックを自動的に更新できます。
# -----------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "latency_high" {
  alarm_name          = "example-latency-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 500 # 500ms
  alarm_description   = "Triggered when response time exceeds 500ms"
}

resource "aws_route53_health_check" "cloudwatch_with_triggers" {
  type                            = "CLOUDWATCH_METRIC"
  cloudwatch_alarm_name           = aws_cloudwatch_metric_alarm.latency_high.alarm_name
  cloudwatch_alarm_region         = "us-west-2"
  insufficient_data_health_status = "LastKnownStatus"

  # triggers: アラームの変更を検知してヘルスチェックを更新するトリガー
  # キーと値のマップで、値が変更されるとヘルスチェックが in-place 更新されます
  # アラームのパラメータ（しきい値、期間など）と同期させる際に有効
  triggers = {
    threshold           = aws_cloudwatch_metric_alarm.latency_high.threshold
    evaluation_periods  = aws_cloudwatch_metric_alarm.latency_high.evaluation_periods
    comparison_operator = aws_cloudwatch_metric_alarm.latency_high.comparison_operator
  }

  tags = {
    Name = "cloudwatch-with-triggers"
  }
}

# -----------------------------------------------------------------------------
# Example 7: Route 53 Application Recovery Controller ヘルスチェック
# -----------------------------------------------------------------------------
# Route 53 Application Recovery Controller のルーティングコントロールを監視。
# ARC のルーティングコントロールの状態に基づいてトラフィックをコントロールします。
# -----------------------------------------------------------------------------

resource "aws_route53_health_check" "recovery_control" {
  type = "RECOVERY_CONTROL"

  # routing_control_arn: Route 53 Application Recovery Controller の
  # ルーティングコントロールの ARN
  # RECOVERY_CONTROL タイプのヘルスチェックで必須
  routing_control_arn = "arn:aws:route53-recovery-control::123456789012:controlpanel/example/routingcontrol/example"

  tags = {
    Name = "recovery-control-health-check"
    Type = "RecoveryControl"
  }
}

# =============================================================================
# Outputs
# =============================================================================
# ヘルスチェックの重要な属性を出力します。
# これらの値は、DNS レコードやアラームの設定で参照できます。
# =============================================================================

output "http_health_check_id" {
  description = "HTTP ヘルスチェックの ID"
  value       = aws_route53_health_check.http_basic.id
}

output "http_health_check_arn" {
  description = "HTTP ヘルスチェックの ARN"
  value       = aws_route53_health_check.http_basic.arn
}

output "calculated_health_check_id" {
  description = "集約ヘルスチェックの ID"
  value       = aws_route53_health_check.calculated_parent.id
}

output "cloudwatch_health_check_id" {
  description = "CloudWatch アラームヘルスチェックの ID"
  value       = aws_route53_health_check.cloudwatch_alarm.id
}

# =============================================================================
# 補足情報
# =============================================================================
#
# 【ヘルスチェックタイプの選択ガイド】
#
# 1. HTTP / HTTPS
#    - Web サーバーやアプリケーションの基本的な可用性確認
#    - HTTP ステータスコード（2xx/3xx）で正常性を判定
#
# 2. HTTP_STR_MATCH / HTTPS_STR_MATCH
#    - アプリケーションレベルの詳細なヘルスチェック
#    - レスポンスボディ内の特定文字列の有無で判定
#    - より細かい正常性の確認が可能（例: "status:ok"）
#
# 3. TCP
#    - TCP 接続の確立のみを確認
#    - HTTP/HTTPS 以外のサービス（DB、SSH、カスタムプロトコル）の監視
#
# 4. CALCULATED
#    - 複数のヘルスチェック結果を集約
#    - 複数エンドポイントの総合的な可用性を評価
#    - DNS フェイルオーバーの複雑なロジック実装に有効
#
# 5. CLOUDWATCH_METRIC
#    - CloudWatch アラームの状態を監視
#    - カスタムメトリクスや複雑な条件でのヘルスチェック
#    - インフラストラクチャメトリクス（CPU、メモリなど）と連携
#
# 6. RECOVERY_CONTROL
#    - Route 53 Application Recovery Controller との統合
#    - マルチリージョンのディザスタリカバリシナリオで使用
#
# 【料金に関する注意】
#
# - 標準ヘルスチェック（30 秒間隔）: 月額 $0.50 / ヘルスチェック
# - 高速ヘルスチェック（10 秒間隔）: 月額 $1.00 / ヘルスチェック
# - 文字列マッチング: 追加料金 $2.00 / ヘルスチェック
# - レイテンシー測定: 追加料金 $1.00 / ヘルスチェック
# - HTTPS ヘルスチェック: HTTP と同額（追加料金なし）
#
# 【DNS フェイルオーバーとの連携】
#
# Route 53 レコードの health_check_id にヘルスチェック ID を指定することで、
# DNS フェイルオーバーを実装できます。
#
# resource "aws_route53_record" "primary" {
#   zone_id         = aws_route53_zone.main.zone_id
#   name            = "app.example.com"
#   type            = "A"
#   ttl             = "60"
#   records         = ["203.0.113.1"]
#   set_identifier  = "primary"
#   health_check_id = aws_route53_health_check.http_basic.id
#
#   failover_routing_policy {
#     type = "PRIMARY"
#   }
# }
#
# 【ベストプラクティス】
#
# 1. failure_threshold の適切な設定
#    - 低すぎる値: 誤検知のリスクが高まる
#    - 高すぎる値: 障害検出が遅れる
#    - 推奨: 3〜5 回
#
# 2. request_interval の選択
#    - 標準（30 秒）: ほとんどのケースで十分
#    - 高速（10 秒）: 迅速な障害検出が必要な重要サービスのみ
#
# 3. 文字列マッチングの活用
#    - アプリケーションの健全性をより正確に判定
#    - 専用のヘルスチェックエンドポイント（/health など）を実装
#
# 4. 集約ヘルスチェックの活用
#    - 複数のエンドポイントやサービスの総合的な監視
#    - 段階的なフェイルオーバーロジックの実装
#
# 5. CloudWatch との統合
#    - インフラストラクチャメトリクスと連携した高度な監視
#    - カスタムメトリクスを使用した独自のヘルスチェックロジック
#
# 6. タグ付けの徹底
#    - 環境、サービス、チームなどで分類
#    - コスト管理とリソース管理の効率化
#
# =============================================================================
