#---------------------------------------------------------------
# AWS Secrets Manager Secret Policy
#---------------------------------------------------------------
#
# AWS Secrets Managerのシークレットにリソースベースポリシーを設定する
# リソースです。リソースベースポリシーを使用することで、シークレットへの
# アクセスを許可するプリンシパルと、実行可能なアクションを定義できます。
# 複数のIAMユーザーやロールへのアクセス付与、他のAWSアカウントへの
# クロスアカウントアクセスの設定が可能です。
#
# AWS公式ドキュメント:
#   - リソースベースポリシー: https://docs.aws.amazon.com/secretsmanager/latest/userguide/auth-and-access_resource-policies.html
#   - アクセス許可の確認: https://docs.aws.amazon.com/secretsmanager/latest/userguide/determine-acccess_examine-iam-policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_secretsmanager_secret_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # secret_arn (Required)
  # 設定内容: ポリシーを設定するシークレットのARNを指定します。
  # 設定可能な値: 有効なSecrets Manager シークレットのARN文字列
  secret_arn = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:my-secret-abc123"

  # policy (Required)
  # 設定内容: シークレットに適用するリソースベースポリシーをJSON文字列で指定します。
  #           有効なIAMポリシードキュメントである必要があります。
  # 設定可能な値: 有効なJSON形式のIAMポリシードキュメント文字列
  # 注意: aws_secretsmanager_secretリソースのpolicyとは異なり、
  #       "{}"（空のポリシー）は無効です。ポリシーが必須となります。
  # 参考: https://docs.aws.amazon.com/secretsmanager/latest/userguide/auth-and-access_resource-policies.html
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableAnotherAWSAccountToReadTheSecret"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = "*"
      }
    ]
  })

  #-------------------------------------------------------------
  # パブリックアクセスブロック設定
  #-------------------------------------------------------------

  # block_public_policy (Optional)
  # 設定内容: リソースポリシーを検証してシークレットへの広範なアクセスを
  #           防止するかどうかを指定します。有効にすると、Zelkovaと
  #           ValidateResourcePolicy APIを使用してポリシーが検証されます。
  # 設定可能な値:
  #   - true: ポリシーの検証を有効化。広範なIAMプリンシパルへのアクセス付与を防止します
  #   - false (デフォルト): ポリシーの検証を無効化
  # 参考: https://docs.aws.amazon.com/secretsmanager/latest/userguide/auth-and-access_resource-policies.html
  block_public_policy = false

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
# - id: シークレットのAmazon Resource Name (ARN)
#---------------------------------------------------------------
