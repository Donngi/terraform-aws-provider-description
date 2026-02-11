################################################################################
# AWS Security Hub Organization Configuration
################################################################################
# Security HubのOrganization全体の設定を管理するリソースです。
#
# 主な機能:
# - 新規アカウントの自動有効化設定
# - デフォルトセキュリティ標準の自動有効化設定
# - ローカル/セントラル構成タイプの設定
#
# 重要な注意事項:
# - このリソースを使用する前に、aws_securityhub_organization_admin_accountの設定が必要
# - セントラル構成(CENTRAL)を使用する場合:
#   * 委任管理者はOrganizationのメンバーアカウントである必要があります(管理アカウントではない)
#   * aws_securityhub_finding_aggregatorの設定が必要
#   * auto_enableはfalseに設定し、auto_enable_standardsはNONEに設定する必要があります
# - これは高度なTerraformリソースです。インポートなしで自動的に管理を引き継ぎ、
#   Terraform設定から削除してもアクションは実行されません
# - このリソースを削除すると、Security Hubはローカル構成にリセットされ、
#   自動有効化はfalseになります
#
# 関連ドキュメント:
# - Terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_organization_configuration
# - AWS API: https://docs.aws.amazon.com/securityhub/1.0/APIReference/API_UpdateOrganizationConfiguration.html
# - 管理ガイド: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-accounts.html
# - セントラル構成: https://docs.aws.amazon.com/securityhub/latest/userguide/central-configuration-intro.html

################################################################################
# Example: Local Configuration (ローカル構成)
################################################################################
# ローカル構成では、委任管理者が各AWSリージョンで個別に新しいOrganizationアカウントの
# Security Hubとデフォルトのセキュリティ標準を有効化できます。

# resource "aws_organizations_organization" "example" {
#   aws_service_access_principals = ["securityhub.amazonaws.com"]
#   feature_set                   = "ALL"
# }

# resource "aws_securityhub_organization_admin_account" "example" {
#   depends_on = [aws_organizations_organization.example]
#
#   admin_account_id = "123456789012"
# }

# resource "aws_securityhub_organization_configuration" "example" {
#   # 新規アカウントでSecurity Hubを自動的に有効化するかどうか
#   # Required: 必須パラメータ
#   # Type: boolean
#   # Default: なし
#   # セントラル構成を使用する場合、このパラメータはfalseに設定し、
#   # ホームリージョンおよびリンクされたリージョンでは変更できません
#   auto_enable = true
#
#   # 新規メンバーアカウントでSecurity Hubのデフォルト標準を自動的に有効化するかどうか
#   # Optional: オプション
#   # Type: string
#   # Valid values: "DEFAULT" | "NONE"
#   # Default: "DEFAULT"
#   # - DEFAULT: AWS Foundational Security Best Practices (FSBP)およびCIS AWS Foundations Benchmark v1.2.0が有効化されます
#   # - NONE: デフォルト標準を有効化しません
#   # セントラル構成を使用する場合、このパラメータはNONEに設定し、
#   # ホームリージョンおよびリンクされたリージョンでは変更できません
#   # auto_enable_standards = "DEFAULT"
# }

################################################################################
# Example: Central Configuration (セントラル構成)
################################################################################
# セントラル構成では、管理者が構成ポリシーを作成して、複数のアカウントおよび
# リージョンでSecurity Hub、セキュリティ標準、セキュリティコントロールを設定できます。
# 新しいアカウントは、ルートまたは割り当てられた組織単位からポリシーを継承します。

# resource "aws_securityhub_organization_admin_account" "example" {
#   depends_on = [aws_organizations_organization.example]
#
#   admin_account_id = "123456789012"
# }

# resource "aws_securityhub_finding_aggregator" "example" {
#   # すべてのリージョンから検出結果を集約
#   linking_mode = "ALL_REGIONS"
#
#   depends_on = [aws_securityhub_organization_admin_account.example]
# }

# resource "aws_securityhub_organization_configuration" "example" {
#   # セントラル構成ではfalseに設定する必要があります
#   # Required: 必須パラメータ
#   # Type: boolean
#   auto_enable = false
#
#   # セントラル構成ではNONEに設定する必要があります
#   # Optional: オプション
#   # Type: string
#   # Valid values: "DEFAULT" | "NONE"
#   auto_enable_standards = "NONE"
#
#   # Organization構成情報
#   # Optional: オプション
#   # Type: block
#   # セントラル構成を使用する場合に設定します
#   organization_configuration {
#     # 構成タイプ: LOCALまたはCENTRAL
#     # Required: 必須パラメータ (organization_configurationブロック内で)
#     # Type: string
#     # Valid values: "LOCAL" | "CENTRAL"
#     # - LOCAL: ローカル構成を使用します
#     # - CENTRAL: セントラル構成を使用します（auto_enableはfalse、auto_enable_standardsはNONEに設定する必要があります）
#     configuration_type = "CENTRAL"
#   }
#
#   depends_on = [aws_securityhub_finding_aggregator.example]
# }

################################################################################
# Attributes Reference (読み取り専用属性)
################################################################################
# このリソースからは以下の属性を参照できます:
#
# - id: AWSアカウントID

################################################################################
# Import
################################################################################
# Security Hub Organization Configurationはインポートできます:
#
# terraform import aws_securityhub_organization_configuration.example 123456789012
#
# 注意: このリソースは高度なTerraformリソースであり、インポートなしで
# 自動的に管理を引き継ぎます。
