################################################################################
# AWS Redshift Event Subscription
# リソース: aws_redshift_event_subscription
# プロバイダーバージョン: 6.28.0
# 最終更新: 2026-02-03
################################################################################
# このリソースは、Amazon Redshiftのイベントサブスクリプションを管理します。
# Redshiftクラスター、パラメータグループ、セキュリティグループ、スナップショット、
# またはスケジュールされたアクションに関連するイベントをSNSトピック経由で通知できます。
#
# ユースケース:
# - Redshiftクラスターの運用イベント（設定変更、管理操作など）の監視
# - セキュリティイベントのリアルタイム通知
# - クラスタースナップショットやパラメータ変更の追跡
# - 運用チームへの自動アラート送信
#
# 参考リンク:
# - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/redshift_event_subscription
# - https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-event-notifications.html
################################################################################

resource "aws_redshift_event_subscription" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # (Required) Redshiftイベントサブスクリプションの名前
  # 制約:
  # - アカウント内でリージョンごとに一意である必要があります
  # - 英数字とハイフン(-)のみ使用可能
  # - 最大255文字
  # 例: "prod-redshift-events", "dev-cluster-notifications"
  name = "example-redshift-event-subscription"

  # (Required) イベントを送信するSNSトピックのARN
  # 送信先のSNSトピックは事前に作成されている必要があります
  # 例: "arn:aws:sns:us-east-1:123456789012:redshift-events"
  sns_topic_arn = "arn:aws:sns:us-east-1:123456789012:example-topic"

  ################################################################################
  # オプションパラメータ - イベントフィルタリング
  ################################################################################

  # (Optional) イベントソースのタイプ
  # 有効な値:
  # - "cluster" - Redshiftクラスター関連のイベント
  # - "cluster-parameter-group" - パラメータグループ関連のイベント
  # - "cluster-security-group" - セキュリティグループ関連のイベント
  # - "cluster-snapshot" - スナップショット関連のイベント
  # - "scheduled-action" - スケジュールされたアクション関連のイベント
  # 未設定の場合、全てのソースタイプが対象となります
  # source_idsを指定する場合は、このパラメータも必須です
  source_type = "cluster"

  # (Optional) イベントソースの識別子のリスト
  # source_typeで指定したタイプの特定のリソースIDを指定します
  # 例:
  # - source_type = "cluster"の場合: クラスター識別子のリスト
  # - source_type = "cluster-snapshot"の場合: スナップショット識別子のリスト
  # 未指定の場合、指定したsource_typeの全てのソースが対象となります
  source_ids = [
    "example-redshift-cluster-1",
    # "example-redshift-cluster-2",
  ]

  # (Optional) 通知するイベントの重大度レベル
  # 有効な値:
  # - "INFO" (デフォルト) - 情報レベルのイベント（設定変更、管理操作など）
  # - "ERROR" - エラーレベルのイベント（障害、問題など）
  # デフォルト値: "INFO"
  severity = "INFO"

  # (Optional) サブスクライブするイベントカテゴリのリスト
  # 指定したsource_typeに対応するイベントカテゴリを指定します
  # 主なカテゴリ（クラスターの場合）:
  # - "configuration" - 設定変更
  # - "management" - 管理操作（起動、停止など）
  # - "monitoring" - モニタリング関連
  # - "security" - セキュリティ関連
  # - "pending" - 保留中の操作
  # 利用可能なカテゴリはsource_typeによって異なります
  # 詳細はAWS CLIで確認: aws redshift describe-event-categories
  # 未指定の場合、全てのイベントカテゴリが対象となります
  event_categories = [
    "configuration",
    "management",
    "monitoring",
    "security",
  ]

  ################################################################################
  # オプションパラメータ - サブスクリプション設定
  ################################################################################

  # (Optional) サブスクリプションの有効/無効フラグ
  # true: サブスクリプションが有効でイベント通知が送信されます
  # false: サブスクリプションが無効でイベント通知は送信されません
  # デフォルト値: true
  # 一時的に通知を停止したい場合などに使用します
  enabled = true

  # (Optional) リージョンの指定
  # このリソースが管理されるAWSリージョンを指定します
  # 未指定の場合、プロバイダー設定のリージョンが使用されます
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  ################################################################################
  # オプションパラメータ - タグ
  ################################################################################

  # (Optional) リソースに割り当てるタグのマップ
  # リソースの分類、コスト管理、検索などに使用
  # プロバイダーレベルでdefault_tagsが設定されている場合、
  # 同じキーのタグはここで指定した値で上書きされます
  tags = {
    Name        = "example-redshift-event-subscription"
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "redshift-monitoring"
  }

  ################################################################################
  # タイムアウト設定
  ################################################################################

  # (Optional) リソース操作のタイムアウト設定
  # 大規模な設定やネットワークの遅延がある場合に調整します
  timeouts {
    # サブスクリプション作成のタイムアウト（デフォルト: 40分）
    create = "40m"

    # サブスクリプション更新のタイムアウト（デフォルト: 40分）
    update = "40m"

    # サブスクリプション削除のタイムアウト（デフォルト: 40分）
    delete = "40m"
  }
}

################################################################################
# 出力値（参照用）
################################################################################

# サブスクリプションのARN
# 他のリソースやポリシーで参照する際に使用
output "redshift_event_subscription_arn" {
  description = "The ARN of the Redshift event subscription"
  value       = aws_redshift_event_subscription.example.arn
}

# サブスクリプションのID（名前と同じ）
# インポートやデータソースでの参照に使用
output "redshift_event_subscription_id" {
  description = "The ID (name) of the Redshift event subscription"
  value       = aws_redshift_event_subscription.example.id
}

