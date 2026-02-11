# ============================================================================
# Terraform Template: aws_dynamodb_tag
# ============================================================================
# 生成日: 2026-01-22
# Provider Version: hashicorp/aws 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-22)の情報に基づいています
# - 最新の仕様は公式ドキュメントを確認してください
# - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/dynamodb_tag
# ============================================================================

# ============================================================================
# リソース概要
# ============================================================================
# aws_dynamodb_tag は個別のDynamoDBリソースタグを管理します。
# このリソースは、DynamoDBリソースがTerraform外部で作成される場合
# (例: 他のリージョンのテーブルレプリカ)にのみ使用してください。
#
# 重要な注意点:
# - 親リソースを管理するTerraformリソースと併用しないでください
#   例: 同じリージョンの同じDynamoDBテーブルに対して aws_dynamodb_table と
#   aws_dynamodb_tag の両方を使用すると、perpetual difference が発生します
# - このタグリソースは provider の ignore_tags 設定を使用しません
#
# AWS公式ドキュメント:
# - タグ付け操作: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tagging.Operations.html
# - TagResource API: https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_TagResource.html
# ============================================================================

resource "aws_dynamodb_tag" "example" {
  # ========================================
  # 必須パラメータ
  # ========================================

  # resource_arn - (必須) タグを付けるDynamoDBリソースのAmazon Resource Name (ARN)
  #
  # 説明:
  # - タグを付与する対象のDynamoDBリソース(テーブル、グローバルテーブルなど)のARNを指定
  # - 別リージョンのレプリカテーブルに対してタグを付与する際は、ARNのリージョン部分を
  #   適切に置換する必要があります
  #
  # 例:
  # - DynamoDBテーブル: arn:aws:dynamodb:us-east-1:123456789012:table/MyTable
  # - レプリカテーブル用の置換: replace(aws_dynamodb_table.example.arn, data.aws_region.current.region, data.aws_region.replica.name)
  #
  # タイプ: string
  # 参考: https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html
  resource_arn = "arn:aws:dynamodb:us-east-1:123456789012:table/example-table"

  # key - (必須) タグの名前(キー)
  #
  # 説明:
  # - タグのキーを指定します
  # - タグキーは大文字小文字を区別します
  # - AWS予約のタグキー(aws:で始まるもの)は使用できません
  #
  # 制約:
  # - 最大長: 128文字
  # - 使用可能文字: Unicode文字、数字、空白、および以下の記号: _ . : / = + - @
  #
  # タイプ: string
  # 参考: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tagging.Operations.html
  key = "Environment"

  # value - (必須) タグの値
  #
  # 説明:
  # - タグの値を指定します
  # - タグ値は大文字小文字を区別します
  # - 空の文字列も有効な値です
  #
  # 制約:
  # - 最大長: 256文字
  # - 使用可能文字: Unicode文字、数字、空白、および以下の記号: _ . : / = + - @
  #
  # タイプ: string
  # 参考: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tagging.Operations.html
  value = "production"

  # ========================================
  # オプションパラメータ
  # ========================================

  # id - (オプション) リソースID
  #
  # 説明:
  # - 通常は自動的に生成されるため、明示的な指定は不要です
  # - 形式: DynamoDBリソース識別子とキーをカンマ(,)で区切った文字列
  # - computed属性としても機能し、リソース作成後に参照可能です
  #
  # タイプ: string
  # デフォルト: 自動生成
  # id = null  # 通常は指定不要

  # region - (オプション) このリソースを管理するリージョン
  #
  # 説明:
  # - このリソースが管理されるAWSリージョンを指定します
  # - 未指定の場合、プロバイダー設定のリージョンがデフォルトとして使用されます
  # - 他リージョンのレプリカテーブルにタグを付ける際は、適切なプロバイダーエイリアスを使用し、
  #   このパラメータで対象リージョンを指定できます
  #
  # 使用例:
  # - マルチリージョン構成で特定リージョンのリソースを管理する場合
  # - プロバイダーエイリアスと組み合わせて使用
  #
  # タイプ: string
  # デフォルト: プロバイダー設定のリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"  # 通常はプロバイダー設定で指定するため不要
}

# ============================================================================
# 出力例 (Computed Attributes)
# ============================================================================
# 以下の属性はリソース作成後に参照可能です:
#
# - id: DynamoDBリソース識別子とキーをカンマで区切った文字列
#   例: aws_dynamodb_tag.example.id
#
# 使用例:
# output "dynamodb_tag_id" {
#   description = "DynamoDB tag identifier"
#   value       = aws_dynamodb_tag.example.id
# }
# ============================================================================

# ============================================================================
# マルチリージョン構成の使用例
# ============================================================================
# 別リージョンのDynamoDBレプリカテーブルにタグを付ける場合:
#
# provider "aws" {
#   region = "us-west-2"
# }
#
# provider "aws" {
#   alias  = "replica"
#   region = "us-east-1"
# }
#
# data "aws_region" "current" {}
#
# data "aws_region" "replica" {
#   provider = aws.replica
# }
#
# resource "aws_dynamodb_table" "example" {
#   name         = "example-table"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "id"
#
#   attribute {
#     name = "id"
#     type = "S"
#   }
#
#   replica {
#     region_name = data.aws_region.replica.name
#   }
# }
#
# resource "aws_dynamodb_tag" "replica_tag" {
#   provider = aws.replica
#
#   resource_arn = replace(
#     aws_dynamodb_table.example.arn,
#     data.aws_region.current.name,
#     data.aws_region.replica.name
#   )
#   key   = "Environment"
#   value = "production"
# }
# ============================================================================

# ============================================================================
# 制限事項と注意点
# ============================================================================
# 1. API呼び出し制限:
#    - TagResource操作は1秒あたり最大5回まで(アカウント単位)
#
# 2. 結果整合性:
#    - TagResource実行直後のListTagsOfResource呼び出しでは、
#      以前のタグセットまたは空のタグセットが返される可能性があります
#
# 3. タグの制約:
#    - 1リソースあたりのタグ数上限: 50個
#    - タグキー長: 最大128文字
#    - タグ値長: 最大256文字
#
# 4. 使用上の注意:
#    - 同じDynamoDBリソースに対して aws_dynamodb_table の tags と
#      aws_dynamodb_tag を併用しないでください
#    - このリソースは provider の ignore_tags 設定を使用しません
#
# 参考:
# - https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_TagResource.html
# - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tagging.Operations.html
# ============================================================================
