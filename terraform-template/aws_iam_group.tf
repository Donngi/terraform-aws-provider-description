#---------------------------------------------------------------
# AWS IAM Group
#---------------------------------------------------------------
#
# AWS IAM (Identity and Access Management) のグループをプロビジョニングするリソースです。
# IAMグループはIAMユーザーの集合であり、グループにポリシーをアタッチすることで
# グループ内のすべてのユーザーに同じ権限を一括付与できます。
#
# AWS公式ドキュメント:
#   - IAM グループ概要: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html
#   - IAM グループの作成: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups_create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: IAMグループの名前を指定します。
  # 設定可能な値: 大文字・小文字の英数字および以下の記号: =,.@-_.
  #   スペースは使用不可。グループ名は大文字・小文字を区別しません。
  #   例えば、"ADMINS"と"admins"という名前のグループは同時に作成できません。
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups_create.html
  name = "developers"

  #-------------------------------------------------------------
  # パス設定
  #-------------------------------------------------------------

  # path (Optional)
  # 設定内容: IAMグループを作成するパスを指定します。
  #   IAMのパス機能により、グループをディレクトリ階層で整理できます。
  # 設定可能な値: スラッシュ(/)で始まりスラッシュで終わる文字列
  #   例: "/", "/users/", "/division_abc/subdivision_xyz/"
  # 省略時: "/" (ルートパス)
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-friendly-names
  path = "/users/"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AWSによって割り当てられたグループのARN
#         例: arn:aws:iam::123456789012:group/developers
#
# - unique_id: AWSによって割り当てられたグループの一意のID
#              例: AGPAIOSFODNN7EXAMPLE
#---------------------------------------------------------------
