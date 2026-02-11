#---------------------------------------------------------------
# IAM Group Policy Attachment
#---------------------------------------------------------------
#
# IAMグループにマネージドポリシーをアタッチするリソースです。
# AWS管理ポリシーまたはカスタマー管理ポリシーをIAMグループに関連付け、
# そのグループに属するすべてのユーザーに対してポリシーで定義された
# 権限を付与します。
#
# AWS公式ドキュメント:
#   - AttachGroupPolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_AttachGroupPolicy.html
#   - IAMグループへのポリシーのアタッチ: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups_manage_attach-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_group_policy_attachment" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # group - IAMグループ名 (必須)
  # ポリシーをアタッチする対象のIAMグループの名前を指定します。
  # グループは事前に作成されている必要があります。
  #
  # 型: string
  # 必須: Yes
  # 更新: グループ名を変更すると、リソースが再作成されます
  group = "example-group"

  # policy_arn - ポリシーARN (必須)
  # アタッチするマネージドポリシーのAmazon Resource Name (ARN)を指定します。
  # AWS管理ポリシー（例: arn:aws:iam::aws:policy/ReadOnlyAccess）または
  # カスタマー管理ポリシー（例: arn:aws:iam::123456789012:policy/MyPolicy）を
  # 指定できます。
  #
  # 型: string
  # 必須: Yes
  # 更新: ポリシーARNを変更すると、リソースが再作成されます
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # id - リソース識別子 (オプション)
  # Terraform内部で使用されるリソースの一意識別子です。
  # 通常は指定する必要はありません。指定しない場合は自動的に
  # "{group}/{policy_arn}" の形式で生成されます。
  #
  # 型: string
  # 必須: No
  # デフォルト: 自動生成 ({group}/{policy_arn})
  # 更新: 変更可能（ただし通常は変更不要）
  # id = "example-group/arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#---------------------------------------------------------------
# Attributes Reference (Read-Only)
#---------------------------------------------------------------
# このリソースをapply後に参照可能な属性:
#
# - id
#   リソースの一意識別子。"{group}/{policy_arn}" の形式で表現されます。
#   例: "example-group/arn:aws:iam::aws:policy/ReadOnlyAccess"
#   他のリソースで参照する際に使用できます。

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: AWS管理ポリシーをグループにアタッチ
resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group_policy_attachment" "developers_readonly" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# 例2: カスタマー管理ポリシーをグループにアタッチ
resource "aws_iam_policy" "custom_policy" {
  name        = "custom-s3-access"
  description = "Custom S3 access policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::example-bucket",
          "arn:aws:s3:::example-bucket/*"
        ]
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "custom_attachment" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.custom_policy.arn
}

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
#
# 1. aws_iam_policy_attachmentとの競合
#    aws_iam_policy_attachmentリソースと同時に使用すると、永続的な差分が
#    表示される場合があります。同じポリシーに対しては、どちらか一方の
#    リソースタイプのみを使用してください。
#
# 2. 複数のポリシーアタッチ
#    1つのグループに複数のポリシーをアタッチする場合は、
#    aws_iam_group_policy_attachmentリソースを複数定義します。
#
# 3. 削除時の動作
#    このリソースを削除すると、グループからポリシーがデタッチされます。
#    グループ自体やポリシー自体は削除されません。
#
# 4. 権限の伝播
#    ポリシーをグループにアタッチすると、そのグループに属する
#    すべてのユーザーに権限が付与されます。
#
# 5. 制限事項
#    - 1つのグループに最大10個のマネージドポリシーをアタッチできます
#    - ポリシーとグループは同じAWSアカウント内に存在する必要があります
