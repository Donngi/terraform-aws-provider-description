# =========================================================================
# AWS Prometheus Rule Group Namespace
# =========================================================================
# Resource: aws_prometheus_rule_group_namespace
# Provider Version: 6.28.0
#
# Amazon Managed Service for Prometheus (AMP) Rule Group Namespaceを管理します。
# ルールグループネームスペースは、PrometheusのRecording RulesとAlerting Rulesを
# 定義するためのYAML設定をAMPワークスペースに適用します。
#
# 主な用途:
# - Recording Rules: 頻繁に使用される式や計算負荷の高い式を事前計算し、新しい
#   時系列として保存することでクエリを高速化
# - Alerting Rules: PromQL式としきい値に基づいてアラート条件を定義し、
#   条件が満たされたときに通知を発火
#
# 参考資料:
# - AWS公式ドキュメント: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-Ruler.html
# - Recording Rules: https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/
# - Alerting Rules: https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/
# =========================================================================

# -------------------------------------------------------------------------
# 基本例: Recording RuleとAlerting Ruleを含むルールグループ
# -------------------------------------------------------------------------
resource "aws_prometheus_rule_group_namespace" "basic" {
  # -------------------------------------------------------------------------
  # 必須パラメータ
  # -------------------------------------------------------------------------

  # name - ルールグループネームスペースの名前
  # Type: string (Required)
  #
  # このルールグループネームスペースを識別する一意の名前です。
  # ワークスペース内で一意である必要があります。
  name = "basic-rules"

  # workspace_id - Amazon Managed Service for PrometheusワークスペースのID
  # Type: string (Required)
  #
  # このルールグループネームスペースをリンクするAMPワークスペースのIDを指定します。
  # aws_prometheus_workspace リソースの id 属性を参照します。
  workspace_id = aws_prometheus_workspace.main.id

  # data - ルールグループの定義データ (YAML形式)
  # Type: string (Required)
  #
  # 適用するルールグループネームスペースのデータをYAML形式で指定します。
  # Prometheus互換のYAML形式で、Recording RulesとAlerting Rulesを定義します。
  #
  # YAML構造:
  # - groups: ルールグループのリスト
  #   - name: ルールグループ名
  #   - interval: 評価間隔 (デフォルト: 60s)
  #   - rules: ルールのリスト
  #     - record: Recording Ruleの場合、新しいメトリック名
  #     - alert: Alerting Ruleの場合、アラート名
  #     - expr: PromQL式
  #     - for: アラートが発火するまでの継続時間
  #     - labels: メトリックやアラートに追加するラベル
  #     - annotations: アラートの説明情報
  #
  # 詳細: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-ruler-rulesfile.html
  data = <<-EOT
    groups:
      - name: example_recording_rules
        interval: 60s
        rules:
          - record: instance:cpu_usage:rate5m
            expr: rate(node_cpu_seconds_total[5m])
            labels:
              team: platform

          - record: instance:memory_usage:percent
            expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
            labels:
              team: platform

      - name: example_alerting_rules
        interval: 60s
        rules:
          - alert: HighCPUUsage
            expr: instance:cpu_usage:rate5m > 0.8
            for: 5m
            labels:
              severity: warning
              team: platform
            annotations:
              summary: "High CPU usage detected on {{ $labels.instance }}"
              description: "CPU usage is above 80% for more than 5 minutes (current value: {{ $value }})"

          - alert: HighMemoryUsage
            expr: instance:memory_usage:percent > 85
            for: 10m
            labels:
              severity: critical
              team: platform
            annotations:
              summary: "High memory usage detected on {{ $labels.instance }}"
              description: "Memory usage is above 85% for more than 10 minutes (current value: {{ $value }}%)"
  EOT

  # -------------------------------------------------------------------------
  # オプションパラメータ
  # -------------------------------------------------------------------------

  # tags - リソースに割り当てるタグのマップ
  # Type: map(string) (Optional)
  #
  # このルールグループネームスペースに割り当てるタグを指定します。
  # プロバイダーレベルの default_tags が設定されている場合、
  # マッチするキーを持つタグは上書きされます。
  tags = {
    Name        = "basic-prometheus-rules"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# -------------------------------------------------------------------------
# 例2: CPU監視用のRecording RulesとAlerting Rules
# -------------------------------------------------------------------------
resource "aws_prometheus_rule_group_namespace" "cpu_monitoring" {
  name         = "cpu-monitoring-rules"
  workspace_id = aws_prometheus_workspace.main.id

  # CPU使用率の監視に特化したルールセット
  # - Recording Rule: 5分間の平均CPU使用率を事前計算
  # - Alerting Rule: CPU使用率が80%を超えた場合にアラート
  data = <<-EOT
    groups:
      - name: cpu_metrics
        interval: 60s
        rules:
          - record: avg_cpu_usage
            expr: avg(rate(node_cpu_seconds_total[5m])) by (instance)
            labels:
              metric_type: aggregated

          - alert: HighAverageCPU
            expr: avg_cpu_usage > 0.8
            for: 10m
            keep_firing_for: 20m
            labels:
              severity: critical
              component: compute
            annotations:
              summary: "Average CPU usage across cluster is too high"
              description: "Cluster average CPU usage has been above 80% for 10 minutes"
  EOT

  tags = {
    Name       = "cpu-monitoring-rules"
    RuleType   = "cpu-monitoring"
    ManagedBy  = "terraform"
  }
}

# -------------------------------------------------------------------------
# 例3: コンテナ監視用の高度なルール
# -------------------------------------------------------------------------
resource "aws_prometheus_rule_group_namespace" "container_monitoring" {
  name         = "container-monitoring-rules"
  workspace_id = aws_prometheus_workspace.main.id

  # Kubernetes/ECSコンテナ環境の監視ルール
  # - コンテナCPU使用率の記録
  # - コンテナメモリ使用率の記録
  # - Pod再起動の検出
  # - コンテナOOMKillの検出
  data = <<-EOT
    groups:
      - name: container_resources
        interval: 30s
        rules:
          - record: container:cpu_usage:rate5m
            expr: rate(container_cpu_usage_seconds_total[5m])
            labels:
              resource: cpu

          - record: container:memory_usage:bytes
            expr: container_memory_usage_bytes
            labels:
              resource: memory

          - record: container:memory_usage:percent
            expr: |
              (container_memory_usage_bytes / container_spec_memory_limit_bytes) * 100
            labels:
              resource: memory

      - name: container_alerts
        interval: 30s
        rules:
          - alert: ContainerHighCPU
            expr: container:cpu_usage:rate5m > 0.9
            for: 5m
            labels:
              severity: warning
              resource: cpu
            annotations:
              summary: "Container {{ $labels.container }} high CPU usage"
              description: "Container {{ $labels.container }} in pod {{ $labels.pod }} has CPU usage above 90%"

          - alert: ContainerHighMemory
            expr: container:memory_usage:percent > 90
            for: 5m
            labels:
              severity: warning
              resource: memory
            annotations:
              summary: "Container {{ $labels.container }} high memory usage"
              description: "Container {{ $labels.container }} in pod {{ $labels.pod }} has memory usage above 90%"

          - alert: PodRestartingFrequently
            expr: rate(kube_pod_container_status_restarts_total[15m]) > 0.1
            for: 5m
            labels:
              severity: warning
              component: pod
            annotations:
              summary: "Pod {{ $labels.pod }} restarting frequently"
              description: "Pod {{ $labels.pod }} in namespace {{ $labels.namespace }} has restarted more than 1.5 times in the last 15 minutes"

          - alert: ContainerOOMKilled
            expr: |
              sum by (pod, container) (
                increase(kube_pod_container_status_terminated_reason{reason="OOMKilled"}[5m])
              ) > 0
            labels:
              severity: critical
              resource: memory
            annotations:
              summary: "Container {{ $labels.container }} was OOM killed"
              description: "Container {{ $labels.container }} in pod {{ $labels.pod }} was killed due to out of memory"
  EOT

  tags = {
    Name        = "container-monitoring-rules"
    Environment = "production"
    RuleType    = "container-monitoring"
    Platform    = "kubernetes"
    ManagedBy   = "terraform"
  }
}

# -------------------------------------------------------------------------
# 例4: アプリケーション/APIレイテンシ監視
# -------------------------------------------------------------------------
resource "aws_prometheus_rule_group_namespace" "api_monitoring" {
  name         = "api-monitoring-rules"
  workspace_id = aws_prometheus_workspace.main.id

  # APIレイテンシとエラーレートの監視
  # - Recording Rule: p95, p99レイテンシの事前計算
  # - Recording Rule: エラーレート計算
  # - Alerting Rule: 高レイテンシ検出
  # - Alerting Rule: 高エラーレート検出
  data = <<-EOT
    groups:
      - name: api_latency_recording
        interval: 30s
        rules:
          - record: http:request_duration_seconds:p95
            expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
            labels:
              quantile: "95"

          - record: http:request_duration_seconds:p99
            expr: histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))
            labels:
              quantile: "99"

          - record: http:request_error_rate:5m
            expr: |
              sum(rate(http_requests_total{status=~"5.."}[5m])) by (job, endpoint)
              /
              sum(rate(http_requests_total[5m])) by (job, endpoint)
            labels:
              metric_type: error_rate

      - name: api_alerts
        interval: 30s
        rules:
          - alert: HighAPILatency
            expr: http:request_duration_seconds:p95 > 1
            for: 5m
            labels:
              severity: warning
              component: api
            annotations:
              summary: "High API latency detected for {{ $labels.endpoint }}"
              description: "P95 latency is above 1 second for endpoint {{ $labels.endpoint }}: {{ $value }}s"

          - alert: CriticalAPILatency
            expr: http:request_duration_seconds:p99 > 5
            for: 2m
            labels:
              severity: critical
              component: api
            annotations:
              summary: "Critical API latency for {{ $labels.endpoint }}"
              description: "P99 latency is above 5 seconds for endpoint {{ $labels.endpoint }}: {{ $value }}s"

          - alert: HighErrorRate
            expr: http:request_error_rate:5m > 0.05
            for: 5m
            labels:
              severity: critical
              component: api
            annotations:
              summary: "High error rate detected for {{ $labels.endpoint }}"
              description: "Error rate is above 5% for endpoint {{ $labels.endpoint }}: {{ $value | humanizePercentage }}"
  EOT

  tags = {
    Name       = "api-monitoring-rules"
    RuleType   = "api-latency-monitoring"
    Component  = "api-gateway"
    ManagedBy  = "terraform"
  }
}

