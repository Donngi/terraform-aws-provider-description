#---------------------------------------------------------------
# AWS SESv2 Email Identity Policy
#---------------------------------------------------------------
#
# Amazon SES (Simple Email Service) v2 のメールアイデンティティに
# 送信認可ポリシーを設定・管理するリソースです。
# 送信認可ポリシーを使用することで、他のAWSアカウントやIAMユーザーに対して
# 特定のメールアイデンティティを使用したメール送信権限を委任できます。
#
# 主な機能:
#   - メールアイデンティティへのリソースベースポリシーの付与
#   - クロスアカウントでの送信権限の委任
#   - ポリシー名による複数ポリシーの管理
#
# AWS公式ドキュメント:
#   - 送信認可ポリシー: https://docs.aws.amazon.com/ses/latest/dg/sending-authorization.html
#   - CreateEmailIdentityPolicy API: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_CreateEmailIdentityPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sesv2_email_identity_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # email_identity (Required)
  # 設定内容: ポリシーを付与するメールアイデンティティを指定します。
  # 設定可能な値:
  #   - ドメイン名: "example.com"（ドメインアイデンティティ）
  #   - メールアドレス: "user@example.com"（メールアドレスアイデンティティ）
  # 注意事項:
  #   - 指定するアイデンティティはaws_sesv2_email_identityリソースで
  #     事前に作成されている必要があります。
  #   - 変更時はリソースの再作成が必要です。
  email_identity = "example.com"

  # policy_name (Required)
  # 設定内容: 送信認可ポリシーに付ける名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  #   例: "SendingAuthorizationPolicy"
  # 注意事項:
  #   - 同一のメールアイデンティティに対して複数のポリシーを付与する場合、
  #     それぞれ一意の名前を設定してください。
  #   - 変更時はリソースの再作成が必要です。
  policy_name = "example-policy"

  # policy (Required)
  # 設定内容: メールアイデンティティに付与するIAMポリシードキュメントをJSON形式で指定します。
  # 設定可能な値: 有効なJSONポリシードキュメント
  # 注意事項:
  #   - jsonencode()関数またはaws_iam_policy_documentデータソースを使用した記述を推奨します。
  #   - ポリシーでは ses:SendEmail および ses:SendRawEmail アクションを許可できます。
  #   - Principal にAWSアカウントIDやIAMエンティティを指定することで
  #     クロスアカウント送信を許可できます。
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSendEmail"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]
        Resource = "*"
      }
    ]
  })

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子（email_identity と policy_name の組み合わせ）
#---------------------------------------------------------------
