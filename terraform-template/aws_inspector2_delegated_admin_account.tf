################################################################################
# Resource: aws_inspector2_delegated_admin_account
# Purpose: Terraform resource for managing an Amazon Inspector Delegated Admin Account
# Provider Version: 6.28.0
# Last Updated: 2026-01-27
################################################################################

################################################################################
# Overview
################################################################################
# Amazon Inspector の組織全体の管理を行う委任管理者アカウントを指定します。
# 委任管理者は、組織内のメンバーアカウントに対して Amazon Inspector の
# スキャン設定の管理、検出結果の集約、抑制ルールの作成などを行う権限を持ちます。
#
# このリソースは AWS Organizations との統合を前提としており、組織の管理アカウント
# から実行する必要があります。委任管理者として指定されたアカウントは、
# 組織内のすべてのメンバーアカウントの Inspector 設定を一元管理できます。
#
# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_delegated_admin_account

################################################################################
# Use Cases
################################################################################
# 1. Multi-Account Security Management
#    組織内の複数アカウントの脆弱性管理を一元化
#    - EC2、ECR、Lambda の自動スキャン管理
#    - Lambda コードスキャンの設定管理
#    - メンバーアカウント全体の検出結果の集約と分析
#
# 2. Centralized Policy Enforcement
#    セキュリティポリシーの一元的な適用
#    - 組織全体のスキャン設定の標準化
#    - 抑制ルール(suppression rules)の一元管理
#    - リスクベースの優先順位付けの実装
#
# 3. Security Governance at Scale
#    大規模環境でのセキュリティガバナンスの実現
#    - 組織ポリシーによるスキャンタイプの強制
#    - メンバーアカウントへのスキャン設定の自動展開
#    - Security Hub との統合による統合的な脆弱性管理

################################################################################
# Prerequisites and Dependencies
################################################################################
# - AWS Organizations が有効化されていること
# - このリソースは組織の管理アカウントから実行する必要があります
# - 委任管理者として指定するアカウントが組織のメンバーであること
# - Amazon Inspector のサービスプリンシパル(inspector2.amazonaws.com)が
#   Organizations の信頼されたアクセスに追加されていること
# - 委任管理者アカウントに AWSServiceRoleForAmazonInspector2 サービスリンク
#   ロールが作成されること(自動的に作成されます)

################################################################################
# Important Notes
################################################################################
# - 組織内で委任管理者として指定できるアカウントは1つのみです
# - 委任管理者を変更する場合は、既存の委任管理者を削除してから
#   新しいアカウントを指定する必要があります
# - 委任管理者を削除すると、そのアカウントが管理していた設定や
#   抑制ルールは削除されませんが、管理権限が失われます
# - リージョン単位で委任管理者を指定します(グローバルリソースではありません)
# - 委任管理者は組織のメンバーアカウントのスキャンを有効化・無効化できますが、
#   組織ポリシーで管理されているスキャンタイプは変更できません

################################################################################
# Security Considerations
################################################################################
# - 委任管理者アカウントは組織全体のセキュリティ検出結果にアクセスできるため、
#   信頼できるアカウントを選択してください
# - 委任管理者アカウントへのアクセスは適切に制限し、最小権限の原則に従ってください
# - 委任管理者の変更履歴を記録し、監査可能な状態を維持してください
# - CloudTrail を使用して委任管理者による操作をログに記録してください

################################################################################
# Example Configuration
################################################################################

# 現在の AWS アカウント ID を取得
data "aws_caller_identity" "current" {}

# 基本的な使用例: 現在のアカウントを委任管理者として指定
resource "aws_inspector2_delegated_admin_account" "example_basic" {
  account_id = data.aws_caller_identity.current.account_id
}

# 特定のアカウントを委任管理者として指定
resource "aws_inspector2_delegated_admin_account" "example_specific_account" {
  # 組織内の特定のセキュリティ管理用アカウントを指定
  account_id = "123456789012"

  # タグ付けによる管理の明確化
  tags = {
    Name        = "Inspector2-Delegated-Admin"
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "centralized-vulnerability-management"
  }
}

# 特定リージョンでの委任管理者の設定
resource "aws_inspector2_delegated_admin_account" "example_specific_region" {
  account_id = data.aws_caller_identity.current.account_id

  # 特定のリージョンで委任管理者を設定
  # デフォルトはプロバイダーの設定リージョン
  region = "us-west-2"
}

