#---------------------------------------------------------------
# AWS SNS Topic Policy
#---------------------------------------------------------------
#
# Amazon SNS トピックへのアクセスを制御するリソースベースのポリシーを
# プロビジョニングするリソースです。
# トピックポリシーを使用することで、他のAWSアカウントやAWSサービスに
# SNSトピックへのアクセス権限を付与できます。
#
# AWS公式ドキュメント:
#   - Amazon SNS アクセス制御の概要: https://docs.aws.amazon.com/sns/latest/dg/sns-access-policy-use-cases.html
#   - IDベースのポリシーの使用: https://docs.aws.amazon.com/sns/latest/dg/sns-using-identity-based-policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sns_topic_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # arn (Required)
  # 設定内容: ポリシーを適用するSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックARN（形式: arn:aws:sns:<region>:<account_id>:<topic_name>）
  arn = "arn:aws:sns:ap-northeast-1:123456789012:example-topic"

  # policy (Required)
  # 設定内容: SNSトピックに適用するアクセスポリシーをJSON形式で指定します。
  # 設定可能な値: IAMポリシードキュメントのJSON文字列。
  #   jsonencode()関数またはaws_iam_policy_document データソースを使用することを推奨します。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sns-access-policy-use-cases.html
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowPublish"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action   = "sns:Publish"
        Resource = "arn:aws:sns:ap-northeast-1:123456789012:example-topic"
      }
    ]
  })

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
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
# - owner: トピックを所有するAWSアカウントID
#---------------------------------------------------------------
