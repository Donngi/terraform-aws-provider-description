# ================================================================================
# Terraform AWS Provider Resource Template
# ================================================================================
# Resource: aws_api_gateway_api_key
# Provider Version: 6.28.0
# Generated: 2026-01-22
#
# このテンプレートは生成時点の AWS Provider バージョンに基づいています。
# 最新の仕様については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_api_key
# ================================================================================

# ================================================================================
# AWS API Gateway API Key
# ================================================================================
# Amazon API Gateway の API キーを作成するリソースです。
# API キーは、使用量プラン（Usage Plan）と組み合わせて、
# API へのアクセス制御、レート制限、クォータ管理を実現します。
#
# 重要な注意点:
# - 2016年8月11日以降、API キーを API ステージと関連付けるには
#   使用量プランが必須です
# - API キーは認証・認可の手段として使用すべきではありません
#   （ベストプラクティス）
# - 1つのステージに対して、1つの API キーは1つの使用量プランにのみ
#   関連付けられます
#
# AWS公式ドキュメント:
# - API Gateway での API キーと使用量プラン
#   https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-usage-plans.html
# ================================================================================

resource "aws_api_gateway_api_key" "example" {
  # ================================================================================
  # 必須パラメータ
  # ================================================================================

  # API キーの名前
  # - 管理コンソールや API 呼び出しで識別するための名前
  # - ユニークである必要はありませんが、識別しやすい名前を推奨
  name = "example-api-key"

  # ================================================================================
  # オプションパラメータ - 基本設定
  # ================================================================================

  # API キーの説明
  # - API キーの用途や関連するアプリケーションなどを記載
  # - デフォルト: "Managed by Terraform"
  description = "API key for example application"

  # API キーの有効/無効状態
  # - true: API キーを使用可能にする（デフォルト）
  # - false: API キーを無効化（一時的に無効化する場合に使用）
  # - API キーを削除せずにアクセスを停止したい場合に便利
  enabled = true

  # ================================================================================
  # オプションパラメータ - API キー値
  # ================================================================================

  # API キーの値（カスタム値を指定する場合）
  # - 指定する場合: 20～128文字の英数字文字列である必要があります
  # - 指定しない場合: AWS が自動的に生成します（推奨）
  # - セキュリティ上の理由から、AWS による自動生成を推奨
  # - この値は機密情報として扱われます（sensitive）
  # value = "your-custom-api-key-value-here"

  # ================================================================================
  # オプションパラメータ - AWS Marketplace 連携
  # ================================================================================

  # AWS Marketplace カスタマー識別子
  # - AWS SaaS Marketplace と統合する場合に使用
  # - Marketplace 経由で API を販売する場合にのみ必要
  # - 通常のユースケースでは設定不要
  # customer_id = "marketplace-customer-id"

  # ================================================================================
  # オプションパラメータ - リージョン設定
  # ================================================================================

  # このリソースを管理するリージョン
  # - 指定しない場合: プロバイダー設定のリージョンを使用（推奨）
  # - マルチリージョン構成の場合に明示的に指定
  # - 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ================================================================================
  # オプションパラメータ - タグ
  # ================================================================================

  # リソースタグ
  # - コスト配分、リソース管理、自動化などに使用
  # - プロバイダーレベルで default_tags を設定している場合、
  #   ここで指定したタグが優先されます
  tags = {
    Name        = "example-api-key"
    Environment = "production"
    ManagedBy   = "Terraform"
    Application = "example-app"
  }

  # タグの統合設定
  # - プロバイダーの default_tags と統合されたタグマップ
  # - 通常は明示的に設定する必要はありません
  # - computed 属性として自動的に計算されます
  # tags_all = {}

  # ================================================================================
  # 参考: Computed 属性（読み取り専用）
  # ================================================================================
  # 以下の属性は Terraform によって自動的に設定され、参照のみ可能です:
  #
  # - id: API キーの ID
  # - arn: API キーの Amazon Resource Name (ARN)
  # - created_date: API キーの作成日時（RFC3339 形式）
  # - last_updated_date: API キーの最終更新日時（RFC3339 形式）
  # - tags_all: プロバイダーの default_tags と統合されたタグマップ
  # ================================================================================
}

# ================================================================================
# 使用例: 使用量プランとの関連付け
# ================================================================================
# API キーは単体では機能せず、使用量プラン（Usage Plan）と
# ステージとの関連付けが必須です。
#
# 以下は aws_api_gateway_usage_plan および aws_api_gateway_usage_plan_key
# リソースと組み合わせた完全な例です:

# resource "aws_api_gateway_usage_plan" "example" {
#   name = "example-usage-plan"
#
#   api_stages {
#     api_id = aws_api_gateway_rest_api.example.id
#     stage  = aws_api_gateway_stage.example.stage_name
#   }
#
#   quota_settings {
#     limit  = 1000
#     period = "MONTH"
#   }
#
#   throttle_settings {
#     burst_limit = 200
#     rate_limit  = 100
#   }
# }
#
# resource "aws_api_gateway_usage_plan_key" "example" {
#   key_id        = aws_api_gateway_api_key.example.id
#   key_type      = "API_KEY"
#   usage_plan_id = aws_api_gateway_usage_plan.example.id
# }

# ================================================================================
# 出力例
# ================================================================================
# output "api_key_id" {
#   description = "The ID of the API key"
#   value       = aws_api_gateway_api_key.example.id
# }
#
# output "api_key_value" {
#   description = "The value of the API key"
#   value       = aws_api_gateway_api_key.example.value
#   sensitive   = true
# }
#
# output "api_key_arn" {
#   description = "The ARN of the API key"
#   value       = aws_api_gateway_api_key.example.arn
# }

