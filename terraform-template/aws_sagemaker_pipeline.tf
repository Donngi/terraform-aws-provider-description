################################################################################
# AWS SageMaker Pipeline
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sagemaker_pipeline
# Version: 6.28.0
################################################################################

# SageMaker Pipelineは、機械学習ワークフローを自動化するためのCI/CD対応サービスです。
# パイプラインはDirected Acyclic Graph (DAG)として定義され、データの前処理、トレーニング、
# モデル評価、デプロイといった一連のステップを自動化できます。

resource "aws_sagemaker_pipeline" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # パイプライン名（アカウント・リージョンペアで一意である必要があります）
  # 命名規則: 英数字、ハイフン、アンダースコアのみ使用可能
  # 最大長: 256文字
  # 例: "my-ml-pipeline", "fraud-detection-pipeline"
  pipeline_name = "example-ml-pipeline"

  # パイプラインの表示名（UI上で表示される名前）
  # より人間が読みやすい名前を設定します
  # 最大長: 256文字
  pipeline_display_name = "Example ML Pipeline"

  # ============================================================================
  # Optional Arguments - Pipeline Definition
  # ============================================================================

  # パイプライン定義をJSON形式で直接指定
  # JSON pipeline definition schema: Version 2020-12-01
  # 参考: https://aws-sagemaker-mlops.github.io/sagemaker-model-building-pipeline-definition-JSON-schema/
  #
  # pipeline_definitionとpipeline_definition_s3_locationのいずれかを指定する必要があります
  # （両方指定した場合、pipeline_definitionが優先されます）
  #
  # 主要なステップタイプ:
  # - Processing: データの前処理や特徴量エンジニアリング
  # - Training: モデルのトレーニング
  # - Condition: 条件分岐（モデル評価結果に基づく判定など）
  # - RegisterModel: モデルレジストリへの登録
  # - CreateModel: モデルエンドポイント用のモデル作成
  # - Transform: バッチ変換ジョブの実行
  # - Tuning: ハイパーパラメータチューニング
  # - Lambda: AWS Lambda関数の実行
  # - Callback: コールバックステップ（手動承認など）
  # - Clarify: モデルバイアス検出や説明可能性の評価
  # - QualityCheck: データ品質やモデル品質のチェック
  # - EMR: Amazon EMRステップの実行
  # - Fail: パイプラインを明示的に失敗させる
  pipeline_definition = jsonencode({
    Version = "2020-12-01"
    # パイプラインパラメータ: 実行時に動的に値を指定可能
    Parameters = [
      {
        Name        = "ProcessingInstanceType"
        Type        = "String"
        DefaultValue = "ml.m5.xlarge"
      },
      {
        Name        = "ProcessingInstanceCount"
        Type        = "Integer"
        DefaultValue = 1
      },
      {
        Name        = "TrainingInstanceType"
        Type        = "String"
        DefaultValue = "ml.m5.xlarge"
      },
      {
        Name        = "ModelApprovalStatus"
        Type        = "String"
        DefaultValue = "PendingManualApproval"
      },
      {
        Name        = "InputDataUrl"
        Type        = "String"
        DefaultValue = "s3://example-bucket/input-data/"
      }
    ]
    # パイプラインステップの定義
    Steps = [
      {
        Name = "PreprocessData"
        Type = "Processing"
        Arguments = {
          ProcessingResources = {
            ClusterConfig = {
              InstanceType   = { Get = "Parameters.ProcessingInstanceType" }
              InstanceCount  = { Get = "Parameters.ProcessingInstanceCount" }
              VolumeSizeInGB = 30
            }
          }
          AppSpecification = {
            ImageUri = "123456789012.dkr.ecr.us-west-2.amazonaws.com/preprocessing:latest"
          }
          ProcessingInputs = [
            {
              InputName = "input-data"
              S3Input = {
                S3Uri        = { Get = "Parameters.InputDataUrl" }
                LocalPath    = "/opt/ml/processing/input"
                S3DataType   = "S3Prefix"
                S3InputMode  = "File"
              }
            }
          ]
          ProcessingOutputConfig = {
            Outputs = [
              {
                OutputName = "train"
                S3Output = {
                  S3Uri           = "s3://example-bucket/preprocessing/train"
                  LocalPath       = "/opt/ml/processing/train"
                  S3UploadMode    = "EndOfJob"
                }
              },
              {
                OutputName = "validation"
                S3Output = {
                  S3Uri           = "s3://example-bucket/preprocessing/validation"
                  LocalPath       = "/opt/ml/processing/validation"
                  S3UploadMode    = "EndOfJob"
                }
              },
              {
                OutputName = "test"
                S3Output = {
                  S3Uri           = "s3://example-bucket/preprocessing/test"
                  LocalPath       = "/opt/ml/processing/test"
                  S3UploadMode    = "EndOfJob"
                }
              }
            ]
          }
          RoleArn = "arn:aws:iam::123456789012:role/SageMakerExecutionRole"
        }
      },
      {
        Name = "TrainModel"
        Type = "Training"
        # データ依存関係: PreprocessDataステップの完了後に実行
        Arguments = {
          AlgorithmSpecification = {
            TrainingImage     = "123456789012.dkr.ecr.us-west-2.amazonaws.com/xgboost:latest"
            TrainingInputMode = "File"
          }
          InputDataConfig = [
            {
              ChannelName = "train"
              DataSource = {
                S3DataSource = {
                  S3DataType = "S3Prefix"
                  # PreprocessDataステップの出力を参照
                  S3Uri           = { Get = "Steps.PreprocessData.ProcessingOutputConfig.Outputs['train'].S3Output.S3Uri" }
                  S3DataDistributionType = "FullyReplicated"
                }
              }
            },
            {
              ChannelName = "validation"
              DataSource = {
                S3DataSource = {
                  S3DataType = "S3Prefix"
                  S3Uri           = { Get = "Steps.PreprocessData.ProcessingOutputConfig.Outputs['validation'].S3Output.S3Uri" }
                  S3DataDistributionType = "FullyReplicated"
                }
              }
            }
          ]
          OutputDataConfig = {
            S3OutputPath = "s3://example-bucket/training-output"
          }
          ResourceConfig = {
            InstanceType   = { Get = "Parameters.TrainingInstanceType" }
            InstanceCount  = 1
            VolumeSizeInGB = 30
          }
          StoppingCondition = {
            MaxRuntimeInSeconds = 3600
          }
          HyperParameters = {
            objective        = "binary:logistic"
            max_depth        = "5"
            eta              = "0.2"
            num_round        = "100"
          }
          RoleArn = "arn:aws:iam::123456789012:role/SageMakerExecutionRole"
        }
      },
      {
        Name = "EvaluateModel"
        Type = "Processing"
        Arguments = {
          ProcessingResources = {
            ClusterConfig = {
              InstanceType   = "ml.m5.xlarge"
              InstanceCount  = 1
              VolumeSizeInGB = 30
            }
          }
          AppSpecification = {
            ImageUri = "123456789012.dkr.ecr.us-west-2.amazonaws.com/evaluation:latest"
          }
          ProcessingInputs = [
            {
              InputName = "model"
              S3Input = {
                # TrainModelステップの出力モデルを参照
                S3Uri        = { Get = "Steps.TrainModel.ModelArtifacts.S3ModelArtifacts" }
                LocalPath    = "/opt/ml/processing/model"
                S3DataType   = "S3Prefix"
                S3InputMode  = "File"
              }
            },
            {
              InputName = "test"
              S3Input = {
                S3Uri        = { Get = "Steps.PreprocessData.ProcessingOutputConfig.Outputs['test'].S3Output.S3Uri" }
                LocalPath    = "/opt/ml/processing/test"
                S3DataType   = "S3Prefix"
                S3InputMode  = "File"
              }
            }
          ]
          ProcessingOutputConfig = {
            Outputs = [
              {
                OutputName = "evaluation"
                S3Output = {
                  S3Uri           = "s3://example-bucket/evaluation"
                  LocalPath       = "/opt/ml/processing/evaluation"
                  S3UploadMode    = "EndOfJob"
                }
              }
            ]
          }
          # PropertyFileを使用して評価結果を後続ステップで参照可能にする
          PropertyFiles = [
            {
              PropertyFileName = "EvaluationReport"
              OutputName       = "evaluation"
              FilePath         = "evaluation.json"
            }
          ]
          RoleArn = "arn:aws:iam::123456789012:role/SageMakerExecutionRole"
        }
      },
      {
        Name = "CheckAccuracy"
        Type = "Condition"
        Arguments = {
          Conditions = [
            {
              Type = "GreaterThanOrEqualTo"
              LeftValue = {
                # PropertyFileから評価メトリクスを取得
                Std:JsonGet = {
                  PropertyFile = { Get = "Steps.EvaluateModel.PropertyFiles.EvaluationReport" }
                  Path         = "$.metrics.accuracy.value"
                }
              }
              RightValue = 0.8
            }
          ]
          # 条件が真の場合に実行するステップ
          IfSteps = [
            {
              Name = "RegisterModel"
              Type = "RegisterModel"
              Arguments = {
                ModelPackageGroupName = "example-model-group"
                ModelMetrics = {
                  ModelQuality = {
                    Statistics = {
                      ContentType = "application/json"
                      S3Uri       = { Get = "Steps.EvaluateModel.ProcessingOutputConfig.Outputs['evaluation'].S3Output.S3Uri" }
                    }
                  }
                }
                InferenceSpecification = {
                  Containers = [
                    {
                      Image        = "123456789012.dkr.ecr.us-west-2.amazonaws.com/inference:latest"
                      ModelDataUrl = { Get = "Steps.TrainModel.ModelArtifacts.S3ModelArtifacts" }
                    }
                  ]
                  SupportedContentTypes = ["text/csv"]
                  SupportedResponseMIMETypes = ["text/csv"]
                }
                ModelApprovalStatus = { Get = "Parameters.ModelApprovalStatus" }
              }
            }
          ]
          # 条件が偽の場合に実行するステップ
          ElseSteps = [
            {
              Name = "ModelRejected"
              Type = "Fail"
              Arguments = {
                ErrorMessage = "Model accuracy is below threshold (0.8)"
              }
            }
          ]
        }
      }
    ]
  })

  # パイプライン定義をS3から読み込む場合の設定
  # pipeline_definitionの代わりにこちらを使用可能
  # S3に保存されたJSON定義ファイルを参照することで、バージョン管理やCI/CDとの統合が容易になります
  # pipeline_definition_s3_location {
  #   # 定義ファイルが保存されているS3バケット名
  #   bucket = "example-bucket"
  #
  #   # 定義ファイルのS3オブジェクトキー
  #   object_key = "pipelines/example-pipeline-definition.json"
  #
  #   # バージョンID（省略可能）
  #   # S3バケットのバージョニングが有効な場合、特定バージョンを参照可能
  #   # 指定しない場合は最新バージョンが使用されます
  #   version_id = "abc123"
  # }

  # ============================================================================
  # Optional Arguments - Execution Configuration
  # ============================================================================

  # パイプラインの説明
  # 目的、使用するデータ、期待される結果などを記載
  pipeline_description = "Example machine learning pipeline for model training and evaluation with conditional model registration"

  # IAMロールARN
  # パイプラインの実行に使用されるIAMロール
  # 必要な権限:
  # - SageMakerへのアクセス権限
  # - S3バケットへの読み取り/書き込み権限
  # - ECRからのイメージプル権限
  # - CloudWatch Logsへの書き込み権限
  # role_arnを指定しない場合、各ステップで個別にRoleArnを指定する必要があります
  role_arn = "arn:aws:iam::123456789012:role/SageMakerPipelineExecutionRole"

  # 並列実行制御設定
  # デフォルトでは、依存関係のないステップは全て並列実行されます
  # リソース制限やコスト管理のために並列実行数を制限できます
  parallelism_configuration {
    # 同時に実行可能なステップの最大数
    # 1-256の範囲で指定可能
    # 例: 3を指定すると、最大3つのステップが同時実行されます
    #
    # 使用例:
    # - リソース制限: インスタンスクォータに応じて制限
    # - コスト管理: 同時実行数を抑えてコストを管理
    # - 依存リソース保護: 外部APIやデータベースへの負荷を制限
    max_parallel_execution_steps = 10
  }

  # ============================================================================
  # Optional Arguments - Management
  # ============================================================================

  # リージョン指定（省略可能）
  # 通常はprovider設定のリージョンが使用されます
  # マルチリージョン構成で明示的にリージョンを指定する場合に使用
  # region = "us-west-2"

  # タグ
  # リソース管理、コスト配分、アクセス制御に使用
  tags = {
    Environment = "Development"
    Project     = "MLOps"
    Team        = "DataScience"
    CostCenter  = "ML-Infrastructure"
    Pipeline    = "ExamplePipeline"
    ManagedBy   = "Terraform"
  }

  # ============================================================================
  # Lifecycle Management
  # ============================================================================

  # パイプライン定義の変更時の動作制御
  lifecycle {
    # パイプライン定義の変更を検知して自動更新
    # create_before_destroy = true

    # タグの変更を無視（他のツールでタグが管理されている場合）
    # ignore_changes = [tags]
  }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################

