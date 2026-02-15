#---------------------------------------
# AWS DMS S3エンドポイント
#---------------------------------------
# AWS Database Migration Serviceでデータ移行先または移行元として使用するAmazon S3エンドポイントを作成します。
# CSV形式またはParquet形式でのデータエクスポート/インポートに対応し、
# 変更データキャプチャ（CDC）やフルロード時の詳細な設定が可能です。
#
# 主な用途:
# - データベースからS3データレイクへの移行
# - S3に格納されたデータのデータベースへのインポート
# - CDC（Change Data Capture）によるリアルタイムデータ同期
# - Parquet形式での効率的なデータ保存とAthena/Glueとの連携
#
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_s3_endpoint
# AWS Documentation: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.S3.html
# Provider Version: 6.28.0
# Generated: 2026-02-14
#
# NOTE: このテンプレートは全属性を含む完全版です。実際の使用時は必須項目のみの設定を推奨します。

#-----------------------------------------------
# 基本設定
#-----------------------------------------------
resource "aws_dms_s3_endpoint" "example" {
  # エンドポイントID（必須）
  # 設定内容: DMSエンドポイントを識別する一意のID
  # 設定可能な値: 英数字とハイフンのみ（先頭は英字）
  endpoint_id = "example-s3-endpoint"

  # エンドポイントタイプ（必須）
  # 設定内容: このエンドポイントの役割（ソース/ターゲット）
  # 設定可能な値: "source"（移行元）, "target"（移行先）
  endpoint_type = "target"

  # S3バケット名（必須）
  # 設定内容: データを保存または読み取るS3バケット名
  bucket_name = "my-dms-bucket"

  # サービスアクセスロールARN（必須）
  # 設定内容: DMSがS3バケットにアクセスするために使用するIAMロールのARN
  # 注意: s3:GetObject, s3:PutObject, s3:DeleteObject, s3:ListBucket権限が必要
  service_access_role_arn = "arn:aws:iam::123456789012:role/dms-s3-access-role"

  #-----------------------------------------------
  # S3バケット構造設定
  #-----------------------------------------------
  # バケット内フォルダパス
  # 設定内容: S3バケット内でデータを保存するフォルダパス
  # 省略時: バケットのルート直下にデータを保存
  bucket_folder = "dms-migration-data"

  # バケット所有者の検証
  # 設定内容: 予期しないバケットへのアクセスを防ぐためのバケット所有者アカウントID
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 所有者検証なし
  expected_bucket_owner = "123456789012"

  #-----------------------------------------------
  # データフォーマット設定
  #-----------------------------------------------
  # データ形式
  # 設定内容: S3に保存するデータのファイル形式
  # 設定可能な値: "csv"（デフォルト）, "parquet"
  # 省略時: CSV形式
  data_format = "parquet"

  # 圧縮タイプ
  # 設定内容: ターゲットファイルの圧縮方式
  # 設定可能な値: "none"（デフォルト）, "gzip"
  # 省略時: 圧縮なし
  compression_type = "gzip"

  # エンコーディングタイプ
  # 設定内容: Parquet形式使用時のエンコーディング方式
  # 設定可能な値: "plain"（デフォルト）, "plain-dictionary", "rle-dictionary"
  # 省略時: plain
  encoding_type = "rle-dictionary"

  #-----------------------------------------------
  # CSV形式固有の設定
  #-----------------------------------------------
  # CSV列区切り文字
  # 設定内容: CSV形式でのカラム区切り文字
  # 省略時: カンマ（,）
  csv_delimiter = ","

  # CSV行区切り文字
  # 設定内容: CSV形式での行区切り文字
  # 省略時: 改行（\n）
  csv_row_delimiter = "\n"

  # CSVにNULL値として書き込む文字列
  # 設定内容: NULL値をCSVに出力する際に使用する文字列
  # 省略時: 空文字列
  csv_null_value = "NULL"

  # CSV補足ログなしの値
  # 設定内容: 補足ログに含まれないカラムに使用する値
  # 省略時: 空文字列
  csv_no_sup_value = ""

  # CSV補足ログなし値の使用
  # 設定内容: csv_no_sup_valueの使用を有効化
  # 設定可能な値: true, false
  # 省略時: false
  use_csv_no_sup_value = false

  # 列名の追加
  # 設定内容: 出力ファイルに列名情報を含める
  # 設定可能な値: true, false
  # 省略時: false
  add_column_name = false

  # 末尾パディング文字の追加
  # 設定内容: 文字列データに末尾パディングを追加
  # 設定可能な値: true, false
  # 省略時: false
  add_trailing_padding_character = false

  # RFC 4180準拠
  # 設定内容: CSVファイルをRFC 4180仕様に準拠させる
  # 設定可能な値: true, false
  # 省略時: true
  rfc_4180 = true

  # ヘッダー行の無視
  # 設定内容: CSV読み取り時にスキップする先頭行数（ソースエンドポイントのみ）
  # 設定可能な値: 0以上の整数
  # 省略時: 0
  ignore_header_rows = 1

  #-----------------------------------------------
  # Parquet形式固有の設定
  #-----------------------------------------------
  # Parquetバージョン
  # 設定内容: 使用するApache Parquetフォーマットのバージョン
  # 設定可能な値: "parquet-1-0"（デフォルト）, "parquet-2-0"
  # 省略時: parquet-1-0
  parquet_version = "parquet-2-0"

  # データページサイズ
  # 設定内容: Parquetファイルの1データページのサイズ（バイト）
  # 設定可能な値: 1024～1048576（1KB～1MB）
  # 省略時: 1048576（1MB）
  data_page_size = 1048576

  # 辞書ページサイズ制限
  # 設定内容: カラムのエンコード済み辞書ページの最大サイズ（バイト）
  # 設定可能な値: 正の整数
  # 省略時: 1048576（1MB）
  dict_page_size_limit = 1048576

  # 行グループ長
  # 設定内容: Parquet形式の1行グループに含める行数
  # 設定可能な値: 正の整数
  # 省略時: 10000
  row_group_length = 10000

  # Parquet統計の有効化
  # 設定内容: Parquetページと行グループの統計情報を有効化
  # 設定可能な値: true（デフォルト）, false
  # 省略時: true
  enable_statistics = true

  # Parquetタイムスタンプのミリ秒精度
  # 設定内容: TIMESTAMP列値をミリ秒精度でParquetファイルに書き込む
  # 設定可能な値: true, false（デフォルト、マイクロ秒精度）
  # 省略時: false
  parquet_timestamp_in_millisecond = false

  # LOBルックアップ失敗時のターゲット切り離し
  # 設定内容: Parquet形式使用時、LOBルックアップ失敗時にターゲットから切り離す
  # 設定可能な値: true, false
  # 省略時: false
  detach_target_on_lob_lookup_failure_parquet = false

  #-----------------------------------------------
  # CDC（Change Data Capture）設定
  #-----------------------------------------------
  # CDCパス
  # 設定内容: CDCファイルを保存するフォルダパス
  # 省略時: bucket_folderと同じパス
  cdc_path = "cdc"

  # CDC INSERTのみ
  # 設定内容: CDCロード時にINSERT操作のみを.csvまたは.parquetファイルに書き込む
  # 設定可能な値: true, false
  # 省略時: false
  cdc_inserts_only = false

  # CDC INSERTとUPDATE
  # 設定内容: CDCロード時にINSERTとUPDATE操作を.csvまたは.parquetファイルに書き込む
  # 設定可能な値: true, false
  # 省略時: false
  cdc_inserts_and_updates = false

  # CDC最大バッチ間隔
  # 設定内容: S3にファイルを出力するまでの最大間隔（秒）
  # 設定可能な値: 正の整数（秒）
  # 省略時: 60秒
  cdc_max_batch_interval = 60

  # CDC最小ファイルサイズ
  # 設定内容: S3にファイルを出力するために到達すべき最小ファイルサイズ（KB）
  # 設定可能な値: 正の整数（キロバイト）
  # 省略時: 32000KB（32MB）
  cdc_min_file_size = 32000

  # トランザクション順序の保持
  # 設定内容: S3ターゲットへのCDCロード時にトランザクション順序を保存
  # 設定可能な値: true, false
  # 省略時: false
  preserve_transactions = false

  # タイムスタンプ列名
  # 設定内容: タイムスタンプ情報を含む列を追加する際の列名
  # 省略時: タイムスタンプ列を追加しない
  timestamp_column_name = "operation_timestamp"

  # フルロード時のタスク開始時刻の使用
  # 設定内容: フルロードタイムスタンプにタスク開始時刻を使用
  # 設定可能な値: true, false
  # 省略時: false
  use_task_start_time_for_full_load_timestamp = false

  #-----------------------------------------------
  # データ操作記録設定
  #-----------------------------------------------
  # フルロード時の操作表示
  # 設定内容: フルロード時にINSERT操作を出力ファイルに記録
  # 設定可能な値: true, false
  # 省略時: false
  include_op_for_full_load = false

  #-----------------------------------------------
  # ファイルサイズ設定
  #-----------------------------------------------
  # 最大ファイルサイズ
  # 設定内容: フルロード時に作成される.csvファイルの最大サイズ（KB）
  # 設定可能な値: 正の整数（キロバイト）
  # 省略時: 1048576KB（1GB）
  max_file_size = 524288

  #-----------------------------------------------
  # 日付パーティション設定
  #-----------------------------------------------
  # 日付パーティショニングの有効化
  # 設定内容: 日付ベースのフォルダパーティショニングを有効化
  # 設定可能な値: true, false
  # 省略時: false
  date_partition_enabled = false

  # 日付パーティション区切り文字
  # 設定内容: フォルダパーティショニング時の日付区切り文字
  # 設定可能な値: "SLASH"（/）, "UNDERSCORE"（_）, "DASH"（-）, "NONE"
  # 省略時: SLASH
  date_partition_delimiter = "SLASH"

  # 日付パーティションシーケンス
  # 設定内容: フォルダパーティショニング時の日付フォーマット順序
  # 設定可能な値: "YYYYMMDD"（デフォルト）, "YYYYMMDDHH", "YYYYMM", "MMYYYYDD", "DDMMYYYY"
  # 省略時: YYYYMMDD
  date_partition_sequence = "YYYYMMDD"

  # 日付パーティションタイムゾーン
  # 設定内容: 日付パーティションフォルダとCDCファイル名生成時に使用するタイムゾーン
  # 設定可能な値: タイムゾーン名（例: "Asia/Tokyo", "UTC"）
  # 省略時: UTC
  date_partition_timezone = "Asia/Tokyo"

  #-----------------------------------------------
  # セキュリティ設定
  #-----------------------------------------------
  # 暗号化モード
  # 設定内容: サーバー側暗号化のタイプ
  # 設定可能な値: "SSE_S3"（S3管理キー）, "SSE_KMS"（KMS管理キー）
  # 省略時: SSE_S3
  encryption_mode = "SSE_KMS"

  # サーバー側暗号化KMSキーID
  # 設定内容: encryption_modeがSSE_KMSの場合に使用するKMSキーID
  # 設定可能な値: KMSキーID、ARN、エイリアス、エイリアスARN
  # 注意: encryption_mode = "SSE_KMS"の場合に設定
  server_side_encryption_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # KMSキーARN
  # 設定内容: データ暗号化に使用するKMSキーのARN
  # 設定可能な値: KMSキーARN
  # 省略時: 計算値
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # SSL/TLS証明書ARN
  # 設定内容: SSL/TLS接続に使用する証明書のARN
  # 省略時: 証明書検証なし
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  # SSLモード
  # 設定内容: SSL接続のセキュリティレベル
  # 設定可能な値: "none", "require", "verify-ca", "verify-full"
  # 省略時: none
  ssl_mode = "none"

  #-----------------------------------------------
  # ACL設定
  #-----------------------------------------------
  # S3オブジェクトのCanned ACL
  # 設定内容: S3バケットに作成されるオブジェクトに適用する事前定義ACL
  # 設定可能な値: "private", "public-read", "public-read-write", "authenticated-read",
  #              "aws-exec-read", "bucket-owner-read", "bucket-owner-full-control"
  # 省略時: private
  canned_acl_for_objects = "bucket-owner-full-control"

  #-----------------------------------------------
  # 外部テーブル定義（ソースエンドポイントのみ）
  #-----------------------------------------------
  # 外部テーブル定義
  # 設定内容: S3ソースファイルでのテーブル定義方法を指定するJSON
  # 注意: endpoint_type = "source"の場合にのみ使用
  external_table_definition = jsonencode({
    TableCount = 1
    Tables = [
      {
        TableName = "example_table"
        TablePath = "example-schema/example-table/"
        TableOwner = "example-schema"
        TableColumns = [
          {
            ColumnName = "id"
            ColumnType = "INT8"
            ColumnNullable = "false"
          }
        ]
      }
    ]
  })

  #-----------------------------------------------
  # AWS Glue統合
  #-----------------------------------------------
  # Glueカタログ生成
  # 設定内容: AWS GlueでS3バケットをカタログ化する
  # 設定可能な値: true, false
  # 省略時: false
  glue_catalog_generation = false

  #-----------------------------------------------
  # リージョン設定
  #-----------------------------------------------
  # リージョン
  # 設定内容: このリソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  region = "us-east-1"

  #-----------------------------------------------
  # タグ設定
  #-----------------------------------------------
  # タグ
  # 設定内容: エンドポイントに付与するタグ
  tags = {
    Environment = "production"
    Project     = "data-migration"
    ManagedBy   = "terraform"
  }

  #-----------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------
  timeouts {
    # 作成タイムアウト
    # 設定内容: エンドポイント作成の最大待機時間
    # 省略時: 5分
    create = "10m"

    # 削除タイムアウト
    # 設定内容: エンドポイント削除の最大待機時間
    # 省略時: 5分
    delete = "10m"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# endpoint_arn               - エンドポイントのARN
# certificate_arn            - 証明書のARN（設定されている場合）
# engine_display_name        - エンジンの表示名（常に"s3"）
# external_id                - 外部ID
# id                         - エンドポイントのID
# kms_key_arn                - KMSキーのARN（設定されている場合）
# region                     - エンドポイントが管理されるリージョン
# ssl_mode                   - SSLモード
# status                     - エンドポイントのステータス
# tags_all                   - プロバイダーのdefault_tagsと統合されたタグの完全なマップ

#---------------------------------------
# 出力例
#---------------------------------------
output "dms_s3_endpoint_arn" {
  description = "DMS S3エンドポイントのARN"
  value       = aws_dms_s3_endpoint.example.endpoint_arn
}

output "dms_s3_endpoint_status" {
  description = "DMS S3エンドポイントのステータス"
  value       = aws_dms_s3_endpoint.example.status
}
