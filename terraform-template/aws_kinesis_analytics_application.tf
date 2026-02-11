#---------------------------------------------------------------
# Amazon Kinesis Data Analytics Application (SQL Applications)
#---------------------------------------------------------------
#
# Amazon Kinesis Data Analytics for SQL Applicationsのリソースを作成します。
# ストリーミングデータを標準SQLを使用してリアルタイムに処理・分析できる
# マネージドサービスです。Kinesis Data StreamsまたはKinesis Data Firehose
# から入力を受け取り、SQLクエリで処理し、結果を様々な宛先に出力できます。
#
# 重要な注意事項:
# このリソースは非推奨であり、将来のバージョンで削除されます。
# 2026年1月27日をもって、AWSはKinesis Data Analytics for SQLのサポートを
# 終了します。新規アプリケーションには aws_kinesisanalyticsv2_application
# リソースを使用してApache Flinkアプリケーションを管理してください。
#
# AWS公式ドキュメント:
#   - Kinesis Data Analytics for SQL Applications Developer Guide:
#     https://docs.aws.amazon.com/kinesisanalytics/latest/dev/index.html
#   - サービス終了のお知らせ:
#     https://docs.aws.amazon.com/kinesisanalytics/latest/dev/discontinuation.html
#   - Apache Flinkへの移行ガイド:
#     https://aws.amazon.com/blogs/big-data/migrate-from-amazon-kinesis-data-analytics-for-sql-to-amazon-managed-service-for-apache-flink-and-amazon-managed-service-for-apache-flink-studio/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_analytics_application
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesis_analytics_application" "example" {
  # (Required) アプリケーション名
  # Kinesis Analyticsアプリケーションの一意な名前を指定します。
  name = "example-analytics-app"

  # (Optional) SQLコード
  # 入力データを変換し、出力を生成するためのSQLコードを指定します。
  # ストリーミングデータの処理、集計、変換などのロジックを記述します。
  # ANSI 2008 SQL標準とストリーミング拡張をサポートしています。
  code = <<SQL
CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (
  column1 VARCHAR(16),
  column2 BIGINT
);

