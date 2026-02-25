#---------------------------------------------------------------
# Amazon Macie 2 Classification Job
#---------------------------------------------------------------
#
# Amazon Macie の分類ジョブ（Classification Job）をプロビジョニングするリソースです。
# 分類ジョブは、S3 バケット内のオブジェクトを分析して機密データを検出し、
# 検出結果を生成します。ジョブの種別として、1回のみ実行する「ONE_TIME」と
# スケジュールに基づいて繰り返し実行する「SCHEDULED」を選択できます。
#
# AWS公式ドキュメント:
#   - Amazon Macie 分類ジョブの概要: https://docs.aws.amazon.com/macie/latest/user/discovery-jobs.html
#   - ジョブの管理: https://docs.aws.amazon.com/macie/latest/user/discovery-jobs-manage.html
#   - S3 バケットの選択基準: https://docs.aws.amazon.com/macie/latest/user/discovery-jobs-s3-criteria.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_classification_job
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_macie2_classification_job" "example" {
  #-------------------------------------------------------------
  # ジョブ基本設定
  #-------------------------------------------------------------

  # job_type (Required)
  # 設定内容: 分類ジョブの実行種別を指定します。
  # 設定可能な値:
  #   - "ONE_TIME": 1回のみ実行される即時ジョブ
  #   - "SCHEDULED": schedule_frequency ブロックで定義したスケジュールに基づき繰り返し実行されるジョブ
  job_type = "ONE_TIME"

  # name (Optional)
  # 設定内容: 分類ジョブに付けるカスタム名を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: Terraform により自動生成
  # 注意: name と name_prefix は同時に指定できません。
  name = "example-classification-job"

  # name_prefix (Optional)
  # 設定内容: 分類ジョブ名のプレフィックスを指定します。サフィックスは Terraform が自動生成します。
  # 設定可能な値: 任意の文字列
  # 省略時: Terraform により自動生成
  # 注意: name と name_prefix は同時に指定できません。
  name_prefix = null

  # description (Optional)
  # 設定内容: 分類ジョブの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example Macie classification job for sensitive data discovery"

  # initial_run (Optional)
  # 設定内容: SCHEDULED ジョブの作成時に即時実行するかどうかを指定します。
  # 設定可能な値:
  #   - true: ジョブ作成直後に最初の実行を行う
  #   - false: スケジュールに従い次の実行タイミングまで待機する
  # 省略時: false
  # 注意: job_type が "ONE_TIME" の場合は常に即時実行されるためこの設定は無効です。
  initial_run = false

  # job_status (Optional)
  # 設定内容: ジョブのステータスを指定します。
  # 設定可能な値:
  #   - "RUNNING": ジョブを実行中（または実行待ち）の状態にする
  #   - "USER_PAUSED": ジョブを一時停止状態にする（30日間一時停止状態が続くとジョブが期限切れとなる）
  #   - "CANCELLED": ジョブをキャンセル（キャンセル後に再開はできない）
  # 省略時: "RUNNING"
  job_status = "RUNNING"

  # sampling_percentage (Optional)
  # 設定内容: ジョブで分析するオブジェクトの割合をパーセンテージで指定します。
  # 設定可能な値: 1～100 の整数
  # 省略時: 100（全オブジェクトを分析）
  sampling_percentage = 100

  # custom_data_identifier_ids (Optional)
  # 設定内容: ジョブで使用するカスタムデータ識別子の ID リストを指定します。
  # 設定可能な値: aws_macie2_custom_data_identifier リソースの ID リスト
  # 省略時: カスタムデータ識別子を使用しない
  custom_data_identifier_ids = []

  #-------------------------------------------------------------
  # S3 ジョブ定義設定
  #-------------------------------------------------------------

  # s3_job_definition (Required)
  # 設定内容: 分析対象の S3 バケットおよびオブジェクトのスコープを定義するブロックです。
  s3_job_definition {

    # bucket_definitions (Optional)
    # 設定内容: 分析対象とする S3 バケットをアカウントごとに明示的に指定するブロックです。
    # 注意: bucket_criteria と bucket_definitions は同時に指定できません。
    bucket_definitions {

      # account_id (Required)
      # 設定内容: バケットが所属する AWS アカウント ID を指定します。
      account_id = "123456789012"

      # buckets (Required)
      # 設定内容: 分析対象とする S3 バケット名のリストを指定します。
      buckets = ["example-bucket-1", "example-bucket-2"]
    }

    # bucket_criteria (Optional)
    # 設定内容: 分析対象 S3 バケットを動的に選択するための条件を指定するブロックです。
    # 注意: bucket_criteria と bucket_definitions は同時に指定できません。
    bucket_criteria {

      # excludes (Optional)
      # 設定内容: バケット選択から除外する条件を AND 論理で指定するブロックです。
      excludes {

        # and (Optional)
        # 設定内容: 除外条件を結合する AND 条件ブロックです。複数指定可能です。
        and {

          # simple_criterion (Optional)
          # 設定内容: シンプルなバケット属性に基づく除外条件を指定するブロックです。
          simple_criterion {

            # comparator (Optional)
            # 設定内容: 比較演算子を指定します。
            # 設定可能な値: "EQ", "GT", "GTE", "LT", "LTE", "NE", "CONTAINS", "STARTS_WITH"
            # 省略時: Terraform が自動設定
            comparator = "EQ"

            # key (Optional)
            # 設定内容: フィルタリングに使用するバケット属性のキーを指定します。
            # 設定可能な値: "ACCOUNT_ID", "S3_BUCKET_EFFECTIVE_PERMISSION",
            #               "S3_BUCKET_NAME", "S3_BUCKET_SHARED_ACCESS"
            # 省略時: Terraform が自動設定
            key = "S3_BUCKET_NAME"

            # values (Optional)
            # 設定内容: 比較対象となる値のリストを指定します。
            # 省略時: Terraform が自動設定
            values = ["excluded-bucket"]
          }

          # tag_criterion (Optional)
          # 設定内容: バケットのタグに基づく除外条件を指定するブロックです。
          tag_criterion {

            # comparator (Optional)
            # 設定内容: タグ比較に使用する演算子を指定します。
            # 設定可能な値: "EQ", "GT", "GTE", "LT", "LTE", "NE", "CONTAINS", "STARTS_WITH"
            # 省略時: Terraform が自動設定
            comparator = "EQ"

            # tag_values (Optional)
            # 設定内容: フィルタリングに使用するタグのキーと値のペアを指定するブロックです。
            tag_values {

              # key (Optional)
              # 設定内容: タグのキーを指定します。
              # 省略時: Terraform が自動設定
              key = "Environment"

              # value (Optional)
              # 設定内容: タグの値を指定します。
              # 省略時: Terraform が自動設定
              value = "dev"
            }
          }
        }
      }

      # includes (Optional)
      # 設定内容: バケット選択に含める条件を AND 論理で指定するブロックです。
      includes {

        # and (Optional)
        # 設定内容: 包含条件を結合する AND 条件ブロックです。複数指定可能です。
        and {

          # simple_criterion (Optional)
          # 設定内容: シンプルなバケット属性に基づく包含条件を指定するブロックです。
          simple_criterion {

            # comparator (Optional)
            # 設定内容: 比較演算子を指定します。
            # 設定可能な値: "EQ", "GT", "GTE", "LT", "LTE", "NE", "CONTAINS", "STARTS_WITH"
            # 省略時: Terraform が自動設定
            comparator = "STARTS_WITH"

            # key (Optional)
            # 設定内容: フィルタリングに使用するバケット属性のキーを指定します。
            # 設定可能な値: "ACCOUNT_ID", "S3_BUCKET_EFFECTIVE_PERMISSION",
            #               "S3_BUCKET_NAME", "S3_BUCKET_SHARED_ACCESS"
            # 省略時: Terraform が自動設定
            key = "S3_BUCKET_NAME"

            # values (Optional)
            # 設定内容: 比較対象となる値のリストを指定します。
            # 省略時: Terraform が自動設定
            values = ["production-"]
          }

          # tag_criterion (Optional)
          # 設定内容: バケットのタグに基づく包含条件を指定するブロックです。
          tag_criterion {

            # comparator (Optional)
            # 設定内容: タグ比較に使用する演算子を指定します。
            # 設定可能な値: "EQ", "GT", "GTE", "LT", "LTE", "NE", "CONTAINS", "STARTS_WITH"
            # 省略時: Terraform が自動設定
            comparator = "EQ"

            # tag_values (Optional)
            # 設定内容: フィルタリングに使用するタグのキーと値のペアを指定するブロックです。
            tag_values {

              # key (Optional)
              # 設定内容: タグのキーを指定します。
              # 省略時: Terraform が自動設定
              key = "Environment"

              # value (Optional)
              # 設定内容: タグの値を指定します。
              # 省略時: Terraform が自動設定
              value = "production"
            }
          }
        }
      }
    }

    # scoping (Optional)
    # 設定内容: 分析対象 S3 オブジェクトのスコープ（包含・除外条件）を指定するブロックです。
    scoping {

      # excludes (Optional)
      # 設定内容: 分析対象から除外するオブジェクトの条件を指定するブロックです。
      excludes {

        # and (Optional)
        # 設定内容: 除外スコープ条件を AND 論理で指定するブロックです。複数指定可能です。
        and {

          # simple_scope_term (Optional)
          # 設定内容: シンプルなオブジェクト属性に基づく除外条件を指定するブロックです。
          simple_scope_term {

            # comparator (Optional)
            # 設定内容: 比較演算子を指定します。
            # 設定可能な値: "EQ", "GT", "GTE", "LT", "LTE", "NE", "CONTAINS", "STARTS_WITH"
            # 省略時: Terraform が自動設定
            comparator = "EQ"

            # key (Optional)
            # 設定内容: フィルタリングに使用するオブジェクト属性のキーを指定します。
            # 設定可能な値: "OBJECT_EXTENSION", "OBJECT_KEY", "OBJECT_LAST_MODIFIED_DATE",
            #               "OBJECT_SIZE"
            # 省略時: Terraform が自動設定
            key = "OBJECT_EXTENSION"

            # values (Optional)
            # 設定内容: 比較対象となる値のリストを指定します。
            # 省略時: Terraform が自動設定
            values = ["tmp"]
          }

          # tag_scope_term (Optional)
          # 設定内容: オブジェクトのタグに基づく除外条件を指定するブロックです。
          tag_scope_term {

            # comparator (Optional)
            # 設定内容: タグ比較に使用する演算子を指定します。
            # 設定可能な値: "EQ", "GT", "GTE", "LT", "LTE", "NE", "CONTAINS", "STARTS_WITH"
            # 省略時: Terraform が自動設定
            comparator = "EQ"

            # key (Optional)
            # 設定内容: タグのキーを指定します。
            # 省略時: Terraform が自動設定
            key = "Classification"

            # target (Optional)
            # 設定内容: タグのターゲットを指定します。
            # 設定可能な値: "S3_OBJECT"
            # 省略時: Terraform が自動設定
            target = "S3_OBJECT"

            # tag_values (Optional)
            # 設定内容: フィルタリングに使用するタグのキーと値のペアを指定するブロックです。
            tag_values {

              # key (Optional)
              # 設定内容: タグのキーを指定します。
              # 省略時: Terraform が自動設定
              key = "Classification"

              # value (Optional)
              # 設定内容: タグの値を指定します。
              # 省略時: Terraform が自動設定
              value = "public"
            }
          }
        }
      }

      # includes (Optional)
      # 設定内容: 分析対象に含めるオブジェクトの条件を指定するブロックです。
      includes {

        # and (Optional)
        # 設定内容: 包含スコープ条件を AND 論理で指定するブロックです。複数指定可能です。
        and {

          # simple_scope_term (Optional)
          # 設定内容: シンプルなオブジェクト属性に基づく包含条件を指定するブロックです。
          simple_scope_term {

            # comparator (Optional)
            # 設定内容: 比較演算子を指定します。
            # 設定可能な値: "EQ", "GT", "GTE", "LT", "LTE", "NE", "CONTAINS", "STARTS_WITH"
            # 省略時: Terraform が自動設定
            comparator = "EQ"

            # key (Optional)
            # 設定内容: フィルタリングに使用するオブジェクト属性のキーを指定します。
            # 設定可能な値: "OBJECT_EXTENSION", "OBJECT_KEY", "OBJECT_LAST_MODIFIED_DATE",
            #               "OBJECT_SIZE"
            # 省略時: Terraform が自動設定
            key = "OBJECT_EXTENSION"

            # values (Optional)
            # 設定内容: 比較対象となる値のリストを指定します。
            # 省略時: Terraform が自動設定
            values = ["csv", "json", "xlsx"]
          }

          # tag_scope_term (Optional)
          # 設定内容: オブジェクトのタグに基づく包含条件を指定するブロックです。
          tag_scope_term {

            # comparator (Optional)
            # 設定内容: タグ比較に使用する演算子を指定します。
            # 設定可能な値: "EQ", "GT", "GTE", "LT", "LTE", "NE", "CONTAINS", "STARTS_WITH"
            # 省略時: Terraform が自動設定
            comparator = "EQ"

            # key (Optional)
            # 設定内容: タグのキーを指定します。
            # 省略時: Terraform が自動設定
            key = "ScanRequired"

            # target (Optional)
            # 設定内容: タグのターゲットを指定します。
            # 設定可能な値: "S3_OBJECT"
            # 省略時: Terraform が自動設定
            target = "S3_OBJECT"

            # tag_values (Optional)
            # 設定内容: フィルタリングに使用するタグのキーと値のペアを指定するブロックです。
            tag_values {

              # key (Optional)
              # 設定内容: タグのキーを指定します。
              # 省略時: Terraform が自動設定
              key = "ScanRequired"

              # value (Optional)
              # 設定内容: タグの値を指定します。
              # 省略時: Terraform が自動設定
              value = "true"
            }
          }
        }
      }
    }
  }

  #-------------------------------------------------------------
  # スケジュール設定
  #-------------------------------------------------------------

  # schedule_frequency (Optional)
  # 設定内容: SCHEDULED ジョブの実行スケジュールを指定するブロックです。
  # 注意: job_type が "SCHEDULED" の場合は必須です。"ONE_TIME" の場合は不要です。
  # 注意: daily_schedule, monthly_schedule, weekly_schedule のいずれか1つのみ指定してください。
  schedule_frequency {

    # daily_schedule (Optional)
    # 設定内容: 毎日実行するスケジュールを指定します。
    # 設定可能な値:
    #   - true: 毎日実行
    # 省略時: 指定なし
    daily_schedule = true

    # monthly_schedule (Optional)
    # 設定内容: 毎月指定した日に実行するスケジュールを指定します。
    # 設定可能な値: 1〜31 の整数（月の日付）
    # 省略時: Terraform が自動設定
    # monthly_schedule = 1

    # weekly_schedule (Optional)
    # 設定内容: 毎週指定した曜日に実行するスケジュールを指定します。
    # 設定可能な値: "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"
    # 省略時: Terraform が自動設定
    # weekly_schedule = "MONDAY"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-classification-job"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" などの時間文字列
    # 省略時: Terraform デフォルト値を使用
    create = "60m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" などの時間文字列
    # 省略時: Terraform デフォルト値を使用
    update = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 分類ジョブの ID
# - job_id: 分類ジョブの一意の識別子
# - job_arn: 分類ジョブの Amazon Resource Name (ARN)
# - created_at: ジョブが作成された日時（ISO 8601 形式）
# - user_paused_details: ジョブが一時停止された際の詳細情報リスト
#     - job_expires_at: ジョブの有効期限（一時停止から30日後）
#     - job_imminent_expiration_health_event_arn: 期限切れ間近の AWS Health イベント ARN
#     - job_paused_at: ジョブが一時停止された日時
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
