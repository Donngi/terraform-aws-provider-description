#---------------------------------------------------------------
# AWS API Gateway Stage
#---------------------------------------------------------------
#
# Amazon API Gatewayのステージをプロビジョニングするリソースです。
# ステージはデプロイメントへの名前付き参照であり、APIのスナップショットです。
# ステージを通じてキャッシュ、スロットリング、ロギング、ステージ変数、
# カナリアリリースなどの設定を管理できます。
#
# AWS公式ドキュメント:
#   - API Gateway ステージの設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-stages.html
#   - カナリアリリースデプロイメント: https://docs.aws.amazon.com/apigateway/latest/developerguide/canary-release.html
#   - ステージ変数: https://docs.aws.amazon.com/apigateway/latest/developerguide/stage-variables.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_stage" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # rest_api_id (Required)
  # 設定内容: 関連するREST APIのIDを指定します。
  # 設定可能な値: 有効なAPI Gateway REST APIのID
  rest_api_id = aws_api_gateway_rest_api.example.id

  # stage_name (Required)
  # 設定内容: ステージの名前を指定します。
  # 設定可能な値: 任意の文字列（例: dev, staging, prod）
  # 注意: ステージ名はAPIのInvoke URLの一部となります
  stage_name = "prod"

  # deployment_id (Required)
  # 設定内容: ステージが指すデプロイメントのIDを指定します。
  # 設定可能な値: 有効なAPI Gatewayデプロイメントリソースのid
  deployment_id = aws_api_gateway_deployment.example.id

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
  # ステージ設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ステージの説明を指定します。
  # 設定可能な値: 任意の文字列
  description = "Production stage for the API"

  # documentation_version (Optional)
  # 設定内容: 関連するAPIドキュメントのバージョンを指定します。
  # 設定可能な値: API Gatewayのドキュメントバージョン識別子
  documentation_version = null

  # variables (Optional)
  # 設定内容: ステージ変数を定義するマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: API Gateway ステージ変数
  #   環境変数のように機能し、API設定やマッピングテンプレートで使用可能。
  #   異なるステージで異なるバックエンドエンドポイントを呼び出すのに有用。
  #   センシティブなデータ（認証情報等）には使用せず、
  #   Lambda Authorizer経由で渡すこと。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/stage-variables.html
  variables = {
    environment = "production"
    log_level   = "INFO"
  }

  #-------------------------------------------------------------
  # キャッシュ設定
  #-------------------------------------------------------------

  # cache_cluster_enabled (Optional)
  # 設定内容: ステージに対してキャッシュクラスターを有効にするかを指定します。
  # 設定可能な値:
  #   - true: キャッシュを有効化
  #   - false: キャッシュを無効化（デフォルト）
  # 注意: キャッシュを有効にすると追加料金が発生します
  cache_cluster_enabled = false

  # cache_cluster_size (Optional)
  # 設定内容: ステージのキャッシュクラスターのサイズを指定します。
  # 設定可能な値: "0.5", "1.6", "6.1", "13.5", "28.4", "58.2", "118", "237"（GB単位）
  # 注意: cache_cluster_enabledがtrueの場合に設定が必要
  cache_cluster_size = null

  #-------------------------------------------------------------
  # クライアント証明書設定
  #-------------------------------------------------------------

  # client_certificate_id (Optional)
  # 設定内容: ステージ用のクライアント証明書の識別子を指定します。
  # 設定可能な値: 有効なAPI Gatewayクライアント証明書のID
  # 関連機能: バックエンド認証
  #   API GatewayからバックエンドへのHTTPSリクエスト時に
  #   クライアント証明書を使用してバックエンド認証を行います。
  client_certificate_id = null

  #-------------------------------------------------------------
  # X-Ray トレーシング設定
  #-------------------------------------------------------------

  # xray_tracing_enabled (Optional)
  # 設定内容: AWS X-Rayによるアクティブトレーシングを有効にするかを指定します。
  # 設定可能な値:
  #   - true: X-Rayトレーシングを有効化
  #   - false: X-Rayトレーシングを無効化（デフォルト）
  # 関連機能: AWS X-Ray
  #   API Gatewayを通過するリクエストをトレースして
  #   パフォーマンス分析やデバッグに役立てることができます。
  xray_tracing_enabled = false

  #-------------------------------------------------------------
  # アクセスログ設定
  #-------------------------------------------------------------

  # access_log_settings (Optional)
  # 設定内容: APIステージのアクセスログ設定を行います。
  # 関連機能: CloudWatch Logs アクセスログ
  #   API GatewayのアクセスログをCloudWatch LogsまたはKinesis Data Firehoseに
  #   送信してAPIの使用状況をモニタリングできます。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html
  access_log_settings {
    # destination_arn (Required)
    # 設定内容: アクセスログを受信するCloudWatch LogsロググループまたはKinesis Data Firehose配信ストリームのARNを指定します。
    # 設定可能な値:
    #   - CloudWatch Logsロググループの有効なARN
    #   - Kinesis Data Firehose配信ストリームのARN（名前は"amazon-apigateway-"で始まる必要があります）
    # 注意: 末尾の":*"は自動的に削除されます
    destination_arn = aws_cloudwatch_log_group.api_gateway_access_logs.arn

    # format (Required)
    # 設定内容: ログに記録されるフォーマットと値を指定します。
    # 設定可能な値: JSONまたはCLF形式のフォーマット文字列
    # 関連機能: アクセスログのフォーマット設定
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html
    format = jsonencode({
      requestId         = "$context.requestId"
      ip                = "$context.identity.sourceIp"
      caller            = "$context.identity.caller"
      user              = "$context.identity.user"
      requestTime       = "$context.requestTime"
      httpMethod        = "$context.httpMethod"
      resourcePath      = "$context.resourcePath"
      status            = "$context.status"
      protocol          = "$context.protocol"
      responseLength    = "$context.responseLength"
      integrationStatus = "$context.integrationStatus"
    })
  }

  #-------------------------------------------------------------
  # カナリア設定
  #-------------------------------------------------------------

  # canary_settings (Optional)
  # 設定内容: カナリアデプロイメントの設定を行います。
  # 関連機能: カナリアリリースデプロイメント
  #   新しいバージョンのAPIをテスト用にデプロイしながら、
  #   本番リリースは通常の運用を続けるソフトウェアデプロイ戦略。
  #   本番とカナリアリリース間でAPIトラフィックをランダムに分離します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/canary-release.html
  # canary_settings {
  #   # deployment_id (Required)
  #   # 設定内容: カナリアが指すデプロイメントのIDを指定します。
  #   # 設定可能な値: 有効なAPI Gatewayデプロイメントリソースのid
  #   deployment_id = aws_api_gateway_deployment.canary.id
  #
  #   # percent_traffic (Optional)
  #   # 設定内容: カナリアデプロイメントに転送するトラフィックの割合を指定します。
  #   # 設定可能な値: 0.0 - 100.0（パーセント）
  #   percent_traffic = 10.0
  #
  #   # stage_variable_overrides (Optional)
  #   # 設定内容: カナリアデプロイメント用にオーバーライドするステージ変数のマップを指定します。
  #   # 設定可能な値: キーと値のペアのマップ（新しい変数も含められます）
  #   stage_variable_overrides = {
  #     environment = "canary"
  #   }
  #
  #   # use_stage_cache (Optional)
  #   # 設定内容: カナリアデプロイメントがステージキャッシュを使用するかを指定します。
  #   # 設定可能な値:
  #   #   - true: ステージキャッシュを使用
  #   #   - false: ステージキャッシュを使用しない（デフォルト）
  #   use_stage_cache = false
  # }

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
    Name        = "production-api-stage"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ステージのAmazon Resource Name (ARN)
#
# - execution_arn: Lambda関数の呼び出しを許可する際に
#   lambda_permissionのsource_arnで使用する実行ARN
#   例: arn:aws:execute-api:eu-west-2:123456789012:z4675bid1j/prod
#
# - invoke_url: APIを呼び出すためのURL（ステージを指す）
#   例: https://z4675bid1j.execute-api.eu-west-2.amazonaws.com/prod
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - web_acl_arn: ステージに関連付けられたWebACLのARN
#---------------------------------------------------------------
