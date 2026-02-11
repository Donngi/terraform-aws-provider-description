#---------------------------------------------------------------
# DMS レプリケーションタスク
#---------------------------------------------------------------
#
# AWS Database Migration Service (DMS) のレプリケーションタスクをプロビジョニングするリソースです。
# データベース間のデータ移行を実行し、フルロード、CDC（Change Data Capture）、
# またはその両方の移行タイプをサポートします。
#
# AWS公式ドキュメント:
#   - AWS DMS レプリケーションタスク: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.html
#   - タスク設定のカスタマイズ: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.html
#   - テーブルマッピング: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/dms_replication_task
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dms_replication_task" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # replication_task_id (Required)
  # 設定内容: レプリケーションタスクの識別子を指定します。
  # 設定可能な値: 1～255文字の英数字またはハイフン
  # 注意: 最初の文字は英字である必要があり、ハイフンで終わることはできず、
  #       連続する2つのハイフンを含めることはできません。
  replication_task_id = "example-replication-task"

  # replication_instance_arn (Required)
  # 設定内容: タスクを実行するレプリケーションインスタンスのARNを指定します。
  # 設定可能な値: 有効なDMSレプリケーションインスタンスのARN
  replication_instance_arn = "arn:aws:dms:us-east-1:123456789012:rep:EXAMPLE"

  # migration_type (Required)
  # 設定内容: 実行する移行のタイプを指定します。
  # 設定可能な値:
  #   - "full-load": 既存データの一括移行のみを実行
  #   - "cdc": 変更データキャプチャ（CDC）のみを実行（継続的レプリケーション）
  #   - "full-load-and-cdc": 一括移行後に継続的レプリケーションを実行
  migration_type = "full-load-and-cdc"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # resource_identifier (Optional)
  # 設定内容: EndpointArnレスポンスパラメータの末尾に使用されるフレンドリ名を指定します。
  # 設定可能な値: 文字列
  # 関連機能: 作成されたEndpointオブジェクトで返されます。
  resource_identifier = null

  #-------------------------------------------------------------
  # エンドポイント設定
  #-------------------------------------------------------------

  # source_endpoint_arn (Required)
  # 設定内容: 移行元データベースを示すソースエンドポイントのARNを指定します。
  # 設定可能な値: 有効なDMSエンドポイントのARN
  source_endpoint_arn = "arn:aws:dms:us-east-1:123456789012:endpoint:SOURCE"

  # target_endpoint_arn (Required)
  # 設定内容: 移行先データベースを示すターゲットエンドポイントのARNを指定します。
  # 設定可能な値: 有効なDMSエンドポイントのARN
  target_endpoint_arn = "arn:aws:dms:us-east-1:123456789012:endpoint:TARGET"

  #-------------------------------------------------------------
  # CDC設定
  #-------------------------------------------------------------

  # cdc_start_position (Optional)
  # 設定内容: 変更データキャプチャ（CDC）オペレーションの開始位置を指定します。
  # 設定可能な値: RFC3339形式の日付、チェックポイント、またはLSN/SCN形式
  #               ソースエンジンに応じた形式で指定
  # 注意: cdc_start_timeと同時に指定することはできません。
  # 関連機能: CDC ネイティブ開始ポイント
  #   チェックポイント、LSN、SCN等のネイティブ形式でCDC開始位置を指定できます。
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Task.CDC.html#CHAP_Task.CDC.StartPoint.Native
  cdc_start_position = null

  # cdc_start_time (Optional)
  # 設定内容: 変更データキャプチャ（CDC）オペレーションの開始時刻を指定します。
  # 設定可能な値: RFC3339形式の日付文字列またはUNIXタイムスタンプ
  #               例: "1993-05-21T05:50:00Z"
  # 注意: cdc_start_positionと同時に指定することはできません。
  cdc_start_time = null

  #-------------------------------------------------------------
  # テーブルマッピング設定
  #-------------------------------------------------------------

  # table_mappings (Required)
  # 設定内容: 移行対象のテーブルと変換ルールを定義するJSON文字列を指定します。
  # 設定可能な値: エスケープされたJSON文字列
  # 関連機能: テーブルマッピング
  #   selection rulesで移行対象のスキーマとテーブルを選択し、
  #   transformation rulesでスキーマ名やテーブル名の変換を定義します。
  #   フィルタを使用して特定の行のみを移行することも可能です。
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.html
  table_mappings = jsonencode({
    rules = [
      {
        rule-type = "selection"
        rule-id   = "1"
        rule-name = "1"
        object-locator = {
          schema-name = "%"
          table-name  = "%"
        }
        rule-action = "include"
      }
    ]
  })

  #-------------------------------------------------------------
  # タスク設定
  #-------------------------------------------------------------

  # replication_task_settings (Optional)
  # 設定内容: タスクの詳細設定を定義するJSON文字列を指定します。
  # 設定可能な値: エスケープされたJSON文字列
  # 省略時: デフォルトのタスク設定が使用されます。
  # 関連機能: タスク設定
  #   TargetMetadata（LOB処理、並列スレッド数等）、FullLoadSettings、
  #   Logging、ControlTablesSettings、ChangeProcessingTuning、
  #   ErrorBehavior、ValidationSettings等を設定できます。
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.html
  # 注意: Logging.CloudWatchLogGroupとLogging.CloudWatchLogStreamは
  #       読み取り専用のため、nullでも指定してはいけません（AWSが自動設定）。
  replication_task_settings = null

  #-------------------------------------------------------------
  # タスク制御設定
  #-------------------------------------------------------------

  # start_replication_task (Optional)
  # 設定内容: タスク作成後に自動的にレプリケーションを開始するかを指定します。
  # 設定可能な値:
  #   - true: タスク作成後に自動的に開始
  #   - false (デフォルト): 手動で開始する必要がある
  start_replication_task = null

  # id (Optional)
  # 設定内容: Terraformが使用するリソースIDを指定します。
  # 省略時: 自動生成されます。
  # 注意: 通常は指定不要です。
  id = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、このリソースレベルのタグで上書きされます。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-replication-task"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - replication_task_arn: レプリケーションタスクのARN
#
# - status: レプリケーションタスクのステータス
#           可能な値: creating, running, stopped, stopping, deleting,
#                     failed, testing, modifying 等
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
