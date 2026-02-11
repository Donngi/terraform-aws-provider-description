#---------------------------------------------------------------
# AWS API Gateway V2 Stage
#---------------------------------------------------------------
#
# Amazon API Gateway Version 2のステージをプロビジョニングするリソースです。
# ステージは、APIのライフサイクル状態への論理的な参照であり、
# APIの特定のデプロイメントスナップショットを指します。
# HTTP APIおよびWebSocket APIの両方で使用されます。
#
# AWS公式ドキュメント:
#   - API Gateway Developer Guide: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api.html
#   - WebSocket APIステージ: https://docs.aws.amazon.com/apigateway/latest/developerguide/websocket-api-stages.html
#   - HTTP APIステージ: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-stages.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apigatewayv2_stage" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: APIの識別子を指定します。
  # 設定可能な値: aws_apigatewayv2_apiリソースのID
  api_id = aws_apigatewayv2_api.example.id

  # name (Required)
  # 設定内容: ステージの名前を指定します。
  # 設定可能な値: 1〜128文字の文字列
  # 注意: HTTP APIでは特別な値"$default"を使用してデフォルトステージを作成できます。
  name = "production"

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
  # デプロイメント設定
  #-------------------------------------------------------------

  # deployment_id (Optional)
  # 設定内容: ステージに関連付けるデプロイメントの識別子を指定します。
  # 設定可能な値: aws_apigatewayv2_deploymentリソースのID
  # 省略時: 自動計算される場合があります（auto_deploy有効時）
  # 注意: aws_apigatewayv2_deploymentリソースを使用してデプロイメントを設定します。
  deployment_id = aws_apigatewayv2_deployment.example.id

  # auto_deploy (Optional)
  # 設定内容: API更新時に新しいデプロイメントを自動的にトリガーするかを指定します。
  # 設定可能な値:
  #   - true: API更新時に自動デプロイを有効化
  #   - false (デフォルト): 自動デプロイを無効化
  # 関連機能: HTTP API自動デプロイ
  #   HTTP APIでのみ適用されます。WebSocket APIでは無効です。
  auto_deploy = false

  #-------------------------------------------------------------
  # 説明
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ステージの説明を指定します。
  # 設定可能な値: 1024文字以下の文字列
  description = "Production stage for the API"

  #-------------------------------------------------------------
  # クライアント証明書設定
  #-------------------------------------------------------------

  # client_certificate_id (Optional)
  # 設定内容: ステージのクライアント証明書の識別子を指定します。
  # 設定可能な値: aws_api_gateway_client_certificateリソースのID
  # 関連機能: 相互TLS認証
  #   WebSocket APIでのみサポートされます。
  #   クライアント証明書を使用してバックエンドへのリクエストを認証できます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/getting-started-client-side-ssl-authentication.html
  client_certificate_id = null

  #-------------------------------------------------------------
  # ステージ変数設定
  #-------------------------------------------------------------

  # stage_variables (Optional)
  # 設定内容: ステージの変数を定義するマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: ステージ変数
  #   ステージ変数は、HTTPインテグレーションのエンドポイントのカスタマイズや
  #   Lambda関数名の指定などに使用できます。
  #   ${}構文でAPI設定内で参照できます（例: ${stageVariables.variableName}）
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-stages.html
  # 注意: 機密データにはステージ変数を使用しないでください。
  #       機密データはLambdaオーソライザー経由で渡してください。
  stage_variables = {
    environment = "production"
    log_level   = "INFO"
  }

  #-------------------------------------------------------------
  # アクセスログ設定
  #-------------------------------------------------------------

  # access_log_settings (Optional)
  # 設定内容: このステージのアクセスログ設定を指定します。
  # 関連機能: CloudWatch Logsへのアクセスログ
  #   API Gatewayは、APIへのリクエストをCloudWatch Logsにログ記録できます。
  #   CloudWatch Loggingを有効にするには、aws_api_gateway_accountリソースで
  #   適切なIAMロールを設定する必要があります。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html
  access_log_settings {
    # destination_arn (Required)
    # 設定内容: アクセスログを受信するCloudWatch Logsロググループの
    #           ARNを指定します。
    # 設定可能な値: 有効なCloudWatch Logsロググループ ARN
    # 注意: ARNの末尾の":*"は自動的に削除されます。
    destination_arn = aws_cloudwatch_log_group.api_access_logs.arn

    # format (Required)
    # 設定内容: アクセスログのフォーマットを指定します。
    # 設定可能な値: 単一行のフォーマット文字列
    # 関連機能: ログフォーマット
    #   HTTP API: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-logging-variables.html
    #   WebSocket API: https://docs.aws.amazon.com/apigateway/latest/developerguide/websocket-api-logging.html
    format = jsonencode({
      requestId         = "$context.requestId"
      ip                = "$context.identity.sourceIp"
      requestTime       = "$context.requestTime"
      httpMethod        = "$context.httpMethod"
      routeKey          = "$context.routeKey"
      status            = "$context.status"
      protocol          = "$context.protocol"
      responseLength    = "$context.responseLength"
      integrationStatus = "$context.integrationStatus"
    })
  }

  #-------------------------------------------------------------
  # デフォルトルート設定
  #-------------------------------------------------------------

  # default_route_settings (Optional)
  # 設定内容: ステージのデフォルトルート設定を指定します。
  # 関連機能: ルート設定
  #   すべてのルートに適用されるデフォルトのスロットリングおよびログ設定を定義します。
  #   個別のルートでオーバーライドすることも可能です。
  default_route_settings {
    # data_trace_enabled (Optional)
    # 設定内容: デフォルトルートのデータトレースログを有効にするかを指定します。
    # 設定可能な値:
    #   - true: データトレースログを有効化（リクエスト/レスポンスデータをログに含む）
    #   - false (デフォルト): データトレースログを無効化
    # 関連機能: CloudWatch Logsへのデータトレース
    #   WebSocket APIでのみサポートされます。
    # 注意: 本番環境では機密データが含まれる可能性があるため注意が必要です。
    data_trace_enabled = false

    # detailed_metrics_enabled (Optional)
    # 設定内容: デフォルトルートの詳細メトリクスを有効にするかを指定します。
    # 設定可能な値:
    #   - true: 詳細メトリクスを有効化
    #   - false (デフォルト): 詳細メトリクスを無効化
    # 関連機能: CloudWatch メトリクス
    #   詳細メトリクスを有効にすると、追加のAPIメトリクスがCloudWatchに
    #   送信されます（追加料金が発生する場合があります）。
    detailed_metrics_enabled = true

    # logging_level (Optional)
    # 設定内容: デフォルトルートのログレベルを指定します。
    # 設定可能な値:
    #   - "ERROR": エラーのみをログ
    #   - "INFO": すべてのイベントをログ
    #   - "OFF" (デフォルト): ログを無効化
    # 関連機能: CloudWatch Logs実行ログ
    #   WebSocket APIでのみサポートされます。
    #   設定が存在する場合のみ、Terraformはドリフト検出を実行します。
    logging_level = "ERROR"

    # throttling_burst_limit (Optional)
    # 設定内容: デフォルトルートのスロットリングバースト制限を指定します。
    # 設定可能な値: 正の整数
    # 関連機能: スロットリング
    #   バースト制限は、API Gatewayが同時に処理できるリクエストの最大数を制御します。
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-throttling.html
    throttling_burst_limit = 5000

    # throttling_rate_limit (Optional)
    # 設定内容: デフォルトルートのスロットリングレート制限を指定します。
    # 設定可能な値: 正の数（リクエスト/秒）
    # 関連機能: スロットリング
    #   レート制限は、APIが1秒あたりに処理できるリクエストの最大数を制御します。
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-throttling.html
    throttling_rate_limit = 10000.0
  }

  #-------------------------------------------------------------
  # ルート設定（個別ルート）
  #-------------------------------------------------------------

  # route_settings (Optional)
  # 設定内容: 特定のルートに対する個別の設定を指定します。
  # 関連機能: ルート固有の設定
  #   default_route_settingsで設定したデフォルト値を
  #   特定のルートでオーバーライドできます。
  route_settings {
    # route_key (Required)
    # 設定内容: ルートキーを指定します。
    # 設定可能な値:
    #   - HTTP API: "GET /items", "POST /items/{id}"など
    #   - WebSocket API: "$connect", "$disconnect", "$default", またはカスタムルートキー
    route_key = "GET /items"

    # data_trace_enabled (Optional)
    # 設定内容: このルートのデータトレースログを有効にするかを指定します。
    # 設定可能な値:
    #   - true: データトレースログを有効化
    #   - false (デフォルト): データトレースログを無効化
    # 注意: WebSocket APIでのみサポートされます。
    data_trace_enabled = false

    # detailed_metrics_enabled (Optional)
    # 設定内容: このルートの詳細メトリクスを有効にするかを指定します。
    # 設定可能な値:
    #   - true: 詳細メトリクスを有効化
    #   - false (デフォルト): 詳細メトリクスを無効化
    detailed_metrics_enabled = true

    # logging_level (Optional)
    # 設定内容: このルートのログレベルを指定します。
    # 設定可能な値:
    #   - "ERROR": エラーのみをログ
    #   - "INFO": すべてのイベントをログ
    #   - "OFF" (デフォルト): ログを無効化
    # 注意: WebSocket APIでのみサポートされます。
    logging_level = "INFO"

    # throttling_burst_limit (Optional)
    # 設定内容: このルートのスロットリングバースト制限を指定します。
    # 設定可能な値: 正の整数
    throttling_burst_limit = 1000

    # throttling_rate_limit (Optional)
    # 設定内容: このルートのスロットリングレート制限を指定します。
    # 設定可能な値: 正の数（リクエスト/秒）
    throttling_rate_limit = 2000.0
  }

  # 複数のルートに対して異なる設定を行う例
  route_settings {
    route_key                = "POST /items"
    detailed_metrics_enabled = true
    throttling_burst_limit   = 500
    throttling_rate_limit    = 1000.0
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
    Name        = "production-stage"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ステージの識別子
#
# - arn: ステージのAmazon Resource Name (ARN)
#
# - execution_arn: aws_lambda_permissionのsource_arn属性で使用する
#                  ARNプレフィックス。WebSocket APIでは、@connections APIへの
#                  アクセスを許可するIAMポリシーでも使用できます。
#                  例: arn:aws:execute-api:region:account-id:api-id/stage-name
#
# - invoke_url: ステージを指すAPI呼び出しURL
#               例（WebSocket）: wss://z4675bid1j.execute-api.eu-west-2.amazonaws.com/example-stage
#               例（HTTP）: https://z4675bid1j.execute-api.eu-west-2.amazonaws.com/
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