# -------------------------------------------------------------------------
# 例5: データベース監視
# -------------------------------------------------------------------------
resource "aws_prometheus_rule_group_namespace" "database_monitoring" {
  name         = "database-monitoring-rules"
  workspace_id = aws_prometheus_workspace.main.id

  # データベースパフォーマンスの監視
  # - 接続数の監視
  # - クエリレイテンシの監視
  # - レプリケーション遅延の監視
  data = <<-EOT
    groups:
      - name: database_metrics
        interval: 60s
        rules:
          - record: db:connections:active
            expr: sum(mysql_global_status_threads_connected) by (instance)
            labels:
              resource: connections

          - record: db:connections:usage_percent
            expr: |
              (db:connections:active / mysql_global_variables_max_connections) * 100
            labels:
              resource: connections

          - record: db:query_duration:p95
            expr: histogram_quantile(0.95, rate(mysql_query_duration_seconds_bucket[5m]))
            labels:
              quantile: "95"

          - record: db:replication_lag:seconds
            expr: mysql_slave_status_seconds_behind_master
            labels:
              resource: replication

      - name: database_alerts
        interval: 60s
        rules:
          - alert: HighDatabaseConnections
            expr: db:connections:usage_percent > 80
            for: 5m
            labels:
              severity: warning
              component: database
            annotations:
              summary: "High database connection usage on {{ $labels.instance }}"
              description: "Database connection usage is above 80%: {{ $value }}%"

          - alert: CriticalDatabaseConnections
            expr: db:connections:usage_percent > 95
            for: 2m
            labels:
              severity: critical
              component: database
            annotations:
              summary: "Critical database connection usage on {{ $labels.instance }}"
              description: "Database connection usage is above 95%: {{ $value }}%. Risk of connection exhaustion."

          - alert: SlowQueries
            expr: db:query_duration:p95 > 2
            for: 10m
            labels:
              severity: warning
              component: database
            annotations:
              summary: "Slow queries detected on {{ $labels.instance }}"
              description: "P95 query duration is above 2 seconds: {{ $value }}s"

          - alert: ReplicationLag
            expr: db:replication_lag:seconds > 60
            for: 5m
            labels:
              severity: warning
              component: database
            annotations:
              summary: "Replication lag detected on {{ $labels.instance }}"
              description: "Replication lag is above 60 seconds: {{ $value }}s"

          - alert: ReplicationLagCritical
            expr: db:replication_lag:seconds > 300
            for: 2m
            labels:
              severity: critical
              component: database
            annotations:
              summary: "Critical replication lag on {{ $labels.instance }}"
              description: "Replication lag is above 5 minutes: {{ $value }}s"
  EOT

  tags = {
    Name       = "database-monitoring-rules"
    RuleType   = "database-monitoring"
    Component  = "mysql"
    ManagedBy  = "terraform"
  }
}

