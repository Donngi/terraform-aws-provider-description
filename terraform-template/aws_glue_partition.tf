# ============================================================
# AWS Glue Partition
# ============================================================
# AWS Glue パーティションリソース
# テーブルデータのスライスを表し、パーティション化されたデータセットの
# 効率的なクエリとデータ管理を可能にします。
#
# AWS Provider Version: 6.28.0
# Resource: aws_glue_partition
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_partition
# ============================================================

resource "aws_glue_partition" "example" {
  # ============================================================
  # 必須パラメータ
  # ============================================================

  # データベース名
  # Type: string (Required)
  # Hive互換性のため、すべて小文字である必要があります
  # テーブルメタデータが存在するメタデータデータベースの名前
  database_name = "example_database"

  # テーブル名
  # Type: string (Required)
  # パーティションが属するテーブルの名前
  table_name = "example_table"

  # パーティション値
  # Type: list(string) (Required)
  # パーティションを定義する値のリスト
  # テーブルのパーティションキーの順序と一致する必要があります
  # 例: テーブルのパーティションキーが [year, month, day] の場合
  #     partition_values = ["2024", "01", "15"]
  partition_values = ["2024", "01", "15"]

  # ============================================================
  # オプションパラメータ
  # ============================================================

  # カタログID
  # Type: string (Optional)
  # Glue カタログとデータベースの ID
  # 省略した場合、AWS アカウント ID + データベース名がデフォルトになります
  # catalog_id = "123456789012"

  # パラメータ
  # Type: map(string) (Optional)
  # このテーブルに関連するプロパティをキーと値のペアとして定義
  # パーティション固有のメタデータや設定を格納するために使用
  parameters = {
    "classification" = "parquet"
    "compressionType" = "snappy"
    "typeOfData" = "file"
  }

  # ============================================================
  # ストレージディスクリプタ (Storage Descriptor)
  # ============================================================
  # パーティションの物理ストレージに関する情報を含むオブジェクト
  # データの場所、フォーマット、スキーマなどを定義します

  storage_descriptor {
    # データの物理的な場所
    # Type: string (Optional)
    # デフォルトでは、ウェアハウスの場所、データベースの場所、
    # テーブル名の形式をとります
    # パーティション固有のS3パスを指定することで、
    # データを論理的に分離して保存できます
    location = "s3://example-bucket/example-database/example-table/year=2024/month=01/day=15/"

    # 入力フォーマット
    # Type: string (Optional)
    # データの読み取りに使用される入力フォーマット
    # 一般的な値:
    # - org.apache.hadoop.mapred.TextInputFormat (テキスト)
    # - org.apache.hadoop.mapred.SequenceFileInputFormat (バイナリ)
    # - org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat (Parquet)
    # - org.apache.hadoop.hive.ql.io.orc.OrcInputFormat (ORC)
    input_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"

    # 出力フォーマット
    # Type: string (Optional)
    # データの書き込みに使用される出力フォーマット
    # 一般的な値:
    # - org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat (テキスト)
    # - org.apache.hadoop.mapred.SequenceFileOutputFormat (バイナリ)
    # - org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat (Parquet)
    # - org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat (ORC)
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    # 圧縮フラグ
    # Type: bool (Optional)
    # テーブル内のデータが圧縮されている場合は true、
    # そうでない場合は false
    compressed = true

    # バケット数
    # Type: number (Optional)
    # テーブルにディメンション列が含まれている場合は指定する必要があります
    # データをバケット化する際のバケット数
    # number_of_buckets = 10

    # バケットカラム
    # Type: list(string) (Optional)
    # リデューサーグループ化列、クラスタリング列、
    # バケット化列のリスト
    # データを効率的に分散させるために使用
    # bucket_columns = ["customer_id"]

    # ソートカラム
    # Type: list(object) (Optional)
    # テーブル内の各バケットのソート順序を指定する
    # Order オブジェクトのリスト
    # sort_columns {
    #   column     = "timestamp"
    #   sort_order = 1  # 1 = 昇順, 0 = 降順
    # }

    # サブディレクトリに格納
    # Type: bool (Optional)
    # テーブルデータがサブディレクトリに格納されている場合は true、
    # そうでない場合は false
    stored_as_sub_directories = false

    # パラメータ
    # Type: map(string) (Optional)
    # ユーザー提供のプロパティをキーと値の形式で定義
    # ストレージ固有の設定やメタデータを格納
    parameters = {
      "projection.enabled" = "false"
    }

    # 追加の場所
    # Type: list(string) (Optional)
    # Delta テーブルが配置されているパスを指す場所のリスト
    # Delta Lake などの形式で使用
    # additional_locations = [
    #   "s3://example-bucket/delta-table-location-1/",
    #   "s3://example-bucket/delta-table-location-2/"
    # ]

    # ============================================================
    # カラム定義
    # ============================================================
    # テーブル内のカラムのリスト

    columns {
      # カラム名
      # Type: string (Required)
      name = "id"

      # データ型
      # Type: string (Optional)
      # カラム内のデータのデータ型
      # 一般的な型: string, int, bigint, double, boolean,
      # date, timestamp, decimal, array, map, struct
      type = "bigint"

      # コメント
      # Type: string (Optional)
      # カラムの説明を記述する自由形式のテキスト
      comment = "Unique identifier"
    }

    columns {
      name    = "name"
      type    = "string"
      comment = "Customer name"
    }

    columns {
      name    = "email"
      type    = "string"
      comment = "Customer email address"
    }

    columns {
      name    = "created_at"
      type    = "timestamp"
      comment = "Record creation timestamp"
    }

    columns {
      name    = "amount"
      type    = "decimal(10,2)"
      comment = "Transaction amount"
    }

    # ============================================================
    # SerDe 情報 (Serialization/Deserialization)
    # ============================================================
    # データのシリアライゼーション・デシリアライゼーション情報

    ser_de_info {
      # SerDe 名
      # Type: string (Optional)
      # シリアライゼーション/デシリアライゼーションの名前
      name = "ParquetHiveSerDe"

      # シリアライゼーションライブラリ
      # Type: string (Optional)
      # 通常、SerDe を実装するクラス
      # 一般的な値:
      # - org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe (テキスト)
      # - org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe (Parquet)
      # - org.apache.hadoop.hive.ql.io.orc.OrcSerde (ORC)
      # - org.openx.data.jsonserde.JsonSerDe (JSON)
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      # パラメータ
      # Type: map(string) (Optional)
      # SerDe の初期化パラメータをキーと値の形式で定義
      # SerDe 固有の設定を指定
      parameters = {
        "serialization.format" = "1"
        "parquet.compression"  = "SNAPPY"
      }
    }

    # ============================================================
    # スキュー情報 (Skewed Info)
    # ============================================================
    # カラムに非常に頻繁に出現する値（スキューされた値）に関する情報

    # skewed_info {
    #   # スキューされたカラム名
    #   # Type: list(string) (Optional)
    #   # スキューされた値を含むカラムの名前のリスト
    #   skewed_column_names = ["status"]
    #
    #   # スキューされたカラム値
    #   # Type: list(string) (Optional)
    #   # 非常に頻繁に出現するためスキューされていると見なされる値のリスト
    #   skewed_column_values = ["ACTIVE", "PENDING"]
    #
    #   # スキューされたカラム値の場所マップ
    #   # Type: map(string) (Optional)
    #   # スキューされた値を含むカラムへのマップ
    #   skewed_column_value_location_maps = {
    #     "ACTIVE"  = "s3://example-bucket/skewed/status=ACTIVE/"
    #     "PENDING" = "s3://example-bucket/skewed/status=PENDING/"
    #   }
    # }
  }

  # ============================================================
  # リージョン指定
  # ============================================================

  # リージョン
  # Type: string (Optional)
  # このリソースが管理されるリージョン
  # 省略した場合、プロバイダー設定のリージョンがデフォルトになります
  # region = "us-east-1"
}

