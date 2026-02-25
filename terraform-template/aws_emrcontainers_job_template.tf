#---------------------------------------
# EMR Containers ジョブテンプレート
#---------------------------------------
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emrcontainers_job_template
# Generated: 2026-02-17
#
# EMR on EKS環境でジョブ実行に使用する再利用可能なテンプレートを定義します。
# StartJobRun APIの実行設定をテンプレート化することで、
# 一貫性のあるジョブ起動パラメータを管理できます。
#
# 【主な用途】
# - Sparkジョブの標準設定をテンプレート化
# - ジョブ起動パラメータの一貫性確保
# - 複数環境での設定の再利用
# - ジョブ実行設定の集中管理
#
# 【前提条件】
# - EMR on EKSクラスタが構成済みであること
# - ジョブ実行用のIAMロールが作成済みであること
# - 必要に応じてKMSキーが準備されていること
#
# 【料金】
# - ジョブテンプレート自体に追加料金なし
# - 実行されるEMRジョブの実行時間に対して課金
#
# 【制限事項】
# - ジョブドライバーはSparkSQLまたはSparkSubmitのいずれか1つのみ指定可能
# - アプリケーション設定は最大100個まで
# - ネストされた設定も最大100個まで
#
# NOTE: このテンプレートは実際のインフラ構築前に内容を確認・調整してください。

