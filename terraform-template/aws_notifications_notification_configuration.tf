#---------------------------------------------------------------
# AWS User Notifications Notification Configuration
#---------------------------------------------------------------
#
# AWS User Notificationsの通知設定を管理するリソースです。
# 通知設定は、特定のAWSサービスやイベントルールに関する通知を
# 受け取るためのコンテナとして機能します。
#
# 通知設定を作成すると、指定したイベントパターンに一致するイベントが
# 発生した際に、設定した配信チャネル（メール、チャット、モバイルアプリ等）
# を通じて通知を受け取ることができます。
#
# AWS公式ドキュメント:
#   - User Notifications 入門ガイド: https://docs.aws.amazon.com/notifications/latest/userguide/getting-started.html
#   - 通知設定の管理: https://docs.aws.amazon.com/notifications/latest/userguide/managing-notifications.html
#   - CreateNotificationConfiguration API: https://docs.aws.amazon.com/notifications/latest/APIReference/API_CreateNotificationConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/notifications_notification_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_notifications_notification_configuration" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # 通知設定の名前
  # - RFC 3986の予約されていない文字をサポート
  # - 最小長: 1文字、最大長: 64文字
  # - パターン: [A-Za-z0-9_\-]+
  # - 用途: 通知設定を識別するための一意の名前
  name = "example-notification-config"

  # 通知設定の説明
  # - 最小長: 0文字、最大長: 256文字
  # - 用途: 通知設定の目的や内容を説明するテキスト
  # - 例: "本番環境のCloudWatchアラーム通知"
  description = "Example notification configuration for monitoring"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 通知の集約期間設定
  # - 複数のイベントを1つの通知にまとめる時間を指定
  # - 有効な値:
  #   * LONG  - 12時間の期間で通知を集約（低優先度の通知に推奨）
  #   * SHORT - 5分間の期間で通知を集約（高優先度の通知に推奨）
  #   * NONE  - 通知を集約しない（即座に個別通知を送信）
  # - デフォルト: NONE
  # - 用途: 通知の頻度を制御し、通知疲れを防ぐ
  # - 注意: 集約設定はデフォルトで有効化されることが推奨されています
  aggregation_duration = "SHORT"

  # タグの設定
  # - リソースに割り当てるタグのマップ（キー: 値のペア）
  # - 最大200個のタグを設定可能
  # - キーのパターン: (?!aws:).{1,128}（awsプレフィックスは予約済み）
  # - 値の長さ: 最小0文字、最大256文字
  # - 用途: リソースの分類、コスト追跡、アクセス制御など
  # - 注意: provider設定でdefault_tagsが設定されている場合、
  #         同じキーのタグはこちらの設定で上書きされます
  tags = {
    Environment = "production"
    Service     = "monitoring"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用の属性）
#---------------------------------------------------------------
# 以下の属性は読み取り専用で、リソース作成後に参照可能です。
# Terraformコードで値を設定することはできません。
#
# - arn
#   通知設定のAmazon Resource Name (ARN)
#   形式: arn:aws:notifications::[0-9]{12}:configuration/[a-z0-9]{27}
#   用途: 他のリソースから通知設定を参照する際に使用
#   例: aws_notifications_notification_configuration.example.arn
#
# - tags_all
#   リソースに割り当てられた全タグのマップ
#   providerのdefault_tags設定で定義されたタグも含まれます
#   用途: リソースに適用されている全タグの確認
#   例: aws_notifications_notification_configuration.example.tags_all
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例とベストプラクティス
#---------------------------------------------------------------
#
# 1. 基本的な使用例:
#    最小限の設定で通知設定を作成する場合
#    resource "aws_notifications_notification_configuration" "basic" {
#      name        = "basic-config"
#      description = "Basic notification configuration"
#    }
#
# 2. 集約設定ありの例:
#    5分間の短期集約で高優先度通知を設定する場合
#    resource "aws_notifications_notification_configuration" "short_aggregation" {
#      name                 = "high-priority-alerts"
#      description          = "High priority alerts with short aggregation"
#      aggregation_duration = "SHORT"
#    }
#
# 3. 長期集約の例:
#    12時間の長期集約で低優先度通知を設定する場合
#    resource "aws_notifications_notification_configuration" "long_aggregation" {
#      name                 = "low-priority-notifications"
#      description          = "Low priority notifications with long aggregation"
#      aggregation_duration = "LONG"
#    }
#
# 4. タグ付きの例:
#    環境やプロジェクト情報をタグで管理する場合
#    resource "aws_notifications_notification_configuration" "tagged" {
#      name        = "production-alerts"
#      description = "Production environment alerts"
#      tags = {
#        Environment = "production"
#        Project     = "web-application"
#        Team        = "devops"
#        CostCenter  = "engineering"
#      }
#    }
#
# 注意事項:
# - 通知設定を作成しただけでは通知は送信されません
# - 実際に通知を受け取るには、以下のリソースも設定が必要です:
#   * aws_notifications_event_rule: イベントルールの定義
#   * aws_notifications_channel_association: 配信チャネルの関連付け
# - 通知データは通知ハブに保存されます
# - 複数アカウントから通知を受け取る場合は、EventBridgeの
#   クロスアカウント設定が必要です
#
#---------------------------------------------------------------
