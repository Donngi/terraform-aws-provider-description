#---------------------------------------------------------------
# AWS IoT Topic Rule
#---------------------------------------------------------------
#
# AWS IoT Coreのトピックルールを作成・管理します。
# IoTデバイスから送信されたMQTTメッセージを受信し、SQL文でフィルタ・変換を行い、
# 指定したAWSサービス（Lambda、SNS、SQS、Kinesis、DynamoDB等）にルーティングします。
#
# AWS公式ドキュメント:
#   - IoT Topic Rules: https://docs.aws.amazon.com/iot/latest/developerguide/iot-rules.html
#   - IoT SQL Reference: https://docs.aws.amazon.com/iot/latest/developerguide/iot-sql-reference.html
#   - TopicRule API: https://docs.aws.amazon.com/iot/latest/apireference/API_TopicRule.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_topic_rule
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_topic_rule" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # (Required) ルールの名前
  # 1-128文字の英数字とアンダースコアのみ使用可能
  name = "my_iot_rule"

  # (Required) ルールが有効かどうか
  # true: ルールが有効でメッセージを処理する
  # false: ルールが無効でメッセージを処理しない
  enabled = true

  # (Required) トピックをクエリするためのSQL文
  # MQTTトピックから受信したメッセージをフィルタ・変換するSQL文
  # 例: "SELECT * FROM 'topic/test'" - 全フィールドを選択
  # 例: "SELECT temperature, humidity FROM 'sensors/+/data' WHERE temperature > 30" - 条件付き選択
  # 参考: https://docs.aws.amazon.com/iot/latest/developerguide/iot-sql-reference.html
  sql = "SELECT * FROM 'topic/test'"

  # (Required) SQLルールエンジンのバージョン
  # 通常は "2016-03-23" を指定（最新の推奨バージョン）
  sql_version = "2016-03-23"

  # (Optional) ルールの説明
  # ルールの用途や動作を説明するテキスト
  description = "Example IoT topic rule"

  # (Optional) リソースをデプロイするリージョン
  # 未指定の場合はプロバイダー設定のリージョンが使用される
  # region = "us-east-1"

  # (Optional) リソースタグ
  # キーバリュー形式でタグを指定
  tags = {
    Environment = "production"
    Application = "iot-data-pipeline"
  }

  #---------------------------------------------------------------
  # アクション設定
  # 以下のいずれかまたは複数のアクションブロックを定義してメッセージをルーティング
  #---------------------------------------------------------------

  #---------------------------------------------------------------
  # CloudWatch Alarm アクション
  #---------------------------------------------------------------
  # CloudWatchアラームの状態を変更
  # cloudwatch_alarm {
  #   # (Required) CloudWatchアラーム名
  #   alarm_name = "my-alarm"
  #
  #   # (Required) CloudWatchアラームにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-cloudwatch-role"
  #
  #   # (Required) アラーム状態変更の理由
  #   state_reason = "IoT rule triggered"
  #
  #   # (Required) アラームの状態値
  #   # 有効な値: OK, ALARM, INSUFFICIENT_DATA
  #   state_value = "ALARM"
  # }

  #---------------------------------------------------------------
  # CloudWatch Logs アクション
  #---------------------------------------------------------------
  # CloudWatch Logsにメッセージを送信
  # cloudwatch_logs {
  #   # (Required) CloudWatchロググループ名
  #   log_group_name = "/aws/iot/my-log-group"
  #
  #   # (Required) CloudWatch LogsにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-logs-role"
  #
  #   # (Optional) バッチモード
  #   # true: JSON配列のレコードをバッチ呼び出しで送信
  #   # false: 個別にメッセージを送信
  #   batch_mode = false
  # }

  #---------------------------------------------------------------
  # CloudWatch Metric アクション
  #---------------------------------------------------------------
  # CloudWatchカスタムメトリクスにデータを送信
  # cloudwatch_metric {
  #   # (Required) CloudWatchメトリクス名
  #   metric_name = "IoTDeviceMetric"
  #
  #   # (Required) CloudWatchメトリクスの名前空間
  #   metric_namespace = "IoT/Custom"
  #
  #   # (Required) メトリクスの単位
  #   # サポートされる単位: http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/cloudwatch_concepts.html#Unit
  #   # 例: None, Seconds, Microseconds, Milliseconds, Count, Bytes, Kilobytes, Megabytes, etc.
  #   metric_unit = "Count"
  #
  #   # (Required) CloudWatchメトリクスの値
  #   # 置換テンプレート使用可能（例: "${temperature}"）
  #   metric_value = "1"
  #
  #   # (Required) CloudWatchメトリクスにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-metric-role"
  #
  #   # (Optional) Unixタイムスタンプ
  #   # 指定しない場合は現在時刻が使用される
  #   # metric_timestamp = "${timestamp()}"
  # }

  #---------------------------------------------------------------
  # DynamoDB アクション
  #---------------------------------------------------------------
  # DynamoDBテーブルにメッセージを書き込み
  # dynamodb {
  #   # (Required) ハッシュキーのフィールド名
  #   hash_key_field = "deviceId"
  #
  #   # (Required) ハッシュキーの値
  #   # 置換テンプレート使用可能（例: "${deviceId}"）
  #   hash_key_value = "${deviceId}"
  #
  #   # (Required) DynamoDBテーブルにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-dynamodb-role"
  #
  #   # (Required) DynamoDBテーブル名
  #   table_name = "IoTDeviceData"
  #
  #   # (Optional) ハッシュキーのタイプ
  #   # 有効な値: STRING, NUMBER
  #   # hash_key_type = "STRING"
  #
  #   # (Optional) レンジキーのフィールド名
  #   # range_key_field = "timestamp"
  #
  #   # (Optional) レンジキーの値
  #   # range_key_value = "${timestamp()}"
  #
  #   # (Optional) レンジキーのタイプ
  #   # 有効な値: STRING, NUMBER
  #   # range_key_type = "NUMBER"
  #
  #   # (Optional) DynamoDB操作
  #   # 有効な値: INSERT, UPDATE, DELETE
  #   # operation = "INSERT"
  #
  #   # (Optional) アクションペイロードのフィールド名
  #   # payload_field = "payload"
  # }

  #---------------------------------------------------------------
  # DynamoDBv2 アクション
  #---------------------------------------------------------------
  # DynamoDBテーブルにメッセージを書き込み（v2 API）
  # dynamodbv2 {
  #   # (Required) DynamoDBテーブルにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-dynamodb-role"
  #
  #   # (Required) DynamoDBにアイテムを書き込むための設定
  #   put_item {
  #     # (Required) DynamoDBテーブル名
  #     table_name = "IoTDeviceData"
  #   }
  # }

  #---------------------------------------------------------------
  # Elasticsearch アクション
  #---------------------------------------------------------------
  # Elasticsearchドメインにデータをインデックス
  # elasticsearch {
  #   # (Required) Elasticsearchドメインのエンドポイント
  #   endpoint = "https://search-my-domain.us-east-1.es.amazonaws.com"
  #
  #   # (Required) 保存するドキュメントの一意識別子
  #   # 置換テンプレート使用可能
  #   id = "${newuuid()}"
  #
  #   # (Required) データを保存するElasticsearchインデックス
  #   index = "iot-data"
  #
  #   # (Required) ElasticsearchにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-es-role"
  #
  #   # (Required) 保存するドキュメントのタイプ
  #   type = "_doc"
  # }

  #---------------------------------------------------------------
  # Firehose アクション
  #---------------------------------------------------------------
  # Amazon Kinesis Data Firehoseにメッセージを送信
  # firehose {
  #   # (Required) Firehose配信ストリーム名
  #   delivery_stream_name = "my-firehose-stream"
  #
  #   # (Required) FirehoseにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-firehose-role"
  #
  #   # (Optional) レコード区切り文字
  #   # 有効な値: '\n' (改行), '\t' (タブ), '\r\n' (Windows改行), ',' (カンマ)
  #   # separator = "\n"
  #
  #   # (Optional) バッチモード
  #   # true: JSON配列のレコードをバッチ呼び出しで送信
  #   batch_mode = false
  # }

  #---------------------------------------------------------------
  # HTTP/HTTPS アクション
  #---------------------------------------------------------------
  # HTTPSエンドポイントにメッセージを送信
  # http {
  #   # (Required) HTTPS URL
  #   url = "https://example.com/iot-endpoint"
  #
  #   # (Optional) URLの所有権を確認するためのHTTPS URL
  #   # confirmation_url = "https://example.com/confirm"
  #
  #   # (Optional) カスタムHTTPヘッダー
  #   # 複数のヘッダーを定義可能
  #   http_header {
  #     # (Required) HTTPヘッダー名
  #     key = "X-Custom-Header"
  #
  #     # (Required) HTTPヘッダー値
  #     value = "custom-value"
  #   }
  # }

  #---------------------------------------------------------------
  # IoT Analytics アクション
  #---------------------------------------------------------------
  # AWS IoT Analyticsチャネルにメッセージを送信
  # iot_analytics {
  #   # (Required) IoT Analyticsチャネル名
  #   channel_name = "my-iot-analytics-channel"
  #
  #   # (Required) IoT AnalyticsにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-analytics-role"
  #
  #   # (Optional) バッチモード
  #   # true: JSON配列のレコードをバッチ呼び出しで送信
  #   batch_mode = false
  # }

  #---------------------------------------------------------------
  # IoT Events アクション
  #---------------------------------------------------------------
  # AWS IoT Eventsにメッセージを送信
  # iot_events {
  #   # (Required) IoT Events入力名
  #   input_name = "my-iot-events-input"
  #
  #   # (Required) IoT EventsにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-events-role"
  #
  #   # (Optional) メッセージID
  #   # 同じmessageIdを持つ1つの入力のみが検出器によって処理されることを保証
  #   # message_id = "${newuuid()}"
  #
  #   # (Optional) バッチモード
  #   # true: JSON配列のレコードをバッチ呼び出しで送信
  #   batch_mode = false
  # }

  #---------------------------------------------------------------
  # Kafka アクション
  #---------------------------------------------------------------
  # Apache Kafkaクラスターにメッセージを送信
  # kafka {
  #   # (Required) Kafkaプロデューサークライアントのプロパティ
  #   # 詳細: https://docs.aws.amazon.com/iot/latest/developerguide/apache-kafka-rule-action.html
  #   client_properties = {
  #     "bootstrap.servers" = "kafka-broker:9092"
  #   }
  #
  #   # (Required) Kafkaアクションのaws_iot_topic_rule_destination ARN
  #   destination_arn = "arn:aws:iot:us-east-1:123456789012:ruledestination/vpc/my-kafka-destination"
  #
  #   # (Required) Kafkaブローカーに送信するメッセージのトピック
  #   topic = "iot-kafka-topic"
  #
  #   # (Optional) Kafkaメッセージキー
  #   # key = "${deviceId}"
  #
  #   # (Optional) Kafkaメッセージパーティション
  #   # partition = "0"
  #
  #   # (Optional) Kafkaヘッダーのリスト
  #   header {
  #     # (Required) Kafkaヘッダーのキー
  #     key = "correlationId"
  #
  #     # (Required) Kafkaヘッダーの値
  #     value = "${newuuid()}"
  #   }
  # }

  #---------------------------------------------------------------
  # Kinesis アクション
  #---------------------------------------------------------------
  # Amazon Kinesisストリームにメッセージを送信
  # kinesis {
  #   # (Required) KinesisストリームにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-kinesis-role"
  #
  #   # (Required) Kinesisストリーム名
  #   stream_name = "my-kinesis-stream"
  #
  #   # (Optional) パーティションキー
  #   # データをシャード間で分散するために使用
  #   # partition_key = "${deviceId}"
  # }

  #---------------------------------------------------------------
  # Lambda アクション
  #---------------------------------------------------------------
  # AWS Lambda関数を呼び出し
  # lambda {
  #   # (Required) Lambda関数のARN
  #   function_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-iot-function"
  # }

  #---------------------------------------------------------------
  # Republish アクション
  #---------------------------------------------------------------
  # 別のMQTTトピックにメッセージを再パブリッシュ
  # republish {
  #   # (Required) 再パブリッシュするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-republish-role"
  #
  #   # (Required) メッセージを再パブリッシュするMQTTトピック名
  #   topic = "republish/topic"
  #
  #   # (Optional) QoS（Quality of Service）レベル
  #   # 有効な値: 0, 1
  #   # デフォルト: 0
  #   # qos = 0
  # }

  #---------------------------------------------------------------
  # S3 アクション
  #---------------------------------------------------------------
  # Amazon S3バケットにメッセージを保存
  # s3 {
  #   # (Required) S3バケット名
  #   bucket_name = "my-iot-bucket"
  #
  #   # (Required) S3オブジェクトキー
  #   # 置換テンプレート使用可能（例: "data/${timestamp()}.json"）
  #   key = "iot-data/${timestamp()}.json"
  #
  #   # (Required) S3にアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-s3-role"
  #
  #   # (Optional) S3 Canned ACL
  #   # 有効な値: https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl
  #   # 例: private, public-read, public-read-write, authenticated-read, etc.
  #   # canned_acl = "private"
  # }

  #---------------------------------------------------------------
  # SNS アクション
  #---------------------------------------------------------------
  # Amazon SNSトピックにメッセージをパブリッシュ
  # sns {
  #   # (Required) メッセージフォーマット
  #   # 有効な値: JSON, RAW
  #   message_format = "RAW"
  #
  #   # (Required) SNSにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-sns-role"
  #
  #   # (Required) SNSトピックのARN
  #   target_arn = "arn:aws:sns:us-east-1:123456789012:my-iot-topic"
  # }

  #---------------------------------------------------------------
  # SQS アクション
  #---------------------------------------------------------------
  # Amazon SQSキューにメッセージを送信
  # sqs {
  #   # (Required) SQSキューのURL
  #   queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-iot-queue"
  #
  #   # (Required) SQSにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-sqs-role"
  #
  #   # (Required) Base64エンコーディングを使用するかどうか
  #   # true: メッセージをBase64エンコードして送信
  #   # false: メッセージをそのまま送信
  #   use_base64 = false
  # }

  #---------------------------------------------------------------
  # Step Functions アクション
  #---------------------------------------------------------------
  # AWS Step Functionsステートマシンの実行を開始
  # step_functions {
  #   # (Required) Step Functionsステートマシン名
  #   state_machine_name = "my-state-machine"
  #
  #   # (Required) Step FunctionsにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-stepfunctions-role"
  #
  #   # (Optional) ステートマシン実行名のプレフィックス
  #   # UUIDと組み合わせて一意の実行名が生成される
  #   # execution_name_prefix = "iot-execution-"
  # }

  #---------------------------------------------------------------
  # Timestream アクション
  #---------------------------------------------------------------
  # Amazon Timestreamデータベースにメッセージを書き込み
  # timestream {
  #   # (Required) Timestreamデータベース名
  #   database_name = "my-timestream-db"
  #
  #   # (Required) TimestreamにアクセスするためのIAMロールARN
  #   role_arn = "arn:aws:iam::123456789012:role/iot-timestream-role"
  #
  #   # (Required) 書き込み先のテーブル名
  #   table_name = "my-timestream-table"
  #
  #   # (Required) 時系列のメタデータ属性（ディメンション）
  #   # 最低1つ必要
  #   dimension {
  #     # (Required) ディメンション名（データベーステーブルのカラム名）
  #     name = "deviceId"
  #
  #     # (Required) ディメンション値
  #     # 置換テンプレート使用可能
  #     value = "${deviceId}"
  #   }
  #
  #   dimension {
  #     name = "location"
  #     value = "${location}"
  #   }
  #
  #   # (Optional) タイムスタンプ設定
  #   # 指定しない場合はデフォルトのタイムスタンプが使用される
  #   timestamp {
  #     # (Required) タイムスタンプの精度
  #     # 有効な値: SECONDS, MILLISECONDS, MICROSECONDS, NANOSECONDS
  #     unit = "MILLISECONDS"
  #
  #     # (Required) long型のエポックタイムを返す式
  #     value = "${timestamp()}"
  #   }
  # }

  #---------------------------------------------------------------
  # エラーアクション設定
  #---------------------------------------------------------------
  # ルール実行中にエラーが発生した場合に実行するアクション
  # error_action {
  #   # 上記のいずれかのアクションを1つ定義
  #   # 例: CloudWatch Logs, SNS, SQS等
  #
  #   sns {
  #     message_format = "RAW"
  #     role_arn       = "arn:aws:iam::123456789012:role/iot-error-sns-role"
  #     target_arn     = "arn:aws:sns:us-east-1:123456789012:iot-error-topic"
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性は computed のみで、リソース作成後に参照可能
#
# - id         : トピックルール名
# - arn        : トピックルールのARN
# - tags_all   : プロバイダーのdefault_tagsから継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
