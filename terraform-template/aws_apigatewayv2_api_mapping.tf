#---------------------------------------------------------------
# AWS API Gateway V2 API Mapping
#---------------------------------------------------------------
#
# Amazon API Gateway Version 2のAPIマッピングをプロビジョニングするリソースです。
# APIマッピングは、カスタムドメイン名とAPI・ステージを関連付け、
# 特定のパス（api_mapping_key）経由でAPIにアクセスできるようにします。
#
# AWS公式ドキュメント:
#   - カスタムドメイン名の設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-custom-domains.html
#   - HTTP APIマッピング: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-mappings.html
#   - WebSocket APIマッピング: https://docs.aws.amazon.com/apigateway/latest/developerguide/websocket-api-mappings.html
#   - REST APIマッピング: https://docs.aws.amazon.com/apigateway/latest/developerguide/rest-api-mappings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api_mapping
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apigatewayv2_api_mapping" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: マッピング対象のAPI識別子を指定します。
  # 設定可能な値: aws_apigatewayv2_api リソースのID
  api_id = aws_apigatewayv2_api.example.id

  # domain_name (Required)
  # 設定内容: マッピング先のドメイン名を指定します。
  # 設定可能な値: aws_apigatewayv2_domain_name リソースのID（ドメイン名文字列）
  # 関連機能: API Gateway カスタムドメイン名
  #   カスタムドメイン名を使用することで、ユーザーフレンドリーなURLを
  #   API Gatewayエンドポイントに割り当てることができます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-custom-domains.html
  domain_name = aws_apigatewayv2_domain_name.example.id

  # stage (Required)
  # 設定内容: マッピング対象のAPIステージを指定します。
  # 設定可能な値: aws_apigatewayv2_stage リソースのID（ステージ名）
  # 関連機能: API Gateway ステージ
  #   ステージはAPIのデプロイメントを表し、特定バージョンのAPIに
  #   アクセスするための名前付きリファレンスです。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-stages.html
  stage = aws_apigatewayv2_stage.example.id

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # api_mapping_key (Optional)
  # 設定内容: APIマッピングキー（URLのベースパス）を指定します。
  # 設定可能な値: 文字列（例: "v1", "api/v1"）
  # 省略時: ドメイン名のルートパスにマッピングされます
  # 関連機能: API Gateway APIマッピング
  #   複数のAPIを同じカスタムドメイン名の異なるパスにマッピングできます。
  #   例: api.example.com/v1 → API1, api.example.com/v2 → API2
  #   - REST API: https://docs.aws.amazon.com/apigateway/latest/developerguide/rest-api-mappings.html
  #   - HTTP API: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-mappings.html
  #   - WebSocket API: https://docs.aws.amazon.com/apigateway/latest/developerguide/websocket-api-mappings.html
  api_mapping_key = "v1"

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
# - id: APIマッピングの識別子
#---------------------------------------------------------------