# -------------------------------------------------------------------------
# 例6: region パラメータを指定した例
# -------------------------------------------------------------------------
resource "aws_prometheus_rule_group_namespace" "regional" {
  name         = "regional-rules"
  workspace_id = aws_prometheus_workspace.main.id

  data = <<-EOT
    groups:
      - name: basic_rules
        rules:
          - record: up:count
            expr: count(up)
  EOT

  # region - このリソースを管理するリージョン
  # Type: string (Optional)
  #
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-west-2"

  tags = {
    Name   = "regional-rules"
    Region = "us-west-2"
  }
}

# =========================================================================
# 出力値
# =========================================================================

# ARN - ルールグループネームスペースのARN
output "rule_group_namespace_basic_arn" {
  description = "The ARN of the basic rule group namespace"
  value       = aws_prometheus_rule_group_namespace.basic.arn
}

# tags_all - リソースに割り当てられたすべてのタグ
# プロバイダーの default_tags から継承されたタグも含まれます
output "rule_group_namespace_basic_tags_all" {
  description = "Map of all tags assigned to the rule group namespace, including provider default_tags"
  value       = aws_prometheus_rule_group_namespace.basic.tags_all
}

# =========================================================================
# 補足情報
# =========================================================================

# ■ Recording Rulesの使い方
# Recording Rulesは、頻繁に実行される複雑なクエリを事前計算して、
# 新しいメトリックとして保存します。これにより:
# - クエリのパフォーマンスが向上
# - ダッシュボードの読み込み速度が向上
# - 長期間のデータ集計が効率化
#
# 命名規則のベストプラクティス:
# level:metric:operations
# 例: instance:cpu_usage:rate5m
#     cluster:http_requests:rate1m

