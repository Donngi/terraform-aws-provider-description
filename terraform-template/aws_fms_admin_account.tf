################################################################################
# AWS Firewall Manager Admin Account
# Resource: aws_fms_admin_account
# Provider Version: 6.28.0
#
# Purpose:
#   AWS Firewall Manager (FMS) の管理者アカウントを関連付け/関連付け解除する
#   リソースです。このリソースは AWS Organizations の管理アカウントまたは
#   メンバーアカウントで使用され、組織全体のファイアウォール管理を一元化します。
#
# Important Notes:
#   - この操作は必ず us-east-1 リージョンで実行する必要があります
#   - AWS Organizations の管理アカウントのみが FMS 管理者アカウントを作成できます
#   - デフォルト管理者アカウントは組織ごとに1つのみ設定可能です
#   - 管理者アカウントは AWS Organizations の委任管理者として自動的に設定されます
#   - このリソースを削除すると、関連するすべての FMS ポリシーが削除されます
#
# Use Cases:
#   - 組織全体の AWS WAF ルールを一元管理
#   - Shield Advanced 保護の集中管理
#   - VPC Security Group の一元管理
#   - AWS Network Firewall ポリシーの統括管理
#   - セキュリティグループの監査とコンプライアンス確保
#
# Prerequisites:
#   - AWS Organizations が有効化されていること
#   - AWS Config が有効化されていること
#   - 管理対象リソースをサポートするサービスが有効化されていること
#
# References:
#   - https://docs.aws.amazon.com/waf/latest/developerguide/fms-creating-administrators.html
#   - https://docs.aws.amazon.com/fms/2018-01-01/APIReference/API_AdminAccountSummary.html
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/fms_admin_account
################################################################################

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28.0"
    }
  }
}

# Provider Configuration
# Note: FMS admin account must be configured in us-east-1 region
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

################################################################################
# Basic Configuration
# 現在のアカウントを FMS 管理者として設定する最もシンプルな構成
################################################################################

resource "aws_fms_admin_account" "example_basic" {
  # Provider の設定で us-east-1 を使用
  provider = aws.us_east_1

  # account_id が指定されない場合、現在のアカウントが使用されます
  # この構成は最もシンプルで、実行中のアカウントを管理者にする場合に使用します
}

################################################################################
# Specific Account Configuration
# 特定の AWS アカウントを FMS 管理者として指定する構成
################################################################################

resource "aws_fms_admin_account" "example_specific" {
  provider = aws.us_east_1

  # ────────────────────────────────────────────────────────────────────────
  # account_id (Optional) - 管理者アカウント ID
  # ────────────────────────────────────────────────────────────────────────
  # Description:
  #   AWS Firewall Manager の管理者として関連付ける AWS アカウント ID。
  #   このアカウントは AWS Organizations の管理アカウントまたはメンバー
  #   アカウントのいずれかを指定できます。
  #
  # Details:
  #   - 未指定の場合: 現在の AWS アカウントがデフォルトで使用されます
  #   - AWS Organizations 管理アカウント: 完全な管理スコープを持ちます
  #   - メンバーアカウント: 委任管理者として設定されます
  #   - ドリフト検出を実行するために必ず設定が必要です
  #   - 12桁の数字で構成される AWS アカウント ID を指定します
  #
  # Use Cases:
  #   - セキュリティ専用アカウントを FMS 管理者として指定
  #   - 組織の管理アカウントとは別のアカウントで FMS を管理
  #   - マルチアカウント戦略での集中管理アカウントの指定
  #
  # Example Values:
  #   - "123456789012" (12桁のアカウント ID)
  #   - data.aws_caller_identity.current.account_id (現在のアカウント)
  #   - var.fms_admin_account_id (変数から取得)
  #
  # Format: 12桁の数字 (文字列)
  # Required: No (デフォルト: 現在のアカウント)
  # Drift Detection: Yes (ドリフト検出に必須)
  # ────────────────────────────────────────────────────────────────────────
  account_id = "123456789012"

  # Note: このアカウントは以下の要件を満たす必要があります:
  # 1. AWS Organizations のメンバーであること
  # 2. AWS Config が有効化されていること
  # 3. FMS がサポートするリージョンで利用可能であること
}

################################################################################
# Configuration with Variables
# 変数を使用した柔軟な構成パターン
################################################################################

# Data Source: 現在のアカウント情報を取得
data "aws_caller_identity" "current" {
  provider = aws.us_east_1
}

