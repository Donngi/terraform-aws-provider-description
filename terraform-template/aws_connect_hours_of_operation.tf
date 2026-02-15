#######################################################################
# Amazon Connect 営業時間
#######################################################################
# Amazon Connectインスタンスの営業時間を定義するリソース。
# コンタクトセンターの営業時間、休日、曜日ごとの営業時間帯を設定します。
#
# 【主な用途】
# - コンタクトセンターの営業時間設定
# - 曜日ごとの営業時間帯の定義
# - 休業日の設定
# - キューやルーティングプロファイルでの営業時間参照
#
# 【前提条件】
# - Amazon Connectインスタンスが作成済みであること
# - 有効なタイムゾーンを指定すること（例: Asia/Tokyo, America/New_York）
#
# 【制限事項】
# - 営業時間設定（config）は最低1つ必要
# - 同じ曜日に複数の時間帯を設定可能
# - 時刻はUTC基準ではなくtime_zoneで指定したタイムゾーン基準
#
# 【注意事項】
# - 営業時間の変更は既存のキューやルーティングプロファイルに影響
# - 曜日の値は英語表記（MONDAY, TUESDAY等）を使用
# - start_timeとend_timeで同じ時刻を指定すると24時間営業扱い
#
# 【参考ドキュメント】
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_hours_of_operation
#
# 【AWS公式ドキュメント】
# https://docs.aws.amazon.com/connect/latest/adminguide/set-hours-operation.html
#
# Generated: 2026-02-13
# NOTE: このテンプレートは参考用です。実際の使用時は環境に合わせて値を調整してください。
# Provider Version: 6.28.0

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

resource "aws_connect_hours_of_operation" "example" {
  # 設定内容: Connectインスタンスの一意の識別子
  # 省略時: エラー（必須）
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  # 設定内容: 営業時間の名前
  # 省略時: エラー（必須）
  name = "営業時間名"

  # 設定内容: タイムゾーン（IANA形式）
  # 設定可能な値: Asia/Tokyo, America/New_York, Europe/London等のIANAタイムゾーン
  # 省略時: エラー（必須）
  time_zone = "Asia/Tokyo"

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: ap-northeast-1, us-east-1, eu-west-1等のリージョンコード
  # 省略時: プロバイダー設定のリージョン
  region = "ap-northeast-1"

  #-----------------------------------------------------------------------
  # 説明・メモ
  #-----------------------------------------------------------------------

  # 設定内容: 営業時間の説明
  # 省略時: 説明なし
  description = "平日9時から18時までの営業時間"

  #-----------------------------------------------------------------------
  # 営業時間設定
  #-----------------------------------------------------------------------

  # 月曜日から金曜日の営業時間（9:00-18:00）
  config {
    # 設定内容: 曜日の指定
    # 設定可能な値: MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
    # 省略時: エラー（必須）
    day = "MONDAY"

    # 営業開始時刻
    start_time {
      # 設定内容: 時（0-23）
      # 省略時: エラー（必須）
      hours = 9

      # 設定内容: 分（0-59）
      # 省略時: エラー（必須）
      minutes = 0
    }

    # 営業終了時刻
    end_time {
      # 設定内容: 時（0-23）
      # 省略時: エラー（必須）
      hours = 18

      # 設定内容: 分（0-59）
      # 省略時: エラー（必須）
      minutes = 0
    }
  }

  config {
    day = "TUESDAY"

    start_time {
      hours   = 9
      minutes = 0
    }

    end_time {
      hours   = 18
      minutes = 0
    }
  }

  config {
    day = "WEDNESDAY"

    start_time {
      hours   = 9
      minutes = 0
    }

    end_time {
      hours   = 18
      minutes = 0
    }
  }

  config {
    day = "THURSDAY"

    start_time {
      hours   = 9
      minutes = 0
    }

    end_time {
      hours   = 18
      minutes = 0
    }
  }

  config {
    day = "FRIDAY"

    start_time {
      hours   = 9
      minutes = 0
    }

    end_time {
      hours   = 18
      minutes = 0
    }
  }

  # 土曜日の短縮営業（10:00-15:00）
  config {
    day = "SATURDAY"

    start_time {
      hours   = 10
      minutes = 0
    }

    end_time {
      hours   = 15
      minutes = 0
    }
  }

  # 日曜日は休業（configブロック自体を削除または別の営業時間リソースとして管理）

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------

  # 設定内容: リソースに付与するタグ
  # 省略時: タグなし
  tags = {
    Name        = "営業時間"
    Environment = "production"
    Department  = "CustomerSupport"
  }
}

#-----------------------------------------------------------------------
# 24時間営業の設定例
#-----------------------------------------------------------------------

resource "aws_connect_hours_of_operation" "twentyfour_seven" {
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"
  name        = "24時間365日営業"
  time_zone   = "UTC"
  description = "年中無休24時間対応"

  # 全曜日を24時間営業に設定
  config {
    day = "MONDAY"

    start_time {
      hours   = 0
      minutes = 0
    }

    end_time {
      hours   = 0
      minutes = 0
    }
  }

  config {
    day = "TUESDAY"

    start_time {
      hours   = 0
      minutes = 0
    }

    end_time {
      hours   = 0
      minutes = 0
    }
  }

  config {
    day = "WEDNESDAY"

    start_time {
      hours   = 0
      minutes = 0
    }

    end_time {
      hours   = 0
      minutes = 0
    }
  }

  config {
    day = "THURSDAY"

    start_time {
      hours   = 0
      minutes = 0
    }

    end_time {
      hours   = 0
      minutes = 0
    }
  }

  config {
    day = "FRIDAY"

    start_time {
      hours   = 0
      minutes = 0
    }

    end_time {
      hours   = 0
      minutes = 0
    }
  }

  config {
    day = "SATURDAY"

    start_time {
      hours   = 0
      minutes = 0
    }

    end_time {
      hours   = 0
      minutes = 0
    }
  }

  config {
    day = "SUNDAY"

    start_time {
      hours   = 0
      minutes = 0
    }

    end_time {
      hours   = 0
      minutes = 0
    }
  }

  tags = {
    Name = "24時間営業"
    Type = "AlwaysOpen"
  }
}

#-----------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-----------------------------------------------------------------------
# このリソースから参照可能な属性:
#
# arn
#   営業時間のARN
#   形式: arn:aws:connect:ap-northeast-1:123456789012:instance/aaaaaaaa-bbbb-cccc-dddd-111111111111/operating-hours/eeeeeeee-ffff-gggg-hhhh-222222222222
#
# hours_of_operation_id
#   営業時間の一意の識別子
#   形式: eeeeeeee-ffff-gggg-hhhh-222222222222
#
# id
#   リソースの識別子（instance_id:hours_of_operation_id形式）
#   形式: aaaaaaaa-bbbb-cccc-dddd-111111111111:eeeeeeee-ffff-gggg-hhhh-222222222222
#
# region
#   リソースが管理されるリージョン
#   形式: ap-northeast-1
#
# tags_all
#   リソースに付与された全タグ（プロバイダーデフォルトタグを含む）
