#---------------------------------------------------------------
# AWS User Notifications Notification Hub
#---------------------------------------------------------------
#
# AWS User Notifications の通知ハブ（Notification Hub）を管理するリソース。
# 通知ハブは、通知の保存・処理・レプリケーションを行うAWSリージョンを
# 決定するアカウントレベルの設定。通知設定（Notification Configuration）を
# 作成する前に、少なくとも1つの通知ハブを選択する必要がある。
#
# AWS公式ドキュメント:
#   - Notification Hubs: https://docs.aws.amazon.com/notifications/latest/userguide/notification-hubs.html
#   - User Notifications: https://docs.aws.amazon.com/notifications/latest/userguide/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/notifications_notification_hub
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_notifications_notification_hub" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # notification_hub_region (Required, Forces new resource)
  # 通知ハブを作成するAWSリージョン。
  # 通知はこのリージョンで保存・処理される。
  # 複数のリージョンに通知ハブを作成することで、通知のレプリケーションが可能。
  # 変更すると新しいリソースが作成される（再作成が必要）。
  #
  # 例:
  #   - "us-east-1"     : 米国東部（バージニア北部）
  #   - "us-west-2"     : 米国西部（オレゴン）
  #   - "ap-northeast-1": アジアパシフィック（東京）
  #   - "eu-west-1"     : 欧州（アイルランド）
  notification_hub_region = "ap-northeast-1"

  #---------------------------------------------------------------
  # タイムアウト設定 (Timeouts)
  #---------------------------------------------------------------

  # timeouts ブロック (Optional)
  # リソースの作成・削除操作のタイムアウト時間を設定。
  # 値は "30s"（30秒）、"5m"（5分）、"2h45m"（2時間45分）のような
  # 時間単位で指定。有効な単位は "s"（秒）、"m"（分）、"h"（時間）。
  timeouts {
    # create (Optional)
    # リソース作成時のタイムアウト時間。
    # デフォルト値はプロバイダーにより決定される。
    # create = "30m"

    # delete (Optional)
    # リソース削除時のタイムアウト時間。
    # 削除操作が状態に保存された後にdestroy操作が発生する場合にのみ適用。
    # デフォルト値はプロバイダーにより決定される。
    # delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# このリソースは追加のcomputed属性をエクスポートしません。
# notification_hub_regionのみが管理される属性です。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# 既存のNotification Hubをインポートするには、リージョン名を使用:
#
# terraform import aws_notifications_notification_hub.example us-west-2
#
#---------------------------------------------------------------
