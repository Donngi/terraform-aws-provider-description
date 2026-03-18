#---------------------------------------------------------------
# AWS User Notifications Managed Notification Additional Channel Association
#---------------------------------------------------------------
#
# AWS User Notificationsのマネージド通知設定（Managed Notification Configuration）に
# 追加チャンネルを関連付けるリソースです。
# マネージド通知はAWSが自動生成する通知（AWS Healthからの通知など）であり、
# このリソースを使用してメール連絡先、モバイルデバイス、チャットチャンネルなどの
# 追加の通知チャンネルをマネージド通知カテゴリに紐付けることで、
# 通知の受信先を拡張できます。
#
# AWS公式ドキュメント:
#   - マネージド通知の概要: https://docs.aws.amazon.com/notifications/latest/userguide/managed-notifications.html
#   - チャンネルの管理: https://docs.aws.amazon.com/notifications/latest/userguide/managing-channels.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/notifications_managed_notification_additional_channel_association
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_notifications_managed_notification_additional_channel_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # channel_arn (Required)
  # 設定内容: マネージド通知設定に関連付けるチャンネルのARNを指定します。
  #           AWS Chatbot、AWS Console Mobile App、
  #           AWS Notifications Contacts（メール連絡先）などのチャンネルが対象です。
  # 設定可能な値: 有効なチャンネルARN文字列
  channel_arn = aws_notificationscontacts_email_contact.example.arn

  # managed_notification_arn (Required)
  # 設定内容: チャンネルを関連付けるマネージド通知設定のARNを指定します。
  #           マネージド通知設定はAWSが提供する事前定義された通知カテゴリです。
  # 設定可能な値: 有効なマネージド通知設定ARN文字列
  #               例: arn:aws:notifications::123456789012:managed-notification-configuration/category/AWS-Health/sub-category/Security
  managed_notification_arn = "arn:aws:notifications::123456789012:managed-notification-configuration/category/AWS-Health/sub-category/Security"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - channel_arn: 関連付けられたチャンネルのARN
# - managed_notification_arn: 関連付けられたマネージド通知設定のARN
#---------------------------------------------------------------
