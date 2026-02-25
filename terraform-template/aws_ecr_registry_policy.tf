#-----------------------------------------------------------------------
# Provider Version: 6.28.0
# Resource: aws_ecr_registry_policy
# Generated: 2026-02-17
#
# Amazon ECR レジストリポリシーを定義するリソースです。
# レジストリ全体に対するクロスアカウントアクセスやレプリケーション権限を制御できます。
#
# NOTE: ECRレジストリポリシーはリージョンごとに1つのみ定義可能です。
#       複数の aws_ecr_registry_policy リソースを定義すると競合が発生します。
#       複数のステートメントが必要な場合は、1つのポリシー内で定義してください。
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ecr_registry_policy
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# ポリシー設定
#-----------------------------------------------------------------------
resource "aws_ecr_registry_policy" "example" {
  # 必須: レジストリポリシードキュメント（JSON形式）
  # 設定内容: IAMポリシードキュメントをJSON文字列で指定します
  # 補足: jsonencode関数を使用して構造化されたポリシーを定義することを推奨します
  # 参考: https://learn.hashicorp.com/terraform/aws/iam-policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCrossAccountReplication"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "ecr:CreateRepository",
          "ecr:ReplicateImage"
        ]
        Resource = "arn:aws:ecr:ap-northeast-1:111122223333:repository/*"
      }
    ]
  })

  #-----------------------------------------------------------------------
  # リージョン設定（オプション）
  #-----------------------------------------------------------------------
  # 任意: このリソースを管理するリージョン
  # 設定内容: AWSリージョン名を指定します（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 補足: リージョンごとに異なるポリシーを適用する場合に使用します
  region = "ap-northeast-1"
}

#-----------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-----------------------------------------------------------------------
# このリソースから参照できる属性:
#
# - id
#   リソースのID（レジストリIDと同じ）
#
# - registry_id
#   レジストリが作成されたAWSアカウントのレジストリID
#   補足: AWSアカウントIDと同じ値になります
