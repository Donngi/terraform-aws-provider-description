################################################################################
# AWS FSx for OpenZFS File System
# Provider Version: 6.28.0
################################################################################

/*
Amazon FSx for OpenZFS は、NetApp の人気の高いオープンソースファイルシステムである
OpenZFS 上に構築された、高性能でフルマネージドなファイルストレージサービスです。
低レイテンシの NFS アクセス、データ圧縮、スナップショット、ボリューム管理などの
機能を提供し、Linux、macOS、Windows クライアントからアクセス可能です。

主な用途:
- ハイパフォーマンスコンピューティング (HPC) ワークロード
- メディア処理とレンダリング
- データ分析とバッチ処理
- コンテナベースアプリケーション
- 開発・テスト環境

公式ドキュメント:
https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/what-is-fsx.html
*/

################################################################################
# 基本設定例: Single-AZ デプロイメント
################################################################################

resource "aws_fsx_openzfs_file_system" "basic" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # 必須パラメータ
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Required) ファイルシステムのデプロイメントタイプ
  # 利用可能な値:
  # - SINGLE_AZ_1: Single-AZ (非 HA) - 第1世代、最も低コスト
  # - SINGLE_AZ_2: Single-AZ (非 HA) - 第2世代、SINGLE_AZ_1 より高性能
  # - SINGLE_AZ_HA_1: Single-AZ (HA) - 高可用性、自動フェイルオーバー
  # - SINGLE_AZ_HA_2: Single-AZ (HA) - 第2世代、最高性能
  # - MULTI_AZ_1: Multi-AZ (HA) - 複数AZ、最高レベルの可用性
  deployment_type = "SINGLE_AZ_1"

  # (Required) ファイルシステムがアクセス可能なサブネットの ID リスト
  # - Single-AZ: 1つのサブネット ID を指定
  # - Multi-AZ: 2つのサブネット ID を指定 (異なる AZ に配置)
  # - 各サブネットは同じ VPC 内に存在する必要があります
  subnet_ids = ["subnet-12345678"]

  # (Required) ファイルシステムのスループット容量 (MB/s)
  # SINGLE_AZ_1 の場合: 64, 128, 256, 512, 1024, 2048, 3072, 4096
  # SINGLE_AZ_2 の場合: 160, 320, 640, 1280, 2560, 3840, 5120, 7680, 10240
  # SINGLE_AZ_HA_1 の場合: 64, 128, 256, 512, 1024, 2048, 3072, 4096
  # SINGLE_AZ_HA_2 の場合: 160, 320, 640, 1280, 2560, 3840, 5120, 7680, 10240
  # MULTI_AZ_1 の場合: 160, 320, 640, 1280, 2560, 3840, 5120, 7680, 10240
  # スループット容量は作成後に増減可能です
  throughput_capacity = 64

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # ストレージ設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) ファイルシステムのストレージ容量 (GiB)
  # - 有効な値: 64 〜 524288 (512 TiB)
  # - storage_type が SSD の場合は必須
  # - storage_type が INTELLIGENT_TIERING の場合は指定不可
  # - 作成後に増加のみ可能 (減少は不可)
  storage_capacity = 64

  # (Optional) ファイルシステムのストレージタイプ
  # - SSD: プロビジョンド SSD ストレージ (デフォルト)
  # - INTELLIGENT_TIERING: エラスティックストレージ、自動階層化
  #   (MULTI_AZ_1 デプロイメントタイプでのみ利用可能)
  storage_type = "SSD"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # ネットワークとセキュリティ
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) ファイルシステムアクセス用のネットワークインターフェースに
  # 適用されるセキュリティグループの ID リスト
  # - 指定しない場合、VPC のデフォルトセキュリティグループが使用されます
  # - NFS アクセス (ポート 2049) を許可する必要があります
  # security_group_ids = ["sg-12345678"]

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # バックアップ設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) 自動バックアップの保持日数
  # - 有効な値: 0 〜 90 日
  # - 0 に設定すると自動バックアップが無効になります
  # - デフォルト: 0 (自動バックアップ無効)
  # automatic_backup_retention_days = 7

  # (Optional) 毎日の自動バックアップの開始時刻 (HH:MM 形式、UTC)
  # - HH: 時 (0-23)、MM: 分 (00-59)
  # - 例: "05:00" は UTC で午前5時を意味します
  # - automatic_backup_retention_days の設定が必要です
  # daily_automatic_backup_start_time = "05:00"

  # (Optional) ファイルシステムのタグをバックアップにコピーするかどうか
  # - true: バックアップにタグをコピー
  # - false: コピーしない (デフォルト)
  # copy_tags_to_backups = false

  # (Optional) ファイルシステムのタグをボリュームにコピーするかどうか
  # - true: ボリュームにタグをコピー
  # - false: コピーしない (デフォルト)
  # copy_tags_to_volumes = false

  # (Optional) ファイルシステム削除時に最終バックアップをスキップするかどうか
  # - true: 最終バックアップをスキップ
  # - false: 最終バックアップを作成 (デフォルト)
  # - この設定はリソース削除前に適用する必要があります
  # skip_final_backup = false

  # (Optional) 最終バックアップに適用するタグのマップ
  # final_backup_tags = {
  #   "Backup-Type" = "Final"
  # }

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # 暗号化設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) ファイルシステムの保存時暗号化に使用する KMS キーの ARN
  # - 指定しない場合、AWS 管理の KMS キーが使用されます
  # - カスタマー管理キーを使用する場合は、適切な IAM 権限が必要です
  # kms_key_id = "arn:aws:kms:us-west-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # メンテナンス設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) 週次メンテナンスの開始時刻 (d:HH:MM 形式、UTC)
  # - d: 曜日 (1=月曜日 〜 7=日曜日)
  # - HH: 時 (00-23)、MM: 分 (00-59)
  # - 例: "1:05:00" は月曜日の UTC 午前5時を意味します
  # - 指定しない場合、AWS が30分のウィンドウをランダムに選択します
  # weekly_maintenance_start_time = "1:05:00"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # リージョン設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) リソースを管理するリージョン
  # - 指定しない場合、プロバイダー設定のリージョンが使用されます
  # - マルチリージョンデプロイメントで明示的にリージョンを指定する際に使用
  # region = "us-west-2"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # タグ
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  tags = {
    Name        = "basic-openzfs-filesystem"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

################################################################################
# Multi-AZ 高可用性構成 (Intelligent-Tiering)
################################################################################

resource "aws_fsx_openzfs_file_system" "multi_az_intelligent_tiering" {
  deployment_type     = "MULTI_AZ_1"
  subnet_ids          = ["subnet-12345678", "subnet-87654321"] # 異なる AZ
  throughput_capacity = 160
  storage_type        = "INTELLIGENT_TIERING"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Multi-AZ 固有の設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) Multi-AZ のみ: 優先ファイルサーバーを配置するサブネット
  # - deployment_type が MULTI_AZ_1 の場合は必須
  # - subnet_ids のいずれかと一致する必要があります
  preferred_subnet_id = "subnet-12345678"

  # (Optional) Multi-AZ のみ: ファイルシステムエンドポイントの IP アドレス範囲
  # - CIDR 表記で指定 (例: "198.19.255.0/24")
  # - /24 ネットマスクを推奨
  # - VPC CIDR の範囲外で、RFC 1918 または RFC 6598 に準拠
  # endpoint_ip_address_range = "198.19.255.0/24"

  # (Optional) Multi-AZ のみ: ルートテーブル ID のリスト
  # - ファイルサーバーへのトラフィックをルーティングするルールを作成
  # - クライアントが配置されているサブネットに関連する全 VPC ルートテーブルを指定
  # - 指定しない場合、VPC のデフォルトルートテーブルが選択されます
  # route_table_ids = ["rtb-12345678", "rtb-87654321"]

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Intelligent-Tiering 用 SSD リードキャッシュ設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) storage_type が INTELLIGENT_TIERING の場合に設定可能
  # プロビジョンド SSD リードキャッシュの設定
  read_cache_configuration {
    # (Optional) リードキャッシュのサイジングモード
    # - NO_CACHE: リードキャッシュなし
    # - USER_PROVISIONED: ユーザー指定サイズ (size が必須)
    # - PROPORTIONAL_TO_THROUGHPUT_CAPACITY: スループット容量に比例
    sizing_mode = "PROPORTIONAL_TO_THROUGHPUT_CAPACITY"

    # (Optional) SSD リードキャッシュのサイズ (GiB)
    # - sizing_mode が USER_PROVISIONED の場合は必須
    # - その他の sizing_mode では指定不可
    # size = 1000
  }

  automatic_backup_retention_days = 7
  copy_tags_to_backups            = true
  copy_tags_to_volumes            = true

  tags = {
    Name        = "multi-az-intelligent-tiering-filesystem"
    Environment = "production"
    HA          = "multi-az"
  }
}

