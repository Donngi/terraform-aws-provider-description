#---------------------------------------------------------------
# Amazon Timestream Query Scheduled Query
#---------------------------------------------------------------
#
# Amazon Timestream Queryのスケジュールクエリをプロビジョニングするリソースです。
# スケジュールクエリを使用すると、定期的にTimestreamデータベースに対してクエリを実行し、
# 結果を別のTimestreamテーブルに書き込むことができます。
# ロールアップやダウンサンプリングなどのデータ集約処理に適しています。
#
# AWS公式ドキュメント:
#   - Timestream Query概要: https://docs.aws.amazon.com/timestream/latest/developerguide/what-is-timestream.html
#   - スケジュールクエリ: https://docs.aws.amazon.com/timestream/latest/developerguide/scheduled-queries.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/timestreamquery_scheduled_query
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
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
  # 設定可能な値: 文字列
  name = "example-scheduled-query"

  # query_string (Required)
  # 設定内容: 実行するクエリ文字列を指定します。
  # 設定可能な値: Timestreamクエリ文字列
  # 注意: パラメータ名は `@` 文字の後に識別子を付けて指定できます。
  #       予約されたパラメータ `@scheduled_runtime` は、クエリがスケジュールされた
  #       実行時刻を取得するために使用できます。schedule_configuration パラメータに
  #       従って計算されたタイムスタンプが、各クエリ実行時の `@scheduled_runtime`
  #       パラメータの値になります。
  # 例: 2021-12-01 00:00:00 に実行されるスケジュールクエリインスタンスでは、
  #     クエリ呼び出し時に `@scheduled_runtime` パラメータはタイムスタンプ
  #     2021-12-01 00:00:00 に初期化されます。
  query_string = <<EOF
SELECT region, az, hostname, BIN(time, 15s) AS binned_timestamp,
  ROUND(AVG(cpu_utilization), 2) AS avg_cpu_utilization,
  ROUND(APPROX_PERCENTILE(cpu_utilization, 0.9), 2) AS p90_cpu_utilization,
  ROUND(APPROX_PERCENTILE(cpu_utilization, 0.95), 2) AS p95_cpu_utilization,
  ROUND(APPROX_PERCENTILE(cpu_utilization, 0.99), 2) AS p99_cpu_utilization
