# ------------------------------------------------------------------------------ 
# AWS DLM Lifecycle Policy - Annotated Template
# ------------------------------------------------------------------------------ 
# Generated: 2026-01-22
# Provider Version: hashicorp/aws 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-22)の情報に基づいています。
#       最新の仕様については、必ず公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dlm_lifecycle_policy
#
# このリソースについて:
# Amazon Data Lifecycle Manager (DLM) のライフサイクルポリシーを提供します。
# EBSスナップショット、EBS-backed AMI、クロスリージョンコピー、
# スナップショット共有の自動管理を行います。
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/ebs/latest/userguide/snapshot-lifecycle.html
# ------------------------------------------------------------------------------ 

resource "aws_dlm_lifecycle_policy" "example" {
  # ------------------------------------------------------------------------------ 
  # 必須パラメータ
  # ------------------------------------------------------------------------------ 

  # description - (Required) DLMライフサイクルポリシーの説明
  # ポリシーの目的や対象を明確に記述してください
  description = "Example DLM lifecycle policy for EBS snapshots"

  # execution_role_arn - (Required) DLMサービスが引き受け可能なIAMロールのARN
  # DLMがスナップショットの作成・削除などの操作を行うために必要です
  # 参考: https://docs.aws.amazon.com/dlm/latest/APIReference/API_CreateLifecyclePolicy.html
  execution_role_arn = "arn:aws:iam::123456789012:role/service-role/AWSDataLifecycleManagerDefaultRole"

  # ------------------------------------------------------------------------------ 
  # オプションパラメータ
  # ------------------------------------------------------------------------------ 

  # default_policy - (Optional) 作成するデフォルトポリシーのタイプを指定
  # 有効な値: "VOLUME" または "INSTANCE"
  # デフォルトポリシーは簡素化されたポリシーで、タグベースのターゲティングなしで
  # すべてのリソースに適用されます
  # default_policy = "VOLUME"

  # state - (Optional) ライフサイクルポリシーを有効または無効にするか
  # 有効な値: "ENABLED" または "DISABLED"
  # デフォルト: "ENABLED"
  state = "ENABLED"

  # tags - (Optional) リソースタグのキー・バリューマップ
  # provider の default_tags 設定ブロックが存在する場合、
  # マッチするキーを持つタグはプロバイダーレベルで定義されたものを上書きします
  tags = {
    Name        = "example-dlm-policy"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  # tags_all - (Optional) computed
  # プロバイダーの default_tags から継承したタグを含む、
  # リソースに割り当てられたすべてのタグのマップ
  # Note: これはcomputed属性のため、通常は指定不要です

  # id - (Optional) DLMライフサイクルポリシーの識別子
  # Note: Terraformによって自動生成されるため、通常は指定不要です
  # id = "dlm-policy-12345678"

  # region - (Optional) このリソースが管理されるリージョン
  # デフォルト: プロバイダー設定で設定されたリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ------------------------------------------------------------------------------ 
  # policy_details ブロック - (Required) ポリシーの詳細設定
  # ------------------------------------------------------------------------------ 
  policy_details {
    # ----------------------------------------------------------------------------
    # Policy Details - 基本設定
    # ----------------------------------------------------------------------------

    # policy_type - (Optional) ポリシーが管理できる有効なターゲットリソースタイプとアクション
    # 有効な値:
    #   - "EBS_SNAPSHOT_MANAGEMENT": Amazon EBSスナップショットのライフサイクルを管理
    #   - "IMAGE_MANAGEMENT": EBS-backed AMIのライフサイクルを管理
    #   - "EVENT_BASED_POLICY": AWSアカウント内で定義されたイベント発生時に特定のアクションを実行
    # デフォルト: "EBS_SNAPSHOT_MANAGEMENT"
    policy_type = "EBS_SNAPSHOT_MANAGEMENT"

    # resource_types - (Optional) ライフサイクルポリシーの対象となるリソースタイプのリスト
    # 有効な値: "VOLUME" および "INSTANCE"
    # スナップショットポリシーまたはAMIポリシーで使用
    resource_types = ["VOLUME"]

    # resource_type - (Optional, デフォルトポリシーのみ) 作成するデフォルトポリシーのタイプ
    # 有効な値: "VOLUME" および "INSTANCE"
    # resource_type = "VOLUME"

    # resource_locations - (Optional) バックアップするリソースの場所
    # 有効な値:
    #   - "CLOUD": ソースリソースがAWSリージョンにある場合
    #   - "OUTPOST": ソースリソースがアカウント内のOutpostにある場合
    #   - "LOCAL_ZONE": ソースリソースがLocal Zoneにある場合
    # resource_locations = ["CLOUD"]

    # target_tags - (Optional) このポリシーの対象リソースを識別する単一のタグ
    # リソースがこのタグを持っている場合、ポリシーの対象となります
    target_tags = {
      Backup = "true"
    }

    # policy_language - (Optional) 作成するポリシーのタイプ
    # 有効な値:
    #   - "SIMPLIFIED": デフォルトポリシーを作成
    #   - "STANDARD": カスタムポリシーを作成
    # policy_language = "STANDARD"

    # copy_tags - (Optional, デフォルトポリシーのみ) ポリシーがソースリソースから
    # スナップショットまたはAMIにタグをコピーするかどうか
    # デフォルト: false
    # copy_tags = false

    # create_interval - (Optional, デフォルトポリシーのみ) ポリシーを実行して
    # スナップショットまたはAMIを作成する頻度
    # 有効な値: 1から7の範囲
    # デフォルト: 1
    # create_interval = 1

    # retain_interval - (Optional, デフォルトポリシーのみ) ポリシーがスナップショットまたは
    # AMIを削除する前に保持する期間
    # 有効な値: 2から14の範囲
    # デフォルト: 7
    # retain_interval = 7

    # extend_deletion - (Optional, デフォルトポリシーのみ) ソースボリュームまたはインスタンスが
    # 削除された場合、またはポリシーがエラー、無効、削除状態に入った場合の
    # スナップショットまたはAMI保持動作
    # デフォルト: false
    # extend_deletion = false

    # --------------------------------------------------------------------------
    # exclusions ブロック - (Optional, デフォルトポリシーのみ)
    # スナップショットまたはAMIを作成しないボリュームまたはインスタンスの除外パラメータ
    # --------------------------------------------------------------------------
    # exclusions {
    #   # exclude_boot_volumes - (Optional) ブートボリュームとしてインスタンスに
    #   # アタッチされているボリュームを除外するかどうか
    #   # ブートボリュームを除外する場合は true を指定
    #   exclude_boot_volumes = false
    #
    #   # exclude_tags - (Optional) 特定のタグを持つボリュームを除外するかどうかを指定するマップ
    #   exclude_tags = {
    #     ExcludeBackup = "true"
    #   }
    #
    #   # exclude_volume_types - (Optional) 除外するボリュームタイプのリスト
    #   # 有効な値: "gp2", "gp3", "io1", "io2", "st1", "sc1", "standard"
    #   exclude_volume_types = ["gp2"]
    # }

    # --------------------------------------------------------------------------
    # parameters ブロック - (Optional)
    # スナップショットおよびAMIライフサイクルポリシーのオプションパラメータセット
    # --------------------------------------------------------------------------
    # parameters {
    #   # exclude_boot_volume - (Optional) CreateSnapshotsを使用して作成された
    #   # スナップショットからルートボリュームを除外するかどうか
    #   # デフォルト: false
    #   exclude_boot_volume = false
    #
    #   # no_reboot - (Optional) AMIライフサイクルポリシーのみに適用
    #   # ライフサイクルポリシー実行時にターゲットインスタンスを再起動するかどうか
    #   # true: ターゲットインスタンスはポリシー実行時に再起動されません
    #   # false: ターゲットインスタンスはポリシー実行時に再起動されます
    #   # デフォルト: true (インスタンスは再起動されません)
    #   no_reboot = true
    # }

    # --------------------------------------------------------------------------
    # action ブロック - (Optional, イベントベースポリシーのみ)
    # イベントベースポリシーがトリガーされたときに実行されるアクション
    # ポリシーごとに1つのアクションのみ指定可能
    # スナップショットまたはAMIポリシーを作成する場合は、このパラメータを省略してください
    # --------------------------------------------------------------------------
    # action {
    #   # name - (Required) アクションの説明的な名前
    #   name = "cross-region-copy-action"
    #
    #   # cross_region_copy ブロック - (Optional) 共有スナップショットを
    #   # リージョン間でコピーするためのルール
    #   # 最小1、最大3のブロックを指定可能
    #   cross_region_copy {
    #     # target - (Required) スナップショットコピーのターゲットリージョンまたは
    #     # ターゲットOutpostのAmazon Resource Name (ARN)
    #     target = "us-west-2"
    #
    #     # encryption_configuration ブロック - (Required)
    #     # コピーされたスナップショットの暗号化設定
    #     # アクションごとに最大1つ
    #     encryption_configuration {
    #       # encrypted - (Required) デフォルトで暗号化が有効でない場合に
    #       # 暗号化されていないスナップショットのコピーを暗号化するには、
    #       # このパラメータを使用して暗号化を有効にします
    #       # 暗号化されたスナップショットのコピーは、このパラメータがfalseの場合でも
    #       # または暗号化がデフォルトで有効でない場合でも暗号化されます
    #       encrypted = true
    #
    #       # cmk_arn - (Optional) EBS暗号化に使用するAWS KMSキーのARN
    #       # このパラメータが指定されていない場合、アカウントのデフォルトKMSキーが使用されます
    #       cmk_arn = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
    #     }
    #
    #     # retain_rule ブロック - (Required)
    #     # クロスリージョンスナップショットコピーの保持ルール
    #     # アクションごとに最大1つ
    #     retain_rule {
    #       # interval - (Required) 各スナップショットを保持する期間
    #       # 最大100年。これは1200か月、5200週、または36500日に相当します
    #       interval = 30
    #
    #       # interval_unit - (Required) 時間ベースの保持の時間単位
    #       # 有効な値: "DAYS", "WEEKS", "MONTHS", "YEARS"
    #       interval_unit = "DAYS"
    #     }
    #   }
    # }

    # --------------------------------------------------------------------------
    # event_source ブロック - (Optional, イベントベースポリシーのみ)
    # イベントベースポリシーをトリガーするイベント
    # スナップショットまたはAMIポリシーを作成する場合は、このパラメータを省略してください
    # --------------------------------------------------------------------------
    # event_source {
    #   # type - (Required) イベントのソース
    #   # 現在、マネージドCloudWatch Eventsルールのみがサポートされています
    #   # 有効な値: "MANAGED_CWE"
    #   type = "MANAGED_CWE"
    #
    #   # parameters ブロック - (Required) イベントに関する情報
    #   # 最小1、最大1のブロック
    #   parameters {
    #     # description_regex - (Required) ポリシーをトリガーできる
    #     # スナップショットの説明。説明パターンは正規表現を使用して指定されます
    #     # ポリシーは、指定されたパターンに一致する説明を持つスナップショットが
    #     # アカウントと共有された場合にのみ実行されます
    #     description_regex = "^.*Created for policy: policy-1234567890abcdef0.*$"
    #
    #     # event_type - (Required) イベントのタイプ
    #     # 現在、shareSnapshotイベントのみがサポートされています
    #     event_type = "shareSnapshot"
    #
    #     # snapshot_owner - (Required) スナップショットをアカウントと共有することで
    #     # ポリシーをトリガーできるAWSアカウントのID
    #     # ポリシーは、指定されたAWSアカウントの1つがスナップショットを
    #     # アカウントと共有した場合にのみ実行されます
    #     snapshot_owner = ["123456789012"]
    #   }
    # }

    # --------------------------------------------------------------------------
    # schedule ブロック - (Optional) ポリシー定義のアクションのスケジュール
    # 最大4つのスケジュールを指定可能
    # --------------------------------------------------------------------------
    schedule {
      # name - (Required) スケジュールの名前
      name = "Daily snapshots"

      # copy_tags - (Optional) ソースボリュームのすべてのユーザー定義タグを
      # このポリシーによって作成されたボリュームのスナップショットにコピー
      copy_tags = false

      # tags_to_add - (Optional) タグキーとその値のマップ
      # DLMライフサイクルポリシーは既にボリュームのタグでスナップショットにタグ付けします
      # この設定は、これらの上に追加のタグを追加します
      tags_to_add = {
        SnapshotCreator = "DLM"
      }

      # variable_tags - (Optional) タグキーと変数値のマップ
      # ポリシー実行時に値が決定されます
      # 有効な値: "$(instance-id)" または "$(timestamp)"
      # resource_types が "INSTANCE" の場合のみ使用可能
      # variable_tags = {
      #   Timestamp = "$(timestamp)"
      # }

      # ------------------------------------------------------------------------
      # create_rule ブロック - (Required) スナップショット作成ルール
      # スケジュールごとに最大1つ
      # ------------------------------------------------------------------------
      create_rule {
        # interval - (Optional) このライフサイクルポリシーを評価する頻度
        # 有効な値: 1, 2, 3, 4, 6, 8, 12, 24
        # cron_expressionと競合します
        # 設定する場合、interval_unitとtimesも設定する必要があります
        interval = 24

        # interval_unit - (Optional) ライフサイクルポリシーを評価する頻度の単位
        # 現在許可されている値は "HOURS" のみで、デフォルト値でもあります
        # cron_expressionと競合します
        # intervalが設定されている場合は設定する必要があります
        interval_unit = "HOURS"

        # times - (Optional) ライフサイクルポリシーを評価する時刻を設定する
        # 24時間形式の時刻のリスト
        # 最大1つ。cron_expressionと競合します
        # intervalが設定されている場合は設定する必要があります
        times = ["23:45"]

        # cron_expression - (Optional) Cron式としてのスケジュール
        # スケジュール間隔は1時間から1年の間である必要があります
        # interval、interval_unit、timesと競合します
        # 有効なCron式の詳細については以下を参照:
        # https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-scheduled-rule-pattern.html#eb-cron-expressions
        # cron_expression = "cron(0 23 * * ? *)"

        # location - (Optional) ポリシーによって作成されたスナップショットの宛先
        # ソースリソースと同じリージョンにスナップショットを作成するには、"CLOUD"を指定
        # ソースリソースと同じOutpostにスナップショットを作成するには、"OUTPOST_LOCAL"を指定
        # デフォルト: "CLOUD"
        # 有効な値: "CLOUD" および "OUTPOST_LOCAL"
        # location = "CLOUD"

        # scripts ブロック - (Optional)
        # インスタンスを対象とするスナップショットライフサイクルポリシーの
        # プリスクリプトおよび/またはポストスクリプトを指定
        # resource_typeがINSTANCEの場合のみ有効
        # 最大1つ
        # scripts {
        #   # execution_handler - (Required) 実行するプリスクリプトおよび/または
        #   # ポストスクリプトを含むSSMドキュメント
        #   # VSSバックアップを自動化する場合は、"AWS_VSS_BACKUP"を指定
        #   # SAP HANAワークロードのアプリケーション整合性スナップショットを自動化する場合は、
        #   # "AWSSystemsManagerSAP-CreateDLMSnapshotForSAPHANA"を指定
        #   # 所有するカスタムSSMドキュメントを使用する場合は、
        #   # SSMドキュメントの名前またはARNを指定
        #   execution_handler = "AWS_VSS_BACKUP"
        #
        #   # execution_handler_service - (Optional) プリスクリプトおよび/または
        #   # ポストスクリプトの実行に使用されるサービスを示します
        #   # カスタムSSMドキュメントを使用する場合、またはSAP HANAワークロードの
        #   # アプリケーション整合性スナップショットを自動化する場合は、"AWS_SYSTEMS_MANAGER"を指定
        #   # VSSバックアップを自動化する場合は、このパラメータを省略します
        #   # デフォルト: "AWS_SYSTEMS_MANAGER"
        #   # execution_handler_service = "AWS_SYSTEMS_MANAGER"
        #
        #   # execute_operation_on_script_failure - (Optional)
        #   # プリスクリプトが失敗した場合にAmazon Data Lifecycle Managerが
        #   # クラッシュ整合性スナップショットにデフォルト設定するかどうか
        #   # デフォルト: true
        #   # execute_operation_on_script_failure = true
        #
        #   # execution_timeout - (Optional) タイムアウト期間を秒単位で指定
        #   # この期間後にAmazon Data Lifecycle Managerはスクリプト実行の試行を失敗とします
        #   # VSSバックアップを自動化する場合は、このパラメータを省略します
        #   # デフォルト: 10
        #   # execution_timeout = 10
        #
        #   # maximum_retry_count - (Optional) Amazon Data Lifecycle Managerが
        #   # 失敗したスクリプトを再試行する回数
        #   # 0から3の間の整数である必要があります
        #   # デフォルト: 0
        #   # maximum_retry_count = 0
        #
        #   # stages - (Optional) Amazon Data Lifecycle Managerがターゲット
        #   # インスタンスで実行すべきスクリプトを示すリスト
        #   # プリスクリプトはAmazon Data Lifecycle Managerがスナップショット作成を
        #   # 開始する前に実行されます
        #   # ポストスクリプトはAmazon Data Lifecycle Managerがスナップショット作成を
        #   # 開始した後に実行されます
        #   # 有効な値: "PRE" および "POST"
        #   # デフォルト: "PRE" および "POST"
        #   # stages = ["PRE", "POST"]
        # }
      }

      # ------------------------------------------------------------------------
      # retain_rule ブロック - (Required) スナップショット保持ルール
      # スケジュールごとに最小1、最大1
      # ------------------------------------------------------------------------
      retain_rule {
        # count - (Optional) 保持するスナップショットの数
        # 1から1000の間の整数である必要があります
        # intervalおよびinterval_unitと競合します
        count = 14

        # interval - (Optional) 各スナップショットを保持する期間
        # 最大100年。これは1200か月、5200週、または36500日に相当します
        # countと競合します
        # 設定する場合、interval_unitも設定する必要があります
        # interval = 7

        # interval_unit - (Optional) 時間ベースの保持の時間単位
        # 有効な値: "DAYS", "WEEKS", "MONTHS", "YEARS"
        # countと競合します
        # intervalが設定されている場合は設定する必要があります
        # interval_unit = "DAYS"
      }

      # ------------------------------------------------------------------------
      # archive_rule ブロック - (Optional) スケジュールのスナップショット
      # アーカイブルールを指定
      # 最大1つ
      # ------------------------------------------------------------------------
      # archive_rule {
      #   # archive_retain_rule ブロック - (Required)
      #   # スナップショットアーカイブルールの保持期間に関する情報
      #   archive_retain_rule {
      #     # retention_archive_tier ブロック - (Required)
      #     # Amazon EBS Snapshots Archiveの保持期間に関する情報
      #     retention_archive_tier {
      #       # count - (Optional) 各ボリュームのアーカイブストレージ層に
      #       # 保持するスナップショットの最大数
      #       # 1から1000の間の整数である必要があります
      #       # intervalおよびinterval_unitと競合します
      #       count = 100
      #
      #       # interval - (Optional) アーカイブ層にスナップショットを保持する期間
      #       # この期間が経過すると、スナップショットは完全に削除されます
      #       # countと競合します
      #       # 設定する場合、interval_unitも設定する必要があります
      #       # interval = 90
      #
      #       # interval_unit - (Optional) 時間ベースの保持の時間単位
      #       # 有効な値: "DAYS", "WEEKS", "MONTHS", "YEARS"
      #       # countと競合します
      #       # intervalが設定されている場合は設定する必要があります
      #       # interval_unit = "DAYS"
      #     }
      #   }
      # }

      # ------------------------------------------------------------------------
      # deprecate_rule ブロック - (Optional) AMI非推奨ルール
      # スケジュールごとに最大1つ
      # ------------------------------------------------------------------------
      # deprecate_rule {
      #   # count - (Optional) 非推奨にする最も古いAMIの数
      #   # 1から1000の間の整数である必要があります
      #   # intervalおよびinterval_unitと競合します
      #   # count = 1
      #
      #   # interval - (Optional) スケジュールによって作成されたAMIを非推奨にする期間
      #   # 最大100年。これは1200か月、5200週、または36500日に相当します
      #   # countと競合します
      #   # 設定する場合、interval_unitも設定する必要があります
      #   # interval = 30
      #
      #   # interval_unit - (Optional) 時間ベースの保持の時間単位
      #   # 有効な値: "DAYS", "WEEKS", "MONTHS", "YEARS"
      #   # countと競合します
      #   # intervalが設定されている場合は設定する必要があります
      #   # interval_unit = "DAYS"
      # }

      # ------------------------------------------------------------------------
      # fast_restore_rule ブロック - (Optional) 高速スナップショット復元ルール
      # スケジュールごとに最大1つ
      # ------------------------------------------------------------------------
      # fast_restore_rule {
      #   # availability_zones - (Required) 高速スナップショット復元を有効にする
      #   # アベイラビリティゾーン
      #   availability_zones = ["us-east-1a", "us-east-1b"]
      #
      #   # count - (Optional) 高速スナップショット復元を有効にするスナップショットの数
      #   # 1から1000の間の整数である必要があります
      #   # intervalおよびinterval_unitと競合します
      #   # count = 10
      #
      #   # interval - (Optional) 高速スナップショット復元を有効にする期間
      #   # 最大100年。これは1200か月、5200週、または36500日に相当します
      #   # countと競合します
      #   # 設定する場合、interval_unitも設定する必要があります
      #   # interval = 7
      #
      #   # interval_unit - (Optional) 高速スナップショット復元を有効にするための時間単位
      #   # 有効な値: "DAYS", "WEEKS", "MONTHS", "YEARS"
      #   # countと競合します
      #   # intervalが設定されている場合は設定する必要があります
      #   # interval_unit = "DAYS"
      # }

      # ------------------------------------------------------------------------
      # share_rule ブロック - (Optional) スナップショット共有ルール
      # スケジュールごとに最大1つ
      # ------------------------------------------------------------------------
      # share_rule {
      #   # target_accounts - (Required) スナップショットを共有するAWSアカウントのID
      #   target_accounts = ["123456789012", "987654321098"]
      #
      #   # unshare_interval - (Optional) 他のAWSアカウントと共有されている
      #   # スナップショットが自動的に共有解除されるまでの期間
      #   # unshare_interval = 7
      #
      #   # unshare_interval_unit - (Optional) 自動共有解除間隔の時間単位
      #   # 有効な値: "DAYS", "WEEKS", "MONTHS", "YEARS"
      #   # unshare_interval_unit = "DAYS"
      # }

      # ------------------------------------------------------------------------
      # cross_region_copy_rule ブロック - (Optional)
      # クロスリージョンコピールール
      # 最大3つ
      # ------------------------------------------------------------------------
      # cross_region_copy_rule {
      #   # encrypted - (Required) デフォルトで暗号化が有効でない場合に
      #   # 暗号化されていないスナップショットのコピーを暗号化するには、
      #   # このパラメータを使用して暗号化を有効にします
      #   # 暗号化されたスナップショットのコピーは、このパラメータがfalseの場合でも
      #   # または暗号化がデフォルトで有効でない場合でも暗号化されます
      #   encrypted = true
      #
      #   # target - (Optional) policy_type=EBS_SNAPSHOT_MANAGEMENTのDLMポリシーのみ
      #   # スナップショットコピーのターゲットリージョンまたはターゲットOutpostの
      #   # Amazon Resource Name (ARN)
      #   # target = "us-west-2"
      #
      #   # target_region - (Optional) policy_type=IMAGE_MANAGEMENTのDLMポリシーのみ
      #   # スナップショットコピーのターゲットリージョンまたはターゲットOutpostの
      #   # Amazon Resource Name (ARN)
      #   # target_region = "us-west-2"
      #
      #   # cmk_arn - (Optional) EBS暗号化に使用するAWS KMSカスタマーマスターキー(CMK)の
      #   # Amazon Resource Name (ARN)
      #   # この引数が指定されていない場合、アカウントのデフォルトKMSキーが使用されます
      #   # cmk_arn = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
      #
      #   # copy_tags - (Optional) ソーススナップショットからクロスリージョン
      #   # スナップショットコピーにすべてのユーザー定義タグをコピーするかどうか
      #   # copy_tags = true
      #
      #   # retain_rule ブロック - (Required)
      #   # 宛先リージョンでスナップショットコピーを保持する期間を示す保持ルール
      #   # スケジュールごとに最大1つ
      #   retain_rule {
      #     # interval - (Required) 各スナップショットを保持する期間
      #     # 最大100年。これは1200か月、5200週、または36500日に相当します
      #     interval = 30
      #
      #     # interval_unit - (Required) 時間ベースの保持の時間単位
      #     # 有効な値: "DAYS", "WEEKS", "MONTHS", "YEARS"
      #     interval_unit = "DAYS"
      #   }
      #
      #   # deprecate_rule ブロック - (Optional)
      #   # クロスリージョンAMIコピーのAMI非推奨ルール
      #   # deprecate_rule {
      #     # interval - (Required) クロスリージョンAMIコピーを非推奨にする期間
      #     # 期間はクロスリージョンAMIコピー保持期間以下である必要があり、
      #     # 10年を超えることはできません。これは120か月、520週、または3650日に相当します
      #     # interval = 30
      #
      #     # interval_unit - (Required) 間隔を測定する時間単位
      #     # 有効な値: "DAYS", "WEEKS", "MONTHS", "YEARS"
      #     # interval_unit = "DAYS"
      #   # }
      # }
    }
  }
}

# ------------------------------------------------------------------------------ 
# Computed Attributes (読み取り専用)
# ------------------------------------------------------------------------------ 
# これらの属性はTerraformによって自動的に設定され、他のリソースで参照できます
#
# - arn: DLMライフサイクルポリシーのAmazon Resource Name (ARN)
#   例: aws_dlm_lifecycle_policy.example.arn
#
# - id: DLMライフサイクルポリシーの識別子
#   例: aws_dlm_lifecycle_policy.example.id
#
# - tags_all: プロバイダーの default_tags から継承したタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#   例: aws_dlm_lifecycle_policy.example.tags_all
# ------------------------------------------------------------------------------ 