################################################################################
# プロビジョンド IOPS 設定 (Single-AZ HA)
################################################################################

resource "aws_fsx_openzfs_file_system" "provisioned_iops" {
  deployment_type     = "SINGLE_AZ_HA_2"
  subnet_ids          = ["subnet-12345678"]
  throughput_capacity = 320
  storage_capacity    = 1024
  storage_type        = "SSD"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # ディスク IOPS 設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) SSD IOPS の設定
  disk_iops_configuration {
    # (Optional) IOPS のモード
    # - AUTOMATIC: システムが自動的に決定 (デフォルト)
    #   - スループット容量 × 3 IOPS/MB/s (最小 96 IOPS)
    # - USER_PROVISIONED: ユーザー指定 (iops が必須)
    mode = "USER_PROVISIONED"

    # (Optional) プロビジョンする IOPS の総数
    # - mode が USER_PROVISIONED の場合は必須
    # - 最小値: 96
    # - 最大値: ストレージ容量 (GiB) × 400
    iops = 10000
  }

  automatic_backup_retention_days      = 14
  daily_automatic_backup_start_time    = "03:00"
  weekly_maintenance_start_time        = "1:04:00"
  copy_tags_to_backups                 = true
  security_group_ids                   = ["sg-12345678"]

  tags = {
    Name        = "provisioned-iops-filesystem"
    Environment = "production"
    Performance = "high-iops"
  }
}

