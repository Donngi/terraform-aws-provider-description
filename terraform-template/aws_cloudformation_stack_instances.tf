#---------------------------------------------------------------
# AWS CloudFormation Stack Instances
#---------------------------------------------------------------
#
# CloudFormation StackSetsのスタックインスタンスを管理するリソースです。
# スタックインスタンスとは、特定のアカウントとリージョンにデプロイされた
# スタックセット内の個々のスタックを指します。
#
# このリソースにより、指定したアカウントやOrganizations OUに対して
# 複数リージョンへのスタックインスタンスの一括デプロイが可能です。
#
# AWS公式ドキュメント:
#   - CloudFormation StackSets概要: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html
#   - スタックインスタンスの操作: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stackinstances-create.html
#   - StackSetsの前提条件: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-prereqs.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_instances
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudformation_stack_instances" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # stack_set_name (Required, Forces new resource)
  # 設定内容: スタックインスタンスを作成する対象のスタックセット名を指定します。
  # 設定可能な値: 既存のCloudFormation StackSet名
  # 注意: スタックセットは事前に aws_cloudformation_stack_set リソースで作成しておく必要があります。
  stack_set_name = aws_cloudformation_stack_set.example.name

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: これはTerraformリソース管理用のリージョンであり、スタックインスタンスのデプロイ先リージョンとは異なります。
  region = null

  #-------------------------------------------------------------
  # デプロイ先設定
  #-------------------------------------------------------------

  # accounts (Optional)
  # 設定内容: スタックインスタンスを作成する対象のAWSアカウントIDのリストを指定します。
  # 設定可能な値: 12桁のAWSアカウントIDのセット
  # 注意: accounts と deployment_targets は排他的です。どちらか一方のみ指定可能です。
  # 用途: 個別のアカウントを明示的に指定してデプロイする場合に使用します。
  accounts = ["123456789012", "234567890123"]

  # regions (Optional)
  # 設定内容: 指定したアカウントでスタックインスタンスを作成するリージョンのリストを指定します。
  # 設定可能な値: 有効なAWSリージョンコードのセット
  # 用途: マルチリージョンデプロイメントを行う際に、対象リージョンを指定します。
  regions = ["us-east-1", "us-west-2", "ap-northeast-1"]

  #-------------------------------------------------------------
  # Organizations デプロイターゲット設定
  #-------------------------------------------------------------

  # deployment_targets (Optional)
  # 設定内容: AWS Organizationsの組織単位(OU)を使用してデプロイ先を指定します。
  # 注意: accounts と deployment_targets は排他的です。どちらか一方のみ指定可能です。
  # 注意: 組織の管理アカウントにはスタックインスタンスはデプロイされません。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-orgs-delegated-admin.html
  deployment_targets {
    # organizational_unit_ids (Optional)
    # 設定内容: スタックセットをデプロイする組織ルートIDまたは組織単位(OU)IDを指定します。
    # 設定可能な値: Organization root ID (r-xxxx) または OU ID (ou-xxxx-xxxxxxxx) のセット
    # 用途: OU単位でスタックインスタンスを一括デプロイする場合に使用します。
    organizational_unit_ids = ["ou-xxxx-xxxxxxxx"]

    # accounts (Optional)
    # 設定内容: deployment_targets内で追加または除外するアカウントのリストを指定します。
    # 設定可能な値: 12桁のAWSアカウントIDのセット
    # 用途: account_filter_typeと組み合わせて、OU内の特定アカウントを対象にしたり除外したりします。
    accounts = null

    # accounts_url (Optional)
    # 設定内容: アカウントリストを含むS3ファイルのURLを指定します。
    # 設定可能な値: S3オブジェクトURL（例: s3://bucket-name/file.txt）
    # 用途: 大量のアカウントを管理する場合、S3ファイルでアカウントリストを外部管理できます。
    accounts_url = null

    # account_filter_type (Optional, Forces new resource)
    # 設定内容: デプロイターゲットの絞り込み方法を指定します。
    # 設定可能な値:
    #   - "INTERSECTION": OU内のアカウントとaccountsリストの共通部分のみを対象
    #   - "DIFFERENCE": OU内のアカウントからaccountsリストを除外
    #   - "UNION": OU内のアカウントとaccountsリストの両方を対象
    #   - "NONE": フィルタなし（OUの全アカウントを対象）
    # 用途: OU内の特定アカウントのみにデプロイしたい場合や、特定アカウントを除外したい場合に使用します。
    account_filter_type = null
  }

  #-------------------------------------------------------------
  # パラメータオーバーライド設定
  #-------------------------------------------------------------

  # parameter_overrides (Optional)
  # 設定内容: スタックセットのパラメータをインスタンス単位で上書きするキーバリューマップを指定します。
  # 設定可能な値: スタックセットテンプレートで定義されたパラメータ名と値のマップ
  # 用途: アカウントやリージョンごとに異なる設定値を適用したい場合に使用します。
  # 注意: ドリフト検出は最初のアカウントとリージョンに限定されます（各インスタンスで異なるパラメータを持つ可能性があるため）。
  parameter_overrides = {
    EnvironmentType = "production"
    InstanceType    = "t3.medium"
  }

  #-------------------------------------------------------------
  # 呼び出し元設定
  #-------------------------------------------------------------

  # call_as (Optional)
  # 設定内容: スタック操作の呼び出し元として、管理アカウントか委任管理者かを指定します。
  # 設定可能な値:
  #   - "SELF" (デフォルト): 管理アカウントとして操作を実行
  #   - "DELEGATED_ADMIN": 委任管理者アカウントとして操作を実行
  # 用途: AWS Organizationsの委任管理者機能を使用してStackSetsを管理する場合に"DELEGATED_ADMIN"を指定します。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-orgs-delegated-admin.html
  call_as = "SELF"

  #-------------------------------------------------------------
  # オペレーション設定
  #-------------------------------------------------------------

  # operation_preferences (Optional)
  # 設定内容: CloudFormationがスタックセット操作を実行する際の動作設定を指定します。
  # 用途: デプロイの並列度、エラー許容度、リージョン順序などを制御します。
  operation_preferences {
    # concurrency_mode (Optional)
    # 設定内容: 操作実行中の同時実行レベルの動作を指定します。
    # 設定可能な値:
    #   - "STRICT_FAILURE_TOLERANCE": 失敗許容度を厳密に適用。許容度を超えると即座に停止
    #   - "SOFT_FAILURE_TOLERANCE": 失敗許容度を緩やかに適用。進行中の操作は完了させてから停止
    concurrency_mode = null

    # failure_tolerance_count (Optional)
    # 設定内容: リージョンごとに操作が失敗しても続行できるアカウント数を指定します。
    # 設定可能な値: 0以上の整数
    # 注意: failure_tolerance_percentage と排他的です。
    failure_tolerance_count = 1

    # failure_tolerance_percentage (Optional)
    # 設定内容: リージョンごとに操作が失敗しても続行できるアカウントの割合を指定します。
    # 設定可能な値: 0-100の整数（パーセンテージ）
    # 注意: failure_tolerance_count と排他的です。
    failure_tolerance_percentage = null

    # max_concurrent_count (Optional)
    # 設定内容: 同時に操作を実行する最大アカウント数を指定します。
    # 設定可能な値: 1以上の整数
    # 注意: max_concurrent_percentage と排他的です。
    # 用途: API制限やリソース競合を避けるために同時実行数を制限する場合に使用します。
    max_concurrent_count = 5

    # max_concurrent_percentage (Optional)
    # 設定内容: 同時に操作を実行する最大アカウントの割合を指定します。
    # 設定可能な値: 1-100の整数（パーセンテージ）
    # 注意: max_concurrent_count と排他的です。
    max_concurrent_percentage = null

    # region_concurrency_type (Optional)
    # 設定内容: リージョン間でのスタックセット操作の実行方法を指定します。
    # 設定可能な値:
    #   - "SEQUENTIAL": リージョンを1つずつ順番にデプロイ
    #   - "PARALLEL": 複数リージョンを同時にデプロイ
    # 用途: デプロイのロールアウト戦略を制御する場合に使用します。
    region_concurrency_type = "PARALLEL"

    # region_order (Optional)
    # 設定内容: スタックセット操作を実行するリージョンの順序を指定します。
    # 設定可能な値: リージョンコードのリスト
    # 用途: region_concurrency_type が "SEQUENTIAL" の場合に、特定の順序でデプロイしたい場合に使用します。
    # 注意: region_concurrency_type が "PARALLEL" の場合は無視されます。
    region_order = null
  }

  #-------------------------------------------------------------
  # 削除時動作設定
  #-------------------------------------------------------------

  # retain_stacks (Optional)
  # 設定内容: Terraformでリソース削除時にスタックインスタンスのスタックを保持するかを指定します。
  # 設定可能な値:
  #   - true: スタックセットからスタックインスタンスを削除するが、実際のスタックは保持
  #   - false (デフォルト): スタックインスタンスとともにスタックも削除
  # 注意: trueを設定する場合、リソース削除前に terraform apply で状態に反映させる必要があります。
  # 注意: 保持されたスタックは再度関連付けることや、新しいスタックセットに追加することはできません。
  retain_stacks = false

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: スタックインスタンス作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    create = "30m"

    # update (Optional)
    # 設定内容: スタックインスタンス更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    update = "30m"

    # delete (Optional)
    # 設定内容: スタックインスタンス削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - stack_set_id: スタックセットの一意の識別子
#
# - stack_instance_summaries: Organizations OUデプロイターゲットから作成された
#   スタックインスタンスのリスト。deployment_targets が設定されている場合にのみ
#   値が設定されます。各インスタンスには以下の属性が含まれます:
#     - account_id: インスタンスがデプロイされているアカウントID
#     - detailed_status: スタックインスタンスの詳細ステータス
#       (PENDING, RUNNING, SUCCEEDED, FAILED, CANCELLED, INOPERABLE,
#        SKIPPED_SUSPENDED_ACCOUNT, FAILED_IMPORT)
#     - drift_status: スタックセットとの構成比較ステータス
#       (DRIFTED, IN_SYNC, UNKNOWN, NOT_CHECKED)
#     - organizational_unit_id: デプロイターゲットで指定したOUのID
#     - region: スタックインスタンスが関連付けられているリージョン
#     - stack_id: スタックインスタンスのID
#     - stack_set_id: スタックセットの名前または一意のID
#     - status: スタックセットとの同期状態
#       (CURRENT, OUTDATED, INOPERABLE)
#     - status_reason: ステータスコードの理由説明
#---------------------------------------------------------------
