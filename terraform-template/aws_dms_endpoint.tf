#-------------------------------------------------------------------------------
# AWS DMS Endpoint
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/dms_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-02-14
#
# NOTE:
# - AWS Database Migration Service (DMS) のエンドポイントを管理するリソースです
# - ソースまたはターゲットのデータベース接続情報を定義し、データ移行タスクで使用されます
# - Secrets Managerとの統合により、認証情報を安全に管理できます
# - 各データベースエンジンごとに専用の設定ブロックが用意されています
#-------------------------------------------------------------------------------

resource "aws_dms_endpoint" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------

  # 設定内容: エンドポイントの一意識別子
  # 制約事項: 最大255文字、小文字英数字とハイフンのみ使用可能
  endpoint_id = "example-endpoint"

  # 設定内容: エンドポイントのタイプ
  # 設定可能な値: source, target
  # source: 移行元データベース / target: 移行先データベース
  endpoint_type = "source"

  # 設定内容: データベースエンジンの種類
  # 設定可能な値: mysql, oracle, postgres, mariadb, aurora, aurora-postgresql, redshift, s3, db2, azuredb, sybase, dynamodb, mongodb, kinesis, kafka, elasticsearch, documentdb, sqlserver, neptune, redis
  # 利用シーン: 接続先データベースの種類に応じて選択
  engine_name = "mysql"

  #---------------------------------------
  # 接続設定
  #---------------------------------------

  # 設定内容: データベースサーバーのホスト名またはIPアドレス
  # 利用シーン: Secrets Managerを使用しない場合に指定
  server_name = "database.example.com"

  # 設定内容: データベースサーバーのポート番号
  # 省略時: エンジンのデフォルトポートが使用される（MySQL: 3306、PostgreSQL: 5432など）
  port = 3306

  # 設定内容: データベース名
  # 利用シーン: 特定のデータベースに接続する場合に指定
  database_name = "mydb"

  # 設定内容: データベース接続用のユーザー名
  # 利用シーン: Secrets Managerを使用しない場合に指定
  username = "admin"

  # 設定内容: データベース接続用のパスワード
  # セキュリティ: 機密情報のため、変数やSecrets Managerの使用を推奨
  # sensitive = true
  password = "change-me-in-production"

  #---------------------------------------
  # Secrets Manager統合
  #---------------------------------------

  # 設定内容: AWS Secrets Managerのシークレットを指定するARN
  # 利用シーン: 認証情報を安全に管理する場合（推奨設定）
  # 形式: arn:aws:secretsmanager:region:account-id:secret:secret-name
  secrets_manager_arn = null

  # 設定内容: Secrets Managerへのアクセスに使用するIAMロールのARN
  # 必須条件: secrets_manager_arnを使用する場合は必須
  secrets_manager_access_role_arn = null

  #---------------------------------------
  # 暗号化とセキュリティ
  #---------------------------------------

  # 設定内容: SSL/TLSモード
  # 設定可能な値: none, require, verify-ca, verify-full
  # none: SSL未使用 / require: SSL必須だが証明書検証なし / verify-ca: CA証明書検証 / verify-full: 完全な証明書検証
  # 省略時: エンジンによって異なる（通常はnone）
  ssl_mode = "none"

  # 設定内容: SSL証明書のARN
  # 利用シーン: SSL/TLS接続でカスタム証明書を使用する場合
  # 形式: arn:aws:dms:region:account-id:cert:certificate-id
  certificate_arn = null

  # 設定内容: データ暗号化に使用するKMSキーのARN
  # 利用シーン: 保管時のデータ暗号化を有効にする場合
  # 形式: arn:aws:kms:region:account-id:key/key-id
  kms_key_arn = null

  #---------------------------------------
  # サービスアクセスロール
  #---------------------------------------

  # 設定内容: DMSがAWSサービスにアクセスするために使用するIAMロールのARN
  # 利用シーン: S3、DynamoDB、Kinesis、Redshiftなどのエンドポイントで必要
  # 形式: arn:aws:iam::account-id:role/role-name
  service_access_role = null

  #---------------------------------------
  # 追加設定
  #---------------------------------------

  # 設定内容: エンドポイント固有の追加接続属性
  # 利用シーン: エンジン固有のパラメータを設定する場合（セミコロン区切り）
  # 例: "maxFileSize=512000;useSSL=true"
  # 省略時: エンジンのデフォルト設定が使用される
  extra_connection_attributes = ""

  # 設定内容: レプリケーションタスクの一時停止フラグ
  # 設定可能な値: true, false
  # true: エンドポイント削除前に関連するレプリケーションタスクを一時停止
  # 利用シーン: エンドポイントを安全に削除する場合
  pause_replication_tasks = false

  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダーのリージョン設定が使用される
  region = null

  #---------------------------------------
  # タグ
  #---------------------------------------

  # 設定内容: リソースに付与するタグ
  # 利用シーン: コスト管理、環境識別、アクセス制御に使用
  tags = {
    Name        = "example-dms-endpoint"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #---------------------------------------
  # Elasticsearch設定（engine_name = "elasticsearch"の場合）
  #---------------------------------------

  # elasticsearch_settings {
  #   # 設定内容: ElasticsearchエンドポイントのURI
  #   # 形式: https://search-domain-name.region.es.amazonaws.com
  #   endpoint_uri = "https://search-example.us-east-1.es.amazonaws.com"
  #
  #   # 設定内容: Elasticsearchへのアクセスに使用するIAMロールのARN
  #   service_access_role_arn = aws_iam_role.dms_elasticsearch_access.arn
  #
  #   # 設定内容: エラー発生時の再試行期間（秒）
  #   # 省略時: 300秒
  #   # error_retry_duration = 300
  #
  #   # 設定内容: 全ロード時の許容エラー率（パーセント）
  #   # 省略時: 10%
  #   # full_load_error_percentage = 10
  #
  #   # 設定内容: 新しいマッピングタイプの使用
  #   # 設定可能な値: true, false
  #   # true: Elasticsearch 7.x以降の_doc型を使用 / false: レガシー型を使用
  #   # use_new_mapping_type = false
  # }

  #---------------------------------------
  # Kafka設定（engine_name = "kafka"の場合）
  #---------------------------------------

  # kafka_settings {
  #   # 設定内容: Kafkaブローカーのアドレス
  #   # 形式: hostname:port（複数の場合はカンマ区切り）
  #   broker = "kafka-broker-1:9092,kafka-broker-2:9092"
  #
  #   # 設定内容: トピック名
  #   # 省略時: デフォルトトピックが使用される
  #   # topic = "dms-topic"
  #
  #   # 設定内容: メッセージフォーマット
  #   # 設定可能な値: json, json-unformatted
  #   # message_format = "json"
  #
  #   # 設定内容: メッセージの最大サイズ（バイト）
  #   # 省略時: 1000000バイト
  #   # message_max_bytes = 1000000
  #
  #   # 設定内容: 制御詳細情報の包含
  #   # include_control_details = false
  #
  #   # 設定内容: NULL値と空値の包含
  #   # include_null_and_empty = false
  #
  #   # 設定内容: パーティション値の包含
  #   # include_partition_value = false
  #
  #   # 設定内容: テーブルALTER操作の包含
  #   # include_table_alter_operations = false
  #
  #   # 設定内容: トランザクション詳細情報の包含
  #   # include_transaction_details = false
  #
  #   # 設定内容: 16進数プレフィックスの除去
  #   # no_hex_prefix = false
  #
  #   # 設定内容: パーティションにスキーマとテーブル名を含める
  #   # partition_include_schema_table = false
  #
  #   # 設定内容: SASL認証メカニズム
  #   # 設定可能な値: scram-sha-512, plain
  #   # sasl_mechanism = "scram-sha-512"
  #
  #   # 設定内容: SASL認証ユーザー名
  #   # sasl_username = "kafka-user"
  #
  #   # 設定内容: SASL認証パスワード
  #   # sensitive = true
  #   # sasl_password = var.kafka_password
  #
  #   # 設定内容: セキュリティプロトコル
  #   # 設定可能な値: plaintext, ssl-authentication, sasl-ssl, ssl-encryption
  #   # security_protocol = "ssl-encryption"
  #
  #   # 設定内容: SSL CA証明書のARN
  #   # ssl_ca_certificate_arn = aws_dms_certificate.kafka_ca.certificate_arn
  #
  #   # 設定内容: SSLクライアント証明書のARN
  #   # ssl_client_certificate_arn = aws_dms_certificate.kafka_client.certificate_arn
  #
  #   # 設定内容: SSLクライアントキーのARN
  #   # ssl_client_key_arn = aws_dms_certificate.kafka_key.certificate_arn
  #
  #   # 設定内容: SSLクライアントキーのパスワード
  #   # sensitive = true
  #   # ssl_client_key_password = var.kafka_key_password
  # }

  #---------------------------------------
  # Kinesis設定（engine_name = "kinesis"の場合）
  #---------------------------------------

  # kinesis_settings {
  #   # 設定内容: Kinesis Data Streamsへのアクセスに使用するIAMロールのARN
  #   # service_access_role_arn = aws_iam_role.dms_kinesis_access.arn
  #
  #   # 設定内容: KinesisストリームのARN
  #   # 形式: arn:aws:kinesis:region:account-id:stream/stream-name
  #   # stream_arn = aws_kinesis_stream.example.arn
  #
  #   # 設定内容: メッセージフォーマット
  #   # 設定可能な値: json, json-unformatted
  #   # message_format = "json"
  #
  #   # 設定内容: 制御詳細情報の包含
  #   # include_control_details = false
  #
  #   # 設定内容: NULL値と空値の包含
  #   # include_null_and_empty = false
  #
  #   # 設定内容: パーティション値の包含
  #   # include_partition_value = false
  #
  #   # 設定内容: テーブルALTER操作の包含
  #   # include_table_alter_operations = false
  #
  #   # 設定内容: トランザクション詳細情報の包含
  #   # include_transaction_details = false
  #
  #   # 設定内容: パーティションにスキーマとテーブル名を含める
  #   # partition_include_schema_table = false
  #
  #   # 設定内容: 大きな整数値の使用
  #   # 設定可能な値: true, false
  #   # true: BigIntを文字列として処理 / false: 数値として処理
  #   # use_large_integer_value = false
  # }

  #---------------------------------------
  # MongoDB設定（engine_name = "mongodb"の場合）
  #---------------------------------------

  # mongodb_settings {
  #   # 設定内容: 認証メカニズム
  #   # 設定可能な値: default, mongodb_cr, scram_sha_1
  #   # auth_mechanism = "default"
  #
  #   # 設定内容: 認証ソースデータベース
  #   # 省略時: adminデータベース
  #   # auth_source = "admin"
  #
  #   # 設定内容: 認証タイプ
  #   # 設定可能な値: password, no
  #   # auth_type = "password"
  #
  #   # 設定内容: スキーマ解析対象のドキュメント数
  #   # 省略時: 1000
  #   # docs_to_investigate = "1000"
  #
  #   # 設定内容: ドキュメントIDの抽出
  #   # 設定可能な値: true, false
  #   # extract_doc_id = "false"
  #
  #   # 設定内容: ネストレベル
  #   # 設定可能な値: none, one
  #   # none: ネスト解除しない / one: 1レベルまで解除
  #   # nesting_level = "none"
  # }

  #---------------------------------------
  # MySQL設定（engine_name = "mysql"の場合）
  #---------------------------------------

  # mysql_settings {
  #   # 設定内容: 接続後に実行するSQLスクリプト
  #   # 利用シーン: セッション変数の設定など
  #   # after_connect_script = "SET time_zone = '+00:00'"
  #
  #   # 設定内容: 認証方法
  #   # 設定可能な値: password, secrets_manager
  #   # 省略時: password
  #   # authentication_method = "password"
  #
  #   # 設定内容: ソースメタデータ不一致時のクリーンアップ
  #   # 設定可能な値: true, false
  #   # true: 不一致時にメタデータをクリーンアップ
  #   # 省略時: false
  #   # clean_source_metadata_on_mismatch = false
  #
  #   # 設定内容: イベントポーリング間隔（秒）
  #   # 省略時: 5秒
  #   # events_poll_interval = 5
  #
  #   # 設定内容: クエリ実行タイムアウト（秒）
  #   # 省略時: 60秒
  #   # execute_timeout = 60
  #
  #   # 設定内容: バイナリログファイルの最大サイズ（KB）
  #   # 省略時: 32768 KB
  #   # max_file_size = 32768
  #
  #   # 設定内容: 並列ロードスレッド数
  #   # 省略時: 1
  #   # 利用シーン: 全ロード時のパフォーマンス向上
  #   # parallel_load_threads = 1
  #
  #   # 設定内容: サーバーのタイムゾーン
  #   # 例: UTC, Asia/Tokyo
  #   # server_timezone = "UTC"
  #
  #   # 設定内容: サービスアクセスロールのARN
  #   # 利用シーン: Aurora MySQLをターゲットにする場合
  #   # service_access_role_arn = aws_iam_role.dms_mysql_access.arn
  #
  #   # 設定内容: ターゲットデータベースタイプ
  #   # 設定可能な値: specific-database, multiple-databases
  #   # specific-database: 単一データベース / multiple-databases: 複数データベース
  #   # 省略時: specific-database
  #   # target_db_type = "specific-database"
  # }

  #---------------------------------------
  # Oracle設定（engine_name = "oracle"の場合）
  #---------------------------------------

  # oracle_settings {
  #   # 設定内容: 認証方法
  #   # 設定可能な値: password, secrets_manager
  #   # 省略時: password
  #   # authentication_method = "password"
  # }

  #---------------------------------------
  # PostgreSQL設定（engine_name = "postgres"の場合）
  #---------------------------------------

  # postgres_settings {
  #   # 設定内容: 接続後に実行するSQLスクリプト
  #   # after_connect_script = "SET search_path = public"
  #
  #   # 設定内容: 認証方法
  #   # 設定可能な値: password, secrets_manager
  #   # 省略時: password
  #   # authentication_method = "password"
  #
  #   # 設定内容: Babelfishデータベース名
  #   # 利用シーン: SQL Server互換モードを使用する場合
  #   # babelfish_database_name = "babelfish_db"
  #
  #   # 設定内容: DDLのキャプチャ
  #   # 設定可能な値: true, false
  #   # capture_ddls = false
  #
  #   # 設定内容: データベースモード
  #   # 設定可能な値: default, babelfish
  #   # database_mode = "default"
  #
  #   # 設定内容: DDLアーティファクトのスキーマ名
  #   # ddl_artifacts_schema = "public"
  #
  #   # 設定内容: クエリ実行タイムアウト（秒）
  #   # 省略時: 60秒
  #   # execute_timeout = 60
  #
  #   # 設定内容: LOB切り捨て時のタスク失敗
  #   # 設定可能な値: true, false
  #   # fail_tasks_on_lob_truncation = false
  #
  #   # 設定内容: ハートビート有効化
  #   # 設定可能な値: true, false
  #   # heartbeat_enable = false
  #
  #   # 設定内容: ハートビート頻度（分）
  #   # 省略時: 1分
  #   # heartbeat_frequency = 1
  #
  #   # 設定内容: ハートビートスキーマ名
  #   # heartbeat_schema = "public"
  #
  #   # 設定内容: Boolean型のマッピング
  #   # 設定可能な値: true, false
  #   # true: Boolean型として保持 / false: 整数にマッピング
  #   # map_boolean_as_boolean = false
  #
  #   # 設定内容: JSONB型のCLOBマッピング
  #   # 設定可能な値: true, false
  #   # map_jsonb_as_clob = false
  #
  #   # 設定内容: 長いVARCHARのマッピング方法
  #   # 設定可能な値: wstring, clob, nclob
  #   # map_long_varchar_as = "wstring"
  #
  #   # 設定内容: LOBファイルの最大サイズ（KB）
  #   # 省略時: 32768 KB
  #   # max_file_size = 32768
  #
  #   # 設定内容: レプリケーションプラグイン名
  #   # 設定可能な値: test_decoding, pglogical
  #   # plugin_name = "test_decoding"
  #
  #   # 設定内容: サービスアクセスロールのARN
  #   # 利用シーン: Aurora PostgreSQLをターゲットにする場合
  #   # service_access_role_arn = aws_iam_role.dms_postgres_access.arn
  #
  #   # 設定内容: レプリケーションスロット名
  #   # slot_name = "dms_slot"
  # }

  #---------------------------------------
  # Redis設定（engine_name = "redis"の場合）
  #---------------------------------------

  # redis_settings {
  #   # 設定内容: Redisサーバーのホスト名
  #   server_name = "redis.example.com"
  #
  #   # 設定内容: Redisサーバーのポート番号
  #   port = 6379
  #
  #   # 設定内容: 認証タイプ
  #   # 設定可能な値: none, auth-role, auth-token
  #   auth_type = "auth-token"
  #
  #   # 設定内容: 認証パスワード
  #   # sensitive = true
  #   # auth_password = var.redis_password
  #
  #   # 設定内容: 認証ユーザー名
  #   # 利用シーン: auth_type = "auth-role"の場合
  #   # auth_user_name = "redis-user"
  #
  #   # 設定内容: SSL CA証明書のARN
  #   # ssl_ca_certificate_arn = aws_dms_certificate.redis_ca.certificate_arn
  #
  #   # 設定内容: SSLセキュリティプロトコル
  #   # 設定可能な値: plaintext, ssl-encryption
  #   # ssl_security_protocol = "ssl-encryption"
  # }

  #---------------------------------------
  # Redshift設定（engine_name = "redshift"の場合）
  #---------------------------------------

  # redshift_settings {
  #   # 設定内容: S3バケット内のフォルダパス
  #   # 利用シーン: データロード用の中間ファイル保存場所
  #   # bucket_folder = "dms-temp"
  #
  #   # 設定内容: S3バケット名
  #   # bucket_name = "my-dms-bucket"
  #
  #   # 設定内容: 暗号化モード
  #   # 設定可能な値: sse-s3, sse-kms
  #   # encryption_mode = "sse-s3"
  #
  #   # 設定内容: サーバー側暗号化用のKMSキーID
  #   # 利用シーン: encryption_mode = "sse-kms"の場合
  #   # server_side_encryption_kms_key_id = aws_kms_key.s3.id
  #
  #   # 設定内容: S3へのアクセスに使用するIAMロールのARN
  #   # service_access_role_arn = aws_iam_role.dms_redshift_access.arn
  # }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  # timeouts {
  #   # 設定内容: エンドポイント作成のタイムアウト
  #   # 省略時: 5分
  #   # create = "5m"
  #
  #   # 設定内容: エンドポイント削除のタイムアウト
  #   # 省略時: 5分
  #   # delete = "5m"
  # }
}