# Variable Definition (通常は variables.tf に定義)
variable "fms_admin_account_id" {
  description = "AWS Firewall Manager の管理者アカウント ID。未指定の場合は現在のアカウントを使用します。"
  type        = string
  default     = null

  validation {
    condition     = var.fms_admin_account_id == null || can(regex("^[0-9]{12}$", var.fms_admin_account_id))
    error_message = "アカウント ID は12桁の数字である必要があります。"
  }
}

variable "enable_fms_admin" {
  description = "AWS Firewall Manager 管理者アカウントを有効化するかどうか"
  type        = bool
  default     = true
}

# Resource with Conditional Creation
resource "aws_fms_admin_account" "example_variable" {
  # 条件付きでリソースを作成
  count = var.enable_fms_admin ? 1 : 0

  provider = aws.us_east_1

  # 変数が指定されている場合はその値を、未指定の場合は現在のアカウントを使用
  account_id = var.fms_admin_account_id != null ? var.fms_admin_account_id : data.aws_caller_identity.current.account_id
}

################################################################################
# Multi-Region Setup (Provider Configuration Only)
# マルチリージョン構成 (FMS 自体は us-east-1 のみ)
################################################################################

# FMS 管理者アカウントは us-east-1 でのみ設定可能ですが、
# ポリシーは他のリージョンでも適用できます

provider "aws" {
  alias  = "ap_northeast_1"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "eu_west_1"
  region = "eu-west-1"
}

# FMS Admin Account (us-east-1 only)
resource "aws_fms_admin_account" "example_multi_region" {
  provider = aws.us_east_1

  # 管理者アカウントの設定は us-east-1 のみで実行
  account_id = data.aws_caller_identity.current.account_id
}

# Note: FMS ポリシーは別リソース (aws_fms_policy) で
# 複数リージョンに対して作成できます

################################################################################
# Outputs
################################################################################

# Basic Output
output "fms_admin_account_id_basic" {
  description = "FMS 管理者アカウントの AWS アカウント ID (Basic)"
  value       = aws_fms_admin_account.example_basic.id
}

# Specific Account Output
output "fms_admin_account_id_specific" {
  description = "FMS 管理者アカウントの AWS アカウント ID (Specific)"
  value       = aws_fms_admin_account.example_specific.id
}

# Variable-based Output
output "fms_admin_account_id_variable" {
  description = "FMS 管理者アカウントの AWS アカウント ID (Variable-based)"
  value       = var.enable_fms_admin ? aws_fms_admin_account.example_variable[0].id : null
}

# Account Information
output "fms_admin_account_info" {
  description = "FMS 管理者アカウントの詳細情報"
  value = {
    account_id = aws_fms_admin_account.example_basic.id
    region     = "us-east-1" # FMS は常に us-east-1 で管理
  }
}

################################################################################
# Important Attributes
################################################################################

# Attribute: id
# ────────────────────────────────────────────────────────────────────────
# Description:
#   AWS Firewall Manager 管理者アカウントの AWS アカウント ID
#
# Details:
#   - 12桁の数字で構成される AWS アカウント ID
#   - account_id 引数が指定されている場合はその値が返される
#   - account_id 引数が未指定の場合は現在のアカウント ID が返される
#   - この ID は FMS ポリシーの作成や管理に使用される
#
# Example Output: "123456789012"
# ────────────────────────────────────────────────────────────────────────

################################################################################
# Best Practices
################################################################################

# 1. Region Configuration
#    - 必ず us-east-1 リージョンで設定すること
#    - provider エイリアスを使用して明示的に指定することを推奨

# 2. Account Selection
#    - セキュリティ専用アカウントを管理者として使用することを推奨
#    - 管理アカウントではなく委任管理者アカウントの使用を検討

# 3. Prerequisites Verification
#    - AWS Organizations が有効化されていることを確認
#    - AWS Config がすべての必要なリージョンで有効化されていることを確認
#    - 必要な IAM 権限が付与されていることを確認

# 4. Lifecycle Management
#    - 管理者アカウントの削除前に FMS ポリシーを削除すること
#    - 管理者変更時は既存ポリシーへの影響を考慮すること

# 5. Monitoring and Compliance
#    - CloudTrail ログで FMS アクティビティを監視
#    - AWS Config で FMS ポリシーのコンプライアンスを追跡
#    - AWS Security Hub と統合してセキュリティ状態を可視化

# 6. Drift Detection
#    - account_id を明示的に設定してドリフト検出を有効化
#    - 定期的に terraform plan で設定の差異を確認

# 7. Error Handling
#    - リソース作成失敗時は AWS Organizations の設定を確認
#    - AWS Config が正しく設定されているか確認
#    - IAM 権限が適切に付与されているか確認

