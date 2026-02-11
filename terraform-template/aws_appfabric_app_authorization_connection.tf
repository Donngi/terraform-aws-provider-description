#---------------------------------------------------------------
# AWS AppFabric App Authorization Connection
#---------------------------------------------------------------
#
# AWS AppFabricとSaaSアプリケーション間の接続を確立するリソースです。
# AppFabricがアプリケーションのAPIを呼び出すことを可能にします。
# App Authorizationを作成した後、このリソースを使用してアプリケーションとの
# 接続を確立します。OAuth2認証タイプの場合、auth_requestブロックで
# 認証コードを提供する必要があります。
#
# AWS公式ドキュメント:
#   - AWS AppFabric概要: https://docs.aws.amazon.com/appfabric/latest/adminguide/what-is-appfabric.html
#   - ConnectAppAuthorization API: https://docs.aws.amazon.com/appfabric/latest/api/API_ConnectAppAuthorization.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_app_authorization_connection
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appfabric_app_authorization_connection" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # app_authorization_arn (Required)
  # 設定内容: 接続リクエストに使用するApp AuthorizationのARNまたはUUIDを指定します。
  # 設定可能な値: 有効なApp Authorization ARN (arn:aws:appfabric:...) またはUUID形式
  # 関連機能: AWS AppFabric App Authorization
  #   App Authorizationは、AppFabricがSaaSアプリケーションに接続するための
  #   認証情報を保持するリソースです。
  #   - https://docs.aws.amazon.com/appfabric/latest/api/API_AppAuthorization.html
  app_authorization_arn = aws_appfabric_app_authorization.example.arn

  # app_bundle_arn (Required)
  # 設定内容: 接続リクエストに使用するApp BundleのARNを指定します。
  # 設定可能な値: 有効なApp Bundle ARN (arn:aws:appfabric:...)
  # 関連機能: AWS AppFabric App Bundle
  #   App Bundleは、複数のApp Authorizationをグループ化するコンテナです。
  #   組織内のSaaSアプリケーションを論理的にまとめて管理できます。
  app_bundle_arn = aws_appfabric_app_bundle.example.arn

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
  # OAuth2認証リクエスト設定
  #-------------------------------------------------------------

  # auth_request (Optional)
  # 設定内容: OAuth2認証情報を含むブロックです。
  # 用途: App AuthorizationがOAuth2 (oauth2) 認証タイプで構成されている場合に必須
  # 注意: API Key認証タイプの場合は不要です
  # 関連機能: OAuth2フロー
  #   OAuth2認証では、ユーザーがアプリケーションのOAuthページで権限を付与した後に
  #   返される認証コードを使用して接続を確立します。
  #   - https://docs.aws.amazon.com/appfabric/latest/api/API_ConnectAppAuthorization.html
  auth_request {
    # code (Required)
    # 設定内容: アプリケーションのOAuthページで権限が付与された後に返される認証コードを指定します。
    # 設定可能な値: アプリケーションから取得した認証コード文字列
    # 取得方法: App AuthorizationのAuthURLにアクセスし、権限を付与後にリダイレクトされる
    #           URLのクエリパラメータから取得します
    code = "authorization_code_from_oauth_flow"

    # redirect_uri (Required)
    # 設定内容: AuthURLおよびアプリケーションクライアントで指定されているリダイレクトURLを指定します。
    # 設定可能な値: 有効なURL文字列
    # 注意: アプリケーション側で登録されているリダイレクトURIと一致する必要があります
    redirect_uri = "https://example.com/callback"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間単位を含む文字列（例: "30s", "5m", "1h"）
    #   - "s": 秒
    #   - "m": 分
    #   - "h": 時間
    # 省略時: Terraformのデフォルトタイムアウト値を使用
    create = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子（app_bundle_arn,app_authorization_arn 形式）
#
# - app: アプリケーションの名前
#        接続先のSaaSアプリケーション名が格納されます
#
# - tenant: アプリケーションテナントに関する情報を含むリスト
#   - tenant_display_name: アプリケーションテナントの表示名
#   - tenant_identifier: アプリケーションテナントの識別子
#---------------------------------------------------------------
