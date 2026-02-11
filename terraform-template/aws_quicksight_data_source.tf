#---------------------------------------------------------------
# AWS QuickSight Data Source
#---------------------------------------------------------------
#
# Amazon QuickSightのデータソースを管理するリソースです。
# S3、Athena、RDS、Redshift、Snowflake、Databricksなど、
# 様々なデータソースとの接続を定義します。
#
# AWS公式ドキュメント:
#   - QuickSight概要: https://docs.aws.amazon.com/quicksight/latest/user/welcome.html
#   - データソース管理: https://docs.aws.amazon.com/quicksight/latest/user/working-with-data-sources.html
#   - データソースタイプ: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateDataSource.html#QS-CreateDataSource-request-Type
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_data_source
#
# Provider Version: 6.28.0
# Generated: 2025-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_data_source" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # data_source_id (Required, Forces new resource)
  # 設定内容: データソースの識別子を指定します。
  # 設定可能な値: 文字列
  # 注意: 変更すると新しいリソースが作成されます
  data_source_id = "example-data-source-id"

  # name (Required)
  # 設定内容: データソースの名前を指定します。
  # 設定可能な値: 文字列（最大128文字）
  name = "My Data Source"

  # type (Required)
  # 設定内容: データソースのタイプを指定します。
  # 設定可能な値:
  #   - "S3": Amazon S3
  #   - "ATHENA": Amazon Athena
  #   - "AURORA": Amazon Aurora MySQL
  #   - "AURORA_POSTGRESQL": Amazon Aurora PostgreSQL
  #   - "RDS": Amazon RDS
  #   - "REDSHIFT": Amazon Redshift
  #   - "MYSQL": MySQL
  #   - "POSTGRESQL": PostgreSQL
  #   - "MARIADB": MariaDB
  #   - "ORACLE": Oracle Database
  #   - "SQLSERVER": Microsoft SQL Server
  #   - "TERADATA": Teradata
  #   - "PRESTO": Presto
  #   - "SPARK": Apache Spark
  #   - "SNOWFLAKE": Snowflake
  #   - "DATABRICKS": Databricks
  #   - "AMAZON_ELASTICSEARCH": Amazon OpenSearch Service
  #   - "AWS_IOT_ANALYTICS": AWS IoT Analytics
  #   - "JIRA": Jira
  #   - "SERVICENOW": ServiceNow
  #   - "TWITTER": Twitter
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateDataSource.html#QS-CreateDataSource-request-Type
  type = "S3"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: AWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーから自動的に決定されたアカウントIDを使用
  # 注意: 変更すると新しいリソースが作成されます
  aws_account_id = null

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
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-quicksight-data-source"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # parameters ブロック (Required)
  #-------------------------------------------------------------
  # データソースへの接続に使用するパラメータを定義します。
  # データソースタイプに応じて、以下のいずれか1つのブロックを指定します。

  parameters {
    #-----------------------------------------------------------
    # S3パラメータ (type="S3"の場合)
    #-----------------------------------------------------------
    s3 {
      # manifest_file_location ブロック (Required)
      # 設定内容: S3マニフェストファイルの場所を指定します。
      manifest_file_location {
        # bucket (Required)
        # 設定内容: マニフェストファイルを含むS3バケット名を指定します。
        # 設定可能な値: S3バケット名
        bucket = "my-bucket"

        # key (Required)
        # 設定内容: バケット内のマニフェストファイルのキー（パス）を指定します。
        # 設定可能な値: S3オブジェクトキー
        key = "path/to/manifest.json"
      }

      # role_arn (Optional)
      # 設定内容: S3データソースのIAMロールARNを指定します。
      # 設定可能な値: 有効なIAMロールARN
      # 用途: アカウント全体のロールをオーバーライドして、
      #       特定のS3データソースへのアクセスを許可する際に使用します。
      #       例えば、アカウント管理者がすべてのS3アクセスをアカウント全体の
      #       ロールで禁止している場合でも、このrole_arnを使用することで
      #       特定のS3データソースのみアクセスを許可できます。
      role_arn = null
    }

    #-----------------------------------------------------------
    # Athenaパラメータ (type="ATHENA"の場合)
    #-----------------------------------------------------------
    # athena {
    #   # work_group (Optional)
    #   # 設定内容: 接続するAthenaワークグループを指定します。
    #   # 設定可能な値: Athenaワークグループ名
    #   work_group = "primary"
    # }

    #-----------------------------------------------------------
    # Aurora MySQLパラメータ (type="AURORA"の場合)
    #-----------------------------------------------------------
    # aurora {
    #   # database (Required)
    #   # 設定内容: 接続するデータベース名を指定します。
    #   # 設定可能な値: データベース名
    #   database = "mydb"
    #
    #   # host (Required)
    #   # 設定内容: 接続するホスト名またはエンドポイントを指定します。
    #   # 設定可能な値: ホスト名またはIPアドレス
    #   host = "aurora-cluster.cluster-xxxxx.ap-northeast-1.rds.amazonaws.com"
    #
    #   # port (Required)
    #   # 設定内容: 接続するポート番号を指定します。
    #   # 設定可能な値: ポート番号（通常は3306）
    #   port = 3306
    # }

    #-----------------------------------------------------------
    # Aurora PostgreSQLパラメータ (type="AURORA_POSTGRESQL"の場合)
    #-----------------------------------------------------------
    # aurora_postgresql {
    #   # database (Required)
    #   # 設定内容: 接続するデータベース名を指定します。
    #   # 設定可能な値: データベース名
    #   database = "mydb"
    #
    #   # host (Required)
    #   # 設定内容: 接続するホスト名またはエンドポイントを指定します。
    #   # 設定可能な値: ホスト名またはIPアドレス
    #   host = "aurora-cluster.cluster-xxxxx.ap-northeast-1.rds.amazonaws.com"
    #
    #   # port (Required)
    #   # 設定内容: 接続するポート番号を指定します。
    #   # 設定可能な値: ポート番号（通常は5432）
    #   port = 5432
    # }

    #-----------------------------------------------------------
    # RDSパラメータ (type="RDS"の場合)
    #-----------------------------------------------------------
    # rds {
    #   # database (Required)
    #   # 設定内容: 接続するデータベース名を指定します。
    #   # 設定可能な値: データベース名
    #   database = "mydb"
    #
    #   # instance_id (Optional)
    #   # 設定内容: 接続するRDSインスタンスIDを指定します。
    #   # 設定可能な値: RDSインスタンスID
    #   instance_id = "my-rds-instance"
    # }

    #-----------------------------------------------------------
    # Redshiftパラメータ (type="REDSHIFT"の場合)
    #-----------------------------------------------------------
    # redshift {
    #   # database (Required)
    #   # 設定内容: 接続するデータベース名を指定します。
    #   # 設定可能な値: データベース名
    #   database = "mydb"
    #
    #   # cluster_id (Optional, Required if host and port are not provided)
    #   # 設定内容: 接続するRedshiftクラスターIDを指定します。
    #   # 設定可能な値: RedshiftクラスターID
    #   # 注意: hostとportが指定されていない場合は必須
    #   cluster_id = "my-redshift-cluster"
    #
    #   # host (Optional, Required if cluster_id is not provided)
    #   # 設定内容: 接続するホスト名またはエンドポイントを指定します。
    #   # 設定可能な値: ホスト名またはIPアドレス
    #   # 注意: cluster_idが指定されていない場合は必須
    #   host = null
    #
    #   # port (Optional, Required if cluster_id is not provided)
    #   # 設定内容: 接続するポート番号を指定します。
    #   # 設定可能な値: ポート番号（通常は5439）
    #   # 注意: cluster_idが指定されていない場合は必須
    #   port = null
    # }

    #-----------------------------------------------------------
    # MySQLパラメータ (type="MYSQL"の場合)
    #-----------------------------------------------------------
    # mysql {
    #   # database (Required)
    #   # 設定内容: 接続するデータベース名を指定します。
    #   # 設定可能な値: データベース名
    #   database = "mydb"
    #
    #   # host (Required)
    #   # 設定内容: 接続するホスト名またはIPアドレスを指定します。
    #   # 設定可能な値: ホスト名またはIPアドレス
    #   host = "mysql.example.com"
    #
    #   # port (Required)
    #   # 設定内容: 接続するポート番号を指定します。
    #   # 設定可能な値: ポート番号（通常は3306）
    #   port = 3306
    # }

    #-----------------------------------------------------------
    # PostgreSQLパラメータ (type="POSTGRESQL"の場合)
    #-----------------------------------------------------------
    # postgresql {
    #   # database (Required)
    #   # 設定内容: 接続するデータベース名を指定します。
    #   # 設定可能な値: データベース名
    #   database = "mydb"
    #
    #   # host (Required)
    #   # 設定内容: 接続するホスト名またはIPアドレスを指定します。
    #   # 設定可能な値: ホスト名またはIPアドレス
    #   host = "postgres.example.com"
    #
    #   # port (Required)
    #   # 設定内容: 接続するポート番号を指定します。
    #   # 設定可能な値: ポート番号（通常は5432）
    #   port = 5432
    # }

    #-----------------------------------------------------------
    # MariaDBパラメータ (type="MARIADB"の場合)
    #-----------------------------------------------------------
    # maria_db {
    #   # database (Required)
    #   # 設定内容: 接続するデータベース名を指定します。
    #   # 設定可能な値: データベース名
    #   database = "mydb"
    #
    #   # host (Required)
    #   # 設定内容: 接続するホスト名またはIPアドレスを指定します。
    #   # 設定可能な値: ホスト名またはIPアドレス
    #   host = "mariadb.example.com"
    #
    #   # port (Required)
    #   # 設定内容: 接続するポート番号を指定します。
    #   # 設定可能な値: ポート番号（通常は3306）
    #   port = 3306
    # }

    #-----------------------------------------------------------
    # Oracleパラメータ (type="ORACLE"の場合)
    #-----------------------------------------------------------
    # oracle {
    #   # database (Required)
    #   # 設定内容: 接続するデータベース名（SID）を指定します。
    #   # 設定可能な値: Oracle SID
    #   database = "ORCL"
    #
    #   # host (Required)
    #   # 設定内容: 接続するホスト名またはIPアドレスを指定します。
    #   # 設定可能な値: ホスト名またはIPアドレス
    #   host = "oracle.example.com"
    #
    #   # port (Required)
    #   # 設定内容: 接続するポート番号を指定します。
    #   # 設定可能な値: ポート番号（通常は1521）
    #   port = 1521
    # }

    #-----------------------------------------------------------
    # SQL Serverパラメータ (type="SQLSERVER"の場合)
    #-----------------------------------------------------------
    # sql_server {
    #   # database (Required)
    #   # 設定内容: 接続するデータベース名を指定します。
    #   # 設定可能な値: データベース名
    #   database = "mydb"
    #
    #   # host (Required)
    #   # 設定内容: 接続するホスト名またはIPアドレスを指定します。
    #   # 設定可能な値: ホスト名またはIPアドレス
    #   host = "sqlserver.example.com"
    #
    #   # port (Required)
    #   # 設定内容: 接続するポート番号を指定します。
    #   # 設定可能な値: ポート番号（通常は1433）
    #   port = 1433
    # }

    #-----------------------------------------------------------
    # Teradataパラメータ (type="TERADATA"の場合)
    #-----------------------------------------------------------
    # teradata {
    #   # database (Required)
    #   # 設定内容: 接続するデータベース名を指定します。
    #   # 設定可能な値: データベース名
    #   database = "mydb"
    #
    #   # host (Required)
    #   # 設定内容: 接続するホスト名またはIPアドレスを指定します。
    #   # 設定可能な値: ホスト名またはIPアドレス
    #   host = "teradata.example.com"
    #
    #   # port (Required)
    #   # 設定内容: 接続するポート番号を指定します。
    #   # 設定可能な値: ポート番号（通常は1025）
    #   port = 1025
    # }

    #-----------------------------------------------------------
    # Prestoパラメータ (type="PRESTO"の場合)
    #-----------------------------------------------------------
    # presto {
    #   # catalog (Required)
    #   # 設定内容: 接続するカタログ名を指定します。
    #   # 設定可能な値: カタログ名
    #   catalog = "hive"
    #
    #   # host (Required)
    #   # 設定内容: 接続するホスト名またはIPアドレスを指定します。
    #   # 設定可能な値: ホスト名またはIPアドレス
    #   host = "presto.example.com"
    #
    #   # port (Required)
    #   # 設定内容: 接続するポート番号を指定します。
    #   # 設定可能な値: ポート番号（通常は8080）
    #   port = 8080
    # }

    #-----------------------------------------------------------
    # Sparkパラメータ (type="SPARK"の場合)
    #-----------------------------------------------------------
    # spark {
    #   # host (Required)
    #   # 設定内容: 接続するホスト名またはIPアドレスを指定します。
    #   # 設定可能な値: ホスト名またはIPアドレス
    #   host = "spark.example.com"
    #
    #   # port (Required)
    #   # 設定内容: 接続するポート番号を指定します。
    #   # 設定可能な値: ポート番号（通常は10000）
    #   port = 10000
    # }

    #-----------------------------------------------------------
    # Snowflakeパラメータ (type="SNOWFLAKE"の場合)
    #-----------------------------------------------------------
    # snowflake {
    #   # database (Required)
    #   # 設定内容: 接続するデータベース名を指定します。
    #   # 設定可能な値: データベース名
    #   database = "mydb"
    #
    #   # host (Required)
    #   # 設定内容: 接続するSnowflakeアカウントのホスト名を指定します。
    #   # 設定可能な値: Snowflakeホスト名（例: account.snowflakecomputing.com）
    #   host = "account.snowflakecomputing.com"
    #
    #   # warehouse (Required)
    #   # 設定内容: 接続するSnowflakeウェアハウス名を指定します。
    #   # 設定可能な値: ウェアハウス名
    #   warehouse = "COMPUTE_WH"
    # }

    #-----------------------------------------------------------
    # Databricksパラメータ (type="DATABRICKS"の場合)
    #-----------------------------------------------------------
    # databricks {
    #   # host (Required)
    #   # 設定内容: Databricksデータソースのホスト名を指定します。
    #   # 設定可能な値: Databricksホスト名
    #   host = "dbc-xxxxx.cloud.databricks.com"
    #
    #   # port (Required)
    #   # 設定内容: Databricksデータソースのポート番号を指定します。
    #   # 設定可能な値: ポート番号（通常は443）
    #   port = 443
    #
    #   # sql_endpoint_path (Required)
    #   # 設定内容: DatabricksデータソースのHTTPパスを指定します。
    #   # 設定可能な値: SQLエンドポイントのパス
    #   sql_endpoint_path = "/sql/1.0/warehouses/xxxxx"
    # }

    #-----------------------------------------------------------
    # Amazon OpenSearch Serviceパラメータ (type="AMAZON_ELASTICSEARCH"の場合)
    #-----------------------------------------------------------
    # amazon_elasticsearch {
    #   # domain (Required)
    #   # 設定内容: OpenSearchドメイン名を指定します。
    #   # 設定可能な値: OpenSearchドメイン名
    #   domain = "my-opensearch-domain"
    # }

    #-----------------------------------------------------------
    # AWS IoT Analyticsパラメータ (type="AWS_IOT_ANALYTICS"の場合)
    #-----------------------------------------------------------
    # aws_iot_analytics {
    #   # data_set_name (Required)
    #   # 設定内容: 接続するIoT Analyticsデータセット名を指定します。
    #   # 設定可能な値: データセット名
    #   data_set_name = "my-iot-dataset"
    # }

    #-----------------------------------------------------------
    # Jiraパラメータ (type="JIRA"の場合)
    #-----------------------------------------------------------
    # jira {
    #   # site_base_url (Required)
    #   # 設定内容: JiraインスタンスのサイトベースURLを指定します。
    #   # 設定可能な値: JiraサイトURL（例: https://company.atlassian.net）
    #   site_base_url = "https://company.atlassian.net"
    # }

    #-----------------------------------------------------------
    # ServiceNowパラメータ (type="SERVICENOW"の場合)
    #-----------------------------------------------------------
    # service_now {
    #   # site_base_url (Required)
    #   # 設定内容: ServiceNowインスタンスのサイトベースURLを指定します。
    #   # 設定可能な値: ServiceNowサイトURL（例: https://company.service-now.com）
    #   site_base_url = "https://company.service-now.com"
    # }

    #-----------------------------------------------------------
    # Twitterパラメータ (type="TWITTER"の場合)
    #-----------------------------------------------------------
    # twitter {
    #   # query (Required)
    #   # 設定内容: データを取得するためのTwitterクエリを指定します。
    #   # 設定可能な値: Twitter検索クエリ文字列
    #   query = "#aws"
    #
    #   # max_rows (Required)
    #   # 設定内容: クエリする最大行数を指定します。
    #   # 設定可能な値: 正の整数
    #   max_rows = 1000
    # }
  }

  #-------------------------------------------------------------
  # credentials ブロック (Optional)
  #-------------------------------------------------------------
  # Amazon QuickSightが基盤となるソースに接続するために使用する認証情報を定義します。
  # 注意: S3やAthenaなど、IAMロールベースの認証を使用するデータソースでは不要

  # credentials {
  #   # credential_pair ブロック (Optional)
  #   # 設定内容: ユーザー名とパスワードのペアを指定します。
  #   credential_pair {
  #     # username (Required)
  #     # 設定内容: データソース接続のユーザー名を指定します。
  #     # 設定可能な値: ユーザー名文字列（最大64文字）
  #     username = "dbuser"
  #
  #     # password (Required)
  #     # 設定内容: データソース接続のパスワードを指定します。
  #     # 設定可能な値: パスワード文字列（最大1024文字）
  #     # 注意: センシティブな情報のため、変数や外部ストアからの参照を推奨
  #     password = "password123"
  #   }
  #
  #   # copy_source_arn (Optional)
  #   # 設定内容: コピー元のデータソースARNを指定します。
  #   # 設定可能な値: QuickSightデータソースのARN
  #   # 用途: 既存のデータソースの認証情報をコピーする場合に使用
  #   copy_source_arn = null
  #
  #   # secret_arn (Optional)
  #   # 設定内容: AWS Secrets Managerに保存された認証情報のARNを指定します。
  #   # 設定可能な値: Secrets ManagerシークレットのARN
  #   # 推奨: パスワードを直接指定せず、Secrets Managerを使用することを推奨
  #   secret_arn = null
  # }

  #-------------------------------------------------------------
  # permission ブロック (Optional, 複数指定可能)
  #-------------------------------------------------------------
  # データソースに対するリソースアクセス許可を定義します。
  # 最大64個まで指定可能

  # permission {
  #   # actions (Required)
  #   # 設定内容: 付与または取り消すIAMアクションのセットを指定します。
  #   # 設定可能な値: IAMアクションのリスト（最大16項目）
  #   # 利用可能なアクション:
  #   #   - "quicksight:DescribeDataSource"
  #   #   - "quicksight:DescribeDataSourcePermissions"
  #   #   - "quicksight:PassDataSource"
  #   #   - "quicksight:UpdateDataSource"
  #   #   - "quicksight:DeleteDataSource"
  #   #   - "quicksight:UpdateDataSourcePermissions"
  #   actions = [
  #     "quicksight:DescribeDataSource",
  #     "quicksight:DescribeDataSourcePermissions",
  #     "quicksight:PassDataSource",
  #   ]
  #
  #   # principal (Required)
  #   # 設定内容: プリンシパルのAmazon Resource Name (ARN)を指定します。
  #   # 設定可能な値: IAMユーザー、IAMロール、QuickSightユーザーまたはグループのARN
  #   principal = "arn:aws:quicksight:ap-northeast-1:123456789012:user/default/user-name"
  # }

  #-------------------------------------------------------------
  # ssl_properties ブロック (Optional)
  #-------------------------------------------------------------
  # Amazon QuickSightが基盤となるソースに接続する際に適用する
  # Secure Socket Layer (SSL)プロパティを定義します。

  # ssl_properties {
  #   # disable_ssl (Required)
  #   # 設定内容: SSLを無効にするかどうかを指定します。
  #   # 設定可能な値:
  #   #   - true: SSLを無効化
  #   #   - false: SSLを有効化
  #   # 注意: セキュリティ上、SSLの無効化は推奨されません
  #   disable_ssl = false
  # }

  #-------------------------------------------------------------
  # vpc_connection_properties ブロック (Optional)
  #-------------------------------------------------------------
  # VPC接続を使用してデータソースに接続する場合のプロパティを定義します。

  # vpc_connection_properties {
  #   # vpc_connection_arn (Required)
  #   # 設定内容: VPC接続のAmazon Resource Name (ARN)を指定します。
  #   # 設定可能な値: QuickSight VPC接続のARN
  #   vpc_connection_arn = "arn:aws:quicksight:ap-northeast-1:123456789012:vpcConnection/vpc-connection-id"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: データソースのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------

