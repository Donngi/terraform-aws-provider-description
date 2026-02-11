#---------------------------------------------------------------
# AWS Auto Scaling Policy
#---------------------------------------------------------------
#
# Amazon EC2 Auto Scalingグループに対するスケーリングポリシーを定義するリソースです。
# スケーリングポリシーは、需要に応じてAuto Scalingグループのインスタンス数を
# 自動的に調整するルールを設定します。
#
# AWS公式ドキュメント:
#   - Auto Scaling概要: https://docs.aws.amazon.com/autoscaling/ec2/userguide/what-is-amazon-ec2-auto-scaling.html
#   - スケーリングポリシー: https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scale-based-on-demand.html
#   - ターゲット追跡スケーリング: https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scaling-target-tracking.html
#   - ステップスケーリング: https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scaling-simple-step.html
#   - 予測スケーリング: https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-predictive-scaling.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_autoscaling_policy" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: スケーリングポリシーの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-scaling-policy"

  # autoscaling_group_name (Required)
  # 設定内容: このポリシーを適用するAuto Scalingグループの名前を指定します。
  # 設定可能な値: 既存のAuto Scalingグループ名
  autoscaling_group_name = "my-asg"

  #-------------------------------------------------------------
  # ポリシータイプ設定
  #-------------------------------------------------------------

  # policy_type (Optional)
  # 設定内容: スケーリングポリシーのタイプを指定します。
  # 設定可能な値:
  #   - "SimpleScaling": シンプルスケーリング。単一の調整を行う
  #   - "StepScaling": ステップスケーリング。アラームの超過度合いに応じた段階的な調整を行う
  #   - "TargetTrackingScaling": ターゲット追跡スケーリング。メトリクスが目標値を維持するよう自動調整
  #   - "PredictiveScaling": 予測スケーリング。機械学習に基づく予測で事前にスケーリング
  # 省略時: "SimpleScaling"
  policy_type = "TargetTrackingScaling"

  # enabled (Optional)
  # 設定内容: スケーリングポリシーを有効にするか無効にするかを指定します。
  # 設定可能な値:
  #   - true: ポリシーを有効化
  #   - false: ポリシーを無効化
  # 省略時: true
  enabled = true

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
  # 調整タイプ設定（SimpleScaling / StepScaling共通）
  #-------------------------------------------------------------

  # adjustment_type (Optional)
  # 設定内容: キャパシティ調整の方法を指定します。
  # 設定可能な値:
  #   - "ChangeInCapacity": 現在のキャパシティに指定値を加算（マイナスで減算）
  #   - "ExactCapacity": 指定値を新しいキャパシティとして設定
  #   - "PercentChangeInCapacity": 現在のキャパシティに対するパーセンテージで調整
  # 注意: TargetTrackingScaling / PredictiveScalingの場合は不要
  adjustment_type = null

  # min_adjustment_magnitude (Optional)
  # 設定内容: PercentChangeInCapacityの場合の最小調整数を指定します。
  # 設定可能な値: 正の整数
  # 用途: 小さいグループでパーセンテージ調整が0になるのを防ぐ
  # 注意: adjustment_typeが"PercentChangeInCapacity"の場合のみ有効
  min_adjustment_magnitude = null

  #-------------------------------------------------------------
  # SimpleScaling専用設定
  #-------------------------------------------------------------

  # scaling_adjustment (Optional)
  # 設定内容: スケーリング時の調整値を指定します。
  # 設定可能な値: 整数（正の値でスケールアウト、負の値でスケールイン）
  # 解釈: adjustment_typeの設定に依存
  #   - ChangeInCapacity: インスタンス数の増減値
  #   - ExactCapacity: 目標インスタンス数
  #   - PercentChangeInCapacity: パーセンテージ
  # 注意: policy_typeが"SimpleScaling"の場合に使用
  scaling_adjustment = null

  # cooldown (Optional)
  # 設定内容: スケーリング活動完了後、次のスケーリング活動を開始するまでの待機時間（秒）
  # 設定可能な値: 0以上の整数（秒）
  # 省略時: Auto Scalingグループのデフォルトクールダウン値を使用
  # 注意: policy_typeが"SimpleScaling"または"StepScaling"の場合に使用
  cooldown = null

  #-------------------------------------------------------------
  # StepScaling専用設定
  #-------------------------------------------------------------

  # metric_aggregation_type (Optional)
  # 設定内容: ポリシーのメトリクス集約タイプを指定します。
  # 設定可能な値:
  #   - "Minimum": 最小値
  #   - "Maximum": 最大値
  #   - "Average": 平均値
  # 省略時: "Average"
  # 注意: policy_typeが"StepScaling"の場合に使用
  metric_aggregation_type = null

  # estimated_instance_warmup (Optional)
  # 設定内容: 新しくスタートしたインスタンスがCloudWatchメトリクスに貢献するまでの推定時間（秒）
  # 設定可能な値: 0以上の整数（秒）
  # 省略時: Auto Scalingグループのクールダウン期間を使用
  # 関連機能: インスタンスウォームアップ
  #   ステップスケーリングとターゲット追跡スケーリングで、新しいインスタンスが
  #   安定するまでの時間を考慮してスケーリング判断を行います。
  estimated_instance_warmup = null

  #-------------------------------------------------------------
  # step_adjustment（StepScaling用）
  #-------------------------------------------------------------
  # ステップ調整を定義します。アラーム閾値との差分に応じた
  # 段階的なスケーリング調整を設定できます。

  # step_adjustment {
  #   # scaling_adjustment (Required)
  #   # 設定内容: この境界範囲に該当した場合のスケーリング調整値
  #   # 設定可能な値: 整数（正の値でスケールアウト、負の値でスケールイン）
  #   scaling_adjustment = 1
  #
  #   # metric_interval_lower_bound (Optional)
  #   # 設定内容: アラーム閾値との差分の下限値を指定します。
  #   # 設定可能な値: 数値（アラーム閾値からの相対値）
  #   # 省略時: 負の無限大として扱われる
  #   # 注意: 境界値は閾値からの相対値であり、0%からの絶対値ではありません
  #   metric_interval_lower_bound = "0"
  #
  #   # metric_interval_upper_bound (Optional)
  #   # 設定内容: アラーム閾値との差分の上限値を指定します。
  #   # 設定可能な値: 数値（アラーム閾値からの相対値）。下限値より大きい必要があります。
  #   # 省略時: 正の無限大として扱われる
  #   metric_interval_upper_bound = "10"
  # }

  #-------------------------------------------------------------
  # target_tracking_configuration（TargetTrackingScaling用）
  #-------------------------------------------------------------
  # ターゲット追跡スケーリングの設定を定義します。
  # 指定したメトリクスが目標値を維持するよう自動的にスケーリングします。

  target_tracking_configuration {
    # target_value (Required)
    # 設定内容: メトリクスの目標値を指定します。
    # 設定可能な値: 数値
    # 用途: Auto Scalingは、このターゲット値を維持するようにインスタンス数を調整します
    target_value = 50.0

    # disable_scale_in (Optional)
    # 設定内容: ターゲット追跡ポリシーによるスケールインを無効にするかを指定します。
    # 設定可能な値:
    #   - true: スケールイン無効（スケールアウトのみ実行）
    #   - false: スケールイン有効
    # 省略時: false
    disable_scale_in = false

    #-----------------------------------------------------------
    # predefined_metric_specification（事前定義メトリクス）
    #-----------------------------------------------------------
    # AWSが事前定義したメトリクスを使用する場合に指定します。
    # customized_metric_specificationと排他的です。

    predefined_metric_specification {
      # predefined_metric_type (Required)
      # 設定内容: 使用する事前定義メトリクスのタイプを指定します。
      # 設定可能な値:
      #   - "ASGAverageCPUUtilization": Auto Scalingグループの平均CPU使用率
      #   - "ASGAverageNetworkIn": Auto Scalingグループの平均ネットワーク受信バイト数
      #   - "ASGAverageNetworkOut": Auto Scalingグループの平均ネットワーク送信バイト数
      #   - "ALBRequestCountPerTarget": ALBターゲットグループあたりのリクエスト数
      predefined_metric_type = "ASGAverageCPUUtilization"

      # resource_label (Optional)
      # 設定内容: 特定のALBターゲットグループを識別するためのリソースラベルを指定します。
      # 設定可能な値: "app/<load-balancer-name>/<load-balancer-id>/targetgroup/<target-group-name>/<target-group-id>"
      # 注意: predefined_metric_typeが"ALBRequestCountPerTarget"の場合に必須
      resource_label = null
    }

    #-----------------------------------------------------------
    # customized_metric_specification（カスタムメトリクス）
    #-----------------------------------------------------------
    # カスタムCloudWatchメトリクスを使用する場合に指定します。
    # predefined_metric_specificationと排他的です。

    # customized_metric_specification {
    #   # metric_name (Optional)
    #   # 設定内容: メトリクス名を指定します。
    #   # 注意: metricsを使用する場合は不要
    #   metric_name = "CPUUtilization"
    #
    #   # namespace (Optional)
    #   # 設定内容: メトリクスの名前空間を指定します。
    #   # 注意: metricsを使用する場合は不要
    #   namespace = "AWS/EC2"
    #
    #   # statistic (Optional)
    #   # 設定内容: メトリクスの統計を指定します。
    #   # 設定可能な値: "Average", "Minimum", "Maximum", "SampleCount", "Sum"
    #   # 注意: metricsを使用する場合は不要
    #   statistic = "Average"
    #
    #   # period (Optional)
    #   # 設定内容: メトリクスの期間（秒）を指定します。
    #   # 設定可能な値: 正の整数（秒）
    #   # 注意: metricsを使用する場合は不要
    #   period = 60
    #
    #   # unit (Optional)
    #   # 設定内容: メトリクスの単位を指定します。
    #   # 設定可能な値: CloudWatchでサポートされる単位（例: "Percent", "Bytes", "Count"）
    #   unit = null
    #
    #   #---------------------------------------------------------
    #   # metric_dimension（メトリクスディメンション）
    #   #---------------------------------------------------------
    #   # metric_dimension {
    #   #   # name (Required)
    #   #   # 設定内容: ディメンション名を指定します。
    #   #   name = "AutoScalingGroupName"
    #   #
    #   #   # value (Required)
    #   #   # 設定内容: ディメンション値を指定します。
    #   #   value = "my-asg"
    #   # }
    #
    #   #---------------------------------------------------------
    #   # metrics（メトリクスマス式）
    #   #---------------------------------------------------------
    #   # 複数のメトリクスを組み合わせたメトリクスマス式を使用する場合に指定します。
    #
    #   # metrics {
    #   #   # id (Required)
    #   #   # 設定内容: メトリクスの一意の識別子を指定します。
    #   #   id = "m1"
    #   #
    #   #   # label (Optional)
    #   #   # 設定内容: メトリクスの人間が読みやすいラベルを指定します。
    #   #   label = "Get the queue size"
    #   #
    #   #   # expression (Optional)
    #   #   # 設定内容: メトリクスマス式を指定します。
    #   #   # 注意: metric_statと排他的
    #   #   expression = null
    #   #
    #   #   # return_data (Optional)
    #   #   # 設定内容: このメトリクスの生データを返すかを指定します。
    #   #   # 省略時: true
    #   #   return_data = false
    #   #
    #   #   # metric_stat (Optional)
    #   #   # CloudWatchメトリクスの統計情報を指定します。
    #   #   # expressionと排他的
    #   #   metric_stat {
    #   #     # stat (Required)
    #   #     # 設定内容: 返すメトリクスの統計を指定します。
    #   #     stat = "Sum"
    #   #
    #   #     # period (Optional)
    #   #     # 設定内容: メトリクスの期間（秒）を指定します。
    #   #     period = 60
    #   #
    #   #     # unit (Optional)
    #   #     # 設定内容: 返すメトリクスの単位を指定します。
    #   #     unit = null
    #   #
    #   #     # metric (Required)
    #   #     # CloudWatchメトリクスの定義を指定します。
    #   #     metric {
    #   #       # metric_name (Required)
    #   #       # 設定内容: メトリクス名を指定します。
    #   #       metric_name = "ApproximateNumberOfMessagesVisible"
    #   #
    #   #       # namespace (Required)
    #   #       # 設定内容: メトリクスの名前空間を指定します。
    #   #       namespace = "AWS/SQS"
    #   #
    #   #       # dimensions (Optional)
    #   #       # メトリクスのディメンションを指定します。
    #   #       dimensions {
    #   #         # name (Required)
    #   #         # 設定内容: ディメンション名を指定します。
    #   #         name = "QueueName"
    #   #
    #   #         # value (Required)
    #   #         # 設定内容: ディメンション値を指定します。
    #   #         value = "my-queue"
    #   #       }
    #   #     }
    #   #   }
    #   # }
    # }
  }

  #-------------------------------------------------------------
  # predictive_scaling_configuration（PredictiveScaling用）
  #-------------------------------------------------------------
  # 予測スケーリングの設定を定義します。
  # 機械学習に基づいて将来の需要を予測し、事前にスケーリングを実行します。

  # predictive_scaling_configuration {
  #   # mode (Optional)
  #   # 設定内容: 予測スケーリングのモードを指定します。
  #   # 設定可能な値:
  #   #   - "ForecastAndScale": 予測を生成し、実際にスケーリングを実行
  #   #   - "ForecastOnly": 予測のみを生成（スケーリングは実行しない）
  #   # 省略時: "ForecastOnly"
  #   mode = "ForecastAndScale"
  #
  #   # max_capacity_breach_behavior (Optional)
  #   # 設定内容: 予測キャパシティがAuto Scalingグループの最大キャパシティに近づいた時の動作
  #   # 設定可能な値:
  #   #   - "HonorMaxCapacity": 最大キャパシティを超えない
  #   #   - "IncreaseMaxCapacity": 必要に応じて最大キャパシティを引き上げる
  #   # 省略時: "HonorMaxCapacity"
  #   max_capacity_breach_behavior = "HonorMaxCapacity"
  #
  #   # max_capacity_buffer (Optional)
  #   # 設定内容: 予測キャパシティが最大キャパシティに近い時に使用するキャパシティバッファのサイズ
  #   # 設定可能な値: "0"～"100"（パーセンテージ）
  #   # 用途: 0に設定すると、予測キャパシティに合わせて最大キャパシティまでスケーリング可能
  #   max_capacity_buffer = null
  #
  #   # scheduling_buffer_time (Optional)
  #   # 設定内容: インスタンス起動時間を早める時間（秒）
  #   # 設定可能な値: "0"以上の数値（秒）
  #   # 用途: インスタンスの起動時間を考慮して、予測された需要より早めにスケーリングを開始
  #   scheduling_buffer_time = null
  #
  #   #---------------------------------------------------------
  #   # metric_specification (Required)
  #   #---------------------------------------------------------
  #   # 予測スケーリングで使用するメトリクスとターゲット値を定義します。
  #
  #   metric_specification {
  #     # target_value (Required)
  #     # 設定内容: スケーリングメトリクスのターゲット値を指定します。
  #     target_value = 50.0
  #
  #     #-------------------------------------------------------
  #     # predefined_metric_pair_specification（事前定義メトリクスペア）
  #     #-------------------------------------------------------
  #     # 事前定義されたロードメトリクスとスケーリングメトリクスのペアを使用
  #
  #     # predefined_metric_pair_specification {
  #     #   # predefined_metric_type (Required)
  #     #   # 設定内容: 使用する事前定義メトリクスペアのタイプを指定します。
  #     #   # 設定可能な値:
  #     #   #   - "ASGCPUUtilization": CPU使用率（ロード: 合計CPU、スケーリング: 平均CPU）
  #     #   #   - "ASGNetworkIn": ネットワーク受信（ロード: 合計、スケーリング: 平均）
  #     #   #   - "ASGNetworkOut": ネットワーク送信（ロード: 合計、スケーリング: 平均）
  #     #   #   - "ALBRequestCount": ALBリクエスト数
  #     #   predefined_metric_type = "ASGCPUUtilization"
  #     #
  #     #   # resource_label (Optional)
  #     #   # 設定内容: ALBターゲットグループを識別するリソースラベル
  #     #   # 注意: predefined_metric_typeが"ALBRequestCount"の場合に必須
  #     #   resource_label = null
  #     # }
  #
  #     #-------------------------------------------------------
  #     # predefined_load_metric_specification（事前定義ロードメトリクス）
  #     #-------------------------------------------------------
  #     # 事前定義されたロードメトリクスのみを個別に指定
  #
  #     # predefined_load_metric_specification {
  #     #   # predefined_metric_type (Required)
  #     #   # 設定内容: 使用する事前定義ロードメトリクスのタイプを指定します。
  #     #   # 設定可能な値:
  #     #   #   - "ASGTotalCPUUtilization": Auto Scalingグループの合計CPU使用率
  #     #   #   - "ASGTotalNetworkIn": Auto Scalingグループの合計ネットワーク受信
  #     #   #   - "ASGTotalNetworkOut": Auto Scalingグループの合計ネットワーク送信
  #     #   #   - "ALBTargetGroupRequestCount": ALBターゲットグループのリクエスト数
  #     #   predefined_metric_type = "ASGTotalCPUUtilization"
  #     #
  #     #   # resource_label (Optional)
  #     #   # 設定内容: ALBターゲットグループを識別するリソースラベル
  #     #   resource_label = null
  #     # }
  #
  #     #-------------------------------------------------------
  #     # predefined_scaling_metric_specification（事前定義スケーリングメトリクス）
  #     #-------------------------------------------------------
  #     # 事前定義されたスケーリングメトリクスのみを個別に指定
  #
  #     # predefined_scaling_metric_specification {
  #     #   # predefined_metric_type (Required)
  #     #   # 設定内容: 使用する事前定義スケーリングメトリクスのタイプを指定します。
  #     #   # 設定可能な値:
  #     #   #   - "ASGAverageCPUUtilization": Auto Scalingグループの平均CPU使用率
  #     #   #   - "ASGAverageNetworkIn": Auto Scalingグループの平均ネットワーク受信
  #     #   #   - "ASGAverageNetworkOut": Auto Scalingグループの平均ネットワーク送信
  #     #   #   - "ALBRequestCountPerTarget": ALBターゲットあたりのリクエスト数
  #     #   predefined_metric_type = "ASGAverageCPUUtilization"
  #     #
  #     #   # resource_label (Optional)
  #     #   # 設定内容: ALBターゲットグループを識別するリソースラベル
  #     #   resource_label = null
  #     # }
  #
  #     #-------------------------------------------------------
  #     # customized_load_metric_specification（カスタムロードメトリクス）
  #     #-------------------------------------------------------
  #     # カスタムロードメトリクスを定義
  #
  #     # customized_load_metric_specification {
  #     #   metric_data_queries {
  #     #     # id (Required)
  #     #     # 設定内容: メトリクスの一意の識別子を指定します。
  #     #     id = "load_sum"
  #     #
  #     #     # expression (Optional)
  #     #     # 設定内容: メトリクスマス式を指定します。
  #     #     # 注意: metric_statと排他的
  #     #     expression = "SUM(SEARCH('{AWS/EC2,AutoScalingGroupName} MetricName=\"CPUUtilization\" my-test-asg', 'Sum', 3600))"
  #     #
  #     #     # label (Optional)
  #     #     # 設定内容: メトリクスの人間が読みやすいラベルを指定します。
  #     #     label = null
  #     #
  #     #     # return_data (Optional)
  #     #     # 設定内容: このメトリクスの生データを返すかを指定します。
  #     #     return_data = true
  #     #
  #     #     # metric_stat (Optional)
  #     #     # CloudWatchメトリクスの統計情報を指定します。
  #     #     # expressionと排他的
  #     #     # metric_stat {
  #     #     #   # stat (Required)
  #     #     #   stat = "Sum"
  #     #     #
  #     #     #   # unit (Optional)
  #     #     #   unit = null
  #     #     #
  #     #     #   # metric (Required)
  #     #     #   metric {
  #     #     #     # metric_name (Required)
  #     #     #     metric_name = "CPUUtilization"
  #     #     #
  #     #     #     # namespace (Required)
  #     #     #     namespace = "AWS/EC2"
  #     #     #
  #     #     #     # dimensions (Optional)
  #     #     #     dimensions {
  #     #     #       name  = "AutoScalingGroupName"
  #     #     #       value = "my-test-asg"
  #     #     #     }
  #     #     #   }
  #     #     # }
  #     #   }
  #     # }
  #
  #     #-------------------------------------------------------
  #     # customized_scaling_metric_specification（カスタムスケーリングメトリクス）
  #     #-------------------------------------------------------
  #     # カスタムスケーリングメトリクスを定義
  #
  #     # customized_scaling_metric_specification {
  #     #   metric_data_queries {
  #     #     id          = "scaling"
  #     #     expression  = null
  #     #     label       = null
  #     #     return_data = true
  #     #
  #     #     metric_stat {
  #     #       stat = "Average"
  #     #       unit = null
  #     #
  #     #       metric {
  #     #         metric_name = "CPUUtilization"
  #     #         namespace   = "AWS/EC2"
  #     #
  #     #         dimensions {
  #     #           name  = "AutoScalingGroupName"
  #     #           value = "my-test-asg"
  #     #         }
  #     #       }
  #     #     }
  #     #   }
  #     # }
  #
  #     #-------------------------------------------------------
  #     # customized_capacity_metric_specification（カスタムキャパシティメトリクス）
  #     #-------------------------------------------------------
  #     # カスタムキャパシティメトリクスを定義
  #     # 注意: customized_load_metric_specificationを使用する場合のみ有効
  #
  #     # customized_capacity_metric_specification {
  #     #   metric_data_queries {
  #     #     id          = "capacity_sum"
  #     #     expression  = "SUM(SEARCH('{AWS/AutoScaling,AutoScalingGroupName} MetricName=\"GroupInServiceIntances\" my-test-asg', 'Average', 300))"
  #     #     label       = null
  #     #     return_data = true
  #     #
  #     #     # metric_stat (Optional)
  #     #     # metric_stat {
  #     #     #   stat = "Average"
  #     #     #   unit = null
  #     #     #
  #     #     #   metric {
  #     #     #     metric_name = "GroupInServiceInstances"
  #     #     #     namespace   = "AWS/AutoScaling"
  #     #     #
  #     #     #     dimensions {
  #     #     #       name  = "AutoScalingGroupName"
  #     #     #       value = "my-test-asg"
  #     #     #     }
  #     #     #   }
  #     #     # }
  #     #   }
  #     # }
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スケーリングポリシーのAmazon Resource Name (ARN)
#---------------------------------------------------------------
