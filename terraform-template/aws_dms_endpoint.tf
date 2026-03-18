#---------------------------------------------------------------
# AWS DMS (Database Migration Service) Endpoint
#---------------------------------------------------------------
#
# AWS Database Migration Service (DMS) のエンドポイントリソースです。
# エンドポイントは、ソースまたはターゲットのデータベース接続情報を定義し、
# レプリケーションタスクで使用されます。各データベースエンジンに応じた
# 専用の設定ブロックを構成できます。
#
# 注意: パスワードを含むすべての引数はTerraform stateにプレーンテキストで
# 保存されます。Secrets Managerとの統合を推奨します。
#
# AWS公式ドキュメント:
#   - DMS 概要: https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html
#   - エンドポイントの作成: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Endpoints.Creating.html
#   - ソースエンドポイント: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.html
#   - ターゲットエンドポイント: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_endpoint
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dms_endpoint" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # endpoint_id (Required)
  # 設定内容: エンドポイントの一意な識別子を指定します。
  # 設定可能な値: 1-255文字。ASCII英数字とハイフンのみ使用可能。
  #   先頭は英字、末尾にハイフン不可、連続ハイフン不可。
  # 関連機能: DMS エンドポイント
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Endpoints.Creating.html
  endpoint_id = "my-dms-endpoint"

  # endpoint_type (Required)
  # 設定内容: エンドポイントのタイプを指定します。
  # 設定可能な値:
  #   - "source": 移行元データベース
  #   - "target": 移行先データベース
  endpoint_type = "source"

  # engine_name (Required)
  # 設定内容: エンドポイントのデータベースエンジンタイプを指定します。
  # 設定可能な値:
  #   - "aurora": Amazon Aurora MySQL
  #   - "aurora-postgresql": Amazon Aurora PostgreSQL
  #   - "aurora-serverless": Aurora Serverless MySQL
  #   - "aurora-postgresql-serverless": Aurora Serverless PostgreSQL
  #   - "azuredb": Azure SQL Database
  #   - "azure-sql-managed-instance": Azure SQL Managed Instance
  #   - "babelfish": Babelfish for Aurora PostgreSQL
  #   - "db2": IBM Db2 LUW
  #   - "db2-zos": IBM Db2 for z/OS
  #   - "docdb": Amazon DocumentDB
  #   - "dynamodb": Amazon DynamoDB
  #   - "elasticsearch": Amazon OpenSearch Service
  #   - "kafka": Apache Kafka
  #   - "kinesis": Amazon Kinesis Data Streams
  #   - "mariadb": MariaDB
  #   - "mongodb": MongoDB
  #   - "mysql": MySQL
  #   - "opensearch": Amazon OpenSearch Service
  #   - "oracle": Oracle
  #   - "postgres": PostgreSQL
  #   - "redshift": Amazon Redshift (targetのみ)
  #   - "redshift-serverless": Amazon Redshift Serverless
  #   - "sqlserver": Microsoft SQL Server
  #   - "neptune": Amazon Neptune
  #   - "sybase": SAP ASE (Sybase)
  # 注意: 一部のエンジンはtargetエンドポイントタイプのみ対応
  engine_name = "mysql"

  #-------------------------------------------------------------
  # 接続設定
  #-------------------------------------------------------------

  # server_name (Optional)
  # 設定内容: データベースサーバーのホスト名を指定します。
  # 設定可能な値: 有効なホスト名またはIPアドレス
  # 注意: secrets_manager_arnを使用する場合は不要
  server_name = "database.example.com"

  # port (Optional)
  # 設定内容: データベースサーバーのポート番号を指定します。
  # 設定可能な値: 有効なポート番号 (例: MySQL=3306, PostgreSQL=5432, Oracle=1521)
  port = 3306

  # database_name (Optional)
  # 設定内容: エンドポイントのデータベース名を指定します。
  # 設定可能な値: 有効なデータベース名の文字列
  database_name = "mydb"

  # username (Optional)
  # 設定内容: データベース接続用のユーザー名を指定します。
  # 設定可能な値: 有効なデータベースユーザー名
  # 注意: secrets_manager_arnを使用する場合は不要
  username = "admin"

  # password (Optional, Sensitive)
  # 設定内容: データベース接続用のパスワードを指定します。
  # 設定可能な値: 有効なパスワード文字列
  # 注意: Terraform stateにプレーンテキストで保存されるため、
  #   変数やSecrets Managerの使用を推奨
  password = "change-me"

  # extra_connection_attributes (Optional, Computed)
  # 設定内容: エンドポイントの追加接続属性を指定します。
  # 設定可能な値: セミコロン区切りのキーバリュー文字列
  # 省略時: 空文字列
  # 関連機能: エンジン固有の追加パラメータ
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.html
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.html
  extra_connection_attributes = ""

  #-------------------------------------------------------------
  # Secrets Manager統合
  #-------------------------------------------------------------

  # secrets_manager_arn (Optional)
  # 設定内容: エンドポイント接続情報を含むSecrets ManagerシークレットのARNを指定します。
  # 設定可能な値: 完全ARN、部分ARN、またはシークレットのフレンドリー名
  # 注意: username, password, server_name, portのクリアテキスト値と排他的。
  #   対応エンジン: aurora, aurora-postgresql, mariadb, mongodb, mysql, oracle,
  #   postgres, redshift, sqlserver
  secrets_manager_arn = null

  # secrets_manager_access_role_arn (Optional)
  # 設定内容: Secrets Managerシークレットへのアクセスに使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: secrets_manager_arnを使用する場合は必須。iam:PassRoleアクションの許可が必要
  secrets_manager_access_role_arn = null

  #-------------------------------------------------------------
  # 暗号化・SSL設定
  #-------------------------------------------------------------

  # ssl_mode (Optional, Computed)
  # 設定内容: SSL接続モードを指定します。
  # 設定可能な値:
  #   - "none": SSL未使用
  #   - "require": SSL必須（証明書検証なし）
  #   - "verify-ca": CA証明書を検証
  #   - "verify-full": CA証明書とホスト名を検証
  # 省略時: "none"
  ssl_mode = "none"

  # certificate_arn (Optional, Computed)
  # 設定内容: SSL接続に使用するDMS証明書のARNを指定します。
  # 設定可能な値: 有効なDMS証明書ARN
  # 省略時: 空文字列
  # 関連機能: DMS SSL証明書
  #   aws_dms_certificateリソースで作成した証明書を指定
  certificate_arn = null

  # kms_key_arn (Optional, Computed)
  # 設定内容: 接続パラメータの暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWSアカウントのデフォルト暗号化キーが使用されます
  # 注意: engine_nameがmongodbの場合は必須。engine_nameがredshiftの場合、
  #   Redshiftターゲット用のKMSキーとして使用されます。
  # 関連機能: DMS 暗号化
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html
  kms_key_arn = null

  #-------------------------------------------------------------
  # サービスアクセス設定
  #-------------------------------------------------------------

  # service_access_role (Optional)
  # 設定内容: DynamoDBエンドポイント用のサービスアクセスIAMロールARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: engine_nameがdynamodbの場合に使用
  service_access_role = null

  #-------------------------------------------------------------
  # レプリケーションタスク制御
  #-------------------------------------------------------------

  # pause_replication_tasks (Optional)
  # 設定内容: エンドポイント変更前に関連するレプリケーションタスクを一時停止するかを指定します。
  # 設定可能な値: true | false
  # 省略時: false
  # 注意: trueの場合、Terraform管理外のタスクも含め関連する実行中タスクを一時停止し、
  #   変更完了後にこのリソースが一時停止したタスクのみ再開します
  pause_replication_tasks = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Elasticsearch / OpenSearch設定
  #-------------------------------------------------------------

  # elasticsearch_settings (Optional)
  # 設定内容: OpenSearch (旧Elasticsearch) エンドポイントの設定ブロックです。
  # 注意: engine_nameが"elasticsearch"または"opensearch"の場合に使用
  # 関連機能: DMS OpenSearchターゲット
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.Elasticsearch.html
  elasticsearch_settings {

    # endpoint_uri (Required)
    # 設定内容: OpenSearchクラスターのエンドポイントURIを指定します。
    # 設定可能な値: 有効なOpenSearchドメインエンドポイントURL
    endpoint_uri = "https://search-example.us-east-1.es.amazonaws.com"

    # service_access_role_arn (Required)
    # 設定内容: OpenSearchクラスターへの書き込み権限を持つIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    service_access_role_arn = "arn:aws:iam::123456789012:role/dms-opensearch-role"

    # error_retry_duration (Optional)
    # 設定内容: OpenSearchクラスターへの失敗したAPIリクエストの最大リトライ秒数を指定します。
    # 設定可能な値: 正の整数（秒）
    # 省略時: 300
    error_retry_duration = 300

    # full_load_error_percentage (Optional)
    # 設定内容: フルロード中に許容される最大エラー率（パーセント）を指定します。
    # 設定可能な値: 0-100の整数
    # 省略時: 10
    full_load_error_percentage = 10

    # use_new_mapping_type (Optional)
    # 設定内容: _docドキュメントタイプを使用してドキュメントを移行するかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    # 注意: OpenSearchおよびElasticsearch 7.x以降のクラスターでのみ_docタイプをサポート
    use_new_mapping_type = false
  }

  #-------------------------------------------------------------
  # Kafka設定
  #-------------------------------------------------------------

  # kafka_settings (Optional)
  # 設定内容: Apache Kafkaエンドポイントの設定ブロックです。
  # 注意: engine_nameが"kafka"の場合に使用
  # 関連機能: DMS Kafkaターゲット
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.Kafka.html
  kafka_settings {

    # broker (Required)
    # 設定内容: Kafkaブローカーの接続先を指定します。
    # 設定可能な値: "ホスト名またはIP:ポート" 形式の文字列
    broker = "kafka-broker-1:9092"

    # topic (Optional)
    # 設定内容: 移行先のKafkaトピック名を指定します。
    # 設定可能な値: 有効なKafkaトピック名
    # 省略時: "kafka-default-topic"
    topic = "dms-migration-topic"

    # message_format (Optional)
    # 設定内容: エンドポイントで作成されるレコードの出力形式を指定します。
    # 設定可能な値:
    #   - "JSON": JSON形式（デフォルト）
    #   - "JSON_UNFORMATTED": タブなしの単一行JSON
    # 省略時: "JSON"
    message_format = "JSON"

    # message_max_bytes (Optional)
    # 設定内容: レコードの最大サイズ（バイト）を指定します。
    # 設定可能な値: 正の整数
    # 省略時: 1000000
    message_max_bytes = 1000000

    # include_control_details (Optional)
    # 設定内容: テーブル定義、カラム定義、テーブル/カラム変更の詳細制御情報を含めるかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    include_control_details = false

    # include_null_and_empty (Optional)
    # 設定内容: 移行レコードにNULL値と空カラムを含めるかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    include_null_and_empty = false

    # include_partition_value (Optional)
    # 設定内容: パーティション値をKafkaメッセージ出力に含めるかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    include_partition_value = false

    # include_table_alter_operations (Optional)
    # 設定内容: rename-table、drop-table、add-column等のDDL操作を制御データに含めるかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    include_table_alter_operations = false

    # include_transaction_details (Optional)
    # 設定内容: ソースデータベースからの詳細なトランザクション情報を含めるかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    include_transaction_details = false

    # no_hex_prefix (Optional)
    # 設定内容: 16進数データに'0x'プレフィックスを付加しないかを指定します。
    # 設定可能な値: true | false
    # 省略時: false (プレフィックスが付加される)
    # 注意: RAWデータ型カラムをOracleソースからKafkaターゲットに移行する際に有用
    no_hex_prefix = false

    # partition_include_schema_table (Optional)
    # 設定内容: パーティション値にスキーマ名とテーブル名をプレフィックスとして付加するかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    # 注意: partition_typeがprimary-key-typeの場合にデータ分散を改善
    partition_include_schema_table = false

    # sasl_mechanism (Optional)
    # 設定内容: SASL/SSL認証で使用するメカニズムを指定します。
    # 設定可能な値:
    #   - "scram-sha-512": SCRAM-SHA-512メカニズム（デフォルト）
    #   - "plain": PLAINメカニズム（DMS 3.5.0以降）
    sasl_mechanism = "scram-sha-512"

    # sasl_username (Optional)
    # 設定内容: SASL-SSL認証用のユーザー名を指定します。
    # 設定可能な値: 有効なMSKクラスターユーザー名
    sasl_username = null

    # sasl_password (Optional, Sensitive)
    # 設定内容: SASL-SSL認証用のパスワードを指定します。
    # 設定可能な値: 有効なMSKクラスターパスワード
    sasl_password = null

    # security_protocol (Optional)
    # 設定内容: Kafkaターゲットへのセキュア接続プロトコルを指定します。
    # 設定可能な値:
    #   - "ssl-encryption": TLSによる暗号化
    #   - "ssl-authentication": TLSによる認証
    #   - "sasl-ssl": SASL-SSL認証（sasl_usernameとsasl_passwordが必要）
    security_protocol = null

    # ssl_ca_certificate_arn (Optional)
    # 設定内容: Kafkaターゲットへのセキュア接続に使用するCA証明書のARNを指定します。
    # 設定可能な値: 有効なACM証明書ARN
    ssl_ca_certificate_arn = null

    # ssl_client_certificate_arn (Optional)
    # 設定内容: Kafkaターゲットへのセキュア接続に使用するクライアント証明書のARNを指定します。
    # 設定可能な値: 有効なACM証明書ARN
    ssl_client_certificate_arn = null

    # ssl_client_key_arn (Optional)
    # 設定内容: Kafkaターゲットへのセキュア接続に使用するクライアント秘密鍵のARNを指定します。
    # 設定可能な値: 有効なACM証明書ARN
    ssl_client_key_arn = null

    # ssl_client_key_password (Optional, Sensitive)
    # 設定内容: クライアント秘密鍵のパスワードを指定します。
    # 設定可能な値: 有効なパスワード文字列
    ssl_client_key_password = null
  }

  #-------------------------------------------------------------
  # Kinesis設定
  #-------------------------------------------------------------

  # kinesis_settings (Optional)
  # 設定内容: Amazon Kinesis Data Streamsエンドポイントの設定ブロックです。
  # 注意: engine_nameが"kinesis"の場合に使用
  # 関連機能: DMS Kinesisターゲット
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.Kinesis.html
  kinesis_settings {

    # stream_arn (Optional)
    # 設定内容: Kinesisデータストリームの ARNを指定します。
    # 設定可能な値: 有効なKinesisストリームARN
    stream_arn = null

    # service_access_role_arn (Optional)
    # 設定内容: Kinesisデータストリームへの書き込み権限を持つIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    service_access_role_arn = null

    # message_format (Optional)
    # 設定内容: レコードの出力形式を指定します。
    # 設定可能な値:
    #   - "json": JSON形式（デフォルト）
    #   - "json-unformatted": タブなしの単一行JSON
    # 省略時: "json"
    message_format = "json"

    # include_control_details (Optional)
    # 設定内容: テーブル定義、カラム定義、変更の詳細制御情報を含めるかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    include_control_details = false

    # include_null_and_empty (Optional)
    # 設定内容: ターゲットにNULL値と空カラムを含めるかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    include_null_and_empty = false

    # include_partition_value (Optional)
    # 設定内容: パーティション値をKinesisメッセージ出力に含めるかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    include_partition_value = false

    # include_table_alter_operations (Optional)
    # 設定内容: DDL操作を制御データに含めるかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    include_table_alter_operations = false

    # include_transaction_details (Optional)
    # 設定内容: 詳細なトランザクション情報を含めるかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    include_transaction_details = false

    # partition_include_schema_table (Optional)
    # 設定内容: パーティション値にスキーマ名とテーブル名をプレフィックスとして付加するかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    partition_include_schema_table = false

    # use_large_integer_value (Optional)
    # 設定内容: 大きな整数値を18桁のint型として使用するかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    # 注意: DMS 3.5.4以降で利用可能。falseの場合、intはdoubleとしてキャストされます
    use_large_integer_value = false
  }

  #-------------------------------------------------------------
  # MongoDB設定
  #-------------------------------------------------------------

  # mongodb_settings (Optional)
  # 設定内容: MongoDBエンドポイントの設定ブロックです。
  # 注意: engine_nameが"mongodb"の場合に使用
  # 関連機能: DMS MongoDBソース
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.MongoDB.html
  mongodb_settings {

    # auth_mechanism (Optional)
    # 設定内容: MongoDBソースへの認証メカニズムを指定します。
    # 設定可能な値: "default", "mongodb_cr", "scram_sha_1"
    # 省略時: "default"
    auth_mechanism = "default"

    # auth_source (Optional)
    # 設定内容: 認証データベース名を指定します。
    # 設定可能な値: 有効なデータベース名
    # 省略時: "admin"
    # 注意: auth_typeが"no"の場合は使用されません
    auth_source = "admin"

    # auth_type (Optional)
    # 設定内容: MongoDBソースへの認証タイプを指定します。
    # 設定可能な値:
    #   - "password": パスワード認証（デフォルト）
    #   - "no": 認証なし
    # 省略時: "password"
    auth_type = "password"

    # docs_to_investigate (Optional)
    # 設定内容: ドキュメント構造を判定するためにプレビューするドキュメント数を指定します。
    # 設定可能な値: 正の整数（文字列として指定）
    # 省略時: "1000"
    # 注意: nesting_levelが"one"の場合に使用
    docs_to_investigate = "1000"

    # extract_doc_id (Optional)
    # 設定内容: ドキュメントIDを抽出するかを指定します。
    # 設定可能な値: "true" | "false"
    # 省略時: "false"
    # 注意: nesting_levelが"none"の場合に使用
    extract_doc_id = "false"

    # nesting_level (Optional)
    # 設定内容: ネストレベルを指定します。
    # 設定可能な値:
    #   - "none": ドキュメントモード（ネスト解除しない）
    #   - "one": テーブルモード（1レベルまで解除）
    # 省略時: "none"
    nesting_level = "none"

    # use_update_lookup (Optional)
    # 設定内容: DMS がMongoDBソースから移行中にドキュメント全体を取得するかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    use_update_lookup = false
  }

  #-------------------------------------------------------------
  # MySQL設定
  #-------------------------------------------------------------

  # mysql_settings (Optional)
  # 設定内容: MySQLエンドポイントの設定ブロックです。
  # 注意: engine_nameが"mysql", "aurora", "mariadb"等のMySQL互換エンジンの場合に使用
  mysql_settings {

    # after_connect_script (Optional)
    # 設定内容: DMSがエンドポイントに接続した直後に実行するスクリプトを指定します。
    # 設定可能な値: 有効なSQL文
    after_connect_script = null

    # authentication_method (Optional)
    # 設定内容: 認証方法を指定します。
    # 設定可能な値:
    #   - "password": パスワード認証
    #   - "iam": IAM認証
    authentication_method = "password"

    # clean_source_metadata_on_mismatch (Optional)
    # 設定内容: 不一致時にレプリケーションインスタンス上のテーブルメタデータをクリーンアップして再作成するかを指定します。
    # 設定可能な値: true | false
    clean_source_metadata_on_mismatch = false

    # events_poll_interval (Optional)
    # 設定内容: データベースがアイドル時にバイナリログの変更をチェックする間隔（秒）を指定します。
    # 設定可能な値: 正の整数（秒）
    # 省略時: 5
    events_poll_interval = 5

    # execute_timeout (Optional)
    # 設定内容: MySQLソースエンドポイントのクライアントステートメントタイムアウト（秒）を指定します。
    # 設定可能な値: 正の整数（秒）
    execute_timeout = null

    # max_file_size (Optional)
    # 設定内容: MySQL互換データベースへのデータ転送に使用するCSVファイルの最大サイズ（KB）を指定します。
    # 設定可能な値: 正の整数（KB）
    max_file_size = null

    # parallel_load_threads (Optional)
    # 設定内容: MySQL互換ターゲットデータベースへのデータロードに使用するスレッド数を指定します。
    # 設定可能な値: 正の整数
    parallel_load_threads = null

    # server_timezone (Optional)
    # 設定内容: ソースMySQLデータベースのタイムゾーンを指定します。
    # 設定可能な値: 有効なタイムゾーン名 (例: "UTC", "Asia/Tokyo")
    server_timezone = null

    # service_access_role_arn (Optional)
    # 設定内容: エンドポイント接続時の認証に使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    service_access_role_arn = null

    # target_db_type (Optional)
    # 設定内容: ソーステーブルの移行先を指定します。
    # 設定可能な値:
    #   - "specific-database": 単一データベースに移行
    #   - "multiple-databases": 複数データベースに移行
    target_db_type = "specific-database"
  }

  #-------------------------------------------------------------
  # Oracle設定
  #-------------------------------------------------------------

  # oracle_settings (Optional)
  # 設定内容: Oracleエンドポイントの設定ブロックです。
  # 注意: engine_nameが"oracle"の場合に使用
  # 関連機能: DMS Oracleソース/ターゲット
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.Oracle.html
  oracle_settings {

    # authentication_method (Optional)
    # 設定内容: 認証メカニズムを指定します。
    # 設定可能な値:
    #   - "password": パスワード認証（デフォルト）
    #   - "kerberos": Kerberos認証
    # 省略時: "password"
    authentication_method = "password"

    # access_alternate_directly (Optional)
    # 設定内容: Binary Readerを使用してAmazon RDS for Oracleの変更データをキャプチャするかを指定します。
    # 設定可能な値: true | false
    # 注意: falseに設定するとBinary Readerを使用
    access_alternate_directly = null

    # add_supplemental_logging (Optional)
    # 設定内容: テーブルレベルの補足ロギングを設定するかを指定します。
    # 設定可能な値: true | false
    # 注意: 移行タスク用に選択された全テーブルのPRIMARY KEY補足ロギングを有効化
    add_supplemental_logging = null

    # additional_archived_log_dest_id (Optional)
    # 設定内容: プライマリ/スタンバイ構成でのアーカイブログの追加宛先IDを指定します。
    # 設定可能な値: 正の整数
    # 注意: archived_log_dest_idと組み合わせてスイッチオーバー時に使用
    additional_archived_log_dest_id = null

    # allow_selected_nested_tables (Optional)
    # 設定内容: ネストテーブルまたは定義型を含むOracleテーブルのレプリケーションを有効にするかを指定します。
    # 設定可能な値: true | false
    allow_selected_nested_tables = null

    # archived_log_dest_id (Optional)
    # 設定内容: アーカイブREDOログの宛先IDを指定します。
    # 設定可能な値: v$archived_logビューのdest_id列の値
    archived_log_dest_id = null

    # archived_logs_only (Optional)
    # 設定内容: アーカイブREDOログのみにアクセスするかを指定します。
    # 設定可能な値: true | false
    archived_logs_only = null

    # asm_password (Optional, Sensitive)
    # 設定内容: Oracle ASM (Automatic Storage Management) のパスワードを指定します。
    # 設定可能な値: 有効なASMパスワード
    asm_password = null

    # asm_server (Optional)
    # 設定内容: Oracle ASMサーバーのアドレスを指定します。
    # 設定可能な値: 有効なホスト名またはIPアドレス
    asm_server = null

    # asm_user (Optional)
    # 設定内容: Oracle ASMのユーザー名を指定します。
    # 設定可能な値: 有効なASMユーザー名
    asm_user = null

    # char_length_semantics (Optional)
    # 設定内容: 文字カラムの長さをバイトまたは文字のどちらで解釈するかを指定します。
    # 設定可能な値:
    #   - "default": デフォルト
    #   - "char": 文字単位
    #   - "byte": バイト単位
    char_length_semantics = null

    # convert_timestamp_with_zone_to_utc (Optional)
    # 設定内容: タイムゾーン付きタイムスタンプをUTC値に変換するかを指定します。
    # 設定可能な値: true | false
    convert_timestamp_with_zone_to_utc = null

    # direct_path_no_log (Optional)
    # 設定内容: テーブルに直接書き込みデータベースログへの書き込みを省略するかを指定します。
    # 設定可能な値: true | false
    # 注意: trueの場合、Oracleターゲットでのコミットレートが向上
    direct_path_no_log = null

    # direct_path_parallel_load (Optional)
    # 設定内容: use_direct_path_full_loadがtrueの場合に並列ロードを使用するかを指定します。
    # 設定可能な値: true | false
    direct_path_parallel_load = null

    # enable_homogenous_tablespace (Optional)
    # 設定内容: 同種テーブルスペースレプリケーションを有効にするかを指定します。
    # 設定可能な値: true | false
    # 注意: ターゲット上で既存テーブルやインデックスを同じテーブルスペースに作成
    enable_homogenous_tablespace = null

    # extra_archived_log_dest_ids (Optional)
    # 設定内容: アーカイブREDOログの追加宛先IDリストを指定します。
    # 設定可能な値: v$archived_logビューのdest_id列の値のリスト
    extra_archived_log_dest_ids = null

    # fail_task_on_lob_truncation (Optional)
    # 設定内容: LOBカラムの実際のサイズがlob_max_sizeより大きい場合にタスクを失敗させるかを指定します。
    # 設定可能な値: true | false
    fail_task_on_lob_truncation = null

    # number_datatype_scale (Optional)
    # 設定内容: NUMBER型データのスケールを指定します。
    # 設定可能な値: 整数値
    number_datatype_scale = null

    # open_transaction_window (Optional)
    # 設定内容: CDC専用タスクのオープントランザクション確認間隔（分）を指定します。
    # 設定可能な値: 0-240の整数
    # 省略時: 0
    open_transaction_window = null

    # oracle_path_prefix (Optional)
    # 設定内容: Amazon RDS for OracleでBinary Readerを使用する場合のREDOログアクセス用Oracleルートパスを指定します。
    # 設定可能な値: 有効なパス文字列
    oracle_path_prefix = null

    # parallel_asm_read_threads (Optional)
    # 設定内容: Oracle ASMを使用したCDCロードのスレッド数を指定します。
    # 設定可能な値: 2-8の整数
    # 省略時: 2
    parallel_asm_read_threads = null

    # read_ahead_blocks (Optional)
    # 設定内容: Oracle ASMを使用したCDCロードの先読みブロック数を指定します。
    # 設定可能な値: 1000-200000の整数
    # 省略時: 1000
    read_ahead_blocks = null

    # read_table_space_name (Optional)
    # 設定内容: テーブルスペースレプリケーションをサポートするかを指定します。
    # 設定可能な値: true | false
    read_table_space_name = null

    # replace_path_prefix (Optional)
    # 設定内容: Amazon RDS for OracleでBinary Readerを使用する場合にデフォルトのOracleルートをuse_path_prefixで置換するかを指定します。
    # 設定可能な値: true | false
    replace_path_prefix = null

    # retry_interval (Optional)
    # 設定内容: クエリ再送までの待機秒数を指定します。
    # 設定可能な値: 正の整数（秒）
    retry_interval = null

    # secrets_manager_oracle_asm_access_role_arn (Optional)
    # 設定内容: Oracle ASM接続情報を含むSecrets ManagerシークレットへのアクセスIAMロールARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 注意: Oracle ASMを使用するエンドポイントでのみ必要
    secrets_manager_oracle_asm_access_role_arn = null

    # secrets_manager_oracle_asm_secret_id (Optional)
    # 設定内容: Oracle ASM接続情報を含むSecrets ManagerシークレットのIDを指定します。
    # 設定可能な値: 完全ARN、部分ARN、またはフレンドリー名
    # 注意: Oracle ASMを使用するエンドポイントでのみ必要
    secrets_manager_oracle_asm_secret_id = null

    # security_db_encryption (Optional, Sensitive)
    # 設定内容: TDE暗号化されたOracleソースのREDOログにアクセスするためのTDEパスワードを指定します。
    # 設定可能な値: 有効なTDEパスワード
    security_db_encryption = null

    # security_db_encryption_name (Optional)
    # 設定内容: TDE暗号化に使用されるキー名を指定します。
    # 設定可能な値: 有効な暗号化キー名
    security_db_encryption_name = null

    # spatial_data_option_to_geo_json_function_name (Optional)
    # 設定内容: SDO_GEOMETRYをGEOJSON形式に変換するための関数名を指定します。
    # 設定可能な値: 有効なSQL関数名
    # 省略時: SDO2GEOJSON関数がアクセス可能な場合はそれを使用
    spatial_data_option_to_geo_json_function_name = null

    # standby_delay_time (Optional)
    # 設定内容: Oracle Active Data Guardスタンバイデータベースでのプライマリとの時間差（分）を指定します。
    # 設定可能な値: 正の整数（分）
    standby_delay_time = null

    # trim_space_in_char (Optional)
    # 設定内容: CHAR/NCHAR型データの末尾スペースをトリムするかを指定します。
    # 設定可能な値: true | false
    # 省略時: true
    trim_space_in_char = null

    # use_alternate_folder_for_online (Optional)
    # 設定内容: Amazon RDS for OracleでBinary Readerを使用する場合に指定プレフィックス置換でオンラインREDOログにアクセスするかを指定します。
    # 設定可能な値: true | false
    use_alternate_folder_for_online = null

    # use_bfile (Optional)
    # 設定内容: Binary Readerユーティリティを使用して変更データをキャプチャするかを指定します。
    # 設定可能な値: true | false
    # 注意: trueにする場合はuse_logminer_readerをfalseに設定
    use_bfile = null

    # use_direct_path_full_load (Optional)
    # 設定内容: Oracle Call Interface (OCI) のダイレクトパスプロトコルを使用してフルロードするかを指定します。
    # 設定可能な値: true | false
    use_direct_path_full_load = null

    # use_logminer_reader (Optional)
    # 設定内容: Oracle LogMinerユーティリティを使用して変更データをキャプチャするかを指定します。
    # 設定可能な値: true | false
    # 省略時: true（デフォルトでLogMinerを使用）
    # 注意: falseに設定するとバイナリファイルとしてREDOログにアクセス
    use_logminer_reader = null

    # use_path_prefix (Optional)
    # 設定内容: Amazon RDS for OracleでBinary Readerを使用する場合のREDOログアクセス用パスプレフィックスを指定します。
    # 設定可能な値: 有効なパス文字列
    use_path_prefix = null
  }

  #-------------------------------------------------------------
  # PostgreSQL設定
  #-------------------------------------------------------------

  # postgres_settings (Optional)
  # 設定内容: PostgreSQLエンドポイントの設定ブロックです。
  # 注意: engine_nameが"postgres", "aurora-postgresql"等のPostgreSQL互換エンジンの場合に使用
  # 関連機能: DMS PostgreSQLソース/ターゲット
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html
  postgres_settings {

    # after_connect_script (Optional)
    # 設定内容: DMSがエンドポイントに接続した直後に実行するスクリプトを指定します。
    # 設定可能な値: 有効なSQL文
    # 注意: CDCのみの使用時に外部キーとユーザートリガーをバイパスしてバルクロード時間を短縮
    after_connect_script = null

    # authentication_method (Optional)
    # 設定内容: 認証方法を指定します。
    # 設定可能な値:
    #   - "password": パスワード認証
    #   - "iam": IAM認証
    authentication_method = "password"

    # babelfish_database_name (Optional)
    # 設定内容: Babelfish for Aurora PostgreSQLのデータベース名を指定します。
    # 設定可能な値: 有効なデータベース名
    # 注意: SQL Server互換モードを使用する場合に指定
    babelfish_database_name = null

    # capture_ddls (Optional)
    # 設定内容: DDLイベントをキャプチャするかを指定します。
    # 設定可能な値: true | false
    # 注意: タスク開始時にPostgreSQLデータベース内に各種アーティファクトを作成
    capture_ddls = null

    # database_mode (Optional)
    # 設定内容: レプリケーションのPostgreSQL互換エンドポイントの処理モードを指定します。
    # 設定可能な値:
    #   - "default": デフォルトモード
    #   - "babelfish": Babelfishモード
    database_mode = null

    # ddl_artifacts_schema (Optional)
    # 設定内容: DDLアーティファクトを作成するスキーマ名を指定します。
    # 設定可能な値: 有効なスキーマ名
    # 省略時: "public"
    ddl_artifacts_schema = "public"

    # execute_timeout (Optional)
    # 設定内容: PostgreSQLインスタンスのクライアントステートメントタイムアウト（秒）を指定します。
    # 設定可能な値: 正の整数（秒）
    # 省略時: 60
    execute_timeout = 60

    # fail_tasks_on_lob_truncation (Optional)
    # 設定内容: LOBカラムの実際のサイズがLobMaxSizeより大きい場合にタスクを失敗させるかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    fail_tasks_on_lob_truncation = false

    # heartbeat_enable (Optional)
    # 設定内容: WALハートビート機能を有効にするかを指定します。
    # 設定可能な値: true | false
    # 注意: アイドル状態の論理レプリケーションスロットが古いWALログを保持することを防止
    heartbeat_enable = false

    # heartbeat_frequency (Optional)
    # 設定内容: WALハートビート頻度（分）を指定します。
    # 設定可能な値: 正の整数（分）
    # 省略時: 5
    heartbeat_frequency = 5

    # heartbeat_schema (Optional)
    # 設定内容: ハートビートアーティファクトを作成するスキーマ名を指定します。
    # 設定可能な値: 有効なスキーマ名
    # 省略時: "public"
    heartbeat_schema = "public"

    # map_boolean_as_boolean (Optional)
    # 設定内容: PostgreSQLのBoolean型をBoolean型としてマッピングするかを指定します。
    # 設定可能な値: true | false
    # 省略時: false
    # 注意: Amazon Redshiftターゲットへのマッピング時に使用
    map_boolean_as_boolean = false

    # map_jsonb_as_clob (Optional)
    # 設定内容: JSONB値をCLOBとして移行するかを指定します。
    # 設定可能な値: true | false
    map_jsonb_as_clob = null

    # map_long_varchar_as (Optional)
    # 設定内容: LONG VARCHAR値のマッピング方法を指定します。
    # 設定可能な値: 有効なマッピングタイプ文字列
    map_long_varchar_as = null

    # max_file_size (Optional)
    # 設定内容: PostgreSQLへのデータ転送に使用するCSVファイルの最大サイズ（KB）を指定します。
    # 設定可能な値: 正の整数（KB）
    # 省略時: 32768
    max_file_size = null

    # plugin_name (Optional)
    # 設定内容: レプリケーションスロットの作成に使用するプラグインを指定します。
    # 設定可能な値:
    #   - "pglogical": pglogicalプラグイン
    #   - "test-decoding": test_decodingプラグイン
    plugin_name = null

    # service_access_role_arn (Optional)
    # 設定内容: エンドポイント接続時の認証に使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    service_access_role_arn = null

    # slot_name (Optional)
    # 設定内容: PostgreSQLソースインスタンスのCDCロード用に作成済みの論理レプリケーションスロット名を指定します。
    # 設定可能な値: 有効なレプリケーションスロット名
    slot_name = null
  }

  #-------------------------------------------------------------
  # Redis設定
  #-------------------------------------------------------------

  # redis_settings (Optional)
  # 設定内容: Redisターゲットエンドポイントの設定ブロックです。
  # 注意: engine_nameが"redis"の場合に使用
  # 関連機能: DMS Redisターゲット
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.Redis.html
  redis_settings {

    # server_name (Required)
    # 設定内容: Redisサーバーの完全修飾ドメイン名を指定します。
    # 設定可能な値: 有効なホスト名
    server_name = "redis.example.com"

    # port (Required)
    # 設定内容: RedisサーバーのTCPポート番号を指定します。
    # 設定可能な値: 有効なポート番号
    port = 6379

    # auth_type (Required)
    # 設定内容: Redisターゲットへの接続時の認証タイプを指定します。
    # 設定可能な値:
    #   - "none": 認証なし
    #   - "auth-token": auth_passwordが必要
    #   - "auth-role": auth_user_nameとauth_passwordが必要
    auth_type = "none"

    # auth_password (Optional, Sensitive)
    # 設定内容: Redis認証パスワードを指定します。
    # 設定可能な値: 有効なパスワード文字列
    # 注意: auth_typeが"auth-token"または"auth-role"の場合に必要
    auth_password = null

    # auth_user_name (Optional)
    # 設定内容: auth-roleオプションの認証ユーザー名を指定します。
    # 設定可能な値: 有効なユーザー名
    # 注意: auth_typeが"auth-role"の場合に必要
    auth_user_name = null

    # ssl_ca_certificate_arn (Optional)
    # 設定内容: RedisターゲットへのDMS接続に使用するCA証明書のARNを指定します。
    # 設定可能な値: 有効な証明書ARN
    ssl_ca_certificate_arn = null

    # ssl_security_protocol (Optional)
    # 設定内容: Redisターゲットへの接続に使用する暗号化プロトコルを指定します。
    # 設定可能な値:
    #   - "plaintext": 暗号化なし
    #   - "ssl-encryption": TLSによる暗号化
    ssl_security_protocol = null
  }

  #-------------------------------------------------------------
  # Redshift設定
  #-------------------------------------------------------------

  # redshift_settings (Optional)
  # 設定内容: Amazon Redshiftターゲットエンドポイントの設定ブロックです。
  # 注意: engine_nameが"redshift"の場合に使用
  # 関連機能: DMS Redshiftターゲット
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.Redshift.html
  redshift_settings {

    # bucket_folder (Optional)
    # 設定内容: S3バケット内のカスタムフォルダパスを指定します。
    # 設定可能な値: 有効なS3オブジェクトプレフィックス
    # 注意: 中間ストレージ用
    bucket_folder = null

    # bucket_name (Optional)
    # 設定内容: 中間ストレージ用のS3バケット名を指定します。
    # 設定可能な値: 有効なS3バケット名
    bucket_name = null

    # encryption_mode (Optional)
    # 設定内容: S3中間ストレージのサーバー側暗号化モードを指定します。
    # 設定可能な値:
    #   - "SSE_S3": S3管理キーによる暗号化（デフォルト）
    #   - "SSE_KMS": KMS管理キーによる暗号化
    # 省略時: "SSE_S3"
    encryption_mode = "SSE_S3"

    # server_side_encryption_kms_key_id (Optional)
    # 設定内容: encryption_modeがSSE_KMSの場合に使用するKMSキーのARNまたはIDを指定します。
    # 設定可能な値: 有効なKMSキーARNまたはID
    # 注意: encryption_modeが"SSE_KMS"の場合は必須
    server_side_encryption_kms_key_id = null

    # service_access_role_arn (Optional)
    # 設定内容: S3バケットへの読み書き権限を持つIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    service_access_role_arn = null
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "5m", "10m")
    # 省略時: 5分
    create = "5m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "5m", "10m")
    # 省略時: 5分
    delete = "5m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tagging.html
  tags = {
    Name        = "my-dms-endpoint"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - endpoint_arn: DMSエンドポイントのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
