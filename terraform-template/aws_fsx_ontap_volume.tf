#---------------------------------------------------------------
# Amazon FSx for NetApp ONTAP Volume
#---------------------------------------------------------------
#
# FSx for ONTAP ボリュームを管理します。ボリュームはファイル、ディレクトリ、
# または iSCSI LUN のデータコンテナとして機能し、NFS、SMB、iSCSI プロトコル
# 経由でアクセスできます。
#
# ボリュームスタイル:
#   - FlexVol: 単一のHAペアを持つファイルシステム向けのシンプルなボリューム
#   - FlexGroup: 複数のHA ペアを持つファイルシステム向けの高性能・高拡張性ボリューム
#
# ボリュームタイプ:
#   - RW (Read-Write): 読み書き可能なボリューム
#   - DP (Data Protection): 読み取り専用、SnapMirror/SnapVault の宛先として使用
#
# AWS公式ドキュメント:
#   - Managing FSx for ONTAP volumes: https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/managing-volumes.html
#   - Volume storage capacity: https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/volume-storage-capacity.html
#   - SnapLock protection: https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/snaplock.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_ontap_volume
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_fsx_ontap_volume" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ボリューム名
  # 最大203文字の英数字とアンダースコア(_)が使用可能
  name = "example-volume"

  # ストレージ仮想マシン(SVM) ID
  # ボリュームを作成する SVM を指定
  # 形式: svm-xxxxxxxxxxxxxxxxx
  storage_virtual_machine_id = "svm-0123456789abcdef0"

  #---------------------------------------------------------------
  # オプションパラメータ - 基本設定
  #---------------------------------------------------------------

  # リージョン
  # このリソースが管理されるAWSリージョン
  # 省略時はプロバイダー設定のリージョンが使用される
  # region = "us-east-1"

  # ボリュームスタイル
  # 有効な値: FLEXVOL (デフォルト), FLEXGROUP
  # FLEXGROUP: 複数のHA ペアを持つファイルシステム向けで、より高い性能と拡張性を提供
  # volume_style = "FLEXVOL"

  # ONTAPボリュームタイプ
  # 有効な値: RW (デフォルト), DP
  # RW: 読み書き可能なボリューム
  # DP: データ保護用の読み取り専用ボリューム (SnapMirror/SnapVault の宛先)
  # ONTAP CLI/API で設定可能。マイグレーションやレプリケーションの一部として使用
  # ontap_volume_type = "RW"

  # ボリュームタイプ
  # 現在の有効な値: ONTAP のみ
  # volume_type = "ONTAP"

  #---------------------------------------------------------------
  # サイズ設定
  #---------------------------------------------------------------

  # ボリュームサイズ (メガバイト単位)
  # 2 PB 未満のボリューム作成時にサポート
  # size_in_bytes または size_in_megabytes のいずれかを指定
  # FLEXGROUP: 構成要素あたり最低 100 GiB 必要
  # size_in_megabytes = 1024

  # ボリュームサイズ (バイト単位)
  # あらゆるサイズで使用可能だが、2 PB を超えるボリュームには必須
  # size_in_bytes または size_in_megabytes のいずれかを指定
  # FLEXGROUP: 構成要素あたり最低 100 GiB 必要
  # size_in_bytes = "1073741824"

  #---------------------------------------------------------------
  # ストレージ設定
  #---------------------------------------------------------------

  # ジャンクションパス
  # SVM の名前空間内でボリュームがマウントされる場所
  # 先頭にフォワードスラッシュが必要 (例: /vol3)
  # junction_path = "/example-volume"

  # セキュリティスタイル
  # 有効な値: UNIX, NTFS, MIXED
  # UNIX: Unix 管理者、NFS クライアント、Unix ユーザーをサービスアカウントとして使用するアプリケーション向け
  # NTFS: Windows 管理者、SMB クライアント、Windows ユーザーをサービスアカウントとして使用するアプリケーション向け
  # security_style = "UNIX"

  # ストレージ効率の有効化
  # true の場合、重複排除、圧縮、コンパクション機能が有効化される
  # ストレージ使用量を最適化するが、若干のパフォーマンス影響がある
  # storage_efficiency_enabled = true

  # スナップショットポリシー
  # ボリュームに適用するスナップショットポリシーを指定
  # スナップショット作成の頻度とスケジュールを定義
  # snapshot_policy = "default"

  #---------------------------------------------------------------
  # データ階層化設定
  #---------------------------------------------------------------

  # 階層化ポリシー
  # プライマリSSDストレージとキャパシティプールストレージ間のデータ移動を制御
  tiering_policy {
    # ポリシー名
    # 有効な値: SNAPSHOT_ONLY (デフォルト), AUTO, ALL, NONE
    # SNAPSHOT_ONLY: スナップショットデータのみをキャパシティプールに移動
    # AUTO: すべてのコールドデータをキャパシティプールに移動
    # ALL: すべてのユーザーデータとスナップショットデータをコールドとしてマーク
    # NONE: すべてのデータをプライマリストレージ層に保持
    # name = "SNAPSHOT_ONLY"

    # クーリング期間 (日数)
    # ボリューム内のユーザーデータが非アクティブと見なされるまでの日数
    # AUTO および SNAPSHOT_ONLY ポリシーでのみ使用
    # 有効な値: 2〜183 の整数
    # デフォルト: AUTO の場合は 31 日、SNAPSHOT_ONLY の場合は 2 日
    # cooling_period = 31
  }

  #---------------------------------------------------------------
  # FLEXGROUP 専用設定
  #---------------------------------------------------------------

  # アグリゲート構成 (FLEXGROUP ボリュームのみ)
  # FLEXGROUP ボリュームの構成要素とアグリゲートの配置を制御
  aggregate_configuration {
    # アグリゲート名のリスト
    # ボリュームが作成されるアグリゲートの名前を指定
    # 形式: aggrX (X はアグリゲート番号)
    # aggregates = ["aggr1", "aggr2"]

    # アグリゲートあたりの構成要素数
    # FlexGroup の各ストレージアグリゲートあたりの構成要素数
    # デフォルト: 8
    # constituents_per_aggregate = 8
  }

  #---------------------------------------------------------------
  # SnapLock 設定
  #---------------------------------------------------------------

  # SnapLock 構成
  # ファイルを WORM (Write Once, Read Many) 状態に移行してデータ保護を実現
  # コンプライアンス要件やランサムウェア対策に使用
  snaplock_configuration {
    # SnapLock タイプ (必須)
    # 有効な値: COMPLIANCE, ENTERPRISE
    # COMPLIANCE: 厳格なコンプライアンス要件向け。保持期間中はいかなるユーザーも削除不可
    # ENTERPRISE: SnapLock 管理者による削除が可能
    # 設定後は変更不可
    # snaplock_type = "COMPLIANCE"

    # 監査ログボリューム
    # SnapLock ボリュームの監査ログボリュームを有効/無効化
    # デフォルト: false
    # audit_log_volume = false

    # 特権削除
    # SnapLock Enterprise ボリュームでの特権削除を制御
    # 有効な値: DISABLED (デフォルト), ENABLED, PERMANENTLY_DISABLED
    # ENABLED: SnapLock 管理者が保持期間中の WORM ファイルを削除可能
    # privileged_delete = "DISABLED"

    # ボリューム追記モード
    # WORM 追記可能ファイルの作成とデータの段階的書き込みを許可
    # デフォルト: false
    # volume_append_mode_enabled = false

    # 自動コミット期間
    # ファイルが自動的に WORM 状態にコミットされるまでの期間
    autocommit_period {
      # タイプ (オプション、computed)
      # 有効な値: MINUTES, HOURS, DAYS, MONTHS, YEARS, NONE
      # NONE: 自動コミットを無効化
      # type = "NONE"

      # 値
      # 自動コミット期間の長さ
      # type が NONE 以外の場合に必要
      # value = 0
    }

    # 保持期間
    # WORM ファイルの保持期間を定義
    retention_period {
      # デフォルト保持期間 (必須)
      # 明示的な保持期間が設定されていない場合に WORM ファイルに割り当てられる期間
      # 最小保持期間以上、最大保持期間以下である必要がある
      default_retention {
        # タイプ (オプション、computed)
        # 有効な値: SECONDS, MINUTES, HOURS, DAYS, MONTHS, YEARS, INFINITE, UNSPECIFIED
        # INFINITE: ファイルを永久に保持
        # UNSPECIFIED: 明示的な保持期間を設定するまでファイルを保持
        # type = "UNSPECIFIED"

        # 値
        # 保持期間の長さ
        # type が INFINITE または UNSPECIFIED 以外の場合に必要
        # value = 0
      }

      # 最小保持期間 (必須)
      # WORM ファイルに割り当て可能な最短保持期間
      minimum_retention {
        # タイプ (オプション、computed)
        # 有効な値: SECONDS, MINUTES, HOURS, DAYS, MONTHS, YEARS, INFINITE, UNSPECIFIED
        # type = "DAYS"

        # 値
        # 保持期間の長さ
        # value = 1
      }

      # 最大保持期間 (必須)
      # WORM ファイルに割り当て可能な最長保持期間
      maximum_retention {
        # タイプ (オプション、computed)
        # 有効な値: SECONDS, MINUTES, HOURS, DAYS, MONTHS, YEARS, INFINITE, UNSPECIFIED
        # type = "YEARS"

        # 値
        # 保持期間の長さ
        # value = 30
      }
    }
  }

  #---------------------------------------------------------------
  # バックアップとタグ設定
  #---------------------------------------------------------------

  # バックアップへのタグのコピー
  # true の場合、ボリュームのタグがバックアップにコピーされる
  # デフォルト: false
  # copy_tags_to_backups = false

  # 最終バックアップのタグ
  # ボリュームの最終バックアップに適用するタグのマップ
  # final_backup_tags = {
  #   "backup-type" = "final"
  # }

  # 最終バックアップのスキップ
  # true の場合、ボリューム削除時のデフォルトの最終バックアップをスキップ
  # この設定は、リソース削除前に個別に適用する必要がある
  # デフォルト: false
  # skip_final_backup = false

  # SnapLock Enterprise 保持のバイパス
  # true の場合、SnapLock 管理者が有効期限切れでない WORM ファイルを含む
  # SnapLock Enterprise ボリュームを削除可能
  # この設定は、リソース削除前に個別に適用する必要がある
  # デフォルト: false
  # bypass_snaplock_enterprise_retention = false

  #---------------------------------------------------------------
  # タグ
  #---------------------------------------------------------------

  # タグ
  # ボリュームに割り当てるタグのマップ
  # プロバイダーの default_tags 設定ブロックと併用可能
  # tags = {
  #   Name        = "example-ontap-volume"
  #   Environment = "production"
  # }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # 操作タイムアウト
  timeouts {
    # 作成タイムアウト
    # ボリューム作成操作のタイムアウト
    # デフォルト: 30m
    # create = "30m"

    # 更新タイムアウト
    # ボリューム更新操作のタイムアウト
    # デフォルト: 30m
    # update = "30m"

    # 削除タイムアウト
    # ボリューム削除操作のタイムアウト
    # デフォルト: 30m
    # delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (Computed Only)
#---------------------------------------------------------------
#
# 以下の属性は Terraform によって自動的に設定されます (読み取り専用):
#
# - arn (string)
#   ボリュームの Amazon リソース名
#
# - id (string)
#   ボリュームの識別子
#   形式: fsvol-xxxxxxxxxxxxxxxxx
#
# - file_system_id (string)
#   ボリュームのファイルシステムの識別子
#   形式: fs-xxxxxxxxxxxxxxxxx
#
# - uuid (string)
#   ボリュームの UUID (汎用一意識別子)
#
# - flexcache_endpoint_type (string)
#   ボリュームの FlexCache エンドポイントタイプ
#   有効な値: NONE, ORIGIN, CACHE
#   デフォルト: NONE
#   ONTAP CLI/API で設定可能。FlexCache 機能で使用
#
# - tags_all (map of strings)
#   リソースに割り当てられたすべてのタグ
#   プロバイダーの default_tags 設定から継承されたタグを含む
#
# - aggregate_configuration.total_constituents (number)
#   FLEXGROUP ボリュームの構成要素の合計数
#   constituents_per_aggregate × aggregates の値
#
#---------------------------------------------------------------
