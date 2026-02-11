#---------------------------------------------------------------
# IAM Account Password Policy
#---------------------------------------------------------------
#
# IAMアカウントのパスワードポリシーを管理します。
# AWSアカウントごとに1つのみ設定可能で、既存のポリシーは上書きされます。
# IAMユーザーのパスワード複雑度要件、有効期限、再利用制限などを定義します。
#
# AWS公式ドキュメント:
#   - Set an account password policy: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords_account-policy.html
#   - UpdateAccountPasswordPolicy API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_UpdateAccountPasswordPolicy.html
#   - PasswordPolicy Data Type: https://docs.aws.amazon.com/IAM/latest/APIReference/API_PasswordPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_account_password_policy" "example" {
  #---------------------------------------------------------------
  # パスワード変更権限
  #---------------------------------------------------------------

  # IAMユーザーが自分のパスワードを変更することを許可するかどうか
  # Type: bool
  # Optional
  # Default: false（AWSデフォルト）
  #
  # true に設定すると、IAMユーザーはAWSマネジメントコンソールから
  # 自分自身のパスワードを変更できます。
  # この設定はアカウントレベルで適用され、各ユーザーに個別の
  # アクセス許可ポリシーをアタッチするわけではありません。
  allow_users_to_change_password = true

  #---------------------------------------------------------------
  # パスワード複雑度要件
  #---------------------------------------------------------------

  # パスワードの最小文字数
  # Type: number
  # Optional
  # Default: 6（AWSデフォルト）
  # Valid Range: 6-128
  #
  # IAMユーザーパスワードに必要な最小文字数を指定します。
  # セキュリティのベストプラクティスとして、最低でも8文字以上、
  # できれば12文字以上の設定が推奨されます。
  minimum_password_length = 14

  # 小文字を少なくとも1文字含むことを要求するかどうか
  # Type: bool
  # Optional
  # Default: false（AWSデフォルト）
  #
  # パスワードに小文字（a-z）を少なくとも1文字含める必要があります。
  require_lowercase_characters = true

  # 数字を少なくとも1文字含むことを要求するかどうか
  # Type: bool
  # Optional
  # Default: false（AWSデフォルト）
  #
  # パスワードに数字（0-9）を少なくとも1文字含める必要があります。
  require_numbers = true

  # 記号を少なくとも1文字含むことを要求するかどうか
  # Type: bool
  # Optional
  # Default: false（AWSデフォルト）
  #
  # パスワードに記号文字（! @ # $ % ^ & * ( ) _ + - = [ ] { } | ' など）を
  # 少なくとも1文字含める必要があります。
  require_symbols = true

  # 大文字を少なくとも1文字含むことを要求するかどうか
  # Type: bool
  # Optional
  # Default: false（AWSデフォルト）
  #
  # パスワードに大文字（A-Z）を少なくとも1文字含める必要があります。
  require_uppercase_characters = true

  #---------------------------------------------------------------
  # パスワード有効期限
  #---------------------------------------------------------------

  # パスワードが有効な日数
  # Type: number
  # Optional, Computed
  # Default: 0（パスワードは期限切れにならない）
  # Valid Range: 1-1095
  #
  # IAMユーザーパスワードが有効な日数を指定します。
  # 0に設定するとパスワードは期限切れになりません。
  # 1以上の値を設定すると、expire_passwords属性が自動的にtrueになります。
  # セキュリティのベストプラクティスとして、90日以内の定期的な
  # パスワード変更が推奨されることがあります。
  max_password_age = 90

  # パスワード期限切れ後の強制リセット
  # Type: bool
  # Optional, Computed
  # Default: false（AWSデフォルト）
  #
  # パスワードの有効期限が切れた後、IAMユーザーがAWSマネジメントコンソール経由で
  # 新しいパスワードを設定することを防ぐかどうかを指定します。
  # trueに設定すると、管理者によるリセットが必要になります。
  # ただし、iam:ChangePassword権限と有効なアクセスキーを持つIAMユーザーは、
  # AWS CLIまたはAPIを使用して期限切れパスワードをリセットできます。
  hard_expiry = false

  #---------------------------------------------------------------
  # パスワード再利用制限
  #---------------------------------------------------------------

  # 再利用を防止する過去のパスワード数
  # Type: number
  # Optional, Computed
  # Default: 0（再利用制限なし）
  # Valid Range: 1-24
  #
  # IAMユーザーが再利用できないようにする過去のパスワードの数を指定します。
  # 例えば、5に設定すると、直近5つのパスワードは再利用できません。
  # セキュリティのベストプラクティスとして、最低でも5-24の値が推奨されます。
  password_reuse_prevention = 12

  #---------------------------------------------------------------
  # 追加設定
  #---------------------------------------------------------------

  # リソースID（オプション）
  # Type: string
  # Optional, Computed
  #
  # Terraformリソースの識別子として使用されます。
  # 通常は設定不要で、自動的に計算されます。
  # id = "account-password-policy"
}

#---------------------------------------------------------------
# Attributes Reference (Computed Only)
#---------------------------------------------------------------
# 以下の属性は読み取り専用で、リソース作成後に参照可能です。
#
# - expire_passwords (bool)
#   パスワードの有効期限が設定されているかを示します。
#   max_password_age が 0 より大きい値の場合は true を返します。
#   0 または未設定の場合は false を返します。
#
#---------------------------------------------------------------
