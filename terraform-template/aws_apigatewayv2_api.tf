#---------------------------------------------------------------
# AWS API Gateway V2 API
#---------------------------------------------------------------
#
# Amazon API Gateway Version 2 APIをプロビジョニングするリソースです。
# WebSocket APIおよびHTTP APIの作成とデプロイに使用します。
# REST APIを作成する場合はAPI Gateway Version 1リソース（aws_api_gateway_rest_api）
# を使用してください。
#
# AWS公式ドキュメント:
#   - HTTP API概要: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html
#   - WebSocket API概要: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api.html
#   - API Gatewayの概念: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-basic-concept.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apigatewayv2_api" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: APIの名前を指定します。
  # 設定可能な値: 128文字以下の文字列
  name = "example-api"

  # protocol_type (Required)
  # 設定内容: APIのプロトコルタイプを指定します。
  # 設定可能な値:
  #   - "HTTP": HTTP API。RESTful APIやシンプルなHTTPプロキシに適用
  #   - "WEBSOCKET": WebSocket API。双方向リアルタイム通信に適用
  # 注意: 一度作成した後はプロトコルタイプを変更できません
  protocol_type = "HTTP"

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
  # API説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: APIの説明を指定します。
  # 設定可能な値: 1024文字以下の文字列
  description = "Example API Gateway V2 API"

  # version (Optional)
  # 設定内容: APIのバージョン識別子を指定します。
  # 設定可能な値: 1-64文字の文字列
  version = "1.0.0"

  #-------------------------------------------------------------
  # IPアドレスタイプ設定
  #-------------------------------------------------------------

  # ip_address_type (Optional)
  # 設定内容: APIを呼び出せるIPアドレスタイプを指定します。
  # 設定可能な値:
  #   - "ipv4" (デフォルト): IPv4アドレスのみからAPIを呼び出し可能
  #   - "dualstack": IPv4およびIPv6アドレスの両方からAPIを呼び出し可能
  ip_address_type = "ipv4"

  #-------------------------------------------------------------
  # APIキー選択式設定（WebSocket API向け）
  #-------------------------------------------------------------

  # api_key_selection_expression (Optional)
  # 設定内容: APIキー選択式を指定します。WebSocket APIに適用されます。
  # 設定可能な値:
  #   - "$context.authorizer.usageIdentifierKey": オーソライザーから返されるusageIdentifierKeyを使用
  #   - "$request.header.x-api-key" (デフォルト): リクエストヘッダーのx-api-keyを使用
  # 関連機能: API Gateway WebSocket API APIキー選択式
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-selection-expressions.html#apigateway-websocket-api-apikey-selection-expressions
  api_key_selection_expression = "$request.header.x-api-key"

  #-------------------------------------------------------------
  # ルート選択式設定
  #-------------------------------------------------------------

  # route_selection_expression (Optional)
  # 設定内容: ルート選択式を指定します。受信リクエストを適切なルートにルーティングします。
  # 設定可能な値:
  #   - HTTP APIの場合: デフォルトは "$request.method $request.path"
  #   - WebSocket APIの場合: 例 "$request.body.action"
  # 関連機能: API Gateway ルート選択式
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-selection-expressions.html#apigateway-websocket-api-route-selection-expressions
  route_selection_expression = "$request.method $request.path"

  #-------------------------------------------------------------
  # エンドポイント設定
  #-------------------------------------------------------------

  # disable_execute_api_endpoint (Optional)
  # 設定内容: デフォルトのexecute-apiエンドポイントを無効化するかを指定します。
  # 設定可能な値:
  #   - true: デフォルトエンドポイントを無効化。カスタムドメイン名のみでAPIを呼び出し可能
  #   - false (デフォルト): デフォルトエンドポイント {api_id}.execute-api.{region}.amazonaws.com を使用可能
  # 用途: カスタムドメインのみでAPIにアクセスさせたい場合に使用
  disable_execute_api_endpoint = false

  #-------------------------------------------------------------
  # Quick Create設定（HTTP API向け）
  #-------------------------------------------------------------
  # Quick Createは、統合、デフォルトのキャッチオールルート、
  # 自動デプロイが設定されたデフォルトステージを持つAPIを素早く作成します。

  # credentials_arn (Optional)
  # 設定内容: 統合に必要な認証情報のARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 用途: Quick Create機能の一部として、統合時の認証情報を指定
  # 適用対象: HTTP APIのみ
  credentials_arn = null

  # route_key (Optional)
  # 設定内容: ルートキーを指定します。Quick Create機能の一部です。
  # 設定可能な値: HTTP APIのルートキー（例: "GET /items", "POST /items/{id}"）
  # 関連機能: HTTP API ルート
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-routes.html
  # 適用対象: HTTP APIのみ
  route_key = null

  # target (Optional)
  # 設定内容: Quick Create用の統合ターゲットを指定します。
  # 設定可能な値:
  #   - HTTP統合の場合: 完全修飾URL（例: "https://example.com/api"）
  #   - Lambda統合の場合: Lambda関数のARN
  # 注意: HTTP統合の場合はHTTP_PROXY、Lambda統合の場合はAWS_PROXYとして作成されます
  # 適用対象: HTTP APIのみ
  target = null

  #-------------------------------------------------------------
  # OpenAPI仕様設定（HTTP API向け）
  #-------------------------------------------------------------

  # body (Optional)
  # 設定内容: OpenAPI仕様を指定します。HTTP APIのルートと統合を定義します。
  # 設定可能な値: OpenAPI 3.0形式のJSON/YAML文字列
  # 適用対象: HTTP APIのみ
  # 注意: bodyを指定した場合、以下のリソースは別途管理せずにOpenAPI内で定義してください:
  #   - aws_apigatewayv2_integration
  #   - aws_apigatewayv2_route
  #   更新時に手動リソースがOpenAPI定義で上書きされる可能性があります
  body = null

  # fail_on_warnings (Optional)
  # 設定内容: OpenAPI仕様を使用したAPI作成/更新時に警告をエラーとして扱うかを指定します。
  # 設定可能な値:
  #   - true: 警告があった場合にエラーを返す
  #   - false (デフォルト): 警告があっても処理を続行
  # 適用対象: HTTP APIのみ（bodyと組み合わせて使用）
  fail_on_warnings = false

  #-------------------------------------------------------------
  # CORS設定（HTTP API向け）
  #-------------------------------------------------------------
  # Cross-Origin Resource Sharing (CORS) の設定を行います。
  # HTTP APIにのみ適用されます。
  # 参考: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-cors.html

  cors_configuration {
    # allow_credentials (Optional)
    # 設定内容: CORSリクエストに認証情報を含めることを許可するかを指定します。
    # 設定可能な値:
    #   - true: Access-Control-Allow-Credentialsヘッダーをtrueに設定
    #   - false: 認証情報を許可しない
    # 注意: trueの場合、allow_originsにワイルドカード(*)は使用できません
    allow_credentials = false

    # allow_headers (Optional)
    # 設定内容: CORSリクエストで許可するHTTPヘッダーのセットを指定します。
    # 設定可能な値: HTTPヘッダー名のセット（例: ["Content-Type", "Authorization", "X-Amz-Date"]）
    # プリフライトリクエストのAccess-Control-Request-Headersに対応
    allow_headers = ["Content-Type", "Authorization", "X-Amz-Date"]

    # allow_methods (Optional)
    # 設定内容: CORSリクエストで許可するHTTPメソッドのセットを指定します。
    # 設定可能な値: HTTPメソッド名のセット（例: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]）
    # ワイルドカード(*)ですべてのメソッドを許可可能
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]

    # allow_origins (Optional)
    # 設定内容: CORSリクエストを許可するオリジンのセットを指定します。
    # 設定可能な値: オリジンURLのセット（例: ["https://example.com", "https://www.example.com"]）
    # ワイルドカード(*)ですべてのオリジンを許可可能（allow_credentials=trueの場合は不可）
    allow_origins = ["https://example.com"]

    # expose_headers (Optional)
    # 設定内容: ブラウザに公開するレスポンスヘッダーのセットを指定します。
    # 設定可能な値: HTTPヘッダー名のセット（例: ["X-Custom-Header", "X-Request-Id"]）
    # Access-Control-Expose-Headersレスポンスヘッダーに対応
    expose_headers = []

    # max_age (Optional)
    # 設定内容: プリフライトリクエスト結果をブラウザがキャッシュする秒数を指定します。
    # 設定可能な値: 秒数（-1から86400の整数）
    # Access-Control-Max-Ageレスポンスヘッダーに対応
    max_age = 300
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-api"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: APIの識別子
#
# - api_endpoint: APIのURI
#   HTTP APIの場合: https://{api-id}.execute-api.{region}.amazonaws.com
#   WebSocket APIの場合: wss://{api-id}.execute-api.{region}.amazonaws.com
#
# - arn: APIのAmazon Resource Name (ARN)
#
# - execution_arn: Lambda Permissionのsource_arnやIAMポリシーで
#   @connections APIへのアクセス認可に使用するARNプレフィックス
#   参考: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-control-access-iam.html
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
