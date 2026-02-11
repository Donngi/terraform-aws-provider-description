################################################################################
# AWS Lambda Alias
################################################################################
# Lambda関数のエイリアスを管理するリソース
# 特定のLambda関数バージョンを指すエイリアスを作成し、トラフィック管理とデプロイ戦略に使用
#
# ユースケース:
# - 環境別エイリアス（production、staging、devなど）の管理
# - Blue-Greenデプロイメント戦略
# - カナリアデプロイメント（トラフィック分割）
# - バージョン管理とロールバック
#
# 参照: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lambda_alias

resource "aws_lambda_alias" "example" {
  # エイリアスの名前
  # パターン: (?!^[0-9]+$)([a-zA-Z0-9-_]+)
  # 必須
  # 命名例: "production", "staging", "dev", "live"
  name = "production"

  # エイリアスの説明
  # オプション
  # 推奨: エイリアスの目的や使用環境を明記
  description = "Production environment alias"

  # Lambda関数の名前またはARN
  # 必須
  # 指定可能な値:
  # - 関数名: "my-function"
  # - 関数ARN: "arn:aws:lambda:us-east-1:123456789012:function:my-function"
  # - 関数名とエイリアスの組み合わせなども可能
  function_name = "example-function"

  # このエイリアスが指すLambda関数のバージョン
  # パターン: (\$LATEST|[0-9]+)
  # 必須
  # "$LATEST" を使用すると常に最新バージョンを指す（開発環境で便利）
  # 数値（"1", "2"など）で特定のバージョンを指定（本番環境推奨）
  function_version = "1"

  # リソースを管理するAWSリージョン
  # オプション（デフォルト: プロバイダー設定のリージョン）
  # region = "us-east-1"

  # トラフィック分割の設定（カナリアデプロイメント用）
  # オプション
  # routing_config {
  #   # 追加バージョンへのトラフィック重み付け（マップ形式）
  #   # キー: バージョン番号（文字列）
  #   # 値: トラフィック割合（0.0～1.0）
  #   # 例: { "2" = 0.1 } → バージョン2に10%のトラフィックを送信
  #   #                    → 残り90%はfunction_versionで指定したバージョンに送信
  #   additional_version_weights = {
  #     "2" = 0.1  # バージョン2に10%のトラフィック
  #     "3" = 0.05 # バージョン3に5%のトラフィック
  #   }
  # }
}

################################################################################
# 出力値
################################################################################

# Lambda関数エイリアスのARN
output "lambda_alias_arn" {
  description = "ARN identifying your Lambda function alias"
  value       = aws_lambda_alias.example.arn
}

# API Gatewayから呼び出す際に使用するARN
output "lambda_alias_invoke_arn" {
  description = "ARN to be used for invoking Lambda Function from API Gateway"
  value       = aws_lambda_alias.example.invoke_arn
}

################################################################################
# 使用例
################################################################################

# 例1: 基本的なエイリアス
# resource "aws_lambda_alias" "production" {
#   name             = "production"
#   description      = "Production environment alias"
#   function_name    = aws_lambda_function.example.arn
#   function_version = "1"
# }

# 例2: トラフィック分割を使用したエイリアス（カナリアデプロイメント）
# resource "aws_lambda_alias" "staging" {
#   name             = "staging"
#   description      = "Staging environment with traffic splitting"
#   function_name    = aws_lambda_function.example.function_name
#   function_version = "2"
#
#   routing_config {
#     additional_version_weights = {
#       "1" = 0.1 # バージョン1に10%のトラフィック
#       # 残り90%はバージョン2（プライマリ）に送信
#     }
#   }
# }

# 例3: Blue-Greenデプロイメント用エイリアス
# resource "aws_lambda_alias" "live" {
#   name             = "live"
#   description      = "Live traffic with gradual rollout to new version"
#   function_name    = aws_lambda_function.example.function_name
#   function_version = "5" # 現在の安定版
#
#   routing_config {
#     additional_version_weights = {
#       "6" = 0.05 # 新バージョンに5%のトラフィックを送信してテスト
#     }
#   }
# }

# 例4: 開発環境用エイリアス（常に最新版を指す）
# resource "aws_lambda_alias" "dev" {
#   name             = "dev"
#   description      = "Development environment - always points to latest"
#   function_name    = aws_lambda_function.example.function_name
#   function_version = "$LATEST"
# }

################################################################################
# ベストプラクティスとヒント
################################################################################
# 1. 本番環境では$LATESTの使用を避け、特定のバージョン番号を指定
# 2. カナリアデプロイメントでは小さい割合（5-10%）から始める
# 3. エイリアス名は環境や用途を明確に表す命名規則を採用
# 4. API Gatewayとの統合時はinvoke_arnを使用
# 5. 複数の環境（dev/staging/prod）で異なるエイリアスを使用することで
#    デプロイメントパイプラインを管理
# 6. トラフィック分割は合計が1.0を超えないように注意
#    （超過分は自動的に調整される）
# 7. エイリアスを削除すると、そのエイリアスを参照している他のサービス
#    （API Gateway、EventBridgeなど）に影響が出るため注意