# ================================================================================
# Terraform AWS Provider Resource Template
# ================================================================================
# Resource: aws_api_gateway_api_key
# Provider Version: 6.28.0
# Generated: 2026-01-22
#
# このテンプレートは生成時点の AWS Provider バージョンに基づいています。
# 最新の仕様については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_api_key
# ================================================================================

# ================================================================================
# AWS API Gateway API Key
# ================================================================================
# Amazon API Gateway の API キーを作成するリソースです。
# API キーは、使用量プラン（Usage Plan）と組み合わせて、
# API へのアクセス制御、レート制限、クォータ管理を実現します。
#
# 重要な注意点:
# - 2016年8月11日以降、API キーを API ステージと関連付けるには
#   使用量プランが必須です
# - API キーは認証・認可の手段として使用すべきではありません
#   （ベストプラクティス）
# - 1つのステージに対して、1つの API キーは1つの使用量プランにのみ
#   関連付けられます
#
# AWS公式ドキュメント:
# - API Gateway での API キーと使用量プラン
#   https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-usage-plans.html
# ================================================================================

resource "aws_api_gateway_api_key" "example" {
  # ================================================================================
  # 必須パラメータ
  # ================================================================================

  # API キーの名前
  # - 管理コンソールや API 呼び出しで識別するための名前
  # - ユニークである必要はありませんが、識別しやすい名前を推奨
  name = "example-api-key"

  # ================================================================================
  # オプションパラメータ - 基本設定
  # ================================================================================

  # API キーの説明
  # - API キーの用途や関連するアプリケーションなどを記載
  # - デフォルト: "Managed by Terraform"
  description = "API key for example application"

  # API キーの有効/無効状態
  # - true: API キーを使用可能にする（デフォルト）
  # - false: API キーを無効化（一時的に無効化する場合に使用）
  # - API キーを削除せずにアクセスを停止したい場合に便利
  enabled = true

  # ================================================================================
  # オプションパラメータ - API キー値
  # ================================================================================

  # API キーの値（カスタム値を指定する場合）
  # - 指定する場合: 20～128文字の英数字文字列である必要があります
  # - 指定しない場合: AWS が自動的に生成します（推奨）
  # - セキュリティ上の理由から、AWS による自動生成を推奨
  # - この値は機密情報として扱われます（sensitive）
  # value = "your-custom-api-key-value-here"

  # ================================================================================
  # オプションパラメータ - AWS Marketplace 連携
  # ================================================================================

  # AWS Marketplace カスタマー識別子
  # - AWS SaaS Marketplace と統合する場合に使用
  # - Marketplace 経由で API を販売する場合にのみ必要
  # - 通常のユースケースでは設定不要
  # customer_id = "marketplace-customer-id"

  # ================================================================================
  # オプションパラメータ - リージョン設定
  # ================================================================================

  # このリソースを管理するリージョン
  # - 指定しない場合: プロバイダー設定のリージョンを使用（推奨）
  # - マルチリージョン構成の場合に明示的に指定
  # - 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ================================================================================
  # オプションパラメータ - タグ
  # ================================================================================

  # リソースタグ
  # - コスト配分、リソース管理、自動化などに使用
  # - プロバイダーレベルで default_tags を設定している場合、
  #   ここで指定したタグが優先されます
  tags = {
    Name        = "example-api-key"
    Environment = "production"
    ManagedBy   = "Terraform"
    Application = "example-app"
  }

  # タグの統合設定
  # - プロバイダーの default_tags と統合されたタグマップ
  # - 通常は明示的に設定する必要はありません
  # - computed 属性として自動的に計算されます
  # tags_all = {}

  # ================================================================================
  # 参考: Computed 属性（読み取り専用）
  # ================================================================================
  # 以下の属性は Terraform によって自動的に設定され、参照のみ可能です:
  #
  # - id: API キーの ID
  # - arn: API キーの Amazon Resource Name (ARN)
  # - created_date: API キーの作成日時（RFC3339 形式）
  # - last_updated_date: API キーの最終更新日時（RFC3339 形式）
  # - tags_all: プロバイダーの default_tags と統合されたタグマップ
  # ================================================================================
}

# ================================================================================
# 使用例: 使用量プランとの関連付け
# ================================================================================
# API キーは単体では機能せず、使用量プラン（Usage Plan）と
# ステージとの関連付けが必須です。
#
# 以下は aws_api_gateway_usage_plan および aws_api_gateway_usage_plan_key
# リソースと組み合わせた完全な例です:

# resource "aws_api_gateway_usage_plan" "example" {
#   name = "example-usage-plan"
#
#   api_stages {
#     api_id = aws_api_gateway_rest_api.example.id
#     stage  = aws_api_gateway_stage.example.stage_name
#   }
#
#   quota_settings {
#     limit  = 1000
#     period = "MONTH"
#   }
#
#   throttle_settings {
#     burst_limit = 200
#     rate_limit  = 100
#   }
# }
#
# resource "aws_api_gateway_usage_plan_key" "example" {
#   key_id        = aws_api_gateway_api_key.example.id
#   key_type      = "API_KEY"
#   usage_plan_id = aws_api_gateway_usage_plan.example.id
# }

# ================================================================================
# 出力例
# ================================================================================
# output "api_key_id" {
#   description = "The ID of the API key"
#   value       = aws_api_gateway_api_key.example.id
# }
#
# output "api_key_value" {
#   description = "The value of the API key"
#   value       = aws_api_gateway_api_key.example.value
#   sensitive   = true
# }
#
# output "api_key_arn" {
#   description = "The ARN of the API key"
#   value       = aws_api_gateway_api_key.example.arn
# }