# Organizations との統合を含む完全な例
data "aws_organizations_organization" "current" {}

resource "aws_inspector2_delegated_admin_account" "example_with_org" {
  account_id = var.security_account_id

  # 組織が有効であることを確認
  depends_on = [data.aws_organizations_organization.current]

  tags = {
    Name           = "Inspector2-DelegatedAdmin"
    Organization   = data.aws_organizations_organization.current.id
    SecurityTeam   = "cloud-security"
    CostCenter     = "security-operations"
    ComplianceTag  = "required"
  }
}

################################################################################
# Required Arguments
################################################################################

# account_id - (必須)
# 説明: Amazon Inspector の委任管理者として指定する AWS アカウント ID
# タイプ: string (12桁の数字)
# 制約:
#   - 有効な AWS アカウント ID である必要があります
#   - 組織のメンバーアカウントである必要があります
#   - 同一リージョンで既に別のアカウントが委任管理者として指定されている場合は
#     エラーになります
# 変更の影響: ForceNew - 変更すると既存のリソースが削除され、新しいリソースが作成されます
# ベストプラクティス:
#   - セキュリティ専用のアカウントを使用することを推奨
#   - データソース(aws_caller_identity)を使用して動的に取得することで、
#     環境間での再利用性を向上させることができます
#   - 変数を使用して環境ごとに異なるアカウントを指定できるようにする
# 例:
#   account_id = "123456789012"
#   account_id = data.aws_caller_identity.current.account_id
#   account_id = var.security_admin_account_id

################################################################################
# Optional Arguments
################################################################################

# region - (オプション)
# 説明: このリソースを管理するリージョン
# タイプ: string
# デフォルト: プロバイダー設定のリージョン
# 制約:
#   - Amazon Inspector が利用可能なリージョンである必要があります
#   - リージョン単位での管理となるため、マルチリージョン構成の場合は
#     各リージョンで個別に設定する必要があります
# 変更の影響: ForceNew - 変更すると既存のリソースが削除され、新しいリソースが作成されます
# ユースケース:
#   - 特定のリージョンのみで Inspector を使用する場合
#   - 各リージョンで異なる委任管理者を設定する場合(非推奨)
#   - リージョン固有のコンプライアンス要件がある場合
# ベストプラクティス:
#   - 通常はプロバイダーのデフォルトリージョンを使用することを推奨
#   - マルチリージョン展開の場合は、terraform workspace や provider alias を
#     使用して管理することを推奨
#   - 組織全体で一貫した委任管理者設定を維持する
# 例:
#   region = "us-east-1"
#   region = var.aws_region
#   region = "eu-west-1"

################################################################################
# Attributes Reference
################################################################################

# relationship_status - (読み取り専用)
# 説明: 委任管理者アカウントの現在の状態
# タイプ: string
# 可能な値:
#   - CREATED: 委任管理者の関係が作成された
#   - INVITED: 招待が送信された(Organizations では通常使用されない)
#   - DISABLED: 無効化されている
#   - ENABLED: 有効化され、正常に機能している
#   - REMOVED: 削除された
#   - RESIGNED: 辞退された
#   - DELETED: 削除された
#   - EMAIL_VERIFICATION_IN_PROGRESS: メール確認中(Organizations では通常使用されない)
#   - EMAIL_VERIFICATION_FAILED: メール確認失敗(Organizations では通常使用されない)
#   - REGION_DISABLED: リージョンで無効化されている
#   - ACCOUNT_SUSPENDED: アカウントが停止されている
#   - CANNOT_CREATE_DETECTOR_IN_ORG_MASTER: 組織マスターでディテクターを作成できない
# 使用例:
#   output "delegated_admin_status" {
#     value       = aws_inspector2_delegated_admin_account.example.relationship_status
#     description = "Current status of the delegated administrator relationship"
#   }
#
# 注意事項:
#   - この属性を使用して、委任管理者の設定が正常に完了したかを確認できます
#   - ENABLED 状態になるまで、委任管理者としての機能は利用できません
#   - depends_on を使用して、他のリソースが委任管理者の設定完了を待機できます

################################################################################
# Import
################################################################################

