#---------------------------------------------------------------
# AWS Lake Formation Permissions
#---------------------------------------------------------------
#
# AWS Lake Formationのデータカタログおよび基盤となるデータストレージ（Amazon S3など）
# へのアクセス権限をプリンシパルに付与するリソース。
# データカタログ、データベース、テーブル、LF-Tag、LF-Tagポリシーなどの
# Lake Formationリソースに対する権限を管理します。
#
# 重要な注意事項:
# - Lake Formation権限はデフォルトでは有効になりません
# - このリソースを使用する前に、既存リソースのセキュリティ設定と
#   新規リソースのデフォルトセキュリティ設定を変更する必要があります
# - プリンシパルはLake Formation管理者やTerraformを実行するエンティティで
#   あるべきではありません（管理者は暗黙的な権限を持つため）
#
# AWS公式ドキュメント:
#   - Security and Access Control to Metadata and Data:
#     https://docs.aws.amazon.com/lake-formation/latest/dg/security-data-access.html
#   - Granting Database Permissions:
#     https://docs.aws.amazon.com/lake-formation/latest/dg/granting-database-permissions.html
#   - Lake Formation Permissions Reference:
#     https://docs.aws.amazon.com/lake-formation/latest/dg/lf-permissions-reference.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_permissions
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lakeformation_permissions" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # 権限を付与されるプリンシパル
  # サポートされるプリンシパル:
  # - IAM_ALLOWED_PRINCIPALS（デフォルト動作用）
  # - IAMロール、ユーザー、グループ
  # - フェデレーテッドユーザー
  # - SAMLグループとユーザー
  # - QuickSightグループ
  # - OU（組織単位）と組織
  # - クロスアカウント権限用のAWSアカウントID
  # 注意: Lake Formation管理者やTerraform実行エンティティは避けるべきです
  principal = "arn:aws:iam::123456789012:role/example-role"

  # 付与する権限のリスト
  # 有効な値:
  # - ALL: すべての権限
  # - ALTER: リソースのメタデータを変更
  # - ASSOCIATE: LF-Tagをリソースに関連付け
  # - CREATE_DATABASE: データカタログにデータベースを作成
  # - CREATE_TABLE: データベースにテーブルを作成
  # - DATA_LOCATION_ACCESS: データロケーションへのアクセス
  # - DELETE: データの削除
  # - DESCRIBE: リソースのメタデータを表示
  # - DROP: リソースを削除
  # - INSERT: データの挿入
  # - SELECT: データの読み取り
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/lf-permissions-reference.html
  permissions = ["SELECT", "DESCRIBE"]

  #---------------------------------------------------------------
  # オプションパラメータ - リソース指定（いずれか1つを使用）
  #---------------------------------------------------------------

  # データカタログ全体への権限を付与するかどうか
  # デフォルト: false
  # catalog_resource = false

  # データセルフィルタリソースの設定
  # 特定のデータセルフィルタに対する権限を付与
  # data_cells_filter {
  #   # 必須: データベース名
  #   database_name = "example_database"
  #
  #   # 必須: データセルフィルタの名前
  #   name = "example_filter"
  #
  #   # 必須: データカタログID
  #   table_catalog_id = "123456789012"
  #
  #   # 必須: テーブル名
  #   table_name = "example_table"
  # }

  # データロケーションリソースの設定
  # S3などのデータロケーションに対する権限を付与
  # data_location {
  #   # 必須: データロケーションを一意に識別するARN
  #   arn = "arn:aws:s3:::example-bucket/example-path"
  #
  #   # オプション: Lake Formationにロケーションが登録されているデータカタログID
  #   # デフォルト: 呼び出し元のアカウントID
  #   catalog_id = "123456789012"
  # }

  # データベースリソースの設定
  # 特定のデータベースに対する権限を付与
  # database {
  #   # 必須: データベースリソースの名前（データカタログ内で一意）
  #   name = "example_database"
  #
  #   # オプション: データカタログのID
  #   # デフォルト: 呼び出し元のアカウントID
  #   catalog_id = "123456789012"
  # }

  # LF-Tagリソースの設定
  # 特定のLF-Tagに対する権限を付与
  # lf_tag {
  #   # 必須: タグのキー名
  #   key = "Environment"
  #
  #   # 必須: 属性が取りうる値のリスト
  #   values = ["Development", "Production"]
  #
  #   # オプション: データカタログのID
  #   # デフォルト: 呼び出し元のアカウントID
  #   catalog_id = "123456789012"
  # }

  # LF-Tagポリシーリソースの設定
  # タグベースのアクセス制御（TBAC）を使用した権限付与
  # lf_tag_policy {
  #   # 必須: タグポリシーが適用されるリソースタイプ
  #   # 有効な値: "DATABASE" または "TABLE"
  #   resource_type = "DATABASE"
  #
  #   # 必須: リソースのタグポリシーに適用されるタグ条件のリスト
  #   # 最低1つのexpressionブロックが必要
  #   expression {
  #     # 必須: LF-Tagのキー名
  #     key = "Team"
  #
  #     # 必須: LF-Tagの可能な値のリスト
  #     values = ["Sales", "Marketing"]
  #   }
  #
  #   expression {
  #     key    = "Environment"
  #     values = ["Development", "Production"]
  #   }
  #
  #   # オプション: データカタログのID
  #   # デフォルト: 呼び出し元のアカウントID
  #   catalog_id = "123456789012"
  # }

  # テーブルリソースの設定
  # 特定のテーブルまたはワイルドカードテーブルに対する権限を付与
  # table {
  #   # 必須: テーブルのデータベース名（データカタログ内で一意）
  #   database_name = "example_database"
  #
  #   # nameまたはwildcardのいずれか1つが必須
  #   # テーブル名（特定のテーブルを指定する場合）
  #   name = "example_table"
  #
  #   # nameまたはwildcardのいずれか1つが必須
  #   # データベース配下のすべてのテーブルを表すワイルドカードを使用するか
  #   # デフォルト: false
  #   # wildcard = true
  #
  #   # オプション: データカタログのID
  #   # デフォルト: 呼び出し元のアカウントID
  #   catalog_id = "123456789012"
  # }

  # カラム付きテーブルリソースの設定
  # テーブル内の特定のカラムに対する権限を付与
  # table_with_columns {
  #   # 必須: カラムリソースを持つテーブルのデータベース名
  #   database_name = "example_database"
  #
  #   # 必須: テーブルリソースの名前
  #   name = "example_table"
  #
  #   # column_namesまたはwildcardのいずれか1つが必須
  #   # テーブルのカラム名のセット（特定カラムを指定する場合）
  #   column_names = ["column1", "column2", "column3"]
  #
  #   # column_namesまたはwildcardのいずれか1つが必須
  #   # カラムワイルドカードを使用するか
  #   # excluded_column_namesを使用する場合、wildcardをtrueに設定する必要があります
  #   # wildcard = true
  #
  #   # オプション: 除外するカラム名のセット
  #   # このオプションを使用する場合、wildcardをtrueに設定する必要があります
  #   # excluded_column_names = ["sensitive_column1", "sensitive_column2"]
  #
  #   # オプション: データカタログのID
  #   # デフォルト: 呼び出し元のアカウントID
  #   catalog_id = "123456789012"
  # }

  #---------------------------------------------------------------
  # オプションパラメータ - 追加設定
  #---------------------------------------------------------------

  # データカタログの識別子
  # データカタログは永続的なメタデータストアで、データベース定義、
  # テーブル定義、Lake Formation環境を管理するための制御情報を含みます
  # デフォルト: アカウントID
  # catalog_id = "123456789012"

  # プリンシパルが他のプリンシパルに渡すことができる権限のサブセット
  # permissionsで指定した権限の一部を、他のユーザーに付与する権限として設定
  # permissions_with_grant_option = ["SELECT"]

  # このリソースが管理されるリージョン
  # デフォルト: プロバイダー設定のリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Computed Attributes (読み取り専用)
  #---------------------------------------------------------------
  # これらの属性はTerraformによって自動的に設定されます。
  # 設定ファイルで指定する必要はありません。
  #
  # - id: リソースの一意識別子（computed）
  #---------------------------------------------------------------
}

