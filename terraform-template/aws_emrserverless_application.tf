# AWS EMR Serverless Application
# https://registry.terraform.io/providers/hashicorp/aws/6.36.0/docs/resources/emrserverless_application
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
#
# EMR Serverlessアプリケーションのリソースです。
# SparkやHiveなどのビッグデータ処理ワークロードをサーバーレス環境で実行できます。
# ジョブ送信時に自動的にキャパシティをスケールし、アイドル時には自動停止することでコストを最適化します。
#
# NOTE:
# - アプリケーションタイプはsparkまたはhiveのみサポート
# - ワーカータイプはアプリケーションタイプにより異なる（Spark: Driver/Executor、Hive: HiveDriver/TezTask）
# - scheduler_configurationはEMR 7.0.0以降でのみ利用可能
# - prometheus_monitoring_configurationはEMR 7.1.0以降でのみ利用可能

resource "aws_emrserverless_application" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------
  # 設定内容: アプリケーション名
  # 必須項目
  name = "example-app"

  # 設定内容: EMRリリースバージョン
  # 必須項目
  # 設定可能な値: emr-6.6.0, emr-6.8.0, emr-7.0.0, emr-7.1.0など
  release_label = "emr-6.6.0"

  # 設定内容: アプリケーションタイプ
  # 必須項目
  # 設定可能な値: spark, hive
  type = "spark"

  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  # 設定内容: リソースタグ
  # 省略時: タグなし
  tags = {
    Environment = "production"
    Application = "data-processing"
  }

  #---------------------------------------
  # アーキテクチャ設定
  #---------------------------------------
  # 設定内容: CPUアーキテクチャ
  # 省略時: X86_64
  # 設定可能な値: ARM64（Graviton）、X86_64
  # 備考: Gravitonプロセッサはx86_64と比較してコストパフォーマンスに優れる
  architecture = "X86_64"

  # auto_start_configuration {
  #   # 設定内容: ジョブ送信時の自動起動を有効化
  #   # 省略時: true（有効）
  #   enabled = true
  # }

  # auto_stop_configuration {
  #   # 設定内容: アイドル時の自動停止を有効化
  #   # 省略時: true（有効）
  #   enabled = true
  #
  #   # 設定内容: アイドル状態が継続した場合に自動停止するまでの時間（分）
  #   # 省略時: 15分
  #   idle_timeout_minutes = 15
  # }

  #---------------------------------------
  # キャパシティ設定
  #---------------------------------------
  # initial_capacity {
  #   # 設定内容: 初期キャパシティのワーカータイプ
  #   # 必須項目
  #   # 設定可能な値: Sparkの場合はDriver/Executor、Hiveの場合はHiveDriver/TezTask
  #   initial_capacity_type = "Driver"
  #
  #   initial_capacity_config {
  #     # 設定内容: 初期化するワーカー数
  #     # 必須項目
  #     worker_count = 1
  #
  #     worker_configuration {
  #       # 設定内容: ワーカーインスタンスのCPU要件
  #       # 必須項目
  #       # 設定可能な値: "1 vCPU", "2 vCPU", "4 vCPU"など
  #       cpu = "2 vCPU"
  #
  #       # 設定内容: ワーカーインスタンスのメモリ要件
  #       # 必須項目
  #       # 設定可能な値: "4 GB", "8 GB", "10 GB"など
  #       memory = "10 GB"
  #
  #       # 設定内容: ワーカーインスタンスのディスク要件
  #       # 省略時: 自動計算
  #       disk = null
  #     }
  #   }
  # }

  # maximum_capacity {
  #   # 設定内容: アプリケーションの最大CPU制限
  #   # 必須項目
  #   # 備考: すべてのワーカーの累積値での制限
  #   cpu = "2 vCPU"
  #
  #   # 設定内容: アプリケーションの最大メモリ制限
  #   # 必須項目
  #   # 備考: すべてのワーカーの累積値での制限
  #   memory = "10 GB"
  #
  #   # 設定内容: アプリケーションの最大ディスク制限
  #   # 省略時: 制限なし
  #   disk = null
  # }

  #---------------------------------------
  # ランタイム設定
  #---------------------------------------
  # runtime_configuration {
  #   # 設定内容: 設定の分類名
  #   # 必須項目
  #   # 設定可能な値: spark-defaults, spark-executor-log4j2, hive-siteなど
  #   classification = "spark-defaults"
  #
  #   # 設定内容: 設定ファイル内のプロパティ
  #   # 省略時: プロパティなし
  #   properties = {
  #     "spark.executor.memory" = "1g"
  #     "spark.executor.cores"  = "1"
  #   }
  # }

  #---------------------------------------
  # ネットワーク設定
  #---------------------------------------
  # network_configuration {
  #   # 設定内容: VPC接続用のセキュリティグループIDリスト
  #   # 省略時: セキュリティグループなし
  #   security_group_ids = []
  #
  #   # 設定内容: VPC接続用のサブネットIDリスト
  #   # 省略時: サブネットなし
  #   subnet_ids = []
  # }

  #---------------------------------------
  # イメージ設定
  #---------------------------------------
  # image_configuration {
  #   # 設定内容: カスタムイメージのURI
  #   # 必須項目
  #   # 備考: すべてのワーカータイプに適用される
  #   image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/custom-emr-image:latest"
  # }

  #---------------------------------------
  # モニタリング設定
  #---------------------------------------
  # monitoring_configuration {
  #   cloudwatch_logging_configuration {
  #     # 設定内容: CloudWatch Logsへのログ送信を有効化
  #     # 必須項目
  #     enabled = true
  #
  #     # 設定内容: ログを送信するCloudWatch Logsロググループ名
  #     # 省略時: デフォルトロググループに送信
  #     log_group_name = "/aws/emr-serverless/example"
  #
  #     # 設定内容: ログストリーム名のプレフィックス
  #     # 省略時: プレフィックスなし
  #     log_stream_name_prefix = "spark-logs"
  #
  #     # 設定内容: CloudWatch Logsの暗号化に使用するKMSキーARN
  #     # 省略時: デフォルト暗号化
  #     encryption_key_arn = null
  #
  #     log_types {
  #       # 設定内容: ワーカータイプ
  #       # 必須項目
  #       # 設定可能な値: SPARK_DRIVER, SPARK_EXECUTOR, HIVE_DRIVER, TEZ_TASK
  #       name = "SPARK_DRIVER"
  #
  #       # 設定内容: 送信するログタイプのリスト
  #       # 必須項目
  #       # 設定可能な値: STDOUT, STDERR, HIVE_LOG, TEZ_AM, SYSTEM_LOGS
  #       values = ["STDOUT", "STDERR"]
  #     }
  #   }
  #
  #   s3_monitoring_configuration {
  #     # 設定内容: ログを送信するS3バケットURI
  #     # 省略時: S3へのログ送信なし
  #     log_uri = null
  #
  #     # 設定内容: S3に保存されるログの暗号化に使用するKMSキーARN
  #     # 省略時: デフォルト暗号化
  #     encryption_key_arn = null
  #   }
  #
  #   managed_persistence_monitoring_configuration {
  #     # 設定内容: マネージドログ永続化を有効化
  #     # 省略時: false（無効）
  #     enabled = false
  #
  #     # 設定内容: 永続化ログの暗号化に使用するKMSキーARN
  #     # 省略時: デフォルト暗号化
  #     encryption_key_arn = null
  #   }
  #
  #   prometheus_monitoring_configuration {
  #     # 設定内容: Prometheusメトリクスを送信するリモートライトURL
  #     # 省略時: Prometheusモニタリングなし
  #     # 備考: EMR 7.1.0以降でサポート
  #     remote_write_url = null
  #   }
  # }

  #---------------------------------------
  # インタラクティブ設定
  #---------------------------------------
  # interactive_configuration {
  #   # 設定内容: Apache Livyエンドポイントを有効化
  #   # 省略時: false（無効）
  #   # 備考: インタラクティブジョブの実行に使用
  #   livy_endpoint_enabled = false
  #
  #   # 設定内容: EMR Studioとの接続を有効化
  #   # 省略時: false（無効）
  #   # 備考: ノートブックでのインタラクティブワークロードに使用
  #   studio_enabled = false
  # }

  #---------------------------------------
  # スケジューラ設定
  #---------------------------------------
  # scheduler_configuration {
  #   # 設定内容: アプリケーション上で同時実行可能なジョブ数の最大値
  #   # 省略時: 15
  #   # 設定可能な値: 1〜1000
  #   # 備考: EMR 7.0.0以降でサポート
  #   max_concurrent_runs = 15
  #
  #   # 設定内容: ジョブがQUEUED状態で待機できる最大時間（分）
  #   # 省略時: 360分（6時間）
  #   # 設定可能な値: 15〜720分
  #   # 備考: EMR 7.0.0以降でサポート
  #   queue_timeout_minutes = 360
  # }

  #---------------------------------------
  # コスト配分設定
  #---------------------------------------
  # job_level_cost_allocation_configuration {
  #   # 設定内容: ジョブレベルのコスト配分を有効化
  #   # 省略時: false（無効）
  #   # 備考: 有効にすると個々のジョブ単位でコスト配分タグが付与される
  #   enabled = false
  # }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# 以下の属性がエクスポートされ、他のリソースから参照できます:
#
# - arn
#   アプリケーションのARN
#
# - id
#   アプリケーションのID
#
# - tags_all
#   リソースに割り当てられたタグのマップ
#   プロバイダーのdefault_tagsで設定されたタグも含む
