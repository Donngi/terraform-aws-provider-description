#---------------------------------------------------------------
# Amazon Kinesis Data Firehose 配信ストリーム
#---------------------------------------------------------------
#
# Amazon Kinesis Data Firehoseの配信ストリームをプロビジョニングするリソースです。
# ストリーミングデータをAmazon S3、Amazon Redshift、Amazon OpenSearch Service、
# Snowflake、Splunk、HTTPエンドポイントなどのデスティネーションにリアルタイムで
# 配信します。データの変換、圧縮、暗号化、フォーマット変換もサポートします。
#
# AWS公式ドキュメント:
#   - Kinesis Data Firehose概要: https://docs.aws.amazon.com/firehose/latest/dev/what-is-this-service.html
#   - 配信ストリーム設定: https://docs.aws.amazon.com/firehose/latest/dev/create-configure-delivery-stream.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesis_firehose_delivery_stream" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 配信ストリームの名前を指定します。
  # 設定可能な値: 文字列（1〜64文字、英数字・ハイフン・アンダースコアを使用可能）
  name = "example-firehose-stream"

  # arn (Optional, Computed)
  # 設定内容: 配信ストリームのARNを指定します。
  # 設定可能な値: 有効なKinesis Data Firehose ARN
  # 省略時: AWSが自動生成したARNを使用
  arn = null

  # destination_id (Optional, Computed)
  # 設定内容: デスティネーションのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: AWSが自動生成した値を使用
  destination_id = null

  # destination (Required)
  # 設定内容: 配信ストリームのデスティネーションタイプを指定します。
  # 設定可能な値:
  #   - s3: Amazon S3（extended_s3_configurationを使用）
  #   - extended_s3: Amazon S3 拡張設定（extended_s3_configurationを使用）
  #   - redshift: Amazon Redshift（redshift_configurationを使用）
  #   - elasticsearch: Amazon Elasticsearch Service（elasticsearch_configurationを使用）
  #   - opensearch: Amazon OpenSearch Service（opensearch_configurationを使用）
  #   - opensearchserverless: Amazon OpenSearch Serverless（opensearchserverless_configurationを使用）
  #   - splunk: Splunk（splunk_configurationを使用）
  #   - http_endpoint: HTTPエンドポイント（http_endpoint_configurationを使用）
  #   - snowflake: Snowflake（snowflake_configurationを使用）
  #   - iceberg: Apache Iceberg（iceberg_configurationを使用）
  destination = "extended_s3"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
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
  tags = {
    Name        = "example-firehose-stream"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # ソース設定: Kinesis データストリーム
  #-------------------------------------------------------------

  # kinesis_source_configuration (Optional, Max: 1)
  # 設定内容: Kinesisデータストリームをソースとして使用する場合の設定を指定します。
  # 関連機能: Kinesisデータストリームソース
  #   Kinesisデータストリームから連続してデータを読み取りデスティネーションに配信します。
  kinesis_source_configuration {

    # kinesis_stream_arn (Required)
    # 設定内容: ソースとして使用するKinesisデータストリームのARNを指定します。
    # 設定可能な値: 有効なKinesisデータストリームARN
    kinesis_stream_arn = "arn:aws:kinesis:ap-northeast-1:123456789012:stream/example-stream"

    # role_arn (Required)
    # 設定内容: Kinesisデータストリームへのアクセスに使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    role_arn = "arn:aws:iam::123456789012:role/firehose-kinesis-source-role"
  }

  #-------------------------------------------------------------
  # ソース設定: MSK (Amazon Managed Streaming for Apache Kafka)
  #-------------------------------------------------------------

  # msk_source_configuration (Optional, Max: 1)
  # 設定内容: Amazon MSKをソースとして使用する場合の設定を指定します。
  # 関連機能: MSKソース
  #   Amazon MSKクラスターのKafkaトピックからデータを読み取りデスティネーションに配信します。
  msk_source_configuration {

    # msk_cluster_arn (Required)
    # 設定内容: ソースとして使用するMSKクラスターのARNを指定します。
    # 設定可能な値: 有効なAmazon MSKクラスターARN
    msk_cluster_arn = "arn:aws:kafka:ap-northeast-1:123456789012:cluster/example-cluster/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx-1"

    # topic_name (Required)
    # 設定内容: 読み取るKafkaトピック名を指定します。
    # 設定可能な値: 文字列（有効なKafkaトピック名）
    topic_name = "example-topic"

    # read_from_timestamp (Optional)
    # 設定内容: Kafkaトピックの読み取り開始タイムスタンプをISO 8601形式で指定します。
    # 設定可能な値: ISO 8601形式のタイムスタンプ（例: 2023-01-01T00:00:00Z）
    # 省略時: 最新のオフセットから読み取りを開始
    read_from_timestamp = null

    # authentication_configuration (Required, Min: 1, Max: 1)
    # 設定内容: MSKクラスターへの認証設定を指定します。
    authentication_configuration {

      # connectivity (Required)
      # 設定内容: MSKクラスターへの接続タイプを指定します。
      # 設定可能な値:
      #   - PUBLIC: パブリック接続
      #   - PRIVATE: プライベート接続（VPC経由）
      connectivity = "PRIVATE"

      # role_arn (Required)
      # 設定内容: MSKクラスターへのアクセスに使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN
      role_arn = "arn:aws:iam::123456789012:role/firehose-msk-source-role"
    }
  }

  #-------------------------------------------------------------
  # サーバーサイド暗号化設定
  #-------------------------------------------------------------

  # server_side_encryption (Optional, Max: 1)
  # 設定内容: Kinesis Data Firehoseの保存データの暗号化設定を指定します。
  # 関連機能: サーバーサイド暗号化
  #   KMSキーを使用して配信ストリームに格納されるデータを暗号化します。
  server_side_encryption {

    # enabled (Optional)
    # 設定内容: サーバーサイド暗号化を有効にするかを指定します。
    # 設定可能な値:
    #   - true: 暗号化を有効化
    #   - false: 暗号化を無効化
    # 省略時: false
    enabled = true

    # key_type (Optional)
    # 設定内容: 暗号化に使用するKMSキーのタイプを指定します。
    # 設定可能な値:
    #   - AWS_OWNED_CMK: AWS管理のカスタマーマスターキーを使用
    #   - CUSTOMER_MANAGED_CMK: カスタマー管理のKMSキーを使用（key_arnの指定が必要）
    # 省略時: AWS_OWNED_CMK
    key_type = "AWS_OWNED_CMK"

    # key_arn (Optional)
    # 設定内容: 暗号化に使用するKMSキーのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    # 注意: key_typeがCUSTOMER_MANAGED_CMKの場合に使用します。
    # 省略時: key_typeがAWS_OWNED_CMKの場合はnull
    key_arn = null
  }

  #-------------------------------------------------------------
  # デスティネーション設定: Extended S3
  #-------------------------------------------------------------

  # extended_s3_configuration (Optional, Max: 1)
  # 設定内容: Amazon S3をデスティネーションとして使用する場合の拡張設定を指定します。
  # 関連機能: S3デスティネーション
  #   データ変換、フォーマット変換、動的パーティショニングなど高度な機能をサポートします。
  # 注意: destinationが"extended_s3"または"s3"の場合に使用します。
  extended_s3_configuration {

    # bucket_arn (Required)
    # 設定内容: データを配信するS3バケットのARNを指定します。
    # 設定可能な値: 有効なS3バケットARN
    bucket_arn = "arn:aws:s3:::example-firehose-bucket"

    # role_arn (Required)
    # 設定内容: S3バケットへのアクセスに使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    role_arn = "arn:aws:iam::123456789012:role/firehose-delivery-role"

    # buffering_interval (Optional)
    # 設定内容: データをバッファリングする時間間隔を秒単位で指定します。
    # 設定可能な値: 0〜900（秒）
    # 省略時: 300（秒）
    buffering_interval = 300

    # buffering_size (Optional)
    # 設定内容: データをバッファリングするサイズをMB単位で指定します。
    # 設定可能な値: 1〜128（MB）
    # 省略時: 5（MB）
    buffering_size = 5

    # compression_format (Optional)
    # 設定内容: データの圧縮形式を指定します。
    # 設定可能な値:
    #   - UNCOMPRESSED: 圧縮なし
    #   - GZIP: GZIP形式
    #   - ZIP: ZIP形式
    #   - Snappy: Snappy形式
    #   - HADOOP_SNAPPY: Hadoop互換Snappy形式
    # 省略時: UNCOMPRESSED
    compression_format = "GZIP"

    # prefix (Optional)
    # 設定内容: S3オブジェクトのプレフィックスを指定します。
    # 設定可能な値: 文字列（例: "year=!{timestamp:yyyy}/month=!{timestamp:MM}/"）
    # 省略時: プレフィックスなし
    prefix = "data/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"

    # error_output_prefix (Optional)
    # 設定内容: 配信失敗時にエラーデータを書き込むS3プレフィックスを指定します。
    # 設定可能な値: 文字列（例: "errors/!{firehose:error-output-type}/"）
    # 省略時: エラーデータはバケットルートに保存
    error_output_prefix = "errors/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"

    # kms_key_arn (Optional)
    # 設定内容: S3オブジェクトの暗号化に使用するKMSキーのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    # 省略時: AWSマネージドキーを使用
    kms_key_arn = null

    # custom_time_zone (Optional)
    # 設定内容: プレフィックスのタイムスタンプ計算に使用するタイムゾーンを指定します。
    # 設定可能な値: IANA タイムゾーン名（例: "Asia/Tokyo", "UTC"）
    # 省略時: UTC
    custom_time_zone = "Asia/Tokyo"

    # file_extension (Optional)
    # 設定内容: S3オブジェクトのファイル拡張子を指定します。
    # 設定可能な値: 文字列（例: ".json", ".csv", ".gz"）
    # 省略時: 拡張子なし（またはcompressionFormatに応じたデフォルト）
    file_extension = null

    # s3_backup_mode (Optional)
    # 設定内容: S3バックアップモードを指定します。
    # 設定可能な値:
    #   - Disabled: バックアップを無効化
    #   - Enabled: すべてのデータをバックアップ
    # 省略時: Disabled
    s3_backup_mode = "Disabled"

    #-----------------------------------------------------------
    # CloudWatchログ設定
    #-----------------------------------------------------------

    # cloudwatch_logging_options (Optional, Max: 1)
    # 設定内容: CloudWatchログへの配信エラーのロギング設定を指定します。
    cloudwatch_logging_options {

      # enabled (Optional)
      # 設定内容: CloudWatchログへの出力を有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      enabled = true

      # log_group_name (Optional)
      # 設定内容: ログを出力するCloudWatchロググループ名を指定します。
      # 設定可能な値: 文字列
      log_group_name = "/aws/kinesisfirehose/example-stream"

      # log_stream_name (Optional)
      # 設定内容: ログを出力するCloudWatchログストリーム名を指定します。
      # 設定可能な値: 文字列
      log_stream_name = "S3Delivery"
    }

    #-----------------------------------------------------------
    # データ変換設定（Lambda）
    #-----------------------------------------------------------

    # processing_configuration (Optional, Max: 1)
    # 設定内容: Lambdaを使用したデータ変換処理の設定を指定します。
    # 関連機能: データ変換
    #   Lambda関数を使用してストリームデータをリアルタイムに変換します。
    processing_configuration {

      # enabled (Optional)
      # 設定内容: データ変換処理を有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      enabled = true

      # processors (Optional)
      # 設定内容: データ変換に使用するプロセッサーの設定を指定します。
      processors {

        # type (Required)
        # 設定内容: プロセッサーのタイプを指定します。
        # 設定可能な値:
        #   - RecordDeAggregation: レコードの非集約化
        #   - Decompression: データの解凍
        #   - CloudWatchLogProcessing: CloudWatchログの処理
        #   - Lambda: Lambda関数による変換
        #   - MetadataExtraction: メタデータの抽出
        #   - AppendDelimiterToRecord: レコードへの区切り文字追加
        type = "Lambda"

        # parameters (Optional)
        # 設定内容: プロセッサーのパラメーターを指定します。
        parameters {

          # parameter_name (Required)
          # 設定内容: パラメーター名を指定します。
          # 設定可能な値: LambdaArn, NumberOfRetries, MetadataExtractionQuery,
          #              JsonParsingEngine, RoleArn, BufferSizeInMBs, BufferIntervalInSeconds,
          #              SubRecordType, Delimiter, CompressionFormat, DataMessageExtraction
          parameter_name = "LambdaArn"

          # parameter_value (Required)
          # 設定内容: パラメーターの値を指定します。
          # 設定可能な値: 文字列
          parameter_value = "arn:aws:lambda:ap-northeast-1:123456789012:function:firehose-transform:$LATEST"
        }

        parameters {
          parameter_name  = "NumberOfRetries"
          parameter_value = "3"
        }

        parameters {
          parameter_name  = "BufferSizeInMBs"
          parameter_value = "3"
        }

        parameters {
          parameter_name  = "BufferIntervalInSeconds"
          parameter_value = "60"
        }
      }
    }

    #-----------------------------------------------------------
    # データフォーマット変換設定
    #-----------------------------------------------------------

    # data_format_conversion_configuration (Optional, Max: 1)
    # 設定内容: JSONからApache ParquetまたはApache ORCへのフォーマット変換設定を指定します。
    # 関連機能: データフォーマット変換
    #   AWS Glueデータカタログを使用してJSONデータをParquet/ORC形式に変換します。
    data_format_conversion_configuration {

      # enabled (Optional)
      # 設定内容: データフォーマット変換を有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: true
      enabled = true

      # input_format_configuration (Required, Min: 1, Max: 1)
      # 設定内容: 入力データのフォーマット設定を指定します。
      input_format_configuration {

        # deserializer (Required, Min: 1, Max: 1)
        # 設定内容: 入力データのデシリアライザーを指定します。
        deserializer {

          # hive_json_ser_de (Optional, Max: 1)
          # 設定内容: Hive JSON SerDeを使用する場合の設定を指定します。
          hive_json_ser_de {

            # timestamp_formats (Optional)
            # 設定内容: タイムスタンプフィールドの形式リストを指定します。
            # 設定可能な値: タイムスタンプ形式文字列のリスト（例: ["dd/MMM/yyyy HH:mm:ss"]）
            # 省略時: デフォルトの形式を使用
            timestamp_formats = null
          }

          # open_x_json_ser_de (Optional, Max: 1)
          # 設定内容: OpenX JSON SerDeを使用する場合の設定を指定します。
          # 注意: hive_json_ser_deとopen_x_json_ser_deのどちらか一方を指定します。
          open_x_json_ser_de {

            # case_insensitive (Optional)
            # 設定内容: JSONキーの大文字小文字を区別しないかを指定します。
            # 設定可能な値: true / false
            # 省略時: false
            case_insensitive = false

            # column_to_json_key_mappings (Optional)
            # 設定内容: 列名とJSONキーのマッピングを指定します。
            # 設定可能な値: マップ形式のキーと値のペア
            # 省略時: マッピングなし
            column_to_json_key_mappings = null

            # convert_dots_in_json_keys_to_underscores (Optional)
            # 設定内容: JSONキーのドット（.）をアンダースコア（_）に変換するかを指定します。
            # 設定可能な値: true / false
            # 省略時: false
            convert_dots_in_json_keys_to_underscores = false
          }
        }
      }

      # output_format_configuration (Required, Min: 1, Max: 1)
      # 設定内容: 出力データのフォーマット設定を指定します。
      output_format_configuration {

        # serializer (Required, Min: 1, Max: 1)
        # 設定内容: 出力データのシリアライザーを指定します。
        serializer {

          # orc_ser_de (Optional, Max: 1)
          # 設定内容: Apache ORC形式で出力する場合の設定を指定します。
          orc_ser_de {

            # block_size_bytes (Optional)
            # 設定内容: ORCファイルのブロックサイズをバイト単位で指定します。
            # 設定可能な値: 数値（バイト）
            # 省略時: 268435456（256MB）
            block_size_bytes = null

            # bloom_filter_columns (Optional)
            # 設定内容: ブルームフィルターを作成する列名のリストを指定します。
            # 設定可能な値: 文字列のリスト
            # 省略時: なし
            bloom_filter_columns = null

            # bloom_filter_false_positive_probability (Optional)
            # 設定内容: ブルームフィルターの誤検知確率を指定します。
            # 設定可能な値: 0〜1の数値
            # 省略時: 0.05
            bloom_filter_false_positive_probability = null

            # compression (Optional)
            # 設定内容: ORC形式の圧縮形式を指定します。
            # 設定可能な値: NONE, ZLIB, SNAPPY
            # 省略時: SNAPPY
            compression = "SNAPPY"

            # dictionary_key_threshold (Optional)
            # 設定内容: 辞書エンコーディングを使用する最大割合を指定します。
            # 設定可能な値: 0〜1の数値
            # 省略時: 0
            dictionary_key_threshold = null

            # enable_padding (Optional)
            # 設定内容: パディングを有効にするかを指定します。
            # 設定可能な値: true / false
            # 省略時: false
            enable_padding = null

            # format_version (Optional)
            # 設定内容: OREのフォーマットバージョンを指定します。
            # 設定可能な値: V0_11, V0_12
            # 省略時: V0_12
            format_version = "V0_12"

            # padding_tolerance (Optional)
            # 設定内容: パディングの許容誤差割合を指定します。
            # 設定可能な値: 0〜1の数値
            # 省略時: 0.05
            padding_tolerance = null

            # row_index_stride (Optional)
            # 設定内容: インデックスエントリ間の行数を指定します。
            # 設定可能な値: 数値
            # 省略時: 10000
            row_index_stride = null

            # stripe_size_bytes (Optional)
            # 設定内容: ORCストライプのサイズをバイト単位で指定します。
            # 設定可能な値: 数値（バイト）
            # 省略時: 67108864（64MB）
            stripe_size_bytes = null
          }

          # parquet_ser_de (Optional, Max: 1)
          # 設定内容: Apache Parquet形式で出力する場合の設定を指定します。
          # 注意: orc_ser_deとparquet_ser_deのどちらか一方を指定します。
          parquet_ser_de {

            # block_size_bytes (Optional)
            # 設定内容: Parquetファイルのブロックサイズをバイト単位で指定します。
            # 設定可能な値: 数値（バイト）
            # 省略時: 268435456（256MB）
            block_size_bytes = null

            # compression (Optional)
            # 設定内容: Parquet形式の圧縮形式を指定します。
            # 設定可能な値: UNCOMPRESSED, GZIP, SNAPPY
            # 省略時: SNAPPY
            compression = "SNAPPY"

            # enable_dictionary_compression (Optional)
            # 設定内容: 辞書圧縮を有効にするかを指定します。
            # 設定可能な値: true / false
            # 省略時: false
            enable_dictionary_compression = null

            # max_padding_bytes (Optional)
            # 設定内容: ファイルに追加する最大パディングバイト数を指定します。
            # 設定可能な値: 数値（バイト）
            # 省略時: 0
            max_padding_bytes = null

            # page_size_bytes (Optional)
            # 設定内容: ページのサイズをバイト単位で指定します。
            # 設定可能な値: 数値（バイト）
            # 省略時: 1048576（1MB）
            page_size_bytes = null

            # writer_version (Optional)
            # 設定内容: Parquetライターのバージョンを指定します。
            # 設定可能な値: V1, V2
            # 省略時: V1
            writer_version = "V1"
          }
        }
      }

      # schema_configuration (Required, Min: 1, Max: 1)
      # 設定内容: AWS Glueデータカタログのスキーマ設定を指定します。
      schema_configuration {

        # database_name (Required)
        # 設定内容: Glueデータカタログのデータベース名を指定します。
        # 設定可能な値: 文字列
        database_name = "example_database"

        # table_name (Required)
        # 設定内容: Glueデータカタログのテーブル名を指定します。
        # 設定可能な値: 文字列
        table_name = "example_table"

        # role_arn (Required)
        # 設定内容: Glueデータカタログへのアクセスに使用するIAMロールのARNを指定します。
        # 設定可能な値: 有効なIAMロールARN
        role_arn = "arn:aws:iam::123456789012:role/firehose-delivery-role"

        # catalog_id (Optional, Computed)
        # 設定内容: Glueデータカタログのカタログを識別するIDを指定します。
        # 設定可能な値: AWSアカウントID
        # 省略時: AWSが現在のアカウントIDを自動設定
        catalog_id = null

        # region (Optional, Computed)
        # 設定内容: Glueデータカタログが存在するリージョンを指定します。
        # 設定可能な値: 有効なAWSリージョンコード
        # 省略時: 配信ストリームと同じリージョン
        region = null

        # version_id (Optional)
        # 設定内容: テーブルの特定バージョンを指定します。
        # 設定可能な値: 文字列（例: "LATEST"）
        # 省略時: LATEST
        version_id = "LATEST"
      }
    }

    #-----------------------------------------------------------
    # 動的パーティショニング設定
    #-----------------------------------------------------------

    # dynamic_partitioning_configuration (Optional, Max: 1)
    # 設定内容: 動的パーティショニングの設定を指定します。
    # 関連機能: 動的パーティショニング
    #   受信データのコンテンツに基づいてS3バケット内のデータをパーティション分割します。
    dynamic_partitioning_configuration {

      # enabled (Optional)
      # 設定内容: 動的パーティショニングを有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      enabled = false

      # retry_duration (Optional)
      # 設定内容: 動的パーティショニング失敗時のリトライ期間を秒単位で指定します。
      # 設定可能な値: 0〜7200（秒）
      # 省略時: 300（秒）
      retry_duration = null
    }

    #-----------------------------------------------------------
    # S3バックアップ設定
    #-----------------------------------------------------------

    # s3_backup_configuration (Optional, Max: 1)
    # 設定内容: 変換前の元データをS3にバックアップする設定を指定します。
    # 注意: s3_backup_modeが"Enabled"の場合に使用します。
    s3_backup_configuration {

      # bucket_arn (Required)
      # 設定内容: バックアップデータを保存するS3バケットのARNを指定します。
      # 設定可能な値: 有効なS3バケットARN
      bucket_arn = "arn:aws:s3:::example-firehose-backup-bucket"

      # role_arn (Required)
      # 設定内容: バックアップS3バケットへのアクセスに使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN
      role_arn = "arn:aws:iam::123456789012:role/firehose-delivery-role"

      # buffering_interval (Optional)
      # 設定内容: バックアップデータのバッファリング時間を秒単位で指定します。
      # 設定可能な値: 0〜900（秒）
      # 省略時: 300（秒）
      buffering_interval = null

      # buffering_size (Optional)
      # 設定内容: バックアップデータのバッファリングサイズをMB単位で指定します。
      # 設定可能な値: 1〜128（MB）
      # 省略時: 5（MB）
      buffering_size = null

      # compression_format (Optional)
      # 設定内容: バックアップデータの圧縮形式を指定します。
      # 設定可能な値: UNCOMPRESSED, GZIP, ZIP, Snappy, HADOOP_SNAPPY
      # 省略時: UNCOMPRESSED
      compression_format = null

      # prefix (Optional)
      # 設定内容: バックアップS3オブジェクトのプレフィックスを指定します。
      # 設定可能な値: 文字列
      # 省略時: プレフィックスなし
      prefix = "backup/"

      # error_output_prefix (Optional)
      # 設定内容: バックアップ配信失敗時のエラーデータを書き込むS3プレフィックスを指定します。
      # 設定可能な値: 文字列
      # 省略時: エラーデータはバケットルートに保存
      error_output_prefix = null

      # kms_key_arn (Optional)
      # 設定内容: バックアップS3オブジェクトの暗号化に使用するKMSキーのARNを指定します。
      # 設定可能な値: 有効なKMSキーARN
      # 省略時: AWSマネージドキーを使用
      kms_key_arn = null

      # cloudwatch_logging_options (Optional, Max: 1)
      # 設定内容: バックアップのCloudWatchログ設定を指定します。
      cloudwatch_logging_options {
        enabled         = false
        log_group_name  = null
        log_stream_name = null
      }
    }
  }

  #-------------------------------------------------------------
  # デスティネーション設定: Redshift
  #-------------------------------------------------------------

  # redshift_configuration (Optional, Max: 1)
  # 設定内容: Amazon Redshiftをデスティネーションとして使用する場合の設定を指定します。
  # 注意: destinationが"redshift"の場合に使用します。
  redshift_configuration {

    # cluster_jdbcurl (Required)
    # 設定内容: RedshiftクラスターのJDBC URLを指定します。
    # 設定可能な値: 文字列（例: "jdbc:redshift://host:5439/database"）
    cluster_jdbcurl = "jdbc:redshift://example.redshift.amazonaws.com:5439/example_db"

    # data_table_name (Required)
    # 設定内容: データを挿入するRedshiftテーブル名を指定します。
    # 設定可能な値: 文字列
    data_table_name = "example_table"

    # role_arn (Required)
    # 設定内容: Redshiftクラスターへのアクセスに使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    role_arn = "arn:aws:iam::123456789012:role/firehose-redshift-role"

    # username (Optional)
    # 設定内容: Redshiftクラスターへの接続に使用するユーザー名を指定します。
    # 設定可能な値: 文字列
    # 省略時: secrets_manager_configurationを使用する場合はnull可
    username = "firehose_user"

    # password (Optional, Sensitive)
    # 設定内容: Redshiftクラスターへの接続に使用するパスワードを指定します。
    # 設定可能な値: 文字列
    # 省略時: secrets_manager_configurationを使用する場合はnull可
    password = null

    # copy_options (Optional)
    # 設定内容: RedshiftのCOPYコマンドの追加オプションを指定します。
    # 設定可能な値: 文字列（例: "delimiter '|'"）
    # 省略時: オプションなし
    copy_options = null

    # data_table_columns (Optional)
    # 設定内容: データを挿入するRedshiftテーブルの列名をカンマ区切りで指定します。
    # 設定可能な値: 文字列（例: "col1,col2,col3"）
    # 省略時: すべての列
    data_table_columns = null

    # retry_duration (Optional)
    # 設定内容: Redshift配信失敗時のリトライ期間を秒単位で指定します。
    # 設定可能な値: 0〜7200（秒）
    # 省略時: 3600（秒）
    retry_duration = 3600

    # s3_backup_mode (Optional)
    # 設定内容: S3バックアップモードを指定します。
    # 設定可能な値:
    #   - Disabled: バックアップを無効化
    #   - Enabled: すべてのデータをバックアップ
    # 省略時: Disabled
    s3_backup_mode = "Disabled"

    # cloudwatch_logging_options (Optional, Max: 1)
    # 設定内容: CloudWatchログへの配信エラーのロギング設定を指定します。
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/example-stream"
      log_stream_name = "RedshiftDelivery"
    }

    # processing_configuration (Optional, Max: 1)
    # 設定内容: Lambdaを使用したデータ変換処理の設定を指定します。
    processing_configuration {
      enabled = false
    }

    # s3_configuration (Required, Min: 1, Max: 1)
    # 設定内容: RedshiftへのCOPYコマンド実行前にデータを中間保存するS3の設定を指定します。
    s3_configuration {

      # bucket_arn (Required)
      # 設定内容: 中間データを保存するS3バケットのARNを指定します。
      # 設定可能な値: 有効なS3バケットARN
      bucket_arn = "arn:aws:s3:::example-firehose-intermediate-bucket"

      # role_arn (Required)
      # 設定内容: S3バケットへのアクセスに使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN
      role_arn = "arn:aws:iam::123456789012:role/firehose-delivery-role"

      # buffering_interval (Optional)
      # 設定内容: バッファリング時間を秒単位で指定します。
      # 設定可能な値: 0〜900（秒）
      # 省略時: 300（秒）
      buffering_interval = null

      # buffering_size (Optional)
      # 設定内容: バッファリングサイズをMB単位で指定します。
      # 設定可能な値: 1〜128（MB）
      # 省略時: 5（MB）
      buffering_size = null

      # compression_format (Optional)
      # 設定内容: データの圧縮形式を指定します。
      # 設定可能な値: UNCOMPRESSED, GZIP, ZIP, Snappy, HADOOP_SNAPPY
      # 省略時: UNCOMPRESSED
      compression_format = "UNCOMPRESSED"

      # prefix (Optional)
      # 設定内容: S3オブジェクトのプレフィックスを指定します。
      # 設定可能な値: 文字列
      # 省略時: プレフィックスなし
      prefix = null

      # error_output_prefix (Optional)
      # 設定内容: エラーデータのS3プレフィックスを指定します。
      # 設定可能な値: 文字列
      # 省略時: エラーデータはバケットルートに保存
      error_output_prefix = null

      # kms_key_arn (Optional)
      # 設定内容: S3オブジェクトの暗号化に使用するKMSキーのARNを指定します。
      # 設定可能な値: 有効なKMSキーARN
      # 省略時: AWSマネージドキーを使用
      kms_key_arn = null

      cloudwatch_logging_options {
        enabled = false
      }
    }

    # s3_backup_configuration (Optional, Max: 1)
    # 設定内容: バックアップS3の設定を指定します。
    s3_backup_configuration {
      bucket_arn = "arn:aws:s3:::example-firehose-backup-bucket"
      role_arn   = "arn:aws:iam::123456789012:role/firehose-delivery-role"

      cloudwatch_logging_options {
        enabled = false
      }
    }

    # secrets_manager_configuration (Optional, Max: 1)
    # 設定内容: Redshiftの認証情報をSecrets Managerで管理する場合の設定を指定します。
    # 関連機能: Secrets Manager統合
    #   パスワードをハードコーディングせずにSecrets Managerで安全に管理できます。
    secrets_manager_configuration {

      # enabled (Optional, Computed)
      # 設定内容: Secrets Manager統合を有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: AWSが自動設定
      enabled = false

      # secret_arn (Optional)
      # 設定内容: Redshiftの認証情報を含むSecrets ManagerシークレットのARNを指定します。
      # 設定可能な値: 有効なSecrets Manager シークレットARN
      # 省略時: null（enabledがtrueの場合は必須）
      secret_arn = null

      # role_arn (Optional)
      # 設定内容: Secrets Managerへのアクセスに使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN
      # 省略時: null
      role_arn = null
    }
  }

  #-------------------------------------------------------------
  # デスティネーション設定: Elasticsearch
  #-------------------------------------------------------------

  # elasticsearch_configuration (Optional, Max: 1)
  # 設定内容: Amazon Elasticsearch Serviceをデスティネーションとして使用する場合の設定を指定します。
  # 注意: destinationが"elasticsearch"の場合に使用します。レガシーサービス向けです。
  elasticsearch_configuration {

    # index_name (Required)
    # 設定内容: データを配信するElasticsearchのインデックス名を指定します。
    # 設定可能な値: 文字列
    index_name = "example-index"

    # role_arn (Required)
    # 設定内容: Elasticsearchへのアクセスに使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    role_arn = "arn:aws:iam::123456789012:role/firehose-elasticsearch-role"

    # domain_arn (Optional)
    # 設定内容: ElasticsearchドメインのARNを指定します。
    # 設定可能な値: 有効なElasticsearchドメインARN
    # 注意: domain_arnとcluster_endpointのどちらか一方を指定します。
    domain_arn = "arn:aws:es:ap-northeast-1:123456789012:domain/example-domain"

    # cluster_endpoint (Optional)
    # 設定内容: Elasticsearchクラスターのエンドポイントを指定します。
    # 設定可能な値: 文字列（例: "https://example.ap-northeast-1.es.amazonaws.com"）
    # 省略時: domain_arnで指定
    cluster_endpoint = null

    # index_rotation_period (Optional)
    # 設定内容: インデックスのローテーション期間を指定します。
    # 設定可能な値: NoRotation, OneHour, OneDay, OneWeek, OneMonth
    # 省略時: OneDay
    index_rotation_period = "OneDay"

    # buffering_interval (Optional)
    # 設定内容: バッファリング時間を秒単位で指定します。
    # 設定可能な値: 60〜900（秒）
    # 省略時: 300（秒）
    buffering_interval = 300

    # buffering_size (Optional)
    # 設定内容: バッファリングサイズをMB単位で指定します。
    # 設定可能な値: 1〜100（MB）
    # 省略時: 5（MB）
    buffering_size = 5

    # retry_duration (Optional)
    # 設定内容: 配信失敗時のリトライ期間を秒単位で指定します。
    # 設定可能な値: 0〜7200（秒）
    # 省略時: 300（秒）
    retry_duration = 300

    # s3_backup_mode (Optional)
    # 設定内容: S3バックアップモードを指定します。
    # 設定可能な値: FailedDocumentsOnly, AllDocuments
    # 省略時: FailedDocumentsOnly
    s3_backup_mode = "FailedDocumentsOnly"

    # type_name (Optional)
    # 設定内容: Elasticsearchのタイプ名を指定します。
    # 設定可能な値: 文字列（Elasticsearch 6.x以降は"_doc"を使用、7.x以降は空文字列）
    # 省略時: 空文字列
    type_name = null

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/example-stream"
      log_stream_name = "ElasticsearchDelivery"
    }

    processing_configuration {
      enabled = false
    }

    # s3_configuration (Required, Min: 1, Max: 1)
    # 設定内容: バックアップ/失敗データを保存するS3の設定を指定します。
    s3_configuration {
      bucket_arn = "arn:aws:s3:::example-firehose-bucket"
      role_arn   = "arn:aws:iam::123456789012:role/firehose-delivery-role"

      cloudwatch_logging_options {
        enabled = false
      }
    }

    # vpc_config (Optional, Max: 1)
    # 設定内容: VPC内のElasticsearchにアクセスするためのVPC設定を指定します。
    vpc_config {

      # role_arn (Required)
      # 設定内容: VPCへのアクセスに使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN
      role_arn = "arn:aws:iam::123456789012:role/firehose-vpc-role"

      # security_group_ids (Required)
      # 設定内容: 使用するセキュリティグループIDのセットを指定します。
      # 設定可能な値: セキュリティグループIDのセット
      security_group_ids = ["sg-12345678"]

      # subnet_ids (Required)
      # 設定内容: 使用するサブネットIDのセットを指定します。
      # 設定可能な値: サブネットIDのセット
      subnet_ids = ["subnet-12345678", "subnet-87654321"]
    }
  }

  #-------------------------------------------------------------
  # デスティネーション設定: OpenSearch Service
  #-------------------------------------------------------------

  # opensearch_configuration (Optional, Max: 1)
  # 設定内容: Amazon OpenSearch Serviceをデスティネーションとして使用する場合の設定を指定します。
  # 注意: destinationが"opensearch"の場合に使用します。
  opensearch_configuration {

    # index_name (Required)
    # 設定内容: データを配信するOpenSearchのインデックス名を指定します。
    # 設定可能な値: 文字列
    index_name = "example-index"

    # role_arn (Required)
    # 設定内容: OpenSearch Serviceへのアクセスに使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    role_arn = "arn:aws:iam::123456789012:role/firehose-opensearch-role"

    # domain_arn (Optional)
    # 設定内容: OpenSearchドメインのARNを指定します。
    # 設定可能な値: 有効なOpenSearchドメインARN
    # 注意: domain_arnとcluster_endpointのどちらか一方を指定します。
    domain_arn = "arn:aws:es:ap-northeast-1:123456789012:domain/example-domain"

    # cluster_endpoint (Optional)
    # 設定内容: OpenSearchクラスターのエンドポイントを指定します。
    # 設定可能な値: 文字列
    # 省略時: domain_arnで指定
    cluster_endpoint = null

    # index_rotation_period (Optional)
    # 設定内容: インデックスのローテーション期間を指定します。
    # 設定可能な値: NoRotation, OneHour, OneDay, OneWeek, OneMonth
    # 省略時: NoRotation
    index_rotation_period = "NoRotation"

    # buffering_interval (Optional)
    # 設定内容: バッファリング時間を秒単位で指定します。
    # 設定可能な値: 60〜900（秒）
    # 省略時: 300（秒）
    buffering_interval = 300

    # buffering_size (Optional)
    # 設定内容: バッファリングサイズをMB単位で指定します。
    # 設定可能な値: 1〜100（MB）
    # 省略時: 5（MB）
    buffering_size = 5

    # retry_duration (Optional)
    # 設定内容: 配信失敗時のリトライ期間を秒単位で指定します。
    # 設定可能な値: 0〜7200（秒）
    # 省略時: 300（秒）
    retry_duration = 300

    # s3_backup_mode (Optional)
    # 設定内容: S3バックアップモードを指定します。
    # 設定可能な値: FailedDocumentsOnly, AllDocuments
    # 省略時: FailedDocumentsOnly
    s3_backup_mode = "FailedDocumentsOnly"

    # type_name (Optional)
    # 設定内容: OpenSearchのタイプ名を指定します。
    # 設定可能な値: 文字列
    # 省略時: 空文字列
    type_name = null

    # document_id_options (Optional, Max: 1)
    # 設定内容: ドキュメントIDの生成方法を指定します。
    document_id_options {

      # default_document_id_format (Required)
      # 設定内容: ドキュメントIDのデフォルト形式を指定します。
      # 設定可能な値:
      #   - FIREHOSE_DEFAULT: Firehoseのデフォルト形式（S3オブジェクトのパス-レコードインデックス）
      #   - NO_DOCUMENT_ID: ドキュメントIDを生成しない（OpenSearchに自動生成させる）
      default_document_id_format = "FIREHOSE_DEFAULT"
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/example-stream"
      log_stream_name = "OpenSearchDelivery"
    }

    processing_configuration {
      enabled = false
    }

    # s3_configuration (Required, Min: 1, Max: 1)
    # 設定内容: バックアップ/失敗データを保存するS3の設定を指定します。
    s3_configuration {
      bucket_arn = "arn:aws:s3:::example-firehose-bucket"
      role_arn   = "arn:aws:iam::123456789012:role/firehose-delivery-role"

      cloudwatch_logging_options {
        enabled = false
      }
    }

    vpc_config {
      role_arn           = "arn:aws:iam::123456789012:role/firehose-vpc-role"
      security_group_ids = ["sg-12345678"]
      subnet_ids         = ["subnet-12345678", "subnet-87654321"]
    }
  }

  #-------------------------------------------------------------
  # デスティネーション設定: OpenSearch Serverless
  #-------------------------------------------------------------

  # opensearchserverless_configuration (Optional, Max: 1)
  # 設定内容: Amazon OpenSearch Serverlessをデスティネーションとして使用する場合の設定を指定します。
  # 注意: destinationが"opensearchserverless"の場合に使用します。
  opensearchserverless_configuration {

    # collection_endpoint (Required)
    # 設定内容: OpenSearch Serverlessコレクションのエンドポイントを指定します。
    # 設定可能な値: 文字列（例: "https://xxxxxxxxxx.ap-northeast-1.aoss.amazonaws.com"）
    collection_endpoint = "https://xxxxxxxxxx.ap-northeast-1.aoss.amazonaws.com"

    # index_name (Required)
    # 設定内容: データを配信するインデックス名を指定します。
    # 設定可能な値: 文字列
    index_name = "example-index"

    # role_arn (Required)
    # 設定内容: OpenSearch Serverlessへのアクセスに使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    role_arn = "arn:aws:iam::123456789012:role/firehose-opensearch-serverless-role"

    # buffering_interval (Optional)
    # 設定内容: バッファリング時間を秒単位で指定します。
    # 設定可能な値: 60〜900（秒）
    # 省略時: 300（秒）
    buffering_interval = null

    # buffering_size (Optional)
    # 設定内容: バッファリングサイズをMB単位で指定します。
    # 設定可能な値: 1〜100（MB）
    # 省略時: 5（MB）
    buffering_size = null

    # retry_duration (Optional)
    # 設定内容: 配信失敗時のリトライ期間を秒単位で指定します。
    # 設定可能な値: 0〜7200（秒）
    # 省略時: 300（秒）
    retry_duration = null

    # s3_backup_mode (Optional)
    # 設定内容: S3バックアップモードを指定します。
    # 設定可能な値: FailedDocumentsOnly, AllDocuments
    # 省略時: FailedDocumentsOnly
    s3_backup_mode = "FailedDocumentsOnly"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/example-stream"
      log_stream_name = "OpenSearchServerlessDelivery"
    }

    processing_configuration {
      enabled = false
    }

    # s3_configuration (Required, Min: 1, Max: 1)
    # 設定内容: バックアップ/失敗データを保存するS3の設定を指定します。
    s3_configuration {
      bucket_arn = "arn:aws:s3:::example-firehose-bucket"
      role_arn   = "arn:aws:iam::123456789012:role/firehose-delivery-role"

      cloudwatch_logging_options {
        enabled = false
      }
    }

    # vpc_config (Optional, Max: 1)
    # 設定内容: VPC内のOpenSearch Serverlessにアクセスするためのネットワーク設定を指定します。
    vpc_config {
      role_arn           = "arn:aws:iam::123456789012:role/firehose-vpc-role"
      security_group_ids = ["sg-12345678"]
      subnet_ids         = ["subnet-12345678", "subnet-87654321"]
    }
  }

  #-------------------------------------------------------------
  # デスティネーション設定: HTTP エンドポイント
  #-------------------------------------------------------------

  # http_endpoint_configuration (Optional, Max: 1)
  # 設定内容: HTTPエンドポイントをデスティネーションとして使用する場合の設定を指定します。
  # 注意: destinationが"http_endpoint"の場合に使用します。
  http_endpoint_configuration {

    # url (Required)
    # 設定内容: HTTPエンドポイントのURLを指定します。
    # 設定可能な値: 有効なHTTPS URL（例: "https://example.com/endpoint"）
    url = "https://example.com/firehose"

    # name (Optional)
    # 設定内容: HTTPエンドポイントの名前を指定します。
    # 設定可能な値: 文字列（1〜256文字）
    # 省略時: エンドポイント名なし
    name = "example-http-endpoint"

    # access_key (Optional, Sensitive)
    # 設定内容: HTTPエンドポイントへの認証に使用するアクセスキーを指定します。
    # 設定可能な値: 文字列（最大4096文字）
    # 省略時: 認証キーなし
    access_key = null

    # buffering_interval (Optional)
    # 設定内容: バッファリング時間を秒単位で指定します。
    # 設定可能な値: 0〜900（秒）
    # 省略時: 300（秒）
    buffering_interval = 300

    # buffering_size (Optional)
    # 設定内容: バッファリングサイズをMB単位で指定します。
    # 設定可能な値: 1〜100（MB）
    # 省略時: 5（MB）
    buffering_size = 5

    # role_arn (Optional)
    # 設定内容: エンドポイントへのアクセスに使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 省略時: null
    role_arn = "arn:aws:iam::123456789012:role/firehose-http-role"

    # retry_duration (Optional)
    # 設定内容: 配信失敗時のリトライ期間を秒単位で指定します。
    # 設定可能な値: 0〜7200（秒）
    # 省略時: 300（秒）
    retry_duration = 300

    # s3_backup_mode (Optional)
    # 設定内容: S3バックアップモードを指定します。
    # 設定可能な値:
    #   - FailedDataOnly: 配信失敗データのみバックアップ
    #   - AllData: すべてのデータをバックアップ
    # 省略時: FailedDataOnly
    s3_backup_mode = "FailedDataOnly"

    # request_configuration (Optional, Max: 1)
    # 設定内容: HTTPエンドポイントへのリクエスト設定を指定します。
    request_configuration {

      # content_encoding (Optional)
      # 設定内容: リクエストボディのコンテンツエンコーディングを指定します。
      # 設定可能な値:
      #   - NONE: エンコーディングなし
      #   - GZIP: GZIP形式
      # 省略時: NONE
      content_encoding = "GZIP"

      # common_attributes (Optional)
      # 設定内容: すべてのリクエストに追加する共通属性を指定します。
      common_attributes {

        # name (Required)
        # 設定内容: 属性名を指定します。
        # 設定可能な値: 文字列
        name = "x-custom-header"

        # value (Required)
        # 設定内容: 属性値を指定します。
        # 設定可能な値: 文字列
        value = "example-value"
      }
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/example-stream"
      log_stream_name = "HttpEndpointDelivery"
    }

    processing_configuration {
      enabled = false
    }

    # s3_configuration (Required, Min: 1, Max: 1)
    # 設定内容: バックアップ/失敗データを保存するS3の設定を指定します。
    s3_configuration {
      bucket_arn = "arn:aws:s3:::example-firehose-bucket"
      role_arn   = "arn:aws:iam::123456789012:role/firehose-delivery-role"

      cloudwatch_logging_options {
        enabled = false
      }
    }

    # secrets_manager_configuration (Optional, Max: 1)
    # 設定内容: HTTPエンドポイントの認証情報をSecrets Managerで管理する場合の設定を指定します。
    secrets_manager_configuration {
      enabled    = false
      secret_arn = null
      role_arn   = null
    }
  }

  #-------------------------------------------------------------
  # デスティネーション設定: Snowflake
  #-------------------------------------------------------------

  # snowflake_configuration (Optional, Max: 1)
  # 設定内容: Snowflakeをデスティネーションとして使用する場合の設定を指定します。
  # 注意: destinationが"snowflake"の場合に使用します。
  snowflake_configuration {

    # account_url (Required)
    # 設定内容: SnowflakeアカウントのURLを指定します。
    # 設定可能な値: 文字列（例: "https://account.snowflakecomputing.com"）
    account_url = "https://example.snowflakecomputing.com"

    # database (Required)
    # 設定内容: データを書き込むSnowflakeデータベース名を指定します。
    # 設定可能な値: 文字列
    database = "EXAMPLE_DB"

    # schema (Required)
    # 設定内容: データを書き込むSnowflakeスキーマ名を指定します。
    # 設定可能な値: 文字列
    schema = "EXAMPLE_SCHEMA"

    # table (Required)
    # 設定内容: データを書き込むSnowflakeテーブル名を指定します。
    # 設定可能な値: 文字列
    table = "EXAMPLE_TABLE"

    # role_arn (Required)
    # 設定内容: Snowflakeへのアクセスに使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    role_arn = "arn:aws:iam::123456789012:role/firehose-snowflake-role"

    # user (Optional)
    # 設定内容: Snowflakeへの接続に使用するユーザー名を指定します。
    # 設定可能な値: 文字列
    # 省略時: secrets_manager_configurationを使用する場合はnull可
    user = "firehose_user"

    # private_key (Optional, Sensitive)
    # 設定内容: Snowflake認証に使用するプライベートキーを指定します。
    # 設定可能な値: PEM形式の秘密鍵文字列
    # 省略時: secrets_manager_configurationを使用する場合はnull可
    private_key = null

    # key_passphrase (Optional, Sensitive)
    # 設定内容: プライベートキーのパスフレーズを指定します。
    # 設定可能な値: 文字列
    # 省略時: パスフレーズなし
    key_passphrase = null

    # data_loading_option (Optional)
    # 設定内容: データのロードオプションを指定します。
    # 設定可能な値:
    #   - JSON_MAPPING: JSONマッピングを使用してデータをロード
    #   - VARIANT_CONTENT_MAPPING: バリアントコンテンツマッピングを使用
    #   - VARIANT_CONTENT_AND_METADATA_MAPPING: バリアントコンテンツとメタデータマッピングを使用
    # 省略時: JSON_MAPPING
    data_loading_option = "JSON_MAPPING"

    # content_column_name (Optional)
    # 設定内容: コンテンツを格納する列名を指定します。
    # 設定可能な値: 文字列
    # 省略時: data_loading_optionに応じたデフォルト値
    content_column_name = null

    # metadata_column_name (Optional)
    # 設定内容: メタデータを格納する列名を指定します。
    # 設定可能な値: 文字列
    # 省略時: null
    metadata_column_name = null

    # buffering_interval (Optional)
    # 設定内容: バッファリング時間を秒単位で指定します。
    # 設定可能な値: 0〜900（秒）
    # 省略時: 0（秒）
    buffering_interval = null

    # buffering_size (Optional)
    # 設定内容: バッファリングサイズをMB単位で指定します。
    # 設定可能な値: 1〜128（MB）
    # 省略時: 1（MB）
    buffering_size = null

    # retry_duration (Optional)
    # 設定内容: 配信失敗時のリトライ期間を秒単位で指定します。
    # 設定可能な値: 0〜7200（秒）
    # 省略時: 60（秒）
    retry_duration = null

    # s3_backup_mode (Optional)
    # 設定内容: S3バックアップモードを指定します。
    # 設定可能な値:
    #   - FailedDataOnly: 配信失敗データのみバックアップ
    #   - AllData: すべてのデータをバックアップ
    # 省略時: FailedDataOnly
    s3_backup_mode = "FailedDataOnly"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/example-stream"
      log_stream_name = "SnowflakeDelivery"
    }

    processing_configuration {
      enabled = false
    }

    # snowflake_role_configuration (Optional, Max: 1)
    # 設定内容: Snowflakeのロール設定を指定します。
    snowflake_role_configuration {

      # enabled (Optional)
      # 設定内容: カスタムSnowflakeロールを使用するかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      enabled = false

      # snowflake_role (Optional)
      # 設定内容: 使用するSnowflakeロール名を指定します。
      # 設定可能な値: 文字列
      # 省略時: null
      snowflake_role = null
    }

    # snowflake_vpc_configuration (Optional, Max: 1)
    # 設定内容: SnowflakeへのプライベートリンクVPC設定を指定します。
    snowflake_vpc_configuration {

      # private_link_vpce_id (Required)
      # 設定内容: SnowflakeへのプライベートリンクのVPCエンドポイントIDを指定します。
      # 設定可能な値: 文字列（VPCエンドポイントID）
      private_link_vpce_id = "vpce-xxxxxxxxxxxxxxxxx"
    }

    # s3_configuration (Required, Min: 1, Max: 1)
    # 設定内容: バックアップ/失敗データを保存するS3の設定を指定します。
    s3_configuration {
      bucket_arn = "arn:aws:s3:::example-firehose-bucket"
      role_arn   = "arn:aws:iam::123456789012:role/firehose-delivery-role"

      cloudwatch_logging_options {
        enabled = false
      }
    }

    # secrets_manager_configuration (Optional, Max: 1)
    # 設定内容: Snowflakeの認証情報をSecrets Managerで管理する場合の設定を指定します。
    secrets_manager_configuration {
      enabled    = false
      secret_arn = null
      role_arn   = null
    }
  }

  #-------------------------------------------------------------
  # デスティネーション設定: Splunk
  #-------------------------------------------------------------

  # splunk_configuration (Optional, Max: 1)
  # 設定内容: Splunkをデスティネーションとして使用する場合の設定を指定します。
  # 注意: destinationが"splunk"の場合に使用します。
  splunk_configuration {

    # hec_endpoint (Required)
    # 設定内容: SplunkのHTTPイベントコレクター（HEC）エンドポイントのURLを指定します。
    # 設定可能な値: 文字列（例: "https://example.splunkcloud.com:8088"）
    hec_endpoint = "https://http-inputs-example.splunkcloud.com:443"

    # hec_endpoint_type (Optional)
    # 設定内容: HECエンドポイントのタイプを指定します。
    # 設定可能な値:
    #   - Raw: 生のHECエンドポイント
    #   - Event: イベントHECエンドポイント
    # 省略時: Raw
    hec_endpoint_type = "Raw"

    # hec_token (Optional)
    # 設定内容: SplunkのHECトークンを指定します。
    # 設定可能な値: 文字列（GUIDフォーマット）
    # 省略時: secrets_manager_configurationを使用する場合はnull可
    hec_token = null

    # hec_acknowledgment_timeout (Optional)
    # 設定内容: HECの確認応答タイムアウトを秒単位で指定します。
    # 設定可能な値: 180〜600（秒）
    # 省略時: 180（秒）
    hec_acknowledgment_timeout = 180

    # buffering_interval (Optional)
    # 設定内容: バッファリング時間を秒単位で指定します。
    # 設定可能な値: 0〜60（秒）
    # 省略時: 60（秒）
    buffering_interval = null

    # buffering_size (Optional)
    # 設定内容: バッファリングサイズをMB単位で指定します。
    # 設定可能な値: 1〜5（MB）
    # 省略時: 5（MB）
    buffering_size = null

    # retry_duration (Optional)
    # 設定内容: 配信失敗時のリトライ期間を秒単位で指定します。
    # 設定可能な値: 0〜7200（秒）
    # 省略時: 3600（秒）
    retry_duration = 3600

    # s3_backup_mode (Optional)
    # 設定内容: S3バックアップモードを指定します。
    # 設定可能な値:
    #   - FailedEventsOnly: 配信失敗データのみバックアップ
    #   - AllEvents: すべてのデータをバックアップ
    # 省略時: FailedEventsOnly
    s3_backup_mode = "FailedEventsOnly"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/example-stream"
      log_stream_name = "SplunkDelivery"
    }

    processing_configuration {
      enabled = false
    }

    # s3_configuration (Required, Min: 1, Max: 1)
    # 設定内容: バックアップ/失敗データを保存するS3の設定を指定します。
    s3_configuration {
      bucket_arn = "arn:aws:s3:::example-firehose-bucket"
      role_arn   = "arn:aws:iam::123456789012:role/firehose-delivery-role"

      cloudwatch_logging_options {
        enabled = false
      }
    }

    # secrets_manager_configuration (Optional, Max: 1)
    # 設定内容: SplunkのHECトークンをSecrets Managerで管理する場合の設定を指定します。
    secrets_manager_configuration {
      enabled    = false
      secret_arn = null
      role_arn   = null
    }
  }

  #-------------------------------------------------------------
  # デスティネーション設定: Apache Iceberg
  #-------------------------------------------------------------

  # iceberg_configuration (Optional, Max: 1)
  # 設定内容: Apache Icebergテーブルをデスティネーションとして使用する場合の設定を指定します。
  # 注意: destinationが"iceberg"の場合に使用します。
  iceberg_configuration {

    # catalog_arn (Required)
    # 設定内容: Icebergテーブルのカタログ（AWS Glue Data CatalogまたはAWS Lake Formation）のARNを指定します。
    # 設定可能な値: 有効なGlueカタログARN
    catalog_arn = "arn:aws:glue:ap-northeast-1:123456789012:catalog"

    # role_arn (Required)
    # 設定内容: Icebergテーブルへのアクセスに使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    role_arn = "arn:aws:iam::123456789012:role/firehose-iceberg-role"

    # buffering_interval (Optional)
    # 設定内容: バッファリング時間を秒単位で指定します。
    # 設定可能な値: 0〜900（秒）
    # 省略時: 300（秒）
    buffering_interval = null

    # buffering_size (Optional)
    # 設定内容: バッファリングサイズをMB単位で指定します。
    # 設定可能な値: 1〜128（MB）
    # 省略時: 5（MB）
    buffering_size = null

    # retry_duration (Optional)
    # 設定内容: 配信失敗時のリトライ期間を秒単位で指定します。
    # 設定可能な値: 0〜7200（秒）
    # 省略時: 300（秒）
    retry_duration = null

    # s3_backup_mode (Optional)
    # 設定内容: S3バックアップモードを指定します。
    # 設定可能な値:
    #   - FailedDataOnly: 配信失敗データのみバックアップ
    #   - AllData: すべてのデータをバックアップ
    # 省略時: FailedDataOnly
    s3_backup_mode = "FailedDataOnly"

    # append_only (Optional, Computed)
    # 設定内容: Icebergテーブルへの書き込みを追加専用モードにするかを指定します。
    # 設定可能な値: true / false
    # 省略時: AWSが自動設定
    append_only = null

    # destination_table_configuration (Optional)
    # 設定内容: データを書き込むIcebergテーブルの設定を指定します（複数指定可能）。
    destination_table_configuration {

      # database_name (Required)
      # 設定内容: Glueデータカタログのデータベース名を指定します。
      # 設定可能な値: 文字列
      database_name = "example_database"

      # table_name (Required)
      # 設定内容: Icebergテーブル名を指定します。
      # 設定可能な値: 文字列
      table_name = "example_iceberg_table"

      # unique_keys (Optional)
      # 設定内容: Icebergテーブルのユニークキーとして使用する列名のリストを指定します。
      # 設定可能な値: 文字列のリスト
      # 省略時: ユニークキーなし
      unique_keys = null

      # s3_error_output_prefix (Optional)
      # 設定内容: Icebergへの配信失敗時にエラーデータを書き込むS3プレフィックスを指定します。
      # 設定可能な値: 文字列
      # 省略時: エラーデータはバケットルートに保存
      s3_error_output_prefix = null
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/example-stream"
      log_stream_name = "IcebergDelivery"
    }

    processing_configuration {
      enabled = false
    }

    # s3_configuration (Required, Min: 1, Max: 1)
    # 設定内容: Icebergテーブルの実際のデータを保存するS3の設定を指定します。
    s3_configuration {
      bucket_arn = "arn:aws:s3:::example-iceberg-data-bucket"
      role_arn   = "arn:aws:iam::123456789012:role/firehose-delivery-role"

      cloudwatch_logging_options {
        enabled = false
      }
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトを指定します。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 配信ストリームのARN（arnと同一）
# - arn: 配信ストリームのARN
# - destination_id: デスティネーションのID
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
# - version_id: 配信ストリームのバージョンID（更新時に変化）
# - region: リソースが管理されているリージョン
#
# elasticsearch_configuration.vpc_config:
# - vpc_id: VPCのID
#
# opensearch_configuration.vpc_config:
# - vpc_id: VPCのID
#
# opensearchserverless_configuration.vpc_config:
# - vpc_id: VPCのID
#
#---------------------------------------------------------------
