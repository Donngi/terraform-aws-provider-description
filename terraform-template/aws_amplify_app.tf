#---------------------------------------------------------------
# AWS Amplify App
#---------------------------------------------------------------
#
# AWS Amplify Hostingでフルスタックサーバーレスアプリケーションをホスティングするための
# リソースです。静的サイト、シングルページアプリケーション（SPA）、
# サーバーサイドレンダリング（SSR）アプリケーションをサポートします。
#
# AWS公式ドキュメント:
#   - Amplify Hosting概要: https://docs.aws.amazon.com/amplify/latest/userguide/welcome.html
#   - ビルド設定: https://docs.aws.amazon.com/amplify/latest/userguide/build-settings.html
#   - カスタムヘッダー: https://docs.aws.amazon.com/amplify/latest/userguide/custom-headers.html
#   - リダイレクトとリライト: https://docs.aws.amazon.com/amplify/latest/userguide/redirects.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/amplify_app
#
# Provider Version: 6.28.0
# Generated: 2025-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_amplify_app" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Amplifyアプリケーションの名前を指定します。
  # 設定可能な値: 文字列
  name = "my-amplify-app"

  # description (Optional)
  # 設定内容: Amplifyアプリケーションの説明を指定します。
  # 設定可能な値: 文字列
  description = "My Amplify application"

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
  # リポジトリ設定
  #-------------------------------------------------------------

  # repository (Optional)
  # 設定内容: Amplifyアプリケーションのソースコードリポジトリを指定します。
  # 設定可能な値: リポジトリURL（例: https://github.com/example/app）
  # 注意: GitHub、GitLab、Bitbucket、AWS CodeCommitをサポート
  repository = "https://github.com/example/app"

  # access_token (Optional, Sensitive)
  # 設定内容: サードパーティソースコントロールシステムの個人アクセストークンを指定します。
  # 設定可能な値: GitHubなどのアクセストークン文字列
  # 注意: このトークンはWebhookと読み取り専用デプロイキーの作成に使用されます。
  #       トークンは保存されないため、適用後にこの属性を削除してセットアップトークンを削除できます。
  #       oauth_tokenと排他的（どちらか一方のみ指定）
  access_token = null

  # oauth_token (Optional, Sensitive)
  # 設定内容: サードパーティソースコントロールシステムのOAuthトークンを指定します。
  # 設定可能な値: OAuthトークン文字列
  # 注意: OAuthトークンはWebhookと読み取り専用デプロイキーの作成に使用されます。
  #       トークンは保存されません。
  #       access_tokenと排他的（どちらか一方のみ指定）
  oauth_token = null

  #-------------------------------------------------------------
  # プラットフォーム設定
  #-------------------------------------------------------------

  # platform (Optional)
  # 設定内容: Amplifyアプリケーションのプラットフォームまたはフレームワークを指定します。
  # 設定可能な値:
  #   - "WEB": 静的サイトまたはシングルページアプリケーション（デフォルト）
  #   - "WEB_COMPUTE": サーバーサイドレンダリング（SSR）アプリケーション
  platform = "WEB"

  #-------------------------------------------------------------
  # ビルド設定
  #-------------------------------------------------------------

  # build_spec (Optional)
  # 設定内容: Amplifyアプリケーションのビルド仕様（build spec）を指定します。
  # 設定可能な値: YAML形式のビルド仕様文字列
  # 関連機能: Amplifyビルド設定
  #   ビルドコマンド、環境変数、ビルドアーティファクトなどを定義します。
  #   - https://docs.aws.amazon.com/amplify/latest/userguide/build-settings.html
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # custom_headers (Optional)
  # 設定内容: AmplifyアプリケーションのカスタムHTTPヘッダーを指定します。
  # 設定可能な値: YAML形式のカスタムヘッダー定義文字列
  # 関連機能: カスタムヘッダー
  #   セキュリティヘッダーやその他のHTTPレスポンスヘッダーを設定できます。
  #   - https://docs.aws.amazon.com/amplify/latest/userguide/custom-headers.html
  custom_headers = <<-EOT
    customHeaders:
      - pattern: '**'
        headers:
          - key: 'Strict-Transport-Security'
            value: 'max-age=31536000; includeSubDomains'
          - key: 'X-Frame-Options'
            value: 'SAMEORIGIN'
          - key: 'X-XSS-Protection'
            value: '1; mode=block'
          - key: 'X-Content-Type-Options'
            value: 'nosniff'
  EOT

  #-------------------------------------------------------------
  # 環境変数設定
  #-------------------------------------------------------------

  # environment_variables (Optional)
  # 設定内容: Amplifyアプリケーションの環境変数マップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: "_CUSTOM_IMAGE"キーを使用してカスタムビルドイメージを指定することも可能
  environment_variables = {
    ENV           = "production"
    _CUSTOM_IMAGE = "node:18"
  }

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # iam_service_role_arn (Optional)
  # 設定内容: AmplifyアプリケーションのIAMサービスロールARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 用途: Amplifyがバックエンドリソースにアクセスするための権限を付与
  iam_service_role_arn = null

  # compute_role_arn (Optional)
  # 設定内容: SSRコンピュートロールのIAM ARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 用途: サーバーサイドレンダリング（SSR）アプリケーションの実行時に使用
  compute_role_arn = null

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # enable_basic_auth (Optional)
  # 設定内容: Amplifyアプリケーションの基本認証を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 基本認証を有効化（アプリ全体のすべてのブランチに適用）
  #   - false: 基本認証を無効化
  enable_basic_auth = false

  # basic_auth_credentials (Optional, Sensitive)
  # 設定内容: Amplifyアプリケーションの基本認証資格情報を指定します。
  # 設定可能な値: Base64エンコードされた "username:password" 形式の文字列
  # 注意: enable_basic_authがtrueの場合に必要
  # 例: base64encode("username:password")
  basic_auth_credentials = null

  #-------------------------------------------------------------
  # ブランチ自動ビルド設定
  #-------------------------------------------------------------

  # enable_branch_auto_build (Optional)
  # 設定内容: ブランチの自動ビルドを有効にするかを指定します。
  # 設定可能な値:
  #   - true: 新しいコミット時に自動的にビルドを開始
  #   - false: 自動ビルドを無効化
  enable_branch_auto_build = true

  # enable_branch_auto_deletion (Optional)
  # 設定内容: Gitリポジトリからブランチを削除した際に、
  #           Amplify Consoleでブランチを自動的に切断するかを指定します。
  # 設定可能な値:
  #   - true: 自動削除を有効化
  #   - false: 自動削除を無効化
  enable_branch_auto_deletion = true

  #-------------------------------------------------------------
  # 自動ブランチ作成設定
  #-------------------------------------------------------------

  # enable_auto_branch_creation (Optional)
  # 設定内容: 自動ブランチ作成を有効にするかを指定します。
  # 設定可能な値:
  #   - true: パターンに一致するブランチを自動的に作成
  #   - false: 自動ブランチ作成を無効化
  enable_auto_branch_creation = false

  # auto_branch_creation_patterns (Optional)
  # 設定内容: 自動ブランチ作成のglobパターンを指定します。
  # 設定可能な値: globパターンのセット
  # 例: ["*", "*/**"] - Amplify Consoleのデフォルトパターン
  auto_branch_creation_patterns = [
    "feature/*",
    "release/*",
  ]

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-amplify-app"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # auto_branch_creation_config ブロック (Optional)
  #-------------------------------------------------------------
  # 自動作成されるブランチの設定を定義します。
  # enable_auto_branch_creationがtrueの場合に使用されます。

  auto_branch_creation_config {
    # basic_auth_credentials (Optional, Sensitive)
    # 設定内容: 自動作成されるブランチの基本認証資格情報を指定します。
    # 設定可能な値: Base64エンコードされた "username:password" 形式の文字列
    basic_auth_credentials = null

    # build_spec (Optional)
    # 設定内容: 自動作成されるブランチのビルド仕様を指定します。
    # 設定可能な値: YAML形式のビルド仕様文字列
    build_spec = null

    # enable_auto_build (Optional)
    # 設定内容: 自動作成されるブランチの自動ビルドを有効にするかを指定します。
    # 設定可能な値:
    #   - true: 自動ビルドを有効化
    #   - false: 自動ビルドを無効化
    enable_auto_build = true

    # enable_basic_auth (Optional)
    # 設定内容: 自動作成されるブランチの基本認証を有効にするかを指定します。
    # 設定可能な値:
    #   - true: 基本認証を有効化
    #   - false: 基本認証を無効化
    enable_basic_auth = false

    # enable_performance_mode (Optional)
    # 設定内容: ブランチのパフォーマンスモードを有効にするかを指定します。
    # 設定可能な値:
    #   - true: パフォーマンスモードを有効化
    #   - false: パフォーマンスモードを無効化
    enable_performance_mode = false

    # enable_pull_request_preview (Optional)
    # 設定内容: 自動作成されるブランチのプルリクエストプレビューを有効にするかを指定します。
    # 設定可能な値:
    #   - true: プルリクエストプレビューを有効化
    #   - false: プルリクエストプレビューを無効化
    enable_pull_request_preview = true

    # environment_variables (Optional)
    # 設定内容: 自動作成されるブランチの環境変数を指定します。
    # 設定可能な値: キーと値のペアのマップ
    environment_variables = {
      ENV = "development"
    }

    # framework (Optional)
    # 設定内容: 自動作成されるブランチのフレームワークを指定します。
    # 設定可能な値: フレームワーク名の文字列（例: "React", "Next.js", "Vue"）
    framework = "React"

    # pull_request_environment_name (Optional)
    # 設定内容: プルリクエストのAmplify環境名を指定します。
    # 設定可能な値: 環境名の文字列
    pull_request_environment_name = "pr"

    # stage (Optional)
    # 設定内容: 自動作成されるブランチの現在のステージを指定します。
    # 設定可能な値:
    #   - "PRODUCTION": 本番環境
    #   - "BETA": ベータ環境
    #   - "DEVELOPMENT": 開発環境
    #   - "EXPERIMENTAL": 実験環境
    #   - "PULL_REQUEST": プルリクエスト環境
    stage = "DEVELOPMENT"
  }

  #-------------------------------------------------------------
  # cache_config ブロック (Optional)
  #-------------------------------------------------------------
  # Amplifyアプリケーションのキャッシュ設定を定義します。

  cache_config {
    # type (Required)
    # 設定内容: キャッシュのタイプを指定します。
    # 設定可能な値:
    #   - "AMPLIFY_MANAGED": Amplifyが管理するキャッシュ
    #   - "AMPLIFY_MANAGED_NO_COOKIES": Cookieを除外したAmplify管理キャッシュ
    type = "AMPLIFY_MANAGED"
  }

  #-------------------------------------------------------------
  # custom_rule ブロック (Optional, 複数指定可能)
  #-------------------------------------------------------------
  # カスタムリライトおよびリダイレクトルールを定義します。
  # 関連機能: リダイレクトとリライト
  #   - https://docs.aws.amazon.com/amplify/latest/userguide/redirects.html

  # リバースプロキシリライトの例（APIリクエスト用）
  custom_rule {
    # source (Required)
    # 設定内容: URLリライトまたはリダイレクトルールのソースパターンを指定します。
    # 設定可能な値: パスパターン文字列
    source = "/api/<*>"

    # target (Required)
    # 設定内容: URLリライトまたはリダイレクトルールのターゲットパターンを指定します。
    # 設定可能な値: ターゲットURL文字列
    target = "https://api.example.com/api/<*>"

    # status (Optional)
    # 設定内容: URLリライトまたはリダイレクトルールのステータスコードを指定します。
    # 設定可能な値:
    #   - "200": リライト（URLは変更されずにコンテンツを返す）
    #   - "301": 永続的リダイレクト
    #   - "302": 一時的リダイレクト
    #   - "404": Not Found
    #   - "404-200": 404をカスタムページにリライト
    status = "200"

    # condition (Optional)
    # 設定内容: URLリライトまたはリダイレクトルールの条件を指定します。
    # 設定可能な値: 条件文字列（例: 国コード）
    condition = null
  }

  # SPAリダイレクトの例
  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    target = "/index.html"
    status = "200"
  }

  #-------------------------------------------------------------
  # job_config ブロック (Optional)
  #-------------------------------------------------------------
  # Amplifyアプリケーションのビルドインスタンス設定を定義します。
  # 関連機能: ビルドコンピュートタイプ
  #   - https://docs.aws.amazon.com/amplify/latest/APIReference/API_JobConfig.html

  job_config {
    # build_compute_type (Optional)
    # 設定内容: ビルドインスタンスのサイズを指定します。
    # 設定可能な値:
    #   - "STANDARD_8GB": 標準インスタンス（デフォルト）
    #   - "LARGE_16GB": 大型インスタンス
    #   - "XLARGE_72GB": 超大型インスタンス
    build_compute_type = "STANDARD_8GB"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AmplifyアプリケーションのAmazon Resource Name (ARN)
#
# - default_domain: Amplifyアプリケーションのデフォルトドメイン
#
# - id: AmplifyアプリケーションのユニークID
#
# - production_branch: 本番ブランチに関する情報を含むブロック:
#   - branch_name: 本番ブランチのブランチ名
#   - last_deploy_time: 本番ブランチの最後のデプロイ時刻
#   - status: 本番ブランチのステータス
#   - thumbnail_url: 本番ブランチのサムネイルURL
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
