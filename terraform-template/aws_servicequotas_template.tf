# ====================================================================
# AWS Service Quotas Template - Annotated Terraform Template
# ====================================================================
# 生成日: 2026-02-05
# Provider: hashicorp/aws
# Version: 6.28.0
#
# このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicequotas_template
# ====================================================================

# AWS Service Quotas Template リソース
# Service Quotas テンプレートは、新しいAWSアカウントやリージョンに適用するクォータ増加リクエストを
# 定義します。組織の管理アカウントで設定すると、新規作成されたアカウントに自動的に適用されます。
# これにより、アカウント作成時に標準的なクォータ設定を一貫して適用できます。
#
# 参考: https://docs.aws.amazon.com/servicequotas/latest/userguide/organization-templates.html
resource "aws_servicequotas_template" "example" {
  # ========================================
  # 必須パラメータ
  # ========================================

  # クォータコード
  # 増加させるクォータの識別子を指定します。
  # クォータコードは各AWSサービスの特定のクォータを一意に識別します。
  #
  # クォータコードの確認方法:
  #   - AWS CLIを使用: aws service-quotas list-service-quotas --service-code <service-code>
  #   - データソースを使用: aws_servicequotas_service_quota
  #
  # 例:
  #   - L-2ACBD22F: Lambda function and layer storage (デフォルト: 75 GB)
  #   - L-B99A9384: Lambda concurrent executions (デフォルト: 1000)
  #   - L-DC2B2D3D: S3 buckets per account (デフォルト: 100)
  #   - L-1216C47A: EC2 Running On-Demand Standard instances (vCPU)
  #
  # 参考: https://docs.aws.amazon.com/servicequotas/latest/userguide/intro.html
  quota_code = "L-2ACBD22F"

  # サービスコード
  # クォータが属するAWSサービスの識別子を指定します。
  # サービスコードはAWSサービスごとに一意の識別子です。
  #
  # サービスコードの確認方法:
  #   - AWS CLIを使用: aws service-quotas list-services
  #   - データソースを使用: aws_servicequotas_service
  #
  # 主要なサービスコード:
  #   - lambda: AWS Lambda
  #   - s3: Amazon S3
  #   - ec2: Amazon EC2
  #   - rds: Amazon RDS
  #   - dynamodb: Amazon DynamoDB
  #   - vpc: Amazon VPC
  #   - iam: AWS IAM
  #   - cloudformation: AWS CloudFormation
  #   - elasticloadbalancing: Elastic Load Balancing
  #
  # 参考: https://docs.aws.amazon.com/servicequotas/latest/userguide/intro.html
  service_code = "lambda"

  # クォータの新しい値
  # クォータの増加後の値を文字列で指定します。
  # この値は現在のクォータ値より大きい必要があります。
  #
  # 注意事項:
  #   - 値は数値ですが、文字列として指定します（例: "80"）
  #   - サービスによって設定可能な最大値が異なります
  #   - 一部のクォータは増加リクエストが必要な場合があります
  #   - グローバルクォータの場合、すべてのリージョンで同じ値が適用されます
  #
  # 参考: https://docs.aws.amazon.com/servicequotas/latest/userguide/request-quota-increase.html
  value = "80"

  # ========================================
  # オプションパラメータ
  # ========================================

  # AWSリージョン
  # テンプレートを適用するAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  #
  # グローバルクォータとリージョナルクォータ:
  #   - グローバルクォータ: リージョンに関係なくアカウント全体に適用（例: IAMユーザー数）
  #   - リージョナルクォータ: 特定のリージョンにのみ適用（例: EC2インスタンス数）
  #
  # グローバルクォータの場合でも、テンプレート作成時はリージョンの指定が推奨されます。
  # リージョナルクォータの場合は、クォータを適用したいリージョンを指定します。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html
  aws_region = "us-east-1"

  # region (非推奨)
  # aws_region と同じ機能ですが、このパラメータは非推奨です。
  # 新しいコードでは aws_region を使用してください。
  # 既存のコードとの互換性のために残されています。
  # region = "us-east-1"
}

# ====================================================================
# データソースの使用例（参考）
# ====================================================================
# クォータコードとサービスコードを動的に取得する場合は、
# 以下のデータソースを使用できます。

