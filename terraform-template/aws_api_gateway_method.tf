#---------------------------------------------------------------
# AWS API Gateway Method
#---------------------------------------------------------------
#
# Amazon API GatewayのREST APIリソースに対するHTTPメソッドを定義するリソースです。
# メソッドは、クライアントがAPIを呼び出す際に使用するHTTPメソッド（GET、POST等）と、
# 認可設定、リクエストパラメータ、リクエストモデル等を設定します。
#
# AWS公式ドキュメント:
#   - API Gatewayメソッドリクエストの設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-method-settings-method-request.html
#   - API Gateway認可: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-control-access-to-api.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_method" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # rest_api_id (Required)
  # 設定内容: 関連付けるREST APIのIDを指定します。
  # 設定可能な値: 有効なAPI Gateway REST APIのID
  rest_api_id = aws_api_gateway_rest_api.example.id

  # resource_id (Required)
  # 設定内容: メソッドを作成するAPIリソースのIDを指定します。
  # 設定可能な値: 有効なAPI Gatewayリソースの ID
  resource_id = aws_api_gateway_resource.example.id

  # http_method (Required)
  # 設定内容: APIメソッドのHTTPメソッドを指定します。
  # 設定可能な値:
  #   - "GET": リソースの取得
  #   - "POST": リソースの作成
  #   - "PUT": リソースの更新（全体）
  #   - "DELETE": リソースの削除
  #   - "HEAD": レスポンスヘッダーのみ取得
  #   - "OPTIONS": 利用可能なメソッドの取得（CORS対応）
  #   - "ANY": 任意のHTTPメソッド（実行時に決定）
  http_method = "GET"

  # authorization (Required)
  # 設定内容: メソッドで使用する認可タイプを指定します。
  # 設定可能な値:
  #   - "NONE": 認可なし（オープンアクセス）
  #   - "CUSTOM": Lambdaオーソライザーを使用したカスタム認可
  #   - "AWS_IAM": IAM認証を使用
  #   - "COGNITO_USER_POOLS": Amazon Cognitoユーザープールを使用
  # 関連機能: API Gateway認可
  #   APIへのアクセス制御を行う機能。認可タイプに応じて異なる認証フローが適用されます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-control-access-to-api.html
  authorization = "NONE"

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
  # 認可設定
  #-------------------------------------------------------------

  # authorizer_id (Optional)
  # 設定内容: 使用するオーソライザーのIDを指定します。
  # 設定可能な値: aws_api_gateway_authorizerリソースのID
  # 注意: authorizationが"CUSTOM"または"COGNITO_USER_POOLS"の場合に必要
  # 関連機能: API Gatewayオーソライザー
  #   Lambdaオーソライザーまたは Cognitoユーザープールを使用して
  #   リクエストの認証・認可を行います。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html
  authorizer_id = null

  # authorization_scopes (Optional)
  # 設定内容: 認可スコープを指定します。
  # 設定可能な値: 文字列のセット（OAuth 2.0スコープ）
  # 用途: authorizationが"COGNITO_USER_POOLS"の場合に使用
  # 関連機能: Cognitoユーザープール認可スコープ
  #   OAuth 2.0スコープを使用してAPIアクセスを細かく制御します。
  authorization_scopes = null

  #-------------------------------------------------------------
  # APIキー設定
  #-------------------------------------------------------------

  # api_key_required (Optional)
  # 設定内容: メソッド呼び出しにAPIキーが必要かどうかを指定します。
  # 設定可能な値:
  #   - true: APIキーが必要
  #   - false: APIキーは不要
  # 省略時: false
  # 関連機能: API Gatewayの使用量プラン
  #   APIキーと使用量プランを組み合わせて、APIの使用量を制御・追跡します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-usage-plans.html
  api_key_required = false

  #-------------------------------------------------------------
  # オペレーション名設定
  #-------------------------------------------------------------

  # operation_name (Optional)
  # 設定内容: SDKを生成する際に使用される関数名を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: API GatewayがリソースパスとHTTPメソッドに基づいて関数名を生成
  # 用途: API GatewayからSDKを生成する際に、わかりやすい関数名を指定するために使用
  operation_name = null

  #-------------------------------------------------------------
  # リクエストモデル設定
  #-------------------------------------------------------------

  # request_models (Optional)
  # 設定内容: リクエストのコンテンツタイプに対応するAPIモデルのマップを指定します。
  # 設定可能な値: コンテンツタイプをキー、モデル名を値とするマップ
  #   - キー: コンテンツタイプ（例: "application/json"）
  #   - 値: "Error"、"Empty"（組み込みモデル）、または aws_api_gateway_model の name
  # 関連機能: API Gatewayモデル
  #   リクエストボディのスキーマを定義し、リクエスト検証やSDK生成に使用されます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/models-mappings.html
  request_models = {
    "application/json" = "Empty"
  }

  #-------------------------------------------------------------
  # リクエストバリデータ設定
  #-------------------------------------------------------------

  # request_validator_id (Optional)
  # 設定内容: リクエストバリデータのIDを指定します。
  # 設定可能な値: aws_api_gateway_request_validatorリソースのID
  # 関連機能: API Gatewayリクエスト検証
  #   リクエストボディやパラメータを検証し、無効なリクエストを拒否します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-method-request-validation.html
  request_validator_id = null

  #-------------------------------------------------------------
  # リクエストパラメータ設定
  #-------------------------------------------------------------

  # request_parameters (Optional)
  # 設定内容: インテグレーションに渡すリクエストパラメータのマップを指定します。
  # 設定可能な値: パラメータ名をキー、必須フラグ（true/false）を値とするマップ
  #   - キーの形式:
  #     - "method.request.path.{パラメータ名}": パスパラメータ
  #     - "method.request.querystring.{パラメータ名}": クエリ文字列パラメータ
  #     - "method.request.header.{ヘッダー名}": ヘッダーパラメータ
  #   - 値:
  #     - true: パラメータは必須
  #     - false: パラメータはオプション
  # 例: ヘッダー"X-Some-Header"とクエリパラメータ"some-query-param"を必須として定義
  # 関連機能: API Gatewayメソッドリクエスト
  #   パス、クエリ文字列、ヘッダーからパラメータを抽出し、インテグレーションに渡します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-method-settings-method-request.html
  request_parameters = {
    "method.request.header.X-Custom-Header"   = false
    "method.request.querystring.example-param" = false
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: メソッドのID（REST API ID、リソースID、HTTPメソッドで構成）
#
#---------------------------------------------------------------
