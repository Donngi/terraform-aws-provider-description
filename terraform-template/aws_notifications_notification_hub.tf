#---------------------------------------------------------------
# AWS User Notifications - Notification Hub (通知ハブ)
#---------------------------------------------------------------
#
# AWS User Notifications の通知ハブを管理するリソースです。
# 通知ハブは、指定したリージョンで AWS User Notifications を有効化し、
# そのリージョンで発生するイベントを通知設定に集約するためのエントリポイントです。
# 通知設定（aws_notifications_notification_configuration）を使用する前に、
# 対象リージョンで通知ハブを作成しておく必要があります。
#
# AWS公式ドキュメント:
#   - AWS User Notifications: https://docs.aws.amazon.com/notifications/latest/userguide/what-is-notifications.html
#   - 通知ハブ (API): https://docs.aws.amazon.com/notifications/latest/APIReference/API_RegisterNotificationHub.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/notifications_notification_hub
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_notifications_notification_hub" "example" {
  #-------------------------------------------------------------
  # 通知ハブ設定
  #-------------------------------------------------------------

  # notification_hub_region (Required)
  # 設定内容: 通知ハブを有効化する AWS リージョンコードを指定します。
  #           指定したリージョンで AWS User Notifications が有効化され、
  #           そのリージョンのイベントが通知設定に集約されます。
  # 設定可能な値: 有効な AWS リージョンコード（例: us-east-1, ap-northeast-1）
  notification_hub_region = "us-east-1"

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定します。
  timeouts {
    # create (Optional)
    # 設定内容: 通知ハブの作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" など Go の time.ParseDuration が解析できる文字列
    # 省略時: プロバイダーのデフォルト値が使用されます
    create = "30m"

    # delete (Optional)
    # 設定内容: 通知ハブの削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" など Go の time.ParseDuration が解析できる文字列
    # 省略時: プロバイダーのデフォルト値が使用されます
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 通知ハブが有効化された AWS リージョンコード（notification_hub_region と同値）
#---------------------------------------------------------------
