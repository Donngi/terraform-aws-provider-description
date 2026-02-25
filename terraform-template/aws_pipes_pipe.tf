#---------------------------------------------------------------
# Amazon EventBridge Pipes Pipe
#---------------------------------------------------------------
#
# Amazon EventBridge Pipesのパイプをプロビジョニングするリソースです。
# パイプはイベントソースからターゲットへのポイントツーポイント統合を実現し、
# フィルタリング・エンリッチメント・変換を組み合わせてイベントを処理します。
# ソースにはSQS、DynamoDB Streams、Kinesis Streams、MSK、RabbitMQ等を指定でき、
# ターゲットにはLambda、ECS、Step Functions、EventBridge等を指定できます。
#
# AWS公式ドキュメント:
#   - EventBridge Pipes概要: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-pipes.html
#   - パイプの作成: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-pipes-create.html
#   - パイプのターゲット: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-pipes-event-target.html
#   - パイプのエンリッチメント: https://docs.aws.amazon.com/eventbridge/latest/userguide/pipes-enrichment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pipes_pipe
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pipes_pipe" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: パイプの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  name = "example-pipe"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: パイプ名のプレフィックスを指定します。Terraformが後ろにランダムなサフィックスを追加します。
  # 設定可能な値: 文字列
  # 省略時: nameを使用するか、どちらも省略した場合はランダム名を生成
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

  # description (Optional)
  # 設定内容: パイプの説明文を指定します。
  # 設定可能な値: 最大512文字の文字列
  # 省略時: 説明なし
  description = "Example EventBridge Pipe"

  # role_arn (Required)
  # 設定内容: パイプがソースからターゲットへデータを送信するために使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN
  # 注意: このロールにはソースの読み取り権限とターゲットへの書き込み権限が必要です。
  #       pipes.amazonaws.comサービスプリンシパルがこのロールを引き受けられる必要があります。
  role_arn = "arn:aws:iam::123456789012:role/example-pipes-role"

  #-------------------------------------------------------------
  # ソース設定
  #-------------------------------------------------------------

  # source (Required)
  # 設定内容: パイプのイベントソースリソースを指定します。
  # 設定可能な値:
  #   - SQS キュー ARN: arn:aws:sqs:region:account-id:queue-name
  #   - DynamoDB Streams ARN: arn:aws:dynamodb:...
  #   - Kinesis Streams ARN: arn:aws:kinesis:...
  #   - Amazon MSK ARN: arn:aws:kafka:...
  #   - RabbitMQ / ActiveMQ ARN: arn:aws:mq:...
  #   - セルフマネージドKafka: smk://bootstrap-server-address:port
  # 参考: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-pipes-create.html
  source = "arn:aws:sqs:ap-northeast-1:123456789012:example-source-queue"

  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # target (Required)
  # 設定内容: パイプのターゲットリソース（通常はARN）を指定します。
  # 設定可能な値:
  #   - SQS キュー、SNS トピック、Lambda 関数、Step Functions、ECS タスク等のARN
  #   - EventBridge イベントバス ARN
  #   - Kinesis Streams ARN、Firehose 配信ストリーム ARN 等
  # 参考: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-pipes-event-target.html
  target = "arn:aws:sqs:ap-northeast-1:123456789012:example-target-queue"

  #-------------------------------------------------------------
  # エンリッチメント設定
  #-------------------------------------------------------------

  # enrichment (Optional)
  # 設定内容: パイプのエンリッチメントリソース（通常はARN）を指定します。
  #           ソースから受け取ったイベントデータをターゲットに送る前に変換・補完するために使用します。
  # 設定可能な値:
  #   - Lambda 関数 ARN
  #   - Step Functions Express ワークフロー ARN
  #   - API Gateway REST API エンドポイント
  #   - EventBridge ApiDestination ARN
  # 省略時: エンリッチメントを使用しない（ソースからターゲットへ直接送信）
  # 参考: https://docs.aws.amazon.com/eventbridge/latest/userguide/pipes-enrichment.html
  enrichment = null

  #-------------------------------------------------------------
  # 状態設定
  #-------------------------------------------------------------

  # desired_state (Optional)
  # 設定内容: パイプの希望する状態を指定します。
  # 設定可能な値:
  #   - "RUNNING": パイプを実行状態にする
  #   - "STOPPED": パイプを停止状態にする
  # 省略時: "RUNNING"（パイプは実行状態で起動）
  desired_state = "RUNNING"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_identifier (Optional)
  # 設定内容: EventBridgeがパイプデータの暗号化に使用するAWS KMSカスタマーマネージドキーの識別子を指定します。
  # 設定可能な値:
  #   - KMSキーのARN
  #   - キーID（KeyId）
  #   - キーエイリアス（例: alias/my-key）
  #   - キーエイリアスARN
  # 省略時: EventBridgeがパイプデータの暗号化にAWSマネージドキーを使用します。
  kms_key_identifier = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし（プロバイダーのdefault_tagsのみ適用）
  tags = {
    Name        = "example-pipe"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # エンリッチメントパラメーター設定
  #-------------------------------------------------------------

  # enrichment_parameters (Optional)
  # 設定内容: エンリッチメント用のパラメーターを設定するブロックです。
  # 省略時: エンリッチメントパラメーターなし
  enrichment_parameters {
    # input_template (Optional)
    # 設定内容: ターゲットに渡す有効なJSONテキストを指定します。
    #           イベント自体のデータは渡されず、このテンプレートの内容のみが渡されます。
    # 設定可能な値: 最大8192文字のJSONテキスト文字列
    # 省略時: イベントデータをそのまま渡す
    input_template = null

    # http_parameters (Optional)
    # 設定内容: ターゲットがAPI Gateway REST エンドポイントまたはEventBridge ApiDestinationの場合の
    #           HTTPパラメーターを設定するブロックです。
    # 省略時: HTTPパラメーターなし
    http_parameters {
      # header_parameters (Optional)
      # 設定内容: API Gateway REST APIまたはEventBridge ApiDestinationの呼び出し時に送信する
      #           HTTPヘッダーのキーと値のマッピングを指定します。
      # 設定可能な値: map(string)
      # 省略時: カスタムヘッダーなし
      header_parameters = {
        "Content-Type" = "application/json"
      }

      # path_parameter_values (Optional)
      # 設定内容: API Gateway REST APIまたはEventBridge ApiDestinationのパスワイルドカード（"*"）を
      #           埋めるために使用するパスパラメーター値のリストを指定します。
      # 設定可能な値: list(string)
      # 省略時: パスパラメーターなし
      path_parameter_values = []

      # query_string_parameters (Optional)
      # 設定内容: API Gateway REST APIまたはEventBridge ApiDestinationの呼び出し時に送信する
      #           クエリ文字列のキーと値のマッピングを指定します。
      # 設定可能な値: map(string)
      # 省略時: クエリ文字列なし
      query_string_parameters = {}
    }
  }

  #-------------------------------------------------------------
  # ログ設定
  #-------------------------------------------------------------

  # log_configuration (Optional)
  # 設定内容: パイプのログ記録設定を行うブロックです。
  # 省略時: ログ記録を設定しない
  log_configuration {
    # level (Required)
    # 設定内容: 含めるログの詳細レベルを指定します。
    # 設定可能な値:
    #   - "OFF": ログ記録なし
    #   - "ERROR": エラーのみ記録
    #   - "INFO": 情報レベル（エラーを含む）を記録
    #   - "TRACE": 詳細トレース（全レベル）を記録
    level = "INFO"

    # include_execution_data (Optional)
    # 設定内容: ログメッセージに実行データ（payload, awsRequest, awsResponseフィールド）を
    #           含めるかを指定する文字列のセットです。すべてのログ送信先に適用されます。
    # 設定可能な値:
    #   - ["ALL"]: 実行データをすべてのログに含める
    # 省略時: 実行データをログに含めない
    include_execution_data = ["ALL"]

    # cloudwatch_logs_log_destination (Optional)
    # 設定内容: Amazon CloudWatch Logsへのログ送信設定を行うブロックです。
    # 省略時: CloudWatch Logsへの送信なし
    cloudwatch_logs_log_destination {
      # log_group_arn (Required)
      # 設定内容: EventBridgeがログレコードを送信するCloudWatch LogsロググループのARNを指定します。
      # 設定可能な値: 有効なCloudWatch LogsロググループのARN
      log_group_arn = "arn:aws:logs:ap-northeast-1:123456789012:log-group:example-pipe-logs"
    }

    # firehose_log_destination (Optional)
    # 設定内容: Amazon Kinesis Data Firehoseへのログ送信設定を行うブロックです。
    # 省略時: Firehoseへの送信なし
    # firehose_log_destination {
    #   # delivery_stream_arn (Required)
    #   # 設定内容: EventBridgeがパイプのログレコードを送信するFirehose配信ストリームのARNを指定します。
    #   # 設定可能な値: 有効なFirehose配信ストリームのARN
    #   delivery_stream_arn = "arn:aws:firehose:ap-northeast-1:123456789012:deliverystream/example"
    # }

    # s3_log_destination (Optional)
    # 設定内容: Amazon S3へのログ送信設定を行うブロックです。
    # 省略時: S3への送信なし
    # s3_log_destination {
    #   # bucket_name (Required)
    #   # 設定内容: EventBridgeがパイプのログレコードを送信するS3バケット名を指定します。
    #   bucket_name = "example-pipe-logs-bucket"
    #
    #   # bucket_owner (Required)
    #   # 設定内容: S3バケットを所有するAWSアカウントIDを指定します。
    #   bucket_owner = "123456789012"
    #
    #   # output_format (Optional)
    #   # 設定内容: ログレコードのフォーマットを指定します。
    #   # 設定可能な値: "json", "plain", "w3c"
    #   # 省略時: デフォルトフォーマット
    #   output_format = "json"
    #
    #   # prefix (Optional)
    #   # 設定内容: S3ログオブジェクト名の先頭に付けるプレフィックステキストを指定します。
    #   # 省略時: プレフィックスなし
    #   prefix = "pipes/example-pipe/"
    # }
  }

  #-------------------------------------------------------------
  # ソースパラメーター設定
  #-------------------------------------------------------------

  # source_parameters (Optional)
  # 設定内容: パイプのソース設定パラメーターを行うブロックです。ソースの種類に応じたサブブロックを使用します。
  # 省略時: ソースパラメーターなし
  source_parameters {
    # filter_criteria (Optional)
    # 設定内容: イベントをフィルタリングするためのイベントパターンコレクションを設定するブロックです。
    #           最大5つのフィルターを指定できます。
    # 省略時: フィルタリングなし（全イベントを通過）
    # 参考: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-pipes-event-filtering.html
    filter_criteria {
      # filter (Optional)
      # 設定内容: イベントパターンを指定するブロックです。最大5個まで指定可能です。
      filter {
        # pattern (Required)
        # 設定内容: イベントパターンを指定します。最大4096文字。
        # 設定可能な値: 有効なEventBridgeイベントパターンのJSON文字列
        pattern = jsonencode({
          source = ["event-source"]
        })
      }
    }

    # sqs_queue_parameters (Optional)
    # 設定内容: Amazon SQSをソースとして使用する場合のパラメーターを設定するブロックです。
    # 省略時: SQSソースパラメーターなし
    sqs_queue_parameters {
      # batch_size (Optional)
      # 設定内容: 各バッチに含める最大レコード数を指定します。
      # 設定可能な値: 1〜10000の整数
      # 省略時: AWSが自動的に決定
      batch_size = 10

      # maximum_batching_window_in_seconds (Optional)
      # 設定内容: イベントを待機する最大時間（秒）を指定します。
      # 設定可能な値: 0〜300の整数（秒）
      # 省略時: AWSが自動的に決定
      maximum_batching_window_in_seconds = 5
    }

    # activemq_broker_parameters (Optional)
    # 設定内容: Active MQ ブローカーをソースとして使用する場合のパラメーターを設定するブロックです。
    # 省略時: ActiveMQソースパラメーターなし
    # activemq_broker_parameters {
    #   # queue_name (Required)
    #   # 設定内容: 消費するキューの名前を指定します。最大1000文字。
    #   queue_name = "example-queue"
    #
    #   # batch_size (Optional)
    #   # 設定内容: 各バッチに含める最大レコード数を指定します。最大10000。
    #   # 省略時: AWSが自動的に決定
    #   batch_size = 10
    #
    #   # maximum_batching_window_in_seconds (Optional)
    #   # 設定内容: イベントを待機する最大時間（秒）を指定します。最大300秒。
    #   # 省略時: AWSが自動的に決定
    #   maximum_batching_window_in_seconds = 5
    #
    #   credentials {
    #     # basic_auth (Required)
    #     # 設定内容: 基本認証資格情報を含むSecrets ManagerシークレットのARNを指定します。
    #     basic_auth = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:example"
    #   }
    # }

    # dynamodb_stream_parameters (Optional)
    # 設定内容: DynamoDB Streamsをソースとして使用する場合のパラメーターを設定するブロックです。
    # 省略時: DynamoDB Streamsソースパラメーターなし
    # dynamodb_stream_parameters {
    #   # starting_position (Required)
    #   # 設定内容: ストリームからの読み取り開始位置を指定します。
    #   # 設定可能な値:
    #   #   - "TRIM_HORIZON": 最も古いレコードから開始
    #   #   - "LATEST": 最新のレコードから開始
    #   starting_position = "LATEST"
    #
    #   # batch_size (Optional)
    #   # 設定内容: 各バッチに含める最大レコード数を指定します。最大10000。
    #   # 省略時: AWSが自動的に決定
    #   batch_size = 100
    #
    #   # maximum_batching_window_in_seconds (Optional)
    #   # 設定内容: イベントを待機する最大時間（秒）を指定します。最大300秒。
    #   # 省略時: AWSが自動的に決定
    #   maximum_batching_window_in_seconds = 5
    #
    #   # maximum_record_age_in_seconds (Optional)
    #   # 設定内容: 指定した経過時間より古いレコードを破棄します。最大604800秒（7日）。
    #   #           デフォルト値は-1（無制限）。
    #   # 省略時: AWSが自動的に決定
    #   maximum_record_age_in_seconds = null
    #
    #   # maximum_retry_attempts (Optional)
    #   # 設定内容: 指定した回数のリトライ後にレコードを破棄します。最大10000回。
    #   #           デフォルト値は-1（無制限リトライ）。
    #   # 省略時: null
    #   maximum_retry_attempts = null
    #
    #   # on_partial_batch_item_failure (Optional)
    #   # 設定内容: バッチアイテムの処理失敗時の動作を定義します。
    #   # 設定可能な値: "AUTOMATIC_BISECT"（バッチを半分に分割して再試行）
    #   # 省略時: null
    #   on_partial_batch_item_failure = null
    #
    #   # parallelization_factor (Optional)
    #   # 設定内容: 各シャードから同時に処理するバッチ数を指定します。最大10。
    #   # 省略時: AWSが自動的に決定
    #   parallelization_factor = null
    #
    #   dead_letter_config {
    #     # arn (Optional)
    #     # 設定内容: デッドレターキューとして使用するSQSキューのARNを指定します。
    #     # 省略時: デッドレターキューなし
    #     arn = "arn:aws:sqs:ap-northeast-1:123456789012:dlq"
    #   }
    # }

    # kinesis_stream_parameters (Optional)
    # 設定内容: Kinesis Streamsをソースとして使用する場合のパラメーターを設定するブロックです。
    # 省略時: Kinesis Streamsソースパラメーターなし
    # kinesis_stream_parameters {
    #   # starting_position (Required)
    #   # 設定内容: ストリームからの読み取り開始位置を指定します。
    #   # 設定可能な値:
    #   #   - "TRIM_HORIZON": 最も古いレコードから開始
    #   #   - "LATEST": 最新のレコードから開始
    #   #   - "AT_TIMESTAMP": 指定タイムスタンプから開始（starting_position_timestampと併用）
    #   starting_position = "LATEST"
    #
    #   # starting_position_timestamp (Optional)
    #   # 設定内容: AT_TIMESTAMP設定時の読み取り開始時刻をUnixタイム秒で指定します。
    #   # 省略時: null
    #   starting_position_timestamp = null
    #
    #   # batch_size (Optional)
    #   # 設定内容: 各バッチに含める最大レコード数を指定します。最大10000。
    #   # 省略時: AWSが自動的に決定
    #   batch_size = 100
    #
    #   # maximum_batching_window_in_seconds (Optional)
    #   # 設定内容: イベントを待機する最大時間（秒）を指定します。最大300秒。
    #   # 省略時: AWSが自動的に決定
    #   maximum_batching_window_in_seconds = 5
    #
    #   # maximum_record_age_in_seconds (Optional)
    #   # 設定内容: 指定した経過時間より古いレコードを破棄します。最大604800秒（7日）。
    #   # 省略時: AWSが自動的に決定
    #   maximum_record_age_in_seconds = null
    #
    #   # maximum_retry_attempts (Optional)
    #   # 設定内容: 指定した回数のリトライ後にレコードを破棄します。最大10000回。
    #   # 省略時: null
    #   maximum_retry_attempts = null
    #
    #   # on_partial_batch_item_failure (Optional)
    #   # 設定内容: バッチアイテムの処理失敗時の動作を定義します。
    #   # 設定可能な値: "AUTOMATIC_BISECT"
    #   # 省略時: null
    #   on_partial_batch_item_failure = null
    #
    #   # parallelization_factor (Optional)
    #   # 設定内容: 各シャードから同時に処理するバッチ数を指定します。最大10。
    #   # 省略時: AWSが自動的に決定
    #   parallelization_factor = null
    #
    #   dead_letter_config {
    #     # arn (Optional)
    #     # 設定内容: デッドレターキューとして使用するSQSキューのARNを指定します。
    #     arn = "arn:aws:sqs:ap-northeast-1:123456789012:dlq"
    #   }
    # }

    # managed_streaming_kafka_parameters (Optional)
    # 設定内容: Amazon MSK（Managed Streaming for Apache Kafka）をソースとして使用する場合の
    #           パラメーターを設定するブロックです。
    # 省略時: MSKソースパラメーターなし
    # managed_streaming_kafka_parameters {
    #   # topic_name (Required)
    #   # 設定内容: パイプが読み取るトピック名を指定します。最大249文字。
    #   topic_name = "example-topic"
    #
    #   # starting_position (Optional)
    #   # 設定内容: ストリームからの読み取り開始位置を指定します。
    #   # 設定可能な値: "TRIM_HORIZON", "LATEST"
    #   # 省略時: null
    #   starting_position = "LATEST"
    #
    #   # consumer_group_id (Optional)
    #   # 設定内容: 消費するコンシューマーグループIDを指定します。最大200文字。
    #   # 省略時: null
    #   consumer_group_id = null
    #
    #   # batch_size (Optional)
    #   # 設定内容: 各バッチに含める最大レコード数を指定します。最大10000。
    #   # 省略時: AWSが自動的に決定
    #   batch_size = 100
    #
    #   # maximum_batching_window_in_seconds (Optional)
    #   # 設定内容: イベントを待機する最大時間（秒）を指定します。最大300秒。
    #   # 省略時: AWSが自動的に決定
    #   maximum_batching_window_in_seconds = 5
    #
    #   credentials {
    #     # client_certificate_tls_auth (Optional)
    #     # 設定内容: 認証資格情報を含むSecrets ManagerシークレットのARNを指定します。
    #     # 省略時: null
    #     client_certificate_tls_auth = null
    #
    #     # sasl_scram_512_auth (Optional)
    #     # 設定内容: 認証資格情報を含むSecrets ManagerシークレットのARNを指定します。
    #     # 省略時: null
    #     sasl_scram_512_auth = null
    #   }
    # }

    # rabbitmq_broker_parameters (Optional)
    # 設定内容: RabbitMQ ブローカーをソースとして使用する場合のパラメーターを設定するブロックです。
    # 省略時: RabbitMQソースパラメーターなし
    # rabbitmq_broker_parameters {
    #   # queue_name (Required)
    #   # 設定内容: 消費するキューの名前を指定します。最大1000文字。
    #   queue_name = "example-queue"
    #
    #   # virtual_host (Optional)
    #   # 設定内容: ソースブローカーに関連付けられた仮想ホスト名を指定します。最大200文字。
    #   # 省略時: null
    #   virtual_host = null
    #
    #   # batch_size (Optional)
    #   # 設定内容: 各バッチに含める最大レコード数を指定します。最大10000。
    #   # 省略時: AWSが自動的に決定
    #   batch_size = 10
    #
    #   # maximum_batching_window_in_seconds (Optional)
    #   # 設定内容: イベントを待機する最大時間（秒）を指定します。最大300秒。
    #   # 省略時: AWSが自動的に決定
    #   maximum_batching_window_in_seconds = 5
    #
    #   credentials {
    #     # basic_auth (Required)
    #     # 設定内容: 資格情報を含むSecrets ManagerシークレットのARNを指定します。
    #     basic_auth = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:example"
    #   }
    # }

    # self_managed_kafka_parameters (Optional)
    # 設定内容: セルフマネージドApache Kafkaをソースとして使用する場合のパラメーターを設定するブロックです。
    # 省略時: セルフマネージドKafkaソースパラメーターなし
    # self_managed_kafka_parameters {
    #   # topic_name (Required)
    #   # 設定内容: パイプが読み取るトピック名を指定します。最大249文字。
    #   topic_name = "example-topic"
    #
    #   # starting_position (Optional)
    #   # 設定内容: ストリームからの読み取り開始位置を指定します。
    #   # 設定可能な値: "TRIM_HORIZON", "LATEST"
    #   # 省略時: null
    #   starting_position = "LATEST"
    #
    #   # additional_bootstrap_servers (Optional)
    #   # 設定内容: 追加のサーバーURLの配列を指定します。最大2アイテム、各300文字まで。
    #   # 省略時: null
    #   additional_bootstrap_servers = []
    #
    #   # consumer_group_id (Optional)
    #   # 設定内容: 消費するコンシューマーグループIDを指定します。最大200文字。
    #   # 省略時: null
    #   consumer_group_id = null
    #
    #   # server_root_ca_certificate (Optional)
    #   # 設定内容: 証明書認証に使用するSecrets ManagerシークレットのARNを指定します。
    #   # 省略時: null
    #   server_root_ca_certificate = null
    #
    #   # batch_size (Optional)
    #   # 設定内容: 各バッチに含める最大レコード数を指定します。最大10000。
    #   # 省略時: AWSが自動的に決定
    #   batch_size = 100
    #
    #   # maximum_batching_window_in_seconds (Optional)
    #   # 設定内容: イベントを待機する最大時間（秒）を指定します。最大300秒。
    #   # 省略時: AWSが自動的に決定
    #   maximum_batching_window_in_seconds = 5
    #
    #   credentials {
    #     # basic_auth (Optional)
    #     # 設定内容: 資格情報を含むSecrets ManagerシークレットのARNを指定します。
    #     # 省略時: null
    #     basic_auth = null
    #
    #     # client_certificate_tls_auth (Optional)
    #     # 設定内容: 資格情報を含むSecrets ManagerシークレットのARNを指定します。
    #     # 省略時: null
    #     client_certificate_tls_auth = null
    #
    #     # sasl_scram_256_auth (Optional)
    #     # 設定内容: 資格情報を含むSecrets ManagerシークレットのARNを指定します。
    #     # 省略時: null
    #     sasl_scram_256_auth = null
    #
    #     # sasl_scram_512_auth (Optional)
    #     # 設定内容: 資格情報を含むSecrets ManagerシークレットのARNを指定します。
    #     # 省略時: null
    #     sasl_scram_512_auth = null
    #   }
    #
    #   vpc {
    #     # security_groups (Optional)
    #     # 設定内容: ストリームに関連付けるセキュリティグループのリストを指定します。
    #     #           最大5つのセキュリティグループを指定可能。
    #     # 省略時: VPCのデフォルトセキュリティグループを使用
    #     security_groups = []
    #
    #     # subnets (Optional)
    #     # 設定内容: ストリームに関連付けるサブネットのリストを指定します。
    #     #           最大16のサブネットを指定可能。
    #     # 省略時: null
    #     subnets = []
    #   }
    # }
  }

  #-------------------------------------------------------------
  # ターゲットパラメーター設定
  #-------------------------------------------------------------

  # target_parameters (Optional)
  # 設定内容: パイプのターゲット設定パラメーターを行うブロックです。ターゲットの種類に応じたサブブロックを使用します。
  # 省略時: ターゲットパラメーターなし
  target_parameters {
    # input_template (Optional)
    # 設定内容: ターゲットに渡す有効なJSONテキストを指定します。
    #           イベント自体のデータは渡されず、このテンプレートの内容のみが渡されます。最大8192文字。
    # 省略時: イベントデータをそのまま渡す
    input_template = null

    # sqs_queue_parameters (Optional)
    # 設定内容: ターゲットとしてAmazon SQSを使用する場合のパラメーターを設定するブロックです。
    # 省略時: SQSターゲットパラメーターなし
    sqs_queue_parameters {
      # message_deduplication_id (Optional)
      # 設定内容: FIFOキュー向けのメッセージ重複排除IDを指定します。このパラメーターはFIFOキューにのみ適用されます。
      # 省略時: null
      message_deduplication_id = null

      # message_group_id (Optional)
      # 設定内容: FIFOキュー向けのメッセージグループIDを指定します。
      # 省略時: null
      message_group_id = null
    }

    # lambda_function_parameters (Optional)
    # 設定内容: ターゲットとしてLambda関数を使用する場合のパラメーターを設定するブロックです。
    # 省略時: Lambdaターゲットパラメーターなし
    # lambda_function_parameters {
    #   # invocation_type (Required)
    #   # 設定内容: Lambda関数を同期的または非同期的に呼び出すかを指定します。
    #   # 設定可能な値:
    #   #   - "REQUEST_RESPONSE": 同期呼び出し（レスポンスを待つ）
    #   #   - "FIRE_AND_FORGET": 非同期呼び出し（レスポンスを待たない）
    #   invocation_type = "REQUEST_RESPONSE"
    # }

    # step_function_state_machine_parameters (Optional)
    # 設定内容: ターゲットとしてStep Functions ステートマシンを使用する場合のパラメーターを設定するブロックです。
    # 省略時: Step Functionsターゲットパラメーターなし
    # step_function_state_machine_parameters {
    #   # invocation_type (Required)
    #   # 設定内容: ステートマシンを同期的または非同期的に呼び出すかを指定します。
    #   # 設定可能な値:
    #   #   - "REQUEST_RESPONSE": 同期呼び出し
    #   #   - "FIRE_AND_FORGET": 非同期呼び出し
    #   invocation_type = "FIRE_AND_FORGET"
    # }

    # eventbridge_event_bus_parameters (Optional)
    # 設定内容: ターゲットとしてEventBridgeイベントバスを使用する場合のパラメーターを設定するブロックです。
    # 省略時: EventBridgeターゲットパラメーターなし
    # eventbridge_event_bus_parameters {
    #   # detail_type (Optional)
    #   # 設定内容: イベントの詳細タイプを示す自由形式の文字列を指定します。最大128文字。
    #   # 省略時: null
    #   detail_type = null
    #
    #   # endpoint_id (Optional)
    #   # 設定内容: エンドポイントのURLサブドメインを指定します。
    #   # 省略時: null
    #   endpoint_id = null
    #
    #   # resources (Optional)
    #   # 設定内容: イベントが主に関係するAWSリソースのARNリストを指定します。
    #   # 省略時: null
    #   resources = []
    #
    #   # source (Optional)
    #   # 設定内容: イベントのソースを指定します。最大256文字。
    #   # 省略時: null
    #   source = null
    #
    #   # time (Optional)
    #   # 設定内容: RFC3339形式のイベントタイムスタンプを指定します。
    #   #           JSONパス形式（例: $.detail.timestamp）も使用可能。
    #   # 省略時: PutEvents呼び出しのタイムスタンプを使用
    #   time = null
    # }

    # kinesis_stream_parameters (Optional)
    # 設定内容: ターゲットとしてKinesis Streamを使用する場合のパラメーターを設定するブロックです。
    # 省略時: Kinesisターゲットパラメーターなし
    # kinesis_stream_parameters {
    #   # partition_key (Required)
    #   # 設定内容: ストリーム内のどのシャードにデータレコードを割り当てるかを決定するパーティションキーを指定します。
    #   #           最大256文字のUnicode文字列。
    #   partition_key = "example-partition-key"
    # }

    # cloudwatch_logs_parameters (Optional)
    # 設定内容: ターゲットとしてCloudWatch Logsを使用する場合のパラメーターを設定するブロックです。
    # 省略時: CloudWatch Logsターゲットパラメーターなし
    # cloudwatch_logs_parameters {
    #   # log_stream_name (Optional)
    #   # 設定内容: ログストリームの名前を指定します。
    #   # 省略時: null
    #   log_stream_name = null
    #
    #   # timestamp (Optional)
    #   # 設定内容: イベント発生時刻（1970-01-01T00:00:00 UTCからのミリ秒）を指定します。
    #   #           JSONパス形式（例: $.detail.timestamp）も使用可能。
    #   # 省略時: null
    #   timestamp = null
    # }

    # redshift_data_parameters (Optional)
    # 設定内容: ターゲットとしてAmazon Redshiftクラスターを使用する場合のパラメーターを設定するブロックです。
    #           BatchExecuteStatement APIを介してSQLを実行します。
    # 省略時: Redshiftターゲットパラメーターなし
    # redshift_data_parameters {
    #   # database (Required)
    #   # 設定内容: データベース名を指定します。一時的な認証情報を使用する場合に必須。
    #   database = "example-database"
    #
    #   # sqls (Required)
    #   # 設定内容: 実行するSQL文のリストを指定します。各SQL文は最大100000文字。
    #   sqls = ["SELECT 1"]
    #
    #   # db_user (Optional)
    #   # 設定内容: データベースユーザー名を指定します。一時的な認証情報を使用する場合に必須。
    #   # 省略時: null
    #   db_user = null
    #
    #   # secret_manager_arn (Optional)
    #   # 設定内容: データベースへのアクセスを有効にするシークレットの名前またはARNを指定します。
    #   #           Secrets Managerを使用して認証する場合に必須。
    #   # 省略時: null
    #   secret_manager_arn = null
    #
    #   # statement_name (Optional)
    #   # 設定内容: SQL文の名前を指定します。クエリを識別するために使用。
    #   # 省略時: null
    #   statement_name = null
    #
    #   # with_event (Optional)
    #   # 設定内容: SQL文実行後にEventBridgeにイベントを送り返すかどうかを指定します。
    #   # 設定可能な値: true, false
    #   # 省略時: null
    #   with_event = false
    # }

    # sagemaker_pipeline_parameters (Optional)
    # 設定内容: ターゲットとしてSageMaker AIパイプラインを使用する場合のパラメーターを設定するブロックです。
    # 省略時: SageMakerターゲットパラメーターなし
    # sagemaker_pipeline_parameters {
    #   pipeline_parameter {
    #     # name (Required)
    #     # 設定内容: SageMaker AIモデル構築パイプライン実行を開始するためのパラメーター名を指定します。最大256文字。
    #     name = "example-param"
    #
    #     # value (Required)
    #     # 設定内容: SageMaker AIモデル構築パイプライン実行を開始するためのパラメーター値を指定します。最大1024文字。
    #     value = "example-value"
    #   }
    # }

    # http_parameters (Optional)
    # 設定内容: ターゲットがAPI Gateway REST APIまたはEventBridge ApiDestinationの場合のカスタムパラメーターを
    #           設定するブロックです。
    # 省略時: HTTPターゲットパラメーターなし
    # http_parameters {
    #   # header_parameters (Optional)
    #   # 設定内容: API呼び出し時に送信するHTTPヘッダーのマッピングを指定します。
    #   # 省略時: null
    #   header_parameters = {}
    #
    #   # path_parameter_values (Optional)
    #   # 設定内容: パスワイルドカード（"*"）を埋めるためのパスパラメーター値のリストを指定します。
    #   # 省略時: null
    #   path_parameter_values = []
    #
    #   # query_string_parameters (Optional)
    #   # 設定内容: API呼び出し時に送信するクエリ文字列のマッピングを指定します。
    #   # 省略時: null
    #   query_string_parameters = {}
    # }

    # batch_job_parameters (Optional)
    # 設定内容: ターゲットとしてAWS Batchジョブを使用する場合のパラメーターを設定するブロックです。
    # 省略時: Batchターゲットパラメーターなし
    # batch_job_parameters {
    #   # job_definition (Required)
    #   # 設定内容: このジョブが使用するジョブ定義を指定します。
    #   #           名前、名前:リビジョン、またはARNを指定可能。リビジョンなしの名前の場合は最新の有効なリビジョンを使用。
    #   job_definition = "example-job-definition"
    #
    #   # job_name (Required)
    #   # 設定内容: ジョブの名前を指定します。最大128文字。
    #   job_name = "example-job"
    #
    #   # parameters (Optional)
    #   # 設定内容: ジョブ定義のパラメーター置換プレースホルダーを置き換える追加パラメーターを指定します。
    #   # 省略時: null
    #   parameters = {}
    #
    #   array_properties {
    #     # size (Optional)
    #     # 設定内容: 配列バッチジョブの場合の配列サイズを指定します。最小2、最大10000。
    #     # 省略時: null
    #     size = null
    #   }
    #
    #   container_overrides {
    #     # command (Optional)
    #     # 設定内容: Dockerイメージまたはタスクのデフォルトコマンドをオーバーライドするコマンドリストを指定します。
    #     # 省略時: null
    #     command = []
    #
    #     # instance_type (Optional)
    #     # 設定内容: マルチノード並列ジョブに使用するインスタンスタイプを指定します。
    #     #           シングルノードコンテナジョブやFargate向けジョブには適用されません。
    #     # 省略時: null
    #     instance_type = null
    #
    #     environment {
    #       # name (Optional)
    #       # 設定内容: 環境変数の名前を指定します。
    #       # 省略時: null
    #       name = "EXAMPLE_ENV"
    #
    #       # value (Optional)
    #       # 設定内容: 環境変数の値を指定します。
    #       # 省略時: null
    #       value = "example-value"
    #     }
    #
    #     resource_requirement {
    #       # type (Required)
    #       # 設定内容: コンテナに割り当てるリソースのタイプを指定します。
    #       # 設定可能な値: "GPU", "MEMORY", "VCPU"
    #       type = "VCPU"
    #
    #       # value (Required)
    #       # 設定内容: 指定されたリソースタイプに予約する量を指定します。
    #       value = "1"
    #     }
    #   }
    #
    #   depends_on {
    #     # job_id (Optional)
    #     # 設定内容: この依存関係に関連付けられたBatchジョブのIDを指定します。
    #     # 省略時: null
    #     job_id = null
    #
    #     # type (Optional)
    #     # 設定内容: ジョブ依存関係のタイプを指定します。
    #     # 設定可能な値: "N_TO_N", "SEQUENTIAL"
    #     # 省略時: null
    #     type = null
    #   }
    #
    #   retry_strategy {
    #     # attempts (Optional)
    #     # 設定内容: ジョブをRUNNABLE状態に移動する回数を指定します。最大10回。
    #     # 省略時: null
    #     attempts = null
    #   }
    # }

    # ecs_task_parameters (Optional)
    # 設定内容: ターゲットとしてAmazon ECSタスクを使用する場合のパラメーターを設定するブロックです。
    # 省略時: ECSターゲットパラメーターなし
    # ecs_task_parameters {
    #   # task_definition_arn (Required)
    #   # 設定内容: ターゲットがECSタスクの場合に使用するタスク定義のARNを指定します。
    #   task_definition_arn = "arn:aws:ecs:ap-northeast-1:123456789012:task-definition/example"
    #
    #   # launch_type (Optional)
    #   # 設定内容: タスクの実行ラウンチタイプを指定します。
    #   # 設定可能な値: "EC2", "FARGATE", "EXTERNAL"
    #   # 省略時: null
    #   launch_type = "FARGATE"
    #
    #   # task_count (Optional)
    #   # 設定内容: タスク定義に基づいて作成するタスク数を指定します。デフォルトは1。
    #   # 省略時: null
    #   task_count = 1
    #
    #   # platform_version (Optional)
    #   # 設定内容: タスクのプラットフォームバージョンを指定します。FARGATEのみ適用。数値部分のみ指定（例: 1.1.0）。
    #   # 省略時: null
    #   platform_version = null
    #
    #   # group (Optional)
    #   # 設定内容: タスクのECSタスクグループを指定します。最大255文字。
    #   # 省略時: null
    #   group = null
    #
    #   # enable_ecs_managed_tags (Optional)
    #   # 設定内容: タスクのAmazon ECS管理タグを有効にするかを指定します。
    #   # 設定可能な値: true, false
    #   # 省略時: null
    #   enable_ecs_managed_tags = false
    #
    #   # enable_execute_command (Optional)
    #   # 設定内容: タスク内のコンテナに対してexecuteコマンド機能を有効にするかを指定します。
    #   # 設定可能な値: true, false
    #   # 省略時: null
    #   enable_execute_command = false
    #
    #   # propagate_tags (Optional)
    #   # 設定内容: タスク定義からタスクにタグを伝播するかを指定します。
    #   # 設定可能な値: "TASK_DEFINITION"
    #   # 省略時: タグの伝播なし
    #   propagate_tags = null
    #
    #   # reference_id (Optional)
    #   # 設定内容: タスクに使用する参照IDを指定します。最大1024文字。
    #   # 省略時: null
    #   reference_id = null
    #
    #   # tags (Optional)
    #   # 設定内容: タスクに適用するキーと値のタグマップを指定します。
    #   # 省略時: null
    #   tags = {}
    #
    #   capacity_provider_strategy {
    #     # capacity_provider (Required)
    #     # 設定内容: キャパシティプロバイダーの短い名前を指定します。最大255文字。
    #     capacity_provider = "FARGATE"
    #
    #     # base (Optional)
    #     # 設定内容: 指定のキャパシティプロバイダーで最低限実行するタスク数を指定します。最大100000。
    #     # 省略時: 0
    #     base = 0
    #
    #     # weight (Optional)
    #     # 設定内容: 指定のキャパシティプロバイダーで起動するタスクの相対的な割合を指定します。最大1000。
    #     # 省略時: null
    #     weight = 100
    #   }
    #
    #   network_configuration {
    #     aws_vpc_configuration {
    #       # assign_public_ip (Optional)
    #       # 設定内容: タスクのElastic Network InterfaceにパブリックIPアドレスを割り当てるかを指定します。
    #       # 設定可能な値: "ENABLED", "DISABLED"
    #       # 省略時: null
    #       assign_public_ip = "ENABLED"
    #
    #       # security_groups (Optional)
    #       # 設定内容: タスクに関連付けるセキュリティグループを指定します。最大5つ。
    #       # 省略時: VPCのデフォルトセキュリティグループを使用
    #       security_groups = []
    #
    #       # subnets (Optional)
    #       # 設定内容: タスクに関連付けるサブネットを指定します。最大16つ。
    #       # 省略時: null
    #       subnets = []
    #     }
    #   }
    #
    #   overrides {
    #     # cpu (Optional)
    #     # 設定内容: タスクのCPUオーバーライドを指定します。
    #     # 省略時: null
    #     cpu = null
    #
    #     # memory (Optional)
    #     # 設定内容: タスクのメモリオーバーライドを指定します。
    #     # 省略時: null
    #     memory = null
    #
    #     # execution_role_arn (Optional)
    #     # 設定内容: タスク実行IAMロールオーバーライドのARNを指定します。
    #     # 省略時: null
    #     execution_role_arn = null
    #
    #     # task_role_arn (Optional)
    #     # 設定内容: タスク内のコンテナが引き受けることができるIAMロールのARNを指定します。
    #     # 省略時: null
    #     task_role_arn = null
    #
    #     container_override {
    #       # name (Optional)
    #       # 設定内容: オーバーライドを受け取るコンテナの名前を指定します。
    #       # 省略時: null
    #       name = null
    #
    #       # command (Optional)
    #       # 設定内容: コンテナのデフォルトコマンドをオーバーライドするコマンドリストを指定します。
    #       # 省略時: null
    #       command = []
    #
    #       # cpu (Optional)
    #       # 設定内容: コンテナに予約するCPUユニット数を指定します。
    #       # 省略時: null
    #       cpu = null
    #
    #       # memory (Optional)
    #       # 設定内容: コンテナのメモリ上限（MiB）を指定します。
    #       # 省略時: null
    #       memory = null
    #
    #       # memory_reservation (Optional)
    #       # 設定内容: コンテナのメモリソフトリミット（MiB）を指定します。
    #       # 省略時: null
    #       memory_reservation = null
    #
    #       environment {
    #         # name (Optional)
    #         # 設定内容: 環境変数の名前を指定します。
    #         # 省略時: null
    #         name = null
    #
    #         # value (Optional)
    #         # 設定内容: 環境変数の値を指定します。
    #         # 省略時: null
    #         value = null
    #       }
    #
    #       environment_file {
    #         # type (Required)
    #         # 設定内容: ファイルタイプを指定します。
    #         # 設定可能な値: "s3"（現在サポートされている唯一の値）
    #         type = "s3"
    #
    #         # value (Required)
    #         # 設定内容: 環境変数ファイルを含むAmazon S3オブジェクトのARNを指定します。
    #         value = "arn:aws:s3:::example-bucket/env-file"
    #       }
    #
    #       resource_requirement {
    #         # type (Required)
    #         # 設定内容: コンテナに割り当てるリソースのタイプを指定します。
    #         # 設定可能な値: "GPU", "InferenceAccelerator"
    #         type = "GPU"
    #
    #         # value (Required)
    #         # 設定内容: 指定されたリソースタイプの値を指定します。
    #         value = "1"
    #       }
    #     }
    #
    #     ephemeral_storage {
    #       # size_in_gib (Required)
    #       # 設定内容: タスクに設定するエフェメラルストレージの合計量（GiB）を指定します。
    #       #           最小21 GiB、最大200 GiB。
    #       size_in_gib = 21
    #     }
    #
    #     inference_accelerator_override {
    #       # device_name (Optional)
    #       # 設定内容: オーバーライドするElastic Inference アクセラレーターのデバイス名を指定します。
    #       #           タスク定義で指定されたdeviceNameと一致する必要があります。
    #       # 省略時: null
    #       device_name = null
    #
    #       # device_type (Optional)
    #       # 設定内容: 使用するElastic Inferenceアクセラレーターのタイプを指定します。
    #       # 省略時: null
    #       device_type = null
    #     }
    #   }
    #
    #   placement_constraint {
    #     # type (Optional)
    #     # 設定内容: 制約のタイプを指定します。
    #     # 設定可能な値: "distinctInstance", "memberOf"
    #     # 省略時: null
    #     type = null
    #
    #     # expression (Optional)
    #     # 設定内容: 制約に適用するクラスタークエリ言語式を指定します。最大2000文字。
    #     #           distinctInstanceタイプでは式を指定できません。
    #     # 省略時: null
    #     expression = null
    #   }
    #
    #   placement_strategy {
    #     # type (Optional)
    #     # 設定内容: 配置ストラテジーのタイプを指定します。
    #     # 設定可能な値: "random", "spread", "binpack"
    #     # 省略時: null
    #     type = null
    #
    #     # field (Optional)
    #     # 設定内容: 配置ストラテジーを適用するフィールドを指定します。最大255文字。
    #     # 省略時: null
    #     field = null
    #   }
    # }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "Xm"（分）や "Xs"（秒）等のGo言語の時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウト
    create = "20m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "Xm"（分）や "Xs"（秒）等のGo言語の時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウト
    update = "20m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "Xm"（分）や "Xs"（秒）等のGo言語の時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウト
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: このパイプのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
