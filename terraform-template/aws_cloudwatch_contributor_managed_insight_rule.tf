#---------------------------------------------------------------
# AWS CloudWatch Contributor Managed Insight Rule
#---------------------------------------------------------------
#
# Amazon CloudWatch Contributor Managed Insight Ruleをプロビジョニングする
# リソースです。Contributor Managed Insight Ruleは、AWSサービスが
# 提供するマネージドテンプレートに基づいて、リソースのコントリビューター
# データを自動的に分析するルールです。
#
# AWS公式ドキュメント:
#   - CloudWatch Contributor Insights: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights.html
#   - Managed Contributor Insights Rules: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights-ManagedRules.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_contributor_managed_insight_rule
#
# Provider Version: 6.28.0
# Generated: 2025-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_contributor_managed_insight_rule" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: Managed Contributor Insights ルールを持つAWSリソースのARNを指定します。
  # 設定可能な値: Managed Contributor Insights ルールをサポートするAWSリソースの有効なARN
  # 例: VPC Endpoint Service、Application Load Balancer等
  # 関連機能: CloudWatch Contributor Insights
  #   特定のAWSリソースに対してマネージドルールを有効化し、
  #   トップコントリビューターを自動的に分析します。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights.html
  resource_arn = aws_vpc_endpoint_service.example.arn

  # template_name (Required)
  # 設定内容: Managed Contributor Insights ルールのテンプレート名を指定します。
  # 設定可能な値: ListManagedInsightRules APIで返されるテンプレート名
  # 例:
  #   - "VpcEndpointService-BytesByEndpointId-v1": VPC Endpoint ServiceのエンドポイントID別バイト数
  #   - "VpcEndpointService-ConnectionsByEndpointId-v1": VPC Endpoint ServiceのエンドポイントID別接続数
  # 関連機能: Managed Contributor Insights Rule Templates
  #   AWSが提供する事前定義されたルールテンプレートを使用して、
  #   特定のメトリクスに対するコントリビューター分析を行います。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights-ManagedRules.html
  template_name = "VpcEndpointService-BytesByEndpointId-v1"

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
  # ルール状態設定
  #-------------------------------------------------------------

  # state (Optional)
  # 設定内容: ルールの状態を指定します。
  # 設定可能な値:
  #   - "ENABLED": ルールを有効化し、データの収集と分析を開始
  #   - "DISABLED": ルールを無効化し、データ収集を停止
  # 省略時: AWSのデフォルト動作に従う
  # 関連機能: Contributor Insights Rule State
  #   ルールを一時的に無効化することで、コスト削減や
  #   メンテナンス時のデータ収集停止が可能です。
  state = "ENABLED"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-managed-insight-rule"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Contributor Managed Insight RuleのAmazon Resource Name (ARN)
#
# - rule_name: 作成されたContributor Insightルールの名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
