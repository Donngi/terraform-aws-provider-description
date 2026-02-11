# ============================================================================
# AWS Service Quotas - Service Quota
# ============================================================================
# Service Quotas（サービスクォータ）は、AWSアカウントやリージョンごとに設定された
# リソース・アクション・アイテムの最大値（制限値）を管理するためのサービスです。
# このリソースを使用すると、個別のサービスクォータの値を変更（引き上げ）できます。
#
# 重要な注意事項:
# - グローバルクォータは全リージョンに適用されますが、アクセスは us-east-1 (商用パーティション)
#   または us-gov-west-1 (GovCloudパーティション) からのみ可能です
# - 他のリージョンからアクセスすると、APIエラーが返されます
# - クォータ値が現在値より高い場合、クォータ引き上げリクエストが自動的に送信されます
# - 小規模な引き上げは通常自動承認されますが、大規模なリクエストはAWSサポートに送信されます
#
# ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicequotas_service_quota
# AWS公式ドキュメント: https://docs.aws.amazon.com/servicequotas/
# ============================================================================

# ----------------------------------------------------------------------------
# 基本的な使用例: VPCのクォータを引き上げ
# ----------------------------------------------------------------------------
resource "aws_servicequotas_service_quota" "example" {
  # ============================================================================
  # 必須パラメータ
  # ============================================================================

  # quota_code - クォータコード（必須）
  # 追跡・管理するサービスクォータのコード
  # 例: "L-F678F1CE" (VPCの数)
  #
  # 利用可能な値の確認方法:
  # AWS CLI: aws service-quotas list-service-quotas --service-code vpc
  #
  # Type: string (Required)
  quota_code = "L-F678F1CE"

  # service_code - サービスコード（必須）
  # 追跡するサービスのコード
  # 例: "vpc" (Amazon VPC), "lambda" (AWS Lambda), "ec2" (Amazon EC2)
  #
  # 利用可能な値の確認方法:
  # AWS CLI: aws service-quotas list-services
  #
  # Type: string (Required)
  service_code = "vpc"

  # value - クォータの希望値（必須）
  # サービスクォータに設定したい値（浮動小数点数）
  # この値が現在値より高い場合、クォータ引き上げリクエストが送信されます
  # 既知のリクエストが送信中の場合、この値は保留中のリクエストの希望値を反映します
  #
  # 注意:
  # - 必ず現在値以上の値を指定してください
  # - 大幅な引き上げはAWSサポートのレビューが必要な場合があります
  #
  # Type: number (Required)
  value = 75

  # ============================================================================
  # オプションパラメータ
  # ============================================================================

  # region - リージョン（オプション）
  # このリソースが管理されるリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  #
  # 重要: グローバルクォータの場合は us-east-1 を指定してください
  #
  # Type: string (Optional, Computed)
  # region = "us-east-1"
}

# ----------------------------------------------------------------------------
# 使用例: Lambda関数の同時実行数クォータ
# ----------------------------------------------------------------------------
resource "aws_servicequotas_service_quota" "lambda_concurrent" {
  quota_code   = "L-B99A9384"
  service_code = "lambda"
  value        = 1000

  # Lambdaの同時実行数制限を1000に引き上げ
}

# ----------------------------------------------------------------------------
# 使用例: EC2 On-Demand インスタンスのvCPUクォータ
# ----------------------------------------------------------------------------
resource "aws_servicequotas_service_quota" "ec2_vcpu" {
  quota_code   = "L-1216C47A"
  service_code = "ec2"
  value        = 128

  # EC2 Standard (A, C, D, H, I, M, R, T, Z) インスタンスファミリーの
  # On-Demand vCPU数を128に引き上げ
}

# ----------------------------------------------------------------------------
# 使用例: S3バケット数のクォータ（グローバルクォータ）
# ----------------------------------------------------------------------------
resource "aws_servicequotas_service_quota" "s3_buckets" {
  quota_code   = "L-DC2B2D3D"
  service_code = "s3"
  value        = 150
  region       = "us-east-1" # グローバルクォータは us-east-1 でのみ管理可能
}

# ============================================================================
# 出力値（Computed Attributes）
# ============================================================================
# このリソースは作成後、以下の属性が自動的に計算されます:

# adjustable (bool)
# - サービスクォータが引き上げ可能かどうか
# - true: 引き上げ可能、false: 引き上げ不可

# arn (string)
# - サービスクォータのAmazon Resource Name（ARN）
# - 形式: arn:aws:servicequotas:region:account-id:service/service-code/quota/quota-code

# default_value (number)
# - サービスクォータのデフォルト値
# - AWSが最初に設定した値

# id (string)
# - リソースID
# - 形式: service_code/quota_code（例: vpc/L-F678F1CE）

# quota_name (string)
# - クォータの名前
# - 例: "VPCs per Region"

# request_id (string)
# - クォータ引き上げリクエストのID
# - リクエストが送信された場合のみ設定されます

