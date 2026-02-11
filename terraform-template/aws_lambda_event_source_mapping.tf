#---------------------------------------------------------------
# Lambda Event Source Mapping
#---------------------------------------------------------------
#
# AWS Lambda Event Source Mappingは、ストリームやキューベースのイベントソースと
# Lambda関数を接続するためのリソースです。このマッピングにより、DynamoDB Streams、
# Kinesis、SQS、Amazon MQ、MSK（Managed Streaming for Apache Kafka）、
# Self-Managed Kafka、DocumentDB Change Streamsなどのイベントソースから
# レコードを読み取り、Lambda関数を呼び出すことができます。
#
# Event Source Mappingは、イベントポーラーを使用してイベントソースから
# 新しいメッセージを継続的にポーリングし、バッチ単位でLambda関数を呼び出します。
# Lambda関数がエラーを返した場合、バッチ全体が成功するまで再処理されます。
#
# AWS公式ドキュメント:
#   - Event Source Mapping概要: https://docs.aws.amazon.com/lambda/latest/dg/invocation-eventsourcemapping.html
#   - CreateEventSourceMapping API: https://docs.aws.amazon.com/lambda/latest/api/API_CreateEventSourceMapping.html
#   - EventSourceMappingConfiguration: https://docs.aws.amazon.com/lambda/latest/api/API_EventSourceMappingConfiguration.html
#   - MSK Event Source: https://docs.aws.amazon.com/lambda/latest/dg/msk-esm-create.html
#   - Self-Managed Kafka: https://docs.aws.amazon.com/lambda/latest/dg/kafka-esm-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_event_source_mapping" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # Lambda関数の名前またはARN
  # イベントを受信するLambda関数を指定します。
  # 関数名、関数ARN、または部分ARN（バージョンやエイリアスを含む）を指定できます。
  function_name = "my-lambda-function"

  #---------------------------------------------------------------
  # イベントソースの設定
  #---------------------------------------------------------------

  # イベントソースのARN
  # Kinesis、DynamoDB Streams、SQS、MQ、MSK、DocumentDBの場合に必須です。
  # Self-Managed Kafkaの場合は指定しません（self_managed_event_sourceを使用）。
  event_source_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/my-stream"

  # イベントソースから読み取りを開始する位置
  # Kinesis、DynamoDB、MSK、Self-Managed Kafkaの場合に使用します。
  # 有効な値: "LATEST", "TRIM_HORIZON", "AT_TIMESTAMP"
  # - LATEST: 最新のレコードから開始
  # - TRIM_HORIZON: 最も古い利用可能なレコードから開始
  # - AT_TIMESTAMP: 特定のタイムスタンプから開始（Kinesisのみ）
  # SQSの場合は指定しません。
  starting_position = "LATEST"

  # 読み取り開始タイムスタンプ（RFC3339形式）
  # starting_positionが"AT_TIMESTAMP"の場合にのみ使用します。
  # 指定したタイムスタンプのレコードが存在しない場合は、次の新しいレコードから開始します。
  # タイムスタンプがTrim Horizonより古い場合は、最も古い利用可能なレコードから開始します。
  # starting_position_timestamp = "2024-01-01T00:00:00Z"

  #---------------------------------------------------------------
  # バッチ処理の設定
  #---------------------------------------------------------------

  # バッチサイズ（レコード数）
  # Lambdaがイベントソースから一度に取得するレコードの最大数です。
  # デフォルト値:
  # - DynamoDB、Kinesis、MQ、MSK: 100
  # - SQS: 10
  batch_size = 100

  # 最大バッチウィンドウ（秒）
  # レコードを収集してから関数を呼び出すまでの最大待機時間（0〜300秒）
  # バッチウィンドウが期限切れになるか、batch_sizeに達するまでレコードを収集します。
  # ストリームソース（DynamoDB、Kinesis）とSQS標準キューで使用可能です。
  # デフォルトでは、ストリームソースではレコードが利用可能になり次第呼び出されます。
  # maximum_batching_window_in_seconds = 5

  #---------------------------------------------------------------
  # 並列処理の設定
  #---------------------------------------------------------------

  # 並列化ファクター
  # 各シャードから同時に処理するバッチ数（1〜10）
  # ストリームソース（DynamoDB、Kinesis）でのみ使用可能です。
  # デフォルト値: 1
  # parallelization_factor = 1

  #---------------------------------------------------------------
  # エラー処理の設定
  #---------------------------------------------------------------

  # 関数エラー時にバッチを2つに分割して再試行するかどうか
  # ストリームソース（DynamoDB、Kinesis）でのみ使用可能です。
  # デフォルト値: false
  # bisect_batch_on_function_error = false

  # レコードの最大経過時間（秒）
  # Lambdaが関数に送信するレコードの最大経過時間です。
  # この時間より古いレコードは処理されません。
  # ストリームソース（DynamoDB、Kinesis）でのみ使用可能です。
  # -1（永続、デフォルト）または60〜604800秒の範囲で指定します。
  # maximum_record_age_in_seconds = -1

  # 最大再試行回数
  # 関数がエラーを返した際の最大再試行回数です。
  # ストリームソース（DynamoDB、Kinesis）でのみ使用可能です。
  # -1（永続、デフォルト）または0〜10000の範囲で指定します。
  # maximum_retry_attempts = -1

  #---------------------------------------------------------------
  # 失敗時の送信先設定
  #---------------------------------------------------------------

  # 失敗したレコードの送信先設定
  # ストリームソース（DynamoDB、Kinesis）とKafkaソース（MSK、Self-Managed）で使用可能です。
  # 失敗したレコードをSQSキュー、SNSトピック、またはS3バケット（Kafkaのみ）に送信できます。
  # destination_config {
  #   on_failure {
  #     # 送信先のARN
  #     # SQS/SNSの場合: 通常のARN
  #     # MSK/Self-Managed Kafkaの場合: "kafka://your-topic-name"形式も可能
  #     destination_arn = "arn:aws:sqs:us-east-1:123456789012:dlq"
  #   }
  # }

  #---------------------------------------------------------------
  # Lambda Checkpointing設定
  #---------------------------------------------------------------

  # 関数のレスポンスタイプ
  # AWS Lambda Checkpointingに使用される現在のレスポンスタイプのリストです。
  # SQSおよびストリームソース（DynamoDB、Kinesis）で使用可能です。
  # 有効な値: ["ReportBatchItemFailures"]
  # function_response_types = ["ReportBatchItemFailures"]

  #---------------------------------------------------------------
  # イベントフィルタリング
  #---------------------------------------------------------------

  # フィルタ条件
  # イベントをフィルタリングするための条件を指定します。
  # Kinesis、DynamoDB、SQSイベントソースで使用可能です。
  # 最大5つのフィルタを設定でき、少なくとも1つを満たすイベントが処理されます。
  # filter_criteria {
  #   filter {
  #     # フィルタパターン（最大4096文字）
  #     # JSON形式でフィルタルールを定義します。
  #     # 詳細: https://docs.aws.amazon.com/lambda/latest/dg/invocation-eventfiltering.html#filtering-syntax
  #     pattern = jsonencode({
  #       body = {
  #         Temperature = [{ numeric = [">", 0, "<=", 100] }]
  #         Location    = ["New York"]
  #       }
  #     })
  #   }
  # }

  #---------------------------------------------------------------
  # ストリーム分析設定
  #---------------------------------------------------------------

  # タンブリングウィンドウ（秒）
  # AWS Lambda Streaming Analyticsの処理ウィンドウの期間（1〜900秒）
  # ストリームソース（DynamoDB、Kinesis）でのみ使用可能です。
  # tumbling_window_in_seconds = 60

  #---------------------------------------------------------------
  # 暗号化設定
  #---------------------------------------------------------------

  # KMSキーのARN
  # Lambdaがフィルタ条件の暗号化に使用するKMSカスタマーマネージドキーのARNです。
  # kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #---------------------------------------------------------------
  # メトリクス設定
  #---------------------------------------------------------------

  # CloudWatchメトリクス設定
  # イベントソースのメトリクス設定です。
  # ストリームソース（DynamoDB、Kinesis）とSQSキューで使用可能です。
  # metrics_config {
  #   # 生成するメトリクスのリスト
  #   # 有効な値: ["EventCount"]
  #   metrics = ["EventCount"]
  # }

  #---------------------------------------------------------------
  # SQS固有の設定
  #---------------------------------------------------------------

  # スケーリング設定
  # SQSキューでのみ使用可能なスケーリング設定です。
  # scaling_config {
  #   # 最大同時実行数
  #   # SQSイベントソースが呼び出せる同時インスタンスの最大数（2以上）
  #   # 1000を超える場合はService Quota増加申請が必要です。
  #   # 詳細: https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html#events-sqs-max-concurrency
  #   maximum_concurrency = 100
  # }

  #---------------------------------------------------------------
  # Amazon MQ固有の設定
  #---------------------------------------------------------------

  # MQキュー名
  # Amazon MQブローカーの宛先キュー名です。
  # MQソースでのみ使用可能です。正確に1つのキュー名を指定する必要があります。
  # queues = ["orders"]

  #---------------------------------------------------------------
  # Kafka固有の設定
  #---------------------------------------------------------------

  # Kafkaトピック名
  # Kafkaトピックの名前です。MSKソースでのみ使用可能です。
  # 単一のトピック名を指定する必要があります。
  # topics = ["orders"]

  #---------------------------------------------------------------
  # Amazon MSK固有の設定
  #---------------------------------------------------------------

  # Amazon MSKイベントソース設定
  # Amazon MSKソース固有の追加設定です。
  # self_managed_event_sourceおよびself_managed_kafka_event_source_configとは互換性がありません。
  # amazon_managed_kafka_event_source_config {
  #   # コンシューマーグループID（1〜200文字）
  #   # 指定しない場合は自動生成されます。
  #   # 詳細: https://docs.aws.amazon.com/lambda/latest/dg/API_AmazonManagedKafkaEventSourceConfig.html
  #   consumer_group_id = "lambda-consumer-group"
  #
  #   # Kafkaスキーマレジストリ設定
  #   schema_registry_config {
  #     # レコードフォーマット
  #     # スキーマ検証後にLambdaが関数に配信するレコード形式です。
  #     # 有効な値: "JSON", "SOURCE"
  #     event_record_format = "JSON"
  #
  #     # スキーマレジストリのURI
  #     # AWS Glueの場合: レジストリのARN
  #     # Confluentの場合: レジストリURL
  #     schema_registry_uri = "arn:aws:glue:us-east-1:123456789012:registry/my-registry"
  #   }
  # }

  #---------------------------------------------------------------
  # Self-Managed Kafka固有の設定
  #---------------------------------------------------------------

  # Self-Managed Kafkaイベントソース
  # Self-Managed Kafkaクラスターの場所を指定します。
  # 設定する場合、source_access_configurationも必須です。
  # self_managed_event_source {
  #   # エンドポイント
  #   # Kafkaの場合、キーは"KAFKA_BOOTSTRAP_SERVERS"、値はカンマ区切りのブローカーエンドポイントです。
  #   endpoints = {
  #     KAFKA_BOOTSTRAP_SERVERS = "kafka1.example.com:9092,kafka2.example.com:9092"
  #   }
  # }

  # Self-Managed Kafkaイベントソース設定
  # Self-Managed Kafkaソース固有の追加設定です。
  # event_source_arnおよびamazon_managed_kafka_event_source_configとは互換性がありません。
  # self_managed_kafka_event_source_config {
  #   # コンシューマーグループID（1〜200文字）
  #   # 指定しない場合は自動生成されます。
  #   # 詳細: https://docs.aws.amazon.com/lambda/latest/dg/API_SelfManagedKafkaEventSourceConfig.html
  #   consumer_group_id = "lambda-consumer-group"
  #
  #   # Kafkaスキーマレジストリ設定
  #   schema_registry_config {
  #     # レコードフォーマット
  #     event_record_format = "JSON"
  #
  #     # スキーマレジストリのURI
  #     schema_registry_uri = "arn:aws:glue:us-east-1:123456789012:registry/my-registry"
  #   }
  # }

  #---------------------------------------------------------------
  # ソースアクセス設定
  #---------------------------------------------------------------

  # ソースアクセス設定
  # 認証プロトコル、VPCコンポーネント、または仮想ホストを指定します。
  # Self-Managed Kafkaの場合、self_managed_event_sourceと併用必須です。
  # 複数のsource_access_configurationブロックを指定できます。
  # source_access_configuration {
  #   # 認証タイプ
  #   # 有効な値の詳細: https://docs.aws.amazon.com/lambda/latest/api/API_SourceAccessConfiguration.html
  #   # 例: "VPC_SUBNET", "VPC_SECURITY_GROUP", "BASIC_AUTH", "SASL_SCRAM_512_AUTH", "VIRTUAL_HOST"
  #   type = "VPC_SUBNET"
  #
  #   # URI
  #   # VPC_SUBNETの場合: "subnet:subnet_id"形式
  #   # VPC_SECURITY_GROUPの場合: "security_group:security_group_id"形式
  #   # BASIC_AUTHの場合: Secrets ManagerシークレットのARN
  #   uri = "subnet:subnet-12345678"
  # }

  #---------------------------------------------------------------
  # Provisioned Pollerモード設定
  #---------------------------------------------------------------

  # Provisioned Poller設定
  # イベントポーラーの設定です。
  # Amazon MSKまたはSelf-Managed Kafkaソースでのみ使用可能です。
  # provisioned_poller_config {
  #   # 最大ポーラー数（1〜2000）
  #   # このイベントソースがスケールアップできる最大イベントポーラー数です。
  #   maximum_pollers = 100
  #
  #   # 最小ポーラー数（1〜200）
  #   # このイベントソースがスケールダウンできる最小イベントポーラー数です。
  #   minimum_pollers = 10
  #
  #   # ポーラーグループ名
  #   # イベントソースのVPC内で複数のESMをグループ化してEPU容量を共有するための名前です。
  #   # Provisionedモードのコストを最適化できます。
  #   # グループあたり最大100のESMをグループ化でき、グループ内の全ESMの最大ポーラー数の合計は2000を超えられません。
  #   poller_group_name = "group-123"
  # }

  #---------------------------------------------------------------
  # DocumentDB固有の設定
  #---------------------------------------------------------------

  # DocumentDBイベントソース設定
  # DocumentDB Change Streamソースの設定です。
  # document_db_event_source_config {
  #   # データベース名（必須）
  #   # DocumentDBクラスター内で使用するデータベース名です。
  #   database_name = "orders"
  #
  #   # コレクション名
  #   # データベース内で使用するコレクション名です。
  #   # 指定しない場合、すべてのコレクションを使用します。
  #   collection_name = "transactions"
  #
  #   # フルドキュメント
  #   # ドキュメント更新操作中にDocumentDBがイベントストリームに送信する内容を決定します。
  #   # UpdateLookup: 変更を記述するデルタと、ドキュメント全体のコピーを送信
  #   # Default: 変更を含む部分ドキュメントのみを送信
  #   # 有効な値: "UpdateLookup", "Default"
  #   full_document = "UpdateLookup"
  # }

  #---------------------------------------------------------------
  # その他の設定
  #---------------------------------------------------------------

  # マッピングを有効にするかどうか
  # デフォルト値: true
  enabled = true

  # リージョン
  # このリソースが管理されるリージョンです。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # region = "us-east-1"

  # リソースID
  # 通常は指定不要です（自動生成されます）。
  # インポート時やステート管理で明示的に指定する必要がある場合のみ使用します。
  # id = "event-source-mapping-uuid"

  # タグ
  # リソースに割り当てるタグのマップです。
  tags = {
    Name        = "my-event-source-mapping"
    Environment = "production"
  }

  # tags_all
  # プロバイダーのdefault_tagsとリソース固有のtagsを統合したタグのマップです。
  # 通常は指定不要です（自動計算されます）。
  # 明示的に全タグを上書きする必要がある場合のみ使用します。
  # tags_all = {
  #   Name        = "my-event-source-mapping"
  #   Environment = "production"
  #   ManagedBy   = "terraform"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（読み取り専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（設定不可）:
#
# - arn                    : Event Source MappingのARN
# - function_arn           : Lambda関数のARN（function_nameとは異なる計算値）
# - last_modified          : このリソースが最後に変更された日時
# - last_processing_result : 最後のLambda関数呼び出しの結果
# - state                  : Event Source Mappingの状態
# - state_transition_reason: 現在の状態になった理由
# - tags_all               : リソースに割り当てられたタグのマップ（プロバイダーのdefault_tagsを含む）
# - uuid                   : 作成されたEvent Source MappingのUUID
#
# 参照例:
# output "event_source_mapping_arn" {
#   value = aws_lambda_event_source_mapping.example.arn
# }
#---------------------------------------------------------------
