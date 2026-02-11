#---------------------------------------------------------------
# AWS API Gateway Integration
#---------------------------------------------------------------
#
# Amazon API Gateway REST APIのメソッドに対するバックエンド統合を設定するリソースです。
# API Gatewayがクライアントからのリクエストを受け取った際に、どのようにバックエンド
# サービス（Lambda関数、HTTPエンドポイント、AWSサービス等）と連携するかを定義します。
#
# AWS公式ドキュメント:
#   - API Gateway REST API統合: https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-integration-settings.html
#   - 統合タイプ: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-integration-types.html
#   - レスポンスストリーミング: https://docs.aws.amazon.com/apigateway/latest/developerguide/response-transfer-mode.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_integration" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # rest_api_id (Required)
  # 設定内容: 関連付けるREST APIのIDを指定します。
  # 設定可能な値: REST APIリソースのID
  rest_api_id = aws_api_gateway_rest_api.example.id

  # resource_id (Required)
  # 設定内容: 統合を設定するAPIリソースのIDを指定します。
  # 設定可能な値: API Gatewayリソースのリソース ID
  resource_id = aws_api_gateway_resource.example.id

  # http_method (Required)
  # 設定内容: 関連リソースを呼び出す際のHTTPメソッドを指定します。
  # 設定可能な値:
  #   - "GET": GETリクエスト
  #   - "POST": POSTリクエスト
  #   - "PUT": PUTリクエスト
  #   - "DELETE": DELETEリクエスト
  #   - "HEAD": HEADリクエスト
  #   - "OPTION": OPTIONリクエスト
  #   - "ANY": 任意のHTTPメソッド
  http_method = aws_api_gateway_method.example.http_method

  # type (Required)
  # 設定内容: 統合の入力タイプを指定します。
  # 設定可能な値:
  #   - "HTTP": HTTPバックエンド用。リクエスト/レスポンスのマッピングが可能
  #   - "HTTP_PROXY": HTTPプロキシ統合。リクエストをそのままバックエンドに転送
  #   - "AWS": AWSサービス統合。リクエスト/レスポンスのマッピングが可能
  #   - "AWS_PROXY": Lambdaプロキシ統合。Lambda関数にイベントをそのまま渡す
  #   - "MOCK": モック統合。実際のバックエンドを呼び出さずにレスポンスを返す
  # 関連機能: API Gateway統合タイプ
  #   VPC_LINKをconnection_typeに設定したHTTPまたはHTTP_PROXY統合は
  #   プライベート統合と呼ばれ、VpcLinkを使用してAPI GatewayをVPC内の
  #   ネットワークロードバランサーに接続します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-integration-types.html
  type = "AWS_PROXY"

  #-------------------------------------------------------------
  # バックエンド接続設定
  #-------------------------------------------------------------

  # uri (Optional)
  # 設定内容: 統合先のURIを指定します。
  # 設定可能な値:
  #   - HTTP統合: 完全な形式のエンコードされたHTTP(S) URL（RFC-3986準拠）
  #   - AWS統合: arn:aws:apigateway:{region}:{subdomain.service|service}:{path|action}/{service_api}
  # 必須条件: typeがAWS、AWS_PROXY、HTTP、HTTP_PROXYの場合は必須
  # 例: Lambda関数の場合
  #   arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:123456789012:function:my-func/invocations
  # 注意: プライベート統合の場合、URIパラメータはリクエストのルーティングには使用されず、
  #       Hostヘッダーの設定と証明書の検証に使用されます。
  uri = aws_lambda_function.example.invoke_arn

  # integration_http_method (Optional)
  # 設定内容: API Gatewayがバックエンドと通信する際に使用するHTTPメソッドを指定します。
  # 設定可能な値:
  #   - "GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "ANY", "PATCH"
  # 必須条件: typeがAWS、AWS_PROXY、HTTP、HTTP_PROXYの場合は必須
  # 注意: 全てのAWS統合で全てのメソッドが互換性があるわけではありません。
  #       例えばLambda関数はPOSTでのみ呼び出し可能です。
  integration_http_method = "POST"

  # integration_target (Optional)
  # 設定内容: VPC Link V2を使用したプライベート統合でリクエストを送信する
  #           ALBまたはNLBのARNを指定します。
  # 設定可能な値: ALBまたはNLBのARN
  # 関連機能: VPC Link V2プライベート統合
  #   VPC Link V2を使用する場合、このパラメータでロードバランサーARNを指定し、
  #   uriはHostヘッダーの設定に使用されます。
  integration_target = null

  #-------------------------------------------------------------
  # VPCリンク設定
  #-------------------------------------------------------------

  # connection_type (Optional)
  # 設定内容: 統合の接続タイプを指定します。
  # 設定可能な値:
  #   - "INTERNET" (デフォルト): パブリックなインターネット経由の接続
  #   - "VPC_LINK": API GatewayとVPC内のネットワークロードバランサー間のプライベート接続
  # 関連機能: API Gatewayプライベート統合
  #   VPC_LINKを使用すると、VPC内のリソースにパブリックインターネットを経由せずに
  #   アクセスできます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-private-integration.html
  connection_type = "INTERNET"

  # connection_id (Optional)
  # 設定内容: 統合に使用するVpcLinkのIDを指定します。
  # 設定可能な値: VpcLinkリソースのID
  # 必須条件: connection_typeがVPC_LINKの場合は必須
  connection_id = null

  #-------------------------------------------------------------
  # 認証情報設定
  #-------------------------------------------------------------

  # credentials (Optional)
  # 設定内容: 統合に必要な認証情報を指定します。
  # 設定可能な値:
  #   - IAMロールのARN: API Gatewayが引き受けるロール
  #   - "arn:aws:iam::*:user/*": 呼び出し元のIDをリクエストからパススルー
  # 用途: AWS統合でバックエンドAWSサービスへのアクセス権限を付与
  credentials = null

  #-------------------------------------------------------------
  # リクエスト変換設定
  #-------------------------------------------------------------

  # request_templates (Optional)
  # 設定内容: リクエストテンプレートのマップを指定します。
  # 設定可能な値: Content-Typeをキー、VTL（Velocity Template Language）テンプレートを値とするマップ
  # 関連機能: API Gatewayマッピングテンプレート
  #   リクエストをバックエンド用に変換するために使用します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/models-mappings.html
  request_templates = {
    "application/json" = <<EOF
{
  "body" : $input.json('$')
}
EOF
  }

  # request_parameters (Optional)
  # 設定内容: バックエンドに渡すリクエストクエリ文字列パラメータとヘッダーのマップを指定します。
  # 設定可能な値: キーは "integration.request.{location}.{name}" 形式
  #              値は "method.request.{location}.{name}" またはリテラル値（シングルクォートで囲む）
  # 例: { "integration.request.header.X-Some-Header" = "method.request.header.X-Original-Header" }
  #     { "integration.request.header.X-Api-Key" = "'static-value'" }
  request_parameters = {
    "integration.request.header.X-Authorization" = "'static'"
  }

  # passthrough_behavior (Optional)
  # 設定内容: リクエストのContent-Typeがrequest_templatesで定義されていない場合の動作を指定します。
  # 設定可能な値:
  #   - "WHEN_NO_MATCH": テンプレートが一致しない場合、リクエストボディをそのまま渡す
  #   - "WHEN_NO_TEMPLATES": テンプレートが定義されていない場合のみ、リクエストボディをそのまま渡す
  #   - "NEVER": テンプレートが一致しない場合、リクエストを拒否（415 Unsupported Media Type）
  # 必須条件: request_templatesを使用する場合は必須
  passthrough_behavior = "WHEN_NO_MATCH"

  # content_handling (Optional)
  # 設定内容: リクエストペイロードのコンテンツタイプ変換方法を指定します。
  # 設定可能な値:
  #   - "CONVERT_TO_BINARY": ペイロードをBase64デコードされたバイナリに変換
  #   - "CONVERT_TO_TEXT": ペイロードをBase64エンコードされたテキストに変換
  # 省略時: passthroughBehaviorsがペイロードのパススルーをサポートするよう設定されている場合、
  #         リクエストペイロードは変更なしでそのまま渡されます。
  content_handling = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeout_milliseconds (Optional)
  # 設定内容: カスタムタイムアウト時間をミリ秒で指定します。
  # 設定可能な値:
  #   - 最小値: 50ミリ秒
  #   - response_transfer_modeがBUFFEREDの場合: 最大300,000ミリ秒（5分）
  #   - response_transfer_modeがSTREAMの場合: 最大900,000ミリ秒（15分）
  # 省略時: 29,000ミリ秒（29秒）
  # 注意: BUFFEREDモードで29,000ミリ秒を超える場合はService Quota Ticketの申請が必要
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_service_limits.html
  timeout_milliseconds = 29000

  #-------------------------------------------------------------
  # レスポンスストリーミング設定
  #-------------------------------------------------------------

  # response_transfer_mode (Optional)
  # 設定内容: レスポンスの転送モードを指定します。
  # 設定可能な値:
  #   - "BUFFERED" (デフォルト): API Gatewayは完全なレスポンスを受信してからクライアントに送信
  #   - "STREAM": API Gatewayはレスポンスを受信しながらリアルタイムでクライアントに送信
  # 関連機能: API Gatewayレスポンスストリーミング
  #   STREAMモードを使用すると、Time-to-First-Byte（TTFB）が改善され、
  #   最大15分のタイムアウトと10MBを超えるペイロードがサポートされます。
  #   HTTP_PROXYとAWS_PROXY統合タイプでのみ使用可能です。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/response-transfer-mode.html
  # 注意: ストリーミングモードでは、エンドポイントキャッシュ、コンテンツエンコーディング、
  #       VTLによるレスポンス変換はサポートされません。
  response_transfer_mode = "BUFFERED"

  #-------------------------------------------------------------
  # キャッシュ設定
  #-------------------------------------------------------------

  # cache_namespace (Optional)
  # 設定内容: 統合のキャッシュ名前空間を指定します。
  # 設定可能な値: 文字列
  # 関連機能: API Gatewayキャッシュ
  #   キャッシュを有効にした場合、このパラメータでキャッシュの名前空間を指定します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-caching.html
  cache_namespace = null

  # cache_key_parameters (Optional)
  # 設定内容: 統合のキャッシュキーパラメータのリストを指定します。
  # 設定可能な値: キャッシュキーとして使用するパラメータ名のリスト
  # 例: ["method.request.path.param", "method.request.querystring.id"]
  cache_key_parameters = []

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
  # TLS設定
  #-------------------------------------------------------------

  # tls_config (Optional)
  # 設定内容: TLS設定を指定するブロックです。
  # 用途: HTTPおよびHTTP_PROXY統合で証明書検証の動作をカスタマイズ
  tls_config {
    # insecure_skip_verification (Optional)
    # 設定内容: API Gatewayが統合エンドポイントの証明書がサポートされている認証局から
    #           発行されているかどうかの検証をスキップするかを指定します。
    # 設定可能な値:
    #   - true: 証明書検証をスキップ（非推奨だが、プライベートCAや自己署名証明書の使用が可能）
    #   - false (デフォルト): 証明書検証を実施
    # 注意: trueに設定しても、API Gatewayは証明書の有効期限、ホスト名、
    #       ルートCAの存在などの基本的な検証は実行します。
    # サポート: HTTPおよびHTTP_PROXY統合でのみサポート
    # 参考: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-supported-certificate-authorities-for-http-endpoints.html
    insecure_skip_verification = false
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 統合の識別子（{rest_api_id}/{resource_id}/{http_method}の形式）
#
#---------------------------------------------------------------
