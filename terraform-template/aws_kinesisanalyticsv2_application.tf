#---------------------------------------------------------------
# Amazon Kinesis Data Analytics v2 Application
#---------------------------------------------------------------
#
# Amazon Kinesis Data Analytics v2アプリケーションをプロビジョニングするリソースです。
# このリソースはSQL-basedアプリケーションとApache Flink-basedアプリケーションの
# 両方を管理できます。リアルタイムストリーミングデータの分析と処理を実行します。
#
# AWS公式ドキュメント:
#   - Managed Service for Apache Flink概要: https://docs.aws.amazon.com/managed-flink/latest/java/what-is.html
#   - アプリケーション設定: https://docs.aws.amazon.com/managed-flink/latest/apiv2/API_ApplicationConfigurationDescription.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesisanalyticsv2_application
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesisanalyticsv2_application" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: アプリケーションの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-kinesis-analytics-app"

  # runtime_environment (Required)
  # 設定内容: アプリケーションのランタイム環境を指定します。
  # 設定可能な値: SQL-1_0, FLINK-1_6, FLINK-1_8, FLINK-1_11, FLINK-1_13, FLINK-1_15, FLINK-1_18, FLINK-1_19, FLINK-1_20
  # 注意: SQL-basedアプリケーションはSQL-1_0を、Flink-basedアプリケーションはFLINK-*を使用します。
  runtime_environment = "FLINK-1_20"

  # service_execution_role (Required)
  # 設定内容: アプリケーションがKinesisデータストリーム、Kinesis Data Firehose配信ストリーム、
  #          Amazon S3オブジェクト、その他の外部リソースにアクセスするために使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 参考: https://docs.aws.amazon.com/managed-flink/latest/java/how-it-works.html
  service_execution_role = "arn:aws:iam::123456789012:role/service-role/KinesisAnalytics-example"

  # description (Optional)
  # 設定内容: アプリケーションの説明を指定します。
  # 設定可能な値: 文字列
  description = "Example Kinesis Analytics v2 Application"

  # application_mode (Optional, Computed)
  # 設定内容: アプリケーションのモードを指定します。
  # 設定可能な値:
  #   - STREAMING: ストリーミングモード
  #   - INTERACTIVE: インタラクティブモード
  # 省略時: AWSがデフォルト値を設定
  application_mode = "STREAMING"

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
  # アプリケーション起動設定
  #-------------------------------------------------------------

  # start_application (Optional)
  # 設定内容: アプリケーションを起動するか停止するかを指定します。
  # 設定可能な値:
  #   - true: アプリケーションを起動
  #   - false: アプリケーションを停止
  start_application = true

  # force_stop (Optional)
  # 設定内容: 応答しないFlink-basedアプリケーションを強制停止するかを指定します。
  # 設定可能な値:
  #   - true: 強制停止を実行
  #   - false: 通常の停止手順を実行
  force_stop = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-kinesis-analytics-app"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # アプリケーション設定
  #-------------------------------------------------------------

  # application_configuration (Optional)
  # 設定内容: アプリケーションの設定を指定します。
  # 関連機能: アプリケーション設定
  #   コード設定、暗号化、スナップショット、環境変数、Flink設定、SQL設定、VPC設定などを定義します。
  #   - https://docs.aws.amazon.com/managed-flink/latest/apiv2/API_ApplicationConfigurationDescription.html
  application_configuration {

    #-----------------------------------------------------------
    # アプリケーションコード設定
    #-----------------------------------------------------------

    # application_code_configuration (Required)
    # 設定内容: アプリケーションコードの場所とタイプパラメータを指定します。
    application_code_configuration {

      # code_content_type (Required)
      # 設定内容: コードコンテンツの形式を指定します。
      # 設定可能な値:
      #   - PLAINTEXT: プレーンテキスト形式（SQLアプリケーション用）
      #   - ZIPFILE: ZIP形式（Flinkアプリケーション用）
      code_content_type = "ZIPFILE"

      # code_content (Optional)
      # 設定内容: アプリケーションコードの場所とタイプを指定します。
      code_content {

        # text_content (Optional)
        # 設定内容: テキスト形式のアプリケーションコードを指定します。
        # 設定可能な値: 文字列（SQLクエリ等）
        # 注意: code_content_typeがPLAINTEXTの場合に使用します。
        text_content = null

        # s3_content_location (Optional)
        # 設定内容: アプリケーションコードを含むS3バケットの情報を指定します。
        s3_content_location {

          # bucket_arn (Required)
          # 設定内容: アプリケーションコードを含むS3バケットのARNを指定します。
          # 設定可能な値: 有効なS3バケットARN
          bucket_arn = "arn:aws:s3:::example-bucket"

          # file_key (Required)
          # 設定内容: アプリケーションコードを含むオブジェクトのファイルキーを指定します。
          # 設定可能な値: S3オブジェクトキー
          file_key = "flink-app.jar"

          # object_version (Optional)
          # 設定内容: アプリケーションコードを含むオブジェクトのバージョンを指定します。
          # 設定可能な値: S3オブジェクトバージョンID
          # 省略時: 最新バージョンを使用
          object_version = null
        }
      }
    }

    #-----------------------------------------------------------
    # 暗号化設定
    #-----------------------------------------------------------

    # application_encryption_configuration (Optional)
    # 設定内容: アプリケーションの暗号化設定を指定します。
    # 関連機能: データ保護
    #   アプリケーション内の保存データを暗号化します。
    application_encryption_configuration {

      # key_type (Required)
      # 設定内容: 使用する暗号化キーのタイプを指定します。
      # 設定可能な値:
      #   - CUSTOMER_MANAGED_KEY: カスタマー管理キー
      #   - AWS_OWNED_KEY: AWS所有キー
      key_type = "AWS_OWNED_KEY"

      # key_id (Optional)
      # 設定内容: 暗号化に使用するKMSキーのARNを指定します。
      # 設定可能な値: 有効なKMSキーARN
      # 注意: key_typeがCUSTOMER_MANAGED_KEYの場合は必須です。KMSキーはアプリケーションと同じリージョンに存在する必要があります。
      key_id = null
    }

    #-----------------------------------------------------------
    # スナップショット設定
    #-----------------------------------------------------------

    # application_snapshot_configuration (Optional)
    # 設定内容: Flink-basedアプリケーションのスナップショット設定を指定します。
    # 関連機能: アプリケーションスナップショット
    #   Flink-basedアプリケーションの状態を保存し、復元を可能にします。
    application_snapshot_configuration {

      # snapshots_enabled (Required)
      # 設定内容: Flink-basedアプリケーションのスナップショットを有効にするかを指定します。
      # 設定可能な値:
      #   - true: スナップショットを有効化
      #   - false: スナップショットを無効化
      snapshots_enabled = true
    }

    #-----------------------------------------------------------
    # 環境プロパティ設定
    #-----------------------------------------------------------

    # environment_properties (Optional)
    # 設定内容: Flink-basedアプリケーションの実行プロパティを指定します。
    # 関連機能: 環境プロパティ
    #   アプリケーションコード内で参照可能なキーと値のペアを定義します。
    environment_properties {

      # property_group (Required, Min: 1, Max: 50)
      # 設定内容: 実行プロパティグループを指定します。
      property_group {

        # property_group_id (Required)
        # 設定内容: アプリケーション実行プロパティキーバリューマップのキーを指定します。
        # 設定可能な値: 文字列
        property_group_id = "PROPERTY-GROUP-1"

        # property_map (Required)
        # 設定内容: アプリケーション実行プロパティのキーバリューマップを指定します。
        # 設定可能な値: マップ形式のキーと値のペア
        property_map = {
          Key1 = "Value1"
          Key2 = "Value2"
        }
      }
    }

    #-----------------------------------------------------------
    # Flinkアプリケーション設定
    #-----------------------------------------------------------

    # flink_application_configuration (Optional)
    # 設定内容: Flink-basedアプリケーションの設定を指定します。
    flink_application_configuration {

      # checkpoint_configuration (Optional)
      # 設定内容: アプリケーションのチェックポイント設定を指定します。
      # 関連機能: チェックポイント
      #   Flinkアプリケーションの状態を定期的に保存し、障害発生時の復旧を可能にします。
      checkpoint_configuration {

        # configuration_type (Required)
        # 設定内容: アプリケーションがKinesis Data Analyticsのデフォルトチェックポイント動作を使用するかを指定します。
        # 設定可能な値:
        #   - CUSTOM: カスタム設定を使用（checkpointing_enabled、checkpoint_interval、min_pause_between_checkpointsが有効）
        #   - DEFAULT: デフォルト設定を使用（checkpointing_enabled=true、checkpoint_interval=60000、min_pause_between_checkpoints=5000）
        # 注意: CUSTOMを設定することで、他のチェックポイント属性値が有効になります。
        configuration_type = "DEFAULT"

        # checkpointing_enabled (Optional, Computed)
        # 設定内容: Flink-basedアプリケーションのチェックポイントを有効にするかを指定します。
        # 設定可能な値:
        #   - true: チェックポイントを有効化
        #   - false: チェックポイントを無効化
        # 省略時: configuration_typeがDEFAULTの場合はtrue
        checkpointing_enabled = null

        # checkpoint_interval (Optional, Computed)
        # 設定内容: チェックポイント操作間の間隔をミリ秒単位で指定します。
        # 設定可能な値: 数値（ミリ秒）
        # 省略時: configuration_typeがDEFAULTの場合は60000
        checkpoint_interval = null

        # min_pause_between_checkpoints (Optional, Computed)
        # 設定内容: チェックポイント操作完了後、新しいチェックポイント操作を開始できるまでの最小時間をミリ秒単位で指定します。
        # 設定可能な値: 数値（ミリ秒）
        # 省略時: configuration_typeがDEFAULTの場合は5000
        min_pause_between_checkpoints = null
      }

      # monitoring_configuration (Optional)
      # 設定内容: アプリケーションのCloudWatchログ設定パラメータを指定します。
      # 関連機能: モニタリング設定
      #   CloudWatchを使用したアプリケーションのモニタリングレベルを制御します。
      monitoring_configuration {

        # configuration_type (Required)
        # 設定内容: アプリケーションのデフォルトCloudWatchログ設定を使用するかを指定します。
        # 設定可能な値:
        #   - CUSTOM: カスタム設定を使用（log_levelとmetrics_levelが有効）
        #   - DEFAULT: デフォルト設定を使用
        # 注意: CUSTOMを設定することで、log_levelとmetrics_level属性値が有効になります。
        configuration_type = "DEFAULT"

        # log_level (Optional, Computed)
        # 設定内容: アプリケーションのCloudWatchログの詳細度を指定します。
        # 設定可能な値: DEBUG, ERROR, INFO, WARN
        # 省略時: configuration_typeに応じたデフォルト値
        log_level = null

        # metrics_level (Optional, Computed)
        # 設定内容: アプリケーションのCloudWatchログの粒度を指定します。
        # 設定可能な値: APPLICATION, OPERATOR, PARALLELISM, TASK
        # 省略時: configuration_typeに応じたデフォルト値
        metrics_level = null
      }

      # parallelism_configuration (Optional)
      # 設定内容: アプリケーションが複数のタスクを同時に実行する方法のパラメータを指定します。
      # 関連機能: 並列実行設定
      #   Flinkアプリケーションの並列度とスケーリング動作を制御します。
      parallelism_configuration {

        # configuration_type (Required)
        # 設定内容: アプリケーションがKinesis Data Analyticsサービスのデフォルト並列度を使用するかを指定します。
        # 設定可能な値:
        #   - CUSTOM: カスタム設定を使用（auto_scaling_enabled、parallelism、parallelism_per_kpuが有効）
        #   - DEFAULT: デフォルト設定を使用
        # 注意: CUSTOMを設定することで、他の並列実行属性値が有効になります。
        configuration_type = "DEFAULT"

        # auto_scaling_enabled (Optional, Computed)
        # 設定内容: スループット増加に応じてKinesis Data Analyticsサービスがアプリケーションの並列度を増やせるかを指定します。
        # 設定可能な値:
        #   - true: 自動スケーリングを有効化
        #   - false: 自動スケーリングを無効化
        # 省略時: configuration_typeに応じたデフォルト値
        auto_scaling_enabled = null

        # parallelism (Optional, Computed)
        # 設定内容: Flink-basedアプリケーションが実行できる初期並列タスク数を指定します。
        # 設定可能な値: 数値
        # 省略時: configuration_typeに応じたデフォルト値
        parallelism = null

        # parallelism_per_kpu (Optional, Computed)
        # 設定内容: Flink-basedアプリケーションが使用するKinesis Processing Unit（KPU）あたりの並列タスク数を指定します。
        # 設定可能な値: 数値
        # 省略時: configuration_typeに応じたデフォルト値
        parallelism_per_kpu = null
      }
    }

    #-----------------------------------------------------------
    # 実行設定
    #-----------------------------------------------------------

    # run_configuration (Optional)
    # 設定内容: Flink-basedアプリケーションの起動プロパティを指定します。
    run_configuration {

      # application_restore_configuration (Optional)
      # 設定内容: 再起動するアプリケーションの復元動作を指定します。
      application_restore_configuration {

        # application_restore_type (Optional, Computed)
        # 設定内容: アプリケーションの復元方法を指定します。
        # 設定可能な値:
        #   - RESTORE_FROM_CUSTOM_SNAPSHOT: カスタムスナップショットから復元
        #   - RESTORE_FROM_LATEST_SNAPSHOT: 最新のスナップショットから復元
        #   - SKIP_RESTORE_FROM_SNAPSHOT: スナップショットからの復元をスキップ
        # 省略時: SKIP_RESTORE_FROM_SNAPSHOT
        application_restore_type = null

        # snapshot_name (Optional)
        # 設定内容: アプリケーションの状態を再起動するために使用する既存のスナップショットの識別子を指定します。
        # 設定可能な値: スナップショット名
        # 注意: application_restore_typeがRESTORE_FROM_CUSTOM_SNAPSHOTの場合に使用します。
        snapshot_name = null
      }

      # flink_run_configuration (Optional)
      # 設定内容: Flink-basedアプリケーションの起動パラメータを指定します。
      flink_run_configuration {

        # allow_non_restored_state (Optional, Computed)
        # 設定内容: スナップショットから復元する際、ランタイムが新しいプログラムにマッピングできない状態をスキップできるようにするかを指定します。
        # 設定可能な値:
        #   - true: マッピング不可の状態をスキップ可能
        #   - false: マッピング不可の状態をスキップ不可
        # 省略時: false
        allow_non_restored_state = null
      }
    }

    #-----------------------------------------------------------
    # SQLアプリケーション設定
    #-----------------------------------------------------------

    # sql_application_configuration (Optional)
    # 設定内容: SQL-basedアプリケーションの設定を指定します。
    # 関連機能: SQLアプリケーション設定
    #   SQLアプリケーションの入力、出力、参照データソースを定義します。
    #   - https://docs.aws.amazon.com/managed-flink/latest/apiv2/API_SqlApplicationConfiguration.html
    sql_application_configuration {

      # input (Optional)
      # 設定内容: アプリケーションが使用する入力ストリームを指定します。
      input {

        # name_prefix (Required)
        # 設定内容: アプリケーション内ストリームを作成する際に使用する名前プレフィックスを指定します。
        # 設定可能な値: 文字列
        name_prefix = "SOURCE_SQL_STREAM"

        # input_schema (Required)
        # 設定内容: ストリーミングソース内のデータの形式と、各データ要素が作成される
        #          アプリケーション内ストリームの対応する列にどのようにマッピングされるかを指定します。
        input_schema {

          # record_encoding (Optional)
          # 設定内容: ストリーミングソース内のレコードのエンコーディングを指定します。
          # 設定可能な値: エンコーディング名（例: UTF-8）
          record_encoding = "UTF-8"

          # record_column (Required, Min: 1, Max: 1000)
          # 設定内容: ストリーミングソース内の各データ要素からアプリケーション内ストリーム内の
          #          対応する列へのマッピングを指定します。
          record_column {

            # name (Required)
            # 設定内容: アプリケーション内入力ストリームまたは参照テーブルに作成される列の名前を指定します。
            # 設定可能な値: 文字列
            name = "COLUMN_1"

            # sql_type (Required)
            # 設定内容: アプリケーション内入力ストリームまたは参照テーブルに作成される列のタイプを指定します。
            # 設定可能な値: SQLデータ型（例: VARCHAR(64), INTEGER, DOUBLE, TIMESTAMP等）
            sql_type = "VARCHAR(64)"

            # mapping (Optional)
            # 設定内容: ストリーミング入力または参照データソース内のデータ要素への参照を指定します。
            # 設定可能な値: 文字列
            mapping = null
          }

          # record_format (Required)
          # 設定内容: ストリーミングソース上のレコードの形式を指定します。
          record_format {

            # record_format_type (Required)
            # 設定内容: レコード形式のタイプを指定します。
            # 設定可能な値: CSV, JSON
            record_format_type = "JSON"

            # mapping_parameters (Required)
            # 設定内容: ストリーミングソース上のレコード形式（JSON、CSV、または区切り文字で区切られたレコードフィールド等）に
            #          固有の追加のマッピング情報を提供します。
            mapping_parameters {

              # csv_mapping_parameters (Optional)
              # 設定内容: レコード形式が区切り文字を使用する場合（例: CSV）の追加のマッピング情報を提供します。
              csv_mapping_parameters {

                # record_column_delimiter (Required)
                # 設定内容: 列の区切り文字を指定します。
                # 設定可能な値: 文字列（例: CSV形式では通常カンマ「,」）
                record_column_delimiter = ","

                # record_row_delimiter (Required)
                # 設定内容: 行の区切り文字を指定します。
                # 設定可能な値: 文字列（例: CSV形式では通常改行「\n」）
                record_row_delimiter = "\n"
              }

              # json_mapping_parameters (Optional)
              # 設定内容: ストリーミングソース上のレコード形式がJSONの場合の追加のマッピング情報を提供します。
              json_mapping_parameters {

                # record_row_path (Required)
                # 設定内容: レコードを含むトップレベルの親へのパスを指定します。
                # 設定可能な値: JSONPath式（例: $）
                record_row_path = "$"
              }
            }
          }
        }

        # input_parallelism (Optional)
        # 設定内容: 作成するアプリケーション内ストリームの数を指定します。
        input_parallelism {

          # count (Optional, Computed)
          # 設定内容: アプリケーション内ストリームの数を指定します。
          # 設定可能な値: 数値
          count = null
        }

        # input_processing_configuration (Optional)
        # 設定内容: 入力の入力処理設定を指定します。
        # 関連機能: 入力処理
        #   アプリケーションのSQLコードが実行される前に、ストリームから受信されたレコードを変換します。
        input_processing_configuration {

          # input_lambda_processor (Required)
          # 設定内容: アプリケーションコードによって処理される前に、ストリーム内のレコードを
          #          前処理するために使用されるLambda関数を指定します。
          input_lambda_processor {

            # resource_arn (Required)
            # 設定内容: ストリーム内のレコードを操作するLambda関数のARNを指定します。
            # 設定可能な値: 有効なLambda関数ARN
            resource_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:preprocessor"
          }
        }

        # input_starting_position_configuration (Optional)
        # 設定内容: 開始位置の設定を指定します。
        # 注意: アプリケーションの開始位置を変更するには、まずstart_application=falseでアプリケーションを停止し、
        #      その後starting_positionを更新してstart_application=trueに設定します。
        input_starting_position_configuration {

          # input_starting_position (Optional, Computed)
          # 設定内容: ストリーム上の開始位置を指定します。
          # 設定可能な値:
          #   - LAST_STOPPED_POINT: 最後に停止した位置から開始
          #   - NOW: 現在の時点から開始
          #   - TRIM_HORIZON: 最も古いレコードから開始
          input_starting_position = null
        }

        # kinesis_firehose_input (Optional)
        # 設定内容: ストリーミングソースがKinesis Data Firehose配信ストリームの場合、配信ストリームのARNを識別します。
        kinesis_firehose_input {

          # resource_arn (Required)
          # 設定内容: 配信ストリームのARNを指定します。
          # 設定可能な値: 有効なKinesis Data Firehose配信ストリームARN
          resource_arn = "arn:aws:firehose:ap-northeast-1:123456789012:deliverystream/example"
        }

        # kinesis_streams_input (Optional)
        # 設定内容: ストリーミングソースがKinesisデータストリームの場合、ストリームのARNを識別します。
        kinesis_streams_input {

          # resource_arn (Required)
          # 設定内容: 入力KinesisデータストリームのARNを指定します。
          # 設定可能な値: 有効なKinesisデータストリームARN
          resource_arn = "arn:aws:kinesis:ap-northeast-1:123456789012:stream/example"
        }
      }

      # output (Optional, Max: 3)
      # 設定内容: アプリケーションが使用する出力先ストリームを指定します。
      output {

        # name (Required)
        # 設定内容: アプリケーション内ストリームの名前を指定します。
        # 設定可能な値: 文字列
        name = "DESTINATION_SQL_STREAM"

        # destination_schema (Required)
        # 設定内容: 出力先にレコードが書き込まれる際のデータ形式を指定します。
        destination_schema {

          # record_format_type (Required)
          # 設定内容: 出力ストリーム上のレコードの形式を指定します。
          # 設定可能な値: CSV, JSON
          record_format_type = "JSON"
        }

        # kinesis_firehose_output (Optional)
        # 設定内容: 出力先としてKinesis Data Firehose配信ストリームを識別します。
        kinesis_firehose_output {

          # resource_arn (Required)
          # 設定内容: 書き込み先の配信ストリームのARNを指定します。
          # 設定可能な値: 有効なKinesis Data Firehose配信ストリームARN
          resource_arn = "arn:aws:firehose:ap-northeast-1:123456789012:deliverystream/output-stream"
        }

        # kinesis_streams_output (Optional)
        # 設定内容: 出力先としてKinesisデータストリームを識別します。
        kinesis_streams_output {

          # resource_arn (Required)
          # 設定内容: 書き込み先のKinesisデータストリームのARNを指定します。
          # 設定可能な値: 有効なKinesisデータストリームARN
          resource_arn = "arn:aws:kinesis:ap-northeast-1:123456789012:stream/output-stream"
        }

        # lambda_output (Optional)
        # 設定内容: 出力先としてLambda関数を識別します。
        lambda_output {

          # resource_arn (Required)
          # 設定内容: 書き込み先のLambda関数のARNを指定します。
          # 設定可能な値: 有効なLambda関数ARN
          resource_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:output-processor"
        }
      }

      # reference_data_source (Optional)
      # 設定内容: アプリケーションが使用する参照データソースを指定します。
      # 関連機能: 参照データソース
      #   ストリーミングデータとの結合に使用される静的データを定義します。
      reference_data_source {

        # table_name (Required)
        # 設定内容: 作成するアプリケーション内テーブルの名前を指定します。
        # 設定可能な値: 文字列
        table_name = "REFERENCE_TABLE"

        # reference_schema (Required)
        # 設定内容: ストリーミングソース内のデータの形式と、各データ要素が作成される
        #          アプリケーション内ストリーム内の対応する列にどのようにマッピングされるかを指定します。
        reference_schema {

          # record_encoding (Optional)
          # 設定内容: ストリーミングソース内のレコードのエンコーディングを指定します。
          # 設定可能な値: エンコーディング名（例: UTF-8）
          record_encoding = "UTF-8"

          # record_column (Required, Min: 1, Max: 1000)
          # 設定内容: ストリーミングソース内の各データ要素からアプリケーション内ストリーム内の
          #          対応する列へのマッピングを指定します。
          record_column {

            # name (Required)
            # 設定内容: アプリケーション内入力ストリームまたは参照テーブルに作成される列の名前を指定します。
            # 設定可能な値: 文字列
            name = "REF_COLUMN_1"

            # sql_type (Required)
            # 設定内容: アプリケーション内入力ストリームまたは参照テーブルに作成される列のタイプを指定します。
            # 設定可能な値: SQLデータ型（例: VARCHAR(64), INTEGER, DOUBLE, TIMESTAMP等）
            sql_type = "INTEGER"

            # mapping (Optional)
            # 設定内容: ストリーミング入力または参照データソース内のデータ要素への参照を指定します。
            # 設定可能な値: 文字列
            mapping = null
          }

          # record_format (Required)
          # 設定内容: ストリーミングソース上のレコードの形式を指定します。
          record_format {

            # record_format_type (Required)
            # 設定内容: レコード形式のタイプを指定します。
            # 設定可能な値: CSV, JSON
            record_format_type = "JSON"

            # mapping_parameters (Required)
            # 設定内容: ストリーミングソース上のレコード形式に固有の追加のマッピング情報を提供します。
            mapping_parameters {

              # csv_mapping_parameters (Optional)
              # 設定内容: レコード形式が区切り文字を使用する場合の追加のマッピング情報を提供します。
              csv_mapping_parameters {

                # record_column_delimiter (Required)
                # 設定内容: 列の区切り文字を指定します。
                # 設定可能な値: 文字列
                record_column_delimiter = ","

                # record_row_delimiter (Required)
                # 設定内容: 行の区切り文字を指定します。
                # 設定可能な値: 文字列
                record_row_delimiter = "\n"
              }

              # json_mapping_parameters (Optional)
              # 設定内容: レコード形式がJSONの場合の追加のマッピング情報を提供します。
              json_mapping_parameters {

                # record_row_path (Required)
                # 設定内容: レコードを含むトップレベルの親へのパスを指定します。
                # 設定可能な値: JSONPath式
                record_row_path = "$"
              }
            }
          }
        }

        # s3_reference_data_source (Required)
        # 設定内容: 参照データを含むS3バケットとオブジェクトを識別します。
        s3_reference_data_source {

          # bucket_arn (Required)
          # 設定内容: S3バケットのARNを指定します。
          # 設定可能な値: 有効なS3バケットARN
          bucket_arn = "arn:aws:s3:::reference-data-bucket"

          # file_key (Required)
          # 設定内容: 参照データを含むオブジェクトキー名を指定します。
          # 設定可能な値: S3オブジェクトキー
          file_key = "reference-data.json"
        }
      }
    }

    #-----------------------------------------------------------
    # VPC設定
    #-----------------------------------------------------------

    # vpc_configuration (Optional)
    # 設定内容: Flink-basedアプリケーションのVPC設定を指定します。
    # 関連機能: VPC設定
    #   アプリケーションがVPC内のリソースにアクセスできるようにします。
    vpc_configuration {

      # security_group_ids (Required)
      # 設定内容: VPC設定で使用するセキュリティグループIDを指定します。
      # 設定可能な値: セキュリティグループIDのセット
      security_group_ids = ["sg-12345678", "sg-87654321"]

      # subnet_ids (Required)
      # 設定内容: VPC設定で使用するサブネットIDを指定します。
      # 設定可能な値: サブネットIDのセット
      subnet_ids = ["subnet-12345678", "subnet-87654321"]
    }
  }

  #-------------------------------------------------------------
  # CloudWatchログ設定
  #-------------------------------------------------------------

  # cloudwatch_logging_options (Optional)
  # 設定内容: アプリケーション設定エラーを監視するCloudWatchログストリームを指定します。
  # 関連機能: CloudWatchログ統合
  #   アプリケーションログをCloudWatch Logsに送信します。
  cloudwatch_logging_options {

    # log_stream_arn (Required)
    # 設定内容: アプリケーションメッセージを受信するCloudWatchログストリームのARNを指定します。
    # 設定可能な値: 有効なCloudWatchログストリームARN
    log_stream_arn = "arn:aws:logs:ap-northeast-1:123456789012:log-group:/aws/kinesis-analytics/example:log-stream:example-stream"
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
    # 設定可能な値: 時間文字列
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アプリケーション識別子
# - arn: アプリケーションのARN
# - create_timestamp: アプリケーションが作成された際の現在のタイムスタンプ
# - last_update_timestamp: アプリケーションが最後に更新された際の現在のタイムスタンプ
# - status: アプリケーションのステータス
# - version_id: 現在のアプリケーションバージョン。アプリケーションが更新されるたびに
#              Kinesis Data Analyticsはversion_idを更新します。
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# sql_application_configuration.input:
# - in_app_stream_names: ストリームソースにマッピングされたアプリケーション内ストリーム名
# - input_id: Kinesis Data Analyticsによって各入力設定に割り当てられたID
#
# sql_application_configuration.output:
# - output_id: 出力設定のID
#
# sql_application_configuration.reference_data_source:
# - reference_id: 参照データソースのID
#
#---------------------------------------------------------------
