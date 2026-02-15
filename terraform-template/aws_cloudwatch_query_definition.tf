#---------------------------------------
# aws_cloudwatch_query_definition
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_query_definition
#
# NOTE:
# CloudWatch Logs Insights クエリ定義を作成・管理するリソースです
# 頻繁に使用するクエリを保存して再利用可能にし、チーム間でのログ分析を効率化します
#
# 主な用途:
# - CloudWatch Logs Insights クエリの保存と共有
# - よく使用するログ分析パターンの標準化
# - チーム全体での一貫したログ分析の実現
#
# 制約事項:
# - クエリ文字列はCloudWatch Logs Insights クエリ構文に準拠する必要があります
# - 保存したクエリはコンソールやAPIから呼び出して実行できます
# - ロググループ名の指定は任意で、実行時に上書き可能です

#-----------------------------------------------------------------------
# リソース定義
#-----------------------------------------------------------------------
resource "aws_cloudwatch_query_definition" "example" {
  #-----------------------------------------------------------------------
  # 基本設定
  #-----------------------------------------------------------------------

  # クエリ定義の名前（必須）
  # 設定内容: CloudWatch Logs Insights クエリの識別名
  # 設定可能な値: 任意の文字列（コンソールやAPIで表示される名前）
  # 推奨値: クエリの目的を明確に示す名前（例: "Error-Analysis", "API-Latency-P99"）
  name = "my-query-definition"

  # CloudWatch Logs Insights クエリ文字列（必須）
  # 設定内容: 実行するクエリの内容をCloudWatch Logs Insights クエリ構文で記述
  # 設定可能な値: 有効なCloudWatch Logs Insights クエリ構文
  # 例: fields @timestamp, @message | filter @message like /ERROR/ | sort @timestamp desc | limit 20
  query_string = <<-EOT
    fields @timestamp, @message
    | filter @message like /ERROR/
    | sort @timestamp desc
    | limit 20
  EOT

  #-----------------------------------------------------------------------
  # ロググループ設定
  #-----------------------------------------------------------------------

  # クエリ対象のロググループ名リスト（オプション）
  # 設定内容: このクエリが対象とするCloudWatch Logs ロググループ名のリスト
  # 設定可能な値: 既存のロググループ名の配列
  # 省略時: ロググループを指定せずにクエリ定義のみ保存（実行時に選択可能）
  log_group_names = [
    "/aws/lambda/my-function",
    "/aws/lambda/another-function"
  ]

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # リソース管理リージョン（オプション）
  # 設定内容: このクエリ定義を管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョン名（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"
}

#-----------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-----------------------------------------------------------------------
# id                  : リソースID（query_definition_id と同値）
# query_definition_id : クエリ定義の一意なID（AWSが自動生成）
# region              : リソースが管理されているリージョン名
