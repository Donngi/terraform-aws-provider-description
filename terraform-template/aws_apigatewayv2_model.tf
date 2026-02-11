#---------------------------------------------------------------
# AWS API Gateway V2 Model
#---------------------------------------------------------------
#
# Amazon API Gateway Version 2のモデルをプロビジョニングするリソースです。
# モデルは、リクエストまたはレスポンスペイロードのデータ構造（スキーマ）を
# 定義するために使用されます。HTTP APIおよびWebSocket APIで使用可能です。
#
# AWS公式ドキュメント:
#   - API Gateway Models and Mappings: https://docs.aws.amazon.com/apigateway/latest/developerguide/models-mappings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_model
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apigatewayv2_model" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: モデルを関連付けるAPI GatewayのAPI IDを指定します。
  # 設定可能な値: 有効なAPI Gateway V2のAPI ID
  api_id = aws_apigatewayv2_api.example.id

  # name (Required)
  # 設定内容: モデルの名前を指定します。
  # 設定可能な値: 1-128文字の英数字
  # 注意: 英数字のみ使用可能
  name = "ExampleModel"

  # content_type (Required)
  # 設定内容: モデルのコンテンツタイプを指定します。
  # 設定可能な値: 1-256文字のMIMEタイプ文字列
  #   - "application/json": JSONデータ（最も一般的）
  #   - "application/xml": XMLデータ
  #   - その他の有効なMIMEタイプ
  content_type = "application/json"

  # schema (Required)
  # 設定内容: モデルのスキーマを指定します。
  # 設定可能な値: JSON Schema Draft 4形式のスキーマ文字列
  # 制限: 32768文字以下
  # 関連機能: JSON Schema Draft 4
  #   API GatewayはJSON Schema Draft 4仕様に基づくスキーマをサポートしています。
  #   - https://tools.ietf.org/html/draft-zyp-json-schema-04
  schema = jsonencode({
    "$schema" = "http://json-schema.org/draft-04/schema#"
    title     = "ExampleModel"
    type      = "object"

    properties = {
      id = {
        type = "string"
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
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: モデルの説明を指定します。
  # 設定可能な値: 1-128文字の文字列
  # 省略時: 説明なし
  description = "Example model for user data"

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
# - id: モデルの識別子
#---------------------------------------------------------------
