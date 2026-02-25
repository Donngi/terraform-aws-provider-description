#---------------------------------------------------------------
# Amazon EventBridge Schema Discoverer
#---------------------------------------------------------------
#
# Amazon EventBridgeのスキーマディスカバラーをプロビジョニングするリソースです。
# スキーマディスカバラーは、EventBusやCloudTrailなどのイベントソースを監視し、
# 送受信されるイベントのスキーマを自動的に検出・記録します。
# 検出されたスキーマはEventBridgeスキーマレジストリに格納され、
# コード生成や型安全なイベント処理に利用できます。
#
# AWS公式ドキュメント:
#   - スキーマディスカバラー概要: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema-discoverer.html
#   - EventBridgeスキーマ: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/schemas_discoverer
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_schemas_discoverer" "example" {
  #-------------------------------------------------------------
  # イベントソース設定
  #-------------------------------------------------------------

  # source_arn (Required)
  # 設定内容: スキーマを発見するイベントソースのARNを指定します。
  # 設定可能な値: EventBusのARN、またはCloudTrailのARN
  # 参考: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema-discoverer.html
  source_arn = "arn:aws:events:ap-northeast-1:123456789012:event-bus/default"

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: スキーマディスカバラーの説明を指定します。
  # 設定可能な値: 最大256文字の文字列
  # 省略時: 説明なし
  description = "EventBusからイベントスキーマを自動検出するディスカバラー"

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
    Name        = "my-schema-discoverer"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スキーマディスカバラーのAmazon Resource Name (ARN)
#
# - id: スキーマディスカバラーのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
