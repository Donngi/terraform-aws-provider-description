#---------------------------------------------------------------
# IAM Group
#---------------------------------------------------------------
#
# Provides an IAM group resource for managing collections of IAM users.
# IAM user groups allow you to specify permissions for multiple users,
# making it easier to manage permissions for those users collectively.
#
# AWS公式ドキュメント:
#   - IAM user groups: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html
#   - View IAM groups: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups_manage_list.html
#   - Delete an IAM group: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups_manage_delete.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_group" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # name - (Required) グループ名
  # グループ名は、大文字と小文字の英数字（スペースなし）で構成する必要があります。
  # 以下の文字も含めることができます: =,.@-_.
  # グループ名は大文字小文字を区別しません。例えば、"ADMINS"と"admins"という
  # 両方の名前のグループを作成することはできません。
  name = "developers"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # path - (Optional) グループを作成するIAM内のパス
  # デフォルトは"/"です。パスはスラッシュ（/）で始まり、スラッシュで終わる必要があります。
  # パスを使用してグループを階層的に整理できます。
  # 例: "/division/department/group-name/"
  path = "/users/"

  # id - (Optional) グループID
  # 通常は明示的に指定する必要はありません。未指定の場合、グループ名がIDとして使用されます。
  # このフィールドは主に計算された値として使用されます。
  # id = "custom-group-id"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは、上記の引数に加えて以下の属性をエクスポートします:
#
# arn - AWSによってこのグループに割り当てられたARN
#       例: arn:aws:iam::123456789012:group/developers
#
# unique_id - AWSによって割り当てられた一意のID
#       これはAWSがグループに割り当てる一意の識別子です。
#
# 注意事項:
# - グループにはユーザーを追加するために、aws_iam_group_membershipまたは
#   aws_iam_user_group_membershipリソースを使用できます。
# - コンソールで手動でユーザー/グループのメンバーシップを管理しながら
#   これらのリソースを使用すると、設定のドリフトや競合が発生する可能性があります。
# - メンバーシップは完全にTerraformで管理するか、完全にAWSコンソール内で
#   管理することを推奨します。
#---------------------------------------------------------------