# 既存の委任管理者アカウントをインポートする場合:
# terraform import aws_inspector2_delegated_admin_account.example <account-id>
#
# 例:
# terraform import aws_inspector2_delegated_admin_account.example 123456789012
#
# 注意:
# - インポート時は account_id のみが必要です
# - リージョンは現在のプロバイダー設定が使用されます
# - インポート後、terraform plan を実行して設定の差分を確認してください

################################################################################
# Validation Examples
################################################################################

# 委任管理者の状態を検証する出力
output "inspector_delegated_admin_status" {
  description = "Status of the Inspector2 delegated administrator"
  value = {
    account_id          = aws_inspector2_delegated_admin_account.example_basic.account_id
    relationship_status = aws_inspector2_delegated_admin_account.example_basic.relationship_status
  }
}

# 委任管理者が有効化されるまで待機する例
resource "null_resource" "wait_for_delegated_admin" {
  triggers = {
    status = aws_inspector2_delegated_admin_account.example_basic.relationship_status
  }

  provisioner "local-exec" {
    command = "echo 'Delegated admin status: ${aws_inspector2_delegated_admin_account.example_basic.relationship_status}'"
  }
}

################################################################################
# Common Patterns
################################################################################

# パターン 1: Organizations 統合との組み合わせ
# 組織の有効化と委任管理者の設定を順次実行
resource "aws_organizations_organization" "example" {
  aws_service_access_principals = [
    "inspector2.amazonaws.com"
  ]

  feature_set = "ALL"
}

resource "aws_inspector2_delegated_admin_account" "example" {
  account_id = var.security_account_id

  depends_on = [aws_organizations_organization.example]
}

# パターン 2: マルチリージョン展開
# 各リージョンで同じアカウントを委任管理者として設定
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu_west_1"
  region = "eu-west-1"
}

resource "aws_inspector2_delegated_admin_account" "us_east" {
  provider   = aws.us_east_1
  account_id = var.security_account_id
}

resource "aws_inspector2_delegated_admin_account" "eu_west" {
  provider   = aws.eu_west_1
  account_id = var.security_account_id
}

# パターン 3: 条件付き作成
# 特定の条件下でのみ委任管理者を設定
resource "aws_inspector2_delegated_admin_account" "conditional" {
  count = var.enable_inspector_delegated_admin ? 1 : 0

  account_id = var.security_account_id
}

################################################################################
# Related Resources
################################################################################

# aws_organizations_organization
# - Organizations の設定と統合
# - inspector2.amazonaws.com をサービスアクセスプリンシパルとして追加
#
# aws_inspector2_organization_configuration
# - 組織レベルの Inspector 設定
# - 自動有効化の設定
#
# aws_inspector2_enabler
# - 個別アカウントでの Inspector 有効化
# - スキャンタイプの設定
#
# aws_securityhub_organization_admin_account
# - Security Hub の委任管理者設定
# - Inspector との統合による統合的なセキュリティ管理

################################################################################
# Variables Example
################################################################################

variable "security_account_id" {
  description = "AWS account ID to be designated as the Inspector2 delegated administrator"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.security_account_id))
    error_message = "The security_account_id must be a valid 12-digit AWS account ID."
  }
}

variable "enable_inspector_delegated_admin" {
  description = "Whether to enable Inspector2 delegated administrator"
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "AWS region for Inspector2 delegated administrator"
  type        = string
  default     = "us-east-1"
}

################################################################################
# Outputs Example
################################################################################

output "inspector2_delegated_admin_account_id" {
  description = "Account ID of the Inspector2 delegated administrator"
  value       = aws_inspector2_delegated_admin_account.example_basic.account_id
}

output "inspector2_delegated_admin_status" {
  description = "Relationship status of the Inspector2 delegated administrator"
  value       = aws_inspector2_delegated_admin_account.example_basic.relationship_status
}

output "inspector2_delegated_admin_id" {
  description = "Identifier of the Inspector2 delegated administrator resource"
  value       = aws_inspector2_delegated_admin_account.example_basic.id
}

################################################################################
# Terraform Configuration
################################################################################

# Required Provider Configuration
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28.0"
    }
  }
}

# Provider configuration example
provider "aws" {
  region = var.aws_region

  # Assume role in the Organizations management account
  assume_role {
    role_arn     = "arn:aws:iam::${var.management_account_id}:role/OrganizationAccountAccessRole"
    session_name = "terraform-inspector2-setup"
  }
}

################################################################################
# End of Configuration Template
################################################################################
