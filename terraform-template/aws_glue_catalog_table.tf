#---------------------------------------------------------------
# AWS Glue Data Catalog Table
#---------------------------------------------------------------
#
# AWS Glue データカタログにテーブルを作成するリソースです。
# データカタログのテーブルはデータストア内のデータのメタデータ定義を格納し、
# Athena、Redshift Spectrum、EMR などのサービスからクエリ実行する際に使用されます。
# Parquet、ORC、CSV などのフォーマット、および Apache Iceberg などの
# オープンテーブルフォーマットをサポートします。
#
# AWS公式ドキュメント:
#   - AWS Glue Data Catalog概要: https://docs.aws.amazon.com/glue/latest/dg/components-key-concepts.html
#   - Glue Table API リファレンス: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-catalog-tables.html
#   - Data Catalog使用開始: https://docs.aws.amazon.com/glue/latest/dg/start-data-catalog.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_catalog_table" "example" {

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: テーブルの名前を指定します。
  # 設定可能な値: 文字列。Hiveとの互換性のため、すべて小文字にする必要があります。
  name = "my_catalog_table"

  # database_name (Required)
  # 設定内容: テーブルメタデータが存在するメタデータデータベースの名前を指定します。
  # 設定可能な値: 文字列。Hiveとの互換性のため、すべて小文字にする必要があります。
  database_name = "my_catalog_database"

  #-------------------------------------------------------------
  # カタログ・識別設定
  #-------------------------------------------------------------

  # catalog_id (Optional)
  # 設定内容: テーブルを作成するGlueカタログおよびデータベースのIDを指定します。
  # 設定可能な値: AWSアカウントID（12桁の数字）
  # 省略時: AWSアカウントIDにデータベース名を追加したものがデフォルトとなります。
  catalog_id = null

  # description (Optional)
  # 設定内容: テーブルの説明を指定します。
  # 設定可能な値: 任意の文字列
  description = null

  # owner (Optional)
  # 設定内容: テーブルの所有者を指定します。
  # 設定可能な値: 任意の文字列
  owner = null

  #-------------------------------------------------------------
  # テーブル種別設定
  #-------------------------------------------------------------

  # table_type (Optional)
  # 設定内容: テーブルの種別を指定します。
  # 設定可能な値:
  #   - "EXTERNAL_TABLE": 外部テーブル（S3等の外部ストレージを参照）
  #   - "VIRTUAL_VIEW": ビューとして定義されたテーブル
  #   - 空文字列: 種別なし（一部のAthena DDLクエリでエラーとなる場合があります）
  # 省略時: 空文字列。ALTER TABLE や SHOW CREATE TABLE 等のAthena DDLクエリが失敗する場合があります。
  table_type = "EXTERNAL_TABLE"

  # view_original_text (Optional)
  # 設定内容: テーブルがビューの場合、ビューの元のテキストを指定します。
  # 設定可能な値: ビュー定義のSQL文字列
  # 省略時: null（ビューでない場合はnullを設定）
  view_original_text = null

  # view_expanded_text (Optional)
  # 設定内容: テーブルがビューの場合、ビューの展開されたテキストを指定します。
  # 設定可能な値: 展開されたビュー定義のSQL文字列
  # 省略時: null（ビューでない場合はnullを設定）
  view_expanded_text = null

  #-------------------------------------------------------------
  # 保持期間設定
  #-------------------------------------------------------------

  # retention (Optional)
  # 設定内容: テーブルの保持時間を指定します。
  # 設定可能な値: 正の整数（秒単位）
  # 省略時: 0（保持期間なし）
  retention = 0

  #-------------------------------------------------------------
  # テーブルパラメータ設定
  #-------------------------------------------------------------

  # parameters (Optional)
  # 設定内容: テーブルに関連付けるプロパティをキーと値のペアで指定します。
  # 設定可能な値: 文字列のマップ
  # 注意: EXTERNAL_TABLEの場合、"EXTERNAL" = "TRUE" を設定することが一般的です。
  #       Athenaでparquetフォーマットを使用する場合は "parquet.compression" 等を設定します。
  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ストレージ記述子設定
  #-------------------------------------------------------------
  # テーブルの物理ストレージに関する情報を設定します。
  # フォーマット、場所、列定義、SerDe情報などを含みます。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-catalog-tables.html#aws-glue-api-catalog-tables-StorageDescriptor

  storage_descriptor {

    #-----------------------------------------------------------
    # ストレージ場所設定
    #-----------------------------------------------------------

    # location (Optional)
    # 設定内容: テーブルの物理的な場所を指定します。
    # 設定可能な値: S3 URIなどのパス（例: "s3://my-bucket/my-table/"）
    # 省略時: ウェアハウスの場所、データベースの場所、テーブル名の順に連結されたパスが使用されます。
    location = "s3://my-bucket/my-table/"

    # additional_locations (Optional)
    # 設定内容: Deltaテーブルが存在するパスを指定する場所のリストです。
    # 設定可能な値: S3 URIの文字列リスト
    additional_locations = []

    #-----------------------------------------------------------
    # フォーマット設定
    #-----------------------------------------------------------

    # input_format (Optional)
    # 設定内容: 入力フォーマットのクラスを指定します。
    # 設定可能な値:
    #   - "org.apache.hadoop.mapred.TextInputFormat": テキスト形式
    #   - "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat": Parquet形式
    #   - "org.apache.hadoop.hive.ql.io.orc.OrcInputFormat": ORC形式
    #   - "org.apache.hadoop.mapred.SequenceFileInputFormat": バイナリシーケンスファイル形式
    #   - カスタムフォーマットクラス名
    input_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"

    # output_format (Optional)
    # 設定内容: 出力フォーマットのクラスを指定します。
    # 設定可能な値:
    #   - "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat": テキスト形式
    #   - "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat": Parquet形式
    #   - "org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat": ORC形式
    #   - "org.apache.hadoop.mapred.SequenceFileOutputFormat": バイナリシーケンスファイル形式
    #   - カスタムフォーマットクラス名
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    #-----------------------------------------------------------
    # 圧縮・バケット設定
    #-----------------------------------------------------------

    # compressed (Optional)
    # 設定内容: テーブルのデータが圧縮されているかどうかを指定します。
    # 設定可能な値:
    #   - true: データが圧縮されている
    #   - false: データが圧縮されていない
    # 省略時: false
    compressed = false

    # number_of_buckets (Optional)
    # 設定内容: バケット数を指定します。
    # 設定可能な値: 正の整数
    # 注意: テーブルに次元列が含まれる場合は必須です。bucket_columnsと合わせて設定します。
    number_of_buckets = 0

    # bucket_columns (Optional)
    # 設定内容: テーブル内のリデューサーグループ列、クラスタリング列、バケット列のリストを指定します。
    # 設定可能な値: 列名の文字列リスト
    bucket_columns = []

    # stored_as_sub_directories (Optional)
    # 設定内容: テーブルデータがサブディレクトリに格納されているかどうかを指定します。
    # 設定可能な値:
    #   - true: サブディレクトリに格納されている
    #   - false: サブディレクトリに格納されていない
    # 省略時: false
    stored_as_sub_directories = false

    # parameters (Optional)
    # 設定内容: ユーザー提供のプロパティをキーと値のペアで指定します。
    # 設定可能な値: 文字列のマップ
    parameters = {}

    #-----------------------------------------------------------
    # 列定義設定
    #-----------------------------------------------------------
    # テーブルの列定義を設定します。複数のcolumnsブロックを指定できます。

    columns {
      # name (Required)
      # 設定内容: 列の名前を指定します。
      # 設定可能な値: 任意の文字列
      name = "my_string_column"

      # type (Optional)
      # 設定内容: 列のデータ型を指定します。
      # 設定可能な値: "string", "int", "bigint", "double", "float", "boolean",
      #              "date", "timestamp", "binary", "array<型>", "map<キー型,値型>",
      #              "struct<フィールド名:型,...>" 等のHiveデータ型
      type = "string"

      # comment (Optional)
      # 設定内容: 列に対する自由記述コメントを指定します。
      # 設定可能な値: 任意の文字列
      comment = "文字列型のサンプル列"

      # parameters (Optional)
      # 設定内容: 列に関連付けるプロパティをキーと値のペアで指定します。
      # 設定可能な値: 文字列のマップ
      parameters = {}
    }

    columns {
      name    = "my_bigint_column"
      type    = "bigint"
      comment = ""
    }

    #-----------------------------------------------------------
    # SerDe情報設定
    #-----------------------------------------------------------
    # シリアライズ/デシリアライズ（SerDe）情報を設定します。

    ser_de_info {
      # name (Optional)
      # 設定内容: SerDeの名前を指定します。
      # 設定可能な値: 任意の文字列
      name = "my-serde"

      # serialization_library (Optional)
      # 設定内容: SerDeを実装するクラスを指定します。
      # 設定可能な値:
      #   - "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe": Parquet形式
      #   - "org.apache.hadoop.hive.ql.io.orc.OrcSerde": ORC形式
      #   - "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe": テキスト（CSV等）
      #   - "org.apache.hadoop.hive.serde2.OpenCSVSerde": CSV形式
      #   - "org.openx.data.jsonserde.JsonSerDe": JSON形式
      #   - "org.apache.hadoop.hive.serde2.columnar.ColumnarSerDe": カラム形式
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      # parameters (Optional)
      # 設定内容: SerDeの初期化パラメータをキーと値のペアで指定します。
      # 設定可能な値: 文字列のマップ
      parameters = {
        "serialization.format" = "1"
      }
    }

    #-----------------------------------------------------------
    # ソート列設定
    #-----------------------------------------------------------
    # バケット内の各ソート順序を設定します。複数のsort_columnsブロックを指定できます。

    sort_columns {
      # column (Required)
      # 設定内容: ソート対象の列名を指定します。
      # 設定可能な値: 列名の文字列
      column = "my_string_column"

      # sort_order (Required)
      # 設定内容: 列が昇順または降順でソートされるかを指定します。
      # 設定可能な値:
      #   - 1: 昇順
      #   - 0: 降順
      sort_order = 1
    }

    #-----------------------------------------------------------
    # スキーマレジストリ参照設定
    #-----------------------------------------------------------
    # AWS Glue スキーマレジストリに格納されたスキーマを参照します。
    # テーブル作成時に列の空リストを渡し、スキーマ参照を使用する場合に設定します。

    schema_reference {
      # schema_version_id (Optional)
      # 設定内容: スキーマのバージョンに割り当てられた一意のIDを指定します。
      # 設定可能な値: スキーマバージョンのUUID文字列
      # 注意: schema_idまたはschema_version_idのいずれかを指定する必要があります。
      schema_version_id = null

      # schema_version_number (Required)
      # 設定内容: スキーマのバージョン番号を指定します。
      # 設定可能な値: 正の整数
      schema_version_number = 1

      # schema_id (Optional)
      # 設定内容: スキーマのアイデンティティフィールドを含む設定ブロックです。
      # 注意: schema_idまたはschema_version_idのいずれかを指定する必要があります。

      schema_id {
        # schema_arn (Optional)
        # 設定内容: スキーマのARNを指定します。
        # 設定可能な値: スキーマの有効なARN
        # 注意: schema_arnまたはschema_nameのいずれかを指定する必要があります。schema_nameと競合します。
        schema_arn = null

        # schema_name (Optional)
        # 設定内容: スキーマの名前を指定します。
        # 設定可能な値: スキーマ名の文字列
        # 注意: schema_arnまたはschema_nameのいずれかを指定する必要があります。
        schema_name = null

        # registry_name (Optional)
        # 設定内容: スキーマが含まれるスキーマレジストリの名前を指定します。
        # 設定可能な値: スキーマレジストリ名の文字列
        # 注意: schema_nameを指定する場合に必須です。schema_arnと競合します。
        registry_name = null
      }
    }

    #-----------------------------------------------------------
    # スキュー情報設定
    #-----------------------------------------------------------
    # 列に非常に頻繁に出現する値（スキュー値）に関する情報を設定します。

    skewed_info {
      # skewed_column_names (Optional)
      # 設定内容: スキュー値を含む列の名前のリストを指定します。
      # 設定可能な値: 列名の文字列リスト
      skewed_column_names = []

      # skewed_column_values (Optional)
      # 設定内容: 頻繁に出現してスキューとみなされる値のリストを指定します。
      # 設定可能な値: 値の文字列リスト
      skewed_column_values = []

      # skewed_column_value_location_maps (Optional)
      # 設定内容: スキュー値とそれを含む列のマッピングを指定します。
      # 設定可能な値: 文字列のマップ
      skewed_column_value_location_maps = {}
    }
  }

  #-------------------------------------------------------------
  # パーティションキー設定
  #-------------------------------------------------------------
  # テーブルをパーティション分割する列を設定します。
  # プリミティブ型のみがパーティションキーとしてサポートされます。
  # 複数のpartition_keysブロックを指定できます。

  partition_keys {
    # name (Required)
    # 設定内容: パーティションキーの名前を指定します。
    # 設定可能な値: 任意の文字列
    name = "year"

    # type (Optional)
    # 設定内容: パーティションキーのデータ型を指定します。
    # 設定可能な値: "string", "int", "bigint", "date" 等のプリミティブHiveデータ型
    type = "string"

    # comment (Optional)
    # 設定内容: パーティションキーに対する自由記述コメントを指定します。
    # 設定可能な値: 任意の文字列
    comment = "年のパーティションキー"

    # parameters (Optional)
    # 設定内容: パーティションキーに関連付けるプロパティをキーと値のペアで指定します。
    # 設定可能な値: 文字列のマップ
    parameters = {}
  }

  partition_keys {
    name    = "month"
    type    = "string"
    comment = "月のパーティションキー"
  }

  #-------------------------------------------------------------
  # パーティションインデックス設定
  #-------------------------------------------------------------
  # パーティションインデックスを設定します。最大3つまで設定できます。

  partition_index {
    # index_name (Required)
    # 設定内容: パーティションインデックスの名前を指定します。
    # 設定可能な値: 任意の文字列
    index_name = "year_month_index"

    # keys (Required)
    # 設定内容: パーティションインデックスのキー列名のリストを指定します。
    # 設定可能な値: パーティションキーとして定義された列名のリスト
    keys = ["year", "month"]
  }

  #-------------------------------------------------------------
  # オープンテーブルフォーマット設定
  #-------------------------------------------------------------
  # Apache Iceberg などのオープンテーブルフォーマットの設定を行います。
  # このブロックを使用する場合は、storage_descriptor は通常省略されます。

  open_table_format_input {

    # iceberg_input (Required)
    # 設定内容: Icebergテーブルの設定ブロックです。
    # 注意: open_table_format_input を使用する場合は必須です。

    iceberg_input {
      # metadata_operation (Required)
      # 設定内容: メタデータ操作の種別を指定します。
      # 設定可能な値:
      #   - "CREATE": テーブル作成時のみ設定可能
      metadata_operation = "CREATE"

      # version (Optional)
      # 設定内容: Icebergテーブルのバージョンを指定します。
      # 設定可能な値: Icebergテーブルバージョンの文字列
      # 省略時: "2"（Iceberg v2）
      version = "2"

      #---------------------------------------------------------
      # Icebergテーブル入力設定
      #---------------------------------------------------------
      # Icebergテーブルのスキーマ、パーティション、ソート順、プロパティ等を設定します。

      iceberg_table_input {
        # location (Required)
        # 設定内容: Icebergテーブルデータが格納されるS3の場所を指定します。
        # 設定可能な値: S3 URI（最大2056文字）
        location = "s3://my-bucket/iceberg-table/"

        # properties (Optional)
        # 設定内容: テーブルのプロパティおよび設定をキーと値のペアで指定します。
        # 設定可能な値: 文字列のマップ
        properties = {}

        #-------------------------------------------------------
        # Icebergスキーマ設定
        #-------------------------------------------------------
        # Icebergテーブルの構造、フィールド型、メタデータを定義します。

        schema {
          # schema_id (Optional)
          # 設定内容: Icebergテーブルのスキーマ進化履歴におけるスキーマバージョンの一意識別子を指定します。
          # 設定可能な値: 0以上の整数
          schema_id = 0

          # type (Optional)
          # 設定内容: スキーマ構造のルート型を指定します。
          # 設定可能な値: "struct"
          type = "struct"

          # identifier_field_ids (Optional)
          # 設定内容: テーブル内のレコードを一意に識別するフィールドIDのリストを指定します。
          # 設定可能な値: フィールドIDの数値リスト
          # 注意: 行レベル操作や重複排除に使用されます。
          identifier_field_ids = []

          # fields (Required)
          # 設定内容: テーブルスキーマを構成するフィールド定義のリストです。
          # 1つ以上のfieldsブロックが必要です。

          fields {
            # id (Required)
            # 設定内容: Icebergテーブルスキーマ内のフィールドの一意識別子を指定します。
            # 設定可能な値: 正の整数
            # 注意: スキーマ進化やフィールド追跡に使用されます。
            id = 1

            # name (Required)
            # 設定内容: フィールドの名前を指定します。
            # 設定可能な値: 1〜1024文字の文字列
            name = "transaction_id"

            # required (Required)
            # 設定内容: フィールドが必須（非null）か任意（null許容）かを指定します。
            # 設定可能な値:
            #   - true: 必須（non-nullable）
            #   - false: 任意（nullable）
            required = true

            # type (Required)
            # 設定内容: フィールドのデータ型をJSON文字列で指定します。
            # 設定可能な値: "string", "long", "int", "float", "double",
            #              "boolean", "date", "timestamp", "decimal(10,2)" 等
            type = "\"string\""

            # doc (Optional)
            # 設定内容: フィールドの目的や使用方法に関する説明テキストを指定します。
            # 設定可能な値: 0〜255文字の文字列
            doc = null

            # initial_default (Optional)
            # 設定内容: スキーマにフィールドが追加される前に書き込まれたレコードのデフォルト値をJSON形式で指定します。
            # 設定可能な値: JSON文字列
            initial_default = null

            # write_default (Optional)
            # 設定内容: スキーマにフィールドが追加された後、値が指定されない場合のデフォルト値をJSON形式で指定します。
            # 設定可能な値: JSON文字列
            write_default = null
          }

          fields {
            id       = 2
            name     = "transaction_date"
            required = true
            type     = "\"date\""
          }
        }

        #-------------------------------------------------------
        # Icebergパーティション仕様設定
        #-------------------------------------------------------
        # Icebergテーブルデータのパーティショニング方法を定義します。

        partition_spec {
          # spec_id (Optional)
          # 設定内容: Icebergテーブルのメタデータ履歴におけるパーティション仕様の一意識別子を指定します。
          # 設定可能な値: 0以上の整数
          spec_id = 0

          # fields (Required)
          # 設定内容: テーブルデータのパーティション方法を定義するフィールドのリストです。
          # 1つ以上のfieldsブロックが必要です。

          fields {
            # name (Required)
            # 設定内容: パーティションフィールドの名前を指定します。
            # 設定可能な値: 1〜1024文字の文字列
            name = "by_year"

            # source_id (Required)
            # 設定内容: パーティションフィールドの元となるテーブルスキーマのソースフィールドIDを指定します。
            # 設定可能な値: スキーマのfieldsで定義したフィールドのid値
            source_id = 2

            # transform (Required)
            # 設定内容: ソースフィールドに適用する変換関数を指定します。
            # 設定可能な値: "identity", "bucket", "truncate", "year", "month", "day", "hour"
            transform = "year"

            # field_id (Optional)
            # 設定内容: Icebergテーブルのパーティション仕様内でのフィールドの一意識別子を指定します。
            # 設定可能な値: 正の整数
            field_id = null
          }
        }

        #-------------------------------------------------------
        # Icebergソート順設定
        #-------------------------------------------------------
        # パーティション内のデータの並び順を定義し、クエリパフォーマンスを最適化します。

        sort_order {
          # order_id (Required)
          # 設定内容: Icebergテーブルのメタデータ内でのソート順仕様の一意識別子を指定します。
          # 設定可能な値: 正の整数
          order_id = 1

          # fields (Required)
          # 設定内容: ソート順序を定義するフィールドのリストです。
          # 1つ以上のfieldsブロックが必要です。

          fields {
            # source_id (Required)
            # 設定内容: ソート対象のテーブルスキーマのソースフィールドIDを指定します。
            # 設定可能な値: スキーマのfieldsで定義したフィールドのid値
            source_id = 1

            # direction (Required)
            # 設定内容: ソート方向を指定します。
            # 設定可能な値: "asc"（昇順）, "desc"（降順）
            direction = "asc"

            # null_order (Required)
            # 設定内容: null値の並び順を指定します。
            # 設定可能な値: "nulls-first"（先頭）, "nulls-last"（末尾）
            null_order = "nulls-last"

            # transform (Required)
            # 設定内容: ソート前にソースフィールドに適用する変換関数を指定します。
            # 設定可能な値: "identity", "bucket", "truncate" 等
            transform = "none"
          }
        }
      }
    }
  }

  #-------------------------------------------------------------
  # リンクターゲットテーブル設定
  #-------------------------------------------------------------
  # リソースリンキングのターゲットテーブルを設定します。

  target_table {
    # catalog_id (Required)
    # 設定内容: テーブルが存在するデータカタログのIDを指定します。
    # 設定可能な値: AWSアカウントID（12桁の数字）
    catalog_id = "123456789012"

    # database_name (Required)
    # 設定内容: ターゲットテーブルが含まれるカタログデータベースの名前を指定します。
    # 設定可能な値: データベース名の文字列
    database_name = "target_database"

    # name (Required)
    # 設定内容: ターゲットテーブルの名前を指定します。
    # 設定可能な値: テーブル名の文字列
    name = "target_table"

    # region (Optional)
    # 設定内容: ターゲットテーブルが存在するリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
    region = null
  }

  #-------------------------------------------------------------
  # ビュー定義設定
  #-------------------------------------------------------------
  # ビューの定義情報を設定します。ビューの方言、クエリ、
  # マテリアライズドビューの設定などを含みます。

  view_definition {
    # definer (Optional)
    # 設定内容: SQLにおけるビューの定義者を指定します。
    # 設定可能な値: 任意の文字列
    definer = null

    # is_protected (Optional)
    # 設定内容: クエリ計画時にユーザー指定の操作をビューの論理プランにプッシュしないようにエンジンに指示するかどうかを指定します。
    # 設定可能な値:
    #   - true: 操作のプッシュを抑止（エンジンが保証するかは実装依存）
    #   - false: 通常の最適化を許可
    is_protected = null

    # last_refresh_type (Optional)
    # 設定内容: マテリアライズドビューの最後のリフレッシュの種類を指定します。
    # 設定可能な値: "Full"（完全リフレッシュ）, "Incremental"（差分リフレッシュ）
    last_refresh_type = null

    # refresh_seconds (Optional)
    # 設定内容: マテリアライズドビューの自動リフレッシュ間隔を秒単位で指定します。
    # 設定可能な値: 正の整数
    refresh_seconds = null

    # sub_objects (Optional)
    # 設定内容: マテリアライズドビューを構成するベーステーブルのARNのリストを指定します。
    # 設定可能な値: テーブルARNの文字列リスト
    sub_objects = []

    # sub_object_version_ids (Optional)
    # 設定内容: マテリアライズドビューが参照するApache Icebergテーブルバージョンのリストを指定します。
    # 設定可能な値: バージョンIDの数値リスト
    sub_object_version_ids = []

    # view_version_id (Optional)
    # 設定内容: ビューのバージョンを識別するIDを指定します。マテリアライズドビューの場合はIcebergテーブルのスナップショットIDです。
    # 設定可能な値: 整数
    view_version_id = null

    # view_version_token (Optional)
    # 設定内容: Apache IcebergテーブルのバージョンIDを指定します。
    # 設定可能な値: 文字列
    view_version_token = null

    #-----------------------------------------------------------
    # ビュー表現設定
    #-----------------------------------------------------------
    # ビューの方言ごとの表現を定義します。複数のrepresentationsブロックを指定できます。

    representations {
      # dialect (Optional)
      # 設定内容: 特定の表現のエンジンタイプを指定します。
      # 設定可能な値: "REDSHIFT", "ATHENA", "SPARK"
      dialect = "ATHENA"

      # dialect_version (Optional)
      # 設定内容: 特定の表現のエンジンバージョンを指定します。
      # 設定可能な値: バージョン文字列
      dialect_version = null

      # validation_connection (Optional)
      # 設定内容: ビューの特定の表現を検証するために使用される接続名を指定します。
      # 設定可能な値: Glue接続名の文字列
      validation_connection = null

      # view_original_text (Optional)
      # 設定内容: ビューを記述する元のSQLクエリを指定します。
      # 設定可能な値: SQL文字列
      view_original_text = null

      # view_expanded_text (Optional)
      # 設定内容: 展開されたリソースARNを含むビューのSQLクエリを指定します。
      # 設定可能な値: SQL文字列
      view_expanded_text = null
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: GlueテーブルのAmazon Resource Name (ARN)
#
# - id: カタログID、データベース名、テーブル名を連結した識別子
#       形式: {catalog_id}:{database_name}:{name}
#
# partition_index ブロックの読み取り専用属性:
#
# - partition_index.index_status: パーティションインデックスのステータス
#---------------------------------------------------------------
