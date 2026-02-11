#---------------------------------------------------------------
# Amazon Macie Organization Configuration
#---------------------------------------------------------------
#
# AWS Organizationsの組織におけるAmazon Macieの設定を管理するリソースです。
# このリソースを使用すると、AWS Organizationsに新しく追加されたアカウントに対して
# Amazon Macieを自動的に有効化するかどうかを設定できます。
#
# AWS公式ドキュメント:
#   - Integrating and configuring an organization in Macie: https://docs.aws.amazon.com/macie/latest/user/accounts-mgmt-ao-integrate.html
#   - Managing multiple Macie accounts with AWS Organizations: https://docs.aws.amazon.com/macie/latest/user/accounts-mgmt-ao.html
#   - AWS Organizations - Macie Configuration: https://docs.aws.amazon.com/macie/latest/APIReference/admin-configuration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/macie2_organization_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_macie2_organization_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # auto_enable (Required)
  # 設定内容: AWS Organizationsに追加されたアカウントに対してAmazon Macieを自動的に有効化するかを指定します。
  # 設定可能な値:
  #   - true: 組織に新しく追加されたアカウントでMacieを自動的に有効化します
  #   - false: 組織に新しく追加されたアカウントでMacieを自動的に有効化しません
  # 関連機能: AWS Organizations統合
  #   委任されたMacie管理者アカウントは、この設定を使用して新しいアカウントが組織に
  #   追加されたときにMacieを自動的に有効化し、メンバーアカウントとして関連付けることができます。
  #   自動有効化により、新しいアカウントは指定されたリージョンでMacieが有効になり、
  #   委任管理者アカウントと関連付けられます。
  #   - https://docs.aws.amazon.com/macie/latest/user/accounts-mgmt-ao-integrate.html
  # 注意: この設定は新しく追加されるアカウントにのみ適用されます。
  #       既存のアカウントを追加する場合は、手動で追加する必要があります。
  auto_enable = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Macie管理者の指定は、リージョナルな指定です。つまり、Macie管理者は
  #       指定されたリージョンでのみメンバーアカウントのMacieを管理できます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# 前提条件と使用上の注意
#---------------------------------------------------------------
# このリソースを使用する前に、以下の前提条件を満たす必要があります:
#
# 1. AWS Organizations統合:
#    - AWS OrganizationsでMacieの信頼されたアクセスを有効化する必要があります
#    - 管理アカウントが委任Macie管理者アカウントを指定する必要があります
#
# 2. 必要な権限:
#    - macie2:EnableOrganizationAdminAccount
#    - organizations:DescribeOrganization
#    - organizations:EnableAWSServiceAccess
#    - organizations:ListAWSServiceAccessForOrganization
#    - organizations:RegisterDelegatedAdministrator
#
# 3. 管理者アカウントの制約:
#    - 組織には1つの委任Macie管理者アカウントのみを設定できます
#    - 管理者アカウントは、最大10,000のメンバーアカウントと関連付けることができます
#    - 1つのアカウントは、1つのMacie管理者アカウントとのみ関連付けることができます
#
# 4. 自動有効化の動作:
#    - auto_enableをtrueに設定した場合、新しいアカウントが組織に追加されると:
#      - 指定されたリージョンでMacieが有効化されます
#      - アカウントは委任管理者アカウントとメンバーアカウントとして関連付けられます
#    - 既存のアカウントについては、手動で追加する必要があります
#
# 5. リージョナルな設定:
#    - この設定は指定されたリージョンでのみ適用されます
#    - 複数のリージョンでMacieを使用する場合は、各リージョンで個別に設定が必要です
#
# 参考:
#   - https://docs.aws.amazon.com/macie/latest/user/accounts-mgmt-ao-notes.html
#   - https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-macie.html
#---------------------------------------------------------------
