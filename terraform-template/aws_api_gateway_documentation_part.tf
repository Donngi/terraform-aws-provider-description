#---------------------------------------
# API Gateway Documentation Part
#---------------------------------------
# API GatewayのAPIエンティティに対するドキュメントパーツを作成・管理します。
# APIのメソッド、リソース、モデルなどに対してSwagger準拠のドキュメントを追加できます。
#
# 主な用途:
# - API GatewayのAPIドキュメント自動生成機能の活用
# - OpenAPI/Swagger仕様に準拠したAPIドキュメントの作成
# - 各エンドポイントの説明やパラメータ情報の追加
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/api_gateway_documentation_part
# Generated: 2026-02-11
# NOTE: このファイルはAPI Gateway Documentation Partリソースのテンプレートです

resource "aws_api_gateway_documentation_part" "example" {
  #-------
  # 基本設定
  #-------
  # 設定内容: ドキュメントパーツを作成するRest APIのID
  # 設定可能な値: aws_api_gateway_rest_apiリソースのID
  rest_api_id = aws_api_gateway_rest_api.example.id

  # 設定内容: APIエンティティのドキュメントコンテンツ
  # 設定可能な値: Swagger準拠のキー・バリューペアをJSON文字列でエンコードしたもの
  # 補足: 例: "{\"description\":\"API説明\"}" の形式で記述
  properties = "{\"description\":\"Example API description\"}"

  #-------
  # ドキュメント対象の指定
  #-------
  location {
    # 設定内容: ドキュメントを適用するAPIエンティティのタイプ
    # 設定可能な値: API, AUTHORIZER, MODEL, RESOURCE, METHOD, PATH_PARAMETER, QUERY_PARAMETER, REQUEST_HEADER, REQUEST_BODY, RESPONSE, RESPONSE_HEADER, RESPONSE_BODY
    # 補足: APIエンティティの種類によって必要な追加パラメータが異なる
    type = "METHOD"

    # 設定内容: 対象のHTTPメソッド
    # 設定可能な値: GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS, ANY, *（すべてのメソッド）
    # 省略時: *（すべてのメソッド）
    method = "GET"

    # 設定内容: 対象のURLパス
    # 設定可能な値: APIのリソースパス（例: /users, /items/{id}）
    # 省略時: /（ルートリソース）
    path = "/example"

    # 設定内容: 対象APIエンティティの名前
    # 設定可能な値: エンティティタイプに応じた名前（例: モデル名、パラメータ名）
    # 省略時: なし（typeがAPI、RESOURCE、METHOD等の場合は不要）
    # name = "example_parameter"

    # 設定内容: 対象のHTTPステータスコード
    # 設定可能な値: 200, 404, 500等のHTTPステータスコード、*（すべてのステータス）
    # 省略時: *（すべてのステータスコード）
    # 補足: typeがRESPONSEの場合に使用
    # status_code = "200"
  }

  #-------
  # リージョン設定
  #-------
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（us-east-1, ap-northeast-1等）
  # 省略時: プロバイダー設定のリージョン
  region = "ap-northeast-1"
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースから参照できる属性値:
#
# - documentation_part_id
#   説明: API Gatewayによって生成されたドキュメントパーツの一意識別子
#   型: string
#
# - id
#   説明: ドキュメントパーツの一意ID
#   型: string
#   形式: <rest_api_id>/<documentation_part_id>
