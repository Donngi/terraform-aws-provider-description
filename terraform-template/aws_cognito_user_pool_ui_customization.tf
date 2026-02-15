# aws_cognito_user_pool_ui_customization
# Cognito ユーザープールのホストUI（クラシック）のブランディングをカスタマイズするためのリソース
# - カスタムロゴ画像とCSSスタイルシートを適用可能
# - 特定のアプリクライアントまたはユーザープール全体に適用可能
# - 管理ログインページではなく、ホストUI（クラシック）のブランディングバージョンでのみ使用
# - ユーザープールにドメインが設定されている必要がある
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_ui_customization
#
# NOTE:
# - ドメイン設定: ユーザープールに事前にドメインを設定する必要がある
# - サイズ制限: ロゴ画像は100KB以下、CSSは3KB以下
# - ブランディングバージョン: 管理ログインではなくホストUI（クラシック）でのみ有効
# - スコープ: client_idを省略すると全アプリクライアントに適用される

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

resource "aws_cognito_user_pool_ui_customization" "example" {
  # 設定内容: カスタマイズを適用するユーザープールのID
  # 備考: ドメインが設定されたユーザープールである必要がある
  user_pool_id = "us-east-1_ABC123DEF"

  # 設定内容: UIカスタマイズを適用する特定のアプリクライアントのID
  # 省略時: ユーザープール内の全アプリクライアントに適用される
  # 備考: アプリクライアントごとに異なるブランディングを設定可能
  client_id = "1234567890abcdef1234567890"

  #-----------------------------------------------------------------------
  # ロゴ画像設定
  #-----------------------------------------------------------------------

  # 設定内容: カスタムロゴとして表示する画像ファイル（Base64エンコード形式）
  # 設定可能な値: PNG、JPG、JPEG形式のファイル
  # 制約: ファイルサイズは100KB以下
  # 備考: filebase64()関数を使用してファイルをエンコード可能
  image_file = filebase64("path/to/logo.png")

  #-----------------------------------------------------------------------
  # CSSカスタマイズ設定
  #-----------------------------------------------------------------------

  # 設定内容: ホストUIの外観をカスタマイズするCSSコード
  # 制約: CSSファイルサイズは3KB以下
  # 備考: 特定のCSSクラス名とプロパティのみ使用可能
  # 参考: GetUICustomizationリクエストでテンプレートを取得可能
  css = <<-EOF
    .banner {
      background-color: #0066cc;
    }
    .label {
      color: #333333;
      font-family: Arial, sans-serif;
    }
    .submitButton-customizable {
      background-color: #0066cc;
      border-color: #0066cc;
    }
    .submitButton-customizable:hover {
      background-color: #004d99;
    }
  EOF

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 備考: リソースの作成後にリージョンを変更するとリソースの再作成が発生
  region = "us-east-1"
}

#-----------------------------------------------------------------------
# 出力例
#-----------------------------------------------------------------------

# ユーザープール全体へのカスタマイズ適用例
resource "aws_cognito_user_pool_ui_customization" "pool_wide" {
  user_pool_id = aws_cognito_user_pool.example.id

  image_file = filebase64("${path.module}/assets/company-logo.png")

  css = file("${path.module}/assets/cognito-custom.css")

  # client_idを省略することで全アプリクライアントに適用
}

# 特定アプリクライアント向けカスタマイズ例
resource "aws_cognito_user_pool_ui_customization" "app_specific" {
  user_pool_id = aws_cognito_user_pool.example.id
  client_id    = aws_cognito_user_pool_client.mobile_app.id

  image_file = filebase64("${path.module}/assets/mobile-app-logo.png")

  css = <<-CSS
    .banner {
      background: linear-gradient(to right, #667eea 0%, #764ba2 100%);
    }
    .label {
      color: #2d3748;
      font-size: 14px;
    }
    .textDescription-customizable {
      color: #4a5568;
    }
    .submitButton-customizable {
      background-color: #667eea;
      border-radius: 4px;
    }
  CSS
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------

# id - UIカスタマイズのID（user_pool_id:client_id形式）
# creation_date - UIカスタマイズが作成された日時（RFC3339形式）
# css_version - 適用されているCSSのバージョン番号
# image_url - ホストされているロゴ画像のURL
# last_modified_date - UIカスタマイズが最後に更新された日時（RFC3339形式）
