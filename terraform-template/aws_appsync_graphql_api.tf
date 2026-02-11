#---------------------------------------------------------------
# AWS AppSync GraphQL API
#---------------------------------------------------------------
#
# AWS AppSyncのGraphQL APIをプロビジョニングするリソースです。
# AppSyncは、リアルタイムデータ同期やオフラインアクセスをサポートする
# フルマネージドなGraphQL APIサービスを提供します。
# DynamoDB、Lambda、Elasticsearch、HTTP データソースなど
# 様々なバックエンドと統合可能です。
#
# AWS公式ドキュメント:
#   - AppSync概要: https://docs.aws.amazon.com/appsync/latest/devguide/index.html
#   - GraphQL APIの作成: https://docs.aws.amazon.com/appsync/latest/devguide/quickstart.html
#   - 設定とオプション: https://docs.aws.amazon.com/appsync/latest/devguide/configuration-and-settings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_graphql_api
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appsync_graphql_api" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: GraphQL APIのユーザー定義名を指定します。
  # 設定可能な値: 任意の文字列
  name = "example-graphql-api"

  # authentication_type (Required)
  # 設定内容: APIのプライマリ認証タイプを指定します。
  # 設定可能な値:
  #   - "API_KEY": APIキーによる認証
  #   - "AWS_IAM": AWS IAMによる認証
  #   - "AMAZON_COGNITO_USER_POOLS": Amazon Cognitoユーザープールによる認証
  #   - "OPENID_CONNECT": OpenID Connect (OIDC)による認証
  #   - "AWS_LAMBDA": Lambda関数によるカスタム認証
  authentication_type = "API_KEY"

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
  # API タイプ設定
  #-------------------------------------------------------------

  # api_type (Optional)
  # 設定内容: APIのタイプを指定します。
  # 設定可能な値:
  #   - "GRAPHQL" (デフォルト): 標準のGraphQL API
  #   - "MERGED": 複数のGraphQL APIを統合したマージAPI
  # 注意: "MERGED"を指定する場合は、merged_api_execution_role_arnの設定が必要
  api_type = "GRAPHQL"

  # merged_api_execution_role_arn (Optional)
  # 設定内容: api_typeが"MERGED"の場合に使用する実行ロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: api_typeが"MERGED"の場合にのみ必要
  merged_api_execution_role_arn = null

  #-------------------------------------------------------------
  # 可視性設定
  #-------------------------------------------------------------

  # visibility (Optional)
  # 設定内容: GraphQL APIの可視性を設定します。
  # 設定可能な値:
  #   - "GLOBAL" (デフォルト): パブリックAPI（インターネットからアクセス可能）
  #   - "PRIVATE": プライベートAPI（VPCエンドポイント経由でのみアクセス可能）
  # 注意: APIの作成後にこの値を変更することはできません
  visibility = "GLOBAL"

  #-------------------------------------------------------------
  # スキーマ設定
  #-------------------------------------------------------------

  # schema (Optional)
  # 設定内容: GraphQLスキーマ定義言語形式でスキーマを指定します。
  # 設定可能な値: GraphQLスキーマ定義言語（SDL）形式の文字列
  # 注意: Terraformはこの設定のドリフト検出を実行できません
  schema = <<EOF
schema {
  query: Query
  mutation: Mutation
}

type Query {
  getItem(id: ID!): Item
  listItems: [Item]
}

type Mutation {
  createItem(input: CreateItemInput!): Item
  updateItem(input: UpdateItemInput!): Item
  deleteItem(id: ID!): Item
}

type Item {
  id: ID!
  name: String!
  description: String
  createdAt: AWSDateTime
}

input CreateItemInput {
  name: String!
  description: String
}

