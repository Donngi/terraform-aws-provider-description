################################################################################
# Terraform AWS Resource Template: aws_dynamodb_table_item
################################################################################
#
# 生成日: 2026-01-22
# Provider Version: 6.28.0
#
# 注意:
# - このテンプレートは生成時点（2026-01-22）の AWS Provider v6.28.0 の仕様に基づいています
# - 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください
# - このリソースは大量のデータ管理には適していません。スケーラビリティを考慮した設計ではありません
# - テーブル内のすべてのデータの定期的なバックアップを実施してください
#
# 公式ドキュメント:
# - Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item
# - AWS DynamoDB PutItem API: https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_PutItem.html
# - AWS DynamoDB バックアップ: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/BackupRestore.html
#
################################################################################

resource "aws_dynamodb_table_item" "example" {
  #==============================================================================
  # 必須パラメータ (Required)
  #==============================================================================

  # table_name - (必須) アイテムを含めるテーブルの名前
  #
  # 既存の DynamoDB テーブルの名前を指定します。
  #
  # 注意: `item` 内に含まれる属性名は、内部的に文字以外がすべて削除されて表現されます。
  # フィルタリング後に同じ名前になる場合、衝突の可能性があります。
  # 例: `your-name-here` と `yournamehere` は重複してエラーを引き起こします。
  #
  # Type: string
  # Reference: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.NamingRulesDataTypes.html
  table_name = "example-table-name"

  # hash_key - (必須) アイテムの検索と識別に使用するハッシュキー
  #
  # DynamoDB テーブルのパーティションキー（ハッシュキー）を指定します。
  # テーブル定義で指定されたハッシュキー属性名と一致する必要があります。
  #
  # Type: string
  # Reference: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.CoreComponents.html#HowItWorks.CoreComponents.PrimaryKey
  hash_key = "exampleHashKey"

  # item - (必須) 属性名/値ペアのマップを表す JSON 表現
  #
  # DynamoDB アイテムの属性を JSON 形式で指定します。
  # プライマリキー属性（hash_key、および range_key が存在する場合）は必須です。
  # その他の属性はオプションで提供できます。
  #
  # JSON 形式は DynamoDB の属性値の型指定を含む必要があります:
  # - S: String
  # - N: Number
  # - B: Binary
  # - BOOL: Boolean
  # - NULL: Null
  # - M: Map
  # - L: List
  # - SS: String Set
  # - NS: Number Set
  # - BS: Binary Set
  #
  # Type: string (JSON形式)
  # Reference: https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_PutItem.html
  # Reference: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.NamingRulesDataTypes.html#HowItWorks.DataTypes
  item = <<ITEM
{
  "exampleHashKey": {"S": "something"},
  "one": {"N": "11111"},
  "two": {"N": "22222"},
  "three": {"N": "33333"},
  "four": {"N": "44444"}
}
ITEM

  #==============================================================================
  # 任意パラメータ (Optional)
  #==============================================================================

  # range_key - (任意) アイテムの検索と識別に使用するレンジキー
  #
  # テーブルにレンジキー（ソートキー）が定義されている場合に必須となります。
  # テーブル定義で指定されたレンジキー属性名と一致する必要があります。
  # レンジキーが定義されていないテーブルの場合、このパラメータは不要です。
  #
  # Type: string
  # Reference: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.CoreComponents.html#HowItWorks.CoreComponents.SecondaryIndexes
  # range_key = "exampleRangeKey"

  # region - (任意) このリソースが管理されるリージョン
  #
  # このリソースが管理される AWS リージョンを指定します。
  # 指定しない場合、プロバイダー設定で設定されたリージョンがデフォルトで使用されます。
  #
  # Type: string
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # region = "us-east-1"

  # id - (任意) Terraform リソース ID
  #
  # Terraform が内部的に使用するリソース識別子です。
  # 通常は自動的に計算されるため、明示的に設定する必要はありません。
  #
  # Type: string
  # Note: Computed属性としても機能するため、通常は指定不要です
  # id = "custom-id"
}

################################################################################
# 使用例: レンジキーを持つテーブルのアイテム
################################################################################
#
# resource "aws_dynamodb_table_item" "with_range_key" {
#   table_name = aws_dynamodb_table.example_with_range.name
#   hash_key   = aws_dynamodb_table.example_with_range.hash_key
#   range_key  = aws_dynamodb_table.example_with_range.range_key
#
#   item = <<ITEM
# {
#   "userId": {"S": "user123"},
#   "timestamp": {"N": "1640995200"},
#   "message": {"S": "Hello, DynamoDB\!"},
#   "tags": {"SS": ["tag1", "tag2", "tag3"]}
# }
# ITEM
# }
#
# resource "aws_dynamodb_table" "example_with_range" {
#   name           = "example-table-with-range"
#   billing_mode   = "PAY_PER_REQUEST"
#   hash_key       = "userId"
#   range_key      = "timestamp"
#
#   attribute {
#     name = "userId"
#     type = "S"
#   }
#
#   attribute {
#     name = "timestamp"
#     type = "N"
#   }
# }
#
################################################################################

################################################################################
# 属性型リファレンス
################################################################################
#
# DynamoDB の JSON 形式で使用可能な属性型:
#
# - S (String): 文字列型
#   例: {"name": {"S": "John Doe"}}
#
# - N (Number): 数値型（整数または小数）
#   例: {"age": {"N": "30"}}, {"price": {"N": "19.99"}}
#
# - B (Binary): バイナリ型（Base64エンコード）
#   例: {"data": {"B": "dGhpcyB0ZXh0IGlzIGJhc2U2NC1lbmNvZGVk"}}
#
# - BOOL (Boolean): 真偽値型
#   例: {"isActive": {"BOOL": true}}
#
# - NULL (Null): Null値
#   例: {"middleName": {"NULL": true}}
#
# - M (Map): マップ型（ネストされたオブジェクト）
#   例: {"address": {"M": {"street": {"S": "123 Main St"}, "city": {"S": "Seattle"}}}}
#
# - L (List): リスト型（配列）
#   例: {"colors": {"L": [{"S": "red"}, {"S": "blue"}, {"S": "green"}]}}
#
# - SS (String Set): 文字列セット型
#   例: {"tags": {"SS": ["tag1", "tag2", "tag3"]}}
#
# - NS (Number Set): 数値セット型
#   例: {"scores": {"NS": ["100", "200", "300"]}}
#
# - BS (Binary Set): バイナリセット型
#   例: {"dataSet": {"BS": ["U3Vubnk=", "UmFpbnk="]}}
#
# Reference: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.NamingRulesDataTypes.html#HowItWorks.DataTypes
#
################################################################################