FROM exampledatabase.exampletable
WHERE measure_name = 'metrics' AND time > ago(2h)
GROUP BY region, hostname, az, BIN(time, 15s)
ORDER BY binned_timestamp ASC
LIMIT 5
EOF

  # execution_role_arn (Required)
  # 設定内容: スケジュールクエリ実行時にTimestreamが引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: このロールにはTimestream、SNS、S3などへの適切な権限が必要です。
  execution_role_arn = "arn:aws:iam::123456789012:role/timestream-scheduled-query-role"

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
  # 設定内容: スケジュールクエリリソースの保存時暗号化に使用するAmazon KMSキーを指定します。
  # 設定可能な値: キーID、キーARN、エイリアス名、またはエイリアスARN
  # 省略時: Timestream所有のAmazon KMSキーで暗号化されます
  # 注意: エイリアス名を使用する場合は、名前の先頭に "alias/" を付けてください。
  #       error_report_configuration で `SSE_KMS` を暗号化タイプとして使用する場合、
  #       エラーレポートの保存時暗号化にも同じ kms_key_id が使用されます。
  kms_key_id = null

  #-------------------------------------------------------------
  # スケジュール設定
  #-------------------------------------------------------------

  # schedule_configuration (Required)
  # 設定内容: スケジュールクエリのスケジュール設定を定義するブロックです。
  schedule_configuration {
    # schedule_expression (Required)
    # 設定内容: スケジュールクエリをトリガーするタイミングを指定します。
    # 設定可能な値: cron式またはrate式
    # 例: "rate(1 hour)", "cron(0 12 * * ? *)"
    schedule_expression = "rate(1 hour)"
  }

  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # target_configuration (Required)
  # 設定内容: クエリ結果の書き込み先設定を定義するブロックです。
  target_configuration {
    # timestream_configuration (Required)
    # 設定内容: Timestreamデータベースとテーブルへの書き込みに必要な情報を定義するブロックです。
    timestream_configuration {
      # database_name (Required)
      # 設定内容: クエリ結果の書き込み先となるTimestreamデータベースの名前を指定します。
      # 設定可能な値: Timestreamデータベース名
      database_name = "example-results-database"

      # table_name (Required)
      # 設定内容: クエリ結果の書き込み先となるTimestreamテーブルの名前を指定します。
      # 設定可能な値: Timestreamテーブル名
      # 注意: テーブルは database_name で指定したデータベース内に存在する必要があります。
      table_name = "example-results-table"

      # time_column (Required)
      # 設定内容: 書き込み先テーブルの時間列として使用するクエリ結果の列を指定します。
      # 設定可能な値: クエリ結果の列名（TIMESTAMP型である必要があります）
      time_column = "binned_timestamp"

      # measure_name_column (Optional)
      # 設定内容: メジャー名の列名を指定します。
      # 設定可能な値: 列名
      measure_name_column = null

      # dimension_mapping (Required)
      # 設定内容: クエリ結果の列から書き込み先テーブルのディメンションへのマッピングを定義します。
      dimension_mapping {
        # name (Required)
        # 設定内容: クエリ結果の列名を指定します。
        # 設定可能な値: クエリ結果に存在する列名
        name = "az"

        # dimension_value_type (Required)
        # 設定内容: ディメンションのタイプを指定します。
        # 設定可能な値: "VARCHAR"
        dimension_value_type = "VARCHAR"
      }

      dimension_mapping {
        name                 = "region"
        dimension_value_type = "VARCHAR"
      }

      dimension_mapping {
        name                 = "hostname"
        dimension_value_type = "VARCHAR"
      }

      # multi_measure_mappings (Optional)
      # 設定内容: マルチメジャーマッピングの設定を定義します。
      # 注意: mixed_measure_mapping と multi_measure_mappings のどちらか一方のみ指定可能です。
      #       multi_measure_mappings は、派生テーブルにデータをマルチメジャーとして
      #       取り込むために使用できます。
      multi_measure_mappings {
        # target_multi_measure_name (Optional)
        # 設定内容: 派生テーブルでのターゲットマルチメジャー名を指定します。
        # 設定可能な値: マルチメジャー名
        # 注意: measure_name_column が指定されていない場合、この入力は必須です。
        #       measure_name_column が指定されている場合、その列の値がマルチメジャー名として使用されます。
        target_multi_measure_name = "multi-metrics"

        # multi_measure_attribute_mapping (Required)
        # 設定内容: マルチメジャー属性の取り込みデータをマッピングするための属性マッピングを定義します。
        multi_measure_attribute_mapping {
          # source_column (Required)
          # 設定内容: 属性値の読み取り元となるソース列を指定します。
          # 設定可能な値: クエリ結果の列名
          source_column = "avg_cpu_utilization"

          # measure_value_type (Required)
          # 設定内容: ソース列から読み取る属性のタイプを指定します。
          # 設定可能な値: "BIGINT", "BOOLEAN", "DOUBLE", "VARCHAR", "TIMESTAMP"
          measure_value_type = "DOUBLE"

          # target_multi_measure_attribute_name (Optional)
          # 設定内容: 派生テーブルでの属性名に使用するカスタム名を指定します。
          # 設定可能な値: 属性名
          # 省略時: source_column が使用されます
          target_multi_measure_attribute_name = null
        }

        multi_measure_attribute_mapping {
          source_column      = "p90_cpu_utilization"
          measure_value_type = "DOUBLE"
        }

        multi_measure_attribute_mapping {
          source_column      = "p95_cpu_utilization"
          measure_value_type = "DOUBLE"
        }

        multi_measure_attribute_mapping {
          source_column      = "p99_cpu_utilization"
          measure_value_type = "DOUBLE"
        }
      }

      # mixed_measure_mapping (Optional)
      # 設定内容: メジャーをマルチメジャーレコードにマッピングする方法を定義します。
      # 注意: mixed_measure_mapping と multi_measure_mappings のどちらか一方のみ指定可能です。
      # mixed_measure_mapping {
      #   # measure_value_type (Required)
      #   # 設定内容: source_column から読み取る値のタイプを指定します。
      #   # 設定可能な値: "BIGINT", "BOOLEAN", "DOUBLE", "VARCHAR", "MULTI"
      #   measure_value_type = "DOUBLE"
      #
      #   # measure_name (Optional)
      #   # 設定内容: 結果行の measure_name の値を参照します。
      #   # 注意: measure_name_column が指定されている場合、このフィールドは必須です。
      #   measure_name = null
      #
      #   # source_column (Optional)
      #   # 設定内容: 結果の実体化のためにメジャー値を読み取るソース列を指定します。
      #   # 設定可能な値: クエリ結果の列名
      #   source_column = null
      #
      #   # target_measure_name (Optional)
      #   # 設定内容: 使用するターゲットメジャー名を指定します。
      #   # 設定可能な値: メジャー名
      #   # 省略時: measure_name（指定されている場合）または source_column がデフォルトで使用されます
      #   target_measure_name = null
      #
      #   # multi_measure_attribute_mapping (Optional)
      #   # 設定内容: MULTI 値メジャーの属性マッピングを定義します。
      #   # 注意: measure_value_type が MULTI の場合は必須です。
      #   # multi_measure_attribute_mapping {
      #   #   source_column      = "column_name"
      #   #   measure_value_type = "DOUBLE"
      #   #   target_multi_measure_attribute_name = null
      #   # }
      # }
    }
  }

  #-------------------------------------------------------------
  # エラーレポート設定
  #-------------------------------------------------------------

  # error_report_configuration (Required)
  # 設定内容: エラーレポート設定を定義するブロックです。
  error_report_configuration {
    # s3_configuration (Required)
    # 設定内容: エラーレポートのS3設定を定義するブロックです。
    s3_configuration {
      # bucket_name (Required)
      # 設定内容: エラーレポートの作成先となるS3バケット名を指定します。
      # 設定可能な値: 有効なS3バケット名
      bucket_name = "example-error-reports-bucket"

      # encryption_option (Optional)
      # 設定内容: エラーレポートの保存時暗号化オプションを指定します。
      # 設定可能な値:
      #   - "SSE_S3": S3マネージド暗号化（デフォルト）
      #   - "SSE_KMS": KMSマネージド暗号化
      # 省略時: Timestreamは SSE_S3 をデフォルトとして選択します
      encryption_option = null

      # object_key_prefix (Optional)
      # 設定内容: エラーレポートキーのプレフィックスを指定します。
      # 設定可能な値: S3オブジェクトキープレフィックス
      object_key_prefix = null
    }
  }

  #-------------------------------------------------------------
  # 通知設定
  #-------------------------------------------------------------

  # notification_configuration (Required)
  # 設定内容: スケジュールクエリの通知設定を定義するブロックです。
  # 注意: スケジュールクエリが作成されたとき、状態が更新されたとき、または削除されたときに、
  #       Timestreamによって通知が送信されます。
  notification_configuration {
    # sns_configuration (Required)
    # 設定内容: Amazon Simple Notification Service (SNS) の設定詳細を定義するブロックです。
    sns_configuration {
      # topic_arn (Required)
      # 設定内容: スケジュールクエリのステータス通知の送信先となるSNSトピックARNを指定します。
      # 設定可能な値: 有効なSNSトピックARN
      topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:example-topic"
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
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-scheduled-query"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を定義するブロックです。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成時のタイムアウト時間を指定します。
  #   # 設定可能な値: 期間として解析可能な文字列（例: "30s", "2h45m"）
  #   # 有効な時間単位: "s" (秒), "m" (分), "h" (時)
  #   # 参考: https://pkg.go.dev/time#ParseDuration
  #   create = null
  #
  #   # update (Optional)
  #   # 設定内容: リソース更新時のタイムアウト時間を指定します。
  #   # 設定可能な値: 期間として解析可能な文字列（例: "30s", "2h45m"）
  #   # 有効な時間単位: "s" (秒), "m" (分), "h" (時)
  #   update = null
  #
  #   # delete (Optional)
  #   # 設定内容: リソース削除時のタイムアウト時間を指定します。
  #   # 設定可能な値: 期間として解析可能な文字列（例: "30s", "2h45m"）
  #   # 有効な時間単位: "s" (秒), "m" (分), "h" (時)
  #   # 注意: Delete操作のタイムアウト設定は、destroy操作が発生する前に
  #   #       変更がstateに保存される場合にのみ適用されます。
  #   delete = null
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スケジュールクエリのARN
#
# - creation_time: スケジュールクエリの作成時刻
#
# - next_invocation_time: スケジュールクエリの次回実行予定時刻
#
# - previous_invocation_time: スケジュールクエリの前回実行時刻
#
# - state: スケジュールクエリの状態
#   設定可能な値: "ENABLED", "DISABLED"
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - last_run_summary: 最後のスケジュールクエリ実行のランタイムサマリー
#   - error_report_location: 単一のスケジュールクエリ呼び出しのエラーレポートの場所
#     - s3_report_location: スケジュールクエリ実行のS3レポート場所
#       - bucket_name: S3バケット名
#       - object_key: S3キー
#   - execution_stats: 単一のスケジュールクエリ実行の統計
#     - bytes_metered: 単一のスケジュールクエリ実行で計測されたバイト数
#     - cumulative_bytes_scanned: 単一のスケジュールクエリ実行でスキャンされたバイト数
#     - data_writes: 単一のスケジュールクエリ実行で取り込まれたレコードに対して計測されたデータ書き込み
#     - execution_time_in_millis: スケジュールクエリ実行の完了に必要な合計時間（ミリ秒）
#     - query_result_rows: 書き込み先データソースへの取り込み前にクエリ実行から得られる出力の行数
#     - records_ingested: 単一のスケジュールクエリ実行で取り込まれたレコード数
#   - failure_reason: 失敗した場合のスケジュールクエリのエラーメッセージ
#     詳細なエラー理由を取得するには、エラーレポートを確認する必要がある場合があります
#   - invocation_time: この実行のInvocationTime
#     これは、クエリが実行されるようにスケジュールされている時刻です
#     パラメータ `@scheduled_runtime` をクエリで使用して値を取得できます
#   - query_insights_response: スケジュールクエリの実行サマリーに関連する各種インサイトとメトリクス
#     - output_bytes: クエリ結果セットのサイズ（バイト）
#       このデータを使用して、クエリチューニング演習の一部として結果セットが変更されたかどうかを検証できます
#     - output_rows: クエリ結果セットの一部として返される行の合計数
#       このデータを使用して、クエリチューニング演習の一部として結果セットの行数が変更されたかどうかを検証できます
#     - query_spatial_coverage: クエリの空間カバレッジに関するインサイト（最適でない（最大）空間プルーニングを持つテーブルを含む）
#       この情報は、空間プルーニングを強化するためのパーティション戦略の改善領域を特定するのに役立ちます
#       - max: 実行されたクエリの空間カバレッジと最も非効率的な空間プルーニングを持つテーブルに関するインサイト
#         - partition_key: パーティションに使用されるパーティションキー（デフォルトの measure_name またはカスタム定義のパーティションキー）
#         - table_arn: 最も最適でない空間プルーニングを持つテーブルのARN
#         - value: 空間カバレッジの最大比率
#     - query_table_count: クエリ内のテーブル数
#     - query_temporal_range: クエリの時間範囲に関するインサイト（最大の時間範囲を持つテーブルを含む）
#       時間ベースのプルーニングを最適化するための潜在的なオプション: 欠落している時間述語の追加、
#       時間述語の周りの関数の削除、すべてのサブクエリへの時間述語の追加
#       - max: クエリの時間範囲に関するインサイト（最大の時間範囲を持つテーブルを含む）
#         - table_arn: 最大の時間範囲でクエリされるテーブルのARN
#         - value: クエリの開始と終了の間の最大期間（ナノ秒）
#   - run_status: スケジュールクエリ実行のステータス
#     設定可能な値: "AUTO_TRIGGER_SUCCESS", "AUTO_TRIGGER_FAILURE",
#                   "MANUAL_TRIGGER_SUCCESS", "MANUAL_TRIGGER_FAILURE"
#   - trigger_time: クエリが実際に実行された時刻
#
# - recently_failed_runs: 最後の5つの失敗したスケジュールクエリ実行のランタイムサマリー
#   構造は last_run_summary と同じです
#---------------------------------------------------------------
