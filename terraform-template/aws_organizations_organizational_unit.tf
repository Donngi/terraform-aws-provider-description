#---------------------------------------------------------------
# AWS Organizations Organizational Unit (OU)
#---------------------------------------------------------------
#
# AWS Organizations内に組織単位（OU）を作成・管理します。
# OUは、アカウントをグループ化して階層構造を構成し、
# ポリシーを適用するための論理的な単位です。
#
# AWS公式ドキュメント:
#   - AWS Organizations User Guide: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous.html
#   - AWS Organizations API Reference (CreateOrganizationalUnit): https://docs.aws.amazon.com/organizations/latest/APIReference/API_CreateOrganizationalUnit.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_organizations_organizational_unit" "example" {
  # ---------------------------------------------------------------
  # 必須パラメータ
  # ---------------------------------------------------------------

  # 組織単位の名前
  # - 同じ親の下で一意である必要があります
  # - 最大長: 128文字
  name = "example-ou"

  # 親の組織単位またはルートのID
  # - 組織のルートIDまたは親OUのIDを指定します
  # - aws_organizations_organization.example.roots[0].id でルートIDを参照可能
  parent_id = "r-xxxx"

  # ---------------------------------------------------------------
  # オプションパラメータ
  # ---------------------------------------------------------------

  # リソースタグ
  # - key-value形式のマップでタグを指定します
  # - プロバイダーレベルのdefault_tagsと組み合わせて使用できます
  # - タグを使用して、コスト配分やリソース管理を行うことができます
  tags = {
    Name        = "example-ou"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # 全てのタグ（プロバイダーのdefault_tagsを含む）
  # - 通常はtags属性の使用を推奨します
  # - この属性は、プロバイダーレベルのdefault_tagsを上書きする必要がある場合にのみ使用します
  # - 設定しない場合は、tagsとdefault_tagsがマージされた値が自動的に設定されます
  # tags_all = {}

  # ---------------------------------------------------------------
  # Computed Attributes (参照のみ可能な属性)
  # ---------------------------------------------------------------
  # 以下の属性は、リソース作成後に参照可能です:
  #
  # - arn         : 組織単位のARN
  # - id          : 組織単位のID (ou-xxxx-xxxxxxxx形式)
  # - accounts    : この組織単位の直下にある子アカウントのリスト
  #                 各要素には以下の属性が含まれます:
  #                 * arn   : アカウントのARN
  #                 * email : アカウントのメールアドレス
  #                 * id    : アカウントID
  #                 * name  : アカウント名
  #                 注意: 子OUのアカウント情報は含まれません
  # - tags_all    : リソースに割り当てられた全タグ（プロバイダーのdefault_tagsを含む）
  #
  # 参照例:
  # - aws_organizations_organizational_unit.example.arn
  # - aws_organizations_organizational_unit.example.id
  # - aws_organizations_organizational_unit.example.accounts
}
