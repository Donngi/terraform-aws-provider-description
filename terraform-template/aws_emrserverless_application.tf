#---------------------------------------------------------------
# EMR Serverless Application
#---------------------------------------------------------------
#
# Amazon EMR Serverless アプリケーションをプロビジョニングします。
# EMR Serverless は、クラスターやサーバーを管理することなく Apache Spark、
# Apache Hive などのビッグデータ分析フレームワークを実行できる
# Amazon EMR のデプロイオプションです。
#
# アプリケーションはクラスターテンプレートとして機能し、
# ジョブの送信時に自動的にリソースをプロビジョニングし、
# 完了後にリソースを解放します。
#
# AWS公式ドキュメント:
#   - Getting started from the AWS CLI: https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/gs-cli.html
#   - EMR Serverless User Guide: https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emrserverless_application
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_emrserverless_application" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # アプリケーション名
  # EMR Serverless アプリケーションの名前を指定します。
  name = "example-application"

  # リリースラベル
  # アプリケーションに関連付けられる EMR リリースバージョンを指定します。
  # 例: "emr-6.6.0", "emr-7.0.0", "emr-7.1.0"
  # 各リリースには異なるバージョンの Spark、Hive などのフレームワークが含まれます。
  release_label = "emr-6.6.0"

  # アプリケーションタイプ
  # 起動するアプリケーションのタイプを指定します。
  # 有効な値: "spark", "hive"
  type = "spark"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # アーキテクチャ
  # アプリケーションの CPU アーキテクチャを指定します。
  # 有効な値: "ARM64", "X86_64"
  # デフォルト: "X86_64"
  # AWS Graviton プロセッサ (ARM64) を使用すると、x86_64 と比較して
  # パフォーマンスの向上とコスト削減が期待できます。
  architecture = "X86_64"

  # ID
  # リソースの ID を指定します。
  # 通常は省略され、Terraform により自動的に生成されます。
  # 明示的に指定することもできますが、一般的には推奨されません。
  # id = "custom-id"

  # リージョン
  # このリソースが管理されるリージョンを指定します。
  # 省略した場合、プロバイダー設定のリージョンが使用されます。
  # region = "us-east-1"

  # タグ
  # リソースに割り当てるキーと値のマッピングを指定します。
  # プロバイダーの default_tags 設定ブロックが存在する場合、
  # 一致するキーを持つタグは上書きされます。
  tags = {
    Environment = "production"
    Project     = "data-analytics"
  }

  # タグ（すべて）
  # リソースに割り当てられるすべてのタグを指定します。
  # プロバイダーの default_tags 設定ブロックからのタグも含めることができます。
  # 通常は tags を使用し、tags_all は特別な理由がある場合のみ使用します。
  # tags_all = {
  #   Environment = "production"
  #   Project     = "data-analytics"
  #   ManagedBy   = "terraform"
  # }

  #---------------------------------------------------------------
  # 自動開始設定 (auto_start_configuration)
  #---------------------------------------------------------------
  # ジョブ送信時にアプリケーションを自動的に開始する設定

  auto_start_configuration {
    # 有効化フラグ
    # ジョブ送信時にアプリケーションを自動的に開始します。
    # デフォルト: true
    enabled = true
  }

  #---------------------------------------------------------------
  # 自動停止設定 (auto_stop_configuration)
  #---------------------------------------------------------------
  # 一定時間アイドル状態が続いた後にアプリケーションを自動停止する設定

  auto_stop_configuration {
    # 有効化フラグ
    # 一定時間アイドル状態が続いた後にアプリケーションを自動停止します。
    # デフォルト: true
    enabled = true

    # アイドルタイムアウト (分)
    # アプリケーションが自動停止するまでのアイドル時間を分単位で指定します。
    # デフォルト: 15 分
    idle_timeout_minutes = 15
  }

  #---------------------------------------------------------------
  # イメージ設定 (image_configuration)
  #---------------------------------------------------------------
  # すべてのワーカータイプに適用されるイメージ設定
  # カスタム Docker イメージを使用する場合に指定します。

  # image_configuration {
  #   # イメージ URI
  #   # カスタムコンテナイメージの URI を指定します。
  #   # Amazon ECR に保存されたイメージを使用できます。
  #   image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/emr-custom-image:latest"
  # }

  #---------------------------------------------------------------
  # 初期容量設定 (initial_capacity)
  #---------------------------------------------------------------
  # アプリケーション作成時に初期化する容量の設定
  # デフォルトではオンデマンドで作成されますが、
  # 事前初期化された容量を設定することでジョブの起動レイテンシを削減できます。

  initial_capacity {
    # 初期容量タイプ
    # ワーカータイプを指定します。
    # Spark アプリケーションの場合: "Driver", "Executor"
    # Hive アプリケーションの場合: "HiveDriver", "TezTask"
    initial_capacity_type = "Driver"

    initial_capacity_config {
      # ワーカー数
      # 初期容量設定におけるワーカーの数を指定します。
      worker_count = 1

      worker_configuration {
        # CPU
        # ワーカータイプの各ワーカーインスタンスに必要な CPU を指定します。
        # 形式: "<数値> vCPU" (例: "2 vCPU", "4 vCPU")
        cpu = "2 vCPU"

        # メモリ
        # ワーカータイプの各ワーカーインスタンスに必要なメモリを指定します。
        # 形式: "<数値> GB" (例: "4 GB", "8 GB")
        memory = "4 GB"

        # ディスク
        # ワーカータイプの各ワーカーインスタンスに必要なディスク容量を指定します。
        # 形式: "<数値> GB" (例: "20 GB")
        # 省略可能。デフォルト値が使用されます。
        # disk = "20 GB"
      }
    }
  }

  initial_capacity {
    initial_capacity_type = "Executor"

    initial_capacity_config {
      worker_count = 2

      worker_configuration {
        cpu    = "4 vCPU"
        memory = "8 GB"
      }
    }
  }

  #---------------------------------------------------------------
  # インタラクティブ設定 (interactive_configuration)
  #---------------------------------------------------------------
  # アプリケーション実行時のインタラクティブユースケースを有効化する設定

  # interactive_configuration {
  #   # Livy エンドポイント有効化
  #   # Apache Livy エンドポイントを有効にして、
  #   # インタラクティブジョブを接続して実行できるようにします。
  #   livy_endpoint_enabled = false
  #
  #   # Studio 有効化
  #   # Amazon EMR Studio にアプリケーションを接続して、
  #   # ノートブックでインタラクティブワークロードを実行できるようにします。
  #   studio_enabled = false
  # }

  #---------------------------------------------------------------
  # 最大容量設定 (maximum_capacity)
  #---------------------------------------------------------------
  # アプリケーション作成時に割り当てる最大容量の設定
  # これは特定の時点でのすべてのワーカーを通じた累積容量であり、
  # アプリケーション作成時だけではありません。
  # 定義された制限のいずれかに達すると、新しいリソースは作成されません。

  maximum_capacity {
    # CPU
    # アプリケーションに許可される最大 CPU を指定します。
    # 形式: "<数値> vCPU" (例: "200 vCPU")
    cpu = "200 vCPU"

    # メモリ
    # アプリケーションに許可される最大メモリを指定します。
    # 形式: "<数値> GB" (例: "1000 GB")
    memory = "1000 GB"

    # ディスク
    # アプリケーションに許可される最大ディスク容量を指定します。
    # 形式: "<数値> GB"
    # 省略可能。
    # disk = "5000 GB"
  }

  #---------------------------------------------------------------
  # モニタリング設定 (monitoring_configuration)
  #---------------------------------------------------------------
  # ログとメトリクスのモニタリング設定

  monitoring_configuration {
    # CloudWatch ロギング設定
    cloudwatch_logging_configuration {
      # 有効化フラグ
      # CloudWatch ロギングを有効にします。
      enabled = true

      # ロググループ名
      # Amazon CloudWatch Logs でログを公開するロググループの名前を指定します。
      # 省略可能。
      log_group_name = "/aws/emr-serverless/example"

      # ログストリーム名プレフィックス
      # CloudWatch ログストリーム名のプレフィックスを指定します。
      # 省略可能。
      log_stream_name_prefix = "spark-logs"

      # 暗号化キー ARN
      # CloudWatch Logs に保存するログを暗号化する AWS KMS キー ARN を指定します。
      # 省略可能。
      # encryption_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

      # ログタイプ
      # CloudWatch に公開するログのタイプを指定します。
      # ログタイプを指定しない場合、デフォルトでドライバーの STDOUT と STDERR ログが
      # CloudWatch Logs に公開されます。
      log_types {
        # ワーカータイプ名
        # 有効な値: "SPARK_DRIVER", "SPARK_EXECUTOR", "HIVE_DRIVER", "TEZ_TASK"
        name = "SPARK_DRIVER"

        # ログタイプの値リスト
        # 有効な値: "STDOUT", "STDERR", "HIVE_LOG", "TEZ_AM", "SYSTEM_LOGS"
        values = ["STDOUT", "STDERR"]
      }

      log_types {
        name   = "SPARK_EXECUTOR"
        values = ["STDOUT"]
      }
    }

    # S3 モニタリング設定
    # Amazon S3 へのログ公開設定
    # s3_monitoring_configuration {
    #   # ログ URI
    #   # ログ公開用の Amazon S3 送信先 URI を指定します。
    #   log_uri = "s3://example-bucket/emr-serverless-logs/"
    #
    #   # 暗号化キー ARN
    #   # 指定された Amazon S3 送信先に公開されるログを暗号化する KMS キー ARN を指定します。
    #   # encryption_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    # }

    # マネージド永続化モニタリング設定
    # マネージドログ永続化の設定
    # managed_persistence_monitoring_configuration {
    #   # 有効化フラグ
    #   # マネージドログ永続化を有効にします。
    #   enabled = false
    #
    #   # 暗号化キー ARN
    #   # マネージド永続化に保存されるログを暗号化する KMS キー ARN を指定します。
    #   # encryption_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    # }

    # Prometheus モニタリング設定
    # Prometheus メトリクスの送信設定
    # EMR 7.1.0 以降でサポートされています。
    # prometheus_monitoring_configuration {
    #   # リモートライト URL
    #   # メトリクスを送信するための Prometheus リモートライト URL を指定します。
    #   remote_write_url = "https://prometheus-remote-write-endpoint.example.com/api/v1/write"
    # }
  }

  #---------------------------------------------------------------
  # ネットワーク設定 (network_configuration)
  #---------------------------------------------------------------
  # カスタマー VPC 接続のためのネットワーク設定
  # VPC 内のデータストアに接続する場合に設定します。

  # network_configuration {
  #   # セキュリティグループ ID
  #   # カスタマー VPC 接続用のセキュリティグループ ID の配列を指定します。
  #   # VPC 内のリソースへのアクセスを制御します。
  #   security_group_ids = ["sg-12345678"]
  #
  #   # サブネット ID
  #   # カスタマー VPC 接続用のサブネット ID の配列を指定します。
  #   # マルチ AZ の恩恵を受けるため、複数のアベイラビリティゾーンにまたがる
  #   # 複数のサブネットを指定することを推奨します。
  #   subnet_ids = ["subnet-12345678", "subnet-87654321"]
  # }

  #---------------------------------------------------------------
  # ランタイム設定 (runtime_configuration)
  #---------------------------------------------------------------
  # アプリケーションのプロビジョニング時に使用される設定仕様
  # アプリケーション固有の設定ファイルとそのプロパティを指定します。
  # 複数の runtime_configuration ブロックを定義できます。

  # runtime_configuration {
  #   # 分類
  #   # 設定内の分類を指定します。
  #   # アプリケーション固有の設定ファイルを参照します。
  #   # 例: "spark-defaults", "spark-executor-log4j2", "hive-site"
  #   classification = "spark-defaults"
  #
  #   # プロパティ
  #   # 設定分類内で指定するプロパティのセットを指定します。
  #   properties = {
  #     "spark.executor.memory" = "4g"
  #     "spark.executor.cores"  = "2"
  #   }
  # }

  #---------------------------------------------------------------
  # スケジューラー設定 (scheduler_configuration)
  #---------------------------------------------------------------
  # このアプリケーションで実行されるバッチおよびストリーミングジョブの
  # スケジューラー設定
  # リリースラベル emr-7.0.0 以降でサポートされています。

  # scheduler_configuration {
  #   # 最大同時実行数
  #   # このアプリケーションで実行できる最大同時ジョブ実行数を指定します。
  #   # 有効範囲: 1 ~ 1000
  #   # デフォルト: 15
  #   max_concurrent_runs = 15
  #
  #   # キュータイムアウト (分)
  #   # QUEUED 状態のジョブの最大期間を分単位で指定します。
  #   # 有効範囲: 15 ~ 720
  #   # デフォルト: 360
  #   queue_timeout_minutes = 360
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性は computed only (読み取り専用) で、リソース作成後に参照可能です。

# arn
# - アプリケーションの ARN
# - 例: output "application_arn" { value = aws_emrserverless_application.example.arn }

# id
# - アプリケーションの ID
# - 例: output "application_id" { value = aws_emrserverless_application.example.id }

# tags_all
# - プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたタグのマップ
# - 例: output "all_tags" { value = aws_emrserverless_application.example.tags_all }
