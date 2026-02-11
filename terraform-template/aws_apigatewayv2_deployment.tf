#---------------------------------------------------------------
# AWS API Gateway V2 Deployment
#---------------------------------------------------------------
#
# Amazon API Gateway Version 2のデプロイメントをプロビジョニングするリソースです。
# デプロイメントは、APIの設定をスナップショットとして保存し、ステージにデプロイ
# するためのメカニズムです。HTTP APIおよびWebSocket APIで使用されます。
#
# AWS公式ドキュメント:
#   - API Gateway Developer Guide: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api.html
#   - HTTP API デプロイメント: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_deployment
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apigatewayv2_deployment" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: デプロイメントを作成するAPIの識別子を指定します。
  # 設定可能な値: 有効なAPI Gateway V2 APIのID
  # 注意: デプロイメントを作成するには、少なくとも1つのaws_apigatewayv2_routeリソースが
  #       そのAPIに関連付けられている必要があります。
  api_id = aws_apigatewayv2_api.example.id

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: デプロイメントリソースの説明を指定します。
  # 設定可能な値: 1024文字以下の文字列
  # 省略時: null（説明なし）
  description = "Example deployment"

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
  # トリガー設定
  #-------------------------------------------------------------

  # triggers (Optional)
  # 設定内容: 変更時に再デプロイをトリガーする任意のキーと値のマップを指定します。
  # 設定可能な値: 任意のキーと値のペアのマップ
  # 省略時: null
  # 用途: 関連リソース（インテグレーションやルート）の変更を検知して自動再デプロイを行う
  # 注意: これらのキー/値を変更せずに再デプロイを強制するには、`terraform taint`コマンドを使用
  # 参考: https://www.terraform.io/docs/commands/taint.html
  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_integration.example),
      jsonencode(aws_apigatewayv2_route.example),
    ])))
  }

  #-------------------------------------------------------------
  # ライフサイクル設定（推奨）
  #-------------------------------------------------------------
  # 再デプロイを適切に順序付けるため、create_before_destroyを有効にすることを推奨
  lifecycle {
    create_before_destroy = true
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: デプロイメントの識別子
#
# - auto_deployed: デプロイメントが自動的にリリースされたかどうかを示すブール値
#                  ステージのauto_deploy設定が有効な場合にtrueとなります。
#---------------------------------------------------------------