################################################################################
# ルートボリューム詳細設定
################################################################################

resource "aws_fsx_openzfs_file_system" "root_volume_config" {
  deployment_type     = "SINGLE_AZ_2"
  subnet_ids          = ["subnet-12345678"]
  throughput_capacity = 160
  storage_capacity    = 512
  storage_type        = "SSD"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # ルートボリューム設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) ファイルシステムのルートボリュームの設定
  # - 全ての子ボリュームはルートボリュームの配下に作成されます
  # - ルートボリュームの設定は子ボリュームに継承されます
  root_volume_configuration {
    # (Optional) データ圧縮タイプ
    # - NONE: 圧縮なし
    # - LZ4: LZ4 圧縮 (推奨、バランスの良い圧縮率と性能)
    # - ZSTD: Zstandard 圧縮 (高圧縮率、CPU 負荷が高い)
    # - 子ボリュームで圧縮オプションを指定しない場合、親から継承されます
    data_compression_type = "LZ4"

    # (Optional) OpenZFS ルートボリュームのレコードサイズ (KiB)
    # - 有効な値: 4, 8, 16, 32, 64, 128, 256, 512, 1024
    # - デフォルト: 128 KiB
    # - ワークロードに応じて調整:
    #   - 小さいファイル/ランダムアクセス: 4-16 KiB
    #   - 大きいファイル/シーケンシャルアクセス: 128-1024 KiB
    record_size_kib = 128

    # (Optional) ボリュームを読み取り専用にするかどうか
    # - true: 読み取り専用
    # - false: 読み書き可能 (デフォルト)
    read_only = false

    # (Optional) タグをスナップショットにコピーするかどうか
    # - true: スナップショットにタグをコピー
    # - false: コピーしない (デフォルト)
    copy_tags_to_snapshots = false

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    # NFS エクスポート設定
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    # (Optional) ルートボリュームの NFS エクスポート設定
    # - 正確に1つのアイテムが必要です
    nfs_exports {
      # (Required) クライアントとマウントオプションの設定リスト
      # - 最大25アイテム
      client_configurations {
        # (Required) ファイルシステムをマウントできるクライアント
        # - ワイルドカード (*): 全てのクライアント
        # - IP アドレス: 0.0.0.0
        # - CIDR アドレス: 192.0.2.0/24
        # - デフォルトでワイルドカード (*) が使用されます
        clients = "10.0.0.0/16"

        # (Required) ファイルシステムマウント時のオプション
        # - 最大20アイテム
        # - Linux NFS exports の標準オプション
        # - デフォルトで crossmount と sync が使用されます
        # 一般的なオプション:
        # - ro: 読み取り専用
        # - rw: 読み書き可能
        # - sync: 同期書き込み (データ整合性重視)
        # - async: 非同期書き込み (パフォーマンス重視)
        # - no_root_squash: root ユーザーの権限を保持
        # - root_squash: root を anonymous にマップ
        # - all_squash: 全ユーザーを anonymous にマップ
        options = ["rw", "crossmount", "sync"]
      }

      # 複数のクライアント構成を定義可能
      client_configurations {
        clients = "192.168.1.0/24"
        options = ["ro", "crossmount", "sync"]
      }
    }

    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    # ユーザー・グループクォータ設定
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    # (Optional) ユーザーまたはグループがボリューム上で使用できるストレージ量
    # - 最大100アイテム
    user_and_group_quotas {
      # (Required) ユーザーまたはグループの ID
      # - 有効な値: 0 〜 2147483647
      # - Linux の UID または GID
      id = 1001

      # (Required) クォータ量 (GiB)
      # - 有効な値: 0 〜 2147483647
      # - 0 はクォータなし (無制限) を意味します
      storage_capacity_quota_gib = 100

      # (Required) クォータの種類
      # - USER: ユーザークォータ
      # - GROUP: グループクォータ
      type = "USER"
    }

    # 複数のクォータを定義可能
    user_and_group_quotas {
      id                         = 2001
      storage_capacity_quota_gib = 200
      type                       = "GROUP"
    }
  }

  automatic_backup_retention_days = 7
  copy_tags_to_backups            = true
  copy_tags_to_volumes            = true

  tags = {
    Name        = "root-volume-config-filesystem"
    Environment = "production"
    Compression = "lz4"
  }
}

