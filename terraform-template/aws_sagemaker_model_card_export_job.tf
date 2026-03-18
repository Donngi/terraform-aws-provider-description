#---------------------------------------------------------------
# Amazon SageMaker Model Card Export Job
#---------------------------------------------------------------
#
# Amazon SageMaker AIのモデルカードエクスポートジョブを管理するリソースです。
# モデルカードの内容をPDFなどの形式でエクスポートし、指定したS3バケットに
# 出力します。モデルカードにはモデルの目的、性能、制約事項などの
# ドキュメントが記載されており、エクスポートすることで共有や
# コンプライアンス対応に利用できます。
#
# AWS公式ドキュメント:
#   - SageMaker Model Cards: https://docs.aws.amazon.com/sagemaker/latest/dg/model-cards.html
#   - モデルカードのエクスポート: https://docs.aws.amazon.com/sagemaker/latest/dg/model-cards-export.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_model_card_export_job
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_model_card_export_job" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # model_card_export_job_name (Required)
  # 設定内容: モデルカードエクスポートジョブの名前を指定します。
  # 設定可能な値: 一意のジョブ名文字列
  model_card_export_job_name = "my-model-card-export-job"

  # model_card_name (Required)
  # 設定内容: エクスポート対象のモデルカードの名前を指定します。
  # 設定可能な値: 既存のモデルカード名
  model_card_name = "my-model-card"

  # model_card_version (Optional)
  # 設定内容: エクスポートするモデルカードのバージョンを指定します。
  # 設定可能な値: 正の整数（モデルカードの既存バージョン番号）
  # 省略時: 最新バージョンがエクスポートされます。
  model_card_version = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 出力設定
  #-------------------------------------------------------------

  # output_config (Required)
  # 設定内容: エクスポートしたモデルカードの出力先を指定する設定ブロックです。
  output_config {

    # s3_output_path (Required)
    # 設定内容: エクスポートされたモデルカードアーティファクトの出力先となる
    #           Amazon S3パスを指定します。
    # 設定可能な値: 有効なS3 URI（例: s3://my-bucket/model-cards/）
    s3_output_path = "s3://my-bucket/model-card-exports/"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定する設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトが適用されます。
    create = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - model_card_export_job_arn: モデルカードエクスポートジョブのARN
# - export_artifacts: エクスポートされたモデルカードアーティファクト
#   - s3_export_artifacts: エクスポートされたアーティファクトのS3 URI
#---------------------------------------------------------------
