#---------------------------------------------------------------
# IAM Role Policy Attachment
#---------------------------------------------------------------
#
# IAMロールにAWS管理ポリシーまたはカスタマー管理ポリシーをアタッチする。
# このリソースは、既存のマネージドポリシーをIAMロールに関連付けて、
# ロールに権限を付与します。
#
# 注意事項:
#   - このリソースとaws_iam_policy_attachmentリソースを併用すると競合が発生します
#   - aws_iam_roleリソースのmanaged_policy_arns引数とも互換性がありません
#   - 両方を使用すると、Terraformが永続的な差分を表示します
#
# AWS公式ドキュメント:
#   - AttachRolePolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_AttachRolePolicy.html
#   - IAM ロールへのポリシーのアタッチ: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-attach-detach.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # role - (Required) IAMロールの名前
  # アタッチ先のIAMロール名を指定します。
  # ロールのARNではなく、ロール名を指定する必要があります。
  #
  # 例: "MyApplicationRole", "LambdaExecutionRole"
  #
  # Type: string
  role = "example-role"

  # policy_arn - (Required) アタッチするIAMポリシーのARN
  # AWS管理ポリシーまたはカスタマー管理ポリシーのARNを指定します。
  # インラインポリシーには使用できません（インラインポリシーにはaws_iam_role_policyを使用）。
  #
  # AWS管理ポリシーの例:
  #   - "arn:aws:iam::aws:policy/ReadOnlyAccess"
  #   - "arn:aws:iam::aws:policy/PowerUserAccess"
  #
  # カスタマー管理ポリシーの例:
  #   - "arn:aws:iam::123456789012:policy/MyCustomPolicy"
  #
  # Type: string
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # id - (Optional) リソースの識別子
  # 通常は指定不要です。指定しない場合、Terraformが自動的に生成します。
  # フォーマット: "{role}/{policy_arn}"
  #
  # Type: string
  # Computed: true (自動生成される)
  # id = "example-role/arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの一意の識別子（フォーマット: "{role}/{policy_arn}"）
#
# これらの属性は他のリソースで参照可能です:
#   aws_iam_role_policy_attachment.example.id
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# IAMロールポリシーアタッチメントは以下の形式でインポートできます:
#
# terraform import aws_iam_role_policy_attachment.example role-name/arn:aws:iam::123456789012:policy/policy-name
#
# 例:
# terraform import aws_iam_role_policy_attachment.example MyRole/arn:aws:iam::aws:policy/ReadOnlyAccess
#
#---------------------------------------------------------------
