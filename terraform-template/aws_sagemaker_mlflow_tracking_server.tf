#---------------------------------------------------------------
# Amazon SageMaker MLflow Tracking Server
#---------------------------------------------------------------
#
# Amazon SageMakerのMLflow Tracking Serverをプロビジョニングするリソースです。
# MLflow Tracking Serverは、機械学習実験を追跡するためのスタンドアロンHTTPサーバーで、
# 実験の実行・パラメータ・メトリクス・アーティファクトを記録・管理します。
# Amazon S3をアーティファクトストアとして使用し、MLflowのREST APIエンドポイントを提供します。
#
# AWS公式ドキュメント:
#   - MLflow Tracking Serverの作成: https://docs.aws.amazon.com/sagemaker/latest/dg/mlflow-create-tracking-server.html
#   - IAMアクセス許可の設定: https://docs.aws.amazon.com/sagemaker/latest/dg/mlflow-create-tracking-server-iam.html
#   - CreateMlflowTrackingServer API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateMlflowTrackingServer.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_mlflow_tracking_server
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_mlflow_tracking_server" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # tracking_server_name (Required)
  # 設定内容: Tracking Serverを一意に識別する名前を指定します。この文字列はTracking ServerのARNの一部になります。
  # 設定可能な値: 1〜256文字の英数字およびハイフン（パターン: [a-zA-Z0-9](-*[a-zA-Z0-9]){0,255}）
  tracking_server_name = "example-mlflow-tracking-server"

  # artifact_store_uri (Required)
  # 設定内容: MLflow Tracking Serverのアーティファクトストアとして使用するS3バケットのURIを指定します。
  # 設定可能な値: 有効なS3 URI（例: s3://my-bucket/path）
  # 注意: クロスリージョンのアーティファクトストレージはサポートされていません。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/mlflow-create-tracking-server.html
  artifact_store_uri = "s3://my-bucket/mlflow-artifacts"

  # role_arn (Required)
  # 設定内容: MLflow Tracking ServerがAmazon S3のアーティファクトストアにアクセスするために使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN（長さ20〜2048文字）
  # 注意: ロールにはAmazonS3FullAccessポリシーが必要です。
  #   自動モデル登録を有効にする場合は、SageMaker Model Registryへのアクセス権限も必要です。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/mlflow-create-tracking-server-iam.html
  role_arn = "arn:aws:iam::123456789012:role/sagemaker-mlflow-role"

  #-------------------------------------------------------------
  # MLflowバージョン設定
  #-------------------------------------------------------------

  # mlflow_version (Optional)
  # 設定内容: Tracking Serverが使用するMLflowのバージョンを指定します。
  # 設定可能な値: バージョン番号の文字列（例: "2.13.2"）（パターン: [0-9]*.[0-9]*.[0-9]*、最大16文字）
  # 省略時: AWSが管理するデフォルトのMLflowバージョンが使用されます（computed）
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/mlflow.html#mlflow-create-tracking-server-how-it-works
  mlflow_version = null

  #-------------------------------------------------------------
  # サーバーサイズ設定
  #-------------------------------------------------------------

  # tracking_server_size (Optional)
  # 設定内容: 作成するTracking Serverのサイズを指定します。
  # 設定可能な値:
  #   - "Small" (デフォルト): 最大25ユーザー規模のチームに推奨
  #   - "Medium": 最大50ユーザー規模のチームに推奨
  #   - "Large": 最大100ユーザー規模のチームに推奨
  # 省略時: "Small" が使用されます
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateMlflowTrackingServer.html
  tracking_server_size = "Small"

  #-------------------------------------------------------------
  # モデル登録設定
  #-------------------------------------------------------------

  # automatic_model_registration (Optional)
  # 設定内容: 新しいMLflowモデルをSageMaker Model Registryに自動登録するかを指定します。
  # 設定可能な値:
  #   - true: 自動モデル登録を有効化。MLflowで登録されたモデルがSageMaker Model Registryに自動的に登録されます
  #   - false: 自動モデル登録を無効化
  # 省略時: false（自動登録は無効）
  # 注意: 有効にするには、role_arnに指定したIAMロールにSageMaker Model Registryへのアクセス権限が必要です。
  automatic_model_registration = false

  #-------------------------------------------------------------
  # メンテナンスウィンドウ設定
  #-------------------------------------------------------------

  # weekly_maintenance_window_start (Optional)
  # 設定内容: 週次メンテナンス更新がスケジュールされるUTC 24時間標準時の曜日と時刻を指定します。
  # 設定可能な値: "DDD:HH:MM" 形式の文字列（例: "TUE:03:30"）
  #   - DDD: Mon、Tue、Wed、Thu、Fri、Sat、Sun
  #   - HH: 00〜23
  #   - MM: 00〜59
  # 省略時: AWSがデフォルトのメンテナンスウィンドウを設定します（computed）
  weekly_maintenance_window_start = "TUE:03:30"

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
  # 設定可能な値: キーと値のペアのマップ（最大50個）
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-mlflow-tracking-server"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: MLflow Tracking Serverの名前
#
# - arn: AWSによって割り当てられたMLflow Tracking ServerのAmazon Resource Name (ARN)
#        形式: arn:aws[a-z-]*:sagemaker:[a-z0-9-]*:[0-9]{12}:mlflow-tracking-server/...
#
# - tracking_server_url: MLflowユーザーインターフェースに接続するためのURL
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
