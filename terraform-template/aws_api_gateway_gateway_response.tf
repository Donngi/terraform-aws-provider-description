#---------------------------------------------------------------
# AWS API Gateway Gateway Response
#---------------------------------------------------------------
#
# Amazon API Gateway REST APIのゲートウェイレスポンスをプロビジョニングするリソースです。
# ゲートウェイレスポンスは、API Gatewayがリクエストを処理できない場合に返される
# エラーレスポンスをカスタマイズするために使用します。認証エラー、スロットリング、
# 統合タイムアウトなど、様々なエラータイプに対してレスポンスの形式やヘッダーを
# カスタマイズできます。
#
# AWS公式ドキュメント:
#   - Gateway responses for REST APIs: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-gatewayResponse-definition.html
#   - Gateway response types: https://docs.aws.amazon.com/apigateway/latest/developerguide/supported-gateway-response-types.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_gateway_response
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_gateway_response" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # rest_api_id (Required)
  # 設定内容: 関連付けるREST APIの識別子を指定します。
  # 設定可能な値: REST APIのID文字列
  rest_api_id = aws_api_gateway_rest_api.example.id

  # response_type (Required)
  # 設定内容: 関連付けるゲートウェイレスポンスのタイプを指定します。
  # 設定可能な値:
  #   - "ACCESS_DENIED" (デフォルト403): 認可失敗時のレスポンス
  #   - "API_CONFIGURATION_ERROR" (デフォルト500): API設定エラー時のレスポンス
  #   - "AUTHORIZER_CONFIGURATION_ERROR" (デフォルト500): オーソライザー接続失敗時のレスポンス
  #   - "AUTHORIZER_FAILURE" (デフォルト500): オーソライザー認証失敗時のレスポンス
  #   - "BAD_REQUEST_PARAMETERS" (デフォルト400): リクエストパラメータ検証エラー時のレスポンス
  #   - "BAD_REQUEST_BODY" (デフォルト400): リクエストボディ検証エラー時のレスポンス
  #   - "DEFAULT_4XX" (デフォルトnull): 未指定の4XXエラー用デフォルトレスポンス
  #   - "DEFAULT_5XX" (デフォルトnull): 未指定の5XXエラー用デフォルトレスポンス
  #   - "EXPIRED_TOKEN" (デフォルト403): AWS認証トークン期限切れ時のレスポンス
  #   - "INTEGRATION_FAILURE" (デフォルト504): 統合失敗時のレスポンス
  #   - "INTEGRATION_TIMEOUT" (デフォルト504): 統合タイムアウト時のレスポンス
  #   - "INVALID_API_KEY" (デフォルト403): 無効なAPIキー時のレスポンス
  #   - "INVALID_SIGNATURE" (デフォルト403): 無効なAWS署名時のレスポンス
  #   - "MISSING_AUTHENTICATION_TOKEN" (デフォルト403): 認証トークン欠落時のレスポンス
  #   - "QUOTA_EXCEEDED" (デフォルト429): 使用量プランクォータ超過時のレスポンス
  #   - "REQUEST_TOO_LARGE" (デフォルト413): リクエストサイズ超過時のレスポンス
  #   - "RESOURCE_NOT_FOUND" (デフォルト404): リソース未検出時のレスポンス
  #   - "THROTTLED" (デフォルト429): スロットリング制限超過時のレスポンス
  #   - "UNAUTHORIZED" (デフォルト401): オーソライザー認証失敗時のレスポンス
  #   - "UNSUPPORTED_MEDIA_TYPE" (デフォルト415): サポートされないメディアタイプ時のレスポンス
  #   - "WAF_FILTERED" (デフォルト403): AWS WAFによりブロックされた時のレスポンス
  # 関連機能: API Gateway ゲートウェイレスポンス
  #   API Gatewayがリクエストを処理できない場合のエラーレスポンスをカスタマイズする機能。
  #   VTLマッピングテンプレートではなく、シンプルな変数置換をサポートする非VTLテンプレートを使用。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/supported-gateway-response-types.html
  response_type = "UNAUTHORIZED"

  #-------------------------------------------------------------
  # HTTPステータスコード設定
  #-------------------------------------------------------------

  # status_code (Optional)
  # 設定内容: ゲートウェイレスポンスのHTTPステータスコードを指定します。
  # 設定可能な値: 有効なHTTPステータスコード（文字列形式）
  #   例: "400", "401", "403", "404", "500", "502", "503", "504"
  # 省略時: response_typeに対応するデフォルトのステータスコードが使用されます
  status_code = "401"

  #-------------------------------------------------------------
  # レスポンステンプレート設定
  #-------------------------------------------------------------

  # response_templates (Optional)
  # 設定内容: レスポンスボディを変換するためのテンプレートのマップを指定します。
  # 設定可能な値: Content-Typeをキー、テンプレート文字列を値とするマップ
  #   キー: MIMEタイプ（例: "application/json", "application/xml"）
  #   値: レスポンステンプレート（$context変数、$stageVariables、メソッドリクエストパラメータを使用可能）
  # 関連機能: API Gateway ゲートウェイレスポンスマッピング
  #   $context変数（$context.error.messageString等）を使用してエラー情報を含むカスタムレスポンスを生成。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html#context-variable-reference
  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  #-------------------------------------------------------------
  # レスポンスパラメータ設定
  #-------------------------------------------------------------

  # response_parameters (Optional)
  # 設定内容: ゲートウェイレスポンスのパラメータ（パス、クエリ文字列、ヘッダー）のマップを指定します。
  # 設定可能な値: パラメータ名をキー、値を値とするマップ
  #   キーの形式:
  #     - "gatewayresponse.header.{header-name}": レスポンスヘッダーを設定
  #   値の形式:
  #     - 静的な値: シングルクォートで囲む（例: "'Basic'"）
  #     - $context変数: $context.変数名
  #     - $stageVariables: $stageVariables.変数名
  #     - メソッドリクエストパラメータ: method.request.{param-position}.{param-name}
  # 用途: カスタムヘッダーの追加（例: CORS対応のAccess-Control-Allow-Originヘッダー）
  response_parameters = {
    "gatewayresponse.header.Authorization" = "'Basic'"
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
# - id: ゲートウェイレスポンスの識別子
#       形式: aggr-{rest_api_id}-{response_type}
#---------------------------------------------------------------
