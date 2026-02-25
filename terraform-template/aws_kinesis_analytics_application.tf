#---------------------------------------------------------------
# Amazon Kinesis Analytics Application (SQL、非推奨)
#---------------------------------------------------------------
#
# Amazon Kinesis Data Analytics for SQL ApplicationsのアプリケーションをプロビジョニングするAWSリソースです。
# 標準SQLを使用してストリーミングデータを処理・分析するマネージドサービスです。
#
# 警告: このリソースは非推奨です。2026年1月27日以降、AWSはAmazon Kinesis Data Analytics for SQL
# のサポートを終了します。代わりに aws_kinesisanalyticsv2_application リソースを使用してください。
# 参考: https://docs.aws.amazon.com/kinesisanalytics/latest/dev/discontinuation.html
#
# AWS公式ドキュメント:
#   - Amazon Kinesis Data Analytics 開発者ガイド: https://docs.aws.amazon.com/kinesisanalytics/latest/dev/what-is.html
#   - SQL移行ガイド: https://docs.aws.amazon.com/kinesisanalytics/latest/dev/migrating-to-kda-studio-overview.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_analytics_application
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesis_analytics_application" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Kinesis Analytics アプリケーションの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  name = "my-kinesis-analytics-application"

  # description (Optional)
  # 設定内容: アプリケーションの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "My Kinesis Analytics SQL Application"

  # code (Optional)
  # 設定内容: 入力データを変換して出力を生成するSQLコードを指定します。
  # 設定可能な値: 有効なSQL文字列
  # 省略時: SQLコードなし
  code = <<-SQL
    CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (ticker_symbol VARCHAR(4), sector VARCHAR(12), change DOUBLE, price DOUBLE);
    CREATE OR REPLACE PUMP "STREAM_PUMP" AS INSERT INTO "DESTINATION_SQL_STREAM"
    SELECT STREAM ticker_symbol, sector, change, price
    FROM "SOURCE_SQL_STREAM_001"
    WHERE sector SIMILAR TO '%TECH%';
  SQL

  # start_application (Optional)
  # 設定内容: アプリケーションを起動するか停止するかを指定します。
  # 設定可能な値:
  #   - true: アプリケーションを起動します（starting_positionが定義されたinputsが必要）
  #   - false: アプリケーションを停止します
  # 省略時: アプリケーションは起動されません
  # 注意: starting_positionを変更する場合は、まず false に設定して停止してから変更し、再度 true に設定してください
  start_application = false

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
  # CloudWatchロギング設定
  #-------------------------------------------------------------

  # cloudwatch_logging_options (Optional)
  # 設定内容: アプリケーションのエラーを監視するためのCloudWatch Logsストリーム設定ブロックです。
  # 注意: 最大1つまで指定可能
  cloudwatch_logging_options {

    # log_stream_arn (Required)
    # 設定内容: CloudWatch LogsストリームのARNを指定します。
    # 設定可能な値: 有効なCloudWatch LogsストリームのARN
    log_stream_arn = "arn:aws:logs:ap-northeast-1:123456789012:log-group:analytics:log-stream:example-kinesis-application"

    # role_arn (Required)
    # 設定内容: アプリケーションのメッセージ送信に使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールのARN
    role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-role"
  }

  #-------------------------------------------------------------
  # 入力設定
  #-------------------------------------------------------------

  # inputs (Optional)
  # 設定内容: アプリケーションの入力ソース設定ブロックです。
  # 注意: 最大1つまで指定可能
  inputs {

    # name_prefix (Required)
    # 設定内容: アプリ内ストリーム作成時に使用する名前プレフィックスを指定します。
    # 設定可能な値: 任意の文字列
    name_prefix = "SOURCE_SQL_STREAM"

    #-------------------------------------------------------------
    # 入力ソース設定（kinesis_firehose または kinesis_stream のどちらか一方）
    #-------------------------------------------------------------

    # kinesis_firehose (Optional)
    # 設定内容: ストリーミングソースとしてKinesis Firehoseを使用する場合の設定ブロックです。
    # 注意: kinesis_stream と排他的（どちらか一方のみ指定可能）。最大1つまで指定可能
    kinesis_firehose {

      # resource_arn (Required)
      # 設定内容: Kinesis FirehoseデリバリーストリームのドリームのARNを指定します。
      # 設定可能な値: 有効なKinesis FirehoseデリバリーストリームのドリームのARN
      resource_arn = "arn:aws:firehose:ap-northeast-1:123456789012:deliverystream/example-delivery-stream"

      # role_arn (Required)
      # 設定内容: ストリームへのアクセスに使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールのARN
      role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-role"
    }

    # kinesis_stream (Optional)
    # 設定内容: ストリーミングソースとしてKinesis Streamを使用する場合の設定ブロックです。
    # 注意: kinesis_firehose と排他的（どちらか一方のみ指定可能）。最大1つまで指定可能
    kinesis_stream {

      # resource_arn (Required)
      # 設定内容: KinesisストリームのARNを指定します。
      # 設定可能な値: 有効なKinesisストリームのARN
      resource_arn = "arn:aws:kinesis:ap-northeast-1:123456789012:stream/example-kinesis-stream"

      # role_arn (Required)
      # 設定内容: ストリームへのアクセスに使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールのARN
      role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-role"
    }

    #-------------------------------------------------------------
    # 並列処理設定
    #-------------------------------------------------------------

    # parallelism (Optional)
    # 設定内容: 作成するアプリ内並列ストリーム数の設定ブロックです。
    # 注意: 最大1つまで指定可能
    parallelism {

      # count (Optional)
      # 設定内容: ストリームの数を指定します。
      # 設定可能な値: 正の整数
      # 省略時: Terraformが自動設定
      count = 1
    }

    #-------------------------------------------------------------
    # レコード前処理設定
    #-------------------------------------------------------------

    # processing_configuration (Optional)
    # 設定内容: ストリームから受信したレコードを変換する処理設定のブロックです。
    # 注意: 最大1つまで指定可能
    processing_configuration {

      # lambda (Required)
      # 設定内容: 前処理に使用するLambda関数の設定ブロックです。
      # 注意: 必須。最大1つまで指定可能
      lambda {

        # resource_arn (Required)
        # 設定内容: Lambda関数のARNを指定します。
        # 設定可能な値: 有効なLambda関数のARN
        resource_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:kinesis-preprocessing-function"

        # role_arn (Required)
        # 設定内容: Lambda関数へのアクセスに使用するIAMロールのARNを指定します。
        # 設定可能な値: 有効なIAMロールのARN
        role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-role"
      }
    }

    #-------------------------------------------------------------
    # 入力スキーマ設定
    #-------------------------------------------------------------

    # schema (Required)
    # 設定内容: ストリーミングソースのデータスキーマ形式の設定ブロックです。
    # 注意: 必須。最大1つまで指定可能
    schema {

      # record_encoding (Optional)
      # 設定内容: ストリーミングソースのレコードのエンコーディングを指定します。
      # 設定可能な値: "UTF-8" 等の標準エンコーディング文字列
      # 省略時: エンコーディング指定なし
      record_encoding = "UTF-8"

      # record_columns (Required)
      # 設定内容: ストリーミングソースのデータ要素のレコードカラムマッピング設定ブロックです。
      # 注意: 最低1つ、最大1000個まで指定可能
      record_columns {

        # name (Required)
        # 設定内容: カラムの名前を指定します。
        # 設定可能な値: 任意の文字列
        name = "ticker_symbol"

        # sql_type (Required)
        # 設定内容: カラムのSQLデータ型を指定します。
        # 設定可能な値: "VARCHAR(4)", "INTEGER", "DOUBLE", "TIMESTAMP" 等の標準SQL型
        sql_type = "VARCHAR(4)"

        # mapping (Optional)
        # 設定内容: データ要素へのマッピング参照を指定します。
        # 設定可能な値: JSONPathやCSV列番号等のマッピング式（例: "$.ticker_symbol"）
        # 省略時: マッピングなし
        mapping = "$.ticker_symbol"
      }

      # record_format (Required)
      # 設定内容: ストリーミングソースのレコード形式とマッピング情報の設定ブロックです。
      # 注意: 必須。最大1つまで指定可能
      record_format {

        # mapping_parameters (Optional)
        # 設定内容: レコード形式のマッピング情報の設定ブロックです。
        # 注意: 最大1つまで指定可能
        mapping_parameters {

          # csv (Optional)
          # 設定内容: デリミタを使用するレコード形式のマッピング情報を指定します。
          # 注意: json と排他的（どちらか一方のみ指定可能）。最大1つまで指定可能
          csv {

            # record_column_delimiter (Required)
            # 設定内容: カラム区切り文字を指定します。
            # 設定可能な値: 任意の1文字以上の文字列（例: ","、"|"、"\t"）
            record_column_delimiter = ","

            # record_row_delimiter (Required)
            # 設定内容: 行区切り文字を指定します。
            # 設定可能な値: 任意の1文字以上の文字列（例: "\n"、"|"）
            record_row_delimiter = "\n"
          }

          # json (Optional)
          # 設定内容: JSONレコード形式のマッピング情報を指定します。
          # 注意: csv と排他的（どちらか一方のみ指定可能）。最大1つまで指定可能
          json {

            # record_row_path (Required)
            # 設定内容: レコードを含むトップレベル親要素へのパスを指定します。
            # 設定可能な値: JSONPathの文字列（例: "$"）
            record_row_path = "$"
          }
        }
      }
    }

    #-------------------------------------------------------------
    # 開始位置設定
    #-------------------------------------------------------------

    # starting_position_configuration (Optional)
    # 設定内容: ストリームの読み込み開始位置の設定ブロックです。
    # 注意: start_application = true にするには、この設定でstarting_positionを定義する必要があります
    starting_position_configuration {

      # starting_position (Optional)
      # 設定内容: ストリームの開始位置を指定します。
      # 設定可能な値:
      #   - "NOW": 現在時刻からの読み込み開始
      #   - "TRIM_HORIZON": ストリームの最も古いレコードから読み込み開始
      #   - "LAST_STOPPED_POINT": アプリケーションが最後に停止した位置から読み込み再開
      # 省略時: Terraformが自動設定
      starting_position = "NOW"
    }
  }

  #-------------------------------------------------------------
  # 出力設定
  #-------------------------------------------------------------

  # outputs (Optional)
  # 設定内容: アプリケーションの出力先設定ブロックです。
  # 注意: 最大3つまで指定可能
  outputs {

    # name (Required)
    # 設定内容: アプリ内ストリームの名前を指定します。
    # 設定可能な値: 任意の文字列
    name = "DESTINATION_SQL_STREAM"

    # kinesis_firehose (Optional)
    # 設定内容: 出力先としてKinesis Firehoseを使用する場合の設定ブロックです。
    # 注意: kinesis_stream、lambda と排他的。最大1つまで指定可能
    kinesis_firehose {

      # resource_arn (Required)
      # 設定内容: Kinesis FirehoseデリバリーストリームのドリームのドリームのARNを指定します。
      # 設定可能な値: 有効なKinesis FirehoseデリバリーストリームのドリームのARN
      resource_arn = "arn:aws:firehose:ap-northeast-1:123456789012:deliverystream/example-output-stream"

      # role_arn (Required)
      # 設定内容: ストリームへのアクセスに使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールのARN
      role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-role"
    }

    # kinesis_stream (Optional)
    # 設定内容: 出力先としてKinesis Streamを使用する場合の設定ブロックです。
    # 注意: kinesis_firehose、lambda と排他的。最大1つまで指定可能
    kinesis_stream {

      # resource_arn (Required)
      # 設定内容: KinesisストリームのARNを指定します。
      # 設定可能な値: 有効なKinesisストリームのARN
      resource_arn = "arn:aws:kinesis:ap-northeast-1:123456789012:stream/example-output-stream"

      # role_arn (Required)
      # 設定内容: ストリームへのアクセスに使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールのARN
      role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-role"
    }

    # lambda (Optional)
    # 設定内容: 出力先としてLambda関数を使用する場合の設定ブロックです。
    # 注意: kinesis_firehose、kinesis_stream と排他的。最大1つまで指定可能
    lambda {

      # resource_arn (Required)
      # 設定内容: Lambda関数のARNを指定します。
      # 設定可能な値: 有効なLambda関数のARN
      resource_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:kinesis-output-function"

      # role_arn (Required)
      # 設定内容: Lambda関数へのアクセスに使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールのARN
      role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-role"
    }

    # schema (Required)
    # 設定内容: 出力先ストリームに書き込むデータのスキーマ形式の設定ブロックです。
    # 注意: 必須。最大1つまで指定可能
    schema {

      # record_format_type (Required)
      # 設定内容: 出力ストリームのレコード形式タイプを指定します。
      # 設定可能な値:
      #   - "CSV": CSV形式
      #   - "JSON": JSON形式
      record_format_type = "JSON"
    }
  }

  #-------------------------------------------------------------
  # 参照データソース設定
  #-------------------------------------------------------------

  # reference_data_sources (Optional)
  # 設定内容: アプリケーションのS3参照データソース設定ブロックです。
  # 注意: 最大1つまで指定可能
  reference_data_sources {

    # table_name (Required)
    # 設定内容: アプリ内テーブルの名前を指定します。
    # 設定可能な値: 任意の文字列
    table_name = "REFERENCE_TABLE"

    # s3 (Optional)
    # 設定内容: 参照データソースのS3設定ブロックです。
    # 注意: 必須。最大1つまで指定可能
    s3 {

      # bucket_arn (Required)
      # 設定内容: S3バケットのARNを指定します。
      # 設定可能な値: 有効なS3バケットのARN
      bucket_arn = "arn:aws:s3:::my-reference-data-bucket"

      # file_key (Required)
      # 設定内容: 参照データが含まれるファイルのキー名を指定します。
      # 設定可能な値: 有効なS3オブジェクトキーの文字列
      file_key = "reference-data/lookup-table.csv"

      # role_arn (Required)
      # 設定内容: データ読み取りに使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールのARN
      role_arn = "arn:aws:iam::123456789012:role/kinesis-analytics-role"
    }

    # schema (Required)
    # 設定内容: ストリーミングソースのデータスキーマ形式の設定ブロックです。
    # 注意: 必須。最大1つまで指定可能
    schema {

      # record_encoding (Optional)
      # 設定内容: ストリーミングソースのレコードのエンコーディングを指定します。
      # 設定可能な値: "UTF-8" 等の標準エンコーディング文字列
      # 省略時: エンコーディング指定なし
      record_encoding = "UTF-8"

      # record_columns (Required)
      # 設定内容: 参照データのレコードカラムマッピング設定ブロックです。
      # 注意: 最低1つ、最大1000個まで指定可能
      record_columns {

        # name (Required)
        # 設定内容: カラムの名前を指定します。
        # 設定可能な値: 任意の文字列
        name = "ticker_symbol"

        # sql_type (Required)
        # 設定内容: カラムのSQLデータ型を指定します。
        # 設定可能な値: "VARCHAR(4)", "INTEGER", "DOUBLE", "TIMESTAMP" 等の標準SQL型
        sql_type = "VARCHAR(4)"

        # mapping (Optional)
        # 設定内容: データ要素へのマッピング参照を指定します。
        # 設定可能な値: JSONPathやCSV列番号等のマッピング式（例: "$.ticker_symbol"）
        # 省略時: マッピングなし
        mapping = "$.ticker_symbol"
      }

      # record_format (Required)
      # 設定内容: 参照データのレコード形式とマッピング情報の設定ブロックです。
      # 注意: 必須。最大1つまで指定可能
      record_format {

        # mapping_parameters (Optional)
        # 設定内容: レコード形式のマッピング情報の設定ブロックです。
        # 注意: 最大1つまで指定可能
        mapping_parameters {

          # csv (Optional)
          # 設定内容: デリミタを使用するレコード形式のマッピング情報を指定します。
          # 注意: json と排他的（どちらか一方のみ指定可能）。最大1つまで指定可能
          csv {

            # record_column_delimiter (Required)
            # 設定内容: カラム区切り文字を指定します。
            # 設定可能な値: 任意の1文字以上の文字列（例: ","、"|"、"\t"）
            record_column_delimiter = ","

            # record_row_delimiter (Required)
            # 設定内容: 行区切り文字を指定します。
            # 設定可能な値: 任意の1文字以上の文字列（例: "\n"、"|"）
            record_row_delimiter = "\n"
          }

          # json (Optional)
          # 設定内容: JSONレコード形式のマッピング情報を指定します。
          # 注意: csv と排他的（どちらか一方のみ指定可能）。最大1つまで指定可能
          json {

            # record_row_path (Required)
            # 設定内容: レコードを含むトップレベル親要素へのパスを指定します。
            # 設定可能な値: JSONPathの文字列（例: "$"）
            record_row_path = "$"
          }
        }
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと一致するキーを持つタグは、
  #       プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-kinesis-analytics-application"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Kinesis Analytics ApplicationのARN
# - arn: Kinesis Analytics ApplicationのARN
# - create_timestamp: アプリケーションバージョンが作成されたタイムスタンプ
# - last_update_timestamp: アプリケーションが最後に更新されたタイムスタンプ
# - status: アプリケーションのステータス
# - version: アプリケーションのバージョン番号
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
