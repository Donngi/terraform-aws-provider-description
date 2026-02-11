#---------------------------------------------------------------
# AWS SSM Maintenance Window Task
#---------------------------------------------------------------
#
# AWS Systems Manager メンテナンスウィンドウに登録するタスクをプロビジョニングするリソースです。
# メンテナンスウィンドウタスクは、指定されたメンテナンスウィンドウの時間枠内で
# 自動的に実行されるアクション（Run Command、Automation、Lambda、Step Functions）を定義します。
#
# AWS公式ドキュメント:
#   - メンテナンスウィンドウ概要: https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-maintenance.html
#   - メンテナンスウィンドウタスク: https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-assign-tasks.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window_task
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_maintenance_window_task" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # window_id (Required)
  # 設定内容: タスクを登録するメンテナンスウィンドウのIDを指定します。
  # 設定可能な値: 有効なメンテナンスウィンドウID
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-maintenance.html
  window_id = aws_ssm_maintenance_window.example.id

  # task_type (Required)
  # 設定内容: 登録するタスクの種類を指定します。
  # 設定可能な値:
  #   - "AUTOMATION": SSM Automationドキュメントを実行
  #   - "LAMBDA": Lambda関数を呼び出し
  #   - "RUN_COMMAND": SSM Run Commandでコマンドを実行
  #   - "STEP_FUNCTIONS": Step Functionsステートマシンを実行
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-assign-tasks.html
  task_type = "RUN_COMMAND"

  # task_arn (Required)
  # 設定内容: 実行するタスクのARNまたはドキュメント名を指定します。
  # 設定可能な値:
  #   - AUTOMATION: Automationドキュメント名（例: "AWS-RestartEC2Instance"）
  #   - LAMBDA: Lambda関数のARN
  #   - RUN_COMMAND: SSMドキュメント名（例: "AWS-RunShellScript"）
  #   - STEP_FUNCTIONS: Step FunctionsアクティビティのARN
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-doc-syntaxref.html
  task_arn = "AWS-RunShellScript"

  #-------------------------------------------------------------
  # 名前・説明設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: メンテナンスウィンドウタスクの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-maintenance-task"

  # description (Optional)
  # 設定内容: メンテナンスウィンドウタスクの説明を指定します。
  # 設定可能な値: 文字列
  description = "Example maintenance window task"

  #-------------------------------------------------------------
  # 実行制御設定
  #-------------------------------------------------------------

  # priority (Optional)
  # 設定内容: メンテナンスウィンドウ内でのタスクの優先度を指定します。
  # 設定可能な値: 数値（小さいほど優先度が高い）
  # 注意: 同じ優先度のタスクは並列に実行されます。
  priority = 1

  # max_concurrency (Optional)
  # 設定内容: タスクを並列に実行できるターゲットの最大数を指定します。
  # 設定可能な値: 数値の文字列（例: "2"）またはパーセンテージ（例: "10%"）
  max_concurrency = "2"

  # max_errors (Optional)
  # 設定内容: タスクのスケジュールを停止するまでに許容されるエラーの最大数を指定します。
  # 設定可能な値: 数値の文字列（例: "1"）またはパーセンテージ（例: "10%"）
  max_errors = "1"

  # cutoff_behavior (Optional)
  # 設定内容: メンテナンスウィンドウのカットオフ時刻に達した後のタスクの動作を指定します。
  # 設定可能な値:
  #   - "CONTINUE_TASK": カットオフ時刻後もタスクの実行を継続
  #   - "CANCEL_TASK": カットオフ時刻でタスクをキャンセル
  # 関連機能: メンテナンスウィンドウのカットオフ動作
  #   メンテナンスウィンドウの終了時刻前にタスクが完了しない場合の動作を制御します。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-maintenance.html
  cutoff_behavior = "CANCEL_TASK"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # service_role_arn (Optional)
  # 設定内容: タスク実行時に使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: アカウントのSystems Managerサービスリンクロールを使用。
  #         存在しない場合は自動的に作成されます。
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/using-service-linked-roles.html
  service_role_arn = aws_iam_role.example.arn

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
  # ターゲット設定
  #-------------------------------------------------------------

  # targets (Optional, 最大5件)
  # 設定内容: タスクの対象となるインスタンスまたはウィンドウターゲットIDを指定します。
  # 関連機能: メンテナンスウィンドウターゲット
  #   インスタンスIDまたはウィンドウターゲットIDでタスクの実行対象を指定します。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-assign-targets.html
  targets {
    # key (Required)
    # 設定内容: ターゲットのキーを指定します。
    # 設定可能な値:
    #   - "InstanceIds": インスタンスIDで指定
    #   - "WindowTargetIds": ウィンドウターゲットIDで指定
    key = "InstanceIds"

    # values (Required)
    # 設定内容: ターゲットの値のリストを指定します。
    # 設定可能な値: インスタンスIDまたはウィンドウターゲットIDのリスト
    values = [aws_instance.example.id]
  }

  #-------------------------------------------------------------
  # タスク実行パラメータ設定
  #-------------------------------------------------------------

  # task_invocation_parameters (Optional)
  # 設定内容: タスク実行時のパラメータを指定します。
  # 注意: task_typeに応じて適切なパラメータブロックを指定してください。
  task_invocation_parameters {

    #-----------------------------------------------------------
    # Run Commandパラメータ (task_type = "RUN_COMMAND" の場合)
    #-----------------------------------------------------------

    # run_command_parameters (Optional)
    # 設定内容: RUN_COMMANDタスクの実行パラメータを指定します。
    run_command_parameters {

      # comment (Optional)
      # 設定内容: コマンドに関する情報を指定します。
      # 設定可能な値: 文字列
      comment = "Run shell script on target instances"

      # document_hash (Optional)
      # 設定内容: ドキュメント作成時にシステムが生成したハッシュ値を指定します。
      # 設定可能な値: SHA-256ハッシュ文字列
      # 注意: SHA-1は非推奨です。
      # document_hash = null

      # document_hash_type (Optional)
      # 設定内容: ハッシュのタイプを指定します。
      # 設定可能な値:
      #   - "Sha256": SHA-256ハッシュ
      #   - "Sha1": SHA-1ハッシュ（非推奨）
      # document_hash_type = null

      # document_version (Optional)
      # 設定内容: 使用するドキュメントのバージョンを指定します。
      # 設定可能な値: バージョン番号の文字列（例: "$LATEST", "$DEFAULT", "1"）
      # document_version = null

      # output_s3_bucket (Optional)
      # 設定内容: コマンド出力を保存するS3バケット名を指定します。
      # 設定可能な値: 有効なS3バケット名
      output_s3_bucket = aws_s3_bucket.example.id

      # output_s3_key_prefix (Optional)
      # 設定内容: S3バケット内のサブフォルダを指定します。
      # 設定可能な値: 文字列
      output_s3_key_prefix = "output"

      # service_role_arn (Optional)
      # 設定内容: SNS通知を発行するためのIAMサービスロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN
      service_role_arn = aws_iam_role.example.arn

      # timeout_seconds (Optional)
      # 設定内容: コマンド実行のタイムアウト秒数を指定します。
      # 設定可能な値: 数値（秒）
      # 注意: この時間に達してもコマンドが開始されていない場合、実行されません。
      timeout_seconds = 600

      # cloudwatch_config (Optional)
      # 設定内容: コマンド出力をCloudWatch Logsに送信するための設定を指定します。
      cloudwatch_config {
        # cloudwatch_log_group_name (Optional)
        # 設定内容: コマンド出力を送信するCloudWatch Logsロググループ名を指定します。
        # 省略時: Systems Managerが自動的にロググループを作成します。
        #         命名形式: aws/ssm/SystemsManagerDocumentName
        cloudwatch_log_group_name = "/aws/ssm/example"

        # cloudwatch_output_enabled (Optional)
        # 設定内容: コマンド出力をCloudWatch Logsに送信するかを指定します。
        # 設定可能な値:
        #   - true: CloudWatch Logsへの出力を有効化
        #   - false: CloudWatch Logsへの出力を無効化
        cloudwatch_output_enabled = true
      }

      # notification_config (Optional)
      # 設定内容: コマンドステータス変更時の通知設定を指定します。
      notification_config {
        # notification_arn (Optional)
        # 設定内容: 通知を送信するSNSトピックのARNを指定します。
        # 設定可能な値: 有効なSNSトピックARN
        notification_arn = aws_sns_topic.example.arn

        # notification_events (Optional)
        # 設定内容: 通知を受け取るイベントの種類を指定します。
        # 設定可能な値:
        #   - "All": すべてのイベント
        #   - "InProgress": 進行中
        #   - "Success": 成功
        #   - "TimedOut": タイムアウト
        #   - "Cancelled": キャンセル
        #   - "Failed": 失敗
        notification_events = ["All"]

        # notification_type (Optional)
        # 設定内容: 通知のタイプを指定します。
        # 設定可能な値:
        #   - "Command": コマンド全体のステータス変更時に通知
        #   - "Invocation": インスタンスごとのステータス変更時に通知（複数インスタンス向け）
        notification_type = "Command"
      }

      # parameter (Optional)
      # 設定内容: RUN_COMMANDタスク実行時のパラメータを指定します。
      parameter {
        # name (Required)
        # 設定内容: パラメータ名を指定します。
        name = "commands"

        # values (Required)
        # 設定内容: パラメータ値のリストを指定します。
        values = ["date"]
      }
    }

    #-----------------------------------------------------------
    # Automationパラメータ (task_type = "AUTOMATION" の場合)
    #-----------------------------------------------------------
    # automation_parameters {
    #   # document_version (Optional)
    #   # 設定内容: 使用するAutomationドキュメントのバージョンを指定します。
    #   document_version = "$LATEST"
    #
    #   # parameter (Optional)
    #   # 設定内容: Automationドキュメントのパラメータを指定します。
    #   parameter {
    #     name   = "InstanceId"
    #     values = [aws_instance.example.id]
    #   }
    # }

    #-----------------------------------------------------------
    # Lambdaパラメータ (task_type = "LAMBDA" の場合)
    #-----------------------------------------------------------
    # lambda_parameters {
    #   # client_context (Optional)
    #   # 設定内容: Lambda関数に渡すクライアント固有の情報を指定します。
    #   # 設定可能な値: Base64エンコードされた文字列
    #   client_context = base64encode("{\"key1\":\"value1\"}")
    #
    #   # payload (Optional, Sensitive)
    #   # 設定内容: Lambda関数への入力としてのJSONを指定します。
    #   # 注意: この値はセンシティブとしてマークされ、ログに表示されません。
    #   payload = "{\"key1\":\"value1\"}"
    #
    #   # qualifier (Optional)
    #   # 設定内容: Lambda関数のバージョンまたはエイリアス名を指定します。
    #   qualifier = "$LATEST"
    # }

    #-----------------------------------------------------------
    # Step Functionsパラメータ (task_type = "STEP_FUNCTIONS" の場合)
    #-----------------------------------------------------------
    # step_functions_parameters {
    #   # input (Optional, Sensitive)
    #   # 設定内容: STEP_FUNCTIONタスクへの入力を指定します。
    #   # 注意: この値はセンシティブとしてマークされ、ログに表示されません。
    #   input = "{\"key1\":\"value1\"}"
    #
    #   # name (Optional)
    #   # 設定内容: STEP_FUNCTIONタスクの名前を指定します。
    #   name = "example"
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: メンテナンスウィンドウタスクのARN
#
# - id: メンテナンスウィンドウタスクのID
#
# - window_task_id: メンテナンスウィンドウタスクのID
#---------------------------------------------------------------
