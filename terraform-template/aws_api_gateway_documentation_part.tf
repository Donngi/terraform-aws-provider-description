# ================================================================================
# AWS API Gateway Documentation Part - Annotated Template
# ================================================================================
# Generated: 2026-01-22
# Provider Version: hashicorp/aws 6.28.0
#
# NOTE: このテンプレートは生成時点の情報に基づいています。
#       最新の仕様は公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_documentation_part
# ================================================================================

# --------------------------------------------------------------------------------
# Resource: aws_api_gateway_documentation_part
# --------------------------------------------------------------------------------
# API Gatewayのドキュメントパートを管理するリソース。
# ドキュメントパートは、API Gateway REST APIの特定のエンティティ（API、リソース、メソッド、
# レスポンス、認可、モデルなど）に関連付けられたドキュメントコンテンツを定義します。
#
# ドキュメントパートは、APIのドキュメント全体を構成するコンポーネントであり、
# 複数のドキュメントパートを組み合わせてAPIドキュメントを作成します。
#
# AWS公式ドキュメント:
# - API Gateway Documentation: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-documenting-api.html
# - Documentation Parts: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-documenting-api-content-representation.html
# --------------------------------------------------------------------------------

resource "aws_api_gateway_documentation_part" "example" {

  # ==============================================================================
  # 必須パラメータ (Required Parameters)
  # ==============================================================================

  # ------------------------------------------------------------------------------
  # rest_api_id
  # ------------------------------------------------------------------------------
  # (Required) ドキュメントパートを関連付けるREST APIのID。
  #
  # この値は、aws_api_gateway_rest_apiリソースから取得するのが一般的です。
  # 1つのREST APIに対して複数のドキュメントパートを作成できます。
  #
  # Type: string
  # ------------------------------------------------------------------------------
  rest_api_id = aws_api_gateway_rest_api.example.id

  # ------------------------------------------------------------------------------
  # properties
  # ------------------------------------------------------------------------------
  # (Required) ドキュメント対象のAPIエンティティを説明するJSON文字列。
  #
  # SwaggerまたはOpenAPI仕様に準拠したキーと値のペアを含む必要があります。
  # このプロパティに記載された情報のみがエクスポートおよび公開可能です。
  #
  # 一般的に含まれるキー:
  # - description: エンティティの説明
  # - summary: エンティティの要約（OpenAPI 3.0）
  # - tags: タグのリスト
  # - externalDocs: 外部ドキュメントへのリンク
  #
  # Example:
  #   properties = jsonencode({
  #     description = "This API endpoint retrieves user information"
  #     summary     = "Get User Info"
  #   })
  #
  # Type: string (JSON encoded)
  # Default: なし
  # ------------------------------------------------------------------------------
  properties = jsonencode({
    description = "Example API documentation"
    summary     = "API documentation part example"
  })

  # ==============================================================================
  # ネストブロック: location (Required)
  # ==============================================================================
  # ドキュメントパートが対象とするAPIエンティティの場所を指定します。
  # このブロックは必須で、1つだけ指定可能です（min_items=1, max_items=1）。
  #
  # locationの組み合わせにより、ドキュメント対象のAPIエンティティが一意に特定されます。
  # ==============================================================================

  location {

    # ----------------------------------------------------------------------------
    # type (Required)
    # ----------------------------------------------------------------------------
    # (Required) ドキュメントが適用されるAPIエンティティのタイプ。
    #
    # 有効な値:
    # - API: REST API全体
    # - AUTHORIZER: カスタム認証
    # - MODEL: データモデル（リクエスト/レスポンスのスキーマ）
    # - RESOURCE: APIリソース（パス）
    # - METHOD: HTTPメソッド
    # - PATH_PARAMETER: パスパラメータ
    # - QUERY_PARAMETER: クエリパラメータ
    # - REQUEST_HEADER: リクエストヘッダー
    # - REQUEST_BODY: リクエストボディ
    # - RESPONSE: HTTPレスポンス
    # - RESPONSE_HEADER: レスポンスヘッダー
    # - RESPONSE_BODY: レスポンスボディ
    #
    # Type: string
    # ----------------------------------------------------------------------------
    type = "METHOD"

    # ----------------------------------------------------------------------------
    # method (Optional)
    # ----------------------------------------------------------------------------
    # (Optional) ドキュメント対象のHTTPメソッド。
    #
    # typeが"METHOD"、"PATH_PARAMETER"、"QUERY_PARAMETER"、"REQUEST_HEADER"、
    # "REQUEST_BODY"、"RESPONSE"、"RESPONSE_HEADER"、"RESPONSE_BODY"の場合に使用します。
    #
    # 有効な値: GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS
    # デフォルト値: "*" (すべてのメソッド)
    #
    # Type: string
    # Default: "*"
    # ----------------------------------------------------------------------------
    method = "GET"

    # ----------------------------------------------------------------------------
    # path (Optional)
    # ----------------------------------------------------------------------------
    # (Optional) ドキュメント対象のURLパス。
    #
    # typeが"RESOURCE"、"METHOD"、"PATH_PARAMETER"、"QUERY_PARAMETER"、
    # "REQUEST_HEADER"、"REQUEST_BODY"、"RESPONSE"、"RESPONSE_HEADER"、
    # "RESPONSE_BODY"の場合に使用します。
    #
    # パスは"/"で始まり、リソースパスと一致する必要があります。
    # デフォルト値: "/" (ルートリソース)
    #
    # Example:
    #   path = "/users/{userId}"
    #   path = "/products"
    #
    # Type: string
    # Default: "/"
    # ----------------------------------------------------------------------------
    path = "/example"

    # ----------------------------------------------------------------------------
    # status_code (Optional)
    # ----------------------------------------------------------------------------
    # (Optional) ドキュメント対象のHTTPステータスコード。
    #
    # typeが"RESPONSE"、"RESPONSE_HEADER"、"RESPONSE_BODY"の場合に使用します。
    #
    # デフォルト値: "*" (すべてのステータスコード)
    #
    # Example:
    #   status_code = "200"
    #   status_code = "404"
    #
    # Type: string
    # Default: "*"
    # ----------------------------------------------------------------------------
    # status_code = "200"

    # ----------------------------------------------------------------------------
    # name (Optional)
    # ----------------------------------------------------------------------------
    # (Optional) ドキュメント対象のAPIエンティティの名前。
    #
    # typeが以下の場合に使用します:
    # - AUTHORIZER: 認証の名前
    # - MODEL: モデルの名前
    # - PATH_PARAMETER: パスパラメータの名前
    # - QUERY_PARAMETER: クエリパラメータの名前
    # - REQUEST_HEADER: リクエストヘッダーの名前
    # - RESPONSE_HEADER: レスポンスヘッダーの名前
    #
    # Example:
    #   name = "userId" (for PATH_PARAMETER)
    #   name = "X-API-Key" (for REQUEST_HEADER)
    #
    # Type: string
    # Default: なし
    # ----------------------------------------------------------------------------
    # name = "userId"
  }

  # ==============================================================================
  # オプションパラメータ (Optional Parameters)
  # ==============================================================================

  # ------------------------------------------------------------------------------
  # id
  # ------------------------------------------------------------------------------
  # (Optional) Terraformリソースの一意識別子。
  #
  # 通常、この値は自動的に生成されるため、明示的に指定する必要はありません。
  # インポート時やカスタムIDを使用する特殊なケースでのみ使用します。
  #
  # Type: string
  # Computed: true (自動生成される)
  # ------------------------------------------------------------------------------
  # id = "custom-id"

  # ------------------------------------------------------------------------------
  # region
  # ------------------------------------------------------------------------------
  # (Optional) このリソースが管理されるAWSリージョン。
  #
  # 指定しない場合、プロバイダー設定で指定されたリージョンが使用されます。
  # 通常は省略し、プロバイダーレベルでリージョンを管理することを推奨します。
  #
  # AWS Regions: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Provider Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # Example:
  #   region = "us-east-1"
  #   region = "ap-northeast-1"
  #
  # Type: string
  # Computed: true (プロバイダー設定から継承される)
  # ------------------------------------------------------------------------------
  # region = "us-east-1"

}

