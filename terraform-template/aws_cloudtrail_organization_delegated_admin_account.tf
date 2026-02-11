# =============================================================================
# AWS CloudTrail Organization Delegated Admin Account
# =============================================================================
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点の情報です。
# 最新の仕様については公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail_organization_delegated_admin_account
# =============================================================================

resource "aws_cloudtrail_organization_delegated_admin_account" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # account_id - (Required) AWS組織のメンバーアカウントID
  # CloudTrailの委任管理者として指定するアカウントのIDを設定します。
  # このアカウントは、組織内のCloudTrailリソース（証跡やイベントデータストア）を
  # 組織の代理で管理できるようになります。
  #
  # 制約:
  # - 12桁のAWSアカウントIDを指定する必要があります
  # - 組織内の既存のメンバーアカウントである必要があります
  # - 管理アカウント自体は委任管理者として指定できません
  # - 組織は最大3つまでCloudTrail委任管理者を持つことができます
  #
  # 注意:
  # - このリソースは組織の管理アカウントから実行する必要があります
  # - 委任管理者を追加する際、CloudTrailはサービスリンクロールの存在を確認し、
  #   存在しない場合は自動的に作成します
  # - 委任管理者によって作成されたCloudTrailリソースの所有権は管理アカウントに
  #   残ります
  #
  # AWS CLI例:
  # aws cloudtrail register-organization-delegated-admin \
  #   --member-account-id 123456789012
  #
  # 参考:
  # - CloudTrail委任管理者について:
  #   https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-delegated-administrator.html
  # - 委任管理者の追加方法:
  #   https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-add-delegated-administrator.html
  # - RegisterOrganizationDelegatedAdmin API:
  #   https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_RegisterOrganizationDelegatedAdmin.html
  account_id = "123456789012"

  # ============================================================================
  # Computed Attributes (Read-Only)
  # ============================================================================
  # 以下の属性は自動的に設定されるため、設定不要です:
  #
  # - arn: 委任管理者アカウントのAmazon Resource Name (ARN)
  # - email: 委任管理者のAWSアカウントに関連付けられたメールアドレス
  # - id: リソースID（account_idと同じ値）
  # - name: 委任管理者アカウントのフレンドリー名
  # - service_principal: AWS CloudTrailサービスプリンシパル名
}

# =============================================================================
# 使用例
# =============================================================================

# 例1: 基本的な使用方法
resource "aws_cloudtrail_organization_delegated_admin_account" "basic" {
  account_id = "123456789012"
}

# 例2: data sourceを使用して動的にアカウントIDを取得
# 別のプロバイダーでメンバーアカウントの情報を取得する場合
resource "aws_cloudtrail_organization_delegated_admin_account" "delegated" {
  account_id = data.aws_caller_identity.delegated.account_id
}

data "aws_caller_identity" "delegated" {
  provider = aws.cloudtrail_delegate_account
}

# 別プロバイダーの設定例（認証情報の設定は省略）
# provider "aws" {
#   alias = "cloudtrail_delegate_account"
#   # authentication arguments
# }

# =============================================================================
# 補足情報
# =============================================================================
#
# 【必要な権限】
# このリソースを作成するには、以下のIAM権限が必要です:
# - cloudtrail:RegisterOrganizationDelegatedAdmin
# - organizations:RegisterDelegatedAdministrator
# - organizations:DescribeOrganization
# - iam:CreateServiceLinkedRole (初回のみ)
#
# 【委任管理者ができること】
# - 組織全体のCloudTrail証跡の作成と管理
# - 組織全体のイベントデータストアの作成と管理
# - CloudTrailイベントのクエリと分析
#
# 【管理アカウントとの違い】
# - 委任管理者が作成したリソースの所有権は管理アカウントに残る
# - 委任管理者の削除は管理アカウントからのみ可能
# - 組織の信頼されたアクセスの有効化/無効化は管理アカウントからのみ可能
#
# 【削除について】
# このリソースを削除すると、指定されたアカウントから委任管理者権限が削除されます。
# AWS CLI: aws cloudtrail deregister-organization-delegated-admin \
#   --delegated-admin-account-id 123456789012
#
# 【組織の要件】
# - AWS Organizationsが有効である必要があります
# - 組織は「すべての機能」モードである必要があります
# - CloudTrailの信頼されたアクセスが有効である必要があります
#
# 【制限事項】
# - 1つの組織につき最大3つまで委任管理者を登録可能
# - 管理アカウント自体は委任管理者として指定不可
#
# 参考リンク:
# - AWS Organizations と CloudTrail の統合:
#   https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-cloudtrail.html
# - 委任管理者の削除:
#   https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-remove-delegated-administrator.html