# ============================================================
# 出力値
# ============================================================

# パーティション ID
# パーティションの一意識別子
output "partition_id" {
  description = "The ID of the Glue partition"
  value       = aws_glue_partition.example.id
}

# 作成時刻
# パーティションが作成された時刻
output "partition_creation_time" {
  description = "The time at which the partition was created"
  value       = aws_glue_partition.example.creation_time
}

# 最終分析時刻
# パーティションのカラム統計が最後に計算された時刻
output "partition_last_analyzed_time" {
  description = "The last time at which column statistics were computed for this partition"
  value       = aws_glue_partition.example.last_analyzed_time
}

# 最終アクセス時刻
# パーティションが最後にアクセスされた時刻
output "partition_last_accessed_time" {
  description = "The last time at which the partition was accessed"
  value       = aws_glue_partition.example.last_accessed_time
}

# ============================================================
# 使用例
# ============================================================

# 例1: 日付パーティション (年/月/日)
# resource "aws_glue_partition" "daily_partition" {
#   database_name    = "sales_db"
#   table_name       = "transactions"
#   partition_values = ["2024", "01", "15"]
#
#   storage_descriptor {
#     location      = "s3://sales-data/transactions/year=2024/month=01/day=15/"
#     input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
#     output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
#     compressed    = true
#
#     columns {
#       name = "transaction_id"
#       type = "bigint"
#     }
#
#     columns {
#       name = "amount"
#       type = "decimal(10,2)"
#     }
#
#     ser_de_info {
#       serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
#       parameters = {
#         "serialization.format" = "1"
#       }
#     }
#   }
# }

