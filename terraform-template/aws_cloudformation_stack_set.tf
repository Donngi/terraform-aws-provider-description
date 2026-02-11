#================================================================================
# Terraform AWS Provider Resource Template
#================================================================================
# Resource: aws_cloudformation_stack_set
# Provider Version: 6.28.0
# Generated: 2026-01-18
#
# NOTE: このテンプレートは生成時点(Provider v6.28.0)の情報に基づいています。
#       最新の仕様は公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set
#================================================================================

resource "aws_cloudformation_stack_set" "example" {
  #------------------------------------------------------------------------------
  # Required Arguments
  #------------------------------------------------------------------------------

  # StackSetの名前
  # 必須項目。StackSetが作成されるリージョン内で一意である必要がある。
  # 名前は英数字(大文字小文字を区別)とハイフンのみ使用可能で、
  # アルファベット文字で始まり、最大128文字まで。
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-concepts.html
  name = "example-stackset"

  #------------------------------------------------------------------------------
  # Optional Arguments - Basic Configuration
  #------------------------------------------------------------------------------

  # StackSetの説明
  # StackSetの目的や内容を説明する文字列。最大1024文字。
  description = "Example StackSet for multi-account deployment"

  # IAM管理者ロールのARN
  # SELF_MANAGED権限モデル使用時に必須。
  # StackSet操作を実行するための管理者アカウント内のIAMロール。
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-prereqs-self-managed.html
  administration_role_arn = "arn:aws:iam::123456789012:role/AWSCloudFormationStackSetAdministrationRole"

  # IAM実行ロール名
  # 全てのターゲットアカウントでStackSet操作に使用されるIAMロールの名前。
  # SELF_MANAGED権限モデル使用時のデフォルトは "AWSCloudFormationStackSetExecutionRole"。
  # SERVICE_MANAGED権限モデル使用時は定義しないこと。
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-prereqs-self-managed.html
  execution_role_name = "AWSCloudFormationStackSetExecutionRole"

  # 権限モデル
  # StackSetに必要なIAMロールの作成方法を指定。
  # 有効な値: SELF_MANAGED(デフォルト), SERVICE_MANAGED
  # - SELF_MANAGED: 管理者アカウントとターゲットアカウントにIAMロールを手動作成
  # - SERVICE_MANAGED: CloudFormationが自動的にIAMロールを作成(AWS Organizations連携時)
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-concepts.html
  permission_model = "SELF_MANAGED"

  # 呼び出し元の種類
  # 組織の管理アカウントの管理者として動作するか、
  # メンバーアカウントの委任管理者として動作するかを指定。
  # 有効な値: SELF(デフォルト), DELEGATED_ADMIN
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-orgs-delegated-admin.html
  call_as = "SELF"

  # CloudFormation機能
  # StackSetに許可する機能のリスト。
  # 有効な値: CAPABILITY_IAM, CAPABILITY_NAMED_IAM, CAPABILITY_AUTO_EXPAND
  # - CAPABILITY_IAM: テンプレートがIAMリソースを作成する場合に必要
  # - CAPABILITY_NAMED_IAM: 名前付きIAMリソースを作成する場合に必要
  # - CAPABILITY_AUTO_EXPAND: テンプレートにマクロやネストされたスタックが含まれる場合に必要
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStackSet.html
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  #------------------------------------------------------------------------------
  # Optional Arguments - Template Configuration
  #------------------------------------------------------------------------------

  # CloudFormationテンプレート本体
  # CloudFormationテンプレートを含む文字列。最大サイズ: 51,200バイト。
  # template_urlと競合するため、どちらか一方のみ指定可能。
  # 全てのテンプレートパラメータ(Defaultを持つものを含む)は設定するか、
  # lifecycleのignore_changesで無視する必要がある。
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html
  template_body = jsonencode({
    Parameters = {
      VPCCidr = {
        Type        = "String"
        Default     = "10.0.0.0/16"
        Description = "VPC CIDR block"
      }
    }
    Resources = {
      VPC = {
        Type = "AWS::EC2::VPC"
        Properties = {
          CidrBlock = { Ref = "VPCCidr" }
        }
      }
    }
  })

  # CloudFormationテンプレートURL
  # CloudFormationテンプレート本体を含むファイルの場所を示すURL。
  # Amazon S3バケット内のテンプレートを指している必要がある。
  # 最大ファイルサイズ: 460,800バイト。
  # template_bodyと競合するため、どちらか一方のみ指定可能。
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-using-console-create-stack-template.html
  # template_url = "https://s3.amazonaws.com/my-bucket/template.json"

  # テンプレートパラメータ
  # StackSetテンプレートの入力パラメータのキー・バリューマップ。
  # 全てのテンプレートパラメータ(Defaultを持つものを含む)は設定するか、
  # lifecycleのignore_changesで無視する必要がある。
  # NoEchoパラメータは必ずignore_changesで無視すること。
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html
  parameters = {
    VPCCidr = "10.0.0.0/16"
  }

  #------------------------------------------------------------------------------
  # Optional Arguments - Auto Deployment (SERVICE_MANAGED only)
  #------------------------------------------------------------------------------

  # 自動デプロイ設定
  # StackSetの自動デプロイモデルを含む設定ブロック。
  # SERVICE_MANAGED権限モデル使用時のみ定義可能。
  # AWS Organizationsに新しいアカウントが追加された際の動作を制御。
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-orgs-associate-stackset-with-org.html
  auto_deployment {
    # 自動デプロイの有効化
    # trueの場合、対象のOUにアカウントが追加されたときに自動的にスタックがデプロイされる。
    enabled = true

    # アカウント削除時のスタック保持
    # アカウントがOUから削除された際にスタックを保持するかどうか。
    # trueの場合、アカウント削除後もスタックは残る。
    # falseの場合、アカウント削除時にスタックも削除される。
    retain_stacks_on_account_removal = false
  }

  #------------------------------------------------------------------------------
  # Optional Arguments - Managed Execution
  #------------------------------------------------------------------------------

  # マネージド実行設定
  # StackSetsが非競合操作を同時実行し、競合操作をキューイングできるようにする設定。
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-concepts.html
  managed_execution {
    # マネージド実行の有効化
    # trueに設定すると、StackSetsは非競合操作を同時に実行し、
    # 競合操作を待機させる。競合操作が終了すると、
    # キューに入っている操作がリクエスト順に開始される。
    # デフォルトはfalse。
    active = true
  }

  #------------------------------------------------------------------------------
  # Optional Arguments - Operation Preferences
  #------------------------------------------------------------------------------

  # 操作の優先設定
  # CloudFormationがStackSet更新を実行する際のユーザー指定の設定。
  # リージョンやアカウントへの並列デプロイの制御、失敗許容度などを設定。
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-concepts.html
  operation_preferences {
    # 失敗許容数
    # リージョンごとに、この操作が失敗してもよいアカウント数。
    # この数を超えると、CloudFormationはそのリージョンでの操作を停止する。
    # failure_tolerance_percentageと排他的に使用。
    failure_tolerance_count = 1

    # 失敗許容率
    # リージョンごとに、この操作が失敗してもよいアカウントの割合(%)。
    # この割合を超えると、CloudFormationはそのリージョンでの操作を停止する。
    # failure_tolerance_countと排他的に使用。
    # failure_tolerance_percentage = 25

    # 最大同時実行数
    # 一度に操作を実行する最大アカウント数。
    # max_concurrent_percentageと排他的に使用。
    max_concurrent_count = 5

    # 最大同時実行率
    # 一度に操作を実行するアカウントの最大割合(%)。
    # max_concurrent_countと排他的に使用。
    # max_concurrent_percentage = 50

    # リージョン同時実行タイプ
    # リージョンへのStackSets操作のデプロイの同時実行タイプ。
    # 並列実行または一度に1つのリージョンで実行するかを指定。
    # 有効な値: SEQUENTIAL, PARALLEL
    region_concurrency_type = "SEQUENTIAL"

    # リージョン順序
    # スタック操作を実行するリージョンの順序。
    # region_concurrency_typeがSEQUENTIALの場合に使用。
    region_order = ["us-east-1", "us-west-2", "eu-west-1"]
  }

  #------------------------------------------------------------------------------
  # Optional Arguments - Resource Management
  #------------------------------------------------------------------------------

  # リージョン指定
  # このリソースが管理されるリージョン。
  # デフォルトはプロバイダー設定で指定されたリージョン。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # タグ
  # このStackSetおよびそこから作成されるStackに関連付けるタグのキー・バリューマップ。
  # CloudFormationは、スタック内で作成されるサポート対象のリソースにもこれらのタグを伝播する。
  # 最大50個のタグを指定可能。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # キーが一致するタグはプロバイダーレベルで定義されたものを上書きする。
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-resource-tags.html
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Project     = "multi-account-deployment"
  }

  #------------------------------------------------------------------------------
  # Lifecycle Configuration (参考例)
  #------------------------------------------------------------------------------

  # lifecycle {
  #   # テンプレートパラメータの変更を無視する場合
  #   # NoEchoパラメータやDefaultを持つパラメータで、
  #   # Terraform管理外の変更を許容する場合に使用
  #   ignore_changes = [
  #     parameters,
  #     template_body,
  #   ]
  # }

  #------------------------------------------------------------------------------
  # Timeouts
  #------------------------------------------------------------------------------

  timeouts {
    # 更新操作のタイムアウト
    # StackSetの更新操作に許容する最大時間。
    # デフォルトは30分。大規模なStackSetや複数リージョンへのデプロイでは延長を推奨。
    update = "60m"
  }
}

