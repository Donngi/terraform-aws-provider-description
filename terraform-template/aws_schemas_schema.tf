#---------------------------------------------------------------
# Amazon EventBridge Schema
#---------------------------------------------------------------
#
# Amazon EventBridgeのスキーマレジストリ内にスキーマをプロビジョニングするリソースです。
# スキーマはEventBridgeに送信されるイベントの構造を定義します。
# OpenAPI 3.0仕様またはJSONSchema Draft4形式で記述できます。
#
# AWS公式ドキュメント:
#   - スキーマの作成: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema-create.html
#   - スキーマレジストリ: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema-registry.html
#   - EventBridgeスキーマ概要: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/schemas_schema
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_schemas_schema" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: スキーマの名前を指定します。
  # 設定可能な値: 最大385文字の文字列（英小文字、英大文字、. - _ @ を使用可能）
  name = "my_schema"

  # registry_name (Required)
  # 設定内容: このスキーマが属するレジストリの名前を指定します。
  # 設定可能な値: 既存のスキーマレジストリ名（aws_schemas_registryリソースで作成したもの等）
  registry_name = "my_own_registry"

  # type (Required)
  # 設定内容: スキーマのタイプを指定します。
  # 設定可能な値:
  #   - "OpenApi3": OpenAPI 3.0仕様形式。サービス間通信のAPI定義に適しています
  #   - "JSONSchemaDraft4": JSONSchema Draft4形式。クライアントサイドのバリデーションに推奨
  # 参考: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema-create.html
  type = "OpenApi3"

  # content (Required)
  # 設定内容: スキーマの仕様を指定します。有効なOpenAPI 3.0仕様またはJSONSchema Draft4形式のJSON文字列を指定します。
  # 設定可能な値: 有効なOpenAPI 3.0仕様またはJSONSchema Draft4形式のJSON文字列
  # 参考: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema-create.html
  content = jsonencode({
    "openapi" : "3.0.0",
    "info" : {
      "version" : "1.0.0",
      "title" : "Event"
    },
    "paths" : {},
    "components" : {
      "schemas" : {
        "Event" : {
          "type" : "object",
          "properties" : {
            "name" : {
              "type" : "string"
            }
          }
        }
      }
    }
  })

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: スキーマの説明を指定します。
  # 設定可能な値: 最大256文字の文字列
  # 省略時: 説明なし
  description = "The schema definition for my event"

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-schema"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スキーマのAmazon Resource Name (ARN)
#
# - last_modified: スキーマの最終更新日時
#
# - version: スキーマのバージョン番号
#
# - version_created_date: スキーマバージョンの作成日時
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
