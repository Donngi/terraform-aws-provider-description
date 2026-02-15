#---------------------------------------------------------------
# AWS API Gateway APIキー
#---------------------------------------------------------------
#
# API Gatewayでクライアント認証とAPIアクセス制御に使用するAPIキーを管理します。
# APIキーは使用量プラン（Usage Plan）と組み合わせて、APIのレート制限や
# クォータ管理を実現します。
#
# 主な用途:
#   - REST APIメソッドへのアクセス制御
#   - API使用量の追跡とモニタリング
#   - 使用量プランを通じたレート制限の適用
#
# 注意事項:
#   - APIキーの値は作成後に変更できません（変更する場合は再作成が必要）
#   - APIキーを機能させるには使用量プランへの関連付けが必須です
#   - APIキー単体では認証機能を提供しません（IAM、Lambda Authorizer等との併用を推奨）
#
# AWS公式ドキュメント:
#   - API GatewayでのAPIキー設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-setup-api-keys.html
#   - 使用量プランとAPIキー: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-usage-plans.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_api_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_api_key" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: APIキーの名前を指定します。
  # 設定可能な値: 任意の文字列（API Gateway内で一意である必要はありません）
  # 用途: APIキーを識別するための名前です。複数のキーを管理する際の識別に利用します。
  # 注意: 同じ名前のAPIキーを複数作成することが可能です。
  name = "my-api-key"

  # description (Optional)
  # 設定内容: APIキーの説明文を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  # 用途: APIキーの用途や対象アプリケーション等を記録します。
  description = "Production API key for mobile app v2"

  #-------------------------------------------------------------
  # キー管理設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: APIキーの有効/無効状態を制御します。
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: true（有効状態で作成されます）
  # 用途:
  #   - 一時的にAPIキーへのアクセスを無効化する場合に使用
  #   - キーのローテーション中の移行期間での制御
  #   - セキュリティインシデント発生時の緊急対応
  # 注意: 無効化されたキーでのAPI呼び出しは拒否されます。
  enabled = true

  # value (Optional)
  # 設定内容: APIキーの値をカスタム指定します。
  # 設定可能な値: 任意の文字列（最小20文字）
  # 省略時: AWS側で自動生成されます（推奨）
  # 用途:
  #   - 既存システムとの互換性維持のため特定の値を使用する場合
  #   - 他の環境から移行する場合
  # 注意:
  #   - このフィールドはセンシティブ情報として扱われます
  #   - セキュリティの観点から自動生成の使用を推奨
  #   - 作成後の値変更は不可（変更する場合は再作成が必要）
  value = null

  #-------------------------------------------------------------
  # AWS Marketplace連携
  #-------------------------------------------------------------

  # customer_id (Optional)
  # 設定内容: AWS Marketplaceの顧客識別子を指定します。
  # 設定可能な値: AWS Marketplaceから提供される顧客ID
  # 省略時: 顧客IDなし
  # 用途:
  #   - AWS Marketplace経由でAPIを販売/配布する場合に使用
  #   - 顧客ごとのAPI使用量追跡とメーター課金
  # 参考: https://docs.aws.amazon.com/marketplace/latest/userguide/saas-integrate-metering.html
  customer_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグを指定します。
  # 設定可能な値: キーと値のマップ（キー最大128文字、値最大256文字）
  # 省略時: タグなし
  # 用途:
  #   - リソースの分類と整理
  #   - コスト配分と追跡
  #   - アクセス制御ポリシーでの条件指定
  # 参考: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Environment = "production"
    Application = "mobile-app"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# 関連リソース: 使用量プランへの関連付け
#---------------------------------------------------------------
# APIキーを機能させるには使用量プラン（Usage Plan）への関連付けが必須です。

resource "aws_api_gateway_usage_plan" "example" {
  name        = "example-usage-plan"
  description = "Example usage plan for API key"

  # レート制限とクォータ設定
  throttle_settings {
    burst_limit = 200  # バースト制限（同時リクエスト数）
    rate_limit  = 100  # レート制限（1秒あたりのリクエスト数）
  }

  quota_settings {
    limit  = 10000   # 期間内の最大リクエスト数
    period = "MONTH" # 期間（DAY, WEEK, MONTH）
  }

  # APIステージとの関連付け
  api_stages {
    api_id = aws_api_gateway_rest_api.example.id
    stage  = aws_api_gateway_stage.example.stage_name
  }
}

# APIキーを使用量プランに関連付け
resource "aws_api_gateway_usage_plan_key" "example" {
  key_id        = aws_api_gateway_api_key.example.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.example.id
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: APIキーの一意識別子（例: abcdef123456）
#
# - arn: APIキーのARN（Amazon Resource Name）
#   形式: arn:aws:apigateway:REGION::/apikeys/KEY_ID
#
# - value: 生成されたAPIキーの値（センシティブ情報）
#   注意: Terraform outputで出力する場合は sensitive = true を設定してください
#
# - created_date: APIキーの作成日時（RFC3339形式のタイムスタンプ）
#   例: 2026-02-11T12:34:56Z
#
# - last_updated_date: APIキーの最終更新日時（RFC3339形式のタイムスタンプ）
#   例: 2026-02-11T15:20:30Z
#
# - tags_all: プロバイダーのdefault_tagsとマージされた全タグ
#---------------------------------------------------------------
