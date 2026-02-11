#---------------------------------------------------------------
# AWS Cognito Managed Login Branding
#---------------------------------------------------------------
#
# Amazon Cognitoのマネージドログインページのブランディング設定を管理し、
# アプリクライアントと関連付けるリソースです。
# ブランディングスタイルには、画像ファイル、表示オプション、CSSの値など、
# ビジュアル設定の集合が含まれます。
#
# AWS公式ドキュメント:
#   - Managed Login Branding概要: https://docs.aws.amazon.com/cognito/latest/developerguide/managed-login-branding.html
#   - Branding Editor: https://docs.aws.amazon.com/cognito/latest/developerguide/managed-login-brandingeditor.html
#   - CreateManagedLoginBranding API: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_CreateManagedLoginBranding.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_managed_login_branding
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cognito_managed_login_branding" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # user_pool_id (Required)
  # 設定内容: クライアントが属するユーザープールのIDを指定します。
  # 設定可能な値: 有効なCognitoユーザープールID（例: ap-northeast-1_aBcDeFgHi）
  # 関連機能: Amazon Cognito User Pools
  #   ユーザーディレクトリとしてのユーザープール。アプリケーションにサインアップとサインインの機能を提供します。
  #   - https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-identity-pools.html
  user_pool_id = "ap-northeast-1_aBcDeFgHi"

  # client_id (Required)
  # 設定内容: ブランディングスタイルを適用するアプリクライアントのIDを指定します。
  # 設定可能な値: 有効なCognitoアプリクライアントID
  # 関連機能: Cognito App Clients
  #   アプリクライアントは、ユーザープールにアクセスするために必要な設定です。各アプリクライアントに個別のブランディングスタイルを適用できます。
  #   - https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-client-apps.html
  client_id = "1a2b3c4d5e6f7g8h9i0j1k2l3m"

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
  # ブランディング設定
  #-------------------------------------------------------------

  # use_cognito_provided_values (Optional)
  # 設定内容: trueに設定すると、Amazon Cognitoが管理するデフォルトのブランディングスタイルオプションを適用します。
  # 設定可能な値:
  #   - true: デフォルトブランディングスタイルを使用
  #   - false または省略時: カスタムブランディング設定（settingsおよびassetブロック）を使用
  # 注意: trueに設定した場合、settingsとassetは省略する必要があります
  # 関連機能: Cognito Default Branding
  #   Amazon Cognitoが提供するデフォルトのブランディングスタイル。カスタマイズなしで迅速に利用できます。
  use_cognito_provided_values = false

  # settings (Optional)
  # 設定内容: スタイルに適用する設定を含むJSON文書を指定します。
  # 設定可能な値: JSON形式の文字列。ブランディング設定（色、フォント、レイアウトなど）を定義
  # 省略時: use_cognito_provided_valuesがtrueの場合は省略必須。それ以外は空の設定
  # 注意: 現在、signUp、instructions、sessionTimerDisplay、languageSelectorの各コンポーネントは実装されていません
  # 関連機能: Managed Login Branding Settings
  #   Amazon Cognitoコンソールがマネージドログインブランディング設定用のJSON-Schemaファイルを管理しています。
  #   - https://docs.aws.amazon.com/cognito/latest/developerguide/managed-login-brandingeditor.html
  settings = jsonencode({
    # カスタム設定をここに記述
    # 例: テキストの配置、ロゴの配置、背景画像と色、プライマリブランディングカラーなど
  })

  #-------------------------------------------------------------
  # アセット設定（画像ファイル）
  #-------------------------------------------------------------

  # asset (Optional)
  # 設定内容: 背景、ロゴ、アイコンなどの役割に適用する画像ファイルを指定します。
  # 設定可能な値: assetブロックの配列（最大40個）
  # 注意: use_cognito_provided_valuesがtrueの場合は省略必須
  # 関連機能: Managed Login Assets
  #   マネージドログインページのビジュアル要素をカスタマイズするための画像アセット。
  #   各アセットは、モード（ダーク、ライト、またはブラウザ適応型）を示す必要があります。
  #   - https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AssetType.html
  asset {
    # category (Required)
    # 設定内容: マネージドログイン設定において画像が対応するカテゴリを指定します。
    # 設定可能な値:
    #   - FAVICON_ICO: ICO形式のファビコン
    #   - FAVICON_SVG: SVG形式のファビコン
    #   - EMAIL_GRAPHIC: Eメールグラフィック
    #   - SMS_GRAPHIC: SMSグラフィック
    #   - AUTH_APP_GRAPHIC: 認証アプリグラフィック
    #   - PASSWORD_GRAPHIC: パスワードグラフィック
    #   - PASSKEY_GRAPHIC: パスキーグラフィック
    #   - PAGE_HEADER_LOGO: ページヘッダーロゴ
    #   - PAGE_HEADER_BACKGROUND: ページヘッダー背景
    #   - PAGE_FOOTER_LOGO: ページフッターロゴ
    #   - PAGE_FOOTER_BACKGROUND: ページフッター背景
    #   - PAGE_BACKGROUND: ページ背景
    #   - FORM_BACKGROUND: フォーム背景
    #   - FORM_LOGO: フォームロゴ
    #   - IDP_BUTTON_ICON: IDプロバイダーボタンアイコン
    # 関連機能: Managed Login Asset Categories
    #   マネージドログインには、さまざまなタイプのロゴ、背景、アイコン用のアセットカテゴリがあります。
    #   - https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AssetType.html
    category = "PAGE_HEADER_LOGO"

    # color_mode (Required)
    # 設定内容: アセットの表示モードターゲットを指定します（ライト、ダーク、ブラウザ適応型）。
    # 設定可能な値:
    #   - LIGHT: ライトモード専用
    #   - DARK: ダークモード専用（ブラウザまたはアプリケーションがダークモードの時のみ表示）
    #   - DYNAMIC: ブラウザ適応型（すべてのコンテキストで表示）
    # 関連機能: Color Mode Targeting
    #   アセットの表示モードを制御し、ユーザーのブラウザまたはアプリケーションの設定に応じて適切な画像を表示します。
    color_mode = "LIGHT"

    # extension (Required)
    # 設定内容: 画像ファイルのファイルタイプを指定します。
    # 設定可能な値:
    #   - ICO: アイコンファイル形式
    #   - JPEG: JPEG画像形式
    #   - PNG: PNG画像形式
    #   - SVG: SVGベクター画像形式
    #   - WEBP: WebP画像形式
    # 注意: カテゴリによって受け入れられるファイルタイプに制限がある場合があります
    extension = "PNG"

    # bytes (Optional)
    # 設定内容: Base64エンコードされたバイナリ形式の画像ファイルを指定します。
    # 設定可能な値: Base64エンコードされたバイナリデータ（最大1,000,000文字）
    # 省略時: resource_idのみを使用してアセットを参照
    # 注意: リクエスト全体のサイズ制限は2MBです。大きなアセットの場合は複数のリクエストに分割する必要があります
    # 関連機能: Asset Upload
    #   filebase64関数を使用してファイルをBase64エンコードしてアップロードできます。
    bytes = filebase64("path/to/logo.png")

    # resource_id (Optional)
    # 設定内容: アセットのIDを指定します。
    # 設定可能な値: 1〜40文字の英数字、ハイフン、スペース（パターン: ^[\w\- ]+$）
    # 省略時: 自動的に生成されます
    resource_id = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - managed_login_branding_id: マネージドログインブランディングスタイルのID
#
# - settings_all: Amazon Cognitoのデフォルト値を含む設定
#---------------------------------------------------------------