################################################################################
# Common Use Cases
################################################################################

# Use Case 1: Central Security Account Setup
# セキュリティ専用アカウントでの集中管理

resource "aws_fms_admin_account" "security_central" {
  provider = aws.us_east_1

  # セキュリティアカウントを管理者として指定
  account_id = "999888777666" # Security Account ID

  # このアカウントから組織全体のファイアウォールポリシーを管理
}

# Use Case 2: Conditional Setup with Tagging
# タグを使用した条件付きセットアップ

locals {
  common_tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Service     = "AWS-Firewall-Manager"
    Purpose     = "Centralized-Security-Management"
    CostCenter  = "Security-Operations"
  }
}

# Note: aws_fms_admin_account リソースは tags をサポートしていません
# タグは関連する FMS ポリシーリソースで使用します

# Use Case 3: Integration with AWS Organizations
# AWS Organizations との統合

data "aws_organizations_organization" "current" {
  provider = aws.us_east_1
}

resource "aws_fms_admin_account" "org_integrated" {
  provider = aws.us_east_1

  # Organizations の管理アカウントを使用
  account_id = data.aws_organizations_organization.current.master_account_id
}

output "organization_id" {
  description = "AWS Organizations の組織 ID"
  value       = data.aws_organizations_organization.current.id
}

output "fms_admin_in_org" {
  description = "FMS 管理者アカウントが設定された組織情報"
  value = {
    organization_id  = data.aws_organizations_organization.current.id
    fms_admin_id     = aws_fms_admin_account.org_integrated.id
    master_account   = data.aws_organizations_organization.current.master_account_id
    feature_set      = data.aws_organizations_organization.current.feature_set
  }
}

################################################################################
# Security Considerations
################################################################################

# 1. IAM Permissions Required:
#    - fms:AssociateAdminAccount
#    - fms:DisassociateAdminAccount
#    - fms:GetAdminAccount
#    - organizations:DescribeOrganization
#    - organizations:EnableAWSServiceAccess
#    - organizations:RegisterDelegatedAdministrator

# 2. Service Control Policies (SCPs):
#    - FMS 管理者アカウントに必要なサービスへのアクセスを許可
#    - 管理対象アカウントでの FMS ポリシー実行を許可

# 3. Cross-Account Access:
#    - FMS 管理者は自動的に委任管理者として設定される
#    - Organizations の OU 情報にアクセス可能

# 4. Audit and Compliance:
#    - すべての FMS アクティビティは CloudTrail に記録される
#    - AWS Config で設定変更を追跡
#    - Security Hub でセキュリティ状態を監視

################################################################################
# Troubleshooting
################################################################################

# Error: "InvalidInputException: Account is not part of an organization"
# Solution: AWS Organizations に参加していることを確認

# Error: "InvalidInputException: AWS Config is not enabled"
# Solution: 必要なリージョンで AWS Config を有効化

# Error: "AccessDeniedException"
# Solution: 必要な IAM 権限が付与されているか確認

# Error: "InvalidOperationException: This operation must be performed in us-east-1"
# Solution: provider で us-east-1 を指定

################################################################################
# Migration Notes
################################################################################

# 既存の FMS 管理者を Terraform で管理する場合:
# terraform import aws_fms_admin_account.example 123456789012

# 管理者アカウントを変更する場合:
# 1. 既存のポリシーをすべて削除
# 2. 既存の管理者アカウントをオフボード
# 3. 新しい管理者アカウントを設定

################################################################################
# Related Resources
################################################################################

# - aws_fms_policy: FMS ポリシーの定義
# - aws_organizations_organization: Organizations の設定
# - aws_config_configuration_recorder: AWS Config の設定
# - aws_cloudtrail: 監査ログの設定
# - aws_securityhub_account: Security Hub の統合

################################################################################
# Version History
################################################################################

# Provider Version 6.28.0:
#   - account_id 属性でドリフト検出をサポート
#   - us-east-1 リージョン要件が明確化
#   - AWS Organizations 委任管理者との統合改善

################################################################################
# Additional Resources
################################################################################

# AWS Documentation:
#   - Firewall Manager Getting Started:
#     https://docs.aws.amazon.com/waf/latest/developerguide/getting-started-fms.html
#   - Creating Administrator Account:
#     https://docs.aws.amazon.com/waf/latest/developerguide/fms-creating-administrators.html
#   - API Reference:
#     https://docs.aws.amazon.com/fms/2018-01-01/APIReference/API_AdminAccountSummary.html

# Terraform Documentation:
#   - Resource Documentation:
#     https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/fms_admin_account

################################################################################
