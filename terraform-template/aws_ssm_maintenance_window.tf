#---------------------------------------------------------------
# AWS Systems Manager Maintenance Window
#---------------------------------------------------------------
#
# AWS Systems Managerのメンテナンスウィンドウをプロビジョニングするリソースです。
# メンテナンスウィンドウは、OSのパッチ適用やソフトウェアのインストールなど、
# AWSリソースに対する破壊的なアクションをスケジュールするためのツールです。
# 特定の時間枠でタスクを実行し、最大期間の設定やターゲットの登録が可能です。
#
# AWS公式ドキュメント:
#   - Maintenance Windows概要: https://docs.aws.amazon.com/systems-manager/latest/userguide/maintenance-windows.html
#   - メンテナンスウィンドウの作成: https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-create-mw.html
#   - スケジュール設定オプション: https://docs.aws.amazon.com/systems-manager/latest/userguide/maintenance-windows-schedule-options.html
#   - Cron/Rate式のリファレンス: https://docs.aws.amazon.com/systems-manager/latest/userguide/reference-cron-and-rate-expressions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_maintenance_window" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: メンテナンスウィンドウの名前を指定します。
  # 設定可能な値: 3-128文字の文字列（パターン: ^[a-zA-Z0-9_\-.]{3,128}$）
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_MaintenanceWindowIdentity.html
  name = "maintenance-window-application"

  # description (Optional)
  # 設定内容: メンテナンスウィンドウの説明を指定します。
  # 設定可能な値: 1-128文字の文字列
  # 省略時: 説明なし
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_MaintenanceWindowIdentity.html
  description = "Maintenance window for application patching"

  #-------------------------------------------------------------
  # スケジュール設定
  #-------------------------------------------------------------

  # schedule (Required)
  # 設定内容: メンテナンスウィンドウのスケジュールをcronまたはrate式で指定します。
  # 設定可能な値:
  #   - Cron式: 6つのフィールド（分、時、日、月、曜日、年）で構成
  #     例: "cron(0 16 ? * TUE *)" - 毎週火曜日の16:00 (UTC)
  #   - Rate式: 2つのフィールド（値、単位）で構成
  #     例: "rate(7 days)" - 7日ごと
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/reference-cron-and-rate-expressions.html
  # 注意: メンテナンスウィンドウは秒フィールドを含むすべてのcron/rate式をサポートします。
  #       最小長1文字、最大長256文字
  schedule = "cron(0 16 ? * TUE *)"

  # schedule_timezone (Optional)
  # 設定内容: メンテナンスウィンドウのスケジュール実行が基づくタイムゾーンを指定します。
  # 設定可能な値: IANA形式のタイムゾーン
  #   例: "America/Los_Angeles", "UTC", "Asia/Tokyo", "Europe/London"
  # 省略時: UTC
  # 関連機能: Maintenance Window スケジュールタイムゾーン
  #   スケジュールされたメンテナンスウィンドウが実行される国際タイムゾーンを決定します。
  #   有効期間中のスケジュール計算に使用されます。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/maintenance-windows-schedule-options.html
  schedule_timezone = "Asia/Tokyo"

  # schedule_offset (Optional)
  # 設定内容: スケジュールされたcron式の日時後、メンテナンスウィンドウの実行を待機する日数を指定します。
  # 設定可能な値: 1-6の整数（日数）
  # 省略時: オフセットなし
  # 関連機能: スケジュールオフセット
  #   cron式で指定された日時からメンテナンスウィンドウの実行を遅延させることができます。
  #   例: 毎月第3火曜日に実行するcron式に対して2日のオフセットを設定すると、
  #       実際には第3木曜日に実行されます。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/maintenance-windows-schedule-options.html
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_MaintenanceWindowIdentity.html
  schedule_offset = null

  #-------------------------------------------------------------
  # 実行期間設定
  #-------------------------------------------------------------

  # duration (Required)
  # 設定内容: メンテナンスウィンドウの期間を時間単位で指定します。
  # 設定可能な値: 1-24の整数（時間）
  # 関連機能: メンテナンスウィンドウ期間
  #   この期間内にタスクが開始および完了できます。期間とcutoffの組み合わせで、
  #   新しいタスクのスケジューリングと既存タスクの実行時間を制御します。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-create-mw.html
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_MaintenanceWindowIdentity.html
  duration = 3

  # cutoff (Required)
  # 設定内容: メンテナンスウィンドウの終了前の何時間前にSystems Managerが新しいタスクのスケジューリングを停止するかを指定します。
  # 設定可能な値: 0-23の整数（時間）
  # 関連機能: タスクスケジューリングの停止時刻
  #   メンテナンスウィンドウ期間の終了前にタスクのスケジューリングを停止することで、
  #   すべてのタスクが期間内に完了する時間を確保します。既に実行中のタスクは継続されます。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-create-mw.html
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_MaintenanceWindowIdentity.html
  # 注意: cutoffは必ずdurationより小さい値を指定する必要があります。
  cutoff = 1

  #-------------------------------------------------------------
  # 有効期間設定
  #-------------------------------------------------------------

  # start_date (Optional)
  # 設定内容: メンテナンスウィンドウがアクティブになる開始日時をISO-8601拡張形式で指定します。
  # 設定可能な値: ISO-8601拡張形式の日時文字列
  #   例: "2024-01-01T00:00:00Z", "2024-06-15T09:00:00+09:00"
  # 省略時: 即座にアクティブ
  # 関連機能: メンテナンスウィンドウの有効期間
  #   start_dateとend_dateでメンテナンスウィンドウが実行可能な期間を定義します。
  #   この期間外ではスケジュールが設定されていてもメンテナンスウィンドウは実行されません。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/maintenance-windows-schedule-options.html
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_MaintenanceWindowIdentity.html
  start_date = null

  # end_date (Optional)
  # 設定内容: メンテナンスウィンドウが非アクティブになる終了日時をISO-8601拡張形式で指定します。
  # 設定可能な値: ISO-8601拡張形式の日時文字列
  #   例: "2024-12-31T23:59:59Z", "2024-12-31T23:59:59+09:00"
  # 省略時: 終了日なし（無期限）
  # 関連機能: メンテナンスウィンドウの有効期間
  #   start_dateとend_dateでメンテナンスウィンドウが実行可能な期間を定義します。
  #   end_date以降はスケジュールが設定されていてもメンテナンスウィンドウは実行されません。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/maintenance-windows-schedule-options.html
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_MaintenanceWindowIdentity.html
  end_date = null

  #-------------------------------------------------------------
  # 動作設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: メンテナンスウィンドウを有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): メンテナンスウィンドウを有効化
  #   - false: メンテナンスウィンドウを無効化
  # 省略時: true
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_MaintenanceWindowIdentity.html
  # 注意: 無効化されたメンテナンスウィンドウはスケジュールされていても実行されません。
  enabled = true

  # allow_unassociated_targets (Optional)
  # 設定内容: ターゲットがメンテナンスウィンドウに登録される前にタスクを定義できるかを指定します。
  # 設定可能な値:
  #   - true: ターゲット未登録でもタスク定義を許可
  #   - false (デフォルト): ターゲット登録後のみタスク定義を許可
  # 省略時: false
  # 関連機能: ターゲット未登録タスク
  #   メンテナンスウィンドウにターゲットを登録する前にタスクを定義できるようにします。
  #   柔軟なワークフロー管理が可能になりますが、ターゲット未登録のタスクは実行されません。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/maintenance-windows.html
  allow_unassociated_targets = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "maintenance-window-application"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: メンテナンスウィンドウのID（例: mw-0123456789abcdef0）
#       パターン: ^mw-[0-9a-f]{17}$
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
