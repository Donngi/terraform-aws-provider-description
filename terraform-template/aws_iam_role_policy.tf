#---------------------------------------------------------------
# AWS IAM Role Inline Policy
#---------------------------------------------------------------
#
# IAMロールにインラインポリシーをアタッチするリソースです。
# インラインポリシーはロールに直接埋め込まれ、ロールと一体として管理されます。
# 再利用可能なポリシーが必要な場合は aws_iam_role_policy_attachment の利用を検討してください。
#
# 注意: aws_iam_role の inline_policy 引数と同時に使用するとTerraformが差分を
#       永続的に検出するため、どちらか一方のみ使用してください。
#
# AWS公式ドキュメント:
#   - IAM インラインポリシー: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html#policies_inline
#   - PutRolePolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_PutRolePolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_role_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # role (Required)
  # 設定内容: インラインポリシーをアタッチするIAMロールの名前またはIDを指定します。
  # 設定可能な値: 有効なIAMロール名またはIAMロールのID
  role = "example-role"

  # policy (Required)
  # 設定内容: ロールにアタッチするインラインポリシードキュメントをJSON形式で指定します。
  # 設定可能な値: 有効なIAMポリシードキュメントのJSON文字列
  # 注意: jsonencode() または aws_iam_policy_document データソースの使用を推奨します。
  #       生のJSON文字列を使用するとフォーマットの差異によりTerraformが差分を検出する場合があります。
  # 参考: https://developer.hashicorp.com/terraform/language/functions/jsonencode
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
        ]
        Resource = "arn:aws:s3:::example-bucket/*"
      },
    ]
  })

  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: インラインポリシーの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコア、プラス記号、等号、カンマ、ピリオド、アットマークを含む文字列
  # 省略時: Terraformがランダムな一意の名前を自動生成します。
  # 注意: name_prefix と排他的（どちらか一方のみ指定可能）
  name = "example-role-policy"

  # name_prefix (Optional)
  # 設定内容: インラインポリシー名のプレフィックスを指定します。Terraformが一意のサフィックスを追加します。
  # 設定可能な値: 英数字、ハイフン、アンダースコア等を含む文字列
  # 省略時: name が指定されない場合にランダム名が生成されます。
  # 注意: name と排他的（どちらか一方のみ指定可能）
  name_prefix = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ロール名とポリシー名をコロンで連結した識別子（例: role_name:policy_name）
#---------------------------------------------------------------
