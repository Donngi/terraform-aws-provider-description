#---------------------------------------------------------------
# AWS CloudFormation StackSet Instance
#---------------------------------------------------------------
#
# CloudFormation StackSetのスタックインスタンスを管理するリソースです。
# スタックインスタンスは、ターゲットアカウントおよびリージョンにおけるスタックへの
# 参照です。StackSet内で定義されたテンプレートに基づいて、指定されたアカウントと
# リージョンにスタックを作成・更新・削除します。
#
# 重要: ターゲットアカウントには、StackSetで設定された実行ロール名
# (aws_cloudformation_stack_setのexecution_role_name)と一致するIAMロールが必要です。
# このロールは管理アカウントまたは管理IAMロールとの信頼関係を持つ必要があります。
#
# AWS公式ドキュメント:
#   - StackSetsの概念: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-concepts.html
#   - StackSetsの前提条件: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-prereqs.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set_instance
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudformation_stack_set_instance" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # stack_set_name (Required)
  # 設定内容: スタックインスタンスを作成するStackSetの名前を指定します。
  # 設定可能な値: 既存のStackSet名
  # 注意: aws_cloudformation_stack_setリソースで作成したStackSetの名前を参照します。
  stack_set_name = aws_cloudformation_stack_set.example.name

  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: スタックを作成するターゲットAWSアカウントIDを指定します。
  # 設定可能な値: 有効な12桁のAWSアカウントID
  # 省略時: 現在のアカウントIDが使用されます。
  # 注意: deployment_targetsと排他的。単一アカウントへのデプロイ時に使用します。
  account_id = "123456789012"

  # stack_set_instance_region (Optional)
  # 設定内容: スタックを作成するターゲットAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: 現在のリージョンが使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html
  stack_set_instance_region = "us-east-1"

  # region (Optional, Deprecated)
  # 設定内容: スタックを作成するターゲットAWSリージョンを指定します。
  # 非推奨: stack_set_instance_regionを使用してください。
  # 省略時: 現在のリージョンが使用されます。
  # region = "us-east-1"

  #-------------------------------------------------------------
  # 呼び出し元設定
  #-------------------------------------------------------------

  # call_as (Optional)
  # 設定内容: 組織の管理アカウントとして操作するか、
  #          委任管理者として操作するかを指定します。
  # 設定可能な値:
  #   - "SELF" (デフォルト): 管理アカウントとして操作
  #   - "DELEGATED_ADMIN": 委任管理者として操作
  # 関連機能: AWS Organizations委任管理者
  #   CloudFormation StackSetsの操作を委任管理者アカウントに委任できます。
  #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-orgs-delegated-admin.html
  call_as = "SELF"

  #-------------------------------------------------------------
  # パラメータオーバーライド
  #-------------------------------------------------------------

  # parameter_overrides (Optional)
  # 設定内容: StackSetのパラメータをこのインスタンス用に上書きするキーバリューマップ。
  # 設定可能な値: StackSetテンプレートで定義されたパラメータ名と値のマップ
  # 用途: 特定のアカウントやリージョンで異なる設定値を使用したい場合に使用します。
  parameter_overrides = {
    InstanceType = "t3.medium"
    Environment  = "production"
  }

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # retain_stack (Optional)
  # 設定内容: Terraformリソース削除時にスタックを保持するかを指定します。
  # 設定可能な値:
  #   - true: StackSetからインスタンスを削除するが、スタックとリソースは保持
  #   - false (デフォルト): スタックとリソースも削除
  # 注意:
  #   - 効果を発揮するには、destroy前にTerraform stateに適用されている必要があります。
  #   - 保持されたスタックを再度StackSetに関連付けることはできません。
  #   - 既存の保持されたスタックを新しいStackSetに追加することもできません。
  retain_stack = false

  #-------------------------------------------------------------
  # デプロイメントターゲット (Organizations向け)
  #-------------------------------------------------------------

  # deployment_targets (Optional)
  # 設定内容: AWS Organizationsのアカウントにデプロイする場合のターゲット設定。
  # 注意:
  #   - account_idと排他的。Organizationsを使用する場合はこちらを使用します。
  #   - 組織の管理アカウントにはスタックインスタンスは作成されません。
  #   - ドリフト検出はこの引数に対してサポートされていません。
  deployment_targets {
    # organizational_unit_ids (Optional)
    # 設定内容: デプロイ先の組織ルートIDまたはOU (Organizational Unit) IDのセット。
    # 設定可能な値: 組織ルートID (例: r-xxxx) またはOU ID (例: ou-xxxx-xxxxxxxx)
    organizational_unit_ids = ["ou-1234-12345678"]

    # account_filter_type (Optional)
    # 設定内容: デプロイターゲットを個別アカウントに限定するか、
    #          追加アカウントを含めるかのフィルタータイプ。
    # 設定可能な値:
    #   - "INTERSECTION": accountsで指定したアカウントのみにデプロイ
    #   - "DIFFERENCE": accountsで指定したアカウントを除外してデプロイ
    #   - "UNION": OU内アカウントとaccountsで指定したアカウントの両方にデプロイ
    #   - "NONE": フィルタなし（OU内全アカウントにデプロイ）
    account_filter_type = "NONE"

    # accounts (Optional)
    # 設定内容: スタックセット更新をデプロイするアカウントのリスト。
    # 設定可能な値: AWSアカウントIDのセット
    # 用途: account_filter_typeと組み合わせて使用します。
    accounts = ["111111111111", "222222222222"]

    # accounts_url (Optional)
    # 設定内容: アカウントリストを含むファイルのS3 URL。
    # 設定可能な値: S3 URL (例: s3://bucket-name/path/to/accounts.txt)
    # 用途: 多数のアカウントをファイルで管理する場合に使用します。
    accounts_url = null
  }

  #-------------------------------------------------------------
  # オペレーション設定
  #-------------------------------------------------------------

  # operation_preferences (Optional)
  # 設定内容: StackSetオペレーションの実行方法に関する設定。
  # 用途: 大規模デプロイメント時の並行実行数や許容失敗数を制御します。
  operation_preferences {
    # failure_tolerance_count (Optional)
    # 設定内容: CloudFormationがオペレーションを停止する前に許容するリージョンごとの失敗数。
    # 設定可能な値: 0以上の整数
    # 注意: failure_tolerance_percentageと排他的。
    failure_tolerance_count = 1

    # failure_tolerance_percentage (Optional)
    # 設定内容: CloudFormationがオペレーションを停止する前に許容するリージョンごとの失敗割合。
    # 設定可能な値: 0-100の整数
    # 注意: failure_tolerance_countと排他的。
    # failure_tolerance_percentage = 10

    # max_concurrent_count (Optional)
    # 設定内容: 同時にオペレーションを実行するアカウントの最大数。
    # 設定可能な値: 1以上の整数
    # 注意: max_concurrent_percentageと排他的。
    max_concurrent_count = 5

    # max_concurrent_percentage (Optional)
    # 設定内容: 同時にオペレーションを実行するアカウントの最大割合。
    # 設定可能な値: 1-100の整数
    # 注意: max_concurrent_countと排他的。
    # max_concurrent_percentage = 50

    # concurrency_mode (Optional)
    # 設定内容: オペレーション実行中の並行レベルの動作を指定します。
    # 設定可能な値:
    #   - "STRICT_FAILURE_TOLERANCE": 失敗許容度を厳格に適用
    #   - "SOFT_FAILURE_TOLERANCE": 失敗許容度を柔軟に適用
    # 関連機能: StackSets並行モード
    #   - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/concurrency-mode.html
    concurrency_mode = "STRICT_FAILURE_TOLERANCE"

    # region_concurrency_type (Optional)
    # 設定内容: リージョン間のデプロイを並列で行うか順次で行うかを指定します。
    # 設定可能な値:
    #   - "SEQUENTIAL": リージョンを順番にデプロイ
    #   - "PARALLEL": リージョンを並列にデプロイ
    region_concurrency_type = "PARALLEL"

    # region_order (Optional)
    # 設定内容: スタックオペレーションを実行するリージョンの順序。
    # 設定可能な値: AWSリージョンコードのリスト
    # 用途: region_concurrency_typeがSEQUENTIALの場合に順序を指定します。
    region_order = ["us-east-1", "us-west-2", "eu-west-1"]
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの一意識別子。
#       deployment_targetsが設定されている場合:
#         StackSet名、OU ID（/区切り）、リージョンのカンマ区切り文字列
#         例: "mystack,ou-123/ou-456,us-east-1"
#       それ以外の場合:
#         StackSet名、AWSアカウントID、リージョンのカンマ区切り文字列
#         例: "mystack,123456789012,us-east-1"
#
# - organizational_unit_id: スタックがデプロイされている組織ルートIDまたはOU ID。
#
# - stack_id: スタック識別子。
#
# - stack_instance_summaries: deployment_targetsが設定されている場合に
#                             作成されたスタックインスタンスのリスト。
#                             各要素には以下が含まれます:
#                             - account_id: スタックがデプロイされているAWSアカウントID
#                             - organizational_unit_id: スタックがデプロイされているOU ID
#                             - stack_id: スタック識別子
#---------------------------------------------------------------
