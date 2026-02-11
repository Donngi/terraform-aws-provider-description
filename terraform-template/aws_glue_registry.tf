#---------------------------------------------------------------
# AWS Glue Registry
#---------------------------------------------------------------
#
# AWS Glue Schema Registryのレジストリリソースをプロビジョニングします。
# レジストリはスキーマのコレクションを管理するための論理コンテナで、
# データストリームのスキーマバージョン管理と互換性チェックを提供します。
#
# AWS公式ドキュメント:
#   - How the schema registry works: https://docs.aws.amazon.com/glue/latest/dg/schema-registry-works.html
#   - Schema registry API: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-schema-registry-api.html
#   - Integrations: https://docs.aws.amazon.com/glue/latest/dg/schema-registry-integrations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_registry
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_registry" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # レジストリの名前
  # - AWS Glue Schema Registryにおける一意の識別子
  # - スキーマのコレクションを管理するための論理コンテナ
  # - 命名規則: 英数字、ハイフン、アンダースコアを使用可能
  # - 例: "default-registry", "production-schemas", "analytics-registry"
  registry_name = "example"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # レジストリの説明文
  # - このレジストリの目的や用途を記述
  # - 管理者やチームメンバーが理解しやすいように詳細を記載
  # - 例: "Production data streaming schemas for MSK topics"
  # - 例: "Development environment schema registry for testing"
  description = "Example schema registry for data streaming"

  # リージョン指定
  # - このリソースが管理されるAWSリージョン
  # - 省略時はプロバイダー設定のリージョンが使用される
  # - クロスリージョンでのスキーマ管理が必要な場合に指定
  # - 例: "us-east-1", "ap-northeast-1"
  # - 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # タグ
  # - リソース管理のためのキーバリューペア
  # - コスト配分、環境識別、アクセス制御などに使用
  # - provider default_tagsと併用可能
  # - 例: { Environment = "production", Team = "data-engineering", CostCenter = "analytics" }
  tags = {
    Name        = "example-glue-registry"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
# 以下の属性は、リソース作成後にTerraformによって自動的に設定されます。
# これらは参照専用で、直接設定することはできません。
#
# - arn: Amazon Resource Name (ARN) of the Glue Registry
#   例: "arn:aws:glue:us-east-1:123456789012:registry/example"
#   他のリソースでこのレジストリを参照する際に使用
#   aws_glue_schema等のリソースでregistry_arnとして指定可能
#
# - id: Amazon Resource Name (ARN) of the Glue Registry
#   arnと同じ値が設定される
#   Terraformのリソース識別子として使用
#
# - tags_all: 全てのタグのマップ（providerのdefault_tagsを含む）
#   明示的に設定したtagsとprovider default_tagsがマージされた結果
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: レジストリを参照するスキーマの作成
#---------------------------------------------------------------
# resource "aws_glue_schema" "example" {
#   schema_name       = "example-schema"
#   registry_arn      = aws_glue_registry.example.arn
#   data_format       = "AVRO"
#   compatibility     = "BACKWARD"
#   schema_definition = jsonencode({
#     type      = "record"
#     name      = "ExampleRecord"
#     namespace = "com.example"
#     fields = [
#       {
#         name = "id"
#         type = "string"
#       },
#       {
#         name = "timestamp"
#         type = "long"
#       }
#     ]
#   })
# }

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# - aws_glue_schema: レジストリ内にスキーマを定義
# - aws_glue_schema_version: スキーマの新しいバージョンを登録
# - aws_iam_policy: Schema Registry APIへのアクセス権限を管理
#
#---------------------------------------------------------------
# 統合可能なAWSサービス
#---------------------------------------------------------------
# - Amazon MSK / Apache Kafka
# - Amazon Kinesis Data Streams
# - Amazon Managed Service for Apache Flink
# - AWS Lambda
# - AWS Glue Data Catalog
# - AWS Glue Streaming ETL
#
#---------------------------------------------------------------
