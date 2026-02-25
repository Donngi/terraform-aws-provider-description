#---------------------------------------------------------------
# Amazon Redshift Resource Policy
#---------------------------------------------------------------
#
# Amazon Redshiftのリソースポリシーをプロビジョニングするリソースです。
# リソースポリシーを使用することで、クロスアカウントのアクセス制御を定義し、
# ゼロETL統合などの機能においてAWSサービスやアカウントが
# Redshiftリソースへアクセスすることを許可できます。
#
# AWS公式ドキュメント:
#   - Amazon Redshift リソースポリシーAPIリファレンス: https://docs.aws.amazon.com/redshift/latest/APIReference/API_ResourcePolicy.html
#   - Amazon Redshift アクセス管理の概要: https://docs.aws.amazon.com/redshift/latest/mgmt/redshift-iam-access-control-overview.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_resource_policy" "example" {
  #-------------------------------------------------------------
  # 対象リソース設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: リソースポリシーを作成または更新する対象リソースのARNを指定します。
  # 設定可能な値: 有効なAmazon Redshiftリソース（クラスターネームスペース等）のARN
  # 注意: ゼロETL統合では通常クラスターのクラスターネームスペースARNを指定します。
  # 参考: https://docs.aws.amazon.com/redshift/latest/APIReference/API_ResourcePolicy.html
  resource_arn = "arn:aws:redshift:ap-northeast-1:123456789012:namespace:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: リソースポリシーの内容をJSON形式で指定します。
  # 設定可能な値: IAMポリシードキュメント形式のJSON文字列（最大2147483647文字）
  # 注意: jsonencode()関数を使用してHCLオブジェクトからJSON文字列に変換することを推奨します。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/redshift-iam-access-control-overview.html
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::12345678901:root"
        }
        Action   = "redshift:CreateInboundIntegration"
        Resource = "arn:aws:redshift:ap-northeast-1:123456789012:namespace:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        Sid      = ""
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
# - id: リソースポリシーを作成または更新するアカウントのAmazon Resource Name (ARN)。
#       resource_arnと同一の値が設定されます。
#---------------------------------------------------------------
