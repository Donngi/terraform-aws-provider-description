#---------------------------------------------------------------
# Amazon MWAA Environment (Managed Workflows for Apache Airflow)
#---------------------------------------------------------------
#
# Amazon MWAA (Managed Workflows for Apache Airflow) の実行環境をプロビジョニングするリソースです。
# Apache Airflowをフルマネージドで提供し、データパイプラインやETLワークフローの管理に使用します。
# DAGファイルはS3バケットから参照し、VPC内のプライベートサブネットで動作します。
#
# AWS公式ドキュメント:
#   - Amazon MWAA とは: https://docs.aws.amazon.com/mwaa/latest/userguide/what-is-mwaa.html
#   - 環境の作成: https://docs.aws.amazon.com/mwaa/latest/userguide/create-environment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mwaa_environment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_mwaa_environment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: MWAA環境の一意な名前を指定します。
  # 設定可能な値: 1〜80文字。英数字、ハイフンが使用可能
  name = "example-mwaa-environment"

  # execution_role_arn (Required)
  # 設定内容: Apache AirflowがAWSリソースにアクセスする際に使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  execution_role_arn = "arn:aws:iam::123456789012:role/mwaa-execution-role"

  # source_bucket_arn (Required)
  # 設定内容: DAGファイル・プラグイン・依存ファイルを格納するS3バケットのARNを指定します。
  # 設定可能な値: 有効なS3バケットARN
  # 注意: バケットはバージョニングを有効にする必要があります
  source_bucket_arn = "arn:aws:s3:::example-mwaa-bucket"

  # dag_s3_path (Required)
  # 設定内容: S3バケット内のDAGファイルを含むフォルダのパスを指定します。
  # 設定可能な値: S3バケット内の有効なフォルダパス（例: "dags/"）
  dag_s3_path = "dags/"

  # airflow_version (Optional)
  # 設定内容: 使用するApache Airflowのバージョンを指定します。
  # 設定可能な値: "2.5.1", "2.6.3", "2.7.2", "2.8.1", "2.9.2" 等のサポートされるバージョン
  # 省略時: AWSが提供する最新バージョンを自動選択
  # 参考: https://docs.aws.amazon.com/mwaa/latest/userguide/airflow-versions.html
  airflow_version = "2.9.2"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # kms_key (Optional)
  # 設定内容: データ暗号化に使用するカスタマー管理KMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWSマネージドキーによる暗号化
  kms_key = null

  #-------------------------------------------------------------
  # 環境クラス設定
  #-------------------------------------------------------------

  # environment_class (Optional)
  # 設定内容: 環境のコンピューティングリソースクラスを指定します。
  # 設定可能な値:
  #   - "mw1.micro": マイクロクラス（開発・テスト用）
  #   - "mw1.small": スモールクラス
  #   - "mw1.medium": ミディアムクラス
  #   - "mw1.large": ラージクラス
  #   - "mw1.xlarge": エクストララージクラス
  #   - "mw1.2xlarge": 2Xラージクラス（大規模ワークロード用）
  # 省略時: "mw1.small"
  environment_class = "mw1.small"

  # min_workers (Optional)
  # 設定内容: 実行環境で実行されるワーカーの最小数を指定します。
  # 設定可能な値: 1〜25 の整数
  # 省略時: 1
  min_workers = 1

  # max_workers (Optional)
  # 設定内容: 実行環境でオートスケーリングできるワーカーの最大数を指定します。
  # 設定可能な値: 1〜25 の整数
  # 省略時: 10
  max_workers = 10

  # schedulers (Optional)
  # 設定内容: 実行環境で実行されるスケジューラーの数を指定します。
  # 設定可能な値: 2〜5 の整数（Airflow 2.x の場合）
  # 省略時: 2
  schedulers = 2

  # min_webservers (Optional)
  # 設定内容: 実行環境で実行されるWebサーバーの最小数を指定します。
  # 設定可能な値: 2〜5 の整数
  # 省略時: 2
  min_webservers = 2

  # max_webservers (Optional)
  # 設定内容: 実行環境でオートスケーリングできるWebサーバーの最大数を指定します。
  # 設定可能な値: 2〜5 の整数
  # 省略時: 2
  max_webservers = 2

  #-------------------------------------------------------------
  # S3ファイル設定
  #-------------------------------------------------------------

  # plugins_s3_path (Optional)
  # 設定内容: S3バケット内のプラグインファイル（plugins.zip）のパスを指定します。
  # 設定可能な値: S3バケット内の有効なファイルパス（例: "plugins/plugins.zip"）
  # 省略時: プラグインなし
  plugins_s3_path = null

  # plugins_s3_object_version (Optional)
  # 設定内容: S3バケット内のプラグインファイルのバージョンを指定します。
  # 設定可能な値: 有効なS3オブジェクトバージョンID
  # 省略時: 最新バージョンを使用（バージョニング変更を自動検知しない）
  plugins_s3_object_version = null

  # requirements_s3_path (Optional)
  # 設定内容: S3バケット内のPython依存関係ファイル（requirements.txt）のパスを指定します。
  # 設定可能な値: S3バケット内の有効なファイルパス（例: "requirements/requirements.txt"）
  # 省略時: 追加パッケージなし
  requirements_s3_path = null

  # requirements_s3_object_version (Optional)
  # 設定内容: S3バケット内のrequirements.txtファイルのバージョンを指定します。
  # 設定可能な値: 有効なS3オブジェクトバージョンID
  # 省略時: 最新バージョンを使用
  requirements_s3_object_version = null

  # startup_script_s3_path (Optional)
  # 設定内容: S3バケット内の起動スクリプトファイルのパスを指定します。
  # 設定可能な値: S3バケット内の有効なファイルパス（例: "scripts/startup.sh"）
  # 省略時: 起動スクリプトなし
  startup_script_s3_path = null

  # startup_script_s3_object_version (Optional)
  # 設定内容: S3バケット内の起動スクリプトファイルのバージョンを指定します。
  # 設定可能な値: 有効なS3オブジェクトバージョンID
  # 省略時: 最新バージョンを使用
  startup_script_s3_object_version = null

  #-------------------------------------------------------------
  # Airflow設定
  #-------------------------------------------------------------

  # airflow_configuration_options (Optional)
  # 設定内容: Apache Airflow の設定オプションをキーバリューマップで指定します。
  # 設定可能な値: Airflow設定のキーとバリューのマップ（例: "core.default_task_retries" = "3"）
  # 省略時: デフォルトのAirflow設定を使用
  # 注意: この属性はsensitiveとしてマークされており、Terraformのプランに表示されません
  # 参考: https://airflow.apache.org/docs/apache-airflow/stable/configurations-ref.html
  airflow_configuration_options = {
    "core.default_task_retries"         = "3"
    "core.parallelism"                  = "32"
    "webserver.dag_default_view"        = "grid"
  }

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # network_configuration (Required)
  # 設定内容: MWAA環境のVPCネットワーク設定ブロックです。
  # 関連機能: VPCネットワーク設定
  #   プライベートサブネットにMWAA環境を配置し、セキュリティグループで通信を制御します。
  #   - https://docs.aws.amazon.com/mwaa/latest/userguide/vpc-create.html
  network_configuration {

    # subnet_ids (Required)
    # 設定内容: MWAA環境が使用するプライベートサブネットIDのセットを指定します。
    # 設定可能な値: 2つの異なるAZのプライベートサブネットIDのセット
    # 注意: 必ず2つの異なるアベイラビリティゾーンのプライベートサブネットを指定すること
    subnet_ids = ["subnet-12345678", "subnet-87654321"]

    # security_group_ids (Required)
    # 設定内容: MWAA環境に関連付けるセキュリティグループIDのセットを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのセット（最大5つ）
    security_group_ids = ["sg-12345678"]
  }

  #-------------------------------------------------------------
  # ウェブサーバーアクセス設定
  #-------------------------------------------------------------

  # webserver_access_mode (Optional)
  # 設定内容: AirflowのWebサーバーへのアクセスモードを指定します。
  # 設定可能な値:
  #   - "PUBLIC_ONLY": パブリックインターネットからアクセス可能
  #   - "PRIVATE_ONLY": VPC内からのみアクセス可能（セキュリティ推奨）
  # 省略時: "PUBLIC_ONLY"
  # 注意: 本番環境では "PRIVATE_ONLY" を推奨
  webserver_access_mode = "PRIVATE_ONLY"

  # endpoint_management (Optional)
  # 設定内容: VPCエンドポイントの管理方法を指定します。
  # 設定可能な値:
  #   - "SERVICE": AWSがVPCエンドポイントを管理
  #   - "CUSTOMER": ユーザーがVPCエンドポイントを管理
  # 省略時: "SERVICE"
  endpoint_management = "SERVICE"

  #-------------------------------------------------------------
  # メンテナンスウィンドウ設定
  #-------------------------------------------------------------

  # weekly_maintenance_window_start (Optional)
  # 設定内容: 毎週のメンテナンスウィンドウ開始時刻をUTC形式で指定します。
  # 設定可能な値: "DAY:HH:MM" 形式（例: "MON:00:00", "SUN:03:00"）
  # 省略時: AWSが自動的に設定
  # 注意: メンテナンス中は環境が一時的に利用不可になる場合があります
  weekly_maintenance_window_start = "MON:01:00"

  # worker_replacement_strategy (Optional)
  # 設定内容: ワーカーノードの交換戦略を指定します。
  # 設定可能な値:
  #   - "FORCED": 強制的に交換
  #   - "ROLLING": ローリング方式で交換（中断を最小化）
  # 省略時: "ROLLING"
  worker_replacement_strategy = "ROLLING"

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # logging_configuration (Optional)
  # 設定内容: Apache AirflowコンポーネントのCloudWatch Logsへのロギング設定ブロックです。
  # 関連機能: MWAA CloudWatch Logsロギング
  #   各Airflowコンポーネントのログレベルとロギング有効化を個別に設定できます。
  #   - https://docs.aws.amazon.com/mwaa/latest/userguide/monitoring-airflow.html
  logging_configuration {

    # dag_processing_logs (Optional)
    # 設定内容: DAG処理ログの設定ブロックです。
    dag_processing_logs {

      # enabled (Optional)
      # 設定内容: DAG処理ログのCloudWatch Logsへの送信を有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      enabled = true

      # log_level (Optional)
      # 設定内容: DAG処理ログのログレベルを指定します。
      # 設定可能な値: "DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"
      # 省略時: "WARNING"
      log_level = "WARNING"
    }

    # scheduler_logs (Optional)
    # 設定内容: スケジューラーログの設定ブロックです。
    scheduler_logs {

      # enabled (Optional)
      # 設定内容: スケジューラーログのCloudWatch Logsへの送信を有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      enabled = true

      # log_level (Optional)
      # 設定内容: スケジューラーログのログレベルを指定します。
      # 設定可能な値: "DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"
      # 省略時: "WARNING"
      log_level = "WARNING"
    }

    # task_logs (Optional)
    # 設定内容: タスク実行ログの設定ブロックです。
    task_logs {

      # enabled (Optional)
      # 設定内容: タスクログのCloudWatch Logsへの送信を有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      enabled = true

      # log_level (Optional)
      # 設定内容: タスクログのログレベルを指定します。
      # 設定可能な値: "DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"
      # 省略時: "INFO"
      log_level = "INFO"
    }

    # webserver_logs (Optional)
    # 設定内容: WebサーバーログのCloudWatch Logsへの設定ブロックです。
    webserver_logs {

      # enabled (Optional)
      # 設定内容: WebサーバーログのCloudWatch Logsへの送信を有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      enabled = true

      # log_level (Optional)
      # 設定内容: Webサーバーログのログレベルを指定します。
      # 設定可能な値: "DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"
      # 省略時: "WARNING"
      log_level = "WARNING"
    }

    # worker_logs (Optional)
    # 設定内容: ワーカーログのCloudWatch Logsへの設定ブロックです。
    worker_logs {

      # enabled (Optional)
      # 設定内容: ワーカーログのCloudWatch Logsへの送信を有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      enabled = true

      # log_level (Optional)
      # 設定内容: ワーカーログのログレベルを指定します。
      # 設定可能な値: "DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"
      # 省略時: "WARNING"
      log_level = "WARNING"
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: Terraform操作のタイムアウト時間の設定ブロックです。
  # 注意: MWAA環境の作成・更新・削除には長時間かかる場合があります
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration文字列
    # 省略時: プロバイダーデフォルト
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration文字列
    # 省略時: プロバイダーデフォルト
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration文字列
    # 省略時: プロバイダーデフォルト
    delete = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 参考: プロバイダーレベルの default_tags と一致するキーはプロバイダー定義を上書きします
  tags = {
    Name        = "example-mwaa-environment"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: MWAA環境のARN
# - created_at: 環境の作成日時
# - status: 環境の現在のステータス（例: "AVAILABLE", "CREATING", "UPDATING"）
# - service_role_arn: AWSが管理するサービスロールのARN
# - webserver_url: AirflowのWebサーバーへのアクセスURL
# - webserver_vpc_endpoint_service: WebサーバーのVPCエンドポイントサービス名
# - database_vpc_endpoint_service: データベースのVPCエンドポイントサービス名
# - last_updated: 環境の最終更新情報（created_at, error, status を含むリスト）
# - logging_configuration.*.cloud_watch_log_group_arn: 各コンポーネントのCloudWatch Logsグループ ARN
# - tags_all: プロバイダーのdefault_tagsを含む全タグマップ
#---------------------------------------------------------------
