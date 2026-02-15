# Terraform resource: aws_cloudtrail_organization_delegated_admin_account
# Provider Version: 6.28.0
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudtrail_organization_delegated_admin_account
#
# NOTE: このテンプレートは学習・参照用です。実際の環境に合わせて必要な設定のみを使用してください。
#
# AWS CloudTrail 組織の委任管理者アカウント
#
# このリソースは、AWS Organizations 内で CloudTrail の委任管理者アカウントを登録・管理します。
# 委任管理者は組織全体の CloudTrail トレイルやイベントデータストアを代理で管理できるアカウントです。
# 管理アカウントは委任管理者が作成したすべてのリソースの所有権を保持し、最大3つまでの委任管理者を設定可能です。

resource "aws_cloudtrail_organization_delegated_admin_account" "example" {
  #---------------------------------------
  # 必須設定
  #---------------------------------------

  # account_id - 委任管理者として指定する AWS アカウント ID
  # 設定内容: 組織メンバーアカウントの12桁のアカウント ID
  # 設定可能な値: 組織に所属する有効なメンバーアカウント ID (12桁の数字)
  # 省略時: 設定必須 (Required)
  account_id = "123456789012"
}

#---------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------

# arn - 委任管理者アカウントの ARN
# email - 委任管理者アカウントに関連付けられたメールアドレス
# id - リソース ID (account_id と同じ値)
# name - 委任管理者アカウントのフレンドリ名
# service_principal - CloudTrail サービスプリンシパル名