# 例1: S3データソース（シンプル）
# resource "aws_quicksight_data_source" "s3_simple" {
#   data_source_id = "s3-example"
#   name           = "My S3 Data"
#   type           = "S3"
#
#   parameters {
#     s3 {
#       manifest_file_location {
#         bucket = "my-bucket"
#         key    = "path/to/manifest.json"
#       }
#     }
#   }
# }

# 例2: S3データソース（IAMロール付き）
# resource "aws_quicksight_data_source" "s3_with_role" {
#   data_source_id = "s3-with-role"
#   name           = "S3 Data with Role"
#   type           = "S3"
#
#   parameters {
#     s3 {
#       manifest_file_location {
#         bucket = aws_s3_bucket.example.bucket
#         key    = aws_s3_object.manifest.key
#       }
#       role_arn = aws_iam_role.quicksight.arn
#     }
#   }
#
#   tags = {
#     Environment = "production"
#   }
# }

# 例3: RDSデータソース（認証情報付き）
# resource "aws_quicksight_data_source" "rds" {
#   data_source_id = "rds-example"
#   name           = "RDS MySQL Database"
#   type           = "RDS"
#
#   parameters {
#     rds {
#       database    = "mydb"
#       instance_id = "my-rds-instance"
#     }
#   }
#
#   credentials {
#     credential_pair {
#       username = "dbuser"
#       password = var.db_password
#     }
#   }
#
#   vpc_connection_properties {
#     vpc_connection_arn = aws_quicksight_vpc_connection.example.arn
#   }
# }