resource "aws_emrcontainers_job_template" "example" {
  #-------
  # 基本設定
  #-------
  # 設定内容: ジョブテンプレートの名前
  # 補足: テンプレートを識別するための一意な名前を指定します
  name = "example-job-template"

  # 設定内容: KMSキーのARN
  # 補足: ジョブテンプレートの暗号化に使用するKMSキーを指定します
  # 省略時: 暗号化なし
  kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------
  # ジョブテンプレートデータ
  #-------
  # 設定内容: StartJobRun APIリクエストのパラメータを保持するジョブテンプレートデータ
  # 補足: ジョブ実行時の標準設定を定義します
  job_template_data {
    # 設定内容: ジョブ実行に使用するIAMロールのARN
    # 補足: EMRジョブがAWSリソースにアクセスするための権限を持つロールを指定します
    execution_role_arn = "arn:aws:iam::123456789012:role/EMRContainers-JobExecutionRole"

    # 設定内容: Amazon EMRのリリースバージョン
    # 設定可能な値: emr-6.x.x-latest形式のバージョン文字列
    # 補足: 使用するEMRランタイムバージョンを指定します
    release_label = "emr-6.10.0-latest"

    # 設定内容: ジョブに割り当てるタグ
    # 補足: ジョブテンプレートから起動されるジョブに自動的に付与されるタグです
    # 省略時: タグなし
    # job_tags = {
    #   Environment = "production"
    #   Application = "data-pipeline"
    # }

    #-------
    # ジョブドライバー設定（必須）
    #-------
    # 設定内容: ジョブの実行形式を定義
    # 補足: SparkSQLまたはSparkSubmitのいずれか1つを指定します
    job_driver {
      #-------
      # Spark SQLジョブドライバー
      #-------
      # 設定内容: Spark SQLジョブの実行パラメータ
      # 補足: SQLファイルを実行する場合に使用します
      spark_sql_job_driver {
        # 設定内容: 実行するSQLファイルのパス
        # 補足: S3上のSQLファイルパスまたは"default"を指定します
        # 省略時: デフォルト設定
        entry_point = "s3://example-bucket/scripts/example.sql"

        # 設定内容: Spark SQLコマンドに含めるパラメータ
        # 補足: SQL実行時の追加パラメータを指定します
        # 省略時: パラメータなし
        # spark_sql_parameters = "--conf spark.sql.shuffle.partitions=200"
      }

      #-------
      # Spark Submitジョブドライバー（SparkSQLと排他）
      #-------
      # 設定内容: Spark Submitジョブの実行パラメータ
      # 補足: JARファイルやPythonスクリプトを実行する場合に使用します
      # spark_submit_job_driver {
      #   # 設定内容: ジョブアプリケーションのエントリーポイント
      #   # 補足: S3上のJARファイルまたはPythonスクリプトのパスを指定します
      #   entry_point = "s3://example-bucket/jars/example.jar"
      #
      #   # 設定内容: ジョブアプリケーションの引数
      #   # 補足: アプリケーションに渡すコマンドライン引数のリストです
      #   # 省略時: 引数なし
      #   # entry_point_arguments = [
      #   #   "--input", "s3://example-bucket/input/",
      #   #   "--output", "s3://example-bucket/output/"
      #   # ]
      #
      #   # 設定内容: ジョブ実行に使用するSpark Submitパラメータ
      #   # 補足: Spark設定や依存JARの指定などを行います
      #   # 省略時: デフォルトパラメータ
      #   # spark_submit_parameters = "--class com.example.MainClass --conf spark.executor.instances=2"
      # }
    }

    #-------
    # 設定オーバーライド
    #-------
    # 設定内容: デフォルト設定をオーバーライドする設定
    # 補足: アプリケーション設定とモニタリング設定を定義します
    # 省略時: デフォルト設定を使用
    # configuration_overrides {
    #   #-------
    #   # アプリケーション設定
    #   #-------
    #   # 設定内容: ジョブ実行で使用するアプリケーションの設定
    #   # 補足: Spark、Hive、Prestoなどの設定を最大100個まで定義できます
    #   # 省略時: デフォルト設定
    #   # application_configuration {
    #   #   # 設定内容: 設定の分類
    #   #   # 設定可能な値: spark-defaults, spark-env, hive-site, core-site等
    #   #   # 補足: 設定ファイルの種類を指定します
    #   #   classification = "spark-defaults"
    #   #
    #   #   # 設定内容: 設定分類内で指定するプロパティのセット
    #   #   # 補足: キーバリュー形式で設定値を定義します
    #   #   # 省略時: プロパティなし
    #   #   # properties = {
    #   #   #   "spark.executor.memory" = "4G"
    #   #   #   "spark.executor.cores"  = "2"
    #   #   # }
    #   #
    #   #   # 設定内容: ネストされた追加設定のリスト
    #   #   # 補足: 設定階層が必要な場合に使用し、最大100個まで定義できます
    #   #   # 省略時: ネスト設定なし
    #   #   # configurations {
    #   #   #   classification = "export"
    #   #   #   properties = {
    #   #   #     "JAVA_HOME" = "/usr/lib/jvm/java-11"
    #   #   #   }
    #   #   # }
    #   # }
    #
    #   #-------
    #   # モニタリング設定
    #   #-------
    #   # 設定内容: ジョブのモニタリング設定
    #   # 補足: CloudWatchログやS3へのログ出力を定義します
    #   # 省略時: モニタリングなし
    #   # monitoring_configuration {
    #   #   # 設定内容: 永続的アプリケーションUIの設定
    #   #   # 設定可能な値: ENABLED, DISABLED
    #   #   # 補足: ジョブ完了後もSpark UIを閲覧可能にするかを指定します
    #   #   # 省略時: DISABLED（計算値）
    #   #   # persistent_app_ui = "ENABLED"
    #   #
    #   #   # 設定内容: CloudWatchへのログ出力設定
    #   #   # 補足: ジョブログをCloudWatch Logsに送信する設定です
    #   #   # 省略時: CloudWatchログ出力なし
    #   #   # cloud_watch_monitoring_configuration {
    #   #   #   # 設定内容: ログ出力先のCloudWatchロググループ名
    #   #   #   # 補足: ログを保存するロググループを指定します
    #   #   #   log_group_name = "/aws/emr-containers/jobs"
    #   #   #
    #   #   #   # 設定内容: ログストリーム名のプレフィックス
    #   #   #   # 補足: ログストリームの命名規則を定義します
    #   #   #   # 省略時: デフォルトプレフィックス
    #   #   #   # log_stream_name_prefix = "job-"
    #   #   # }
    #   #
    #   #   # 設定内容: S3へのログ出力設定
    #   #   # 補足: ジョブログをS3に保存する設定です
    #   #   # 省略時: S3ログ出力なし
    #   #   # s3_monitoring_configuration {
    #   #   #   # 設定内容: ログ出力先のS3 URI
    #   #   #   # 補足: S3バケットとプレフィックスを指定します
    #   #   #   log_uri = "s3://example-bucket/emr-logs/"
    #   #   # }
    #   # }
    # }
  }

  #-------
  # リソース管理タグ
  #-------
  # 設定内容: リソースに付けるタグのキーバリューマッピング
  # 補足: コスト配分やリソース管理に使用します
  # 省略時: タグなし
  tags = {
    Name        = "example-job-template"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------
  # リージョン設定
  #-------
  # 設定内容: リソースを管理するAWSリージョン
  # 補足: 明示的にリージョンを指定する場合に使用します
  # 省略時: プロバイダー設定のリージョン（計算値）
  region = "ap-northeast-1"

  #-------
  # タイムアウト設定
  #-------
  # 設定内容: リソース操作のタイムアウト時間
  # 省略時: デフォルトタイムアウト
  # timeouts {
  #   # 設定内容: 削除操作のタイムアウト時間
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトタイムアウト
  #   # delete = "30m"
  # }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースの作成後に参照可能な属性：
#
# arn
#   ジョブテンプレートのARN
#   例: arn:aws:emr-containers:ap-northeast-1:123456789012:/jobtemplates/abc123def456
#
# id
#   ジョブテンプレートのID
#   補足: ARNと同じ値が設定されます
#
# tags_all
#   リソースに割り当てられたタグのマップ
#   補足: プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます
#
# 参照例:
#   output "job_template_arn" {
#     value = aws_emrcontainers_job_template.example.arn
#   }
