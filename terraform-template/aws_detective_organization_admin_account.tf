#---------------------------------------------------------------
# AWS Detective Organization Admin Account
#---------------------------------------------------------------
#
# AWS Detective Organization Admin Accountをプロビジョニングするリソースです。
# このリソースを使用するAWSアカウントはOrganizationsのプライマリアカウントである
# 必要があります。Detectiveで委任管理者アカウントを指定することで、
# 組織全体でDetectiveを管理できるようになります。
#
# AWS公式ドキュメント:
#   - Detective Organizations統合: https://docs.aws.amazon.com/detective/latest/adminguide/accounts-orgs-transition.html
#   - Detective管理者ガイド: https://docs.aws.amazon.com/detective/latest/adminguide/what-is-detective.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/detective_organization_admin_account
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 前提条件: AWS Organizations
#---------------------------------------------------------------
# Detective Organization Admin Accountを使用するには、
# 先にOrganizationsでDetectiveサービスアクセスを有効にする必要があります。

resource "aws_organizations_organization" "example" {
  aws_service_access_principals = ["detective.amazonaws.com"]
  feature_set                   = "ALL"
}

#---------------------------------------------------------------
# Detective Organization Admin Account
#---------------------------------------------------------------

resource "aws_detective_organization_admin_account" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # account_id (Required)
  # 設定内容: Detectiveの委任管理者として指定するAWSアカウントIDを指定します。
  # 設定可能な値: 有効な12桁のAWSアカウントID
  # 注意: 指定するアカウントは組織のメンバーアカウントである必要があります。
  #       組織のプライマリアカウント自体を指定することも可能です。
  # 関連機能: Detective委任管理者
  #   委任管理者アカウントは、組織内の他のアカウントのDetective
  #   メンバーシップを管理し、調査グラフにメンバーを招待できます。
  #   - https://docs.aws.amazon.com/detective/latest/adminguide/accounts-orgs-transition.html
  account_id = "123456789012"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 依存関係
  #-------------------------------------------------------------
  # AWS Organizationsでサービスアクセスが有効化されてから
  # このリソースを作成する必要があります。

  depends_on = [aws_organizations_organization.example]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSアカウント識別子
#---------------------------------------------------------------
