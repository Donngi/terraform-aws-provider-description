#---------------------------------------------------------------
# AWS SSO Admin Application
#---------------------------------------------------------------
#
# AWS IAM Identity Center（旧称: AWS SSO）のカスタムOAuth 2.0アプリケーションを
# プロビジョニングするリソースです。
# アクセスポータルに表示するアプリケーションを定義し、ユーザーのシングルサインオン
# アクセスを一元管理します。
#
# 注意: CreateApplication APIはカスタムOAuth 2.0アプリケーションのみをサポートします。
# サードパーティのSAMLまたはOAuth 2.0アプリケーションの作成は、
# 対応するアプリサービスまたはAWSコンソールを通じて設定する必要があります。
#
# AWS公式ドキュメント:
#   - アプリケーションへのアクセス設定: https://docs.aws.amazon.com/singlesignon/latest/userguide/manage-your-applications.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_application
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_application" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: アプリケーションの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-application"

  # application_provider_arn (Required)
  # 設定内容: アプリケーションプロバイダーのARNを指定します。
  # 設定可能な値: 有効なアプリケーションプロバイダーARN
  #   - "arn:aws:sso::aws:applicationProvider/custom": カスタムアプリケーションプロバイダー
  application_provider_arn = "arn:aws:sso::aws:applicationProvider/custom"

  # instance_arn (Required)
  # 設定内容: IAM Identity CenterインスタンスのARNを指定します。
  # 設定可能な値: 有効なIAM Identity CenterインスタンスARN
  # 参考: data.aws_ssoadmin_instances.example.arns を使用してARNを取得できます。
  instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef0"

  #-------------------------------------------------------------
  # ステータス設定
  #-------------------------------------------------------------

  # status (Optional)
  # 設定内容: アプリケーションのステータスを指定します。
  # 設定可能な値:
  #   - "ENABLED": アプリケーションを有効化し、アクセスポータルに表示します
  #   - "DISABLED": アプリケーションを無効化します
  # 省略時: "ENABLED" が設定されます
  status = "ENABLED"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: アプリケーションの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  description = "My custom OAuth 2.0 application"

  #-------------------------------------------------------------
  # 冪等性設定
  #-------------------------------------------------------------

  # client_token (Optional)
  # 設定内容: リクエストの冪等性を確保するための一意のIDを指定します。
  #           大文字・小文字を区別します。
  # 設定可能な値: 文字列
  # 省略時: AWSが自動的にランダムな値を生成します。
  client_token = null

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
  # ポータルオプション設定
  #-------------------------------------------------------------

  # portal_options (Optional)
  # 設定内容: アプリケーションに関連付けられたアクセスポータルのオプションを設定します。
  portal_options {
    # visibility (Optional)
    # 設定内容: アクセスポータルでのアプリケーションの表示設定を指定します。
    # 設定可能な値:
    #   - "ENABLED": アクセスポータルにアプリケーションを表示します
    #   - "DISABLED": アクセスポータルにアプリケーションを表示しません
    # 省略時: "ENABLED" が設定されます
    visibility = "ENABLED"

    # sign_in_options (Optional)
    # 設定内容: アクセスポータルのサインインオプションを設定します。
    sign_in_options {
      # origin (Required)
      # 設定内容: IAM Identity Centerがユーザーをターゲットアプリケーションにナビゲートする方法を指定します。
      # 設定可能な値:
      #   - "APPLICATION": IAM Identity Centerが設定済みのapplication_urlにリダイレクトします
      #   - "IDENTITY_CENTER": IAM Identity CenterがSAMLアイデンティティプロバイダー起動の
      #                        認証を使用してユーザーをSAMLベースのアプリケーションに直接サインインします
      origin = "APPLICATION"

      # application_url (Optional)
      # 設定内容: アプリケーションの認証リクエストを受け付けるURLを指定します。
      # 設定可能な値: 有効なURL文字列
      # 省略時: URLなし
      # 注意: originが "APPLICATION" の場合に使用します。
      application_url = "https://example.com/sso"
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-application"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: アプリケーションのARN
# - application_arn: アプリケーションのARN（非推奨: arnを使用してください）
# - application_account: アプリケーションが属するAWSアカウントID
# - id: アプリケーションのARN（非推奨: arnを使用してください）
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