# 以下の属性は作成後に参照可能です:

# aws_sagemaker_pipeline.example.id
# パイプライン名が返されます

# aws_sagemaker_pipeline.example.arn
# パイプラインのARN
# 形式: arn:aws:sagemaker:region:account-id:pipeline/pipeline-name

# aws_sagemaker_pipeline.example.tags_all
# providerのdefault_tagsとリソースのtagsがマージされた完全なタグマップ

################################################################################
# Output Examples
################################################################################

output "pipeline_arn" {
  description = "ARN of the SageMaker Pipeline"
  value       = aws_sagemaker_pipeline.example.arn
}

output "pipeline_id" {
  description = "ID (name) of the SageMaker Pipeline"
  value       = aws_sagemaker_pipeline.example.id
}

################################################################################
# Additional Notes
################################################################################

# 1. パイプライン定義の方法
#    - Inline JSON (pipeline_definition): 小規模なパイプラインや開発環境に適しています
#    - S3参照 (pipeline_definition_s3_location): 大規模パイプラインやCI/CD統合に適しています
#
# 2. パイプラインパラメータ
#    - 実行時に動的に値を変更可能
#    - タイプ: String, Integer, Float, Boolean
#    - DefaultValueの指定が推奨されます
#
# 3. ステップ間のデータ依存関係
#    - Get構文を使用してステップ間でデータを受け渡し
#    - 例: { Get = "Steps.TrainModel.ModelArtifacts.S3ModelArtifacts" }
#    - 依存関係は自動的に解決され、実行順序が決定されます
#
# 4. PropertyFiles
#    - ステップの出力からJSON形式でメトリクスや結果を抽出
#    - Conditionステップで評価条件として使用可能
#    - JsonPathクエリで特定の値を取得
#
# 5. 条件分岐
#    - Conditionステップでモデル品質に基づく判定が可能
#    - IfSteps: 条件が真の場合に実行
#    - ElseSteps: 条件が偽の場合に実行
#
# 6. 並列実行制御
#    - リソースレベル: parallelism_configurationで制御
#    - 実行レベル: StartPipelineExecution APIで上書き可能
#
# 7. キャッシング
#    - ステップ定義にCachingConfigurationを追加することで結果をキャッシュ可能
#    - 同じ入力での再実行時に時間とコストを節約
#
# 8. リトライポリシー
#    - ステップ定義にRetryPoliciesを追加することで自動リトライ設定が可能
#    - ExceptionTypesとIntervalSeconds、MaxAttempts、BackoffRateを指定
#
# 9. セキュリティ考慮事項
#    - pipeline_definitionに機密情報（認証情報、APIキー）を含めないこと
#    - DescribePipeline APIで定義が参照可能になります
#    - 機密情報はAWS Secrets ManagerやParameter Storeを使用
#
# 10. モニタリングとトラブルシューティング
#     - CloudWatch Logsでパイプライン実行ログを確認
#     - SageMaker StudioでパイプラインのDAGを可視化
#     - DescribePipelineExecution APIで実行状態を確認
#
# 11. コスト最適化
#     - Spot Instancesの使用（TrainingやProcessingステップで設定可能）
#     - 適切なインスタンスタイプの選択
#     - 並列実行数の制限による同時実行コストの管理
#     - ステップキャッシングの活用
#
# 12. CI/CDとの統合
#     - pipeline_definition_s3_locationを使用してGit管理
#     - CodePipelineやGitHub Actionsからパイプライン実行をトリガー
#     - バージョニングによるロールバック対応

################################################################################
# Related Resources
################################################################################

# IAM Role for Pipeline Execution
# resource "aws_iam_role" "pipeline_execution" {
#   name = "sagemaker-pipeline-execution-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "sagemaker.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# S3 Bucket for Pipeline Artifacts
# resource "aws_s3_bucket" "pipeline_artifacts" {
#   bucket = "example-pipeline-artifacts"
# }

# EventBridge Rule for Scheduled Pipeline Execution
# resource "aws_cloudwatch_event_rule" "pipeline_schedule" {
#   name                = "daily-pipeline-execution"
#   description         = "Trigger SageMaker Pipeline daily"
#   schedule_expression = "cron(0 2 * * ? *)"
# }

# Lambda Function for Pipeline Triggering
# resource "aws_lambda_function" "pipeline_trigger" {
#   function_name = "trigger-sagemaker-pipeline"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "index.handler"
#   runtime       = "python3.11"
#   # ...
# }
