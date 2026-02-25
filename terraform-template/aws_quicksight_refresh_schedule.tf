#---------------------------------------------------------------
# Amazon QuickSight Refresh Schedule
#---------------------------------------------------------------
#
# Amazon QuickSight データセットの更新スケジュールをプロビジョニングするリソースです。
# SPICE データセットの完全更新（FULL_REFRESH）または増分更新（INCREMENTAL_REFRESH）を
# 定期的に自動実行するスケジュールを設定します。1つのデータセットに最大5件まで設定可能です。
#
# AWS公式ドキュメント:
#   - QuickSight RefreshSchedule API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_RefreshSchedule.html
#   - QuickSight データ更新: https://docs.aws.amazon.com/quicksight/latest/user/refreshing-imported-data.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_refresh_schedule
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_refresh_schedule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # data_set_id (Required, Forces new resource)
  # 設定内容: スケジュールを適用するデータセットのIDを指定します。
  # 設定可能な値: 有効なQuickSightデータセットID文字列
  data_set_id = "dataset-id"

  # schedule_id (Required, Forces new resource)
  # 設定内容: 更新スケジュールの一意のIDを指定します。
  # 設定可能な値: 任意の文字列（同一データセット内で一意である必要があります）
  schedule_id = "schedule-id"

  #-------------------------------------------------------------
  # アカウント・リージョン設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: QuickSightリソースを管理するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーが自動的に判定したアカウントIDを使用します。
  aws_account_id = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # スケジュール設定
  #-------------------------------------------------------------

  # schedule (Required)
  # 設定内容: データセットの更新スケジュール設定ブロックです。
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_RefreshSchedule.html
  schedule {

    # refresh_type (Required)
    # 設定内容: データセットが実行する更新の種類を指定します。
    # 設定可能な値:
    #   - "FULL_REFRESH": データセット全体を完全に更新します。
    #   - "INCREMENTAL_REFRESH": 指定した時間ウィンドウ内で変更されたデータのみを更新します。
    refresh_type = "FULL_REFRESH"

    # start_after_date_time (Optional)
    # 設定内容: スケジュールの開始日時を指定します。指定した日時以降に初回実行されます。
    # 設定可能な値: ISO 8601形式の日時文字列（例: "2026-03-01T00:00:00"）
    # 省略時: Terraformが自動的に設定します。
    start_after_date_time = null

    #-----------------------------------------------------------
    # スケジュール頻度設定
    #-----------------------------------------------------------

    # schedule_frequency (Optional)
    # 設定内容: スケジュールされた更新の間隔と実行タイミングの設定ブロックです。
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_RefreshFrequency.html
    schedule_frequency {

      # interval (Required)
      # 設定内容: スケジュールされた更新の間隔を指定します。
      # 設定可能な値:
      #   - "MINUTE15": 15分ごとに更新します（1データセットにつき1スケジュールのみ設定可能）
      #   - "MINUTE30": 30分ごとに更新します
      #   - "HOURLY": 1時間ごとに更新します
      #   - "DAILY": 1日ごとに更新します
      #   - "WEEKLY": 1週間ごとに更新します（refresh_on_day の day_of_week 指定が必要）
      #   - "MONTHLY": 1ヶ月ごとに更新します（refresh_on_day の day_of_month 指定が必要）
      interval = "HOURLY"

      # time_of_the_day (Optional)
      # 設定内容: データセットを更新する時刻をHH:MM形式で指定します。
      # 設定可能な値: "HH:MM" 形式の文字列（例: "01:00"、"23:30"）
      # 省略時: Terraformが自動的に設定します。
      # 注意: HOURLY スケジュールの場合は指定不要です。DAILY・WEEKLY・MONTHLY の場合に有効です。
      time_of_the_day = null

      # timezone (Optional)
      # 設定内容: 更新スケジュールに使用するタイムゾーンを指定します。
      # 設定可能な値: java.util.time.getAvailableIDs() に対応するタイムゾーンID文字列
      #               （例: "Asia/Tokyo"、"America/New_York"、"Europe/London"）
      # 省略時: Terraformが自動的に設定します。
      timezone = null

      #---------------------------------------------------------
      # 更新日指定設定
      #---------------------------------------------------------

      # refresh_on_day (Optional)
      # 設定内容: 週次または月次スケジュールの更新曜日・日付の設定ブロックです。
      # 注意: interval が "WEEKLY" の場合は day_of_week を、"MONTHLY" の場合は day_of_month を指定します。
      # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ScheduleRefreshOnEntity.html
      refresh_on_day {

        # day_of_week (Optional)
        # 設定内容: 週次更新の曜日を指定します。interval が "WEEKLY" の場合に使用します。
        # 設定可能な値:
        #   - "SUNDAY": 日曜日
        #   - "MONDAY": 月曜日
        #   - "TUESDAY": 火曜日
        #   - "WEDNESDAY": 水曜日
        #   - "THURSDAY": 木曜日
        #   - "FRIDAY": 金曜日
        #   - "SATURDAY": 土曜日
        day_of_week = null

        # day_of_month (Optional)
        # 設定内容: 月次更新の日付を指定します。interval が "MONTHLY" の場合に使用します。
        # 設定可能な値: "1" ～ "31" の文字列（例: "1" は毎月1日）
        day_of_month = null
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 更新スケジュールのAmazon Resource Name (ARN)
# - id: AWSアカウントID、データセットID、スケジュールIDをカンマで連結した文字列
#---------------------------------------------------------------
