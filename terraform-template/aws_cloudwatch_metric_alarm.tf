#####################################################################
# CloudWatch Metric Alarm
#####################################################################
# 説明: CloudWatchメトリクスに基づいてアラームを作成し、SNSやAuto Scalingなどのアクションをトリガーする
# ユースケース: EC2/RDS/ELBなどの監視、自動スケーリング、SNS通知
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudwatch_metric_alarm
# Generated: 2026-02-12
# NOTE: このテンプレートは全設定項目を網羅した参考資料です。実際の利用時は必要な項目のみを使用してください。

resource "aws_cloudwatch_metric_alarm" "example" {
  #-----------------------------------------------
  # 基本設定
  #-----------------------------------------------
  # 設定内容: アラーム名（一意）
  # 設定可能な値: 1-255文字の英数字/ハイフン/アンダースコア
  # 省略時: 省略不可
  alarm_name = "example-cpu-alarm"

  # 設定内容: 比較演算子（メトリクスとしきい値の比較方法）
  # 設定可能な値: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold, LessThanLowerOrGreaterThanUpperThreshold, LessThanLowerThreshold, GreaterThanUpperThreshold
  # 省略時: 省略不可
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # 設定内容: アラーム評価期間（何期間連続してしきい値を超えたらアラーム発動するか）
  # 設定可能な値: 1以上の整数
  # 省略時: 省略不可
  evaluation_periods = 2

  #-----------------------------------------------
  # メトリクス設定（単純メトリクス）
  #-----------------------------------------------
  # 設定内容: メトリクス名
  # 設定可能な値: CloudWatchの標準/カスタムメトリクス名（例: CPUUtilization, NetworkIn）
  # 省略時: metric_queryを使用する場合は省略可
  metric_name = "CPUUtilization"

  # 設定内容: メトリクスの名前空間
  # 設定可能な値: AWS/EC2, AWS/RDS, AWS/ELB など
  # 省略時: metric_queryを使用する場合は省略可
  namespace = "AWS/EC2"

  # 設定内容: メトリクスの統計方法
  # 設定可能な値: SampleCount, Average, Sum, Minimum, Maximum
  # 省略時: extended_statisticまたはmetric_queryを使用する場合は省略可
  statistic = "Average"

  # 設定内容: メトリクスの評価期間（秒単位）
  # 設定可能な値: 10, 30, 60の倍数（最小10秒、標準メトリクスは60秒以上推奨）
  # 省略時: metric_queryを使用する場合は省略可
  period = 300

  # 設定内容: メトリクスのディメンション（フィルタリング条件）
  # 設定可能な値: キーと値のマップ（例: InstanceId = i-1234567890abcdef0）
  # 省略時: すべてのリソースが対象
  dimensions = {
    InstanceId = "i-1234567890abcdef0"
  }

  # 設定内容: パーセンタイル統計（p99.9など）
  # 設定可能な値: p0.0 から p100 の形式（例: p99, p95.5）
  # 省略時: statisticを使用
  extended_statistic = null

  # 設定内容: メトリクスの単位
  # 設定可能な値: Seconds, Microseconds, Milliseconds, Bytes, Kilobytes, Megabytes, Gigabytes, Terabytes, Bits, Kilobits, Megabits, Gigabits, Terabits, Percent, Count, Bytes/Second, Kilobytes/Second, Megabytes/Second, Gigabytes/Second, Terabytes/Second, Bits/Second, Kilobits/Second, Megabits/Second, Gigabits/Second, Terabits/Second, Count/Second, None
  # 省略時: 単位チェックなし
  unit = null

  #-----------------------------------------------
  # しきい値とアラーム動作設定
  #-----------------------------------------------
  # 設定内容: アラームのしきい値
  # 設定可能な値: 数値（comparison_operatorと組み合わせて使用）
  # 省略時: threshold_metric_idを使用する場合は省略可
  threshold = 80.0

  # 設定内容: アラーム判定に必要なデータポイント数
  # 設定可能な値: 1からevaluation_periodsまでの整数
  # 省略時: evaluation_periodsと同じ（すべての期間でしきい値超過が必要）
  datapoints_to_alarm = null

  # 設定内容: データ不足時の扱い方
  # 設定可能な値: missing（データ不足を無視）, notBreaching（正常と見なす）, breaching（異常と見なす）, ignore（アラーム状態を変更しない）
  # 省略時: missing
  treat_missing_data = "notBreaching"

  # 設定内容: サンプル数が少ない場合のパーセンタイル評価方法
  # 設定可能な値: evaluate, ignore
  # 省略時: evaluate（パーセンタイル使用時のデフォルト動作）
  evaluate_low_sample_count_percentiles = null

  #-----------------------------------------------
  # アクション設定
  #-----------------------------------------------
  # 設定内容: アラーム発動を有効化するかどうか
  # 設定可能な値: true（アクション実行）, false（アクション無効）
  # 省略時: true
  actions_enabled = true

  # 設定内容: アラーム状態になったときに実行するアクション（ARNのリスト）
  # 設定可能な値: SNS Topic ARN, Auto Scaling Policy ARN, Systems Manager OpsItem ARN など
  # 省略時: アクションなし
  alarm_actions = [
    "arn:aws:sns:ap-northeast-1:123456789012:example-topic",
  ]

  # 設定内容: OK状態に戻ったときに実行するアクション
  # 設定可能な値: SNS Topic ARNなど
  # 省略時: アクションなし
  ok_actions = null

  # 設定内容: データ不足状態になったときに実行するアクション
  # 設定可能な値: SNS Topic ARNなど
  # 省略時: アクションなし
  insufficient_data_actions = null

  #-----------------------------------------------
  # 説明とタグ
  #-----------------------------------------------
  # 設定内容: アラームの説明
  # 設定可能な値: 最大1024文字のテキスト
  # 省略時: 説明なし
  alarm_description = "CPU使用率が80%を超えた場合にアラーム発動"

  # 設定内容: リソースタグ
  # 設定可能な値: キーと値のマップ（最大50個）
  # 省略時: タグなし
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-----------------------------------------------
  # 高度なメトリクス設定（メトリクスクエリ）
  #-----------------------------------------------
  # 設定内容: 複数メトリクスの組み合わせや数式による評価
  # 設定可能な値: metric_queryブロックのリスト
  # 省略時: 単純メトリクス（metric_name, namespace等）を使用
  # metric_query {
  #   # 設定内容: クエリの一意識別子
  #   # 設定可能な値: 英小文字で始まる1-255文字の英数字/アンダースコア
  #   # 省略時: 省略不可
  #   id = "m1"
  #
  #   # 設定内容: メトリクスの数式（他のクエリIDを参照可能）
  #   # 設定可能な値: 数式文字列（例: "m1 + m2", "AVG([m1, m2])"）
  #   # 省略時: metricブロックで実メトリクスを指定
  #   # expression = "m1 + m2"
  #
  #   # 設定内容: グラフやアラームで使用するラベル
  #   # 設定可能な値: 任意の文字列
  #   # 省略時: デフォルトラベル
  #   # label = "Total CPU Usage"
  #
  #   # 設定内容: このクエリの結果をアラーム評価に使用するか
  #   # 設定可能な値: true, false
  #   # 省略時: true（最後のクエリ）
  #   # return_data = true
  #
  #   # 設定内容: クロスアカウントメトリクスのアカウントID
  #   # 設定可能な値: 12桁のAWSアカウントID
  #   # 省略時: 現在のアカウント
  #   # account_id = "123456789012"
  #
  #   # 設定内容: メトリクスの評価期間（秒）
  #   # 設定可能な値: 60の倍数（最小60秒）
  #   # 省略時: アラームのperiod設定を継承
  #   # period = 300
  #
  #   # 設定内容: 実際のCloudWatchメトリクス
  #   # 設定可能な値: metricブロック（最大1個）
  #   # 省略時: expressionを使用
  #   metric {
  #     # 設定内容: メトリクス名
  #     # 設定可能な値: CloudWatchメトリクス名
  #     # 省略時: 省略不可
  #     metric_name = "CPUUtilization"
  #
  #     # 設定内容: メトリクスの名前空間
  #     # 設定可能な値: AWS/EC2, AWS/RDSなど
  #     # 省略時: デフォルト名前空間
  #     namespace = "AWS/EC2"
  #
  #     # 設定内容: 評価期間（秒）
  #     # 設定可能な値: 60の倍数
  #     # 省略時: 省略不可
  #     period = 300
  #
  #     # 設定内容: 統計方法
  #     # 設定可能な値: Average, Sum, Minimum, Maximum, SampleCount, pXX.XX（パーセンタイル）
  #     # 省略時: 省略不可
  #     stat = "Average"
  #
  #     # 設定内容: メトリクスのディメンション
  #     # 設定可能な値: キーと値のマップ
  #     # 省略時: すべてのリソース
  #     dimensions = {
  #       InstanceId = "i-1234567890abcdef0"
  #     }
  #
  #     # 設定内容: メトリクスの単位
  #     # 設定可能な値: Percent, Bytes, Seconds など
  #     # 省略時: 単位チェックなし
  #     # unit = "Percent"
  #   }
  # }

  # 設定内容: 動的しきい値を使用する場合のメトリクスクエリID
  # 設定可能な値: metric_queryブロックのid値
  # 省略時: thresholdを使用
  threshold_metric_id = null

  #-----------------------------------------------
  # リージョン設定
  #-----------------------------------------------
  # 設定内容: リソースを作成するAWSリージョン
  # 設定可能な値: ap-northeast-1, us-east-1 など
  # 省略時: プロバイダーのデフォルトリージョン
  region = null
}

#####################################################################
# Attributes Reference（参照専用属性）
#####################################################################
# 以下の属性はリソース作成後に参照可能（設定不可）

# arn             - アラームのARN
# id              - アラーム名（alarm_nameと同じ）
# tags_all        - デフォルトタグを含むすべてのタグ
