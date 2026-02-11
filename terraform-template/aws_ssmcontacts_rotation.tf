#---------------------------------------------------------------
# AWS SSM Contacts Rotation (Incident Manager)
#---------------------------------------------------------------
#
# AWS Systems Manager Incident Managerのオンコールローテーションを
# 管理するリソースです。ローテーションを設定することで、インシデント発生時に
# 対応する担当者を自動的にスケジューリングできます。
#
# NOTE: ローテーションはレプリケーションセットに暗黙的に依存します。
#       Terraformでレプリケーションセットを構成した場合は、depends_on引数に
#       追加することを推奨します。
#
# AWS公式ドキュメント:
#   - Incident Manager概要: https://docs.aws.amazon.com/incident-manager/latest/userguide/what-is-incident-manager.html
#   - オンコールスケジュール: https://docs.aws.amazon.com/incident-manager/latest/userguide/incident-manager-on-call-schedule.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_rotation
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssmcontacts_rotation" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ローテーションの名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "example-rotation"

  # contact_ids (Required)
  # 設定内容: ローテーションに追加するコンタクトのARNリストを指定します。
  # 設定可能な値: aws_ssmcontacts_contactリソースのARNリスト
  # 注意: リストの順序がローテーションスケジュールにおけるシフト順序となります。
  contact_ids = [
    "arn:aws:ssm-contacts:ap-northeast-1:123456789012:contact/example-contact-1",
    "arn:aws:ssm-contacts:ap-northeast-1:123456789012:contact/example-contact-2",
  ]

  # time_zone_id (Required)
  # 設定内容: ローテーションのアクティビティの基準となるタイムゾーンを指定します。
  # 設定可能な値: IANA形式のタイムゾーン識別子
  #   例: "Asia/Tokyo", "America/New_York", "Europe/London", "Australia/Sydney"
  # 参考: https://www.iana.org/time-zones
  time_zone_id = "Asia/Tokyo"

  # start_time (Optional)
  # 設定内容: ローテーションが有効になる日時をRFC 3339形式で指定します。
  # 設定可能な値: RFC 3339形式の日時文字列（例: "2024-01-01T00:00:00+09:00"）
  # 省略時: 即座に有効
  start_time = "2024-01-01T00:00:00+09:00"

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
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-rotation"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # 繰り返し設定 (recurrence) - Required
  #-------------------------------------------------------------
  # オンコールローテーションの実施タイミングとローテーション期間を設定します。
  # daily_settings, weekly_settings, monthly_settings のいずれか1つを
  # 必ず指定する必要があります。

  recurrence {
    # number_of_on_calls (Required)
    # 設定内容: シフト中に同時にオンコールとなるコンタクト（シフトチームメンバー）の数です。
    # 設定可能な値: 正の整数
    number_of_on_calls = 1

    # recurrence_multiplier (Required)
    # 設定内容: 単一ローテーションの期間を示す日数・週数・月数です。
    # 設定可能な値: 正の整数
    # 注意: daily_settingsの場合は日数、weekly_settingsの場合は週数、
    #       monthly_settingsの場合は月数として解釈されます。
    recurrence_multiplier = 1

    #-----------------------------------------------------------
    # 日次設定 (daily_settings) - Optional
    #-----------------------------------------------------------
    # 毎日繰り返すオンコールローテーションの設定です。
    # オンコールシフトの引き継ぎ時刻を24時間形式で指定します。
    # 注意: weekly_settings, monthly_settings とは排他的です。
    daily_settings {
      # hour_of_day (Required)
      # 設定内容: 引き継ぎ時刻の「時」を指定します。
      # 設定可能な値: 0〜23
      hour_of_day = 9

      # minute_of_hour (Required)
      # 設定内容: 引き継ぎ時刻の「分」を指定します。
      # 設定可能な値: 0〜59
      minute_of_hour = 0
    }

    #-----------------------------------------------------------
    # 週次設定 (weekly_settings) - Optional
    #-----------------------------------------------------------
    # 毎週繰り返すオンコールローテーションの設定です。
    # 複数の曜日を指定して異なる引き継ぎ時刻を設定できます。
    # 注意: daily_settings, monthly_settings とは排他的です。
    # weekly_settings {
    #   # day_of_week (Required)
    #   # 設定内容: ローテーションが開始される曜日を指定します。
    #   # 設定可能な値: "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"
    #   day_of_week = "MON"
    #
    #   # hand_off_time (Required)
    #   # 設定内容: シフトの引き継ぎ時刻を指定します。
    #   hand_off_time {
    #     # hour_of_day (Required)
    #     # 設定可能な値: 0〜23
    #     hour_of_day = 9
    #
    #     # minute_of_hour (Required)
    #     # 設定可能な値: 0〜59
    #     minute_of_hour = 0
    #   }
    # }
    #
    # # 複数の曜日を指定する場合は、weekly_settingsブロックを追加します。
    # weekly_settings {
    #   day_of_week = "FRI"
    #   hand_off_time {
    #     hour_of_day    = 17
    #     minute_of_hour = 0
    #   }
    # }

    #-----------------------------------------------------------
    # 月次設定 (monthly_settings) - Optional
    #-----------------------------------------------------------
    # 毎月繰り返すオンコールローテーションの設定です。
    # 複数の日付を指定して異なる引き継ぎ時刻を設定できます。
    # 注意: daily_settings, weekly_settings とは排他的です。
    # monthly_settings {
    #   # day_of_month (Required)
    #   # 設定内容: 月次ローテーションが開始される日を指定します。
    #   # 設定可能な値: 1〜31
    #   day_of_month = 1
    #
    #   # hand_off_time (Required)
    #   # 設定内容: シフトの引き継ぎ時刻を指定します。
    #   hand_off_time {
    #     # hour_of_day (Required)
    #     # 設定可能な値: 0〜23
    #     hour_of_day = 9
    #
    #     # minute_of_hour (Required)
    #     # 設定可能な値: 0〜59
    #     minute_of_hour = 0
    #   }
    # }

    #-----------------------------------------------------------
    # シフトカバレッジ設定 (shift_coverages) - Optional
    #-----------------------------------------------------------
    # オンコールローテーションがカバーする曜日と時間帯を指定します。
    # 各曜日ごとにカバレッジ時間を設定できます。
    # shift_coverages {
    #   # map_block_key (Required)
    #   # 設定内容: シフトカバレッジが適用される曜日を指定します。
    #   # 設定可能な値: "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"
    #   map_block_key = "MON"
    #
    #   # coverage_times (Required)
    #   # 設定内容: オンコールシフトの開始・終了時刻を指定します。
    #   coverage_times {
    #     # start (Required)
    #     # 設定内容: オンコールシフトの開始時刻を指定します。
    #     start {
    #       hour_of_day    = 9
    #       minute_of_hour = 0
    #     }
    #
    #     # end (Required)
    #     # 設定内容: オンコールシフトの終了時刻を指定します。
    #     end {
    #       hour_of_day    = 17
    #       minute_of_hour = 0
    #     }
    #   }
    # }
    #
    # # 複数の曜日をカバーする場合は、shift_coveragesブロックを追加します。
    # shift_coverages {
    #   map_block_key = "TUE"
    #   coverage_times {
    #     start {
    #       hour_of_day    = 9
    #       minute_of_hour = 0
    #     }
    #     end {
    #       hour_of_day    = 17
    #       minute_of_hour = 0
    #     }
    #   }
    # }
  }

  # depends_on (推奨)
  # ローテーションはレプリケーションセットに暗黙的に依存するため、
  # Terraformでレプリケーションセットを管理している場合は明示的に指定してください。
  # depends_on = [aws_ssmincidents_replication_set.example]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ローテーションのAmazon Resource Name (ARN)
#
# - id: ローテーションのARN
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
