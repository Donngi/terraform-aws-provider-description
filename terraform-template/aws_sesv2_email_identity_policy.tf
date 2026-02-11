# ============================================================
# AWS SESv2 Email Identity Policy
# ============================================================
# Terraform resource for managing an AWS SESv2 (Simple Email V2) Email Identity Policy.
#
# Provider Version: 6.28.0
# Resource Type: aws_sesv2_email_identity_policy
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sesv2_email_identity_policy
#
# 概要:
# - SESv2メールアイデンティティに対するIAMポリシーを管理
# - 特定のIAMユーザーやロールにSES操作の権限を付与
# - JSON形式のポリシードキュメントでアクセス制御を定義
#
# 主な用途:
# - クロスアカウントアクセスの許可
# - 特定のIAMプリンシパルへのSES操作権限の委譲
# - メールアイデンティティのセキュリティ管理
#
# 注意事項:
# - ポリシーはJSON形式で記述する必要があります
# - メールアイデンティティは事前に作成されている必要があります
# - ポリシー名はアイデンティティ内で一意である必要があります
# ============================================================

resource "aws_sesv2_email_identity_policy" "example" {
  # ------------------------------------------------------------
  # Required Parameters
  # ------------------------------------------------------------

  # email_identity (Required, string)
  # メールアイデンティティ（メールアドレスまたはドメイン）
  #
  # 説明: このポリシーを適用するSESv2メールアイデンティティを指定します
  #
  # 設定例:
  # - "user@example.com" : メールアドレスの場合
  # - "example.com" : ドメインの場合
  # - aws_sesv2_email_identity.example.email_identity : 他のリソースを参照
  #
  # 注意事項:
  # - 指定するアイデンティティは既に存在している必要があります
  # - メールアドレスまたは検証済みドメインを指定できます
  # ------------------------------------------------------------
  email_identity = aws_sesv2_email_identity.example.email_identity

  # policy_name (Required, string)
  # ポリシー名
  #
  # 説明: このポリシーを識別するための名前を指定します
  #
  # 設定例:
  # - "example-policy" : 基本的な命名
  # - "cross-account-send" : 目的を示す命名
  # - "allow-iam-user-access" : 機能説明的な命名
  #
  # 注意事項:
  # - 同一メールアイデンティティ内で一意である必要があります
  # - 英数字とハイフンが使用可能です
  # ------------------------------------------------------------
  policy_name = "example"

  # policy (Required, string)
  # IAMポリシードキュメント（JSON形式）
  #
  # 説明: メールアイデンティティに適用するアクセス許可をJSON形式で定義します
  #
  # 設定例:
  # HEREDOCを使用した記述:
  # policy = <<EOF
  # {
  #   "Version": "2012-10-17",
  #   "Statement": [...]
  # }
  # EOF
  #
  # jsonencode関数を使用した記述:
  # policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [...]
  # })
  #
  # ポリシーの主要要素:
  # - Version : ポリシー言語のバージョン（通常は "2012-10-17"）
  # - Statement : 権限ステートメントの配列
  #   - Sid : ステートメントID（オプション）
  #   - Effect : "Allow" または "Deny"
  #   - Principal : 権限を付与するプリンシパル
  #   - Action : 許可するSES API操作
  #   - Resource : 対象となるリソースARN
  #
  # よく使用されるSES Actions:
  # - ses:SendEmail : メール送信
  # - ses:SendRawEmail : Raw形式でのメール送信
  # - ses:DeleteEmailIdentity : メールアイデンティティの削除
  # - ses:PutEmailIdentityDkimSigningAttributes : DKIM署名属性の設定
  # - ses:GetEmailIdentity : メールアイデンティティ情報の取得
  #
  # 注意事項:
  # - JSON形式が正しいことを確認してください
  # - ResourceにはメールアイデンティティのARNを指定します
  # - クロスアカウントアクセスの場合、Principalに他のAWSアカウントのARNを指定します
  # ------------------------------------------------------------
  policy = <<EOF
{
  "Id":"ExampleAuthorizationPolicy",
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AuthorizeIAMUser",
      "Effect":"Allow",
      "Resource":"${aws_sesv2_email_identity.example.arn}",
      "Principal":{
        "AWS":[
          "arn:aws:iam::123456789012:user/John",
          "arn:aws:iam::123456789012:user/Jane"
        ]
      },
      "Action":[
        "ses:DeleteEmailIdentity",
        "ses:PutEmailIdentityDkimSigningAttributes"
      ]
    }
  ]
}
EOF

  # ------------------------------------------------------------
  # Optional Parameters
  # ------------------------------------------------------------

  # region (Optional, string, Computed)
  # AWSリージョン
  #
  # 説明: このリソースが管理されるAWSリージョンを指定します
  #
  # 設定例:
  # - "us-east-1" : 米国東部（バージニア北部）
  # - "eu-west-1" : 欧州（アイルランド）
  # - "ap-northeast-1" : アジアパシフィック（東京）
  #
  # デフォルト動作:
  # - 指定しない場合、プロバイダー設定のリージョンが使用されます
  # - Computed属性のため、実際に使用されるリージョンが取得できます
  #
  # 注意事項:
  # - 通常は明示的に指定する必要はありません
  # - マルチリージョン構成の場合に使用します
  # ------------------------------------------------------------
  # region = "us-east-1"
}

