#---------------------------------------------------------------
# AWS AppSync Event API
#---------------------------------------------------------------
#
# AWS AppSync Event APIをプロビジョニングするリソースです。
# Event APIは、AppSyncアプリケーションでリアルタイムサブスクリプションと
# イベント駆動通信を実現するためのサーバーレスWebSocket APIを提供します。
#
# AWS公式ドキュメント:
#   - AppSync Events概要: https://docs.aws.amazon.com/appsync/latest/eventapi/event-api-concepts.html
#   - WebSocketプロトコル: https://docs.aws.amazon.com/appsync/latest/eventapi/event-api-websocket-protocol.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_api
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appsync_api" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Event APIの名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "example-event-api"

  # owner_contact (Optional)
  # 設定内容: Event APIのオーナーの連絡先情報を指定します。
  # 設定可能な値: 任意の文字列（メールアドレス、担当者名など）
  owner_contact = "api-team@example.com"

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
    Name        = "example-event-api"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # イベント設定 (event_config)
  #-------------------------------------------------------------
  # Event APIの認証、接続、ログ設定を定義します。
  # リアルタイム通信のための認証モードや、パブリッシュ・サブスクライブの
  # デフォルト認証モードを設定します。

  event_config {
    #-----------------------------------------------------------
    # 認証プロバイダー設定 (auth_provider)
    #-----------------------------------------------------------
    # Event APIで使用する認証プロバイダーのリストを定義します。
    # 複数の認証プロバイダーを設定することで、異なる認証方式を
    # サポートできます。

    auth_provider {
      # auth_type (Required)
      # 設定内容: 認証プロバイダーの種類を指定します。
      # 設定可能な値:
      #   - "API_KEY": APIキー認証
      #   - "AWS_IAM": AWS IAM認証
      #   - "AMAZON_COGNITO_USER_POOLS": Amazon Cognito User Pools認証
      #   - "OPENID_CONNECT": OpenID Connect認証
      #   - "AWS_LAMBDA": Lambda Authorizer認証
      auth_type = "API_KEY"

      #---------------------------------------------------------
      # Cognito設定 (cognito_config)
      #---------------------------------------------------------
      # auth_typeが"AMAZON_COGNITO_USER_POOLS"の場合に必要な設定です。
      # Cognito User Poolを使用した認証を構成します。

      # cognito_config {
      #   # user_pool_id (Required)
      #   # 設定内容: Cognito User PoolのIDを指定します。
      #   # 設定可能な値: 有効なCognito User Pool ID
      #   user_pool_id = "ap-northeast-1_XXXXXXXXX"
      #
      #   # aws_region (Required)
      #   # 設定内容: User Poolが存在するAWSリージョンを指定します。
      #   # 設定可能な値: 有効なAWSリージョンコード
      #   aws_region = "ap-northeast-1"
      #
      #   # app_id_client_regex (Optional)
      #   # 設定内容: クライアントIDをマッチングするための正規表現を指定します。
      #   # 設定可能な値: 有効な正規表現パターン
      #   # 用途: 特定のアプリクライアントからのリクエストのみを許可する場合に使用
      #   app_id_client_regex = null
      # }

      #---------------------------------------------------------
      # Lambda Authorizer設定 (lambda_authorizer_config)
      #---------------------------------------------------------
      # auth_typeが"AWS_LAMBDA"の場合に必要な設定です。
      # Lambda関数を使用したカスタム認証を構成します。

      # lambda_authorizer_config {
      #   # authorizer_uri (Required)
      #   # 設定内容: 認証に使用するLambda関数のARNを指定します。
      #   # 設定可能な値: 有効なLambda関数ARN
      #   authorizer_uri = "arn:aws:lambda:ap-northeast-1:123456789012:function:my-authorizer"
      #
      #   # authorizer_result_ttl_in_seconds (Optional)
      #   # 設定内容: 認証結果のキャッシュTTLを秒単位で指定します。
      #   # 設定可能な値: 数値（秒）
      #   # 省略時: デフォルト値が適用
      #   # 用途: 認証結果をキャッシュすることでLambda呼び出し回数を削減
      #   authorizer_result_ttl_in_seconds = 300
      #
      #   # identity_validation_expression (Optional)
      #   # 設定内容: IDトークンの検証に使用する正規表現を指定します。
      #   # 設定可能な値: 有効な正規表現パターン
      #   identity_validation_expression = null
      # }

      #---------------------------------------------------------
      # OpenID Connect設定 (openid_connect_config)
      #---------------------------------------------------------
      # auth_typeが"OPENID_CONNECT"の場合に必要な設定です。
      # OpenID Connectプロバイダーを使用した認証を構成します。

      # openid_connect_config {
      #   # issuer (Required)
      #   # 設定内容: OpenID ConnectプロバイダーのIssuer URLを指定します。
      #   # 設定可能な値: 有効なHTTPS URL
      #   issuer = "https://accounts.google.com"
      #
      #   # client_id (Optional)
      #   # 設定内容: OpenID ConnectプロバイダーのクライアントIDを指定します。
      #   # 設定可能な値: プロバイダーから発行されたクライアントID
      #   client_id = "your-client-id.apps.googleusercontent.com"
      #
      #   # auth_ttl (Optional)
      #   # 設定内容: 認証トークンのTTLを秒単位で指定します。
      #   # 設定可能な値: 数値（秒）
      #   # 省略時: デフォルト値が適用
      #   auth_ttl = 3600
      #
      #   # iat_ttl (Optional)
      #   # 設定内容: トークン発行時刻（iat）のTTLを秒単位で指定します。
      #   # 設定可能な値: 数値（秒）
      #   # 省略時: デフォルト値が適用
      #   iat_ttl = 3600
      # }
    }

    #-----------------------------------------------------------
    # 接続認証モード設定 (connection_auth_mode)
    #-----------------------------------------------------------
    # WebSocket接続確立時の認証モードを定義します。

    connection_auth_mode {
      # auth_type (Required)
      # 設定内容: 接続時の認証タイプを指定します。
      # 設定可能な値:
      #   - "API_KEY": APIキー認証
      #   - "AWS_IAM": AWS IAM認証
      #   - "AMAZON_COGNITO_USER_POOLS": Amazon Cognito User Pools認証
      #   - "OPENID_CONNECT": OpenID Connect認証
      #   - "AWS_LAMBDA": Lambda Authorizer認証
      auth_type = "API_KEY"
    }

    #-----------------------------------------------------------
    # デフォルトパブリッシュ認証モード設定 (default_publish_auth_mode)
    #-----------------------------------------------------------
    # イベントパブリッシュ時のデフォルト認証モードを定義します。

    default_publish_auth_mode {
      # auth_type (Required)
      # 設定内容: パブリッシュ時のデフォルト認証タイプを指定します。
      # 設定可能な値:
      #   - "API_KEY": APIキー認証
      #   - "AWS_IAM": AWS IAM認証
      #   - "AMAZON_COGNITO_USER_POOLS": Amazon Cognito User Pools認証
      #   - "OPENID_CONNECT": OpenID Connect認証
      #   - "AWS_LAMBDA": Lambda Authorizer認証
      auth_type = "API_KEY"
    }

    #-----------------------------------------------------------
    # デフォルトサブスクライブ認証モード設定 (default_subscribe_auth_mode)
    #-----------------------------------------------------------
    # イベントサブスクライブ時のデフォルト認証モードを定義します。

    default_subscribe_auth_mode {
      # auth_type (Required)
      # 設定内容: サブスクライブ時のデフォルト認証タイプを指定します。
      # 設定可能な値:
      #   - "API_KEY": APIキー認証
      #   - "AWS_IAM": AWS IAM認証
      #   - "AMAZON_COGNITO_USER_POOLS": Amazon Cognito User Pools認証
      #   - "OPENID_CONNECT": OpenID Connect認証
      #   - "AWS_LAMBDA": Lambda Authorizer認証
      auth_type = "API_KEY"
    }

    #-----------------------------------------------------------
    # ログ設定 (log_config)
    #-----------------------------------------------------------
    # CloudWatch Logsへのログ出力設定を定義します。
    # デバッグやモニタリングのためにAPI操作のログを記録できます。

    # log_config {
    #   # cloudwatch_logs_role_arn (Required)
    #   # 設定内容: CloudWatch Logsへの書き込み権限を持つIAMロールのARNを指定します。
    #   # 設定可能な値: 有効なIAMロールARN
    #   # 注意: ロールにはCloudWatch Logsへの書き込み権限が必要
    #   cloudwatch_logs_role_arn = "arn:aws:iam::123456789012:role/appsync-logs-role"
    #
    #   # log_level (Required)
    #   # 設定内容: ログレベルを指定します。
    #   # 設定可能な値:
    #   #   - "NONE": ログを記録しない
    #   #   - "ERROR": エラーのみ記録
    #   #   - "INFO": 情報レベルのログを記録
    #   #   - "DEBUG": デバッグレベルのログを記録（最も詳細）
    #   #   - "ALL": すべてのログを記録
    #   log_level = "ERROR"
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - api_id: Event APIのID
#
# - api_arn: Event APIのAmazon Resource Name (ARN)
#
# - dns: Event APIのDNS設定（マップ形式）
#        WebSocket接続やHTTPリクエストに使用するエンドポイント情報を含みます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#
# - waf_web_acl_arn: 関連付けられたWAF Web ACLのARN（設定されている場合）
#
# - xray_enabled: X-Rayトレースが有効かどうか
#---------------------------------------------------------------
