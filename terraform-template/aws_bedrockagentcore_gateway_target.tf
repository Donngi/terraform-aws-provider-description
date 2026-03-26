#---------------------------------------------------------------
# AWS Bedrock AgentCore Gateway Target
#---------------------------------------------------------------
#
# Amazon Bedrock AgentCore Gatewayのターゲットを管理するリソースです。
# Gateway Targetは、ゲートウェイが呼び出すエンドポイントと構成を定義し、
# Lambda関数、API Gateway、MCPサーバーなどの外部サービスと
# Model Context Protocol (MCP) を通じてエージェントが対話できるようにします。
#
# AWS公式ドキュメント:
#   - AgentCore Gateway概要: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway.html
#   - サポートされるターゲット: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway-supported-targets.html
#   - ターゲット設定ガイド: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway-add-target-api-target-config.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_gateway_target
#
# Provider Version: 6.38.0
# Generated: 2026-03-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_gateway_target" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Gateway Targetの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-target"

  # gateway_identifier (Required)
  # 設定内容: このターゲットが属するGatewayの識別子を指定します。
  # 設定可能な値: Gateway ID または ARN
  gateway_identifier = aws_bedrockagentcore_gateway.example.gateway_id

  # description (Optional)
  # 設定内容: Gateway Targetの説明を指定します。
  # 設定可能な値: 文字列
  description = "Lambda function target for processing requests"

  # region (Optional)
  # 設定内容: リソースを作成するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 認証設定 (credential_provider_configuration)
  #-------------------------------------------------------------
  # ターゲットへのリクエスト認証の設定です。
  # lambda、open_api_schema、smithy_modelを使用する場合は必須です。
  # mcp_serverを認証なしで使用する場合は指定しないでください。
  # 以下の3つから1つを選択して設定します:
  #   - gateway_iam_role: GatewayのIAMロールを使用
  #   - api_key: APIキーベースの認証
  #   - oauth: OAuthベースの認証

  credential_provider_configuration {
    #-----------------------------------------------------------
    # オプション1: Gateway IAM Role認証 (gateway_iam_role)
    #-----------------------------------------------------------
    # GatewayのIAMロールを認証に使用します。
    # 空のブロックとして指定します。

    gateway_iam_role {}

    #-----------------------------------------------------------
    # オプション2: APIキー認証 (api_key)
    #-----------------------------------------------------------
    # APIキーベースの認証設定です。

    # api_key {
    #   # provider_arn (Required)
    #   # 設定内容: APIキー認証用のOIDCプロバイダーのARNを指定します。
    #   # 設定可能な値: 有効なOIDCプロバイダーARN
    #   provider_arn = "arn:aws:iam::123456789012:oidc-provider/example.com"
    #
    #   # credential_location (Optional)
    #   # 設定内容: APIキー認証情報の場所を指定します。
    #   # 設定可能な値:
    #   #   - "HEADER": HTTPヘッダーに認証情報を配置
    #   #   - "QUERY_PARAMETER": クエリパラメータに認証情報を配置
    #   credential_location = "HEADER"
    #
    #   # credential_parameter_name (Optional)
    #   # 設定内容: APIキー認証情報を含むパラメータ名を指定します。
    #   # 設定可能な値: 文字列（例: "X-API-Key", "Authorization"）
    #   credential_parameter_name = "X-API-Key"
    #
    #   # credential_prefix (Optional)
    #   # 設定内容: APIキー認証情報の値に追加するプレフィックスを指定します。
    #   # 設定可能な値: 文字列（例: "Bearer", "ApiKey"）
    #   credential_prefix = "Bearer"
    # }

    #-----------------------------------------------------------
    # オプション3: OAuth認証 (oauth)
    #-----------------------------------------------------------
    # OAuthベースの認証設定です。

    # oauth {
    #   # provider_arn (Required)
    #   # 設定内容: OAuth認証用のOAuth認証情報プロバイダーのARNを指定します。
    #   # 設定可能な値: 有効なOAuth認証情報プロバイダーARN
    #   provider_arn = "arn:aws:iam::123456789012:oidc-provider/oauth.example.com"
    #
    #   # scopes (Required)
    #   # 設定内容: リクエストするOAuthスコープのセットを指定します。
    #   # 設定可能な値: 文字列のセット
    #   scopes = ["read", "write"]
    #
    #   # grant_type (Optional)
    #   # 設定内容: OAuthの認可タイプを指定します。
    #   # 設定可能な値:
    #   #   - "CLIENT_CREDENTIALS": マシン間認証
    #   #   - "AUTHORIZATION_CODE": ユーザー委任アクセス
    #   grant_type = "CLIENT_CREDENTIALS"
    #
    #   # default_return_url (Optional)
    #   # 設定内容: 認可コード取得後にブラウザがリダイレクトされるURLを指定します。
    #   # 設定可能な値: 有効なURL文字列
    #   # 注意: grant_typeが"AUTHORIZATION_CODE"の場合は必須
    #   # default_return_url = "https://myapp.example.com/callback"
    #
    #   # custom_parameters (Optional)
    #   # 設定内容: OAuthリクエストに含めるカスタムパラメータを指定します。
    #   # 設定可能な値: 文字列のマップ
    #   custom_parameters = {
    #     "client_type" = "confidential"
    #   }
    # }
  }

  #-------------------------------------------------------------
  # ターゲット設定 (target_configuration)
  #-------------------------------------------------------------
  # ターゲットエンドポイントの設定を定義します（必須）。

  target_configuration {
    #-----------------------------------------------------------
    # MCP設定 (mcp)
    #-----------------------------------------------------------
    # Model Context Protocol (MCP) の設定です。
    # 以下の5つから1つを選択して設定します:
    #   - lambda: Lambda関数ターゲット
    #   - api_gateway: API Gateway REST APIターゲット
    #   - mcp_server: MCPサーバーターゲット
    #   - open_api_schema: OpenAPIスキーマベースのターゲット
    #   - smithy_model: Smithyモデルベースのターゲット

    mcp {
      #---------------------------------------------------------
      # オプション1: Lambda関数ターゲット (lambda)
      #---------------------------------------------------------

      lambda {
        # lambda_arn (Required)
        # 設定内容: 呼び出すLambda関数のARNを指定します。
        # 設定可能な値: 有効なLambda関数ARN
        lambda_arn = aws_lambda_function.example.arn

        #-------------------------------------------------------
        # ツールスキーマ (tool_schema)
        #-------------------------------------------------------
        # ツールのスキーマ定義です（Lambda使用時は必須）。
        # inline_payload または s3 のいずれかを指定します。

        tool_schema {
          #-----------------------------------------------------
          # オプション1: インラインペイロード (inline_payload)
          #-----------------------------------------------------

          inline_payload {
            # name (Required)
            # 設定内容: ツールの名前を指定します。
            # 設定可能な値: 文字列
            name = "process_request"

            # description (Required)
            # 設定内容: ツールの説明を指定します。
            # 設定可能な値: 文字列
            description = "Process incoming requests"

            #---------------------------------------------------
            # 入力スキーマ (input_schema) - 必須
            #---------------------------------------------------
            # ツールの入力スキーマを定義します。

            input_schema {
              # type (Required)
              # 設定内容: スキーマのデータ型を指定します。
              # 設定可能な値: "string", "number", "integer", "boolean", "array", "object"
              type = "object"

              # description (Optional)
              # 設定内容: スキーマ要素の説明を指定します。
              # 設定可能な値: 文字列
              description = "Request processing schema"

              #-------------------------------------------------
              # プロパティ定義 (property) - typeが"object"の場合
              #-------------------------------------------------
              # オブジェクト型の場合、プロパティを定義します。

              property {
                # name (Required)
                # 設定内容: プロパティの名前を指定します。
                # 設定可能な値: 文字列
                name = "message"

                # type (Required)
                # 設定内容: プロパティのデータ型を指定します。
                # 設定可能な値: "string", "number", "integer", "boolean", "array", "object"
                type = "string"

                # description (Optional)
                # 設定内容: プロパティの説明を指定します。
                # 設定可能な値: 文字列
                description = "Message to process"

                # required (Optional)
                # 設定内容: このプロパティが必須かどうかを指定します。
                # 設定可能な値: true, false
                # 省略時: false
                required = true

                # items_json (Optional)
                # 設定内容: 配列アイテムのJSONエンコードされたスキーマ定義を指定します。
                # 用途: 複雑なネスト構造に使用。properties_jsonとは排他的。
                # items_json = jsonencode({ type = "string" })

                # properties_json (Optional)
                # 設定内容: オブジェクトプロパティのJSONエンコードされたスキーマ定義を指定します。
                # 用途: 複雑なネスト構造に使用。items_jsonとは排他的。
                # properties_json = jsonencode({
                #   properties = {
                #     "created_at" = { type = "string" }
                #     "version"    = { type = "number" }
                #   }
                #   required = ["created_at"]
                # })

                #-----------------------------------------------
                # ネストされたitems定義 (typeが"array"の場合)
                #-----------------------------------------------
                # items {
                #   type        = "string"
                #   description = "Array item description"
                #
                #   # さらにネストされたitems（配列の配列の場合）
                #   # items {
                #   #   type = "string"
                #   # }
                #
                #   # ネストされたproperty（オブジェクトの配列の場合）
                #   # property {
                #   #   name = "nested_property"
                #   #   type = "string"
                #   # }
                # }

                #-----------------------------------------------
                # ネストされたproperty定義 (typeが"object"の場合)
                #-----------------------------------------------
                # property {
                #   name = "nested_property"
                #   type = "string"
                # }
              }

              property {
                name = "options"
                type = "object"

                property {
                  name = "priority"
                  type = "string"
                }

                property {
                  name = "tags"
                  type = "array"

                  items {
                    type = "string"
                  }
                }
              }

              #-------------------------------------------------
              # アイテム定義 (items) - typeが"array"の場合
              #-------------------------------------------------
              # 配列型の場合、アイテムのスキーマを定義します。

              # items {
              #   # type (Required)
              #   # 設定内容: 配列アイテムのデータ型を指定します。
              #   # 設定可能な値: "string", "number", "integer", "boolean", "array", "object"
              #   type = "string"
              #
              #   # description (Optional)
              #   # 設定内容: 配列アイテムの説明を指定します。
              #   # 設定可能な値: 文字列
              #   description = "Array item"
              #
              #   # ネストされたitems（配列の配列の場合）
              #   # items { ... }
              #
              #   # ネストされたproperty（オブジェクトの配列の場合）
              #   # property { ... }
              # }
            }

            #---------------------------------------------------
            # 出力スキーマ (output_schema) - オプション
            #---------------------------------------------------
            # ツールの出力スキーマを定義します。
            # 構造はinput_schemaと同様です。

            output_schema {
              type = "object"

              property {
                name     = "status"
                type     = "string"
                required = true
              }

              property {
                name = "result"
                type = "string"
              }
            }
          }

          #-----------------------------------------------------
          # オプション2: S3ベースのツール定義 (s3)
          #-----------------------------------------------------

          # s3 {
          #   # uri (Optional)
          #   # 設定内容: ツールスキーマが保存されているS3 URIを指定します。
          #   # 設定可能な値: S3 URI（例: "s3://bucket-name/path/to/schema.json"）
          #   uri = "s3://my-bucket/schemas/tool-schema.json"
          #
          #   # bucket_owner_account_id (Optional)
          #   # 設定内容: S3バケット所有者のアカウントIDを指定します。
          #   # 設定可能な値: AWSアカウントID
          #   bucket_owner_account_id = "123456789012"
          # }
        }
      }

      #---------------------------------------------------------
      # オプション2: API Gatewayターゲット (api_gateway)
      #---------------------------------------------------------
      # API Gateway REST APIステージをターゲットとして使用します。
      # REST APIのパスとメソッドをMCPツールとして公開します。

      # api_gateway {
      #   # rest_api_id (Required)
      #   # 設定内容: 呼び出すAPI Gateway REST APIのIDを指定します。
      #   # 設定可能な値: 有効なREST API ID
      #   rest_api_id = aws_api_gateway_rest_api.example.id
      #
      #   # stage (Required)
      #   # 設定内容: ターゲットとして追加するREST APIのステージ名を指定します。
      #   # 設定可能な値: 有効なステージ名
      #   stage = "prod"
      #
      #   #-----------------------------------------------------
      #   # API Gatewayツール設定 (api_gateway_tool_configuration)
      #   #-----------------------------------------------------
      #   # ツールのフィルタリングとオーバーライドの設定です。
      #
      #   api_gateway_tool_configuration {
      #     #---------------------------------------------------
      #     # ツールフィルター (tool_filter)
      #     #---------------------------------------------------
      #     # パスとメソッドパターンで公開するツールをフィルタリングします。
      #     # 複数のtool_filterブロックを指定可能です。
      #
      #     tool_filter {
      #       # filter_path (Required)
      #       # 設定内容: REST APIでマッチさせるリソースパスを指定します。
      #       # 設定可能な値: 完全パス（例: "/pets"）またはワイルドカードパス（例: "/pets/*"）
      #       # 注意: REST APIに存在するパスと一致する必要があります
      #       filter_path = "/pets/*"
      #
      #       # methods (Required)
      #       # 設定内容: フィルタリングするHTTPメソッドのリストを指定します。
      #       # 設定可能な値: "GET", "DELETE", "HEAD", "OPTIONS", "PATCH", "PUT", "POST"
      #       methods = ["GET", "POST"]
      #     }
      #
      #     #---------------------------------------------------
      #     # ツールオーバーライド (tool_override)
      #     #---------------------------------------------------
      #     # ツール定義を明示的にカスタマイズします。
      #     # 複数のtool_overrideブロックを指定可能です。
      #
      #     tool_override {
      #       # name (Required)
      #       # 設定内容: ツールの名前を指定します。
      #       # 設定可能な値: Model Context Protocolでツールを識別する文字列
      #       name = "list_pets"
      #
      #       # path (Required)
      #       # 設定内容: REST APIのリソースパスを指定します。
      #       # 設定可能な値: REST APIに存在するパス（例: "/pets"）
      #       # 注意: REST APIに存在するパスと明示的に一致する必要があります
      #       path = "/pets"
      #
      #       # method (Required)
      #       # 設定内容: 公開するHTTPメソッドを指定します。
      #       # 設定可能な値: "GET", "DELETE", "HEAD", "OPTIONS", "PATCH", "PUT", "POST"
      #       method = "GET"
      #
      #       # description (Optional)
      #       # 設定内容: ツールの説明を指定します。
      #       # 設定可能な値: 文字列
      #       # 省略時: APIのOpenAPI仕様からの説明を使用
      #       description = "List all pets"
      #     }
      #   }
      # }

      #---------------------------------------------------------
      # オプション3: MCPサーバーターゲット (mcp_server)
      #---------------------------------------------------------
      # 既存のMCPサーバーをターゲットとして使用します。

      # mcp_server {
      #   # endpoint (Required)
      #   # 設定内容: MCPサーバーのエンドポイントを指定します。
      #   # 設定可能な値: 有効なエンドポイントURL
      #   endpoint = "https://mcp-server.example.com/mcp"
      # }

      #---------------------------------------------------------
      # オプション4: OpenAPIスキーマターゲット (open_api_schema)
      #---------------------------------------------------------
      # OpenAPI仕様を使用してREST APIをMCPツールに変換します。

      # open_api_schema {
      #   # インラインペイロード
      #   inline_payload {
      #     # payload (Required)
      #     # 設定内容: OpenAPIスキーマのペイロードを指定します。
      #     # 設定可能な値: JSON/YAML形式のOpenAPI仕様
      #     payload = file("openapi-spec.json")
      #   }
      #
      #   # または S3ベース
      #   # s3 {
      #   #   uri                     = "s3://my-bucket/schemas/openapi-spec.json"
      #   #   bucket_owner_account_id = "123456789012"
      #   # }
      # }

      #---------------------------------------------------------
      # オプション5: Smithyモデルターゲット (smithy_model)
      #---------------------------------------------------------
      # Smithyモデル定義を使用してMCPツールを構築します。

      # smithy_model {
      #   # インラインペイロード
      #   inline_payload {
      #     # payload (Required)
      #     # 設定内容: Smithyモデルのペイロードを指定します。
      #     # 設定可能な値: Smithyモデル定義
      #     payload = file("smithy-model.smithy")
      #   }
      #
      #   # または S3ベース
      #   # s3 {
      #   #   uri                     = "s3://my-bucket/schemas/smithy-model.smithy"
      #   #   bucket_owner_account_id = "123456789012"
      #   # }
      # }
    }
  }

  #-------------------------------------------------------------
  # メタデータ設定 (metadata_configuration)
  #-------------------------------------------------------------
  # GatewayとターゲットサーバーのHTTPヘッダーおよびクエリパラメータの
  # 伝播設定を定義します。各設定は最大10項目まで指定可能です。
  # 参考: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway-headers.html

  metadata_configuration {
    # allowed_request_headers (Optional)
    # 設定内容: クライアントリクエストからターゲットに伝播を許可するHTTPヘッダーを指定します。
    # 設定可能な値: 文字列のセット（最大10件）
    # 注意: 標準HTTPヘッダー（認証、コンテンツネゴシエーション等）や
    #       X-Amzn-で始まるヘッダー（X-Amzn-Bedrock-AgentCore-Runtime-Custom-*を除く）は制限されています。
    allowed_request_headers = ["x-correlation-id", "x-tenant-id"]

    # allowed_response_headers (Optional)
    # 設定内容: ターゲットレスポンスからクライアントに伝播を許可するHTTPヘッダーを指定します。
    # 設定可能な値: 文字列のセット（最大10件）
    allowed_response_headers = ["x-rate-limit-remaining"]

    # allowed_query_parameters (Optional)
    # 設定内容: GatewayのURLからターゲットに伝播を許可するURLクエリパラメータを指定します。
    # 設定可能な値: 文字列のセット（最大10件）
    allowed_query_parameters = ["version"]
  }

  #-------------------------------------------------------------
  # タイムアウト設定 (timeouts)
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - target_id: Gateway Targetの一意の識別子
#
#---------------------------------------------------------------
