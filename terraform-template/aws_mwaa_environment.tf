#---------------------------------------------------------------
# AWS MWAA Environment
#---------------------------------------------------------------
#
# Amazon Managed Workflows for Apache Airflow (MWAA) 環境をプロビジョニングするリソースです。
# MWAA は Apache Airflow のマネージドサービスで、クラウド上でデータパイプラインを
# 大規模に設定・実行できます。自動スケーリング、セキュリティ、可用性を
# インフラストラクチャ管理なしで利用できます。
#
# AWS公式ドキュメント:
#   - Amazon MWAA とは: https://docs.aws.amazon.com/mwaa/latest/userguide/what-is-mwaa.html
#   - MWAA 環境の作成: https://docs.aws.amazon.com/mwaa/latest/userguide/create-environment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mwaa_environment
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_mwaa_environment" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Apache Airflow 環境の名前を指定します。
  # 設定可能な値: 1〜80文字の英数字とハイフン
  # 注意: 一度作成すると変更できません（再作成が必要）
  name = "my-mwaa-environment"

  # dag_s3_path (Required)
  # 設定内容: Amazon S3 バケット上の DAG フォルダへの相対パスを指定します。
  # 設定可能な値: 例: "dags/"
  # 参考: https://docs.aws.amazon.com/mwaa/latest/userguide/configuring-dag-import.html
  dag_s3_path = "dags/"

  # execution_role_arn (Required)
  # 設定内容: MWAA と環境が引き受けることができるタスク実行ロールの ARN を指定します。
  # 設定可能な値: 有効な IAM ロール ARN
  # 参考: https://docs.aws.amazon.com/mwaa/latest/userguide/mwaa-create-role.html
  execution_role_arn = "arn:aws:iam::123456789012:role/mwaa-execution-role"

  # source_bucket_arn (Required)
  # 設定内容: DAG コードとサポートファイルを保存する Amazon S3 バケットの ARN を指定します。
  # 設定可能な値: 有効な S3 バケット ARN（例: arn:aws:s3:::airflow-mybucketname）
  source_bucket_arn = "arn:aws:s3:::my-airflow-bucket"

  #-------------------------------------------------------------
  # ネットワーク設定（必須）
  #-------------------------------------------------------------

  # network_configuration (Required)
  # 設定内容: Apache Airflow 環境のネットワーク設定を指定します。
  # 注意: 2つのプライベートサブネットとセキュリティグループが必要です。
  #       各サブネットはインターネット接続が必要です（NAT Gateway 経由など）。
  network_configuration {
    # security_group_ids (Required)
    # 設定内容: 環境に関連付けるセキュリティグループ ID のリストを指定します。
    # 設定可能な値: セキュリティグループ ID のリスト
    # 注意: 少なくとも1つのセキュリティグループが MWAA リソース間の通信を許可する必要があります。
    security_group_ids = ["sg-xxxxxxxxxxxxxxxxx"]

    # subnet_ids (Required)
    # 設定内容: 環境を作成するプライベートサブネット ID のリストを指定します。
    # 設定可能な値: サブネット ID のリスト
    # 注意: MWAA は2つのサブネットを必要とします。
    subnet_ids = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]
  }

  #-------------------------------------------------------------
  # Airflow バージョン設定
  #-------------------------------------------------------------

  # airflow_version (Optional)
  # 設定内容: 環境の Apache Airflow バージョンを指定します。
  # 設定可能な値: MWAA がサポートするバージョン（例: "2.10.3", "2.9.2", "2.8.1"）
  # 省略時: MWAA がサポートする最新バージョンが設定されます。
  # 参考: https://docs.aws.amazon.com/mwaa/latest/userguide/airflow-versions.html
  airflow_version = null

  #-------------------------------------------------------------
  # Airflow 設定オプション
  #-------------------------------------------------------------

  # airflow_configuration_options (Optional)
  # 設定内容: Airflow のオーバーライドオプションを指定します。
  # 設定可能な値: キーと値のマップ
  # 設定例:
  #   - "core.default_task_retries" = "3"
  #   - "core.parallelism" = "32"
  #   - "webserver.default_ui_timezone" = "Asia/Tokyo"
  # 参考: https://docs.aws.amazon.com/mwaa/latest/userguide/configuring-env-variables.html
  # 注意: この属性は sensitive としてマークされています。
  airflow_configuration_options = {
    "core.default_task_retries" = "3"
    "core.parallelism"          = "32"
  }

  #-------------------------------------------------------------
  # 環境クラス・スケーリング設定
  #-------------------------------------------------------------

  # environment_class (Optional)
  # 設定内容: クラスターの環境クラスを指定します。
  # 設定可能な値:
  #   - "mw1.micro": 最小構成（開発・テスト向け）
  #   - "mw1.small" (デフォルト): 小規模ワークロード向け
  #   - "mw1.medium": 中規模ワークロード向け
  #   - "mw1.large": 大規模ワークロード向け
  # 参考: https://aws.amazon.com/managed-workflows-for-apache-airflow/pricing/
  environment_class = "mw1.small"

  # min_workers (Optional)
  # 設定内容: 環境で実行するワーカーの最小数を指定します。
  # 設定可能な値: 1 以上の整数
  # 省略時: 1
  min_workers = 1

  # max_workers (Optional)
  # 設定内容: 自動スケールアップできるワーカーの最大数を指定します。
  # 設定可能な値: 1〜25
  # 省略時: 10
  max_workers = 10

  # min_webservers (Optional)
  # 設定内容: 環境で実行する Web サーバーの最小数を指定します。
  # 設定可能な値:
  #   - mw1.micro 以外の environment_class: 2〜5
  #   - mw1.micro: 1
  min_webservers = null

  # max_webservers (Optional)
  # 設定内容: 環境で実行する Web サーバーの最大数を指定します。
  # 設定可能な値:
  #   - mw1.micro 以外の environment_class: 2〜5
  #   - mw1.micro: 1
  max_webservers = null

  # schedulers (Optional)
  # 設定内容: 環境で実行するスケジューラーの数を指定します。
  # 設定可能な値:
  #   - Airflow v2.0.2 以上: 2〜5（デフォルト: 2）
  #   - Airflow v1.10.12: 1
  schedulers = null

  #-------------------------------------------------------------
  # アクセス設定
  #-------------------------------------------------------------

  # webserver_access_mode (Optional)
  # 設定内容: Web サーバーへのアクセス方法を指定します。
  # 設定可能な値:
  #   - "PRIVATE_ONLY" (デフォルト): VPC 内からのみアクセス可能
  #   - "PUBLIC_ONLY": インターネット経由でアクセス可能
  # 注意: どちらの場合も IAM によるアクセス制御が適用されます。
  webserver_access_mode = "PRIVATE_ONLY"

  # endpoint_management (Optional)
  # 設定内容: VPC エンドポイントの作成・管理方法を指定します。
  # 設定可能な値:
  #   - "SERVICE" (デフォルト): AWS が必要な VPC エンドポイントを作成・管理
  #   - "CUSTOMER": 自分で VPC エンドポイントを作成・管理する必要がある
  endpoint_management = "SERVICE"

  #-------------------------------------------------------------
  # プラグイン・依存関係設定
  #-------------------------------------------------------------

  # plugins_s3_path (Optional)
  # 設定内容: S3 バケット上の plugins.zip ファイルへの相対パスを指定します。
  # 設定可能な値: 例: "plugins.zip"
  # 参考: https://docs.aws.amazon.com/mwaa/latest/userguide/configuring-dag-import.html
  # 注意: 相対パスを指定する場合は plugins_s3_object_version も必要です。
  plugins_s3_path = null

  # plugins_s3_object_version (Optional)
  # 設定内容: 使用する plugins.zip ファイルのバージョンを指定します。
  # 設定可能な値: S3 オブジェクトバージョン ID
  # 注意: plugins_s3_path で相対パスを指定した場合に必要です。
  plugins_s3_object_version = null

  # requirements_s3_path (Optional)
  # 設定内容: S3 バケット上の requirements.txt ファイルへの相対パスを指定します。
  # 設定可能な値: 例: "requirements.txt"
  # 参考: https://docs.aws.amazon.com/mwaa/latest/userguide/configuring-dag-import.html
  # 注意: 相対パスを指定する場合は requirements_s3_object_version も必要です。
  requirements_s3_path = null

  # requirements_s3_object_version (Optional)
  # 設定内容: 使用する requirements.txt ファイルのバージョンを指定します。
  # 設定可能な値: S3 オブジェクトバージョン ID
  # 注意: requirements_s3_path で相対パスを指定した場合に必要です。
  requirements_s3_object_version = null

  # startup_script_s3_path (Optional)
  # 設定内容: S3 バケット上のスタートアップスクリプトへの相対パスを指定します。
  # 設定可能な値: シェルスクリプトファイルへのパス
  # 機能: 環境起動時に Apache Airflow プロセス開始前に実行されます。
  #       依存関係のインストール、設定オプションの変更、環境変数の設定に使用できます。
  # 参考: https://docs.aws.amazon.com/mwaa/latest/userguide/using-startup-script.html
  # 対象: Airflow バージョン 2.x 以降でサポート
  startup_script_s3_path = null

  # startup_script_s3_object_version (Optional)
  # 設定内容: 使用するスタートアップスクリプトのバージョンを指定します。
  # 設定可能な値: S3 オブジェクトバージョン ID
  # 注意: ファイルを更新するたびに S3 が割り当てるバージョン ID を指定する必要があります。
  startup_script_s3_object_version = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key (Optional)
  # 設定内容: 暗号化に使用する KMS キーの ARN を指定します。
  # 設定可能な値: 有効な KMS キー ARN
  # 省略時: AWS マネージドキー aws/airflow が使用されます。
  # 参考: https://docs.aws.amazon.com/mwaa/latest/userguide/custom-keys-certs.html
  kms_key = null

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # logging_configuration (Optional)
  # 設定内容: Amazon CloudWatch Logs に送信する Apache Airflow ログの設定を指定します。
  logging_configuration {
    # dag_processing_logs (Optional)
    # 設定内容: DAG 処理ログの設定を指定します。
    # 省略時: 無効
    dag_processing_logs {
      # enabled (Optional)
      # 設定内容: ログ収集を有効にするかを指定します。
      # 設定可能な値: true / false
      enabled = true

      # log_level (Optional)
      # 設定内容: ログレベルを指定します。
      # 設定可能な値: "CRITICAL", "ERROR", "WARNING", "INFO", "DEBUG"
      # 省略時: "INFO"
      log_level = "INFO"
    }

    # scheduler_logs (Optional)
    # 設定内容: スケジューラーログの設定を指定します。
    # 省略時: 無効
    scheduler_logs {
      enabled   = true
      log_level = "INFO"
    }

    # task_logs (Optional)
    # 設定内容: DAG タスクログの設定を指定します。
    # 省略時: INFO レベルで有効
    task_logs {
      enabled   = true
      log_level = "INFO"
    }

    # webserver_logs (Optional)
    # 設定内容: Web サーバーログの設定を指定します。
    # 省略時: 無効
    webserver_logs {
      enabled   = true
      log_level = "INFO"
    }

    # worker_logs (Optional)
    # 設定内容: ワーカーログの設定を指定します。
    # 省略時: 無効
    worker_logs {
      enabled   = true
      log_level = "INFO"
    }
  }

  #-------------------------------------------------------------
  # メンテナンス設定
  #-------------------------------------------------------------

  # weekly_maintenance_window_start (Optional)
  # 設定内容: 週次メンテナンスウィンドウの開始日時を指定します。
  # 設定可能な値: "DAY:HH:MM" 形式（例: "SUN:00:00"）
  # 注意: UTC タイムゾーンで指定します。
  weekly_maintenance_window_start = null

  # worker_replacement_strategy (Optional)
  # 設定内容: ワーカー置換戦略を指定します。
  # 設定可能な値:
  #   - "FORCED": 即座にワーカーを置換（タスクが中断される可能性あり）
  #   - "GRACEFUL": タスク完了を待ってからワーカーを置換
  worker_replacement_strategy = null

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
  # 設定内容: リソースに関連付けるタグのマップを指定します。
  # 設定可能な値: キーと値のマップ
  # 注意: プロバイダーの default_tags 設定がある場合、同じキーのタグは
  #       このリソースで設定した値で上書きされます。
  tags = {
    Name        = "my-mwaa-environment"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 注意: MWAA 環境の作成・更新には時間がかかることがあります。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "120m", "2h"）
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "120m", "2h"）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "120m", "2h"）
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能です（設定不可）:
#
# - arn
#   MWAA 環境の ARN
#
# - created_at
#   MWAA 環境の作成日時
#
# - database_vpc_endpoint_service
#   環境の Amazon RDS データベース用 VPC エンドポイント
#
# - last_updated
#   最終更新情報（created_at, error, status を含むオブジェクト）
#
# - service_role_arn
#   Amazon MWAA 環境のサービスロール ARN
#
# - status
#   Amazon MWAA 環境のステータス
#
# - webserver_url
#   MWAA 環境の Web サーバー URL
#
# - webserver_vpc_endpoint_service
#   環境の Web サーバー用 VPC エンドポイント
#
# - logging_configuration[0].<LOG_TYPE>[0].cloud_watch_log_group_arn
#   各ログタイプの CloudWatch ロググループ ARN
#
#---------------------------------------------------------------
