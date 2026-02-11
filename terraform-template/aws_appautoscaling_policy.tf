#---------------------------------------------------------------
# AWS Application Auto Scaling Policy
#---------------------------------------------------------------
#
# Application Auto Scalingのスケーリングポリシーをプロビジョニングするリソースです。
# スケーリングポリシーは、スケーラブルターゲットに対してスケーリングアクションを
# トリガーする条件とスケーリング動作を定義します。
#
# 対応サービス: ECS, DynamoDB, Aurora, SageMaker, Comprehend, Lambda,
#               ElastiCache, Neptune, EMR, Kafka, Custom Resources など
#
# AWS公式ドキュメント:
#   - Application Auto Scaling概要: https://docs.aws.amazon.com/autoscaling/application/userguide/what-is-application-auto-scaling.html
#   - ターゲット追跡スケーリング: https://docs.aws.amazon.com/autoscaling/application/userguide/application-auto-scaling-target-tracking.html
#   - ステップスケーリング: https://docs.aws.amazon.com/autoscaling/application/userguide/application-auto-scaling-step-scaling-policies.html
#   - 予測スケーリング: https://docs.aws.amazon.com/autoscaling/application/userguide/application-auto-scaling-predictive-scaling.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appautoscaling_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: スケーリングポリシーの名前を指定します。
  # 設定可能な値: 1-255文字の文字列
  name = "example-scaling-policy"

  # resource_id (Required)
  # 設定内容: スケーリングポリシーに関連付けるリソースタイプと一意の識別子を指定します。
  # 設定可能な値: サービスに応じた形式の文字列
  #   - ECS: "service/{cluster-name}/{service-name}"
  #   - DynamoDB Table: "table/{table-name}"
  #   - DynamoDB GSI: "table/{table-name}/index/{index-name}"
  #   - Aurora: "cluster:{cluster-id}"
  #   - SageMaker: "endpoint/{endpoint-name}/variant/{variant-name}"
  #   - Lambda: "function:{function-name}:provisioned-concurrency"
  # 参考: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html
  resource_id = "service/my-cluster/my-service"

  # scalable_dimension (Required)
  # 設定内容: スケーラブルターゲットのスケーラブルディメンションを指定します。
  # 設定可能な値:
  #   - "ecs:service:DesiredCount": ECSサービスのタスク数
  #   - "dynamodb:table:ReadCapacityUnits": DynamoDBテーブルの読み取りキャパシティ
  #   - "dynamodb:table:WriteCapacityUnits": DynamoDBテーブルの書き込みキャパシティ
  #   - "dynamodb:index:ReadCapacityUnits": DynamoDB GSIの読み取りキャパシティ
  #   - "dynamodb:index:WriteCapacityUnits": DynamoDB GSIの書き込みキャパシティ
  #   - "rds:cluster:ReadReplicaCount": Auroraリードレプリカ数
  #   - "sagemaker:variant:DesiredInstanceCount": SageMakerエンドポイントのインスタンス数
  #   - "lambda:function:ProvisionedConcurrency": Lambda関数のプロビジョンド同時実行数
  # 参考: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html
  scalable_dimension = "ecs:service:DesiredCount"

  # service_namespace (Required)
  # 設定内容: スケーラブルターゲットのAWSサービス名前空間を指定します。
  # 設定可能な値:
  #   - "ecs": Amazon Elastic Container Service
  #   - "dynamodb": Amazon DynamoDB
  #   - "rds": Amazon RDS (Aurora)
  #   - "sagemaker": Amazon SageMaker
  #   - "lambda": AWS Lambda
  #   - "elasticache": Amazon ElastiCache
  #   - "neptune": Amazon Neptune
  #   - "kafka": Amazon MSK
  #   - "custom-resource": カスタムリソース
  # 参考: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html
  service_namespace = "ecs"

  # policy_type (Optional)
  # 設定内容: スケーリングポリシーのタイプを指定します。
  # 設定可能な値:
  #   - "StepScaling" (デフォルト): ステップスケーリング。アラーム違反の程度に応じて段階的にスケーリング
  #   - "TargetTrackingScaling": ターゲット追跡スケーリング。メトリクスのターゲット値を維持するよう自動調整
  #   - "PredictiveScaling": 予測スケーリング。過去のメトリクスパターンから将来の需要を予測してスケーリング
  # 注意: サービスによっては特定のポリシータイプのみサポート
  policy_type = "TargetTrackingScaling"

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
  # ターゲット追跡スケーリングポリシー設定
  # (policy_type = "TargetTrackingScaling" の場合に使用)
  #-------------------------------------------------------------

  target_tracking_scaling_policy_configuration {
    # target_value (Required)
    # 設定内容: メトリクスのターゲット値を指定します。
    # 設定可能な値: 0より大きい数値
    # 例: CPU使用率70%を維持したい場合は70を指定
    target_value = 70.0

    # disable_scale_in (Optional)
    # 設定内容: ターゲット追跡ポリシーによるスケールインを無効にするかを指定します。
    # 設定可能な値:
    #   - true: スケールインを無効化。ポリシーはスケーラブルリソースからキャパシティを削除しない
    #   - false (デフォルト): スケールインを有効化
    # 用途: スケールアウトのみを自動化し、スケールインは手動で制御したい場合
    disable_scale_in = false

    # scale_in_cooldown (Optional)
    # 設定内容: スケールインアクティビティ完了後、次のスケールインが開始できるまでの待機時間（秒）を指定します。
    # 設定可能な値: 0以上の整数
    # 省略時: デフォルトのクールダウン期間を使用
    # 用途: 頻繁なスケールイン/アウトの繰り返し（フラッピング）を防止
    scale_in_cooldown = 300

    # scale_out_cooldown (Optional)
    # 設定内容: スケールアウトアクティビティ完了後、次のスケールアウトが開始できるまでの待機時間（秒）を指定します。
    # 設定可能な値: 0以上の整数
    # 省略時: デフォルトのクールダウン期間を使用
    scale_out_cooldown = 300

    #-----------------------------------------------------------
    # 事前定義メトリクス仕様
    # (predefined_metric_specification または customized_metric_specification のいずれかを指定)
    #-----------------------------------------------------------

    predefined_metric_specification {
      # predefined_metric_type (Required)
      # 設定内容: 事前定義されたメトリクスタイプを指定します。
      # 設定可能な値 (サービスにより異なる):
      #   ECS:
      #     - "ECSServiceAverageCPUUtilization": 平均CPU使用率
      #     - "ECSServiceAverageMemoryUtilization": 平均メモリ使用率
      #   DynamoDB:
      #     - "DynamoDBReadCapacityUtilization": 読み取りキャパシティ使用率
      #     - "DynamoDBWriteCapacityUtilization": 書き込みキャパシティ使用率
      #   RDS (Aurora):
      #     - "RDSReaderAverageCPUUtilization": リーダーの平均CPU使用率
      #     - "RDSReaderAverageDatabaseConnections": リーダーの平均DB接続数
      #   ALB:
      #     - "ALBRequestCountPerTarget": ターゲット当たりのリクエスト数
      #   Lambda:
      #     - "LambdaProvisionedConcurrencyUtilization": プロビジョンド同時実行使用率
      predefined_metric_type = "ECSServiceAverageCPUUtilization"

      # resource_label (Optional)
      # 設定内容: ターゲットグループを一意に識別するラベルを指定します。
      # 設定可能な値: 1023文字以下の文字列
      # 用途: predefined_metric_typeが"ALBRequestCountPerTarget"の場合に必須
      # 形式: "app/{load-balancer-name}/{load-balancer-id}/targetgroup/{target-group-name}/{target-group-id}"
      # 参考: https://docs.aws.amazon.com/autoscaling/plans/APIReference/API_PredefinedScalingMetricSpecification.html
      resource_label = null
    }

    #-----------------------------------------------------------
    # カスタムメトリクス仕様
    # (predefined_metric_specification または customized_metric_specification のいずれかを指定)
    #-----------------------------------------------------------

    # customized_metric_specification {
    #   # --- 単一メトリクス指定方式（レガシー） ---
    #
    #   # metric_name (Optional)
    #   # 設定内容: CloudWatchメトリクスの名前を指定します。
    #   # 設定可能な値: 有効なCloudWatchメトリクス名
    #   metric_name = "CPUUtilization"
    #
    #   # namespace (Optional)
    #   # 設定内容: CloudWatchメトリクスの名前空間を指定します。
    #   # 設定可能な値: 有効なCloudWatch名前空間
    #   namespace = "AWS/ECS"
    #
    #   # statistic (Optional)
    #   # 設定内容: メトリクスの統計を指定します。
    #   # 設定可能な値:
    #   #   - "Average": 平均
    #   #   - "Minimum": 最小
    #   #   - "Maximum": 最大
    #   #   - "SampleCount": サンプル数
    #   #   - "Sum": 合計
    #   statistic = "Average"
    #
    #   # unit (Optional)
    #   # 設定内容: メトリクスの単位を指定します。
    #   # 設定可能な値: 有効なCloudWatch単位（Percent, Count, Seconds等）
    #   unit = "Percent"
    #
    #   # dimensions (Optional)
    #   # 設定内容: メトリクスのディメンションを指定します。
    #   dimensions {
    #     # name (Required)
    #     # 設定内容: ディメンション名を指定します。
    #     name = "ClusterName"
    #
    #     # value (Required)
    #     # 設定内容: ディメンション値を指定します。
    #     value = "my-cluster"
    #   }
    #
    #   # --- メトリクスマス方式（推奨） ---
    #
    #   # metrics (Optional)
    #   # 設定内容: メトリクスデータクエリを使用した高度なメトリクス指定
    #   metrics {
    #     # id (Required)
    #     # 設定内容: このメトリクスの短い識別子を指定します。
    #     # 設定可能な値: 英数字とアンダースコア、先頭は小文字
    #     id = "m1"
    #
    #     # label (Optional)
    #     # 設定内容: このメトリクスの人間が読めるラベルを指定します。
    #     label = "Get the queue size"
    #
    #     # expression (Optional)
    #     # 設定内容: 返されたデータに対して実行する数式を指定します。
    #     # 注意: expressionとmetric_statは排他的（どちらか一方のみ指定可能）
    #     expression = null
    #
    #     # return_data (Optional)
    #     # 設定内容: このメトリクスのタイムスタンプと生データを返すかを指定します。
    #     # 設定可能な値: true/false (デフォルト: true)
    #     return_data = true
    #
    #     # metric_stat (Optional)
    #     # 設定内容: 返すCloudWatchメトリクスの情報を指定します。
    #     # 注意: expressionとmetric_statは排他的
    #     metric_stat {
    #       # stat (Required)
    #       # 設定内容: メトリクスの統計を指定します。
    #       stat = "Sum"
    #
    #       # unit (Optional)
    #       # 設定内容: 返されるデータポイントの単位を指定します。
    #       unit = null
    #
    #       # metric (Required)
    #       # 設定内容: CloudWatchメトリクスの詳細を指定します。
    #       metric {
    #         # metric_name (Required)
    #         # 設定内容: メトリクス名を指定します。
    #         metric_name = "ApproximateNumberOfMessagesVisible"
    #
    #         # namespace (Required)
    #         # 設定内容: メトリクスの名前空間を指定します。
    #         namespace = "AWS/SQS"
    #
    #         # dimensions (Optional)
    #         # 設定内容: メトリクスのディメンションを指定します。
    #         dimensions {
    #           name  = "QueueName"
    #           value = "my-queue"
    #         }
    #       }
    #     }
    #   }
    # }
  }

  #-------------------------------------------------------------
  # ステップスケーリングポリシー設定
  # (policy_type = "StepScaling" の場合に使用)
  #-------------------------------------------------------------

  # step_scaling_policy_configuration {
  #   # adjustment_type (Optional)
  #   # 設定内容: 調整値が絶対数かキャパシティに対する割合かを指定します。
  #   # 設定可能な値:
  #   #   - "ChangeInCapacity": 現在のキャパシティに対する増減値
  #   #   - "ExactCapacity": 設定するキャパシティの絶対値
  #   #   - "PercentChangeInCapacity": 現在のキャパシティに対する増減割合
  #   adjustment_type = "ChangeInCapacity"
  #
  #   # cooldown (Optional)
  #   # 設定内容: スケーリングアクティビティ完了後、次のスケーリングが開始できるまでの待機時間（秒）を指定します。
  #   # 設定可能な値: 0以上の整数
  #   cooldown = 60
  #
  #   # metric_aggregation_type (Optional)
  #   # 設定内容: ポリシーのメトリクスの集計タイプを指定します。
  #   # 設定可能な値:
  #   #   - "Minimum": 最小値
  #   #   - "Maximum": 最大値
  #   #   - "Average" (デフォルト): 平均値
  #   metric_aggregation_type = "Maximum"
  #
  #   # min_adjustment_magnitude (Optional)
  #   # 設定内容: スケーリングアクティビティの結果としてスケーラブルディメンションを調整する最小値を指定します。
  #   # 設定可能な値: 1以上の整数
  #   # 用途: adjustment_typeがPercentChangeInCapacityの場合に使用
  #   min_adjustment_magnitude = null
  #
  #   # step_adjustment (Optional)
  #   # 設定内容: スケーリングを管理する調整のセットを指定します。
  #   step_adjustment {
  #     # metric_interval_lower_bound (Optional)
  #     # 設定内容: アラームしきい値とCloudWatchメトリクスの差の下限を指定します。
  #     # 設定可能な値: 数値（省略時は負の無限大として扱われる）
  #     metric_interval_lower_bound = null
  #
  #     # metric_interval_upper_bound (Optional)
  #     # 設定内容: アラームしきい値とCloudWatchメトリクスの差の上限を指定します。
  #     # 設定可能な値: 数値（省略時は正の無限大として扱われる）
  #     # 注意: 上限は下限より大きくなければならない
  #     metric_interval_upper_bound = 0
  #
  #     # scaling_adjustment (Required)
  #     # 設定内容: 調整境界が突破されたときにスケールするメンバー数を指定します。
  #     # 設定可能な値: 正の値でスケールアップ、負の値でスケールダウン
  #     scaling_adjustment = -1
  #   }
  #
  #   step_adjustment {
  #     metric_interval_lower_bound = 0
  #     metric_interval_upper_bound = 10
  #     scaling_adjustment          = 1
  #   }
  #
  #   step_adjustment {
  #     metric_interval_lower_bound = 10
  #     scaling_adjustment          = 3
  #   }
  # }

  #-------------------------------------------------------------
  # 予測スケーリングポリシー設定
  # (policy_type = "PredictiveScaling" の場合に使用)
  #-------------------------------------------------------------

  # predictive_scaling_policy_configuration {
  #   # max_capacity_breach_behavior (Optional)
  #   # 設定内容: 予測キャパシティが最大キャパシティに近づいたり超えたりした場合の動作を指定します。
  #   # 設定可能な値:
  #   #   - "HonorMaxCapacity": 最大キャパシティを尊重（超えない）
  #   #   - "IncreaseMaxCapacity": 必要に応じて最大キャパシティを一時的に増加
  #   max_capacity_breach_behavior = "HonorMaxCapacity"
  #
  #   # max_capacity_buffer (Optional)
  #   # 設定内容: 予測キャパシティが最大キャパシティに近い場合に使用するキャパシティバッファのサイズを指定します。
  #   # 設定可能な値: 予測キャパシティに対する割合（パーセント）
  #   # 用途: max_capacity_breach_behaviorが"IncreaseMaxCapacity"の場合に必須
  #   max_capacity_buffer = null
  #
  #   # mode (Optional)
  #   # 設定内容: 予測スケーリングモードを指定します。
  #   # 設定可能な値:
  #   #   - "ForecastOnly": 予測のみ（スケーリングアクションは実行しない）
  #   #   - "ForecastAndScale": 予測に基づいてスケーリングを実行
  #   mode = "ForecastAndScale"
  #
  #   # scheduling_buffer_time (Optional)
  #   # 設定内容: 開始時刻を前倒しできる時間（秒）を指定します。
  #   # 設定可能な値: 0以上の整数
  #   # 用途: 予測されたキャパシティが実際に必要になる前にリソースを準備
  #   scheduling_buffer_time = null
  #
  #   # metric_specification (Required)
  #   # 設定内容: 予測スケーリングに使用するメトリクスとターゲット使用率を指定します。
  #   metric_specification {
  #     # target_value (Required)
  #     # 設定内容: ターゲット使用率を指定します。
  #     # 設定可能な値: 文字列形式の数値
  #     target_value = "40"
  #
  #     #---------------------------------------------------------
  #     # 事前定義メトリクスペア仕様
  #     # (適切なスケーリングメトリクスとロードメトリクスを自動的に選択)
  #     #---------------------------------------------------------
  #
  #     predefined_metric_pair_specification {
  #       # predefined_metric_type (Required)
  #       # 設定内容: 使用するメトリクスを指定します。
  #       # 設定可能な値:
  #       #   - "ECSServiceAverageCPUUtilization": ECS CPU使用率
  #       #   - "ECSServiceAverageMemoryUtilization": ECSメモリ使用率
  #       predefined_metric_type = "ECSServiceMemoryUtilization"
  #
  #       # resource_label (Optional)
  #       # 設定内容: ターゲットグループを一意に識別するラベルを指定します。
  #       resource_label = null
  #     }
  #
  #     #---------------------------------------------------------
  #     # 事前定義ロードメトリクス仕様
  #     # (カスタマイズされた予測スケーリング構成用)
  #     #---------------------------------------------------------
  #
  #     # predefined_load_metric_specification {
  #     #   # predefined_metric_type (Required)
  #     #   # 設定内容: ロードメトリクスタイプを指定します。
  #     #   predefined_metric_type = "ECSServiceAverageMemoryUtilization"
  #     #
  #     #   # resource_label (Optional)
  #     #   # 設定内容: ターゲットグループを一意に識別するラベルを指定します。
  #     #   resource_label = null
  #     # }
  #
  #     #---------------------------------------------------------
  #     # 事前定義スケーリングメトリクス仕様
  #     # (カスタマイズされた予測スケーリング構成用)
  #     #---------------------------------------------------------
  #
  #     # predefined_scaling_metric_specification {
  #     #   # predefined_metric_type (Required)
  #     #   # 設定内容: スケーリングメトリクスタイプを指定します。
  #     #   predefined_metric_type = "ECSServiceAverageCPUUtilization"
  #     #
  #     #   # resource_label (Optional)
  #     #   # 設定内容: ターゲットグループを一意に識別するラベルを指定します。
  #     #   resource_label = null
  #     # }
  #
  #     #---------------------------------------------------------
  #     # カスタムキャパシティメトリクス仕様
  #     # (カスタムメトリクスを使用してキャパシティを予測)
  #     #---------------------------------------------------------
  #
  #     # customized_capacity_metric_specification {
  #     #   metric_data_query {
  #     #     # id (Required)
  #     #     # 設定内容: レスポンスでオブジェクトの結果を識別する短い名前を指定します。
  #     #     id = "capacity1"
  #     #
  #     #     # expression (Optional)
  #     #     # 設定内容: 返されたデータに対して実行する数式を指定します。
  #     #     expression = null
  #     #
  #     #     # label (Optional)
  #     #     # 設定内容: このメトリクスまたは式の人間が読めるラベルを指定します。
  #     #     label = null
  #     #
  #     #     # return_data (Optional)
  #     #     # 設定内容: このメトリクスのタイムスタンプと生データを返すかを指定します。
  #     #     return_data = true
  #     #
  #     #     metric_stat {
  #     #       stat = "Average"
  #     #       unit = null
  #     #
  #     #       metric {
  #     #         metric_name = "DesiredTaskCount"
  #     #         namespace   = "ECS/ContainerInsights"
  #     #
  #     #         dimension {
  #     #           name  = "ClusterName"
  #     #           value = "my-cluster"
  #     #         }
  #     #         dimension {
  #     #           name  = "ServiceName"
  #     #           value = "my-service"
  #     #         }
  #     #       }
  #     #     }
  #     #   }
  #     # }
  #
  #     #---------------------------------------------------------
  #     # カスタムロードメトリクス仕様
  #     # (カスタムメトリクスを使用してロードを測定)
  #     #---------------------------------------------------------
  #
  #     # customized_load_metric_specification {
  #     #   metric_data_query {
  #     #     id = "load1"
  #     #     # ... (customized_capacity_metric_specificationと同じ構造)
  #     #   }
  #     # }
  #
  #     #---------------------------------------------------------
  #     # カスタムスケーリングメトリクス仕様
  #     # (カスタムメトリクスを使用してスケーリングを決定)
  #     #---------------------------------------------------------
  #
  #     # customized_scaling_metric_specification {
  #     #   metric_data_query {
  #     #     id = "scaling1"
  #     #     # ... (customized_capacity_metric_specificationと同じ構造)
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
# - arn: AWSによって割り当てられたスケーリングポリシーのARN
#
# - alarm_arns: スケーリングポリシーに関連付けられたCloudWatchアラームのARNのリスト
#
# - name: スケーリングポリシーの名前
#
# - policy_type: スケーリングポリシーのタイプ
#---------------------------------------------------------------