# request_status (string)
# - クォータ引き上げリクエストのステータス
# - 可能な値: PENDING, APPROVED, DENIED, CASE_OPENED, CASE_CLOSED

# service_name (string)
# - サービスの名前
# - 例: "Amazon Virtual Private Cloud (Amazon VPC)"

# usage_metric (list)
# - 測定に関する情報（構造化データ）
# - metric_dimensions: メトリクスのディメンション
#   - class: クラス
#   - resource: リソース
#   - service: サービス
#   - type: タイプ
# - metric_name: メトリクスの名前
# - metric_namespace: メトリクスのネームスペース
# - metric_statistic_recommendation: 推奨される統計方法

# ============================================================================
# 出力定義の例
# ============================================================================
output "service_quota_id" {
  description = "サービスクォータのID"
  value       = aws_servicequotas_service_quota.example.id
}

output "service_quota_arn" {
  description = "サービスクォータのARN"
  value       = aws_servicequotas_service_quota.example.arn
}

output "service_quota_adjustable" {
  description = "サービスクォータが調整可能かどうか"
  value       = aws_servicequotas_service_quota.example.adjustable
}

output "service_quota_default_value" {
  description = "サービスクォータのデフォルト値"
  value       = aws_servicequotas_service_quota.example.default_value
}

output "service_quota_current_value" {
  description = "サービスクォータの現在値"
  value       = aws_servicequotas_service_quota.example.value
}

output "service_quota_name" {
  description = "クォータの名前"
  value       = aws_servicequotas_service_quota.example.quota_name
}

output "service_quota_request_status" {
  description = "クォータ引き上げリクエストのステータス"
  value       = aws_servicequotas_service_quota.example.request_status
}

# ============================================================================
# ベストプラクティスと注意事項
# ============================================================================
#
# 1. クォータコードとサービスコードの確認
#    - AWS CLIを使用して正確なコードを確認してください
#    - aws service-quotas list-services
#    - aws service-quotas list-service-quotas --service-code <service-code>
#
# 2. グローバルクォータの管理
#    - S3バケット数などのグローバルクォータは us-east-1 で管理
#    - 他のリージョンからアクセスするとエラーになります
#
# 3. クォータ引き上げの承認プロセス
#    - 小規模な引き上げ: 通常自動承認
#    - 大規模な引き上げ: AWSサポートのレビューが必要
#    - 承認には数日かかる場合があります
#
# 4. 現在の使用状況の監視
#    - AWS CloudWatchを使用してクォータ使用率を監視
#    - Service Quotas コンソールで使用率を確認できます
#
# 5. クォータの自動管理
#    - AWS Trusted Advisorでクォータの使用状況を監視
#    - CloudWatch Alarmsで閾値に達した際のアラートを設定
#
# 6. リクエストステータスの確認
#    - request_status属性でリクエストの状態を確認
#    - PENDING: 承認待ち
#    - APPROVED: 承認済み
#    - DENIED: 却下
#
# 7. アカウントレベルとリソースレベルのクォータ
#    - このリソースは主にアカウントレベルのクォータを管理
#    - リソースレベルのクォータは別の方法で管理する場合があります
#
# 8. Terraformでの管理
#    - クォータ値を変更すると、新しいリクエストが送信されます
#    - 値を下げることは通常できません（AWSの制限）
#    - destroy時は元の値には戻りません
#
# 9. コスト管理
#    - クォータ引き上げ自体に費用はかかりません
#    - ただし、より多くのリソースを使用すると料金が増加します
#
# 10. マルチリージョン戦略
#     - 各リージョンで個別にクォータを管理する必要があります
#     - グローバルクォータは全リージョンに影響します
#
# ============================================================================
# 関連リソース
# ============================================================================
# - aws_servicequotas_template: Service Quotasテンプレートの管理
# - aws_servicequotas_template_association: テンプレートの関連付け
# - data.aws_servicequotas_service: サービス情報の取得
# - data.aws_servicequotas_service_quota: サービスクォータ情報の取得
#
# ============================================================================
# よくあるユースケース
# ============================================================================
#
# 1. VPCの数を増やす
#    - デフォルト: 5個/リージョン
#    - 大規模な組織で複数のVPCが必要な場合
#
# 2. Lambda同時実行数を増やす
#    - デフォルト: 1000同時実行
#    - 高トラフィックアプリケーション向け
#
# 3. EC2インスタンスのvCPU数を増やす
#    - デフォルト: インスタンスファミリーごとに異なる
#    - 大規模なコンピューティングワークロード向け
#
# 4. S3バケット数を増やす
#    - デフォルト: 100バケット/アカウント
#    - 多数のアプリケーションやプロジェクトを管理する場合
#
# 5. EBS ボリューム数やIOPSを増やす
#    - デフォルト: リージョンごとに制限あり
#    - 大規模なストレージ要件がある場合
#
# ============================================================================
