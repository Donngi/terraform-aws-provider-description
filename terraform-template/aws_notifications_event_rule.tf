#---------------------------------------------------------------
# AWS User Notifications Event Rule
#---------------------------------------------------------------
#
# AWS User Notificationsのイベントルールを作成します。
# イベントルールは、AWSサービスからのイベントをフィルタリングし、
# 通知設定（Notification Configuration）に関連付けて通知を生成するためのルールです。
#
# AWS公式ドキュメント:
#   - AWS User Notifications ユーザーガイド: https://docs.aws.amazon.com/notifications/latest/userguide/
#   - EventRuleStructure API リファレンス: https://docs.aws.amazon.com/notifications/latest/APIReference/API_EventRuleStructure.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/notifications_event_rule
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_notifications_event_rule" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # event_type - イベントタイプ
  # [必須] マッチさせるEventBridgeイベントのタイプを指定します。
  # 1〜128文字で、パターン ([a-zA-Z0-9 \-\(\)])+ に一致する必要があります。
  # 例: "CloudWatch Alarm State Change", "EC2 Instance State-change Notification"
  event_type = "CloudWatch Alarm State Change"

  # notification_configuration_arn - 通知設定のARN
  # [必須] このイベントルールを関連付ける通知設定（Notification Configuration）のARNを指定します。
  # パターン: arn:aws:notifications::[0-9]{12}:configuration/[a-z0-9]{27}
  notification_configuration_arn = aws_notifications_notification_configuration.example.arn

  # regions - リージョン
  # [必須] イベントルールを適用するAWSリージョンのセットを指定します。
  # 各リージョンは2〜25文字で、パターン ([a-z]{1,2})-([a-z]{1,15}-)+([0-9]) に一致する必要があります。
  # 複数のリージョンを指定することで、マルチリージョンでのイベント監視が可能です。
  regions = ["us-east-1", "us-west-2"]

  # source - イベントソース
  # [必須] マッチさせるイベントのソースを指定します。
  # 1〜36文字で、パターン aws.([a-z0-9\-])+ に一致する必要があります。
  # 例: "aws.cloudwatch", "aws.ec2", "aws.health", "aws.macie"
  source = "aws.cloudwatch"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # event_pattern - イベントパターン
  # [任意] イベントに対する追加のフィルタ条件をJSON文字列で指定します。
  # 最大4096文字まで指定可能です。
  # EventBridgeのイベントパターン構文に従って記述します。
  # 指定しない場合、sourceとevent_typeに一致するすべてのイベントが通知対象となります。
  # 例: CloudWatchアラームがALARM状態になった場合のみ通知する
  event_pattern = jsonencode({
    detail = {
      state = {
        value = ["ALARM"]
      }
    }
  })
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能です。
#
# arn - イベントルールのARN
#   AWS CloudFormationによって生成されるARNで、NotificationConfigurationとの
#   関連付けに使用されます。
#---------------------------------------------------------------
