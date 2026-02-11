#---------------------------------------------------------------
# IAM User Login Profile
#---------------------------------------------------------------
#
# IAMユーザーのログインプロファイル（コンソールパスワード）を管理します。
# PGP暗号化によりパスワードを安全に受け渡すことができます。
# Terraformリソース作成時のみパスワード生成をサポートし、既存のログイン
# プロファイルをインポートする場合は制限があります。
#
# AWS公式ドキュメント:
#   - IAM ユーザーのパスワード管理: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords_admin-change-user.html
#   - UpdateLoginProfile API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_UpdateLoginProfile.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_login_profile
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_user_login_profile" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # IAMユーザー名
  # ログインプロファイルを作成する対象のIAMユーザーの名前を指定します。
  # このユーザーは事前に作成されている必要があります。
  #
  # 例: "john.doe", "app-user"
  user = "example-user"


  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # PGP公開鍵
  # パスワードを暗号化するためのPGP公開鍵を指定します。
  # 以下のいずれかの形式で指定できます:
  #   - Base64エンコードされたPGP公開鍵
  #   - Keybaseユーザー名: "keybase:username"
  #
  # この設定はリソース作成時のみ適用され、ドリフト検出は行われません。
  # pgp_keyを指定しない場合、平文パスワードが生成されTerraform stateに
  # 保存されるため、セキュリティ上のリスクがあります。
  #
  # 例: "keybase:some_person_that_exists"
  #     "mQENBF..."（Base64エンコードされたPGP公開鍵）
  # pgp_key = "keybase:username"

  # パスワードの長さ
  # リソース作成時に生成するパスワードの長さを指定します。
  # デフォルト値は20文字です。
  #
  # この設定はリソース作成時のみ適用され、ドリフト検出は行われません。
  # アカウントのパスワードポリシーで設定された最小長以上である必要があります。
  #
  # 例: 20, 32, 64
  # password_length = 20

  # パスワードリセット要求
  # 初回サインイン時にユーザーに新しいパスワードの設定を強制するかどうかを
  # 指定します。
  #
  # この設定はリソース作成時のみ適用されます。
  # セキュリティのベストプラクティスとして、通常はtrueに設定することが
  # 推奨されます。
  #
  # デフォルト: null（設定なし）
  # 例: true, false
  # password_reset_required = true

  # ID（オプション）
  # Terraformリソースの識別子として使用されます。
  # 通常は自動的に計算されるため、明示的な指定は不要です。
  #
  # computed属性でもあるため、指定しない場合は自動的に設定されます。
  # id = null
}


#---------------------------------------------------------------
# Attributes Reference（読み取り専用）
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - encrypted_password
#     Base64エンコードされた暗号化パスワード。
#     pgp_keyが指定され、かつTerraformでリソースが作成された場合のみ
#     利用可能です（インポートした場合は利用不可）。
#
#     復号化コマンド例:
#     terraform output password | base64 --decode | keybase pgp decrypt
#
# - key_fingerprint
#     パスワードの暗号化に使用されたPGP鍵のフィンガープリント。
#     Terraformでリソースが作成された場合のみ利用可能です
#     （インポートした場合は利用不可）。
#
# - password
#     平文のパスワード。
#     pgp_keyが指定されていない場合のみ利用可能です。
#     この属性はセンシティブとして扱われます。
#
#     セキュリティ上の理由から、pgp_keyを使用して暗号化することを
#     強く推奨します。
#
#---------------------------------------------------------------


#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: PGP鍵を使用した安全なパスワード生成
resource "aws_iam_user" "example_secure" {
  name          = "secure-user"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "example_secure" {
  user                    = aws_iam_user.example_secure.name
  pgp_key                 = "keybase:some_person_that_exists"
  password_length         = 32
  password_reset_required = true
}

output "encrypted_password" {
  description = "暗号化されたパスワード（Keybaseで復号化してください）"
  value       = aws_iam_user_login_profile.example_secure.encrypted_password
}


# 例2: カスタムパスワード長とリセット要求
resource "aws_iam_user" "example_custom" {
  name = "custom-password-user"
  path = "/system/"
}

resource "aws_iam_user_login_profile" "example_custom" {
  user                    = aws_iam_user.example_custom.name
  pgp_key                 = "keybase:admin_user"
  password_length         = 64
  password_reset_required = true
}


#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
#
# 1. パスワードのリセット
#    IAMユーザーのパスワードをTerraformでリセットするには、
#    以下のいずれかの方法を使用します:
#    - `terraform taint` コマンドを実行
#    - いずれかの引数を変更してリソースを再作成
#
# 2. セキュリティ
#    pgp_keyを指定しない場合、平文パスワードがTerraform stateファイルに
#    保存されます。本番環境では必ずPGP暗号化を使用してください。
#
# 3. ドリフト検出の制限
#    以下の属性はドリフト検出が行われません:
#    - pgp_key
#    - password_length
#    これらの値を変更してもTerraformは差分として検出しません。
#
# 4. インポートの制限
#    既存のログインプロファイルをインポートした場合、
#    encrypted_password、key_fingerprint、password属性は利用できません。
#
# 5. アカウントパスワードポリシー
#    生成されるパスワードは、AWSアカウントに設定されたパスワード
#    ポリシーの要件を満たす必要があります。
#
#---------------------------------------------------------------
