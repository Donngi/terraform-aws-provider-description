#================================================
# AWS Cognito User Pool UI Customization
#================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-19)の情報に基づいています。
#       最新の仕様については、以下の公式ドキュメントを必ず確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_ui_customization
#================================================

resource "aws_cognito_user_pool_ui_customization" "example" {
  #----------------------------------------------
  # Required Parameters
  #----------------------------------------------

  # ユーザープールID (必須)
  # UIカスタマイズを適用するCognito User PoolのID
  # 注意: ユーザープールには事前にドメインが関連付けられている必要があります
  # aws_cognito_user_pool_domainリソースのuser_pool_id属性を参照することで、
  # ドメインが'Active'状態であることを保証できます
  # 参考: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-app-ui-customization.html
  user_pool_id = "us-west-2_EXAMPLE"

  #----------------------------------------------
  # Optional Parameters
  #----------------------------------------------

  # アプリクライアントID (オプション)
  # カスタマイズを適用するアプリクライアントのID
  # - 省略した場合: すべてのアプリクライアントにデフォルトのスタイルが適用されます
  # - "ALL"を指定: クライアントレベルのブランディングが設定されていないすべてのアプリクライアントに適用
  # - 具体的なクライアントIDを指定: そのアプリクライアントにのみ適用され、デフォルトの"ALL"設定を上書きします
  # 型: string
  # 制約: 1-128文字、パターン: [\w+]+
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_SetUICustomization.html
  client_id = "1example23456789"

  # カスタムCSS (オプション)
  # ホストUIに適用するカスタムCSSスタイル
  # - プレーンテキスト形式のCSSファイルの内容
  # - Amazon Cognito コンソールからテンプレートをダウンロード可能
  #   (ユーザープール > アプリクライアント > ログインページ > ホストUI(クラシック)スタイルを編集)
  # - 最大サイズ: 3 KB (約131,072文字)
  # - カスタマイズ可能なCSSクラス例:
  #   .logo-customizable, .banner-customizable, .label-customizable,
  #   .submitButton-customizable, .inputField-customizable, など
  # 型: string
  # 制約: 0-131,072文字
  # 参考: https://docs.aws.amazon.com/cognito/latest/developerguide/hosted-ui-classic-branding.html
  css = <<-CSS
    .logo-customizable {
      max-width: 60%;
      max-height: 30%;
    }
    .banner-customizable {
      padding: 25px 0px 25px 0px;
      background-color: lightgray;
    }
    .label-customizable {
      font-weight: 400;
    }
    .submitButton-customizable {
      font-size: 14px;
      font-weight: bold;
      margin: 20px 0px 10px 0px;
      height: 40px;
      width: 100%;
      color: #fff;
      background-color: #337ab7;
    }
    .inputField-customizable {
      width: 100%;
      height: 34px;
      color: #555;
      background-color: #fff;
      border: 1px solid #ccc;
    }
  CSS

  # ロゴ画像ファイル (オプション)
  # クラシックホストUIでログインロゴとして設定する画像
  # - Base64エンコードされたバイナリデータとして指定
  # - filebase64()関数を使用してローカルファイルを読み込むことが推奨されます
  # - サポート形式: PNG, JPG, JPEG
  # - 最大サイズ: 100 KB (約131,072バイト)
  # 型: string (Base64エンコード)
  # 制約: 0-131,072文字
  # 参考: https://docs.aws.amazon.com/cognito/latest/developerguide/hosted-ui-classic-branding.html
  image_file = filebase64("logo.png")

  # リージョン (オプション)
  # このリソースが管理されるAWSリージョン
  # - 省略した場合: プロバイダー設定のリージョンがデフォルトで使用されます
  # - 明示的に指定することで、プロバイダーとは異なるリージョンでリソースを管理できます
  # 型: string
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # Terraform管理用ID (オプション)
  # Terraformがリソースを識別するための内部ID
  # - 通常は省略し、Terraformに自動生成させることを推奨
  # - 明示的に指定することも可能ですが、特別な理由がない限り不要です
  # 型: string
  # 注意: このフィールドはcomputed属性でもあるため、Terraformが自動的に値を設定します
  id = null

  #----------------------------------------------
  # Computed Attributes (参照専用)
  #----------------------------------------------
  # 以下の属性は読み取り専用で、Terraformによって自動的に設定されます。
  # テンプレートには含めませんが、参照用に記載しています。
  #
  # - creation_date: UIカスタマイズの作成日時 (RFC3339形式)
  #   参考: https://tools.ietf.org/html/rfc3339#section-5.8
  #
  # - css_version: CSSのバージョン番号
  #   更新のたびにAWSが自動的にインクリメントします
  #
  # - image_url: アップロードされたロゴ画像のURL
  #   例: https://auth.example.com/1example23456789/20250109170543/assets/images/image.jpg
  #
  # - last_modified_date: UIカスタマイズの最終更新日時 (RFC3339形式)
  #   参考: https://tools.ietf.org/html/rfc3339#section-5.8
  #----------------------------------------------

  #----------------------------------------------
  # 重要な注意事項
  #----------------------------------------------
  # 1. ドメインの事前設定が必須
  #    - このリソースを使用する前に、ユーザープールにドメインを設定する必要があります
  #    - aws_cognito_user_pool_domainリソースを作成し、そのuser_pool_id属性を参照してください
  #
  # 2. ホストUI (クラシック) vs マネージドログイン
  #    - このリソースはホストUI (クラシック) ブランディングバージョンにのみ適用されます
  #    - マネージドログインページには効果がありません
  #    - マネージドログインのブランディング設定には別のAPIを使用してください
  #    参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_CreateManagedLoginBranding.html
  #
  # 3. CSS制約
  #    - CSSクラス名とプロパティには制限があります
  #    - 詳細はAmazon Cognitoコンソールからダウンロードできるテンプレートを参照してください
  #
  # 4. 依存関係の管理
  #    - user_pool_idには、aws_cognito_user_pool_domainのuser_pool_id属性を参照することを推奨
  #    - これにより、ドメインが'Active'状態になってからカスタマイズが適用されます
  #
  # 参考ドキュメント:
  # - Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_ui_customization
  # - AWS API Reference: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_SetUICustomization.html
  # - Customizing the Built-in Sign-In and Sign-up Webpages: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-app-ui-customization.html
  # - Hosted UI (classic) branding: https://docs.aws.amazon.com/cognito/latest/developerguide/hosted-ui-classic-branding.html
  #----------------------------------------------
}
