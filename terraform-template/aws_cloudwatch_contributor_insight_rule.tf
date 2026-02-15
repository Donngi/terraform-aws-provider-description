#---------------------------------------------------------------
# AWS CloudWatch Contributor Insight Rule
#---------------------------------------------------------------
#
# Amazon CloudWatch Contributor Insight Ruleをプロビジョニングする
# リソースです。Contributor Insight Ruleは、カスタムルール定義に基づいて、
# ログデータやメトリクスからトップコントリビューターを分析し、
# パフォーマンス問題やセキュリティ脅威の特定を支援します。
#
# AWS公式ドキュメント:
#   - CloudWatch Contributor Insights: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights.html
#   - Contributor Insights Rule Syntax: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights-RuleSyntax.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_contributor_insight_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-12
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_contributor_insight_rule" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # rule_name (Required)
  # 設定内容: Contributor Insightルールの名前を指定します。
  # 設定可能な値: 1〜128文字の英数字、ハイフン、アンダースコアのみ使用可能
  # 関連機能: CloudWatch Contributor Insights
  #   ルール名はアカウント内でユニークである必要があり、
  #   ルールの識別とメトリクスの参照に使用されます。
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights.html
  rule_name = "example-contributor-insight-rule"

  # rule_definition (Required)
  # 設定内容: Contributor Insightルールの定義をJSON形式で指定します。
  # 設定可能な値: CloudWatch Contributor Insights Rule Syntaxに準拠したJSON文字列
  # 関連機能: Rule Definition Syntax
  #   ルール定義には、分析対象のログフィールド、集計方法、
  #   コントリビューターの識別方法を記述します。
  #   構造例:
  #   - "Schema": データソースのスキーマ定義
  #   - "AggregateOn": 集計対象フィールド
  #   - "Contribution": コントリビューターの識別キー
  #   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights-RuleSyntax.html
  rule_definition = jsonencode({
    Schema = {
      Name    = "CloudWatchLogRule"
      Version = 1
    }
    LogGroupNames = [
      "/aws/lambda/example-function"
    ]
    LogFormat    = "JSON"
    AggregateOn  = "Sum"
    Contribution = {
      Filters = []
      Keys = [
        "$.userIdentity.principalId"
      ]
      ValueOf = "$.responseElements.bytes"
    }
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

  #-------------------------------------------------------------
  # ルール状態設定
  #-------------------------------------------------------------

  # rule_state (Optional)
  # 設定内容: ルールの状態を指定します。
  # 設定可能な値:
  #   - "ENABLED": ルールを有効化し、データの収集と分析を開始
  #   - "DISABLED": ルールを無効化し、データ収集を停止
  # 省略時: デフォルトで有効化されます
  # 関連機能: Contributor Insights Rule State
  #   ルールを一時的に無効化することで、コスト削減や
  #   メンテナンス時のデータ収集停止が可能です。
  rule_state = "ENABLED"

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
    Name        = "example-contributor-insight-rule"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - resource_arn: Contributor Insight RuleのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
