#---------------------------------------------------------------
# AWS Security Hub Member
#---------------------------------------------------------------
#
# AWS Security Hubのメンバーアカウントをプロビジョニングするリソースです。
# このリソースを使用することで、Security Hubの管理者アカウントから
# 他のAWSアカウントをメンバーとして招待・管理できます。
# メンバーアカウントを追加することで、複数アカウントにわたる
# セキュリティ所見を一元的に集約・管理することができます。
#
# AWS公式ドキュメント:
#   - AWS Security Hub メンバーアカウントの管理: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-accounts.html
#   - CreateMembers API: https://docs.aws.amazon.com/securityhub/1.0/APIReference/API_CreateMembers.html
#   - InviteMembers API: https://docs.aws.amazon.com/securityhub/1.0/APIReference/API_InviteMembers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_member
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_member" "example" {
  #-------------------------------------------------------------
  # 前提条件設定
  #-------------------------------------------------------------

  # depends_on (Optional)
  # 設定内容: Security Hub メンバーを作成する前に、
  #          Security Hubアカウントが有効化されていることを保証します。
  # 推奨事項: aws_securityhub_account リソースへの依存関係を明示的に定義して、
  #          Security Hubが有効化されてからメンバーを追加するようにします。
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-settingup.html
  depends_on = [aws_securityhub_account.example]

  #-------------------------------------------------------------
  # メンバーアカウント設定 (Required)
  #-------------------------------------------------------------

  # account_id (Required)
  # 設定内容: Security Hubのメンバーとして追加するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 用途: 管理者アカウントに関連付けるメンバーアカウントを指定します。
  #       このアカウントのセキュリティ所見が管理者アカウントに集約されます。
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-accounts.html
  account_id = "123456789012"

  #-------------------------------------------------------------
  # 連絡先情報 (Optional)
  #-------------------------------------------------------------

  # email (Optional)
  # 設定内容: メンバーアカウントに関連付けるメールアドレスを指定します。
  # 設定可能な値: 有効なメールアドレス形式の文字列
  # 用途: メンバーアカウントへの招待メールを送信する際のメールアドレスとして使用されます。
  #       このメールアドレスは、招待を受け取るための通知先となります。
  # 推奨事項: メンバーアカウントの管理者またはセキュリティチームの連絡先を設定してください。
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-accounts.html
  email = "security-team@example.com"

  #-------------------------------------------------------------
  # 招待設定 (Optional)
  #-------------------------------------------------------------

  # invite (Optional)
  # 設定内容: メンバーアカウントに招待を送信するかどうかを指定します。
  # 設定可能な値: true または false
  # 省略時: false（招待を送信しない）
  # 動作:
  #   - true: メンバーアカウントを追加し、招待メールを送信します。
  #          メンバー側で招待を承諾する必要があります。
  #   - false: メンバーアカウントを追加しますが、招待は送信されません。
  #           Organizations統合を使用している場合や、
  #           手動で招待を管理する場合に使用します。
  # 関連機能: AWS Organizations統合
  #   AWS Organizations統合を使用している場合、組織内のアカウントは
  #   自動的にメンバーとして追加され、招待の承諾は不要です。
  #   - https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-settingup.html#securityhub-enable-org
  invite = true

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます
  # 用途: 複数リージョンでSecurity Hubを運用する場合に、
  #       特定リージョンでのメンバー管理を行う際に指定します。
  # 注意: Security Hubはリージョナルサービスであるため、
  #       各リージョンで個別にメンバーアカウントを設定する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: メンバーAWSアカウントのID（account_idと同一）
#
# - master_id: Security Hub管理者アカウントのID
#   用途: メンバーが関連付けられている管理者アカウントを識別します
#
# - member_status: メンバーアカウントの関係ステータス
#   設定可能な値:
#     - "Created": メンバーが作成されたが、まだ招待が送信されていない状態
#     - "Invited": 招待が送信され、承諾待ちの状態
#     - "Enabled": メンバーが招待を承諾し、有効化された状態
#     - "Removed": メンバーが削除された状態
#     - "Resigned": メンバーが自発的に関連付けを解除した状態
#   参考: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-accounts.html
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のSecurity Hub メンバーをインポートする場合:
#
#---------------------------------------------------------------
