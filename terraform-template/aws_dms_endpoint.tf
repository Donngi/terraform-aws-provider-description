# ------------------------------------------------------------------------------
# AWS DMS Endpoint - Annotated Template
# ------------------------------------------------------------------------------
# Generated: 2026-01-22
# Provider Version: 6.28.0
# Resource: aws_dms_endpoint
#
# このテンプレートは生成時点(2026-01-22)の AWS Provider 6.28.0 の仕様に基づいています。
# 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_endpoint
# ------------------------------------------------------------------------------

resource "aws_dms_endpoint" "example" {
  # ------------------------------------------------------------------------------
  # Required Parameters
  # ------------------------------------------------------------------------------

  # (必須) データベースエンドポイント識別子
  # 1〜255文字の英数字またはハイフンで構成する必要があります
  # 先頭は文字で始まり、末尾はハイフンで終わってはならず、連続したハイフンを含んではいけません
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Endpoints.html
  endpoint_id = "example-dms-endpoint"

  # (必須) エンドポイントのタイプ
  # 有効な値: "source", "target"
  # source: ソースデータベース（移行元）
  # target: ターゲットデータベース（移行先）
  endpoint_type = "source"

  # (必須) エンドポイントのエンジンタイプ
  # 有効な値: "aurora", "aurora-postgresql", "aurora-serverless", "aurora-postgresql-serverless",
  # "azuredb", "azure-sql-managed-instance", "babelfish", "db2", "db2-zos", "docdb", "dynamodb",
  # "elasticsearch", "kafka", "kinesis", "mariadb", "mongodb", "mysql", "opensearch", "oracle",
  # "postgres", "redshift", "redshift-serverless", "sqlserver", "neptune", "sybase"
  # 注意: 一部のエンジン(redshift等)はtargetタイプでのみ利用可能です
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.html
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.html
  engine_name = "aurora"

  # ------------------------------------------------------------------------------
  # Optional Parameters
  # ------------------------------------------------------------------------------

  # (オプション) 証明書のARN
  # SSL接続に使用する証明書を指定します
  # デフォルト: 空文字列
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  # (オプション) エンドポイントデータベース名
  # 接続先のデータベース名を指定します
  database_name = "mydb"

  # (オプション) 追加の接続属性
  # ソースエンドポイントとターゲットエンドポイントで利用可能な追加属性
  # ソース: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.html
  # ターゲット: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.html
  extra_connection_attributes = ""

  # (オプション) KMSキーのARN
  # engine_nameがmongodbの場合は必須、それ以外はオプション
  # 接続パラメータの暗号化に使用されるKMSキーのARN
  # 指定しない場合、AWS DMSはデフォルトの暗号化キーを使用します
  # engine_nameがredshiftの場合、これはRedshiftターゲットのKMSキーであり、
  # redshift_settings.server_side_encryption_kms_key_idはS3中間ストレージを暗号化します
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html#CHAP_Security.EncryptionAtRest
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # (オプション) エンドポイントデータベースへのログインに使用するパスワード
  # 注意: パスワードを含むすべての引数はプレーンテキストとして状態ファイルに保存されます
  # https://www.terraform.io/docs/state/sensitive-data.html
  password = "password123"

  # (オプション) 関連する実行中のレプリケーションタスクを一時停止するかどうか
  # Terraformで管理されているかどうかに関わらず、エンドポイント変更前にタスクを一時停止します
  # リソースによって一時停止されたタスクのみが、変更完了後に再起動されます
  # デフォルト: false
  pause_replication_tasks = false

  # (オプション) エンドポイントデータベースで使用するポート番号
  port = 3306

  # (オプション) このリソースが管理されるリージョン
  # デフォルトではプロバイダー設定のリージョンが使用されます
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # (オプション) Secrets ManagerアクセスロールのARN
  # AWS DMSが信頼されたエンティティとして指定され、Secrets Managerシークレットの値に
  # アクセスするために必要な権限を持つIAMロールのARN
  # ロールはiam:PassRoleアクションを許可する必要があります
  # 注意: secrets_manager_arnと組み合わせて指定するか、
  # username, password, server_name, portのクリアテキスト値を指定できます（両方は不可）
  secrets_manager_access_role_arn = "arn:aws:iam::123456789012:role/dms-secrets-manager-role"

  # (オプション) Secrets ManagerシークレットのARN
  # エンドポイント接続の詳細を含むSecrets Managerシークレットの完全なARN、部分ARN、
  # またはフレンドリー名
  # サポート対象のengine_name: "aurora", "aurora-postgresql", "mariadb", "mongodb",
  # "mysql", "oracle", "postgres", "redshift", "sqlserver"
  secrets_manager_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:my-secret"

  # (オプション) サーバーのホスト名
  server_name = "db.example.com"

  # (オプション) DynamoDBエンドポイント用のサービスアクセスIAMロールのARN
  service_access_role = "arn:aws:iam::123456789012:role/dms-dynamodb-role"

  # (オプション) 接続に使用するSSLモード
  # 有効な値: "none", "require", "verify-ca", "verify-full"
  # デフォルト: "none"
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html#CHAP_Security.SSL
  ssl_mode = "none"

  # (オプション) リソースに割り当てるタグのマップ
  # provider default_tags設定ブロックが存在する場合、一致するキーのタグは
  # プロバイダーレベルで定義されたものを上書きします
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-dms-endpoint"
    Environment = "production"
  }

  # (オプション、非推奨) tags_allは読み取り専用属性のため設定不要
  # プロバイダーのdefault_tagsを含む、リソースに割り当てられたタグのマップ
  # tags_all = {}

  # (オプション) エンドポイントデータベースへのログインに使用するユーザー名
  username = "admin"

  # ------------------------------------------------------------------------------
  # Elasticsearch/OpenSearch Settings
  # ------------------------------------------------------------------------------
  # OpenSearchクラスターまたはElasticsearchへのレプリケーション設定
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.Elasticsearch.html

  elasticsearch_settings {
    # (必須) OpenSearchクラスターのエンドポイント
    endpoint_uri = "https://search-domain.us-east-1.es.amazonaws.com"

    # (必須) OpenSearchクラスターへの書き込み権限を持つIAMロールのARN
    service_access_role_arn = "arn:aws:iam::123456789012:role/dms-elasticsearch-role"

    # (オプション) DMSがOpenSearchクラスターへの失敗したAPIリクエストを再試行する最大秒数
    # デフォルト: 300
    error_retry_duration = 300

    # (オプション) フルロード操作が停止する前に書き込みに失敗できるレコードの最大パーセンテージ
    # デフォルト: 10
    full_load_error_percentage = 10

    # (オプション) ドキュメントタイプ _doc を使用してドキュメントを移行できるようにする
    # OpenSearchおよびElasticsearchクラスターはバージョン7.x以降で _doc ドキュメントタイプのみをサポート
    # デフォルト: false
    use_new_mapping_type = false
  }

  # ------------------------------------------------------------------------------
  # Kafka Settings
  # ------------------------------------------------------------------------------
  # Apache Kafkaエンドポイントへのレプリケーション設定
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.Kafka.html

  kafka_settings {
    # (必須) Kafkaブローカーの場所
    # 形式: broker-hostname-or-ip:port
    broker = "kafka-broker.example.com:9092"

    # (オプション) テーブル定義、列定義、テーブルと列の変更の詳細な制御情報を
    # Kafkaメッセージ出力に表示します
    # デフォルト: false
    include_control_details = false

    # (オプション) エンドポイントに移行されたレコードに対してNULLおよび空の列を含める
    # デフォルト: false
    include_null_and_empty = false

    # (オプション) パーティションタイプが schema-table-type でない限り、
    # Kafkaメッセージ出力内にパーティション値を表示します
    # デフォルト: false
    include_partition_value = false

    # (オプション) rename-table、drop-table、add-column、drop-column、rename-columnなど、
    # テーブルを変更するデータ定義言語(DDL)操作を制御データに含めます
    # デフォルト: false
    include_table_alter_operations = false

    # (オプション) ソースデータベースからの詳細なトランザクション情報を提供します
    # コミットタイムスタンプ、ログ位置、transaction_id、previous transaction_id、
    # transaction_record_idの値が含まれます
    # デフォルト: false
    include_transaction_details = false

    # (オプション) エンドポイントに作成されるレコードの出力形式
    # 有効な値: "JSON" (デフォルト), "JSON_UNFORMATTED" (タブなしの1行)
    message_format = "JSON"

    # (オプション) エンドポイントに作成されるレコードの最大サイズ(バイト単位)
    # デフォルト: 1,000,000
    message_max_bytes = 1000000

    # (オプション) 16進形式の生データに '0x' プレフィックスを追加しないようにする
    # たとえば、デフォルトでは、AWS DMSはOracleソースからKafkaターゲットに移動する際、
    # 16進形式のLOB列タイプに '0x' プレフィックスを追加します
    # このパラメータをtrueに設定すると、'0x'プレフィックスなしでRAWデータ型列の移行が可能になります
    no_hex_prefix = false

    # (オプション) パーティションタイプが primary-key-type の場合、
    # スキーマとテーブル名をパーティション値の接頭辞として付けます
    # これにより、Kafkaパーティション間のデータ分散が増加します
    # デフォルト: false
    partition_include_schema_table = false

    # (オプション) SASL/SSL認証の場合、AWS DMSはデフォルトで scram-sha-512 メカニズムをサポート
    # AWS DMS バージョン3.5.0以降はPLAINメカニズムもサポート
    # PLAINメカニズムを使用するには、このパラメータを "plain" に設定します
    sasl_mechanism = "scram-sha-512"

    # (オプション) MSKクラスターを最初に設定したときに作成したセキュアパスワード
    # SASL-SSL認証を使用してクライアントIDを検証し、サーバーとクライアント間で
    # 暗号化された接続を確立します
    sasl_password = "sasl-password"

    # (オプション) MSKクラスターを最初に設定したときに作成したセキュアユーザー名
    # SASL-SSL認証を使用してクライアントIDを検証し、サーバーとクライアント間で
    # 暗号化された接続を確立します
    sasl_username = "sasl-username"

    # (オプション) Transport Layer Security (TLS)を使用してKafkaターゲットエンドポイントへの
    # セキュア接続を設定します
    # 有効な値: "ssl-encryption", "ssl-authentication", "sasl-ssl"
    # "sasl-ssl" には sasl_username と sasl_password が必要です
    security_protocol = "ssl-encryption"

    # (オプション) AWS DMSがKafkaターゲットエンドポイントに安全に接続するために使用する
    # プライベート認証局(CA)証明書のARN
    ssl_ca_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/ca-cert"

    # (オプション) Kafkaターゲットエンドポイントに安全に接続するために使用される
    # クライアント証明書のARN
    ssl_client_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/client-cert"

    # (オプション) Kafkaターゲットエンドポイントに安全に接続するために使用される
    # クライアント秘密鍵のARN
    ssl_client_key_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:client-key"

    # (オプション) Kafkaターゲットエンドポイントに安全に接続するために使用される
    # クライアント秘密鍵のパスワード
    ssl_client_key_password = "key-password"

    # (オプション) 移行用のKafkaトピック
    # デフォルト: "kafka-default-topic"
    topic = "my-kafka-topic"
  }

  # ------------------------------------------------------------------------------
  # Kinesis Settings
  # ------------------------------------------------------------------------------
  # Amazon Kinesisエンドポイントへのレプリケーション設定
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.Kinesis.html

  kinesis_settings {
    # (オプション) テーブル定義、列定義、テーブルと列の変更の詳細な制御情報を
    # Kinesisメッセージ出力に表示します
    # デフォルト: false
    include_control_details = false

    # (オプション) ターゲットにNULLおよび空の列を含めます
    # デフォルト: false
    include_null_and_empty = false

    # (オプション) パーティションタイプが schema-table-type でない限り、
    # Kinesisメッセージ出力内にパーティション値を表示します
    # デフォルト: false
    include_partition_value = false

    # (オプション) テーブルを変更するデータ定義言語(DDL)操作を制御データに含めます
    # デフォルト: false
    include_table_alter_operations = false

    # (オプション) ソースデータベースからの詳細なトランザクション情報を提供します
    # デフォルト: false
    include_transaction_details = false

    # (オプション) 作成されたレコードの出力形式
    # 有効な値: "json", "json-unformatted" (タブなしの1行)
    # デフォルト: "json"
    message_format = "json"

    # (オプション) パーティションタイプが primary-key-type の場合、
    # スキーマとテーブル名をパーティション値の接頭辞として付けます
    # デフォルト: false
    partition_include_schema_table = false

    # (オプション) Kinesisデータストリームへの書き込み権限を持つIAMロールのARN
    service_access_role_arn = "arn:aws:iam::123456789012:role/dms-kinesis-role"

    # (オプション) KinesisデータストリームのARN
    stream_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/my-stream"

    # (オプション) 整数をdoubleとしてキャストする代わりに、最大18桁の整数を使用します
    # AWS DMS バージョン3.5.4以降で利用可能
    # デフォルト: false
    use_large_integer_value = false
  }

  # ------------------------------------------------------------------------------
  # MongoDB Settings
  # ------------------------------------------------------------------------------
  # MongoDBソースエンドポイントの設定
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.MongoDB.html

  mongodb_settings {
    # (オプション) MongoDBソースエンドポイントにアクセスするための認証メカニズム
    # デフォルト: "default"
    auth_mechanism = "default"

    # (オプション) 認証データベース名
    # auth_type が "no" の場合は使用されません
    # デフォルト: "admin"
    auth_source = "admin"

    # (オプション) MongoDBソースエンドポイントにアクセスするための認証タイプ
    # デフォルト: "password"
    auth_type = "password"

    # (オプション) ドキュメント構成を決定するためにプレビューするドキュメントの数
    # nesting_level が "one" に設定されている場合に使用します
    # デフォルト: 1000
    docs_to_investigate = 1000

    # (オプション) ドキュメントID
    # nesting_level が "none" に設定されている場合に使用します
    # デフォルト: false
    extract_doc_id = false

    # (オプション) ドキュメントモードまたはテーブルモードを指定します
    # 有効な値: "one" (テーブルモード), "none" (ドキュメントモード)
    # デフォルト: "none"
    nesting_level = "none"
  }

  # ------------------------------------------------------------------------------
  # MySQL Settings
  # ------------------------------------------------------------------------------
  # MySQLエンドポイントの詳細設定
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.MySQL.html

  mysql_settings {
    # (オプション) AWS DMSがエンドポイントに接続した直後に実行するスクリプト
    after_connect_script = "SET SESSION sql_mode=''"

    # (オプション) 認証方法
    # 有効な値: "password", "iam"
    authentication_method = "password"

    # (オプション) 不一致が発生した場合、レプリケーションインスタンス上のテーブルメタデータ情報を
    # クリーンアップして再作成するかどうか
    clean_source_metadata_on_mismatch = false

    # (オプション) データベースがアイドル状態のときにバイナリログで新しい変更/イベントを
    # チェックする時間間隔(秒単位)
    # デフォルト: 5
    events_poll_interval = 5

    # (オプション) MySQLソースエンドポイントのクライアントステートメントタイムアウト(秒単位)
    execute_timeout = 60

    # (オプション) MySQL互換データベースにデータを転送するために使用される.csvファイルの最大サイズ(KB単位)
    max_file_size = 512000

    # (オプション) MySQL互換ターゲットデータベースにデータをロードするために使用するスレッドの数
    parallel_load_threads = 1

    # (オプション) ソースMySQLデータベースのタイムゾーン
    server_timezone = "UTC"

    # (オプション) エンドポイントへの接続時に認証するために使用するIAMロールのARN
    service_access_role_arn = "arn:aws:iam::123456789012:role/dms-mysql-role"

    # (オプション) ターゲット上のソーステーブルの移行先
    # 有効な値: "specific-database", "multiple-databases"
    target_db_type = "specific-database"
  }

  # ------------------------------------------------------------------------------
  # Oracle Settings
  # ------------------------------------------------------------------------------
  # Oracleソースエンドポイントの認証設定
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.Oracle.html

  oracle_settings {
    # (オプション) Oracleソースエンドポイントにアクセスするための認証メカニズム
    # 有効な値: "password", "kerberos"
    # デフォルト: "password"
    authentication_method = "password"
  }

  # ------------------------------------------------------------------------------
  # PostgreSQL Settings
  # ------------------------------------------------------------------------------
  # PostgreSQLエンドポイントの詳細設定
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html

  postgres_settings {
    # (オプション) 変更データキャプチャ(CDC)でのみ使用
    # この属性により、AWS DMSは外部キーとユーザートリガーをバイパスして
    # データの一括ロードにかかる時間を短縮します
    after_connect_script = "SET session_replication_role = 'replica';"

    # (オプション) 認証方法を指定します
    # 有効な値: "password", "iam"
    authentication_method = "password"

    # (オプション) Babelfish for Aurora PostgreSQLデータベース名
    babelfish_database_name = "babelfish_db"

    # (オプション) DDLイベントをキャプチャするため、AWS DMSはタスク開始時に
    # PostgreSQLデータベース内に様々なアーティファクトを作成します
    capture_ddls = false

    # (オプション) Babelfishエンドポイントなど、追加の設定を必要とするPostgreSQL互換エンドポイントの
    # レプリケーション処理のデフォルト動作を指定します
    database_mode = "default"

    # (オプション) 操作DDLデータベースアーティファクトが作成されるスキーマを設定します
    # デフォルト: "public"
    ddl_artifacts_schema = "public"

    # (オプション) PostgreSQLインスタンスのクライアントステートメントタイムアウトを秒単位で設定します
    # デフォルト: 60
    execute_timeout = 60

    # (オプション) trueに設定すると、LOB列の実際のサイズが指定されたLobMaxSizeより大きい場合、
    # タスクが失敗します
    # デフォルト: false
    fail_tasks_on_lob_truncation = false

    # (オプション) 先行書き込みログ(WAL)ハートビート機能はダミートランザクションを模倣します
    # これにより、アイドル状態の論理レプリケーションスロットが古いWALログを保持することを防ぎ、
    # ソースでのストレージフル状況を防ぎます
    heartbeat_enable = false

    # (オプション) WALハートビート頻度を分単位で設定します
    # デフォルト: 5
    heartbeat_frequency = 5

    # (オプション) ハートビートアーティファクトが作成されるスキーマを設定します
    # デフォルト: "public"
    heartbeat_schema = "public"

    # (オプション) PostgreSQLエンドポイント設定を使用して、PostgreSQLソースから
    # Amazon Redshiftターゲットへブール値をブール値としてマッピングできます
    # デフォルト: false
    map_boolean_as_boolean = false

    # (オプション) trueの場合、DMSはJSONB値をCLOBとして移行します
    map_jsonb_as_clob = false

    # (オプション) trueの場合、DMSはLONG値をVARCHARとして移行します
    map_long_varchar_as = "wstring"

    # (オプション) PostgreSQLにデータを転送するために使用される.csvファイルの最大サイズをKB単位で指定します
    # デフォルト: 32,768 KB
    max_file_size = 32768

    # (オプション) レプリケーションスロットを作成するために使用するプラグインを指定します
    # 有効な値: "pglogical", "test-decoding"
    plugin_name = "pglogical"

    # (オプション) 接続の認証に使用するIAMロールを指定します
    service_access_role_arn = "arn:aws:iam::123456789012:role/dms-postgres-role"

    # (オプション) PostgreSQLソースインスタンスのCDCロード用に以前に作成された
    # 論理レプリケーションスロットの名前を設定します
    slot_name = "my_replication_slot"
  }

  # ------------------------------------------------------------------------------
  # Redis Settings
  # ------------------------------------------------------------------------------
  # Redisターゲットエンドポイントの設定
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.Redis.html

  redis_settings {
    # (必須) 認証タイプ
    # 有効な値: "none", "auth-token", "auth-role"
    # "auth-token" オプションには auth_password 値が必要です
    # "auth-role" オプションには auth_user_name と auth_password 値が必要です
    auth_type = "none"

    # (必須) エンドポイントの完全修飾ドメイン名
    server_name = "redis.example.com"

    # (必須) エンドポイントのTransmission Control Protocol (TCP)ポート
    port = 6379

    # (オプション) AuthTypeの auth-role および auth-token オプションで提供されるパスワード
    auth_password = "redis-password"

    # (オプション) AuthTypeの auth-role オプションで提供されるユーザー名
    auth_user_name = "redis-user"

    # (オプション) DMSがRedisターゲットエンドポイントに接続するために使用する
    # 認証局(CA)のAmazon Resource Name (ARN)
    ssl_ca_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/redis-ca"

    # (オプション) SSL/TLSプロトコルのセキュリティ設定
    ssl_security_protocol = "plaintext"
  }

  # ------------------------------------------------------------------------------
  # Redshift Settings
  # ------------------------------------------------------------------------------
  # Amazon Redshiftターゲットエンドポイントの設定
  # https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.Redshift.html

  redshift_settings {
    # (オプション) 中間ストレージ用のカスタムS3バケットオブジェクトプレフィックス
    bucket_folder = "dms-redshift"

    # (オプション) 中間ストレージ用のカスタムS3バケット名
    bucket_name = "my-dms-bucket"

    # (オプション) S3にコピーされた中間.csvオブジェクトファイルを暗号化する
    # サーバー側暗号化モード
    # 有効な値: "SSE_S3", "SSE_KMS"
    # デフォルト: "SSE_S3"
    encryption_mode = "SSE_S3"

    # (必須: encryption_mode が SSE_KMS の場合、それ以外は設定不可)
    # encryption_mode が SSE_KMS の場合に使用するKMSキーのARNまたはID
    server_side_encryption_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/redshift-key"

    # (オプション) 中間ストレージ用のS3バケットからの読み取りまたは書き込み権限を持つ
    # IAMロールのAmazon Resource Name (ARN)
    service_access_role_arn = "arn:aws:iam::123456789012:role/dms-redshift-role"
  }

  # ------------------------------------------------------------------------------
  # Timeouts
  # ------------------------------------------------------------------------------
  # リソース操作のタイムアウト設定
  # https://www.terraform.io/docs/configuration/blocks/resources/syntax.html#operation-timeouts

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

# エンドポイントのARN
output "endpoint_arn" {
  description = "ARN of the DMS endpoint"
  value       = aws_dms_endpoint.example.endpoint_arn
}

# エンドポイントID
output "endpoint_id" {
  description = "ID of the DMS endpoint"
  value       = aws_dms_endpoint.example.endpoint_id
}

# プロバイダーのdefault_tagsを含むすべてのタグ
output "tags_all" {
  description = "Map of tags assigned to the resource, including provider default_tags"
  value       = aws_dms_endpoint.example.tags_all
}