################################################################################
# バックアップからの復元
################################################################################

resource "aws_fsx_openzfs_file_system" "from_backup" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # バックアップからの復元
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) バックアップからファイルシステムを作成する場合のソースバックアップ ID
  # - バックアップ ID を指定すると、そのバックアップから新しいファイルシステムが作成されます
  # - バックアップの設定 (デプロイメントタイプ、スループット容量など) が継承されます
  # - storage_capacity や throughput_capacity などは復元後に変更可能です
  backup_id = "backup-0123456789abcdef0"

  deployment_type     = "SINGLE_AZ_1"
  subnet_ids          = ["subnet-12345678"]
  throughput_capacity = 64

  # バックアップから復元する場合、storage_capacity は任意
  # 指定しない場合、バックアップの容量が使用されます
  # storage_capacity = 128

  automatic_backup_retention_days = 7

  tags = {
    Name         = "restored-from-backup"
    Environment  = "production"
    RestoredFrom = "backup-0123456789abcdef0"
  }
}

################################################################################
# ファイルシステムレベルのユーザー・グループクォータ
################################################################################

resource "aws_fsx_openzfs_file_system" "with_quotas" {
  deployment_type     = "SINGLE_AZ_2"
  subnet_ids          = ["subnet-12345678"]
  throughput_capacity = 160
  storage_capacity    = 256
  storage_type        = "SSD"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # ファイルシステムレベルのクォータ設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) ファイルシステム全体でのユーザーまたはグループのストレージクォータ
  # - 最大値は FSx for OpenZFS リソースクォータで定義されています
  # - https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/limits.html
  user_and_group_quotas {
    id                         = 1001
    storage_capacity_quota_gib = 50
    type                       = "USER"
  }

  user_and_group_quotas {
    id                         = 1002
    storage_capacity_quota_gib = 75
    type                       = "USER"
  }

  user_and_group_quotas {
    id                         = 2001
    storage_capacity_quota_gib = 150
    type                       = "GROUP"
  }

  automatic_backup_retention_days = 7

  tags = {
    Name        = "filesystem-with-quotas"
    Environment = "production"
    Quotas      = "enabled"
  }
}