#-------------------------------------------------------------------------------
# Outputs
#-------------------------------------------------------------------------------

# エンドポイントのARN
# 利用シーン: 他のリソースから参照する場合
output "endpoint_arn" {
  description = "DMSエンドポイントのARN"
  value       = aws_dms_endpoint.example.endpoint_arn
}

# エンドポイントID
# 利用シーン: コンソールでの確認や他リソースでの参照
output "endpoint_id" {
  description = "DMSエンドポイントのID"
  value       = aws_dms_endpoint.example.endpoint_id
}

#-------------------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-------------------------------------------------------------------------------

# endpoint_arn - エンドポイントのARN
# id - エンドポイントのID（endpoint_idと同じ）
# endpoint_id - エンドポイントの識別子
# tags_all - デフォルトタグを含む全てのタグのマップ
# certificate_arn - SSL証明書のARN（computed属性）
# kms_key_arn - KMSキーのARN（computed属性）
# ssl_mode - SSL/TLSモード（computed属性）
# extra_connection_attributes - 追加接続属性（computed属性）

#-------------------------------------------------------------------------------
# Import（既存リソースのインポート方法）
#-------------------------------------------------------------------------------

# DMSエンドポイントはendpoint_idを使用してインポートできます。
#
# 実行例:
# terraform import aws_dms_endpoint.example example-endpoint
