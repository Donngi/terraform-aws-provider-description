#---------------------------------------------------------------
# AWS Glue Registry
#---------------------------------------------------------------
#
# AWS Glue スキーマレジストリをプロビジョニングするリソースです。
# スキーマレジストリはデータストリームのスキーマを一元管理・発見するための
# サービスで、Avro・JSON・Protobuf形式のデータをサポートします。
# Amazon MSK・Kinesis Data Streams・Apache Kafka等との統合に使用します。
#
# AWS公式ドキュメント:
#   - AWS Glue スキーマレジストリ: https://docs.aws.amazon.com/glue/latest/dg/schema-registry.html
#   - レジストリの作成: https://docs.aws.amazon.com/glue/latest/dg/schema-registry-gs3.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_registry
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_registry" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # registry_name (Required)
  # 設定内容: レジストリの名前を指定します。
  # 設定可能な値: 最大255文字の文字列。英数字・ハイフン・アンダースコア・
  #              ドル記号・ハッシュ記号のみ使用可能
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/schema-registry-gs3.html
  registry_name = "example-registry"

  # description (Optional)
  # 設定内容: レジストリの説明を指定します。
  # 設定可能な値: 最大2048バイトの文字列
  # 省略時: 説明なし
  description = "スキーマレジストリの説明"

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
    Name        = "example-registry"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Glue レジストリの Amazon Resource Name (ARN)
#
# - id: Glue レジストリの Amazon Resource Name (ARN)
#       (arnと同じ値)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
