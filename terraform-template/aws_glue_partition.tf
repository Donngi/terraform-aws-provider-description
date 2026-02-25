#---------------------------------------------------------------
# AWS Glue Partition
#---------------------------------------------------------------
#
# AWS Glue Data Catalog のパーティションをプロビジョニングするリソースです。
# パーティションはテーブルのサブセットであり、指定したキー値によってデータを
# 論理的に分割します。パーティションを利用することで、クエリのスキャン範囲を
# 絞り込み、パフォーマンスとコストを最適化できます。
#
# AWS公式ドキュメント:
#   - AWS Glue Data Catalog パーティション管理: https://docs.aws.amazon.com/glue/latest/dg/populate-dg-manual.html
#   - AWS Glue Data Catalog テーブルAPIリファレンス: https://docs.aws.amazon.com/glue/latest/webapi/API_GetUnfilteredPartitionMetadata.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_partition
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_partition" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # database_name (Required)
  # 設定内容: パーティションが属するメタデータデータベースの名前を指定します。
  # 設定可能な値: 文字列。Hive互換性のため、すべて小文字にする必要があります。
  database_name = "example_database"

  # table_name (Required)
  # 設定内容: パーティションが属するテーブルの名前を指定します。
  # 設定可能な値: 有効なGlue Data Catalogテーブル名
  table_name = "example_table"

  # partition_values (Required)
  # 設定内容: パーティションを定義する値のリストを指定します。
  # 設定可能な値: 文字列のリスト。テーブルのパーティションキーに対応する値を順番に指定します。
  # 注意: 値の順序はテーブルのパーティションキーの定義順と一致させる必要があります。
  partition_values = ["2024", "01", "15"]

  #-------------------------------------------------------------
  # カタログ設定
  #-------------------------------------------------------------

  # catalog_id (Optional)
  # 設定内容: テーブルメタデータを作成するGlue CatalogおよびデータベースのIDを指定します。
  # 設定可能な値: AWSアカウントID（12桁の数字）
  # 省略時: AWSアカウントIDにデータベース名を組み合わせた値が使用されます。
  catalog_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # パラメーター設定
  #-------------------------------------------------------------

  # parameters (Optional)
  # 設定内容: このパーティションに関連するプロパティをキーと値のペアで指定します。
  # 設定可能な値: 文字列のキーバリューマップ
  # 省略時: パラメーターなし
  parameters = {
    classification = "parquet"
  }

  #-------------------------------------------------------------
  # ストレージ記述子設定
  #-------------------------------------------------------------

  # storage_descriptor (Optional)
  # 設定内容: このパーティションの物理的なストレージに関する情報を格納する設定ブロックです。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-catalog-tables.html#aws-glue-api-catalog-tables-StorageDescriptor
  storage_descriptor {

    # location (Optional)
    # 設定内容: テーブルの物理的なロケーションを指定します。
    # 設定可能な値: S3 URIなどのパス文字列（例: s3://my-bucket/prefix/year=2024/month=01/day=15/）
    # 省略時: ウェアハウスロケーション、データベースロケーション、テーブル名を組み合わせた値が使用されます。
    location = "s3://example-bucket/example-database/example-table/year=2024/month=01/day=15/"

    # input_format (Optional)
    # 設定内容: データの入力フォーマットを指定します。
    # 設定可能な値:
    #   - "org.apache.hadoop.mapred.TextInputFormat": テキスト形式
    #   - "org.apache.hadoop.mapred.SequenceFileInputFormat": シーケンスファイル（バイナリ）形式
    #   - "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat": Parquet形式
    #   - "com.amazon.emr.compress.AmazonS3SnappyInputFormat": Snappy圧縮形式
    #   - カスタムフォーマットクラス名
    input_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"

    # output_format (Optional)
    # 設定内容: データの出力フォーマットを指定します。
    # 設定可能な値:
    #   - "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat": テキスト出力形式
    #   - "org.apache.hadoop.mapred.SequenceFileOutputFormat": シーケンスファイル（バイナリ）出力形式
    #   - "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat": Parquet出力形式
    #   - カスタムフォーマットクラス名
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    # compressed (Optional)
    # 設定内容: テーブルのデータが圧縮されているかどうかを指定します。
    # 設定可能な値:
    #   - true: データが圧縮されている
    #   - false: データが圧縮されていない
    # 省略時: false
    compressed = false

    # number_of_buckets (Optional)
    # 設定内容: バケット分割数を指定します。
    # 設定可能な値: 整数値
    # 注意: テーブルにディメンション列が含まれる場合は指定が必要です。
    # 省略時: 0
    number_of_buckets = 0

    # bucket_columns (Optional)
    # 設定内容: テーブルのリデューサーグルーピング列、クラスタリング列、バケット列のリストを指定します。
    # 設定可能な値: 列名の文字列リスト
    # 省略時: バケット列なし
    bucket_columns = []

    # additional_locations (Optional)
    # 設定内容: Deltaテーブルが格納されているパスを指定する追加ロケーションのリストを指定します。
    # 設定可能な値: S3 URIなどのパス文字列のリスト
    # 省略時: 追加ロケーションなし
    additional_locations = []

    # stored_as_sub_directories (Optional)
    # 設定内容: テーブルデータがサブディレクトリに格納されているかどうかを指定します。
    # 設定可能な値:
    #   - true: サブディレクトリに格納されている
    #   - false: サブディレクトリに格納されていない
    # 省略時: false
    stored_as_sub_directories = false

    # parameters (Optional)
    # 設定内容: ストレージ記述子のユーザー定義プロパティをキーと値のペアで指定します。
    # 設定可能な値: 文字列のキーバリューマップ
    # 省略時: パラメーターなし
    parameters = {}

    #-----------------------------------------------------------
    # カラム設定
    #-----------------------------------------------------------

    # columns (Optional)
    # 設定内容: テーブルのカラム定義のリストを指定する設定ブロックです。
    columns {

      # name (Required)
      # 設定内容: カラムの名前を指定します。
      # 設定可能な値: 有効なカラム名の文字列
      name = "id"

      # type (Optional)
      # 設定内容: カラムのデータ型を指定します。
      # 設定可能な値: "string", "int", "bigint", "double", "float", "boolean", "binary",
      #               "timestamp", "date", "array<...>", "map<...>", "struct<...>" 等のHiveデータ型
      # 省略時: 型なし（空文字列）
      type = "string"

      # comment (Optional)
      # 設定内容: カラムに対する自由形式のテキストコメントを指定します。
      # 設定可能な値: 任意の文字列
      # 省略時: コメントなし
      comment = "レコードの一意識別子"
    }

    columns {
      name    = "value"
      type    = "double"
      comment = "測定値"
    }

    #-----------------------------------------------------------
    # SerDe情報設定
    #-----------------------------------------------------------

    # ser_de_info (Optional)
    # 設定内容: シリアライズ/デシリアライズ（SerDe）情報の設定ブロックです。
    # 注意: このブロックは最大1つまで指定できます。
    ser_de_info {

      # name (Optional)
      # 設定内容: SerDeの名前を指定します。
      # 設定可能な値: 任意の文字列
      # 省略時: 名前なし
      name = "example-serde"

      # serialization_library (Optional)
      # 設定内容: SerDeを実装するクラス名を指定します。
      # 設定可能な値:
      #   - "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe": テキスト形式用
      #   - "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe": Parquet形式用
      #   - "org.openx.data.jsonserde.JsonSerDe": JSON形式用
      #   - "org.apache.hadoop.hive.serde2.columnar.ColumnarSerDe": カラムナー形式用
      # 省略時: SerDeライブラリなし
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      # parameters (Optional)
      # 設定内容: SerDeの初期化パラメーターをキーと値のペアで指定します。
      # 設定可能な値: 文字列のキーバリューマップ
      # 省略時: パラメーターなし
      parameters = {
        "serialization.format" = "1"
      }
    }

    #-----------------------------------------------------------
    # ソート列設定
    #-----------------------------------------------------------

    # sort_columns (Optional)
    # 設定内容: テーブルの各バケット内のソート順を指定する設定ブロックです。
    sort_columns {

      # column (Required)
      # 設定内容: ソート対象のカラム名を指定します。
      # 設定可能な値: テーブルに存在するカラム名の文字列
      column = "id"

      # sort_order (Required)
      # 設定内容: カラムのソート順を指定します。
      # 設定可能な値:
      #   - 1: 昇順
      #   - 0: 降順
      sort_order = 1
    }

    #-----------------------------------------------------------
    # スキュー情報設定
    #-----------------------------------------------------------

    # skewed_info (Optional)
    # 設定内容: カラムに頻繁に出現する値（スキュー値）に関する情報の設定ブロックです。
    # 注意: このブロックは最大1つまで指定できます。
    skewed_info {

      # skewed_column_names (Optional)
      # 設定内容: スキュー値を含むカラム名のリストを指定します。
      # 設定可能な値: カラム名の文字列リスト
      # 省略時: スキューカラムなし
      skewed_column_names = ["id"]

      # skewed_column_values (Optional)
      # 設定内容: スキューとみなされる値のリストを指定します。
      # 設定可能な値: 値の文字列リスト
      # 省略時: スキュー値なし
      skewed_column_values = ["1", "2"]

      # skewed_column_value_location_maps (Optional)
      # 設定内容: スキュー値からその値が格納されているカラムへのマッピングを指定します。
      # 設定可能な値: 文字列のキーバリューマップ
      # 省略時: マッピングなし
      skewed_column_value_location_maps = {
        "1" = "s3://example-bucket/skewed/1/"
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: パーティションのID（catalog_id:database_name:table_name:partition_valuesで構成）
# - creation_time: パーティションが作成された日時
# - last_accessed_time: パーティションに最後にアクセスされた日時
# - last_analyzed_time: このパーティションに対して列統計が最後に計算された日時
#---------------------------------------------------------------
