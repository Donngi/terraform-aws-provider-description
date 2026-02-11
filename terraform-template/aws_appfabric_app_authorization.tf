#---------------------------------------------------------------
# AWS AppFabric App Authorization
#---------------------------------------------------------------
#
# AWS AppFabricのアプリケーション認可をプロビジョニングするリソースです。
# App Authorizationは、AppFabricがSaaSアプリケーションと接続・連携するための
# 権限を付与し、監査ログの取り込みを可能にします。
# OAuth2またはAPIキー認証を使用して、様々なSaaSアプリケーションと連携できます。
#
# AWS公式ドキュメント:
#   - AppFabric概要: https://docs.aws.amazon.com/appfabric/latest/adminguide/what-is-appfabric.html
#   - 用語と概念: https://docs.aws.amazon.com/appfabric/latest/adminguide/terminology.html
#   - CreateAppAuthorization API: https://docs.aws.amazon.com/appfabric/latest/api/API_CreateAppAuthorization.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_app_authorization
#
# Provider Version: 6.28.0
# Generated: 2025-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appfabric_app_authorization" "example" {
  #-------------------------------------------------------------
  # アプリケーション設定
  #-------------------------------------------------------------

  # app (Required)
  # 設定内容: 連携するSaaSアプリケーションの名前を指定します。
  # 設定可能な値: サポートされているアプリケーション名
  #   - "ASANA", "BOX", "DROPBOX", "GITHUB", "GOOGLEWORKSPACE"
  #   - "JIRA", "MIRO", "OKTA", "ONELOGIN", "SALESFORCE"
  #   - "SLACK", "SMARTSHEET", "TERRAFORMCLOUD", "WEBEX"
  #   - "ZENDESK", "ZOOM" など
  # 関連機能: AWS AppFabric サポートアプリケーション
  #   AppFabricは多くのSaaSアプリケーションとの連携をサポートしています。
  #   サポートされるアプリケーションの完全なリストはAPIドキュメントを参照してください。
  #   - https://docs.aws.amazon.com/appfabric/latest/api/API_CreateAppAuthorization.html
  app = "TERRAFORMCLOUD"

  # app_bundle_arn (Required)
  # 設定内容: 使用するApp BundleのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なApp Bundle ARN
  #   形式: arn:aws:appfabric:{region}:{account-id}:appbundle/{bundle-id}
  # 関連機能: AWS AppFabric App Bundle
  #   App Bundleはアプリケーション認可とインジェスションを格納するコンテナです。
  #   各AWSアカウントはリージョンごとに1つのApp Bundleを作成できます。
  #   - https://docs.aws.amazon.com/appfabric/latest/adminguide/terminology.html
  app_bundle_arn = aws_appfabric_app_bundle.example.arn

  # auth_type (Required)
  # 設定内容: アプリケーション認可の認証タイプを指定します。
  # 設定可能な値:
  #   - "oauth2": OAuth 2.0を使用した認証。クライアントID/シークレットが必要
  #   - "apiKey": APIキーを使用した認証。APIキートークンが必要
  # 注意: credentialブロックで指定する認証情報はauth_typeと一致させる必要があります
  auth_type = "apiKey"

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
  # 認証情報設定
  #-------------------------------------------------------------

  # credential (Required)
  # 設定内容: アプリケーションの認証情報を指定します。
  # auth_typeに応じて、api_key_credentialまたはoauth2_credentialのいずれかを指定します。
  credential {
    # api_key_credential (Optional)
    # 設定内容: APIキー認証情報を指定します。
    # auth_typeが"apiKey"の場合に使用します。
    api_key_credential {
      # api_key (Required, Sensitive)
      # 設定内容: APIキートークンを指定します。
      # 設定可能な値: アプリケーションから発行されたAPIキー文字列
      # 注意: この値は機密情報として扱われ、Terraform stateに保存されます
      api_key = "your-api-key-token"
    }

    # oauth2_credential (Optional)
    # 設定内容: OAuth 2.0認証情報を指定します。
    # auth_typeが"oauth2"の場合に使用します。
    # oauth2_credential {
    #   # client_id (Required)
    #   # 設定内容: クライアントアプリケーションのクライアントIDを指定します。
    #   # 設定可能な値: OAuth 2.0クライアントID文字列
    #   client_id = "your-client-id"
    #
    #   # client_secret (Required, Sensitive)
    #   # 設定内容: クライアントアプリケーションのクライアントシークレットを指定します。
    #   # 設定可能な値: OAuth 2.0クライアントシークレット文字列
    #   # 注意: この値は機密情報として扱われ、Terraform stateに保存されます
    #   client_secret = "your-client-secret"
    # }
  }

  #-------------------------------------------------------------
  # テナント設定
  #-------------------------------------------------------------

  # tenant (Required)
  # 設定内容: アプリケーションテナントの情報を指定します。
  # テナントIDとテナント名は、アプリケーション認可と関連するインジェスションの
  # ラベル付けに使用されます。
  tenant {
    # tenant_display_name (Required)
    # 設定内容: テナントの表示名を指定します。
    # 設定可能な値: 任意の文字列（識別しやすい名前を推奨）
    tenant_display_name = "example"

    # tenant_identifier (Required)
    # 設定内容: アプリケーションテナントの一意の識別子を指定します。
    # 設定可能な値: アプリケーション固有のテナントID
    #   例: 組織ID、ワークスペースID、ドメイン名など
    tenant_identifier = "example"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    delete = null
  }

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
    Name        = "example-app-authorization"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: App AuthorizationのAmazon Resource Name (ARN)
#
# - auth_url: OAuthフローのためのアプリケーションURL
#             auth_typeが"oauth2"の場合に設定されます
#
# - created_at: App Authorizationが作成されたタイムスタンプ
#
# - id: リソースの識別子
#
# - persona: App Authorizationのユーザーペルソナ
#            常に"admin"が設定されます
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - updated_at: App Authorizationが最後に更新されたタイムスタンプ
#---------------------------------------------------------------
