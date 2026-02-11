#---------------------------------------------------------------
# AWS Glue User Defined Function
#---------------------------------------------------------------
#
# AWS Glue User Defined Function (UDF) リソースをプロビジョニングします。
# このリソースは、AWS Glue Data Catalog に Hive 形式のユーザー定義関数を
# 登録するために使用されます。UDFは、Glue ETLジョブやAthenaクエリで
# カスタムロジックを実行するために使用できます。
#
# AWS公式ドキュメント:
#   - User-defined Function API: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-catalog-functions.html
#   - UserDefinedFunction: https://docs.aws.amazon.com/glue/latest/webapi/API_UserDefinedFunction.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_user_defined_function
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_user_defined_function" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) UDFの名前
  #
  # Data Catalog内での関数の識別名として使用されます。
  # この名前はデータベース内で一意である必要があります。
  #
  # 制約:
  #   - 最小長: 1文字
  #   - 最大長: 255文字
  name = "my_udf_function"

  # (Required) 関数を作成するデータベース名
  #
  # UDFが属するGlue Data Catalogデータベースの名前を指定します。
  # このデータベースは事前に作成されている必要があります。
  #
  # 制約:
  #   - 最小長: 1文字
  #   - 最大長: 255文字
  database_name = "my_database"

  # (Required) 関数コードを含むJavaクラス名
  #
  # UDFの実装を含む完全修飾Javaクラス名を指定します。
  # このクラスは、resource_urisで指定されたJARファイル内に
  # 存在する必要があります。
  #
  # 例: "com.example.MyCustomUDF"
  #
  # 制約:
  #   - 最小長: 1文字
  #   - 最大長: 255文字
  class_name = "com.example.functions.MyUDF"

  # (Required) 関数の所有者名
  #
  # UDFを所有するユーザー、ロール、またはグループの名前を指定します。
  # owner_typeと組み合わせて使用されます。
  #
  # 制約:
  #   - 最小長: 1文字
  #   - 最大長: 255文字
  owner_name = "admin"

  # (Required) 所有者のタイプ
  #
  # UDFの所有者がユーザー、ロール、グループのいずれであるかを指定します。
  #
  # 有効な値:
  #   - USER: IAMユーザーが所有者
  #   - ROLE: IAMロールが所有者
  #   - GROUP: IAMグループが所有者
  owner_type = "USER"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) Glue Data CatalogのID
  #
  # UDFを作成するData CatalogのIDを指定します。
  # 省略した場合は、現在のAWSアカウントIDがデフォルトで使用されます。
  # クロスアカウントでのカタログアクセスを行う場合に指定します。
  #
  # 制約:
  #   - 最小長: 1文字
  #   - 最大長: 255文字
  #
  # デフォルト: 現在のAWSアカウントID
  # catalog_id = "123456789012"

  # (Optional) リソースが管理されるリージョン
  #
  # このリソースが作成されるAWSリージョンを指定します。
  # 省略した場合は、プロバイダー設定のリージョンが使用されます。
  #
  # 参考:
  #   - Regional Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #   - Provider Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # デフォルト: プロバイダー設定のリージョン
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Resource URIs Block (Optional)
  #---------------------------------------------------------------

  # (Optional) 関数で使用するリソースURIの設定
  #
  # UDFの実装を含むJARファイルや、その他の必要なリソースファイルの
  # URIを指定します。複数のリソースURIを指定できます。
  #
  # 制約:
  #   - 最小: 0個
  #   - 最大: 1000個
  resource_uris {
    # (Required) リソースのタイプ
    #
    # 使用するリソースの種類を指定します。
    #
    # 有効な値:
    #   - JAR: Javaアーカイブファイル
    #   - FILE: 通常のファイル
    #   - ARCHIVE: アーカイブファイル (tar, zip等)
    resource_type = "JAR"

    # (Required) リソースにアクセスするためのURI
    #
    # リソースファイルの場所を示すURIを指定します。
    # S3 URIの形式で指定することが一般的です。
    #
    # 例: "s3://my-bucket/path/to/my-udf.jar"
    uri = "s3://my-glue-assets/udfs/my-custom-udf.jar"
  }

  # 複数のリソースURIを指定する例:
  # resource_uris {
  #   resource_type = "FILE"
  #   uri           = "s3://my-bucket/config/udf-config.properties"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Read-Only)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です(computed only):
#
# - id: Glue User Defined FunctionのID
#   形式: catalog_id:database_name:function_name
#
# - arn: UDFのAmazon Resource Name (ARN)
#   形式: arn:aws:glue:region:account-id:userDefinedFunction/database_name/function_name
#
# - create_time: UDFが作成された日時
#   形式: RFC3339形式のタイムスタンプ
#
# 使用例:
# output "udf_arn" {
#   value = aws_glue_user_defined_function.example.arn
# }
#
# output "udf_create_time" {
#   value = aws_glue_user_defined_function.example.create_time
# }
