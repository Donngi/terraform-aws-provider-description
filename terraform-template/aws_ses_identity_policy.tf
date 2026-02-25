#---------------------------------------------------------------
# AWS SES Identity Policy
#---------------------------------------------------------------
#
# Amazon SES（Simple Email Service）の送信認証ポリシーをプロビジョニングするリソースです。
# 送信認証ポリシーを使用すると、SESアイデンティティ（ドメインまたはメールアドレス）の
# オーナーが、他のAWSアカウントや IAMユーザーに対して、そのアイデンティティを使って
# メールを送信する権限を委任できます。
#
# AWS公式ドキュメント:
#   - SES送信認証の概要: https://docs.aws.amazon.com/ses/latest/dg/sending-authorization-overview.html
#   - SES送信認証ポリシーの作成: https://docs.aws.amazon.com/ses/latest/dg/sending-authorization-identity-owner-tasks-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_identity_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_identity_policy" "example" {
  #-------------------------------------------------------------
  # アイデンティティ設定
  #-------------------------------------------------------------

  # identity (Required)
  # 設定内容: ポリシーを適用するSESアイデンティティの名前またはARNを指定します。
  # 設定可能な値:
  #   - ドメイン名（例: "example.com"）
  #   - メールアドレス（例: "sender@example.com"）
  #   - SESアイデンティティのARN（例: "arn:aws:ses:us-east-1:123456789012:identity/example.com"）
  # 注意: 指定するアイデンティティはSESで事前に検証済みである必要があります。
  # 参考: https://docs.aws.amazon.com/ses/latest/dg/sending-authorization-overview.html
  identity = "example.com"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ポリシーの名前を指定します。
  # 設定可能な値: 英数字、ハイフン（-）、アンダースコア（_）のみ使用可能。最大64文字。
  # 注意: 同一アイデンティティ内でポリシー名は一意である必要があります。
  # 参考: https://docs.aws.amazon.com/ses/latest/dg/sending-authorization-identity-owner-tasks-policy.html
  name = "example-policy"

  # policy (Required)
  # 設定内容: JSON形式のポリシードキュメントを指定します。
  # 設定可能な値: SES送信認証ポリシーのJSON文字列。最大4KBまで。
  #   ポリシーには以下のSESアクションを含めることができます:
  #   - "SES:SendEmail": 標準のメール送信を許可
  #   - "SES:SendRawEmail": 生のメール送信を許可
  #   - "SES:SendTemplatedEmail": テンプレートを使用したメール送信を許可
  #   - "SES:SendBulkTemplatedEmail": バルクテンプレートメール送信を許可
  # 推奨: aws_iam_policy_documentデータソースを使用してポリシーを構築することを推奨します。
  # 参考: https://docs.aws.amazon.com/ses/latest/dg/sending-authorization-overview.html
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action   = ["SES:SendEmail", "SES:SendRawEmail"]
        Resource = "arn:aws:ses:us-east-1:123456789012:identity/example.com"
      }
    ]
  })

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アイデンティティとポリシー名を組み合わせた識別子
#       形式: "{identity}|{policy_name}"
#---------------------------------------------------------------
