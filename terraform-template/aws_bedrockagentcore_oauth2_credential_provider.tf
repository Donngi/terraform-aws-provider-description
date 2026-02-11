#---------------------------------------------------------------
# AWS Bedrock AgentCore OAuth2 Credential Provider
#---------------------------------------------------------------
#
# Amazon Bedrock AgentCoreのOAuth2認証情報プロバイダーをプロビジョニングするリソースです。
# OAuth2認証情報プロバイダーは、エージェントランタイムが外部のOAuth2/OpenID Connect
# IDプロバイダーとセキュアに認証するための機能を提供します。
#
# GitHub、Google、Microsoft、Salesforce、Slackなどの事前定義されたプロバイダーや、
# カスタムOAuth2プロバイダーを設定できます。
#
# AWS公式ドキュメント:
#   - Bedrock AgentCore Identity: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity-getting-started-cognito.html
#   - CreateOauth2CredentialProvider API: https://docs.aws.amazon.com/bedrock-agentcore-control/latest/APIReference/API_CreateOauth2CredentialProvider.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_oauth2_credential_provider
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_oauth2_credential_provider" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: OAuth2認証情報プロバイダーの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-oauth-provider"

  # credential_provider_vendor (Required)
  # 設定内容: OAuth2認証情報プロバイダーのベンダーを指定します。
  # 設定可能な値:
  #   - "CustomOauth2": カスタムOAuth2プロバイダー
  #   - "GithubOauth2": GitHub OAuth2プロバイダー
  #   - "GoogleOauth2": Google OAuth2プロバイダー
  #   - "Microsoft": Microsoft OAuth2プロバイダー
  #   - "SalesforceOauth2": Salesforce OAuth2プロバイダー
  #   - "SlackOauth2": Slack OAuth2プロバイダー
  # 注意: 選択したベンダーに対応するoauth2_provider_config内のブロックを設定する必要があります。
  credential_provider_vendor = "CustomOauth2"

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
  # OAuth2プロバイダー設定
  #-------------------------------------------------------------
  # oauth2_provider_config (Required)
  # 設定内容: OAuth2プロバイダーの設定を指定します。
  # 注意: 以下のプロバイダー設定のうち、credential_provider_vendorに対応する
  #       1つだけを設定する必要があります。

  oauth2_provider_config {

    #-----------------------------------------------------------
    # カスタムOAuth2プロバイダー設定 (credential_provider_vendor = "CustomOauth2" の場合)
    #-----------------------------------------------------------
    # custom_oauth2_provider_config (Optional)
    # 設定内容: カスタムOAuth2プロバイダーの設定を指定します。
    # 用途: Auth0、Keycloak、Okta等の任意のOAuth2プロバイダーを設定する場合に使用

    custom_oauth2_provider_config {

      # client_id (Optional, Sensitive)
      # 設定内容: OAuth2クライアントIDを指定します。
      # 設定可能な値: 文字列
      # 注意: client_id_woとは排他的（どちらか一方のみ指定可能）
      #       client_secretと一緒に使用する必要があります。
      client_id = "your-oauth2-client-id"

      # client_secret (Optional, Sensitive)
      # 設定内容: OAuth2クライアントシークレットを指定します。
      # 設定可能な値: 文字列
      # 注意: client_secret_woとは排他的（どちらか一方のみ指定可能）
      #       client_idと一緒に使用する必要があります。
      client_secret = "your-oauth2-client-secret"

      # client_id_wo (Optional, Sensitive, Write-Only)
      # 設定内容: Write-Only OAuth2クライアントIDを指定します。
      # 設定可能な値: 文字列
      # 注意: client_idとは排他的（どちらか一方のみ指定可能）
      #       client_secret_woおよびclient_credentials_wo_versionと一緒に使用する必要があります。
      #       Write-Only引数はHashiCorp Terraform 1.11.0以降でサポートされています。
      # client_id_wo = "your-oauth2-client-id"

      # client_secret_wo (Optional, Sensitive, Write-Only)
      # 設定内容: Write-Only OAuth2クライアントシークレットを指定します。
      # 設定可能な値: 文字列
      # 注意: client_secretとは排他的（どちらか一方のみ指定可能）
      #       client_id_woおよびclient_credentials_wo_versionと一緒に使用する必要があります。
      #       Write-Only引数はHashiCorp Terraform 1.11.0以降でサポートされています。
      # client_secret_wo = "your-oauth2-client-secret"

      # client_credentials_wo_version (Optional)
      # 設定内容: Write-Only認証情報の更新をトリガーするためのバージョン番号を指定します。
      # 設定可能な値: 数値
      # 用途: client_id_woまたはclient_secret_woを更新する必要がある場合、
      #       この値をインクリメントしてください。
      # client_credentials_wo_version = 1

      #---------------------------------------------------------
      # OAuth Discovery設定
      #---------------------------------------------------------
      # oauth_discovery (Optional)
      # 設定内容: OAuthディスカバリー設定を指定します。
      # 注意: discovery_urlまたはauthorization_server_metadataのいずれか一方を指定します。

      oauth_discovery {
        # discovery_url (Optional)
        # 設定内容: OpenID Connect Discovery URLを指定します。
        # 設定可能な値: URL文字列（例: https://provider.com/.well-known/openid-configuration）
        # 注意: authorization_server_metadataとは排他的（どちらか一方のみ指定可能）
        # discovery_url = "https://auth.example.com/.well-known/openid-configuration"

        # authorization_server_metadata (Optional)
        # 設定内容: OAuth2認可サーバーのメタデータを手動で指定します。
        # 注意: discovery_urlとは排他的（どちらか一方のみ指定可能）
        authorization_server_metadata {
          # issuer (Required)
          # 設定内容: OAuth2認可サーバーの発行者識別子を指定します。
          # 設定可能な値: URL文字列
          issuer = "https://auth.example.com"

          # authorization_endpoint (Required)
          # 設定内容: OAuth2認可エンドポイントURLを指定します。
          # 設定可能な値: URL文字列
          authorization_endpoint = "https://auth.example.com/oauth2/authorize"

          # token_endpoint (Required)
          # 設定内容: OAuth2トークンエンドポイントURLを指定します。
          # 設定可能な値: URL文字列
          token_endpoint = "https://auth.example.com/oauth2/token"

          # response_types (Optional)
          # 設定内容: 認可サーバーでサポートされるOAuth2レスポンスタイプのセットを指定します。
          # 設定可能な値: 文字列のセット（例: ["code"], ["code", "id_token"]）
          response_types = ["code"]
        }
      }
    }

    #-----------------------------------------------------------
    # GitHub OAuth2プロバイダー設定 (credential_provider_vendor = "GithubOauth2" の場合)
    #-----------------------------------------------------------
    # github_oauth2_provider_config (Optional)
    # 設定内容: GitHub OAuthプロバイダーの設定を指定します。
    # 注意: OAuth Discovery設定は自動的に構成されます（oauth_discoveryはcomputed属性）。

    # github_oauth2_provider_config {
    #   # client_id (Optional, Sensitive)
    #   # 設定内容: GitHubアプリのクライアントIDを指定します。
    #   # 注意: client_id_woとは排他的。client_secretと一緒に使用。
    #   client_id = "github-client-id"
    #
    #   # client_secret (Optional, Sensitive)
    #   # 設定内容: GitHubアプリのクライアントシークレットを指定します。
    #   # 注意: client_secret_woとは排他的。client_idと一緒に使用。
    #   client_secret = "github-client-secret"
    #
    #   # client_id_wo (Optional, Sensitive, Write-Only)
    #   # 設定内容: Write-Only GitHubクライアントIDを指定します。
    #   # client_id_wo = "github-client-id"
    #
    #   # client_secret_wo (Optional, Sensitive, Write-Only)
    #   # 設定内容: Write-Only GitHubクライアントシークレットを指定します。
    #   # client_secret_wo = "github-client-secret"
    #
    #   # client_credentials_wo_version (Optional)
    #   # 設定内容: Write-Only認証情報の更新トリガー用バージョン番号。
    #   # client_credentials_wo_version = 1
    # }

    #-----------------------------------------------------------
    # Google OAuth2プロバイダー設定 (credential_provider_vendor = "GoogleOauth2" の場合)
    #-----------------------------------------------------------
    # google_oauth2_provider_config (Optional)
    # 設定内容: Google OAuthプロバイダーの設定を指定します。
    # 注意: OAuth Discovery設定は自動的に構成されます（oauth_discoveryはcomputed属性）。

    # google_oauth2_provider_config {
    #   # client_id (Optional, Sensitive)
    #   # 設定内容: Google OAuthクライアントIDを指定します。
    #   # 注意: client_id_woとは排他的。client_secretと一緒に使用。
    #   client_id = "google-client-id"
    #
    #   # client_secret (Optional, Sensitive)
    #   # 設定内容: Google OAuthクライアントシークレットを指定します。
    #   # 注意: client_secret_woとは排他的。client_idと一緒に使用。
    #   client_secret = "google-client-secret"
    #
    #   # client_id_wo (Optional, Sensitive, Write-Only)
    #   # 設定内容: Write-Only GoogleクライアントIDを指定します。
    #   # client_id_wo = "google-client-id"
    #
    #   # client_secret_wo (Optional, Sensitive, Write-Only)
    #   # 設定内容: Write-Only Googleクライアントシークレットを指定します。
    #   # client_secret_wo = "google-client-secret"
    #
    #   # client_credentials_wo_version (Optional)
    #   # 設定内容: Write-Only認証情報の更新トリガー用バージョン番号。
    #   # client_credentials_wo_version = 1
    # }

    #-----------------------------------------------------------
    # Microsoft OAuth2プロバイダー設定 (credential_provider_vendor = "Microsoft" の場合)
    #-----------------------------------------------------------
    # microsoft_oauth2_provider_config (Optional)
    # 設定内容: Microsoft OAuthプロバイダーの設定を指定します。
    # 注意: OAuth Discovery設定は自動的に構成されます（oauth_discoveryはcomputed属性）。

    # microsoft_oauth2_provider_config {
    #   # client_id (Optional, Sensitive)
    #   # 設定内容: Microsoft Azure ADアプリのクライアントIDを指定します。
    #   # 注意: client_id_woとは排他的。client_secretと一緒に使用。
    #   client_id = "microsoft-client-id"
    #
    #   # client_secret (Optional, Sensitive)
    #   # 設定内容: Microsoft Azure ADアプリのクライアントシークレットを指定します。
    #   # 注意: client_secret_woとは排他的。client_idと一緒に使用。
    #   client_secret = "microsoft-client-secret"
    #
    #   # client_id_wo (Optional, Sensitive, Write-Only)
    #   # 設定内容: Write-Only MicrosoftクライアントIDを指定します。
    #   # client_id_wo = "microsoft-client-id"
    #
    #   # client_secret_wo (Optional, Sensitive, Write-Only)
    #   # 設定内容: Write-Only Microsoftクライアントシークレットを指定します。
    #   # client_secret_wo = "microsoft-client-secret"
    #
    #   # client_credentials_wo_version (Optional)
    #   # 設定内容: Write-Only認証情報の更新トリガー用バージョン番号。
    #   # client_credentials_wo_version = 1
    # }

    #-----------------------------------------------------------
    # Salesforce OAuth2プロバイダー設定 (credential_provider_vendor = "SalesforceOauth2" の場合)
    #-----------------------------------------------------------
    # salesforce_oauth2_provider_config (Optional)
    # 設定内容: Salesforce OAuthプロバイダーの設定を指定します。
    # 注意: OAuth Discovery設定は自動的に構成されます（oauth_discoveryはcomputed属性）。

    # salesforce_oauth2_provider_config {
    #   # client_id (Optional, Sensitive)
    #   # 設定内容: Salesforce Connected AppのクライアントIDを指定します。
    #   # 注意: client_id_woとは排他的。client_secretと一緒に使用。
    #   client_id = "salesforce-client-id"
    #
    #   # client_secret (Optional, Sensitive)
    #   # 設定内容: Salesforce Connected Appのクライアントシークレットを指定します。
    #   # 注意: client_secret_woとは排他的。client_idと一緒に使用。
    #   client_secret = "salesforce-client-secret"
    #
    #   # client_id_wo (Optional, Sensitive, Write-Only)
    #   # 設定内容: Write-Only SalesforceクライアントIDを指定します。
    #   # client_id_wo = "salesforce-client-id"
    #
    #   # client_secret_wo (Optional, Sensitive, Write-Only)
    #   # 設定内容: Write-Only Salesforceクライアントシークレットを指定します。
    #   # client_secret_wo = "salesforce-client-secret"
    #
    #   # client_credentials_wo_version (Optional)
    #   # 設定内容: Write-Only認証情報の更新トリガー用バージョン番号。
    #   # client_credentials_wo_version = 1
    # }

    #-----------------------------------------------------------
    # Slack OAuth2プロバイダー設定 (credential_provider_vendor = "SlackOauth2" の場合)
    #-----------------------------------------------------------
    # slack_oauth2_provider_config (Optional)
    # 設定内容: Slack OAuthプロバイダーの設定を指定します。
    # 注意: OAuth Discovery設定は自動的に構成されます（oauth_discoveryはcomputed属性）。

    # slack_oauth2_provider_config {
    #   # client_id (Optional, Sensitive)
    #   # 設定内容: Slack AppのクライアントIDを指定します。
    #   # 注意: client_id_woとは排他的。client_secretと一緒に使用。
    #   client_id = "slack-client-id"
    #
    #   # client_secret (Optional, Sensitive)
    #   # 設定内容: Slack Appのクライアントシークレットを指定します。
    #   # 注意: client_secret_woとは排他的。client_idと一緒に使用。
    #   client_secret = "slack-client-secret"
    #
    #   # client_id_wo (Optional, Sensitive, Write-Only)
    #   # 設定内容: Write-Only SlackクライアントIDを指定します。
    #   # client_id_wo = "slack-client-id"
    #
    #   # client_secret_wo (Optional, Sensitive, Write-Only)
    #   # 設定内容: Write-Only Slackクライアントシークレットを指定します。
    #   # client_secret_wo = "slack-client-secret"
    #
    #   # client_credentials_wo_version (Optional)
    #   # 設定内容: Write-Only認証情報の更新トリガー用バージョン番号。
    #   # client_credentials_wo_version = 1
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - credential_provider_arn: OAuth2認証情報プロバイダーのAmazon Resource Name (ARN)
#
# - client_secret_arn: クライアントシークレットを含むAWS Secrets ManagerシークレットのARN
#   - secret_arn: AWS Secrets Manager内のシークレットのARN
#
# 注意: GitHub、Google、Microsoft、Salesforce、Slackの各プロバイダー設定では、
#       oauth_discoveryはcomputed属性として自動的に設定されます。
#---------------------------------------------------------------
