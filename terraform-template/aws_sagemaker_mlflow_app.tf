#---------------------------------------------------------------
# Amazon SageMaker AI MLflow App
#---------------------------------------------------------------
#
# SageMaker AIのMLflow Appリソースを管理するリソースです。
# MLflow Appはアカウントレベルで機械学習実験の追跡とモデル管理を行うための
# マネージドMLflowサービスを提供します。Amazon S3をアーティファクトストアとして使用し、
# SageMaker Model Registryへの自動モデル登録もサポートします。
#
# AWS公式ドキュメント:
#   - MLflow概要: https://docs.aws.amazon.com/sagemaker/latest/dg/mlflow.html
#   - MLflow Tracking Serverの作成: https://docs.aws.amazon.com/sagemaker/latest/dg/mlflow-create-tracking-server.html
#   - IAMアクセス許可の設定: https://docs.aws.amazon.com/sagemaker/latest/dg/mlflow-create-tracking-server-iam.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_mlflow_app
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_mlflow_app" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: MLflow Appの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-mlflow-app"

  # artifact_store_uri (Required)
  # 設定内容: MLflow Appのアーティファクトストアとして使用する汎用S3バケットのURIを指定します。
  # 設定可能な値: 有効なS3 URI（例: s3://my-bucket/path）
  # 注意: クロスリージョンのアーティファクトストレージはサポートされていません。
  artifact_store_uri = "s3://my-bucket/mlflow-artifacts"

  # role_arn (Required)
  # 設定内容: MLflow AppがAmazon S3のアーティファクトストアにアクセスするために使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: ロールにはS3バケットへのアクセス権限が必要です。
  #   自動モデル登録を有効にする場合は、SageMaker Model Registryへのアクセス権限も必要です。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/mlflow-create-tracking-server-iam.html
  role_arn = "arn:aws:iam::123456789012:role/sagemaker-mlflow-role"

  #-------------------------------------------------------------
  # アカウントデフォルト設定
  #-------------------------------------------------------------

  # account_default_status (Optional)
  # 設定内容: このMLflow Appがアカウント全体のデフォルトかどうかを指定します。
  # 設定可能な値:
  #   - "ENABLED": アカウント全体のデフォルトとして有効化
  #   - "DISABLED": アカウント全体のデフォルトを無効化
  account_default_status = null

  # default_domain_id_list (Optional)
  # 設定内容: このMLflow Appをデフォルトとして使用するSageMakerドメインIDのリストを指定します。
  # 設定可能な値: SageMakerドメインIDの文字列セット（例: ["d-example123456"]）
  # 関連リソース: aws_sagemaker_domain
  default_domain_id_list = null

  #-------------------------------------------------------------
  # モデル登録設定
  #-------------------------------------------------------------

  # model_registration_mode (Optional)
  # 設定内容: 新しいMLflowモデルをSageMaker Model Registryに自動登録するかを指定します。
  # 設定可能な値:
  #   - "AutoModelRegistrationEnabled": 自動モデル登録を有効化
  #   - "AutoModelRegistrationDisabled": 自動モデル登録を無効化
  # 省略時: "AutoModelRegistrationDisabled"
  # 注意: 有効にするには、role_arnに指定したIAMロールにSageMaker Model Registryへのアクセス権限が必要です。
  model_registration_mode = "AutoModelRegistrationDisabled"

  #-------------------------------------------------------------
  # メンテナンスウィンドウ設定
  #-------------------------------------------------------------

  # weekly_maintenance_window_start (Optional)
  # 設定内容: 週次メンテナンス更新がスケジュールされるUTC 24時間標準時の曜日と時刻を指定します。
  # 設定可能な値: "DDD:HH:MM" 形式の文字列（例: "SUN:03:00"）
  #   - DDD: MON、TUE、WED、THU、FRI、SAT、SUN
  #   - HH: 00〜23
  #   - MM: 00〜59
  # 省略時: AWSがデフォルトのメンテナンスウィンドウを設定します（computed）
  weekly_maintenance_window_start = "SUN:03:00"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1、us-east-1）
  # 省略時: プロバイダー設定で指定されたリージョンを使用（computed）
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-mlflow-app"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # timeouts ブロック (Optional)
  #-------------------------------------------------------------
  # リソースの作成・更新・削除操作のタイムアウト時間を設定します。

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: MLflow Appの名前
#
# - arn: AWSによって割り当てられたMLflow AppのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
