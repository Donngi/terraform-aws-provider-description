#---------------------------------------------------------------
# AWS User Notifications Channel Association
#---------------------------------------------------------------
#
# AWS User Notifications のチャンネル（メール連絡先や Chatbot チャンネルなど）を
# 通知設定（Notification Configuration）に関連付けるリソースです。
# 通知設定に対して複数のチャンネルを関連付けることで、特定のイベントが
# 発生した際に複数の通知先へ同時に通知を送信できます。
#
# AWS公式ドキュメント:
#   - AWS User Notifications: https://docs.aws.amazon.com/notifications/latest/userguide/what-is-notifications.html
#   - チャンネルの関連付け (API): https://docs.aws.amazon.com/notifications/latest/APIReference/API_AssociateChannel.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/notifications_channel_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_notifications_channel_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # arn (Required)
  # 設定内容: 通知設定に関連付けるチャンネルの ARN を指定します。
  #           サポートされるチャンネルは AWS Chatbot、AWS Console Mobile App、
  #           AWS Notifications Contacts（メール連絡先）です。
  # 設定可能な値: 以下のパターンに一致する ARN 文字列
  #               ^arn:aws:(chatbot|consoleapp|notifications-contacts):[a-zA-Z0-9-]*:[0-9]{12}:[a-zA-Z0-9-_.@]+/[a-zA-Z0-9/_.@:-]+$
  arn = "arn:aws:notifications-contacts:us-east-1:123456789012:emailcontact/example-contact"

  # notification_configuration_arn (Required)
  # 設定内容: チャンネルを関連付ける通知設定の ARN を指定します。
  #           aws_notifications_notification_configuration リソースで作成した
  #           通知設定の ARN を参照します。
  # 設定可能な値: 有効な通知設定 ARN 文字列
  notification_configuration_arn = "arn:aws:notifications::123456789012:configuration/example-notification-config"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: arn と notification_configuration_arn をカンマで連結した文字列
#---------------------------------------------------------------
