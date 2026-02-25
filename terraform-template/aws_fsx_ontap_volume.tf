#---------------------------------------
# AWS FSx for ONTAP Volume
#---------------------------------------
# Amazon FSx for NetApp ONTAPのボリュームを管理するリソース
# FlexVolまたはFlexGroupボリュームを作成し、ストレージ効率化、データ階層化、SnapLock、スナップショットポリシーなどを設定可能
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
#
# NOTE: このテンプレートのコメントはスキーマから自動生成されたものを基に日本語で記載しています。
#       実際の使用時は、各属性の詳細な仕様を公式ドキュメントで確認してください。
#
# 公式ドキュメント:
# https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/managing-volumes.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_ontap_volume

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_fsx_ontap_volume" "example" {
  #---------------------------------------
  # 必須パラメータ
  #---------------------------------------

  # name (Required)
  # 設定内容: ボリュームの名称（最大203文字の英数字とアンダースコアが使用可能）
  name = "example-volume"

  # storage_virtual_machine_id (Required)
  # 設定内容: ボリュームを作成するストレージ仮想マシン（SVM）のID
  storage_virtual_machine_id = "svm-0123456789abcdef0"

  #---------------------------------------
  # ボリュームサイズ設定
  #---------------------------------------

  # size_in_megabytes (Optional)
  # 設定内容: ボリュームのサイズをMB単位で指定（2PB未満のボリュームに対応）
  # 省略時: 未設定（size_in_bytesまたはsize_in_megabytesのいずれかが必須）
  # 備考: FLEXGROUPボリュームの場合、各構成要素の最小サイズは100GB
  size_in_megabytes = null

  # size_in_bytes (Optional)
  # 設定内容: ボリュームのサイズをバイト単位で指定（全サイズに対応可能、2PB超のボリュームでは必須）
  # 省略時: 未設定（size_in_bytesまたはsize_in_megabytesのいずれかが必須）
  # 備考: FLEXGROUPボリュームの場合、各構成要素の最小サイズは100GB
  size_in_bytes = null

  #---------------------------------------
  # ボリュームタイプとスタイル設定
  #---------------------------------------

  # volume_style (Optional)
  # 設定内容: ボリュームのスタイルを指定
  # 設定可能な値: FLEXVOL（標準ボリューム、単一HAペアに最適）, FLEXGROUP（高性能・大容量ボリューム、複数HAペアに対応）
  # 省略時: FLEXVOL
  volume_style = null

  # ontap_volume_type (Optional)
  # 設定内容: ONTAPボリュームのタイプを指定（マイグレーションやレプリケーション用途）
  # 設定可能な値: RW（読み書き可能）, DP（データ保護、読み取り専用、SnapMirror/SnapVault先として使用）
  # 省略時: RW
  ontap_volume_type = null

  # volume_type (Optional)
  # 設定内容: ボリュームのタイプを指定
  # 設定可能な値: ONTAP（現在はこの値のみサポート）
  # 省略時: 未設定
  volume_type = null

  #---------------------------------------
  # マウントとアクセス設定
  #---------------------------------------

  # junction_path (Optional)
  # 設定内容: SVM名前空間内でボリュームがマウントされる場所（先頭にスラッシュが必要、例: /vol3）
  # 省略時: 未設定
  junction_path = null

  # security_style (Optional)
  # 設定内容: ボリュームのセキュリティスタイルを指定
  # 設定可能な値: UNIX（Unix管理者、NFSクライアント向け）, NTFS（Windows管理者、SMBクライアント向け）, MIXED（混在環境）
  # 省略時: SVMのデフォルト設定を継承
  security_style = null

  #---------------------------------------
  # ストレージ効率化設定
  #---------------------------------------

  # storage_efficiency_enabled (Optional)
  # 設定内容: 重複排除、圧縮、コンパクションを有効化するかどうか
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: false
  storage_efficiency_enabled = null

  #---------------------------------------
  # スナップショット設定
  #---------------------------------------

  # snapshot_policy (Optional)
  # 設定内容: ボリュームに適用するスナップショットポリシー
  # 設定可能な値: default, default-1weekly, none, またはカスタムポリシー名
  # 省略時: default
  snapshot_policy = null

  #---------------------------------------
  # バックアップとタグ設定
  #---------------------------------------

  # copy_tags_to_backups (Optional)
  # 設定内容: ボリュームのタグをバックアップにコピーするかどうか
  # 設定可能な値: true（コピーする）, false（コピーしない）
  # 省略時: false
  copy_tags_to_backups = null

  # final_backup_tags (Optional)
  # 設定内容: ボリュームの最終バックアップに適用するタグのマップ
  # 省略時: 未設定
  final_backup_tags = null

  #---------------------------------------
  # 削除設定
  #---------------------------------------

  # skip_final_backup (Optional)
  # 設定内容: ボリューム削除時にデフォルトで作成される最終バックアップをスキップするかどうか
  # 設定可能な値: true（スキップする）, false（スキップしない）
  # 省略時: false
  # 備考: リソース削除前にこの設定を個別に適用する必要がある
  skip_final_backup = null

  # bypass_snaplock_enterprise_retention (Optional)
  # 設定内容: 未期限切れWORMファイルを持つSnapLock Enterpriseボリュームの削除を許可するかどうか
  # 設定可能な値: true（削除許可）, false（削除不可）
  # 省略時: false
  # 備考: リソース削除前にこの設定を個別に適用する必要がある
  bypass_snaplock_enterprise_retention = null

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # region (Optional)
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  #---------------------------------------
  # タグ
  #---------------------------------------

  # tags (Optional)
  # 設定内容: ボリュームに割り当てるタグのマップ
  # 省略時: 未設定
  # 備考: プロバイダーの default_tags と統合される
  tags = null

  #---------------------------------------
  # データ階層化ポリシー設定
  #---------------------------------------

  # tiering_policy (Optional)
  # 設定内容: データを容量プールストレージに移動するための階層化ポリシー
  tiering_policy {
    # name (Optional)
    # 設定内容: 階層化ポリシーのタイプを指定
    # 設定可能な値: SNAPSHOT_ONLY（スナップショットのみ階層化）, AUTO（自動階層化）, ALL（全データ階層化）, NONE（階層化なし）
    # 省略時: SNAPSHOT_ONLY
    name = null

    # cooling_period (Optional)
    # 設定内容: データが「コールド」と見なされ容量プールに移動されるまでの非アクティブ期間（日数）
    # 設定可能な値: 2～183の整数
    # 省略時: AUTO の場合は31日、SNAPSHOT_ONLY の場合は2日
    # 備考: AUTO および SNAPSHOT_ONLY ポリシーでのみ使用可能
    cooling_period = null
  }

  #---------------------------------------
  # FlexGroup集約設定
  #---------------------------------------

  # aggregate_configuration (Optional)
  # 設定内容: FLEXGROUPボリュームの集約設定
  aggregate_configuration {
    # aggregates (Optional)
    # 設定内容: ボリュームを作成する集約の名前リスト（各集約は aggrX 形式、Xは集約番号）
    # 省略時: システムが自動選択
    aggregates = null

    # constituents_per_aggregate (Optional)
    # 設定内容: ストレージ集約ごとのFlexGroup構成要素数を明示的に設定
    # 省略時: 8
    constituents_per_aggregate = null
  }

  #---------------------------------------
  # SnapLock設定
  #---------------------------------------

  # snaplock_configuration (Optional)
  # 設定内容: FSx for ONTAP SnapLockボリュームの設定（WORM: Write Once Read Many）
  snaplock_configuration {
    # snaplock_type (Required)
    # 設定内容: SnapLockボリュームの保持モードを指定（設定後は変更不可）
    # 設定可能な値: COMPLIANCE（規制準拠モード、管理者でも削除不可）, ENTERPRISE（エンタープライズモード、特権削除可能）
    snaplock_type = "ENTERPRISE"

    # audit_log_volume (Optional)
    # 設定内容: SnapLockボリュームの監査ログボリュームを有効化するかどうか
    # 設定可能な値: true（有効）, false（無効）
    # 省略時: false
    audit_log_volume = null

    # privileged_delete (Optional)
    # 設定内容: SnapLock Enterpriseボリュームでの特権削除の設定
    # 設定可能な値: DISABLED（無効）, ENABLED（有効）, PERMANENTLY_DISABLED（恒久的に無効）
    # 省略時: DISABLED
    privileged_delete = null

    # volume_append_mode_enabled (Optional)
    # 設定内容: ボリューム追記モードを有効化するかどうか
    # 設定可能な値: true（有効）, false（無効）
    # 省略時: false
    volume_append_mode_enabled = null

    # autocommit_period (Optional)
    # 設定内容: ファイルの自動コミット期間設定
    autocommit_period {
      # type (Optional)
      # 設定内容: 自動コミット期間の時間単位
      # 設定可能な値: MINUTES（分）, HOURS（時間）, DAYS（日）, MONTHS（月）, YEARS（年）, NONE（無効）
      type = null

      # value (Optional)
      # 設定内容: 自動コミット期間の時間量
      # 省略時: 未設定
      value = null
    }

    # retention_period (Optional)
    # 設定内容: SnapLockボリュームの保持期間設定
    retention_period {
      # default_retention (Optional)
      # 設定内容: 明示的な保持期間が設定されていないWORMファイルに割り当てられるデフォルト保持期間
      # 備考: 最小保持期間以上、最大保持期間以下である必要がある
      default_retention {
        # type (Optional)
        # 設定内容: 保持期間の時間単位
        # 設定可能な値: SECONDS（秒）, MINUTES（分）, HOURS（時間）, DAYS（日）, MONTHS（月）, YEARS（年）, INFINITE（無期限）, UNSPECIFIED（未指定）
        type = null

        # value (Optional)
        # 設定内容: 保持期間の時間量
        # 省略時: 未設定
        value = null
      }

      # maximum_retention (Optional)
      # 設定内容: WORMファイルに割り当て可能な最長保持期間
      maximum_retention {
        # type (Optional)
        # 設定内容: 保持期間の時間単位
        # 設定可能な値: SECONDS（秒）, MINUTES（分）, HOURS（時間）, DAYS（日）, MONTHS（月）, YEARS（年）, INFINITE（無期限）, UNSPECIFIED（未指定）
        type = null

        # value (Optional)
        # 設定内容: 保持期間の時間量
        # 省略時: 未設定
        value = null
      }

      # minimum_retention (Optional)
      # 設定内容: WORMファイルに割り当て可能な最短保持期間
      minimum_retention {
        # type (Optional)
        # 設定内容: 保持期間の時間単位
        # 設定可能な値: SECONDS（秒）, MINUTES（分）, HOURS（時間）, DAYS（日）, MONTHS（月）, YEARS（年）, INFINITE（無期限）, UNSPECIFIED（未指定）
        type = null

        # value (Optional)
        # 設定内容: 保持期間の時間量
        # 省略時: 未設定
        value = null
      }
    }
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間
    create = null

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間
    update = null

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間
    delete = null
  }
}

#---------------------------------------
# Attributes Reference (参照可能な属性)
#---------------------------------------
# このリソースから取得できる属性値
#
# - arn: ボリュームのAmazon Resource Name
# - id: ボリュームの識別子（例: fsvol-12345678）
# - file_system_id: ボリュームが属するファイルシステムの識別子（例: fs-12345679）
# - uuid: ボリュームのUUID（汎用一意識別子）
# - tags_all: リソースに割り当てられたすべてのタグ（プロバイダーの default_tags を含む）
# - volume_type: ボリュームのタイプ（現在は ONTAP のみ）
# - flexcache_endpoint_type: FlexCacheエンドポイントタイプ（NONE, ORIGIN, CACHE）
# - aggregate_configuration.total_constituents: FLEXGROUPボリュームの総構成要素数（constituents_per_aggregate × aggregates）
