#---------------------------------------------------------------
# AWS Athena Data Catalog
#---------------------------------------------------------------
#
# Amazon Athenaのデータカタログをプロビジョニングするリソースです。
# データカタログは、Athenaがクエリ対象のデータベースやテーブルのメタデータを
# 参照するためのデータソースを定義します。AWS Glue Data Catalog、
# Apache Hiveメタストア、Lambdaベースのフェデレーテッドカタログなど、
# 複数のデータソースタイプをサポートしています。
#
# AWS公式ドキュメント:
#   - Athena概要: https://docs.aws.amazon.com/athena/latest/ug/what-is.html
#   - DataCatalog API: https://docs.aws.amazon.com/athena/latest/APIReference/API_DataCatalog.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_data_catalog
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_athena_data_catalog" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: データカタログの名前を指定します。
  # 設定可能な値:
  #   - 1-256文字の文字列
  #   - 英数字、アンダースコア(_)、アットマーク(@)、ハイフン(-)が使用可能
  #   - AWSアカウント内で一意である必要があります
  # 注意: 最大127文字までがユーザー指定可能で、残りの256文字はAthenaが予約しています。
  name = "my-data-catalog"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Required)
  # 設定内容: データカタログの説明を指定します。
  # 設定可能な値: 1-1024文字の文字列
  description = "Sample data catalog for demonstration"

  #-------------------------------------------------------------
  # カタログタイプ設定
  #-------------------------------------------------------------

  # type (Required)
  # 設定内容: 作成するデータカタログのタイプを指定します。
  # 設定可能な値:
  #   - "GLUE": AWS Glue Data Catalog。既存のAWS Glueカタログをデータソースとして使用
  #   - "HIVE": 外部Apache Hiveメタストア。Lambda関数経由でHiveメタストアに接続
  #   - "LAMBDA": フェデレーテッドカタログ。カスタムLambda関数でメタデータとデータを処理
  #   - "FEDERATED": Athenaがパラメータに基づいてLambda関数とGlue接続を自動作成するフェデレーテッドカタログ
  # 関連機能: Athena フェデレーテッドクエリ
  #   異なるデータソース（リレーショナル、非リレーショナル、オブジェクト、カスタム）に対して
  #   単一のSQLクエリを実行できます。
  #   - https://docs.aws.amazon.com/athena/latest/ug/connect-to-a-data-source.html
  type = "GLUE"

  #-------------------------------------------------------------
  # パラメータ設定
  #-------------------------------------------------------------

  # parameters (Required)
  # 設定内容: データカタログに必要なパラメータをマップ形式で指定します。
  # 設定可能な値: カタログタイプによって異なります
  #
  # GLUEタイプの場合:
  #   - "catalog-id": AWS Glueカタログが属するAWSアカウントID
  #
  # HIVEタイプの場合:
  #   - "metadata-function" (必須): メタデータを処理するLambda関数のARN
  #   - "sdk-version" (任意): SDKバージョン。省略時は現在サポートされているバージョンを使用
  #
  # LAMBDAタイプの場合 (2つの方式から選択):
  #   方式1: メタデータとデータを別々のLambda関数で処理
  #     - "metadata-function": メタデータを処理するLambda関数のARN
  #     - "record-function": 実データを読み取るLambda関数のARN
  #   方式2: 単一のLambda関数で両方を処理
  #     - "function": メタデータとデータの両方を処理するLambda関数のARN
  #
  # FEDERATEDタイプの場合 (2つの方式から選択):
  #   方式1: 既存のGlue接続を再利用
  #     - "connection-arn": 既存のAWS Glue接続ARN
  #   方式2: 新規接続を設定
  #     - "connection-type": 接続タイプ (MYSQL, REDSHIFT, POSTGRESQL等)
  #     - "connection-properties": 接続プロパティのJSON文字列
  #
  # 参考: https://docs.aws.amazon.com/athena/latest/APIReference/API_DataCatalog.html
  parameters = {
    "catalog-id" = "123456789012"
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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-data-catalog"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# タイプ別の設定例
#---------------------------------------------------------------

# HIVE タイプの例
resource "aws_athena_data_catalog" "hive_example" {
  name        = "hive-data-catalog"
  description = "Hive based Data Catalog"
  type        = "HIVE"

  parameters = {
    "metadata-function" = "arn:aws:lambda:ap-northeast-1:123456789012:function:hive-metastore-function"
  }
}

# LAMBDA タイプの例 (メタデータとデータを別々の関数で処理)
resource "aws_athena_data_catalog" "lambda_example" {
  name        = "lambda-data-catalog"
  description = "Lambda based Data Catalog"
  type        = "LAMBDA"

  parameters = {
    "metadata-function" = "arn:aws:lambda:ap-northeast-1:123456789012:function:metadata-function"
    "record-function"   = "arn:aws:lambda:ap-northeast-1:123456789012:function:record-function"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: データカタログの名前。
#
# - arn: データカタログのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
