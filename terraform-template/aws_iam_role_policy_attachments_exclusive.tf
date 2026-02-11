#---------------------------------------------------------------
# IAM Role Policy Attachments Exclusive
#---------------------------------------------------------------
#
# IAMロールにアタッチされているマネージドポリシーの排他的管理を行う。
# このリソースは、指定されたIAMロールに対するマネージドポリシーのアタッチメントを
# 完全に制御し、Terraform外で追加されたポリシーを自動的に削除します。
#
# 重要な注意事項:
#   - このリソースは、ロールにアタッチされているマネージドポリシーの排他的所有権を取得します
#   - 明示的に設定されていないマネージドポリシーは削除されます
#   - aws_iam_role_policy_attachmentリソースを併用する場合、そのポリシーARNも
#     policy_arns引数に含める必要があります。含めない場合、永続的なドリフトが発生します
#   - このリソースの削除は、Terraformによる調整管理を停止するのみで、
#     設定されたポリシーはロールからデタッチされません
#
# 使用ケース:
#   - IAMロールのポリシーアタッチメントを厳密に管理したい場合
#   - 手動で追加されたポリシーを自動的に削除したい場合
#   - マネージドポリシーのアタッチメントを禁止したい場合（policy_arns = []）
#
# AWS公式ドキュメント:
#   - AttachRolePolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_AttachRolePolicy.html
#   - IAM ロールへのポリシーのアタッチ: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-attach-detach.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role_policy_attachments_exclusive
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_role_policy_attachments_exclusive" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # role_name - (Required) IAMロール名
  # マネージドポリシーアタッチメントを排他的に管理する対象のIAMロール名を指定します。
  # ロールのARNではなく、ロール名を指定する必要があります。
  #
  # 例: "MyApplicationRole", "LambdaExecutionRole"
  #
  # Type: string
  role_name = aws_iam_role.example.name

  # policy_arns - (Required) ロールにアタッチするマネージドIAMポリシーのARNのリスト
  # このロールにアタッチすることを許可するマネージドポリシーのARNを指定します。
  # ここに指定されていないポリシーがロールにアタッチされている場合、
  # Terraformは次回の適用時にそれらを削除します。
  #
  # 空のリスト([])を指定すると、すべてのマネージドポリシーのアタッチメントを禁止できます。
  #
  # AWS管理ポリシーの例:
  #   - "arn:aws:iam::aws:policy/ReadOnlyAccess"
  #   - "arn:aws:iam::aws:policy/PowerUserAccess"
  #
  # カスタマー管理ポリシーの例:
  #   - "arn:aws:iam::123456789012:policy/MyCustomPolicy"
  #
  # 注意: インラインポリシーは対象外です（インラインポリシーの管理には
  #       aws_iam_role_policyまたはaws_iam_role_policies_exclusiveを使用）
  #
  # Type: set(string)
  policy_arns = [
    aws_iam_policy.example.arn,
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]

  #---------------------------------------------------------------
  # マネージドポリシーのアタッチメントを禁止する例
  #---------------------------------------------------------------
  #
  # すべてのマネージドポリシーのアタッチメントを禁止したい場合は、
  # 空のリストを指定します:
  #
  # policy_arns = []
  #
  # この設定により、手動または他のツールでマネージドポリシーがアタッチされても、
  # Terraformが次回の適用時に自動的に削除します。
  #
  #---------------------------------------------------------------
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは明示的にエクスポートする属性はありませんが、
# 標準のリソース参照（aws_iam_role_policy_attachments_exclusive.example）
# として他のリソースから参照できます。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# IAMロールポリシーアタッチメント排他管理は以下の形式でインポートできます:
#
# terraform import aws_iam_role_policy_attachments_exclusive.example role-name
#
# 例:
# terraform import aws_iam_role_policy_attachments_exclusive.example MyApplicationRole
#
# インポート後、Terraformはロールに現在アタッチされているすべてのマネージドポリシーを
# 検出し、それらをpolicy_arns引数に追加する必要があります。
# 追加しない場合、次回のapply時にそれらのポリシーが削除されます。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 基本的な使用方法
#---------------------------------------------------------------
#
# resource "aws_iam_role" "example" {
#   name = "example-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
# }
#
# resource "aws_iam_policy" "example" {
#   name = "example-policy"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = ["s3:GetObject"]
#         Effect   = "Allow"
#         Resource = "*"
#       }
#     ]
#   })
# }
#
# resource "aws_iam_role_policy_attachments_exclusive" "example" {
#   role_name   = aws_iam_role.example.name
#   policy_arns = [aws_iam_policy.example.arn]
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: マネージドポリシーのアタッチメントを禁止
#---------------------------------------------------------------
#
# resource "aws_iam_role" "example" {
#   name = "example-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
# }
#
# # すべてのマネージドポリシーのアタッチメントを禁止
# resource "aws_iam_role_policy_attachments_exclusive" "example" {
#   role_name   = aws_iam_role.example.name
#   policy_arns = []
# }
#
# # インラインポリシーのみを使用する場合
# resource "aws_iam_role_policy" "example" {
#   name = "example-inline-policy"
#   role = aws_iam_role.example.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = ["s3:GetObject"]
#         Effect   = "Allow"
#         Resource = "*"
#       }
#     ]
#   })
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 複数のポリシーを組み合わせる
#---------------------------------------------------------------
#
# resource "aws_iam_role" "app_role" {
#   name = "application-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }
#
# resource "aws_iam_policy" "custom_policy" {
#   name = "custom-app-policy"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = ["dynamodb:GetItem", "dynamodb:PutItem"]
#         Effect   = "Allow"
#         Resource = "arn:aws:dynamodb:us-east-1:123456789012:table/MyTable"
#       }
#     ]
#   })
# }
#
# resource "aws_iam_role_policy_attachments_exclusive" "app_role" {
#   role_name = aws_iam_role.app_role.name
#   policy_arns = [
#     "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
#     "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
#     aws_iam_policy.custom_policy.arn,
#   ]
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 条件付きポリシーアタッチメント
#---------------------------------------------------------------
#
# variable "enable_s3_access" {
#   description = "S3アクセスを有効にするかどうか"
#   type        = bool
#   default     = false
# }
#
# resource "aws_iam_role" "conditional_role" {
#   name = "conditional-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
# }
#
# resource "aws_iam_policy" "base_policy" {
#   name = "base-policy"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
#         Effect   = "Allow"
#         Resource = "*"
#       }
#     ]
#   })
# }
#
# resource "aws_iam_policy" "s3_policy" {
#   name = "s3-policy"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = ["s3:GetObject", "s3:PutObject"]
#         Effect   = "Allow"
#         Resource = "arn:aws:s3:::my-bucket/*"
#       }
#     ]
#   })
# }
#
# resource "aws_iam_role_policy_attachments_exclusive" "conditional" {
#   role_name = aws_iam_role.conditional_role.name
#   policy_arns = concat(
#     [aws_iam_policy.base_policy.arn],
#     var.enable_s3_access ? [aws_iam_policy.s3_policy.arn] : []
#   )
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
#
# - aws_iam_role: IAMロールの定義
# - aws_iam_policy: カスタマー管理ポリシーの定義
# - aws_iam_role_policy: インラインポリシーの管理
# - aws_iam_role_policy_attachment: 個別のポリシーアタッチメント管理
#   （注意: このリソースと併用する場合は、policy_arnsに含める必要があります）
# - aws_iam_role_policies_exclusive: インラインポリシーの排他的管理
#
#---------------------------------------------------------------
