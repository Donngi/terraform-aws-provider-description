# ==============================================================================
# AWS CloudWatch Metric Alarm - Annotated Template
# ==============================================================================
# Generated: 2026-01-19
# Provider: hashicorp/aws v6.28.0
# Resource: aws_cloudwatch_metric_alarm
#
# NOTE: このテンプレートは生成時点(2026-01-19)の情報に基づいています。
#       最新の仕様や詳細については、必ず公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm
# ==============================================================================

resource "aws_cloudwatch_metric_alarm" "example" {
  # ==============================================================================
  # Required Arguments
  # ==============================================================================

  # アラーム名（AWSアカウント内で一意である必要があります）
  # - 最小長: 1文字
  # - 最大長: 255文字
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  alarm_name = "example-alarm"

  # 比較演算子
  # 指定された統計値（Statistic）と閾値（Threshold）を比較する際の算術演算を定義します。
  # 統計値が第1オペランドとして使用されます。
  #
  # 通常のアラームで使用可能な値:
  # - GreaterThanOrEqualToThreshold: 統計値 >= 閾値
  # - GreaterThanThreshold: 統計値 > 閾値
  # - LessThanThreshold: 統計値 < 閾値
  # - LessThanOrEqualToThreshold: 統計値 <= 閾値
  #
  # 異常検知モデルベースのアラームでのみ使用可能な値:
  # - LessThanLowerOrGreaterThanUpperThreshold: 統計値が下限未満または上限超過
  # - LessThanLowerThreshold: 統計値 < 下限
  # - GreaterThanUpperThreshold: 統計値 > 上限
  #
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # 評価期間数
  # データを指定された閾値と比較する期間の数を定義します。
  # - 最小値: 1
  # 例: evaluation_periods = 2 の場合、2つの連続した期間にわたってデータが評価されます。
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  evaluation_periods = 2

  # ==============================================================================
  # Optional Arguments - Basic Configuration
  # ==============================================================================

  # アラームの説明
  # - 最小長: 0文字
  # - 最大長: 1024文字
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  alarm_description = "This metric monitors example metric"

  # アクションの有効化
  # アラームの状態が変化したときにアクションを実行するかどうかを指定します。
  # - デフォルト: true
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  actions_enabled = true

  # リージョン
  # このリソースが管理されるリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  # Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#region
  # region = "us-east-1"

  # ==============================================================================
  # Optional Arguments - Metric Configuration (Single Metric)
  # ==============================================================================
  # NOTE: metric_query を指定する場合、以下のパラメータ（metric_name, namespace, period, statistic）は
  #       指定できません。単一メトリクスベースのアラームの場合のみこれらを使用します。

  # メトリクス名
  # アラームに関連付けられたメトリクスの名前を指定します。
  # - 最小長: 1文字
  # - 最大長: 255文字
  # 例: "CPUUtilization", "NetworkIn", "DiskReadBytes"
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/CW_Support_For_AWS.html
  metric_name = "CPUUtilization"

  # ネームスペース
  # メトリクスのネームスペースを指定します。
  # - 最小長: 1文字
  # - 最大長: 255文字
  # - パターン: [^:].*（コロンで始まらない）
  # 例: "AWS/EC2", "AWS/Lambda", "AWS/RDS"
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/aws-namespaces.html
  namespace = "AWS/EC2"

  # 期間（秒単位）
  # 指定された統計が適用される期間を秒単位で指定します。
  # - 最小値: 1
  # - 通常の解像度メトリクス: 10, 20, 30, または60の倍数
  # - 高解像度メトリクス: 1, 5, 10, 20, 30, または60の倍数
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  period = 300

  # 統計
  # メトリクスに適用する統計を指定します。
  # パーセンタイル統計の場合は、extended_statistic を使用してください。
  # 使用可能な値:
  # - SampleCount: サンプル数
  # - Average: 平均値
  # - Sum: 合計値
  # - Minimum: 最小値
  # - Maximum: 最大値
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Statistics-definitions.html
  statistic = "Average"

  # ==============================================================================
  # Optional Arguments - Threshold Configuration
  # ==============================================================================

  # 閾値
  # 指定された統計と比較する値を設定します。
  # - 静的閾値ベースのアラームには必須
  # - 異常検知モデルベースのアラームでは使用しない
  # Type: Double
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  threshold = 80.0

  # 異常検知バンドのメトリクスID
  # 異常検知モデルベースのアラームの場合、ANOMALY_DETECTION_BAND 関数のIDと一致させます。
  # - 最小長: 1文字
  # - 最大長: 255文字
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  # threshold_metric_id = "ad1"

  # ==============================================================================
  # Optional Arguments - Advanced Evaluation Settings
  # ==============================================================================

  # アラームをトリガーするデータポイント数
  # アラームをトリガーするために違反している必要があるデータポイントの数を指定します。
  # - 最小値: 1
  # - evaluation_periods 以下である必要があります
  # 例: datapoints_to_alarm = 2, evaluation_periods = 3 の場合、
  #     3つの評価期間のうち2つでデータが閾値を超えた場合にアラームがトリガーされます。
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  datapoints_to_alarm = 2

  # 欠損データの扱い方
  # 欠損データポイントをどのように扱うかを設定します。
  # 使用可能な値:
  # - missing (デフォルト): 欠損データとして扱う
  # - ignore: 欠損データを無視し、現在の状態を維持
  # - breaching: 欠損データを閾値違反として扱う
  # - notBreaching: 欠損データを閾値違反ではないものとして扱う
  # - 最小長: 1文字
  # - 最大長: 255文字
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html#alarms-and-missing-data
  treat_missing_data = "notBreaching"

  # パーセンタイル統計における低サンプル数の評価方法
  # パーセンタイルベースのアラームでのみ使用します。
  # 使用可能な値:
  # - ignore: 統計的に有意でない期間中はアラーム状態を変更しない
  # - evaluate: データポイント数に関わらず常に評価する（省略時のデフォルト動作）
  # - 最小長: 1文字
  # - 最大長: 255文字
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  # evaluate_low_sample_count_percentiles = "evaluate"

  # ==============================================================================
  # Optional Arguments - Dimensions
  # ==============================================================================

  # ディメンション
  # メトリクスに関連付けられたディメンションを指定します。
  # Type: Map of strings
  # 最大30項目まで指定可能
  # 例:
  # - EC2インスタンス: { InstanceId = "i-1234567890abcdef0" }
  # - Auto Scalingグループ: { AutoScalingGroupName = "my-asg" }
  # - ロードバランサー: { LoadBalancer = "app/my-lb/1234567890abcdef" }
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/CW_Support_For_AWS.html
  dimensions = {
    InstanceId = "i-1234567890abcdef0"
  }

  # ==============================================================================
  # Optional Arguments - Extended Statistics
  # ==============================================================================

  # 拡張統計（パーセンタイル）
  # メトリクスに関連付けられたパーセンタイル統計を指定します。
  # - 範囲: p0.0 ～ p100
  # - statistic パラメータの代わりに使用します（両方を同時に指定しない）
  # 例: "p99", "p95", "p50"
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  # extended_statistic = "p99"

  # ==============================================================================
  # Optional Arguments - Unit
  # ==============================================================================

  # 単位
  # メトリクスに関連付けられた単位を指定します。
  # 使用可能な値:
  # - 時間: Seconds, Microseconds, Milliseconds
  # - データ容量: Bytes, Kilobytes, Megabytes, Gigabytes, Terabytes
  # - ビット: Bits, Kilobits, Megabits, Gigabits, Terabits
  # - レート（データ容量/秒）: Bytes/Second, Kilobytes/Second, Megabytes/Second, Gigabytes/Second, Terabytes/Second
  # - レート（ビット/秒）: Bits/Second, Kilobits/Second, Megabits/Second, Gigabits/Second, Terabits/Second
  # - カウント: Percent, Count, Count/Second
  # - その他: None
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  # unit = "Percent"

  # ==============================================================================
  # Optional Arguments - Actions
  # ==============================================================================

  # ALARM状態への移行時のアクション
  # アラームがALARM状態に移行したときに実行するアクションのリストを指定します。
  # 各アクションはAmazon Resource Name (ARN) で指定します。
  # Type: Set of strings
  # - 最大5項目
  # - 各ARNの長さ: 1～1024文字
  # 例: SNSトピック、Auto Scalingポリシー、EC2アクション、Systems Managerアクション
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  alarm_actions = [
    # "arn:aws:sns:us-east-1:123456789012:my-topic",
    # "arn:aws:autoscaling:us-east-1:123456789012:scalingPolicy:policy-id:autoScalingGroupName/my-asg:policyName/my-policy"
  ]

  # OK状態への移行時のアクション
  # アラームがOK状態に移行したときに実行するアクションのリストを指定します。
  # Type: Set of strings
  # - 最大5項目
  # - 各ARNの長さ: 1～1024文字
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  ok_actions = [
    # "arn:aws:sns:us-east-1:123456789012:my-topic"
  ]

  # INSUFFICIENT_DATA状態への移行時のアクション
  # アラームがINSUFFICIENT_DATA状態に移行したときに実行するアクションのリストを指定します。
  # Type: Set of strings
  # - 最大5項目
  # - 各ARNの長さ: 1～1024文字
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
  insufficient_data_actions = [
    # "arn:aws:sns:us-east-1:123456789012:my-topic"
  ]

  # ==============================================================================
  # Optional Arguments - Tags
  # ==============================================================================

  # タグ
  # リソースに割り当てるタグのマップ。
  # プロバイダーの default_tags 設定ブロックと一緒に使用した場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  # Type: Map of strings
  # Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#tags
  tags = {
    Environment = "production"
    Project     = "example"
  }

  # tags_all（オプション - 通常は使用しない）
  # リソースに割り当てられた全タグのマップ。
  # プロバイダーの default_tags から継承されたタグを含みます。
  # NOTE: これは通常、Terraformによって自動的に管理されるため、明示的に設定する必要はありません。
  # Type: Map of strings
  # Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#tags_all
  # tags_all = {}

  # id（オプション - 通常は使用しない）
  # Terraformリソースの識別子。
  # NOTE: これは通常、Terraformによって自動的に管理されます。
  # Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#id
  # id = "example-alarm"

  # ==============================================================================
  # Optional Block - Metric Query
  # ==============================================================================
  # NOTE: metric_query を1つ以上指定する場合、単一メトリクスパラメータ（metric_name, namespace, period, statistic）は
  #       指定できません。メトリクス数式またはMetrics Insightsクエリベースのアラームを作成する場合に使用します。
  #
  # 使用例:
  # - メトリクス数式: 複数のメトリクスを組み合わせた計算（エラー率、比率など）
  # - Metrics Insights: SQLライクなクエリ言語を使用した高度なメトリクス分析
  #
  # 制限事項:
  # - PutMetricAlarmでは最大20個のmetric_query構造を指定可能
  # - メトリクス取得用の構造は最大10個
  # - 数式実行用の構造は最大10個
  # - 正確に1つのmetric_queryのreturn_dataをtrueに設定する必要があります
  #
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html
  # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricDataQuery.html

  # Example 1: メトリクス数式を使用したアラーム（エラー率の計算）
  # metric_query {
  #   # 計算結果を返すクエリ（return_data = true）
  #   id          = "e1"
  #   expression  = "m2/m1*100"
  #   label       = "Error Rate"
  #   return_data = true
  # }
  #
  # metric_query {
  #   # 総リクエスト数の取得
  #   id = "m1"
  #
  #   metric {
  #     metric_name = "RequestCount"
  #     namespace   = "AWS/ApplicationELB"
  #     period      = 300
  #     stat        = "Sum"
  #     unit        = "Count"
  #
  #     dimensions = {
  #       LoadBalancer = "app/my-lb/1234567890abcdef"
  #     }
  #   }
  # }
  #
  # metric_query {
  #   # エラー数の取得
  #   id = "m2"
  #
  #   metric {
  #     metric_name = "HTTPCode_Target_5XX_Count"
  #     namespace   = "AWS/ApplicationELB"
  #     period      = 300
  #     stat        = "Sum"
  #     unit        = "Count"
  #
  #     dimensions = {
  #       LoadBalancer = "app/my-lb/1234567890abcdef"
  #     }
  #   }
  # }

  # Example 2: Metrics Insightsクエリを使用したアラーム
  # metric_query {
  #   id          = "q1"
  #   expression  = <<-EOT
  #     SELECT
  #       MAX(CPUUtilization)
  #     FROM SCHEMA("AWS/EC2", InstanceId)
  #     WHERE InstanceId != 'i-excluded'
  #     GROUP BY InstanceId
  #     ORDER BY MAX() DESC
  #     LIMIT 1
  #   EOT
  #   period      = 300
  #   return_data = true
  #   label       = "Max CPU Utilization across EC2 Instances"
  # }
}