CREATE OR REPLACE PUMP "STREAM_PUMP" AS
INSERT INTO "DESTINATION_SQL_STREAM"
SELECT STREAM column1, column2
FROM "SOURCE_SQL_STREAM_001";
SQL

  # (Optional) アプリケーションの説明
  # アプリケーションの目的や動作の説明を記述します。
  description = "Example Kinesis Analytics Application for streaming data processing"

  # (Optional) ID
  # Terraformリソースの識別子です。通常は自動計算されますが、
  # インポート時など特定の場合に明示的に指定できます。
  # id = "example-id"

  # (Optional) リージョン指定
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合はプロバイダー設定のリージョンが使用されます。
  # region = "us-east-1"

  # (Optional) アプリケーションの起動設定
  # trueに設定するとアプリケーションを起動します。
  # アプリケーションを起動するには、starting_positionが定義された入力が必要です。
  # starting_positionを変更する場合は、まずfalseで停止してから変更し、
  # その後trueで再起動してください。
  start_application = false

  # (Optional) タグ
  # リソースに付与するキーと値のペアのマップです。
  # default_tagsと組み合わせて使用できます。
  tags = {
    Environment = "development"
    Application = "streaming-analytics"
  }

  # (Optional) すべてのタグ
  # プロバイダーのdefault_tagsを含む、すべてのタグのマップです。
  # 通常は自動計算されますが、明示的に指定することもできます。
  # tags_all = {
  #   Environment = "development"
  #   Application = "streaming-analytics"
  #   ManagedBy   = "terraform"
  # }

  #---------------------------------------------------------------
  # CloudWatch Logging Options
  #---------------------------------------------------------------
  # (Optional) CloudWatchログストリームの設定
  # アプリケーションエラーを監視するためのCloudWatchログストリームオプション。
  # 最大1つまで指定可能です。
  cloudwatch_logging_options {
    # (Required) CloudWatch LogストリームのARN
    log_stream_arn = "arn:aws:logs:us-east-1:123456789012:log-group:analytics-log-group:log-stream:analytics-log-stream"

    # (Required) IAMロールのARN
    # アプリケーションメッセージを送信するために使用されるIAMロールのARNです。
    role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-cloudwatch-role"
  }

  #---------------------------------------------------------------
  # Inputs Configuration
  #---------------------------------------------------------------
  # (Optional) アプリケーションの入力設定
  # ストリーミングソースからのデータ入力を構成します。
  # 最大1つまで指定可能です。
  inputs {
    # (Required) ストリームプレフィックス名
    # アプリケーション内ストリームを作成する際に使用する名前プレフィックスです。
    name_prefix = "SOURCE_SQL_STREAM"

    #---------------------------------------------------------------
    # Input Source: Kinesis Stream
    #---------------------------------------------------------------
    # (Optional) Kinesis Streamの設定
    # ストリーミングソースとしてKinesis Streamを使用します。
    # kinesis_firehoseとは排他的です（どちらか一方のみ指定可能）。
    kinesis_stream {
      # (Required) Kinesis StreamのARN
      resource_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/example-stream"

      # (Required) IAMロールのARN
      # ストリームへのアクセスに使用されるIAMロールのARNです。
      role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-input-role"
    }

    #---------------------------------------------------------------
    # Input Source: Kinesis Firehose (Alternative)
    #---------------------------------------------------------------
    # (Optional) Kinesis Firehoseの設定
    # ストリーミングソースとしてKinesis Firehoseを使用します。
    # kinesis_streamとは排他的です（どちらか一方のみ指定可能）。
    # kinesis_firehose {
    #   # (Required) Kinesis Firehose配信ストリームのARN
    #   resource_arn = "arn:aws:firehose:us-east-1:123456789012:deliverystream/example-firehose"
    #
    #   # (Required) IAMロールのARN
    #   # ストリームへのアクセスに使用されるIAMロールのARNです。
    #   role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-firehose-role"
    # }

    #---------------------------------------------------------------
    # Parallelism Configuration
    #---------------------------------------------------------------
    # (Optional) 並列処理の設定
    # 作成するアプリケーション内並列ストリームの数を指定します。
    # 最大1つまで指定可能です。
    parallelism {
      # (Optional) ストリームの数
      # 並列処理するストリームの数を指定します。
      # 指定しない場合は自動的に設定されます。
      count = 1
    }

    #---------------------------------------------------------------
    # Processing Configuration
    #---------------------------------------------------------------
    # (Optional) 処理設定
    # ストリームから受信したレコードを変換する処理設定です。
    # Lambda関数を使用してデータの前処理や変換を行います。
    # 最大1つまで指定可能です。
    # processing_configuration {
    #   lambda {
    #     # (Required) Lambda関数のARN
    #     resource_arn = "arn:aws:lambda:us-east-1:123456789012:function:preprocessing-function"
    #
    #     # (Required) IAMロールのARN
    #     # Lambda関数へのアクセスに使用されるIAMロールのARNです。
    #     role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-lambda-role"
    #   }
    # }

    #---------------------------------------------------------------
    # Schema Configuration
    #---------------------------------------------------------------
    # (Required) スキーマ設定
    # ストリーミングソース内のデータのスキーマフォーマットを定義します。
    # 最大1つまで指定可能です。
    schema {
      # (Optional) レコードのエンコーディング
      # ストリーミングソース内のレコードのエンコーディングを指定します。
      # 例: "UTF-8"
      record_encoding = "UTF-8"

      #---------------------------------------------------------------
      # Record Columns
      #---------------------------------------------------------------
      # (Required) レコードカラムのマッピング
      # ストリーミングソースデータ要素のレコードカラムマッピングです。
      # 最小1つ、最大1000個まで指定可能です。
      record_columns {
        # (Required) カラム名
        name = "column1"

        # (Required) カラムのSQLタイプ
        # 例: VARCHAR(16), INTEGER, BIGINT, DOUBLE, TIMESTAMP, etc.
        sql_type = "VARCHAR(16)"

        # (Optional) データ要素へのマッピング参照
        # JSONパス式を使用してデータ要素をマッピングします。
        # 例: "$.fieldName"
        mapping = "$.column1"
      }

      record_columns {
        name     = "column2"
        sql_type = "BIGINT"
        mapping  = "$.column2"
      }

      #---------------------------------------------------------------
      # Record Format
      #---------------------------------------------------------------
      # (Required) レコードフォーマット
      # レコードをスキーマ化するためのレコードフォーマットとマッピング情報です。
      # 最小1つ、最大1つまで指定可能です。
      record_format {
        #---------------------------------------------------------------
        # Mapping Parameters
        #---------------------------------------------------------------
        # (Optional) マッピングパラメータ
        # レコードフォーマットのマッピング情報を定義します。
        # csvまたはjsonのいずれかを指定します。
        # 最大1つまで指定可能です。
        mapping_parameters {
          # (Optional) JSONマッピングパラメータ
          # レコードフォーマットがJSONの場合のマッピング情報です。
          # csvとは排他的です（どちらか一方のみ指定可能）。
          json {
            # (Required) レコードを含むトップレベル親へのパス
            # JSONPathを使用してレコードの位置を指定します。
            # ルート要素を指すには "$" を使用します。
            record_row_path = "$"
          }

          # (Optional) CSVマッピングパラメータ
          # レコードフォーマットが区切り文字を使用する場合のマッピング情報です。
          # jsonとは排他的です（どちらか一方のみ指定可能）。
          # csv {
          #   # (Required) カラムの区切り文字
          #   record_column_delimiter = ","
          #
          #   # (Required) 行の区切り文字
          #   record_row_delimiter = "\n"
          # }
        }
      }
    }

    #---------------------------------------------------------------
    # Starting Position Configuration
    #---------------------------------------------------------------
    # (Optional) 開始位置の設定
    # ストリームの開始位置を指定します。
    # start_applicationをtrueにする場合は必須です。
    starting_position_configuration {
      # (Optional) 開始位置
      # 有効な値:
      # - LAST_STOPPED_POINT: 前回停止した位置から再開
      # - NOW: 現在のタイムスタンプから開始
      # - TRIM_HORIZON: ストリームの最も古いレコードから開始
      starting_position = "NOW"
    }
  }

  #---------------------------------------------------------------
  # Outputs Configuration
  #---------------------------------------------------------------
  # (Optional) 出力先の設定
  # アプリケーションの出力先を構成します。
  # 最大3つまで指定可能です。
  outputs {
    # (Required) アプリケーション内ストリームの名前
    name = "OUTPUT_STREAM_1"

    #---------------------------------------------------------------
    # Output Schema
    #---------------------------------------------------------------
    # (Required) 出力スキーマ
    # 宛先に書き込まれるデータのスキーマフォーマットです。
    # 最小1つ、最大1つまで指定可能です。
    schema {
      # (Required) レコードフォーマットタイプ
      # 出力ストリームのレコードのフォーマットタイプです。
      # 有効な値: CSV, JSON
      record_format_type = "JSON"
    }

    #---------------------------------------------------------------
    # Output Destination: Kinesis Stream
    #---------------------------------------------------------------
    # (Optional) Kinesis Streamへの出力設定
    # 出力先としてKinesis Streamを使用します。
    # kinesis_firehoseおよびlambdaとは排他的です。
    kinesis_stream {
      # (Required) Kinesis StreamのARN
      resource_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/output-stream"

      # (Required) IAMロールのARN
      # ストリームへのアクセスに使用されるIAMロールのARNです。
      role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-output-role"
    }

    #---------------------------------------------------------------
    # Output Destination: Kinesis Firehose (Alternative)
    #---------------------------------------------------------------
    # (Optional) Kinesis Firehoseへの出力設定
    # 出力先としてKinesis Firehoseを使用します。
    # kinesis_streamおよびlambdaとは排他的です。
    # kinesis_firehose {
    #   # (Required) Kinesis Firehose配信ストリームのARN
    #   resource_arn = "arn:aws:firehose:us-east-1:123456789012:deliverystream/output-firehose"
    #
    #   # (Required) IAMロールのARN
    #   role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-firehose-output-role"
    # }

    #---------------------------------------------------------------
    # Output Destination: Lambda (Alternative)
    #---------------------------------------------------------------
    # (Optional) Lambda関数への出力設定
    # 出力先としてLambda関数を使用します。
    # kinesis_streamおよびkinesis_firehoseとは排他的です。
    # lambda {
    #   # (Required) Lambda関数のARN
    #   resource_arn = "arn:aws:lambda:us-east-1:123456789012:function:output-function"
    #
    #   # (Required) IAMロールのARN
    #   # Lambda関数へのアクセスに使用されるIAMロールのARNです。
    #   role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-lambda-output-role"
    # }
  }

  #---------------------------------------------------------------
  # Reference Data Sources
  #---------------------------------------------------------------
  # (Optional) 参照データソース
  # アプリケーション用のS3参照データソースを設定します。
  # 静的データでストリーミングデータを強化するために使用します。
  # 最大1つまで指定可能です。
  # reference_data_sources {
  #   # (Required) アプリケーション内テーブル名
  #   # 参照データを格納するテーブルの名前です。
  #   table_name = "REFERENCE_TABLE"
  #
  #   #---------------------------------------------------------------
  #   # S3 Reference Configuration
  #   #---------------------------------------------------------------
  #   # (Required) S3設定
  #   # 参照データソースのS3設定です。
  #   # 最小1つ、最大1つまで指定可能です。
  #   s3 {
  #     # (Required) S3バケットのARN
  #     bucket_arn = "arn:aws:s3:::reference-data-bucket"
  #
  #     # (Required) 参照データを含むファイルキー名
  #     file_key = "reference-data/data.csv"
  #
  #     # (Required) データを読み取るIAMロールのARN
  #     role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-s3-role"
  #   }
  #
  #   #---------------------------------------------------------------
  #   # Reference Data Schema
  #   #---------------------------------------------------------------
  #   # (Required) スキーマ設定
  #   # 参照データのスキーマフォーマットです。
  #   # 最小1つ、最大1つまで指定可能です。
  #   schema {
  #     # (Optional) レコードのエンコーディング
  #     record_encoding = "UTF-8"
  #
  #     # (Required) レコードカラム
  #     # 最小1つ、最大1000個まで指定可能です。
  #     record_columns {
  #       name     = "ref_column1"
  #       sql_type = "VARCHAR(64)"
  #       mapping  = "$.ref_column1"
  #     }
  #
  #     # (Required) レコードフォーマット
  #     # 最小1つ、最大1つまで指定可能です。
  #     record_format {
  #       mapping_parameters {
  #         csv {
  #           record_column_delimiter = ","
  #           record_row_delimiter    = "\n"
  #         }
  #       }
  #     }
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はcomputed(計算値)として提供されます:
#
# - id: Kinesis Analytics ApplicationのARN
# - arn: Kinesis Analytics ApplicationのARN
# - create_timestamp: アプリケーションバージョンが作成されたタイムスタンプ
# - last_update_timestamp: アプリケーションが最後に更新されたタイムスタンプ
# - status: アプリケーションのステータス
# - version: アプリケーションのバージョン番号
# - tags_all: プロバイダーのdefault_tagsを含む、リソースに割り当てられたタグのマップ
#---------------------------------------------------------------
