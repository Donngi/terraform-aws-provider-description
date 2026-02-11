#---------------------------------------------------------------
# AWS API Gateway V2 Authorizer
#---------------------------------------------------------------
#
# Amazon API Gateway V2（HTTP APIおよびWebSocket API）のオーソライザーを
# プロビジョニングするリソースです。オーソライザーは、APIへのリクエストが
# 許可されているかどうかを判断するために使用されます。
# Lambda関数を使用したカスタム認可（REQUESTタイプ）や、
# JSON Web Tokens（JWTタイプ）による認可をサポートします。
#
# AWS公式ドキュメント:
#   - HTTP APIのアクセス制御: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-access-control.html
#   - Lambda Authorizer設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/configure-api-gateway-lambda-authorization.html
#   - API Gateway V2 Authorizerリファレンス: https://docs.aws.amazon.com/apigatewayv2/latest/api-reference/apis-apiid-authorizers-authorizerid.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_authorizer
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apigatewayv2_authorizer" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: オーソライザーを関連付けるAPIの識別子を指定します。
  # 設定可能な値: 有効なAPI Gateway V2 APIのID
  api_id = aws_apigatewayv2_api.example.id

  # authorizer_type (Required)
  # 設定内容: オーソライザーのタイプを指定します。
  # 設定可能な値:
  #   - "JWT": JSON Web Tokensを使用した認可（HTTP APIのみサポート）
  #   - "REQUEST": Lambda関数を使用してリクエストパラメータに基づく認可
  # 注意: HTTP APIではJWTとREQUESTの両方を使用可能
  #       WebSocket APIではREQUESTのみ使用可能
  authorizer_type = "REQUEST"

  # name (Required)
  # 設定内容: オーソライザーの名前を指定します。
  # 設定可能な値: 1〜128文字の文字列
  name = "example-authorizer"

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
  # Lambda Authorizer設定（REQUESTタイプ用）
  #-------------------------------------------------------------

  # authorizer_uri (Optional)
  # 設定内容: オーソライザーのUniform Resource Identifier（URI）を指定します。
  # 設定可能な値: Lambda関数のinvoke_arn形式のURI
  #   例: aws_lambda_function.example.invoke_arn
  # 必須条件: authorizer_typeが"REQUEST"の場合に必要
  # 文字数制限: 1〜2048文字
  authorizer_uri = aws_lambda_function.example.invoke_arn

  # authorizer_credentials_arn (Optional)
  # 設定内容: API GatewayがオーソライザーのLambda関数を呼び出すためのIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 必須条件: authorizer_typeが"REQUEST"の場合にサポート
  # 注意: 省略時は、Lambda関数のリソースベースポリシーでAPI Gatewayからの呼び出しを許可する必要があります
  authorizer_credentials_arn = null

  # authorizer_payload_format_version (Optional)
  # 設定内容: HTTP API Lambda Authorizerに送信されるペイロードのフォーマットバージョンを指定します。
  # 設定可能な値:
  #   - "1.0": バージョン1.0形式（従来形式）
  #   - "2.0": バージョン2.0形式（新形式、よりシンプルなペイロード）
  # 必須条件: HTTP APIのLambda Authorizerの場合に必須
  # 注意: WebSocket APIでは使用不可
  authorizer_payload_format_version = "2.0"

  # enable_simple_responses (Optional)
  # 設定内容: Lambda Authorizerがシンプルなレスポンスフォーマットを返すかを指定します。
  # 設定可能な値:
  #   - true: Lambda Authorizerはブール値のみを返すシンプルなレスポンスを使用
  #   - false: IAMポリシー形式のレスポンスを返す
  # サポート: HTTP APIのみ
  # 注意: trueにすると、Lambda関数はIAMポリシーの代わりにブール値を返すことができます
  enable_simple_responses = false

  #-------------------------------------------------------------
  # Identity Sources設定
  #-------------------------------------------------------------

  # identity_sources (Optional)
  # 設定内容: 認可に使用するアイデンティティソースを指定します。
  # 設定可能な値:
  #   REQUESTタイプの場合:
  #     HTTP API: "$request.header.{ヘッダー名}"、"$request.querystring.{パラメータ名}"など
  #     WebSocket API: "route.request.header.{ヘッダー名}"など
  #   JWTタイプの場合:
  #     JWTを抽出する場所を指定（例: "$request.header.Authorization"）
  # 注意: 複数のソースを指定可能（REQUESTタイプ）
  identity_sources = ["$request.header.Authorization"]

  #-------------------------------------------------------------
  # キャッシュ設定
  #-------------------------------------------------------------

  # authorizer_result_ttl_in_seconds (Optional)
  # 設定内容: キャッシュされたオーソライザーの結果のTTL（Time To Live）を秒単位で指定します。
  # 設定可能な値: 0〜3600（秒）
  #   - 0: 認可キャッシュを無効化
  #   - 1以上: 指定された秒数だけ認可結果をキャッシュ
  # 省略時: 300（5分）
  # サポート: HTTP API Lambda Authorizerのみ
  authorizer_result_ttl_in_seconds = 300

  #-------------------------------------------------------------
  # JWT設定（JWTタイプ用）
  #-------------------------------------------------------------

  # jwt_configuration (Optional)
  # 設定内容: JWT Authorizerの設定を指定します。
  # 必須条件: authorizer_typeが"JWT"の場合に必須
  # サポート: HTTP APIのみ
  jwt_configuration {
    # audience (Optional)
    # 設定内容: JWTの意図された受信者（audience）のリストを指定します。
    # 設定可能な値: 文字列のセット
    # 注意: 有効なJWTは、このリストの少なくとも1つのエントリと一致するaudを提供する必要があります
    audience = ["https://api.example.com"]

    # issuer (Optional)
    # 設定内容: JSON Web Tokensを発行するIDプロバイダーのベースドメインを指定します。
    # 設定可能な値: OIDC準拠のIDプロバイダーのURL
    #   例: Amazon Cognitoの場合はaws_cognito_user_pool.example.endpoint
    issuer = "https://cognito-idp.ap-northeast-1.amazonaws.com/ap-northeast-1_xxxxxxxxx"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # delete (Optional)
    # 設定内容: 削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    delete = null
  }
}

#---------------------------------------------------------------
# resource "aws_apigatewayv2_authorizer" "websocket_example" {
#   api_id           = aws_apigatewayv2_api.websocket.id
#   authorizer_type  = "REQUEST"
#   authorizer_uri   = aws_lambda_function.websocket_authorizer.invoke_arn
#   identity_sources = ["route.request.header.Auth"]
#   name             = "websocket-authorizer"
# }

#---------------------------------------------------------------
# resource "aws_apigatewayv2_authorizer" "jwt_example" {
#   api_id           = aws_apigatewayv2_api.http.id
#   authorizer_type  = "JWT"
#   identity_sources = ["$request.header.Authorization"]
#   name             = "cognito-authorizer"
#
#   jwt_configuration {
#     audience = [aws_cognito_user_pool_client.example.id]
#     issuer   = "https://${aws_cognito_user_pool.example.endpoint}"
#   }
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: オーソライザーの識別子
#
#---------------------------------------------------------------
