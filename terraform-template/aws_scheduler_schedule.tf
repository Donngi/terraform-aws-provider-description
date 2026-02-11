################################################################################
# EventBridge Scheduler Schedule
################################################################################
# EventBridge Schedulerのスケジュールリソース
# 指定した時刻または間隔でAWSサービスやHTTPエンドポイントを呼び出す
#
# 主な用途:
# - 定期的なバッチ処理の実行
# - スケジュールされたワークフローの起動
# - 時間ベースの自動化タスク
# - Cron式やRate式による柔軟なスケジューリング
#
# EventBridge Schedulerは旧CloudWatch Eventsの後継サービスで、
# より高度なスケジューリング機能を提供します。
#
# 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/what-is-scheduler.html

resource "aws_scheduler_schedule" "example" {
  ################################################################################
  # Basic Configuration
  ################################################################################

  # name - (Optional, Forces new resource) スケジュールの名前
  # 省略した場合、Terraformがランダムな一意の名前を割り当てます
  # name_prefixと競合するため、どちらか一方のみ指定可能です
  #
  # 命名規則:
  # - 1-64文字
  # - 英数字、ハイフン、アンダースコアが使用可能
  # - スケジュールグループ内で一意である必要があります
  #
  # 例:
  # name = "daily-backup-job"
  # name = "hourly-data-sync"
  name = "example-schedule"

  # name_prefix - (Optional, Forces new resource) 指定されたプレフィックスで始まる一意の名前を作成
  # nameと競合するため、どちらか一方のみ指定可能です
  #
  # Terraformが自動的にプレフィックスの後にランダムな文字列を追加します
  #
  # 例:
  # name_prefix = "backup-"  # 結果: backup-abc123
  # name_prefix = "sync-"    # 結果: sync-xyz789
  # name_prefix = "example-"

  # group_name - (Optional, Forces new resource) このスケジュールに関連付けるスケジュールグループの名前
  # 省略した場合、デフォルトのスケジュールグループが使用されます
  #
  # スケジュールグループは複数のスケジュールを論理的にグループ化し、
  # まとめて管理・監視するための仕組みです
  #
  # 例:
  # group_name = "production-schedules"
  # group_name = "backup-jobs"
  # group_name = "data-processing"
  group_name = "default"

  # description - (Optional) スケジュールの簡潔な説明
  # 最大512文字まで設定可能です
  #
  # スケジュールの目的や動作を説明する際に使用します
  #
  # 例:
  # description = "毎日午前3時にS3バックアップを実行"
  # description = "1時間ごとにデータ同期処理を実行"
  # description = "週次レポート生成ジョブ"
  description = "Example EventBridge Scheduler schedule"

  ################################################################################
  # Schedule Expression Configuration
  ################################################################################

  # schedule_expression - (Required) スケジュールの実行タイミングを定義
  # Rate式、Cron式、または一度限りのスケジュールを指定できます
  #
  # Rate式の形式:
  # - rate(value unit)
  # - unit: minute(s), hour(s), day(s)
  # - 例: rate(5 minutes), rate(1 hour), rate(7 days)
  #
  # Cron式の形式:
  # - cron(分 時 日 月 曜日 年)
  # - 例: cron(0 10 * * ? *)  # 毎日10:00 UTC
  # - 例: cron(15 12 * * ? *)  # 毎日12:15 UTC
  # - 例: cron(0 18 ? * MON-FRI *)  # 平日18:00 UTC
  #
  # 一度限りの実行:
  # - at(yyyy-mm-ddThh:mm:ss)
  # - 例: at(2024-12-31T23:59:00)
  #
  # 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html
  schedule_expression = "rate(1 hours)"

  # schedule_expression_timezone - (Optional) スケジュール式が評価されるタイムゾーン
  # デフォルトはUTCです
  #
  # IANAタイムゾーンデータベースの形式で指定します
  # Cron式を使用する場合に特に重要です
  #
  # 例:
  # schedule_expression_timezone = "Asia/Tokyo"      # 日本時間
  # schedule_expression_timezone = "America/New_York" # 米国東部時間
  # schedule_expression_timezone = "Europe/London"    # ロンドン時間
  schedule_expression_timezone = "UTC"

  ################################################################################
  # Schedule Time Window
  ################################################################################

  # start_date - (Optional) スケジュールがターゲットの呼び出しを開始できる日時（UTC）
  # スケジュールの繰り返し式に応じて、指定した開始日以降に呼び出しが発生します
  # 一度限りのスケジュールでは無視されます
  #
  # ISO 8601形式で指定: yyyy-MM-ddTHH:mm:ssZ
  #
  # 例:
  # start_date = "2024-01-01T00:00:00Z"
  # start_date = "2024-06-15T09:00:00Z"
  # start_date = "2030-01-01T01:00:00Z"

  # end_date - (Optional) スケジュールがターゲットを呼び出せる最終日時（UTC）
  # スケジュールの繰り返し式に応じて、指定した終了日以前に呼び出しが停止します
  # 一度限りのスケジュールでは無視されます
  #
  # ISO 8601形式で指定: yyyy-MM-ddTHH:mm:ssZ
  #
  # 例:
  # end_date = "2024-12-31T23:59:59Z"
  # end_date = "2025-06-30T23:59:59Z"
  # end_date = "2030-01-01T01:00:00Z"

  ################################################################################
  # Flexible Time Window
  ################################################################################

  # flexible_time_window - (Required) スケジュールが呼び出される時間枠を設定
  # スケジュールされた時刻から指定した時間枠内でランダムに実行されます
  flexible_time_window {
    # mode - (Required) スケジュールを柔軟な時間枠内で呼び出すかどうかを決定
    # 値:
    # - OFF: 正確なスケジュール時刻に実行（デフォルト的な使い方）
    # - FLEXIBLE: 指定した時間枠内でランダムに実行
    #
    # FLEXIBLEモードは、複数のスケジュールが同時に実行されることを避け、
    # リソースの負荷を分散させるのに役立ちます
    #
    # 例:
    # mode = "OFF"      # 正確な時刻に実行
    # mode = "FLEXIBLE" # 時間枠内でランダムに実行
    mode = "OFF"

    # maximum_window_in_minutes - (Optional) スケジュールを呼び出せる最大時間枠（分）
    # modeがFLEXIBLEの場合のみ必要です
    # 範囲: 1〜1440分（1分〜24時間）
    #
    # スケジュールされた時刻からこの時間枠内のランダムな時刻に実行されます
    #
    # 例:
    # maximum_window_in_minutes = 15   # 15分以内
    # maximum_window_in_minutes = 60   # 1時間以内
    # maximum_window_in_minutes = 240  # 4時間以内
    # maximum_window_in_minutes = 10
  }

  ################################################################################
  # Schedule State and Action
  ################################################################################

  # state - (Optional) スケジュールが有効か無効かを指定
  # 値:
  # - ENABLED: スケジュールが有効（デフォルト）
  # - DISABLED: スケジュールが無効
  #
  # 無効にすると、スケジュールは実行されませんが、設定は保持されます
  # 一時的にスケジュールを停止したい場合に便利です
  #
  # 例:
  # state = "ENABLED"
  # state = "DISABLED"
  state = "ENABLED"

  # action_after_completion - (Optional) ターゲット呼び出し完了後にスケジュールに適用されるアクション
  # 値:
  # - NONE: 何もしない（デフォルト）
  # - DELETE: スケジュールを削除
  #
  # DELETEは一度限りのスケジュール（at式）で使用すると、
  # 実行後に自動的にスケジュールが削除されます
  #
  # 例:
  # action_after_completion = "NONE"
  # action_after_completion = "DELETE"  # 一度限りの実行後に削除
  action_after_completion = "NONE"

  ################################################################################
  # Target Configuration
  ################################################################################

  # target - (Required) スケジュールのターゲット設定
  # スケジュールが呼び出すAWSサービスやリソースを指定します
  target {
    # arn - (Required) このスケジュールのターゲットのARN
    # SQSキュー、ECSクラスター、Lambda関数などを指定できます
    #
    # ユニバーサルターゲットの場合、特定のサービスARN形式を使用:
    # - SQS: arn:aws:scheduler:::aws-sdk:sqs:sendMessage
    # - Lambda: arn:aws:scheduler:::aws-sdk:lambda:invoke
    # - SNS: arn:aws:scheduler:::aws-sdk:sns:publish
    # - Step Functions: arn:aws:scheduler:::aws-sdk:sfn:startExecution
    #
    # 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-targets-universal.html
    #
    # 例:
    # arn = aws_sqs_queue.target.arn
    # arn = aws_lambda_function.target.arn
    # arn = "arn:aws:scheduler:::aws-sdk:sqs:sendMessage"
    arn = "arn:aws:sqs:us-east-1:123456789012:example-queue"

    # role_arn - (Required) スケジュールが呼び出されたときにEventBridge Schedulerが使用するIAMロールのARN
    # このロールには、ターゲットリソースを呼び出すための適切な権限が必要です
    #
    # 必要な権限の例:
    # - SQS: sqs:SendMessage
    # - Lambda: lambda:InvokeFunction
    # - ECS: ecs:RunTask
    # - Step Functions: states:StartExecution
    #
    # 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/setting-up.html#setting-up-execution-role
    #
    # 例:
    # role_arn = aws_iam_role.scheduler_role.arn
    role_arn = "arn:aws:iam::123456789012:role/scheduler-execution-role"

    # input - (Optional) ターゲットに渡されるテキストまたは整形されたJSON
    # ユニバーサルターゲット使用時に、API呼び出しのパラメータを指定します
    #
    # JSONエンコードされた文字列として指定する必要があります
    # jsonencode関数を使用して、Terraform内でJSONを構築できます
    #
    # 例:
    # input = jsonencode({
    #   MessageBody = "Hello from EventBridge Scheduler"
    #   QueueUrl    = aws_sqs_queue.target.url
    # })
    #
    # input = jsonencode({
    #   FunctionName = aws_lambda_function.target.function_name
    #   Payload      = jsonencode({ key = "value" })
    # })
    #
    # 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-targets-universal.html
    # input = jsonencode({
    #   message = "Scheduled event"
    # })

    ################################################################################
    # Dead Letter Configuration
    ################################################################################

    # dead_letter_config - (Optional) EventBridge Schedulerがデッドレターキューとして使用するAmazon SQSキューの情報
    # 指定すると、ターゲットへの配信に失敗したイベントがキューに送信されます
    #
    # 失敗したイベントを記録し、後で分析・再処理するために使用します
    # dead_letter_config {
    #   # arn - (Required) デッドレターキューとして指定されたSQSキューのARN
    #   # 失敗したイベントがこのキューに送信されます
    #   #
    #   # 例:
    #   # arn = aws_sqs_queue.dlq.arn
    #   arn = "arn:aws:sqs:us-east-1:123456789012:scheduler-dlq"
    # }

    ################################################################################
    # Retry Policy
    ################################################################################

    # retry_policy - (Optional) リトライポリシーの設定
    # ターゲット呼び出しが失敗した場合の再試行動作を制御します
    # retry_policy {
    #   # maximum_retry_attempts - (Optional) リクエストが失敗する前に行う最大再試行回数
    #   # 範囲: 0〜185（デフォルト: 185）
    #   #
    #   # 0を指定すると再試行は行われません
    #   #
    #   # 例:
    #   # maximum_retry_attempts = 3
    #   # maximum_retry_attempts = 10
    #   # maximum_retry_attempts = 0  # 再試行なし
    #   maximum_retry_attempts = 3
    #
    #   # maximum_event_age_in_seconds - (Optional) 再試行を続ける最大時間（秒）
    #   # 範囲: 60〜86400秒（デフォルト: 86400 = 24時間）
    #   #
    #   # この時間を超えると、再試行回数が残っていても再試行は停止します
    #   #
    #   # 例:
    #   # maximum_event_age_in_seconds = 3600   # 1時間
    #   # maximum_event_age_in_seconds = 7200   # 2時間
    #   # maximum_event_age_in_seconds = 86400  # 24時間
    #   maximum_event_age_in_seconds = 3600
    # }

    ################################################################################
    # ECS Parameters
    ################################################################################

    # ecs_parameters - (Optional) Amazon ECS RunTask APIオペレーションのテンプレート化されたターゲットタイプ
    # ECSタスクをスケジュール実行する場合に使用します
    # ecs_parameters {
    #   # task_definition_arn - (Required) 使用するタスク定義のARN
    #   # タスク定義のファミリー名とリビジョン、またはフルARNを指定できます
    #   #
    #   # 例:
    #   # task_definition_arn = aws_ecs_task_definition.example.arn
    #   # task_definition_arn = "arn:aws:ecs:us-east-1:123456789012:task-definition/my-task:1"
    #   task_definition_arn = "arn:aws:ecs:us-east-1:123456789012:task-definition/example-task"
    #
    #   # task_count - (Optional) 作成するタスクの数
    #   # 範囲: 1（デフォルト）〜10
    #   #
    #   # 複数のタスクを同時に実行する場合に使用します
    #   #
    #   # 例:
    #   # task_count = 1
    #   # task_count = 3
    #   # task_count = 5
    #   task_count = 1
    #
    #   # launch_type - (Optional) タスクが実行される起動タイプ
    #   # ターゲットタスクの起動タイプ互換性と一致する必要があります
    #   # 値: EC2, FARGATE, EXTERNAL
    #   #
    #   # 例:
    #   # launch_type = "FARGATE"
    #   # launch_type = "EC2"
    #   launch_type = "FARGATE"
    #
    #   # platform_version - (Optional) タスクのプラットフォームバージョン
    #   # Fargateの場合、プラットフォームバージョンの数値部分のみを指定します
    #   #
    #   # 例:
    #   # platform_version = "LATEST"
    #   # platform_version = "1.4.0"
    #   # platform_version = "1.3.0"
    #   # platform_version = "LATEST"
    #
    #   # group - (Optional) ECSタスクグループの指定
    #   # 最大255文字
    #   #
    #   # タスクをグループ化して管理・監視する際に使用します
    #   #
    #   # 例:
    #   # group = "scheduled-tasks"
    #   # group = "batch-processing"
    #   # group = "scheduled-batch"
    #
    #   # enable_ecs_managed_tags - (Optional) タスクにAmazon ECS管理タグを有効にするかどうか
    #   # true/falseで指定します
    #   #
    #   # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-using-tags.html
    #   #
    #   # 例:
    #   # enable_ecs_managed_tags = true
    #   # enable_ecs_managed_tags = false
    #   enable_ecs_managed_tags = false
    #
    #   # enable_execute_command - (Optional) このタスク内のコンテナでexecuteコマンド機能を有効にするかどうか
    #   # true/falseで指定します
    #   #
    #   # ECS Execを使用してコンテナに接続する場合に有効化します
    #   #
    #   # 例:
    #   # enable_execute_command = true
    #   # enable_execute_command = false
    #   enable_execute_command = false
    #
    #   # propagate_tags - (Optional) タスク定義からタスクへタグを伝播するかどうか
    #   # 値: TASK_DEFINITION
    #   #
    #   # タスク定義で定義されたタグが起動されたタスクにも適用されます
    #   #
    #   # 例:
    #   # propagate_tags = "TASK_DEFINITION"
    #   # propagate_tags = "TASK_DEFINITION"
    #
    #   # reference_id - (Optional) タスクで使用する参照ID
    #   # タスクを識別するためのカスタムIDを指定できます
    #   #
    #   # 例:
    #   # reference_id = "scheduled-task-001"
    #   # reference_id = "batch-job-abc123"
    #   # reference_id = "ref-12345"
    #
    #   # tags - (Optional) タスクに適用するメタデータ
    #   # 各タグはキーとオプションの値で構成されます
    #   #
    #   # 参考: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_RunTask.html
    #   #
    #   # 例:
    #   # tags = {
    #   #   Environment = "production"
    #   #   Application = "data-processing"
    #   #   ManagedBy   = "terraform"
    #   # }
    #   tags = {
    #     Scheduled = "true"
    #   }
    #
    #   ################################################################################
    #   # ECS Network Configuration
    #   ################################################################################
    #
    #   # network_configuration - (Optional) タスクに関連するネットワーク設定
    #   # Fargateタスクの場合は必須です
    #   network_configuration {
    #     # subnets - (Optional) タスクに関連付ける1〜16個のサブネットのセット
    #     # これらのサブネットはすべて同じVPC内に存在する必要があります
    #     #
    #     # 例:
    #     # subnets = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    #     # subnets = [
    #     #   "subnet-12345678",
    #     #   "subnet-87654321",
    #     # ]
    #     subnets = ["subnet-12345678"]
    #
    #     # security_groups - (Optional) タスクに関連付ける1〜5個のセキュリティグループIDのセット
    #     # これらのセキュリティグループはすべて同じVPC内に存在する必要があります
    #     #
    #     # 例:
    #     # security_groups = [aws_security_group.ecs_tasks.id]
    #     # security_groups = [
    #     #   "sg-12345678",
    #     #   "sg-87654321",
    #     # ]
    #     security_groups = ["sg-12345678"]
    #
    #     # assign_public_ip - (Optional) タスクのElastic Network InterfaceがパブリックIPアドレスを受け取るかどうか
    #     # ブール型で、trueはENABLEDに、falseはDISABLEDにマッピングされます
    #     # launch_typeがFARGATEに設定されている場合にのみtrueを指定できます
    #     #
    #     # 例:
    #     # assign_public_ip = true   # パブリックIPを割り当て
    #     # assign_public_ip = false  # パブリックIPを割り当てない
    #     assign_public_ip = false
    #   }
    #
    #   ################################################################################
    #   # ECS Capacity Provider Strategy
    #   ################################################################################
    #
    #   # capacity_provider_strategy - (Optional) タスクに使用する最大6個のキャパシティプロバイダー戦略
    #   # 複数のキャパシティプロバイダー間でタスクを分散する場合に使用します
    #   # capacity_provider_strategy {
    #   #   # capacity_provider - (Required) キャパシティプロバイダーの短縮名
    #   #   # クラスターに関連付けられたキャパシティプロバイダーの名前を指定します
    #   #   #
    #   #   # 例:
    #   #   # capacity_provider = "FARGATE"
    #   #   # capacity_provider = "FARGATE_SPOT"
    #   #   # capacity_provider = aws_ecs_capacity_provider.example.name
    #   #   capacity_provider = "FARGATE"
    #   #
    #   #   # weight - (Optional) 起動される合計タスク数の相対的なパーセンテージ
    #   #   # base値が定義されている場合、それが満たされた後に重みの値が考慮されます
    #   #   # 範囲: 0〜1000
    #   #   #
    #   #   # 例:
    #   #   # weight = 1    # 1倍の重み
    #   #   # weight = 100  # 100倍の重み
    #   #   weight = 1
    #   #
    #   #   # base - (Optional) 指定されたキャパシティプロバイダーで最低限実行するタスク数
    #   #   # キャパシティプロバイダー戦略では、1つのキャパシティプロバイダーのみがbaseを定義できます
    #   #   # 範囲: 0（デフォルト）〜100000
    #   #   #
    #   #   # 例:
    #   #   # base = 0   # ベースタスクなし
    #   #   # base = 1   # 最低1タスク
    #   #   # base = 2   # 最低2タスク
    #   #   base = 0
    #   # }
    #
    #   ################################################################################
    #   # ECS Placement Strategy
    #   ################################################################################
    #
    #   # placement_strategy - (Optional) 最大5個の配置戦略のセット
    #   # タスクをECSクラスター内のインスタンスにどのように配置するかを制御します
    #   # placement_strategy {
    #   #   # type - (Required) 配置戦略のタイプ
    #   #   # 値: random, spread, binpack
    #   #   #
    #   #   # random: タスクをランダムに配置
    #   #   # spread: 指定したフィールドの値に基づいてタスクを均等に分散
    #   #   # binpack: 指定したフィールドに基づいて最小限のリソースを使用してタスクを配置
    #   #   #
    #   #   # 例:
    #   #   # type = "spread"
    #   #   # type = "binpack"
    #   #   # type = "random"
    #   #   type = "spread"
    #   #
    #   #   # field - (Optional) 配置戦略を適用するフィールド
    #   #   # typeがrandom以外の場合に使用します
    #   #   #
    #   #   # spread: attribute:ecs.availability-zone, instanceId
    #   #   # binpack: cpu, memory
    #   #   #
    #   #   # 例:
    #   #   # field = "attribute:ecs.availability-zone"  # AZ間で分散
    #   #   # field = "instanceId"                       # インスタンス間で分散
    #   #   # field = "memory"                           # メモリ使用量でbinpack
    #   #   field = "attribute:ecs.availability-zone"
    #   # }
    #
    #   ################################################################################
    #   # ECS Placement Constraints
    #   ################################################################################
    #
    #   # placement_constraints - (Optional) タスクに使用する最大10個の配置制約のセット
    #   # タスクを配置できるインスタンスを制限する場合に使用します
    #   # placement_constraints {
    #   #   # type - (Required) 制約のタイプ
    #   #   # 値: distinctInstance, memberOf
    #   #   #
    #   #   # distinctInstance: 各タスクが異なるインスタンスに配置される
    #   #   # memberOf: クラスタークエリ言語式で指定されたインスタンスにタスクを配置
    #   #   #
    #   #   # 例:
    #   #   # type = "distinctInstance"
    #   #   # type = "memberOf"
    #   #   type = "memberOf"
    #   #
    #   #   # expression - (Optional) 制約に適用するクラスタークエリ言語式
    #   #   # typeがdistinctInstanceの場合は指定できません
    #   #   #
    #   #   # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-query-language.html
    #   #   #
    #   #   # 例:
    #   #   # expression = "attribute:ecs.instance-type =~ t2.*"
    #   #   # expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
    #   #   expression = "attribute:ecs.instance-type =~ t3.*"
    #   # }
    # }

    ################################################################################
    # EventBridge Parameters
    ################################################################################

    # eventbridge_parameters - (Optional) EventBridge PutEvents APIオペレーションのテンプレート化されたターゲットタイプ
    # EventBusにカスタムイベントを送信する場合に使用します
    # eventbridge_parameters {
    #   # detail_type - (Required) イベント詳細で期待されるフィールドを決定するための自由形式の文字列
    #   # 最大128文字
    #   #
    #   # イベントのカテゴリやタイプを示すラベルとして使用します
    #   #
    #   # 例:
    #   # detail_type = "Scheduled Task Execution"
    #   # detail_type = "Backup Job Completed"
    #   # detail_type = "Data Sync Event"
    #   detail_type = "Scheduled Event"
    #
    #   # source - (Required) イベントのソース
    #   # イベントを生成したサービスやアプリケーションを識別します
    #   #
    #   # 命名規則: リバースドメイン形式を推奨
    #   # 例: com.mycompany.myapp
    #   #
    #   # 例:
    #   # source = "com.example.scheduler"
    #   # source = "custom.backup.service"
    #   # source = "myapp.scheduled.jobs"
    #   source = "custom.scheduler"
    # }

    ################################################################################
    # Kinesis Parameters
    ################################################################################

    # kinesis_parameters - (Optional) Amazon Kinesis PutRecord APIオペレーションのテンプレート化されたターゲットタイプ
    # Kinesisストリームにレコードを送信する場合に使用します
    # kinesis_parameters {
    #   # partition_key - (Required) EventBridge Schedulerがイベントを送信するシャードを指定
    #   # 最大256文字
    #   #
    #   # 同じパーティションキーを持つレコードは同じシャードに送信されます
    #   # これにより、レコードの順序が保証されます
    #   #
    #   # 例:
    #   # partition_key = "user-123"
    #   # partition_key = "device-abc"
    #   # partition_key = "order-456"
    #   partition_key = "default"
    # }

    ################################################################################
    # SageMaker Pipeline Parameters
    ################################################################################

    # sagemaker_pipeline_parameters - (Optional) Amazon SageMaker StartPipelineExecution APIオペレーションのテンプレート化されたターゲットタイプ
    # SageMakerパイプラインを実行する場合に使用します
    # sagemaker_pipeline_parameters {
    #   # pipeline_parameter - (Optional) SageMakerモデル構築パイプライン実行を開始するために使用する最大200個のパラメータ名と値のセット
    #   # パイプラインの実行時にパラメータを渡す場合に使用します
    #   pipeline_parameter {
    #     # name - (Required) SageMakerモデル構築パイプライン実行を開始するパラメータの名前
    #     # パイプライン定義で定義されたパラメータ名と一致する必要があります
    #     #
    #     # 例:
    #     # name = "TrainingInstanceType"
    #     # name = "InputDataPath"
    #     # name = "ModelApprovalStatus"
    #     name = "ParameterName"
    #
    #     # value - (Required) SageMakerモデル構築パイプライン実行を開始するパラメータの値
    #     # パイプラインで期待される値の形式と一致する必要があります
    #     #
    #     # 例:
    #     # value = "ml.m5.xlarge"
    #     # value = "s3://my-bucket/training-data/"
    #     # value = "Approved"
    #     value = "ParameterValue"
    #   }
    # }

    ################################################################################
    # SQS Parameters
    ################################################################################

    # sqs_parameters - (Optional) Amazon SQS SendMessage APIオペレーションのテンプレート化されたターゲットタイプ
    # SQSキューにメッセージを送信する場合に使用します
    # sqs_parameters {
    #   # message_group_id - (Optional) ターゲットとして使用するFIFOメッセージグループID
    #   # FIFO（先入れ先出し）キューを使用する場合に必須です
    #   #
    #   # 同じメッセージグループIDを持つメッセージは順序が保証され、
    #   # 1つずつ処理されます
    #   #
    #   # 例:
    #   # message_group_id = "order-processing-group"
    #   # message_group_id = "user-notifications-group"
    #   # message_group_id = "group-1"
    #   message_group_id = "default-group"
    # }
  }

  ################################################################################
  # Encryption Configuration
  ################################################################################

  # kms_key_arn - (Optional) EventBridge Schedulerがデータの暗号化と復号化に使用するカスタマー管理のKMSキーのARN
  # 指定しない場合、AWSが管理するキーで暗号化されます
  #
  # KMSキーを使用すると、スケジュールのペイロードや機密情報を追加のセキュリティで保護できます
  #
  # 例:
  # kms_key_arn = aws_kms_key.scheduler.arn
  # kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  # kms_key_arn = aws_kms_key.example.arn
}

