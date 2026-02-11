#---------------------------------------------------------------
# AWS Glue Workflow
#---------------------------------------------------------------
#
# AWS Glueワークフローリソースをプロビジョニングします。
# ワークフローは、複数の依存関係を持つGlueジョブとクローラーを
# 組み合わせて、複雑なETLタスクを完了するためのコレクションです。
# ワークフロー内のすべてのジョブとクローラーの実行と監視を管理します。
#
# AWS公式ドキュメント:
#   - Overview of workflows in AWS Glue: https://docs.aws.amazon.com/glue/latest/dg/workflows_overview.html
#   - Workflows API: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-workflow.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_workflow
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_workflow" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (オプション扱いだが推奨) ワークフローに割り当てる名前
  # - ワークフロー名はアカウント/リージョン内で一意である必要があります
  # - このワークフローを識別するために使用されます
  # - aws_glue_triggerリソースのworkflow_name属性で参照されます
  name = "example-workflow"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # ワークフローの説明
  # - ワークフローの目的や処理内容を記述します
  # - 管理コンソールやAPIで表示されます
  description = "Example workflow for ETL processing"

  # ワークフローのデフォルト実行プロパティ
  # - このワークフローに関連付けられたすべてのジョブに渡されるプロパティ
  # - キー・バリューペアのマップとして定義します
  # - ワークフロー実行全体で共有・管理される状態として使用できます
  # - ジョブはAWS Glue APIを使用してこれらのプロパティを取得・変更できます
  default_run_properties = {
    "environment" = "production"
    "data_source" = "s3://my-bucket/data/"
  }

  # 同時実行可能なワークフロー実行の最大数
  # - このパラメータを指定しない場合、同時ワークフロー実行数に制限はありません
  # - コンポーネントジョブの最大同時実行数を超えないようにします
  # - イベント駆動型の場合、予想されるイベント量に基づいて調整することが推奨されます
  # - 同時実行制限を超えた場合、ワークフロー実行は開始されず、AWS Glueは再試行しません
  max_concurrent_runs = 1

  # リージョン設定
  # - このリソースが管理されるAWSリージョン
  # - 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # - リソースを特定のリージョンで管理したい場合に明示的に指定します
  # region = "us-east-1"

  # リソースタグ
  # - ワークフローリソースに付与するキー・バリューペアのタグ
  # - プロバイダーのdefault_tags設定ブロックと併用できます
  # - 同じキーのタグがある場合、リソースレベルのタグが優先されます
  # - コスト管理、リソース整理、アクセス制御などに使用されます
  tags = {
    Environment = "Production"
    Project     = "DataPipeline"
    ManagedBy   = "Terraform"
  }

  # tags_all属性は明示的に設定する必要はありません
  # プロバイダーのdefault_tagsとリソースのtagsが自動的にマージされます
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed only）:
#
# - arn: ワークフローのAmazon Resource Name (ARN)
#   例: aws_glue_workflow.example.arn
#
# - id: ワークフロー名
#   例: aws_glue_workflow.example.id
#
# - tags_all: リソースに割り当てられたタグのマップ（プロバイダーのdefault_tagsから継承されたものを含む）
#   例: aws_glue_workflow.example.tags_all
#
#---------------------------------------------------------------
# Usage Notes
#---------------------------------------------------------------
# 1. ワークフローグラフ（DAG）はaws_glue_triggerリソースを使用して構築できます
#
# 2. ワークフローの開始方法（start trigger）は3種類あります：
#    - スケジュール: cronベースのスケジュール定義
#    - オンデマンド: コンソール、API、CLIから手動で開始
#    - EventBridgeイベント: イベント駆動型アーキテクチャで使用
#
# 3. ワークフロー内のジョブ、クローラー、トリガーの合計数は100以下に制限することが推奨されます
#    100を超えると、ワークフロー実行の再開や停止時にエラーが発生する可能性があります
#
# 4. ワークフロー内のトリガーは、ジョブとクローラーの両方を開始でき、
#    ジョブやクローラーが完了したときに起動できます
#    これにより、相互依存するジョブとクローラーの大規模なチェーンを作成できます
#
#---------------------------------------------------------------
# Example: Creating a workflow with triggers
#---------------------------------------------------------------
# resource "aws_glue_workflow" "example" {
#   name = "example"
# }
#
# resource "aws_glue_trigger" "start_trigger" {
#   name          = "trigger-start"
#   type          = "ON_DEMAND"
#   workflow_name = aws_glue_workflow.example.name
#
#   actions {
#     job_name = "example-job"
#   }
# }
#
# resource "aws_glue_trigger" "conditional_trigger" {
#   name          = "trigger-conditional"
#   type          = "CONDITIONAL"
#   workflow_name = aws_glue_workflow.example.name
#
#   predicate {
#     conditions {
#       job_name = "example-job"
#       state    = "SUCCEEDED"
#     }
#   }
#
#   actions {
#     job_name = "another-example-job"
#   }
# }
#---------------------------------------------------------------
