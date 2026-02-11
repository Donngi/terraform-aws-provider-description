#---------------------------------------------------------------
# AWS EventBridge Schemas Registry Policy
#---------------------------------------------------------------
#
# Amazon EventBridge Schema Registryにリソースベースポリシーを
# アタッチするリソースです。リソースベースポリシーにより、他のAWSアカウントや
# AWS Organizations組織に対してスキーマレジストリAPIへのアクセスを許可できます。
#
# AWS公式ドキュメント:
#   - EventBridge Schemasのリソースベースポリシー: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-resource-based-schemas.html
#   - EventBridge Schema Registry: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema-registry.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/schemas_registry_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_schemas_registry_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # registry_name (Required)
  # 設定内容: ポリシーをアタッチするEventBridge Schema Registryの名前を指定します。
  # 設定可能な値: 既存のスキーマレジストリ名（文字列）
  # 注意: aws_schemas_registryリソースで作成したレジストリ名を指定してください。
  registry_name = "example"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: EventBridge Schema Registryに適用するリソースベースポリシーを指定します。
  # 設定可能な値: IAMポリシードキュメントのJSON文字列
  # 関連機能: EventBridge Schemasリソースベースポリシー
  #   リソースベースポリシーにより、他のAWSアカウントに対してスキーマレジストリAPIの
  #   アクセスを許可できます。サポートされるAPIには DescribeRegistry, UpdateRegistry,
  #   DeleteRegistry, ListSchemas, SearchSchemas, DescribeSchema, CreateSchema,
  #   DeleteSchema, UpdateSchema, ListSchemaVersions, DeleteSchemaVersion,
  #   DescribeCodeBinding, GetCodeBindingSource, PutCodeBinding があります。
  #   - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-resource-based-schemas.html
  # 注意: aws_iam_policy_documentデータソースを使用してポリシーを生成することを推奨します。
  policy = data.aws_iam_policy_document.example.json

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子（registry_nameと同じ値）
#---------------------------------------------------------------
