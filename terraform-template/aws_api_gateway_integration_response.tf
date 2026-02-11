#---------------------------------------------------------------
# AWS API Gateway Integration Response
#---------------------------------------------------------------
#
# API Gateway REST APIのIntegration Responseをプロビジョニングするリソースです。
# Integration Responseは、バックエンドからのレスポンスをクライアントに返す前に
# 変換するための設定を定義します。非プロキシ統合でのみ使用されます。
#
# AWS公式ドキュメント:
#   - Integration Response設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-integration-settings-integration-response.html
#   - Method Response設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-method-settings-method-response.html
#   - バイナリメディアタイプ: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-payload-encodings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration_response
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_integration_response" "example" {
  #-------------------------------------------------------------
  # 必須設定 (Required)
  #-------------------------------------------------------------

  # rest_api_id (Required)
  # 設定内容: 関連付けるREST APIのIDを指定します。
  # 設定可能な値: 有効なREST API ID
  rest_api_id = aws_api_gateway_rest_api.example.id

  # resource_id (Required)
  # 設定内容: APIリソースのIDを指定します。
  # 設定可能な値: 有効なAPIリソースID
  resource_id = aws_api_gateway_resource.example.id

  # http_method (Required)
  # 設定内容: HTTPメソッドを指定します。
  # 設定可能な値:
  #   - "GET": GETメソッド
  #   - "POST": POSTメソッド
  #   - "PUT": PUTメソッド
  #   - "DELETE": DELETEメソッド
  #   - "HEAD": HEADメソッド
  #   - "OPTIONS": OPTIONSメソッド
  #   - "ANY": すべてのHTTPメソッド
  http_method = aws_api_gateway_method.example.http_method

  # status_code (Required)
  # 設定内容: HTTPステータスコードを指定します。
  # 設定可能な値: 有効なHTTPステータスコード（例: "200", "400", "500"）
  # 注意: 対応するaws_api_gateway_method_responseが必要です。
  status_code = aws_api_gateway_method_response.example.status_code

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # レスポンス選択パターン (Optional)
  #-------------------------------------------------------------

  # selection_pattern (Optional)
  # 設定内容: バックエンドからのレスポンスに基づいてIntegration Responseを選択するための
  #           正規表現パターンを指定します。
  # 設定可能な値: 正規表現パターン文字列
  # 省略時: デフォルトのIntegration Responseとして使用されます（まだ設定されていないレスポンスをキャッチ）
  # 動作:
  #   - AWS Lambda関数の場合: Lambdaエラーヘッダーと照合
  #   - その他のHTTPおよびAWSバックエンド: HTTPステータスコードと照合
  # 例: "5\\d{2}" は5xx系エラー、"4\\d{2}" は4xx系エラーにマッチ
  # 関連機能: Integration Response選択
  #   複数のIntegration Responseを設定し、バックエンドの応答に応じて
  #   異なるMethod Responseにマッピングできます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-integration-settings-integration-response.html
  selection_pattern = null

  #-------------------------------------------------------------
  # レスポンスパラメータ (Optional)
  #-------------------------------------------------------------

  # response_parameters (Optional)
  # 設定内容: バックエンドレスポンスから読み取れるレスポンスパラメータのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  #   - キー: method.response.header.{ヘッダー名} 形式
  #   - 値: integration.response.header.{ヘッダー名} または静的値（'value'形式）
  # 用途: バックエンドからのレスポンスヘッダーをMethod Responseのヘッダーにマッピング
  # 関連機能: レスポンスパラメータマッピング
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/request-response-data-mappings.html
  response_parameters = {
    "method.response.header.X-Custom-Header" = "integration.response.header.X-Backend-Header"
  }

  #-------------------------------------------------------------
  # レスポンステンプレート (Optional)
  #-------------------------------------------------------------

  # response_templates (Optional)
  # 設定内容: Integration Responseボディを変換するためのテンプレートのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  #   - キー: Content-Type（例: "application/json", "application/xml"）
  #   - 値: VTL (Velocity Template Language) テンプレート
  # 用途: バックエンドからのレスポンスボディをクライアント向けに変換
  # 関連機能: レスポンスマッピングテンプレート
  #   VTLを使用してバックエンドのJSONレスポンスを別の形式（XMLなど）に変換可能
  response_templates = {
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
{
  "data": $inputRoot.body
}
EOF
  }

  #-------------------------------------------------------------
  # コンテンツハンドリング (Optional)
  #-------------------------------------------------------------

  # content_handling (Optional)
  # 設定内容: リクエストペイロードのコンテンツタイプ変換方法を指定します。
  # 設定可能な値:
  #   - "CONVERT_TO_BINARY": Base64エンコードされた文字列をバイナリBlobに変換
  #   - "CONVERT_TO_TEXT": バイナリBlobをBase64エンコードされた文字列に変換
  # 省略時: レスポンスペイロードは変更なしでMethod Responseに渡されます
  # 関連機能: バイナリメディアタイプ
  #   REST APIでバイナリペイロード（画像、gzipファイルなど）を処理するための設定。
  #   binaryMediaTypesと組み合わせて使用します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-payload-encodings.html
  # 注意: MOCKまたはプライベート統合では、コンソールからの設定はサポートされていません。
  #       AWS CLI、CloudFormation、またはSDKを使用して設定する必要があります。
  content_handling = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Integration ResponseのID（Terraformが内部的に生成）
#---------------------------------------------------------------

#---------------------------------------------------------------
# 依存関係に関する注意
#---------------------------------------------------------------
# このリソースはaws_api_gateway_integrationに依存します。
# クリーンな実行を確保するために、明示的なdepends_onの追加が必要な場合があります。
#
# 例:
#   depends_on = [aws_api_gateway_integration.example]
#---------------------------------------------------------------
