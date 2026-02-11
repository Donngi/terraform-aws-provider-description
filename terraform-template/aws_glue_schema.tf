#---------------------------------------------------------------
# AWS Glue Schema
#---------------------------------------------------------------
#
# AWS Glue Schemaリソースを作成します。
# AWS Glue Schema Registryにスキーマを登録し、データストリームの
# スキーマを集中管理・制御・進化させることができます。
#
# スキーマは、データレコードの構造と形式を定義するバージョン管理された
# 仕様です。AVRO、JSON、Protobuf形式をサポートし、Apache Kafka、
# Amazon MSK、Amazon Kinesis Data Streams、Amazon Managed Service for
# Apache Flink、AWS Lambdaなどとの統合が可能です。
#
# AWS公式ドキュメント:
#   - AWS Glue Schema Registry: https://docs.aws.amazon.com/glue/latest/dg/schema-registry.html
#   - Schema Registry の仕組み: https://docs.aws.amazon.com/glue/latest/dg/schema-registry-works.html
#   - Schema Registry との統合: https://docs.aws.amazon.com/glue/latest/dg/schema-registry-integrations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_schema
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_schema" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # schema_name - (必須) スキーマの名前
  # スキーマを識別するための名前を指定します。
  # この名前はレジストリ内で一意である必要があります。
  schema_name = "example-schema"

  # data_format - (必須) スキーマ定義のデータフォーマット
  # 有効な値: "AVRO", "JSON", "PROTOBUF"
  #
  # - AVRO: Apache Avro形式 (v1.11.4をサポート)
  # - JSON: JSON Schema形式 (Draft-04, Draft-06, Draft-07をサポート)
  # - PROTOBUF: Protocol Buffers形式 (proto2とproto3をサポート、extensionsとgroupsは未サポート)
  #
  # データのシリアライズ/デシリアライズに使用される形式です。
  data_format = "AVRO"

  # compatibility - (必須) スキーマの互換性モード
  # 有効な値: "NONE", "DISABLED", "BACKWARD", "BACKWARD_ALL", "FORWARD", "FORWARD_ALL", "FULL", "FULL_ALL"
  #
  # - NONE: 互換性チェックなし。新しいバージョンはチェックなしで受け入れられます
  # - DISABLED: バージョニングを無効化。新しいバージョンを追加できません
  # - BACKWARD: 後方互換性。コンシューマーが現在と前のバージョンを読み取り可能
  #   (フィールド削除またはオプションフィールド追加が可能)
  # - BACKWARD_ALL: すべての前バージョンとの後方互換性
  # - FORWARD: 前方互換性。コンシューマーが現在と次のバージョンを読み取り可能
  #   (フィールド追加または必須フィールド削除が可能)
  # - FORWARD_ALL: すべての次バージョンとの前方互換性
  # - FULL: 完全互換性。BACKWARDとFORWARDの両方を満たす
  # - FULL_ALL: すべてのバージョンとの完全互換性
  #
  # スキーマの進化方法を制御し、プロデューサーとコンシューマー間の
  # 契約を形成します。
  compatibility = "BACKWARD"

  # schema_definition - (必須) スキーマ定義
  # data_formatで指定した形式に従ったスキーマ定義を文字列で指定します。
  #
  # AVRO形式の例:
  # {"type": "record", "name": "Employee", "fields": [
  #   {"name": "Name", "type": "string"},
  #   {"name": "Age", "type": "int"}
  # ]}
  #
  # JSON Schema形式の例:
  # {
  #   "$schema": "http://json-schema.org/draft-07/schema#",
  #   "type": "object",
  #   "properties": {
  #     "name": {"type": "string"}
  #   }
  # }
  #
  # Protobuf形式の例:
  # syntax = "proto2";
  # message Person {
  #   optional string name = 1;
  #   optional int32 id = 2;
  # }
  schema_definition = jsonencode({
    type = "record"
    name = "ExampleRecord"
    fields = [
      {
        name = "id"
        type = "int"
      },
      {
        name = "name"
        type = "string"
      }
    ]
  })

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # registry_arn - (オプション) スキーマを作成するGlue RegistryのARN
  # 指定しない場合、デフォルトレジストリが使用されます。
  # レジストリを使用してスキーマを論理的にグループ化し、
  # アクセス制御を管理できます。
  #
  # 形式: arn:aws:glue:region:account-id:registry/registry-name
  # registry_arn = aws_glue_registry.example.arn

  # description - (オプション) スキーマの説明
  # スキーマの目的や用途を記述します。
  # description = "Example schema for customer data"

  # region - (オプション) リソースを管理するAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # リージョンエンドポイントについては以下を参照:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - (オプション) リソースタグのキーバリューマップ
  # リソースの分類、コスト配分、アクセス制御などに使用します。
  # プロバイダーのdefault_tags設定ブロックと併用可能です。
  # 同じキーの場合、ここで定義したタグがプロバイダーレベルのタグを上書きします。
  #
  # tags = {
  #   Environment = "production"
  #   Team        = "data-engineering"
  #   Application = "streaming-pipeline"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# これらの属性はリソース作成後に参照可能ですが、設定はできません。
#
# - arn - スキーマのAmazon Resource Name (ARN)
#   形式: arn:aws:glue:region:account-id:schema/registry-name/schema-name
#   例: aws_glue_schema.example.arn
#
# - id - スキーマのAmazon Resource Name (ARN) (arnと同じ値)
#   例: aws_glue_schema.example.id
#
# - registry_name - Glue Registryの名前
#   スキーマが所属するレジストリの名前を返します
#   例: aws_glue_schema.example.registry_name
#
# - latest_schema_version - 最新のスキーマバージョン番号
#   スキーマの最新バージョンを表す整数値
#   例: aws_glue_schema.example.latest_schema_version
#
# - next_schema_version - 次のスキーマバージョン番号
#   次に登録されるスキーマのバージョン番号
#   例: aws_glue_schema.example.next_schema_version
#
# - schema_checkpoint - スキーマチェックポイント
#   互換性モードが最後に変更されたバージョン番号
#   新しいバージョンの互換性チェックはこのチェックポイントバージョンに対して実行されます
#   例: aws_glue_schema.example.schema_checkpoint
#
# - tags_all - リソースに割り当てられたすべてのタグのマップ
#   プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます
#   例: aws_glue_schema.example.tags_all
#
#---------------------------------------------------------------
