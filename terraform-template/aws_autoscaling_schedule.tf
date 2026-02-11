#---------------------------------------------------------------
# AWS Auto Scaling Schedule
#---------------------------------------------------------------
#
# Amazon EC2 Auto Scalingのスケジュールされたスケーリングアクションを
# 定義するリソースです。
# 予測可能な負荷変動に基づいて、特定の日時にAuto Scalingグループの
# キャパシティを自動的に調整します。
#
# AWS公式ドキュメント:
#   - Scheduled scaling概要: https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-scheduled-scaling.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_autoscaling_schedule" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # scheduled_action_name (Required)
  # 設定内容: スケジュールされたアクションの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 注意: 同一Auto Scalingグループ内で一意である必要があります。
  scheduled_action_name = "scale-out-weekday-morning"

  # autoscaling_group_name (Required)
  # 設定内容: スケジュールを適用するAuto Scalingグループの名前を指定します。
  # 設定可能な値: 既存のAuto Scalingグループ名
  autoscaling_group_name = "my-asg"

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
  # キャパシティ設定
  #-------------------------------------------------------------

  # desired_capacity (Optional)
  # 設定内容: スケジュールされたアクション実行後のAuto Scalingグループの
  #          希望キャパシティ（インスタンス数）を指定します。
  # 設定可能な値:
  #   - 0以上の整数: 指定したインスタンス数に設定
  #   - -1: 希望キャパシティを変更しない
  # 省略時: 0
  # 注意: min_sizeとmax_sizeの範囲内である必要があります。
  desired_capacity = 4

  # min_size (Optional)
  # 設定内容: スケジュールされたアクション実行後のAuto Scalingグループの
  #          最小インスタンス数を指定します。
  # 設定可能な値:
  #   - 0以上の整数: 指定した最小インスタンス数に設定
  #   - -1: 最小サイズを変更しない
  # 省略時: 0
  min_size = 2

  # max_size (Optional)
  # 設定内容: スケジュールされたアクション実行後のAuto Scalingグループの
  #          最大インスタンス数を指定します。
  # 設定可能な値:
  #   - 0以上の整数: 指定した最大インスタンス数に設定
  #   - -1: 最大サイズを変更しない
  # 省略時: 0
  max_size = 10

  #-------------------------------------------------------------
  # スケジュール設定
  #-------------------------------------------------------------

  # start_time (Optional)
  # 設定内容: スケジュールされたアクションの開始日時を指定します。
  # 設定可能な値: ISO 8601形式のUTC日時（"YYYY-MM-DDThh:mm:ssZ"）
  # 例: "2024-06-01T09:00:00Z"
  # 注意:
  #   - recurrenceと併用する場合、繰り返しの開始境界となります
  #   - 一回限りのアクションの場合は実行時刻を指定します
  start_time = "2024-06-01T00:00:00Z"

  # end_time (Optional)
  # 設定内容: スケジュールされたアクションの終了日時を指定します。
  # 設定可能な値: ISO 8601形式のUTC日時（"YYYY-MM-DDThh:mm:ssZ"）
  # 例: "2024-12-31T23:59:59Z"
  # 注意:
  #   - recurrenceと併用する場合、繰り返しの終了境界となります
  #   - end_timeに達するとスケジュールアクションはアカウントから削除されます
  #   - end_timeとrecurrence時刻が一致する場合、その時刻のアクションは実行されません
  end_time = "2024-12-31T23:59:59Z"

  # recurrence (Optional)
  # 設定内容: 繰り返しスケジュールをUnix cron形式で指定します。
  # 設定可能な値: 5フィールドのcron式（[分] [時] [日] [月] [曜日]）
  # 例:
  #   - "0 9 * * 1-5": 平日の9:00に実行
  #   - "30 6 * * 2": 毎週火曜日の6:30に実行
  #   - "0 18 * * *": 毎日18:00に実行
  # 参考: https://crontab.guru/examples.html
  # 注意:
  #   - time_zoneを指定しない場合はUTCとして解釈されます
  #   - start_timeとend_timeで繰り返しの境界を設定できます
  recurrence = "0 9 * * 1-5"

  # time_zone (Optional)
  # 設定内容: cron式を解釈するタイムゾーンを指定します。
  # 設定可能な値: IANAタイムゾーンデータベースの正規名
  # 例:
  #   - "Asia/Tokyo": 日本標準時
  #   - "America/New_York": 米国東部時間（DST自動調整あり）
  #   - "Etc/UTC": UTC（DST調整なし）
  # 省略時: UTC
  # 参考: https://www.iana.org/time-zones
  # 注意:
  #   - America/New_YorkなどのロケーションベースのタイムゾーンはDST自動調整あり
  #   - Etc/UTCなどのUTCベースのタイムゾーンはDST調整なし
  time_zone = "Asia/Tokyo"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スケジュールされたアクションのAmazon Resource Name (ARN)
#
# - id: リソースID
#
#---------------------------------------------------------------
