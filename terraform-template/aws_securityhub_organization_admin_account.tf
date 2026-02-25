#---------------------------------------------------------------
# AWS Security Hub Organization Admin Account
#---------------------------------------------------------------
#
# AWS OrganizationsのマネジメントアカウントにおいてSecurity Hubの
# 委任管理者アカウントを指定するリソースです。
# 指定されたアカウントがOrganization全体のSecurity Hub管理者となり、
# メンバーアカウントの有効化やセキュリティ設定の管理を行います。
#
# AWS公式ドキュメント:
#   - Security Hub 委任管理者の指定: https://docs.aws.amazon.com/securityhub/latest/userguide/designate-orgs-admin-account.html
#   - AWS Organizations と Security Hub の統合: https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-securityhub.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_organization_admin_account
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_organization_admin_account" "example" {
  #-------------------------------------------------------------
  # 管理者アカウント設定
  #-------------------------------------------------------------

  # admin_account_id (Required)
  # 設定内容: Security Hub の委任管理者として指定するAWSアカウントのIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 注意: このリソースを使用するAWSアカウントはOrganizationsのマネジメントアカウントである必要があります。
  #       マネジメントアカウント自身を委任管理者として指定することはできません。
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/designate-orgs-admin-account.html
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
# - id: 委任管理者として指定されたAWSアカウントID
#---------------------------------------------------------------
