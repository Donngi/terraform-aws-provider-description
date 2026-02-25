#---------------------------------------------------------------
# AWS Glue Schema
#---------------------------------------------------------------
#
# AWS Glue Schema Registry にスキーマをプロビジョニングするリソースです。
# スキーマはデータレコードの構造とフォーマットを定義するバージョン管理された仕様であり、
# データプロデューサーとコンシューマー間の信頼性の高いデータのやり取りを保証します。
# AVRO、JSON、PROTOBUF の各データフォーマットをサポートし、
# 互換性モードによってスキーマの進化ルールを制御できます。
#
# AWS公式ドキュメント:
#   - AWS Glue Schema Registry 概要: https://docs.aws.amazon.com/glue/latest/dg/schema-registry.html
#   - スキーマの作成: https://docs.aws.amazon.com/glue/latest/dg/schema-registry-gs4.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_schema
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_schema" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # schema_name (Required)
  # 設定内容: スキーマの名前を指定します。
  # 設定可能な値: 1-255文字の英数字、ハイフン、アンダースコアを含む文字列
  schema_name = "example-schema"

  # data_format (Required)
  # 設定内容: スキーマ定義のデータフォーマットを指定します。
  # 設定可能な値:
  #   - "AVRO": Apache Avro フォーマット。JSONでスキーマを記述しバイナリでデータを保存
  #   - "JSON": JSON Schema フォーマット
  #   - "PROTOBUF": Protocol Buffers フォーマット
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/schema-registry.html
  data_format = "AVRO"

  # compatibility (Required)
  # 設定内容: スキーマの互換性モードを指定します。新しいスキーマバージョン登録時の
  #   互換性チェックルールを定義します。
  # 設定可能な値:
  #   - "NONE": 互換性チェックなし。任意のスキーマバージョンを登録可能
  #   - "DISABLED": スキーマ進化を無効化。新しいバージョンの登録が不可
  #   - "BACKWARD": 新しいスキーマで古いデータを読み込み可能（後方互換）
  #   - "BACKWARD_ALL": 全ての過去バージョンのデータを新しいスキーマで読み込み可能
  #   - "FORWARD": 古いスキーマで新しいデータを読み込み可能（前方互換）
  #   - "FORWARD_ALL": 全ての過去バージョンのスキーマで新しいデータを読み込み可能
  #   - "FULL": BACKWARD と FORWARD の両方の互換性を保持
  #   - "FULL_ALL": BACKWARD_ALL と FORWARD_ALL の両方の互換性を保持
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/schema-registry.html
  compatibility = "NONE"

  # schema_definition (Required)
  # 設定内容: data_format で指定したフォーマットに従ったスキーマ定義を指定します。
  # 設定可能な値: data_format に対応したスキーマ定義文字列
  #   - AVRO の場合: Avro スキーマ定義の JSON 文字列
  #   - JSON の場合: JSON Schema 定義文字列
  #   - PROTOBUF の場合: Protocol Buffers スキーマ定義文字列
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/schema-registry-gs4.html
  schema_definition = "{\"type\": \"record\", \"name\": \"r1\", \"fields\": [{\"name\": \"f1\", \"type\": \"int\"}, {\"name\": \"f2\", \"type\": \"string\"}]}"

  #-------------------------------------------------------------
  # レジストリ設定
  #-------------------------------------------------------------

  # registry_arn (Optional)
  # 設定内容: スキーマを作成する Glue Registry の ARN を指定します。
  # 設定可能な値: 有効な Glue Registry の ARN
  # 省略時: デフォルトレジストリが使用されます。
  # 注意: スキーマはいずれか一つのレジストリに所属します。
  registry_arn = "arn:aws:glue:ap-northeast-1:123456789012:registry/example-registry"

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
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: スキーマの説明を指定します。
  # 設定可能な値: 任意の文字列（最大2048文字）
  # 省略時: 説明なし
  description = "Avroフォーマットのサンプルスキーマ"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-schema"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スキーマの Amazon Resource Name (ARN)
#
# - registry_name: スキーマが所属する Glue Registry の名前
#
# - latest_schema_version: 返されたスキーマ定義に関連するスキーマの最新バージョン番号
#
# - next_schema_version: 返されたスキーマ定義に関連するスキーマの次のバージョン番号
#
# - schema_checkpoint: チェックポイントのバージョン番号（互換性モードが最後に変更された時点）
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられた全タグのマップ
#---------------------------------------------------------------
