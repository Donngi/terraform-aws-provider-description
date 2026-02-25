#---------------------------------------------------------------
# Amazon EventBridge Scheduler Schedule
#---------------------------------------------------------------
#
# Amazon EventBridge Schedulerのスケジュールをプロビジョニングするリソースです。
# スケジュールは、指定した日時や頻度でAWSサービスのAPIオペレーションを自動的に
# 呼び出すための主要リソースです。rate式、cron式、または1回限りのat式を使用して
# スケジュールを定義し、200以上のAWSサービスをターゲットとして指定できます。
#
# AWS公式ドキュメント:
#   - EventBridge Schedulerとは: https://docs.aws.amazon.com/scheduler/latest/UserGuide/what-is-scheduler.html
#   - スケジュール管理: https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-schedule.html
#   - スケジュール式タイプ: https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_scheduler_schedule" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: スケジュールの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "my-schedule"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: スケジュール名のプレフィックスを指定します。Terraformが後ろにランダムなサフィックスを追加します。
  # 設定可能な値: 文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

  #-------------------------------------------------------------
  # スケジュールグループ設定
  #-------------------------------------------------------------

  # group_name (Optional, Forces new resource)
  # 設定内容: このスケジュールを関連付けるスケジュールグループ名を指定します。
  # 設定可能な値: 既存のスケジュールグループ名の文字列
  # 省略時: デフォルトスケジュールグループ（"default"）が使用されます。
  group_name = "default"

  #-------------------------------------------------------------
  # スケジュール式設定
  #-------------------------------------------------------------

  # schedule_expression (Required)
  # 設定内容: スケジュールの実行タイミングを定義する式を指定します。
  # 設定可能な値:
  #   - "rate(<値> <単位>)": 一定間隔で実行。例: "rate(1 hours)", "rate(5 minutes)", "rate(1 day)"
  #   - "cron(<分> <時> <日> <月> <曜日> <年>)": cron式で実行。例: "cron(0 12 * * ? *)"
  #   - "at(<日時>)": 1回限りの実行。例: "at(2030-01-01T00:00:00)"
  # 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html
  schedule_expression = "rate(1 hours)"

  # schedule_expression_timezone (Optional)
  # 設定内容: スケジュール式を評価するタイムゾーンを指定します。
  # 設定可能な値: IANAタイムゾーンデータベースのタイムゾーン識別子。例: "Asia/Tokyo", "Australia/Sydney", "America/New_York"
  # 省略時: "UTC"が使用されます。
  # 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html
  schedule_expression_timezone = "Asia/Tokyo"

  #-------------------------------------------------------------
  # スケジュール有効期間設定
  #-------------------------------------------------------------

  # start_date (Optional)
  # 設定内容: スケジュールがターゲットを呼び出し始めることができるUTCの日時を指定します。
  # 設定可能な値: ISO 8601形式の日時文字列。例: "2030-01-01T01:00:00Z"
  # 省略時: 制限なし（作成直後から有効）
  # 注意: 1回限りスケジュールの場合、この値は無視されます。
  start_date = null

  # end_date (Optional)
  # 設定内容: スケジュールがターゲットを呼び出すことができるUTCの終了日時を指定します。
  # 設定可能な値: ISO 8601形式の日時文字列。例: "2030-12-31T23:59:59Z"
  # 省略時: 制限なし（終了日なし）
  # 注意: 1回限りスケジュールの場合、この値は無視されます。
  end_date = null

  #-------------------------------------------------------------
  # スケジュール状態設定
  #-------------------------------------------------------------

  # state (Optional)
  # 設定内容: スケジュールが有効か無効かを指定します。
  # 設定可能な値:
  #   - "ENABLED" (デフォルト): スケジュールを有効化します。
  #   - "DISABLED": スケジュールを無効化します。
  # 省略時: "ENABLED"
  state = "ENABLED"

  #-------------------------------------------------------------
  # 完了後アクション設定
  #-------------------------------------------------------------

  # action_after_completion (Optional)
  # 設定内容: ターゲット呼び出し完了後にスケジュールに適用するアクションを指定します。
  # 設定可能な値:
  #   - "NONE" (デフォルト): スケジュールを保持します。
  #   - "DELETE": スケジュールを自動的に削除します。1回限りスケジュールの自動クリーンアップに有用です。
  # 省略時: "NONE"
  action_after_completion = "NONE"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: スケジュールの簡単な説明を指定します。
  # 設定可能な値: 文字列
  description = "毎時1回SQSキューにメッセージを送信するスケジュール"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_arn (Optional)
  # 設定内容: EventBridge Schedulerがデータの暗号化・復号化に使用するカスタマーマネージドKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWSマネージドキーで暗号化されます。
  kms_key_arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # フレキシブルタイムウィンドウ設定
  #-------------------------------------------------------------

  # flexible_time_window (Required)
  # 設定内容: EventBridge Schedulerがスケジュールを呼び出す時間ウィンドウを設定するブロックです。
  # フレキシブルタイムウィンドウを使用すると、指定した時間範囲内のランダムなタイミングで
  # スケジュールが実行されます。これにより、同時実行のトラフィックスパイクを緩和できます。
  # 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-schedule.html
  flexible_time_window {

    # mode (Required)
    # 設定内容: フレキシブルタイムウィンドウを使用するかどうかを指定します。
    # 設定可能な値:
    #   - "OFF": フレキシブルタイムウィンドウを無効化し、正確なスケジュール時刻に実行します。
    #   - "FLEXIBLE": 指定した最大時間ウィンドウ内のランダムなタイミングで実行します。
    mode = "OFF"

    # maximum_window_in_minutes (Optional)
    # 設定内容: スケジュールを呼び出すことができる最大時間ウィンドウを分単位で指定します。
    # 設定可能な値: 1〜1440の整数
    # 省略時: modeが"FLEXIBLE"の場合は必須です。modeが"OFF"の場合は不要です。
    maximum_window_in_minutes = null
  }

  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # target (Required)
  # 設定内容: スケジュールによって呼び出されるターゲットを設定するブロックです。
  # SQS、Lambda、ECS、EventBridge等のAWSサービスや、ユニバーサルターゲットとして
  # AWS SDK API操作を直接呼び出すことができます。
  # 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-targets-universal.html
  target {

    # arn (Required)
    # 設定内容: ターゲットのARNを指定します。SQSキュー、ECSクラスター等のARN、または
    # ユニバーサルターゲットの場合はサービス固有のARNを指定します。
    # 設定可能な値: 有効なターゲットARN。例: SQSキューARN、またはユニバーサルターゲットARN "arn:aws:scheduler:::aws-sdk:sqs:sendMessage"
    # 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-targets-universal.html#supported-universal-targets
    arn = "arn:aws:sqs:ap-northeast-1:123456789012:my-queue"

    # role_arn (Required)
    # 設定内容: スケジュールが呼び出されたときにEventBridge Schedulerがこのターゲットに使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/setting-up.html#setting-up-execution-role
    role_arn = "arn:aws:iam::123456789012:role/scheduler-execution-role"

    # input (Optional)
    # 設定内容: ターゲットに渡すテキストまたは整形されたJSONを指定します。
    # 設定可能な値: テキスト文字列または整形されたJSON文字列
    # 省略時: ターゲットに入力は渡されません。
    # 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-targets-universal.html
    input = jsonencode({
      MessageBody = "Hello from EventBridge Scheduler!"
    })

    #-----------------------------------------------------------
    # デッドレターキュー設定
    #-----------------------------------------------------------

    # dead_letter_config (Optional)
    # 設定内容: 配信に失敗したイベントを送信するSQSキューを設定するブロックです。
    # リトライポリシーが尽きた後も配信できなかったイベントがデッドレターキューに送信されます。
    # 参考: https://docs.aws.amazon.com/scheduler/latest/UserGuide/managing-schedule.html
    dead_letter_config {

      # arn (Required)
      # 設定内容: デッドレターキューとして指定するSQSキューのARNを指定します。
      # 設定可能な値: 有効なSQSキューARN
      arn = "arn:aws:sqs:ap-northeast-1:123456789012:my-dlq"
    }

    #-----------------------------------------------------------
    # リトライポリシー設定
    #-----------------------------------------------------------

    # retry_policy (Optional)
    # 設定内容: リトライポリシーの設定ブロックです。ターゲット呼び出しが失敗した場合の
    # リトライ動作を設定します。
    retry_policy {

      # maximum_event_age_in_seconds (Optional)
      # 設定内容: リトライを継続する最大時間を秒単位で指定します。
      # 設定可能な値: 60〜86400の整数
      # 省略時: 86400（デフォルト）
      maximum_event_age_in_seconds = 86400

      # maximum_retry_attempts (Optional)
      # 設定内容: リクエストが失敗する前に実行するリトライの最大回数を指定します。
      # 設定可能な値: 0〜185の整数
      # 省略時: 185（デフォルト）
      maximum_retry_attempts = 185
    }

    #-----------------------------------------------------------
    # ECSパラメーター設定
    #-----------------------------------------------------------

    # ecs_parameters (Optional)
    # 設定内容: Amazon ECS RunTask APIオペレーションのテンプレート化されたターゲットタイプの設定ブロックです。
    # ターゲットのARNがECSクラスターの場合に使用します。
    # 参考: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_RunTask.html
    ecs_parameters {

      # task_definition_arn (Required)
      # 設定内容: 使用するタスク定義のARNを指定します。
      # 設定可能な値: 有効なECSタスク定義ARN
      task_definition_arn = "arn:aws:ecs:ap-northeast-1:123456789012:task-definition/my-task:1"

      # task_count (Optional)
      # 設定内容: 作成するタスク数を指定します。
      # 設定可能な値: 1〜10の整数
      # 省略時: 1
      task_count = 1

      # launch_type (Optional)
      # 設定内容: タスクを実行するラウンチタイプを指定します。
      # 設定可能な値:
      #   - "EC2": EC2インスタンスでタスクを実行します。
      #   - "FARGATE": AWS Fargateでタスクを実行します。
      #   - "EXTERNAL": 外部インフラストラクチャでタスクを実行します。
      # 省略時: タスク定義の互換性設定に依存します。
      launch_type = "FARGATE"

      # platform_version (Optional)
      # 設定内容: タスクのプラットフォームバージョンを指定します。数値部分のみ指定します。
      # 設定可能な値: "1.1.0", "1.4.0", "LATEST" 等
      # 省略時: AWSが最新バージョンを使用します。
      platform_version = "LATEST"

      # group (Optional)
      # 設定内容: タスクのECSタスクグループを指定します。
      # 設定可能な値: 最大255文字の文字列
      group = null

      # enable_ecs_managed_tags (Optional)
      # 設定内容: タスクにAmazon ECSマネージドタグを有効化するかを指定します。
      # 設定可能な値:
      #   - true: ECSマネージドタグを有効化します。
      #   - false: ECSマネージドタグを無効化します。
      # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-using-tags.html
      enable_ecs_managed_tags = false

      # enable_execute_command (Optional)
      # 設定内容: このタスク内のコンテナに対してExecuteCommandを有効化するかを指定します。
      # 設定可能な値:
      #   - true: ExecuteCommandを有効化します。
      #   - false: ExecuteCommandを無効化します。
      enable_execute_command = false

      # propagate_tags (Optional)
      # 設定内容: タグをタスク定義からタスクに伝播するかを指定します。
      # 設定可能な値:
      #   - "TASK_DEFINITION": タスク定義のタグをタスクに伝播します。
      propagate_tags = null

      # reference_id (Optional)
      # 設定内容: タスクの参照IDを指定します。
      # 設定可能な値: 文字列
      reference_id = null

      # tags (Optional)
      # 設定内容: タスクに適用するメタデータのタグを指定します。
      # 設定可能な値: キーと値のペアのマップ
      tags = {
        ManagedBy = "EventBridgeScheduler"
      }

      # capacity_provider_strategy (Optional)
      # 設定内容: タスクに使用するキャパシティプロバイダーストラテジーを設定するブロックです。
      # 最大6つのキャパシティプロバイダーストラテジーを指定できます。
      capacity_provider_strategy {

        # capacity_provider (Required)
        # 設定内容: キャパシティプロバイダーの短い名前を指定します。
        # 設定可能な値: 有効なキャパシティプロバイダー名
        capacity_provider = "FARGATE_SPOT"

        # base (Optional)
        # 設定内容: 指定したキャパシティプロバイダーで実行するタスクの最小数を指定します。
        # ストラテジー内で1つのキャパシティプロバイダーのみbaseを定義できます。
        # 設定可能な値: 0〜100000の整数
        # 省略時: 0
        base = 0

        # weight (Optional)
        # 設定内容: 起動するタスクの合計数のうち、指定したキャパシティプロバイダーを使用する割合を指定します。
        # 設定可能な値: 0〜1000の整数
        weight = 1
      }

      # network_configuration (Optional)
      # 設定内容: タスクに関連付けるネットワーク設定ブロックです。
      network_configuration {

        # subnets (Required)
        # 設定内容: タスクに関連付けるサブネットIDのセットを指定します。
        # 設定可能な値: 1〜16個の有効なサブネットIDのセット。同一VPC内のサブネットを指定します。
        subnets = ["subnet-12345678", "subnet-87654321"]

        # security_groups (Optional)
        # 設定内容: タスクに関連付けるセキュリティグループIDのセットを指定します。
        # 設定可能な値: 1〜5個の有効なセキュリティグループIDのセット。同一VPC内のセキュリティグループを指定します。
        security_groups = ["sg-12345678"]

        # assign_public_ip (Optional)
        # 設定内容: タスクのElastic Network InterfaceにパブリックIPアドレスを割り当てるかを指定します。
        # 設定可能な値:
        #   - true: パブリックIPアドレスを割り当てます（ENABLED相当）。launch_typeが"FARGATE"の場合のみ指定可能。
        #   - false: パブリックIPアドレスを割り当てません（DISABLED相当）。
        assign_public_ip = false
      }

      # placement_constraints (Optional)
      # 設定内容: タスクのプレイスメント制約のセットを設定するブロックです。最大10件指定できます。
      placement_constraints {

        # type (Required)
        # 設定内容: 制約のタイプを指定します。
        # 設定可能な値:
        #   - "distinctInstance": 各タスクを異なるコンテナインスタンスに配置します。
        #   - "memberOf": クラスタークエリ言語式を使用して条件に合うインスタンスにタスクを配置します。
        type = "memberOf"

        # expression (Optional)
        # 設定内容: 制約に適用するクラスタークエリ言語の式を指定します。
        # 設定可能な値: クラスタークエリ言語の式文字列
        # 省略時: 制約タイプが"distinctInstance"の場合は指定不可。
        # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-query-language.html
        expression = "attribute:ecs.instance-type =~ t3.*"
      }

      # placement_strategy (Optional)
      # 設定内容: タスクのプレイスメントストラテジーのセットを設定するブロックです。最大5件指定できます。
      placement_strategy {

        # type (Required)
        # 設定内容: プレイスメントストラテジーのタイプを指定します。
        # 設定可能な値:
        #   - "random": タスクをランダムに配置します。
        #   - "spread": 指定したフィールドに基づいてタスクを均等に分散します。
        #   - "binpack": CPUまたはメモリの使用量が最小のインスタンスにタスクを配置します。
        type = "spread"

        # field (Optional)
        # 設定内容: プレイスメントストラテジーを適用するフィールドを指定します。
        # 設定可能な値: "instanceId", "host", "attribute:ecs.availability-zone" 等
        field = "attribute:ecs.availability-zone"
      }
    }

    #-----------------------------------------------------------
    # EventBridgeパラメーター設定
    #-----------------------------------------------------------

    # eventbridge_parameters (Optional)
    # 設定内容: EventBridge PutEvents APIオペレーションのテンプレート化されたターゲットタイプの設定ブロックです。
    # 参考: https://docs.aws.amazon.com/eventbridge/latest/APIReference/API_PutEvents.html
    eventbridge_parameters {

      # detail_type (Required)
      # 設定内容: イベント詳細のフィールドを決定するために使用する自由形式の文字列を指定します。
      # 設定可能な値: 最大128文字の文字列
      detail_type = "MyScheduledEvent"

      # source (Required)
      # 設定内容: イベントのソースを指定します。
      # 設定可能な値: 文字列
      source = "com.mycompany.scheduler"
    }

    #-----------------------------------------------------------
    # Kinesisパラメーター設定
    #-----------------------------------------------------------

    # kinesis_parameters (Optional)
    # 設定内容: Amazon Kinesis PutRecord APIオペレーションのテンプレート化されたターゲットタイプの設定ブロックです。
    # 参考: https://docs.aws.amazon.com/kinesis/latest/APIReference/API_PutRecord.html
    kinesis_parameters {

      # partition_key (Required)
      # 設定内容: EventBridge SchedulerがイベントをKinesisストリームのどのシャードに送信するかを指定します。
      # 設定可能な値: 最大256文字の文字列
      partition_key = "my-partition-key"
    }

    #-----------------------------------------------------------
    # SageMakerパイプラインパラメーター設定
    #-----------------------------------------------------------

    # sagemaker_pipeline_parameters (Optional)
    # 設定内容: Amazon SageMaker AI StartPipelineExecution APIオペレーションのテンプレート化されたターゲットタイプの設定ブロックです。
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_StartPipelineExecution.html
    sagemaker_pipeline_parameters {

      # pipeline_parameter (Optional)
      # 設定内容: SageMaker AIモデルビルディングパイプラインの実行時に使用するパラメーター名と値のセットを設定するブロックです。
      # 最大200件指定できます。
      pipeline_parameter {

        # name (Required)
        # 設定内容: SageMaker AIモデルビルディングパイプラインの実行を開始するパラメーター名を指定します。
        # 設定可能な値: 文字列
        name = "my-parameter"

        # value (Required)
        # 設定内容: SageMaker AIモデルビルディングパイプラインの実行を開始するパラメーターの値を指定します。
        # 設定可能な値: 文字列
        value = "my-value"
      }
    }

    #-----------------------------------------------------------
    # SQSパラメーター設定
    #-----------------------------------------------------------

    # sqs_parameters (Optional)
    # 設定内容: Amazon SQS SendMessage APIオペレーションのテンプレート化されたターゲットタイプの設定ブロックです。
    # 参考: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_SendMessage.html
    sqs_parameters {

      # message_group_id (Optional)
      # 設定内容: ターゲットとして使用するFIFOメッセージグループIDを指定します。
      # 設定可能な値: 文字列
      # 省略時: メッセージグループIDは設定されません。FIFOキューの場合は指定が必要です。
      message_group_id = null
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: スケジュールの名前
# - arn: スケジュールのARN
#---------------------------------------------------------------
