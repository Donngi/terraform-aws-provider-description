#---------------------------------------------------------------
# AWS API Gateway Authorizer
#---------------------------------------------------------------
#
# Amazon API Gateway REST APIにオーソライザー（認可機能）を追加するリソースです。
# オーソライザーは、APIへのアクセスを制御するために使用され、
# Lambda関数またはAmazon Cognito ユーザープールを使用してリクエストを認証します。
#
# AWS公式ドキュメント:
#   - API Gateway オーソライザーの使用: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html
#   - Cognito ユーザープールをオーソライザーとして使用: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-integrate-with-cognito.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_authorizer
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_authorizer" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: オーソライザーの名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "my-authorizer"

  # rest_api_id (Required)
  # 設定内容: 関連付けるREST APIのIDを指定します。
  # 設定可能な値: 有効なREST API ID
  rest_api_id = aws_api_gateway_rest_api.example.id

  #-------------------------------------------------------------
  # オーソライザータイプ設定
  #-------------------------------------------------------------

  # type (Optional)
  # 設定内容: オーソライザーのタイプを指定します。
  # 設定可能な値:
  #   - "TOKEN" (デフォルト): カスタムヘッダーで送信された単一の認可トークンを使用するLambda関数
  #   - "REQUEST": 受信リクエストパラメータ（ヘッダー、クエリ文字列、ステージ変数など）を使用するLambda関数
  #   - "COGNITO_USER_POOLS": Amazon Cognito ユーザープールを使用
  # 関連機能: Lambda オーソライザー / Cognito オーソライザー
  #   TOKENとREQUESTタイプはLambda関数でカスタム認可ロジックを実装。
  #   COGNITO_USER_POOLSはCognitoユーザープールと統合して認証を行います。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html
  type = "TOKEN"

  #-------------------------------------------------------------
  # Lambda オーソライザー設定 (type: TOKEN/REQUEST)
  #-------------------------------------------------------------

  # authorizer_uri (Optional, Required for type TOKEN/REQUEST)
  # 設定内容: オーソライザーのUniform Resource Identifier (URI)を指定します。
  # 設定可能な値: Lambda関数のURIで、以下の形式である必要があります:
  #   arn:aws:apigateway:{region}:lambda:path/{service_api}
  #   例: arn:aws:apigateway:us-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-2:012345678912:function:my-function/invocations
  # 注意: typeがTOKENまたはREQUESTの場合は必須
  # 関連機能: Lambda オーソライザー
  #   Lambda関数を使用してAPIリクエストの認可を行います。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html
  authorizer_uri = aws_lambda_function.authorizer.invoke_arn

  # authorizer_credentials (Optional)
  # 設定内容: オーソライザーに必要な認証情報を指定します。
  # 設定可能な値: IAMロールARN
  # 用途: API GatewayがLambda関数を呼び出すために引き受けるIAMロールを指定します。
  # 関連機能: API Gateway 実行ロール
  #   API GatewayがLambdaオーソライザーを呼び出す権限を持つIAMロール。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html
  authorizer_credentials = aws_iam_role.invocation_role.arn

  #-------------------------------------------------------------
  # Cognito ユーザープール設定 (type: COGNITO_USER_POOLS)
  #-------------------------------------------------------------

  # provider_arns (Optional, Required for type COGNITO_USER_POOLS)
  # 設定内容: Amazon Cognito ユーザープールのARNのリストを指定します。
  # 設定可能な値: Cognito ユーザープールARNのリスト
  #   各要素は以下の形式: arn:aws:cognito-idp:{region}:{account_id}:userpool/{user_pool_id}
  # 注意: typeがCOGNITO_USER_POOLSの場合は必須
  # 関連機能: Amazon Cognito ユーザープール
  #   Cognitoユーザープールを使用してAPIリクエストを認証します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-integrate-with-cognito.html
  provider_arns = null

  #-------------------------------------------------------------
  # アイデンティティソース設定
  #-------------------------------------------------------------

  # identity_source (Optional)
  # 設定内容: 受信リクエスト内のアイデンティティのソースを指定します。
  # 設定可能な値:
  #   - TOKENタイプ: ヘッダー名（デフォルト: "method.request.header.Authorization"）
  #   - REQUESTタイプ: ヘッダー、クエリ文字列パラメータ、ステージ変数をカンマ区切りで指定
  #     例: "method.request.header.SomeHeaderName,method.request.querystring.SomeQueryStringName,stageVariables.SomeStageVariableName"
  # 省略時: "method.request.header.Authorization"
  # 関連機能: Lambda オーソライザーのアイデンティティソース
  #   オーソライザーに渡すリクエストパラメータを指定します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html
  identity_source = "method.request.header.Authorization"

  # identity_validation_expression (Optional)
  # 設定内容: 受信アイデンティティの検証式を指定します。
  # 設定可能な値: 正規表現パターン（TOKENタイプの場合）
  # 用途: クライアントからの受信トークンがこの式と照合され、
  #       一致した場合のみ処理が続行されます。一致しない場合、
  #       クライアントは401 Unauthorizedレスポンスを受け取ります。
  # 例: "^Bearer [-0-9a-zA-Z._]*$" （Bearerトークン形式の検証）
  # 関連機能: トークン検証
  #   Lambda関数を呼び出す前にトークン形式を検証し、無効なトークンを早期に拒否できます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html
  identity_validation_expression = null

  #-------------------------------------------------------------
  # キャッシュ設定
  #-------------------------------------------------------------

  # authorizer_result_ttl_in_seconds (Optional)
  # 設定内容: キャッシュされたオーソライザー結果のTTL（秒）を指定します。
  # 設定可能な値: 0〜3600の整数
  #   - 0: キャッシュを無効化
  #   - 1-3600: 指定した秒数だけ結果をキャッシュ
  # 省略時: 300秒（5分）
  # 関連機能: オーソライザーキャッシング
  #   オーソライザーの結果をキャッシュすることで、Lambda関数の呼び出し回数を減らし、
  #   レイテンシーを改善できます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html
  authorizer_result_ttl_in_seconds = 300

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
# - arn: API Gateway オーソライザーのAmazon Resource Name (ARN)
#
# - id: オーソライザーの識別子
#---------------------------------------------------------------
