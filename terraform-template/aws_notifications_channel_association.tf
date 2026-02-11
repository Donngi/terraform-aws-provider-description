#---------------------------------------------------------------
# AWS User Notifications Channel Association
#---------------------------------------------------------------
#
# AWS User Notifications の通知設定（Notification Configuration）に
# 配信チャネル（メール、モバイル、チャット等）を関連付けるリソース。
#
# このリソースを使用することで、通知設定に対してどのチャネルを通じて
# 通知を配信するかを制御できます。サポートされるチャネルには以下が含まれます：
#   - Email（notifications-contacts）
#   - AWS Console Mobile Application
#   - Amazon Q Developer in chat applications（Slack、Chime等）
#
# AWS公式ドキュメント:
#   - AssociateChannel API: https://docs.aws.amazon.com/notifications/latest/APIReference/API_AssociateChannel.html
#   - Adding delivery channels: https://docs.aws.amazon.com/notifications/latest/userguide/manage-delivery-channels.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/notifications_channel_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_notifications_channel_association" "this" {
  #---------------------------------------------------------------
  # 必須引数（Required Arguments）
  #---------------------------------------------------------------

  # arn (Required, Forces new resource)
  # 通知設定に関連付けるチャネルのARN。
  #
  # 関連付け可能なチャネルタイプ：
  #   - notifications-contacts: メール連絡先（aws_notificationscontacts_email_contact）
  #   - chatbot: Amazon Q Developer in chat applications（Slack、Chime等）
  #   - consoleapp: AWS Console Mobile Application
  #
  # ARNパターン:
  #   ^arn:aws:(chatbot|consoleapp|notifications-contacts):[a-zA-Z0-9-]*:[0-9]{12}:[a-zA-Z0-9-_.@]+/[a-zA-Z0-9/_.@:-]+$
  #
  # 例:
  #   - メール: arn:aws:notifications-contacts:us-east-1:123456789012:emailcontact/example-contact
  #   - チャット: arn:aws:chatbot::123456789012:chat-configuration/slack-channel/my-channel
  #
  # Type: string
  arn = null # Required

  # notification_configuration_arn (Required, Forces new resource)
  # チャネルを関連付ける通知設定のARN。
  #
  # aws_notifications_notification_configuration リソースで作成した
  # 通知設定のARNを指定します。
  #
  # Type: string
  notification_configuration_arn = null # Required
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# このリソースはTerraformの状態に追加の属性をエクスポートしません。
# arn と notification_configuration_arn のみが設定可能であり、
# これらの値がそのまま状態として保持されます。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# # 1. 通知設定の作成
# resource "aws_notifications_notification_configuration" "example" {
#   name        = "example-notification-config"
#   description = "Example notification configuration"
# }
#
# # 2. メール連絡先の作成
# resource "aws_notificationscontacts_email_contact" "example" {
#   name          = "example-contact"
#   email_address = "example@example.com"
# }
#
# # 3. チャネル関連付けの作成
# resource "aws_notifications_channel_association" "example" {
#   arn                            = aws_notificationscontacts_email_contact.example.arn
#   notification_configuration_arn = aws_notifications_notification_configuration.example.arn
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# terraform import コマンドを使用してインポートできます。
# インポート時の識別子は通知設定ARNとチャネルARNを結合した値を使用します。
#
# 例:
#   terraform import aws_notifications_channel_association.example \
#     arn:aws:notifications:us-east-1:123456789012:configuration/example|arn:aws:notifications-contacts:us-east-1:123456789012:emailcontact/example
#
#---------------------------------------------------------------
