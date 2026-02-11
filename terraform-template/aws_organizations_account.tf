#---------------------------------------------------------------
# AWS Organizations Account
#---------------------------------------------------------------
#
# AWS Organizationsで管理される組織内にメンバーアカウントを作成するリソースです。
# 既存のAWSアカウントをインポートすることはできず、新規のアカウント作成のみ可能です。
#
# 重要な注意事項:
#   - アカウント管理操作は組織のルートアカウントから実行する必要があります
#   - デフォルトでは、このリソースを削除しても組織からアカウントを削除するのみで、
#     アカウント自体はクローズされません
#   - close_on_deletion=trueを設定するとアカウントをクローズできますが、
#     クォータ制限により CLOSE_ACCOUNT_QUOTA_EXCEEDED エラーが発生する可能性があり、
#     その場合は手動でアカウントをクローズする必要があります
#   - GovCloudアカウントでは close_on_deletion はサポートされていません
#
# AWS公式ドキュメント:
#   - AWS Organizations とは: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html
#   - CreateAccount API: https://docs.aws.amazon.com/organizations/latest/APIReference/API_CreateAccount.html
#   - CloseAccount API: https://docs.aws.amazon.com/organizations/latest/APIReference/API_CloseAccount.html
#   - CreateGovCloudAccount API: https://docs.aws.amazon.com/organizations/latest/APIReference/API_CreateGovCloudAccount.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_organizations_account" "example" {
  #-------------------------------------------------------------
  # 基本設定 (Required)
  #-------------------------------------------------------------

  # email (Required)
  # 設定内容: 新しいメンバーアカウントの所有者に割り当てるメールアドレスを指定します。
  # 設定可能な値: 有効なメールアドレス形式の文字列
  # 制約事項: このメールアドレスは他のAWSアカウントに既に関連付けられていないものを
  #           使用する必要があります。各AWSアカウントには一意のメールアドレスが必要です。
  # 推奨事項: 組織的な管理を考慮し、個人のメールアドレスではなく、チームや部門の
  #           メール配信リスト（例: aws-dev-team@example.com）の使用を推奨します。
  # 参考: https://docs.aws.amazon.com/organizations/latest/APIReference/API_CreateAccount.html
  email = "aws-account-001@example.com"

  # name (Required)
  # 設定内容: メンバーアカウントのわかりやすい名前を指定します。
  # 設定可能な値: 任意の文字列
  # 文字制限: 詳細は公式ドキュメントを参照してください
  # 用途: AWS Organizations のコンソールやAPI応答で表示される識別用の名前です。
  #       アカウントの目的や環境（開発、本番等）を含めた命名を推奨します。
  # 参考: https://docs.aws.amazon.com/organizations/latest/APIReference/API_CreateAccount.html
  name = "Development Account 001"

  #-------------------------------------------------------------
  # アカウント削除設定 (Optional)
  #-------------------------------------------------------------

  # close_on_deletion (Optional)
  # 設定内容: Terraformでのリソース削除時にアカウントをクローズするかどうかを指定します。
  # 設定可能な値:
  #   - true: 削除時にアカウントをクローズします（アカウントの完全削除）
  #   - false: 削除時に組織からのみ削除します（デフォルト動作）
  # 省略時: false（組織からの削除のみ）
  # 注意事項:
  #   - GovCloudアカウントではサポートされていません
  #   - アカウントのクローズにはクォータ制限があり、
  #     CLOSE_ACCOUNT_QUOTA_EXCEEDED エラーが発生する可能性があります
  #   - エラーが発生した場合は、手動でアカウントをクローズする必要があります
  #   - アカウントをクローズすると、通常90日間の猶予期間中のみ再開可能です
  # 参考: https://docs.aws.amazon.com/organizations/latest/APIReference/API_CloseAccount.html
  close_on_deletion = false

  #-------------------------------------------------------------
  # GovCloudアカウント作成設定 (Optional)
  #-------------------------------------------------------------

  # create_govcloud (Optional)
  # 設定内容: 商用アカウントと連携したGovCloudアカウントを同時に作成するかどうかを指定します。
  # 設定可能な値:
  #   - true: GovCloudアカウントを作成します
  #   - false: GovCloudアカウントを作成しません（デフォルト）
  # 省略時: false
  # 用途: 米国政府機関や規制対象の顧客向けにGovCloud環境が必要な場合に使用します。
  #       FedRAMPやDoDコンプライアンス要件を満たす必要がある場合に有効です。
  # 補足: trueに設定した場合、GovCloudアカウントIDは govcloud_id 属性で参照できます。
  #       GovCloudアカウントをTerraformで管理するには、後続でインポートする必要があります。
  # 参考: https://docs.aws.amazon.com/organizations/latest/APIReference/API_CreateGovCloudAccount.html
  create_govcloud = false

  #-------------------------------------------------------------
  # IAMアクセス設定 (Optional)
  #-------------------------------------------------------------

  # iam_user_access_to_billing (Optional)
  # 設定内容: IAMユーザーとロールが請求情報にアクセスできるかどうかを指定します。
  # 設定可能な値:
  #   - "ALLOW": IAMユーザーとロールが必要な権限を持っている場合、請求情報にアクセス可能
  #   - "DENY": ルートユーザーのみが請求情報にアクセス可能（ロールも含めてIAMからのアクセス不可）
  # 省略時: AWS APIのデフォルト（"ALLOW"）が適用されます
  # 注意事項: この設定を変更すると、リソースの再作成が試行されます
  # 推奨事項: セキュリティポリシーに応じて設定してください。一般的には "ALLOW" を設定し、
  #           IAMポリシーで詳細なアクセス制御を行うことを推奨します。
  # 参考: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/control-access-billing.html
  iam_user_access_to_billing = "ALLOW"

  #-------------------------------------------------------------
  # 組織構造設定 (Optional)
  #-------------------------------------------------------------

  # parent_id (Optional)
  # 設定内容: アカウントを配置する親となる組織単位（OU）IDまたはルートIDを指定します。
  # 設定可能な値:
  #   - OU ID（例: "ou-xxxx-xxxxxxxx"）
  #   - Root ID（例: "r-xxxx"）
  # 省略時: 組織のデフォルトルートIDが使用されます
  # 用途: 組織内でアカウントを論理的にグループ化し、階層構造を作成する際に使用します。
  #       OUごとに異なるSCPを適用することで、きめ細かなアクセス制御が可能になります。
  # 注意事項: ドリフト検出を実行するには、この引数の設定が必要です
  # 例: 本番環境用OU、開発環境用OUなどに分類することで環境ごとの管理が容易になります
  # 参考: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous.html
  parent_id = null

  #-------------------------------------------------------------
  # IAMロール設定 (Optional)
  #-------------------------------------------------------------

  # role_name (Optional)
  # 設定内容: 新しいメンバーアカウントで自動的に事前設定されるIAMロールの名前を指定します。
  # 設定可能な値: IAMロール名として有効な文字列
  # 省略時: デフォルトのロール名（"OrganizationAccountAccessRole"）が使用されます
  # 機能説明:
  #   - このロールはルートアカウントを信頼し、ルートアカウントのユーザーがこのロールを
  #     引き受けることを許可します
  #   - ロールにはメンバーアカウントの管理者権限が付与されます
  #   - 管理アカウントからメンバーアカウントへのクロスアカウントアクセスに使用されます
  # 注意事項:
  #   - Organizations APIは、アカウント作成後にこの情報を読み取る方法を提供していません
  #   - そのため、Terraformはドリフト検出を実行できず、インポート後は常に差分が表示されます
  #   - ignore_changes を使用して、インポート後の差分表示を抑制することを推奨します
  # 参考: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html
  role_name = "OrganizationAccountAccessRole"

  #-------------------------------------------------------------
  # タグ設定 (Optional)
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するキーと値のペアのマップです。
  # 設定可能な値: キーと値の文字列マップ
  # 用途: アカウントの識別、分類、コスト配分などに使用します。
  #       環境（Environment）、プロジェクト（Project）、コストセンター（CostCenter）などの
  #       タグを付与することで、アカウント管理とコスト追跡が容易になります。
  # 注意事項: プロバイダーの default_tags 設定ブロックで定義されたタグとキーが一致する場合、
  #           このタグ設定が優先されます。
  # 推奨事項:
  #   - 組織全体で統一されたタグ戦略を策定し、一貫したタグ付けを行うことを推奨します
  #   - ManagedBy, Environment, CostCenter, Owner などの標準タグを定義することで管理が容易になります
  # 参考: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Environment = "Development"
    Project     = "Example Project"
    ManagedBy   = "Terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間を設定します。
  # 用途: アカウント作成や削除などの操作は時間がかかる場合があるため、
  #       デフォルトのタイムアウト時間を変更する必要がある場合に使用します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 推奨値: アカウント作成は通常数分で完了しますが、状況により時間がかかる場合があるため、
    #         30分程度を推奨します
    create = null

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    update = null

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 推奨値: close_on_deletion=true の場合、アカウントのクローズには時間がかかるため、
    #         十分なタイムアウト時間を設定することを推奨します
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: このアカウントのARN
#        形式: arn:aws:organizations::123456789012:account/o-xxxxxxxxxxxx/123456789012
#
# - govcloud_id: GovCloudアカウントを作成した場合のGovCloudアカウントID
#                （create_govcloud=true の場合のみ設定されます）
#
# - id: AWSアカウントID（12桁の数字）
#
# - joined_method: アカウントが組織に参加した方法
#                  可能な値: "CREATED" (組織から作成), "INVITED" (招待により参加)
#
# - joined_timestamp: アカウントが組織の一部になった日時
#                     形式: RFC3339形式のタイムスタンプ（例: 2024-01-15T10:30:00Z）
#
# - state: 組織内のアカウントの状態
#          主な値: "ACTIVE", "SUSPENDED", "PENDING_CLOSURE"
#
# - status: (非推奨 - 代わりに state を使用してください)
#           組織内のアカウントのステータス
#
#---------------------------------------------------------------
