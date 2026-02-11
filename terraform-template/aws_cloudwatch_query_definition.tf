# ================================================================================
# aws_cloudwatch_query_definition
# ================================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点の情報です。
# 最新の仕様は公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_query_definition
# ================================================================================

# CloudWatch Logs Insights用のクエリ定義を作成・管理するリソース。
# 保存されたクエリはCloudWatch Logsコンソールから簡単に呼び出せるため、
# 頻繁に使用するクエリをチーム内で共有したり、定型的な分析を標準化できます。
#
# AWS公式ドキュメント:
# - API Reference: https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutQueryDefinition.html
# - Query Definition: https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_QueryDefinition.html
# - Query Syntax: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html

resource "aws_cloudwatch_query_definition" "example" {
  # ================================================================================
  # 必須パラメータ
  # ================================================================================

  # name - (必須) クエリ定義の名前
  # - 最小長: 1文字
  # - 最大長: 255文字
  # - CloudWatch Logsコンソールやリストで表示される識別名
  # - チーム内でわかりやすい命名規則を使用することを推奨
  name = "custom_query"

  # query_string - (必須) CloudWatch Logs Insightsクエリ文字列
  # - 最小長: 1文字
  # - 最大長: 10,000文字
  # - CloudWatch Logs Insights Query Language (CWLI)、SQL、PPLのいずれかの形式で記述
  # - 複数行のクエリを記述する場合はヒアドキュメント構文が便利
  # - クエリ構文の詳細: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html
  # - サンプルクエリ集: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax-examples.html
  query_string = <<EOF
fields @timestamp, @message
| sort @timestamp desc
| limit 25
EOF

  # ================================================================================
  # オプションパラメータ
  # ================================================================================

  # log_group_names - (オプション) クエリで使用する特定のロググループのリスト
  # - 型: list(string)
  # - 最小要素数: 1
  # - 最大要素数: 512
  # - 各要素の最小長: 1文字
  # - 各要素の最大長: 512文字
  # - このパラメータを指定すると、クエリ実行時にデフォルトでこれらのロググループが選択される
  # - 省略した場合、クエリ実行時にユーザーがロググループを手動で選択する必要がある
  # - 更新時にこのパラメータを省略すると、クエリ定義からロググループの関連付けが削除される
  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  # region - (オプション) このリソースが管理されるAWSリージョン
  # - デフォルト: プロバイダー設定で指定されたリージョン
  # - マルチリージョン構成で特定のリージョンにリソースを作成する場合に指定
  # - リージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - プロバイダー設定: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # region = "us-east-1"

  # id - (オプション) Terraformリソース識別子
  # - 通常は自動的に設定されるため、明示的な指定は不要
  # - カスタムIDを使用したい特殊なケースでのみ指定
  # id = "custom-id"
}

# ================================================================================
# 出力例
# ================================================================================

# 以下の属性が参照可能（computed）:
# - query_definition_id: クエリ定義のID（AWS側で自動生成される一意の識別子）

# 使用例:
# output "query_definition_id" {
#   description = "CloudWatch Logs Query DefinitionのID"
#   value       = aws_cloudwatch_query_definition.example.query_definition_id
# }
