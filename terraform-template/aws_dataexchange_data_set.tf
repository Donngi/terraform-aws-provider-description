#---------------------------------------------------------------
# AWS Data Exchange Data Set
#---------------------------------------------------------------
#
# AWS Data Exchangeのデータセットをプロビジョニングするリソースです。
# データセットは、1つ以上のリビジョンを含むリソースであり、S3スナップショット、
# API Gateway API、Redshiftデータシェア、Lake Formationデータ権限、S3データ
# アクセスなど、さまざまなタイプのアセットを含めることができます。
#
# AWS公式ドキュメント:
#   - Data Exchange API Reference (DataSetEntry): https://docs.aws.amazon.com/data-exchange/latest/apireference/API_DataSetEntry.html
#   - Data Exchange API Reference (CreateDataSet): https://docs.aws.amazon.com/data-exchange/latest/apireference/API_CreateDataSet.html
#   - Data Exchange API Reference (AssetEntry): https://docs.aws.amazon.com/data-exchange/latest/apireference/API_AssetEntry.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dataexchange_data_set
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dataexchange_data_set" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # asset_type (Required)
  # 設定内容: データセットに追加されるアセットのタイプを指定します。
  # 設定可能な値:
  #   - "S3_SNAPSHOT": Amazon S3オブジェクトとして保存されるデータ
  #   - "API_GATEWAY_API": Amazon API Gateway APIとして提供されるデータ
  #   - "REDSHIFT_DATA_SHARE": Amazon Redshiftデータシェアとして提供されるデータ
  #   - "S3_DATA_ACCESS": Amazon S3データアクセスとして提供されるデータ
  #   - "LAKE_FORMATION_DATA_PERMISSION": AWS Lake Formationデータ権限として提供されるデータ
  # 関連機能: AWS Data Exchange Asset Types
  #   データセットに含めることができるアセットのタイプを定義します。
  #   各タイプは異なるデータ配信メカニズムとユースケースをサポートします。
  #   - https://docs.aws.amazon.com/data-exchange/latest/apireference/API_AssetEntry.html
  asset_type = "S3_SNAPSHOT"

  # description (Required)
  # 設定内容: データセットの説明を指定します。
  # 設定可能な値: 文字列。データセットの内容や用途を説明するテキスト。
  # 注意: この説明は、データセットを識別し、その内容を理解するために重要です。
  description = "Example data set for demonstration purposes"

  # name (Required)
  # 設定内容: データセットの名前を指定します。
  # 設定可能な値: 文字列。データセットを識別するための一意の名前。
  # 注意: データセット名はアカウント内で一意である必要はありませんが、
  #       管理しやすいよう一意の名前を付けることを推奨します。
  name = "example-data-set"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: データセットの一意の識別子を指定します。
  # 設定可能な値: 文字列。通常は省略し、AWSによって自動生成されます。
  # 省略時: AWSが自動的に一意のIDを生成します。
  # 注意: 通常は明示的に設定する必要はありません。
  id = null

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-data-set"
    Environment = "development"
    ManagedBy   = "terraform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: リソースに割り当てられたすべてのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: プロバイダーのdefault_tags設定ブロックから継承されたタグが自動的に含まれます。
  # 注意: 通常、このプロパティは明示的に設定する必要はありません。
  #       tagsプロパティとプロバイダーのdefault_tagsが自動的にマージされます。
  tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: データセットの一意の識別子。
#       データセット作成後にAWSによって自動生成されます。
#
# - arn: データセットのAmazon Resource Name (ARN)。
#        他のAWSサービスとの統合やIAMポリシーでの参照に使用できます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#
# - region: リソースが管理されているAWSリージョン。
#---------------------------------------------------------------
