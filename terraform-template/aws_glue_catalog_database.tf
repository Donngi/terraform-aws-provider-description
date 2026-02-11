#---------------------------------------------------------------
# AWS Glue Catalog Database
#---------------------------------------------------------------
#
# AWS Glue Data Catalog内にデータベースを作成します。
# AWS Glue Data Catalogは、データセットに関するメタデータを管理する
# 永続的なメタデータストアです。データベースは、関連するテーブルや
# メタデータを論理的にグループ化するために使用されます。
#
# AWS公式ドキュメント:
#   - Getting started with the AWS Glue Data Catalog: https://docs.aws.amazon.com/glue/latest/dg/start-data-catalog.html
#   - AWS Glue Data Catalog best practices: https://docs.aws.amazon.com/glue/latest/dg/best-practice-catalog.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_catalog_database" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # name - (Required) データベースの名前
  # 使用可能な文字: 小文字のアルファベット、数字、アンダースコア文字
  # データベースの論理的な名前を指定します。一意である必要があります。
  name = "my_catalog_database"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # catalog_id - (Optional) データベースを作成するGlue CatalogのID
  # 省略した場合、デフォルトでAWSアカウントIDが使用されます。
  # クロスアカウントでData Catalogを使用する場合に指定します。
  # catalog_id = "123456789012"

  # description - (Optional) データベースの説明
  # データベースの目的や内容を記述します。
  # description = "This is a catalog database for analytics data"

  # location_uri - (Optional) データベースの場所を示すURI
  # 例えば、HDFSパスなどを指定します。
  # Data Catalogクライアントで使用されることがあります。
  # location_uri = "s3://my-bucket/my-database/"

  # parameters - (Optional) データベースのプロパティを定義するキー・バリューのマップ
  # データベースに関するカスタムメタデータを保存できます。
  # parameters = {
  #   "classification" = "parquet"
  #   "environment"    = "production"
  # }

  # region - (Optional) このリソースが管理されるリージョン
  # デフォルトでは、プロバイダー設定で指定されたリージョンが使用されます。
  # マルチリージョン構成で明示的にリージョンを指定する場合に使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  # tags - (Optional) リソースに付与するタグのマップ
  # プロバイダーにdefault_tags設定ブロックが存在する場合、
  # 同じキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags = {
  #   Name        = "my-catalog-database"
  #   Environment = "production"
  #   Owner       = "data-team"
  # }

  # tags_all - (Optional) リソースに割り当てられたタグのマップ
  # プロバイダーのdefault_tagsから継承されたタグも含まれます。
  # 通常、このパラメータは明示的に指定する必要はありません。
  # tags_all = {}

  #---------------------------------------------------------------
  # ネストブロック: create_table_default_permission
  #---------------------------------------------------------------
  # create_table_default_permission - (Optional)
  # テーブルに対するデフォルトのアクセス許可セットをプリンシパルに対して作成します。
  # AWS Lake Formationを使用している場合、このブロックを使用してデフォルトの
  # テーブルパーミッションを制御できます。
  #
  # create_table_default_permission {
  #   # permissions - (Optional) プリンシパルに付与される権限のリスト
  #   # 有効な値: ALL, SELECT, ALTER, DROP, DELETE, INSERT, CREATE_DATABASE, CREATE_TABLE, DATA_LOCATION_ACCESS
  #   permissions = ["SELECT"]
  #
  #   # principal - (Optional) 権限を付与されるプリンシパル
  #   principal {
  #     # data_lake_principal_identifier - (Optional) Lake Formationプリンシパルの識別子
  #     # 特殊な値 "IAM_ALLOWED_PRINCIPALS" を指定すると、IAMで許可されたプリンシパル全てを意味します。
  #     # または、特定のIAM ARNを指定できます。
  #     data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
  #   }
  # }

  #---------------------------------------------------------------
  # ネストブロック: federated_database
  #---------------------------------------------------------------
  # federated_database - (Optional)
  # AWS Glue Data Catalog外部のエンティティを参照する設定ブロック。
  # 外部メタストア（例: Apache Hive metastore）に接続する場合に使用します。
  # このブロックは最大1つまで指定可能です。
  #
  # federated_database {
  #   # connection_name - (Optional) 外部メタストアへの接続名
  #   # AWS Glueで定義された接続リソースの名前を指定します。
  #   connection_name = "my-external-metastore-connection"
  #
  #   # identifier - (Optional) フェデレーテッドデータベースの一意識別子
  #   # 外部メタストア内のデータベース名や識別子を指定します。
  #   identifier = "external_database_name"
  # }

  #---------------------------------------------------------------
  # ネストブロック: target_database
  #---------------------------------------------------------------
  # target_database - (Optional)
  # リソースリンク用のターゲットデータベースの設定ブロック。
  # 他のData Catalog内のデータベースへのリンクを作成する場合に使用します。
  # このブロックは最大1つまで指定可能です。
  #
  # target_database {
  #   # catalog_id - (Required) ターゲットデータベースが存在するData CatalogのID
  #   # 通常はAWSアカウントIDです。
  #   catalog_id = "123456789012"
  #
  #   # database_name - (Required) カタログデータベースの名前
  #   # リンク先のデータベース名を指定します。
  #   database_name = "target_database"
  #
  #   # region - (Optional) ターゲットデータベースのリージョン
  #   # クロスリージョンでのリソースリンクを作成する場合に指定します。
  #   region = "us-east-1"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed属性）:
#
# - arn - Glue Catalog DatabaseのARN
# - id - カタログIDとデータベース名（形式: catalog_id:database_name）
# - tags_all - プロバイダーのdefault_tagsから継承されたタグを含む、
#              リソースに割り当てられた全てのタグのマップ
#
# これらの属性は、他のリソースやデータソースで参照できます:
#   例: aws_glue_catalog_database.example.arn
#---------------------------------------------------------------
