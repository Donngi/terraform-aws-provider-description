#---------------------------------------------------------------
# AWS ECS Account Setting Default
#---------------------------------------------------------------
#
# Amazon Elastic Container Service (ECS) のアカウント設定のデフォルト値を
# 管理するリソースです。特定のリージョン内で特定のECSリソース名に対する
# デフォルトアカウント設定を提供します。
#
# 主な用途:
#   - タスク/サービス/コンテナインスタンスのARN形式の変更（長いARN形式の有効化）
#   - デフォルトログドライバーモードの設定（ブロッキング/非ブロッキング）
#   - FIPS 140-2準拠の設定
#
# 重要な注意事項:
#   - このリソースはAWS APIによって削除されません。destroy実行時は設定の無効化を試みます。
#   - containerInstanceLongArnFormat、serviceLongArnFormat、taskLongArnFormat
#     の無効化は一部のAWSアカウントでサポートされていない場合があります。
#   - 無効化がサポートされていない場合、destroyは設定を無効化せず、
#     Terraformエラーも発生しませんが、AWSエラーログが記録されます。
#
# AWS公式ドキュメント:
#   - ECS アカウント設定: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-account-settings.html
#   - ECS ARN形式: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-account-settings.html#ecs-resource-ids
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_account_setting_default
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecs_account_setting_default" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 設定するアカウント設定の名前を指定します。
  # 設定可能な値:
  #   - serviceLongArnFormat: ECSサービスの長いARN形式
  #   - taskLongArnFormat: ECSタスクの長いARN形式
  #   - containerInstanceLongArnFormat: ECSコンテナインスタンスの長いARN形式
  #   - awsvpcTrunking: ECSタスク用のENIトランキング
  #   - containerInsights: ECS Container Insights
  #   - fargateFIPSMode: Fargate FIPS 140-2準拠モード
  #   - tagResourceAuthorization: タグベースのリソース認可
  #   - fargateTaskRetirementWaitPeriod: Fargateタスクの廃止待機期間
  #   - guardDutyActivate: GuardDuty ECS Runtime Monitoring
  #   - defaultLogDriverMode: デフォルトログドライバーモード
  # 参考: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-account-settings.html
  name = "taskLongArnFormat"

  # value (Required)
  # 設定内容: アカウント設定の状態を指定します。
  # 設定可能な値:
  #   - "enabled": 設定を有効化
  #   - "disabled": 設定を無効化
  #   - その他の値: 設定によって異なる（例: defaultLogDriverModeの場合は "blocking" または "non-blocking"）
  # 注意:
  #   - 長いARN形式（serviceLongArnFormat, taskLongArnFormat, containerInstanceLongArnFormat）は
  #     一度有効化すると無効化できない場合があります。
  #   - 無効化をサポートしていないアカウントでは、AWS APIが
  #     「InvalidParameterException: You can no longer disable Long Arn settings」
  #     エラーを返します。
  value = "enabled"

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 任意のAWSリージョン（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: アカウント設定はリージョンごとに管理されます。
  #       複数のリージョンで同じ設定を適用する場合は、各リージョンごとに
  #       このリソースを定義する必要があります。
  # region = "us-east-1"
}

#---------------------------------------------------------------

# 例1: タスクの長いARN形式を有効化
resource "aws_ecs_account_setting_default" "task_long_arn" {
  name  = "taskLongArnFormat"
  value = "enabled"
}

# 例2: サービスの長いARN形式を有効化
resource "aws_ecs_account_setting_default" "service_long_arn" {
  name  = "serviceLongArnFormat"
  value = "enabled"
}

# 例3: コンテナインスタンスの長いARN形式を有効化
resource "aws_ecs_account_setting_default" "container_instance_long_arn" {
  name  = "containerInstanceLongArnFormat"
  value = "enabled"
}

# 例4: Container Insightsを有効化
resource "aws_ecs_account_setting_default" "container_insights" {
  name  = "containerInsights"
  value = "enabled"
}

# 例5: デフォルトログドライバーモードを非ブロッキングに設定
resource "aws_ecs_account_setting_default" "log_driver_mode" {
  name  = "defaultLogDriverMode"
  value = "non-blocking"
}

# 例6: 特定のリージョンで設定を適用
resource "aws_ecs_account_setting_default" "task_long_arn_tokyo" {
  name   = "taskLongArnFormat"
  value  = "enabled"
  region = "ap-northeast-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アカウント設定の名前（nameと同じ値）
#
# - principal_arn: アカウント設定を識別するARN
#        形式: arn:aws:ecs:{region}:{account-id}:account-setting/{name}
#        用途: IAMポリシーやCloudTrailログでの識別に使用
#
# - region: このリソースが管理されているリージョン
#        値: プロバイダー設定またはregion属性で指定されたリージョン
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# 1. 長いARN形式の有効化:
#    - 新しいECSクラスターを作成する前に、すべての長いARN形式設定を有効化することを推奨
#    - これにより、タスク、サービス、コンテナインスタンスのARNに詳細な情報が含まれます
#
# 2. Container Insights:
#    - パフォーマンスメトリクスと診断情報の収集に有用
#    - 追加料金が発生するため、必要に応じて有効化
#
#---------------------------------------------------------------