################################################################################
# 削除オプション設定
################################################################################

resource "aws_fsx_openzfs_file_system" "with_delete_options" {
  deployment_type     = "SINGLE_AZ_1"
  subnet_ids          = ["subnet-12345678"]
  throughput_capacity = 64
  storage_capacity    = 64
  storage_type        = "SSD"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # 削除オプション
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # (Optional) ファイルシステム削除時の動作を指定する削除オプションのリスト
  # - 現在サポートされている値:
  #   - DELETE_CHILD_VOLUMES_AND_SNAPSHOTS:
  #     全ての子ボリュームとスナップショットを削除
  # - このオプションを設定しない場合、子ボリュームやスナップショットが
  #   存在するとファイルシステムの削除が失敗します
  delete_options = ["DELETE_CHILD_VOLUMES_AND_SNAPSHOTS"]

  skip_final_backup = true

  tags = {
    Name        = "filesystem-with-delete-options"
    Environment = "development"
  }
}

################################################################################
# 出力値
################################################################################

output "basic_filesystem_id" {
  description = "ファイルシステムの ID (例: fs-12345678)"
  value       = aws_fsx_openzfs_file_system.basic.id
}

output "basic_filesystem_arn" {
  description = "ファイルシステムの ARN"
  value       = aws_fsx_openzfs_file_system.basic.arn
}

output "basic_filesystem_dns_name" {
  description = <<-EOT
    ファイルシステムの DNS 名 (例: fs-12345678.fsx.us-west-2.amazonaws.com)
    NFS マウント時に使用します
  EOT
  value       = aws_fsx_openzfs_file_system.basic.dns_name
}

output "basic_filesystem_endpoint_ip_address" {
  description = <<-EOT
    ファイルシステムへのデータアクセスまたは管理に使用されるエンドポイントの IP アドレス
  EOT
  value       = aws_fsx_openzfs_file_system.basic.endpoint_ip_address
}

output "basic_filesystem_network_interface_ids" {
  description = <<-EOT
    ファイルシステムがアクセス可能な Elastic Network Interface の ID セット
    最初のネットワークインターフェースがプライマリです
  EOT
  value       = aws_fsx_openzfs_file_system.basic.network_interface_ids
}

output "basic_filesystem_owner_id" {
  description = "ファイルシステムを作成した AWS アカウント ID"
  value       = aws_fsx_openzfs_file_system.basic.owner_id
}

output "basic_filesystem_root_volume_id" {
  description = "ルートボリュームの ID (例: fsvol-12345678)"
  value       = aws_fsx_openzfs_file_system.basic.root_volume_id
}

output "basic_filesystem_vpc_id" {
  description = "ファイルシステムの Virtual Private Cloud の ID"
  value       = aws_fsx_openzfs_file_system.basic.vpc_id
}

output "basic_filesystem_tags_all" {
  description = <<-EOT
    リソースに割り当てられたタグのマップ
    プロバイダーの default_tags から継承されたタグを含む
  EOT
  value       = aws_fsx_openzfs_file_system.basic.tags_all
}

################################################################################
# NFS マウント例
################################################################################

/*
作成したファイルシステムを Linux クライアントからマウントする例:

# 基本的なマウント
sudo mount -t nfs -o nfsvers=3 fs-12345678.fsx.us-west-2.amazonaws.com:/fsx /mnt/fsx

# nconnect を使用したマルチフロー接続 (推奨、パフォーマンス向上)
sudo mount -t nfs -o nfsvers=3,nconnect=16 fs-12345678.fsx.us-west-2.amazonaws.com:/fsx /mnt/fsx

# /etc/fstab に追加して永続化
fs-12345678.fsx.us-west-2.amazonaws.com:/fsx /mnt/fsx nfs nfsvers=3,nconnect=16,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 0 0

重要な NFS マウントオプション:
- nfsvers=3: NFS バージョン3を使用 (推奨、低レイテンシ)
- nconnect=16: 複数の TCP 接続を使用 (パフォーマンス向上)
- rsize/wsize: 読み取り/書き込みバッファサイズ (バイト)
- hard: ハードマウント (I/O エラー時にリトライ)
- timeo: タイムアウト値 (600 = 60秒)
- retrans: リトライ回数
- noresvport: 非特権ポートを使用
*/

