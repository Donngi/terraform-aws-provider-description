#---------------------------------------------------------------
# AWS API Gateway Request Validator
#---------------------------------------------------------------
#
# Amazon API GatewayのREST APIに対するリクエストバリデーターを
# プロビジョニングするリソースです。
# リクエストバリデーターを使用すると、バックエンドに到達する前に
# リクエストボディやリクエストパラメータの基本的な検証を実行できます。
#
# AWS公式ドキュメント:
#   - API Gatewayのリクエスト検証: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-method-request-validation.html
#   - リクエスト検証のセットアップ: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-request-validation-set-up.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_request_validator
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_request_validator" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: リクエストバリデーターの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: APIメソッドにバリデーターを割り当てる際の識別子として使用
  name = "example-validator"

  # rest_api_id (Required)
  # 設定内容: このリクエストバリデーターを関連付けるREST APIのIDを指定します。
  # 設定可能な値: 有効なREST API ID
  # 関連機能: API Gateway REST API
  #   REST APIを作成した後、リクエストバリデーターを追加して
  #   APIメソッドに割り当てることができます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-method-request-validation.html
  rest_api_id = aws_api_gateway_rest_api.example.id

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
  # 検証設定
  #-------------------------------------------------------------

  # validate_request_body (Optional)
  # 設定内容: リクエストボディを検証するかどうかを指定します。
  # 設定可能な値:
  #   - true: リクエストボディをモデルスキーマに対して検証
  #   - false (デフォルト): リクエストボディを検証しない
  # 関連機能: リクエストボディ検証
  #   リクエストペイロードが指定されたJSONスキーマ（モデル）に
  #   適合しているかを検証します。コンテンツタイプごとに
  #   異なるモデルを定義できます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-method-request-validation.html
  validate_request_body = true

  # validate_request_parameters (Optional)
  # 設定内容: リクエストパラメータを検証するかどうかを指定します。
  # 設定可能な値:
  #   - true: 必須のリクエストパラメータ（URI、クエリ文字列、ヘッダー）が
  #           存在し、nullでないことを検証
  #   - false (デフォルト): リクエストパラメータを検証しない
  # 関連機能: リクエストパラメータ検証
  #   URI、クエリ文字列、ヘッダーの必須パラメータが存在し、
  #   値がnullでないことを確認します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-method-request-validation.html
  validate_request_parameters = true
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リクエストバリデーターの一意のID
#---------------------------------------------------------------
