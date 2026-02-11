#---------------------------------------------------------------
# AWS API Gateway Model
#---------------------------------------------------------------
#
# Amazon API Gateway REST APIのモデルをプロビジョニングするリソースです。
# モデルは、メソッドのリクエストまたはレスポンスペイロードのデータ構造を定義します。
# JSON Schemaドラフト4形式でスキーマを定義し、リクエストの検証やSDK生成に使用されます。
#
# AWS公式ドキュメント:
#   - API Gateway Model API: https://docs.aws.amazon.com/apigateway/latest/api/API_Model.html
#   - API Gatewayの概念: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-basic-concept.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_model
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_model" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # rest_api_id (Required)
  # 設定内容: モデルを関連付けるREST APIのIDを指定します。
  # 設定可能な値: 有効なAPI Gateway REST APIのID
  # 注意: aws_api_gateway_rest_apiリソースのidを参照することが一般的
  rest_api_id = aws_api_gateway_rest_api.example.id

  # name (Required)
  # 設定内容: モデルの名前を指定します。
  # 設定可能な値: 英数字のみの文字列（アルファベットと数字のみ）
  # 注意: スペースや特殊文字は使用不可
  name = "UserModel"

  # content_type (Required)
  # 設定内容: モデルのコンテンツタイプを指定します。
  # 設定可能な値: MIMEタイプ（例: "application/json", "application/xml"）
  # 注意: 通常は "application/json" を使用
  content_type = "application/json"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: モデルの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: モデルの目的や使用方法を記述
  description = "User data model for API request/response"

  # schema (Optional)
  # 設定内容: モデルのスキーマをJSON形式で指定します。
  # 設定可能な値: JSON Schemaドラフト4形式のJSON文字列
  # 関連機能: API Gatewayリクエスト検証
  #   スキーマを定義することで、リクエストボディの検証が可能になります。
  #   また、SDK生成時にデータ構造として使用されます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-basic-concept.html
  # 注意:
  #   - application/jsonモデルの場合、JSON Schemaドラフト4を使用
  #   - プロパティの説明に "\*/" を含めないこと
  #     （Java/JavaScriptなどでコメント終了マーカーと解釈され、SDK生成に失敗する可能性）
  schema = jsonencode({
    "$schema" = "http://json-schema.org/draft-04/schema#"
    title     = "UserModel"
    type      = "object"
    properties = {
      id = {
        type = "integer"
      }
      name = {
        type = "string"
      }
      email = {
        type   = "string"
        format = "email"
      }
    }
    required = ["id", "name"]
  })

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
# - id: モデルリソースの識別子
#---------------------------------------------------------------
