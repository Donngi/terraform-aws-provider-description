#---------------------------------------
# AWS Data Lifecycle Manager ライフサイクルポリシー
#---------------------------------------
# Resource: aws_dlm_lifecycle_policy
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dlm_lifecycle_policy
#
# NOTE:
# 用途: EBSスナップショット・AMIの自動作成・保持・削除を管理するポリシー
# 機能: スケジュールベース/イベントベースのバックアップ自動化、クロスリージョンコピー、アーカイブ、共有設定
# 関連: EBS Volume、EC2 Instance、AMI、KMS Key
#---------------------------------------

resource "aws_dlm_lifecycle_policy" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------
  # ポリシーの説明（必須）
  # 設定内容: ライフサイクルポリシーの目的と対象を説明する文字列
  # 制約: 最大500文字、英数字と一部記号のみ使用可能
  description = "Daily snapshots for production volumes"

  # IAM実行ロールARN（必須）
  # 設定内容: DLMがスナップショット/AMI操作を実行するために使用するIAMロール
  # 要件: AWSDataLifecycleManagerDefaultRoleポリシーまたは同等の権限が必要
  execution_role_arn = "arn:aws:iam::123456789012:role/service-role/AWSDataLifecycleManagerDefaultRole"

  # ポリシーの有効化状態
  # 設定可能な値: ENABLED（有効）、DISABLED（無効）
  # 省略時: ENABLED
  state = "ENABLED"

  # デフォルトポリシーの種類
  # 設定可能な値: VOLUME（EBSボリューム）、INSTANCE（EC2インスタンス）
  # 用途: タグなしリソースに対する自動バックアップポリシーを有効化
  # 注意: デフォルトポリシー使用時はpolicy_detailsの設定内容が制限される
  default_policy = "VOLUME"

  # リージョン指定
  # 設定内容: ポリシーを管理するAWSリージョン
  # 省略時: プロバイダーのリージョン設定を使用
  region = "ap-northeast-1"

  #---------------------------------------
  # ポリシー詳細設定
  #---------------------------------------
  policy_details {
    # ポリシータイプ
    # 設定可能な値:
    #   - EBS_SNAPSHOT_MANAGEMENT: EBSスナップショット管理
    #   - IMAGE_MANAGEMENT: AMI管理
    #   - EVENT_BASED_POLICY: イベントベースポリシー（共有スナップショット受信時など）
    policy_type = "EBS_SNAPSHOT_MANAGEMENT"

    # ポリシー言語の種類
    # 設定可能な値: SIMPLIFIED（簡易版）、STANDARD（標準版）
    # 省略時: SIMPLIFIED
    # 用途: SIMPLIFIEDはcreate_interval/retain_interval使用、STANDARDはscheduleブロック使用
    # policy_language = "SIMPLIFIED"

    # 対象リソースタイプ（policy_language=SIMPLIFIEDまたはIMAGE_MANAGEMENTで使用）
    # 設定可能な値: VOLUME（EBSボリューム）、INSTANCE（EC2インスタンス）
    # 用途: スナップショット作成対象のリソース種別を指定
    resource_types = ["VOLUME"]

    # 対象リソースのタグ条件（カスタムポリシーで必須）
    # 設定内容: このタグを持つリソースが自動バックアップの対象となる
    # 注意: デフォルトポリシーではタグ条件なしで全リソースが対象
    target_tags = {
      Backup = "daily"
    }

    # リソースの配置場所
    # 設定可能な値: CLOUD（標準リージョン）、OUTPOST（AWS Outposts）
    # 省略時: ["CLOUD"]
    # resource_locations = ["CLOUD"]

    # タグのコピー設定
    # 設定内容: ソースリソースのタグをスナップショット/AMIにコピーするか
    # 省略時: false
    # copy_tags = true

    # スナップショット作成間隔（policy_language=SIMPLIFIEDで使用）
    # 設定内容: 1〜7の整数（日数）
    # 用途: 簡易ポリシーでのバックアップ頻度を指定
    # create_interval = 1

    # スナップショット保持期間（policy_language=SIMPLIFIEDで使用）
    # 設定内容: 2〜14の整数（日数）
    # 用途: 簡易ポリシーでの保持日数を指定
    # retain_interval = 7

    # リソース削除時の動作拡張（デフォルトポリシーで使用）
    # 設定内容: ソースリソース削除後もスナップショット/AMIを保持するか
    # 省略時: false（ソース削除時に関連スナップショットも削除）
    # extend_deletion = true

    #---------------------------------------
    # AMI/スナップショット作成パラメータ
    #---------------------------------------
    # parameters {
    #   # ブートボリュームの除外設定（IMAGE_MANAGEMENTで使用）
    #   # 設定内容: インスタンスのルートボリュームをAMIから除外するか
    #   # 省略時: false（ブートボリュームも含める）
    #   exclude_boot_volume = false
    #
    #   # 再起動なしでのスナップショット作成（IMAGE_MANAGEMENTで使用）
    #   # 設定内容: AMI作成時にインスタンスを再起動しないか
    #   # 省略時: false（再起動あり、ファイルシステム整合性確保）
    #   no_reboot = false
    # }

    #---------------------------------------
    # 除外設定
    #---------------------------------------
    # exclusions {
    #   # ブートボリュームを除外
    #   # 設定内容: インスタンスのルートボリュームをバックアップ対象から除外
    #   exclude_boot_volumes = true
    #
    #   # タグによる除外
    #   # 設定内容: 指定タグを持つリソースをバックアップ対象から除外
    #   exclude_tags = {
    #     ExcludeBackup = "true"
    #   }
    #
    #   # ボリュームタイプによる除外
    #   # 設定可能な値: gp2、gp3、io1、io2、sc1、st1、standard
    #   exclude_volume_types = ["gp2"]
    # }

    #---------------------------------------
    # イベントソース設定（EVENT_BASED_POLICYで使用）
    #---------------------------------------
    # event_source {
    #   # イベントタイプ
    #   # 設定可能な値: MANAGED_CWE（CloudWatch Events管理）
    #   type = "MANAGED_CWE"
    #
    #   parameters {
    #     # イベント種別
    #     # 設定可能な値: shareSnapshot（スナップショット共有受信時）
    #     event_type = "shareSnapshot"
    #
    #     # スナップショット所有者のAWSアカウントID
    #     # 設定内容: このアカウントからの共有スナップショットのみ処理
    #     snapshot_owner = ["123456789012"]
    #
    #     # スナップショット説明の正規表現フィルタ
    #     # 設定内容: この正規表現にマッチするスナップショットのみ処理
    #     description_regex = "^prod-.*"
    #   }
    # }

    #---------------------------------------
    # イベントベースポリシーのアクション（EVENT_BASED_POLICYで使用）
    #---------------------------------------
    # action {
    #   # アクション名
    #   name = "copy-shared-snapshots"
    #
    #   # クロスリージョンコピー設定（最大3リージョン）
    #   cross_region_copy {
    #     # コピー先リージョン
    #     target = "us-west-2"
    #
    #     # 暗号化設定
    #     encryption_configuration {
    #       # 暗号化の有効化
    #       encrypted = true
    #
    #       # KMS CMK ARN（省略時はデフォルトEBS暗号化キー使用）
    #       # cmk_arn = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
    #     }
    #
    #     # 保持ルール
    #     retain_rule {
    #       # 保持期間の数値
    #       interval = 30
    #
    #       # 保持期間の単位
    #       # 設定可能な値: DAYS、WEEKS、MONTHS、YEARS
    #       interval_unit = "DAYS"
    #     }
    #   }
    # }

    #---------------------------------------
    # スケジュール設定（最大4スケジュール）
    #---------------------------------------
    schedule {
      # スケジュール名（必須）
      name = "Daily snapshots"

      # タグのコピー設定（スケジュール単位）
      # 省略時: false
      # copy_tags = true

      # スナップショットに追加するタグ
      # tags_to_add = {
      #   SnapshotType = "automated"
      # }

      # 変数タグ設定
      # 用途: スナップショット作成時刻などの動的な値をタグに埋め込む
      # 使用可能な変数: $(instance-id)、$(timestamp)
      # variable_tags = {
      #   CreatedOn = "$(timestamp)"
      # }

      #---------------------------------------
      # スナップショット作成ルール
      #---------------------------------------
      create_rule {
        # Cron式による実行スケジュール
        # 形式: cron(分 時 日 月 曜日 年)（UTC時刻）
        # 例: cron(0 2 * * ? *) = 毎日2:00 UTC
        # 注意: interval/interval_unitとの併用不可
        cron_expression = "cron(0 2 * * ? *)"

        # 実行間隔（整数値）
        # 設定可能な値: 1、2、3、4、6、8、12、24
        # 注意: cron_expressionとの併用不可
        # interval = 24

        # 実行間隔の単位
        # 設定可能な値: HOURS
        # 省略時: HOURS
        # interval_unit = "HOURS"

        # 実行開始時刻（interval使用時に指定可能）
        # 形式: ["HH:MM"]（UTC時刻、複数指定可能だが通常は1つ）
        # times = ["02:00"]

        # スナップショット作成場所
        # 設定可能な値: CLOUD（標準リージョン）、OUTPOST（AWS Outposts）
        # 省略時: CLOUD
        # location = "CLOUD"

        #---------------------------------------
        # アプリケーション整合性スナップショット設定
        #---------------------------------------
        # scripts {
        #   # 実行ハンドラーARN（必須）
        #   # 設定内容: AWS Systems Manager Automation実行用のARN
        #   execution_handler = "arn:aws:lambda:ap-northeast-1:123456789012:function:pre-snapshot"
        #
        #   # 実行ハンドラーサービス
        #   # 設定可能な値: AWS_SYSTEMS_MANAGER
        #   # 省略時: AWS_SYSTEMS_MANAGER
        #   # execution_handler_service = "AWS_SYSTEMS_MANAGER"
        #
        #   # スクリプト実行ステージ
        #   # 設定可能な値: PRE（スナップショット前）、POST（スナップショット後）
        #   # stages = ["PRE", "POST"]
        #
        #   # タイムアウト時間（秒）
        #   # 省略時: 10秒
        #   # execution_timeout = 60
        #
        #   # 最大リトライ回数
        #   # 省略時: 0（リトライなし）
        #   # maximum_retry_count = 3
        #
        #   # スクリプト失敗時の動作
        #   # 設定内容: trueの場合はスクリプト失敗してもスナップショット作成を続行
        #   # 省略時: false（スクリプト失敗時は作成中止）
        #   # execute_operation_on_script_failure = false
        # }
      }

      #---------------------------------------
      # 保持ルール（必須）
      #---------------------------------------
      retain_rule {
        # 保持数（個数ベース保持）
        # 設定内容: 保持するスナップショット/AMIの最大数
        # 注意: intervalとの併用不可
        count = 7

        # 保持期間の数値（期間ベース保持）
        # 設定内容: スナップショット/AMIを保持する期間
        # 注意: countとの併用不可
        # interval = 7

        # 保持期間の単位
        # 設定可能な値: DAYS、WEEKS、MONTHS、YEARS
        # 注意: intervalと併用時に指定
        # interval_unit = "DAYS"
      }

      #---------------------------------------
      # 廃止ルール（AMI管理で使用）
      #---------------------------------------
      # deprecate_rule {
      #   # 廃止までの回数（個数ベース）
      #   # count = 5
      #
      #   # 廃止までの期間の数値
      #   # interval = 30
      #
      #   # 廃止までの期間の単位
      #   # 設定可能な値: DAYS、WEEKS、MONTHS、YEARS
      #   # interval_unit = "DAYS"
      # }

      #---------------------------------------
      # アーカイブルール（EBSスナップショット専用）
      #---------------------------------------
      # archive_rule {
      #   archive_retain_rule {
      #     retention_archive_tier {
      #       # アーカイブ層での保持数
      #       # count = 100
      #
      #       # アーカイブ層での保持期間の数値
      #       # 制約: 最小90日間の保持が必要
      #       # interval = 365
      #
      #       # アーカイブ層での保持期間の単位
      #       # 設定可能な値: DAYS、WEEKS、MONTHS、YEARS
      #       # interval_unit = "DAYS"
      #     }
      #   }
      # }

      #---------------------------------------
      # 高速スナップショット復元（Fast Snapshot Restore）
      #---------------------------------------
      # fast_restore_rule {
      #   # 高速復元を有効化するアベイラビリティゾーン（必須）
      #   # 設定内容: 最大10個のAZ指定可能
      #   # 注意: 追加コストが発生
      #   availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
      #
      #   # 高速復元の保持数
      #   # count = 3
      #
      #   # 高速復元の保持期間の数値
      #   # interval = 7
      #
      #   # 高速復元の保持期間の単位
      #   # interval_unit = "DAYS"
      # }

      #---------------------------------------
      # クロスリージョンコピールール（最大3リージョン）
      #---------------------------------------
      # cross_region_copy_rule {
      #   # コピー先リージョン
      #   # 注意: targetまたはtarget_regionのいずれか一方を指定
      #   target = "us-west-2"
      #
      #   # 暗号化設定（必須）
      #   encrypted = true
      #
      #   # KMS CMK ARN（省略時はデフォルトEBS暗号化キー使用）
      #   # cmk_arn = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
      #
      #   # タグのコピー設定
      #   # 省略時: false
      #   # copy_tags = true
      #
      #   # 保持ルール
      #   retain_rule {
      #     # 保持期間の数値
      #     interval = 14
      #
      #     # 保持期間の単位
      #     interval_unit = "DAYS"
      #   }
      #
      #   # 廃止ルール（AMI管理で使用）
      #   # deprecate_rule {
      #   #   interval      = 7
      #   #   interval_unit = "DAYS"
      #   # }
      # }

      #---------------------------------------
      # クロスアカウント共有ルール
      #---------------------------------------
      # share_rule {
      #   # 共有先AWSアカウントID（必須）
      #   # 設定内容: 最大5個のアカウントID指定可能
      #   target_accounts = ["123456789012", "210987654321"]
      #
      #   # 共有解除までの期間の数値
      #   # 用途: 指定期間経過後に自動的に共有を解除
      #   # unshare_interval = 7
      #
      #   # 共有解除までの期間の単位
      #   # 設定可能な値: DAYS、WEEKS、MONTHS、YEARS
      #   # unshare_interval_unit = "DAYS"
      # }
    }
  }

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  tags = {
    Name        = "production-daily-backup"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# arn    : ポリシーのARN（例: arn:aws:dlm:ap-northeast-1:123456789012:policy/policy-0123456789abcdef0）
# id     : ポリシーID（例: policy-0123456789abcdef0）
# region : ポリシーが管理されているリージョン
# tags_all : リソースに割り当てられた全タグ（プロバイダーdefault_tagsを含む）
