#---------------------------------------------------------------
# AWS Audit Manager Organization Admin Account Registration
#---------------------------------------------------------------
#
# AWS Audit Manager の組織管理者アカウント登録をプロビジョニングするリソースです。
# このリソースを使用すると、AWS Organizations 内の特定のアカウントを
# Audit Manager の委任管理者（Delegated Administrator）として指定できます。
# 委任管理者は、組織全体のAudit Manager評価を管理し、複数のアカウントにわたる
# エビデンスを統合することができます。
#
# AWS公式ドキュメント:
#   - 委任管理者の追加: https://docs.aws.amazon.com/audit-manager/latest/userguide/add-delegated-admin.html
#   - AWS Audit ManagerとAWS Organizations: https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-audit-manager.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/auditmanager_organization_admin_account_registration
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_auditmanager_organization_admin_account_registration" "example" {
  #-------------------------------------------------------------
  # 管理者アカウント設定
  #-------------------------------------------------------------

  # admin_account_id (Required)
  # 設定内容: 組織管理者として登録するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID（例: "123456789012"）
  # 注意事項:
  #   - AWS Organizationsの管理アカウントを委任管理者として指定することはできません
  #   - 複数のリージョンでAudit Managerを有効にする場合は、
  #     各リージョンで同じ委任管理者アカウントを指定する必要があります
  #   - 委任管理者を登録すると、管理アカウントはAudit Managerで
  #     評価を作成できなくなります
  admin_account_id = "123456789012"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 組織管理者アカウントの識別子（admin_account_idと同じ値）
#
# - organization_id: 組織の識別子
#---------------------------------------------------------------