# ============================================================
# Outputs
# ============================================================
# リソースから取得可能な出力値の例

# output "email_identity_policy_id" {
#   description = "The email identity policy resource ID (format: email_identity|policy_name)"
#   value       = aws_sesv2_email_identity_policy.example.id
# }
#
# output "email_identity_policy_name" {
#   description = "The name of the email identity policy"
#   value       = aws_sesv2_email_identity_policy.example.policy_name
# }
#
# output "email_identity" {
#   description = "The email identity associated with this policy"
#   value       = aws_sesv2_email_identity_policy.example.email_identity
# }

# ============================================================
# 使用例：クロスアカウントアクセス
# ============================================================
# 別のAWSアカウントからのメール送信を許可する例

# resource "aws_sesv2_email_identity" "cross_account" {
#   email_identity = "shared@example.com"
# }
#
# resource "aws_sesv2_email_identity_policy" "cross_account" {
#   email_identity = aws_sesv2_email_identity.cross_account.email_identity
#   policy_name    = "allow-cross-account-send"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowCrossAccountSend"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::987654321098:root"
#         }
#         Action = [
#           "ses:SendEmail",
#           "ses:SendRawEmail"
#         ]
#         Resource = aws_sesv2_email_identity.cross_account.arn
#       }
#     ]
#   })
# }

# ============================================================
# 使用例：特定のIAMロールへの権限付与
# ============================================================
# Lambda関数などで使用するIAMロールに送信権限を付与する例

# resource "aws_sesv2_email_identity" "lambda" {
#   email_identity = "noreply@example.com"
# }
#
# resource "aws_sesv2_email_identity_policy" "lambda_send" {
#   email_identity = aws_sesv2_email_identity.lambda.email_identity
#   policy_name    = "allow-lambda-send"
#
#   policy = jsonencode({
#     Id      = "LambdaSendPolicy"
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowLambdaToSendEmail"
#         Effect = "Allow"
#         Principal = {
#           AWS = aws_iam_role.email_sender.arn
#         }
#         Action = [
#           "ses:SendEmail",
#           "ses:SendRawEmail"
#         ]
#         Resource = aws_sesv2_email_identity.lambda.arn
#       }
#     ]
#   })
# }

# ============================================================
# 使用例：複数のプリンシパルへの権限付与
# ============================================================
# 複数のIAMユーザーやロールに異なる権限を付与する例

# resource "aws_sesv2_email_identity" "shared" {
#   email_identity = "team@example.com"
# }
#
# resource "aws_sesv2_email_identity_policy" "team_access" {
#   email_identity = aws_sesv2_email_identity.shared.email_identity
#   policy_name    = "team-access-policy"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowSendersToSend"
#         Effect = "Allow"
#         Principal = {
#           AWS = [
#             "arn:aws:iam::123456789012:user/sender1",
#             "arn:aws:iam::123456789012:user/sender2",
#             "arn:aws:iam::123456789012:role/EmailSenderRole"
#           ]
#         }
#         Action = [
#           "ses:SendEmail",
#           "ses:SendRawEmail"
#         ]
#         Resource = aws_sesv2_email_identity.shared.arn
#       },
#       {
#         Sid    = "AllowAdminsToManage"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::123456789012:user/admin"
#         }
#         Action = [
#           "ses:*"
#         ]
#         Resource = aws_sesv2_email_identity.shared.arn
#       }
#     ]
#   })
# }

# ============================================================
# 依存リソースの例
# ============================================================
# このリソースと一緒に使用する関連リソースの例

# メールアイデンティティの作成（メールアドレス）
# resource "aws_sesv2_email_identity" "example" {
#   email_identity = "user@example.com"
# }

# メールアイデンティティの作成（ドメイン）
# resource "aws_sesv2_email_identity" "domain" {
#   email_identity = "example.com"
#
#   dkim_signing_attributes {
#     next_signing_key_length = "RSA_2048_BIT"
#   }
# }

# IAMロールの作成（Lambda用）
# resource "aws_iam_role" "email_sender" {
#   name = "email-sender-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }
