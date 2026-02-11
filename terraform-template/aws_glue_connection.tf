#---------------------------------------------------------------
# AWS Glue Connection
#---------------------------------------------------------------
#
# AWS Glueで使用するデータソースへの接続情報を定義するリソース。
# JDBC、MongoDB、Kafka、Snowflake、BigQuery、OpenSearch、DynamoDB等の
# 様々なデータストアへの接続設定を管理します。
#
# AWS公式ドキュメント:
#   - AWS Glue connection properties: https://docs.aws.amazon.com/glue/latest/dg/connection-properties.html
#   - Creating connections for connectors: https://docs.aws.amazon.com/glue/latest/dg/creating-connections.html
#   - Connection API: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-catalog-connections-connections.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_connection
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_connection" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (Required) 接続の名前
  # Data Catalog内で一意である必要があります。
  name = "example-connection"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # (Optional) Data CatalogのカタログID
  # 指定しない場合はAWSアカウントIDがデフォルトで使用されます。
  # 通常は省略可能ですが、クロスアカウント接続の場合に指定します。
  catalog_id = null

  # (Optional) Athena固有の接続プロパティ
  # Athena Federated Query（DynamoDB等へのフェデレーテッドクエリ）で使用します。
  # 主にDynamoDB接続タイプで利用され、Lambda関数ARNやスピルバケットを指定します。
  # 例:
  # athena_properties = {
  #   lambda_function_arn      = "arn:aws:lambda:us-east-1:123456789012:function:athenafederatedcatalog_athena_abcdefgh"
  #   disable_spill_encryption = "false"
  #   spill_bucket             = "example-bucket"
  # }
  # Sensitive: true（機密情報として扱われます）
  athena_properties = null

  # (Optional) 接続プロパティのキー・バリューマップ
  # 接続タイプに応じた設定を行います。詳細は以下のAWS公式ドキュメントを参照:
  # https://docs.aws.amazon.com/glue/latest/dg/connection-properties.html
  #
  # JDBC接続の例:
  # connection_properties = {
  #   JDBC_CONNECTION_URL = "jdbc:mysql://example.com/exampledatabase"
  #   USERNAME            = "exampleusername"
  #   PASSWORD            = "examplepassword"
  # }
  #
  # Secrets Managerを使用する場合:
  # connection_properties = {
  #   JDBC_CONNECTION_URL = "jdbc:mysql://example.com/exampledatabase"
  #   SECRET_ID           = "example-secret"
  # }
  #
  # Snowflake/BigQuery/OpenSearch等のSparkベース接続の場合、SparkPropertiesキーに
  # JSON形式の設定を渡します:
  # connection_properties = {
  #   SparkProperties = jsonencode({
  #     secretId = "example-secret"
  #     sfRole   = "EXAMPLEETLROLE"
  #     sfUrl    = "exampleorg-exampleconnection.snowflakecomputing.com"
  #   })
  # }
  #
  # Sensitive: true（機密情報として扱われます）
  connection_properties = null

  # (Optional) 接続タイプ
  # 有効な値: AZURECOSMOS, AZURESQL, BIGQUERY, CUSTOM, DYNAMODB, JDBC, KAFKA,
  #          MARKETPLACE, MONGODB, NETWORK, OPENSEARCH, SNOWFLAKE
  # デフォルト: JDBC
  #
  # - JDBC: RDS、Redshift、Aurora等のJDBC互換データベース
  # - MONGODB: MongoDB、MongoDB Atlas
  # - KAFKA: Apache Kafka、Amazon MSK
  # - SNOWFLAKE: Snowflake Data Warehouse
  # - BIGQUERY: Google BigQuery
  # - OPENSEARCH: Amazon OpenSearch Service
  # - AZURECOSMOS: Azure Cosmos DB
  # - AZURESQL: Azure SQL Database
  # - DYNAMODB: Amazon DynamoDB（Athenaフェデレーテッドクエリ用）
  # - CUSTOM: カスタムコネクタ（独自JDBCドライバ等）
  # - NETWORK: VPC内のネットワーク接続のみ
  connection_type = "JDBC"

  # (Optional) 接続の説明
  # 接続の目的や用途を記述します。
  description = null

  # (Optional) マッチ基準のリスト
  # この接続を選択する際に使用できる基準を指定します。
  # カスタムコネクタを使用する場合、テンプレート接続を定義し、
  # 他の接続からこのリストで参照することができます。
  #
  # カスタムコネクタの例:
  # match_criteria = ["template-connection"]
  #
  # テンプレート接続を参照する例:
  # match_criteria = ["Connection", aws_glue_connection.template.name]
  match_criteria = null

  # (Optional) AWS リージョン
  # このリソースが管理されるリージョンを指定します。
  # 省略した場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 通常は指定不要ですが、マルチリージョン構成で明示的に指定する場合に使用します。
  region = null

  # (Optional) リソースタグ
  # 接続にタグを付与します。キー・バリュー形式のマップです。
  # provider default_tags設定ブロックと組み合わせて使用できます。
  tags = {}

  # (Optional) 物理接続要件
  # VPCおよびセキュリティグループなどのネットワーク設定を定義します。
  # VPC内のデータソース（RDS、Redshift等）に接続する場合に必要です。
  # 最大1つまで指定可能です。
  #
  # 設定例:
  # physical_connection_requirements {
  #   availability_zone      = "us-east-1a"
  #   security_group_id_list = ["sg-12345678"]
  #   subnet_id              = "subnet-12345678"
  # }
  # physical_connection_requirements {
  #   # (Optional) アベイラビリティゾーン
  #   # 接続が使用するアベイラビリティゾーンを指定します。
  #   # このフィールドはsubnet_idから暗黙的に導出されますが、現在のAPI要件として必要です。
  #   # 通常はsubnet_idと同じAZを指定します。
  #   availability_zone = null

  #   # (Optional) セキュリティグループIDリスト
  #   # 接続で使用するセキュリティグループのIDリストです。
  #   # データソースへのインバウンド・アウトバウンドルールを適切に設定する必要があります。
  #   # AWS Glueは、VPCサブネットにアタッチされたElastic Network Interfaceに
  #   # これらのセキュリティグループを関連付けます。
  #   security_group_id_list = []

  #   # (Optional) サブネットID
  #   # 接続で使用するVPCサブネットのIDです。
  #   # データソースと同じVPC内のサブネットを指定する必要があります。
  #   # 重要: 現在、1つのETLジョブは1つのサブネット内のJDBC接続のみを使用できます。
  #   #       複数のデータストアを使用する場合、同じサブネット上にあるか、
  #   #       そのサブネットからアクセス可能である必要があります。
  #   subnet_id = null
  # }
}