# サブスクリプションに関連付けられたAWSアカウントID
# マルチアカウント環境での確認用
output "redshift_event_subscription_customer_aws_id" {
  description = "The AWS customer account associated with the subscription"
  value       = aws_redshift_event_subscription.example.customer_aws_id
}

# サブスクリプションのステータス
# "active", "creating", "deleting", "modifying" などの状態を確認
output "redshift_event_subscription_status" {
  description = "The status of the Redshift event subscription"
  value       = aws_redshift_event_subscription.example.status
}

# プロバイダーのdefault_tagsとマージされた全てのタグ
# 実際に適用されているタグの確認用
output "redshift_event_subscription_tags_all" {
  description = "All tags assigned to the subscription including provider defaults"
  value       = aws_redshift_event_subscription.example.tags_all
}

################################################################################
# 使用例
################################################################################

# Example 1: クラスター用のイベントサブスクリプション（基本設定）
resource "aws_redshift_event_subscription" "cluster_events" {
  name          = "cluster-events-subscription"
  sns_topic_arn = aws_sns_topic.redshift_events.arn
  source_type   = "cluster"
  source_ids    = [aws_redshift_cluster.main.id]
  severity      = "INFO"

  event_categories = [
    "configuration",
    "management",
  ]

  tags = {
    Name = "cluster-events"
  }
}

# Example 2: 全イベントタイプの監視（セキュリティ重視）
resource "aws_redshift_event_subscription" "all_events_security" {
  name          = "all-events-security"
  sns_topic_arn = aws_sns_topic.security_alerts.arn
  severity      = "ERROR" # エラーレベルのみ

  # source_typeとsource_idsを指定しない = 全てのソースタイプが対象

  tags = {
    Name        = "all-events-security"
    Alert       = "critical"
    Environment = "production"
  }
}

# Example 3: スナップショットイベントの監視
resource "aws_redshift_event_subscription" "snapshot_events" {
  name          = "snapshot-events"
  sns_topic_arn = aws_sns_topic.backup_notifications.arn
  source_type   = "cluster-snapshot"

  event_categories = [
    "backup",
  ]

  enabled = true

  tags = {
    Name    = "snapshot-events"
    Purpose = "backup-monitoring"
  }
}

# Example 4: パラメータグループ変更の監視
resource "aws_redshift_event_subscription" "parameter_group_events" {
  name          = "parameter-group-events"
  sns_topic_arn = aws_sns_topic.config_changes.arn
  source_type   = "cluster-parameter-group"
  source_ids    = [aws_redshift_parameter_group.main.id]

  event_categories = [
    "configuration",
  ]

  tags = {
    Name        = "parameter-group-events"
    Environment = "production"
  }
}

# Example 5: 一時的に無効化されたサブスクリプション
resource "aws_redshift_event_subscription" "maintenance_window" {
  name          = "maintenance-window-subscription"
  sns_topic_arn = aws_sns_topic.maintenance.arn
  source_type   = "cluster"
  enabled       = false # メンテナンス中は通知を無効化

  tags = {
    Name   = "maintenance-window"
    Status = "temporarily-disabled"
  }
}

################################################################################
# 関連リソース定義例
################################################################################

# SNSトピックの定義例（イベント通知先）
resource "aws_sns_topic" "redshift_events" {
  name = "redshift-events-topic"

  tags = {
    Name = "redshift-events"
  }
}

# SNSトピックサブスクリプション例（メール通知）
resource "aws_sns_topic_subscription" "redshift_events_email" {
  topic_arn = aws_sns_topic.redshift_events.arn
  protocol  = "email"
  endpoint  = "ops-team@example.com"
}

# Redshiftクラスターの定義例（イベントソース）
resource "aws_redshift_cluster" "main" {
  cluster_identifier = "example-cluster"
  database_name      = "exampledb"
  master_username    = "admin"
  master_password    = "ExamplePassword123!" # 実際はSecrets Managerなどを使用
  node_type          = "dc2.large"
  cluster_type       = "single-node"

  tags = {
    Name = "example-cluster"
  }
}

################################################################################
# 補足情報
################################################################################

# インポート方法:
# terraform import aws_redshift_event_subscription.example example-subscription-name

# 注意事項:
# 1. SNSトピックは事前に存在している必要があります
# 2. source_idsを指定する場合、source_typeも必須です
# 3. 利用可能なイベントカテゴリはsource_typeによって異なります
# 4. enabled=falseにしてもサブスクリプション自体は維持されます
# 5. タグの変更は即座に反映されます
# 6. サブスクリプションの削除時、SNSトピックは削除されません
# 7. リージョンを跨いだイベント監視はできません
# 8. 同一の名前のサブスクリプションは同じリージョン内で作成できません

# ベストプラクティス:
# 1. 環境ごとに異なるSNSトピックを使用して通知先を分離
# 2. 重要度に応じてseverityを設定（本番環境ではERRORのみなど）
# 3. event_categoriesで必要なイベントのみをフィルタリング
# 4. タグを活用してコスト管理と運用管理を効率化
# 5. 複数のクラスターを監視する場合、source_idsで明示的に指定
# 6. セキュリティイベントは必ず監視対象に含める
# 7. SNSトピックのアクセスポリシーを適切に設定
# 8. CloudWatch Logsとの連携も検討（SNS経由でLambdaトリガー等）

# トラブルシューティング:
# - イベントが通知されない場合:
#   * enabled = trueになっているか確認
#   * SNSトピックのアクセスポリシーを確認
#   * source_typeとsource_idsの組み合わせが正しいか確認
#   * event_categoriesとseverityの設定を確認
# - サブスクリプション作成に失敗する場合:
#   * SNSトピックが存在するか確認
#   * IAMロールに必要な権限があるか確認
#   * 同じ名前のサブスクリプションが既に存在しないか確認
