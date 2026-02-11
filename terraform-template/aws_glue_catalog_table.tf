#---------------------------------------------------------------
# AWS Glue Catalog Table
#---------------------------------------------------------------
#
# AWS Glue Data Catalogのテーブルメタデータを定義します。
# Glue Data Catalogは、S3やその他のデータソースに対する
# メタデータリポジトリとして機能し、スキーマ情報、パーティション情報、
# データの場所などを管理します。
#
# AWS公式ドキュメント:
#   - AWS Glue Data Catalog: https://docs.aws.amazon.com/glue/latest/dg/components-key-concepts.html
#   - Table API Reference: https://docs.aws.amazon.com/glue/latest/webapi/API_Table.html
#   - Managing the Data Catalog: https://docs.aws.amazon.com/glue/latest/dg/manage-catalog.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_catalog_table" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # テーブル名（Hive互換性のため完全に小文字である必要があります）
  name = "example_table"

  # テーブルメタデータが格納されるデータベース名
  # （Hive互換性のため完全に小文字である必要があります）
  database_name = "example_database"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # Glue CatalogとデータベースのID
  # 省略時はAWSアカウントID + データベース名がデフォルトとして使用されます
  catalog_id = null

  # テーブルの説明文
  description = null

  # テーブルの所有者
  owner = null

  # テーブルに関連付けられるプロパティ（キー・バリューペア）
  # 例: EXTERNAL = "TRUE", "parquet.compression" = "SNAPPY"
  parameters = null

  # このリソースが管理されるリージョン
  # 省略時はプロバイダー設定のリージョンがデフォルトとして使用されます
  region = null

  # テーブルの保持期間
  retention = null

  # テーブルのタイプ（EXTERNAL_TABLE, VIRTUAL_VIEW等）
  # Athenaの一部DDLクエリ（ALTER TABLE, SHOW CREATE TABLE等）では
  # この引数が必須となる場合があります
  table_type = null

  # テーブルがビューの場合、ビューの展開されたテキスト
  # それ以外の場合はnull
  view_expanded_text = null

  # テーブルがビューの場合、ビューの元のテキスト
  # それ以外の場合はnull
  view_original_text = null

  #---------------------------------------------------------------
  # Open Table Format Input Block
  #---------------------------------------------------------------
  # オープンテーブルフォーマット（Iceberg等）の設定
  # 最大1つのブロックを指定可能

  # open_table_format_input {
  #   # Icebergテーブル設定（必須）
  #   iceberg_input {
  #     # 必須のメタデータ操作（CREATEのみ設定可能）
  #     metadata_operation = "CREATE"
  #
  #     # Icebergテーブルのバージョン（デフォルト: 2）
  #     version = "2"
  #   }
  # }

  #---------------------------------------------------------------
  # Partition Index Blocks
  #---------------------------------------------------------------
  # パーティションインデックスの設定
  # 最大3つのインデックスを指定可能

  # partition_index {
  #   # パーティションインデックスの名前
  #   index_name = "example_index"
  #
  #   # パーティションインデックスのキー
  #   keys = ["year", "month"]
  # }

  #---------------------------------------------------------------
  # Partition Keys Blocks
  #---------------------------------------------------------------
  # テーブルがパーティション分割される列の設定
  # プリミティブ型のみがパーティションキーとしてサポートされます

  # partition_keys {
  #   # パーティションキーの名前
  #   name = "year"
  #
  #   # 自由形式のコメント
  #   comment = "Partition year"
  #
  #   # キー・バリューペアのマップ
  #   parameters = null
  #
  #   # パーティションキーのデータ型
  #   type = "string"
  # }

  #---------------------------------------------------------------
  # Storage Descriptor Block
  #---------------------------------------------------------------
  # テーブルの物理ストレージに関する情報
  # 詳細はGlue Developer Guideを参照:
  # https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-catalog-tables.html#aws-glue-api-catalog-tables-StorageDescriptor

  # storage_descriptor {
  #   # Deltaテーブルが配置されているパスを指す場所のリスト
  #   additional_locations = null
  #
  #   # テーブル内のreducer grouping列、clustering列、bucketing列のリスト
  #   bucket_columns = null
  #
  #   # テーブル内のデータが圧縮されているかどうか
  #   compressed = null
  #
  #   # 入力フォーマット: SequenceFileInputFormat（バイナリ）、
  #   # TextInputFormat、またはカスタムフォーマット
  #   input_format = null
  #
  #   # テーブルの物理的な場所
  #   # デフォルトでは、ウェアハウスの場所、その後ウェアハウス内の
  #   # データベースの場所、その後テーブル名の形式になります
  #   location = null
  #
  #   # テーブルにディメンション列が含まれる場合は指定する必要があります
  #   number_of_buckets = null
  #
  #   # 出力フォーマット: SequenceFileOutputFormat（バイナリ）、
  #   # IgnoreKeyTextOutputFormat、またはカスタムフォーマット
  #   output_format = null
  #
  #   # ユーザー提供のキー・バリュー形式のプロパティ
  #   parameters = null
  #
  #   # テーブルデータがサブディレクトリに格納されているかどうか
  #   stored_as_sub_directories = null
  #
  #   #---------------------------------------------------------------
  #   # Columns Blocks
  #   #---------------------------------------------------------------
  #   # テーブル内の列の設定
  #
  #   # columns {
  #   #   # 列の名前
  #   #   name = "id"
  #   #
  #   #   # 自由形式のコメント
  #   #   comment = "Unique identifier"
  #   #
  #   #   # 列に関連付けられたプロパティを定義するキー・バリューペア
  #   #   parameters = null
  #   #
  #   #   # 列内のデータのデータ型
  #   #   type = "bigint"
  #   # }
  #
  #   #---------------------------------------------------------------
  #   # Schema Reference Block
  #   #---------------------------------------------------------------
  #   # AWS Glue Schema Registryに格納されたスキーマを参照するオブジェクト
  #   # テーブル作成時に、スキーマの空のリストを渡す代わりに
  #   # スキーマ参照を使用できます
  #
  #   # schema_reference {
  #   #   # スキーマのバージョン番号
  #   #   schema_version_number = 1
  #   #
  #   #   # スキーマに割り当てられた一意のID
  #   #   # schema_idまたはこれのいずれかを指定する必要があります
  #   #   schema_version_id = null
  #   #
  #   #   # スキーマIDの設定ブロック
  #   #   # schema_version_idまたはこれのいずれかを指定する必要があります
  #   #   schema_id {
  #   #     # スキーマを含むスキーマレジストリの名前
  #   #     # schema_nameが指定されている場合に提供する必要があり、
  #   #     # schema_arnと競合します
  #   #     registry_name = null
  #   #
  #   #     # スキーマのARN
  #   #     # schema_arnまたはschema_nameのいずれかを指定する必要があります
  #   #     schema_arn = null
  #   #
  #   #     # スキーマの名前
  #   #     # schema_arnまたはschema_nameのいずれかを指定する必要があります
  #   #     schema_name = null
  #   #   }
  #   # }
  #
  #   #---------------------------------------------------------------
  #   # SerDe Info Block
  #   #---------------------------------------------------------------
  #   # シリアライゼーションおよびデシリアライゼーション（SerDe）情報の設定
  #
  #   # ser_de_info {
  #   #   # SerDeの名前
  #   #   name = null
  #   #
  #   #   # SerDeの初期化パラメータのマップ（キー・バリュー形式）
  #   #   parameters = null
  #   #
  #   #   # 通常、SerDeを実装するクラス
  #   #   # 例: org.apache.hadoop.hive.serde2.columnar.ColumnarSerDe
  #   #   serialization_library = null
  #   # }
  #
  #   #---------------------------------------------------------------
  #   # Skewed Info Block
  #   #---------------------------------------------------------------
  #   # 列に非常に頻繁に出現する値（スキューされた値）に関する情報の設定
  #
  #   # skewed_info {
  #   #   # スキューされた値を含む列の名前のリスト
  #   #   skewed_column_names = null
  #   #
  #   #   # 非常に頻繁に出現するためスキューされていると見なされる値のリスト
  #   #   skewed_column_value_location_maps = null
  #   #
  #   #   # スキューされた値をそれらを含む列にマッピングするマップ
  #   #   skewed_column_values = null
  #   # }
  #
  #   #---------------------------------------------------------------
  #   # Sort Columns Blocks
  #   #---------------------------------------------------------------
  #   # テーブル内の各バケットのソート順の設定
  #
  #   # sort_columns {
  #   #   # 列の名前
  #   #   column = "created_at"
  #   #
  #   #   # 列が昇順（1）または降順（0）でソートされているかどうか
  #   #   sort_order = 1
  #   # }
  # }

  #---------------------------------------------------------------
  # Target Table Block
  #---------------------------------------------------------------
  # リソースリンクのターゲットテーブルの設定
  # 最大1つのブロックを指定可能

  # target_table {
  #   # テーブルが格納されているData CatalogのID
  #   catalog_id = "123456789012"
  #
  #   # ターゲットテーブルを含むカタログデータベースの名前
  #   database_name = "target_database"
  #
  #   # ターゲットテーブルの名前
  #   name = "target_table"
  #
  #   # ターゲットテーブルのリージョン
  #   region = null
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - arn: GlueテーブルのARN
# - id: Catalog ID、データベース名、テーブル名の組み合わせ
#
# これらの属性は読み取り専用で、リソース作成後に参照可能です。
#---------------------------------------------------------------