#---------------------------------------------------------------
# Attributes Reference（読み取り専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（設定不可）:
#
# - arn         : Glue接続のARN
#                 例: "arn:aws:glue:us-east-1:123456789012:connection/example-connection"
#
# - id          : カタログIDと接続名の組み合わせ
#                 例: "123456789012:example-connection"
#
# - tags_all    : リソースに割り当てられたタグのマップ（provider default_tagsを含む）
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: 非VPC JDBC接続（RDS等への基本接続）
resource "aws_glue_connection" "non_vpc_example" {
  name = "non-vpc-connection"

  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:mysql://example.com/exampledatabase"
    USERNAME            = "exampleusername"
    PASSWORD            = "examplepassword"
  }
}

# 例2: Secrets Managerを使用した接続
data "aws_secretsmanager_secret" "db_credentials" {
  name = "example-secret"
}

resource "aws_glue_connection" "with_secret" {
  name = "connection-with-secret"

  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:mysql://example.com/exampledatabase"
    SECRET_ID           = data.aws_secretsmanager_secret.db_credentials.name
  }
}

# 例3: VPC内のRDS接続
resource "aws_glue_connection" "vpc_connection" {
  name = "vpc-connection"

  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:mysql://${aws_rds_cluster.example.endpoint}/exampledatabase"
    USERNAME            = "exampleusername"
    PASSWORD            = "examplepassword"
  }

  physical_connection_requirements {
    availability_zone      = aws_subnet.example.availability_zone
    security_group_id_list = [aws_security_group.example.id]
    subnet_id              = aws_subnet.example.id
  }
}

# 例4: Snowflake接続
resource "aws_glue_connection" "snowflake" {
  name            = "snowflake-connection"
  connection_type = "SNOWFLAKE"

  connection_properties = {
    SparkProperties = jsonencode({
      secretId = aws_secretsmanager_secret.snowflake_creds.name
      sfRole   = "EXAMPLEETLROLE"
      sfUrl    = "exampleorg-exampleconnection.snowflakecomputing.com"
    })
  }
}

# 例5: DynamoDB接続（Athenaフェデレーテッドクエリ用）
resource "aws_glue_connection" "dynamodb" {
  name            = "dynamodb-connection"
  connection_type = "DYNAMODB"

  athena_properties = {
    lambda_function_arn      = "arn:aws:lambda:us-east-1:123456789012:function:athenafederatedcatalog_athena_abcdefgh"
    disable_spill_encryption = "false"
    spill_bucket             = "example-bucket"
  }
}

# 例6: カスタムコネクタ（Snowflake JDBC）
# ステップ1: テンプレート接続を定義
resource "aws_glue_connection" "custom_connector_template" {
  name            = "snowflake-template"
  connection_type = "CUSTOM"

  connection_properties = {
    CONNECTOR_CLASS_NAME = "net.snowflake.client.jdbc.SnowflakeDriver"
    CONNECTION_TYPE      = "Jdbc"
    CONNECTOR_URL        = "s3://example/snowflake-jdbc.jar"
    JDBC_CONNECTION_URL  = "[[\"default=jdbc:snowflake://example.com/?user=$${user}&password=$${password}\"],\",\"]"
  }

  match_criteria = ["template-connection"]
}

# ステップ2: テンプレートを参照する接続
resource "aws_glue_connection" "custom_connector_instance" {
  name            = "snowflake-instance"
  connection_type = "CUSTOM"

  connection_properties = {
    CONNECTOR_CLASS_NAME = "net.snowflake.client.jdbc.SnowflakeDriver"
    CONNECTION_TYPE      = "Jdbc"
    CONNECTOR_URL        = "s3://example/snowflake-jdbc.jar"
    JDBC_CONNECTION_URL  = "jdbc:snowflake://example.com/?user=$${user}&password=$${password}"
    SECRET_ID            = data.aws_secretsmanager_secret.db_credentials.name
  }

  match_criteria = ["Connection", aws_glue_connection.custom_connector_template.name]
}
