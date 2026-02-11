#---------------------------------------------------------------
# AWS Glue Trigger
#---------------------------------------------------------------
#
# AWS Glue Triggerは、ジョブやクローラーを開始するための起動メカニズムを
# プロビジョニングします。トリガーは、オンデマンド、スケジュール、条件、
# またはイベントベースで実行できます。
#
# AWS公式ドキュメント:
#   - AWS Glue triggers: https://docs.aws.amazon.com/glue/latest/dg/about-triggers.html
#   - Time-based schedules: https://docs.aws.amazon.com/glue/latest/dg/monitor-data-warehouse-schedule.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_trigger
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_trigger" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # トリガー名
  # AWS Glue内で一意である必要があります
  name = "example-trigger"

  # トリガータイプ
  # - CONDITIONAL: 条件付きトリガー（先行ジョブ/クローラーの完了状態に基づく）
  # - EVENT: イベントベーストリガー（EventBridgeイベントに基づく）
  # - ON_DEMAND: オンデマンドトリガー（手動実行）
  # - SCHEDULED: スケジュールトリガー（cron式に基づく）
  type = "CONDITIONAL"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # トリガーの説明
  description = "Trigger description"

  # トリガーの有効化
  # trueの場合、トリガーは作成後に有効化されます
  # デフォルト: true
  enabled = true

  # リージョン設定
  # このリソースが管理されるAWSリージョン
  # 省略時はプロバイダー設定のリージョンが使用されます
  # region = "us-east-1"

  # スケジュール設定（type = "SCHEDULED" の場合に使用）
  # cron式を使用してジョブやクローラーの実行スケジュールを指定
  # 例: "cron(15 12 * * ? *)" = 毎日12:15 UTC
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/monitor-data-warehouse-schedule.html
  schedule = "cron(0 12 * * ? *)"

  # 作成時の開始設定
  # trueの場合、SCHEDULEDおよびCONDITIONALトリガーが作成時に開始されます
  # ON_DEMANDトリガーではtrueはサポートされていません
  start_on_creation = true

  # ワークフロー名
  # トリガーを関連付けるワークフロー名
  # ワークフローのDAGには開始トリガー（ON_DEMANDまたはSCHEDULED）が必要で、
  # 複数のCONDITIONALトリガーを含めることができます
  workflow_name = "example-workflow"

  # リソースタグ
  # Key-Value形式でタグを設定
  tags = {
    Environment = "production"
    Project     = "data-pipeline"
  }

  #---------------------------------------------------------------
  # actionsブロック（必須）
  # トリガー発火時に実行されるアクションを定義
  #---------------------------------------------------------------
  actions {
    # ジョブ名（crawler_nameと排他）
    # 実行するGlueジョブの名前
    job_name = "example-job"

    # クローラー名（job_nameと排他）
    # 実行するGlueクローラーの名前
    # crawler_name = "example-crawler"

    # ジョブ引数
    # ジョブに渡される引数（Key-Valueペア）
    # AWS Glueが使用する引数と、ユーザースクリプトが使用する引数の両方を指定可能
    arguments = {
      "--job-language"        = "python"
      "--additional-argument" = "value"
    }

    # タイムアウト設定（分単位）
    # ジョブのタイムアウト値を上書きします
    timeout = 60

    # セキュリティ設定
    # このアクションで使用されるセキュリティ設定構造の名前
    security_configuration = "example-security-config"

    # 通知プロパティ
    # ジョブ実行通知の設定プロパティ
    notification_property {
      # ジョブ実行開始後、遅延通知を送信するまでの待機時間（分単位）
      notify_delay_after = 20
    }
  }

  # 複数アクションの例（複数のジョブやクローラーを同時に開始）
  # actions {
  #   job_name = "second-job"
  # }

  #---------------------------------------------------------------
  # predicateブロック（type = "CONDITIONAL" の場合に必須）
  # トリガーが発火するための条件を定義
  #---------------------------------------------------------------
  predicate {
    # 論理演算子
    # 複数の条件をどのように処理するか
    # - AND: すべての条件が満たされた場合に発火（デフォルト）
    # - ANY: いずれかの条件が満たされた場合に発火
    logical = "AND"

    # 条件リスト（必須）
    # 監視するジョブやクローラーの完了状態を定義
    conditions {
      # ジョブ名（crawler_nameと排他）
      # 監視対象のジョブ名
      # 指定した場合、stateも指定する必要があります
      job_name = "prerequisite-job"

      # ジョブの完了状態（job_name指定時に必須、crawl_stateと排他）
      # 監視する状態: SUCCEEDED, STOPPED, TIMEOUT, FAILED
      state = "SUCCEEDED"

      # クローラー名（job_nameと排他）
      # 監視対象のクローラー名
      # 指定した場合、crawl_stateも指定する必要があります
      # crawler_name = "prerequisite-crawler"

      # クローラーの完了状態（crawler_name指定時に必須、stateと排他）
      # 監視する状態: RUNNING, SUCCEEDED, CANCELLED, FAILED
      # crawl_state = "SUCCEEDED"

      # 論理演算子
      # 条件の比較演算子（デフォルト: EQUALS）
      logical_operator = "EQUALS"
    }

    # 複数条件の例
    # conditions {
    #   job_name = "another-job"
    #   state    = "SUCCEEDED"
    # }
  }

  #---------------------------------------------------------------
  # event_batching_conditionブロック（type = "EVENT" の場合にオプション）
  # EventBridgeイベントトリガーのバッチ処理条件を定義
  #---------------------------------------------------------------
  # event_batching_condition {
  #   # バッチサイズ（必須）
  #   # EventBridgeイベントトリガーが発火するまでに
  #   # Amazon EventBridgeから受信する必要があるイベント数
  #   batch_size = 10
  #
  #   # バッチウィンドウ（秒単位）
  #   # 最初のイベントを受信してからEventBridgeイベントトリガーが発火するまでの
  #   # 時間ウィンドウ（デフォルト: 900秒）
  #   batch_window = 900
  # }

  #---------------------------------------------------------------
  # timeoutsブロック（オプション）
  # リソース操作のタイムアウト設定
  #---------------------------------------------------------------
  # timeouts {
  #   # 作成操作のタイムアウト
  #   create = "5m"
  #
  #   # 削除操作のタイムアウト
  #   delete = "5m"
  #
  #   # 更新操作のタイムアウト
  #   update = "5m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能です:
#
# - arn: GlueトリガーのAmazon Resource Name (ARN)
# - id: トリガー名
# - state: トリガーの現在の状態
# - tags_all: リソースに割り当てられたすべてのタグ
#             （プロバイダーのdefault_tagsから継承されたタグを含む）
#---------------------------------------------------------------
