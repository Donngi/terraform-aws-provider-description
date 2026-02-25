#---------------------------------------------------------------
# Amazon Redshift Serverless Resource Policy
#---------------------------------------------------------------
#
# Amazon Redshift Serverlessのリソースポリシーをプロビジョニングするリソースです。
# リソースポリシーを使用することで、スナップショット等のRedshift Serverlessリソースを
# 他のAWSアカウントと共有したり、サービス間連携（ゼロETLなど）の認可設定が行えます。
#
# AWS公式ドキュメント:
#   - PutResourcePolicy API: https://docs.aws.amazon.com/redshift-serverless/latest/APIReference/API_PutResourcePolicy.html
#   - ResourcePolicy リファレンス: https://docs.aws.amazon.com/redshift-serverless/latest/APIReference/API_ResourcePolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshiftserverless_resource_policy" "example" {
  #-------------------------------------------------------------
  # 対象リソース設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: リソースポリシーを作成または更新する対象リソースのARNを指定します。
  # 設定可能な値: 有効なAWS ARN文字列（例: スナップショットやネームスペースのARN）
  # 参考: https://docs.aws.amazon.com/redshift-serverless/latest/APIReference/API_PutResourcePolicy.html
  resource_arn = "arn:aws:redshift-serverless:ap-northeast-1:123456789012:snapshot/example-snapshot"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: 作成または更新するリソースポリシーをJSON形式の文字列で指定します。
  #           スナップショットの共有や、ゼロETL統合の認可等に使用します。
  # 設定可能な値: IAMポリシードキュメント形式のJSON文字列
  #   - Effect: "Allow" または "Deny"
  #   - Principal: ポリシーを適用するAWSアカウントID、IAMユーザー/ロールのARN
  #   - Action: 許可/拒否するRedshift Serverlessアクション
  #             例: "redshift-serverless:RestoreFromSnapshot"
  #   - Sid: ステートメントID（任意）
  # 注意: jsonencode関数を使用するとHCL内でJSONを構造的に記述できます。
  # 参考: https://docs.aws.amazon.com/redshift-serverless/latest/APIReference/API_PutResourcePolicy.html
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = ["arn:aws:iam::987654321098:root"]
        }
        Action = [
          "redshift-serverless:RestoreFromSnapshot",
        ]
        Sid = ""
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
# - id: リソースポリシーを作成または更新した対象アカウントのARN（resource_arnと同値）
#---------------------------------------------------------------
