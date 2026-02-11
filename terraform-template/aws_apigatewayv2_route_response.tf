#---------------------------------------------------------------
# AWS API Gateway V2 Route Response
#---------------------------------------------------------------
#
# Amazon API Gateway Version 2のルートレスポンスをプロビジョニングするリソースです。
# ルートレスポンスは、WebSocket APIでバックエンドからのレスポンスをクライアントに
# 返すために必要な設定です。API Gatewayは、ルートレスポンスが設定されていない限り、
# バックエンドのレスポンスをクライアントに返しません。
#
# AWS公式ドキュメント:
#   - WebSocket APIルートレスポンス: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-route-response.html
#   - WebSocket API概要: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route_response
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apigatewayv2_route_response" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: APIの識別子を指定します。
  # 設定可能な値: 有効なAPI Gateway V2 APIのID
  api_id = aws_apigatewayv2_api.example.id

  # route_id (Required)
  # 設定内容: ルートレスポンスを関連付けるルートの識別子を指定します。
  # 設定可能な値: 有効なaws_apigatewayv2_routeのID
  route_id = aws_apigatewayv2_route.example.id

  # route_response_key (Required)
  # 設定内容: ルートレスポンスのキーを指定します。
  # 設定可能な値:
  #   - "$default": デフォルトのルートレスポンス（WebSocket APIでは$defaultのみ定義可能）
  # 注意: WebSocket APIでは、$defaultルートレスポンスのみを定義できます。
  route_response_key = "$default"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # model_selection_expression (Optional)
  # 設定内容: ルートレスポンスのモデル選択式を指定します。
  # 設定可能な値: モデル選択式の文字列（例: "$request.body.action"）
  # 関連機能: モデル選択式
  #   受信メッセージの内容に基づいて、レスポンスボディの検証に使用するモデルを
  #   動的に選択するための式です。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-selection-expressions.html#apigateway-websocket-api-model-selection-expressions
  model_selection_expression = null

  # response_models (Optional)
  # 設定内容: ルートレスポンスのレスポンスモデルを指定します。
  # 設定可能な値: コンテンツタイプをキー、モデル名を値とするマップ
  # 例: { "application/json" = "ModelName" }
  # 関連機能: レスポンスモデル
  #   レスポンスボディのデータ構造を記述するJSONスキーマです。
  #   API Gatewayでモデルを作成し、その名前を指定します。
  response_models = {
    "application/json" = "ExampleModel"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ルートレスポンスの識別子
#---------------------------------------------------------------