input UpdateItemInput {
  id: ID!
  name: String
  description: String
}
EOF

  #-------------------------------------------------------------
  # イントロスペクションとクエリ制限設定
  #-------------------------------------------------------------

  # introspection_config (Optional)
  # 設定内容: GraphQLイントロスペクションの有効/無効を設定します。
  # 設定可能な値:
  #   - "ENABLED" (デフォルト): イントロスペクションを有効化
  #   - "DISABLED": イントロスペクションを無効化
  # 関連機能: GraphQL イントロスペクション
  #   スキーマの構造を問い合わせる機能。セキュリティ上の理由で
  #   本番環境では無効化することが推奨される場合があります。
  #   - https://graphql.org/learn/introspection/
  introspection_config = "ENABLED"

  # query_depth_limit (Optional)
  # 設定内容: 単一リクエストでのクエリの最大ネスト深度を指定します。
  # 設定可能な値:
  #   - 0 (デフォルト): 無制限
  #   - 1-75: ネストレベルの制限値
  # 用途: 深くネストされたクエリによるリソース消費を防止
  # 注意: 制限を超えるとエラーが返されます。
  #       非nullableフィールドでエラーが発生した場合、
  #       最初のnullableフィールドまでエラーが伝播します。
  query_depth_limit = 0

  # resolver_count_limit (Optional)
  # 設定内容: 単一リクエストで呼び出し可能なリゾルバーの最大数を指定します。
  # 設定可能な値:
  #   - 0 (デフォルト): 10000に設定
  #   - 1-10000: リゾルバー数の制限値
  # 用途: リクエストあたりのリゾルバー実行数を制限
  resolver_count_limit = 0

  #-------------------------------------------------------------
  # X-Ray トレーシング設定
  #-------------------------------------------------------------

  # xray_enabled (Optional)
  # 設定内容: AWS X-Rayによるトレーシングを有効にするかを指定します。
  # 設定可能な値:
  #   - true: X-Rayトレーシングを有効化
  #   - false (デフォルト): X-Rayトレーシングを無効化
  # 関連機能: AWS X-Ray
  #   リクエストのトレースと分析を行い、パフォーマンスの
  #   ボトルネックやエラーを特定するのに役立ちます。
  xray_enabled = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-graphql-api"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsと統合されたすべてのタグ。
  # 注意: 通常は明示的に設定せず、Terraformが自動的に計算します。
  # tags_all = null

  #-------------------------------------------------------------
  # Cognito User Pool 認証設定
  #-------------------------------------------------------------
  # authentication_typeが"AMAZON_COGNITO_USER_POOLS"の場合に必要

  # user_pool_config (Optional)
  # 設定内容: Amazon Cognito User Pool認証の設定を指定します。
  # user_pool_config {
  #   # default_action (Required - Cognitoがデフォルト認証の場合)
  #   # 設定内容: Cognito User Pool設定に一致しないリクエストの処理方法を指定します。
  #   # 設定可能な値:
  #   #   - "ALLOW": リクエストを許可
  #   #   - "DENY": リクエストを拒否
  #   default_action = "DENY"
  #
  #   # user_pool_id (Required)
  #   # 設定内容: Cognito User PoolのIDを指定します。
  #   user_pool_id = "ap-northeast-1_XXXXXXXXX"
  #
  #   # aws_region (Optional)
  #   # 設定内容: User Poolが作成されたAWSリージョンを指定します。
  #   # 省略時: 現在のリージョンを使用
  #   aws_region = "ap-northeast-1"
  #
  #   # app_id_client_regex (Optional)
  #   # 設定内容: Cognito User Poolアプリクライアントを検証するための正規表現を指定します。
  #   app_id_client_regex = null
  # }

  #-------------------------------------------------------------
  # OpenID Connect 認証設定
  #-------------------------------------------------------------
  # authentication_typeが"OPENID_CONNECT"の場合に必要

  # openid_connect_config (Optional)
  # 設定内容: OpenID Connect認証の設定を指定します。
  # openid_connect_config {
  #   # issuer (Required)
  #   # 設定内容: OpenID Connect設定の発行者URLを指定します。
  #   # 注意: ディスカバリから返されるissuerはIDトークンのissクレームと完全一致する必要があります。
  #   issuer = "https://example.com"
  #
  #   # client_id (Optional)
  #   # 設定内容: OpenIDプロバイダーでのRelying Partyのクライアント識別子を指定します。
  #   # 注意: 正規表現を指定して複数のクライアントIDに対して検証することも可能です。
  #   client_id = null
  #
  #   # auth_ttl (Optional)
  #   # 設定内容: 認証後にトークンが有効な期間をミリ秒で指定します。
  #   auth_ttl = null
  #
  #   # iat_ttl (Optional)
  #   # 設定内容: トークン発行後にトークンが有効な期間をミリ秒で指定します。
  #   iat_ttl = null
  # }

  #-------------------------------------------------------------
  # Lambda Authorizer 認証設定
  #-------------------------------------------------------------
  # authentication_typeが"AWS_LAMBDA"の場合に必要

  # lambda_authorizer_config (Optional)
  # 設定内容: Lambda関数によるカスタム認証の設定を指定します。
  # lambda_authorizer_config {
  #   # authorizer_uri (Required)
  #   # 設定内容: 認証に使用するLambda関数のARNを指定します。
  #   # 注意: Lambda関数にはappsync.amazonaws.comからのlambda:InvokeFunctionを
  #   #       許可するリソースベースポリシーが必要です。
  #   authorizer_uri = "arn:aws:lambda:ap-northeast-1:123456789012:function:custom_authorizer"
  #
  #   # authorizer_result_ttl_in_seconds (Optional)
  #   # 設定内容: レスポンスのキャッシュ時間を秒で指定します。
  #   # 設定可能な値: 0-3600（デフォルト: 300秒 = 5分）
  #   # 注意: 0を指定するとキャッシュが無効化されます。
  #   #       Lambda関数からttlOverrideキーを返すことでオーバーライド可能です。
  #   authorizer_result_ttl_in_seconds = 300
  #
  #   # identity_validation_expression (Optional)
  #   # 設定内容: Lambda関数呼び出し前にトークンを検証するための正規表現を指定します。
  #   identity_validation_expression = null
  # }

  #-------------------------------------------------------------
  # ログ設定
  #-------------------------------------------------------------

  # log_config (Optional)
  # 設定内容: CloudWatch Logsへのログ出力設定を指定します。
  # log_config {
  #   # cloudwatch_logs_role_arn (Required)
  #   # 設定内容: CloudWatch Logsへの書き込み権限を持つIAMロールのARNを指定します。
  #   # 注意: AWSAppSyncPushToCloudWatchLogsポリシーをアタッチしたロールを使用
  #   cloudwatch_logs_role_arn = "arn:aws:iam::123456789012:role/appsync-logs-role"
  #
  #   # field_log_level (Required)
  #   # 設定内容: フィールドレベルのログレベルを指定します。
  #   # 設定可能な値:
  #   #   - "ALL": すべてのフィールドをログ
  #   #   - "ERROR": エラーのみログ
  #   #   - "NONE": ログ無効
  #   field_log_level = "ERROR"
  #
  #   # exclude_verbose_content (Optional)
  #   # 設定内容: ヘッダー、コンテキスト、評価されたマッピングテンプレートなどの
  #   #          詳細情報をログから除外するかを指定します。
  #   # 設定可能な値:
  #   #   - true: 詳細情報を除外
  #   #   - false (デフォルト): 詳細情報を含める
  #   exclude_verbose_content = false
  # }

  #-------------------------------------------------------------
  # 拡張メトリクス設定
  #-------------------------------------------------------------

  # enhanced_metrics_config (Optional)
  # 設定内容: CloudWatchへの拡張メトリクス出力の設定を指定します。
  # enhanced_metrics_config {
  #   # data_source_level_metrics_behavior (Required)
  #   # 設定内容: データソースメトリクスのCloudWatchへの出力方法を指定します。
  #   # 設定可能な値:
  #   #   - "FULL_REQUEST_DATA_SOURCE_METRICS": リクエスト全体のデータソースメトリクス
  #   #   - "PER_DATA_SOURCE_METRICS": データソースごとのメトリクス
  #   data_source_level_metrics_behavior = "FULL_REQUEST_DATA_SOURCE_METRICS"
  #
  #   # operation_level_metrics_config (Required)
  #   # 設定内容: オペレーションメトリクスのCloudWatchへの出力を設定します。
  #   # 設定可能な値:
  #   #   - "ENABLED": オペレーションメトリクスを有効化
  #   #   - "DISABLED": オペレーションメトリクスを無効化
  #   operation_level_metrics_config = "ENABLED"
  #
  #   # resolver_level_metrics_behavior (Required)
  #   # 設定内容: リゾルバーメトリクスのCloudWatchへの出力方法を指定します。
  #   # 設定可能な値:
  #   #   - "FULL_REQUEST_RESOLVER_METRICS": リクエスト全体のリゾルバーメトリクス
  #   #   - "PER_RESOLVER_METRICS": リゾルバーごとのメトリクス
  #   resolver_level_metrics_behavior = "FULL_REQUEST_RESOLVER_METRICS"
  # }

  #-------------------------------------------------------------
  # 追加認証プロバイダー設定
  #-------------------------------------------------------------

  # additional_authentication_provider (Optional)
  # 設定内容: プライマリ認証に加えて追加の認証プロバイダーを設定します。
  # 複数のプロバイダーを設定可能です。
  # additional_authentication_provider {
  #   # authentication_type (Required)
  #   # 設定内容: 追加認証のタイプを指定します。
  #   # 設定可能な値: "API_KEY", "AWS_IAM", "AMAZON_COGNITO_USER_POOLS",
  #   #              "OPENID_CONNECT", "AWS_LAMBDA"
  #   authentication_type = "AWS_IAM"
  #
  #   # 以下のブロックは authentication_type に応じて設定
  #
  #   # user_pool_config (Optional)
  #   # authentication_typeが"AMAZON_COGNITO_USER_POOLS"の場合に設定
  #   # user_pool_config {
  #   #   user_pool_id        = "ap-northeast-1_XXXXXXXXX"
  #   #   aws_region          = "ap-northeast-1"
  #   #   app_id_client_regex = null
  #   # }
  #
  #   # openid_connect_config (Optional)
  #   # authentication_typeが"OPENID_CONNECT"の場合に設定
  #   # openid_connect_config {
  #   #   issuer    = "https://example.com"
  #   #   client_id = null
  #   #   auth_ttl  = null
  #   #   iat_ttl   = null
  #   # }
  #
  #   # lambda_authorizer_config (Optional)
  #   # authentication_typeが"AWS_LAMBDA"の場合に設定
  #   # lambda_authorizer_config {
  #   #   authorizer_uri                   = "arn:aws:lambda:ap-northeast-1:123456789012:function:custom_authorizer"
  #   #   authorizer_result_ttl_in_seconds = 300
  #   #   identity_validation_expression   = null
  #   # }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: GraphQL APIのAmazon Resource Name (ARN)
#
# - id: GraphQL APIのID
#
# - uris: APIに関連付けられたURIのマップ
#         例: uris["GRAPHQL"] = https://ID.appsync-api.REGION.amazonaws.com/graphql
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