# # サービス情報の取得
# data "aws_servicequotas_service" "lambda" {
#   service_name = "AWS Lambda"
# }
#
# # 特定のクォータ情報の取得
# data "aws_servicequotas_service_quota" "lambda_storage" {
#   service_code = data.aws_servicequotas_service.lambda.service_code
#   quota_name   = "Function and layer storage"
# }
#
# # データソースを使用したリソース定義
# resource "aws_servicequotas_template" "lambda_storage" {
#   aws_region   = "us-east-1"
#   quota_code   = data.aws_servicequotas_service_quota.lambda_storage.quota_code
#   service_code = data.aws_servicequotas_service_quota.lambda_storage.service_code
#   value        = "100"
# }

# ====================================================================
# 複数クォータの設定例（参考）
# ====================================================================
# 複数のクォータテンプレートを定義する場合の例です。

# # Lambda - Function and layer storage
# resource "aws_servicequotas_template" "lambda_storage" {
#   aws_region   = "us-east-1"
#   quota_code   = "L-2ACBD22F"
#   service_code = "lambda"
#   value        = "100"
# }
#
# # Lambda - Concurrent executions
# resource "aws_servicequotas_template" "lambda_concurrent" {
#   aws_region   = "us-east-1"
#   quota_code   = "L-B99A9384"
#   service_code = "lambda"
#   value        = "5000"
# }
#
# # S3 - Buckets
# resource "aws_servicequotas_template" "s3_buckets" {
#   aws_region   = "us-east-1"
#   quota_code   = "L-DC2B2D3D"
#   service_code = "s3"
#   value        = "200"
# }
#
# # EC2 - On-Demand Standard instances (vCPUs)
# resource "aws_servicequotas_template" "ec2_vcpus" {
#   aws_region   = "us-east-1"
#   quota_code   = "L-1216C47A"
#   service_code = "ec2"
#   value        = "128"
# }

# ====================================================================
# 出力例（参考）
# ====================================================================
# 以下の computed 属性は、リソース作成後に参照可能です。

# output "template_id" {
#   description = "Unique identifier for the Service Quotas template (format: region,quota_code,service_code)"
#   value       = aws_servicequotas_template.example.id
# }
#
# output "global_quota" {
#   description = "Indicates whether the quota is global"
#   value       = aws_servicequotas_template.example.global_quota
# }
#
# output "quota_name" {
#   description = "Name of the quota"
#   value       = aws_servicequotas_template.example.quota_name
# }
#
# output "service_name" {
#   description = "Name of the AWS service"
#   value       = aws_servicequotas_template.example.service_name
# }
#
# output "unit" {
#   description = "Unit of measurement for the quota"
#   value       = aws_servicequotas_template.example.unit
# }

# ====================================================================
# 使用上の注意事項
# ====================================================================
# 1. 組織の管理アカウント要件:
#    - Service Quotas テンプレートは AWS Organizations の管理アカウントでのみ作成可能です
#    - メンバーアカウントではこの機能は使用できません
#
# 2. テンプレートの適用タイミング:
#    - 新しいアカウントが作成されたとき
#    - 既存のアカウントに新しいリージョンが有効化されたとき
#    - テンプレートは自動的に適用されます
#
# 3. クォータ増加の承認:
#    - ほとんどのクォータは自動承認されますが、一部は手動レビューが必要です
#    - 増加リクエストの状態は Service Quotas コンソールまたは API で確認できます
#
# 4. グローバルクォータとリージョナルクォータ:
#    - global_quota 属性で確認できます
#    - グローバルクォータはリージョンに関係なくアカウント全体に適用されます
#    - リージョナルクォータは指定したリージョンにのみ適用されます
#
# 5. 削除時の動作:
#    - テンプレートを削除しても、既に適用されたクォータ値は変更されません
#    - 将来作成されるアカウント/リージョンにのみ影響します
#
# 6. ベストプラクティス:
#    - 本番環境の要件に基づいて適切なクォータ値を設定してください
#    - クォータコードとサービスコードの確認にはデータソースの使用を推奨します
#    - 複数のリージョンで同じクォータ設定が必要な場合は、リージョンごとにリソースを定義してください
#
# 参考資料:
#   - Service Quotas ユーザーガイド: https://docs.aws.amazon.com/servicequotas/latest/userguide/
#   - AWS Organizations とテンプレート: https://docs.aws.amazon.com/servicequotas/latest/userguide/organization-templates.html
#   - クォータ増加リクエスト: https://docs.aws.amazon.com/servicequotas/latest/userguide/request-quota-increase.html
