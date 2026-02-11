#---------------------------------------------------------------
# Amazon SageMaker AI MLflow Tracking Server
#---------------------------------------------------------------
#
# SageMaker AI MLflow Tracking Serverをプロビジョニングするリソースです。
# MLflow Tracking Serverは、機械学習の実験管理を行うためのマネージドサービスで、
# モデルのパラメータ、メトリクス、アーティファクトを追跡・管理できます。
#
# AWS公式ドキュメント:
#   - SageMaker MLflow概要: https://docs.aws.amazon.com/sagemaker/latest/dg/mlflow.html
#   - MLflow Tracking Server IAM権限: https://docs.aws.amazon.com/sagemaker/latest/dg/mlflow-create-tracking-server-iam.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_mlflow_tracking_server
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
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
  # 設定内容: トラッキングサーバーの一意な名前を指定します。
  # 設定可能な値: 一意な文字列。この名前はトラッキングサーバーのARNの一部になります。
  # 注意: リソース作成後の変更はできません（Forces new resource）
  tracking_server_name = "example-mlflow-server"

  # role_arn (Required)
  # 設定内容: MLflow Tracking ServerがAmazon S3のアーティファクトストアにアクセスするための
  #           IAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: ロールにはAmazonS3FullAccessの権限が必要です。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/mlflow-create-tracking-server-iam.html
  role_arn = aws_iam_role.example.arn

  # artifact_store_uri (Required)
  # 設定内容: MLflow Tracking Serverのアーティファクトストアとして使用する
  #           汎用S3バケットのURIを指定します。
  # 設定可能な値: s3://で始まるS3 URI（例: s3://my-bucket/path）
  # 注意: アーティファクト（モデルファイル、データセットなど）の保存先となります
  artifact_store_uri = "s3://${aws_s3_bucket.example.bucket}/mlflow"

  #-------------------------------------------------------------
  # サーバー設定
  #-------------------------------------------------------------

  # tracking_server_size (Optional)
  # 設定内容: 作成するトラッキングサーバーのサイズを指定します。
  # 設定可能な値:
  #   - "Small" (デフォルト): 小規模な実験管理向け
  #   - "Medium": 中規模な実験管理向け
  #   - "Large": 大規模な実験管理向け（大量のデータログ、多数のユーザー、高頻度の利用）
  # 省略時: "Small"
  # 注意: データログの量、ユーザー数、利用頻度に応じてサイズを選択してください
  tracking_server_size = "Small"

  # mlflow_version (Optional)
  # 設定内容: トラッキングサーバーが使用するMLflowのバージョンを指定します。
  # 設定可能な値: 利用可能なMLflowバージョン文字列
  # 省略時: AWSが提供するデフォルトバージョンが使用されます
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/mlflow.html#mlflow-create-tracking-server-how-it-works
  # mlflow_version = "2.13.2"

  # automatic_model_registration (Optional)
  # 設定内容: MLflowで記録されたモデルをSageMaker Model Registryに自動登録するかどうかを指定します。
  # 設定可能な値: true / false
  # 省略時: false
  # 注意: trueに設定すると、MLflowで記録されたモデルがSageMaker Model Registryに
  #       自動的に登録され、デプロイや管理が容易になります
  automatic_model_registration = false

  # weekly_maintenance_window_start (Optional)
  # 設定内容: 週次メンテナンス更新がスケジュールされる曜日と時刻をUTC 24時間制で指定します。
  # 設定可能な値: "曜日:時:分" 形式の文字列（例: "TUE:03:30", "SUN:00:00"）
  # 省略時: AWSがデフォルトのメンテナンスウィンドウを設定します
  # weekly_maintenance_window_start = "SUN:03:00"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-mlflow-server"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: MLflow Tracking ServerのAmazon Resource Name (ARN)
#
# - id: MLflow Tracking Serverの名前
#
# - tracking_server_url: MLflowユーザーインターフェースに接続するためのURL
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
