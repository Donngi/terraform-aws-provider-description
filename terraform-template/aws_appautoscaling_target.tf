#---------------------------------------------------------------
# AWS Application Auto Scaling Target
#---------------------------------------------------------------
#
# Application Auto Scalingのスケーラブルターゲットをプロビジョニングするリソースです。
# スケーラブルターゲットは、自動スケーリングを適用するリソースを定義します。
# ECSサービス、DynamoDBテーブル、Aurora DBクラスター、Lambda関数など、
# 様々なAWSサービスのリソースをスケーリング対象として登録できます。
#
# AWS公式ドキュメント:
#   - Application Auto Scaling概要: https://docs.aws.amazon.com/autoscaling/application/userguide/what-is-application-auto-scaling.html
#   - Application Auto Scalingの概念: https://docs.aws.amazon.com/autoscaling/application/userguide/getting-started.html
#   - RegisterScalableTarget API: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appautoscaling_target" "example" {
  #-------------------------------------------------------------
  # サービス名前空間設定
  #-------------------------------------------------------------

  # service_namespace (Required)
  # 設定内容: スケーラブルターゲットのAWSサービス名前空間を指定します。
  # 設定可能な値:
  #   - "ecs": Amazon ECS
  #   - "elasticmapreduce": Amazon EMR
  #   - "ec2": Amazon EC2 (Spot Fleet)
  #   - "appstream": Amazon AppStream 2.0
  #   - "dynamodb": Amazon DynamoDB
  #   - "rds": Amazon RDS (Aurora)
  #   - "sagemaker": Amazon SageMaker
  #   - "custom-resource": カスタムリソース
  #   - "comprehend": Amazon Comprehend
  #   - "lambda": AWS Lambda
  #   - "cassandra": Amazon Keyspaces
  #   - "kafka": Amazon MSK
  #   - "elasticache": Amazon ElastiCache
  #   - "neptune": Amazon Neptune
  #   - "workspaces": Amazon WorkSpaces
  # 参考: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html#API_RegisterScalableTarget_RequestParameters
  service_namespace = "ecs"

  #-------------------------------------------------------------
  # リソースID設定
  #-------------------------------------------------------------

  # resource_id (Required)
  # 設定内容: スケーリングポリシーに関連付けるリソースの一意識別子を指定します。
  # 設定可能な値: リソースタイプに応じた形式の文字列
  #   - ECSサービス: "service/{クラスター名}/{サービス名}"
  #   - Spot Fleet: "spot-fleet-request/{リクエストID}"
  #   - EMRインスタンスグループ: "instancegroup/{クラスターID}/{インスタンスグループID}"
  #   - AppStream 2.0フリート: "fleet/{フリート名}"
  #   - DynamoDBテーブル: "table/{テーブル名}"
  #   - DynamoDB GSI: "table/{テーブル名}/index/{インデックス名}"
  #   - Aurora DBクラスター: "cluster:{クラスター名}"
  #   - SageMakerエンドポイントバリアント: "endpoint/{エンドポイント名}/variant/{バリアント名}"
  #   - Lambda関数: "function:{関数名}:{エイリアスまたはバージョン}"
  #   - Keyspacesテーブル: "keyspace/{キースペース名}/table/{テーブル名}"
  #   - MSKクラスター: クラスターARN
  #   - ElastiCacheレプリケーショングループ: "replication-group/{グループ名}"
  #   - Neptuneクラスター: "cluster:{クラスター名}"
  #   - WorkSpacesプール: "workspacespool/{プールID}"
  # 参考: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html#API_RegisterScalableTarget_RequestParameters
  resource_id = "service/my-cluster/my-service"

  #-------------------------------------------------------------
  # スケーラブルディメンション設定
  #-------------------------------------------------------------

  # scalable_dimension (Required)
  # 設定内容: スケーラブルターゲットのスケーラブルディメンション（スケーリング対象の属性）を指定します。
  # 設定可能な値:
  #   - "ecs:service:DesiredCount": ECSサービスのタスク数
  #   - "elasticmapreduce:instancegroup:InstanceCount": EMRインスタンスグループのインスタンス数
  #   - "ec2:spot-fleet-request:TargetCapacity": Spot Fleetのターゲット容量
  #   - "appstream:fleet:DesiredCapacity": AppStream 2.0フリートの容量
  #   - "dynamodb:table:ReadCapacityUnits": DynamoDBテーブルのプロビジョンド読み取り容量
  #   - "dynamodb:table:WriteCapacityUnits": DynamoDBテーブルのプロビジョンド書き込み容量
  #   - "dynamodb:index:ReadCapacityUnits": DynamoDB GSIのプロビジョンド読み取り容量
  #   - "dynamodb:index:WriteCapacityUnits": DynamoDB GSIのプロビジョンド書き込み容量
  #   - "rds:cluster:ReadReplicaCount": Aurora DBクラスターのリードレプリカ数
  #   - "sagemaker:variant:DesiredInstanceCount": SageMakerエンドポイントバリアントのインスタンス数
  #   - "custom-resource:ResourceType:Property": カスタムリソースのスケーラブルディメンション
  #   - "comprehend:document-classifier-endpoint:DesiredInferenceUnits": Comprehendドキュメント分類エンドポイントの推論ユニット数
  #   - "comprehend:entity-recognizer-endpoint:DesiredInferenceUnits": Comprehendエンティティ認識エンドポイントの推論ユニット数
  #   - "lambda:function:ProvisionedConcurrency": Lambda関数のプロビジョンド同時実行数
  #   - "cassandra:table:ReadCapacityUnits": Keyspacesテーブルのプロビジョンド読み取り容量
  #   - "cassandra:table:WriteCapacityUnits": Keyspacesテーブルのプロビジョンド書き込み容量
  #   - "kafka:broker-storage:VolumeSize": MSKブローカーのボリュームサイズ(GiB)
  #   - "elasticache:cache-cluster:Nodes": ElastiCacheキャッシュクラスターのノード数
  #   - "elasticache:replication-group:NodeGroups": ElastiCacheレプリケーショングループのノードグループ数
  #   - "elasticache:replication-group:Replicas": ElastiCacheレプリケーショングループのノードグループあたりのレプリカ数
  #   - "neptune:cluster:ReadReplicaCount": Neptune DBクラスターのリードレプリカ数
  #   - "sagemaker:variant:DesiredProvisionedConcurrency": SageMakerサーバーレスエンドポイントのプロビジョンド同時実行数
  #   - "sagemaker:inference-component:DesiredCopyCount": SageMaker推論コンポーネントのコピー数
  #   - "workspaces:workspacespool:DesiredUserSessions": WorkSpacesプールのユーザーセッション数
  # 参考: https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html#API_RegisterScalableTarget_RequestParameters
  scalable_dimension = "ecs:service:DesiredCount"

  #-------------------------------------------------------------
  # 容量設定
  #-------------------------------------------------------------

  # min_capacity (Required)
  # 設定内容: スケーラブルターゲットの最小容量を指定します。
  # 設定可能な値: 0以上の整数（サービスによって最小値が異なる）
  # 注意:
  #   - 以下のリソースでは最小値0が許可されます:
  #     AppStream 2.0フリート、Aurora DBクラスター、ECSサービス、EMRクラスター、
  #     Lambdaプロビジョンド同時実行、SageMakerエンドポイントバリアント、
  #     SageMaker推論コンポーネント、SageMakerサーバーレスエンドポイント、
  #     Spot Fleet、カスタムリソース
  #   - CloudWatchメトリクスに基づくスケーリングを使用する場合、0より大きい値を推奨
  # 関連機能: Application Auto Scaling 容量設定
  #   スケーリングポリシーはこの最小容量を下回るスケールインを行いません。
  #   - https://docs.aws.amazon.com/autoscaling/application/userguide/getting-started.html
  min_capacity = 1

  # max_capacity (Required)
  # 設定内容: スケーラブルターゲットの最大容量を指定します。
  # 設定可能な値: min_capacity以上の整数
  # 注意:
  #   - 大きな最大容量を指定できますが、各サービスにはデフォルトのクォータがあります
  #   - より高い制限が必要な場合は、AWSサポートに引き上げをリクエストできます
  # 関連機能: Application Auto Scaling 容量設定
  #   スケーリングポリシーはこの最大容量を超えるスケールアウトを行いません。
  #   - https://docs.aws.amazon.com/autoscaling/application/userguide/getting-started.html
  #   - https://docs.aws.amazon.com/general/latest/gr/aws-service-information.html
  max_capacity = 10

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
  # IAMロール設定
  #-------------------------------------------------------------

  # role_arn (Optional)
  # 設定内容: Application Auto Scalingがスケーラブルターゲットを変更するためのIAMロールARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: ほとんどのサービスではAWSがサービスリンクロールを自動作成・使用します
  # 注意:
  #   - サービスリンクロールをサポートしないサービス（Amazon EMRなど）では必須
  #   - サービスリンクロールをサポートするサービスでは、APIによって無視されます
  # 関連機能: IAM Service-Linked Role
  #   Application Auto Scalingは、スケーラブルターゲットの登録時に必要に応じて
  #   サービスリンクロールを自動作成します。
  #   - https://docs.aws.amazon.com/autoscaling/application/userguide/security_iam_service-with-iam.html#security_iam_service-with-iam-roles
  role_arn = null

  #-------------------------------------------------------------
  # スケーリング一時停止設定
  #-------------------------------------------------------------

  # suspended_state (Optional)
  # 設定内容: スケーラブルターゲットのスケーリングアクティビティを一時停止するかどうかを指定します。
  # 関連機能: Application Auto Scaling Suspended State
  #   スケーリングを一時的に無効化する必要がある場合（メンテナンス時など）に使用します。
  #   - https://docs.aws.amazon.com/autoscaling/application/userguide/application-auto-scaling-suspend-resume-scaling.html
  suspended_state {
    # dynamic_scaling_in_suspended (Optional)
    # 設定内容: スケールインアクティビティを一時停止するかどうかを指定します。
    # 設定可能な値:
    #   - true: スケールイン（容量削減）を一時停止
    #   - false (デフォルト): スケールインを許可
    # 注意: スケールインを停止しても、スケールアウトは引き続き可能です
    dynamic_scaling_in_suspended = false

    # dynamic_scaling_out_suspended (Optional)
    # 設定内容: スケールアウトアクティビティを一時停止するかどうかを指定します。
    # 設定可能な値:
    #   - true: スケールアウト（容量拡張）を一時停止
    #   - false (デフォルト): スケールアウトを許可
    # 注意: スケールアウトを停止しても、スケールインは引き続き可能です
    dynamic_scaling_out_suspended = false

    # scheduled_scaling_suspended (Optional)
    # 設定内容: スケジュールされたスケーリングアクションを一時停止するかどうかを指定します。
    # 設定可能な値:
    #   - true: スケジュールされたスケーリングを一時停止
    #   - false (デフォルト): スケジュールされたスケーリングを許可
    # 注意: スケジュールされたアクションの開始時刻は、一時停止中も過ぎていきます
    scheduled_scaling_suspended = false
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意:
  #   - 2023年3月20日より前に作成されたスケーラブルターゲットにはARNが割り当てられておらず、
  #     タグを使用できません。この場合、lifecycle.ignore_changesを使用してください
  #   - プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #     一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします
  tags = {
    Name        = "my-autoscaling-target"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スケーラブルターゲットのAmazon Resource Name (ARN)
#        2023年3月20日より前に作成されたリソースには割り当てられていない場合があります。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
