#---------------------------------------------------------------
# IAM User Group Membership
#---------------------------------------------------------------
#
# IAMユーザーを1つ以上のIAMグループに追加するリソース。
# 同一ユーザーに対して複数回使用でき、重複しないグループへの
# 追加が可能です。
#
# グループ内のユーザーを排他的に管理する場合は、
# aws_iam_group_membershipリソースを使用してください。
#
# AWS公式ドキュメント:
#   - IAM グループへのユーザーの追加/削除: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups_manage_add-remove-users.html
#   - AddUserToGroup API: https://docs.aws.amazon.com/IAM/latest/UserGuide/iam_example_iam_AddUserToGroup_section.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_user_group_membership" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) グループに追加するIAMユーザーの名前
  # 既存のIAMユーザーを指定する必要があります
  # 例: "john.doe", "service-account-1"
  user = "example-user"

  # (Required) ユーザーを追加するIAMグループのリスト
  # 1つ以上のグループ名を指定します
  # 例: ["developers", "admins", "read-only-users"]
  groups = [
    "example-group-1",
    "example-group-2",
  ]

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) リソースID
  # 指定しない場合は自動的に生成されます
  # 通常は明示的に指定する必要はありません
  # id = "example-user/example-group"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子（computed）
#   形式: {user_name}/{group_names...}
#   自動的に生成されます
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Usage Examples
#---------------------------------------------------------------
#
# 例1: 単一ユーザーを複数グループに追加
#
# resource "aws_iam_user_group_membership" "developer_membership" {
#   user = aws_iam_user.developer.name
#
#   groups = [
#     aws_iam_group.developers.name,
#     aws_iam_group.readonly.name,
#   ]
# }
#
# 例2: 同じユーザーを異なるグループセットに追加（非重複）
#
# resource "aws_iam_user_group_membership" "admin_membership" {
#   user = aws_iam_user.developer.name
#
#   groups = [
#     aws_iam_group.admins.name,
#   ]
# }
#
# 注意事項:
# - 同じユーザーに対して複数のaws_iam_user_group_membershipリソースを
#   使用する場合、グループが重複しないようにしてください
# - グループメンバーシップを排他的に管理する場合は、
#   aws_iam_group_membershipリソースの使用を検討してください
#
#---------------------------------------------------------------
