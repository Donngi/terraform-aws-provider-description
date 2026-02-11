################################################################################
# aws_emrcontainers_job_template
# Terraform AWS Provider リソーステンプレート
################################################################################
# 生成日: 2026-01-23
# Provider Version: 6.28.0
#
# 注意事項:
#   - このテンプレートは生成時点（Provider v6.28.0）の仕様に基づいています
#   - 最新の仕様や詳細は公式ドキュメントを必ずご確認ください
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emrcontainers_job_template
################################################################################

################################################################################
# リソース概要
################################################################################
# EMR Containers (EMR on EKS) のジョブテンプレートを管理します。
# ジョブテンプレートは StartJobRun API リクエストの値を保存し、
# 同じAPI リクエスト値の繰り返しを避け、特定の値を強制するために使用されます。
#
# AWS公式ドキュメント:
#   - https://docs.aws.amazon.com/emr-on-eks/latest/APIReference/API_JobTemplate.html
#   - https://docs.aws.amazon.com/emr-on-eks/latest/APIReference/API_CreateJobTemplate.html

################################################################################
# リソース定義
################################################################################
resource "aws_emrcontainers_job_template" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # name - ジョブテンプレートの名前
  # Type: string (required)
  #
  # ジョブテンプレートの識別名を指定します。
  #
  # AWS API仕様: 1-64文字の長さ制限があります。
  #
  # 参考: https://docs.aws.amazon.com/emr-on-eks/latest/APIReference/API_CreateJobTemplate.html
  name = "example-job-template"

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # kms_key_arn - KMSキーARN
  # Type: string (optional)
  #
  # ジョブテンプレートの暗号化に使用されるKMSキーのARNを指定します。
  # ジョブテンプレートの機密情報を保護するために使用されます。
  #
  # 指定しない場合は暗号化されません。
  #
  # 参考: https://docs.aws.amazon.com/emr-on-eks/latest/APIReference/API_CreateJobTemplate.html
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # region - リージョン
  # Type: string (optional, computed)
  #
  # このリソースが管理されるAWSリージョンを指定します。
  #
  # デフォルト値: プロバイダー設定で指定されたリージョン
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # tags - リソースタグ
  # Type: map(string) (optional)
  #
  # リソースに付与するタグのキーと値のマッピングです。
  #
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーを持つタグはこちらで上書きされます。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    Application = "analytics"
    ManagedBy   = "terraform"
  }

  # tags_all - 全タグ（プロバイダーのdefault_tagsを含む）
  # Type: map(string) (optional, computed)
  #
  # リソースに割り当てられた全タグのマップ。
  # プロバイダーの default_tags から継承されたタグも含まれます。
  #
  # 通常は computed 属性として扱われるため、明示的に指定する必要はありません。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags_all = {}

  ################################################################################
  # job_template_data ブロック（必須）
  ################################################################################
  # StartJobRun API リクエストの値を保持するジョブテンプレートデータです。
  #
  # 参考: https://docs.aws.amazon.com/emr-on-eks/latest/APIReference/API_JobTemplateData.html
  job_template_data {
    ################################################################################
    # job_template_data - 必須パラメータ
    ################################################################################

    # execution_role_arn - 実行ロールARN
    # Type: string (required)
    #
    # ジョブ実行に使用されるIAMロールのARNを指定します。
    # このロールはEMRジョブがAWSリソースにアクセスするための権限を提供します。
    #
    # AWS API仕様: 4-2048文字の長さ制限があります。
    #
    # 参考: https://docs.aws.amazon.com/emr-on-eks/latest/APIReference/API_JobTemplateData.html
    execution_role_arn = "arn:aws:iam::123456789012:role/EMRContainersJobExecutionRole"

    # release_label - EMRリリースバージョン
    # Type: string (required)
    #
    # Amazon EMRのリリースバージョンを指定します。
    # 例: "emr-6.10.0-latest", "emr-6.9.0-latest" など
    #
    # AWS API仕様: 1-64文字の長さ制限があります。
    #
    # 利用可能なバージョン: https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-components.html
    release_label = "emr-6.10.0-latest"

    ################################################################################
    # job_template_data - オプションパラメータ
    ################################################################################

    # job_tags - ジョブタグ
    # Type: map(string) (optional)
    #
    # このジョブテンプレートを使用して開始されるジョブに割り当てられるタグです。
    #
    # AWS API仕様: 最大50個のタグを指定できます。
    #
    # 参考: https://docs.aws.amazon.com/emr-on-eks/latest/APIReference/API_JobTemplateData.html
    job_tags = {
      JobType = "spark-sql"
      Team    = "data-engineering"
    }

    ################################################################################
    # job_driver ブロック（必須）
    ################################################################################
    # ジョブが実行されるドライバーを指定します。
    # spark_sql_job_driver または spark_submit_job_driver のいずれか1つが必須です。
    #
    # 参考: https://docs.aws.amazon.com/emr-on-eks/latest/APIReference/API_JobDriver.html
    job_driver {
      ################################################################################
      # spark_sql_job_driver ブロック（オプション）
      ################################################################################
      # Spark SQLジョブの設定です。
      # spark_submit_job_driver と排他的に使用します。
      spark_sql_job_driver {
        # entry_point - SQLファイルのパス
        # Type: string (optional)
        #
        # 実行されるSQLファイルのS3パスまたはローカルパスを指定します。
        # 例: "s3://bucket-name/path/to/query.sql"
        entry_point = "s3://my-emr-bucket/scripts/analytics-query.sql"

        # spark_sql_parameters - Sparkパラメータ
        # Type: string (optional)
        #
        # Spark SQLコマンドに含めるSparkパラメータを指定します。
        #
        # 参考: https://spark.apache.org/docs/latest/sql-ref.html
        spark_sql_parameters = "--conf spark.sql.shuffle.partitions=200"
      }

      ################################################################################
      # spark_submit_job_driver ブロック（オプション）
      ################################################################################
      # Spark Submitジョブの設定です。
      # spark_sql_job_driver と排他的に使用します。
      #
      # 参考: https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/emr-eks-jobs-submit.html
      # spark_submit_job_driver {
      #   # entry_point - エントリーポイント
      #   # Type: string (required)
      #   #
      #   # ジョブアプリケーションのエントリーポイント（メインクラスまたはスクリプト）を指定します。
      #   # 例: "s3://bucket-name/path/to/application.jar"
      #   #      "local:///opt/spark/examples/jars/spark-examples.jar"
      #   entry_point = "s3://my-emr-bucket/jars/my-application.jar"
      #
      #   # entry_point_arguments - エントリーポイント引数
      #   # Type: set(string) (optional)
      #   #
      #   # ジョブアプリケーションに渡される引数のリストです。
      #   entry_point_arguments = [
      #     "--input", "s3://my-bucket/input/",
      #     "--output", "s3://my-bucket/output/",
      #     "--date", "2024-01-01"
      #   ]
      #
      #   # spark_submit_parameters - Spark Submitパラメータ
      #   # Type: string (optional)
      #   #
      #   # ジョブ実行に使用されるSpark Submitパラメータを指定します。
      #   #
      #   # 参考: https://spark.apache.org/docs/latest/submitting-applications.html
      #   spark_submit_parameters = "--class com.example.MainClass --conf spark.executor.instances=2 --conf spark.executor.memory=4G --conf spark.executor.cores=2"
      # }
    }

    ################################################################################
    # configuration_overrides ブロック（オプション）
    ################################################################################
    # デフォルト設定を上書きする設定です。
    configuration_overrides {
      ################################################################################
      # application_configuration ブロック（オプション）
      ################################################################################
      # ジョブ実行で実行されるアプリケーションの設定です。
      #
      # 最大100個まで指定可能です。
      #
      # 参考: https://docs.aws.amazon.com/emr-on-eks/latest/APIReference/API_Configuration.html
      application_configuration {
        # classification - 分類
        # Type: string (required)
        #
        # 設定内の分類を指定します。
        # 例: "spark-defaults", "spark-env", "hadoop-env" など
        #
        # 利用可能な分類: https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-configure-apps.html
        classification = "spark-defaults"

        # properties - プロパティ
        # Type: map(string) (optional)
        #
        # 設定の分類内で指定されるプロパティのセットです。
        properties = {
          "spark.executor.memory"    = "4G"
          "spark.executor.cores"     = "2"
          "spark.dynamicAllocation.enabled" = "true"
        }

        ################################################################################
        # configurations ブロック（オプション、ネスト可能）
        ################################################################################
        # 設定オブジェクト内に適用される追加の設定リストです。
        #
        # 最大100個まで指定可能です。
        configurations {
          # classification - 分類
          # Type: string (optional)
          #
          # ネストされた設定の分類を指定します。
          classification = "spark-env"

          # properties - プロパティ
          # Type: map(string) (optional)
          #
          # ネストされた設定のプロパティです。
          properties = {
            "SPARK_DAEMON_MEMORY" = "2G"
          }
        }
      }

      ################################################################################
      # monitoring_configuration ブロック（オプション）
      ################################################################################
      # モニタリングの設定です。
      monitoring_configuration {
        # persistent_app_ui - 永続的アプリケーションUI
        # Type: string (optional, computed)
        #
        # 永続的アプリケーションUIのモニタリング設定を指定します。
        #
        # 有効な値: "ENABLED" または "DISABLED"
        #
        # 参考: https://docs.aws.amazon.com/emr-on-eks/latest/APIReference/API_MonitoringConfiguration.html
        persistent_app_ui = "ENABLED"

        ################################################################################
        # cloud_watch_monitoring_configuration ブロック（オプション）
        ################################################################################
        # CloudWatchのモニタリング設定です。
        cloud_watch_monitoring_configuration {
          # log_group_name - ログループ名
          # Type: string (required)
          #
          # ログ発行のためのCloudWatch Logsグループ名を指定します。
          log_group_name = "/aws/emr-containers/jobs"

          # log_stream_name_prefix - ログストリーム名プレフィックス
          # Type: string (optional)
          #
          # ログストリームの名前プレフィックスを指定します。
          log_stream_name_prefix = "spark-job"
        }

        ################################################################################
        # s3_monitoring_configuration ブロック（オプション）
        ################################################################################
        # S3へのログ発行設定です。
        s3_monitoring_configuration {
          # log_uri - ログURI
          # Type: string (required)
          #
          # ログ発行のためのAmazon S3の宛先URIを指定します。
          # 例: "s3://my-bucket/logs/emr-containers/"
          log_uri = "s3://my-emr-logs-bucket/job-logs/"
        }
      }
    }
  }

  ################################################################################
  # timeouts ブロック（オプション）
  ################################################################################
  # リソース操作のタイムアウト設定です。
  timeouts {
    # delete - 削除タイムアウト
    # Type: string (optional)
    #
    # リソース削除のタイムアウト時間を指定します。
    #
    # デフォルト値: 設定なし
    # 形式: "30m" (30分)、"1h" (1時間) など
    delete = "30m"
  }
}

