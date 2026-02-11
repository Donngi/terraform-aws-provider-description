#---------------------------------------------------------------
# AWS API Gateway Documentation Version
#---------------------------------------------------------------
#
# Amazon API GatewayのREST APIドキュメントバージョンを管理するリソースです。
# ドキュメントバージョンは、DocumentationPartsコレクションのスナップショットで、
# バージョン識別子でタグ付けされます。ドキュメントの公開には、ドキュメントバージョンを
# 作成し、APIステージに関連付け、ステージ固有のバージョンを外部OpenAPIファイルに
# エクスポートする手順が含まれます。
#
# AWS公式ドキュメント:
#   - REST APIのドキュメント: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-documenting-api.html
#   - ドキュメントの表現: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-documenting-api-content-representation.html
#   - CreateDocumentationVersion API: https://docs.aws.amazon.com/apigateway/latest/api/API_CreateDocumentationVersion.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_documentation_version
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_documentation_version" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # rest_api_id (Required)
  # 設定内容: 関連付けるREST APIのIDを指定します。
  # 設定可能な値: 有効なAPI Gateway REST APIのID
  # 注意: aws_api_gateway_rest_apiリソースのidを参照することを推奨
  rest_api_id = aws_api_gateway_rest_api.example.id

  # version (Required)
  # 設定内容: APIドキュメントスナップショットのバージョン識別子を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: ドキュメントの特定バージョンを識別し、APIステージへの関連付けや
  #       OpenAPIファイルへのエクスポートに使用されます。
  version = "1.0.0"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: APIドキュメントバージョンの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: バージョンの変更内容や目的を記録するために使用
  description = "Initial version of API documentation"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 依存関係
  #-------------------------------------------------------------
  # 注意: ドキュメントバージョンを作成する前に、少なくとも1つの
  # aws_api_gateway_documentation_partが存在している必要があります。
  # depends_onを使用して明示的に依存関係を指定することを推奨します。
  #
  # depends_on = [aws_api_gateway_documentation_part.example]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子
#---------------------------------------------------------------
