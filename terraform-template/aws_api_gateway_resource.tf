#---------------------------------------------------------------
# AWS API Gateway Resource
#---------------------------------------------------------------
#
# Amazon API Gateway REST APIのリソースをプロビジョニングするリソースです。
# リソースはAPI内のパス（URLエンドポイント）を表し、HTTPメソッド（GET、POST等）と
# 統合先（Lambda関数、HTTPエンドポイント等）を関連付けるための論理的なエンティティです。
# 階層的な構造を持ち、parent_idで親リソースを指定することでネストしたパスを構築できます。
#
# AWS公式ドキュメント:
#   - API Gateway REST APIs: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-rest-api.html
#   - API Gateway use cases: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-overview-developer-experience.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_resource" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # rest_api_id (Required)
  # 設定内容: リソースを作成するREST APIのIDを指定します。
  # 設定可能な値: 有効なAPI Gateway REST APIのID
  # 取得方法: aws_api_gateway_rest_apiリソースの.id属性から取得
  rest_api_id = aws_api_gateway_rest_api.example.id

  # parent_id (Required)
  # 設定内容: 親APIリソースのIDを指定します。
  # 設定可能な値: 有効なAPI GatewayリソースID
  # 取得方法:
  #   - ルート直下に配置する場合: aws_api_gateway_rest_api.example.root_resource_id
  #   - 他のリソースの下に配置する場合: 親aws_api_gateway_resourceの.id属性
  # 用途: リソースの階層構造を定義。例: /users/{userId}/ordersのような
  #       ネストしたパスを構築する際に使用
  parent_id = aws_api_gateway_rest_api.example.root_resource_id

  # path_part (Required)
  # 設定内容: このAPIリソースのパスの最後のセグメントを指定します。
  # 設定可能な値:
  #   - 静的パス: "users", "orders", "items" などの固定文字列
  #   - パスパラメータ: "{userId}", "{orderId}" などの中括弧で囲んだ変数
  #   - グリーディパスパラメータ: "{proxy+}" (任意のサブパスをキャプチャ)
  # 例:
  #   - path_part = "users" → /users
  #   - path_part = "{userId}" → /users/{userId}
  #   - path_part = "{proxy+}" → /api/{proxy+} (プロキシ統合用)
  path_part = "mydemoresource"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"
}

#---------------------------------------------------------------
# 関連リソース例
#---------------------------------------------------------------
# API Gateway Resourceを使用する際は、通常以下のリソースと組み合わせます:
#
# resource "aws_api_gateway_rest_api" "example" {
#   name        = "MyDemoAPI"
#   description = "This is my API for demonstration purposes"
# }
#
# # ネストしたリソースの例
# resource "aws_api_gateway_resource" "users" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   parent_id   = aws_api_gateway_rest_api.example.root_resource_id
#   path_part   = "users"
# }
#
# resource "aws_api_gateway_resource" "user" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   parent_id   = aws_api_gateway_resource.users.id
#   path_part   = "{userId}"
# }
# → これにより /users/{userId} というパスが作成されます
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子
#
# - path: このAPIリソースの完全なパス（すべての親パスを含む）
#         例: /users/{userId}/orders
#
#---------------------------------------------------------------
