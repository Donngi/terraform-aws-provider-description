#---------------------------------------------------------------
# Amazon Kinesis Data Firehose Delivery Stream
#---------------------------------------------------------------
#
# Amazon Kinesis Data Firehoseの配信ストリームをプロビジョニングします。
# リアルタイムデータストリームを、Amazon S3、Amazon Redshift、
# Amazon OpenSearch Service、Splunk、Snowflake、HTTP endpoints、
# Icebergなどの宛先に配信するための完全マネージド型サービスです。
#
# AWS公式ドキュメント:
#   - Amazon Kinesis Data Firehose Features: https://aws.amazon.com/kinesis/data-firehose/features/
#   - API Reference - DeliveryStreamDescription: https://docs.aws.amazon.com/firehose/latest/APIReference/API_DeliveryStreamDescription.html
#   - API Reference - DescribeDeliveryStream: https://docs.aws.amazon.com/firehose/latest/APIReference/API_DescribeDeliveryStream.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesis_firehose_delivery_stream" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # 配信ストリームの名前
  # AWSアカウントとリージョン内で一意である必要があります
  # WAFログ用に使用する場合は、`aws-waf-logs-`で始まる必要があります
  # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/waf-policies.html#waf-policies-logging-config
  name = "terraform-kinesis-firehose-test-stream"

  # データの配信先
  # 有効な値: "extended_s3", "redshift", "elasticsearch", "opensearch",
  #          "opensearchserverless", "splunk", "http_endpoint", "snowflake", "iceberg"
  # 注意: "s3"は非推奨です。代わりに"extended_s3"を使用してください
  destination = "extended_s3"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # リソースに割り当てるタグのマップ
  # プロバイダーのdefault_tagsブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします
  tags = {
    Environment = "production"
    Application = "data-pipeline"
  }

  # このリソースが管理されるリージョン
  # デフォルト値: プロバイダー設定のリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # ソース設定 (オプション)
  #---------------------------------------------------------------

  # Kinesis Data Streamをソースとして使用する場合の設定
  # 注意: Kinesis Streamをソースとして設定する場合、
  #       サーバーサイド暗号化を有効にしないでください
  # kinesis_source_configuration {
  #   # ソースとして使用するKinesis StreamのARN (必須)
  #   kinesis_stream_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/my-stream"
  #
  #   # ソースKinesis Streamへのアクセスを提供するロールのARN (必須)
  #   role_arn = "arn:aws:iam::123456789012:role/firehose-role"
  # }

  # Amazon MSKクラスターをソースとして使用する場合の設定
  # msk_source_configuration {
  #   # Amazon MSKクラスターのARN (必須)
  #   msk_cluster_arn = "arn:aws:kafka:us-east-1:123456789012:cluster/my-cluster/uuid"
  #
  #   # MSKクラスター内のトピック名 (必須)
  #   topic_name = "my-topic"
  #
  #   # MSKトピック内のオフセット位置の開始日時 (UTC)
  #   # デフォルト値: Firehoseがアクティブになった時のタイムスタンプ
  #   # 最も古い位置から開始する場合は、Epoch (1970-01-01T00:00:00Z) を設定
  #   # read_from_timestamp = "1970-01-01T00:00:00Z"
  #
  #   # 認証設定 (必須)
  #   authentication_configuration {
  #     # MSKクラスターへのアクセスに使用する接続タイプ (必須)
  #     # 有効な値: "PUBLIC", "PRIVATE"
  #     connectivity = "PRIVATE"
  #
  #     # MSKクラスターへのアクセスに使用するロールのARN (必須)
  #     role_arn = "arn:aws:iam::123456789012:role/firehose-msk-role"
  #   }
  # }

  #---------------------------------------------------------------
  # サーバーサイド暗号化設定 (オプション)
  #---------------------------------------------------------------

  # 保存時の暗号化オプション
  # 注意: Kinesis Streamをソースとして使用する場合は、
  #       この設定を有効にしないでください
  # server_side_encryption {
  #   # 保存時の暗号化を有効にするかどうか
  #   # デフォルト値: false
  #   enabled = true
  #
  #   # 暗号化キーのAmazon Resource Name (ARN)
  #   # key_typeが"CUSTOMER_MANAGED_CMK"の場合に必須
  #   # key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  # }

  #---------------------------------------------------------------
  # Extended S3 宛先設定
  #---------------------------------------------------------------

  # destinationが"extended_s3"の場合に必須
  # S3宛先の拡張設定オプション
  extended_s3_configuration {
    # ストリームが引き受けるロールのARN (必須)
    role_arn = "arn:aws:iam::123456789012:role/firehose-role"

    # S3バケットのARN (必須)
    bucket_arn = "arn:aws:s3:::my-bucket"

    # S3に配信されるファイルに追加されるプレフィックス
    # "YYYY/MM/DD/HH"の時間形式プレフィックスは自動的に使用されます
    # スラッシュで終わる場合、S3バケット内でフォルダーとして表示されます
    # prefix = "data/"

    # エラー出力用のプレフィックス
    # 失敗したレコードの前にこのプレフィックスが追加されます
    # Redshift宛先では現在サポートされていません
    # 参考: https://docs.aws.amazon.com/firehose/latest/dev/s3-prefixes.html
    # error_output_prefix = "errors/"

    # データの圧縮形式
    # デフォルト値: "UNCOMPRESSED"
    # 有効な値: "UNCOMPRESSED", "GZIP", "ZIP", "Snappy", "HADOOP_SNAPPY"
    # compression_format = "GZIP"

    # データを宛先に配信する前にバッファリングする時間 (秒)
    # 範囲: 0〜900秒
    # デフォルト値: 300秒
    # buffering_interval = 300

    # データを宛先に配信する前にバッファリングするサイズ (MB)
    # 範囲: 1〜100 MB
    # デフォルト値: 5 MB
    # 推奨: 配信ストリームに通常取り込むデータ量の10秒分より大きい値
    # 例: データを1 MB/秒で取り込む場合、10 MB以上に設定
    # buffering_size = 5

    # ストリームがデータ暗号化に使用するKMSキーのARN
    # 設定されていない場合、暗号化は使用されません
    # kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

    # 優先するタイムゾーン
    # 有効な値: "UTC" または 非3文字のIANAタイムゾーン (例: "America/Los_Angeles")
    # デフォルト値: "UTC"
    # custom_time_zone = "UTC"

    # デフォルトのファイル拡張子を上書きするファイル拡張子
    # 例: ".json"
    # file_extension = ".json"

    # Amazon S3バックアップモード
    # 有効な値: "Disabled", "Enabled"
    # デフォルト値: "Disabled"
    # s3_backup_mode = "Disabled"

    # S3バックアップ設定
    # s3_backup_modeが"Enabled"の場合に必須
    # s3_configurationオブジェクトと同じフィールドをサポートします
    # s3_backup_configuration {
    #   role_arn   = "arn:aws:iam::123456789012:role/firehose-role"
    #   bucket_arn = "arn:aws:s3:::my-backup-bucket"
    # }

    # CloudWatch Loggingオプション
    # cloudwatch_logging_options {
    #   # ロギングを有効または無効にする
    #   # デフォルト値: false
    #   enabled = true
    #
    #   # CloudWatchグループ名
    #   # enabledがtrueの場合に必須
    #   log_group_name = "/aws/kinesisfirehose/my-stream"
    #
    #   # CloudWatchログストリーム名
    #   # enabledがtrueの場合に必須
    #   log_stream_name = "S3Delivery"
    # }

    # データ処理設定
    # processing_configuration {
    #   # データ処理を有効または無効にする
    #   enabled = true
    #
    #   # データプロセッサーの設定
    #   processors {
    #     # プロセッサーのタイプ (必須)
    #     # 有効な値: "RecordDeAggregation", "Lambda", "MetadataExtraction",
    #     #          "AppendDelimiterToRecord", "Decompression", "CloudWatchLogProcessing"
    #     type = "Lambda"
    #
    #     # プロセッサーパラメータ
    #     parameters {
    #       # パラメータ名 (必須)
    #       # 有効な値: "LambdaArn", "NumberOfRetries", "MetadataExtractionQuery",
    #       #          "JsonParsingEngine", "RoleArn", "BufferSizeInMBs",
    #       #          "BufferIntervalInSeconds", "SubRecordType", "Delimiter",
    #       #          "CompressionFormat", "DataMessageExtraction"
    #       parameter_name = "LambdaArn"
    #
    #       # パラメータ値 (必須)
    #       # 長さ: 1〜512文字
    #       # Lambda ARNを指定する場合は、リソースバージョンも指定してください
    #       parameter_value = "arn:aws:lambda:us-east-1:123456789012:function:my-function:$LATEST"
    #     }
    #   }
    # }

    # 動的パーティショニング設定
    # 動的パーティショニングを使用する場合に必須
    # 参考: https://docs.aws.amazon.com/firehose/latest/dev/dynamic-partitioning.html
    # 注意: 動的パーティショニングは新しい配信ストリームの作成時のみ有効化可能
    #       一度有効化すると無効化できないため、Terraformはリソースを再作成します
    # dynamic_partitioning_configuration {
    #   # 動的パーティショニングを有効または無効にする
    #   # デフォルト値: false
    #   enabled = true
    #
    #   # 配信失敗後のリトライにかける合計時間 (秒)
    #   # 有効な値: 0〜7200秒
    #   # デフォルト値: 300秒
    #   retry_duration = 300
    # }

    # データフォーマット変換設定
    # JSON形式のデータをParquetまたはORC形式に変換してS3に書き込む場合の設定
    # シリアライザー、デシリアライザー、スキーマの設定
    # data_format_conversion_configuration {
    #   # フォーマット変換を無効にしながら設定を保持する場合はfalseに設定
    #   # デフォルト値: true
    #   enabled = true
    #
    #   # 入力フォーマット設定 (必須)
    #   input_format_configuration {
    #     # デシリアライザーの指定 (必須)
    #     deserializer {
    #       # Apache Hive JSON SerDeを使用する場合
    #       # hive_json_ser_de {
    #       #   # 日時スタンプのパースフォーマットのリスト
    #       #   # JodaTimeのDateTimeFormatパターン構文に従う
    #       #   # 参考: https://www.joda.org/joda-time/apidocs/org/joda/time/format/DateTimeFormat.html
    #       #   # エポックミリ秒でパースする場合は特殊値"millis"を使用
    #       #   # timestamp_formats = ["yyyy-MM-dd'T'HH:mm:ss.SSSZ"]
    #       # }
    #
    #       # OpenX JSON SerDeを使用する場合
    #       # open_x_json_ser_de {
    #       #   # JSONキーをデシリアライズする前に小文字に変換するかどうか
    #       #   # デフォルト値: true
    #       #   case_insensitive = true
    #       #
    #       #   # カラム名と一致しないJSONキーのマッピング
    #       #   # Hiveキーワード (例: timestamp) を含むJSONキーがある場合に便利
    #       #   # column_to_json_key_mappings = {
    #       #   #   ts = "timestamp"
    #       #   # }
    #       #
    #       #   # JSONキー内のドットをアンダースコアに置き換えるかどうか
    #       #   # Apache Hiveはカラム名にドットを許可しないため便利
    #       #   # デフォルト値: false
    #       #   convert_dots_in_json_keys_to_underscores = false
    #       # }
    #     }
    #   }
    #
    #   # 出力フォーマット設定 (必須)
    #   output_format_configuration {
    #     # シリアライザーの指定 (必須)
    #     serializer {
    #       # ORC SerDeを使用する場合
    #       # 参考: https://orc.apache.org/docs/
    #       # orc_ser_de {
    #       #   # Hadoop分散ファイルシステム (HDFS) ブロックサイズ
    #       #   # デフォルト値: 256 MiB、最小値: 64 MiB
    #       #   # block_size_bytes = 268435456
    #       #
    #       #   # Bloom filterを作成するカラム名のリスト
    #       #   # bloom_filter_columns = ["col1", "col2"]
    #       #
    #       #   # Bloom filter偽陽性確率 (FPP)
    #       #   # デフォルト値: 0.05、最小値: 0、最大値: 1
    #       #   # bloom_filter_false_positive_probability = 0.05
    #       #
    #       #   # データブロック上で使用する圧縮コード
    #       #   # デフォルト値: "SNAPPY"
    #       #   # compression = "SNAPPY"
    #       #
    #       #   # 辞書エンコーディングのしきい値
    #       #   # 辞書エンコーディングをオフにする場合は1未満の値を設定
    #       #   # 常に使用する場合は1を設定
    #       #   # dictionary_key_threshold = 0.8
    #       #
    #       #   # HDFSブロック境界までストライプをパディングするかどうか
    #       #   # デフォルト値: false
    #       #   # enable_padding = false
    #       #
    #       #   # 書き込むファイルのバージョン
    #       #   # 有効な値: "V0_11", "V0_12"
    #       #   # デフォルト値: "V0_12"
    #       #   # format_version = "V0_12"
    #       #
    #       #   # ブロックパディングの許容範囲
    #       #   # デフォルト値: 0.05 (ストライプサイズの5%)
    #       #   # padding_tolerance = 0.05
    #       #
    #       #   # インデックスエントリ間の行数
    #       #   # デフォルト値: 10000、最小値: 1000
    #       #   # row_index_stride = 10000
    #       #
    #       #   # 各ストライプのバイト数
    #       #   # デフォルト値: 64 MiB、最小値: 8 MiB
    #       #   # stripe_size_bytes = 67108864
    #       # }
    #
    #       # Parquet SerDeを使用する場合
    #       # 参考: https://parquet.apache.org/docs/
    #       # parquet_ser_de {
    #       #   # Hadoop分散ファイルシステム (HDFS) ブロックサイズ
    #       #   # デフォルト値: 256 MiB、最小値: 64 MiB
    #       #   # block_size_bytes = 268435456
    #       #
    #       #   # データブロック上で使用する圧縮コード
    #       #   # 有効な値: "UNCOMPRESSED", "SNAPPY", "GZIP"
    #       #   # デフォルト値: "SNAPPY"
    #       #   # compression = "SNAPPY"
    #       #
    #       #   # 辞書圧縮を有効にするかどうか
    #       #   # enable_dictionary_compression = true
    #       #
    #       #   # 適用する最大パディング量
    #       #   # デフォルト値: 0
    #       #   # max_padding_bytes = 0
    #       #
    #       #   # Parquetページサイズ
    #       #   # 最小値: 64 KiB、デフォルト値: 1 MiB
    #       #   # page_size_bytes = 1048576
    #       #
    #       #   # 出力する行フォーマットのバージョン
    #       #   # 有効な値: "V1", "V2"
    #       #   # デフォルト値: "V1"
    #       #   # writer_version = "V1"
    #       # }
    #     }
    #   }
    #
    #   # スキーマ設定 (必須)
    #   schema_configuration {
    #     # 出力データのスキーマを含むAWS Glueデータベース名 (必須)
    #     database_name = "my_database"
    #
    #     # データスキーマを構成するカラム情報を含むAWS Glueテーブル名 (必須)
    #     table_name = "my_table"
    #
    #     # Firehoseがテーブルにアクセスするために使用するロールのARN (必須)
    #     # 注意: Firehoseと同じアカウント内のロールである必要があります
    #     role_arn = "arn:aws:iam::123456789012:role/firehose-glue-role"
    #
    #     # AWS Glue Data CatalogのID
    #     # 指定しない場合、デフォルトでAWSアカウントIDが使用されます
    #     # catalog_id = "123456789012"
    #
    #     # AWSリージョン
    #     # 指定しない場合、デフォルトで現在のリージョンが使用されます
    #     # region = "us-east-1"
    #
    #     # 出力データスキーマのテーブルバージョン
    #     # デフォルト値: "LATEST"
    #     # version_id = "LATEST"
    #   }
    # }
  }

  #---------------------------------------------------------------
  # Redshift 宛先設定
  #---------------------------------------------------------------

  # destinationが"redshift"の場合に使用
  # redshift_configuration {
  #   # RedshiftクラスターのJDBC URL (必須)
  #   cluster_jdbcurl = "jdbc:redshift://redshift-cluster.example.com:5439/database"
  #
  #   # Redshiftテーブル名 (必須)
  #   data_table_name = "my_table"
  #
  #   # ストリームが引き受けるロールのARN (必須)
  #   role_arn = "arn:aws:iam::123456789012:role/firehose-role"
  #
  #   # 配信ストリームが使用するユーザー名
  #   # secrets_manager_configurationが提供されていない場合に必須
  #   # 注意: Kinesis Firehose専用のユーザー名とパスワードを使用し、
  #   #       権限をRedshiftのINSERT権限に制限することを強く推奨
  #   # username = "firehose_user"
  #
  #   # 上記ユーザー名のパスワード
  #   # secrets_manager_configurationが提供されていない場合に必須
  #   # password = "password"
  #
  #   # S3中間バケットからRedshiftクラスターにデータをコピーするためのコピーオプション
  #   # デフォルトの区切り文字を変更する場合などに使用
  #   # 参考: http://docs.aws.amazon.com/firehose/latest/APIReference/API_CopyCommand.html
  #   # copy_options = "delimiter '|'"
  #
  #   # COPYコマンドの対象となるデータテーブルのカラム
  #   # data_table_columns = "col1,col2,col3"
  #
  #   # 配信失敗後にFirehoseがリトライする期間 (秒)
  #   # 最初のリクエストから開始し、最初の試行を含む
  #   # デフォルト値: 3600秒 (60分)
  #   # 0に設定した場合、または最初の配信試行がこの値より長くかかる場合、リトライしません
  #   # retry_duration = 3600
  #
  #   # S3設定 (必須)
  #   s3_configuration {
  #     role_arn           = "arn:aws:iam::123456789012:role/firehose-role"
  #     bucket_arn         = "arn:aws:s3:::my-bucket"
  #     buffering_size     = 10
  #     buffering_interval = 400
  #     compression_format = "GZIP"
  #   }
  #
  #   # Amazon S3バックアップモード
  #   # 有効な値: "Disabled", "Enabled"
  #   # デフォルト値: "Disabled"
  #   # s3_backup_mode = "Enabled"
  #
  #   # S3バックアップ設定
  #   # s3_backup_modeが"Enabled"の場合に必須
  #   # s3_backup_configuration {
  #   #   role_arn           = "arn:aws:iam::123456789012:role/firehose-role"
  #   #   bucket_arn         = "arn:aws:s3:::my-backup-bucket"
  #   #   buffering_size     = 15
  #   #   buffering_interval = 300
  #   #   compression_format = "GZIP"
  #   # }
  #
  #   # Secrets Manager設定
  #   # usernameとpasswordが提供されていない場合に必須
  #   # secrets_manager_configuration {
  #   #   # Secrets Manager設定を有効または無効にする
  #   #   enabled = true
  #   #
  #   #   # Secrets ManagerシークレットのARN
  #   #   # enabledがtrueの場合に必須
  #   #   secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:my-secret"
  #   #
  #   #   # ストリームが引き受けるロールのARN
  #   #   role_arn = "arn:aws:iam::123456789012:role/firehose-secrets-role"
  #   # }
  #
  #   # CloudWatch Loggingオプション
  #   # cloudwatch_logging_options {
  #   #   enabled         = true
  #   #   log_group_name  = "/aws/kinesisfirehose/redshift"
  #   #   log_stream_name = "RedshiftDelivery"
  #   # }
  #
  #   # データ処理設定
  #   # processing_configuration {
  #   #   enabled = true
  #   #
  #   #   processors {
  #   #     type = "Lambda"
  #   #
  #   #     parameters {
  #   #       parameter_name  = "LambdaArn"
  #   #       parameter_value = "arn:aws:lambda:us-east-1:123456789012:function:my-function:$LATEST"
  #   #     }
  #   #   }
  #   # }
  # }

  #---------------------------------------------------------------
  # Elasticsearch 宛先設定
  #---------------------------------------------------------------

  # destinationが"elasticsearch"の場合に使用
  # elasticsearch_configuration {
  #   # Amazon ESドメインのARN
  #   # パターン: "arn:.*"
  #   # cluster_endpointと競合します
  #   # domain_arn = "arn:aws:es:us-east-1:123456789012:domain/my-domain"
  #
  #   # クラスターとの通信時に使用するエンドポイント
  #   # domain_arnと競合します
  #   # cluster_endpoint = "https://my-cluster.us-east-1.es.amazonaws.com"
  #
  #   # Elasticsearchインデックス名 (必須)
  #   index_name = "my-index"
  #
  #   # Elasticsearchインデックスローテーション期間
  #   # インデックスローテーションはIndexNameにタイムスタンプを追加して古いデータの有効期限を容易にします
  #   # 有効な値: "NoRotation", "OneHour", "OneDay", "OneWeek", "OneMonth"
  #   # デフォルト値: "OneDay"
  #   # index_rotation_period = "OneDay"
  #
  #   # Elasticsearchタイプ名
  #   # 最大長: 100文字
  #   # type_name = "my-type"
  #
  #   # FirehoseがES Configuration APIを呼び出し、ドキュメントをインデックス化するために
  #   # 引き受けるIAMロールのARN (必須)
  #   # パターン: "arn:.*"
  #   # 必要な権限: DescribeElasticsearchDomain, DescribeElasticsearchDomains,
  #   #           DescribeElasticsearchDomainConfig
  #   role_arn = "arn:aws:iam::123456789012:role/firehose-es-role"
  #
  #   # データを宛先に配信する前にバッファリングする時間 (秒)
  #   # 範囲: 0〜900秒
  #   # デフォルト値: 300秒
  #   # buffering_interval = 300
  #
  #   # データを宛先に配信する前にバッファリングするサイズ (MB)
  #   # 範囲: 1〜100 MB
  #   # デフォルト値: 5 MB
  #   # buffering_size = 5
  #
  #   # 最初の配信失敗後、Firehoseが再配信を試みる合計時間 (秒)
  #   # 範囲: 0〜7200秒
  #   # デフォルト値: 300秒
  #   # 0に設定した場合、リトライしません
  #   # retry_duration = 300
  #
  #   # S3設定 (必須)
  #   s3_configuration {
  #     role_arn           = "arn:aws:iam::123456789012:role/firehose-role"
  #     bucket_arn         = "arn:aws:s3:::my-bucket"
  #     buffering_size     = 10
  #     buffering_interval = 400
  #     compression_format = "GZIP"
  #   }
  #
  #   # ドキュメントをS3に配信する方法の定義
  #   # 有効な値: "FailedDocumentsOnly", "AllDocuments"
  #   # デフォルト値: "FailedDocumentsOnly"
  #   # s3_backup_mode = "FailedDocumentsOnly"
  #
  #   # CloudWatch Loggingオプション
  #   # cloudwatch_logging_options {
  #   #   enabled         = true
  #   #   log_group_name  = "/aws/kinesisfirehose/elasticsearch"
  #   #   log_stream_name = "ElasticsearchDelivery"
  #   # }
  #
  #   # VPC設定
  #   # VPCに関連付けられたElastic Searchに接続するための配信ストリームのVPC設定
  #   # vpc_config {
  #   #   # Kinesis Firehoseに関連付けるサブネットIDのリスト (必須)
  #   #   subnet_ids = ["subnet-12345678", "subnet-87654321"]
  #   #
  #   #   # Kinesis Firehoseに関連付けるセキュリティグループIDのリスト (必須)
  #   #   security_group_ids = ["sg-12345678"]
  #   #
  #   #   # FirehoseがEC2設定APIを呼び出し、ネットワークインターフェースを作成するために
  #   #   # 引き受けるIAMロールのARN (必須)
  #   #   # 必要な権限を確認: https://docs.aws.amazon.com/firehose/latest/dev/controlling-access.html#using-iam-es-vpc
  #   #   role_arn = "arn:aws:iam::123456789012:role/firehose-vpc-role"
  #   # }
  #
  #   # データ処理設定
  #   # processing_configuration {
  #   #   enabled = true
  #   #
  #   #   processors {
  #   #     type = "Lambda"
  #   #
  #   #     parameters {
  #   #       parameter_name  = "LambdaArn"
  #   #       parameter_value = "arn:aws:lambda:us-east-1:123456789012:function:my-function:$LATEST"
  #   #     }
  #   #   }
  #   # }
  # }

  #---------------------------------------------------------------
  # OpenSearch 宛先設定
  #---------------------------------------------------------------

  # destinationが"opensearch"の場合に使用
  # opensearch_configuration {
  #   # Amazon OpenSearchドメインのARN
  #   # パターン: "arn:.*"
  #   # cluster_endpointと競合します
  #   # domain_arn = "arn:aws:es:us-east-1:123456789012:domain/my-domain"
  #
  #   # クラスターとの通信時に使用するエンドポイント
  #   # domain_arnと競合します
  #   # cluster_endpoint = "https://my-cluster.us-east-1.es.amazonaws.com"
  #
  #   # OpenSearchインデックス名 (必須)
  #   index_name = "my-index"
  #
  #   # OpenSearchインデックスローテーション期間
  #   # インデックスローテーションはIndexNameにタイムスタンプを追加して古いデータの有効期限を容易にします
  #   # 有効な値: "NoRotation", "OneHour", "OneDay", "OneWeek", "OneMonth"
  #   # デフォルト値: "OneDay"
  #   # index_rotation_period = "OneDay"
  #
  #   # Elasticsearchタイプ名
  #   # 最大長: 100文字
  #   # 注意: OpenSearch 1.1ではタイプは非推奨です。TypeNameは空である必要があります
  #   # type_name = ""
  #
  #   # FirehoseがES Configuration APIを呼び出し、ドキュメントをインデックス化するために
  #   # 引き受けるIAMロールのARN (必須)
  #   # パターン: "arn:.*"
  #   # 必要な権限: DescribeDomain, DescribeDomains, DescribeDomainConfig
  #   role_arn = "arn:aws:iam::123456789012:role/firehose-opensearch-role"
  #
  #   # データを宛先に配信する前にバッファリングする時間 (秒)
  #   # 範囲: 0〜900秒
  #   # デフォルト値: 300秒
  #   # buffering_interval = 300
  #
  #   # データを宛先に配信する前にバッファリングするサイズ (MB)
  #   # 範囲: 1〜100 MB
  #   # デフォルト値: 5 MB
  #   # buffering_size = 5
  #
  #   # 最初の配信失敗後、Firehoseが再配信を試みる合計時間 (秒)
  #   # 範囲: 0〜7200秒
  #   # デフォルト値: 300秒
  #   # 0に設定した場合、リトライしません
  #   # retry_duration = 300
  #
  #   # S3設定 (必須)
  #   s3_configuration {
  #     role_arn           = "arn:aws:iam::123456789012:role/firehose-role"
  #     bucket_arn         = "arn:aws:s3:::my-bucket"
  #     buffering_size     = 10
  #     buffering_interval = 400
  #     compression_format = "GZIP"
  #   }
  #
  #   # ドキュメントをS3に配信する方法の定義
  #   # 有効な値: "FailedDocumentsOnly", "AllDocuments"
  #   # デフォルト値: "FailedDocumentsOnly"
  #   # s3_backup_mode = "FailedDocumentsOnly"
  #
  #   # ドキュメントIDの設定方法
  #   # document_id_options {
  #   #   # ドキュメントIDのデフォルトフォーマット (必須)
  #   #   # 有効な値: "FIREHOSE_DEFAULT", "NO_DOCUMENT_ID"
  #   #   default_document_id_format = "FIREHOSE_DEFAULT"
  #   # }
  #
  #   # CloudWatch Loggingオプション
  #   # cloudwatch_logging_options {
  #   #   enabled         = true
  #   #   log_group_name  = "/aws/kinesisfirehose/opensearch"
  #   #   log_stream_name = "OpenSearchDelivery"
  #   # }
  #
  #   # VPC設定
  #   # VPCに関連付けられたOpenSearchに接続するための配信ストリームのVPC設定
  #   # vpc_config {
  #   #   subnet_ids         = ["subnet-12345678", "subnet-87654321"]
  #   #   security_group_ids = ["sg-12345678"]
  #   #   role_arn           = "arn:aws:iam::123456789012:role/firehose-vpc-role"
  #   # }
  #
  #   # データ処理設定
  #   # processing_configuration {
  #   #   enabled = true
  #   #
  #   #   processors {
  #   #     type = "Lambda"
  #   #
  #   #     parameters {
  #   #       parameter_name  = "LambdaArn"
  #   #       parameter_value = "arn:aws:lambda:us-east-1:123456789012:function:my-function:$LATEST"
  #   #     }
  #   #   }
  #   # }
  # }

  #---------------------------------------------------------------
  # OpenSearch Serverless 宛先設定
  #---------------------------------------------------------------

  # destinationが"opensearchserverless"の場合に使用
  # opensearchserverless_configuration {
  #   # OpenSearch Serverlessコレクションとの通信時に使用するエンドポイント (必須)
  #   collection_endpoint = "https://my-collection.us-east-1.aoss.amazonaws.com"
  #
  #   # OpenSearch Serverlessインデックス名 (必須)
  #   index_name = "my-index"
  #
  #   # Kinesis Data FirehoseがServerless offering for OpenSearchのConfiguration APIを
  #   # 呼び出し、ドキュメントをインデックス化するために引き受けるIAMロールのARN (必須)
  #   # パターン: "arn:.*"
  #   role_arn = "arn:aws:iam::123456789012:role/firehose-serverless-role"
  #
  #   # データを宛先に配信する前にバッファリングする時間 (秒)
  #   # 範囲: 0〜900秒
  #   # デフォルト値: 300秒
  #   # buffering_interval = 300
  #
  #   # データを宛先に配信する前にバッファリングするサイズ (MB)
  #   # 範囲: 1〜100 MB
  #   # デフォルト値: 5 MB
  #   # buffering_size = 5
  #
  #   # 最初の配信失敗後、Kinesis Data Firehoseが再配信を試みる合計時間 (秒)
  #   # 範囲: 0〜7200秒
  #   # デフォルト値: 300秒
  #   # 0に設定した場合、リトライしません
  #   # retry_duration = 300
  #
  #   # S3設定 (必須)
  #   s3_configuration {
  #     role_arn           = "arn:aws:iam::123456789012:role/firehose-role"
  #     bucket_arn         = "arn:aws:s3:::my-bucket"
  #     buffering_size     = 10
  #     buffering_interval = 400
  #     compression_format = "GZIP"
  #   }
  #
  #   # ドキュメントをS3に配信する方法の定義
  #   # 有効な値: "FailedDocumentsOnly", "AllDocuments"
  #   # デフォルト値: "FailedDocumentsOnly"
  #   # s3_backup_mode = "FailedDocumentsOnly"
  #
  #   # CloudWatch Loggingオプション
  #   # cloudwatch_logging_options {
  #   #   enabled         = true
  #   #   log_group_name  = "/aws/kinesisfirehose/serverless"
  #   #   log_stream_name = "ServerlessDelivery"
  #   # }
  #
  #   # VPC設定
  #   # VPCに関連付けられたOpenSearch Serverlessに接続するための配信ストリームのVPC設定
  #   # vpc_config {
  #   #   subnet_ids         = ["subnet-12345678", "subnet-87654321"]
  #   #   security_group_ids = ["sg-12345678"]
  #   #   role_arn           = "arn:aws:iam::123456789012:role/firehose-vpc-role"
  #   # }
  #
  #   # データ処理設定
  #   # processing_configuration {
  #   #   enabled = true
  #   #
  #   #   processors {
  #   #     type = "Lambda"
  #   #
  #   #     parameters {
  #   #       parameter_name  = "LambdaArn"
  #   #       parameter_value = "arn:aws:lambda:us-east-1:123456789012:function:my-function:$LATEST"
  #   #     }
  #   #   }
  #   # }
  # }

  #---------------------------------------------------------------
  # Iceberg 宛先設定
  #---------------------------------------------------------------

  # destinationが"iceberg"の場合に使用
  # iceberg_configuration {
  #   # 宛先Apache Icebergテーブルの識別子となるGlue catalog ARN (必須)
  #   # フォーマット: "arn:aws:glue:region:account-id:catalog"
  #   catalog_arn = "arn:aws:glue:us-east-1:123456789012:catalog"
  #
  #   # FirehoseがApache Iceberg Tablesを呼び出すために引き受けるIAMロールのARN (必須)
  #   role_arn = "arn:aws:iam::123456789012:role/firehose-iceberg-role"
  #
  #   # データを宛先に配信する前にバッファリングする時間 (秒)
  #   # 範囲: 0〜900秒
  #   # デフォルト値: 300秒
  #   # buffering_interval = 400
  #
  #   # データを宛先に配信する前にバッファリングするサイズ (MB)
  #   # 範囲: 1〜128 MB
  #   # デフォルト値: 5 MB
  #   # buffering_size = 10
  #
  #   # 指定された宛先へのデータ配信をFirehoseがリトライする期間 (秒)
  #   # 範囲: 0〜7200秒
  #   # retry_duration = 300
  #
  #   # S3設定 (必須)
  #   s3_configuration {
  #     role_arn   = "arn:aws:iam::123456789012:role/firehose-role"
  #     bucket_arn = "arn:aws:s3:::my-bucket"
  #   }
  #
  #   # Firehoseがデータを配信するテーブル固有の設定
  #   # テーブル固有の設定が提供されていない場合、Firehoseはinsertでデータを書き込みます
  #   # destination_table_configuration {
  #   #   # Apache Icebergデータベース名 (必須)
  #   #   database_name = "my_database"
  #   #
  #   #   # Apache Icebergテーブル名 (必須)
  #   #   table_name = "my_table"
  #   #
  #   #   # テーブル固有のS3エラー出力プレフィックス
  #   #   # このテーブルへの配信中に発生したすべてのエラーは、
  #   #   # S3宛先でこの値がプレフィックスとして付けられます
  #   #   # s3_error_output_prefix = "errors/"
  #   #
  #   #   # 特定のApache Icebergテーブルの一意キーのリスト
  #   #   # Firehoseは、指定されたIcebergテーブルでのCreate、Update、
  #   #   # またはDelete操作の実行にこれらを使用します
  #   #   # unique_keys = ["id"]
  #   # }
  #
  #   # CloudWatch Loggingオプション
  #   # cloudwatch_logging_options {
  #   #   enabled         = true
  #   #   log_group_name  = "/aws/kinesisfirehose/iceberg"
  #   #   log_stream_name = "IcebergDelivery"
  #   # }
  #
  #   # データ処理設定
  #   # processing_configuration {
  #   #   enabled = true
  #   #
  #   #   processors {
  #   #     type = "Lambda"
  #   #
  #   #     parameters {
  #   #       parameter_name  = "LambdaArn"
  #   #       parameter_value = "arn:aws:lambda:us-east-1:123456789012:function:my-function:$LATEST"
  #   #     }
  #   #   }
  #   # }
  # }

  #---------------------------------------------------------------
  # Splunk 宛先設定
  #---------------------------------------------------------------

  # destinationが"splunk"の場合に使用
  # splunk_configuration {
  #   # Kinesis FirehoseがデータをHTTP Event Collector (HEC) に送信するエンドポイント (必須)
  #   hec_endpoint = "https://http-inputs-mydomain.splunkcloud.com:443"
  #
  #   # SplunkクラスターでHECエンドポイントを作成する際に取得するGUID
  #   # secrets_manager_configurationが提供されていない場合に必須
  #   # hec_token = "51D4DA16-C61B-4F5F-8EC7-ED4301342A4A"
  #
  #   # HECエンドポイントタイプ
  #   # 有効な値: "Raw", "Event"
  #   # デフォルト値: "Raw"
  #   # hec_endpoint_type = "Event"
  #
  #   # Kinesis Firehoseがデータを送信した後、Splunkからの確認応答を待つ時間 (秒)
  #   # 範囲: 180〜600秒
  #   # hec_acknowledgment_timeout = 600
  #
  #   # ストリームが引き受けるロールのARN (必須)
  #   role_arn = "arn:aws:iam::123456789012:role/firehose-role"
  #
  #   # データを宛先に配信する前にバッファリングする時間 (秒)
  #   # 範囲: 0〜60秒
  #   # デフォルト値: 60秒
  #   # buffering_interval = 60
  #
  #   # データを宛先に配信する前にバッファリングするサイズ (MB)
  #   # 範囲: 1〜5 MB
  #   # デフォルト値: 5 MB
  #   # buffering_size = 5
  #
  #   # 最初の配信失敗後、FirehoseがSplunkへの再配信を試みる合計時間 (秒)
  #   # 範囲: 0〜7200秒
  #   # デフォルト値: 300秒
  #   # 0に設定した場合、リトライしません
  #   # retry_duration = 300
  #
  #   # S3設定 (必須)
  #   s3_configuration {
  #     role_arn           = "arn:aws:iam::123456789012:role/firehose-role"
  #     bucket_arn         = "arn:aws:s3:::my-bucket"
  #     buffering_size     = 10
  #     buffering_interval = 400
  #     compression_format = "GZIP"
  #   }
  #
  #   # ドキュメントをS3に配信する方法の定義
  #   # 有効な値: "FailedEventsOnly", "AllEvents"
  #   # デフォルト値: "FailedEventsOnly"
  #   # s3_backup_mode = "FailedEventsOnly"
  #
  #   # Secrets Manager設定
  #   # hec_tokenが提供されていない場合に必須
  #   # secrets_manager_configuration {
  #   #   enabled    = true
  #   #   secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:my-secret"
  #   #   role_arn   = "arn:aws:iam::123456789012:role/firehose-secrets-role"
  #   # }
  #
  #   # CloudWatch Loggingオプション
  #   # cloudwatch_logging_options {
  #   #   enabled         = true
  #   #   log_group_name  = "/aws/kinesisfirehose/splunk"
  #   #   log_stream_name = "SplunkDelivery"
  #   # }
  #
  #   # データ処理設定
  #   # processing_configuration {
  #   #   enabled = true
  #   #
  #   #   processors {
  #   #     type = "Lambda"
  #   #
  #   #     parameters {
  #   #       parameter_name  = "LambdaArn"
  #   #       parameter_value = "arn:aws:lambda:us-east-1:123456789012:function:my-function:$LATEST"
  #   #     }
  #   #   }
  #   # }
  # }

  #---------------------------------------------------------------
  # HTTP Endpoint 宛先設定
  #---------------------------------------------------------------

  # destinationが"http_endpoint"の場合に使用
  # 例: New Relic、Datadog、MongoDBなど
  # http_endpoint_configuration {
  #   # Kinesis Firehoseがデータを送信するHTTPエンドポイントURL (必須)
  #   url = "https://aws-api.newrelic.com/firehose/v1"
  #
  #   # HTTPエンドポイント名
  #   # name = "New Relic"
  #
  #   # Kinesis Firehoseが宛先として選択したHTTPエンドポイントで認証するために
  #   # 必要なアクセスキー
  #   # access_key = "my-key"
  #
  #   # Kinesis Data Firehoseが配信ストリームに必要なすべての権限のために使用する
  #   # IAMロール (必須)
  #   # パターン: "arn:.*"
  #   role_arn = "arn:aws:iam::123456789012:role/firehose-role"
  #
  #   # データを宛先に配信する前にバッファリングする時間 (秒)
  #   # デフォルト値: 300秒 (5分)
  #   # buffering_interval = 600
  #
  #   # データを宛先に配信する前にバッファリングするサイズ (MB)
  #   # デフォルト値: 5 MB
  #   # buffering_size = 15
  #
  #   # 最初の試行が失敗した後、Firehoseがリトライに費やす合計時間 (秒)
  #   # この期間は最初の試行失敗後に開始し、宛先からの確認応答を待つ時間は含みません
  #   # 範囲: 0〜7200秒
  #   # デフォルト値: 300秒
  #   # retry_duration = 300
  #
  #   # S3設定 (必須)
  #   s3_configuration {
  #     role_arn           = "arn:aws:iam::123456789012:role/firehose-role"
  #     bucket_arn         = "arn:aws:s3:::my-bucket"
  #     buffering_size     = 10
  #     buffering_interval = 400
  #     compression_format = "GZIP"
  #   }
  #
  #   # ドキュメントをS3に配信する方法の定義
  #   # 有効な値: "FailedDataOnly", "AllData"
  #   # デフォルト値: "FailedDataOnly"
  #   # s3_backup_mode = "FailedDataOnly"
  #
  #   # リクエスト設定
  #   # request_configuration {
  #   #   # Kinesis Data Firehoseが宛先にリクエストを送信する前に
  #   #   # リクエストのボディを圧縮するために使用するコンテンツエンコーディング
  #   #   # 有効な値: "NONE", "GZIP"
  #   #   # デフォルト値: "NONE"
  #   #   content_encoding = "GZIP"
  #   #
  #   #   # HTTPエンドポイント宛先に送信されるメタデータ
  #   #   common_attributes {
  #   #     # HTTPエンドポイント共通属性の名前 (必須)
  #   #     name = "testname"
  #   #
  #   #     # HTTPエンドポイント共通属性の値 (必須)
  #   #     value = "testvalue"
  #   #   }
  #   #
  #   #   common_attributes {
  #   #     name  = "testname2"
  #   #     value = "testvalue2"
  #   #   }
  #   # }
  #
  #   # Secrets Manager設定
  #   # secrets_manager_configuration {
  #   #   enabled    = true
  #   #   secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:my-secret"
  #   #   role_arn   = "arn:aws:iam::123456789012:role/firehose-secrets-role"
  #   # }
  #
  #   # CloudWatch Loggingオプション
  #   # cloudwatch_logging_options {
  #   #   enabled         = true
  #   #   log_group_name  = "/aws/kinesisfirehose/http"
  #   #   log_stream_name = "HttpDelivery"
  #   # }
  #
  #   # データ処理設定
  #   # processing_configuration {
  #   #   enabled = true
  #   #
  #   #   processors {
  #   #     type = "Lambda"
  #   #
  #   #     parameters {
  #   #       parameter_name  = "LambdaArn"
  #   #       parameter_value = "arn:aws:lambda:us-east-1:123456789012:function:my-function:$LATEST"
  #   #     }
  #   #   }
  #   # }
  # }

  #---------------------------------------------------------------
  # Snowflake 宛先設定
  #---------------------------------------------------------------

  # destinationが"snowflake"の場合に使用
  # snowflake_configuration {
  #   # SnowflakeアカウントのURL (必須)
  #   # フォーマット: https://[account_identifier].snowflakecomputing.com
  #   account_url = "https://example.snowflakecomputing.com"
  #
  #   # Snowflakeデータベース名 (必須)
  #   database = "example-db"
  #
  #   # Snowflakeスキーマ名 (必須)
  #   schema = "example-schema"
  #
  #   # Snowflakeテーブル名 (必須)
  #   table = "example-table"
  #
  #   # 認証用のユーザー
  #   # secrets_manager_configurationが提供されていない場合に必須
  #   # user = "example-usr"
  #
  #   # 認証用の秘密鍵
  #   # secrets_manager_configurationが提供されていない場合に必須
  #   # private_key = "..."
  #
  #   # 秘密鍵のパスフレーズ
  #   # key_passphrase = "..."
  #
  #   # ストリームが引き受けるロールのARN (必須)
  #   role_arn = "arn:aws:iam::123456789012:role/firehose-role"
  #
  #   # データを宛先に配信する前にバッファリングする時間 (秒)
  #   # 範囲: 0〜900秒
  #   # デフォルト値: 0秒
  #   # buffering_interval = 600
  #
  #   # データを宛先に配信する前にバッファリングするサイズ (MB)
  #   # 範囲: 1〜128 MB
  #   # デフォルト値: 1 MB
  #   # buffering_size = 15
  #
  #   # 最初の配信失敗後、FirehoseがSnowflakeへの再配信を試みる合計時間 (秒)
  #   # 範囲: 0〜7200秒
  #   # デフォルト値: 60秒
  #   # 0に設定した場合、リトライしません
  #   # retry_duration = 60
  #
  #   # データロード オプション
  #   # data_loading_option = "JSON_MAPPING"
  #
  #   # メタデータカラム名
  #   # metadata_column_name = "metadata"
  #
  #   # コンテンツカラム名
  #   # content_column_name = "content"
  #
  #   # S3バックアップモード
  #   # s3_backup_mode = "AllData"
  #
  #   # S3設定 (必須)
  #   s3_configuration {
  #     role_arn           = "arn:aws:iam::123456789012:role/firehose-role"
  #     bucket_arn         = "arn:aws:s3:::my-bucket"
  #     buffering_size     = 10
  #     buffering_interval = 400
  #     compression_format = "GZIP"
  #   }
  #
  #   # Snowflakeロール設定
  #   # snowflake_role_configuration {
  #   #   # Snowflakeロールを有効にするかどうか
  #   #   enabled = true
  #   #
  #   #   # Snowflakeロール
  #   #   snowflake_role = "my-snowflake-role"
  #   # }
  #
  #   # Snowflake VPC設定
  #   # snowflake_vpc_configuration {
  #   #   # FirehoseがSnowflakeとプライベートに接続するためのVPCE ID (必須)
  #   #   private_link_vpce_id = "vpce-12345678"
  #   # }
  #
  #   # Secrets Manager設定
  #   # userとprivate_keyが提供されていない場合に必須
  #   # secrets_manager_configuration {
  #   #   enabled    = true
  #   #   secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:my-secret"
  #   #   role_arn   = "arn:aws:iam::123456789012:role/firehose-secrets-role"
  #   # }
  #
  #   # CloudWatch Loggingオプション
  #   # cloudwatch_logging_options {
  #   #   enabled         = true
  #   #   log_group_name  = "/aws/kinesisfirehose/snowflake"
  #   #   log_stream_name = "SnowflakeDelivery"
  #   # }
  #
  #   # データ処理設定
  #   # processing_configuration {
  #   #   enabled = true
  #   #
  #   #   processors {
  #   #     type = "Lambda"
  #   #
  #   #     parameters {
  #   #       parameter_name  = "LambdaArn"
  #   #       parameter_value = "arn:aws:lambda:us-east-1:123456789012:function:my-function:$LATEST"
  #   #     }
  #   #   }
  #   # }
  # }

  #---------------------------------------------------------------
  # Timeouts設定 (オプション)
  #---------------------------------------------------------------

  # timeouts {
  #   # 配信ストリームの作成タイムアウト
  #   # デフォルト値: 30分
  #   # create = "30m"
  #
  #   # 配信ストリームの更新タイムアウト
  #   # デフォルト値: 10分
  #   # update = "10m"
  #
  #   # 配信ストリームの削除タイムアウト
  #   # デフォルト値: 30分
  #   # delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Computed Attributes)
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能です:
#
# - arn            : ストリームを指定するAmazon Resource Name (ARN)
# - destination_id : 配信先のID
# - id             : リソースのID
# - region         : このリソースが管理されるリージョン
# - tags_all       : リソースに割り当てられたタグのマップ
#                    プロバイダーのdefault_tagsブロックから継承されたタグも含む
# - version_id     : バージョンID (配信先が更新されるたびに変更される)
#
#---------------------------------------------------------------