# ================================================================================
# Computed Attributes (読み取り専用)
# ================================================================================
# 以下の属性はTerraformによって自動的に計算され、リソース作成後に参照可能です。
# これらの属性は設定ファイルに記述できません（computed only）。
#
# - documentation_part_id (string)
#   API Gatewayによって生成されるドキュメントパートの一意識別子。
#   API Gateway APIを直接操作する際に使用されます。
#
#   Example:
#     output "doc_part_id" {
#       value = aws_api_gateway_documentation_part.example.documentation_part_id
#     }
# ================================================================================

# ================================================================================
# 使用例: 様々なAPIエンティティに対するドキュメントパート
# ================================================================================

# Example 1: API全体のドキュメント
# resource "aws_api_gateway_documentation_part" "api_doc" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   properties  = jsonencode({
#     description = "This is the main API for user management"
#     info = {
#       version = "1.0.0"
#       title   = "User Management API"
#     }
#   })
#
#   location {
#     type = "API"
#   }
# }

# Example 2: リソースのドキュメント
# resource "aws_api_gateway_documentation_part" "resource_doc" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   properties  = jsonencode({
#     description = "User resource endpoint"
#   })
#
#   location {
#     type = "RESOURCE"
#     path = "/users"
#   }
# }

# Example 3: レスポンスのドキュメント
# resource "aws_api_gateway_documentation_part" "response_doc" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   properties  = jsonencode({
#     description = "Successful response with user data"
#   })
#
#   location {
#     type        = "RESPONSE"
#     method      = "GET"
#     path        = "/users/{userId}"
#     status_code = "200"
#   }
# }

