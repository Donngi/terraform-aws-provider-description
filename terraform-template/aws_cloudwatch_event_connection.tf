#---------------------------------------------------------------
# AWS EventBridge Connection
#---------------------------------------------------------------
#
# Amazon EventBridgeの接続（Connection）をプロビジョニングするリソースです。
# 接続は、EventBridgeがAPI DestinationsなどのHTTPSエンドポイントに
# アクセスする際の認証方法と認証情報を定義します。
# 認証情報はAWS Secrets Managerに安全に保存・管理されます。
#
# Note: EventBridgeは以前CloudWatch Eventsとして知られていました。
#       機能は同一です。
#
# AWS公式ドキュメント:
#   - EventBridge Connections概要: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-target-connection.html
#   - 接続の作成: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-target-connection-create.html
#   - API Destinations: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-api-destinations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_connection
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_event_connection" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: 接続の名前を指定します。
  # 設定可能な値: 最大64文字。数字、大文字/小文字、.、-、_ で構成
  name = "my-api-connection"

  # description (Optional)
  # 設定内容: 接続の説明を指定します。
  # 設定可能な値: 最大512文字の文字列
  description = "Connection for external API integration"

  # authorization_type (Required)
  # 設定内容: 接続で使用する認証タイプを指定します。
  # 設定可能な値:
  #   - "API_KEY": APIキー認証。ヘッダーにAPIキーを含めて認証
  #   - "BASIC": Basic認証。ユーザー名とパスワードで認証
  #   - "OAUTH_CLIENT_CREDENTIALS": OAuthクライアント認証情報フロー
  authorization_type = "API_KEY"

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
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_identifier (Optional)
  # 設定内容: 接続の認証パラメータの暗号化に使用するKMSキーの識別子を指定します。
  # 設定可能な値:
  #   - KMSキーのARN
  #   - KeyId
  #   - キーエイリアス
  #   - キーエイリアスARN
  # 省略時: AWS所有のキーが使用されます
  # 関連機能: EventBridge Customer Managed Keys (CMK)
  #   認証情報をカスタマーマネージドキーで暗号化することで、
  #   組織のセキュリティ要件とガバナンスポリシーに準拠できます。
  #   CloudTrailでキーの使用状況を監視・監査可能です。
  kms_key_identifier = null

  #-------------------------------------------------------------
  # 認証パラメータ (auth_parameters)
  #-------------------------------------------------------------
  # 接続で使用する認証パラメータを指定します。
  # authorization_typeに応じて、api_key、basic、oauthのいずれかを設定します。
  # invocation_http_parametersは追加の認証情報として任意で設定可能です。

  auth_parameters {

    #-----------------------------------------------------------
    # API Key認証 (api_key)
    #-----------------------------------------------------------
    # authorization_type = "API_KEY" の場合に使用します。
    # basicおよびoauthと排他的です。

    api_key {
      # key (Required)
      # 設定内容: APIキーを含めるヘッダー名を指定します。
      # 設定可能な値: 任意のヘッダー名（例: x-api-key, Authorization）
      key = "x-api-key"

      # value (Required, Sensitive)
      # 設定内容: APIキーの値を指定します。
      # 設定可能な値: APIキー文字列
      # 注意: この値はAWS Secrets Managerに保存されます
      value = "your-api-key-value"
    }

    #-----------------------------------------------------------
    # Basic認証 (basic)
    #-----------------------------------------------------------
    # authorization_type = "BASIC" の場合に使用します。
    # api_keyおよびoauthと排他的です。
    # 以下はコメントアウトされた例です。

    # basic {
    #   # username (Required)
    #   # 設定内容: Basic認証のユーザー名を指定します。
    #   username = "api-user"
    #
    #   # password (Required, Sensitive)
    #   # 設定内容: Basic認証のパスワードを指定します。
    #   # 注意: この値はAWS Secrets Managerに保存されます
    #   password = "your-password"
    # }

    #-----------------------------------------------------------
    # OAuth認証 (oauth)
    #-----------------------------------------------------------
    # authorization_type = "OAUTH_CLIENT_CREDENTIALS" の場合に使用します。
    # api_keyおよびbasicと排他的です。
    # 以下はコメントアウトされた例です。

    # oauth {
    #   # authorization_endpoint (Required)
    #   # 設定内容: OAuthトークンを取得するための認証エンドポイントURLを指定します。
    #   authorization_endpoint = "https://auth.example.com/oauth/token"
    #
    #   # http_method (Required)
    #   # 設定内容: 認証エンドポイントへのリクエストで使用するHTTPメソッドを指定します。
    #   # 設定可能な値: "GET", "POST", "PUT"
    #   http_method = "POST"
    #
    #   #---------------------------------------------------------
    #   # OAuthクライアントパラメータ (client_parameters)
    #   #---------------------------------------------------------
    #   client_parameters {
    #     # client_id (Required)
    #     # 設定内容: OAuthクライアントIDを指定します。
    #     # 注意: この値はAWS Secrets Managerに保存されます
    #     client_id = "your-client-id"
    #
    #     # client_secret (Required, Sensitive)
    #     # 設定内容: OAuthクライアントシークレットを指定します。
    #     # 注意: この値はAWS Secrets Managerに保存されます
    #     client_secret = "your-client-secret"
    #   }
    #
    #   #---------------------------------------------------------
    #   # OAuth HTTPパラメータ (oauth_http_parameters)
    #   #---------------------------------------------------------
    #   # 認証エンドポイントへのリクエストに含める追加パラメータを指定します。
    #   oauth_http_parameters {
    #     # body (Optional)
    #     # リクエストボディに含める追加パラメータ（最大100個）
    #     body {
    #       # key (Optional)
    #       # 設定内容: パラメータのキー名
    #       key = "grant_type"
    #
    #       # value (Optional, Sensitive)
    #       # 設定内容: パラメータの値
    #       # 注意: is_value_secretがtrueの場合、Secrets Managerに保存されます
    #       value = "client_credentials"
    #
    #       # is_value_secret (Optional)
    #       # 設定内容: 値をシークレットとして扱うかを指定
    #       # 設定可能な値: true, false
    #       is_value_secret = false
    #     }
    #
    #     # header (Optional)
    #     # リクエストヘッダーに含める追加パラメータ（最大100個）
    #     header {
    #       key             = "Content-Type"
    #       value           = "application/x-www-form-urlencoded"
    #       is_value_secret = false
    #     }
    #
    #     # query_string (Optional)
    #     # クエリ文字列に含める追加パラメータ（最大100個）
    #     query_string {
    #       key             = "scope"
    #       value           = "read write"
    #       is_value_secret = false
    #     }
    #   }
    # }

    #-----------------------------------------------------------
    # 呼び出しHTTPパラメータ (invocation_http_parameters)
    #-----------------------------------------------------------
    # API Destinationの呼び出し時に追加される認証情報を指定します。
    # API Destination Ruleターゲットに追加のHttpParametersがある場合、
    # 値はマージされ、この接続の値が優先されます。
    # シークレット値はAWS Secrets Managerに保存・管理されます。

    # invocation_http_parameters {
    #   # body (Optional)
    #   # リクエストボディに含める追加パラメータ（最大100個）
    #   # 各パラメータはイベントペイロードサイズ（最大64KB）にカウントされます
    #   body {
    #     # key (Optional)
    #     # 設定内容: パラメータのキー名
    #     key = "additional_param"
    #
    #     # value (Optional, Sensitive)
    #     # 設定内容: パラメータの値
    #     # 注意: is_value_secretがtrueの場合、Secrets Managerに保存されます
    #     value = "param_value"
    #
    #     # is_value_secret (Optional)
    #     # 設定内容: 値をシークレットとして扱うかを指定
    #     # 設定可能な値: true, false
    #     is_value_secret = false
    #   }
    #
    #   # header (Optional)
    #   # リクエストヘッダーに含める追加パラメータ（最大100個）
    #   header {
    #     key             = "X-Custom-Header"
    #     value           = "custom-value"
    #     is_value_secret = false
    #   }
    #
    #   # query_string (Optional)
    #   # クエリ文字列に含める追加パラメータ（最大100個）
    #   query_string {
    #     key             = "api_version"
    #     value           = "v1"
    #     is_value_secret = false
    #   }
    # }
  }

  #-------------------------------------------------------------
  # 呼び出し接続パラメータ (invocation_connectivity_parameters)
  #-------------------------------------------------------------
  # プライベートAPIを呼び出すためのパラメータを指定します。
  # EventBridgeはAmazon VPC Latticeのリソース設定を使用して
  # プライベートHTTPSエンドポイントへの接続を作成します。

  # invocation_connectivity_parameters {
  #   #---------------------------------------------------------
  #   # リソースパラメータ (resource_parameters)
  #   #---------------------------------------------------------
  #   resource_parameters {
  #     # resource_configuration_arn (Required)
  #     # 設定内容: リソースエンドポイント用のAmazon VPC Latticeリソース設定のARNを指定します。
  #     # 関連リソース: aws_vpclattice_resource_configuration
  #     resource_configuration_arn = "arn:aws:vpc-lattice:ap-northeast-1:123456789012:resourceconfiguration/rcfg-1234567890abcdef0"
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 接続のAmazon Resource Name (ARN)
#
# - secret_arn: 接続の認証パラメータから作成されたシークレットの
#               Amazon Resource Name (ARN)
#               認証情報はAWS Secrets Managerに安全に保存されます。
#
# - invocation_connectivity_parameters.resource_parameters.resource_association_arn:
#               リソース関連付けのARN（invocation_connectivity_parameters使用時）
#---------------------------------------------------------------
