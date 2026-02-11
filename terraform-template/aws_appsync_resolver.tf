#---------------------------------------------------------------
# AWS AppSync Resolver
#---------------------------------------------------------------
#
# AWS AppSyncのResolverをプロビジョニングするリソースです。
# Resolverは、GraphQL APIのフィールドをデータソースに接続し、
# リクエスト/レスポンスのマッピングテンプレートを使用してデータを変換します。
#
# AWS公式ドキュメント:
#   - AppSync概要: https://docs.aws.amazon.com/appsync/latest/devguide/what-is-appsync.html
#   - Resolverについて: https://docs.aws.amazon.com/appsync/latest/devguide/resolver-components.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_resolver
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appsync_resolver" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: GraphQL APIのIDを指定します。
  # 設定可能な値: aws_appsync_graphql_apiリソースのIDを参照
  api_id = aws_appsync_graphql_api.example.id

  # type (Required)
  # 設定内容: GraphQL APIのスキーマで定義された型名を指定します。
  # 設定可能な値: スキーマに定義されたルートタイプ名（例: Query, Mutation, Subscription）
  #              またはカスタム型名
  type = "Query"

  # field (Required)
  # 設定内容: GraphQL APIのスキーマで定義されたフィールド名を指定します。
  # 設定可能な値: 指定したtypeに定義されたフィールド名
  field = "singlePost"

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
  # Resolver種別設定
  #-------------------------------------------------------------

  # kind (Optional)
  # 設定内容: Resolverの種別を指定します。
  # 設定可能な値:
  #   - "UNIT" (デフォルト): 単一のデータソースに対してリクエストを実行
  #   - "PIPELINE": 複数のFunctionを順番に実行するパイプライン型
  # 関連機能: Pipeline Resolvers
  #   複数のデータソースへのオペレーションを順次実行可能。
  #   Functionを組み合わせて複雑なビジネスロジックを実装できます。
  #   - https://docs.aws.amazon.com/appsync/latest/devguide/pipeline-resolvers.html
  kind = "UNIT"

  #-------------------------------------------------------------
  # データソース設定
  #-------------------------------------------------------------

  # data_source (Optional)
  # 設定内容: 接続するデータソースの名前を指定します。
  # 設定可能な値: aws_appsync_datasourceリソースのname属性を参照
  # 注意: kind="UNIT"の場合に使用。kind="PIPELINE"の場合はpipeline_configを使用
  data_source = aws_appsync_datasource.example.name

  #-------------------------------------------------------------
  # マッピングテンプレート設定（VTL）
  #-------------------------------------------------------------

  # request_template (Optional)
  # 設定内容: リクエストマッピングテンプレートを指定します。
  # 設定可能な値: Apache Velocity Template Language (VTL) 形式の文字列
  # 用途:
  #   - UNIT resolver: リクエストマッピングテンプレート
  #   - PIPELINE resolver: 'before mapping template'（パイプライン実行前の処理）
  # 注意: Lambda resolvers以外では必須。codeと排他的（どちらか一方を使用）
  # 参考: https://docs.aws.amazon.com/appsync/latest/devguide/resolver-mapping-template-reference.html
  request_template = <<EOF
{
    "version": "2018-05-29",
    "method": "GET",
    "resourcePath": "/",
    "params": {
        "headers": $utils.http.copyheaders($ctx.request.headers)
    }
}
EOF

  # response_template (Optional)
  # 設定内容: レスポンスマッピングテンプレートを指定します。
  # 設定可能な値: Apache Velocity Template Language (VTL) 形式の文字列
  # 用途:
  #   - UNIT resolver: レスポンスマッピングテンプレート
  #   - PIPELINE resolver: 'after mapping template'（パイプライン実行後の処理）
  # 注意: Lambda resolvers以外では必須。codeと排他的（どちらか一方を使用）
  response_template = <<EOF
#if($ctx.result.statusCode == 200)
    $ctx.result.body
#else
    $utils.appendError($ctx.result.body, $ctx.result.statusCode)
