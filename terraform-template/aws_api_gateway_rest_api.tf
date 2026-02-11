#---------------------------------------------------------------
# AWS API Gateway REST API
#---------------------------------------------------------------
#
# Amazon API Gateway REST APIをプロビジョニングするリソースです。
# REST APIは、OpenAPI仕様をbody引数でインポートして設定するか、
# 他のTerraformリソース（aws_api_gateway_resource、aws_api_gateway_method、
# aws_api_gateway_integration等）を使用して設定できます。
#
# AWS公式ドキュメント:
#   - API Gateway概要: https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html
#   - REST APIの作成: https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-create-api.html
#   - OpenAPIによるインポート: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_rest_api" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: REST APIの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: OpenAPI仕様をbody引数でインポートする場合、info.titleフィールドに対応します。
  #       引数値がOpenAPIの値と異なる場合、引数値がOpenAPIの値を上書きします。
  name = "my-rest-api"

  # description (Optional)
  # 設定内容: REST APIの説明を指定します。
  # 設定可能な値: 文字列
  # 注意: OpenAPI仕様をbody引数でインポートする場合、info.descriptionフィールドに対応します。
  #       引数値がOpenAPIの値と異なる場合、引数値がOpenAPIの値を上書きします。
  description = "My REST API description"

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
  # OpenAPI仕様設定
  #-------------------------------------------------------------

  # body (Optional)
  # 設定内容: REST APIの一部として作成するルートと統合を定義するOpenAPI仕様を指定します。
  # 設定可能な値: JSON形式のOpenAPI仕様文字列
  # 関連機能: API Gateway OpenAPIインポート
  #   この設定と更新により、このリソースおよび他のリソース更新でオーバーライドされた値を除き、
  #   すべてのREST API設定が置き換えられます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html
  # 注意: bodyを使用する場合、aws_api_gateway_deploymentの作成前に適用される
  #       他のリソース更新は、既存のメソッド、リソース、統合を削除する可能性があります。
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "example"
      version = "1.0"
    }
    paths = {
      "/example" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://example.com"
          }
        }
      }
    }
  })

  # parameters (Optional)
  # 設定内容: body引数で仕様をインポートする際のカスタマイズのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  #   - ignore = "documentation": DocumentationPartsをインポートから除外
  #   - basepath = "prepend" | "split" | "ignore": ベースパスの処理方法を指定
  # 関連機能: API Gateway インポートカスタマイズ
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html
  parameters = {
    ignore = "documentation"
  }

  # put_rest_api_mode (Optional)
  # 設定内容: body引数でOpenAPI仕様をインポートする際のPutRestApi操作のモードを指定します。
  # 設定可能な値:
  #   - "overwrite" (デフォルト): 既存のAPI設定を完全に置き換えます
  #   - "merge": 既存のAPI設定とマージします
  # 注意: 未指定時はoverwriteがデフォルト（後方互換性のため）。
  #       PRIVATEエンドポイントを使用する場合は、エンドポイントとRoute53レコードの
  #       削除を防ぐためにmergeを推奨します。
  put_rest_api_mode = "merge"

  # fail_on_warnings (Optional)
  # 設定内容: API Gatewayがリソースを作成・更新する際に警告が発生した場合にエラーを返すかを指定します。
  # 設定可能な値:
  #   - true: 警告時にエラーを返す
  #   - false (デフォルト): 警告時にエラーを返さない
  fail_on_warnings = false

  #-------------------------------------------------------------
  # APIキーソース設定
  #-------------------------------------------------------------

  # api_key_source (Optional)
  # 設定内容: リクエストのAPIキーのソースを指定します。
  # 設定可能な値:
  #   - "HEADER" (デフォルト): x-api-keyヘッダーからAPIキーを取得
  #   - "AUTHORIZER": Lambda AuthorizerからAPIキーを取得
  # 関連機能: API Gateway APIキー
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-api-key-source.html
  # 注意: OpenAPI仕様をbody引数でインポートする場合、
  #       x-amazon-apigateway-api-key-source拡張に対応します。
  api_key_source = "HEADER"

  #-------------------------------------------------------------
  # バイナリメディアタイプ設定
  #-------------------------------------------------------------

  # binary_media_types (Optional)
  # 設定内容: REST APIがサポートするバイナリメディアタイプのリストを指定します。
  # 設定可能な値: MIMEタイプの文字列リスト（例: "image/png", "application/octet-stream"）
  # 省略時: REST APIはUTF-8エンコードされたテキストペイロードのみをサポート
  # 関連機能: API Gateway バイナリサポート
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-payload-encodings.html
  # 注意: OpenAPI仕様をbody引数でインポートする場合、
  #       x-amazon-apigateway-binary-media-types拡張に対応します。
  binary_media_types = [
    "image/png",
    "application/octet-stream"
  ]

  #-------------------------------------------------------------
  # 圧縮設定
  #-------------------------------------------------------------

  # minimum_compression_size (Optional)
  # 設定内容: REST APIの最小レスポンス圧縮サイズを指定します。
  # 設定可能な値: -1から10485760（10MB）の間の整数値を含む文字列
  #   - "-1": 既存の圧縮設定を無効化
  #   - "0"以上: 指定したサイズ（バイト）以上のレスポンスを圧縮
  # 省略時: 圧縮は無効（新規リソースでは省略推奨、-1は既存設定の無効化用）
  # 関連機能: API Gateway コンテンツ圧縮
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-gzip-compression-decompression.html
  # 注意: OpenAPI仕様をbody引数でインポートする場合、
  #       x-amazon-apigateway-minimum-compression-size拡張に対応します。
  minimum_compression_size = "10240"

  #-------------------------------------------------------------
  # エンドポイント設定
  #-------------------------------------------------------------

  # disable_execute_api_endpoint (Optional)
  # 設定内容: デフォルトのexecute-apiエンドポイントを使用してAPIを呼び出せるかを指定します。
  # 設定可能な値:
  #   - true: デフォルトエンドポイントを無効化（カスタムドメインの使用を強制）
  #   - false (デフォルト): デフォルトエンドポイントを有効化
  # 関連機能: API Gateway カスタムドメイン
  #   クライアントはデフォルトでhttps://{api_id}.execute-api.{region}.amazonaws.comを使用可能。
  #   カスタムドメインの使用を強制する場合はtrueに設定。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-custom-domains.html
  # 注意: OpenAPI仕様をbody引数でインポートする場合、
  #       x-amazon-apigateway-endpoint-configurationのdisableExecuteApiEndpointプロパティに対応します。
  disable_execute_api_endpoint = false

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Optional)
  # 設定内容: API Gatewayへのアクセスを制御するJSON形式のポリシードキュメントを指定します。
  # 設定可能な値: IAMポリシードキュメント（JSON形式）
  # 関連機能: API Gateway リソースポリシー
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-resource-policies.html
  # 注意: aws_api_gateway_rest_api_policyリソースの使用を推奨します。
  #       OpenAPI仕様をbody引数でインポートする場合、x-amazon-apigateway-policy拡張に対応します。
  policy = null

  #-------------------------------------------------------------
  # エンドポイント構成 (endpoint_configuration)
  #-------------------------------------------------------------

  # endpoint_configuration (Optional)
  # 設定内容: APIエンドポイントタイプを含むエンドポイント構成を定義します。
  endpoint_configuration {
    # types (Required)
    # 設定内容: エンドポイントタイプのリストを指定します。
    # 設定可能な値:
    #   - "EDGE": エッジ最適化API（CloudFront経由でグローバルにデプロイ）
    #   - "REGIONAL": リージョンAPI（特定のリージョン内でのみアクセス可能）
    #   - "PRIVATE": プライベートAPI（VPCエンドポイント経由でのみアクセス可能）
    # 省略時: EDGE
    # 注意: 現在このリソースは単一の値のみをサポートしています。
    #       PRIVATEに設定する場合はput_rest_api_mode = "merge"を推奨します。
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/create-regional-api.html
    types = ["REGIONAL"]

    # ip_address_type (Optional)
    # 設定内容: APIを呼び出すことができるIPアドレスタイプを指定します。
    # 設定可能な値:
    #   - "ipv4": IPv4アドレスのみがAPIを呼び出せる
    #   - "dualstack": IPv4とIPv6の両方のアドレスがAPIを呼び出せる
    # 注意: PRIVATEエンドポイントタイプの場合、dualstackのみがサポートされます。
    ip_address_type = "ipv4"

    # vpc_endpoint_ids (Optional)
    # 設定内容: VPCエンドポイント識別子のセットを指定します。
    # 設定可能な値: VPCエンドポイントIDの文字列セット
    # 注意: PRIVATEエンドポイントタイプでのみサポートされます。
    #       OpenAPI仕様をbody引数でインポートする場合、
    #       x-amazon-apigateway-endpoint-configurationのvpcEndpointIdsプロパティに対応します。
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-private-apis.html
    vpc_endpoint_ids = null
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
    Name        = "my-rest-api"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: REST APIのAmazon Resource Name (ARN)
#
# - created_date: REST APIの作成日
#
# - execution_arn: Lambda関数の呼び出し権限設定時に使用する実行ARNの一部
#        例: arn:aws:execute-api:eu-west-2:123456789012:z4675bid1j
#        許可されたステージ、メソッド、リソースパスと連結して使用します。
#
# - id: REST APIのID
#
# - root_resource_id: REST APIのルートリソースのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
