#---------------------------------------------------------------
# AWS API Gateway V2 Route
#---------------------------------------------------------------
#
# Amazon API Gateway Version 2のルートをプロビジョニングするリソースです。
# ルートは、受信APIリクエストをバックエンドリソースに振り分けます。
# HTTP APIとWebSocket APIの両方をサポートしています。
#
# AWS公式ドキュメント:
#   - WebSocket APIのルート: https://docs.aws.amazon.com/apigateway/latest/developerguide/websocket-api-develop-routes.html
#   - HTTP APIのルート: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-routes.html
#   - API Gatewayの概念: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-basic-concept.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apigatewayv2_route" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: ルートを作成するAPI GatewayのAPI識別子を指定します。
  # 設定可能な値: 有効なAPI Gateway V2 APIのID
  api_id = aws_apigatewayv2_api.example.id

  # route_key (Required)
  # 設定内容: ルートのルートキーを指定します。
  # 設定可能な値:
  #   - HTTP API: "$default" またはHTTPメソッドとリソースパスの組み合わせ
  #     例: "GET /pets", "POST /users", "ANY /proxy/{proxy+}"
  #   - WebSocket API: "$connect", "$disconnect", "$default", またはカスタムルートキー
  #     例: "join", "sendmessage"
  # 関連機能: API Gatewayルーティング
  #   HTTP APIではルートはHTTPメソッドとリソースパスで構成されます。
  #   WebSocket APIではroute selection expressionの評価結果と一致するルートキーを定義します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/websocket-api-develop-routes.html
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-routes.html
  route_key = "GET /example"

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
  # ターゲット設定
  #-------------------------------------------------------------

  # target (Optional)
  # 設定内容: ルートのターゲットを指定します。
  # 設定可能な値: "integrations/{IntegrationID}" 形式の文字列
  #   IntegrationIDはaws_apigatewayv2_integrationリソースのID
  # 省略時: ルートにはインテグレーションが設定されません
  # 関連機能: API Gatewayインテグレーション
  #   ルートをバックエンドサービス（Lambda関数、HTTPエンドポイント等）に接続します。
  target = "integrations/${aws_apigatewayv2_integration.example.id}"

  #-------------------------------------------------------------
  # 認可設定
  #-------------------------------------------------------------

  # authorization_type (Optional)
  # 設定内容: ルートの認可タイプを指定します。
  # 設定可能な値:
  #   - "NONE" (デフォルト): 認可なし（オープンアクセス）
  #   - "AWS_IAM": AWS IAMポリシーを使用した認可
  #   - "CUSTOM": Lambdaオーソライザーを使用した認可
  #   - "JWT" (HTTP APIのみ): JSON Web Tokenを使用した認可
  # 関連機能: API Gateway認可
  #   WebSocket APIでは$connectルートで設定した認可がAPI全体に適用されます。
  #   HTTP APIではルートごとに異なる認可を設定できます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-jwt-authorizer.html
  authorization_type = "NONE"

  # authorizer_id (Optional)
  # 設定内容: ルートに関連付けるオーソライザーのIDを指定します。
  # 設定可能な値: 有効なaws_apigatewayv2_authorizerリソースのID
  # 省略時: オーソライザーは関連付けられません
  # 注意: authorization_typeが"CUSTOM"または"JWT"の場合に必要
  authorizer_id = null

  # authorization_scopes (Optional)
  # 設定内容: JWTオーソライザーで使用する認可スコープを指定します。
  # 設定可能な値: スコープ名の文字列セット
  #   例: ["read:pets", "write:pets"]
  # 省略時: スコープによる制限なし
  # 関連機能: OAuth 2.0スコープ
  #   JWTオーソライザーでメソッド呼び出しを認可する際に使用されます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-jwt-authorizer.html
  authorization_scopes = null

  #-------------------------------------------------------------
  # APIキー設定
  #-------------------------------------------------------------

  # api_key_required (Optional)
  # 設定内容: ルートにAPIキーが必要かどうかを指定します。
  # 設定可能な値:
  #   - true: APIキー必須
  #   - false (デフォルト): APIキー不要
  # 注意: WebSocket APIの$connectルートでのみサポートされます
  # 関連機能: API Gateway APIキー
  #   使用量プランと組み合わせてAPIへのアクセスを制御・追跡できます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-usage-plans.html
  api_key_required = false

  #-------------------------------------------------------------
  # WebSocket API固有設定
  #-------------------------------------------------------------

  # model_selection_expression (Optional)
  # 設定内容: ルートのモデル選択式を指定します。
  # 設定可能な値: モデル選択式の文字列
  #   例: "$request.body.action"
  # 省略時: モデル選択式なし
  # 注意: WebSocket APIでのみサポートされます
  # 関連機能: API Gatewayモデル選択式
  #   リクエストペイロードに基づいて使用するモデルを選択します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-selection-expressions.html#apigateway-websocket-api-model-selection-expressions
  model_selection_expression = null

  # operation_name (Optional)
  # 設定内容: ルートの操作名を指定します。
  # 設定可能な値: 1〜64文字の文字列
  # 省略時: 操作名なし
  # 用途: ルートを識別するための説明的な名前
  operation_name = null

  # request_models (Optional)
  # 設定内容: ルートのリクエストモデルを指定します。
  # 設定可能な値: キーにコンテンツタイプ、値にモデル名を持つマップ
  #   例: { "application/json" = "MyModel" }
  # 省略時: リクエストモデルなし
  # 注意: WebSocket APIでのみサポートされます
  request_models = null

  # route_response_selection_expression (Optional)
  # 設定内容: ルートレスポンス選択式を指定します。
  # 設定可能な値: ルートレスポンス選択式の文字列
  #   例: "$default"
  # 省略時: ルートレスポンス選択式なし
  # 注意: WebSocket APIでのみサポートされます
  # 関連機能: API Gatewayルートレスポンス
  #   WebSocket APIで双方向通信を有効にするために設定します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-selection-expressions.html#apigateway-websocket-api-route-response-selection-expressions
  route_response_selection_expression = null

  #-------------------------------------------------------------
  # リクエストパラメータ設定
  #-------------------------------------------------------------

  # request_parameter (Optional, Multiple)
  # 設定内容: ルートのリクエストパラメータを指定します。
  # 注意: WebSocket APIでのみサポートされます
  # 関連機能: リクエストパラメータマッピング
  #   WebSocket APIでリクエストデータをマッピングするために使用します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/websocket-api-data-mapping.html#websocket-mapping-request-parameters
  #
  # request_parameter {
  #   # request_parameter_key (Required)
  #   # 設定内容: リクエストパラメータのキーを指定します。
  #   # 設定可能な値: リクエストデータマッピングパラメータキー
  #   #   例: "route.request.header.Authorization"
  #   request_parameter_key = "route.request.header.Authorization"
  #
  #   # required (Required)
  #   # 設定内容: パラメータが必須かどうかを指定します。
  #   # 設定可能な値:
  #   #   - true: パラメータ必須
  #   #   - false: パラメータ任意
  #   required = true
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ルート識別子
#
#---------------------------------------------------------------
