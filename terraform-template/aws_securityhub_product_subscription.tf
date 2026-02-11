#---------------------------------------------------------------
# AWS Security Hub Product Subscription
#---------------------------------------------------------------
#
# AWS Security Hubのセキュリティ製品サブスクリプションを管理するリソースです。
# このリソースを使用することで、Security Hubに統合されたAWSサービスや
# サードパーティ製品からのセキュリティ検出結果(Findings)をインポートできます。
#
# 主な特徴:
#   - AWS標準のセキュリティサービス（GuardDuty、Inspector、Macieなど）の統合
#   - サードパーティ製品（AlertLogic、Trend Microなど）の統合
#   - リージョン単位での管理（各リージョンで個別にサブスクリプションが必要）
#
# AWS公式ドキュメント:
#   - Product integrations: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-findings-providers.html
#   - AWS service integrations: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-internal-providers.html
#   - Third-party integrations: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-partner-providers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_product_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_product_subscription" "example" {
  #-------------------------------------------------------------
  # 前提条件の設定
  #-------------------------------------------------------------

  # depends_on (Meta-argument)
  # 設定内容: Security Hubアカウントが有効化されていることを保証します。
  # 重要: product_subscriptionを作成する前に、必ずaws_securityhub_accountリソースを
  #       作成して有効化しておく必要があります。
  # 例:
  # depends_on = [aws_securityhub_account.example]
  depends_on = [aws_securityhub_account.example]

  #-------------------------------------------------------------
  # 製品ARN設定 (Required)
  #-------------------------------------------------------------

  # product_arn (Required)
  # 設定内容: Security Hubに統合する製品のARNを指定します。
  # ARN形式: arn:aws:securityhub:{region}:{account-id}:product/{company-id}/{product-id}
  #
  # 主要なAWS製品ARN例（{region}は実際のリージョンに置き換えてください）:
  #   - AWS GuardDuty:
  #       arn:aws:securityhub:{region}::product/aws/guardduty
  #   - AWS Inspector:
  #       arn:aws:securityhub:{region}::product/aws/inspector
  #   - AWS Macie:
  #       arn:aws:securityhub:{region}::product/aws/macie
  #   - AWS IAM Access Analyzer:
  #       arn:aws:securityhub:{region}::product/aws/access-analyzer
  #   - AWS Firewall Manager:
  #       arn:aws:securityhub:{region}::product/aws/firewall-manager
  #   - AWS Systems Manager Patch Manager:
  #       arn:aws:securityhub:{region}::product/aws/ssm-patch-manager
  #
  # サードパーティ製品ARN例（{region}は実際のリージョンに置き換えてください）:
  #   - Alert Logic:
  #       arn:aws:securityhub:{region}:733251395267:product/alertlogic/althreatmanagement
  #   - CrowdStrike Falcon:
  #       arn:aws:securityhub:{region}:517716713836:product/crowdstrike/crowdstrike-falcon
  #   - Trend Micro Cloud One:
  #       arn:aws:securityhub:{region}:679593333241:product/trend-micro/cloud-one-workload-security
  #   - Palo Alto Networks Prisma Cloud:
  #       arn:aws:securityhub:{region}:188619942792:product/paloaltonetworks/redlock
  #
  # 利用可能な製品リストの確認方法:
  #   AWS CLI: aws securityhub describe-products --region <region>
  #
  # 動的なリージョン参照の例:
  #   product_arn = "arn:aws:securityhub:${data.aws_region.current.region}::product/aws/guardduty"
  #
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-findings-providers.html
  product_arn = "arn:aws:securityhub:${data.aws_region.current.region}:733251395267:product/alertlogic/althreatmanagement"

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 省略時: プロバイダー設定で指定されたリージョンを使用します。
  # 用途: マルチリージョン環境で、プロバイダー設定とは異なるリージョンで
  #       製品サブスクリプションを管理する場合に使用します。
  # 注意: Security Hubはリージョナルサービスのため、各リージョンで
  #       個別にサブスクリプションを設定する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サブスクリプションの識別子（product_arnと同じ値）
