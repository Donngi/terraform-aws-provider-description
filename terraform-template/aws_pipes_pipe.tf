#---------------------------------------------------------------
# Amazon EventBridge Pipes
#---------------------------------------------------------------
#
# EventBridge Pipesは、イベントソースとターゲット間のポイントツーポイント統合を実現するサービスです。
# イベントのフィルタリング、変換、エンリッチメント機能を提供し、
# SQS、Kinesis、DynamoDB Streams、Kafka等からイベントを受信し、
# Lambda、Step Functions、ECSタスク、EventBridge Event Bus等に配信します。
#
# AWS公式ドキュメント:
#   - Amazon EventBridge Pipes: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-pipes.html
#   - EventBridge Pipes concepts: https://docs.aws.amazon.com/eventbridge/latest/userguide/pipes-concepts.html
#   - Event enrichment: https://docs.aws.amazon.com/eventbridge/latest/userguide/pipes-enrichment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pipes_pipe
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pipes_pipe" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # role_arn - (必須) パイプがターゲットにデータを送信するために使用するIAMロールのARN
  # パイプはソースからのイベント読み取り、エンリッチメント呼び出し、ターゲット呼び出しの
  # 各操作に必要な権限を持つロールを必要とします。
  # 例: "arn:aws:iam::123456789012:role/service-role/EventBridge-Pipe-Role"
  role_arn = "arn:aws:iam::123456789012:role/example-pipe-role"

  # source - (必須) パイプのソースリソース（通常はARN）
  # セルフマネージドKafkaクラスターを使用する場合は、ARNの代わりに
  # 'smk://' + ブートストラップサーバーのアドレス を使用します。
  # サポートされるソース:
  #   - Amazon SQS queue
  #   - Amazon Kinesis stream
  #   - Amazon DynamoDB stream
  #   - Amazon MQ (ActiveMQ/RabbitMQ)
  #   - Amazon MSK (Managed Streaming for Apache Kafka)
  #   - Self-managed Apache Kafka
  # 例: "arn:aws:sqs:us-east-1:123456789012:source-queue"
  source = "arn:aws:sqs:us-east-1:123456789012:source-queue"

  # target - (必須) パイプのターゲットリソース（通常はARN）
  # サポートされるターゲット:
  #   - AWS Batch job queue
  #   - Amazon CloudWatch Logs log group
  #   - Amazon ECS task
  #   - Amazon EventBridge event bus
  #   - API Gateway REST API/EventBridge API destination
  #   - Amazon Kinesis stream
  #   - AWS Lambda function
  #   - Amazon Redshift cluster
  #   - Amazon SageMaker Pipeline
  #   - Amazon SQS queue
  #   - AWS Step Functions state machine
  # 例: "arn:aws:sqs:us-east-1:123456789012:target-queue"
  target = "arn:aws:sqs:us-east-1:123456789012:target-queue"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # name - (オプション) パイプの名前
  # 省略するとTerraformがランダムな一意の名前を割り当てます。
  # name_prefixと競合するため、両方は指定できません。
  # 例: "order-processing-pipe"
  name = "example-pipe"

  # name_prefix - (オプション) 指定されたプレフィックスで始まる一意の名前を生成
  # nameと競合するため、両方は指定できません。
  # 例: "app-pipe-"
  # name_prefix = "example-"

  # description - (オプション) パイプの説明（最大512文字）
  # 例: "Processes order events from SQS to Lambda"
  description = "Example pipe for event processing"

  # desired_state - (オプション) パイプの望ましい状態
  # 有効な値: RUNNING, STOPPED
  # デフォルト: RUNNING
  # 例: "RUNNING"
  desired_state = "RUNNING"

  # enrichment - (オプション) パイプのエンリッチメントリソース（通常はARN）
  # エンリッチメントは、ソースからのデータをターゲットに送信する前に強化します。
  # サポートされるエンリッチメント:
  #   - Lambda function
  #   - Step Functions state machine (Express workflow)
  #   - API Gateway REST API
  #   - EventBridge API destination
  # エンリッチメントは同期的に呼び出され、レスポンスサイズは最大6MBです。
  # 例: "arn:aws:lambda:us-east-1:123456789012:function:enrich-data"
  # enrichment = "arn:aws:lambda:us-east-1:123456789012:function:example-enrichment"

  # kms_key_identifier - (オプション) パイプデータの暗号化に使用するKMSキーの識別子
  # 指定可能な識別子:
  #   - Key ARN
  #   - Key ID
  #   - Key alias
  #   - Key alias ARN
  # 指定しない場合、EventBridgeはAWS所有のキーを使用してパイプデータを暗号化します。
  # 例: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  # kms_key_identifier = "alias/example-key"

  # region - (オプション) リソースが管理されるリージョン
  # プロバイダー設定で指定されたリージョンがデフォルトとして使用されます。
  # 例: "us-east-1"
  # region = "us-east-1"

  # tags - (オプション) リソースのタグ（キーと値のマッピング）
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  tags = {
    Environment = "production"
    Application = "event-processing"
    ManagedBy   = "terraform"
  }

  #---------------------------------------------------------------
  # エンリッチメントパラメータ
  # enrichment_parameters - エンリッチメント設定（enrichment指定時に使用）
  #---------------------------------------------------------------

  # enrichment_parameters {
  #   # input_template - (オプション) ターゲットに渡される有効なJSONテキスト（最大8192文字）
  #   # 指定した場合、イベント自体の内容は送信されません。
  #   # 例: "{\"order_id\": <$.detail.order_id>, \"timestamp\": <$.time>}"
  #   # input_template = "{\"data\": <$.body>}"
  #
  #   # http_parameters - (オプション) HTTPエンリッチメント用のパラメータ
  #   # API Gateway REST APIまたはEventBridge API Destinationがエンリッチメントの場合に使用
  #   # http_parameters {
  #     # header_parameters - (オプション) リクエストヘッダーのキーと値のマッピング
  #     # 例: {"Authorization" = "Bearer token", "Content-Type" = "application/json"}
  #     # header_parameters = {
  #     #   "X-Custom-Header" = "value"
  #     # }
  #
  #     # path_parameter_values - (オプション) パスパラメータ値のリスト
  #     # API GatewayまたはAPI Destinationのパスワイルドカード("*")を置換します。
  #     # 例: ["orders", "12345"]
  #     # path_parameter_values = ["example-path"]
  #
  #     # query_string_parameters - (オプション) クエリ文字列パラメータのキーと値のマッピング
  #     # 例: {"filter" = "active", "limit" = "100"}
  #     # query_string_parameters = {
  #     #   "param1" = "value1"
  #     # }
  #   # }
  # }

  #---------------------------------------------------------------
  # ログ設定
  # log_configuration - パイプのロギング設定
  #---------------------------------------------------------------

  # log_configuration {
  #   # level - (必須) ロギング詳細レベル
  #   # 有効な値: OFF, ERROR, INFO, TRACE
  #   # OFF: ロギングなし
  #   # ERROR: エラーのみ記録
  #   # INFO: 情報とエラーを記録
  #   # TRACE: すべての実行詳細を記録
  #   # 例: "INFO"
  #   level = "INFO"
  #
  #   # include_execution_data - (オプション) 実行データをログに含めるかを指定
  #   # 実行データには payload, awsRequest, awsResponse フィールドが含まれます。
  #   # 有効な値: ["ALL"]
  #   # 例: ["ALL"]
  #   # include_execution_data = ["ALL"]
  #
  #   # cloudwatch_logs_log_destination - (オプション) CloudWatch Logsログ送信先
  #   # cloudwatch_logs_log_destination {
  #     # log_group_arn - (必須) CloudWatch LogグループのARN
  #     # EventBridgeがログレコードを送信する先のロググループ
  #     # 例: "arn:aws:logs:us-east-1:123456789012:log-group:/aws/events/pipes/example-pipe"
  #     # log_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:example-log-group"
  #   # }
  #
  #   # firehose_log_destination - (オプション) Kinesis Data Firehoseログ送信先
  #   # firehose_log_destination {
  #     # delivery_stream_arn - (必須) Kinesis Data Firehose配信ストリームのARN
  #     # EventBridgeがログレコードを配信する先のストリーム
  #     # 例: "arn:aws:firehose:us-east-1:123456789012:deliverystream/example-stream"
  #     # delivery_stream_arn = "arn:aws:firehose:us-east-1:123456789012:deliverystream:example-stream"
  #   # }
  #
  #   # s3_log_destination - (オプション) S3ログ送信先
  #   # s3_log_destination {
  #     # bucket_name - (必須) ログレコードの配信先S3バケット名
  #     # 例: "example-pipe-logs"
  #     # bucket_name = "example-logs-bucket"
  #
  #     # bucket_owner - (必須) S3バケットを所有するAWSアカウントID
  #     # 例: "123456789012"
  #     # bucket_owner = "123456789012"
  #
  #     # output_format - (オプション) ログレコードのEventBridge形式
  #     # 有効な値: json, plain, w3c
  #     # デフォルト: json
  #     # 例: "json"
  #     # output_format = "json"
  #
  #     # prefix - (オプション) S3ログオブジェクト名の先頭に付けるプレフィックステキスト
  #     # 例: "pipes/example-pipe/"
  #     # prefix = "logs/"
  #   # }
  # }

  #---------------------------------------------------------------
  # ソースパラメータ
  # source_parameters - ソースの設定
  #---------------------------------------------------------------

  # source_parameters {
  #   # filter_criteria - (オプション) イベントフィルタリング用のイベントパターンのコレクション
  #   # 最大5つのフィルターを指定可能
  #   # filter_criteria {
  #     # filter - (オプション) 最大5つのイベントパターン配列
  #     # filter {
  #       # pattern - (必須) イベントパターン（最大4096文字）
  #       # JSONエンコードされたイベントパターン
  #       # 例: jsonencode({"source" = ["event-source"], "detail-type" = ["order-placed"]})
  #       # pattern = jsonencode({
  #       #   source = ["aws.s3"]
  #       # })
  #     # }
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # SQS Queue Parameters
  #   #-----------------------------------------------------------
  #   # sqs_queue_parameters - (オプション) Amazon SQSキューソースのパラメータ
  #   # sqs_queue_parameters {
  #     # batch_size - (オプション) 各バッチに含める最大レコード数（最大10000）
  #     # デフォルト: 10
  #     # 例: 10
  #     # batch_size = 10
  #
  #     # maximum_batching_window_in_seconds - (オプション) イベント待機の最大時間（秒）
  #     # 最大300秒
  #     # デフォルト: 0
  #     # 例: 5
  #     # maximum_batching_window_in_seconds = 5
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # Kinesis Stream Parameters
  #   #-----------------------------------------------------------
  #   # kinesis_stream_parameters - (オプション) Kinesisストリームソースのパラメータ
  #   # kinesis_stream_parameters {
  #     # starting_position - (必須) ストリーム読み取り開始位置
  #     # 有効な値: TRIM_HORIZON, LATEST, AT_TIMESTAMP
  #     # TRIM_HORIZON: 保持期間内の最も古いレコードから開始
  #     # LATEST: 最新のレコードから開始
  #     # AT_TIMESTAMP: starting_position_timestampで指定された時刻から開始
  #     # 例: "LATEST"
  #     # starting_position = "LATEST"
  #
  #     # starting_position_timestamp - (オプション) AT_TIMESTAMP使用時の開始時刻
  #     # Unixエポック秒形式
  #     # 例: "2024-01-01T00:00:00Z"
  #     # starting_position_timestamp = "2024-01-01T00:00:00Z"
  #
  #     # batch_size - (オプション) 各バッチに含める最大レコード数（最大10000）
  #     # デフォルト: 100
  #     # batch_size = 100
  #
  #     # maximum_batching_window_in_seconds - (オプション) イベント待機の最大時間（秒）
  #     # 最大300秒
  #     # maximum_batching_window_in_seconds = 5
  #
  #     # maximum_record_age_in_seconds - (オプション) 指定された経過時間より古いレコードを破棄
  #     # -1は無限（レコードを破棄しない）、最大604,800秒（7日間）
  #     # デフォルト: -1
  #     # maximum_record_age_in_seconds = -1
  #
  #     # maximum_retry_attempts - (オプション) 指定された再試行回数後にレコードを破棄
  #     # -1は無限再試行、最大10,000回
  #     # デフォルト: -1
  #     # maximum_retry_attempts = -1
  #
  #     # on_partial_batch_item_failure - (オプション) アイテム処理失敗時の処理方法
  #     # 有効な値: AUTOMATIC_BISECT
  #     # AUTOMATIC_BISECT: バッチを半分に分割して各半分を再試行
  #     # on_partial_batch_item_failure = "AUTOMATIC_BISECT"
  #
  #     # parallelization_factor - (オプション) 各シャードから同時処理するバッチ数
  #     # デフォルト: 1、最大10
  #     # parallelization_factor = 1
  #
  #     # dead_letter_config - (オプション) デッドレターキュー設定
  #     # dead_letter_config {
  #       # arn - (オプション) デッドレターキューとして指定されたSQSキューのARN
  #       # 例: "arn:aws:sqs:us-east-1:123456789012:dlq"
  #       # arn = "arn:aws:sqs:us-east-1:123456789012:example-dlq"
  #     # }
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # DynamoDB Stream Parameters
  #   #-----------------------------------------------------------
  #   # dynamodb_stream_parameters - (オプション) DynamoDB Streamsソースのパラメータ
  #   # kinesis_stream_parametersと同様の設定項目を持ちます
  #   # dynamodb_stream_parameters {
  #     # starting_position - (必須) ストリーム読み取り開始位置
  #     # 有効な値: TRIM_HORIZON, LATEST
  #     # starting_position = "LATEST"
  #
  #     # batch_size - (オプション) 各バッチの最大レコード数（最大10000）
  #     # batch_size = 100
  #
  #     # maximum_batching_window_in_seconds - (オプション) イベント待機の最大時間（最大300秒）
  #     # maximum_batching_window_in_seconds = 5
  #
  #     # maximum_record_age_in_seconds - (オプション) レコード経過時間の上限（最大604,800秒、-1は無限）
  #     # maximum_record_age_in_seconds = -1
  #
  #     # maximum_retry_attempts - (オプション) 最大再試行回数（最大10,000、-1は無限）
  #     # maximum_retry_attempts = -1
  #
  #     # on_partial_batch_item_failure - (オプション) 部分失敗時の処理（AUTOMATIC_BISECT）
  #     # on_partial_batch_item_failure = "AUTOMATIC_BISECT"
  #
  #     # parallelization_factor - (オプション) シャードあたりの並列バッチ数（最大10）
  #     # parallelization_factor = 1
  #
  #     # dead_letter_config - (オプション) デッドレターキュー設定
  #     # dead_letter_config {
  #       # arn - (オプション) デッドレターキュー用SQS ARN
  #       # arn = "arn:aws:sqs:us-east-1:123456789012:example-dlq"
  #     # }
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # ActiveMQ Broker Parameters
  #   #-----------------------------------------------------------
  #   # activemq_broker_parameters - (オプション) ActiveMQブローカーソースのパラメータ
  #   # activemq_broker_parameters {
  #     # queue_name - (必須) 消費する宛先キュー名（最大1000文字）
  #     # 例: "order-queue"
  #     # queue_name = "example-queue"
  #
  #     # credentials - (必須) リソースアクセスに必要な認証情報
  #     # credentials {
  #       # basic_auth - (必須) Basic認証情報を含むSecrets Manager SecretのARN
  #       # 例: "arn:aws:secretsmanager:us-east-1:123456789012:secret:activemq-creds-AbCdEf"
  #       # basic_auth = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example-secret"
  #     # }
  #
  #     # batch_size - (オプション) 各バッチの最大レコード数（最大10000）
  #     # batch_size = 10
  #
  #     # maximum_batching_window_in_seconds - (オプション) イベント待機の最大時間（最大300秒）
  #     # maximum_batching_window_in_seconds = 5
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # RabbitMQ Broker Parameters
  #   #-----------------------------------------------------------
  #   # rabbitmq_broker_parameters - (オプション) RabbitMQブローカーソースのパラメータ
  #   # rabbitmq_broker_parameters {
  #     # queue_name - (必須) 消費する宛先キュー名（最大1000文字）
  #     # queue_name = "example-queue"
  #
  #     # credentials - (必須) リソースアクセスに必要な認証情報
  #     # credentials {
  #       # basic_auth - (必須) Basic認証情報を含むSecrets Manager SecretのARN
  #       # basic_auth = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example-secret"
  #     # }
  #
  #     # virtual_host - (オプション) ソースブローカーに関連付けられた仮想ホスト名（最大200文字）
  #     # virtual_host = "/"
  #
  #     # batch_size - (オプション) 各バッチの最大レコード数（最大10000）
  #     # batch_size = 10
  #
  #     # maximum_batching_window_in_seconds - (オプション) イベント待機の最大時間（最大300秒）
  #     # maximum_batching_window_in_seconds = 5
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # Managed Streaming for Kafka (MSK) Parameters
  #   #-----------------------------------------------------------
  #   # managed_streaming_kafka_parameters - (オプション) MSKストリームソースのパラメータ
  #   # managed_streaming_kafka_parameters {
  #     # topic_name - (必須) パイプが読み取るトピック名（最大249文字）
  #     # 例: "orders-topic"
  #     # topic_name = "example-topic"
  #
  #     # starting_position - (オプション) ストリーム読み取り開始位置
  #     # 有効な値: TRIM_HORIZON, LATEST
  #     # starting_position = "LATEST"
  #
  #     # batch_size - (オプション) 各バッチの最大レコード数（最大10000）
  #     # batch_size = 100
  #
  #     # maximum_batching_window_in_seconds - (オプション) イベント待機の最大時間（最大300秒）
  #     # maximum_batching_window_in_seconds = 5
  #
  #     # consumer_group_id - (オプション) コンシューマーグループID（最大200文字）
  #     # consumer_group_id = "example-consumer-group"
  #
  #     # credentials - (オプション) リソースアクセスに必要な認証情報
  #     # credentials {
  #       # client_certificate_tls_auth - (オプション) 認証情報を含むSecrets Manager SecretのARN
  #       # client_certificate_tls_auth = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example-secret"
  #
  #       # sasl_scram_512_auth - (オプション) SASL/SCRAM-512認証情報を含むSecrets Manager SecretのARN
  #       # sasl_scram_512_auth = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example-secret"
  #     # }
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # Self-managed Kafka Parameters
  #   #-----------------------------------------------------------
  #   # self_managed_kafka_parameters - (オプション) セルフマネージドKafkaソースのパラメータ
  #   # self_managed_kafka_parameters {
  #     # topic_name - (必須) パイプが読み取るトピック名（最大249文字）
  #     # topic_name = "example-topic"
  #
  #     # starting_position - (オプション) ストリーム読み取り開始位置
  #     # 有効な値: TRIM_HORIZON, LATEST
  #     # starting_position = "LATEST"
  #
  #     # batch_size - (オプション) 各バッチの最大レコード数（最大10000）
  #     # batch_size = 100
  #
  #     # maximum_batching_window_in_seconds - (オプション) イベント待機の最大時間（最大300秒）
  #     # maximum_batching_window_in_seconds = 5
  #
  #     # consumer_group_id - (オプション) コンシューマーグループID（最大200文字）
  #     # consumer_group_id = "example-consumer-group"
  #
  #     # additional_bootstrap_servers - (オプション) 追加のサーバーURL配列
  #     # 最大2項目、各項目は最大300文字
  #     # additional_bootstrap_servers = ["kafka-broker-2:9092"]
  #
  #     # server_root_ca_certificate - (オプション) 証明書検証用Secrets Manager SecretのARN
  #     # server_root_ca_certificate = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example-ca-cert"
  #
  #     # credentials - (オプション) リソースアクセスに必要な認証情報
  #     # credentials {
  #       # basic_auth - (オプション) Basic認証情報を含むSecrets Manager SecretのARN
  #       # basic_auth = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example-secret"
  #
  #       # client_certificate_tls_auth - (オプション) TLS証明書を含むSecrets Manager SecretのARN
  #       # client_certificate_tls_auth = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example-secret"
  #
  #       # sasl_scram_256_auth - (オプション) SASL/SCRAM-256認証情報を含むSecrets Manager SecretのARN
  #       # sasl_scram_256_auth = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example-secret"
  #
  #       # sasl_scram_512_auth - (オプション) SASL/SCRAM-512認証情報を含むSecrets Manager SecretのARN
  #       # sasl_scram_512_auth = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example-secret"
  #     # }
  #
  #     # vpc - (オプション) VPCサブネットとセキュリティグループの設定
  #     # vpc {
  #       # subnets - (オプション) ストリームに関連付けられたサブネットのリスト
  #       # 最大16サブネット、すべて同じVPC内である必要があります
  #       # subnets = ["subnet-12345678", "subnet-87654321"]
  #
  #       # security_groups - (オプション) ストリームに関連付けられたセキュリティグループのリスト
  #       # 最大5セキュリティグループ、すべて同じVPC内である必要があります
  #       # 指定しない場合、VPCのデフォルトセキュリティグループが使用されます
  #       # security_groups = ["sg-12345678"]
  #     # }
  #   # }
  # }

  #---------------------------------------------------------------
  # ターゲットパラメータ
  # target_parameters - ターゲットの設定
  #---------------------------------------------------------------

  # target_parameters {
  #   # input_template - (オプション) ターゲットに渡される有効なJSONテキスト（最大8192文字）
  #   # 指定した場合、イベント自体の内容は送信されません。
  #   # 例: "{\"message\": <$.body>, \"timestamp\": <$.timestamp>}"
  #   # input_template = "{\"data\": <$.body>}"
  #
  #   #-----------------------------------------------------------
  #   # SQS Queue Parameters
  #   #-----------------------------------------------------------
  #   # sqs_queue_parameters - (オプション) Amazon SQSキューターゲットのパラメータ
  #   # sqs_queue_parameters {
  #     # message_group_id - (オプション) ターゲットとして使用するFIFOメッセージグループID
  #     # FIFO（先入れ先出し）キューの場合に使用
  #     # 例: "order-group-1"
  #     # message_group_id = "example-group"
  #
  #     # message_deduplication_id - (オプション) 送信メッセージの重複排除に使用するトークン
  #     # FIFOキューの場合にのみ適用
  #     # 例: "order-12345"
  #     # message_deduplication_id = "example-dedupe-id"
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # Lambda Function Parameters
  #   #-----------------------------------------------------------
  #   # lambda_function_parameters - (オプション) Lambda関数ターゲットのパラメータ
  #   # lambda_function_parameters {
  #     # invocation_type - (オプション) 関数の呼び出しタイプ
  #     # 有効な値: REQUEST_RESPONSE, FIRE_AND_FORGET
  #     # REQUEST_RESPONSE: 同期呼び出し（レスポンスを待つ）
  #     # FIRE_AND_FORGET: 非同期呼び出し（レスポンスを待たない）
  #     # デフォルト: REQUEST_RESPONSE
  #     # 例: "REQUEST_RESPONSE"
  #     # invocation_type = "REQUEST_RESPONSE"
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # Step Functions State Machine Parameters
  #   #-----------------------------------------------------------
  #   # step_function_state_machine_parameters - (オプション) Step Functionsステートマシンターゲットのパラメータ
  #   # step_function_state_machine_parameters {
  #     # invocation_type - (オプション) ステートマシンの呼び出しタイプ
  #     # 有効な値: REQUEST_RESPONSE, FIRE_AND_FORGET
  #     # invocation_type = "FIRE_AND_FORGET"
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # Kinesis Stream Parameters
  #   #-----------------------------------------------------------
  #   # kinesis_stream_parameters - (オプション) Kinesisストリームターゲットのパラメータ
  #   # kinesis_stream_parameters {
  #     # partition_key - (必須) データレコードが割り当てられるシャードを決定するパーティションキー
  #     # 最大256文字のUnicode文字列
  #     # MD5ハッシュ関数を使用して128ビット整数値にマップされ、特定のシャードに割り当てられます
  #     # 同じパーティションキーを持つすべてのレコードは同じシャードにマップされます
  #     # 例: "order-id"
  #     # partition_key = "$.eventID"
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # ECS Task Parameters
  #   #-----------------------------------------------------------
  #   # ecs_task_parameters - (オプション) ECSタスクターゲットのパラメータ
  #   # ecs_task_parameters {
  #     # task_definition_arn - (必須) イベントターゲットがECSタスクの場合に使用するタスク定義のARN
  #     # 例: "arn:aws:ecs:us-east-1:123456789012:task-definition/example-task:1"
  #     # task_definition_arn = "arn:aws:ecs:us-east-1:123456789012:task-definition:example-task"
  #
  #     # task_count - (オプション) タスク定義に基づいて作成するタスク数
  #     # デフォルト: 1
  #     # task_count = 1
  #
  #     # launch_type - (オプション) タスクが実行される起動タイプ
  #     # 有効な値: EC2, FARGATE, EXTERNAL
  #     # capacity_provider_strategyを指定する場合はlaunch_typeを省略する必要があります
  #     # launch_type = "FARGATE"
  #
  #     # platform_version - (オプション) タスクのプラットフォームバージョン
  #     # LaunchTypeがFARGATEの場合にのみ使用
  #     # 数値部分のみ指定（例: 1.4.0）
  #     # platform_version = "LATEST"
  #
  #     # group - (オプション) ECSタスクグループ（最大255文字）
  #     # group = "example-task-group"
  #
  #     # enable_ecs_managed_tags - (オプション) ECSマネージドタグを有効にするか
  #     # 有効な値: true, false
  #     # enable_ecs_managed_tags = true
  #
  #     # enable_execute_command - (オプション) タスク内のコンテナでexecuteコマンド機能を有効にするか
  #     # 有効な値: true, false
  #     # enable_execute_command = false
  #
  #     # propagate_tags - (オプション) タスク定義からタスクにタグを伝播するか
  #     # 有効な値: TASK_DEFINITION
  #     # タグはタスク作成時にのみ伝播可能
  #     # propagate_tags = "TASK_DEFINITION"
  #
  #     # reference_id - (オプション) タスクに使用する参照ID（最大1,024文字）
  #     # reference_id = "ref-12345"
  #
  #     # tags - (オプション) タスクの分類と整理に役立つタグ
  #     # tags = {
  #     #   Environment = "production"
  #     # }
  #
  #     # network_configuration - (オプション) ECSタスクがawsvpcネットワークモードを使用する場合の設定
  #     # LaunchTypeがFARGATEの場合は必須（Fargateタスクはawsvpcモードが必須）
  #     # network_configuration {
  #       # aws_vpc_configuration - (オプション) タスクに関連付けられたVPCサブネットとセキュリティグループ
  #       # aws_vpc_configuration {
  #         # subnets - (オプション) タスクに関連付けられたサブネット（最大16サブネット）
  #         # すべて同じVPC内である必要があります
  #         # subnets = ["subnet-12345678", "subnet-87654321"]
  #
  #         # security_groups - (オプション) タスクに関連付けられたセキュリティグループ（最大5グループ）
  #         # すべて同じVPC内である必要があります
  #         # 指定しない場合、VPCのデフォルトセキュリティグループが使用されます
  #         # security_groups = ["sg-12345678"]
  #
  #         # assign_public_ip - (オプション) タスクのENIにパブリックIPアドレスを割り当てるか
  #         # 有効な値: ENABLED, DISABLED
  #         # LaunchTypeがFARGATEの場合にのみENABLEDを指定可能
  #         # assign_public_ip = "DISABLED"
  #       # }
  #     # }
  #
  #     # capacity_provider_strategy - (オプション) タスクに使用するキャパシティプロバイダー戦略
  #     # 最大6項目
  #     # capacity_provider_strategy {
  #       # capacity_provider - (必須) キャパシティプロバイダーの短縮名（最大255文字）
  #       # capacity_provider = "FARGATE"
  #
  #       # weight - (オプション) 起動する総タスク数の相対パーセンテージ（最大1,000）
  #       # base値（定義されている場合）が満たされた後に考慮されます
  #       # weight = 1
  #
  #       # base - (オプション) 指定されたキャパシティプロバイダーで実行する最小タスク数（最大100,000）
  #       # キャパシティプロバイダー戦略内で1つのみbase定義可能
  #       # base = 0
  #     # }
  #
  #     # placement_strategy - (オプション) タスクの配置戦略（最大5つ）
  #     # placement_strategy {
  #       # type - (オプション) 配置戦略のタイプ
  #       # 有効な値: random, spread, binpack
  #       # random: 利用可能な候補にランダムに配置
  #       # spread: fieldパラメータに基づいて利用可能な候補に均等に分散
  #       # binpack: fieldパラメータで指定されたリソースの残量が最も少ない候補に配置
  #       # type = "spread"
  #
  #       # field - (オプション) 配置戦略を適用するフィールド（最大255文字）
  #       # spread: instanceId (または host)、または任意のカスタム属性
  #       # binpack: cpu または memory
  #       # random: このフィールドは使用されません
  #       # field = "attribute:ecs.availability-zone"
  #     # }
  #
  #     # placement_constraint - (オプション) タスクの配置制約（最大10個）
  #     # placement_constraint {
  #       # type - (オプション) 制約のタイプ
  #       # 有効な値: distinctInstance, memberOf
  #       # distinctInstance: グループ内の各タスクを異なるコンテナインスタンスで実行
  #       # memberOf: 有効な候補のグループに選択を制限
  #       # type = "distinctInstance"
  #
  #       # expression - (オプション) 制約に適用するクラスタクエリ言語式（最大2,000文字）
  #       # typeがdistinctInstanceの場合は指定できません
  #       # expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  #     # }
  #
  #     # overrides - (オプション) タスクに関連付けられたオーバーライド
  #     # overrides {
  #       # cpu - (オプション) タスクのCPUオーバーライド
  #       # cpu = "256"
  #
  #       # memory - (オプション) タスクのメモリオーバーライド
  #       # memory = "512"
  #
  #       # task_role_arn - (オプション) このタスクのコンテナが引き受けることができるIAMロールのARN
  #       # task_role_arn = "arn:aws:iam::123456789012:role/example-task-role"
  #
  #       # execution_role_arn - (オプション) タスク実行IAMロールオーバーライドのARN
  #       # execution_role_arn = "arn:aws:iam::123456789012:role/example-execution-role"
  #
  #       # container_override - (オプション) コンテナに送信されるオーバーライド
  #       # container_override {
  #         # name - (オプション) オーバーライドを受け取るコンテナの名前
  #         # オーバーライドが指定されている場合は必須
  #         # name = "example-container"
  #
  #         # command - (オプション) Dockerイメージまたはタスク定義のデフォルトコマンドをオーバーライドするコマンド
  #         # command = ["python", "app.py"]
  #
  #         # cpu - (オプション) タスク定義のデフォルト値の代わりにコンテナ用に予約されるCPUユニット数
  #         # cpu = 256
  #
  #         # memory - (オプション) タスク定義のデフォルト値の代わりにコンテナに提供するメモリのハード制限（MiB）
  #         # memory = 512
  #
  #         # memory_reservation - (オプション) タスク定義のデフォルト値の代わりにコンテナ用に予約するメモリのソフト制限（MiB）
  #         # memory_reservation = 256
  #
  #         # environment - (オプション) コンテナに送信する環境変数
  #         # environment {
  #           # name - (オプション) 環境変数の名前
  #           # name = "ENV_VAR"
  #
  #           # value - (オプション) 環境変数の値
  #           # value = "production"
  #         # }
  #
  #         # environment_file - (オプション) コンテナに渡す環境変数を含むファイルのリスト
  #         # environment_file {
  #           # type - (オプション) 使用するファイルタイプ（サポートされる値: s3）
  #           # type = "s3"
  #
  #           # value - (オプション) 環境変数ファイルを含むS3オブジェクトのARN
  #           # value = "arn:aws:s3:::example-bucket/env-file.env"
  #         # }
  #
  #         # resource_requirement - (オプション) タスク定義の代わりにコンテナに割り当てるリソースのタイプと量
  #         # resource_requirement {
  #           # type - (必須) コンテナに割り当てるリソースのタイプ
  #           # サポートされる値: GPU, InferenceAccelerator
  #           # type = "GPU"
  #
  #           # value - (必須) 指定されたリソースタイプの値
  #           # value = "1"
  #         # }
  #       # }
  #
  #       # ephemeral_storage - (オプション) タスクのエフェメラルストレージ設定オーバーライド
  #       # ephemeral_storage {
  #         # size_in_gib - (必須) タスクに設定するエフェメラルストレージの合計量（GiB）
  #         # 最小21GiB、最大200GiB
  #         # size_in_gib = 21
  #       # }
  #
  #       # inference_accelerator_override - (オプション) Elastic Inferenceアクセラレータオーバーライド
  #       # inference_accelerator_override {
  #         # device_name - (オプション) タスクに対してオーバーライドするElastic Inferenceアクセラレータデバイス名
  #         # タスク定義で指定されたdeviceNameと一致する必要があります
  #         # device_name = "device1"
  #
  #         # device_type - (オプション) 使用するElastic Inferenceアクセラレータタイプ
  #         # device_type = "eia2.medium"
  #       # }
  #     # }
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # Batch Job Parameters
  #   #-----------------------------------------------------------
  #   # batch_job_parameters - (オプション) AWS Batchジョブターゲットのパラメータ
  #   # batch_job_parameters {
  #     # job_definition - (必須) このジョブが使用するジョブ定義
  #     # name, name:revision, またはジョブ定義のARNを指定可能
  #     # nameのみ指定した場合、最新のアクティブリビジョンが使用されます
  #     # job_definition = "example-job-definition:1"
  #
  #     # job_name - (必須) ジョブの名前（最大128文字）
  #     # job_name = "example-job"
  #
  #     # parameters - (オプション) ジョブ定義で設定されたパラメータ置換プレースホルダーを置き換える追加パラメータ
  #     # parameters = {
  #     #   "param1" = "value1"
  #     # }
  #
  #     # array_properties - (オプション) 送信されたジョブの配列プロパティ（配列サイズなど）
  #     # array_properties {
  #       # size - (オプション) 配列ジョブの場合の配列のサイズ
  #       # 最小2、最大10,000
  #       # size = 10
  #     # }
  #
  #     # retry_strategy - (オプション) 失敗したジョブの再試行戦略
  #     # retry_strategy {
  #       # attempts - (オプション) ジョブをRUNNABLE状態に移行する回数
  #       # 最大10回
  #       # attempts = 3
  #     # }
  #
  #     # container_overrides - (オプション) コンテナに送信されるオーバーライド
  #     # container_overrides {
  #       # command - (オプション) Dockerイメージまたはタスク定義のデフォルトコマンドをオーバーライドするコマンド
  #       # command = ["python", "script.py"]
  #
  #       # instance_type - (オプション) マルチノード並列ジョブに使用するインスタンスタイプ
  #       # instance_type = "m5.large"
  #
  #       # environment - (オプション) コンテナに送信する環境変数
  #       # environment {
  #         # name - (オプション) 環境変数の名前
  #         # name = "ENV_VAR"
  #
  #         # value - (オプション) 環境変数の値
  #         # value = "production"
  #       # }
  #
  #       # resource_requirement - (オプション) コンテナに割り当てるリソースのタイプと量
  #       # resource_requirement {
  #         # type - (必須) リソースのタイプ（GPU, MEMORY, VCPU）
  #         # type = "VCPU"
  #
  #         # value - (必須) 指定されたリソースタイプの値
  #         # value = "2"
  #       # }
  #     # }
  #
  #     # depends_on - (オプション) ジョブの依存関係（最大20ジョブ）
  #     # depends_on {
  #       # job_id - (オプション) この依存関係に関連付けられたAWS BatchジョブのジョブID
  #       # job_id = "example-job-id"
  #
  #       # type - (オプション) ジョブ依存関係のタイプ
  #       # 有効な値: N_TO_N, SEQUENTIAL
  #       # type = "SEQUENTIAL"
  #     # }
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # CloudWatch Logs Parameters
  #   #-----------------------------------------------------------
  #   # cloudwatch_logs_parameters - (オプション) CloudWatch Logsログストリームターゲットのパラメータ
  #   # cloudwatch_logs_parameters {
  #     # log_stream_name - (オプション) ログストリームの名前
  #     # log_stream_name = "example-log-stream"
  #
  #     # timestamp - (オプション) イベントが発生した時刻
  #     # 1970年1月1日00:00:00 UTC以降のミリ秒数
  #     # イベント内のフィールドへのJSONパス（例: $.detail.timestamp）
  #     # timestamp = "$.timestamp"
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # EventBridge Event Bus Parameters
  #   #-----------------------------------------------------------
  #   # eventbridge_event_bus_parameters - (オプション) EventBridge Event Busターゲットのパラメータ
  #   # eventbridge_event_bus_parameters {
  #     # source - (オプション) イベントのソース（最大256文字）
  #     # source = "custom.application"
  #
  #     # detail_type - (オプション) イベント詳細で期待されるフィールドを決定する自由形式の文字列（最大128文字）
  #     # detail_type = "Order Placed"
  #
  #     # resources - (オプション) イベントが主に関係するAWSリソースのARNリスト
  #     # resources = ["arn:aws:s3:::example-bucket"]
  #
  #     # time - (オプション) RFC3339形式のイベントのタイムスタンプ
  #     # イベント内のフィールドへのJSONパス（例: $.detail.timestamp）
  #     # time = "$.timestamp"
  #
  #     # endpoint_id - (オプション) エンドポイントのURLサブドメイン
  #     # endpoint_id = "abcde.veo"
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # HTTP Parameters
  #   #-----------------------------------------------------------
  #   # http_parameters - (オプション) API Gateway REST APIまたはEventBridge API Destinationsターゲットのパラメータ
  #   # http_parameters {
  #     # header_parameters - (オプション) リクエストヘッダーのキーと値のマッピング
  #     # header_parameters = {
  #     #   "X-Custom-Header" = "value"
  #     # }
  #
  #     # path_parameter_values - (オプション) パスパラメータ値のリスト
  #     # path_parameter_values = ["path-value"]
  #
  #     # query_string_parameters - (オプション) クエリ文字列パラメータのキーと値のマッピング
  #     # query_string_parameters = {
  #     #   "param" = "value"
  #     # }
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # Redshift Data Parameters
  #   #-----------------------------------------------------------
  #   # redshift_data_parameters - (オプション) Amazon Redshiftクラスターターゲットのパラメータ
  #   # redshift_data_parameters {
  #     # database - (必須) データベース名
  #     # 一時認証情報を使用して認証する場合は必須
  #     # database = "example-db"
  #
  #     # sqls - (必須) 実行するSQL文のリスト（各文は最大100,000文字）
  #     # sqls = ["SELECT * FROM orders WHERE status = 'pending'"]
  #
  #     # db_user - (オプション) データベースユーザー名
  #     # 一時認証情報を使用して認証する場合は必須
  #     # db_user = "example-user"
  #
  #     # secret_manager_arn - (オプション) データベースアクセスを可能にするSecrets ManagerシークレットのARN
  #     # Secrets Managerを使用して認証する場合は必須
  #     # secret_manager_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example-secret"
  #
  #     # statement_name - (オプション) SQL文の名前
  #     # statement_name = "example-statement"
  #
  #     # with_event - (オプション) SQL文実行後にEventBridgeにイベントを送り返すか
  #     # with_event = false
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # SageMaker Pipeline Parameters
  #   #-----------------------------------------------------------
  #   # sagemaker_pipeline_parameters - (オプション) SageMaker AIパイプラインターゲットのパラメータ
  #   # sagemaker_pipeline_parameters {
  #     # pipeline_parameter - (オプション) SageMaker AI Model Building Pipeline実行のパラメータ名と値のリスト
  #     # pipeline_parameter {
  #       # name - (必須) SageMaker AI Model Building Pipeline実行を開始するパラメータ名（最大256文字）
  #       # name = "example-param"
  #
  #       # value - (必須) SageMaker AI Model Building Pipeline実行を開始するパラメータ値（最大1024文字）
  #       # value = "example-value"
  #     # }
  #   # }
  # }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts {
  #   # create - (オプション) リソース作成のタイムアウト（デフォルト: 30m）
  #   # create = "30m"
  #
  #   # update - (オプション) リソース更新のタイムアウト（デフォルト: 30m）
  #   # update = "30m"
  #
  #   # delete - (オプション) リソース削除のタイムアウト（デフォルト: 30m）
  #   # delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（読み取り専用）:
#
# arn - パイプのARN
#   例: "arn:aws:pipes:us-east-1:123456789012:pipe/example-pipe"
#
# id - パイプの識別子（nameと同じ）
#   例: "example-pipe"
#
# tags_all - リソースに割り当てられたタグのマップ
#   プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます
#   例: {"Environment" = "production", "ManagedBy" = "terraform"}
#
# これらの属性は他のリソースで参照可能です:
#   resource_arn = aws_pipes_pipe.example.arn
#   pipe_id     = aws_pipes_pipe.example.id
#   all_tags    = aws_pipes_pipe.example.tags_all
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のEventBridge Pipeは`name`を使用してインポート可能です:
#
# terraform import aws_pipes_pipe.example example-pipe
#---------------------------------------------------------------