#end
EOF

  #-------------------------------------------------------------
  # JavaScript Resolver設定（APPSYNC_JS）
  #-------------------------------------------------------------

  # code (Optional)
  # 設定内容: リクエストとレスポンス関数を含むJavaScriptコードを指定します。
  # 設定可能な値: APPSYNC_JSランタイム形式のJavaScriptコード
  # 注意: codeを使用する場合はruntimeブロックの指定が必須
  #       request_template/response_templateとは排他的（どちらか一方を使用）
  # 関連機能: JavaScript Resolvers
  #   VTLの代わりにJavaScriptでresolverロジックを記述可能。
  #   - https://docs.aws.amazon.com/appsync/latest/devguide/resolver-reference-js-version.html
  code = null

  #-------------------------------------------------------------
  # バッチ処理設定
  #-------------------------------------------------------------

  # max_batch_size (Optional)
  # 設定内容: Resolverの最大バッチサイズを指定します。
  # 設定可能な値: 0〜2000の整数
  # 省略時: バッチ処理を使用しない
  # 関連機能: Batch Resolvers
  #   複数のGraphQLリクエストを1つのデータソースリクエストにバッチ処理。
  #   DynamoDB BatchGetItemなどと連携してパフォーマンスを最適化できます。
  #   - https://docs.aws.amazon.com/appsync/latest/devguide/tutorial-batch-resolver.html
  max_batch_size = 0

  #-------------------------------------------------------------
  # キャッシング設定
  #-------------------------------------------------------------

  # caching_config (Optional)
  # 設定内容: Resolverのキャッシュ設定を指定します。
  # 関連機能: AppSync Caching
  #   API全体またはResolver単位でキャッシュを有効化できます。
  #   APIレベルでキャッシュが有効になっている必要があります。
  #   - https://docs.aws.amazon.com/appsync/latest/devguide/enabling-caching.html
  caching_config {
    # caching_keys (Optional)
    # 設定内容: キャッシュのキーとして使用する値を指定します。
    # 設定可能な値: $context.arguments, $context.source, $context.identity からのエントリ
    # 例: "$context.identity.sub", "$context.arguments.id"
    caching_keys = [
      "$context.identity.sub",
      "$context.arguments.id",
    ]

    # ttl (Optional)
    # 設定内容: キャッシュのTTL（有効期間）を秒単位で指定します。
    # 設定可能な値: 1〜3600秒
    ttl = 60
  }

  #-------------------------------------------------------------
  # パイプライン設定
  #-------------------------------------------------------------

  # pipeline_config (Optional)
  # 設定内容: PIPELINE resolverで実行するFunction一覧を指定します。
  # 注意: kind="PIPELINE"の場合に使用
  # 関連機能: Pipeline Resolvers
  #   複数のFunctionを順序付けて実行できます。
  #   - https://docs.aws.amazon.com/appsync/latest/devguide/pipeline-resolvers.html
  pipeline_config {
    # functions (Optional)
    # 設定内容: 実行するFunctionのIDリストを指定します。
    # 設定可能な値: aws_appsync_functionリソースのfunction_id属性の配列
    # 注意: 配列の順序で実行されます
    functions = [
      # aws_appsync_function.example1.function_id,
      # aws_appsync_function.example2.function_id,
    ]
  }

  #-------------------------------------------------------------
  # ランタイム設定
  #-------------------------------------------------------------

  # runtime (Optional)
  # 設定内容: JavaScript resolverのランタイム設定を指定します。
  # 注意: code属性を使用する場合は必須
  # 関連機能: APPSYNC_JS Runtime
  #   JavaScriptでresolverロジックを記述するためのランタイム環境。
  #   - https://docs.aws.amazon.com/appsync/latest/devguide/resolver-reference-js-version.html
  runtime {
    # name (Required within runtime block)
    # 設定内容: ランタイムの名前を指定します。
    # 設定可能な値: "APPSYNC_JS"（現在唯一サポートされている値）
    name = "APPSYNC_JS"

    # runtime_version (Required within runtime block)
    # 設定内容: ランタイムのバージョンを指定します。
    # 設定可能な値: "1.0.0"（現在唯一サポートされている値）
    runtime_version = "1.0.0"
  }

  #-------------------------------------------------------------
  # 同期設定（Conflict Resolution）
  #-------------------------------------------------------------

  # sync_config (Optional)
  # 設定内容: DataStore/Amplifyとの同期における競合解決設定を指定します。
  # 関連機能: Conflict Detection and Resolution
  #   オフラインデータ同期時の競合を検出・解決するための設定。
  #   Amplify DataStoreと連携する場合に使用します。
  #   - https://docs.aws.amazon.com/appsync/latest/devguide/conflict-detection-and-sync.html
  sync_config {
    # conflict_detection (Optional)
    # 設定内容: 競合検出の戦略を指定します。
    # 設定可能な値:
    #   - "NONE": 競合検出を無効化
    #   - "VERSION": バージョンベースの競合検出を有効化
    conflict_detection = "VERSION"

    # conflict_handler (Optional)
    # 設定内容: 競合発生時の解決戦略を指定します。
    # 設定可能な値:
    #   - "NONE": 競合解決を行わない
    #   - "OPTIMISTIC_CONCURRENCY": 楽観的ロックで解決（最新バージョンが優先）
    #   - "AUTOMERGE": 自動マージで解決
    #   - "LAMBDA": Lambda関数でカスタム解決ロジックを実行
    conflict_handler = "OPTIMISTIC_CONCURRENCY"

    # lambda_conflict_handler_config (Optional)
    # 設定内容: conflict_handler="LAMBDA"の場合のLambda関数設定を指定します。
    lambda_conflict_handler_config {
      # lambda_conflict_handler_arn (Optional)
      # 設定内容: 競合解決に使用するLambda関数のARNを指定します。
      # 設定可能な値: 有効なLambda関数ARN
      lambda_conflict_handler_arn = null
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ResolverのAmazon Resource Name (ARN)
#
#---------------------------------------------------------------
