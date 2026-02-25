#---------------------------------------------------------------
# AWS RAM - AWS Organizations との共有設定
#---------------------------------------------------------------
#
# AWS Resource Access Manager (RAM) の Organizations 共有機能を有効化する
# リソースです。この設定を有効にすることで、AWS Organizations 内のメンバー
# アカウントとリソースを招待なしに共有できるようになります。
#
# 有効化すると、管理アカウントに AWSServiceRoleForResourceAccessManager
# というサービスリンクロールが自動的に作成されます。
#
# 注意: このリソースを使用して Organizations 内の共有を管理してください。
#       aws_organizations_organization の aws_service_access_principals に
#       ram.amazonaws.com を設定する方法は非推奨です。
#
# AWS公式ドキュメント:
#   - RAM と Organizations の統合: https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-ram.html
#   - Organizations を使ったリソース共有: https://docs.aws.amazon.com/ram/latest/userguide/getting-started-sharing.html
#   - EnableSharingWithAwsOrganization API: https://docs.aws.amazon.com/ram/latest/APIReference/API_EnableSharingWithAwsOrganization.html
#   - サービスリンクロール: https://docs.aws.amazon.com/ram/latest/userguide/security-iam-service-linked-roles.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_sharing_with_organization
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ram_sharing_with_organization" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースの識別子を指定します。通常は省略し、AWS が自動的に割り当てます。
  # 設定可能な値: AWS アカウント ID の文字列
  # 省略時: AWS が自動的にアカウント ID を割り当てます。
  # 注意: 通常このフィールドを明示的に指定する必要はありません。
  # id = null

  # 前提条件:
  #   - 実行する IAM ユーザー/ロールが管理アカウント (Management Account) に存在すること
  #   - AWS Organizations が有効化されていること
  #
  # 有効化後の動作:
  #   - Organizations 内のプリンシパルはリソース共有への招待なしでアクセス可能になります
  #   - AWSServiceRoleForResourceAccessManager サービスリンクロールが自動作成されます
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWS アカウント ID
#---------------------------------------------------------------
