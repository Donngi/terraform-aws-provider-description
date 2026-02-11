#---------------------------------------------------------------
# AWS API Gateway Method Response
#---------------------------------------------------------------
#
# API Gatewayのメソッドレスポンスを定義するリソースです。
# メソッドレスポンスは、APIメソッドリクエストの出力をカプセル化し、
# HTTPステータスコード、ヘッダー、ボディを含みます。
# 非プロキシ統合では、レスポンスパラメータとボディを統合レスポンスから
# マッピングしたり、静的な値を割り当てることができます。
#
# AWS公式ドキュメント:
#   - API Gatewayメソッドレスポンス設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-method-settings-method-response.html
#   - MethodResponse API: https://docs.aws.amazon.com/apigateway/latest/api/API_MethodResponse.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_method_response" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # rest_api_id (Required)
  # 設定内容: 関連付けるREST APIの識別子を指定します。
  # 設定可能な値: REST APIの文字列識別子
  # 注意: aws_api_gateway_rest_apiリソースのidを参照することが一般的です。
  rest_api_id = aws_api_gateway_rest_api.example.id

  # resource_id (Required)
  # 設定内容: メソッドリソースのリソース識別子を指定します。
  # 設定可能な値: APIリソースの識別子
  # 注意: aws_api_gateway_resourceリソースのidを参照することが一般的です。
  resource_id = aws_api_gateway_resource.example.id

  # http_method (Required)
  # 設定内容: メソッドリソースのHTTP動詞を指定します。
  # 設定可能な値:
  #   - "GET": リソースの取得
  #   - "POST": リソースの作成
  #   - "PUT": リソースの更新（全体置換）
  #   - "DELETE": リソースの削除
  #   - "HEAD": ヘッダー情報のみ取得
  #   - "OPTIONS": 利用可能なメソッドの確認（CORS対応）
  #   - "ANY": 全てのHTTPメソッドにマッチ
  # 注意: 対応するaws_api_gateway_methodリソースのhttp_methodと一致させる必要があります。
  http_method = aws_api_gateway_method.example.http_method

  # status_code (Required)
  # 設定内容: メソッドレスポンスのHTTPステータスコードを指定します。
  # 設定可能な値: 文字列形式のHTTPステータスコード
  #   - "200": 成功
  #   - "201": 作成成功
  #   - "204": コンテンツなし
  #   - "400": 不正なリクエスト
  #   - "401": 認証エラー
  #   - "403": アクセス拒否
  #   - "404": リソースが見つからない
  #   - "500": サーバーエラー
  #   等、1XX〜5XXの範囲のHTTPステータスコード
  # 注意: パターン [1-5]\d\d に一致する必要があります。
  status_code = "200"

  #-------------------------------------------------------------
  # レスポンスモデル設定
  #-------------------------------------------------------------

  # response_models (Optional)
  # 設定内容: レスポンスのコンテンツタイプに使用するモデルリソースを指定します。
  # 設定可能な値: コンテンツタイプをキー、モデル名を値とするマップ
  #   - キー: コンテンツタイプ（例: "application/json", "application/xml"）
  #   - 値: API Gatewayで定義されたモデル名、または組み込みモデル
  #     - "Empty": 空のレスポンス
  #     - "Error": エラーレスポンス
  #     - カスタムモデル名（aws_api_gateway_modelで定義）
  # 関連機能: API Gateway モデル
  #   レスポンスボディのスキーマを定義し、強い型付けのSDK生成に使用されます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/models-mappings.html
  response_models = {
    "application/json" = "Empty"
  }

  #-------------------------------------------------------------
  # レスポンスパラメータ設定
  #-------------------------------------------------------------

  # response_parameters (Optional)
  # 設定内容: API Gatewayがクライアントに返すレスポンスパラメータを指定します。
  # 設定可能な値: ヘッダー名をキー、必須/任意フラグ（boolean）を値とするマップ
  #   - キー: "method.response.header.{name}" 形式
  #     （{name}は有効で一意なヘッダー名）
  #   - 値:
  #     - true: 必須パラメータ（統合レスポンスで必ずマッピングが必要）
  #     - false: 任意パラメータ
  # 関連機能: API Gateway レスポンスパラメータマッピング
  #   統合レスポンスからメソッドレスポンスへのパラメータマッピングに使用されます。
  #   統合レスポンスでは以下の形式でマッピング可能:
  #   - integration.response.header.{name}: 統合レスポンスヘッダー
  #   - 'static_value': 静的な値（シングルクォートで囲む）
  #   - integration.response.body.{JSON-expression}: バックエンドレスポンスのJSONパス
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-method-settings-method-response.html
  response_parameters = {
    "method.response.header.Content-Type"           = false
    "method.response.header.Access-Control-Allow-Origin" = false
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
# - id: リソースの識別子
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# resource "aws_api_gateway_model" "response_model" {
#   rest_api_id  = aws_api_gateway_rest_api.example.id
#   name         = "ResponseModel"
#   description  = "API response model"
#   content_type = "application/json"
#   schema = jsonencode({
#     "$schema" = "http://json-schema.org/draft-04/schema#"
#     title     = "Response"
#     type      = "object"
#     properties = {
#       message = {
#         type = "string"
#       }
#     }
#---------------------------------------------------------------
