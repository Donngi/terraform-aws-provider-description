#####################################################################
# Terraform Resource Template: aws_cloudwatch_contributor_insight_rule
#####################################################################
# 生成日: 2026-01-18
# Provider Version: hashicorp/aws 6.28.0
#
# 注意: このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については、公式ドキュメントを必ずご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_contributor_insight_rule
#####################################################################

resource "aws_cloudwatch_contributor_insight_rule" "example" {
  #####################################################################
  # 必須パラメータ (Required Parameters)
  #####################################################################

  # rule_name - (Required) ルールの一意な名前
  # Contributor Insightsルールを識別するための名前を指定します。
  # 同一リージョン内で一意である必要があります。
  # Type: string
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights.html
  rule_name = "example-contributor-insight-rule"

  # rule_definition - (Required) ルールの定義（JSON形式）
  # Contributor Insightsルールの詳細な設定をJSON文字列で指定します。
  # Schema、LogGroupNames、LogFormat、Contribution、AggregateOnなどの
  # フィールドを含む必要があります。
  # Type: string
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights-RuleSyntax.html
  rule_definition = jsonencode({
    Schema = {
      Name    = "CloudWatchLogRule"
      Version = 1
    }
    AggregateOn = "Count"
    Contribution = {
      Filters = [
        {
          Match = "$.eventType"
          In    = ["ERROR"]
        }
      ]
      Keys = ["$.userIdentity.principalId"]
    }
    LogFormat      = "JSON"
    LogGroupNames  = ["/aws/lambda/example-function"]
  })

  #####################################################################
  # オプションパラメータ (Optional Parameters)
  #####################################################################

  # region - (Optional) このリソースが管理されるリージョン
  # リソースが作成されるAWSリージョンを指定します。
  # 未指定の場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # Type: string
  # Computed: true (未指定時は自動設定)
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # rule_state - (Optional) ルールの状態
  # ルールの有効/無効状態を指定します。
  # 有効な値: "ENABLED", "DISABLED"
  # デフォルト: "ENABLED"（明示的に指定しない場合）
  # Type: string
  rule_state = "ENABLED"

  # tags - (Optional) リソースに割り当てるタグ
  # ルールに付与するタグのマップを指定します。
  # コスト管理やリソース整理に使用できます。
  # Type: map(string)
  # 注意: tags_all（全タグを含む計算済み属性）は自動的に管理されます
  tags = {
    Name        = "example-contributor-insight-rule"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #####################################################################
  # 計算専用属性 (Computed-only Attributes)
  #####################################################################
  # 以下の属性は自動的に計算され、Terraform設定で指定できません:
  #
  # - resource_arn (string): Contributor Insight RuleのARN
  #   作成されたルールのAmazon Resource Name (ARN)
  #
  # - tags_all (map(string)): すべてのタグ
  #   プロバイダーレベルのdefault_tagsとリソースレベルのtagsを
  #   マージした完全なタグマップ
  #####################################################################
}

#####################################################################
# 補足情報 (Additional Information)
#####################################################################
#
# Contributor Insightsについて:
# - ログデータを分析し、トップコントリビューターを特定するための機能です
# - リアルタイムでログデータを解析し、時系列データを生成します
# - システムパフォーマンスに影響を与えている要因を特定するのに役立ちます
#
# rule_definition の主要フィールド:
# - Schema: ルールのスキーマバージョン（通常は {Name: "CloudWatchLogRule", Version: 1}）
# - LogGroupNames: 分析対象のCloudWatch Logsのロググループ名のリスト
# - LogFormat: ログのフォーマット（JSON, CLF, Apache, etc.）
# - Contribution: 分析条件（Keys: 分析キー、Filters: フィルター条件）
# - AggregateOn: 集計方法（Count, Sum, etc.）
#
# 料金について:
# - ルールに一致するログイベントの発生回数に応じて課金されます
# - 詳細: https://aws.amazon.com/cloudwatch/pricing/
#
# 制限事項:
# - ルールが参照する数値は -1e9 から 1e9 の範囲内である必要があります
# - 範囲外の値を持つログエントリはスキップされます
#
# 関連リソース:
# - aws_cloudwatch_log_group: ログデータのソース
#
#####################################################################