################################################################################
# ベストプラクティスと推奨事項
################################################################################

/*
1. デプロイメントタイプの選択:
   - 開発・テスト: SINGLE_AZ_1 または SINGLE_AZ_2 (コスト最適化)
   - 本番環境: SINGLE_AZ_HA_2 または MULTI_AZ_1 (高可用性)
   - 最高性能が必要: SINGLE_AZ_HA_2 (Single-AZ で最高性能)
   - 最高可用性が必要: MULTI_AZ_1 (複数 AZ で冗長化)

2. ストレージタイプの選択:
   - SSD (プロビジョンド):
     * 全データセットに低レイテンシアクセスが必要な場合
     * ワーキングセットサイズが予測可能な場合
     * 一定のパフォーマンスが必要な場合

   - INTELLIGENT_TIERING (エラスティック):
     * ストレージ需要が変動する場合
     * コスト最適化が重要な場合
     * アクティブデータのみに低レイテンシが必要な場合
     * MULTI_AZ_1 デプロイメント必須

3. スループット容量の設定:
   - ワークロードに基づいて適切な値を選択
   - 作成後に増減可能なため、小さく始めて調整可能
   - CloudWatch メトリクスで使用率を監視

4. IOPS の設定:
   - AUTOMATIC モード: ほとんどのワークロードに適切
   - USER_PROVISIONED: 高 IOPS が必要な場合のみ
     * データベースワークロード
     * ランダム I/O が多いアプリケーション

5. データ圧縮:
   - LZ4: バランスの良い圧縮率とパフォーマンス (推奨)
   - ZSTD: 高圧縮率が必要で CPU リソースに余裕がある場合
   - NONE: 圧縮済みデータや暗号化データの場合

6. バックアップ戦略:
   - 本番環境: automatic_backup_retention_days を 7-30 日に設定
   - バックアップウィンドウを業務時間外に設定
   - copy_tags_to_backups を true に設定して管理を容易に

7. ネットワーク設定:
   - 適切なセキュリティグループで NFS ポート (2049) を制限
   - Multi-AZ の場合、route_table_ids を明示的に指定
   - 大規模デプロイメントでは endpoint_ip_address_range を計画

8. パフォーマンス最適化:
   - EC2 クライアントには Enhanced Networking をサポートするインスタンスタイプを使用
   - NFS マウント時に nconnect オプションを使用 (マルチフロー)
   - record_size_kib をワークロードに合わせて調整
   - CloudWatch でメトリクスを監視し、ボトルネックを特定

9. コスト最適化:
   - 開発環境では automatic_backup_retention_days を短く設定
   - 不要な場合は skip_final_backup を true に設定
   - Intelligent-Tiering を使用してストレージコストを削減
   - 適切なスループット容量を選択 (過剰なプロビジョニングを避ける)

10. セキュリティ:
    - カスタマー管理 KMS キーを使用して暗号化を管理
    - NFS エクスポートで適切なクライアント制限を設定
    - no_root_squash の使用は慎重に (セキュリティリスク)
    - セキュリティグループで送信元 IP を制限

11. 運用管理:
    - タグを適切に設定してリソース管理を容易に
    - copy_tags_to_backups と copy_tags_to_volumes を有効化
    - weekly_maintenance_start_time を業務時間外に設定
    - CloudWatch アラームで容量とパフォーマンスを監視

12. クォータ管理:
    - ユーザーまたはグループクォータでストレージ使用を制御
    - ファイルシステムまたはボリュームレベルでクォータを設定可能
    - 定期的にクォータ使用率を監視

参考リンク:
- FSx for OpenZFS ユーザーガイド:
  https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/what-is-fsx.html
- パフォーマンスガイド:
  https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/performance.html
- ベストプラクティス:
  https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/best-practices.html
- 料金情報:
  https://aws.amazon.com/fsx/openzfs/pricing/
*/
