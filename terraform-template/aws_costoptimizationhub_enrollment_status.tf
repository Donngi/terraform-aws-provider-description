# ==============================================================================
# Terraform AWS Resource Template: aws_costoptimizationhub_enrollment_status
# ==============================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# NOTE: このテンプレートは生成時点(2026-01-19)の情報に基づいています。
#       最新の仕様や詳細については、必ず公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/costoptimizationhub_enrollment_status
# ==============================================================================

# ------------------------------------------------------------------------------
# Resource: aws_costoptimizationhub_enrollment_status
# ------------------------------------------------------------------------------
# AWS Cost Optimization Hub の登録ステータスを管理するリソース。
#
# Cost Optimization Hub は、複数のAWSアカウントとリージョンにわたるコスト最適化の
# 推奨事項を統合し、優先順位付けするためのサービスです。
# このリソースを使用して、アカウントのCost Optimization Hub への登録を管理します。
#
# 重要な注意点:
# - Cost Optimization Hub は us-east-1 エンドポイントのみを持ちますが、
#   AWS Provider を使用することで他のリージョンからもグローバルにアクセス可能です。
# - このリソースがTerraform構成に存在する場合、ステータスは常に "Active" になります。
# - リソースを削除すると、アカウントの登録が解除されます。
#
# AWS公式ドキュメント:
# - Getting started with Cost Optimization Hub:
#   https://docs.aws.amazon.com/cost-management/latest/userguide/coh-getting-started.html
# - UpdateEnrollmentStatus API:
#   https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_CostOptimizationHub_UpdateEnrollmentStatus.html
# - AWS Organizations integration:
#   https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-coh.html
# ------------------------------------------------------------------------------

resource "aws_costoptimizationhub_enrollment_status" "example" {
  # ----------------------------------------------------------------------------
  # include_member_accounts (オプション)
  # ----------------------------------------------------------------------------
  # Type: bool
  # Default: false
  #
  # 組織のメンバーアカウントを登録に含めるかどうかを指定するフラグ。
  # このアカウントが管理アカウント(Organizations management account)の場合にのみ有効です。
  #
  # - true: 組織内の全メンバーアカウントをCost Optimization Hubに自動的に登録します。
  #         この設定により、AWS Organizations の信頼されたアクセスが自動的に有効化されます。
  # - false: 現在のアカウントのみを登録します(デフォルト)。
  #
  # 注意事項:
  # - 現在、この引数に対するドリフト検出はサポートされていません。
  # - メンバーアカウントを含める場合、管理アカウントに Cost Optimization Hub の
  #   サービスリンクロール(AWSServiceRoleForCostOptimizationHub)が自動作成されます。
  # - 信頼されたアクセスを無効にすると、メンバーアカウントの推奨事項へのアクセスが拒否されます。
  #
  # 使用例:
  # - 組織全体でコスト最適化の推奨事項を一元管理したい場合: true
  # - 単一アカウントでのみ使用したい場合: false または省略
  #
  # 参考:
  # - Trusted Access: https://docs.aws.amazon.com/cost-management/latest/userguide/coh-trusted-access.html
  # - Delegated Administrator: https://docs.aws.amazon.com/cost-management/latest/userguide/coh-delegated-admin.html
  # ----------------------------------------------------------------------------
  include_member_accounts = false

  # ==============================================================================
  # Computed Attributes (読み取り専用 - 設定不要)
  # ==============================================================================
  # 以下の属性は自動的に計算され、出力として利用可能です:
  #
  # - id: リソースの識別子(文字列)
  # - status: 登録ステータス(文字列)
  #   このリソースがTerraform構成に存在する場合、常に "Active" となります。
  # ==============================================================================
}
