#---------------------------------------------------------------
# IAM User Policy Attachment
#---------------------------------------------------------------
#
# IAMユーザーにマネージドポリシーをアタッチするリソース。
# AWS管理ポリシーまたはカスタマー管理ポリシーをIAMユーザーに関連付けることで、
# ユーザーに対する権限を付与します。
#
# 重要な注意事項:
# - このリソースは aws_iam_policy_attachment リソースと競合します。
#   両方を同時に使用すると永続的な差分が表示されます。
# - マネージドポリシー（AWS管理またはカスタマー管理）のアタッチに使用します。
# - インラインポリシーを埋め込む場合は aws_iam_user_policy を使用してください。
#
# AWS公式ドキュメント:
#   - AttachUserPolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_AttachUserPolicy.html
#   - マネージドポリシーとインラインポリシー: https://docs.aws.amazon.com/IAM/latest/UserGuide/policies-managed-vs-inline.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_user_policy_attachment" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # user - IAMユーザーの名前（フレンドリー名、ARNではない）
  # Type: string (required)
  # ポリシーをアタッチするIAMユーザーの名前を指定します。
  # 1〜64文字の英数字、記号（_+=,.@-）を使用できます。
  # 例: "developer-user", "admin.user"
  user = "example-user"

  # policy_arn - アタッチするIAMポリシーのARN
  # Type: string (required)
  # アタッチするマネージドポリシーのARNを指定します。
  # AWS管理ポリシーまたはカスタマー管理ポリシーのARNを指定できます。
  # ARNの形式: arn:aws:iam::aws:policy/PolicyName (AWS管理ポリシー)
  #           arn:aws:iam::123456789012:policy/PolicyName (カスタマー管理ポリシー)
  # 例: "arn:aws:iam::aws:policy/ReadOnlyAccess"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # id - リソースID（通常は指定不要）
  # Type: string (optional, computed)
  # Terraform管理用のリソースIDです。
  # 通常は自動的に生成されるため、明示的に指定する必要はありません。
  # 形式: <user>/<policy_arn>
  # id = "example-user/arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
# このリソースはcomputed属性を持ちません。
# idのみが利用可能ですが、これはoptionalでもあるため上記に記載しています。

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のIAMユーザーポリシーアタッチメントは以下の形式でインポートできます:
# terraform import aws_iam_user_policy_attachment.example user-name/arn:aws:iam::123456789012:policy/policy-name
#
# 例:
# terraform import aws_iam_user_policy_attachment.example developer-user/arn:aws:iam::aws:policy/ReadOnlyAccess
