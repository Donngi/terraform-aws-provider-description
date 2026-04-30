#---------------------------------------------------------------
# AWS CloudWatch Metric Alarm
#---------------------------------------------------------------
#
# Amazon CloudWatchのメトリクスアラームをプロビジョニングするリソースです。
# 指定したCloudWatchメトリクスやメトリクス数式、PromQLクエリの値を監視し、
# しきい値を超えた場合にSNS通知やAuto Scalingアクション、EC2/Systems Managerアクション等を
# 自動的に発動させることができます。
#
# AWS公式ドキュメント:
#   - CloudWatch Alarms概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html
#   - PutMetricAlarm API: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_PutMetricAlarm.html
#   - メトリクス数式によるアラーム: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Create-alarm-on-metric-math-expression.html
#   - PromQLアラーム: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/alarm-promql.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.43.0/docs/resources/cloudwatch_metric_alarm
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # alarm_name (Required)
  # 設定内容: アラームを一意に識別する名前を指定します。
  # 設定可能な値: 1-255文字のASCII文字列（同一AWSアカウント・同一リージョン内で一意）
  # 注意: 名前を変更すると既存アラームが削除され新規作成されます。
  alarm_name = "example-cpu-utilization-high"

  # alarm_description (Optional)
  # 設定内容: アラームの説明文を指定します。
  # 設定可能な値: 0-1024文字の文字列
  # 省略時: 説明なし
  alarm_description = "EC2インスタンスのCPU使用率が80%を超えた場合に発動するアラーム"

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
  # 比較演算子・しきい値設定
  #-------------------------------------------------------------

  # comparison_operator (Optional)
  # 設定内容: メトリクスとしきい値の比較方法を指定します。
  # 設定可能な値:
  #   - "GreaterThanOrEqualToThreshold": メトリクス >= しきい値
  #   - "GreaterThanThreshold": メトリクス > しきい値
  #   - "LessThanThreshold": メトリクス < しきい値
  #   - "LessThanOrEqualToThreshold": メトリクス <= しきい値
  #   - "LessThanLowerOrGreaterThanUpperThreshold": 異常検出（範囲外）
  #   - "LessThanLowerThreshold": 異常検出（下限を下回る）
  #   - "GreaterThanUpperThreshold": 異常検出（上限を上回る）
  # 省略時: evaluation_criteriaを使用するPromQLアラームでは省略可
  # 注意: 通常のメトリクスアラームでは必須。
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # threshold (Optional)
  # 設定内容: アラームを発動させるしきい値（数値）を指定します。
  # 設定可能な値: 数値（comparison_operatorと組み合わせて使用）
  # 省略時: threshold_metric_id（異常検出）を使用する場合は省略可
  threshold = 80.0

  # threshold_metric_id (Optional)
  # 設定内容: 動的しきい値（異常検出モデル）として参照するmetric_queryブロックのidを指定します。
  # 設定可能な値: metric_queryブロックのid属性値
  # 省略時: 静的なthresholdを使用
  # 関連機能: CloudWatch 異常検出
  #   過去のメトリクス値からモデルを学習し、動的に「期待される値の範囲」を生成。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Anomaly_Detection.html
  threshold_metric_id = null

  #-------------------------------------------------------------
  # 評価期間設定
  #-------------------------------------------------------------

  # evaluation_periods (Optional)
  # 設定内容: しきい値判定に使用するデータポイントの期間数を指定します。
  # 設定可能な値: 1以上の整数
  # 省略時: evaluation_criteria（PromQLアラーム）を使用する場合は省略可
  # 注意: 通常のメトリクスアラームでは必須。
  evaluation_periods = 2

  # datapoints_to_alarm (Optional)
  # 設定内容: evaluation_periodsのうちアラームを発動させるのに必要な違反データポイント数を指定します。
  # 設定可能な値: 1以上、evaluation_periods以下の整数
  # 省略時: evaluation_periodsと同値（M out of M アラーム）
  # 関連機能: M out of N アラーム
  #   N期間中M期間で違反した場合にアラームとなる動作モード。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html#alarm-evaluation
  datapoints_to_alarm = 2

  #-------------------------------------------------------------
  # メトリクス指定（単純メトリクス）
  #-------------------------------------------------------------

  # metric_name (Optional)
  # 設定内容: アラームが対象とするCloudWatchメトリクスの名前を指定します。
  # 設定可能な値: CloudWatchの標準メトリクス名またはカスタムメトリクス名（例: CPUUtilization）
  # 省略時: metric_queryブロックまたはevaluation_criteriaブロックを使用する場合は省略可
  # 注意: metric_queryブロックを使用する場合は省略する必要があります。
  metric_name = "CPUUtilization"

  # namespace (Optional)
  # 設定内容: 監視対象メトリクスの名前空間を指定します。
  # 設定可能な値: AWSサービスの名前空間（AWS/EC2, AWS/RDS, AWS/Lambda等）またはカスタム名前空間
  # 省略時: metric_queryブロックまたはevaluation_criteriaブロックを使用する場合は省略可
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html
  namespace = "AWS/EC2"

  # period (Optional)
  # 設定内容: メトリクスを集計する期間（秒）を指定します。
  # 設定可能な値: 10, 30, または60の倍数（最大86400秒）
  # 省略時: metric_queryブロックまたはevaluation_criteriaブロックを使用する場合は省略可
  # 注意: 高解像度メトリクス(1秒精度)は10/30秒、それ以外は60秒以上を指定。
  period = 300

  # statistic (Optional)
  # 設定内容: メトリクスの集計統計を指定します。
  # 設定可能な値: "SampleCount", "Average", "Sum", "Minimum", "Maximum"
  # 省略時: extended_statisticまたはmetric_queryを使用する場合は省略可
  # 注意: extended_statisticと同時指定不可。
  statistic = "Average"

  # extended_statistic (Optional)
  # 設定内容: パーセンタイル統計やトリム平均などの拡張統計を指定します。
  # 設定可能な値:
  #   - パーセンタイル: "p99", "p95.5", "p50" 等（p0.0〜p100）
  #   - トリム平均: "tm99", "tm(10%:90%)" 等
  #   - その他: "wm", "tc", "ts" 等
  # 省略時: statisticを使用
  # 注意: statisticと同時指定不可。
  extended_statistic = null

  # dimensions (Optional)
  # 設定内容: メトリクスのディメンション（フィルタリング条件）をマップで指定します。
  # 設定可能な値: 文字列のキー・値ペアのマップ（最大10ディメンション）
  # 省略時: ディメンションなしのメトリクスを対象
  # 例: EC2インスタンス指定 -> { InstanceId = "i-xxxxxxxxxxxxxxxxx" }
  dimensions = {
    InstanceId = "i-1234567890abcdef0"
  }

  # unit (Optional)
  # 設定内容: メトリクスの単位を指定します。
  # 設定可能な値: "Seconds", "Microseconds", "Milliseconds", "Bytes", "Kilobytes",
  #              "Megabytes", "Gigabytes", "Terabytes", "Bits", "Kilobits", "Megabits",
  #              "Gigabits", "Terabits", "Percent", "Count", "Bytes/Second",
  #              "Kilobytes/Second", "Megabytes/Second", "Gigabytes/Second",
  #              "Terabytes/Second", "Bits/Second", "Kilobits/Second", "Megabits/Second",
  #              "Gigabits/Second", "Terabits/Second", "Count/Second", "None"
  # 省略時: 単位フィルタリングなし
  # 注意: メトリクス公開時の単位と一致しない場合、データなしとして扱われます。
  unit = "Percent"

  #-------------------------------------------------------------
  # 欠損データ・サンプル数処理
  #-------------------------------------------------------------

  # treat_missing_data (Optional)
  # 設定内容: データポイントが欠損している場合の扱いを指定します。
  # 設定可能な値:
  #   - "missing": 欠損として扱う（評価対象外）。デフォルト
  #   - "notBreaching": 違反していないデータポイントとして扱う
  #   - "breaching": 違反データポイントとして扱う
  #   - "ignore": 現在のアラーム状態を維持
  # 省略時: "missing"
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html#alarms-and-missing-data
  treat_missing_data = "missing"

  # evaluate_low_sample_count_percentiles (Optional)
  # 設定内容: パーセンタイル統計使用時、サンプル数が少ない場合の評価動作を指定します。
  # 設定可能な値:
  #   - "evaluate": サンプル数に関わらずアラームを評価
  #   - "ignore": サンプル数が少ない場合は評価をスキップ（アラーム状態を維持）
  # 省略時: "evaluate"
  # 注意: extended_statisticでパーセンタイルを使用する場合のみ意味を持ちます。
  evaluate_low_sample_count_percentiles = null

  #-------------------------------------------------------------
  # アクション設定
  #-------------------------------------------------------------

  # actions_enabled (Optional)
  # 設定内容: アラームのアクション実行を有効化するかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): アクションを実行
  #   - false: アラーム発動してもアクションを実行しない
  # 省略時: true
  actions_enabled = true

  # alarm_actions (Optional)
  # 設定内容: ALARM状態に遷移した際に実行するアクションのARNを指定します。
  # 設定可能な値: ARN文字列のセット（最大5個）
  #   - SNSトピックARN: SNS通知
  #   - Auto Scalingポリシー: スケーリング実行
  #   - EC2アクション: 停止/終了/再起動/復旧（arn:aws:automate:<region>:ec2:<action>）
  #   - Systems Manager OpsItem/Incident: arn:aws:ssm:<region>:<account>:opsitem:<severity> 等
  # 省略時: アクションなし
  alarm_actions = [
    "arn:aws:sns:ap-northeast-1:123456789012:example-alarm-topic",
  ]

  # ok_actions (Optional)
  # 設定内容: OK状態に復帰した際に実行するアクションのARNを指定します。
  # 設定可能な値: ARN文字列のセット（最大5個。alarm_actionsと同形式）
  # 省略時: アクションなし
  ok_actions = [
    "arn:aws:sns:ap-northeast-1:123456789012:example-ok-topic",
  ]

  # insufficient_data_actions (Optional)
  # 設定内容: INSUFFICIENT_DATA状態に遷移した際に実行するアクションのARNを指定します。
  # 設定可能な値: ARN文字列のセット（最大5個。alarm_actionsと同形式）
  # 省略時: アクションなし
  insufficient_data_actions = []

  #-------------------------------------------------------------
  # メトリクスクエリ設定（メトリクス数式・複合クエリ）
  #-------------------------------------------------------------

  # metric_query (Optional, Block Set)
  # 設定内容: 複数メトリクスの組み合わせやメトリクス数式によるアラーム評価を定義します。
  # 設定可能な値: metric_queryブロックのセット（メトリクス数式利用時は複数必須）
  # 省略時: metric_name等の単純メトリクス指定を使用
  # 注意: metric_query使用時はトップレベルのmetric_name/namespace/period/statistic/extended_statistic/dimensions/unitは指定不可。
  # 関連機能: メトリクス数式・Metrics Insights
  #   複数メトリクスを式で組み合わせて評価可能（例: "m1 / m2 * 100"）。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html
  metric_query {

    # id (Required)
    # 設定内容: クエリの一意識別子を指定します。
    # 設定可能な値: 1-255文字。英小文字で始まり、英数字とアンダースコアのみ使用可能
    id = "m1"

    # account_id (Optional)
    # 設定内容: クロスアカウントメトリクスを参照する場合のAWSアカウントIDを指定します。
    # 設定可能な値: 12桁のAWSアカウントID
    # 省略時: 同一アカウントのメトリクスを使用
    # 関連機能: クロスアカウントCloudWatch
    #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Cross-Account-Cross-Region.html
    account_id = null

    # expression (Optional)
    # 設定内容: メトリクス数式を指定します。
    # 設定可能な値: 数式文字列（例: "m1 + m2", "100 * (m1 / m2)", "ANOMALY_DETECTION_BAND(m1)"）
    # 省略時: metricブロックで実メトリクスを指定
    # 注意: expressionとmetricブロックは排他的（どちらか一方のみ指定）。
    expression = null

    # label (Optional)
    # 設定内容: クエリ結果に付与するラベルを指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: 自動生成されたラベル
    label = "EC2 CPU Utilization"

    # period (Optional)
    # 設定内容: メトリクス取得期間（秒）を指定します。expressionでは無視されます。
    # 設定可能な値: 10, 30, または60の倍数
    # 省略時: metricブロックのperiodを使用
    period = 300

    # return_data (Optional)
    # 設定内容: このクエリの結果をアラーム評価対象にするかを指定します。
    # 設定可能な値:
    #   - true: アラーム評価に使用（複数metric_queryのうち1つだけがtrue）
    #   - false: 中間計算用クエリ
    # 省略時: false
    # 注意: 少なくとも1つのmetric_queryでtrueを指定する必要があります。
    return_data = true

    # metric (Optional, Block List, Max: 1)
    # 設定内容: 実際のCloudWatchメトリクスを参照する設定ブロックです。
    # 注意: expressionと排他的です。
    metric {

      # metric_name (Required)
      # 設定内容: メトリクス名を指定します。
      # 設定可能な値: 標準/カスタムCloudWatchメトリクス名
      metric_name = "CPUUtilization"

      # namespace (Optional)
      # 設定内容: メトリクスの名前空間を指定します。
      # 設定可能な値: AWS/EC2, AWS/RDS等の名前空間
      # 省略時: 名前空間なし
      namespace = "AWS/EC2"

      # period (Required)
      # 設定内容: メトリクス取得期間（秒）を指定します。
      # 設定可能な値: 10, 30, または60の倍数
      period = 300

      # stat (Required)
      # 設定内容: 統計関数を指定します。
      # 設定可能な値:
      #   - 標準統計: "SampleCount", "Average", "Sum", "Minimum", "Maximum"
      #   - パーセンタイル: "p99", "p95.5" 等
      #   - 拡張統計: "tm99", "wm99", "tc99", "ts99" 等
      stat = "Average"

      # dimensions (Optional)
      # 設定内容: メトリクスのディメンションをマップで指定します。
      # 設定可能な値: キー・値ペアのマップ（最大10ディメンション）
      # 省略時: ディメンションなしのメトリクス
      dimensions = {
        InstanceId = "i-1234567890abcdef0"
      }

      # unit (Optional)
      # 設定内容: メトリクスの単位を指定します。
      # 設定可能な値: トップレベルunitと同じ値
      # 省略時: 単位フィルタリングなし
      unit = "Percent"
    }
  }

  #-------------------------------------------------------------
  # PromQLアラーム設定（v6.43.0以降）
  #-------------------------------------------------------------

  # evaluation_criteria (Optional, Block List, Max: 1)
  # 設定内容: PromQLクエリベースのアラーム評価条件を定義します。
  # 省略時: 通常のメトリクスアラーム（comparison_operator/threshold等を使用）
  # 注意: evaluation_criteria使用時は、metric_name/namespace/period/statistic/threshold/
  #       evaluation_periods/comparison_operator等の通常パラメータは併用不可です。
  # 関連機能: CloudWatch PromQLアラーム
  #   CloudWatch OTLPエンドポイント経由で取り込まれたメトリクスをPrometheus Query Language (PromQL)で
  #   評価するアラーム。マッチした各時系列をcontributorとして個別に追跡し、ALARM/OK/recovering状態を遷移します。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/alarm-promql.html
  evaluation_criteria {

    # promql_criteria (Required, Block List, Max: 1)
    # 設定内容: PromQLクエリの評価条件を定義する設定ブロックです。
    # 関連機能: AlarmPromQLCriteria API
    #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_AlarmPromQLCriteria.html
    promql_criteria {

      # query (Required)
      # 設定内容: 評価するPromQLクエリを指定します。
      # 設定可能な値: 1-10000文字のPromQLクエリ（vector型結果を返す必要があります）
      # 注意: マッチする全時系列が違反対象（contributor）として扱われます。
      query = "avg(up) < 0.5"

      # pending_period (Optional)
      # 設定内容: contributorがALARM状態に遷移するまでの違反継続時間（秒）を指定します。
      # 設定可能な値: 0-86400（最大1日）の整数（秒）
      # 省略時: API側のデフォルト値が適用されます
      pending_period = 300

      # recovery_period (Optional)
      # 設定内容: contributorがOK状態に復帰するまでの非違反継続時間（秒）を指定します。
      # 設定可能な値: 0-86400（最大1日）の整数（秒）
      # 省略時: API側のデフォルト値が適用されます
      recovery_period = 300
    }
  }

  # evaluation_interval (Optional)
  # 設定内容: PromQLアラームのクエリ評価間隔（秒）を指定します。
  # 設定可能な値: 整数（秒）
  # 省略時: API側のデフォルト値が適用されます
  # 注意: PromQLアラーム（evaluation_criteria使用時）でのみ有効です。
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/alarm-promql.html
  evaluation_interval = 60

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50タグ）
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tagsと同一キーが指定された場合、リソース側の定義が優先されます。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch-and-tagging.html
  tags = {
    Name        = "example-cpu-utilization-high"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アラームの識別子（alarm_nameと同一）
# - arn: CloudWatchメトリクスアラームのAmazon Resource Name (ARN)
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
