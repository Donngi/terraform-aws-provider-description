#---------------------------------------------------------------
# IAM Policy Attachment
#---------------------------------------------------------------
#
# IAMポリシーをユーザー、ロール、グループにアタッチする
#
# ⚠️ 重要な注意事項:
# このリソースはIAMポリシーの排他的(exclusive)アタッチメントを作成します。
# AWSアカウント全体で、単一のポリシーにアタッチされる全てのユーザー/ロール/グループは、
# 単一のaws_iam_policy_attachmentリソースで宣言する必要があります。
# 他の手段（他のTerraformリソースを含む）でアタッチされたポリシーも、
# このリソースによって取り消されます。
#
# 代替案として、以下のリソースの使用を検討してください:
# - aws_iam_role_policy_attachment
# - aws_iam_user_policy_attachment
# - aws_iam_group_policy_attachment
# これらのリソースは排他的アタッチメントを強制しません。
#
# AWS公式ドキュメント:
#   - AttachUserPolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_AttachUserPolicy.html
#   - IAMポリシーの管理: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-attach-detach.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_policy_attachment" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # アタッチメントの名前
  # この名前はアタッチメントを識別するために使用されます。
  #
  # 型: string
  # 必須: true
  name = "example-policy-attachment"

  # アタッチするIAMポリシーのARN
  # マネージドポリシー（AWS管理またはカスタマー管理）のARNを指定します。
  #
  # ⚠️ 重要: 依存関係を正しく管理するため、ARNを直接構築するのではなく、
  # IAMリソースへの参照を使用してください。
  # 推奨: policy_arn = aws_iam_policy.example.arn
  # 非推奨: policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/Example"
  #
  # 型: string
  # 必須: true
  policy_arn = aws_iam_policy.example.arn

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # ポリシーをアタッチするIAMグループ名のセット
  # グループ名（ARNではない）を指定します。
  #
  # 注意: このリソースで指定したグループ以外で同じポリシーがアタッチされている場合、
  # そのアタッチメントは削除されます（排他的制御）。
  #
  # 型: set(string)
  # 必須: false
  groups = [
    # "example-group-1",
    # "example-group-2",
  ]

  # ポリシーをアタッチするIAMロール名のセット
  # ロール名（ARNではない）を指定します。
  #
  # 注意: このリソースで指定したロール以外で同じポリシーがアタッチされている場合、
  # そのアタッチメントは削除されます（排他的制御）。
  #
  # また、aws_iam_roleリソースのmanaged_policy_arns引数との併用は非互換です。
  # 両方を使用すると、Terraformは永続的な差分を表示します。
  #
  # 型: set(string)
  # 必須: false
  roles = [
    # "example-role-1",
    # "example-role-2",
  ]

  # ポリシーをアタッチするIAMユーザー名のセット
  # ユーザー名（ARNではない）を指定します。
  #
  # 注意: このリソースで指定したユーザー以外で同じポリシーがアタッチされている場合、
  # そのアタッチメントは削除されます（排他的制御）。
  #
  # 型: set(string)
  # 必須: false
  users = [
    # "example-user-1",
    # "example-user-2",
  ]
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id (string)
#     ポリシーのID
#
# - name (string)
#     アタッチメントの名前
#
#---------------------------------------------------------------
