################################################################################
# AWS QuickSight Account Subscription
################################################################################
# リソースの概要:
# Amazon QuickSightアカウントサブスクリプションを管理するリソース。
# QuickSightの利用開始時にアカウント設定（認証方法、エディション、通知先等）を構成します。
#
# 主な用途:
# - QuickSightアカウントのプロビジョニング
# - 認証方式の設定（IAM、Active Directory、IAM Identity Center等）
# - エディション（STANDARD、ENTERPRISE、ENTERPRISE_AND_Q）の選択
# - ユーザーグループの割り当て
#
# 重要な注意事項:
# - admin_group、author_group、reader_group等のグループ設定は、
#   DescribeAccountSettings APIレスポンスに含まれないため、
#   サブスクリプション作成後の変更は検知されません
# - aws_account_idを変更すると強制的に新規リソースが作成されます
# - ENTERPRISE_AND_Qエディション選択時は contact_number、email_address、
#   first_name、last_name が必須となります
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateAccountSubscription.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_account_subscription
#
# Provider Version: 6.28.0
################################################################################

resource "aws_quicksight_account_subscription" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # アカウント名 (必須)
  # AWS全体で一意である必要があります。ユーザーのサインイン時に表示されます。
  # 例: "my-quicksight-account", "analytics-platform-prod"
  account_name = "quicksight-terraform-example"

  # 認証方法 (必須)
  # QuickSightアカウントの認証方式を指定します。
  # 有効な値:
  #   - IAM_AND_QUICKSIGHT: IAMとQuickSightネイティブ認証の両方を使用
  #   - IAM_ONLY: IAM認証のみを使用
  #   - IAM_IDENTITY_CENTER: AWS IAM Identity Center（旧AWS SSO）を使用
  #   - ACTIVE_DIRECTORY: Active Directory認証を使用
  authentication_method = "IAM_AND_QUICKSIGHT"

  # エディション (必須)
  # QuickSightアカウントのエディションを選択します。
  # 有効な値:
  #   - STANDARD: 基本的なBI機能
  #   - ENTERPRISE: エンタープライズ機能（より高度な分析、セキュリティ）
  #   - ENTERPRISE_AND_Q: Enterpriseに加えQ（自然言語クエリ）機能を含む
  # 注意: ENTERPRISE_AND_Qを選択する場合、contact_number、email_address、
  #       first_name、last_nameが必須になります
  edition = "ENTERPRISE"

  # 通知メールアドレス (必須)
  # QuickSightアカウントやサブスクリプションに関する通知を受信するメールアドレス。
  notification_email = "quicksight-notifications@example.com"

  ################################################################################
  # Active Directory関連（authentication_method="ACTIVE_DIRECTORY"の場合に使用）
  ################################################################################

  # Active Directoryの名前 (オプション、ACTIVE_DIRECTORY認証時は必須)
  # Active Directoryを認証方法として選択した場合に設定します。
  # active_directory_name = "corp.example.com"

  # ディレクトリID (オプション)
  # QuickSightアカウントに関連付けるActive DirectoryのID。
  # AWS Directory Serviceで作成したディレクトリのIDを指定します。
  # directory_id = "d-1234567890"

  # レルム (オプション)
  # Active Directoryに関連付けられたレルム（Kerberosレルム）。
  # realm = "CORP.EXAMPLE.COM"

  ################################################################################
  # IAM Identity Center関連（authentication_method="IAM_IDENTITY_CENTER"の場合に使用）
  ################################################################################

  # IAM Identity CenterインスタンスARN (オプション)
  # IAM Identity Center認証を使用する場合、インスタンスのARNを指定します。
  # iam_identity_center_instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef0"

  ################################################################################
  # ユーザーグループ設定（ACTIVE_DIRECTORYまたはIAM_IDENTITY_CENTER認証時に使用）
  ################################################################################

  # 管理者グループ (オプション、ACTIVE_DIRECTORYまたはIAM_IDENTITY_CENTER認証時は必須)
  # QuickSight管理者権限を持つユーザーグループを指定します。
  # admin_group = ["QuickSight-Admins"]

  # 管理者PROグループ (オプション)
  # QuickSight管理者PRO権限を持つユーザーグループ。
  # admin_pro_group = ["QuickSight-Admin-Pro"]

  # 作成者グループ (オプション)
  # QuickSightで分析やダッシュボードを作成できるユーザーグループ。
  # author_group = ["QuickSight-Authors"]

  # 作成者PROグループ (オプション)
  # QuickSight作成者PRO権限を持つユーザーグループ。
  # author_pro_group = ["QuickSight-Author-Pro"]

  # 閲覧者グループ (オプション)
  # QuickSightダッシュボードの閲覧のみ可能なユーザーグループ。
  # reader_group = ["QuickSight-Readers"]

  # 閲覧者PROグループ (オプション)
  # QuickSight閲覧者PRO権限を持つユーザーグループ。
  # reader_pro_group = ["QuickSight-Reader-Pro"]

  ################################################################################
  # その他のオプションパラメータ
  ################################################################################

  # AWSアカウントID (オプション、変更時は強制的に新規リソース作成)
  # 指定しない場合はTerraform AWSプロバイダーのアカウントIDが自動的に使用されます。
  # 明示的に指定する場合は以下のようにします。
  # aws_account_id = "123456789012"

  # リージョン (オプション)
  # このリソースが管理されるAWSリージョン。
  # 指定しない場合はプロバイダー設定のリージョンが使用されます。
  # region = "us-east-1"

  ################################################################################
  # ENTERPRISE_AND_Qエディション選択時の必須パラメータ
  ################################################################################
  # 以下のパラメータはedition="ENTERPRISE_AND_Q"を選択した場合に必須となります。

  # 連絡先電話番号 (オプション、ENTERPRISE_AND_Q選択時は必須)
  # 今後のコミュニケーション用の10桁の電話番号（国際形式）。
  # contact_number = "+1-555-0100"

  # メールアドレス (オプション、ENTERPRISE_AND_Q選択時は必須)
  # QuickSightアカウント作成者の今後のコミュニケーション用メールアドレス。
  # email_address = "author@example.com"

  # 名 (オプション、ENTERPRISE_AND_Q選択時は必須)
  # QuickSightアカウント作成者の名前（ファーストネーム）。
  # first_name = "John"

  # 姓 (オプション、ENTERPRISE_AND_Q選択時は必須)
  # QuickSightアカウント作成者の姓（ラストネーム）。
  # last_name = "Doe"

  ################################################################################
  # タイムアウト設定
  ################################################################################
  # リソースの作成、読み取り、削除操作のタイムアウトを設定できます。

  timeouts {
    # 作成タイムアウト（デフォルト: 10分）
    create = "10m"

    # 読み取りタイムアウト（デフォルト: 1分）
    read = "1m"

    # 削除タイムアウト（デフォルト: 10分）
    delete = "10m"
  }
}

