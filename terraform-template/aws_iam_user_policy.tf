#---------------------------------------------------------------
# IAM User Policy (Inline Policy)
#---------------------------------------------------------------
#
# IAMユーザーに直接埋め込むインラインポリシーを作成します。
# インラインポリシーはユーザーと一対一の関係で、ユーザーに直接アタッチされる
# JSON形式のポリシードキュメントです。
#
# 注意: 複数のユーザーで同じポリシーを共有する場合は、
#       aws_iam_policy（マネージドポリシー）とaws_iam_user_policy_attachmentの
#       組み合わせの使用を推奨します。
#
# AWS公式ドキュメント:
#   - PutUserPolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_PutUserPolicy.html
#   - IAM User Guide - Inline Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_user_policy" "example" {
  # -------------------------
  # 必須プロパティ
  # -------------------------

  # (Required) ポリシードキュメント（JSON形式）
  # IAMユーザーに付与する権限を定義するポリシードキュメント。
  # 推奨: jsonencode()関数またはaws_iam_policy_documentデータソースを使用して
  #       Terraformのコード内でJSON形式を生成することで、フォーマットの不整合を回避。
  #
  # 例:
  #   policy = jsonencode({
  #     Version = "2012-10-17"
  #     Statement = [
  #       {
  #         Effect = "Allow"
  #         Action = ["s3:GetObject", "s3:ListBucket"]
  #         Resource = "*"
  #       }
  #     ]
  #   })
  #
  # または:
  #   policy = data.aws_iam_policy_document.example.json
  #
  # 参考: https://learn.hashicorp.com/terraform/aws/iam-policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
        ]
        Resource = "*"
      },
    ]
  })

  # (Required) ポリシーをアタッチするIAMユーザー名
  # このポリシーが関連付けられるIAMユーザーの名前を指定します。
  # 通常は他のaws_iam_userリソースの名前属性を参照します。
  #
  # 例:
  #   user = aws_iam_user.example.name
  user = "example-user"

  # -------------------------
  # オプションプロパティ
  # -------------------------

  # (Optional) ポリシーの名前
  # 省略した場合、Terraformがランダムで一意な名前を自動生成します。
  # name_prefixと同時に指定することはできません。
  #
  # 制約:
  #   - 長さ: 1～128文字
  #   - 使用可能文字: 英数字、+=,.@-_
  #
  # 例:
  #   name = "my-user-policy"
  name = "example-policy"

  # (Optional) ポリシー名のプレフィックス
  # 指定したプレフィックスで始まる一意な名前をTerraformが自動生成します。
  # nameと同時に指定することはできません（Conflicts with name）。
  # Forces new resource: この値を変更すると新しいリソースが作成されます。
  #
  # 例:
  #   name_prefix = "app-policy-"
  #   # 結果: "app-policy-20230101123456" のような名前が生成される
  # name_prefix = null
}

#---------------------------------------------------------------
# Attributes Reference (Read-Only)
#---------------------------------------------------------------
# このリソースが作成された後、以下の属性を参照できます:
#
# - id
#     タイプ: string
#     説明: ユーザーポリシーのID。形式は "user_name:user_policy_name"
#     例: "example-user:example-policy"
#
# - name
#     タイプ: string
#     説明: ポリシーの名前（常に設定されます）
#     nameまたはname_prefixを指定した場合は指定値、
#     どちらも指定しない場合は自動生成された名前が返されます。
#
#---------------------------------------------------------------