# 例4: Redshiftデータソース（クラスターID指定）
# resource "aws_quicksight_data_source" "redshift" {
#   data_source_id = "redshift-example"
#   name           = "Redshift Cluster"
#   type           = "REDSHIFT"
#
#   parameters {
#     redshift {
#       database   = "analytics"
#       cluster_id = "my-redshift-cluster"
#     }
#   }
#
#   credentials {
#     credential_pair {
#       username = "redshift_user"
#       password = var.redshift_password
#     }
#   }
# }

# 例5: Athenaデータソース
# resource "aws_quicksight_data_source" "athena" {
#   data_source_id = "athena-example"
#   name           = "Athena Data Lake"
#   type           = "ATHENA"
#
#   parameters {
#     athena {
#       work_group = "primary"
#     }
#   }
# }

# 例6: Snowflakeデータソース
# resource "aws_quicksight_data_source" "snowflake" {
#   data_source_id = "snowflake-example"
#   name           = "Snowflake DW"
#   type           = "SNOWFLAKE"
#
#   parameters {
#     snowflake {
#       database  = "ANALYTICS"
#       host      = "account.snowflakecomputing.com"
#       warehouse = "COMPUTE_WH"
#     }
#   }
#
#   credentials {
#     credential_pair {
#       username = "snowflake_user"
#       password = var.snowflake_password
#     }
#   }
# }