#---------------------------------------------------------------
# 使用例: S3データロケーションへの権限付与
#---------------------------------------------------------------
# resource "aws_lakeformation_permissions" "s3_location" {
#   principal   = aws_iam_role.workflow_role.arn
#   permissions = ["DATA_LOCATION_ACCESS"]
#
#   data_location {
#     arn = aws_lakeformation_resource.example.arn
#   }
# }

#---------------------------------------------------------------
# 使用例: Glueデータベースへの権限付与
#---------------------------------------------------------------
# resource "aws_lakeformation_permissions" "database" {
#   principal   = aws_iam_role.workflow_role.arn
#   permissions = ["CREATE_TABLE", "ALTER", "DROP"]
#
#   database {
#     name       = aws_glue_catalog_database.example.name
#     catalog_id = "110376042874"
#   }
# }

#---------------------------------------------------------------
# 使用例: タグベースアクセス制御（TBAC）を使用した権限付与
#---------------------------------------------------------------
# resource "aws_lakeformation_permissions" "tbac" {
#   principal   = aws_iam_role.sales_role.arn
#   permissions = ["CREATE_TABLE", "ALTER", "DROP"]
#
#   lf_tag_policy {
#     resource_type = "DATABASE"
#
#     expression {
#       key    = "Team"
#       values = ["Sales"]
#     }
#
#     expression {
#       key    = "Environment"
#       values = ["Dev", "Production"]
#     }
#   }
# }