# ==============================================================================
# Metric Query Block - Detailed Configuration
# ==============================================================================
# 以下は metric_query ブロック内で使用可能な全パラメータの詳細説明です。

# metric_query {
#   # id (Required)
#   # このオブジェクトをレスポンスの結果に紐付けるための短い名前。
#   # 数式を実行する場合、この名前はデータを表し、数式内で変数として使用できます。
#   # - 有効な文字: 英字、数字、アンダースコア
#   # - 最初の文字は小文字の英字である必要があります
#   # - 最小長: 1文字
#   # - 最大長: 255文字
#   # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricDataQuery.html
#   id = "m1"
#
#   # account_id (Optional)
#   # メトリクスが配置されているアカウントのID。
#   # クロスアカウントアラームの場合に使用します。
#   # Type: String
#   # Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#account_id
#   # account_id = "123456789012"
#
#   # expression (Optional)
#   # Metrics Insightsクエリまたはメトリクス数式。
#   # 返されたデータに対して評価されます。
#   #
#   # メトリクス数式の例:
#   # - "m1 + m2": メトリクスの加算
#   # - "m1 / m2 * 100": パーセンテージ計算
#   # - "IF(m1 > 100, m1, 0)": 条件式
#   #
#   # NOTE: metric または expression のいずれか一方のみを指定する必要があります（両方は不可）。
#   # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html
#   # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch-metrics-insights-querylanguage
#   # expression = "m1 / m2 * 100"
#
#   # label (Optional)
#   # このメトリクスまたは数式に対する人間が読みやすいラベル。
#   # 特に数式の場合、値が何を表すかを明確にするために非常に有用です。
#   # Type: String
#   # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricDataQuery.html
#   # label = "Error Rate (%)"
#
#   # period (Optional)
#   # 返されるデータポイントの粒度（秒単位）。
#   # - 通常の解像度メトリクス: 60の倍数
#   # - 高解像度メトリクス: 1, 5, 10, 20, 30, または60の倍数
#   # - 最小値: 1
#   # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricDataQuery.html
#   # period = 300
#
#   # return_data (Optional)
#   # このメトリクスクエリの結果をアラームの評価に使用するかどうかを指定します。
#   # - 正確に1つのmetric_queryをtrueに設定する必要があります
#   # - デフォルト: false
#   # Type: Boolean
#   # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricDataQuery.html
#   # return_data = true
#
#   # metric block (Optional)
#   # 統計、期間、単位とともに返されるメトリクス。
#   # このオブジェクトがメトリクスを取得する場合のみ使用します（数式実行時には使用しません）。
#   #
#   # NOTE: metric または expression のいずれか一方のみを指定する必要があります（両方は不可）。
#   # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricDataQuery.html
#   metric {
#     # metric_name (Required)
#     # このメトリクスの名前。
#     # - 最小長: 1文字
#     # - 最大長: 255文字
#     # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/CW_Support_For_AWS.html
#     metric_name = "CPUUtilization"
#
#     # namespace (Optional)
#     # このメトリクスのネームスペース。
#     # 省略した場合は、親リソースのnamespaceが使用される場合があります。
#     # Type: String
#     # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/aws-namespaces.html
#     # namespace = "AWS/EC2"
#
#     # period (Required)
#     # 返されるデータポイントの粒度（秒単位）。
#     # - 通常の解像度メトリクス: 60の倍数
#     # - 高解像度メトリクス: 1, 5, 10, 20, 30, または60の倍数
#     # - 最小値: 1
#     # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricStat.html
#     period = 300
#
#     # stat (Required)
#     # このメトリクスに適用する統計。
#     # 使用可能な値:
#     # - 標準統計: Average, Sum, SampleCount, Minimum, Maximum
#     # - パーセンタイル: p0.0 ～ p100（例: p99, p95, p50）
#     # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Statistics-definitions.html
#     stat = "Average"
#
#     # unit (Optional)
#     # このメトリクスの単位。
#     # 使用可能な値は、トップレベルの unit パラメータと同じです。
#     # Type: String
#     # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricStat.html
#     # unit = "Percent"
#
#     # dimensions (Optional)
#     # このメトリクスのディメンション。
#     # Type: Map of strings
#     # - 最大30項目
#     # Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/CW_Support_For_AWS.html
#     # dimensions = {
#     #   InstanceId = "i-1234567890abcdef0"
#     # }
#   }
# }

