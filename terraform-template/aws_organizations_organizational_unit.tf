#---------------------------------------------------------------
# AWS Organizations Organizational Unit
#---------------------------------------------------------------
#
# AWS Organizations 内の組織単位（OU）を管理するリソース。
# OU を利用することで、アカウントを階層的にグループ化し、
# サービスコントロールポリシー（SCP）や他のポリシーを一括適用できる。
#
# AWS公式ドキュメント:
#   - AWS Organizations とは: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html
#   - CreateOrganizationalUnit API: https://docs.aws.amazon.com/organizations/latest/APIReference/API_CreateOrganizationalUnit.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_organizations_organizational_unit" "example" {

  #---------------------------------------
  # 必須設定
  #---------------------------------------

  # 設定内容: 組織単位の名前
  # 設定可能な値: 1〜128文字の文字列
  name = "example-ou"

  # 設定内容: 親となる組織単位またはルートの ID
  # 設定可能な値: ルート ID (r-xxxx) または 組織単位 ID (ou-xxxx-xxxxxxxx)
  parent_id = "r-xxxx"

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # 設定内容: リソースに付与するタグ
  # 省略時: タグなし
  tags = {
    Name = "example-ou"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# id       - 組織単位の一意識別子
# arn      - 組織単位の ARN
# accounts - OU に直接属するアカウントの一覧（arn, email, id, name を含むオブジェクトのリスト）
