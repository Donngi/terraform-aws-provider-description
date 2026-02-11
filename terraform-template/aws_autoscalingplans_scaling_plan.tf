#---------------------------------------------------------------
# AWS Auto Scaling Plan
#---------------------------------------------------------------
#
# AWS Auto Scalingスケーリングプランをプロビジョニングするリソースです。
# スケーリングプランは、Auto Scalingグループ、ECSサービス、DynamoDBテーブル/
# インデックス、Spot Fleet等のスケーラブルなリソースに対して、
# 動的スケーリングや予測スケーリングを設定します。
#
# AWS公式ドキュメント:
#   - AWS Auto Scaling User Guide: https://docs.aws.amazon.com/autoscaling/plans/userguide/what-is-aws-auto-scaling.html
#   - Scaling Instructions API: https://docs.aws.amazon.com/autoscaling/plans/APIReference/API_ScalingInstruction.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscalingplans_scaling_plan
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 備考: 予測スケーリングを有効にしたスケーリングプランを初めて作成すると、
#       AWSはIAMサービスリンクロールを自動的に作成しようとします。
#       手動で管理する場合は aws_iam_service_linked_role リソースを使用してください。
#       https://docs.aws.amazon.com/autoscaling/plans/userguide/aws-auto-scaling-service-linked-roles.html
#
#---------------------------------------------------------------

