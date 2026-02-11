#---------------------------------------------------------------
# Amazon SageMaker Monitoring Schedule
#---------------------------------------------------------------
#
# Amazon SageMaker のモニタリングスケジュールを管理するリソースです。
# モデルの品質やデータ品質を継続的に監視し、ドリフトや異常を検出します。
#
# モニタリングタイプ:
#   - DataQuality: データ品質の監視（欠損値、異常値など）
#   - ModelQuality: モデル品質の監視（精度、再現率など）
#   - ModelBias: モデルバイアスの監視
#   - ModelExplainability: モデルの説明可能性の監視
#
# モニタリング対象:
#   - Real-time Endpoint: リアルタイムエンドポイントの推論データ
#   - Batch Transform Job: バッチ変換ジョブの入出力データ
#
# AWS公式ドキュメント:
#   - SageMaker Model Monitor 概要: https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html
#   - モニタリングジョブのスケジューリング: https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-scheduling.html
#   - データ品質モニタリング: https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
#   - モデル品質モニタリング: https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-model-quality.html
#   - API リファレンス: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateMonitoringSchedule.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_monitoring_schedule
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_monitoring_schedule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Computed)
  # 設定内容: モニタリングスケジュールの名前を指定します。
  # 設定可能な値: 1-63文字の英数字とハイフン。AWSアカウント・リージョン内で一意である必要があります
  # 省略時: Terraformが自動的にランダムな一意の名前を割り当てます
  # 関連機能: SageMaker モニタリングスケジュール名
  #   モニタリングスケジュールを識別するための名前。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-scheduling.html
  name = "example-monitoring-schedule"

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # モニタリングスケジュール設定
  #-------------------------------------------------------------

  # monitoring_schedule_config (Required)
  # 設定内容: モニタリングスケジュールの詳細設定を指定します。
  # 用途: モニタリングジョブの定義名、監視タイプ、実行スケジュールを設定
  monitoring_schedule_config {
    # monitoring_job_definition_name (Required)
    # 設定内容: スケジュールするモニタリングジョブ定義の名前を指定します。
    # 設定可能な値: 既存のモニタリングジョブ定義名
    #   - aws_sagemaker_data_quality_job_definition
    #   - aws_sagemaker_model_quality_job_definition
    #   - aws_sagemaker_model_bias_job_definition
    #   - aws_sagemaker_model_explainability_job_definition
    # 関連機能: SageMaker モニタリングジョブ定義
    #   事前に作成したジョブ定義を参照してモニタリングを実行。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor-data-quality.html
    monitoring_job_definition_name = "example-data-quality-job-definition"

    # monitoring_type (Required)
    # 設定内容: スケジュールするモニタリングジョブのタイプを指定します。
    # 設定可能な値:
    #   - "DataQuality": データ品質の監視（欠損値、型の不一致、分布のドリフトなど）
    #   - "ModelQuality": モデル品質の監視（精度、再現率、F1スコアなど）
    #   - "ModelBias": モデルのバイアス監視（公平性指標の評価）
    #   - "ModelExplainability": モデルの説明可能性の監視（特徴量の重要度など）
    # 関連機能: SageMaker モニタリングタイプ
    #   監視目的に応じて適切なタイプを選択。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html
    monitoring_type = "DataQuality"

    # schedule_config (Optional)
    # 設定内容: モニタリングジョブの実行スケジュールを設定します。
    # 用途: 定期的なモニタリングの頻度を制御
    # 省略時: モニタリングは自動的に実行されません
    schedule_config {
      # schedule_expression (Required)
      # 設定内容: モニタリングスケジュールの詳細を記述するcron式を指定します。
      # 設定可能な値: AWS cron式形式
      #   - 例: "cron(0 * ? * * *)" → 毎時0分に実行
      #   - 例: "cron(0 0 ? * * *)" → 毎日0時0分に実行
      #   - 例: "cron(0 */6 ? * * *)" → 6時間ごとに実行
      # フォーマット: cron(分 時 日 月 曜日 年)
      # 関連機能: CloudWatch Events Schedule Expressions
      #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html
      schedule_expression = "cron(0 * ? * * *)"
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/tagging.html
  tags = {
    Name        = "example-monitoring-schedule"
    Environment = "production"
    Purpose     = "data-quality-monitoring"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はモニタリングスケジュール名と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: モニタリングスケジュールのAmazon Resource Name (ARN)
#
# - name: モニタリングスケジュールの名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# resource "aws_sagemaker_monitoring_schedule" "data_quality" {
#   name = "data-quality-monitoring"
#
#   monitoring_schedule_config {
#     monitoring_job_definition_name = aws_sagemaker_data_quality_job_definition.example.name
#     monitoring_type                = "DataQuality"
#
#     schedule_config {
#       schedule_expression = "cron(0 * ? * * *)" # 毎時実行
#     }
#---------------------------------------------------------------