################################################################################
# Outputs
################################################################################

# スケジュールのID（名前）を出力
output "scheduler_schedule_id" {
  description = "The ID (name) of the EventBridge Scheduler schedule"
  value       = aws_scheduler_schedule.example.id
}

# スケジュールのARNを出力
output "scheduler_schedule_arn" {
  description = "The ARN of the EventBridge Scheduler schedule"
  value       = aws_scheduler_schedule.example.arn
}

################################################################################
# 使用例とベストプラクティス
################################################################################

# 例1: SQSキューへの定期メッセージ送信
# resource "aws_scheduler_schedule" "sqs_hourly" {
#   name       = "hourly-sqs-message"
#   group_name = "default"
#
#   flexible_time_window {
#     mode = "OFF"
#   }
#
#   schedule_expression = "rate(1 hours)"
#
#   target {
#     arn      = aws_sqs_queue.target.arn
#     role_arn = aws_iam_role.scheduler.arn
#
#     input = jsonencode({
#       timestamp = "{{scheduled-time}}"
#       message   = "Hourly scheduled message"
#     })
#
#     retry_policy {
#       maximum_retry_attempts       = 3
#       maximum_event_age_in_seconds = 3600
#     }
#   }
# }

# 例2: Lambda関数の毎日実行（日本時間）
# resource "aws_scheduler_schedule" "daily_lambda" {
#   name        = "daily-data-processing"
#   description = "毎日午前3時（日本時間）にデータ処理を実行"
#   group_name  = "production-schedules"
#
#   flexible_time_window {
#     mode = "OFF"
#   }
#
#   schedule_expression          = "cron(0 3 * * ? *)"
#   schedule_expression_timezone = "Asia/Tokyo"
#
#   target {
#     arn      = aws_lambda_function.processor.arn
#     role_arn = aws_iam_role.scheduler.arn
#
#     input = jsonencode({
#       action = "process_daily_data"
#       date   = "{{execution-date}}"
#     })
#
#     dead_letter_config {
#       arn = aws_sqs_queue.dlq.arn
#     }
#   }
# }

