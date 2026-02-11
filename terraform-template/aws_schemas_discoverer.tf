################################################################################
# AWS EventBridge Schema Discoverer
################################################################################
# EventBridge Schema Discoverer automatically discovers and infers event schemas
# from events flowing through an EventBridge event bus. It creates and maintains
# schemas in the EventBridge Schema Registry, enabling automatic schema versioning
# and code generation for event-driven applications.
#
# 主な用途:
# - EventBridgeイベントバスのスキーマ自動検出
# - スキーマレジストリへの自動登録とバージョン管理
# - イベント駆動アーキテクチャのスキーマガバナンス
# - OpenAPI/JSONSchemaフォーマットでのスキーマ生成
#
# 主な機能:
# - イベントバス上のイベントから自動的にスキーマを推論
# - スキーマの自動バージョニング（イベント構造変更時）
# - クロスアカウントイベントのスキーマ検出サポート
# - 最大255レベルの深さまでスキーマ検出
# - OpenAPI 3.0およびJSONSchema Draft 4形式でのスキーマエクスポート
#
# 制限事項:
# - 1000 KiBを超えるイベントはスキーマ検出対象外
# - カスタマー管理キーで暗号化されたイベントバスでは非サポート
# - スキーマ検出にはコストが発生する可能性がある
#
# 関連サービス:
# - Amazon EventBridge (イベントバス)
# - EventBridge Schema Registry (スキーマストレージ)
# - AWS Lambda (スキーマベースのコード生成)
# - API Gateway (スキーマベースのバリデーション)
#
# 参考ドキュメント:
# - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schemas-infer.html
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/schemas_discoverer
################################################################################

resource "aws_schemas_discoverer" "example" {
  ################################################################################
  # Required Parameters
  ################################################################################

  # source_arn - (Required) The ARN of the event bus to discover event schemas on
  # イベントスキーマを検出するEventBridgeイベントバスのARN
  #
  # 詳細:
  # - EventBridgeイベントバス（デフォルトまたはカスタム）のARNを指定
  # - このイベントバスを通過するすべてのイベントがスキーマ検出の対象
  # - カスタムイベントバスの場合、明示的なARN指定が必要
  # - クロスアカウントイベントのスキーマも検出可能
  #
  # 形式: arn:aws:events:<region>:<account-id>:event-bus/<event-bus-name>
  # 例: arn:aws:events:us-east-1:123456789012:event-bus/chat-messages
  source_arn = aws_cloudwatch_event_bus.example.arn

  ################################################################################
  # Optional Parameters
  ################################################################################

  # description - (Optional) The description of the discoverer
  # スキーマディスカバラーの説明文
  #
  # 詳細:
  # - 最大256文字まで
  # - ディスカバラーの目的や対象イベントの説明に使用
  # - コンソールやAPIでの識別に役立つ
  #
  # 例: "Auto discover event schemas for chat application"
  description = "Auto discover event schemas"

  # region - (Optional) Region where this resource will be managed
  # このリソースが管理されるAWSリージョン
  #
  # 詳細:
  # - デフォルトではプロバイダー設定のリージョンを使用
  # - 特定のリージョンでディスカバラーを作成する場合に指定
  # - スキーマレジストリはリージョナルサービス
  # - イベントバスと同じリージョンに作成することを推奨
  #
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  # tags - (Optional) A map of tags to assign to the resource
  # リソースに割り当てるタグのマップ
  #
  # 詳細:
  # - プロバイダーのdefault_tags設定ブロックと統合
  # - 同じキーのタグはリソースレベルの定義が優先
  # - コスト配分、リソース管理、アクセス制御に使用
  #
  # 例:
  # tags = {
  #   Environment = "production"
  #   Application = "event-driven-app"
  #   ManagedBy   = "terraform"
  # }
  tags = {
    Name        = "example-schema-discoverer"
    Environment = "production"
  }

  ################################################################################
  # Computed Attributes (Read-only)
  ################################################################################
  # これらの属性は作成後に参照可能です:
  #
  # arn - The Amazon Resource Name (ARN) of the discoverer
  # ディスカバラーのARN
  # 形式: arn:aws:schemas:<region>:<account-id>:discoverer/<discoverer-id>
  # 参照方法: aws_schemas_discoverer.example.arn
  #
  # id - The ID of the discoverer
  # ディスカバラーの一意な識別子
  # 参照方法: aws_schemas_discoverer.example.id
  #
  # tags_all - A map of tags assigned to the resource
  # リソースに割り当てられたすべてのタグ（プロバイダーのdefault_tagsを含む）
  # 参照方法: aws_schemas_discoverer.example.tags_all
  ################################################################################
}

