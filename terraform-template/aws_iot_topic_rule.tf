#---------------------------------------------------------------
# AWS IoT トピックルール
#---------------------------------------------------------------
#
# AWS IoT Core のトピックルールをプロビジョニングするリソースです。
# トピックルールは SQL ステートメントを使用して MQTT メッセージを評価し、
# 条件に一致したメッセージを各種 AWS サービスへルーティングします。
# CloudWatch、DynamoDB、Kinesis、Lambda、S3、SNS、SQS など
# 多数のアクションターゲットをサポートします。
#
# AWS公式ドキュメント:
#   - トピックルールの概要: https://docs.aws.amazon.com/iot/latest/developerguide/iot-rules.html
#   - トピックルールのアクション: https://docs.aws.amazon.com/iot/latest/developerguide/iot-rule-actions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_topic_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_topic_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: トピックルールの名前を指定します。
  # 設定可能な値: 英数字とアンダースコアのみ使用可能。1〜128文字。
  name = "example_iot_topic_rule"

  # sql (Required)
  # 設定内容: メッセージの評価に使用する SQL ステートメントを指定します。
  # 設定可能な値: AWS IoT SQL 構文の有効なクエリ文字列
  # 注意: sql_version と組み合わせて使用します。
  sql = "SELECT * FROM 'iot/topic'"

  # sql_version (Required)
  # 設定内容: SQL ステートメントのバージョンを指定します。
  # 設定可能な値:
  #   - "2015-10-08": 最初の SQL バージョン
  #   - "2016-03-23": 追加関数・演算子をサポート
  #   - "beta": 最新のベータバージョン（本番環境では非推奨）
  sql_version = "2016-03-23"

  # enabled (Required)
  # 設定内容: トピックルールの有効・無効を指定します。
  # 設定可能な値:
  #   - true: ルールを有効化し、マッチするメッセージを処理します
  #   - false: ルールを無効化します
  enabled = true

  # description (Optional)
  # 設定内容: トピックルールの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしで作成されます
  description = "Example IoT topic rule"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値の文字列ペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルのタグを上書きします。
  tags = {
    Name        = "example-iot-topic-rule"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # アクション: CloudWatch アラーム
  #-------------------------------------------------------------

  # cloudwatch_alarm (Optional)
  # 設定内容: ルールに一致したときに CloudWatch アラームの状態を変更するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の cloudwatch_alarm ブロックを定義できます。
  cloudwatch_alarm {
    # alarm_name (Required)
    # 設定内容: 状態を変更する CloudWatch アラームの名前を指定します。
    alarm_name = "example-alarm"

    # role_arn (Required)
    # 設定内容: IoT が CloudWatch アラームを変更するために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-cloudwatch-role"

    # state_reason (Required)
    # 設定内容: アラーム状態変更の理由を指定する文字列を指定します。
    # 設定可能な値: 任意の文字列
    state_reason = "IoT rule triggered alarm"

    # state_value (Required)
    # 設定内容: 設定するアラームの状態を指定します。
    # 設定可能な値: "OK", "ALARM", "INSUFFICIENT_DATA"
    state_value = "ALARM"
  }

  #-------------------------------------------------------------
  # アクション: CloudWatch Logs
  #-------------------------------------------------------------

  # cloudwatch_logs (Optional)
  # 設定内容: ルールに一致したメッセージを CloudWatch Logs に送信するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の cloudwatch_logs ブロックを定義できます。
  cloudwatch_logs {
    # log_group_name (Required)
    # 設定内容: ログを送信する CloudWatch Logs のロググループ名を指定します。
    log_group_name = "/aws/iot/example"

    # role_arn (Required)
    # 設定内容: IoT が CloudWatch Logs に書き込むために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-cloudwatch-logs-role"

    # batch_mode (Optional)
    # 設定内容: バッチモードを有効にするかどうかを指定します。
    # 設定可能な値:
    #   - false (デフォルト): バッチモードを無効化
    #   - true: バッチモードを有効化
    # 省略時: false
    batch_mode = false
  }

  #-------------------------------------------------------------
  # アクション: CloudWatch メトリクス
  #-------------------------------------------------------------

  # cloudwatch_metric (Optional)
  # 設定内容: ルールに一致したメッセージから CloudWatch メトリクスデータを発行するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の cloudwatch_metric ブロックを定義できます。
  cloudwatch_metric {
    # metric_name (Required)
    # 設定内容: 発行する CloudWatch メトリクスの名前を指定します。
    metric_name = "ExampleMetric"

    # metric_namespace (Required)
    # 設定内容: メトリクスの名前空間を指定します。
    metric_namespace = "IoT/Example"

    # metric_unit (Required)
    # 設定内容: メトリクスの単位を指定します。
    # 設定可能な値: "Seconds", "Microseconds", "Milliseconds", "Bytes", "Kilobytes",
    #               "Megabytes", "Gigabytes", "Terabytes", "Bits", "Kilobits",
    #               "Megabits", "Gigabits", "Terabits", "Percent", "Count",
    #               "Bytes/Second", "Kilobytes/Second", "Megabytes/Second",
    #               "Gigabytes/Second", "Terabytes/Second", "Bits/Second",
    #               "Kilobits/Second", "Megabits/Second", "Gigabits/Second",
    #               "Terabits/Second", "Count/Second", "None"
    metric_unit = "Count"

    # metric_value (Required)
    # 設定内容: メトリクスに設定する値を指定します。
    # 設定可能な値: 数値を表す文字列
    metric_value = "1"

    # role_arn (Required)
    # 設定内容: IoT が CloudWatch メトリクスを発行するために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-cloudwatch-metric-role"

    # metric_timestamp (Optional)
    # 設定内容: メトリクスのタイムスタンプを指定します。
    # 設定可能な値: Unix エポック時間（秒）を表す文字列、または IoT SQL の substitution テンプレート
    # 省略時: 現在時刻が使用されます
    metric_timestamp = null
  }

  #-------------------------------------------------------------
  # アクション: DynamoDB (v1)
  #-------------------------------------------------------------

  # dynamodb (Optional)
  # 設定内容: ルールに一致したメッセージを DynamoDB テーブルに書き込むアクションです（v1 API）。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の dynamodb ブロックを定義できます。
  dynamodb {
    # hash_key_field (Required)
    # 設定内容: DynamoDB テーブルのハッシュキーのフィールド名を指定します。
    hash_key_field = "id"

    # hash_key_value (Required)
    # 設定内容: ハッシュキーに設定する値を指定します。IoT SQL の substitution テンプレートを使用できます。
    hash_key_value = "${newuuid()}"

    # table_name (Required)
    # 設定内容: データを書き込む DynamoDB テーブルの名前を指定します。
    table_name = "example-table"

    # role_arn (Required)
    # 設定内容: IoT が DynamoDB テーブルに書き込むために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-dynamodb-role"

    # hash_key_type (Optional)
    # 設定内容: ハッシュキーのデータ型を指定します。
    # 設定可能な値: "STRING", "NUMBER"
    # 省略時: "STRING"
    hash_key_type = "STRING"

    # range_key_field (Optional)
    # 設定内容: レンジキーのフィールド名を指定します。
    # 省略時: レンジキーなし
    range_key_field = null

    # range_key_value (Optional)
    # 設定内容: レンジキーに設定する値を指定します。
    # 省略時: レンジキーなし
    range_key_value = null

    # range_key_type (Optional)
    # 設定内容: レンジキーのデータ型を指定します。
    # 設定可能な値: "STRING", "NUMBER"
    # 省略時: "STRING"
    range_key_type = null

    # operation (Optional)
    # 設定内容: 実行する DynamoDB オペレーションを指定します。
    # 設定可能な値: "INSERT", "UPDATE", "DELETE"
    # 省略時: "INSERT"
    operation = null

    # payload_field (Optional)
    # 設定内容: ペイロードを格納するフィールド名を指定します。
    # 省略時: ペイロードは "payload" フィールドに格納されます
    payload_field = null
  }

  #-------------------------------------------------------------
  # アクション: DynamoDB (v2)
  #-------------------------------------------------------------

  # dynamodbv2 (Optional)
  # 設定内容: ルールに一致したメッセージを DynamoDB テーブルに書き込むアクションです（v2 API）。
  #           JSON ペイロードの各フィールドを個別の属性として書き込みます。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の dynamodbv2 ブロックを定義できます。
  dynamodbv2 {
    # role_arn (Required)
    # 設定内容: IoT が DynamoDB テーブルに書き込むために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-dynamodbv2-role"

    # put_item (Optional)
    # 設定内容: DynamoDB テーブルへの書き込み設定を定義するブロックです。
    put_item {
      # table_name (Required)
      # 設定内容: データを書き込む DynamoDB テーブルの名前を指定します。
      table_name = "example-v2-table"
    }
  }

  #-------------------------------------------------------------
  # アクション: Elasticsearch
  #-------------------------------------------------------------

  # elasticsearch (Optional)
  # 設定内容: ルールに一致したメッセージを Amazon Elasticsearch Service に送信するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の elasticsearch ブロックを定義できます。
  elasticsearch {
    # endpoint (Required)
    # 設定内容: Elasticsearch エンドポイントの URL を指定します。
    endpoint = "https://example.ap-northeast-1.es.amazonaws.com"

    # id (Required)
    # 設定内容: ドキュメント ID を指定します。IoT SQL の substitution テンプレートを使用できます。
    id = "${newuuid()}"

    # index (Required)
    # 設定内容: ドキュメントを格納するインデックス名を指定します。
    index = "iot-data"

    # type (Required)
    # 設定内容: ドキュメントのタイプを指定します。
    type = "_doc"

    # role_arn (Required)
    # 設定内容: IoT が Elasticsearch にデータを書き込むために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-elasticsearch-role"
  }

  #-------------------------------------------------------------
  # アクション: Kinesis Firehose
  #-------------------------------------------------------------

  # firehose (Optional)
  # 設定内容: ルールに一致したメッセージを Kinesis Data Firehose に送信するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の firehose ブロックを定義できます。
  firehose {
    # delivery_stream_name (Required)
    # 設定内容: データを送信する Kinesis Data Firehose 配信ストリームの名前を指定します。
    delivery_stream_name = "example-firehose-stream"

    # role_arn (Required)
    # 設定内容: IoT が Firehose にデータを書き込むために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-firehose-role"

    # batch_mode (Optional)
    # 設定内容: バッチモードを有効にするかどうかを指定します。
    # 設定可能な値:
    #   - false (デフォルト): バッチモードを無効化
    #   - true: バッチモードを有効化
    # 省略時: false
    batch_mode = false

    # separator (Optional)
    # 設定内容: レコード間の区切り文字を指定します。
    # 設定可能な値: ",", ";", "\n", "\t", または省略
    # 省略時: 区切り文字なし
    separator = null
  }

  #-------------------------------------------------------------
  # アクション: HTTP
  #-------------------------------------------------------------

  # http (Optional)
  # 設定内容: ルールに一致したメッセージを HTTP エンドポイントに送信するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の http ブロックを定義できます。
  http {
    # url (Required)
    # 設定内容: メッセージを送信する HTTP または HTTPS エンドポイントの URL を指定します。
    url = "https://example.com/iot-webhook"

    # confirmation_url (Optional)
    # 設定内容: エンドポイントの確認に使用する URL を指定します。
    # 省略時: url と同じ URL が確認に使用されます
    confirmation_url = null

    # http_header (Optional)
    # 設定内容: HTTP リクエストに付加するカスタムヘッダーを定義するブロックです。
    # 注意: 複数の http_header ブロックを定義できます。
    http_header {
      # key (Required)
      # 設定内容: HTTP ヘッダーのキー名を指定します。
      key = "Content-Type"

      # value (Required)
      # 設定内容: HTTP ヘッダーの値を指定します。IoT SQL の substitution テンプレートを使用できます。
      value = "application/json"
    }
  }

  #-------------------------------------------------------------
  # アクション: IoT Analytics
  #-------------------------------------------------------------

  # iot_analytics (Optional)
  # 設定内容: ルールに一致したメッセージを AWS IoT Analytics チャネルに送信するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の iot_analytics ブロックを定義できます。
  iot_analytics {
    # channel_name (Required)
    # 設定内容: データを送信する IoT Analytics チャネルの名前を指定します。
    channel_name = "example-channel"

    # role_arn (Required)
    # 設定内容: IoT が IoT Analytics にデータを送信するために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-analytics-role"

    # batch_mode (Optional)
    # 設定内容: バッチモードを有効にするかどうかを指定します。
    # 設定可能な値:
    #   - false (デフォルト): バッチモードを無効化
    #   - true: バッチモードを有効化
    # 省略時: false
    batch_mode = false
  }

  #-------------------------------------------------------------
  # アクション: IoT Events
  #-------------------------------------------------------------

  # iot_events (Optional)
  # 設定内容: ルールに一致したメッセージを AWS IoT Events に送信するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の iot_events ブロックを定義できます。
  iot_events {
    # input_name (Required)
    # 設定内容: データを送信する IoT Events 入力の名前を指定します。
    input_name = "example-input"

    # role_arn (Required)
    # 設定内容: IoT が IoT Events にデータを送信するために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-events-role"

    # batch_mode (Optional)
    # 設定内容: バッチモードを有効にするかどうかを指定します。
    # 設定可能な値:
    #   - false (デフォルト): バッチモードを無効化
    #   - true: バッチモードを有効化
    # 省略時: false
    batch_mode = false

    # message_id (Optional)
    # 設定内容: メッセージ ID を指定します。IoT SQL の substitution テンプレートを使用できます。
    # 省略時: ランダムな UUID が割り当てられます
    message_id = null
  }

  #-------------------------------------------------------------
  # アクション: Kafka
  #-------------------------------------------------------------

  # kafka (Optional)
  # 設定内容: ルールに一致したメッセージを Amazon MSK または自己管理の Apache Kafka クラスターに送信するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の kafka ブロックを定義できます。
  kafka {
    # destination_arn (Required)
    # 設定内容: Kafka クラスターの VPC 接続先 ARN を指定します。
    destination_arn = "arn:aws:iot:ap-northeast-1:123456789012:ruledestination/vpc/example"

    # topic (Required)
    # 設定内容: メッセージを送信する Kafka トピック名を指定します。
    topic = "example-topic"

    # client_properties (Required)
    # 設定内容: Kafka プロデューサーのクライアントプロパティを指定します。
    # 設定可能な値: Kafka プロデューサーの設定プロパティのマップ
    client_properties = {
      "bootstrap.servers" = "broker1:9092,broker2:9092"
      "compression.type"  = "none"
    }

    # key (Optional)
    # 設定内容: Kafka メッセージのキーを指定します。IoT SQL の substitution テンプレートを使用できます。
    # 省略時: キーなし
    key = null

    # partition (Optional)
    # 設定内容: メッセージを送信する Kafka パーティション番号を指定します。
    # 省略時: Kafka のパーティション割り当てロジックに従います
    partition = null

    # header (Optional)
    # 設定内容: Kafka メッセージヘッダーを定義するブロックです。
    # 注意: 複数の header ブロックを定義できます。
    header {
      # key (Required)
      # 設定内容: Kafka メッセージヘッダーのキー名を指定します。
      key = "X-Custom-Header"

      # value (Required)
      # 設定内容: Kafka メッセージヘッダーの値を指定します。IoT SQL の substitution テンプレートを使用できます。
      value = "example-value"
    }
  }

  #-------------------------------------------------------------
  # アクション: Kinesis Data Streams
  #-------------------------------------------------------------

  # kinesis (Optional)
  # 設定内容: ルールに一致したメッセージを Kinesis Data Streams に送信するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の kinesis ブロックを定義できます。
  kinesis {
    # stream_name (Required)
    # 設定内容: データを送信する Kinesis Data Streams のストリーム名を指定します。
    stream_name = "example-kinesis-stream"

    # role_arn (Required)
    # 設定内容: IoT が Kinesis Data Streams にデータを書き込むために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-kinesis-role"

    # partition_key (Optional)
    # 設定内容: Kinesis レコードのパーティションキーを指定します。IoT SQL の substitution テンプレートを使用できます。
    # 省略時: ランダムなパーティションキーが使用されます
    partition_key = null
  }

  #-------------------------------------------------------------
  # アクション: Lambda
  #-------------------------------------------------------------

  # lambda (Optional)
  # 設定内容: ルールに一致したメッセージで Lambda 関数を呼び出すアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の lambda ブロックを定義できます。
  lambda {
    # function_arn (Required)
    # 設定内容: 呼び出す Lambda 関数の ARN を指定します。
    function_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:example-function"
  }

  #-------------------------------------------------------------
  # アクション: IoT Republish
  #-------------------------------------------------------------

  # republish (Optional)
  # 設定内容: ルールに一致したメッセージを別の IoT トピックに再パブリッシュするアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の republish ブロックを定義できます。
  republish {
    # topic (Required)
    # 設定内容: メッセージを再パブリッシュする IoT トピックを指定します。
    topic = "iot/republish/example"

    # role_arn (Required)
    # 設定内容: IoT がメッセージを再パブリッシュするために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-republish-role"

    # qos (Optional)
    # 設定内容: メッセージの QoS（サービス品質）レベルを指定します。
    # 設定可能な値:
    #   - 0 (デフォルト): At most once（最大1回の配信）
    #   - 1: At least once（最低1回の配信）
    # 省略時: 0
    qos = 0
  }

  #-------------------------------------------------------------
  # アクション: S3
  #-------------------------------------------------------------

  # s3 (Optional)
  # 設定内容: ルールに一致したメッセージを S3 バケットに保存するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の s3 ブロックを定義できます。
  s3 {
    # bucket_name (Required)
    # 設定内容: データを保存する S3 バケットの名前を指定します。
    bucket_name = "example-iot-bucket"

    # key (Required)
    # 設定内容: S3 オブジェクトのキー（パス）を指定します。IoT SQL の substitution テンプレートを使用できます。
    key = "iot/${timestamp()}/${newuuid()}.json"

    # role_arn (Required)
    # 設定内容: IoT が S3 バケットにデータを書き込むために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-s3-role"

    # canned_acl (Optional)
    # 設定内容: S3 オブジェクトの定義済み ACL を指定します。
    # 設定可能な値: "private", "public-read", "public-read-write", "aws-exec-read",
    #               "authenticated-read", "bucket-owner-read", "bucket-owner-full-control",
    #               "log-delivery-write"
    # 省略時: ACL なし
    canned_acl = null
  }

  #-------------------------------------------------------------
  # アクション: SNS
  #-------------------------------------------------------------

  # sns (Optional)
  # 設定内容: ルールに一致したメッセージを SNS トピックに送信するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の sns ブロックを定義できます。
  sns {
    # target_arn (Required)
    # 設定内容: メッセージを送信する SNS トピックの ARN を指定します。
    target_arn = "arn:aws:sns:ap-northeast-1:123456789012:example-topic"

    # role_arn (Required)
    # 設定内容: IoT が SNS にメッセージを送信するために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-sns-role"

    # message_format (Optional)
    # 設定内容: SNS メッセージのフォーマットを指定します。
    # 設定可能な値:
    #   - "RAW" (デフォルト): 生のメッセージペイロード
    #   - "JSON": JSON 形式でのメッセージ
    # 省略時: "RAW"
    message_format = "RAW"
  }

  #-------------------------------------------------------------
  # アクション: SQS
  #-------------------------------------------------------------

  # sqs (Optional)
  # 設定内容: ルールに一致したメッセージを SQS キューに送信するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の sqs ブロックを定義できます。
  sqs {
    # queue_url (Required)
    # 設定内容: メッセージを送信する SQS キューの URL を指定します。
    queue_url = "https://sqs.ap-northeast-1.amazonaws.com/123456789012/example-queue"

    # role_arn (Required)
    # 設定内容: IoT が SQS にメッセージを送信するために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-sqs-role"

    # use_base64 (Required)
    # 設定内容: SQS メッセージのペイロードを Base64 エンコードするかどうかを指定します。
    # 設定可能な値:
    #   - false: Base64 エンコードしない
    #   - true: Base64 エンコードする
    use_base64 = false
  }

  #-------------------------------------------------------------
  # アクション: Step Functions
  #-------------------------------------------------------------

  # step_functions (Optional)
  # 設定内容: ルールに一致したメッセージで AWS Step Functions のステートマシンを起動するアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の step_functions ブロックを定義できます。
  step_functions {
    # state_machine_name (Required)
    # 設定内容: 起動する Step Functions のステートマシン名を指定します。
    state_machine_name = "example-state-machine"

    # role_arn (Required)
    # 設定内容: IoT が Step Functions を起動するために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-stepfunctions-role"

    # execution_name_prefix (Optional)
    # 設定内容: ステートマシン実行名のプレフィックスを指定します。
    # 省略時: プレフィックスなし
    execution_name_prefix = null
  }

  #-------------------------------------------------------------
  # アクション: Timestream
  #-------------------------------------------------------------

  # timestream (Optional)
  # 設定内容: ルールに一致したメッセージを Amazon Timestream に書き込むアクションです。
  # 省略時: このアクションは使用されません。
  # 注意: 複数の timestream ブロックを定義できます。
  timestream {
    # database_name (Required)
    # 設定内容: データを書き込む Timestream データベースの名前を指定します。
    database_name = "example-timestream-db"

    # table_name (Required)
    # 設定内容: データを書き込む Timestream テーブルの名前を指定します。
    table_name = "example-timestream-table"

    # role_arn (Required)
    # 設定内容: IoT が Timestream にデータを書き込むために引き受ける IAM ロールの ARN を指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-timestream-role"

    # dimension (Required, minimum 1)
    # 設定内容: Timestream レコードのディメンション（メタデータ）を定義するブロックです。
    # 注意: 最低1つの dimension ブロックが必要です。複数定義できます。
    dimension {
      # name (Required)
      # 設定内容: ディメンションの名前を指定します。
      name = "device_id"

      # value (Required)
      # 設定内容: ディメンションの値を指定します。IoT SQL の substitution テンプレートを使用できます。
      value = "${clientId()}"
    }

    # timestamp (Optional)
    # 設定内容: Timestream レコードのタイムスタンプを定義するブロックです。
    # 省略時: レコードのエンキュー時刻が使用されます。
    timestamp {
      # unit (Required)
      # 設定内容: タイムスタンプの時間単位を指定します。
      # 設定可能な値: "SECONDS", "MILLISECONDS", "MICROSECONDS", "NANOSECONDS"
      unit = "MILLISECONDS"

      # value (Required)
      # 設定内容: タイムスタンプの値を指定します。IoT SQL の substitution テンプレートを使用できます。
      value = "${timestamp()}"
    }
  }

  #-------------------------------------------------------------
  # エラーアクション設定
  #-------------------------------------------------------------

  # error_action (Optional)
  # 設定内容: ルールのアクション実行時にエラーが発生した場合のフォールバックアクションを定義するブロックです。
  # 省略時: エラーアクションなし
  # 注意: error_action 内には上記のアクションブロックのいずれか1つを指定します。
  error_action {
    # 以下は代表例として s3 アクションを使用しています。
    # 実際の用途に合わせて他のアクションブロックに置き換えてください。
    s3 {
      bucket_name = "example-iot-error-bucket"
      key         = "errors/${timestamp()}/${newuuid()}.json"
      role_arn    = "arn:aws:iam::123456789012:role/iot-s3-error-role"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: トピックルールの Amazon Resource Name (ARN)
#
# - id: トピックルールの名前（name と同一）
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
