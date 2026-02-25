#---------------------------------------------------------------
# AWS Security Hub Product Subscription
#---------------------------------------------------------------
#
# AWS Security Hubにおけるサードパーティ製品またはAWSサービス統合の
# サブスクリプションをプロビジョニングするリソースです。
# サブスクリプションを作成することで、指定した製品からのセキュリティ検知結果を
# Security Hubに取り込めるようになります。
#
# AWS公式ドキュメント:
#   - サードパーティ製品の統合: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-partner-providers.html
#   - 統合の概要: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-findings-providers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/securityhub_product_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_product_subscription" "example" {
  #-------------------------------------------------------------
  # 製品設定
  #-------------------------------------------------------------

  # product_arn (Required, Forces new resource)
  # 設定内容: Security Hubに検知結果を取り込む製品のARNを指定します。
  # 設定可能な値: 有効な製品ARN。形式は以下の通りです。
  #   arn:aws:securityhub:{region}:{account-id}:product/{company}/{product}
  # 利用可能な製品の一覧:
  #   - AWS CLIコマンド `aws securityhub describe-products` で確認可能
  #   - AWSサービス統合: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-internal-providers.html
  #   - サードパーティ製品統合: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-partner-providers.html
  # 注意: aws_securityhub_account リソースで Security Hub が有効化されていることが前提条件です。
  #       depends_on で依存関係を明示することを推奨します。
  product_arn = "arn:aws:securityhub:ap-northeast-1:733251395267:product/alertlogic/althreatmanagement"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: サブスクリプションを表すリソースのARN。
#        指定した製品からの検知結果をSecurity Hubにインポートするための
#        サブスクリプションを識別します。
#---------------------------------------------------------------
