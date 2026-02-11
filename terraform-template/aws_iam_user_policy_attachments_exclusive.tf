#---------------------------------------------------------------
# IAM User Policy Attachments Exclusive
#---------------------------------------------------------------
#
# IAMユーザーにアタッチされるマネージドポリシーの排他的管理を行うリソース。
# このリソースは、指定したIAMユーザーにアタッチされるマネージドポリシーを
# 完全に制御し、設定に含まれていないポリシーは自動的に削除されます。
#
# 重要な注意事項:
#   - このリソースは、IAMユーザーにアタッチされたマネージドポリシーの
#     排他的な所有権を持ちます
#   - 明示的に設定されていないマネージドポリシーは削除されます
#   - 他の aws_iam_user_policy_attachment リソースと併用する場合は、
#     それらのポリシーARNも policy_arns に含める必要があります
#   - このリソースを削除してもポリシーのデタッチは行われません
#     （Terraformによる管理の終了のみ）
#
# ユースケース:
#   - IAMユーザーのポリシーアタッチメントをTerraformで完全に管理したい場合
#   - 手動でアタッチされたポリシーを自動的に削除したい場合
#   - マネージドポリシーのアタッチメントを禁止したい場合（policy_arns = []）
#
# AWS公式ドキュメント:
#   - AttachUserPolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_AttachUserPolicy.html
#   - DetachUserPolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_DetachUserPolicy.html
#   - マネージドポリシーとインラインポリシー: https://docs.aws.amazon.com/IAM/latest/UserGuide/policies-managed-vs-inline.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_user_policy_attachments_exclusive
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_user_policy_attachments_exclusive" "example" {

  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # user_name - (Required) IAMユーザー名
  #
  # ポリシーアタッチメントを排他的に管理する対象のIAMユーザー名を指定します。
  # このユーザーにアタッチされているマネージドポリシーのうち、
  # policy_arns に含まれていないものは自動的に削除されます。
  #
  # - 型: string
  # - 文字制限: 1〜64文字
  # - 使用可能文字: 英数字、アンダースコア(_)、プラス(+)、等号(=)、
  #   カンマ(,)、ピリオド(.)、アットマーク(@)、ハイフン(-)
  # - フレンドリー名（ARNではない）を指定
  #
  # 重要:
  #   - 指定したユーザーは事前に存在している必要があります
  #   - aws_iam_user リソースの name 属性を参照することが推奨されます
  #
  # 例:
  #   user_name = "developers"
  #   user_name = aws_iam_user.example.name
  user_name = aws_iam_user.example.name

  # policy_arns - (Required) マネージドポリシーARNのリスト
  #
  # IAMユーザーにアタッチするマネージドポリシーのARNをセットで指定します。
  # ここに含まれていないポリシーは、既にユーザーにアタッチされていても
  # 自動的に削除されます。
  #
  # - 型: set(string)
  # - 空のセット [] を指定することで、すべてのマネージドポリシーを
  #   ユーザーから削除できます（マネージドポリシーを一切許可しない設定）
  # - インラインポリシーは対象外（このリソースでは管理されません）
  #
  # 特徴:
  #   - AWS管理ポリシーとカスタマー管理ポリシーの両方を指定可能
  #   - aws_iam_policy リソースの arn 属性を参照することが推奨されます
  #   - 重複したARNは自動的に正規化されます
  #
  # 注意事項:
  #   - aws_iam_user_policy_attachment リソースを併用している場合、
  #     そのポリシーARNもこのリストに含める必要があります
  #   - 含めない場合、永続的なドリフトが発生します
  #   - このリソースで管理するポリシーを aws_iam_user_policy_attachment で
  #     同時に管理しないでください（競合が発生します）
  #
  # 例（複数ポリシーのアタッチ）:
  #   policy_arns = [
  #     "arn:aws:iam::aws:policy/ReadOnlyAccess",
  #     "arn:aws:iam::123456789012:policy/custom-policy",
  #     aws_iam_policy.example.arn
  #   ]
  #
  # 例（マネージドポリシーを一切許可しない）:
  #   policy_arns = []
  policy_arns = [
    aws_iam_policy.example.arn,
  ]

}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
#
# このリソースには computed 専用の属性はありません。
# 標準属性（id など）は通常通り参照可能です。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: 基本的な使用方法
# IAMユーザーに特定のマネージドポリシーのみをアタッチ
resource "aws_iam_user" "developer" {
  name = "developer-user"
  path = "/developers/"
}

resource "aws_iam_user_policy_attachments_exclusive" "developer" {
  user_name = aws_iam_user.developer.name
  policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
}

# 例2: マネージドポリシーを一切許可しない設定
# セキュリティ要件で特定ユーザーにマネージドポリシーを
# アタッチさせたくない場合
resource "aws_iam_user" "restricted" {
  name = "restricted-user"
}

resource "aws_iam_user_policy_attachments_exclusive" "restricted" {
  user_name   = aws_iam_user.restricted.name
  policy_arns = [] # 空のリストでマネージドポリシーを禁止
}

# 例3: カスタムポリシーと AWS管理ポリシーの組み合わせ
resource "aws_iam_policy" "custom" {
  name        = "custom-developer-policy"
  description = "Custom policy for developers"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user" "team_member" {
  name = "team-member"
}

resource "aws_iam_user_policy_attachments_exclusive" "team_member" {
  user_name = aws_iam_user.team_member.name
  policy_arns = [
    aws_iam_policy.custom.arn,
    "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
  ]
}

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# 既存のIAMユーザーのポリシーアタッチメント設定を
# インポートすることができます。
#
# インポート構文:
#   terraform import aws_iam_user_policy_attachments_exclusive.example user-name
#
# 例:
#   terraform import aws_iam_user_policy_attachments_exclusive.developer developer-user
#
# 注意:
#   インポート後、現在アタッチされているすべてのマネージドポリシーが
#   Terraform管理下に入ります。policy_arns に含まれていないポリシーは
#   次回の apply で削除されるため、インポート前に現在の状態を確認し、
#   必要なポリシーをすべて設定に含めてください。
#
#---------------------------------------------------------------
