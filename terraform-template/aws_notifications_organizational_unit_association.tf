#---------------------------------------------------------------
# AWS User Notifications Organizational Unit Association
#---------------------------------------------------------------
#
# AWS User Notificationsの通知設定（Notification Configuration）に
# AWS Organizations の組織単位（OU）またはルートを関連付けるリソースです。
# この関連付けにより、指定した OU 配下のアカウントに対して
# 通知設定を適用することができます。組織ルートID を指定することで、
# 組織全体に通知設定を適用することも可能です。
#
# AWS公式ドキュメント:
#   - AWS User Notifications: https://docs.aws.amazon.com/notifications/latest/userguide/what-is-notifications.html
#   - OU の関連付け (API): https://docs.aws.amazon.com/notifications/latest/APIReference/API_AssociateOrganizationalUnit.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/notifications_organizational_unit_association
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_notifications_organizational_unit_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # notification_configuration_arn (Required)
  # 設定内容: 組織単位を関連付ける通知設定の ARN を指定します。
  #           aws_notifications_notification_configuration リソースで作成した
  #           通知設定の ARN を参照します。
  # 設定可能な値: 有効な通知設定 ARN 文字列
  notification_configuration_arn = "arn:aws:notifications::123456789012:configuration/example-notification-config"

  # organizational_unit_id (Required)
  # 設定内容: 通知設定に関連付ける組織単位（OU）の ID またはルート ID を指定します。
  #           OU ID（例: ou-xxxx-xxxxxxxx）を指定すると、その OU 配下のアカウントに
  #           通知設定が適用されます。ルート ID（例: r-xxxx）を指定すると、
  #           組織全体に通知設定を適用できます。
  # 設定可能な値: 有効な OU ID（ou-xxxx-xxxxxxxx 形式）またはルート ID（r-xxxx 形式）
  organizational_unit_id = "ou-xxxx-xxxxxxxx"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - notification_configuration_arn: 関連付けられた通知設定の ARN
# - organizational_unit_id: 関連付けられた組織単位の ID
#---------------------------------------------------------------
