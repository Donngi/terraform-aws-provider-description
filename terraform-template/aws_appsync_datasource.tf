#---------------------------------------------------------------
# AWS AppSync Data Source
#---------------------------------------------------------------
#
# AWS AppSyncのデータソースをプロビジョニングするリソースです。
# データソースは、AppSync GraphQL APIがデータを取得・操作する際に
# 接続するバックエンドサービス（DynamoDB、Lambda、HTTPエンドポイント等）を定義します。
#
# AWS公式ドキュメント:
#   - AppSync概要: https://docs.aws.amazon.com/appsync/latest/devguide/what-is-appsync.html
#   - データソース: https://docs.aws.amazon.com/appsync/latest/devguide/data-source-components.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_datasource
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appsync_datasource" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: データソースを関連付けるGraphQL APIのIDを指定します。
  # 設定可能な値: aws_appsync_graphql_apiリソースのID
  api_id = aws_appsync_graphql_api.example.id

  # name (Required)
  # 設定内容: データソースのユーザー指定名を指定します。
  # 設定可能な値: 任意の文字列
  name = "example_datasource"

  # type (Required)
  # 設定内容: データソースのタイプを指定します。
  # 設定可能な値:
  #   - "AWS_LAMBDA": Lambda関数をデータソースとして使用
  #   - "AMAZON_DYNAMODB": DynamoDBテーブルをデータソースとして使用
  #   - "AMAZON_ELASTICSEARCH": Elasticsearchドメインをデータソースとして使用（非推奨）
  #   - "AMAZON_OPENSEARCH_SERVICE": OpenSearch Serviceドメインをデータソースとして使用
  #   - "HTTP": HTTPエンドポイントをデータソースとして使用
  #   - "NONE": データソースなし（ローカルリゾルバー用）
  #   - "RELATIONAL_DATABASE": RDS Aurora Serverlessをデータソースとして使用
  #   - "AMAZON_EVENTBRIDGE": EventBridgeをデータソースとして使用
  type = "AMAZON_DYNAMODB"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: データソースの説明を指定します。
  # 設定可能な値: 任意の文字列
  description = "Example AppSync data source"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # service_role_arn (Optional)
  # 設定内容: データソースへのアクセスに使用するIAMサービスロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: typeがAWS_LAMBDA、AMAZON_DYNAMODB、AMAZON_ELASTICSEARCH、
  #       AMAZON_EVENTBRIDGE、またはAMAZON_OPENSEARCH_SERVICEの場合は必須
  service_role_arn = aws_iam_role.example.arn

  #-------------------------------------------------------------
  # DynamoDB設定 (type = "AMAZON_DYNAMODB" の場合)
  #-------------------------------------------------------------

  # dynamodb_config (Optional)
  # 設定内容: DynamoDBデータソースの設定を指定します。
  # 用途: typeが"AMAZON_DYNAMODB"の場合に使用
  dynamodb_config {
    # table_name (Required)
    # 設定内容: DynamoDBテーブルの名前を指定します。
    # 設定可能な値: 有効なDynamoDBテーブル名
    table_name = aws_dynamodb_table.example.name

    # region (Optional)
    # 設定内容: DynamoDBテーブルのAWSリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード
    # 省略時: 現在のリージョンを使用
    region = null

    # use_caller_credentials (Optional)
    # 設定内容: Amazon Cognito認証情報をこのデータソースで使用するかを指定します。
    # 設定可能な値:
    #   - true: Cognito認証情報を使用
    #   - false: サービスロールを使用
    use_caller_credentials = false

    # versioned (Optional)
    # 設定内容: このデータソースで競合検出と解決を有効にするかを指定します。
    # 設定可能な値:
    #   - true: バージョニングを有効化（Delta Sync用）
    #   - false: バージョニングを無効化
    versioned = false

    # delta_sync_config (Optional)
    # 設定内容: バージョン管理されたデータソースのDelta Sync設定を指定します。
    # 用途: オフラインクライアントの同期最適化に使用
    # delta_sync_config {
    #   # delta_sync_table_name (Required)
    #   # 設定内容: Delta Syncログを格納するテーブル名を指定します。
    #   delta_sync_table_name = "example_delta_sync"
    #
    #   # base_table_ttl (Optional)
    #   # 設定内容: ベーステーブルのアイテムを保持する時間（分）を指定します。
    #   base_table_ttl = 0
    #
    #   # delta_sync_table_ttl (Optional)
    #   # 設定内容: Delta Syncテーブルのエントリを保持する時間（分）を指定します。
    #   delta_sync_table_ttl = 60
    # }
  }

  #-------------------------------------------------------------
  # Elasticsearch設定 (type = "AMAZON_ELASTICSEARCH" の場合)
  # 注意: 非推奨。新規構築にはopensearchservice_configを使用
  #-------------------------------------------------------------

  # elasticsearch_config (Optional)
  # 設定内容: Amazon Elasticsearchデータソースの設定を指定します。
  # 用途: typeが"AMAZON_ELASTICSEARCH"の場合に使用
  # elasticsearch_config {
  #   # endpoint (Required)
  #   # 設定内容: ElasticsearchドメインのHTTPエンドポイントを指定します。
  #   endpoint = "https://search-example-xxxxx.ap-northeast-1.es.amazonaws.com"
  #
  #   # region (Optional)
  #   # 設定内容: ElasticsearchドメインのAWSリージョンを指定します。
  #   # 省略時: 現在のリージョンを使用
  #   region = null
  # }

  #-------------------------------------------------------------
  # OpenSearch Service設定 (type = "AMAZON_OPENSEARCH_SERVICE" の場合)
  #-------------------------------------------------------------

  # opensearchservice_config (Optional)
  # 設定内容: Amazon OpenSearch Serviceデータソースの設定を指定します。
  # 用途: typeが"AMAZON_OPENSEARCH_SERVICE"の場合に使用
  # opensearchservice_config {
  #   # endpoint (Required)
  #   # 設定内容: OpenSearch ServiceドメインのHTTPエンドポイントを指定します。
  #   endpoint = "https://search-example-xxxxx.ap-northeast-1.aoss.amazonaws.com"
  #
  #   # region (Optional)
  #   # 設定内容: OpenSearch ServiceドメインのAWSリージョンを指定します。
  #   # 省略時: 現在のリージョンを使用
  #   region = null
  # }

  #-------------------------------------------------------------
  # EventBridge設定 (type = "AMAZON_EVENTBRIDGE" の場合)
  #-------------------------------------------------------------

  # event_bridge_config (Optional)
  # 設定内容: AWS EventBridgeデータソースの設定を指定します。
  # 用途: typeが"AMAZON_EVENTBRIDGE"の場合に使用
  # event_bridge_config {
  #   # event_bus_arn (Required)
  #   # 設定内容: EventBridgeバスのARNを指定します。
  #   event_bus_arn = aws_cloudwatch_event_bus.example.arn
  # }

  #-------------------------------------------------------------
  # HTTP設定 (type = "HTTP" の場合)
  #-------------------------------------------------------------

  # http_config (Optional)
  # 設定内容: HTTPデータソースの設定を指定します。
  # 用途: typeが"HTTP"の場合に使用
  # http_config {
  #   # endpoint (Required)
  #   # 設定内容: HTTPエンドポイントのURLを指定します。
  #   endpoint = "https://api.example.com"
  #
  #   # authorization_config (Optional)
  #   # 設定内容: HTTPエンドポイントが認証を必要とする場合の設定を指定します。
  #   # authorization_config {
  #   #   # authorization_type (Optional)
  #   #   # 設定内容: HTTPエンドポイントが必要とする認証タイプを指定します。
  #   #   # 設定可能な値:
  #   #   #   - "AWS_IAM": IAM認証を使用
  #   #   # 省略時: "AWS_IAM"
  #   #   authorization_type = "AWS_IAM"
  #   #
  #   #   # aws_iam_config (Optional)
  #   #   # 設定内容: IAM認証の設定を指定します。
  #   #   # aws_iam_config {
  #   #   #   # signing_region (Optional)
  #   #   #   # 設定内容: IAM認証のための署名リージョンを指定します。
  #   #   #   signing_region = "ap-northeast-1"
  #   #   #
  #   #   #   # signing_service_name (Optional)
  #   #   #   # 設定内容: IAM認証のための署名サービス名を指定します。
  #   #   #   signing_service_name = "execute-api"
  #   #   # }
  #   # }
  # }

  #-------------------------------------------------------------
  # Lambda設定 (type = "AWS_LAMBDA" の場合)
  #-------------------------------------------------------------

  # lambda_config (Optional)
  # 設定内容: AWS Lambdaデータソースの設定を指定します。
  # 用途: typeが"AWS_LAMBDA"の場合に使用
  # lambda_config {
  #   # function_arn (Required)
  #   # 設定内容: Lambda関数のARNを指定します。
  #   function_arn = aws_lambda_function.example.arn
  # }

  #-------------------------------------------------------------
  # リレーショナルデータベース設定 (type = "RELATIONAL_DATABASE" の場合)
  #-------------------------------------------------------------

  # relational_database_config (Optional)
  # 設定内容: リレーショナルデータベースデータソースの設定を指定します。
  # 用途: typeが"RELATIONAL_DATABASE"の場合に使用（Aurora Serverless v1対応）
  # relational_database_config {
  #   # source_type (Optional)
  #   # 設定内容: リレーショナルデータベースのソースタイプを指定します。
  #   # 設定可能な値:
  #   #   - "RDS_HTTP_ENDPOINT": RDS Data APIを使用
  #   source_type = "RDS_HTTP_ENDPOINT"
  #
  #   # http_endpoint_config (Optional)
  #   # 設定内容: Amazon RDS HTTPエンドポイントの設定を指定します。
  #   # http_endpoint_config {
  #   #   # db_cluster_identifier (Required)
  #   #   # 設定内容: Amazon RDSクラスター識別子を指定します。
  #   #   db_cluster_identifier = aws_rds_cluster.example.cluster_identifier
  #   #
  #   #   # aws_secret_store_arn (Required)
  #   #   # 設定内容: データベース認証情報を含むAWS Secrets ManagerシークレットのARNを指定します。
  #   #   aws_secret_store_arn = aws_secretsmanager_secret.example.arn
  #   #
  #   #   # database_name (Optional)
  #   #   # 設定内容: 論理データベース名を指定します。
  #   #   database_name = "mydb"
  #   #
  #   #   # region (Optional)
  #   #   # 設定内容: RDS HTTPエンドポイントのAWSリージョンを指定します。
  #   #   # 省略時: 現在のリージョンを使用
  #   #   region = null
  #   #
  #   #   # schema (Optional)
  #   #   # 設定内容: 論理スキーマ名を指定します。
  #   #   schema = "public"
  #   # }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: データソースのAmazon Resource Name (ARN)
#---------------------------------------------------------------