################################################################################
# Additional Configuration Examples
################################################################################

# Example: Schema discoverer for default event bus
# デフォルトイベントバス用のスキーマディスカバラー
resource "aws_schemas_discoverer" "default_bus" {
  source_arn  = "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:event-bus/default"
  description = "Discover schemas from default event bus"

  tags = {
    Name = "default-bus-discoverer"
  }
}

# Example: Schema discoverer with custom event bus
# カスタムイベントバスを使用したスキーマディスカバラー
resource "aws_cloudwatch_event_bus" "custom" {
  name = "custom-application-events"

  tags = {
    Name = "custom-event-bus"
  }
}

resource "aws_schemas_discoverer" "custom_bus" {
  source_arn  = aws_cloudwatch_event_bus.custom.arn
  description = "Discover schemas for custom application events"

  tags = {
    Name        = "custom-bus-discoverer"
    Application = "event-driven-app"
  }
}

# Example: Cross-region schema discoverer
# クロスリージョンのスキーマディスカバラー
resource "aws_schemas_discoverer" "cross_region" {
  source_arn  = aws_cloudwatch_event_bus.example.arn
  description = "Schema discoverer in specific region"
  region      = "us-west-2"

  tags = {
    Name   = "us-west-2-discoverer"
    Region = "us-west-2"
  }
}

################################################################################
# Data Sources for Reference
################################################################################

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

################################################################################
# Outputs
################################################################################

output "schema_discoverer_arn" {
  description = "The ARN of the EventBridge Schema Discoverer"
  value       = aws_schemas_discoverer.example.arn
}

output "schema_discoverer_id" {
  description = "The ID of the EventBridge Schema Discoverer"
  value       = aws_schemas_discoverer.example.id
}

output "schema_discoverer_tags_all" {
  description = "All tags assigned to the Schema Discoverer including default tags"
  value       = aws_schemas_discoverer.example.tags_all
}

################################################################################
# Best Practices & Notes
################################################################################
# 1. スキーマ検出の有効化
#    - スキーマディスカバラーを作成すると、対象イベントバスで自動的にスキーマ検出が開始
#    - 既存のイベントではなく、有効化後のイベントのみが対象
#
# 2. コスト管理
#    - スキーマ検出には料金が発生する可能性がある
#    - 不要なディスカバラーは削除してコストを削減
#    - 特定のイベントソースのみを対象にする場合はイベントルールでフィルタリング
#
# 3. スキーマバージョニング
#    - イベントの構造が変更されると、新しいスキーマバージョンが自動生成
#    - 後方互換性のない変更には注意が必要
#    - スキーマレジストリで履歴を確認可能
#
# 4. セキュリティ
#    - カスタマー管理キー（CMK）で暗号化されたイベントバスではスキーマ検出は非サポート
#    - クロスアカウントスキーマ検出を無効化する場合は、個別に設定が必要
#
# 5. 統合パターン
#    - 検出されたスキーマはEventBridge Schema Registryに保存
#    - スキーマからコードバインディング生成が可能（Go, Java, Python, TypeScript）
#    - API Gatewayと統合してイベントバリデーションを自動化
#
# 6. モニタリング
#    - CloudWatchメトリクスでスキーマ検出の状態を監視
#    - EventBridgeルールで新しいスキーマバージョンの作成を検知
#    - Lambda関数を使用してスキーマ変更の自動処理が可能
#
# 7. 制限事項の確認
#    - イベントサイズ: 最大1000 KiB
#    - スキーマ深度: 最大255レベル
#    - リージョナルサービス（グローバルではない）
#
# 8. 命名規則
#    - ディスカバラーには明確な名前をタグで設定
#    - イベントバスとの関連性が分かる命名を推奨
#    - 環境（dev/staging/prod）を明示
################################################################################
