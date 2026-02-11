#---------------------------------------------------------------
# AWS API Gateway REST API Put
#---------------------------------------------------------------
#
# 既存のAPI Gateway REST APIにOpenAPI定義をインポート（上書き）するリソースです。
# PUT操作を使用してAPI定義全体を置き換えるため、既存のAPI構成は
# 新しい定義で完全に上書きされます。
#
# AWS公式ドキュメント:
#   - API Gateway REST API: https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-create-api.html
#   - OpenAPIからのREST APIのインポート: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api_put
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_rest_api_put" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # rest_api_id (Required)
  # 設定内容: 更新対象のREST APIの識別子を指定します。
  # 設定可能な値: 有効なaws_api_gateway_rest_apiリソースのID
  # 注意: このAPIの既存の構成は、bodyで指定した定義で上書きされます。
  rest_api_id = aws_api_gateway_rest_api.example.id

  # body (Required)
  # 設定内容: 外部API定義を含むPUTリクエストボディを指定します。
  # 設定可能な値: OpenAPI定義（JSON/YAML形式）の文字列
  # 制限: API定義ファイルの最大サイズは6MB
  # 関連機能: API Gateway OpenAPIインポート
  #   OpenAPI 2.0（Swagger）またはOpenAPI 3.0形式の定義をサポート。
  #   Amazon API Gateway拡張機能を使用してAWS固有の統合設定が可能。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "Example API"
      version = "v1"
    }
    paths = {
      "/example" = {
        get = {
          responses = {
            "200" = {
              description = "OK"
            }
          }
          x-amazon-apigateway-integration = {
            httpMethod = "GET"
            type       = "HTTP"
            responses = {
              default = {
                statusCode = "200"
              }
            }
            uri = "https://api.example.com/"
          }
        }
      }
    }
  })

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # fail_on_warnings (Optional)
  # 設定内容: 警告が発生した場合にAPIの更新をロールバックするかを指定します。
  # 設定可能な値:
  #   - true: 警告時にロールバック（厳格なインポート）
  #   - false (デフォルト): 警告があっても更新を継続
  # 用途: 本番環境では true を推奨。インポート時の問題を早期に検出できます。
  fail_on_warnings = true

  # parameters (Optional)
  # 設定内容: body引数の仕様をインポートするためのカスタマイズマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  #   - basepath: ベースパスの処理方法を指定
  #     - "prepend": APIのベースパスに指定したパスを前置
  #     - "split": ベースパスを最初のパスセグメントで分割
  #     - "ignore": ベースパスを無視
  #   - ignore: 特定の要素を無視（例: "documentation"でDocumentationPartsを除外）
  # 関連機能: API Gateway インポートパラメータ
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html
  parameters = {
    basepath = "ignore"
  }

  # triggers (Optional)
  # 設定内容: 再デプロイをトリガーするための任意のキーと値のマップを指定します。
  # 設定可能な値: 文字列のキーと値のペアのマップ
  # 用途: API定義ファイルの変更を検出して再デプロイをトリガーするために使用
  # ヒント:
  #   - ファイルのハッシュ値を使用することで、定義変更時に自動的に再デプロイ可能
  #   - これらのキー/値を変更せずに再デプロイを強制する場合は、
  #     terraform planまたはterraform applyで-replaceオプションを使用
  triggers = {
    redeployment = sha1(jsonencode({
      # API定義が変更されたときに再デプロイをトリガー
      body = self.body
    }))
  }

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
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: デフォルトのタイムアウト値を使用
    create = "5m"
  }
}

#---------------------------------------------------------------
# 複数バージョンのAPIを段階的にデプロイする場合:
#
# resource "aws_api_gateway_rest_api_put" "v1" {
#   body             = file("v1.yaml")
#   fail_on_warnings = true
#   rest_api_id      = aws_api_gateway_rest_api.example.id
#
#   triggers = {
#     redeployment = sha1(file("v1.yaml"))
#   }
#
#   lifecycle {
#     create_before_destroy = true
#   }
# }
#
# resource "aws_api_gateway_deployment" "v1" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#
#   triggers = {
#     redeployment = aws_api_gateway_rest_api_put.v1.triggers.redeployment
#   }
#
#   lifecycle {
#     create_before_destroy = true
#   }
# }
#
# resource "aws_api_gateway_stage" "v1" {
#   stage_name    = "v1"
#   rest_api_id   = aws_api_gateway_rest_api.example.id
#   deployment_id = aws_api_gateway_deployment.v1.id
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
# - bodyに指定したOpenAPI定義の info.title フィールドは、関連する
#   aws_api_gateway_rest_api リソースの name を更新します。
#   インポートした title が設定済みの name と異なる場合、
#   Terraformは差分を報告します。
#
# - PUT操作は既存のAPI構成を完全に上書きします。
#   部分的な更新には aws_api_gateway_rest_api_patch リソースを使用してください。
#---------------------------------------------------------------
