#---------------------------------------------------------------
# IAM Account Alias
#---------------------------------------------------------------
#
# AWS アカウントのエイリアスを管理します。アカウントエイリアスを設定すると、
# AWS マネジメントコンソールのサインイン URL に、アカウント ID の代わりに
# わかりやすい名前を使用できます。
#
# 重要な注意事項:
#   - 1つの AWS アカウントにつき、設定できるアカウントエイリアスは1つのみです
#   - アカウントエイリアスは AWS アカウント全体でグローバルに一意である必要があります
#   - サインイン URL: https://{account_alias}.signin.aws.amazon.com/console
#
# AWS公式ドキュメント:
#   - Creating an account alias: https://docs.aws.amazon.com/IAM/latest/UserGuide/account-alias-create.html
#   - IAM User Guide: https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_alias
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_account_alias" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # account_alias - (Required) AWS アカウントのエイリアス名
  #
  # 説明:
  #   - AWS マネジメントコンソールのサインイン URL で使用されるエイリアス名
  #   - AWS アカウント全体でグローバルに一意である必要があります
  #   - 3～63文字の英数字、ハイフン(-)で構成可能
  #   - 英小文字、数字、ハイフンのみ使用可能（大文字は使用不可）
  #   - 先頭と末尾はハイフン以外の文字である必要があります
  #
  # 例:
  #   - "my-company-production"
  #   - "acme-dev-account"
  #   - "my-org-staging"
  #
  # 注意事項:
  #   - 既に使用されているエイリアスは設定できません
  #   - 設定後、サインイン URL は https://{account_alias}.signin.aws.amazon.com/console となります
  #   - 1つのアカウントに設定できるエイリアスは1つのみです（このリソースを更新すると既存のエイリアスが上書きされます）
  #
  account_alias = "my-account-alias"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性は Terraform によって自動的に設定されます（読み取り専用）:
#
# - id - アカウントエイリアス名（account_alias と同じ値）
#
#---------------------------------------------------------------
