#---------------------------------------------------------------
# AWS QuickSight Role Custom Permission
#---------------------------------------------------------------
#
# QuickSightのロールに対してカスタムパーミッションを関連付けるリソースです。
# カスタムパーミッションプロファイルを使用することで、READER、AUTHOR、ADMIN
# などの標準ロールに対して、より細かい権限制御を追加することができます。
#
# AWS公式ドキュメント:
#   - QuickSight カスタムパーミッション: https://docs.aws.amazon.com/quicksight/latest/user/custom-permissions.html
#   - QuickSight ユーザーロール: https://docs.aws.amazon.com/quicksight/latest/user/user-management.html
#   - QuickSight API Reference: https://docs.aws.amazon.com/quicksight/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_role_custom_permission
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_role_custom_permission" "example" {
  #-------------------------------------------------------------
  # ロール設定 (Required)
  #-------------------------------------------------------------

  # role (Required, Forces new resource)
  # 設定内容: カスタムパーミッションを関連付けるQuickSightロールを指定します。
  # 設定可能な値:
  #   - "READER": 標準のReaderロール（ダッシュボードの閲覧のみ）
  #   - "AUTHOR": 標準のAuthorロール（ダッシュボードの作成と編集）
  #   - "ADMIN": 標準のAdminロール（QuickSightの管理権限）
  #   - "READER_PRO": QuickSight Enterpriseのプロフェッショナル版Reader
  #   - "AUTHOR_PRO": QuickSight Enterpriseのプロフェッショナル版Author
  #   - "ADMIN_PRO": QuickSight Enterpriseのプロフェッショナル版Admin
  # 注意: この値を変更すると、リソースが再作成されます（Forces new resource）。
  # 関連機能: QuickSight User Roles
  #   各ロールには標準で定義された権限セットがありますが、カスタムパーミッションを
  #   関連付けることで、より細かい権限制御が可能になります。
  #   - https://docs.aws.amazon.com/quicksight/latest/user/user-management.html
  role = "READER"

  #-------------------------------------------------------------
  # カスタムパーミッション設定 (Required)
  #-------------------------------------------------------------

  # custom_permissions_name (Required, Forces new resource)
  # 設定内容: 関連付けるカスタムパーミッションプロファイルの名前を指定します。
  # 設定可能な値: 事前に作成されたカスタムパーミッションプロファイル名
  # 注意: この値を変更すると、リソースが再作成されます（Forces new resource）。
  # 前提条件: aws_quicksight_custom_permissionsリソースで事前にカスタムパーミッション
  #           プロファイルを作成しておく必要があります。
  # 関連リソース:
  #   - aws_quicksight_custom_permissions: カスタムパーミッションプロファイルの定義
  # 参考: https://docs.aws.amazon.com/quicksight/latest/user/custom-permissions.html
  custom_permissions_name = "example-custom-permissions"

  #-------------------------------------------------------------
  # アカウント設定 (Optional)
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: QuickSightロールカスタムパーミッションを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraformプロバイダーに設定されているアカウントIDが自動的に使用されます。
  # 注意: この値を変更すると、リソースが再作成されます（Forces new resource）。
  # 用途: マルチアカウント環境でQuickSightを管理する場合に、特定のアカウントを
  #       明示的に指定する際に使用します。
  aws_account_id = null

  #-------------------------------------------------------------
  # Namespace設定 (Optional)
  #-------------------------------------------------------------

  # namespace (Optional, Forces new resource)
  # 設定内容: QuickSightのネームスペースを指定します。
  # 設定可能な値: ネームスペース名の文字列
  # 省略時: "default" ネームスペースが使用されます。
  # 注意: この値を変更すると、リソースが再作成されます（Forces new resource）。
  # 関連機能: QuickSight Namespaces
  #   ネームスペースは、QuickSightのリソース（ユーザー、グループ、ダッシュボードなど）を
  #   論理的に分離するための仕組みです。通常はデフォルトネームスペースで十分ですが、
  #   マルチテナント環境などでリソースを分離する必要がある場合に使用します。
  #   - https://docs.aws.amazon.com/quicksight/latest/user/namespaces.html
  namespace = null

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョンが使用されます。
  # 用途: 特定のリージョンでQuickSightリソースを管理する必要がある場合に使用します。
  # 注意: QuickSightは一部のリージョンでのみ利用可能です。利用可能なリージョンは
  #       公式ドキュメントを確認してください。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは標準的なTerraformのid属性をエクスポートします。
#
# - id: リソースの識別子
#       形式の詳細については公式ドキュメントを参照してください
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のQuickSightロールカスタムパーミッションは以下の形式でインポートできます:
#
# terraform import aws_quicksight_role_custom_permission.example <aws_account_id>/<namespace>/<role>/<custom_permissions_name>
#
# 例:
# terraform import aws_quicksight_role_custom_permission.example 123456789012/default/READER/my-custom-permissions
#---------------------------------------------------------------
