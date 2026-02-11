#---------------------------------------------------------------
# AWS EventBridge Target (CloudWatch Event Target)
#---------------------------------------------------------------
#
# Amazon EventBridgeのターゲットをプロビジョニングするリソースです。
# EventBridgeルールにマッチしたイベントを特定のAWSサービス
# （Lambda、ECS、Step Functions、Kinesis、SNS等）に転送します。
#
# NOTE: EventBridgeは旧CloudWatch Eventsの名称変更版です。
#       機能は同一です。
#
# NOTE: Lambda関数やSNSトピックをターゲットとして呼び出すには、
#       aws_lambda_permissionやaws_sns_topic_policyで適切な権限を
#       設定する必要があります。
#
# AWS公式ドキュメント:
#   - EventBridge概要: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html
#   - EventBridgeターゲット: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-targets.html
#   - リソースベースポリシー: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-use-resource-based.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_event_target" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # rule (Required)
  # 設定内容: ターゲットを追加するEventBridgeルールの名前を指定します。
  # 設定可能な値: 既存のEventBridgeルールの名前
  rule = "example-rule"

  # arn (Required)
  # 設定内容: ターゲットのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なAWSリソースARN
  # 対応サービス例:
  #   - Lambda関数: arn:aws:lambda:region:account:function:function-name
  #   - ECSクラスター: arn:aws:ecs:region:account:cluster/cluster-name
  #   - Kinesis: arn:aws:kinesis:region:account:stream/stream-name
  #   - Step Functions: arn:aws:states:region:account:stateMachine:state-machine-name
  #   - SNS: arn:aws:sns:region:account:topic-name
  #   - SQS: arn:aws:sqs:region:account:queue-name
  #   - API Gateway: arn:aws:execute-api:region:account:api-id/stage/method/resource
  #   - EventBus: arn:aws:events:region:account:event-bus/bus-name
  arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:my-function"

  #-------------------------------------------------------------
  # ターゲット識別設定
  #-------------------------------------------------------------

  # target_id (Optional)
  # 設定内容: ターゲットの一意な識別子を指定します。
  # 設定可能な値: 1-64文字の英数字、ハイフン、アンダースコア
  # 省略時: Terraformがランダムな一意のIDを生成します。
  target_id = "example-target"

  #-------------------------------------------------------------
  # イベントバス設定
  #-------------------------------------------------------------

  # event_bus_name (Optional)
  # 設定内容: ルールに関連付けるイベントバスの名前またはARNを指定します。
  # 設定可能な値:
  #   - "default": デフォルトイベントバス
  #   - カスタムイベントバス名
  #   - イベントバスのARN
  # 省略時: "default"イベントバスが使用されます。
  event_bus_name = null

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
  # 設定内容: ルールがトリガーされたときにターゲットを呼び出すIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 必須条件:
  #   - ecs_targetを使用する場合
  #   - arnがEC2インスタンス、Kinesisストリーム、Step Functionsステートマシンの場合
  #   - 異なるアカウントまたはリージョンのイベントバスをターゲットにする場合
  # 注意: ロールにはevents.amazonaws.comへのAssumeRole権限が必要です。
  role_arn = null

  #-------------------------------------------------------------
  # 入力データ設定
  #-------------------------------------------------------------

  # input (Optional)
  # 設定内容: ターゲットに渡す有効なJSON文字列を指定します。
  # 設定可能な値: 有効なJSON文字列
  # 注意: input_path、input_transformerと排他的（いずれか1つのみ指定可能）
  # 省略時: マッチしたイベント全体がターゲットに渡されます。
  input = null

  # input_path (Optional)
  # 設定内容: イベントからデータを抽出するJSONPathを指定します。
  # 設定可能な値: 有効なJSONPath式（例: "$.detail"）
  # 注意: input、input_transformerと排他的（いずれか1つのみ指定可能）
  # 参考: http://goessner.net/articles/JsonPath/
  input_path = null

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: AWSによって作成されたマネージドルールを削除するかを指定します。
  # 設定可能な値:
  #   - true: マネージドルールを削除可能
  #   - false (デフォルト): マネージドルールは削除不可
  force_destroy = false

  #-------------------------------------------------------------
  # 入力変換設定
  #-------------------------------------------------------------

  # input_transformer (Optional, 最大1つ)
  # 設定内容: イベントデータをカスタム形式に変換してターゲットに渡す設定です。
  # 注意: input、input_pathと排他的（いずれか1つのみ指定可能）
  # input_transformer {
  #   # input_paths (Optional)
  #   # 設定内容: イベントからデータを抽出するJSONPathのマップを指定します。
  #   # 設定可能な値:
  #   #   - キー: 変数名（"AWS"で始まる名前は使用不可）
  #   #   - 値: JSONPath式（JSON dot notation形式）
  #   # 制限: 最大100個のキーバリューペア
  #   input_paths = {
  #     instance = "$.detail.instance"
  #     status   = "$.detail.status"
  #   }
  #
  #   # input_template (Required)
  #   # 設定内容: ターゲットに送信するデータのテンプレートを指定します。
  #   # 設定可能な値: 有効なJSON文字列またはプレースホルダーを含む文字列
  #   # 注意:
  #   #   - 文字列値を送信する場合はダブルクォートで囲む必要があります
  #   #   - JSONとTerraform両方でのエスケープが必要
  #   #   - 例: "\"<instance> is in state <status>\""
  #   input_template = <<EOF
  # {
  #   "instance_id": <instance>,
  #   "instance_status": <status>
  # }
  # EOF
  # }

  #-------------------------------------------------------------
  # リトライポリシー設定
  #-------------------------------------------------------------

  # retry_policy (Optional, 最大1つ)
  # 設定内容: ターゲット呼び出し失敗時のリトライポリシーを指定します。
  # retry_policy {
  #   # maximum_event_age_in_seconds (Optional)
  #   # 設定内容: イベントの最大保持時間（秒）を指定します。
  #   # 設定可能な値: 60-86400（1分-24時間）
  #   # 省略時: 24時間（86400秒）
  #   maximum_event_age_in_seconds = 3600
  #
  #   # maximum_retry_attempts (Optional)
  #   # 設定内容: 最大リトライ回数を指定します。
  #   # 設定可能な値: 0-185
  #   # 省略時: 185回
  #   maximum_retry_attempts = 3
  # }

  #-------------------------------------------------------------
  # デッドレターキュー設定
  #-------------------------------------------------------------

  # dead_letter_config (Optional, 最大1つ)
  # 設定内容: ターゲット呼び出し失敗時のデッドレターキューを指定します。
  # 関連機能: EventBridge デッドレターキュー
  #   ターゲットへの配信に失敗したイベントを保存し、後で分析・再処理できます。
  # dead_letter_config {
  #   # arn (Optional)
  #   # 設定内容: デッドレターキューとして使用するSQSキューのARNを指定します。
  #   # 設定可能な値: 有効なSQSキューARN
  #   arn = "arn:aws:sqs:ap-northeast-1:123456789012:my-dlq"
  # }

  #-------------------------------------------------------------
  # ECSターゲット設定
  #-------------------------------------------------------------

  # ecs_target (Optional, 最大1つ)
  # 設定内容: Amazon ECSタスクをターゲットとする場合の設定です。
  # 注意: arnにはECSクラスターのARNを指定します。
  # ecs_target {
  #   # task_definition_arn (Required)
  #   # 設定内容: 実行するタスク定義のARNを指定します。
  #   # 設定可能な値: 有効なECSタスク定義ARN
  #   task_definition_arn = "arn:aws:ecs:ap-northeast-1:123456789012:task-definition/my-task:1"
  #
  #   # task_count (Optional)
  #   # 設定内容: 起動するタスク数を指定します。
  #   # 設定可能な値: 正の整数
  #   # 省略時: 1
  #   task_count = 1
  #
  #   # launch_type (Optional)
  #   # 設定内容: タスクの起動タイプを指定します。
  #   # 設定可能な値:
  #   #   - "EC2": EC2インスタンスで実行
  #   #   - "FARGATE": Fargateで実行
  #   #   - "EXTERNAL": 外部インスタンスで実行
  #   # 注意: ターゲットタスク定義の互換性と一致する必要があります。
  #   launch_type = "FARGATE"
  #
  #   # platform_version (Optional)
  #   # 設定内容: Fargateプラットフォームのバージョンを指定します。
  #   # 設定可能な値: 数値形式のバージョン（例: "1.4.0"）または"LATEST"
  #   # 注意: launch_typeがFARGATEの場合のみ使用
  #   # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html
  #   platform_version = "LATEST"
  #
  #   # group (Optional)
  #   # 設定内容: ECSタスクグループを指定します。
  #   # 設定可能な値: 最大255文字の文字列
  #   group = null
  #
  #   # enable_ecs_managed_tags (Optional)
  #   # 設定内容: ECSマネージドタグを有効にするかを指定します。
  #   # 設定可能な値: true / false
  #   enable_ecs_managed_tags = false
  #
  #   # enable_execute_command (Optional)
  #   # 設定内容: ECS Execを有効にするかを指定します。
  #   # 設定可能な値: true / false
  #   # trueの場合、タスク内のすべてのコンテナでexecute command機能が有効になります。
  #   enable_execute_command = false
  #
  #   # propagate_tags (Optional)
  #   # 設定内容: タスク定義からタスクへのタグ伝播を指定します。
  #   # 設定可能な値: "TASK_DEFINITION" または null
  #   propagate_tags = null
  #
  #   # tags (Optional)
  #   # 設定内容: ECSリソースに割り当てるタグを指定します。
  #   # 設定可能な値: キーと値のペアのマップ
  #   tags = {}
  #
  #   # network_configuration (Optional, 最大1つ)
  #   # 設定内容: awsvpcネットワークモードを使用する場合のネットワーク設定です。
  #   # 注意: launch_typeがFARGATEの場合は必須（awsvpcモードが必須のため）
  #   # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-networking.html
  #   # network_configuration {
  #   #   # subnets (Required)
  #   #   # 設定内容: タスクに関連付けるサブネットを指定します。
  #   #   # 設定可能な値: サブネットIDのセット
  #   #   subnets = ["subnet-12345678", "subnet-87654321"]
  #   #
  #   #   # security_groups (Optional)
  #   #   # 設定内容: タスクに関連付けるセキュリティグループを指定します。
  #   #   # 設定可能な値: セキュリティグループIDのセット
  #   #   # 省略時: VPCのデフォルトセキュリティグループが使用されます。
  #   #   security_groups = ["sg-12345678"]
  #   #
  #   #   # assign_public_ip (Optional)
  #   #   # 設定内容: パブリックIPアドレスを割り当てるかを指定します。
  #   #   # 設定可能な値: true / false
  #   #   # 省略時: false
  #   #   # 注意: Fargate起動タイプでのみ使用
  #   #   assign_public_ip = false
  #   # }
  #
  #   # capacity_provider_strategy (Optional, 複数指定可)
  #   # 設定内容: タスクのキャパシティプロバイダー戦略を指定します。
  #   # 注意: launch_typeパラメータと排他的
  #   # capacity_provider_strategy {
  #   #   # capacity_provider (Required)
  #   #   # 設定内容: キャパシティプロバイダーの短縮名を指定します。
  #   #   # 設定可能な値: 有効なキャパシティプロバイダー名
  #   #   capacity_provider = "FARGATE"
  #   #
  #   #   # weight (Optional)
  #   #   # 設定内容: 相対的なタスク起動割合を指定します。
  #   #   # 設定可能な値: 0-1000
  #   #   weight = 1
  #   #
  #   #   # base (Optional)
  #   #   # 設定内容: 最小タスク数を指定します。
  #   #   # 設定可能な値: 0-100000
  #   #   # 省略時: 0
  #   #   # 注意: 1つのキャパシティプロバイダーのみbaseを定義可能
  #   #   base = 0
  #   # }
  #
  #   # ordered_placement_strategy (Optional, 最大5つ)
  #   # 設定内容: タスクの配置戦略を指定します。
  #   # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-placement-strategies.html
  #   # ordered_placement_strategy {
  #   #   # type (Required)
  #   #   # 設定内容: 配置戦略のタイプを指定します。
  #   #   # 設定可能な値:
  #   #   #   - "binpack": 利用可能なリソースを最小限に使用してタスクを配置
  #   #   #   - "random": ランダムに配置
  #   #   #   - "spread": 指定されたフィールドに基づいて均等に分散
  #   #   type = "spread"
  #   #
  #   #   # field (Optional)
  #   #   # 設定内容: 配置戦略を適用するフィールドを指定します。
  #   #   # 設定可能な値:
  #   #   #   - spread: "instanceId"(または"host")、"attribute:ecs.availability-zone"等
  #   #   #   - binpack: "cpu"、"memory"
  #   #   #   - random: 使用しない
  #   #   field = "attribute:ecs.availability-zone"
  #   # }
  #
  #   # placement_constraint (Optional, 最大10個)
  #   # 設定内容: タスクの配置制約を指定します。
  #   # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-query-language.html
  #   # placement_constraint {
  #   #   # type (Required)
  #   #   # 設定内容: 制約のタイプを指定します。
  #   #   # 設定可能な値:
  #   #   #   - "memberOf": 指定された式を満たすインスタンスにのみ配置
  #   #   #   - "distinctInstance": 各タスクを別々のインスタンスに配置
  #   #   type = "distinctInstance"
  #   #
  #   #   # expression (Optional)
  #   #   # 設定内容: クラスタークエリ言語の式を指定します。
  #   #   # 注意: distinctInstanceタイプでは不要
  #   #   expression = null
  #   # }
  # }

  #-------------------------------------------------------------
  # Batchターゲット設定
  #-------------------------------------------------------------

  # batch_target (Optional, 最大1つ)
  # 設定内容: AWS Batchジョブをターゲットとする場合の設定です。
  # batch_target {
  #   # job_definition (Required)
  #   # 設定内容: 使用するジョブ定義のARNまたは名前を指定します。
  #   # 設定可能な値: 既存のジョブ定義のARNまたは名前
  #   job_definition = "arn:aws:batch:ap-northeast-1:123456789012:job-definition/my-job:1"
  #
  #   # job_name (Required)
  #   # 設定内容: このジョブ実行の名前を指定します。
  #   # 設定可能な値: ジョブ名として有効な文字列
  #   job_name = "my-scheduled-job"
  #
  #   # array_size (Optional)
  #   # 設定内容: 配列ジョブの場合のサイズを指定します。
  #   # 設定可能な値: 2-10000
  #   array_size = null
  #
  #   # job_attempts (Optional)
  #   # 設定内容: ジョブ失敗時のリトライ回数を指定します。
  #   # 設定可能な値: 1-10
  #   job_attempts = null
  # }

  #-------------------------------------------------------------
  # Kinesisターゲット設定
  #-------------------------------------------------------------

  # kinesis_target (Optional, 最大1つ)
  # 設定内容: Amazon Kinesisストリームをターゲットとする場合の設定です。
  # kinesis_target {
  #   # partition_key_path (Optional)
  #   # 設定内容: パーティションキーとして使用するイベントのJSONPathを指定します。
  #   # 設定可能な値: 有効なJSONPath式
  #   partition_key_path = "$.detail.id"
  # }

  #-------------------------------------------------------------
  # SQSターゲット設定
  #-------------------------------------------------------------

  # sqs_target (Optional, 最大1つ)
  # 設定内容: Amazon SQSキューをターゲットとする場合の設定です。
  # sqs_target {
  #   # message_group_id (Optional)
  #   # 設定内容: FIFOキューの場合のメッセージグループIDを指定します。
  #   # 設定可能な値: 文字列
  #   # 注意: FIFOキューでのみ使用
  #   message_group_id = null
  # }

  #-------------------------------------------------------------
  # HTTPターゲット設定（API Gateway）
  #-------------------------------------------------------------

  # http_target (Optional, 最大1つ)
  # 設定内容: API Gateway RESTエンドポイントをターゲットとする場合の設定です。
  # http_target {
  #   # header_parameters (Optional)
  #   # 設定内容: リクエストに追加するHTTPヘッダーを指定します。
  #   # 設定可能な値: キーと値のペアのマップ
  #   header_parameters = {
  #     "Content-Type" = "application/json"
  #     "X-Custom-Header" = "value"
  #   }
  #
  #   # query_string_parameters (Optional)
  #   # 設定内容: 呼び出しエンドポイントに追加するクエリ文字列パラメータを指定します。
  #   # 設定可能な値: キーと値のペアのマップ
  #   query_string_parameters = {
  #     "param1" = "value1"
  #   }
  #
  #   # path_parameter_values (Optional)
  #   # 設定内容: エンドポイントARNのパス変数に対応する値のリストを指定します。
  #   # 設定可能な値: 文字列のリスト
  #   # 例: arn:aws:execute-api:region:account:api/stage/POST/pets/* の*に対応
  #   path_parameter_values = []
  # }

  #-------------------------------------------------------------
  # Run Commandターゲット設定
  #-------------------------------------------------------------

  # run_command_targets (Optional, 最大5つ)
  # 設定内容: Amazon EC2 Run Commandをターゲットとする場合の設定です。
  # run_command_targets {
  #   # key (Required)
  #   # 設定内容: ターゲットを識別するキーを指定します。
  #   # 設定可能な値:
  #   #   - "tag:tag-key": タグキーで識別
  #   #   - "InstanceIds": インスタンスIDで識別
  #   key = "tag:Name"
  #
  #   # values (Required)
  #   # 設定内容: キーに対応する値のリストを指定します。
  #   # 設定可能な値:
  #   #   - keyが"tag:tag-key"の場合: タグ値のリスト
  #   #   - keyが"InstanceIds"の場合: EC2インスタンスIDのリスト
  #   values = ["WebServer", "AppServer"]
  # }

  #-------------------------------------------------------------
  # Redshiftターゲット設定
  #-------------------------------------------------------------

  # redshift_target (Optional, 最大1つ)
  # 設定内容: Amazon Redshift Data APIをターゲットとする場合の設定です。
  # redshift_target {
  #   # database (Required)
  #   # 設定内容: データベース名を指定します。
  #   # 設定可能な値: 有効なRedshiftデータベース名
  #   database = "mydb"
  #
  #   # db_user (Optional)
  #   # 設定内容: データベースユーザー名を指定します。
  #   # 設定可能な値: 有効なデータベースユーザー名
  #   db_user = null
  #
  #   # secrets_manager_arn (Optional)
  #   # 設定内容: データベースアクセス用のSecrets ManagerシークレットのARNを指定します。
  #   # 設定可能な値: 有効なSecrets ManagerシークレットARN
  #   secrets_manager_arn = null
  #
  #   # sql (Optional)
  #   # 設定内容: 実行するSQL文を指定します。
  #   # 設定可能な値: 有効なSQL文
  #   sql = null
  #
  #   # statement_name (Optional)
  #   # 設定内容: SQL文の名前を指定します。
  #   # 設定可能な値: 文字列
  #   statement_name = null
  #
  #   # with_event (Optional)
  #   # 設定内容: SQL実行後にEventBridgeにイベントを送信するかを指定します。
  #   # 設定可能な値: true / false
  #   with_event = false
  # }

  #-------------------------------------------------------------
  # SageMaker Pipelineターゲット設定
  #-------------------------------------------------------------

  # sagemaker_pipeline_target (Optional, 最大1つ)
  # 設定内容: Amazon SageMaker AI Pipelineをターゲットとする場合の設定です。
  # sagemaker_pipeline_target {
  #   # pipeline_parameter_list (Optional, 最大200個)
  #   # 設定内容: パイプライン実行に渡すパラメータを指定します。
  #   # pipeline_parameter_list {
  #   #   # name (Required)
  #   #   # 設定内容: パラメータ名を指定します。
  #   #   # 設定可能な値: 有効なパラメータ名
  #   #   name = "InputDataPath"
  #   #
  #   #   # value (Required)
  #   #   # 設定内容: パラメータ値を指定します。
  #   #   # 設定可能な値: 文字列
  #   #   value = "s3://my-bucket/input"
  #   # }
  # }

  #-------------------------------------------------------------
  # AppSyncターゲット設定
  #-------------------------------------------------------------

  # appsync_target (Optional, 最大1つ)
  # 設定内容: AWS AppSync GraphQL APIをターゲットとする場合の設定です。
  # 注意: arnにはAppSync GraphQL APIのエンドポイントARN
  #       （"apis"を"endpoints/graphql-api"に置換した形式）を指定します。
  # appsync_target {
  #   # graphql_operation (Optional)
  #   # 設定内容: 実行するGraphQLミューテーションを指定します。
  #   # 設定可能な値: 有効なGraphQLミューテーション文字列
  #   graphql_operation = "mutation TestMutation($input: MutationInput!) { testMutation(input: $input) { result } }"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子
#       形式: event_bus_name/rule_name/target_id
#
# - region: リソースが管理されているリージョン
#           regionを明示的に指定しない場合、プロバイダー設定のリージョン
#
# - target_id: target_idを明示的に指定しない場合、自動生成されたID
#---------------------------------------------------------------