# ==============================================================================
# Computed Attributes (Read-Only)
# ==============================================================================
# 以下の属性はTerraformによって自動的に計算され、リソース作成後に参照できます。
# これらは設定ファイルに記述する必要はありません。

# arn (Computed)
# CloudWatch Metric AlarmのAmazon Resource Name (ARN)
# Type: String
# - 最小長: 1文字
# - 最大長: 1600文字
# 使用例: aws_cloudwatch_metric_alarm.example.arn
# Ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html

# ==============================================================================
# Output Examples
# ==============================================================================
# output "alarm_arn" {
#   description = "The ARN of the CloudWatch Metric Alarm"
#   value       = aws_cloudwatch_metric_alarm.example.arn
# }
#
# output "alarm_id" {
#   description = "The ID of the CloudWatch Metric Alarm"
#   value       = aws_cloudwatch_metric_alarm.example.id
# }

# ==============================================================================
# Additional References
# ==============================================================================
# - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm
# - AWS CloudWatch API Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
# - Supported Metrics: https://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/CW_Support_For_AWS.html
# - AWS Namespaces: https://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/aws-namespaces.html
# - Metric Math: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html
# - Metrics Insights: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch-metrics-insights-querylanguage
# - Missing Data Handling: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html#alarms-and-missing-data
