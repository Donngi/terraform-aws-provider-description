#---------------------------------------------------------------
# AWS QuickSight Account Subscription
#---------------------------------------------------------------
#
# Amazon QuickSightのアカウントサブスクリプションをプロビジョニングするリソースです。
# 新しいQuickSightアカウントの作成、または既存のAWSアカウントへのQuickSightサービスの
# サブスクリプション登録を行います。認証方式（IAM、Active Directory、IAM Identity Center）
# やエディション（Standard、Enterprise）を指定してセットアップします。
#
# AWS公式ドキュメント:
#   - CreateAccountSubscription API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateAccountSubscription.html
#   - Amazon QuickSight概要: https://docs.aws.amazon.com/quicksight/latest/user/welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_account_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_account_subscription" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # account_name (Required)
  # 設定内容: Amazon QuickSightアカウントの名前を指定します。
  #           この名前はAWS全体で一意であり、ユーザーがサインインするときに表示されます。
  # 設定可能な値: 英数字、ハイフンを含む文字列
  account_name = "quicksight-terraform"

  # edition (Required)
  # 設定内容: Amazon QuickSightアカウントのエディションを指定します。
  # 設定可能な値:
  #   - "STANDARD": スタンダードエディション。個人ユーザーや小規模グループ向け
  #   - "ENTERPRISE": エンタープライズエディション。VPC接続、行レベルセキュリティ、
  #                    Active Directoryグループ管理等の拡張機能を含む
  #   - "ENTERPRISE_AND_Q": エンタープライズ＋Q。AI機能（Amazon Q）を含む
  # 参考: https://docs.aws.amazon.com/quicksight/latest/user/editions.html
  edition = "ENTERPRISE"

  # notification_email (Required)
  # 設定内容: Amazon QuickSightアカウントまたはサブスクリプションに関する
  #           通知の送信先メールアドレスを指定します。
  # 設定可能な値: 有効なメールアドレス
  notification_email = "notification@example.com"

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # authentication_method (Required)
  # 設定内容: Amazon QuickSightアカウントの認証方式を指定します。
  # 設定可能な値:
  #   - "IAM_AND_QUICKSIGHT": IAMとQuickSight独自の認証を併用
  #   - "IAM_ONLY": IAM認証のみを使用
  #   - "IAM_IDENTITY_CENTER": AWS IAM Identity Center（旧AWS SSO）を使用
  #   - "ACTIVE_DIRECTORY": Microsoft Active Directoryを使用
  # 注意: "ACTIVE_DIRECTORY"選択時はactive_directory_nameとdirectory_idが必要。
  #       "IAM_IDENTITY_CENTER"選択時はiam_identity_center_instance_arnが必要。
  authentication_method = "IAM_AND_QUICKSIGHT"

  # active_directory_name (Optional)
  # 設定内容: Active Directoryの名前を指定します。
  # 設定可能な値: Active Directoryのドメイン名（例: corp.example.com）
  # 省略時: null（authentication_methodが"ACTIVE_DIRECTORY"の場合は必須）
  active_directory_name = null

  # directory_id (Optional)
  # 設定内容: Amazon QuickSightアカウントに関連付けるActive DirectoryのIDを指定します。
  # 設定可能な値: AWS Directory ServiceのディレクトリID（例: d-1234567890）
  # 省略時: null（authentication_methodが"ACTIVE_DIRECTORY"の場合は必須）
  directory_id = null

  # realm (Optional)
  # 設定内容: Amazon QuickSightアカウントに関連付けるActive DirectoryのRealmを指定します。
  # 設定可能な値: Active DirectoryのRealmまたはドメイン名
  # 省略時: null
  realm = null

  # iam_identity_center_instance_arn (Optional)
  # 設定内容: AWS IAM Identity CenterインスタンスのARNを指定します。
  # 設定可能な値: 有効なIAM Identity CenterインスタンスのARN
  # 省略時: null（authentication_methodが"IAM_IDENTITY_CENTER"の場合に必要）
  # 参考: https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
  iam_identity_center_instance_arn = null

  #-------------------------------------------------------------
  # グループ設定
  #-------------------------------------------------------------
  # 注意: admin_group、author_group、reader_group、admin_pro_group、author_pro_group、
  #       reader_pro_groupはDescribeAccountSettings APIレスポンスに含まれないため、
  #       サブスクリプション作成後にこれらのグループを変更してもTerraformは変更を検出できません。

  # admin_group (Optional)
  # 設定内容: Active DirectoryまたはIAM Identity Centerアカウントに関連付ける
  #           管理者グループのリストを指定します。
  # 設定可能な値: グループ名の文字列リスト
  # 省略時: null（authentication_methodが"ACTIVE_DIRECTORY"または"IAM_IDENTITY_CENTER"の場合に必要）
  admin_group = null

  # admin_pro_group (Optional)
  # 設定内容: Active DirectoryまたはIAM Identity Centerアカウントに関連付ける
  #           管理者PROグループのリストを指定します。
  # 設定可能な値: グループ名の文字列リスト
  # 省略時: null
  admin_pro_group = null

  # author_group (Optional)
  # 設定内容: Active DirectoryまたはIAM Identity Centerアカウントに関連付ける
  #           作成者グループのリストを指定します。
  # 設定可能な値: グループ名の文字列リスト
  # 省略時: null
  author_group = null

  # author_pro_group (Optional)
  # 設定内容: Active DirectoryまたはIAM Identity Centerアカウントに関連付ける
  #           作成者PROグループのリストを指定します。
  # 設定可能な値: グループ名の文字列リスト
  # 省略時: null
  author_pro_group = null

  # reader_group (Optional)
  # 設定内容: Active DirectoryまたはIAM Identity Centerアカウントに関連付ける
  #           閲覧者グループのリストを指定します。
  # 設定可能な値: グループ名の文字列リスト
  # 省略時: null
  reader_group = null

  # reader_pro_group (Optional)
  # 設定内容: Active DirectoryまたはIAM Identity Centerアカウントに関連付ける
  #           閲覧者PROグループのリストを指定します。
  # 設定可能な値: グループ名の文字列リスト
  # 省略時: null
  reader_pro_group = null

  #-------------------------------------------------------------
  # アカウント担当者情報設定
  #-------------------------------------------------------------
  # 注意: 以下のfirst_name、last_name、email_address、contact_numberは
  #       editionが"ENTERPRISE_AND_Q"の場合に必須です。

  # first_name (Optional)
  # 設定内容: Amazon QuickSightアカウントの担当者の名前（名）を指定します。
  # 設定可能な値: 文字列
  # 省略時: null（editionが"ENTERPRISE_AND_Q"の場合は必須）
  first_name = null

  # last_name (Optional)
  # 設定内容: Amazon QuickSightアカウントの担当者の名前（姓）を指定します。
  # 設定可能な値: 文字列
  # 省略時: null（editionが"ENTERPRISE_AND_Q"の場合は必須）
  last_name = null

  # email_address (Optional)
  # 設定内容: 今後の連絡先として使用するAmazon QuickSightアカウント担当者の
  #           メールアドレスを指定します。
  # 設定可能な値: 有効なメールアドレス
  # 省略時: null（editionが"ENTERPRISE_AND_Q"の場合は必須）
  email_address = null

  # contact_number (Optional)
  # 設定内容: 今後の連絡先として使用するAmazon QuickSightアカウント担当者の
  #           10桁の電話番号を指定します。
  # 設定可能な値: 10桁の電話番号文字列
  # 省略時: null（editionが"ENTERPRISE_AND_Q"の場合は必須）
  contact_number = null

  #-------------------------------------------------------------
  # AWSアカウント設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: QuickSightサブスクリプションを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーが自動的に検出したアカウントIDを使用
  aws_account_id = null

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定する設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルト値を使用
    create = "30m"

    # read (Optional)
    # 設定内容: リソース読み取り操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルト値を使用
    read = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルト値を使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - account_subscription_status: Amazon QuickSightアカウントのサブスクリプションのステータス。
#                                 （例: "ACCOUNT_CREATED", "UNSUBSCRIBED"）
#
# - id: AWSアカウントID（aws_account_idと同一）
#---------------------------------------------------------------
