# ==============================================================================
# AWS Connect Hours of Operation - Annotated Template
# ==============================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# Note: このテンプレートは生成時点(2026-01-19)の情報に基づいています。
#       最新の仕様については、以下の公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_hours_of_operation
# ==============================================================================

resource "aws_connect_hours_of_operation" "example" {
  # ==============================================================================
  # 必須パラメータ
  # ==============================================================================

  # instance_id - Amazon Connect インスタンスの識別子
  # Amazon Connect インスタンスのIDを指定します。
  # フォーマット: UUID形式 (例: aaaaaaaa-bbbb-cccc-dddd-111111111111)
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-instances.html
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  # name - 営業時間の名前
  # 営業時間セットの名前を指定します。
  # 制約: 1〜127文字
  # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_HoursOfOperation.html
  name = "Office Hours"

  # time_zone - タイムゾーン
  # 営業時間のタイムゾーンを指定します。
  # Amazon Connectは夏時間（DST）を自動的に調整します。
  # 例: "EST", "America/New_York", "Asia/Tokyo", "UTC"
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/set-hours-operation.html
  time_zone = "EST"

  # ==============================================================================
  # オプションパラメータ
  # ==============================================================================

  # description - 営業時間の説明
  # 営業時間セットの説明を指定します。
  # 制約: 1〜250文字
  # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_HoursOfOperation.html
  description = "Monday to Friday office hours"

  # id - リソース識別子
  # Terraformが管理するリソースのID。
  # 通常は自動生成されるため、明示的な指定は不要です。
  # フォーマット: {instance_id}:{hours_of_operation_id}
  # id = "aaaaaaaa-bbbb-cccc-dddd-111111111111:hhhhhhhh-iiii-jjjj-kkkk-222222222222"

  # region - AWSリージョン
  # このリソースを管理するAWSリージョンを指定します。
  # 未指定の場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - リソースタグ
  # 営業時間に適用するタグを指定します。
  # プロバイダーのdefault_tagsと組み合わせて使用できます。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "Example Hours of Operation"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }

  # tags_all - 全てのタグ
  # プロバイダーのdefault_tagsを含む全てのタグ。
  # 通常はTerraformが自動管理するため、明示的な指定は不要です。
  # tags_all = {
  #   Name        = "Example Hours of Operation"
  #   Environment = "Production"
  #   ManagedBy   = "Terraform"
  # }

  # ==============================================================================
  # 必須ブロック: config
  # ==============================================================================
  # 営業時間の設定を定義します。
  # 1つ以上のconfigブロックが必要です（最大100個まで設定可能）。
  # 各ブロックは特定の曜日の営業時間を定義します。
  # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_HoursOfOperationConfig.html

  # 月曜日の営業時間
  config {
    # day - 曜日
    # 営業時間を適用する曜日を指定します。
    # 有効な値: SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY
    # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_HoursOfOperationConfig.html
    day = "MONDAY"

    # start_time - 開始時刻
    # コンタクトセンターの開始時刻を指定します。
    # 必須ブロック（各configに1つ必要）
    start_time {
      # hours - 開始時刻の時間
      # 24時間形式で時間を指定します（0-23）
      # 例: 午前8時 = 8, 午後1時 = 13
      hours = 8

      # minutes - 開始時刻の分
      # 分を指定します（0-59）
      # 例: 30分 = 30
      minutes = 0
    }

    # end_time - 終了時刻
    # コンタクトセンターの終了時刻を指定します。
    # 必須ブロック（各configに1つ必要）
    # 注意: 深夜0時を指定する場合は hours=0, minutes=0 を使用します
    # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/set-hours-operation.html#set-hours-operation-midnight
    end_time {
      # hours - 終了時刻の時間
      # 24時間形式で時間を指定します（0-23）
      # 例: 午後5時 = 17, 深夜0時 = 0
      hours = 17

      # minutes - 終了時刻の分
      # 分を指定します（0-59）
      minutes = 0
    }
  }

  # 火曜日の営業時間
  config {
    day = "TUESDAY"

    start_time {
      hours   = 8
      minutes = 0
    }

    end_time {
      hours   = 17
      minutes = 0
    }
  }

  # 水曜日の営業時間
  config {
    day = "WEDNESDAY"

    start_time {
      hours   = 8
      minutes = 0
    }

    end_time {
      hours   = 17
      minutes = 0
    }
  }

  # 木曜日の営業時間
  config {
    day = "THURSDAY"

    start_time {
      hours   = 8
      minutes = 0
    }

    end_time {
      hours   = 17
      minutes = 0
    }
  }

  # 金曜日の営業時間
  config {
    day = "FRIDAY"

    start_time {
      hours   = 8
      minutes = 0
    }

    end_time {
      hours   = 17
      minutes = 0
    }
  }

  # 土曜日の営業時間（ランチ休憩の例）
  # 複数の時間帯を設定することで、休憩時間を表現できます
  # この例では、8:00-12:00と13:00-17:00の2つの時間帯を設定しています
  config {
    day = "SATURDAY"

    start_time {
      hours   = 8
      minutes = 0
    }

    end_time {
      hours   = 12
      minutes = 0
    }
  }

  config {
    day = "SATURDAY"

    start_time {
      hours   = 13
      minutes = 0
    }

    end_time {
      hours   = 17
      minutes = 0
    }
  }

  # 24時間営業の例（日曜日）
  # 深夜0時から深夜0時までを指定することで24時間営業を表現できます
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
}

# ==============================================================================
# 出力値の例
# ==============================================================================

# arn - Amazon Resource Name
# 営業時間のARNを出力します（computed属性）
output "hours_of_operation_arn" {
  description = "The ARN of the Hours of Operation"
  value       = aws_connect_hours_of_operation.example.arn
}

# hours_of_operation_id - 営業時間ID
# 営業時間の一意の識別子を出力します（computed属性）
output "hours_of_operation_id" {
  description = "The identifier for the hours of operation"
  value       = aws_connect_hours_of_operation.example.hours_of_operation_id
}

# ==============================================================================
# 参考情報
# ==============================================================================
#
# AWS公式ドキュメント:
# - Amazon Connect Getting Started:
#   https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
# - Set Hours of Operation:
#   https://docs.aws.amazon.com/connect/latest/adminguide/set-hours-operation.html
# - HoursOfOperation API Reference:
#   https://docs.aws.amazon.com/connect/latest/APIReference/API_HoursOfOperation.html
# - HoursOfOperationConfig API Reference:
#   https://docs.aws.amazon.com/connect/latest/APIReference/API_HoursOfOperationConfig.html
# - CreateHoursOfOperation API:
#   https://docs.aws.amazon.com/connect/latest/APIReference/API_CreateHoursOfOperation.html
#
# Terraform公式ドキュメント:
# - aws_connect_hours_of_operation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_hours_of_operation
#
# 重要な注意事項:
# - Amazon Connectは夏時間（Daylight Saving Time）を自動的に調整します
# - 深夜0時を指定する場合は、hours=0, minutes=0 を使用します
# - 休憩時間を表現する場合は、同じ曜日に複数のconfigブロックを設定できます
# - 最大100個のconfigブロックを設定できます
# - エージェントの休憩時間は営業時間ではなく、カスタムエージェントステータスで管理することが推奨されます
#   https://docs.aws.amazon.com/connect/latest/adminguide/agent-custom.html
#
# ==============================================================================
