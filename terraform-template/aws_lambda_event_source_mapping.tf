#---------------------------------------------------------------
# AWS Lambda Event Source Mapping
#---------------------------------------------------------------
#
# AWS Lambdaのイベントソースマッピングをプロビジョニングするリソースです。
# Lambda関数とイベントソース（Kinesis、DynamoDB、SQS、Amazon MQ、MSK、
# DocumentDB、セルフマネージドKafka等）を接続し、Lambda関数がイベントソースから
# レコードを読み取って処理できるようにします。
#
# AWS公式ドキュメント:
#   - イベントソースマッピングの概要: https://docs.aws.amazon.com/lambda/latest/dg/invocation-eventsourcemapping.html
#   - CreateEventSourceMapping API: https://docs.aws.amazon.com/lambda/latest/api/API_CreateEventSourceMapping.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_event_source_mapping" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # function_name (Required)
  # 設定内容: イベントをサブスクライブするLambda関数の名前またはARNを指定します。
  # 設定可能な値: Lambda関数名、部分ARN、完全なARN（エイリアスやバージョンを含む場合も可）
  function_name = aws_lambda_function.example.arn

  # event_source_arn (Optional)
  # 設定内容: イベントソースのARNを指定します。
  # 設定可能な値: Kinesisストリーム、DynamoDBストリーム、SQSキュー、MQブローカー、
  #   MSKクラスター、DocumentDB変更ストリームのARN
  # 省略時: self_managed_event_sourceを使用するセルフマネージドKafkaソースの場合は省略可
  # 注意: self_managed_event_sourceとは排他的
  event_source_arn = aws_kinesis_stream.example.arn

  # enabled (Optional)
  # 設定内容: イベントソースマッピングを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): マッピングを有効化し、Lambda関数がイベントを処理します
  #   - false: マッピングを一時停止し、Lambda関数はイベントを処理しません
  # 省略時: true
  enabled = true

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # バッチ処理設定
  #-------------------------------------------------------------

  # batch_size (Optional)
  # 設定内容: 1回の呼び出しでLambdaがイベントソースから取得するレコードの最大数を指定します。
  # 設定可能な値:
  #   - DynamoDB/Kinesis/MSK/MQ: 1〜10000
  #   - SQS標準キュー: 1〜10000
  #   - SQS FIFOキュー: 1〜10
  # 省略時: DynamoDB/Kinesis/MQ/MSKは100、SQSは10
  batch_size = 100

  # maximum_batching_window_in_seconds (Optional)
  # 設定内容: 関数を呼び出す前にレコードを収集する最大待機時間（秒）を指定します。
  # 設定可能な値: 0〜300秒
  # 省略時: ストリームソースの場合はレコードが利用可能になり次第処理
  # 注意: ストリームソース（DynamoDB/Kinesis）とSQS標準キューのみ利用可能
  maximum_batching_window_in_seconds = 5

  # tumbling_window_in_seconds (Optional)
  # 設定内容: Lambdaストリーミング分析の処理ウィンドウの期間（秒）を指定します。
  # 設定可能な値: 1〜900秒
  # 省略時: null（ウィンドウなし）
  # 注意: ストリームソース（DynamoDB/Kinesis）のみ利用可能
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/with-kinesis.html#services-kinesis-windows
  tumbling_window_in_seconds = null

  #-------------------------------------------------------------
  # 読み取り開始位置設定
  #-------------------------------------------------------------

  # starting_position (Optional)
  # 設定内容: Lambda関数がストリームの読み取りを開始する位置を指定します。
  # 設定可能な値:
  #   - "LATEST": 最新のレコードから読み取りを開始
  #   - "TRIM_HORIZON": 最も古いレコードから読み取りを開始
  #   - "AT_TIMESTAMP": starting_position_timestampで指定した時刻から読み取りを開始（Kinesisのみ）
  # 省略時: SQSからイベントを取得する場合は指定不要
  # 注意: Kinesis、DynamoDB、MSK、セルフマネージドApache Kafkaの場合に必要
  # 参考: https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_streams_GetShardIterator.html
  starting_position = "LATEST"

  # starting_position_timestamp (Optional)
  # 設定内容: starting_positionが"AT_TIMESTAMP"の場合に読み取りを開始する時刻を指定します。
  # 設定可能な値: RFC3339形式のタイムスタンプ文字列（例: "2024-01-01T00:00:00Z"）
  # 省略時: null
  # 注意: starting_positionが"AT_TIMESTAMP"の場合のみ有効
  starting_position_timestamp = null

  #-------------------------------------------------------------
  # エラー処理設定（ストリームソース用）
  #-------------------------------------------------------------

  # bisect_batch_on_function_error (Optional)
  # 設定内容: 関数がエラーを返した場合にバッチを2分割してリトライするかを指定します。
  # 設定可能な値:
  #   - true: エラー発生時にバッチを分割してリトライ。問題のあるレコードを特定しやすくなります
  #   - false (デフォルト): バッチを分割せずにリトライ
  # 省略時: false
  # 注意: ストリームソース（DynamoDB/Kinesis）のみ利用可能
  bisect_batch_on_function_error = false

  # maximum_record_age_in_seconds (Optional)
  # 設定内容: Lambdaが関数に送信するレコードの最大経過時間（秒）を指定します。
  # 設定可能な値: -1（無制限）または60〜604800（秒）
  # 省略時: -1（無制限、デフォルト）
  # 注意: ストリームソース（DynamoDB/Kinesis）のみ利用可能
  maximum_record_age_in_seconds = -1

  # maximum_retry_attempts (Optional)
  # 設定内容: 関数がエラーを返した場合の最大リトライ回数を指定します。
  # 設定可能な値: -1（無制限）〜10000
  # 省略時: -1（無制限、デフォルト）
  # 注意: ストリームソース（DynamoDB/Kinesis）のみ利用可能
  maximum_retry_attempts = -1

  # parallelization_factor (Optional)
  # 設定内容: 各シャードから並行して処理するバッチ数を指定します。
  # 設定可能な値: 1〜10
  # 省略時: 1（デフォルト）
  # 注意: ストリームソース（DynamoDB/Kinesis）のみ利用可能
  parallelization_factor = 1

  #-------------------------------------------------------------
  # レスポンスタイプ設定
  #-------------------------------------------------------------

  # function_response_types (Optional)
  # 設定内容: Lambda チェックポイントのためにイベントソースマッピングに適用するレスポンスタイプのリストを指定します。
  # 設定可能な値:
  #   - "ReportBatchItemFailures": バッチ内の個別アイテムの失敗を報告。失敗したアイテムのみリトライ可能
  # 省略時: null（全バッチをリトライ）
  # 注意: SQSとストリームソース（DynamoDB/Kinesis）のみ利用可能
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/with-ddb.html#services-ddb-batchfailurereporting
  function_response_types = ["ReportBatchItemFailures"]

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_arn (Optional)
  # 設定内容: フィルター条件の暗号化に使用するKMSカスタマーマネージドキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: null（フィルター条件は暗号化されません）
  kms_key_arn = null

  #-------------------------------------------------------------
  # Amazon MQ設定
  #-------------------------------------------------------------

  # queues (Optional)
  # 設定内容: 消費するAmazon MQブローカーのデスティネーションキュー名を指定します。
  # 設定可能な値: キュー名のリスト（正確に1つのキュー名を指定する必要があります）
  # 省略時: null
  # 注意: MQソースのみ利用可能
  queues = null

  #-------------------------------------------------------------
  # Kafkaトピック設定
  #-------------------------------------------------------------

  # topics (Optional)
  # 設定内容: Kafkaトピックの名前を指定します。
  # 設定可能な値: トピック名のセット（単一トピック名を指定）
  # 省略時: null
  # 注意: MSKソースのみ利用可能
  topics = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-event-source-mapping"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # フィルター条件設定
  #-------------------------------------------------------------

  # filter_criteria (Optional)
  # 設定内容: Lambdaがイベントを処理するかどうかを判定するフィルター条件の設定ブロックです。
  # 注意: Kinesisストリーム、DynamoDBストリーム、SQSキューイベントソースで利用可能
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/invocation-eventfiltering.html
  filter_criteria {

    # filter (Optional)
    # 設定内容: フィルタールールのセットを指定します（最大10個）。
    # 設定内容: いずれか1つのフィルターを満たすイベントがLambdaに送信されます。
    filter {

      # pattern (Optional)
      # 設定内容: フィルタールールのパターン（最大4096文字）を指定します。
      # 設定可能な値: フィルタールール構文に従うJSON文字列
      # 参考: https://docs.aws.amazon.com/lambda/latest/dg/invocation-eventfiltering.html#filtering-syntax
      pattern = jsonencode({
        body = {
          temperature = [{ numeric = [">", 0, "<=", 100] }]
        }
      })
    }
  }

  #-------------------------------------------------------------
  # 失敗時の転送先設定
  #-------------------------------------------------------------

  # destination_config (Optional)
  # 設定内容: 処理失敗したレコードの転送先設定ブロックです。
  # 注意: ストリームソース（DynamoDB/Kinesis）とKafkaソース（MSK/セルフマネージド）のみ利用可能
  destination_config {

    # on_failure (Optional)
    # 設定内容: 呼び出し失敗時の転送先設定ブロックです。
    on_failure {

      # destination_arn (Required)
      # 設定内容: 失敗したレコードの転送先ARNを指定します。
      # 設定可能な値: SQSキューARN、SNSトピックARN、Kafkaソースの場合は "kafka://トピック名"
      destination_arn = aws_sqs_queue.dlq.arn
    }
  }

  #-------------------------------------------------------------
  # メトリクス設定
  #-------------------------------------------------------------

  # metrics_config (Optional)
  # 設定内容: イベントソースのCloudWatchメトリクス設定ブロックです。
  # 注意: ストリームソース（DynamoDB/Kinesis）とSQSキューのみ利用可能
  metrics_config {

    # metrics (Required)
    # 設定内容: 出力するメトリクスのリストを指定します。
    # 設定可能な値:
    #   - "EventCount": イベント数メトリクスを有効化
    metrics = ["EventCount"]
  }

  #-------------------------------------------------------------
  # スケーリング設定（SQS用）
  #-------------------------------------------------------------

  # scaling_config (Optional)
  # 設定内容: イベントソースのスケーリング設定ブロックです。
  # 注意: SQSキューのみ利用可能
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html#events-sqs-max-concurrency
  scaling_config {

    # maximum_concurrency (Optional)
    # 設定内容: Amazon SQSイベントソースが呼び出せる同時Lambda実行数の上限を指定します。
    # 設定可能な値: 2以上の整数（1000超はService Quotaチケットが必要）
    maximum_concurrency = 100
  }

  #-------------------------------------------------------------
  # プロビジョニング済みポーラー設定
  #-------------------------------------------------------------

  # provisioned_poller_config (Optional)
  # 設定内容: イベントソースのイベントポーラー設定ブロックです。プロビジョニングモードの
  #   最小・最大ポーラー数を制御し、専用のポーリングリソースを確保します。
  # 注意: Amazon MSKまたはセルフマネージドApache Kafkaソースのみ利用可能
  provisioned_poller_config {

    # minimum_pollers (Optional)
    # 設定内容: イベントソースがスケールダウンできるイベントポーラーの最小数を指定します。
    # 設定可能な値: 1〜200
    # 省略時: AWSが自動設定
    minimum_pollers = 1

    # maximum_pollers (Optional)
    # 設定内容: イベントソースがスケールアップできるイベントポーラーの最大数を指定します。
    # 設定可能な値: 1〜2000
    # 省略時: AWSが自動設定
    maximum_pollers = 10

    # poller_group_name (Optional)
    # 設定内容: イベントソースのVPC内の複数ESMをグループ化するプロビジョニング済みポーラーグループ名を指定します。
    # 設定可能な値: 文字列（1グループ最大100のESM、グループ全体のmaximum_pollers合計は2000未満）
    # 省略時: AWSが自動設定
    poller_group_name = null
  }

  #-------------------------------------------------------------
  # Amazon Managed Kafka（MSK）イベントソース設定
  #-------------------------------------------------------------

  # amazon_managed_kafka_event_source_config (Optional)
  # 設定内容: Amazon Managed Streaming for Apache Kafka（MSK）ソースの追加設定ブロックです。
  # 注意: self_managed_event_sourceおよびself_managed_kafka_event_source_configとは排他的
  amazon_managed_kafka_event_source_config {

    # consumer_group_id (Optional)
    # 設定内容: イベントソースマッピング作成時に使用するKafkaコンシューマーグループIDを指定します。
    # 設定可能な値: 1〜200文字の文字列
    # 省略時: 自動生成されます
    # 参考: https://docs.aws.amazon.com/lambda/latest/dg/API_AmazonManagedKafkaEventSourceConfig.html
    consumer_group_id = "lambda-consumer-group"

    # schema_registry_config (Optional)
    # 設定内容: Kafkaスキーマレジストリの設定ブロックです。
    schema_registry_config {

      # event_record_format (Optional)
      # 設定内容: スキーマ検証後にLambdaが関数に渡すレコードフォーマットを指定します。
      # 設定可能な値:
      #   - "JSON": JSONフォーマットでレコードを配信
      #   - "SOURCE": ソースフォーマットのままレコードを配信
      event_record_format = "JSON"

      # schema_registry_uri (Optional)
      # 設定内容: スキーマレジストリのURIを指定します。
      # 設定可能な値: AWS GlueスキーマレジストリのARN、またはConfluentスキーマレジストリのURL
      schema_registry_uri = "arn:aws:glue:ap-northeast-1:123456789012:registry/example-registry"

      # access_config (Optional)
      # 設定内容: スキーマレジストリの認証設定ブロックです。
      access_config {

        # type (Optional)
        # 設定内容: スキーマレジストリへの認証にLambdaが使用する認証タイプを指定します。
        # 設定可能な値: スキーマレジストリの種類に応じた認証タイプ
        type = "BASIC_AUTH"

        # uri (Optional)
        # 設定内容: スキーマレジストリへの認証に使用するシークレット（Secrets Manager シークレットARN）のURIを指定します。
        # 設定可能な値: 有効なSecrets ManagerシークレットのARN
        uri = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:example-secret"
      }

      # schema_validation_config (Optional)
      # 設定内容: スキーマ検証設定の繰り返しブロックです。Lambdaがスキーマレジストリを使用して
      #   検証・フィルタリングするメッセージ属性を指定します。
      schema_validation_config {

        # attribute (Optional)
        # 設定内容: 検証するメッセージ属性を指定します。
        # 設定可能な値:
        #   - "KEY": メッセージキーを検証
        #   - "VALUE": メッセージ値を検証
        attribute = "VALUE"
      }
    }
  }

  #-------------------------------------------------------------
  # セルフマネージドKafkaイベントソース設定
  #-------------------------------------------------------------

  # self_managed_event_source (Optional)
  # 設定内容: セルフマネージドApache Kafkaクラスターの場所を指定する設定ブロックです。
  # 注意: 設定する場合、source_access_configurationも必須。event_source_arnとは排他的
  self_managed_event_source {

    # endpoints (Required)
    # 設定内容: セルフマネージドソースのエンドポイントマップを指定します。
    # 設定可能な値: Kafkaセルフマネージドソースの場合、キーは "KAFKA_BOOTSTRAP_SERVERS"、
    #   値はカンマ区切りのブローカーエンドポイントのリスト文字列
    endpoints = {
      KAFKA_BOOTSTRAP_SERVERS = "kafka1.example.com:9092,kafka2.example.com:9092"
    }
  }

  # self_managed_kafka_event_source_config (Optional)
  # 設定内容: セルフマネージドApache Kafkaソースの追加設定ブロックです。
  # 注意: event_source_arnおよびamazon_managed_kafka_event_source_configとは排他的
  self_managed_kafka_event_source_config {

    # consumer_group_id (Optional)
    # 設定内容: イベントソースマッピング作成時に使用するKafkaコンシューマーグループIDを指定します。
    # 設定可能な値: 1〜200文字の文字列
    # 省略時: 自動生成されます
    # 参考: https://docs.aws.amazon.com/lambda/latest/dg/API_SelfManagedKafkaEventSourceConfig.html
    consumer_group_id = "lambda-consumer-group"

    # schema_registry_config (Optional)
    # 設定内容: Kafkaスキーマレジストリの設定ブロックです。
    schema_registry_config {

      # event_record_format (Optional)
      # 設定内容: スキーマ検証後にLambdaが関数に渡すレコードフォーマットを指定します。
      # 設定可能な値:
      #   - "JSON": JSONフォーマットでレコードを配信
      #   - "SOURCE": ソースフォーマットのままレコードを配信
      event_record_format = "JSON"

      # schema_registry_uri (Optional)
      # 設定内容: スキーマレジストリのURIを指定します。
      # 設定可能な値: ConfluentスキーマレジストリのURL、またはAWS GlueスキーマレジストリのARN
      schema_registry_uri = "https://schema-registry.example.com"

      # access_config (Optional)
      # 設定内容: スキーマレジストリの認証設定ブロックです。
      access_config {

        # type (Optional)
        # 設定内容: スキーマレジストリへの認証にLambdaが使用する認証タイプを指定します。
        type = "BASIC_AUTH"

        # uri (Optional)
        # 設定内容: スキーマレジストリへの認証に使用するシークレット（Secrets Manager シークレットARN）のURIを指定します。
        # 設定可能な値: 有効なSecrets ManagerシークレットのARN
        uri = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:example-secret"
      }

      # schema_validation_config (Optional)
      # 設定内容: スキーマ検証設定の繰り返しブロックです。
      schema_validation_config {

        # attribute (Optional)
        # 設定内容: 検証するメッセージ属性を指定します。
        # 設定可能な値:
        #   - "KEY": メッセージキーを検証
        #   - "VALUE": メッセージ値を検証
        attribute = "VALUE"
      }
    }
  }

  #-------------------------------------------------------------
  # ソースアクセス設定
  #-------------------------------------------------------------

  # source_access_configuration (Optional, 最大22個)
  # 設定内容: イベントソースのセキュリティ・VPCコンポーネント・仮想ホストの認証設定ブロックです。
  # 注意: セルフマネージドKafkaソースの場合はself_managed_event_sourceと共に必要
  # 参考: https://docs.aws.amazon.com/lambda/latest/api/API_SourceAccessConfiguration.html
  source_access_configuration {

    # type (Required)
    # 設定内容: 認証プロトコル、VPCコンポーネント、または仮想ホストのタイプを指定します。
    # 設定可能な値: VPC_SUBNET, VPC_SECURITY_GROUP, BASIC_AUTH, VIRTUAL_HOST,
    #   CLIENT_CERTIFICATE_TLS_AUTH, SERVER_ROOT_CA_CERTIFICATE 等
    # 参考: https://docs.aws.amazon.com/lambda/latest/api/API_SourceAccessConfiguration.html
    type = "VPC_SUBNET"

    # uri (Required)
    # 設定内容: この設定のURIを指定します。
    # 設定可能な値:
    #   - VPC_SUBNET の場合: "subnet:<subnet_id>"
    #   - VPC_SECURITY_GROUP の場合: "security_group:<security_group_id>"
    #   - BASIC_AUTH の場合: Secrets ManagerシークレットARN
    #   - VIRTUAL_HOST の場合: RabbitMQの仮想ホストパス（例: "/production"）
    uri = "subnet:${aws_subnet.example.id}"
  }

  #-------------------------------------------------------------
  # DocumentDB変更ストリーム設定
  #-------------------------------------------------------------

  # document_db_event_source_config (Optional)
  # 設定内容: DocumentDBイベントソースの設定ブロックです。
  document_db_event_source_config {

    # database_name (Required)
    # 設定内容: DocumentDBクラスター内で消費するデータベース名を指定します。
    # 設定可能な値: 有効なDocumentDBデータベース名
    database_name = "orders"

    # collection_name (Optional)
    # 設定内容: データベース内で消費するコレクション名を指定します。
    # 設定可能な値: 有効なコレクション名
    # 省略時: null（全コレクションを消費）
    collection_name = "transactions"

    # full_document (Optional)
    # 設定内容: ドキュメント更新操作時にDocumentDBがイベントストリームに送信する内容を指定します。
    # 設定可能な値:
    #   - "UpdateLookup": 変更の差分と共にドキュメント全体のコピーを送信
    #   - "Default": 変更部分のみを含む部分ドキュメントを送信
    # 省略時: "Default"
    full_document = "UpdateLookup"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: イベントソースマッピングのARN
# - function_arn: イベントを送信するLambda関数のARN（function_nameと異なる場合あり）
# - last_modified: イベントソースマッピングが最後に更新された日時
# - last_processing_result: Lambda関数の最後の呼び出し結果
# - state: イベントソースマッピングの現在の状態
# - state_transition_reason: 現在の状態になった理由
# - uuid: 作成されたイベントソースマッピングのUUID
# - tags_all: プロバイダーのdefault_tags設定から継承されたタグを含む全タグマップ
#---------------------------------------------------------------
