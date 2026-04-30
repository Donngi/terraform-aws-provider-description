#---------------------------------------------------------------
# AWS Security Hub Standards Subscription
#---------------------------------------------------------------
#
# AWS Security Hubのセキュリティ基準（スタンダード）へのサブスクリプションを
# プロビジョニングするリソースです。Security Hubを有効化した後、
# CIS AWS Foundations BenchmarkやPCI DSSなどのセキュリティ基準を
# サブスクライブすることで、自動的にセキュリティチェックが実行されます。
#
# AWS公式ドキュメント:
#   - Security Hub概要: https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html
#   - セキュリティ基準: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-standards.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_standards_subscription" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # standards_arn (Required)
  # 設定内容: サブスクライブするセキュリティ基準のARNを指定します。
  # 設定可能な値: 以下のセキュリティ基準ARNが利用可能です（${var.partition}と${var.region}は環境に合わせて置換）。
  #   - AWS Foundational Security Best Practices:
  #     arn:${var.partition}:securityhub:${var.region}::standards/aws-foundational-security-best-practices/v/1.0.0
  #   - AWS Resource Tagging Standard:
  #     arn:${var.partition}:securityhub:${var.region}::standards/aws-resource-tagging-standard/v/1.0.0
  #   - CIS AWS Foundations Benchmark v1.2.0:
  #     arn:${var.partition}:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0
  #   - CIS AWS Foundations Benchmark v1.4.0:
  #     arn:${var.partition}:securityhub:${var.region}::standards/cis-aws-foundations-benchmark/v/1.4.0
  #   - CIS AWS Foundations Benchmark v3.0.0:
  #     arn:${var.partition}:securityhub:${var.region}::standards/cis-aws-foundations-benchmark/v/3.0.0
  #   - NIST SP 800-53 Rev. 5:
  #     arn:${var.partition}:securityhub:${var.region}::standards/nist-800-53/v/5.0.0
  #   - NIST SP 800-171 Rev. 2:
  #     arn:${var.partition}:securityhub:${var.region}::standards/nist-800-171/v/2.0.0
  #   - PCI DSS v3.2.1:
  #     arn:${var.partition}:securityhub:${var.region}::standards/pci-dss/v/3.2.1
  #   - PCI DSS v4.0.1:
  #     arn:${var.partition}:securityhub:${var.region}::standards/pci-dss/v/4.0.1
  # 注意: このリソースを使用する前にaws_securityhub_accountでSecurity Hubを有効化する必要があります。
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-standards.html
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration形式の文字列
    # 省略時: デフォルトのタイムアウト値を使用
    create = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration形式の文字列
    # 省略時: デフォルトのタイムアウト値を使用
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サブスクリプションを表すリソースのARN
# - arn: サブスクリプションのARN
#---------------------------------------------------------------