resource "aws_autoscalingplans_scaling_plan" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: スケーリングプランの名前を指定します。
  # 設定可能な値: 文字列（垂直バー、コロン、スラッシュを含めることはできません）
  name = "example-scaling-plan"

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
  # application_source (Required)
  #-------------------------------------------------------------
  # スケーリング対象となるアプリケーションソースを定義します。
  # CloudFormationスタックまたはタグフィルターのいずれかを指定します。
  # 1つのアプリケーションソースにつき1つのスケーリングプランのみ作成可能です。
  #-------------------------------------------------------------

  application_source {
    # cloudformation_stack_arn (Optional)
    # 設定内容: AWS CloudFormationスタックのARNを指定します。
    # 設定可能な値: 有効なCloudFormationスタックARN
    # 注意: tag_filterと排他的に使用（どちらか一方を指定）
    cloudformation_stack_arn = null

    # tag_filter (Optional)
    # 設定内容: スケーリング対象リソースを識別するためのタグフィルターを指定します。
    # 注意: cloudformation_stack_arnと排他的に使用（どちらか一方を指定）
    # 最大50個まで指定可能
    tag_filter {
      # key (Required)
      # 設定内容: タグのキーを指定します。
      key = "application"

      # values (Optional)
      # 設定内容: タグの値のセットを指定します。
      # 設定可能な値: 文字列のセット
      values = ["example"]
    }
  }

  #-------------------------------------------------------------
  # scaling_instruction (Required)
  #-------------------------------------------------------------
  # スケーリング対象リソースごとのスケーリング設定を定義します。
  # 複数のscaling_instructionブロックを指定することで、
  # 複数のリソースに対するスケーリングを設定できます。
  # 詳細: https://docs.aws.amazon.com/autoscaling/plans/APIReference/API_ScalingInstruction.html
  #-------------------------------------------------------------

  scaling_instruction {
    #-----------------------------------------------------------
    # スケーリング対象リソースの識別
    #-----------------------------------------------------------

    # service_namespace (Required)
    # 設定内容: AWSサービスの名前空間を指定します。
    # 設定可能な値:
    #   - "autoscaling": Auto Scalingグループ
    #   - "dynamodb": DynamoDBテーブル/インデックス
    #   - "ecs": ECSサービス
    #   - "ec2": EC2 Spot Fleet
    #   - "rds": RDS Auroraリードレプリカ
    service_namespace = "autoscaling"

    # resource_id (Required)
    # 設定内容: スケーリング対象リソースのIDを指定します。
    # 設定可能な値: リソースタイプと一意の識別子で構成される文字列
    # 例:
    #   - Auto Scaling: "autoScalingGroup/my-asg-name"
    #   - DynamoDB Table: "table/my-table-name"
    #   - DynamoDB GSI: "table/my-table-name/index/my-index-name"
    #   - ECS: "service/my-cluster-name/my-service-name"
    #   - Spot Fleet: "spot-fleet-request/sfr-12345678-1234-1234-1234-123456789012"
    #   - RDS: "cluster:my-cluster-id"
    resource_id = "autoScalingGroup/my-asg-name"

    # scalable_dimension (Required)
    # 設定内容: スケーリング対象のディメンション（スケール可能な属性）を指定します。
    # 設定可能な値:
    #   - "autoscaling:autoScalingGroup:DesiredCapacity": Auto Scalingグループの希望キャパシティ
    #   - "dynamodb:index:ReadCapacityUnits": DynamoDBインデックスの読み取りキャパシティ
    #   - "dynamodb:index:WriteCapacityUnits": DynamoDBインデックスの書き込みキャパシティ
    #   - "dynamodb:table:ReadCapacityUnits": DynamoDBテーブルの読み取りキャパシティ
    #   - "dynamodb:table:WriteCapacityUnits": DynamoDBテーブルの書き込みキャパシティ
    #   - "ecs:service:DesiredCount": ECSサービスの希望タスク数
    #   - "ec2:spot-fleet-request:TargetCapacity": Spot Fleetのターゲットキャパシティ
    #   - "rds:cluster:ReadReplicaCount": RDSクラスターのリードレプリカ数
    scalable_dimension = "autoscaling:autoScalingGroup:DesiredCapacity"

    #-----------------------------------------------------------
    # キャパシティ設定
    #-----------------------------------------------------------

    # min_capacity (Required)
    # 設定内容: リソースの最小キャパシティを指定します。
    # 設定可能な値: 0以上の整数
    min_capacity = 0

    # max_capacity (Required)
    # 設定内容: リソースの最大キャパシティを指定します。
    # 設定可能な値: min_capacity以上の整数
    # 注意: predictive_scaling_max_capacity_behaviorがデフォルト以外の場合、
    #       この上限を超える可能性があります。
    max_capacity = 3

    #-----------------------------------------------------------
    # 動的スケーリング設定
    #-----------------------------------------------------------

    # disable_dynamic_scaling (Optional)
    # 設定内容: AWS Auto Scalingによる動的スケーリングを無効にするかを指定します。
    # 設定可能な値:
    #   - true: 動的スケーリングを無効化（予測スケーリングのみ使用）
    #   - false (デフォルト): 動的スケーリングを有効化
    disable_dynamic_scaling = false

    # scaling_policy_update_behavior (Optional)
    # 設定内容: 外部で作成されたスケーリングポリシーの扱いを指定します。
    # 設定可能な値:
    #   - "KeepExternalPolicies" (デフォルト): 外部ポリシーを保持
    #   - "ReplaceExternalPolicies": 外部ポリシーを置き換え
    scaling_policy_update_behavior = "KeepExternalPolicies"

    # scheduled_action_buffer_time (Optional)
    # 設定内容: スケジュールされたスケーリングアクションの実行時間を
    #           バッファリングする秒数を指定します（スケールアウト時）。
    # 設定可能な値: 秒数（整数）
    scheduled_action_buffer_time = null

    #-----------------------------------------------------------
    # 予測スケーリング設定
    #-----------------------------------------------------------

    # predictive_scaling_mode (Optional)
    # 設定内容: 予測スケーリングのモードを指定します。
    # 設定可能な値:
    #   - "ForecastAndScale": 予測に基づいてスケーリングを実行
    #   - "ForecastOnly": 予測のみ実行（スケーリングは実行しない）
    predictive_scaling_mode = null

    # predictive_scaling_max_capacity_behavior (Optional)
    # 設定内容: 予測キャパシティがmax_capacityに近い/超える場合の動作を指定します。
    # 設定可能な値:
    #   - "SetForecastCapacityToMaxCapacity": 予測キャパシティをmax_capacityに設定
    #   - "SetMaxCapacityAboveForecastCapacity": max_capacityを予測キャパシティ以上に設定
    #   - "SetMaxCapacityToForecastCapacity": max_capacityを予測キャパシティに設定
    predictive_scaling_max_capacity_behavior = null

    # predictive_scaling_max_capacity_buffer (Optional)
    # 設定内容: 予測キャパシティがmax_capacityに近い/超える場合に使用する
    #           キャパシティバッファのサイズを指定します。
    # 設定可能な値: 整数（パーセンテージ）
    predictive_scaling_max_capacity_buffer = null

    #-----------------------------------------------------------
    # target_tracking_configuration (Required)
    #-----------------------------------------------------------
    # ターゲット追跡スケーリングの設定を定義します。
    # 最大10個まで指定可能です。
    # 詳細: https://docs.aws.amazon.com/autoscaling/plans/APIReference/API_TargetTrackingConfiguration.html
    #-----------------------------------------------------------

    target_tracking_configuration {
      # target_value (Required)
      # 設定内容: メトリクスのターゲット値を指定します。
      # 設定可能な値: 数値（メトリクスに応じた適切な値）
      # 例: CPU使用率70%をターゲットにする場合は70を指定
      target_value = 70

      # disable_scale_in (Optional)
      # 設定内容: ターゲット追跡スケーリングポリシーによるスケールインを無効にするかを指定します。
      # 設定可能な値:
      #   - true: スケールインを無効化
      #   - false (デフォルト): スケールインを有効化
      disable_scale_in = false

      # estimated_instance_warmup (Optional)
      # 設定内容: 新しく起動されたインスタンスがCloudWatchメトリクスに
      #           貢献するまでの推定秒数を指定します。
      # 設定可能な値: 秒数（整数）
      # 注意: この値はリソースがAuto Scalingグループの場合のみ使用されます。
      estimated_instance_warmup = null

      # scale_in_cooldown (Optional)
      # 設定内容: スケールインアクティビティ完了後、
      #           次のスケールインアクティビティを開始できるまでの秒数を指定します。
      # 設定可能な値: 秒数（整数）
      # 注意: この値はスケーラブルリソースがAuto Scalingグループでない場合に使用されます。
      scale_in_cooldown = null

      # scale_out_cooldown (Optional)
      # 設定内容: スケールアウトアクティビティ完了後、
      #           次のスケールアウトアクティビティを開始できるまでの秒数を指定します。
      # 設定可能な値: 秒数（整数）
      # 注意: この値はスケーラブルリソースがAuto Scalingグループでない場合に使用されます。
      scale_out_cooldown = null

      #---------------------------------------------------------
      # predefined_scaling_metric_specification (Optional)
      #---------------------------------------------------------
      # 事前定義されたスケーリングメトリクスを使用する場合に指定します。
      # customized_scaling_metric_specificationと排他的
      # (どちらか一方のみ指定可能)
      # 詳細: https://docs.aws.amazon.com/autoscaling/plans/APIReference/API_PredefinedScalingMetricSpecification.html
      #---------------------------------------------------------

      predefined_scaling_metric_specification {
        # predefined_scaling_metric_type (Required)
        # 設定内容: 事前定義されたスケーリングメトリクスのタイプを指定します。
        # 設定可能な値:
        #   - "ALBRequestCountPerTarget": ALBターゲットあたりのリクエスト数
        #   - "ASGAverageCPUUtilization": Auto Scalingグループの平均CPU使用率
        #   - "ASGAverageNetworkIn": Auto Scalingグループの平均ネットワーク入力
        #   - "ASGAverageNetworkOut": Auto Scalingグループの平均ネットワーク出力
        #   - "DynamoDBReadCapacityUtilization": DynamoDB読み取りキャパシティ使用率
        #   - "DynamoDBWriteCapacityUtilization": DynamoDB書き込みキャパシティ使用率
        #   - "ECSServiceAverageCPUUtilization": ECSサービスの平均CPU使用率
        #   - "ECSServiceAverageMemoryUtilization": ECSサービスの平均メモリ使用率
        #   - "EC2SpotFleetRequestAverageCPUUtilization": Spot Fleetの平均CPU使用率
        #   - "EC2SpotFleetRequestAverageNetworkIn": Spot Fleetの平均ネットワーク入力
        #   - "EC2SpotFleetRequestAverageNetworkOut": Spot Fleetの平均ネットワーク出力
        #   - "RDSReaderAverageCPUUtilization": RDSリーダーの平均CPU使用率
        #   - "RDSReaderAverageDatabaseConnections": RDSリーダーの平均DB接続数
        predefined_scaling_metric_type = "ASGAverageCPUUtilization"

        # resource_label (Optional)
        # 設定内容: メトリクスタイプに関連付けられたリソースを識別します。
        # 設定可能な値: リソースラベル文字列
        # 注意: ALBRequestCountPerTargetでのみ必要
        #       形式: "app/my-alb/50dc6c495c0c9188/targetgroup/my-target-group/50dc6c495c0c9188"
        resource_label = null
      }

      #---------------------------------------------------------
      # customized_scaling_metric_specification (Optional)
      #---------------------------------------------------------
      # カスタムスケーリングメトリクスを使用する場合に指定します。
      # predefined_scaling_metric_specificationと排他的
      # (どちらか一方のみ指定可能)
      # 詳細: https://docs.aws.amazon.com/autoscaling/plans/APIReference/API_CustomizedScalingMetricSpecification.html
      #
      # customized_scaling_metric_specification {
      #   # metric_name (Required)
      #   # 設定内容: メトリクスの名前を指定します。
      #   metric_name = "MyCustomMetric"
      #
      #   # namespace (Required)
      #   # 設定内容: メトリクスの名前空間を指定します。
      #   namespace = "MyNamespace"
      #
      #   # statistic (Required)
      #   # 設定内容: メトリクスの統計を指定します。
      #   # 設定可能な値: "Average", "Maximum", "Minimum", "SampleCount", "Sum"
      #   statistic = "Average"
      #
      #   # dimensions (Optional)
      #   # 設定内容: メトリクスのディメンションを指定します。
      #   # 設定可能な値: キーと値のマップ
      #   dimensions = {
      #     "DimensionName" = "DimensionValue"
      #   }
      #
      #   # unit (Optional)
      #   # 設定内容: メトリクスの単位を指定します。
      #   unit = null
      # }
      #---------------------------------------------------------
    }

    #-----------------------------------------------------------
    # predefined_load_metric_specification (Optional)
    #-----------------------------------------------------------
    # 事前定義された負荷メトリクスを使用した予測スケーリングを設定します。
    # 予測スケーリングを使用する場合、predefined_load_metric_specification
    # または customized_load_metric_specification のいずれかを指定する必要があります。
    # 詳細: https://docs.aws.amazon.com/autoscaling/plans/APIReference/API_PredefinedLoadMetricSpecification.html
    #
    # predefined_load_metric_specification {
    #   # predefined_load_metric_type (Required)
    #   # 設定内容: 事前定義された負荷メトリクスのタイプを指定します。
    #   # 設定可能な値:
    #   #   - "ALBTargetGroupRequestCount": ALBターゲットグループのリクエスト数
    #   #   - "ASGTotalCPUUtilization": Auto Scalingグループの合計CPU使用率
    #   #   - "ASGTotalNetworkIn": Auto Scalingグループの合計ネットワーク入力
    #   #   - "ASGTotalNetworkOut": Auto Scalingグループの合計ネットワーク出力
    #   predefined_load_metric_type = "ASGTotalCPUUtilization"
    #
    #   # resource_label (Optional)
    #   # 設定内容: メトリクスタイプに関連付けられたリソースを識別します。
    #   # 設定可能な値: リソースラベル文字列
    #   resource_label = null
    # }
    #-----------------------------------------------------------

    #-----------------------------------------------------------
    # customized_load_metric_specification (Optional)
    #-----------------------------------------------------------
    # カスタム負荷メトリクスを使用した予測スケーリングを設定します。
    # 予測スケーリングを使用する場合、customized_load_metric_specification
    # または predefined_load_metric_specification のいずれかを指定する必要があります。
    # 詳細: https://docs.aws.amazon.com/autoscaling/plans/APIReference/API_CustomizedLoadMetricSpecification.html
    #
    # customized_load_metric_specification {
    #   # metric_name (Required)
    #   # 設定内容: メトリクスの名前を指定します。
    #   metric_name = "MyCustomLoadMetric"
    #
    #   # namespace (Required)
    #   # 設定内容: メトリクスの名前空間を指定します。
    #   namespace = "MyNamespace"
    #
    #   # statistic (Required)
    #   # 設定内容: メトリクスの統計を指定します。
    #   # 設定可能な値: 現在、値は常に "Sum" である必要があります。
    #   statistic = "Sum"
    #
    #   # dimensions (Optional)
    #   # 設定内容: メトリクスのディメンションを指定します。
    #   # 設定可能な値: キーと値のマップ
    #   dimensions = {
    #     "DimensionName" = "DimensionValue"
    #   }
    #
    #   # unit (Optional)
    #   # 設定内容: メトリクスの単位を指定します。
    #   unit = null
    # }
    #-----------------------------------------------------------
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: スケーリングプランの識別子
#
# - scaling_plan_version: スケーリングプランのバージョン番号
#                         この値は常に1です。
#---------------------------------------------------------------
