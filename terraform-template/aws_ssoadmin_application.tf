#---------------------------------------------------------------
# AWS SSO Admin Application
#---------------------------------------------------------------
#
# IAM Identity CenterのカスタムOAuth 2.0アプリケーションを管理するリソースです。
# CreateApplication APIはカスタムOAuth 2.0アプリケーションのみをサポートします。
# サードパーティのSAMLまたはOAuth 2.0アプリケーションの作成は、
# 関連するアプリサービスまたはAWSコンソールを通じて設定する必要があります。
#
# AWS公式ドキュメント:
#   - IAM Identity Center Applications: https://docs.aws.amazon.com/singlesignon/latest/userguide/customermanagedapps.html
#   - SAML 2.0 and OAuth 2.0 Applications: https://docs.aws.amazon.com/singlesignon/latest/userguide/customermanagedapps-saml2-oauth2.html
#   - CreateApplication API: https://docs.aws.amazon.com/singlesignon/latest/APIReference/API_CreateApplication.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_application
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_application" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # アプリケーションプロバイダーのARN
  # カスタムOAuth 2.0アプリケーションの場合は "arn:aws:sso::aws:applicationProvider/custom" を指定
  # Type: string
  application_provider_arn = "arn:aws:sso::aws:applicationProvider/custom"

  # IAM Identity CenterインスタンスのARN
  # aws_ssoadmin_instancesデータソースで取得可能
  # Type: string
  instance_arn = "arn:aws:sso:::instance/ssoins-0123456789abcdef"

  # アプリケーション名
  # IAM Identity Center内で一意である必要があります
  # Type: string
  name = "example-application"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # クライアントトークン
  # リクエストの冪等性を保証するための一意なケースセンシティブなID
  # 指定しない場合、AWSがランダムな値を生成します
  # Type: string
  # client_token = "unique-client-token-12345"

  # アプリケーションの説明
  # Type: string
  # description = "Example OAuth 2.0 application for custom integration"

  # このリソースが管理されるリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # Type: string
  # region = "us-east-1"

  # アプリケーションのステータス
  # 有効な値: ENABLED, DISABLED
  # Type: string
  # status = "ENABLED"

  # リソースタグ
  # プロバイダーのdefault_tagsと統合され、マッチするキーは上書きされます
  # Type: map(string)
  # tags = {
  #   Environment = "production"
  #   Application = "custom-oauth-app"
  #   ManagedBy   = "terraform"
  # }

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # アクセスポータルに関連するオプション
  # portal_options {
  #   # アクセスポータルでのアプリケーションの表示設定
  #   # 有効な値: ENABLED, DISABLED
  #   # Type: string
  #   visibility = "ENABLED"
  #
  #   # アクセスポータルのサインインオプション
  #   sign_in_options {
  #     # IAM Identity Centerがターゲットアプリケーションにユーザーを誘導する方法
  #     # APPLICATION: 設定されたapplication_urlにリダイレクト
  #     # IDENTITY_CENTER: SAML IDプロバイダー起動認証を使用してSAMLベースアプリケーションに直接サインイン
  #     # Type: string (Required)
  #     origin = "APPLICATION"
  #
  #     # アプリケーションの認証リクエストを受け入れるURL
  #     # originがAPPLICATIONの場合に必要
  #     # Type: string
  #     application_url = "https://example.com/auth"
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はcomputed onlyのため、参照のみ可能です:
#
# application_account - AWSアカウントID
# application_arn     - (非推奨: 代わりにarnを参照) アプリケーションのARN
# arn                 - アプリケーションのARN
# id                  - (非推奨: 代わりにarnを参照) アプリケーションのARN
# tags_all            - プロバイダーのdefault_tagsを含む、リソースに割り当てられた全タグのマップ
#---------------------------------------------------------------