################################################################################
# 出力値
################################################################################
# リソース作成後に参照可能な属性値

# アカウントサブスクリプションステータス
# QuickSightアカウントのサブスクリプション状態を示します。
# 例: "ACCOUNT_CREATED", "UNSUBSCRIBED"
output "quicksight_account_subscription_status" {
  description = "Status of the QuickSight account subscription"
  value       = aws_quicksight_account_subscription.example.account_subscription_status
}

# アカウントID
# QuickSightアカウントに関連付けられたAWSアカウントIDです。
output "quicksight_account_id" {
  description = "AWS Account ID associated with QuickSight subscription"
  value       = aws_quicksight_account_subscription.example.aws_account_id
}

# リソースID
# Terraformで管理するQuickSightアカウントサブスクリプションの一意のID。
output "quicksight_subscription_id" {
  description = "ID of the QuickSight account subscription"
  value       = aws_quicksight_account_subscription.example.id
}

################################################################################
# 使用例とベストプラクティス
################################################################################
# 1. IAM_AND_QUICKSIGHT認証の基本設定（推奨開始設定）:
#    - authentication_method = "IAM_AND_QUICKSIGHT"
#    - edition = "ENTERPRISE"（ほとんどの企業ユースケースに適合）
#    - 必要なパラメータのみ設定してシンプルに開始
#
# 2. IAM Identity Center統合（SSOを使用する企業環境）:
#    - authentication_method = "IAM_IDENTITY_CENTER"
#    - iam_identity_center_instance_arn を設定
#    - admin_group を必ず設定
#    - 必要に応じてauthor_group、reader_groupを設定
#
# 3. Active Directory統合（オンプレミスAD統合が必要な場合）:
#    - authentication_method = "ACTIVE_DIRECTORY"
#    - active_directory_name、directory_id、realmを設定
#    - admin_groupを必ず設定
#
# 4. Q機能を使用する場合:
#    - edition = "ENTERPRISE_AND_Q"
#    - contact_number、email_address、first_name、last_nameを設定
#
# 5. セキュリティのベストプラクティス:
#    - 本番環境では必ずIAM Identity CenterまたはActive Directory認証を使用
#    - 最小権限の原則に従ってユーザーグループを適切に分離
#    - notification_emailは組織の共有メールアドレスを使用
#
# 6. 運用上の注意:
#    - グループ設定の変更は検知されないため、変更が必要な場合は手動で対応
#    - サブスクリプション削除時はQuickSight内のすべてのリソースが削除されるため注意
#    - 複数リージョンで使用する場合は各リージョンで個別にサブスクリプションが必要
################################################################################
