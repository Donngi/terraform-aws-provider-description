#---------------------------------------------------------------
# AWS API Gateway V2 Integration Response
#---------------------------------------------------------------
#
# Amazon API Gateway Version 2のインテグレーションレスポンスを
# プロビジョニングするリソースです。
# インテグレーションレスポンスは、WebSocket APIにおいてバックエンドからの
# レスポンスをクライアントに返す前に変換・加工するための設定を定義します。
#
# AWS公式ドキュメント:
#   - WebSocket API概要: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api.html
#   - インテグレーションレスポンス: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-integration-responses.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration_response
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apigatewayv2_integration_response" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: API識別子を指定します。
  # 設定可能な値: aws_apigatewayv2_apiリソースのID
  # 注意: WebSocket APIまたはHTTP APIのIDを指定します。
  api_id = aws_apigatewayv2_api.example.id

  # integration_id (Required)
  # 設定内容: インテグレーションの識別子を指定します。
  # 設定可能な値: aws_apigatewayv2_integrationリソースのID
  # 注意: このレスポンス設定が適用されるインテグレーションを指定します。
  integration_id = aws_apigatewayv2_integration.example.id

  # integration_response_key (Required)
  # 設定内容: インテグレーションレスポンスキーを指定します。
  # 設定可能な値:
  #   - WebSocket APIの場合: レスポンスを選択するためのキー
  #     例: "/200/", "/400/", "$default"
  #   - 正規表現パターンを使用可能
  # 関連機能: レスポンスルーティング
  #   バックエンドからのレスポンスを適切なレスポンス設定にマッピングするために使用します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-integration-responses.html
  integration_response_key = "/200/"

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
  # コンテンツ変換設定
  #-------------------------------------------------------------

  # content_handling_strategy (Optional)
  # 設定内容: レスポンスペイロードのコンテンツタイプ変換方法を指定します。
  # 設定可能な値:
  #   - "CONVERT_TO_BINARY": レスポンスペイロードをBase64エンコードされた文字列から
  #                          対応するバイナリBlobに変換
  #   - "CONVERT_TO_TEXT": レスポンスペイロードをバイナリBlobから
  #                        Base64エンコードされた文字列に変換
  # 省略時: ペイロードはパススルーで変換なし
  # 関連機能: バイナリメディアタイプ
  #   API Gatewayでバイナリデータを扱う場合に使用します。
  #   画像やドキュメントなどのバイナリコンテンツを送受信する際に設定します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/websocket-api-develop-binary-media-types.html
  content_handling_strategy = null

  #-------------------------------------------------------------
  # レスポンステンプレート設定
  #-------------------------------------------------------------

  # response_templates (Optional)
  # 設定内容: リクエストペイロードに適用されるVelocityテンプレートのマップを指定します。
  # 設定可能な値: キーはContent-Typeヘッダー値、値はVTL（Velocity Template Language）テンプレート
  # 関連機能: データ変換
  #   クライアントが送信するContent-Typeヘッダーの値に基づいて、
  #   適切なテンプレートが選択され、レスポンスデータを変換します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-mapping-template-reference.html
  response_templates = {
    "application/json" = "$input.json('$')"
  }

  # template_selection_expression (Optional)
  # 設定内容: インテグレーションレスポンス用のテンプレート選択式を指定します。
  # 設定可能な値: 選択式の文字列
  #   例: "$request.body.action"
  # 関連機能: 選択式
  #   API Gatewayの選択式を使用して、実行時にどのテンプレートを使用するかを決定します。
  #   response_templatesに複数のテンプレートがある場合に、
  #   リクエストやコンテキストに基づいて適切なテンプレートを選択します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-selection-expressions.html#apigateway-websocket-api-template-selection-expressions
  template_selection_expression = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: インテグレーションレスポンス識別子
#---------------------------------------------------------------