# 例2: リージョンとステータスによるパーティション
# resource "aws_glue_partition" "region_status_partition" {
#   database_name    = "customer_db"
#   table_name       = "orders"
#   partition_values = ["us-east-1", "completed"]
#
#   parameters = {
#     "classification" = "json"
#   }
#
#   storage_descriptor {
#     location      = "s3://customer-data/orders/region=us-east-1/status=completed/"
#     input_format  = "org.apache.hadoop.mapred.TextInputFormat"
#     output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
#
#     columns {
#       name = "order_id"
#       type = "string"
#     }
#
#     columns {
#       name = "customer_id"
#       type = "string"
#     }
#
#     columns {
#       name = "order_date"
#       type = "timestamp"
#     }
#
#     ser_de_info {
#       serialization_library = "org.openx.data.jsonserde.JsonSerDe"
#       parameters = {
#         "serialization.format" = "1"
#       }
#     }
#   }
# }

# 例3: ORC フォーマットのパーティション
# resource "aws_glue_partition" "orc_partition" {
#   database_name    = "analytics_db"
#   table_name       = "events"
#   partition_values = ["2024", "Q1"]
#
#   storage_descriptor {
#     location      = "s3://analytics-data/events/year=2024/quarter=Q1/"
#     input_format  = "org.apache.hadoop.hive.ql.io.orc.OrcInputFormat"
#     output_format = "org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat"
#     compressed    = true
#
#     columns {
#       name = "event_id"
#       type = "bigint"
#     }
#
#     columns {
#       name = "event_type"
#       type = "string"
#     }
#
#     columns {
#       name = "user_id"
#       type = "bigint"
#     }
#
#     ser_de_info {
#       serialization_library = "org.apache.hadoop.hive.ql.io.orc.OrcSerde"
#       parameters = {
#         "serialization.format" = "1"
#       }
#     }
#   }
# }

# ============================================================
# 重要な注意事項
# ============================================================
# 1. パーティション値の順序
#    - partition_values の順序は、テーブルのパーティションキーの
#      順序と正確に一致する必要があります
#
# 2. Hive 互換性
#    - database_name は Hive 互換性のため、すべて小文字である必要があります
#
# 3. S3 パスの構造
#    - location は通常、パーティションキーと値を含むパターンに従います
#      例: s3://bucket/table/key1=value1/key2=value2/
#
# 4. データフォーマット
#    - input_format、output_format、serialization_library は
#      一貫性を保つ必要があります
#    - Parquet: MapredParquetInputFormat / MapredParquetOutputFormat / ParquetHiveSerDe
#    - ORC: OrcInputFormat / OrcOutputFormat / OrcSerde
#    - JSON: TextInputFormat / HiveIgnoreKeyTextOutputFormat / JsonSerDe
#    - CSV: TextInputFormat / HiveIgnoreKeyTextOutputFormat / OpenCSVSerDe
#
# 5. パーティション管理
#    - AWS Glue クローラーは自動的にパーティションを検出できます
#    - パーティションプロジェクションを使用すると、メタデータルックアップを
#      回避して、クエリのパフォーマンスを向上させることができます
#
# 6. カラム統計
#    - GetColumnStatisticsForPartition API を使用して
#      パーティションレベルのカラム統計を取得できます
#
# 7. バッチ操作
#    - 複数のパーティションを一度に作成する場合は、
#      BatchCreatePartition API の使用を検討してください
#
# 8. セキュリティ
#    - パーティションデータへのアクセスは、IAM ポリシーと
#      Lake Formation のアクセス許可によって制御されます
#
# 9. コスト最適化
#    - 適切なパーティショニング戦略により、
#      スキャンするデータ量を削減してクエリコストを削減できます
#
# 10. 既存データとの同期
#     - S3 に既存のパーティションデータがある場合、
#       Terraform でパーティションメタデータを作成する際に
#       location を正しく設定してください