# Example 4: パスパラメータのドキュメント
# resource "aws_api_gateway_documentation_part" "param_doc" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   properties  = jsonencode({
#     description = "The unique identifier of the user"
#   })
#
#   location {
#     type   = "PATH_PARAMETER"
#     method = "GET"
#     path   = "/users/{userId}"
#     name   = "userId"
#   }
# }

# ================================================================================
# 関連リソース
# ================================================================================
# - aws_api_gateway_rest_api: REST APIの定義
# - aws_api_gateway_resource: APIリソースの定義
# - aws_api_gateway_method: HTTPメソッドの定義
# - aws_api_gateway_documentation_version: ドキュメントのバージョン管理
# - aws_api_gateway_stage: APIステージ（ドキュメントバージョンと関連付け）
# ================================================================================

# ================================================================================
# AWS API Gateway Documentation Part - Annotated Template
# ================================================================================
# Generated: 2026-01-22
# Provider Version: hashicorp/aws 6.28.0
#
# NOTE: このテンプレートは生成時点の情報に基づいています。
#       最新の仕様は公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_documentation_part
# ================================================================================

# --------------------------------------------------------------------------------
# Resource: aws_api_gateway_documentation_part
# --------------------------------------------------------------------------------
# API Gatewayのドキュメントパートを管理するリソース。
# ドキュメントパートは、API Gateway REST APIの特定のエンティティ（API、リソース、メソッド、
# レスポンス、認可、モデルなど）に関連付けられたドキュメントコンテンツを定義します。
#
# ドキュメントパートは、APIのドキュメント全体を構成するコンポーネントであり、
# 複数のドキュメントパートを組み合わせてAPIドキュメントを作成します。
#
# AWS公式ドキュメント:
# - API Gateway Documentation: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-documenting-api.html
# - Documentation Parts: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-documenting-api-content-representation.html
# --------------------------------------------------------------------------------

