#---------------------------------------------------------------
# Amazon EventBridge Schema Registry
#---------------------------------------------------------------
#
# Amazon EventBridge Schema Registryは、イベントスキーマを管理・整理するための
# カスタムレジストリリソースをプロビジョニングします。
# スキーマレジストリは、スキーマを論理的なグループにまとめるコンテナとして機能し、
# カスタムスキーマやアップロードされたスキーマを整理できます。
#
# AWS公式ドキュメント:
#   - Schema registries in Amazon EventBridge: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema-registry.html
#   - Amazon EventBridge Schema Registry API Reference: https://docs.aws.amazon.com/eventbridge/latest/schema-reference/index.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/schemas_registry
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_schemas_registry" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # レジストリ名
  # - カスタムイベントスキーマレジストリの名前
  # - 最大64文字（小文字、大文字、0-9、.、-、_のみ使用可能）
  # - 例: "my_custom_registry", "app-events-registry"
  name = "my_own_registry"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # レジストリの説明
  # - レジストリの目的や内容を説明するテキスト
  # - 最大256文字
  # - 例: "アプリケーション固有のイベントスキーマを管理するレジストリ"
  description = "A custom schema registry"

  # リージョン
  # - このリソースが管理されるAWSリージョン
  # - 省略時はプロバイダー設定のリージョンを使用
  # - リージョン間でレジストリを移行する場合に使用
  # - 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # タグ
  #---------------------------------------------------------------

  # リソースタグ
  # - レジストリに割り当てるキーと値のペア
  # - リソースの分類、管理、コスト配分に使用
  # - プロバイダーのdefault_tagsと統合され、tags_allとして管理される
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all
  # - tags と provider の default_tags を統合した全タグ
  # - computed属性のため、通常は設定不要
  # - Terraformが自動的に管理
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference（参照専用の属性）
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能です（設定不可）:
#
# - arn
#   説明: レジストリのAmazon Resource Name（ARN）
#   型: string
#   例: output "registry_arn" { value = aws_schemas_registry.example.arn }
#
# - id
#   説明: レジストリの識別子（通常はname属性と同じ値）
#   型: string
#   例: output "registry_id" { value = aws_schemas_registry.example.id }
#
#---------------------------------------------------------------
