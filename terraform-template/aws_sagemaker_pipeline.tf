#---------------------------------------------------------------
# AWS SageMaker Pipeline
#---------------------------------------------------------------
#
# Amazon SageMaker Pipelinesのパイプラインをプロビジョニングするリソースです。
# SageMaker Pipelinesは、機械学習（ML）ワークフローを自動化するための
# サーバーレスワークフローオーケストレーションサービスです。
# データ処理・モデルトレーニング・評価・デプロイまでのMLワークフローを
# 一連のステップ（有向非巡回グラフ: DAG）として定義・実行できます。
#
# AWS公式ドキュメント:
#   - SageMaker Pipelines概要: https://docs.aws.amazon.com/sagemaker/latest/dg/pipelines.html
#   - Pipelineパイプライン定義JSONスキーマ: https://docs.aws.amazon.com/sagemaker/latest/dg/pipeline-def-json.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_pipeline
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_pipeline" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # pipeline_name (Required)
  # 設定内容: パイプラインの一意な名前を指定します。
  # 設定可能な値: 1-256文字の英数字、ハイフン。AWSアカウント・リージョン内で一意である必要があります。
  pipeline_name = "example-ml-pipeline"

  # pipeline_display_name (Required)
  # 設定内容: SageMaker Studio等のコンソールに表示されるパイプラインの表示名を指定します。
  # 設定可能な値: 1-256文字の文字列
  pipeline_display_name = "Example ML Pipeline"

  # pipeline_description (Optional)
  # 設定内容: パイプラインの説明文を指定します。
  # 設定可能な値: 最大3072文字の文字列
  # 省略時: 説明なし
  pipeline_description = "Example machine learning pipeline for data processing and model training."

  #-------------------------------------------------------------
  # 実行ロール設定
  #-------------------------------------------------------------

  # role_arn (Optional)
  # 設定内容: パイプラインの実行に使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: パイプラインの実行時にロールが必要になる場合がある
  # 注意: ロールにはパイプラインが使用するSageMakerリソースや
  #       S3バケット等へのアクセス権限が必要です。
  role_arn = "arn:aws:iam::123456789012:role/sagemaker-pipeline-execution-role"

  #-------------------------------------------------------------
  # パイプライン定義設定
  #-------------------------------------------------------------

  # pipeline_definition (Optional)
  # 設定内容: パイプラインの定義をJSON文字列で直接指定します。
  # 設定可能な値: SageMaker Pipeline Definition JSONスキーマに準拠したJSON文字列
  #   - jsonencode()関数を使用してHCLからJSON変換が可能
  # 省略時: pipeline_definition_s3_locationブロックで指定する必要があります。
  # 注意: pipeline_definitionとpipeline_definition_s3_locationはどちらか一方のみ指定可能
  pipeline_definition = jsonencode({
    Version = "2020-12-01"
    Steps = [{
      Name = "ProcessingStep"
      Type = "Processing"
      Arguments = {
        ProcessingInputs  = []
        ProcessingOutputConfig = {}
      }
    }]
  })

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 並列実行設定
  #-------------------------------------------------------------

  # parallelism_configuration (Optional)
  # 設定内容: パイプライン実行時の並列実行制御の設定ブロックです。
  # 省略時: パイプラインのすべての実行でデフォルト動作が適用されます。
  # 関連機能: SageMaker Pipelines 並列実行制御
  #   パイプライン内で同時に実行できるステップ数の上限を設定します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/pipelines.html
  parallelism_configuration {

    # max_parallel_execution_steps (Required)
    # 設定内容: 同時に実行できるステップの最大数を指定します。
    # 設定可能な値: 1以上の整数
    # 注意: この値を大きくするとステップが並行実行されますが、
    #       AWSのサービスクォータに注意が必要です。
    max_parallel_execution_steps = 1
  }

  #-------------------------------------------------------------
  # S3パイプライン定義設定
  #-------------------------------------------------------------

  # pipeline_definition_s3_location (Optional)
  # 設定内容: Amazon S3に保存されたパイプライン定義ファイルの場所の設定ブロックです。
  # 省略時: pipeline_definitionで直接定義する必要があります。
  # 注意: pipeline_definitionとpipeline_definition_s3_locationはどちらか一方のみ指定可能
  # pipeline_definition_s3_location {

    # bucket (Required)
    # 設定内容: パイプライン定義ファイルが格納されているS3バケット名を指定します。
    # 設定可能な値: 有効なS3バケット名
    # bucket = "my-pipeline-definitions-bucket"

    # object_key (Required)
    # 設定内容: S3バケット内のパイプライン定義ファイルのオブジェクトキーを指定します。
    # 設定可能な値: 有効なS3オブジェクトキー（パス）
    # object_key = "pipelines/example-pipeline-definition.json"

    # version_id (Optional)
    # 設定内容: 使用するパイプライン定義ファイルのS3バージョンIDを指定します。
    # 設定可能な値: 有効なS3バージョンID
    # 省略時: 最新バージョンのオブジェクトが使用されます。
    # version_id = "abc123VersionId"

  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-ml-pipeline"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: パイプラインに割り当てられたAmazon Resource Name (ARN)
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
