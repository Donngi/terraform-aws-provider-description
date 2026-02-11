#---------------------------------------------------------------
# AWS IAM Group Policy Attachments Exclusive
#---------------------------------------------------------------
#
# AWS IAM (Identity & Access Management) グループに対する管理ポリシーアタッチメントの
# 排他的管理を提供するTerraformリソースです。
#
# このリソースは、指定されたIAMグループに対する管理ポリシーの排他的所有権を持ちます。
# つまり、このリソースで明示的に設定されていない管理ポリシーは自動的に削除されます。
#
# 重要な注意点:
# - このリソースと並行して aws_iam_group_policy_attachment リソースを管理する場合、
#   永続的なドリフトを防ぐため、それらのポリシーARNを policy_arns 引数に含める必要があります。
# - このリソースを削除すると、Terraformは設定されたポリシーアタッチメントの調整を
#   管理しなくなりますが、設定されたポリシーをグループからデタッチすることはありません。
#
# AWS公式ドキュメント:
#   - IAM グループの概要: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html
#   - 管理ポリシーとインラインポリシー: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachments_exclusive
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_group_policy_attachments_exclusive" "example" {
  #-------------------------------------------------------------
  # グループ設定
  #-------------------------------------------------------------

  # group_name (Required)
  # 設定内容: 管理ポリシーアタッチメントを排他的に管理する対象のIAMグループ名を指定します。
  # 設定可能な値: 有効なIAMグループ名
  # 用途: このグループに対する管理ポリシーのアタッチメントを、このリソースで完全に制御します。
  # 関連機能: IAM グループ
  #   IAMグループは、IAMユーザーの集合を管理する単位です。グループに権限を付与することで、
  #   複数のユーザーに対して一括で権限を管理できます。
  #   - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html
  # 注意: 既存の aws_iam_group リソースの name 属性を参照することが一般的です。
  group_name = aws_iam_group.example.name

  #-------------------------------------------------------------
  # ポリシーアタッチメント設定
  #-------------------------------------------------------------

  # policy_arns (Required)
  # 設定内容: グループにアタッチする管理ポリシーのARNのリストを指定します。
  # 設定可能な値:
  #   - 管理ポリシーARNのセット（重複なし）
  #   - 空のリスト [] も指定可能（管理ポリシーの使用を完全に禁止する場合）
  # 排他的動作: このリストに含まれないポリシーは、グループから自動的に削除されます。
  # 関連機能: IAM 管理ポリシー
  #   AWS管理ポリシー（AWSが提供）またはカスタマー管理ポリシー（ユーザーが作成）を
  #   グループにアタッチすることで、グループメンバーに権限を付与します。
  #   管理ポリシーは複数のエンティティ（ユーザー、グループ、ロール）で再利用できます。
  #   - https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
  # 注意:
  #   - 空リストを指定すると、グループに管理ポリシーをアタッチしないことを強制します。
  #   - aws_iam_group_policy_attachment と併用する場合、そのポリシーもここに含める必要があります。
  # 参考:
  #   - AWS管理ポリシーのリスト: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html#aws-managed-policies
  policy_arns = [
    aws_iam_policy.example.arn,
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]

  # 例: 管理ポリシーの使用を完全に禁止する場合
  # policy_arns = []
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは設定可能な属性のみを持ち、エクスポートされる追加の読み取り専用属性はありません。
#---------------------------------------------------------------

#---------------------------------------------------------------
# resource "aws_iam_group" "example" {
#   name = "example-group"
# }
#
# resource "aws_iam_policy" "example" {
#   name        = "example-policy"
#   description = "Example policy"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = ["s3:ListBucket"]
#         Resource = ["arn:aws:s3:::example-bucket"]
#       }
#     ]
#   })
# }
#---------------------------------------------------------------
