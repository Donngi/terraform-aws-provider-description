#---------------------------------------------------------------
# AWS API Gateway V2 Integration
#---------------------------------------------------------------
#
# Amazon API Gateway Version 2（HTTP API/WebSocket API）の統合（Integration）を
# プロビジョニングするリソースです。統合は、APIルートとバックエンドサービス
# （Lambda関数、HTTPエンドポイント、AWSサービス等）を接続する設定を定義します。
#
# AWS公式ドキュメント:
#   - WebSocket API統合: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api.html
#   - HTTP API Lambda統合: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-lambda.html
#   - HTTP APIパラメータマッピング: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-parameter-mapping.html
#   - HTTP API AWSサービス統合リファレンス: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-aws-services-reference.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apigatewayv2_integration" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: 統合を作成するAPI Gateway APIの識別子を指定します。
  # 設定可能な値: 有効なAPI Gateway V2 APIのID
  api_id = aws_apigatewayv2_api.example.id

  # integration_type (Required)
  # 設定内容: 統合のタイプを指定します。
  # 設定可能な値:
  #   - "AWS": AWSサービス統合（WebSocket APIのみサポート）
  #   - "AWS_PROXY": AWSサービスプロキシ統合（Lambda、SQS等）
  #   - "HTTP": HTTP統合（WebSocket APIのみサポート）
  #   - "HTTP_PROXY": HTTPプロキシ統合（HTTP APIのプライベート統合はこれを使用）
  #   - "MOCK": モック統合（WebSocket APIのみサポート）
  integration_type = "AWS_PROXY"

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
  # 接続設定
  #-------------------------------------------------------------

  # connection_type (Optional)
  # 設定内容: 統合エンドポイントへのネットワーク接続タイプを指定します。
  # 設定可能な値:
  #   - "INTERNET" (デフォルト): パブリックインターネット経由
  #   - "VPC_LINK": VPCリンク経由のプライベート接続
  connection_type = "INTERNET"

  # connection_id (Optional)
  # 設定内容: プライベート統合で使用するVPCリンクのIDを指定します。
  # 設定可能な値: 有効なVPCリンクのID（1〜1024文字）
  # 注意: HTTP APIのみサポート。connection_typeが"VPC_LINK"の場合に必要
  # 関連リソース: aws_apigatewayv2_vpc_link
  connection_id = null

  #-------------------------------------------------------------
  # 統合設定
  #-------------------------------------------------------------

  # integration_method (Optional)
  # 設定内容: 統合のHTTPメソッドを指定します。
  # 設定可能な値: GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS, ANY
  # 注意: integration_typeがMOCKでない場合は必須
  integration_method = "POST"

  # integration_uri (Optional)
  # 設定内容: 統合のURIを指定します。
  # 設定可能な値:
  #   - Lambda統合: Lambda関数のinvoke ARN
  #   - HTTP統合: 完全修飾URL
  #   - HTTPプライベート統合: ALB/NLBリスナーのARNまたはCloud MapサービスのARN
  integration_uri = aws_lambda_function.example.invoke_arn

  # integration_subtype (Optional)
  # 設定内容: 呼び出すAWSサービスアクションを指定します。
  # 設定可能な値: SQS-SendMessage, EventBridge-PutEvents, StepFunctions-StartExecution等
  # 参考: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-aws-services-reference.html
  # 注意: HTTP APIでintegration_typeがAWS_PROXYの場合のみサポート。1〜128文字
  integration_subtype = null

  # credentials_arn (Optional)
  # 設定内容: 統合に必要な認証情報（IAMロール）のARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN
  # 用途: AWSサービス統合時にAPI Gatewayがサービスを呼び出す際の権限を指定
  credentials_arn = null

  # description (Optional)
  # 設定内容: 統合の説明を指定します。
  # 設定可能な値: 任意の文字列
  description = "Lambda integration example"

  #-------------------------------------------------------------
  # ペイロード設定
  #-------------------------------------------------------------

  # payload_format_version (Optional)
  # 設定内容: 統合に送信されるペイロードのフォーマットバージョンを指定します。
  # 設定可能な値:
  #   - "1.0" (デフォルト): レガシーフォーマット
  #   - "2.0": 簡略化されたフォーマット（HTTP APIで推奨）
  # 参考: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-lambda.html#http-api-develop-integrations-lambda.proxy-format
  payload_format_version = "2.0"

  # content_handling_strategy (Optional)
  # 設定内容: レスポンスペイロードのコンテンツタイプ変換を処理する方法を指定します。
  # 設定可能な値:
  #   - "CONVERT_TO_BINARY": テキストからバイナリへ変換
  #   - "CONVERT_TO_TEXT": バイナリからテキストへ変換
  # 注意: WebSocket APIのみサポート
  content_handling_strategy = null

  # passthrough_behavior (Optional)
  # 設定内容: リクエストのContent-Typeヘッダーと利用可能なマッピングテンプレートに基づく
  #           パススルー動作を指定します。
  # 設定可能な値:
  #   - "WHEN_NO_MATCH" (デフォルト): Content-Typeに一致するテンプレートがない場合にパススルー
  #   - "WHEN_NO_TEMPLATES": テンプレートが定義されていない場合のみパススルー
  #   - "NEVER": パススルーしない（テンプレートがない場合は415エラー）
  # 注意: WebSocket APIのみサポート
  passthrough_behavior = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeout_milliseconds (Optional)
  # 設定内容: カスタムタイムアウト値をミリ秒で指定します。
  # 設定可能な値:
  #   - WebSocket API: 50〜29,000ミリ秒（デフォルト29秒）
  #   - HTTP API: 50〜30,000ミリ秒（デフォルト30秒）
  # 注意: 設定値が存在する場合のみドリフト検出を実行
  timeout_milliseconds = 30000

  #-------------------------------------------------------------
  # リクエストパラメータ・テンプレート設定
  #-------------------------------------------------------------

  # request_parameters (Optional)
  # 設定内容: リクエストパラメータのマッピングを指定します。
  # 設定可能な値: キーと値のマップ
  # 用途:
  #   - WebSocket API: メソッドリクエストからバックエンドに渡すパラメータ
  #   - HTTP API (integration_subtypeあり): AWS_PROXYに渡すパラメータ
  #   - HTTP API (integration_subtypeなし): バックエンド送信前のHTTPリクエスト変換
  # 参考: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-parameter-mapping.html
  request_parameters = {
    "overwrite:path" = "/api/v1/resource"
  }

  # request_templates (Optional)
  # 設定内容: リクエストペイロードに適用するVelocityテンプレートのマップを指定します。
  # 設定可能な値: Content-Typeをキーとし、Velocityテンプレートを値とするマップ
  # 注意: WebSocket APIのみサポート
  # 参考: https://velocity.apache.org/
  request_templates = null

  # template_selection_expression (Optional)
  # 設定内容: 統合のテンプレート選択式を指定します。
  # 設定可能な値: テンプレート選択式の文字列
  # 参考: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-selection-expressions.html#apigateway-websocket-api-template-selection-expressions
  template_selection_expression = null

  #-------------------------------------------------------------
  # レスポンスパラメータ設定
  #-------------------------------------------------------------

  # response_parameters (Optional)
  # 設定内容: バックエンドからのHTTPレスポンスをクライアントに返す前に変換するマッピングを指定します。
  # 注意: HTTP APIのみサポート

  response_parameters {
    # status_code (Required)
    # 設定内容: HTTPステータスコードを指定します。
    # 設定可能な値: 200〜599の範囲のHTTPステータスコード
    status_code = 200

    # mappings (Required)
    # 設定内容: パラメータマッピングを指定します。
    # 設定可能な値: キーは変更するリクエストパラメータの場所と変更方法、値は新しいデータ
    # 参考: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-parameter-mapping.html
    mappings = {
      "overwrite:statuscode" = "204"
    }
  }

  response_parameters {
    status_code = 403
    mappings = {
      "append:header.auth" = "$context.authorizer.authorizerResponse"
    }
  }

  #-------------------------------------------------------------
  # TLS設定
  #-------------------------------------------------------------

  # tls_config (Optional)
  # 設定内容: プライベート統合のTLS設定を指定します。
  # 注意: HTTP APIのみサポート

  tls_config {
    # server_name_to_verify (Optional)
    # 設定内容: サーバー名を指定します。
    # 設定可能な値: ドメイン名の文字列
    # 用途: API Gatewayが統合の証明書でホスト名を検証するために使用。
    #       TLSハンドシェイクでSNI（Server Name Indication）または仮想ホスティングをサポートするためにも含まれます。
    server_name_to_verify = "example.com"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 統合の識別子
#
# - integration_response_selection_expression: 統合の統合レスポンス選択式
#   参考: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-selection-expressions.html#apigateway-websocket-api-integration-response-selection-expressions
#---------------------------------------------------------------
