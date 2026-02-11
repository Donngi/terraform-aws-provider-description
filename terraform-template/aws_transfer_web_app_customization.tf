#---------------------------------------------------------------
# AWS Transfer Family Web App Customization
#---------------------------------------------------------------
#
# AWS Transfer Family Web Appのカスタマイズプロパティ（アイコンファイル、
# ロゴファイル、タイトル）を管理するためのリソースです。
# Web Appの外観をブランディング要件に合わせてカスタマイズできます。
#
# AWS公式ドキュメント:
#   - UpdateWebAppCustomization API: https://docs.aws.amazon.com/transfer/latest/APIReference/API_UpdateWebAppCustomization.html
#   - Transfer Family Web Apps: https://docs.aws.amazon.com/transfer/latest/userguide/webapp-customize.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_web_app_customization
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_web_app_customization" "example" {
  #-------------------------------------------------------------
  # Web App識別子設定
  #-------------------------------------------------------------

  # web_app_id (Required)
  # 設定内容: カスタマイズ対象のWeb Appの一意な識別子を指定します。
  # 設定可能な値: 24文字固定長の文字列（パターン: webapp-[0-9a-f]{17}）
  # 注意: この値はaws_transfer_web_appリソースのweb_app_id属性から取得します。
  # 参考: https://docs.aws.amazon.com/transfer/latest/APIReference/API_UpdateWebAppCustomization.html
  web_app_id = "webapp-1234567890abcdef0"

  #-------------------------------------------------------------
  # ファビコン設定
  #-------------------------------------------------------------

  # favicon_file (Optional)
  # 設定内容: Web Appに表示するファビコン（Favicon）の画像データをBase64エンコードした文字列を指定します。
  # 設定可能な値: Base64エンコードされた画像データ（最小1文字、最大20960文字）
  # 省略時: ファビコンは設定されません。
  # 注意: Terraformはこの引数が指定された場合のみドリフトを検出します。
  #       ファビコンを削除する場合はリソースを再作成する必要があります。
  #       filebase64()関数を使用してファイルから読み込むことが推奨されます。
  # 参考: https://docs.aws.amazon.com/transfer/latest/APIReference/API_UpdateWebAppCustomization.html
  favicon_file = filebase64("${path.module}/favicon.png")

  #-------------------------------------------------------------
  # ロゴ設定
  #-------------------------------------------------------------

  # logo_file (Optional)
  # 設定内容: Web Appに表示するロゴ画像のデータをBase64エンコードした文字列を指定します。
  # 設定可能な値: Base64エンコードされた画像データ（最小1文字、最大51200文字）
  # 省略時: ロゴは設定されません。
  # 注意: Terraformはこの引数が指定された場合のみドリフトを検出します。
  #       ロゴを削除する場合はリソースを再作成する必要があります。
  #       filebase64()関数を使用してファイルから読み込むことが推奨されます。
  # 参考: https://docs.aws.amazon.com/transfer/latest/APIReference/API_UpdateWebAppCustomization.html
  logo_file = filebase64("${path.module}/logo.png")

  #-------------------------------------------------------------
  # タイトル設定
  #-------------------------------------------------------------

  # title (Optional)
  # 設定内容: Web Appに表示するページタイトルを指定します。
  # 設定可能な値: 0〜100文字の文字列
  # 省略時: タイトルは設定されません。
  # 参考: https://docs.aws.amazon.com/transfer/latest/APIReference/API_UpdateWebAppCustomization.html
  title = "My Secure File Transfer"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# (computed only属性はありません)
#---------------------------------------------------------------