resource "aws_api_gateway_documentation_part" "example" {

  # ==============================================================================
  # 必須パラメータ (Required Parameters)
  # ==============================================================================

  # ------------------------------------------------------------------------------
  # rest_api_id
  # ------------------------------------------------------------------------------
  # (Required) ドキュメントパートを関連付けるREST APIのID。
  #
  # この値は、aws_api_gateway_rest_apiリソースから取得するのが一般的です。
  # 1つのREST APIに対して複数のドキュメントパートを作成できます。
  #
  # Type: string
  # ------------------------------------------------------------------------------
  rest_api_id = aws_api_gateway_rest_api.example.id

  # ------------------------------------------------------------------------------
  # properties
  # ------------------------------------------------------------------------------
  # (Required) ドキュメント対象のAPIエンティティを説明するJSON文字列。
  #
  # SwaggerまたはOpenAPI仕様に準拠したキーと値のペアを含む必要があります。
  # このプロパティに記載された情報のみがエクスポートおよび公開可能です。
  #
  # 一般的に含まれるキー:
  # - description: エンティティの説明
  # - summary: エンティティの要約（OpenAPI 3.0）
  # - tags: タグのリスト
  # - externalDocs: 外部ドキュメントへのリンク
  #
  # Example:
  #   properties = jsonencode({
  #     description = "This API endpoint retrieves user information"
  #     summary     = "Get User Info"
  #   })
  #
  # Type: string (JSON encoded)
  # Default: なし
  # ------------------------------------------------------------------------------
  properties = jsonencode({
    description = "Example API documentation"
    summary     = "API documentation part example"
  })

  # ==============================================================================
  # ネストブロック: location (Required)
  # ==============================================================================
  # ドキュメントパートが対象とするAPIエンティティの場所を指定します。
  # このブロックは必須で、1つだけ指定可能です（min_items=1, max_items=1）。
  #
  # locationの組み合わせにより、ドキュメント対象のAPIエンティティが一意に特定されます。
  # ==============================================================================

  location {

    # ----------------------------------------------------------------------------
    # type (Required)
    # ----------------------------------------------------------------------------
    # (Required) ドキュメントが適用されるAPIエンティティのタイプ。
    #
    # 有効な値:
    # - API: REST API全体
    # - AUTHORIZER: カスタム認証
    # - MODEL: データモデル（リクエスト/レスポンスのスキーマ）
    # - RESOURCE: APIリソース（パス）
    # - METHOD: HTTPメソッド
    # - PATH_PARAMETER: パスパラメータ
    # - QUERY_PARAMETER: クエリパラメータ
    # - REQUEST_HEADER: リクエストヘッダー
    # - REQUEST_BODY: リクエストボディ
    # - RESPONSE: HTTPレスポンス
    # - RESPONSE_HEADER: レスポンスヘッダー
    # - RESPONSE_BODY: レスポンスボディ
    #
    # Type: string
    # ----------------------------------------------------------------------------
    type = "METHOD"

    # ----------------------------------------------------------------------------
    # method (Optional)
    # ----------------------------------------------------------------------------
    # (Optional) ドキュメント対象のHTTPメソッド。
    #
    # typeが"METHOD"、"PATH_PARAMETER"、"QUERY_PARAMETER"、"REQUEST_HEADER"、
    # "REQUEST_BODY"、"RESPONSE"、"RESPONSE_HEADER"、"RESPONSE_BODY"の場合に使用します。
    #
    # 有効な値: GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS
    # デフォルト値: "*" (すべてのメソッド)
    #
    # Type: string
    # Default: "*"
    # ----------------------------------------------------------------------------
    method = "GET"

    # ----------------------------------------------------------------------------
    # path (Optional)
    # ----------------------------------------------------------------------------
    # (Optional) ドキュメント対象のURLパス。
    #
    # typeが"RESOURCE"、"METHOD"、"PATH_PARAMETER"、"QUERY_PARAMETER"、
    # "REQUEST_HEADER"、"REQUEST_BODY"、"RESPONSE"、"RESPONSE_HEADER"、
    # "RESPONSE_BODY"の場合に使用します。
    #
    # パスは"/"で始まり、リソースパスと一致する必要があります。
    # デフォルト値: "/" (ルートリソース)
    #
    # Example:
    #   path = "/users/{userId}"
    #   path = "/products"
    #
    # Type: string
    # Default: "/"
    # ----------------------------------------------------------------------------
    path = "/example"

    # ----------------------------------------------------------------------------
    # status_code (Optional)
    # ----------------------------------------------------------------------------
    # (Optional) ドキュメント対象のHTTPステータスコード。
    #
    # typeが"RESPONSE"、"RESPONSE_HEADER"、"RESPONSE_BODY"の場合に使用します。
    #
    # デフォルト値: "*" (すべてのステータスコード)
    #
    # Example:
    #   status_code = "200"
    #   status_code = "404"
    #
    # Type: string
    # Default: "*"
    # ----------------------------------------------------------------------------
    # status_code = "200"

    # ----------------------------------------------------------------------------
    # name (Optional)
    # ----------------------------------------------------------------------------
    # (Optional) ドキュメント対象のAPIエンティティの名前。
    #
    # typeが以下の場合に使用します:
    # - AUTHORIZER: 認証の名前
    # - MODEL: モデルの名前
    # - PATH_PARAMETER: パスパラメータの名前
    # - QUERY_PARAMETER: クエリパラメータの名前
    # - REQUEST_HEADER: リクエストヘッダーの名前
    # - RESPONSE_HEADER: レスポンスヘッダーの名前
    #
    # Example:
    #   name = "userId" (for PATH_PARAMETER)
    #   name = "X-API-Key" (for REQUEST_HEADER)
    #
    # Type: string
    # Default: なし
    # ----------------------------------------------------------------------------
    # name = "userId"
  }

  # ==============================================================================
  # オプションパラメータ (Optional Parameters)
  # ==============================================================================

  # ------------------------------------------------------------------------------
  # id
  # ------------------------------------------------------------------------------
  # (Optional) Terraformリソースの一意識別子。
  #
  # 通常、この値は自動的に生成されるため、明示的に指定する必要はありません。
  # インポート時やカスタムIDを使用する特殊なケースでのみ使用します。
  #
  # Type: string
  # Computed: true (自動生成される)
  # ------------------------------------------------------------------------------
  # id = "custom-id"

  # ------------------------------------------------------------------------------
  # region
  # ------------------------------------------------------------------------------
  # (Optional) このリソースが管理されるAWSリージョン。
  #
  # 指定しない場合、プロバイダー設定で指定されたリージョンが使用されます。
  # 通常は省略し、プロバイダーレベルでリージョンを管理することを推奨します。
  #
  # AWS Regions: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Provider Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # Example:
  #   region = "us-east-1"
  #   region = "ap-northeast-1"
  #
  # Type: string
  # Computed: true (プロバイダー設定から継承される)
  # ------------------------------------------------------------------------------
  # region = "us-east-1"

}

