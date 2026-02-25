#---------------------------------------------------------------
# AWS IAM User Policy Attachment
#---------------------------------------------------------------
#
# IAMユーザーにマネージドIAMポリシーをアタッチするリソースです。
# ユーザーに対してAWS管理ポリシーまたはカスタマー管理ポリシーを
# 直接アタッチすることで、ユーザーに権限を付与します。
#
# 注意: このリソースは aws_iam_policy_attachment リソースと競合します。
#       両方を同時に定義すると、差分が永続的に表示されます。
#       グループやロールへの一括アタッチには aws_iam_policy_attachment を
#       使用し、ユーザー個別のアタッチには本リソースを使用してください。
#
# AWS公式ドキュメント:
#   - IAMマネージドポリシーのアタッチ: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-using.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_user_policy_attachment" "example" {
  #-------------------------------------------------------------
  # ユーザー設定
  #-------------------------------------------------------------

  # user (Required)
  # 設定内容: ポリシーをアタッチするIAMユーザーの名前を指定します。
  # 設定可能な値: 既存のIAMユーザー名の文字列
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html
  user = "example-user"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy_arn (Required)
  # 設定内容: アタッチするIAMマネージドポリシーのARNを指定します。
  # 設定可能な値: AWS管理ポリシーまたはカスタマー管理ポリシーのARN
  #   - AWS管理ポリシー例: "arn:aws:iam::aws:policy/ReadOnlyAccess"
  #   - カスタマー管理ポリシー例: "arn:aws:iam::123456789012:policy/MyPolicy"
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アタッチメントの識別子。"{user_name}/{policy_arn}" の形式で自動生成されます。
#---------------------------------------------------------------
