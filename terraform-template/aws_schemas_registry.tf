#---------------------------------------------------------------
# Amazon EventBridge Custom Schema Registry
#---------------------------------------------------------------
#
# Amazon EventBridgeのカスタムスキーマレジストリをプロビジョニングするリソースです。
# スキーマレジストリはEventBridgeスキーマを整理・管理するためのコンテナであり、
# カスタムレジストリを作成することで独自のイベントスキーマを分類・管理できます。
#
# AWS公式ドキュメント:
#   - スキーマレジストリ概要: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema-registry.html
#   - EventBridgeスキーマ: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/schemas_registry
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_schemas_registry" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: カスタムイベントスキーマレジストリの名前を指定します。
  # 設定可能な値: 最大64文字の文字列。使用可能文字: 小文字 (a-z)、大文字 (A-Z)、数字 (0-9)、.(ドット)、-(ハイフン)、_(アンダースコア)
  # 参考: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema-registry.html
  name = "my_custom_registry"

  # description (Optional)
  # 設定内容: スキーマレジストリの説明を指定します。
  # 設定可能な値: 最大256文字の文字列
  # 省略時: 説明なし
  description = "カスタムイベントスキーマを管理するレジストリ"

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
  # 注意: プロバイダーのdefault_tags設定ブロックで定義されたタグと一致するキーを持つタグは、
  #       プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-custom-registry"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スキーマレジストリのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