#================================================================================
# Computed Attributes (読み取り専用)
#================================================================================
# 以下の属性はTerraformで自動的に設定され、参照のみ可能です:
#
# - arn: StackSetのAmazon Resource Name (ARN)
# - id: StackSetの名前
# - stack_set_id: StackSetの一意の識別子
# - tags_all: リソースに割り当てられたタグのマップ(プロバイダーのdefault_tagsから継承されたものを含む)
# - execution_role_name: 設定されていない場合、computed値として返される
# - template_body: template_urlを使用している場合、computed値として返される
# - region: 指定されていない場合、プロバイダー設定のリージョンが返される
#================================================================================

#================================================================================
# 使用上の注意
#================================================================================
# 1. Permission Models:
#    - SELF_MANAGED: administration_role_arnとexecution_role_nameが必要
#    - SERVICE_MANAGED: auto_deploymentブロックの使用が可能、execution_role_nameは不要
#
# 2. Template Parameters:
#    - 全てのパラメータ(Defaultありを含む)を設定するか、ignore_changesで無視すること
#    - NoEchoパラメータは必ずignore_changesで無視すること
#
# 3. Delegated Administrator:
#    - call_as = "DELEGATED_ADMIN"を使用する場合、
#      IAMユーザーまたはロールにorganizations:ListDelegatedAdministrators権限が必要
#
# 4. Template Conflicts:
#    - template_bodyとtemplate_urlは排他的。どちらか一方のみ指定可能
#
# 5. Stack Instances:
#    - StackSetの作成後、aws_cloudformation_stack_set_instanceリソースを使用して
#      特定のアカウント・リージョンにスタックインスタンスをデプロイする必要がある
#
# 参考リンク:
# - StackSets概要: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html
# - Self-Managed権限: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-prereqs-self-managed.html
# - Service-Managed権限: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-orgs-associate-stackset-with-org.html
#================================================================================
