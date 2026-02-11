#---------------------------------------------------------------
# AWS AppFlow Connector Profile
#---------------------------------------------------------------
#
# Amazon AppFlowのコネクタプロファイル（接続）をプロビジョニングするリソースです。
# コネクタプロファイルは、ソースまたはデスティネーションアプリケーションへの
# 接続に必要な設定詳細と認証情報を保存します。一度作成したコネクタプロファイルは
# 新規または既存のフローに割り当てて再利用できます。
#
# AWS公式ドキュメント:
#   - Amazon AppFlow概要: https://docs.aws.amazon.com/appflow/latest/userguide/what-is-appflow.html
#   - 接続の管理: https://docs.aws.amazon.com/appflow/latest/userguide/connections.html
#   - CreateConnectorProfile API: https://docs.aws.amazon.com/appflow/1.0/APIReference/API_CreateConnectorProfile.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appflow_connector_profile
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appflow_connector_profile" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: コネクタプロファイルの名前を指定します。
  # 設定可能な値: 一意の文字列
  name = "example-connector-profile"

  # connector_type (Required)
  # 設定内容: コネクタの種類を指定します。
  # 設定可能な値:
  #   - "Amplitude": Amplitude
  #   - "CustomConnector": カスタムコネクタ
  #   - "Datadog": Datadog
  #   - "Dynatrace": Dynatrace
  #   - "Googleanalytics": Google Analytics
  #   - "Honeycode": Amazon Honeycode
  #   - "Infornexus": Infor Nexus
  #   - "Marketo": Marketo
  #   - "Redshift": Amazon Redshift
  #   - "Salesforce": Salesforce
  #   - "SAPOData": SAP OData
  #   - "Servicenow": ServiceNow
  #   - "Singular": Singular
  #   - "Slack": Slack
  #   - "Snowflake": Snowflake
  #   - "Trendmicro": Trend Micro
  #   - "Veeva": Veeva
  #   - "Zendesk": Zendesk
  connector_type = "Redshift"

  # connection_mode (Required)
  # 設定内容: 接続モードを指定します。
  # 設定可能な値:
  #   - "Public": パブリック接続。インターネット経由で接続します。
  #   - "Private": プライベート接続。AWS PrivateLinkを使用してVPC内で接続します。
  connection_mode = "Public"

  # connector_label (Optional)
  # 設定内容: カスタムコネクタを使用する場合のラベルを指定します。
  # 設定可能な値: 文字列
  # 注意: connector_typeが"CustomConnector"の場合にのみ使用します。
  connector_label = null

  # kms_arn (Optional)
  # 設定内容: コネクタプロファイルのデータ暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWSマネージドキーを使用
  kms_arn = null

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
  # コネクタプロファイル設定
  #-------------------------------------------------------------

  # connector_profile_config (Required)
  # 設定内容: コネクタプロファイルの設定ブロックです。
  #          認証情報とプロパティの両方を含みます。
  connector_profile_config {

    #-----------------------------------------------------------
    # 認証情報設定
    #-----------------------------------------------------------

    # connector_profile_credentials (Required)
    # 設定内容: コネクタの認証情報を指定します。
    #          connector_typeに応じたブロックを1つ指定します。
    connector_profile_credentials {

      #---------------------------------------------------------
      # Amplitude認証情報
      #---------------------------------------------------------
      # amplitude {
      #   # api_key (Required)
      #   # 設定内容: AmplitudeのAPIキーを指定します。
      #   api_key = "your-api-key"
      #
      #   # secret_key (Required, Sensitive)
      #   # 設定内容: Amplitudeのシークレットキーを指定します。
      #   secret_key = "your-secret-key"
      # }

      #---------------------------------------------------------
      # CustomConnector認証情報
      #---------------------------------------------------------
      # custom_connector {
      #   # authentication_type (Required)
      #   # 設定内容: 認証タイプを指定します。
      #   # 設定可能な値:
      #   #   - "API_KEY": APIキー認証
      #   #   - "BASIC": ベーシック認証
      #   #   - "CUSTOM": カスタム認証
      #   #   - "OAUTH2": OAuth2認証
      #   authentication_type = "OAUTH2"
      #
      #   # api_key (Optional)
      #   # 設定内容: APIキー認証の設定ブロック
      #   # api_key {
      #   #   # api_key (Required)
      #   #   api_key = "your-api-key"
      #   #
      #   #   # api_secret_key (Optional)
      #   #   api_secret_key = "your-api-secret-key"
      #   # }
      #
      #   # basic (Optional)
      #   # 設定内容: ベーシック認証の設定ブロック
      #   # basic {
      #   #   # username (Required)
      #   #   username = "username"
      #   #
      #   #   # password (Required, Sensitive)
      #   #   password = "password"
      #   # }
      #
      #   # custom (Optional)
      #   # 設定内容: カスタム認証の設定ブロック
      #   # custom {
      #   #   # custom_authentication_type (Required)
      #   #   custom_authentication_type = "custom-auth-type"
      #   #
      #   #   # credentials_map (Optional, Sensitive)
      #   #   credentials_map = {
      #   #     key1 = "value1"
      #   #   }
      #   # }
      #
      #   # oauth2 (Optional)
      #   # 設定内容: OAuth2認証の設定ブロック
      #   # oauth2 {
      #   #   # access_token (Optional, Sensitive)
      #   #   access_token = "access-token"
      #   #
      #   #   # client_id (Optional)
      #   #   client_id = "client-id"
      #   #
      #   #   # client_secret (Optional, Sensitive)
      #   #   client_secret = "client-secret"
      #   #
      #   #   # refresh_token (Optional)
      #   #   refresh_token = "refresh-token"
      #   #
      #   #   # oauth_request (Optional)
      #   #   # oauth_request {
      #   #   #   # auth_code (Optional)
      #   #   #   auth_code = "auth-code"
      #   #   #
      #   #   #   # redirect_uri (Optional)
      #   #   #   redirect_uri = "https://example.com/callback"
      #   #   # }
      #   # }
      # }

      #---------------------------------------------------------
      # Datadog認証情報
      #---------------------------------------------------------
      # datadog {
      #   # api_key (Required)
      #   # 設定内容: DatadogのAPIキーを指定します。
      #   api_key = "your-api-key"
      #
      #   # application_key (Required)
      #   # 設定内容: Datadogのアプリケーションキーを指定します。
      #   application_key = "your-application-key"
      # }

      #---------------------------------------------------------
      # Dynatrace認証情報
      #---------------------------------------------------------
      # dynatrace {
      #   # api_token (Required)
      #   # 設定内容: DynatraceのAPIトークンを指定します。
      #   api_token = "your-api-token"
      # }

      #---------------------------------------------------------
      # Google Analytics認証情報
      #---------------------------------------------------------
      # google_analytics {
      #   # client_id (Required)
      #   # 設定内容: Google AnalyticsのクライアントIDを指定します。
      #   client_id = "client-id"
      #
      #   # client_secret (Required, Sensitive)
      #   # 設定内容: Google Analyticsのクライアントシークレットを指定します。
      #   client_secret = "client-secret"
      #
      #   # access_token (Optional, Sensitive)
      #   # 設定内容: アクセストークンを指定します。
      #   access_token = null
      #
      #   # refresh_token (Optional)
      #   # 設定内容: リフレッシュトークンを指定します。
      #   refresh_token = null
      #
      #   # oauth_request (Optional)
      #   # oauth_request {
      #   #   # auth_code (Optional)
      #   #   auth_code = "auth-code"
      #   #
      #   #   # redirect_uri (Optional)
      #   #   redirect_uri = "https://example.com/callback"
      #   # }
      # }

      #---------------------------------------------------------
      # Honeycode認証情報
      #---------------------------------------------------------
      # honeycode {
      #   # access_token (Optional, Sensitive)
      #   # 設定内容: アクセストークンを指定します。
      #   access_token = null
      #
      #   # refresh_token (Optional)
      #   # 設定内容: リフレッシュトークンを指定します。
      #   refresh_token = null
      #
      #   # oauth_request (Optional)
      #   # oauth_request {
      #   #   # auth_code (Optional)
      #   #   auth_code = "auth-code"
      #   #
      #   #   # redirect_uri (Optional)
      #   #   redirect_uri = "https://example.com/callback"
      #   # }
      # }

      #---------------------------------------------------------
      # Infor Nexus認証情報
      #---------------------------------------------------------
      # infor_nexus {
      #   # access_key_id (Required)
      #   # 設定内容: アクセスキーIDを指定します。
      #   access_key_id = "access-key-id"
      #
      #   # datakey (Required)
      #   # 設定内容: データキーを指定します。
      #   datakey = "datakey"
      #
      #   # secret_access_key (Required, Sensitive)
      #   # 設定内容: シークレットアクセスキーを指定します。
      #   secret_access_key = "secret-access-key"
      #
      #   # user_id (Required)
      #   # 設定内容: ユーザーIDを指定します。
      #   user_id = "user-id"
      # }

      #---------------------------------------------------------
      # Marketo認証情報
      #---------------------------------------------------------
      # marketo {
      #   # client_id (Required)
      #   # 設定内容: MarketoのクライアントIDを指定します。
      #   client_id = "client-id"
      #
      #   # client_secret (Required, Sensitive)
      #   # 設定内容: Marketoのクライアントシークレットを指定します。
      #   client_secret = "client-secret"
      #
      #   # access_token (Optional, Sensitive)
      #   # 設定内容: アクセストークンを指定します。
      #   access_token = null
      #
      #   # oauth_request (Optional)
      #   # oauth_request {
      #   #   # auth_code (Optional)
      #   #   auth_code = "auth-code"
      #   #
      #   #   # redirect_uri (Optional)
      #   #   redirect_uri = "https://example.com/callback"
      #   # }
      # }

      #---------------------------------------------------------
      # Redshift認証情報
      #---------------------------------------------------------
      redshift {
        # username (Required)
        # 設定内容: Redshiftのユーザー名を指定します。
        username = "admin"

        # password (Required, Sensitive)
        # 設定内容: Redshiftのパスワードを指定します。
        password = "your-password"
      }

      #---------------------------------------------------------
      # Salesforce認証情報
      #---------------------------------------------------------
      # salesforce {
      #   # access_token (Optional, Sensitive)
      #   # 設定内容: アクセストークンを指定します。
      #   access_token = null
      #
      #   # client_credentials_arn (Optional)
      #   # 設定内容: Secrets Managerに保存されたクライアント認証情報のARNを指定します。
      #   client_credentials_arn = null
      #
      #   # jwt_token (Optional)
      #   # 設定内容: JWTトークンを指定します。
      #   jwt_token = null
      #
      #   # oauth2_grant_type (Optional)
      #   # 設定内容: OAuth2のグラントタイプを指定します。
      #   # 設定可能な値:
      #   #   - "AUTHORIZATION_CODE": 認可コードグラント
      #   #   - "CLIENT_CREDENTIALS": クライアントクレデンシャルグラント
      #   #   - "JWT_BEARER": JWTベアラーグラント
      #   oauth2_grant_type = null
      #
      #   # refresh_token (Optional)
      #   # 設定内容: リフレッシュトークンを指定します。
      #   refresh_token = null
      #
      #   # oauth_request (Optional)
      #   # oauth_request {
      #   #   # auth_code (Optional)
      #   #   auth_code = "auth-code"
      #   #
      #   #   # redirect_uri (Optional)
      #   #   redirect_uri = "https://example.com/callback"
      #   # }
      # }

      #---------------------------------------------------------
      # SAP OData認証情報
      #---------------------------------------------------------
      # sapo_data {
      #   # basic_auth_credentials (Optional)
      #   # 設定内容: ベーシック認証の設定ブロック
      #   # basic_auth_credentials {
      #   #   # username (Required)
      #   #   username = "username"
      #   #
      #   #   # password (Required, Sensitive)
      #   #   password = "password"
      #   # }
      #
      #   # oauth_credentials (Optional)
      #   # 設定内容: OAuth認証の設定ブロック
      #   # oauth_credentials {
      #   #   # client_id (Required)
      #   #   client_id = "client-id"
      #   #
      #   #   # client_secret (Required)
      #   #   client_secret = "client-secret"
      #   #
      #   #   # access_token (Optional, Sensitive)
      #   #   access_token = null
      #   #
      #   #   # refresh_token (Optional)
      #   #   refresh_token = null
      #   #
      #   #   # oauth_request (Optional)
      #   #   # oauth_request {
      #   #   #   # auth_code (Optional)
      #   #   #   auth_code = "auth-code"
      #   #   #
      #   #   #   # redirect_uri (Optional)
      #   #   #   redirect_uri = "https://example.com/callback"
      #   #   # }
      #   # }
      # }

      #---------------------------------------------------------
      # ServiceNow認証情報
      #---------------------------------------------------------
      # service_now {
      #   # username (Required)
      #   # 設定内容: ServiceNowのユーザー名を指定します。
      #   username = "username"
      #
      #   # password (Required, Sensitive)
      #   # 設定内容: ServiceNowのパスワードを指定します。
      #   password = "password"
      # }

      #---------------------------------------------------------
      # Singular認証情報
      #---------------------------------------------------------
      # singular {
      #   # api_key (Required)
      #   # 設定内容: SingularのAPIキーを指定します。
      #   api_key = "your-api-key"
      # }

      #---------------------------------------------------------
      # Slack認証情報
      #---------------------------------------------------------
      # slack {
      #   # client_id (Required)
      #   # 設定内容: SlackのクライアントIDを指定します。
      #   client_id = "client-id"
      #
      #   # client_secret (Required, Sensitive)
      #   # 設定内容: Slackのクライアントシークレットを指定します。
      #   client_secret = "client-secret"
      #
      #   # access_token (Optional, Sensitive)
      #   # 設定内容: アクセストークンを指定します。
      #   access_token = null
      #
      #   # oauth_request (Optional)
      #   # oauth_request {
      #   #   # auth_code (Optional)
      #   #   auth_code = "auth-code"
      #   #
      #   #   # redirect_uri (Optional)
      #   #   redirect_uri = "https://example.com/callback"
      #   # }
      # }

      #---------------------------------------------------------
      # Snowflake認証情報
      #---------------------------------------------------------
      # snowflake {
      #   # username (Required)
      #   # 設定内容: Snowflakeのユーザー名を指定します。
      #   username = "username"
      #
      #   # password (Required, Sensitive)
      #   # 設定内容: Snowflakeのパスワードを指定します。
      #   password = "password"
      # }

      #---------------------------------------------------------
      # Trend Micro認証情報
      #---------------------------------------------------------
      # trendmicro {
      #   # api_secret_key (Required, Sensitive)
      #   # 設定内容: Trend MicroのAPIシークレットキーを指定します。
      #   api_secret_key = "your-api-secret-key"
      # }

      #---------------------------------------------------------
      # Veeva認証情報
      #---------------------------------------------------------
      # veeva {
      #   # username (Required)
      #   # 設定内容: Veevaのユーザー名を指定します。
      #   username = "username"
      #
      #   # password (Required, Sensitive)
      #   # 設定内容: Veevaのパスワードを指定します。
      #   password = "password"
      # }

      #---------------------------------------------------------
      # Zendesk認証情報
      #---------------------------------------------------------
      # zendesk {
      #   # client_id (Required)
      #   # 設定内容: ZendeskのクライアントIDを指定します。
      #   client_id = "client-id"
      #
      #   # client_secret (Required, Sensitive)
      #   # 設定内容: Zendeskのクライアントシークレットを指定します。
      #   client_secret = "client-secret"
      #
      #   # access_token (Optional, Sensitive)
      #   # 設定内容: アクセストークンを指定します。
      #   access_token = null
      #
      #   # oauth_request (Optional)
      #   # oauth_request {
      #   #   # auth_code (Optional)
      #   #   auth_code = "auth-code"
      #   #
      #   #   # redirect_uri (Optional)
      #   #   redirect_uri = "https://example.com/callback"
      #   # }
      # }
    }

    #-----------------------------------------------------------
    # プロパティ設定
    #-----------------------------------------------------------

    # connector_profile_properties (Required)
    # 設定内容: コネクタのプロパティを指定します。
    #          connector_typeに応じたブロックを1つ指定します。
    connector_profile_properties {

      #---------------------------------------------------------
      # Amplitudeプロパティ
      #---------------------------------------------------------
      # amplitude {
      #   # プロパティなし（空のブロック）
      # }

      #---------------------------------------------------------
      # CustomConnectorプロパティ
      #---------------------------------------------------------
      # custom_connector {
      #   # profile_properties (Optional)
      #   # 設定内容: カスタムコネクタのプロファイルプロパティを指定します。
      #   profile_properties = {
      #     key1 = "value1"
      #   }
      #
      #   # oauth2_properties (Optional)
      #   # 設定内容: OAuth2プロパティの設定ブロック
      #   # oauth2_properties {
      #   #   # oauth2_grant_type (Required)
      #   #   # 設定可能な値:
      #   #   #   - "AUTHORIZATION_CODE": 認可コードグラント
      #   #   #   - "CLIENT_CREDENTIALS": クライアントクレデンシャルグラント
      #   #   oauth2_grant_type = "AUTHORIZATION_CODE"
      #   #
      #   #   # token_url (Required)
      #   #   # 設定内容: トークンエンドポイントのURLを指定します。
      #   #   token_url = "https://example.com/oauth/token"
      #   #
      #   #   # token_url_custom_properties (Optional)
      #   #   # 設定内容: トークンURLのカスタムプロパティを指定します。
      #   #   token_url_custom_properties = {
      #   #     key1 = "value1"
      #   #   }
      #   # }
      # }

      #---------------------------------------------------------
      # Datadogプロパティ
      #---------------------------------------------------------
      # datadog {
      #   # instance_url (Required)
      #   # 設定内容: DatadogインスタンスのURLを指定します。
      #   # 設定可能な値: 有効なDatadog URL（例: https://api.datadoghq.com）
      #   instance_url = "https://api.datadoghq.com"
      # }

      #---------------------------------------------------------
      # Dynatraceプロパティ
      #---------------------------------------------------------
      # dynatrace {
      #   # instance_url (Required)
      #   # 設定内容: DynatraceインスタンスのURLを指定します。
      #   instance_url = "https://your-instance.live.dynatrace.com"
      # }

      #---------------------------------------------------------
      # Google Analyticsプロパティ
      #---------------------------------------------------------
      # google_analytics {
      #   # プロパティなし（空のブロック）
      # }

      #---------------------------------------------------------
      # Honeycodeプロパティ
      #---------------------------------------------------------
      # honeycode {
      #   # プロパティなし（空のブロック）
      # }

      #---------------------------------------------------------
      # Infor Nexusプロパティ
      #---------------------------------------------------------
      # infor_nexus {
      #   # instance_url (Required)
      #   # 設定内容: Infor NexusインスタンスのURLを指定します。
      #   instance_url = "https://your-instance.infornexus.com"
      # }

      #---------------------------------------------------------
      # Marketoプロパティ
      #---------------------------------------------------------
      # marketo {
      #   # instance_url (Required)
      #   # 設定内容: MarketoインスタンスのURLを指定します。
      #   instance_url = "https://your-instance.mktorest.com"
      # }

      #---------------------------------------------------------
      # Redshiftプロパティ
      #---------------------------------------------------------
      redshift {
        # bucket_name (Required)
        # 設定内容: 中間ストレージ用のS3バケット名を指定します。
        # 用途: RedshiftへのCOPYコマンド実行時の中間ストレージとして使用されます。
        bucket_name = "example-bucket"

        # role_arn (Required)
        # 設定内容: Redshiftがデータにアクセスするために使用するIAMロールのARNを指定します。
        role_arn = "arn:aws:iam::123456789012:role/RedshiftAppFlowRole"

        # bucket_prefix (Optional)
        # 設定内容: S3バケット内のプレフィックスを指定します。
        bucket_prefix = null

        # cluster_identifier (Optional)
        # 設定内容: Redshiftクラスター識別子を指定します。
        # 注意: database_urlを使用しない場合に指定します。
        cluster_identifier = null

        # data_api_role_arn (Optional)
        # 設定内容: Redshift Data APIを使用するためのIAMロールのARNを指定します。
        data_api_role_arn = null

        # database_name (Optional)
        # 設定内容: データベース名を指定します。
        # 注意: database_urlを使用しない場合に指定します。
        database_name = null

        # database_url (Optional)
        # 設定内容: RedshiftデータベースのJDBC URLを指定します。
        # 設定可能な値: jdbc:redshift://<endpoint>/<database_name>
        database_url = "jdbc:redshift://example-cluster.xxxxxxxxxxxx.ap-northeast-1.redshift.amazonaws.com:5439/example_db"
      }

      #---------------------------------------------------------
      # Salesforceプロパティ
      #---------------------------------------------------------
      # salesforce {
      #   # instance_url (Optional)
      #   # 設定内容: SalesforceインスタンスのURLを指定します。
      #   instance_url = null
      #
      #   # is_sandbox_environment (Optional)
      #   # 設定内容: サンドボックス環境かどうかを指定します。
      #   # 設定可能な値:
      #   #   - true: サンドボックス環境
      #   #   - false: 本番環境（デフォルト）
      #   is_sandbox_environment = false
      #
      #   # use_privatelink_for_metadata_and_authorization (Optional)
      #   # 設定内容: メタデータと認可にPrivateLinkを使用するかを指定します。
      #   # 設定可能な値:
      #   #   - true: PrivateLinkを使用。すべての通信がプライベートネットワーク経由。
      #   #   - false: デフォルト。一部の通信はパブリックインターネット経由。
      #   use_privatelink_for_metadata_and_authorization = false
      # }

      #---------------------------------------------------------
      # SAP ODataプロパティ
      #---------------------------------------------------------
      # sapo_data {
      #   # application_host_url (Required)
      #   # 設定内容: SAP ODataアプリケーションホストのURLを指定します。
      #   application_host_url = "https://your-sap-instance.example.com"
      #
      #   # application_service_path (Required)
      #   # 設定内容: SAP ODataサービスパスを指定します。
      #   application_service_path = "/sap/opu/odata/example/path"
      #
      #   # client_number (Required)
      #   # 設定内容: SAPクライアント番号を指定します。
      #   client_number = "100"
      #
      #   # port_number (Required)
      #   # 設定内容: ポート番号を指定します。
      #   port_number = 443
      #
      #   # logon_language (Optional)
      #   # 設定内容: ログオン言語を指定します（例: EN, JA）。
      #   logon_language = "EN"
      #
      #   # private_link_service_name (Optional)
      #   # 設定内容: PrivateLinkサービス名を指定します。
      #   private_link_service_name = null
      #
      #   # oauth_properties (Optional)
      #   # 設定内容: OAuthプロパティの設定ブロック
      #   # oauth_properties {
      #   #   # auth_code_url (Required)
      #   #   # 設定内容: 認可コードURLを指定します。
      #   #   auth_code_url = "https://example.com/oauth/authorize"
      #   #
      #   #   # oauth_scopes (Required)
      #   #   # 設定内容: OAuthスコープのリストを指定します。
      #   #   oauth_scopes = ["openid", "profile"]
      #   #
      #   #   # token_url (Required)
      #   #   # 設定内容: トークンURLを指定します。
      #   #   token_url = "https://example.com/oauth/token"
      #   # }
      # }

      #---------------------------------------------------------
      # ServiceNowプロパティ
      #---------------------------------------------------------
      # service_now {
      #   # instance_url (Required)
      #   # 設定内容: ServiceNowインスタンスのURLを指定します。
      #   instance_url = "https://your-instance.service-now.com"
      # }

      #---------------------------------------------------------
      # Singularプロパティ
      #---------------------------------------------------------
      # singular {
      #   # プロパティなし（空のブロック）
      # }

      #---------------------------------------------------------
      # Slackプロパティ
      #---------------------------------------------------------
      # slack {
      #   # instance_url (Required)
      #   # 設定内容: SlackワークスペースのURLを指定します。
      #   instance_url = "https://your-workspace.slack.com"
      # }

      #---------------------------------------------------------
      # Snowflakeプロパティ
      #---------------------------------------------------------
      # snowflake {
      #   # bucket_name (Required)
      #   # 設定内容: 中間ストレージ用のS3バケット名を指定します。
      #   bucket_name = "example-bucket"
      #
      #   # stage (Required)
      #   # 設定内容: Snowflakeステージ名を指定します。
      #   stage = "example_stage"
      #
      #   # warehouse (Required)
      #   # 設定内容: Snowflakeウェアハウス名を指定します。
      #   warehouse = "example_warehouse"
      #
      #   # account_name (Optional)
      #   # 設定内容: Snowflakeアカウント名を指定します。
      #   account_name = null
      #
      #   # bucket_prefix (Optional)
      #   # 設定内容: S3バケット内のプレフィックスを指定します。
      #   bucket_prefix = null
      #
      #   # private_link_service_name (Optional)
      #   # 設定内容: PrivateLinkサービス名を指定します。
      #   private_link_service_name = null
      #
      #   # region (Optional)
      #   # 設定内容: Snowflakeリージョンを指定します。
      #   region = null
      # }

      #---------------------------------------------------------
      # Trend Microプロパティ
      #---------------------------------------------------------
      # trendmicro {
      #   # プロパティなし（空のブロック）
      # }

      #---------------------------------------------------------
      # Veevaプロパティ
      #---------------------------------------------------------
      # veeva {
      #   # instance_url (Required)
      #   # 設定内容: VeevaインスタンスのURLを指定します。
      #   instance_url = "https://your-instance.veevavault.com"
      # }

      #---------------------------------------------------------
      # Zendeskプロパティ
      #---------------------------------------------------------
      # zendesk {
      #   # instance_url (Required)
      #   # 設定内容: ZendeskインスタンスのURLを指定します。
      #   instance_url = "https://your-subdomain.zendesk.com"
      # }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コネクタプロファイルのAmazon Resource Name (ARN)
#
# - credentials_arn: コネクタプロファイルの認証情報のARN
#        AWS Secrets Managerに保存された認証情報を参照します。
#---------------------------------------------------------------