# ================================================================================
# Computed Attributes (読み取り専用)
# ================================================================================
# 以下の属性はTerraformによって自動的に計算され、リソース作成後に参照可能です。
# これらの属性は設定ファイルに記述できません（computed only）。
#
# - documentation_part_id (string)
#   API Gatewayによって生成されるドキュメントパートの一意識別子。
#   API Gateway APIを直接操作する際に使用されます。
#
#   Example:
#     output "doc_part_id" {
#       value = aws_api_gateway_documentation_part.example.documentation_part_id
#     }
# ================================================================================

# ================================================================================
# 使用例: 様々なAPIエンティティに対するドキュメントパート
# ================================================================================

# Example 1: API全体のドキュメント
# resource "aws_api_gateway_documentation_part" "api_doc" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   properties  = jsonencode({
#     description = "This is the main API for user management"
#     info = {
#       version = "1.0.0"
#       title   = "User Management API"
#     }
#   })
#
#   location {
#     type = "API"
#   }
# }

# Example 2: リソースのドキュメント
# resource "aws_api_gateway_documentation_part" "resource_doc" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   properties  = jsonencode({
#     description = "User resource endpoint"
#   })
#
#   location {
#     type = "RESOURCE"
#     path = "/users"
#   }
# }

# Example 3: レスポンスのドキュメント
# resource "aws_api_gateway_documentation_part" "response_doc" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   properties  = jsonencode({
#     description = "Successful response with user data"
#   })
#
#   location {
#     type        = "RESPONSE"
#     method      = "GET"
#     path        = "/users/{userId}"
#     status_code = "200"
#   }
# }

# Example 4: パスパラメータのドキュメント
# resource "aws_api_gateway_documentation_part" "param_doc" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   properties  = jsonencode({
#     description = "The unique identifier of the user"
#   })
#
#   location {
#     type   = "PATH_PARAMETER"
#     method = "GET"
#     path   = "/users/{userId}"
#     name   = "userId"
#   }
# }

# ================================================================================
# 関連リソース
# ================================================================================
# - aws_api_gateway_rest_api: REST APIの定義
# - aws_api_gateway_resource: APIリソースの定義
# - aws_api_gateway_method: HTTPメソッドの定義
# - aws_api_gateway_documentation_version: ドキュメントのバージョン管理
# - aws_api_gateway_stage: APIステージ（ドキュメントバージョンと関連付け）
# ================================================================================

