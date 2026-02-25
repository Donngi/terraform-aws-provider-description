#---------------------------------------------------------------
# AWS IAM User Group Membership
#---------------------------------------------------------------
#
# IAMユーザーをIAMグループに追加するリソースです。
# 同一ユーザーに対して重複しないグループを指定して複数回使用できます。
# グループ内のユーザーを排他的に管理する場合は aws_iam_group_membership を使用してください。
#
# AWS公式ドキュメント:
#   - IAM グループの概要: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html
#   - IAM ユーザーのグループへの追加: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups_manage_add-remove-users.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_user_group_membership" "example" {
  #-------------------------------------------------------------
  # ユーザー設定
  #-------------------------------------------------------------

  # user (Required)
  # 設定内容: グループに追加するIAMユーザーの名前を指定します。
  # 設定可能な値: 既存のIAMユーザー名の文字列
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html
  user = "example-user"

  #-------------------------------------------------------------
  # グループ設定
  #-------------------------------------------------------------

  # groups (Required)
  # 設定内容: ユーザーを追加するIAMグループ名のセットを指定します。
  # 設定可能な値: 既存のIAMグループ名の文字列セット
  # 注意: 同じユーザーに対して複数のリソースを使用する場合、
  #       グループは重複しないように指定する必要があります。
  #       グループを排他的に管理する場合は aws_iam_group_membership を使用してください。
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html
  groups = [
    "example-group-1",
    "example-group-2",
  ]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ユーザー名とグループ名から構成される一意の識別子
#---------------------------------------------------------------
