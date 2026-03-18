#---------------------------------------------------------------
# AWS User Notifications Managed Notification Account Contact Association
#---------------------------------------------------------------
#
# AWS User Notificationsのマネージド通知設定（Managed Notification Configuration）に
# アカウントコンタクトを関連付けるリソースです。
# マネージド通知はAWSが自動生成する通知（現在はAWS Healthからの通知）であり、
# このリソースを使用してアカウントの連絡先（プライマリ、請求、運用、セキュリティ）を
# 特定のマネージド通知カテゴリに紐付けることで、通知の受信先を制御できます。
#
# AWS公式ドキュメント:
#   - マネージド通知の概要: https://docs.aws.amazon.com/notifications/latest/userguide/managed-notifications.html
#   - アカウントコンタクトの管理: https://docs.aws.amazon.com/notifications/latest/userguide/Add-remove-account-contacts.html
#   - API リファレンス: https://docs.aws.amazon.com/notifications/latest/APIReference/API_AssociateManagedNotificationAccountContact.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/notifications_managed_notification_account_contact_association
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_notifications_managed_notification_account_contact_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # contact_identifier (Required)
  # 設定内容: マネージド通知設定に関連付けるアカウントコンタクトの種類を指定します。
  #           AWSアカウントに登録されている連絡先の種類に対応しています。
  # 設定可能な値:
  #   - "ACCOUNT_PRIMARY": プライマリアカウント連絡先（ルートユーザーのメールアドレス）
  #   - "ACCOUNT_ALTERNATE_BILLING": 代替請求連絡先
  #   - "ACCOUNT_ALTERNATE_OPERATIONS": 代替運用連絡先
  #   - "ACCOUNT_ALTERNATE_SECURITY": 代替セキュリティ連絡先
  contact_identifier = "ACCOUNT_PRIMARY"

  # managed_notification_configuration_arn (Required)
  # 設定内容: アカウントコンタクトを関連付けるマネージド通知設定のARNを指定します。
  #           マネージド通知設定はAWSが提供する事前定義された通知カテゴリです。
  # 設定可能な値: 有効なマネージド通知設定ARN文字列
  #               例: arn:aws:notifications::123456789012:managed-notification-configuration/category/AWS-Health/sub-category/Security
  managed_notification_configuration_arn = "arn:aws:notifications::123456789012:managed-notification-configuration/category/AWS-Health/sub-category/Security"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - contact_identifier: 関連付けられたアカウントコンタクトの識別子
# - managed_notification_configuration_arn: 関連付けられたマネージド通知設定のARN
#---------------------------------------------------------------
