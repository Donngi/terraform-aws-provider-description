#---------------------------------------------------------------
# Amazon Redshift Scheduled Action
#---------------------------------------------------------------
#
# Amazon Redshiftのスケジュールされたアクションをプロビジョニングするリソースです。
# スケジュールを定義し、指定した日時または定期的にRedshiftのAPIオペレーション
# （クラスターの一時停止・再開・リサイズ）を自動実行します。
#
# AWS公式ドキュメント:
#   - スケジュールされたアクション (APIリファレンス): https://docs.aws.amazon.com/redshift/latest/APIReference/API_ScheduledAction.html
#   - スケジュールされたアクションの作成: https://docs.aws.amazon.com/redshift/latest/APIReference/API_CreateScheduledAction.html
#   - クラスターの一時停止と再開: https://docs.aws.amazon.com/redshift/latest/mgmt/rs-mgmt-pause-resume-cluster.html
#   - クラスターのリサイズ: https://docs.aws.amazon.com/redshift/latest/mgmt/resizing-cluster.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_scheduled_action
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_scheduled_action" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: スケジュールされたアクションの一意な名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアで構成される文字列
  name = "tf-redshift-scheduled-action"

  # schedule (Required)
  # 設定内容: アクションを実行するスケジュールを指定します。
  # 設定可能な値:
  #   - at式: at(YYYY-MM-DDTHH:MM:SS) 形式（一回限りの実行）
  #     例: at(2024-03-15T23:00:00)
  #   - cron式: cron(分 時 日 月 曜日 年) 形式（繰り返し実行）
  #     例: cron(0 23 * * ? *) — 毎日23時UTCに実行
  # 参考: https://docs.aws.amazon.com/redshift/latest/APIReference/API_ScheduledAction.html
  schedule = "cron(00 23 * * ? *)"

  # iam_role (Required)
  # 設定内容: スケジュールされたアクションを実行するために引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: IAMロールはRedshiftスケジューラーサービス（scheduler.redshift.amazonaws.com）が
  #       AssumeRoleできること、および対象オペレーション（PauseCluster/ResumeCluster/ResizeCluster）
  #       の実行権限を持つことが必要です。
  iam_role = "arn:aws:iam::123456789012:role/redshift_scheduled_action"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: スケジュールされたアクションの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "毎日23時UTCにクラスターを一時停止するスケジュールされたアクション"

  #-------------------------------------------------------------
  # 有効化設定
  #-------------------------------------------------------------

  # enable (Optional)
  # 設定内容: スケジュールされたアクションを有効化するかどうかを指定します。
  # 設定可能な値:
  #   - true: 有効化（スケジュールに従ってアクションが実行される）
  #   - false: 無効化（スケジュールは保持されるがアクションは実行されない）
  # 省略時: true
  enable = true

  #-------------------------------------------------------------
  # 実行期間設定
  #-------------------------------------------------------------

  # start_time (Optional)
  # 設定内容: スケジュールが有効になる開始時刻をUTCで指定します。
  # 設定可能な値: UTC RFC3339形式の日時文字列（例: 2024-03-01T00:00:00Z）
  # 省略時: 即座にスケジュールが有効になります
  start_time = "2024-03-01T00:00:00Z"

  # end_time (Optional)
  # 設定内容: スケジュールが無効になる終了時刻をUTCで指定します。
  # 設定可能な値: UTC RFC3339形式の日時文字列（例: 2024-12-31T23:59:59Z）
  # 省略時: スケジュールは無期限に有効となります
  end_time = "2024-12-31T23:59:59Z"

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
  # ターゲットアクション設定
  #-------------------------------------------------------------

  # target_action (Required)
  # 設定内容: スケジュールに従って実行するRedshift APIオペレーションを定義するブロックです。
  # 注意: pause_cluster、resize_cluster、resume_cluster のいずれか1つを指定してください。
  # 参考: https://docs.aws.amazon.com/redshift/latest/APIReference/API_ScheduledActionType.html
  target_action {

    #-------------------------------------------------------------
    # クラスター一時停止アクション設定
    #-------------------------------------------------------------

    # pause_cluster (Optional)
    # 設定内容: PauseCluster APIオペレーションを実行するアクションブロックです。
    # 設定内容: 指定したクラスターを一時停止し、コンピュートコストを停止します。
    # 注意: pause_cluster、resize_cluster、resume_cluster は排他的に1つだけ指定してください。
    # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/rs-mgmt-pause-resume-cluster.html
    pause_cluster {

      # cluster_identifier (Required)
      # 設定内容: 一時停止するクラスターの識別子を指定します。
      # 設定可能な値: 有効なRedshiftクラスター識別子
      cluster_identifier = "tf-redshift001"
    }

    #-------------------------------------------------------------
    # クラスターリサイズアクション設定
    #-------------------------------------------------------------

    # resize_cluster (Optional)
    # 設定内容: ResizeCluster APIオペレーションを実行するアクションブロックです。
    # 設定内容: 指定したクラスターのノード数やノードタイプを変更します。
    # 注意: pause_cluster、resize_cluster、resume_cluster は排他的に1つだけ指定してください。
    # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/resizing-cluster.html
    # resize_cluster {

    #   # cluster_identifier (Required)
    #   # 設定内容: リサイズするクラスターの一意な識別子を指定します。
    #   # 設定可能な値: 有効なRedshiftクラスター識別子
    #   cluster_identifier = "tf-redshift001"

    #   # classic (Optional)
    #   # 設定内容: クラシックリサイズプロセスを使用するかどうかを指定します。
    #   # 設定可能な値:
    #   #   - true: クラシックリサイズを使用（新しいクラスターを作成してデータを移行）
    #   #   - false: エラスティックリサイズを使用（インプレースでリサイズ、高速）
    #   # 省略時: false
    #   classic = false

    #   # cluster_type (Optional)
    #   # 設定内容: リサイズ後のクラスタータイプを指定します。
    #   # 設定可能な値:
    #   #   - "multi-node": マルチノードクラスター
    #   #   - "single-node": シングルノードクラスター
    #   # 省略時: 現在のクラスタータイプを維持
    #   cluster_type = "multi-node"

    #   # node_type (Optional)
    #   # 設定内容: 追加するノードの新しいノードタイプを指定します。
    #   # 設定可能な値: dc2.large, dc2.8xlarge, ra3.xlplus, ra3.4xlarge, ra3.16xlarge 等
    #   # 省略時: 現在のノードタイプを維持
    #   node_type = "dc2.large"

    #   # number_of_nodes (Optional)
    #   # 設定内容: リサイズ後のクラスターのノード数を指定します。
    #   # 設定可能な値: 1以上の整数
    #   # 省略時: 現在のノード数を維持
    #   number_of_nodes = 2
    # }

    #-------------------------------------------------------------
    # クラスター再開アクション設定
    #-------------------------------------------------------------

    # resume_cluster (Optional)
    # 設定内容: ResumeCluster APIオペレーションを実行するアクションブロックです。
    # 設定内容: 一時停止中のクラスターを再開します。
    # 注意: pause_cluster、resize_cluster、resume_cluster は排他的に1つだけ指定してください。
    # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/rs-mgmt-pause-resume-cluster.html
    # resume_cluster {

    #   # cluster_identifier (Required)
    #   # 設定内容: 再開するクラスターの識別子を指定します。
    #   # 設定可能な値: 有効なRedshiftクラスター識別子
    #   cluster_identifier = "tf-redshift001"
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: スケジュールされたアクションの名前（name属性と同じ値）
#---------------------------------------------------------------
