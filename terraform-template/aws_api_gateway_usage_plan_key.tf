#---------------------------------------------------------------
# API Gateway 使用量プランキー
#---------------------------------------------------------------
#
# API Gateway の使用量プランに API キーを関連付けるリソースです。
# 使用量プランは API へのアクセスを管理し、スロットリング制限やクォータを
# 設定します。API キーを使用量プランに関連付けることで、その API キーを
# 使用するクライアントに対して使用量プランで定義された制限が適用されます。
#
# 注意事項:
# - API キーは各ステージごとに 1 つの使用量プランにのみ関連付けることが
#   できます。
# - 使用量プランへの API キーの追加後、更新操作が完了するまで数分かかる
#   場合があります。
#
# AWS公式ドキュメント:
#   - 使用量プランの作成: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-usage-plans.html
#   - CreateUsagePlanKey API: https://docs.aws.amazon.com/apigateway/latest/api/API_CreateUsagePlanKey.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_usage_plan_key" "example" {

  #---------------------------------------------------------------
  # 必須設定
  #---------------------------------------------------------------

  # usage_plan_id (Required)
  # 設定内容: API キーを関連付ける使用量プランの ID を指定します。
  # 参照例: aws_api_gateway_usage_plan.main.id
  usage_plan_id = "usage-plan-id"

  # key_id (Required)
  # 設定内容: 使用量プランに関連付ける API キーの ID を指定します。
  # 参照例: aws_api_gateway_api_key.main.id
  key_id = "api-key-id"

  # key_type (Required)
  # 設定内容: API キーリソースのタイプを指定します。
  # 設定可能な値: API_KEY（現在サポートされている唯一のタイプ）
  key_type = "API_KEY"

  #---------------------------------------------------------------
  # オプション設定
  #---------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 用途: マルチリージョン構成でリソースごとにリージョンを指定する場合に使用します。
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 使用量プランキーの ID
# - key_id: API Gateway キーリソースの ID
# - key_type: 使用量プランキーのタイプ（現在は API_KEY のみ）
# - usage_plan_id: API リソースの ID
# - name: 使用量プランキーの名前
# - value: 使用量プランキーの値
#---------------------------------------------------------------
