################################################################################
# AWS SES Identity Policy
################################################################################
# リソース種別: aws_ses_identity_policy
# プロバイダーバージョン: 6.28.0
#
# 概要:
# SES Identity Policyを管理します。SES Sending Authorization Policiesの詳細については、
# SES Developer Guideを参照してください。
# https://docs.aws.amazon.com/ses/latest/DeveloperGuide/sending-authorization-policies.html
#
# ユースケース:
# - SESアイデンティティへのアクセス権限を他のAWSアカウントまたはサービスに付与
# - クロスアカウントでのメール送信権限の制御
# - 特定のプリンシパルに対するSES操作の許可・拒否
#
# 注意事項:
# - ポリシーはJSON形式で指定する必要があります
# - identityには、SESドメインまたはメールアドレスのARNを指定します
# - ポリシー名は、同一アイデンティティ内で一意である必要があります
################################################################################

resource "aws_ses_identity_policy" "example" {
  #------------------------------------------------------------------------------
  # 必須パラメータ
  #------------------------------------------------------------------------------

  # identity - (必須) string
  # 説明: SES IdentityのNameまたはARN
  # 制約:
  # - aws_ses_domain_identityまたはaws_ses_email_identityリソースのARNを指定
  # - ドメイン名(example.com)またはメールアドレス(user@example.com)も使用可能
  # 例: aws_ses_domain_identity.example.arn
  identity = aws_ses_domain_identity.example.arn

  # name - (必須) string
  # 説明: ポリシーの名前
  # 制約:
  # - 同一Identity内で一意である必要があります
  # - 英数字、ハイフン、アンダースコアが使用可能
  # 例: "example-policy", "cross-account-send-policy"
  name = "example-policy"

  # policy - (必須) string
  # 説明: ポリシーのJSON文字列
  # 制約:
  # - 有効なIAMポリシードキュメントである必要があります
  # - SES:SendEmail、SES:SendRawEmailなどのアクションを指定
  # - Terraformのaws_iam_policy_documentデータソースの使用を推奨
  # リファレンス: https://learn.hashicorp.com/terraform/aws/iam-policy
  # 例:
  # data "aws_iam_policy_document" "example" {
  #   statement {
  #     actions   = ["SES:SendEmail", "SES:SendRawEmail"]
  #     resources = [aws_ses_domain_identity.example.arn]
  #     principals {
  #       identifiers = ["123456789012"]  # AWSアカウントID
  #       type        = "AWS"
  #     }
  #   }
  # }
  policy = data.aws_iam_policy_document.example.json

  #------------------------------------------------------------------------------
  # オプションパラメータ
  #------------------------------------------------------------------------------

  # region - (オプション) string, computed
  # 説明: このリソースが管理されるリージョン
  # デフォルト: プロバイダー設定のリージョン
  # 制約:
  # - 有効なAWSリージョンコード(us-east-1, ap-northeast-1など)
  # - 指定しない場合、プロバイダー設定のリージョンが使用されます
  # リファレンス: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 例: "us-east-1", "eu-west-1"
  # region = "us-east-1"

  #------------------------------------------------------------------------------
  # Computed属性 (読み取り専用)
  #------------------------------------------------------------------------------

  # id - string, computed
  # 説明: リソースのID (identity:name 形式)
  # 自動生成され、terraform stateに保存されます
}

################################################################################
# 使用例
################################################################################

# 1. SESドメインアイデンティティの作成
resource "aws_ses_domain_identity" "example" {
  domain = "example.com"
}

# 2. IAMポリシードキュメントの定義
data "aws_iam_policy_document" "example" {
  statement {
    # SESメール送信アクションを許可
    actions = [
      "SES:SendEmail",
      "SES:SendRawEmail"
    ]

    # 対象のSESアイデンティティARNを指定
    resources = [aws_ses_domain_identity.example.arn]

    # 全てのAWSプリンシパルに許可 (本番環境では特定のアカウントIDを指定推奨)
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
  }
}

# 3. SES Identity Policyの作成
resource "aws_ses_identity_policy" "example" {
  identity = aws_ses_domain_identity.example.arn
  name     = "example"
  policy   = data.aws_iam_policy_document.example.json
}

################################################################################
# クロスアカウント送信ポリシーの例
################################################################################

data "aws_iam_policy_document" "cross_account" {
  statement {
    sid = "AllowCrossAccountSend"

    actions = [
      "SES:SendEmail",
      "SES:SendRawEmail"
    ]

    resources = [aws_ses_domain_identity.example.arn]

    # 特定のAWSアカウントに送信権限を付与
    principals {
      identifiers = [
        "arn:aws:iam::123456789012:root",  # 送信を許可するAWSアカウントID
        "arn:aws:iam::210987654321:root"
      ]
      type = "AWS"
    }
  }
}

resource "aws_ses_identity_policy" "cross_account" {
  identity = aws_ses_domain_identity.example.arn
  name     = "cross-account-send-policy"
  policy   = data.aws_iam_policy_document.cross_account.json
}

################################################################################
# 条件付きアクセス制御の例
################################################################################

data "aws_iam_policy_document" "conditional" {
  statement {
    sid = "AllowSendWithConditions"

    actions = [
      "SES:SendEmail",
      "SES:SendRawEmail"
    ]

    resources = [aws_ses_domain_identity.example.arn]

    principals {
      identifiers = ["arn:aws:iam::123456789012:root"]
      type        = "AWS"
    }

    # 送信元メールアドレスの条件を追加
    condition {
      test     = "StringEquals"
      variable = "ses:FromAddress"
      values   = ["noreply@example.com"]
    }
  }
}

resource "aws_ses_identity_policy" "conditional" {
  identity = aws_ses_domain_identity.example.arn
  name     = "conditional-send-policy"
  policy   = data.aws_iam_policy_document.conditional.json
}

################################################################################
# 補足情報
################################################################################

# インポート:
# 既存のSES Identity Policyは以下のコマンドでインポート可能:
# terraform import aws_ses_identity_policy.example identity:policy_name
#
# 例:
# terraform import aws_ses_identity_policy.example example.com:example
# terraform import aws_ses_identity_policy.example arn:aws:ses:us-east-1:123456789012:identity/example.com:example

# 関連リソース:
# - aws_ses_domain_identity: SESドメインアイデンティティ
# - aws_ses_email_identity: SESメールアドレスアイデンティティ
# - aws_iam_policy_document: IAMポリシードキュメント(データソース)

# 参考リンク:
# - Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_identity_policy
# - AWS SES Developer Guide: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/sending-authorization-policies.html
# - SES Sending Authorization: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/sending-authorization.html
