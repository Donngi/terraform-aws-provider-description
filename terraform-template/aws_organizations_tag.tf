#---------------------------------------------------------------
# AWS Organizations Tag
#---------------------------------------------------------------
#
# AWS Organizations のリソース（アカウント、組織単位、ポリシー、ルート）に対して
# 個別タグを管理するリソースです。Terraform 外部（AWS Control Tower 等）で
# 作成された Organizations リソースへのタグ付けに適しています。
#
# 注意: 同一リソースを管理する Terraform リソース（例: aws_organizations_account）と
#       組み合わせる場合は、親リソース側の lifecycle ブロックに
#       ignore_changes = [tags] を設定してください。
#       また、このリソースはプロバイダーの ignore_tags 設定を使用しません。
#
# AWS公式ドキュメント:
#   - AWS Organizations タグ付け: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tagging.html
#   - タグの追加・更新・削除: https://docs.aws.amazon.com/organizations/latest/userguide/add-tag.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/organizations_tag
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_organizations_tag" "example" {
  #-------------------------------------------------------------
  # 対象リソース設定
  #-------------------------------------------------------------

  # resource_id (Required)
  # 設定内容: タグを付与する Organizations リソースの ID を指定します。
  # 設定可能な値:
  #   - AWSアカウントID（例: 123456789012）
  #   - 組織単位（OU）ID（例: ou-xxxx-xxxxxxxx）
  #   - ポリシーID（例: p-xxxxxxxxxxxxxxxx）
  #   - ルートID（例: r-xxxx）
  # 参考: https://docs.aws.amazon.com/organizations/latest/APIReference/API_TagResource.html
  resource_id = "ou-xxxx-xxxxxxxx"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # key (Required)
  # 設定内容: タグのキー名を指定します。
  # 設定可能な値: 最大128文字の文字列。大文字・小文字を区別します。
  # 参考: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tagging.html
  key = "Environment"

  # value (Required)
  # 設定内容: タグの値を指定します。
  # 設定可能な値: 最大256文字の文字列。大文字・小文字を区別します。
  # 参考: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tagging.html
  value = "production"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Organizations リソース ID とタグキーをカンマ区切りで結合した識別子
#       （例: ou-xxxx-xxxxxxxx,Environment）
#---------------------------------------------------------------
