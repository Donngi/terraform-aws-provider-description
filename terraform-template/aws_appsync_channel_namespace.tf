#---------------------------------------------------------------
# AWS AppSync Channel Namespace
#---------------------------------------------------------------
#
# AWS AppSync Event APIのChannel Namespace（チャネル名前空間）を
# プロビジョニングするリソースです。
# Channel Namespaceは、関連するチャネルの機能と動作を定義し、
# 認証モードやイベントハンドラーの設定を管理します。
#
# AWS公式ドキュメント:
#   - AppSync Events概要: https://docs.aws.amazon.com/appsync/latest/eventapi/event-api-concepts.html
#   - Channel Namespace: https://docs.aws.amazon.com/appsync/latest/eventapi/channel-namespaces.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_channel_namespace
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appsync_channel_namespace" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # api_id (Required)
  # 設定内容: このChannel Namespaceを関連付けるAppSync Event APIのIDを指定します。
  # 設定可能な値: aws_appsync_apiリソースから取得されるapi_id
  api_id = aws_appsync_api.example.api_id

  # name (Required)
  # 設定内容: Channel Namespaceの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: この名前は、チャネルパスの最初のセグメント（プレフィックス）として機能します。
  #       例: 名前が"default"の場合、"/default/messages"、"/default/greetings"などの
  #       チャネルがこのNamespaceに属します。
  name = "default"

  #-------------------------------------------------------------
  # イベントハンドラー設定
  #-------------------------------------------------------------

  # code_handlers (Optional)
  # 設定内容: パブリッシュされたイベントやサブスクライブリクエストを処理する
  #          カスタムビジネスロジックを実行するイベントハンドラー関数を指定します。
  # 設定可能な値: JavaScriptで記述されたハンドラーコード文字列
  # 関連機能: AppSync Event Handler
  #   AppSync_JSランタイムで実行されるJavaScript関数。データソースと連携して
  #   外部データへのアクセスやカスタムビジネスロジックを実行できます。
  #   - https://docs.aws.amazon.com/appsync/latest/eventapi/event-api-concepts.html
  code_handlers = null

  #-------------------------------------------------------------
  # ハンドラー設定
  #-------------------------------------------------------------

  # handler_configs (Optional)
  # 設定内容: on_publishおよびon_subscribeハンドラーの設定を指定します。
  # 関連機能: Event Handler Configuration
  #   パブリッシュ時およびサブスクライブ時のハンドラー動作を定義します。
  handler_configs {

    # on_publish (Optional)
    # 設定内容: イベントがパブリッシュされた際に実行されるハンドラーの設定です。
    on_publish {

      # behavior (Required)
      # 設定内容: ハンドラーの動作を指定します。
      # 設定可能な値:
      #   - "CODE": カスタムコードハンドラーを使用して処理
      #   - "DIRECT": データソースに直接接続して処理
      behavior = "DIRECT"

      # integration (Required)
      # 設定内容: ハンドラーのデータソース統合設定です。
      integration {

        # data_source_name (Required)
        # 設定内容: APIで設定済みのデータソースの一意の名前を指定します。
        # 設定可能な値: aws_appsync_datasourceリソースで定義された名前
        data_source_name = aws_appsync_datasource.example.name

        # lambda_config (Optional)
        # 設定内容: Lambdaデータソースの設定です。
        lambda_config {

          # invoke_type (Optional)
          # 設定内容: Lambdaデータソースの呼び出しタイプを指定します。
          # 設定可能な値:
          #   - "REQUEST_RESPONSE": 同期呼び出し。Lambdaからのレスポンスを待機します。
          #   - "EVENT": 非同期呼び出し。レスポンスを待機せずに処理を継続します。
          invoke_type = "REQUEST_RESPONSE"
        }
      }
    }

    # on_subscribe (Optional)
    # 設定内容: クライアントがチャネルにサブスクライブする際に実行されるハンドラーの設定です。
    on_subscribe {

      # behavior (Required)
      # 設定内容: ハンドラーの動作を指定します。
      # 設定可能な値:
      #   - "CODE": カスタムコードハンドラーを使用して処理
      #   - "DIRECT": データソースに直接接続して処理
      behavior = "DIRECT"

      # integration (Required)
      # 設定内容: ハンドラーのデータソース統合設定です。
      integration {

        # data_source_name (Required)
        # 設定内容: APIで設定済みのデータソースの一意の名前を指定します。
        # 設定可能な値: aws_appsync_datasourceリソースで定義された名前
        data_source_name = aws_appsync_datasource.example.name

        # lambda_config (Optional)
        # 設定内容: Lambdaデータソースの設定です。
        lambda_config {

          # invoke_type (Optional)
          # 設定内容: Lambdaデータソースの呼び出しタイプを指定します。
          # 設定可能な値:
          #   - "REQUEST_RESPONSE": 同期呼び出し。Lambdaからのレスポンスを待機します。
          #   - "EVENT": 非同期呼び出し。レスポンスを待機せずに処理を継続します。
          invoke_type = "REQUEST_RESPONSE"
        }
      }
    }
  }

  #-------------------------------------------------------------
  # パブリッシュ認証モード設定
  #-------------------------------------------------------------

  # publish_auth_mode (Optional)
  # 設定内容: チャネル名前空間でのメッセージパブリッシュに使用する認証モードを指定します。
  #          この設定はデフォルトのAPI認証設定を上書きします。
  # 関連機能: AppSync Authorization
  #   Event APIで使用可能な認証メカニズムを定義します。
  #   - https://docs.aws.amazon.com/appsync/latest/eventapi/configure-event-api-auth.html
  publish_auth_mode {

    # auth_type (Required)
    # 設定内容: 認証タイプを指定します。
    # 設定可能な値:
    #   - "API_KEY": APIキー認証
    #   - "AWS_IAM": IAM認証
    #   - "AMAZON_COGNITO_USER_POOLS": Amazon Cognitoユーザープール認証
    #   - "OPENID_CONNECT": OpenID Connect認証
    #   - "AWS_LAMBDA": Lambda関数による認証
    auth_type = "API_KEY"
  }

  #-------------------------------------------------------------
  # サブスクライブ認証モード設定
  #-------------------------------------------------------------

  # subscribe_auth_mode (Optional)
  # 設定内容: チャネル名前空間でのメッセージサブスクライブに使用する認証モードを指定します。
  #          この設定はデフォルトのAPI認証設定を上書きします。
  # 関連機能: AppSync Authorization
  #   Event APIで使用可能な認証メカニズムを定義します。
  #   - https://docs.aws.amazon.com/appsync/latest/eventapi/configure-event-api-auth.html
  subscribe_auth_mode {

    # auth_type (Required)
    # 設定内容: 認証タイプを指定します。
    # 設定可能な値:
    #   - "API_KEY": APIキー認証
    #   - "AWS_IAM": IAM認証
    #   - "AMAZON_COGNITO_USER_POOLS": Amazon Cognitoユーザープール認証
    #   - "OPENID_CONNECT": OpenID Connect認証
    #   - "AWS_LAMBDA": Lambda関数による認証
    auth_type = "API_KEY"
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
    Name        = "example-channel-namespace"
    Environment = "development"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - channel_namespace_arn: Channel NamespaceのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
