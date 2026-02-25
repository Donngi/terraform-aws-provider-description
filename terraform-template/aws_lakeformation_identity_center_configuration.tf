#---------------------------------------------------------------
# AWS Lake Formation Identity Center Configuration
#---------------------------------------------------------------
#
# AWS Lake Formation と IAM Identity Center の統合設定をプロビジョニングするリソースです。
# この設定により、IAM Identity Center のユーザーおよびグループが Data Catalog リソースへ
# アクセスできるようになります。Lake Formation は IAM Identity Center と連携して
# 信頼されたアイデンティティの伝播（Trusted Identity Propagation）をサポートし、
# データレイクへのきめ細かいアクセス制御を実現します。
#
# AWS公式ドキュメント:
#   - Lake Formation と IAM Identity Center の連携: https://docs.aws.amazon.com/lake-formation/latest/dg/identity-center-integration.html
#   - IAM Identity Center 統合設定 API: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_CreateLakeFormationIdentityCenterConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_identity_center_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lakeformation_identity_center_configuration" "example" {
  #-------------------------------------------------------------
  # IAM Identity Center 設定
  #-------------------------------------------------------------

  # instance_arn (Required)
  # 設定内容: 関連付ける IAM Identity Center インスタンスの ARN を指定します。
  # 設定可能な値: 有効な IAM Identity Center インスタンスの ARN
  #   例: "arn:aws:sso:::instance/ssoins-1234567890abcdef"
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/dg/identity-center-integration.html
  instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef"

  #-------------------------------------------------------------
  # Data Catalog 設定
  #-------------------------------------------------------------

  # catalog_id (Optional)
  # 設定内容: 統合対象の Data Catalog の識別子を指定します。
  # 設定可能な値: 有効な AWS アカウント ID（12桁の数字）
  # 省略時: 現在の AWS アカウント ID が自動的に使用されます。
  # 参考: https://docs.aws.amazon.com/lake-formation/latest/APIReference/API_CreateLakeFormationIdentityCenterConfiguration.html
  catalog_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - application_arn: IAM Identity Center と統合された Lake Formation アプリケーションの ARN
#
# - resource_share: AWS Resource Access Manager (RAM) リソース共有の ARN
#---------------------------------------------------------------
