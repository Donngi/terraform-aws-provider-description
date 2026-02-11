#---------------------------------------------------------------
# AWS API Gateway Usage Plan Key
#---------------------------------------------------------------
#
# API GatewayのAPIキーと使用プランを関連付けるリソースです。
# 使用プランキーを作成することで、特定のAPIキーを使用プランに紐づけ、
# スロットリングやクォータ制限を適用できます。
#
# AWS公式ドキュメント:
#   - API Gateway使用プラン: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-usage-plans.html
#   - APIキーの作成と使用: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-setup-api-key-with-console.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan_key
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_usage_plan_key" "example" {
  #-------------------------------------------------------------
  # 識別子設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: 使用プランキーのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformが自動的に生成します。
  # 注意: 通常は指定不要で、Terraformがリソース作成時に自動的に割り当てます。
  id = null

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
  # APIキー設定
  #-------------------------------------------------------------

  # key_id (Required)
  # 設定内容: 使用プランに関連付けるAPIキーリソースの識別子を指定します。
  # 設定可能な値: aws_api_gateway_api_keyリソースのID
  # 関連機能: API Gateway APIキー
  #   APIへのアクセスを制御するための英数字の文字列。
  #   使用プランと組み合わせてリクエストのスロットリングやクォータ制限を適用できます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-setup-api-key-with-console.html
  key_id = aws_api_gateway_api_key.example.id

  # key_type (Required)
  # 設定内容: APIキーリソースのタイプを指定します。
  # 設定可能な値:
  #   - "API_KEY": APIキータイプ（現在サポートされている唯一の値）
  key_type = "API_KEY"

  #-------------------------------------------------------------
  # 使用プラン設定
  #-------------------------------------------------------------

  # usage_plan_id (Required)
  # 設定内容: キーを関連付ける使用プランリソースのIDを指定します。
  # 設定可能な値: aws_api_gateway_usage_planリソースのID
  # 関連機能: API Gateway使用プラン
  #   APIステージへのアクセスを制御するための設定。
  #   スロットリング制限やクォータ制限を設定し、APIの使用量を管理できます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-usage-plans.html
  usage_plan_id = aws_api_gateway_usage_plan.example.id
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 使用プランキーのID
#
# - name: 使用プランキーの名前
#
# - value: 使用プランキーの値（APIキーの値）
#---------------------------------------------------------------