# 例3: ECSタスクの週次実行
# resource "aws_scheduler_schedule" "weekly_ecs_task" {
#   name        = "weekly-report-generation"
#   description = "毎週月曜日午前9時にレポート生成タスクを実行"
#
#   flexible_time_window {
#     mode                      = "FLEXIBLE"
#     maximum_window_in_minutes = 30
#   }
#
#   schedule_expression          = "cron(0 9 ? * MON *)"
#   schedule_expression_timezone = "Asia/Tokyo"
#
#   target {
#     arn      = aws_ecs_cluster.main.arn
#     role_arn = aws_iam_role.scheduler.arn
#
#     ecs_parameters {
#       task_definition_arn = aws_ecs_task_definition.report.arn
#       task_count          = 1
#       launch_type         = "FARGATE"
#       platform_version    = "LATEST"
#
#       network_configuration {
#         subnets          = [aws_subnet.private.id]
#         security_groups  = [aws_security_group.ecs.id]
#         assign_public_ip = false
#       }
#     }
#
#     retry_policy {
#       maximum_retry_attempts       = 2
#       maximum_event_age_in_seconds = 7200
#     }
#   }
# }

# 例4: ユニバーサルターゲットを使用したSQS送信
# resource "aws_scheduler_schedule" "universal_target" {
#   name = "universal-sqs-sender"
#
#   flexible_time_window {
#     mode = "OFF"
#   }
#
#   schedule_expression = "rate(30 minutes)"
#
#   target {
#     arn      = "arn:aws:scheduler:::aws-sdk:sqs:sendMessage"
#     role_arn = aws_iam_role.scheduler.arn
#
#     input = jsonencode({
#       MessageBody = "Scheduled message from EventBridge Scheduler"
#       QueueUrl    = aws_sqs_queue.target.url
#     })
#   }
# }

# 例5: 一度限りの実行（実行後に削除）
# resource "aws_scheduler_schedule" "one_time_execution" {
#   name        = "one-time-migration"
#   description = "2024年12月31日に一度だけ実行するマイグレーションタスク"
#
#   flexible_time_window {
#     mode = "OFF"
#   }
#
#   schedule_expression      = "at(2024-12-31T23:59:00)"
#   action_after_completion = "DELETE"
#
#   target {
#     arn      = aws_lambda_function.migration.arn
#     role_arn = aws_iam_role.scheduler.arn
#   }
# }

# ベストプラクティス:
# 1. スケジュールグループを使用して関連するスケジュールを論理的にグループ化する
# 2. 適切なタイムゾーンを設定してCron式を使用する
# 3. リトライポリシーとデッドレターキューを設定してエラーハンドリングを強化する
# 4. IAMロールに最小権限の原則を適用する
# 5. 柔軟な時間枠（FLEXIBLE mode）を使用して負荷を分散する
# 6. KMS暗号化を使用して機密データを保護する
# 7. タグを使用してリソースを管理・追跡する
# 8. CloudWatch Logsでスケジュールの実行状況を監視する
