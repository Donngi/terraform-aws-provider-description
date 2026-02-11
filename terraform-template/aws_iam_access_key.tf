#---------------------------------------------------------------
# AWS IAM Access Key
#---------------------------------------------------------------
#
# IAMユーザーのアクセスキーをプロビジョニングするリソースです。
# アクセスキーは、IAMユーザーとしてAWS CLIやAWS APIへの
# プログラムによるリクエストを認証するための長期認証情報です。
# アクセスキーIDとシークレットアクセスキーのペアで構成されます。
#
# セキュリティのベストプラクティスとして、長期的なアクセスキーよりも
# IAMロールによる一時的な認証情報の使用が推奨されます。
# やむを得ずアクセスキーを使用する場合は、定期的なローテーションと
# 最小権限の原則の適用が重要です。
#
# AWS公式ドキュメント:
#   - IAMユーザーのアクセスキー管理: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
#   - アクセスキーのセキュリティ: https://docs.aws.amazon.com/IAM/latest/UserGuide/securing_access-keys.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
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
  # 注意: 各IAMユーザーは最大2つのアクセスキーを持つことができます。
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
  user = aws_iam_user.example.name

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # pgp_key (Optional)
  # 設定内容: シークレットアクセスキーの暗号化に使用するPGP公開鍵を指定します。
  # 設定可能な値:
  #   - Base-64エンコードされたPGP公開鍵（"raw"形式。gpg --exportで-aオプションを付けない形式）
  #   - Keybaseユーザー名（"keybase:some_person_that_exists"の形式）
  # 省略時: シークレットアクセスキーはTerraform stateファイルに平文で保存されます。
  # 関連機能: PGP暗号化によるシークレット保護
  #   pgp_keyを指定すると、encrypted_secret属性でBase-64エンコードされた暗号化済み
  #   シークレットを取得できます。復号は以下のコマンドで実行可能:
  #   terraform output -raw encrypted_secret | base64 --decode | keybase pgp decrypt
  # 注意: pgp_keyを指定しない場合、secret属性に平文のシークレットアクセスキーが
  #       stateファイルに記録されます。stateファイルの保護を適切に行ってください。
  pgp_key = null

  #-------------------------------------------------------------
  # ステータス設定
  #-------------------------------------------------------------

  # status (Optional)
  # 設定内容: アクセスキーのステータスを指定します。
  # 設定可能な値:
  #   - "Active" (デフォルト): アクセスキーが有効。APIリクエストの認証に使用可能
  #   - "Inactive": アクセスキーが無効。APIリクエストの認証に使用不可
  # 省略時: "Active"
  # 関連機能: アクセスキーのライフサイクル管理
  #   一時的にアクセスキーを無効化する場合に"Inactive"を使用します。
  #   不要になったアクセスキーは無効化後に削除することが推奨されます。
  #   - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
  status = "Active"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アクセスキーID。
#
# - create_date: アクセスキーが作成された日時（RFC3339形式）。
#
# - secret: シークレットアクセスキー（平文）。
#        pgp_keyを指定していない場合にのみ利用可能。
#        インポートされたリソースでは利用不可。
#        注意: stateファイルに平文で記録されるため、
#        バックエンドのstateファイルを適切に保護してください。
#        (sensitive属性)
#
# - encrypted_secret: pgp_keyが指定されている場合に利用可能な、
#        Base-64エンコードされた暗号化済みシークレット。
#        インポートされたリソースでは利用不可。
#
# - key_fingerprint: シークレットの暗号化に使用されたPGP鍵の
#        フィンガープリント。インポートされたリソースでは利用不可。
#
# - ses_smtp_password_v4: AWSのSigv4変換アルゴリズムにより変換された
#        SES SMTPパスワード。インポートされたリソースでは利用不可。
#        SigV4はリージョン固有のため、対応プロバイダーリージョンは
#        ap-south-1, ap-southeast-2, eu-central-1, eu-west-1,
#        us-east-1, us-west-2 です。
#        (sensitive属性)
#
# - encrypted_ses_smtp_password_v4: pgp_keyが指定されている場合に
#        利用可能な、Base-64エンコードされた暗号化済みSES SMTPパスワード。
#        インポートされたリソースでは利用不可。
#---------------------------------------------------------------
