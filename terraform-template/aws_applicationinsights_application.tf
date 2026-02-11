#---------------------------------------------------------------
# AWS CloudWatch Application Insights Application
#---------------------------------------------------------------
#
# Amazon CloudWatch Application Insightsのアプリケーションをプロビジョニングするリソースです。
# Application Insightsは、アプリケーションとその基盤となるAWSリソースの問題を検出し、
# 監視を容易にするサービスです。SageMakerおよび他のAWS技術を使用して、
# 潜在的な問題を示す自動化されたダッシュボードを提供し、
# 平均修復時間（MTTR）を短縮します。
#
# AWS公式ドキュメント:
#   - CloudWatch Application Insights概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch-application-insights.html
#   - Application Insightsの仕組み: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/appinsights-how-works.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/applicationinsights_application
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_applicationinsights_application" "example" {
  #-------------------------------------------------------------
  # リソースグループ設定
  #-------------------------------------------------------------

  # resource_group_name (Required)
  # 設定内容: 監視対象のリソースグループの名前を指定します。
  # 設定可能な値: 既存のAWS Resource Groupsのグループ名
  # 注意: aws_resourcegroups_groupリソースと組み合わせて使用することが一般的です。
  resource_group_name = "example-resource-group"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 自動設定オプション
  #-------------------------------------------------------------

  # auto_config_enabled (Optional)
  # 設定内容: Application Insightsがリソースグループ内の未監視リソースを
  #           自動的に設定するかどうかを指定します。
  # 設定可能な値:
  #   - true: 未監視リソースを自動設定
  #   - false: 自動設定を無効化
  # 関連機能: Application Insights自動設定
  #   リソースグループに追加されたリソースに対して、推奨されるメトリクスとログを
  #   自動的に設定します。
  auto_config_enabled = true

  # auto_create (Optional)
  # 設定内容: リソースグループ内のすべてのリソースに推奨される設定を
  #           適用するかどうかを指定します。
  # 設定可能な値:
  #   - true: 推奨設定を自動適用
  #   - false: 自動適用を無効化
  auto_create = true

  #-------------------------------------------------------------
  # モニタリング設定
  #-------------------------------------------------------------

  # cwe_monitor_enabled (Optional)
  # 設定内容: Application Insightsがアプリケーションリソースの
  #           CloudWatch Eventsをリッスンするかどうかを指定します。
  # 設定可能な値:
  #   - true: CloudWatch Events監視を有効化（インスタンス終了、デプロイ失敗など）
  #   - false: CloudWatch Events監視を無効化
  # 関連機能: CloudWatch Events連携
  #   アプリケーションリソースのイベント（インスタンス終了、デプロイ失敗など）を
  #   監視し、問題の検出に活用します。
  cwe_monitor_enabled = true

  #-------------------------------------------------------------
  # グルーピング設定
  #-------------------------------------------------------------

  # grouping_type (Optional)
  # 設定内容: Application Insightsがアプリケーションを作成する基準を指定します。
  # 設定可能な値:
  #   - "ACCOUNT_BASED": アカウント内のすべてのリソースを使用してアカウントベースの
  #                      アプリケーションを作成
  #   - 未指定: リソースグループベースのアプリケーションを作成（デフォルト）
  # 注意: ACCOUNT_BASEDを指定すると、アカウント内のすべてのリソースが監視対象となります。
  grouping_type = null

  #-------------------------------------------------------------
  # OpsCenter連携設定
  #-------------------------------------------------------------

  # ops_center_enabled (Optional)
  # 設定内容: アプリケーションで問題が検出された場合にOpsItemを作成するかどうかを指定します。
  # 設定可能な値:
  #   - true: 問題検出時にOpsItemを作成
  #   - false: OpsItem作成を無効化
  # 関連機能: AWS Systems Manager OpsCenter連携
  #   OpsItemを作成することで、Systems Manager Automationドキュメントを使用して
  #   問題を解決できます。
  #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/OpsCenter.html
  ops_center_enabled = false

  # ops_item_sns_topic_arn (Optional)
  # 設定内容: OpsItemに関連付けるSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックARN
  # 用途: OpsItemの更新通知を受け取るために使用します。
  # 注意: ops_center_enabledがtrueの場合に有効です。
  ops_item_sns_topic_arn = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-application-insights"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Application InsightsアプリケーションのAmazon Resource Name (ARN)
#
# - id: リソースグループの名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------

#---------------------------------------------------------------
# resource "aws_resourcegroups_group" "example" {
#   name = "example-resource-group"
#
#   resource_query {
#     query = jsonencode({
#       ResourceTypeFilters = [
#         "AWS::EC2::Instance"
#       ]
#       TagFilters = [
#         {
#           Key    = "Environment"
#---------------------------------------------------------------