################################################################################
# 出力例
################################################################################
# このリソースから取得可能な属性:
#
# - arn : ジョブテンプレートのARN
#   例: aws_emrcontainers_job_template.example.arn
#
# - id : ジョブテンプレートのID
#   例: aws_emrcontainers_job_template.example.id
#
# - tags_all : プロバイダーのdefault_tagsを含む全タグのマップ
#   例: aws_emrcontainers_job_template.example.tags_all

################################################################################
# 使用例
################################################################################
# 基本的な使用例:
#
# resource "aws_emrcontainers_job_template" "basic" {
#   name = "basic-spark-job"
#
#   job_template_data {
#     execution_role_arn = aws_iam_role.emr_job_execution.arn
#     release_label      = "emr-6.10.0-latest"
#
#     job_driver {
#       spark_sql_job_driver {
#         entry_point = "s3://my-bucket/scripts/query.sql"
#       }
#     }
#   }
# }
#
# Spark Submitを使用する例:
#
# resource "aws_emrcontainers_job_template" "spark_submit" {
#   name = "spark-submit-job"
#
#   job_template_data {
#     execution_role_arn = aws_iam_role.emr_job_execution.arn
#     release_label      = "emr-6.10.0-latest"
#
#     job_driver {
#       spark_submit_job_driver {
#         entry_point = "s3://my-bucket/jars/my-app.jar"
#         entry_point_arguments = ["--input", "s3://input/", "--output", "s3://output/"]
#         spark_submit_parameters = "--class com.example.Main --conf spark.executor.instances=5"
#       }
#     }
#   }
# }

################################################################################
# 関連リソース
################################################################################
# - aws_emrcontainers_virtual_cluster: EMR on EKSの仮想クラスター
# - aws_iam_role: ジョブ実行に使用するIAMロール
# - aws_kms_key: ジョブテンプレートの暗号化に使用するKMSキー
#
# 参考リンク:
# - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emrcontainers_job_template
# - AWS EMR on EKS Documentation: https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/
# - AWS API Reference: https://docs.aws.amazon.com/emr-on-eks/latest/APIReference/
