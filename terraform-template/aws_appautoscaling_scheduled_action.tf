#---------------------------------------------------------------
# AWS Application Auto Scaling Scheduled Action
#---------------------------------------------------------------
#
# Application Auto Scalingのスケジュールアクションをプロビジョニングするリソースです。
# スケジュールアクションを使用すると、予測可能な負荷変動に基づいて、特定の日時に
# スケーラブルターゲットの最小/最大キャパシティを自動的に調整できます。
#
# AWS公式ドキュメント:
#   - Scheduled scaling for Application Auto Scaling: https://docs.aws.amazon.com/autoscaling/application/userguide/application-auto-scaling-scheduled-scaling.html
#   - PutScheduledAction API Reference: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_PutScheduledAction.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_scheduled_action
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appautoscaling_scheduled_action" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: スケジュールアクションの名前を指定します。
  # 設定可能な値: 文字列。同一スケーラブルターゲット内で一意である必要があります。
  name = "my-scheduled-action"

  # service_namespace (Required)
  # 設定内容: AWSサービスの名前空間を指定します。
  # 設定可能な値:
  #   - "appstream": Amazon AppStream 2.0
  #   - "comprehend": Amazon Comprehend
  #   - "custom-resource": カスタムリソース
  #   - "dynamodb": Amazon DynamoDB
  #   - "ec2": Amazon EC2 Spot Fleet
  #   - "ecs": Amazon ECS
  #   - "elasticache": Amazon ElastiCache
  #   - "elasticmapreduce": Amazon EMR
  #   - "kafka": Amazon Managed Streaming for Apache Kafka (MSK)
  #   - "lambda": AWS Lambda
  #   - "neptune": Amazon Neptune
  #   - "rds": Amazon RDS
  #   - "sagemaker": Amazon SageMaker
  #   - "workspaces": Amazon WorkSpaces
  # 参考: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_PutScheduledAction.html
  service_namespace = "ecs"

  # resource_id (Required)
  # 設定内容: スケジュールアクションに関連付けるリソースの識別子を指定します。
  # 設定可能な値: サービスによって異なるフォーマット
  #   - ECS: "service/{clusterName}/{serviceName}"
  #   - DynamoDB Table: "table/{tableName}"
  #   - DynamoDB GSI: "table/{tableName}/index/{indexName}"
  #   - Spot Fleet: "spot-fleet-request/{spotFleetRequestId}"
  #   - Lambda: "function:{functionName}:{alias}" または "function:{functionName}"
  #   - RDS: "cluster:{clusterIdentifier}"
  # 参考: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_PutScheduledAction.html
  resource_id = "service/my-cluster/my-service"

  # scalable_dimension (Required)
  # 設定内容: スケーリング対象のディメンションを指定します。
  # 設定可能な値: サービスによって異なる
  #   - ECS: "ecs:service:DesiredCount"
  #   - DynamoDB Table: "dynamodb:table:ReadCapacityUnits", "dynamodb:table:WriteCapacityUnits"
  #   - DynamoDB GSI: "dynamodb:index:ReadCapacityUnits", "dynamodb:index:WriteCapacityUnits"
  #   - Spot Fleet: "ec2:spot-fleet-request:TargetCapacity"
  #   - Lambda: "lambda:function:ProvisionedConcurrency"
  #   - RDS: "rds:cluster:ReadReplicaCount"
  # 参考: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_PutScheduledAction.html
  scalable_dimension = "ecs:service:DesiredCount"

  # schedule (Required)
  # 設定内容: スケジュールアクションの実行スケジュールを指定します。
  # 設定可能な値:
  #   - At式: at(yyyy-mm-ddThh:mm:ss) - 1回のみ実行
  #     例: "at(2024-01-15T09:00:00)"
  #   - Rate式: rate(value unit) - 定期的な間隔で実行
  #     例: "rate(1 hour)", "rate(5 minutes)", "rate(1 day)"
  #   - Cron式: cron(fields) - 定期的なスケジュールで実行
  #     例: "cron(0 9 * * ? *)" - 毎日9:00に実行
  # 注意: at式およびcron式の時刻は timezone で指定したタイムゾーンで評価されます。
  # 参考: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_PutScheduledAction.html
  schedule = "cron(0 9 * * ? *)"

  #-------------------------------------------------------------
  # スケーラブルターゲットアクション（必須）
  #-------------------------------------------------------------

  # scalable_target_action (Required)
  # 設定内容: スケジュールアクション実行時に設定する最小/最大キャパシティを指定します。
  # 注意: min_capacity または max_capacity の少なくとも一方を指定する必要があります。
  scalable_target_action {
    # min_capacity (Optional)
    # 設定内容: スケーラブルターゲットの最小キャパシティを指定します。
    # 設定可能な値: 0以上の整数（文字列として指定）
    # 注意: max_capacity との少なくとも一方を指定する必要があります。
    min_capacity = "2"

    # max_capacity (Optional)
    # 設定内容: スケーラブルターゲットの最大キャパシティを指定します。
    # 設定可能な値: 0以上の整数（文字列として指定）
    # 注意: min_capacity との少なくとも一方を指定する必要があります。
    max_capacity = "10"
  }

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # start_time (Optional)
  # 設定内容: スケジュールアクションが有効になる開始日時を指定します。
  # 設定可能な値: RFC 3339形式の日時文字列
  #   例: "2024-01-15T00:00:00Z"
  # 注意: タイムゾーンは timezone 設定の影響を受けません（常にUTCで評価）。
  start_time = null

  # end_time (Optional)
  # 設定内容: スケジュールアクションが無効になる終了日時を指定します。
  # 設定可能な値: RFC 3339形式の日時文字列
  #   例: "2024-12-31T23:59:59Z"
  # 注意: タイムゾーンは timezone 設定の影響を受けません（常にUTCで評価）。
  end_time = null

  # timezone (Optional)
  # 設定内容: at式またはcron式で使用するタイムゾーンを指定します。
  # 設定可能な値: IANA Time Zone Database形式のタイムゾーン名
  #   例: "Asia/Tokyo", "America/New_York", "Europe/London", "Etc/GMT+9", "Pacific/Tahiti"
  # 省略時: "UTC"
  # 注意: start_time および end_time のタイムゾーンには影響しません。
  # 参考: https://www.joda.org/joda-time/timezones.html
  timezone = "Asia/Tokyo"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スケジュールアクションのAmazon Resource Name (ARN)
#
#---------------------------------------------------------------
