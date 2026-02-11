#---------------------------------------------------------------
# AWS DMS S3 Endpoint
#---------------------------------------------------------------
#
# AWS Database Migration Service (DMS) の S3 エンドポイントを作成します。
# S3 をソースまたはターゲットとしてデータベース移行を実行する際に使用します。
# CSV または Parquet 形式でのデータ出力、CDC（Change Data Capture）、
# 暗号化、パーティショニングなど、豊富な設定オプションを提供します。
#
# AWS公式ドキュメント:
#   - Using Amazon S3 as a source for AWS DMS: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.S3.html
#   - Using Amazon S3 as a target for AWS DMS: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.S3.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_s3_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dms_s3_endpoint" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # エンドポイントID
  # 1〜255文字の英数字またはハイフン。先頭は英字、末尾はハイフン不可、
  # 連続するハイフン不可。ASCII文字のみ使用可能。
  endpoint_id = "example-s3-endpoint"

  # エンドポイントタイプ
  # 有効な値: "source" (ソース), "target" (ターゲット)
  endpoint_type = "target"

  # S3バケット名
  # データの移行元または移行先となるS3バケットの名前を指定します。
  bucket_name = "my-dms-bucket"

  # サービスアクセスロールARN
  # S3バケットへのアクセス権限を持つIAMロールのARNを指定します。
  # このロールにはS3への読み取り/書き込み権限が必要です。
  service_access_role_arn = "arn:aws:iam::123456789012:role/dms-s3-access-role"

  #---------------------------------------------------------------
  # オプションパラメータ - 基本設定
  #---------------------------------------------------------------

  # リージョン
  # このリソースが管理されるAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # region = "us-east-1"

  # S3オブジェクトプレフィックス
  # S3バケット内のフォルダパスを指定します（例: "data/migration/"）。
  # bucket_folder = "migration-data"

  # SSL接続モード
  # 有効な値: "none", "require", "verify-ca", "verify-full"
  # AWS デフォルト: "none"
  # ssl_mode = "none"

  # 証明書ARN
  # SSL接続に使用する証明書のARN（オプション）。
  # certificate_arn = ""

  # KMSキーARN
  # 接続パラメータの暗号化に使用するKMSキーのARN。
  # 指定しない場合、AWSのデフォルト暗号化キーが使用されます。
  # kms_key_arn = ""

  # 期待されるバケット所有者
  # スナイピング防止のためのAWSアカウントID。
  # expected_bucket_owner = "123456789012"

  # タグ
  # リソースに割り当てるタグのマップ。
  # tags = {
  #   Name        = "example-dms-s3-endpoint"
  #   Environment = "production"
  # }

  # すべてのタグ
  # プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  # リソースに割り当てられたすべてのタグのマップ。
  # 通常はcomputed属性として使用されますが、明示的に設定することも可能です。
  # tags_all = {
  #   Name        = "example-dms-s3-endpoint"
  #   Environment = "production"
  #   ManagedBy   = "terraform"
  # }

  #---------------------------------------------------------------
  # データフォーマット設定
  #---------------------------------------------------------------

  # データフォーマット
  # 出力ファイルのフォーマット。
  # 有効な値: "csv", "parquet"
  # ソースエンドポイントの場合はCSVのみ有効。
  # data_format = "parquet"

  # 圧縮タイプ
  # ターゲットファイルの圧縮設定。
  # 有効な値: "GZIP", "NONE"
  # デフォルト: "NONE"
  # ソースエンドポイントでは無視されます。
  # compression_type = "GZIP"

  # 暗号化モード
  # S3にコピーされる.csvまたは.parquetファイルの暗号化モード。
  # 有効な値: "SSE_S3", "SSE_KMS"
  # AWS デフォルト: "SSE_S3"
  # ソースエンドポイントではSSE_S3のみ有効。
  # encryption_mode = "SSE_S3"

  # サーバー側暗号化KMSキーID
  # encryption_modeが"SSE_KMS"の場合のKMSキーARN。
  # ソースエンドポイントでは無視されます（SSE_S3のみ有効）。
  # server_side_encryption_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #---------------------------------------------------------------
  # CSV形式設定
  #---------------------------------------------------------------

  # CSV区切り文字
  # ソースファイルの列を区切る文字。デフォルト: ","
  # csv_delimiter = ";"

  # CSV行区切り文字
  # ソースファイルの行を区切る文字。デフォルト: 改行 (\n)
  # csv_row_delimiter = "\\r\\n"

  # CSV NULL値
  # ターゲットへの書き込み時にNULLとして扱う文字列。
  # AWS デフォルト: "NULL"
  # csv_null_value = "?"

  # CSV NoSup値
  # 補足ログに含まれない列に使用する文字列。
  # use_csv_no_sup_valueがtrueの場合に有効。
  # ソースエンドポイントでは無視されます。
  # csv_no_sup_value = "x"

  # CSV NoSup値の使用
  # 補足ログに含まれない列にcsv_no_sup_valueを使用するかどうか。
  # ソースエンドポイントでは無視されます。
  # use_csv_no_sup_value = false

  # RFC 4180準拠
  # S3ソースの場合、先頭の二重引用符の後に終了の二重引用符が
  # 必要かどうか。デフォルト: true
  # rfc_4180 = true

  # ヘッダー行を無視
  # .csvファイルの最初の行ヘッダーを無視するかどうか。
  # 1に設定するとDMSは最初の行を無視します。
  # AWS デフォルト: 0
  # ignore_header_rows = 1

  #---------------------------------------------------------------
  # Parquet形式設定
  #---------------------------------------------------------------

  # Parquetバージョン
  # .parquetファイルフォーマットのバージョン。
  # 有効な値: "parquet-1-0", "parquet-2-0"
  # AWS デフォルト: "parquet-1-0"
  # ソースエンドポイントでは無視されます。
  # parquet_version = "parquet-2-0"

  # Parquetタイムスタンプ（ミリ秒）
  # .parquet形式のS3オブジェクトファイルに書き込まれるTIMESTAMP列の
  # 精度をミリ秒単位で指定するかどうか。デフォルト: false
  # ソースエンドポイントでは無視されます。
  # parquet_timestamp_in_millisecond = true

  # データページサイズ
  # 1データページのバイトサイズ。
  # AWS デフォルト: 1 MiB (1048576)
  # data_page_size = 1100000

  # 辞書ページサイズ制限
  # 列のエンコードされた辞書ページの最大バイトサイズ。
  # AWS デフォルト: 1 MiB (1048576)
  # dict_page_size_limit = 1000000

  # エンコーディングタイプ
  # 使用するエンコーディングのタイプ。
  # 有効な値: "rle_dictionary", "plain", "plain_dictionary"
  # AWS デフォルト: "rle_dictionary"
  # encoding_type = "plain"

  # 統計を有効化
  # Parquetページと行グループの統計を有効にするかどうか。
  # デフォルト: true
  # enable_statistics = false

  # 行グループ長
  # 行グループ内の行数。
  # AWS デフォルト: 10000
  # row_group_length = 11000

  #---------------------------------------------------------------
  # CDC（Change Data Capture）設定
  #---------------------------------------------------------------

  # CDCパス
  # CDCファイルのフォルダパス。設定すると、AWS DMSはこのパスから
  # CDCファイルを読み取り、ターゲットエンドポイントにデータ変更を
  # レプリケートします。AWS DMS 3.4.2以降でサポート。CDCには必須。
  # cdc_path = "cdc/path"

  # CDC挿入のみ
  # 挿入操作のみを.csvまたは.parquet出力ファイルに書き込むかどうか。
  # デフォルト: false
  # cdc_inserts_only = false

  # CDC挿入と更新
  # 挿入および更新操作を.csvまたは.parquet出力ファイルに書き込むかどうか。
  # デフォルト: false
  # cdc_inserts_and_updates = true

  # CDC最大バッチ間隔
  # Amazon S3へのファイル出力後の最大間隔（秒単位）。
  # AWS デフォルト: 60秒
  # cdc_max_batch_interval = 100

  # CDC最小ファイルサイズ
  # Amazon S3へのファイル出力の最小ファイルサイズ条件（KB単位）。
  # AWS デフォルト: 32000 KB
  # cdc_min_file_size = 16

  # トランザクションを保持
  # DMSがcdc_pathで指定されたS3ターゲットのCDCロードの
  # トランザクション順序を保存するかどうか。デフォルト: false
  # ソースエンドポイントでは無視されます。
  # preserve_transactions = false

  #---------------------------------------------------------------
  # 追加オプション
  #---------------------------------------------------------------

  # 列名を追加
  # .csv出力ファイルに列名情報を追加するかどうか。
  # デフォルト: false
  # add_column_name = true

  # 末尾パディング文字を追加
  # パディングを追加するかどうか。デフォルト: false
  # ソースエンドポイントでは無視されます。
  # add_trailing_padding_character = false

  # Canned ACL for Objects
  # S3バケットに作成されるオブジェクトの定義済みACL。
  # 有効な値: "none", "private", "public-read", "public-read-write",
  #          "authenticated-read", "aws-exec-read", "bucket-owner-read",
  #          "bucket-owner-full-control"
  # デフォルト: "none"
  # canned_acl_for_objects = "private"

  # 外部テーブル定義
  # AWS DMSがデータを解釈する方法を記述するJSONドキュメント。
  # ソースエンドポイントには必須。
  # external_table_definition = "{\"TableCount\":1,\"Tables\":[...]}"

  # フルロードの操作を含む
  # フルロードで.csv出力ファイルにINSERT操作のみを書き込み、
  # 行がソースデータベースに追加された方法を示すかどうか。
  # デフォルト: false
  # include_op_for_full_load = true

  # 最大ファイルサイズ
  # フルロード中にS3ターゲットへの移行時に作成される.csvファイルの
  # 最大サイズ（KB単位）。有効な値: 1〜1048576
  # AWS デフォルト: 1 GB (1048576)
  # max_file_size = 1000000

  # タイムスタンプ列名
  # エンドポイントデータにタイムスタンプ情報を追加する列名。
  # timestamp_column_name = "tx_commit_time"

  # フルロードタイムスタンプにタスク開始時刻を使用
  # trueに設定すると、データがターゲットに書き込まれる時刻ではなく、
  # タスク開始時刻をタイムスタンプ列の値として使用します。
  # フルロードの場合、各行にタスク開始時刻が含まれます。
  # CDCロードの場合、各行にトランザクションコミット時刻が含まれます。
  # デフォルト: false
  # use_task_start_time_for_full_load_timestamp = true

  #---------------------------------------------------------------
  # 日付パーティション設定
  #---------------------------------------------------------------

  # 日付パーティションを有効化
  # トランザクションコミット日に基づいてS3バケットフォルダを
  # パーティション分割するかどうか。デフォルト: false
  # ソースエンドポイントでは無視されます。
  # date_partition_enabled = true

  # 日付パーティション区切り文字
  # フォルダパーティション時に使用する日付区切り文字。
  # 有効な値: "SLASH", "UNDERSCORE", "DASH", "NONE"
  # AWS デフォルト: "SLASH"
  # ソースエンドポイントでは無視されます。
  # date_partition_delimiter = "UNDERSCORE"

  # 日付パーティションシーケンス
  # フォルダパーティション時に使用する日付フォーマット。
  # date_partition_enabledがtrueの場合に使用します。
  # 有効な値: "YYYYMMDD", "YYYYMMDDHH", "YYYYMM", "MMYYYYDD", "DDMMYYYY"
  # AWS デフォルト: "YYYYMMDD"
  # ソースエンドポイントでは無視されます。
  # date_partition_sequence = "YYYYMMDDHH"

  # 日付パーティションタイムゾーン
  # 現在のUTC時刻をタイムゾーンに変換します。変換は、日付パーティション
  # フォルダが作成され、CDCファイル名が生成されるときに発生します。
  # フォーマット: Area/Location (例: "Europe/Paris")
  # date_partition_enabledがtrueの場合に使用します。
  # ソースエンドポイントでは無視されます。
  # date_partition_timezone = "Asia/Tokyo"

  #---------------------------------------------------------------
  # Glue Data Catalog統合
  #---------------------------------------------------------------

  # Glue Catalogの生成
  # AWS Glue Data CatalogとAmazon S3ターゲットを統合するかどうか。
  # 統合により、Amazon AthenaなどのサービスでS3データをクエリできます。
  # デフォルト: false
  # glue_catalog_generation = true

  #---------------------------------------------------------------
  # その他の詳細設定
  #---------------------------------------------------------------

  # LOBルックアップ失敗時にターゲットを切り離す（Parquet）
  # AWSサポートの指示に従って使用する、ドキュメント化されていない引数。
  # detach_target_on_lob_lookup_failure_parquet = false
}

#---------------------------------------------------------------
# Timeouts設定
#---------------------------------------------------------------

# resource "aws_dms_s3_endpoint" "example" {
#   # ... 上記の設定 ...
#
#   timeouts {
#     # 作成タイムアウト（デフォルト: 5分）
#     create = "10m"
#
#     # 削除タイムアウト（デフォルト: 5分）
#     delete = "10m"
#   }
# }

#---------------------------------------------------------------
# Attributes Reference（Computed属性 - 読み取り専用）
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能です:
#
# - endpoint_arn - エンドポイントのARN
# - engine_display_name - エンジン名の展開名
# - external_id - クロスアカウント検証に使用可能。
#                 別のアカウントでaws_dms_s3_endpointと共に使用して
#                 クロスアカウントエンドポイントを作成できます。
# - status - エンドポイントのステータス
# - tags_all - リソースに割り当てられたタグのマップ。
#              プロバイダーのdefault_tags設定ブロックから継承された
#              タグを含みます。
#
#---------------------------------------------------------------
