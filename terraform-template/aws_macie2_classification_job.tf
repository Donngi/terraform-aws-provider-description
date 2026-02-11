# Generated: 2026-01-18
# Provider Version: 6.28.0
# 注意: このテンプレートは生成時点の情報です。最新の仕様は公式ドキュメントを確認してください。

# Amazon Macie Classification Jobリソース
# S3バケット内のオブジェクトを分析して機密データを検出するMacieジョブを作成・管理します。
#
# 参考: https://docs.aws.amazon.com/macie/latest/APIReference/jobs.html
# Terraform公式ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_classification_job

resource "aws_macie2_classification_job" "example" {
  # job_type - (Required) ジョブのスケジュール。
  # ONE_TIME: ジョブを一度だけ実行（schedule_frequencyは指定不可）
  # SCHEDULED: 日次、週次、月次でジョブを実行（schedule_frequencyで繰り返しパターンを定義）
  job_type = "ONE_TIME"

  # name - (Optional) ジョブのカスタム名。最大500文字。
  # 省略した場合、Terraformがランダムで一意な名前を割り当てます。name_prefixとは競合します。
  name = "example-macie-job"

  # name_prefix - (Optional) 指定したプレフィックスで始まる一意な名前を作成します。
  # nameとは競合します。
  # name_prefix = "macie-job-"

  # description - (Optional) ジョブのカスタム説明。最大200文字。
  description = "Example Macie classification job for sensitive data detection"

  # custom_data_identifier_ids - (Optional) データ分析と分類に使用するカスタムデータ識別子のID。
  custom_data_identifier_ids = []

  # initial_run - (Optional) ジョブ作成後、すぐにすべての既存の適格オブジェクトを分析するかどうか。
  initial_run = true

  # sampling_percentage - (Optional) オブジェクト処理時に適用するサンプリング深度（パーセンテージ）。
  # 100未満の場合、Macieは指定したパーセンテージまでランダムにオブジェクトを選択して分析します。
  # デフォルト値は記載されていませんが、通常は100（全オブジェクト分析）が推奨されます。
  sampling_percentage = 100

  # job_status - (Optional) ジョブのステータス。
  # 有効な値: CANCELLED（キャンセル）、RUNNING（実行中）、USER_PAUSED（ユーザーによる一時停止）
  job_status = "RUNNING"

  # region - (Optional) このリソースが管理されるリージョン。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  region = "us-east-1"

  # tags - (Optional) リソースに割り当てるタグのマップ。
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # s3_job_definition - (Required) 分析するオブジェクトを含むS3バケットと分析のスコープ。
  s3_job_definition {
    # bucket_definitions - (Optional) 分析するバケットを所有するAWSアカウントごとのオブジェクト配列。
    # bucket_criteriaとは競合します。
    bucket_definitions {
      # account_id - (Required) バケットを所有するAWSアカウントの一意識別子。
      account_id = "123456789012"

      # buckets - (Required) バケット名のリスト。
      buckets = ["example-bucket-1", "example-bucket-2"]
    }

    # bucket_criteria - (Optional) 分析に含める/除外するS3バケットを決定するプロパティベースおよびタグベースの条件。
    # bucket_definitionsとは競合します。
    # bucket_criteria {
    #   includes {
    #     and {
    #       simple_criterion {
    #         comparator = "EQ"
    #         key        = "BUCKET_NAME"
    #         values     = ["my-bucket"]
    #       }
    #     }
    #   }
    # }

    # scoping - (Optional) 分析に含める/除外するオブジェクトを決定するプロパティベースおよびタグベースの条件。
    scoping {
      # includes - (Optional) 分析に含めるオブジェクトを決定する条件。
      includes {
        and {
          # simple_scope_term - (Optional) プロパティベースの条件。
          simple_scope_term {
            # comparator - (Optional) 条件で使用する演算子。
            # 有効な値: EQ, GT, GTE, LT, LTE, NE, CONTAINS, STARTS_WITH
            comparator = "STARTS_WITH"

            # key - (Optional) 条件で使用するオブジェクトプロパティ。
            key = "OBJECT_KEY"

            # values - (Optional) 条件で使用する値の配列。
            values = ["sensitive/"]
          }
        }
      }

      # excludes - (Optional) 分析から除外するオブジェクトを決定する条件。
      # excludes {
      #   and {
      #     simple_scope_term {
      #       comparator = "EQ"
      #       key        = "OBJECT_EXTENSION"
      #       values     = [".txt"]
      #     }
      #   }
      # }
    }
  }

  # schedule_frequency - (Optional) ジョブを実行する繰り返しパターン。
  # ジョブを一度だけ実行する場合は指定せず、job_typeをONE_TIMEに設定します。
  # schedule_frequency {
  #   # daily_schedule - (Optional) 日次繰り返しパターンを指定します。
  #   daily_schedule = true
  #
  #   # weekly_schedule - (Optional) 週次繰り返しパターンを指定します。
  #   # 曜日を指定（例: "MONDAY"）
  #   # weekly_schedule = "MONDAY"
  #
  #   # monthly_schedule - (Optional) 月次繰り返しパターンを指定します。
  #   # 月の日付を指定（1-31）
  #   # monthly_schedule = 1
  # }

  # timeouts - タイムアウト設定
  timeouts {
    # create - (Optional) リソース作成のタイムアウト。デフォルトは特に記載なし。
    create = "10m"

    # update - (Optional) リソース更新のタイムアウト。デフォルトは特に記載なし。
    update = "10m"
  }
}
