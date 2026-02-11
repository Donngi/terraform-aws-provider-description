################################################################################
# AWS SageMaker Service Catalog Portfolio Status
################################################################################
# リソース概要:
#   SageMakerにおけるService Catalogのステータスを管理します。
#   Service CatalogはSageMaker AIプロジェクトを作成するために使用されます。
#
# ユースケース:
#   - SageMaker ProjectsやJumpStart機能を有効化する際に使用
#   - 組織全体でSageMaker Service Catalogの使用を制御
#   - Service Catalogの有効化/無効化の状態管理
#
# 公式ドキュメント:
#   https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sagemaker_servicecatalog_portfolio_status
#   https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects.html
#
# プロバイダーバージョン: 6.28.0
################################################################################

resource "aws_sagemaker_servicecatalog_portfolio_status" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # status - (必須) SageMakerでService Catalogが有効か無効かを指定
  # 有効な値: "Enabled", "Disabled"
  #
  # 説明:
  #   - Enabled: SageMaker ProjectsとJumpStartの機能が利用可能になります
  #   - Disabled: これらの機能が無効化されます
  #
  # 注意事項:
  #   - この設定はAWSリージョンごとに管理されます
  #   - 有効化すると、SageMaker Projectsテンプレートが利用可能になります
  status = "Enabled"

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # region - (オプション) リソースが管理されるAWSリージョン
  # デフォルト: プロバイダー設定で指定されたリージョン
  #
  # 説明:
  #   - 特定のリージョンでService Catalogのステータスを管理する場合に指定
  #   - 通常はプロバイダーのデフォルトリージョンが使用されます
  #
  # 参考:
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # region = "us-west-2"

  ################################################################################
  # 計算される属性 (Computed Attributes)
  ################################################################################

  # id - Service Catalogポートフォリオステータスが存在するAWSリージョン
  #   自動的に計算されます
}

################################################################################
# 出力例
################################################################################

# output "sagemaker_servicecatalog_status" {
#   description = "SageMaker Service Catalogのステータス"
#   value       = aws_sagemaker_servicecatalog_portfolio_status.example.status
# }
#
# output "sagemaker_servicecatalog_region" {
#   description = "Service Catalogが有効化されているリージョン"
#   value       = aws_sagemaker_servicecatalog_portfolio_status.example.id
# }

################################################################################
# 使用例
################################################################################

# 例1: 基本的な使用方法
# resource "aws_sagemaker_servicecatalog_portfolio_status" "enable" {
#   status = "Enabled"
# }

# 例2: 特定のリージョンで有効化
# resource "aws_sagemaker_servicecatalog_portfolio_status" "us_west" {
#   status = "Enabled"
#   region = "us-west-2"
# }

# 例3: Service Catalogを無効化
# resource "aws_sagemaker_servicecatalog_portfolio_status" "disable" {
#   status = "Disabled"
# }

################################################################################
# ベストプラクティス
################################################################################
#
# 1. リージョンごとの管理
#    - Service Catalogのステータスはリージョンごとに管理されます
#    - マルチリージョン環境では、各リージョンで個別に設定が必要です
#
# 2. プロジェクト管理との連携
#    - SageMaker Projectsを使用する前に、このリソースでService Catalogを
#      有効化する必要があります
#
# 3. アクセス権限
#    - Service Catalogを有効化するには、適切なIAM権限が必要です
#    - sagemaker:EnableSagemakerServicecatalogPortfolio権限を確認してください
#
# 4. 組織的な制御
#    - Service Control Policies (SCP)を使用して、組織レベルで制御することも
#      可能です
#
# 5. 状態の監視
#    - CloudTrailを使用して、Service Catalogのステータス変更を監視できます

################################################################################
# 注意事項
################################################################################
#
# - このリソースは、SageMaker Studio ClassicやSageMaker Studio（新バージョン）
#   でプロジェクトを作成する際に必要です
# - Service Catalogを有効化すると、デフォルトのSageMakerプロジェクト
#   テンプレートが自動的に利用可能になります
# - 無効化する場合、既存のプロジェクトには影響しませんが、新規プロジェクトの
#   作成ができなくなります
# - リージョンごとに独立して管理されるため、マルチリージョン展開時は
#   各リージョンで個別に設定が必要です
