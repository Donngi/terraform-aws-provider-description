#---------------------------------------------------------------
# Amazon Timestream Query スケジュールクエリ
#---------------------------------------------------------------
#
# Amazon Timestreamのスケジュールクエリをプロビジョニングするリソースです。
# スケジュールクエリは、定期的にTimestream Query言語（TimestreamQL）クエリを実行し、
# 結果を別のTimestreamテーブルに書き込む機能を提供します。
# データの集計・変換・ダウンサンプリングなどの定期的な処理に利用します。
#
# AWS公式ドキュメント:
#   - Amazon Timestream Query スケジュールクエリ: https://docs.aws.amazon.com/timestream/latest/developerguide/scheduledqueries.html
#   - スケジュールクエリの作成: https://docs.aws.amazon.com/timestream/latest/developerguide/scheduledqueries-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/timestreamquery_scheduled_query
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_timestreamquery_scheduled_query" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: スケジュールクエリの名前を指定します。
  # 設定可能な値: 有効なスケジュールクエリ名の文字列
  # 関連機能: Timestream スケジュールクエリ識別子
  #   クエリを一意に識別する名前を定義します。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/scheduledqueries.html
  name = "example-scheduled-query"

  # query_string (Required)
  # 設定内容: 定期実行するTimestreamQLクエリ文字列を指定します。
  # 設定可能な値: 有効なTimestreamQLクエリ文字列
  # 関連機能: Timestream Query 言語
  #   定期実行するSELECT文を記述します。INTO句でターゲットテーブルを指定できます。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/query-syntax.html
  query_string = "SELECT region, az, hostname, BIN(time, 15s) AS binned_timestamp, ROUND(AVG(cpu_utilization), 2) AS avg_cpu_utilization FROM \"$database\".\"$table\" WHERE measure_name = 'metrics' AND time > ago(2h) GROUP BY region, az, hostname, BIN(time, 15s)"

  # execution_role_arn (Required)
  # 設定内容: スケジュールクエリ実行時に引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN文字列
  # 関連機能: IAM実行ロール
  #   Timestreamクエリとターゲットテーブルへの書き込み権限が必要です。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/scheduledqueries-executionrole.html
  execution_role_arn = "arn:aws:iam::123456789012:role/example-scheduled-query-role"

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
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: スケジュールクエリのデータを暗号化するKMSキーIDまたはARNを指定します。
  # 設定可能な値: 有効なKMSキーIDまたはARN文字列
  # 省略時: AWSマネージドキーを使用
  # 関連機能: KMS 暗号化
  #   スケジュールクエリの関連データをカスタマーマネージドキーで暗号化します。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/EncryptionAtRest.html
  kms_key_id = null

  #-------------------------------------------------------------
  # スケジュール設定
  #-------------------------------------------------------------

  # schedule_configuration (Required)
  # 設定内容: スケジュールクエリの実行スケジュールを設定します。
  # 関連機能: クエリ実行スケジュール
  #   cron式またはrate式でクエリの実行タイミングを定義します。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/scheduledqueries-create.html
  schedule_configuration {
    # schedule_expression (Required)
    # 設定内容: クエリを実行するスケジュール式を指定します。
    # 設定可能な値:
    #   - "rate(5 minutes)": 5分毎に実行
    #   - "rate(1 hour)": 1時間毎に実行
    #   - "cron(0 12 * * ? *)": 毎日12時に実行
    # 関連機能: スケジュール式
    #   AWSのスケジュール式構文に従って実行タイミングを指定します。
    #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html
    schedule_expression = "rate(1 hour)"
  }

  #-------------------------------------------------------------
  # 通知設定
  #-------------------------------------------------------------

  # notification_configuration (Required)
  # 設定内容: スケジュールクエリ実行結果の通知設定を行います。
  # 関連機能: SNS通知
  #   クエリ成功・失敗時にSNSトピックへ通知を送信します。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/scheduledqueries-notifications.html
  notification_configuration {
    # sns_configuration (Required)
    # 設定内容: 通知先のSNSトピック設定を指定します。
    sns_configuration {
      # topic_arn (Required)
      # 設定内容: 通知を送信するSNSトピックのARNを指定します。
      # 設定可能な値: 有効なSNSトピックのARN文字列
      # 関連機能: Amazon SNS
      #   スケジュールクエリ実行結果の通知受信に利用します。
      #   - https://docs.aws.amazon.com/sns/latest/dg/welcome.html
      topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:example-scheduled-query-topic"
    }
  }

  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # target_configuration (Optional)
  # 設定内容: スケジュールクエリの実行結果を書き込む先のターゲット設定を行います。
  # 省略時: ターゲット設定なし
  # 関連機能: Timestream ターゲットテーブル
  #   クエリ結果を書き込むTimestreamテーブルと列マッピングを定義します。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/scheduledqueries-create.html
  target_configuration {
    # timestream_configuration (Required)
    # 設定内容: ターゲットとなるTimestreamテーブルの設定を指定します。
    timestream_configuration {
      # database_name (Required)
      # 設定内容: クエリ結果を書き込むTimestreamデータベース名を指定します。
      # 設定可能な値: 有効なTimestreamデータベース名
      # 関連機能: Timestream データベース
      #   ターゲットテーブルが属するデータベースを指定します。
      #   - https://docs.aws.amazon.com/timestream/latest/developerguide/databases.html
      database_name = "example-target-database"

      # table_name (Required)
      # 設定内容: クエリ結果を書き込むTimestreamテーブル名を指定します。
      # 設定可能な値: 有効なTimestreamテーブル名
      # 関連機能: Timestream テーブル
      #   クエリ結果の書き込み先テーブルを指定します。事前に作成が必要です。
      #   - https://docs.aws.amazon.com/timestream/latest/developerguide/tables.html
      table_name = "example-target-table"

      # time_column (Required)
      # 設定内容: クエリ結果のタイムスタンプとして使用するカラム名を指定します。
      # 設定可能な値: クエリ結果に含まれるタイムスタンプ型のカラム名
      # 関連機能: 時系列データ時刻カラム
      #   Timestreamの時系列データに対応するtime属性のソースカラムを指定します。
      #   - https://docs.aws.amazon.com/timestream/latest/developerguide/scheduledqueries-create.html
      time_column = "binned_timestamp"

      # measure_name_column (Optional)
      # 設定内容: メジャー名として使用するカラム名を指定します。
      # 設定可能な値: クエリ結果に含まれるカラム名
      # 省略時: メジャー名カラムは未指定
      # 関連機能: Timestream メジャー名
      #   複数メジャーを扱う場合にメジャー名を識別するカラムを指定します。
      #   - https://docs.aws.amazon.com/timestream/latest/developerguide/writes.html
      measure_name_column = null

      # dimension_mapping (Required)
      # 設定内容: クエリ結果のカラムをTimestreamのディメンションにマッピングします。
      # 関連機能: Timestream ディメンションマッピング
      #   クエリ結果のメタデータカラムをTimestreamのディメンション属性として定義します。
      #   - https://docs.aws.amazon.com/timestream/latest/developerguide/scheduledqueries-create.html
      dimension_mapping {
        # name (Required)
        # 設定内容: マッピングするクエリ結果カラム名（ディメンション名）を指定します。
        # 設定可能な値: クエリ結果に含まれるカラム名
        name = "region"

        # dimension_value_type (Required)
        # 設定内容: ディメンション値のデータ型を指定します。
        # 設定可能な値:
        #   - "VARCHAR": 文字列型
        dimension_value_type = "VARCHAR"
      }

      dimension_mapping {
        name                 = "az"
        dimension_value_type = "VARCHAR"
      }

      dimension_mapping {
        name                 = "hostname"
        dimension_value_type = "VARCHAR"
      }

      # mixed_measure_mapping (Optional)
      # 設定内容: 複数のメジャー型を含むミックスドメジャーマッピングを設定します。
      # 省略時: ミックスドメジャーマッピングなし
      # 関連機能: Timestream ミックスドメジャー
      #   複数の型のメジャーを1つのレコードに格納するためのマッピングを定義します。
      #   - https://docs.aws.amazon.com/timestream/latest/developerguide/writes-mixed-measures.html
      mixed_measure_mapping {
        # measure_value_type (Required)
        # 設定内容: ミックスドメジャーのメジャー値の型を指定します。
        # 設定可能な値:
        #   - "BIGINT": 64ビット整数
        #   - "BOOLEAN": ブール値
        #   - "DOUBLE": 倍精度浮動小数点
        #   - "VARCHAR": 文字列
        #   - "MULTI": 複数属性マッピング（multi_measure_attribute_mappingと組み合わせて使用）
        measure_value_type = "DOUBLE"

        # source_column (Optional)
        # 設定内容: メジャー値のソースとなるクエリ結果のカラム名を指定します。
        # 設定可能な値: クエリ結果に含まれるカラム名
        # 省略時: ソースカラムは未指定
        source_column = "avg_cpu_utilization"

        # measure_name (Optional)
        # 設定内容: ターゲットテーブルに書き込む際のメジャー名を指定します。
        # 設定可能な値: 文字列
        # 省略時: source_columnと同じ名前を使用
        measure_name = null

        # target_measure_name (Optional)
        # 設定内容: ターゲットテーブルに書き込む際のメジャー名（ターゲット側）を指定します。
        # 設定可能な値: 文字列
        # 省略時: source_columnと同じ名前を使用
        target_measure_name = null

        # multi_measure_attribute_mapping (Optional)
        # 設定内容: measure_value_typeがMULTIの場合に複数属性のマッピングを設定します。
        # 省略時: 属性マッピングなし
        # multi_measure_attribute_mapping {
        #   # source_column (Required)
        #   # 設定内容: 属性値のソースとなるクエリ結果のカラム名を指定します。
        #   source_column = "example_column"
        #
        #   # measure_value_type (Required)
        #   # 設定内容: 属性値のデータ型を指定します。
        #   # 設定可能な値: BIGINT, BOOLEAN, DOUBLE, VARCHAR, TIMESTAMP
        #   measure_value_type = "DOUBLE"
        #
        #   # target_multi_measure_attribute_name (Optional)
        #   # 設定内容: ターゲット属性名を指定します。
        #   # 省略時: source_columnと同じ名前を使用
        #   target_multi_measure_attribute_name = null
        # }
      }

      # multi_measure_mappings (Optional)
      # 設定内容: 複数のメジャーをまとめてターゲットテーブルに書き込むマッピング設定です。
      # 省略時: マルチメジャーマッピングなし
      # 関連機能: Timestream マルチメジャーレコード
      #   複数の計測値を1つのTimestreamレコードにまとめて格納します。
      #   - https://docs.aws.amazon.com/timestream/latest/developerguide/writes-multi-measures.html
      # multi_measure_mappings {
      #   # target_multi_measure_name (Optional)
      #   # 設定内容: ターゲットテーブルに書き込む複合メジャーの名前を指定します。
      #   # 省略時: ターゲット複合メジャー名は未指定
      #   target_multi_measure_name = null
      #
      #   # multi_measure_attribute_mapping (Required)
      #   # 設定内容: 複合メジャー内の各属性とソースカラムのマッピングを定義します。
      #   multi_measure_attribute_mapping {
      #     source_column = "example_column"
      #     measure_value_type = "DOUBLE"
      #     target_multi_measure_attribute_name = null
      #   }
      # }
    }
  }

  #-------------------------------------------------------------
  # エラーレポート設定
  #-------------------------------------------------------------

  # error_report_configuration (Optional)
  # 設定内容: スケジュールクエリ実行エラー時のレポート出力先を設定します。
  # 省略時: エラーレポート設定なし
  # 関連機能: エラーレポート
  #   クエリ実行失敗時の詳細情報をS3に保存してデバッグを支援します。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/scheduledqueries-error.html
  error_report_configuration {
    # s3_configuration (Required)
    # 設定内容: エラーレポートを書き込むS3バケットの設定を指定します。
    s3_configuration {
      # bucket_name (Required)
      # 設定内容: エラーレポートを保存するS3バケット名を指定します。
      # 設定可能な値: 有効なS3バケット名
      bucket_name = "example-error-report-bucket"

      # object_key_prefix (Optional)
      # 設定内容: エラーレポートオブジェクトのS3キープレフィックスを指定します。
      # 設定可能な値: S3オブジェクトキープレフィックス文字列
      # 省略時: プレフィックスなし
      object_key_prefix = "scheduled-query-errors/"

      # encryption_option (Optional)
      # 設定内容: エラーレポートファイルの暗号化オプションを指定します。
      # 設定可能な値:
      #   - "SSE_S3": S3マネージドキーでのサーバー側暗号化
      #   - "SSE_KMS": KMSマネージドキーでのサーバー側暗号化
      # 省略時: SSE_S3（デフォルト）
      # 関連機能: S3 暗号化
      #   エラーレポートファイルの保存時暗号化方式を選択します。
      #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
      encryption_option = null
    }
  }

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
    Name        = "example-scheduled-query"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # 最終実行サマリー（読み取り専用）
  #-------------------------------------------------------------

  # last_run_summary (Computed)
  # 設定内容: スケジュールクエリの最後の実行サマリーを参照します。
  # 省略時: 読み取り専用属性のため設定不要
  # 関連機能: Timestream スケジュールクエリ実行結果
  #   最後の実行のステータス、実行時刻、エラー情報、実行統計などを取得できます。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/scheduledqueries-notifications.html
  # last_run_summary {
  #   # 以下はすべて読み取り専用属性
  #   # run_status          - 実行ステータス
  #   # invocation_time     - 実行時刻
  #   # trigger_time        - トリガー時刻
  #   # failure_reason      - 失敗理由
  #   # error_report_location {} - エラーレポートのS3場所
  #   # execution_stats {}       - 実行統計（bytes_metered, cumulative_bytes_scanned等）
  #   # query_insights_response {} - クエリインサイト情報
  # }

  #-------------------------------------------------------------
  # 最近の失敗実行履歴（読み取り専用）
  #-------------------------------------------------------------

  # recently_failed_runs (Computed)
  # 設定内容: スケジュールクエリの最近の失敗した実行の一覧を参照します。
  # 省略時: 読み取り専用属性のため設定不要
  # 関連機能: Timestream スケジュールクエリ失敗履歴
  #   最近の失敗実行の詳細情報（ステータス、時刻、エラー原因等）を取得できます。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/scheduledqueries-notifications.html
  # recently_failed_runs {
  #   # 以下はすべて読み取り専用属性
  #   # run_status          - 実行ステータス
  #   # invocation_time     - 実行時刻
  #   # trigger_time        - トリガー時刻
  #   # failure_reason      - 失敗理由
  #   # error_report_location {} - エラーレポートのS3場所
  #   # execution_stats {}       - 実行統計
  #   # query_insights_response {} - クエリインサイト情報
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの時間文字列
    # 省略時: プロバイダーデフォルトのタイムアウトを使用
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの時間文字列
    # 省略時: プロバイダーデフォルトのタイムアウトを使用
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの時間文字列
    # 省略時: プロバイダーデフォルトのタイムアウトを使用
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: スケジュールクエリのARN
#
# - arn: スケジュールクエリを一意に識別するARN
#
# - creation_time: スケジュールクエリが作成された時刻（ISO 8601形式）
#
# - next_invocation_time: 次回スケジュール実行予定時刻（ISO 8601形式）
#
# - previous_invocation_time: 前回スケジュール実行時刻（ISO 8601形式）
#
# - state: スケジュールクエリの現在の状態（ENABLED / DISABLED など）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - last_run_summary: 最後の実行サマリー情報（run_status, invocation_time,
#                     trigger_time, failure_reason など）
#
# - recently_failed_runs: 最近の失敗した実行の情報のリスト
#---------------------------------------------------------------