#
# - arn: Security Hubにおける製品サブスクリプションのARN
#       形式: arn:aws:securityhub:{region}:{account-id}:product-subscription/{company-id}/{product-id}
#       用途: 他のリソースでこのサブスクリプションを参照する場合に使用
#
# 使用例:
#   output "subscription_arn" {
#     description = "Security Hub Product Subscription ARN"
#     value       = aws_securityhub_product_subscription.example.arn
#   }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 補足情報
#---------------------------------------------------------------
#
# ■ Security Hub有効化の必要性
#   - product_subscriptionを作成する前に、Security Hubアカウントを
#     有効化する必要があります（aws_securityhub_account）
#   - depends_onを使用して依存関係を明示的に設定してください
#
# ■ リージョン単位の管理
#   - Security Hubはリージョナルサービスです
#   - 各リージョンで個別にサブスクリプションを設定する必要があります
#   - マルチリージョン対応の場合はfor_eachやcountを活用してください
#
# ■ AWS Organizations統合
#   - 管理アカウントでSecurity Hubを有効化すると、組織内の全メンバー
#     アカウントで自動的にSecurity Hubを有効化できます
#   - メンバーアカウントでの製品サブスクリプションは個別に設定が必要です
#
# ■ コスト管理
#   - Security Hub自体とサードパーティ製品には料金が発生します
#   - 製品によってはFindingsの数や量に応じて課金されます
#   - 料金の詳細: https://aws.amazon.com/security-hub/pricing/
#
# ■ セキュリティ標準との違い
#   - Security Hub製品サブスクリプション: 特定の製品からFindingsを受信
#   - セキュリティ標準（aws_securityhub_standards_subscription）:
#     CIS、PCI DSS、AWS Foundational Security Best Practicesなどの
#     コンプライアンス標準に基づくチェックを実行
#
# ■ 利用可能な製品の確認
#   AWS CLIコマンド:
#   aws securityhub describe-products --region us-east-1
#
# ■ トラブルシューティング
#   - エラー "InvalidInputException": 製品ARNが正しいか確認してください
#   - エラー "ResourceNotFoundException": Security Hubが有効化されているか確認
#   - エラー "LimitExceededException": サブスクリプション上限に達していないか確認
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: data sourceと組み合わせた動的なARN構築
#---------------------------------------------------------------
#
# data "aws_region" "current" {}
#
# resource "aws_securityhub_account" "example" {}
#
# resource "aws_securityhub_product_subscription" "guardduty" {
#   depends_on  = [aws_securityhub_account.example]
#   product_arn = "arn:aws:securityhub:${data.aws_region.current.region}::product/aws/guardduty"
# }
#
# resource "aws_securityhub_product_subscription" "inspector" {
#   depends_on  = [aws_securityhub_account.example]
#   product_arn = "arn:aws:securityhub:${data.aws_region.current.region}::product/aws/inspector"
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 複数リージョンでの製品サブスクリプション
#---------------------------------------------------------------
#
# variable "regions" {
#   type    = list(string)
#   default = ["us-east-1", "us-west-2", "ap-northeast-1"]
# }
#
# provider "aws" {
#   alias = "multi_region"
#   for_each = toset(var.regions)
#   region   = each.value
# }
#
# resource "aws_securityhub_account" "multi_region" {
#   for_each = toset(var.regions)
#   provider = aws.multi_region[each.value]
# }
#
# resource "aws_securityhub_product_subscription" "guardduty_multi_region" {
#   for_each    = toset(var.regions)
#   provider    = aws.multi_region[each.value]
#   depends_on  = [aws_securityhub_account.multi_region[each.value]]
#   product_arn = "arn:aws:securityhub:${each.value}::product/aws/guardduty"
# }
#
#---------------------------------------------------------------
