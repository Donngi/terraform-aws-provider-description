#---------------------------------------------------------------
# AWS IAM Access Key
#---------------------------------------------------------------
#
# IAMユーザーのアクセスキーをプロビジョニングするリソースです。
# アクセスキーはIAMユーザーとしてAPIリクエストを実行するための
# 認証情報（アクセスキーIDとシークレットアクセスキー）を提供します。
#
# AWS公式ドキュメント:
#   - IAMアクセスキーの管理: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
#   - IAMのベストプラクティス: https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_access_key" "example" {
  #-------------------------------------------------------------
  # ユーザー設定
  #-------------------------------------------------------------

  # user (Required)
  # 設定内容: アクセスキーを関連付けるIAMユーザー名を指定します。
  # 設定可能な値: 既存のIAMユーザー名（文字列）
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
  user = "example-iam-user"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # pgp_key (Optional)
  # 設定内容: シークレットアクセスキーの暗号化に使用するPGP公開鍵を指定します。
  # 設定可能な値:
  #   - base64エンコードされたPGP公開鍵（raw形式、armored形式は不可）
  #   - keybaseユーザー名（例: "keybase:some_person_that_exists"）
  # 省略時: シークレットアクセスキーが平文でTerraformのstateファイルに保存されます。
  # 注意: base64エンコードされたPGP公開鍵を指定する場合、"--armor"オプション(-a)を
  #       使用しない raw 形式の鍵を使用してください（gpg --export を使用）。
  #       この属性を指定した場合、secret属性ではなくencrypted_secret属性を使用します。
  #       インポートされたリソースではencrypted_secret属性は利用できません。
  pgp_key = null

  #-------------------------------------------------------------
  # ステータス設定
  #-------------------------------------------------------------

  # status (Optional)
  # 設定内容: アクセスキーのステータスを指定します。
  # 設定可能な値:
  #   - "Active" (デフォルト): アクセスキーを有効化し、APIリクエストに使用可能
  #   - "Inactive": アクセスキーを無効化し、APIリクエストに使用不可
  # 省略時: "Active" が設定されます。
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
  status = "Active"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アクセスキーID
#
# - create_date: アクセスキーが作成された日時（RFC3339形式）
#
# - encrypted_secret: pgp_keyが指定された場合のbase64エンコードされた暗号化シークレット。
#                     インポートされたリソースでは利用不可。
#
# - encrypted_ses_smtp_password_v4: pgp_keyが指定された場合のbase64エンコードされた
#                                   暗号化SES SMTPパスワード。インポートされたリソースでは利用不可。
#
# - key_fingerprint: シークレット暗号化に使用されたPGP鍵のフィンガープリント。
#                    インポートされたリソースでは利用不可。
#
# - secret: シークレットアクセスキー（平文）。インポートされたリソースでは利用不可。
#           stateファイルに平文で保存されるため、pgp_keyの使用を推奨します。
#
# - ses_smtp_password_v4: SES SMTP認証用パスワード（SigV4変換済み）。
#                          インポートされたリソースでは利用不可。
#---------------------------------------------------------------