# ■ Alerting Rulesの使い方
# Alerting Rulesは、指定された条件が満たされたときにアラートを発火します。
#
# 主要パラメータ:
# - expr: アラート条件を定義するPromQL式
# - for: アラートが発火するまでの継続時間（オプション）
# - keep_firing_for: アラートが発火し続ける時間（オプション）
# - labels: アラートに追加するラベル（重要度、チームなど）
# - annotations: アラートの説明（summary, descriptionなど）
#
# 重要度レベルの例:
# - info: 情報レベル
# - warning: 注意が必要
# - critical: 即座の対応が必要

# ■ YAMLフォーマットの注意点
# 1. インデントは半角スペースを使用（タブ不可）
# 2. 複数行の式は | を使用してブロックスタイルで記述
# 3. グループ内のルールは順序通りに評価される
# 4. 同じグループ内の前のルールの結果を後のルールで使用可能

# ■ IAM権限
# このリソースを使用するには、以下のIAM権限が必要です:
# - aps:CreateRuleGroupsNamespace
# - aps:DescribeRuleGroupsNamespace
# - aps:PutRuleGroupsNamespace
# - aps:DeleteRuleGroupsNamespace
# - aps:ListRuleGroupsNamespaces
# - aps:ListTagsForResource
# - aps:TagResource
# - aps:UntagResource

# ■ ルール評価のモニタリング
# CloudWatchメトリクスを使用してルールの評価をモニタリング:
# - RuleEvaluationLatency: ルール評価のレイテンシ
# - RuleEvaluationFailures: ルール評価の失敗数
# - RulesEvaluated: 評価されたルールの数
#
# これらのメトリクスをGrafanaダッシュボードで可視化できます。

# ■ AlertManagerとの統合
# Alerting Rulesで発火したアラートは、AlertManagerに送信されます。
# AlertManagerを設定して、以下への通知ルーティングを実装:
# - Amazon SNS
# - PagerDuty
# - Slack
# - Email
# - Webhook
#
# AlertManagerの設定例:
# https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-alertmanager.html

# ■ トラブルシューティング
# ルール評価の問題をトラブルシューティングする場合:
# 1. CloudWatchメトリクスで RuleEvaluationFailures を確認
# 2. PromQL式の構文を検証
# 3. メトリクスが実際に収集されているか確認
# 4. ルールグループの評価間隔が適切か確認
# 5. ワークスペースの権限設定を確認

# ■ コスト最適化
# - 不要なRecording Rulesは削除
# - ルール評価の間隔を適切に設定（デフォルト60秒）
# - 高cardinality（多次元）メトリクスの集約を検討
# - 保持期間の設定を最適化

# ■ 関連リソース
# - aws_prometheus_workspace: AMPワークスペース
# - aws_prometheus_alert_manager_definition: AlertManagerの設定
# - aws_prometheus_scraper: メトリクスのスクレイピング設定

# ■ 参考リンク
# - AMP User Guide: https://docs.aws.amazon.com/prometheus/latest/userguide/
# - Prometheus Recording Rules: https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/
# - Prometheus Alerting Rules: https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/
# - PromQL: https://prometheus.io/docs/prometheus/latest/querying/basics/
# - Best Practices Blog: https://aws.amazon.com/blogs/mt/alerting-best-practices-with-amazon-managed-service-for-prometheus/
