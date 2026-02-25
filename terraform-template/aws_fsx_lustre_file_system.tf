#---------------------------------------
# Amazon FSx for Lustre ファイルシステム
#---------------------------------------
# 高性能コンピューティング（HPC）やML、ビッグデータ解析用の
# POSIX準拠の並列ファイルシステムを提供するマネージドサービス
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/fsx_lustre_file_system
#
# NOTE: このテンプレートは全設定項目を網羅した参考例です。
#       実際の使用時は必要な項目のみを残し、不要な項目は削除してください。
#
# 主な用途:
# - 機械学習トレーニングの高速データアクセス
# - ビッグデータ解析やゲノム解析の大規模処理
# - S3データリポジトリとの高速同期
# - メディアレンダリングや金融モデリング
#
# 参考: https://docs.aws.amazon.com/fsx/latest/LustreGuide/what-is.html

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_fsx_lustre_file_system" "example" {
  # subnet_ids - 必須
  # 設定内容: ファイルシステムにアクセス可能なサブネットのIDリスト
  # 制約事項: 現在は単一サブネット(1つのAZ)のみサポート
  # 注意点: ファイルサーバーは指定したサブネットのAZに配置される
  subnet_ids = ["subnet-12345678"]

  #---------------------------------------
  # デプロイメントタイプ設定
  #---------------------------------------

  # deployment_type
  # 設定内容: ファイルシステムのデプロイメント種別
  # 設定可能な値:
  # - SCRATCH_1: 一時的な高速ストレージ（低コスト、レプリケーションなし）
  # - SCRATCH_2: SCRATCH_1の改良版（バースト性能向上、200MB/s/TiB）
  # - PERSISTENT_1: 永続的ストレージ（自動バックアップ、HA構成）
  # - PERSISTENT_2: PERSISTENT_1の改良版（SSD/HDD/INTELLIGENT_TIERING対応）
  # 省略時: SCRATCH_1
  deployment_type = "PERSISTENT_2"

  #---------------------------------------
  # ストレージ設定
  #---------------------------------------

  # storage_capacity
  # 設定内容: ファイルシステムのストレージ容量（GiB単位）
  # 最小値: 1200 GiB
  # 注意点:
  # - デプロイメントタイプにより増分値が異なる
  # - SCRATCH_2/PERSISTENT_1/PERSISTENT_2は作成後の拡張可能
  # - バックアップからの作成時は省略可能
  storage_capacity = 1200

  # storage_type
  # 設定内容: ストレージメディアの種別
  # 設定可能な値:
  # - SSD: 高IOPS、低レイテンシ（デフォルト）
  # - HDD: PERSISTENT_1のみ対応、コスト効率重視
  # - INTELLIGENT_TIERING: PERSISTENT_2のみ、自動階層化
  # 注意点: INTELLIGENT_TIERINGはdata_read_cache_configuration必須
  # 省略時: SSD
  storage_type = "SSD"

  # per_unit_storage_throughput
  # 設定内容: 1TiBあたりのスループット（MB/s/TiB）
  # 設定可能な値:
  # - PERSISTENT_1 + SSD: 50, 100, 200
  # - PERSISTENT_1 + HDD: 12, 40
  # - PERSISTENT_2 + SSD: 125, 250, 500, 1000
  # 注意点: efa_enabled有効時は変更不可
  per_unit_storage_throughput = 125

  # throughput_capacity
  # 設定内容: INTELLIGENT_TIERINGストレージタイプのスループット（MBps）
  # 設定可能な値: 4000または4000の倍数
  # 必須条件: storage_type = "INTELLIGENT_TIERING"の場合のみ
  throughput_capacity = 4000

  # drive_cache_type
  # 設定内容: PERSISTENT_1 + HDDのドライブキャッシュ種別
  # 設定可能な値: READ（読み取りキャッシュ）、NONE
  # 必須条件: PERSISTENT_1でHDDを使用する場合は必須
  drive_cache_type = "READ"

  #---------------------------------------
  # S3データリポジトリ連携（PERSISTENT_1のみ）
  #---------------------------------------

  # import_path
  # 設定内容: FSx Lustreファイルシステムのデータリポジトリとして使用するS3 URI
  # 形式例: s3://my-bucket/optional-prefix/
  # 制約事項: PERSISTENT_1デプロイメントタイプのみサポート
  # 注意点: PERSISTENT_2ではaws_fsx_data_repository_associationを使用
  import_path = "s3://example-bucket/data/"

  # export_path
  # 設定内容: FSxファイルシステムのルートをエクスポートするS3 URI
  # 制約事項:
  # - import_pathと同じS3バケット必須
  # - import_pathと同値に設定するとエクスポート時に上書き
  # 省略時: s3://{IMPORT BUCKET}/FSxLustre{CREATION TIMESTAMP}
  # PERSISTENT_1のみサポート
  export_path = "s3://example-bucket/exports/"

  # imported_file_chunk_size
  # 設定内容: データリポジトリからインポートするファイルの
  #           ストライプカウント/単一ディスクあたりの最大データ量（MiB）
  # 設定可能な値: 1～512000
  # 省略時: 1024
  # 制約事項: PERSISTENT_1のみサポート、import_path必須
  imported_file_chunk_size = 1024

  # auto_import_policy
  # 設定内容: リンクされたS3バケット変更時の自動インポートポリシー
  # 設定可能な値:
  # - NEW: 新規オブジェクトのみ自動インポート
  # - NEW_CHANGED: 新規と変更されたオブジェクトを自動インポート
  # - NEW_CHANGED_DELETED: 削除も含めて自動同期
  # 制約事項: PERSISTENT_1のみサポート
  # 参考: https://docs.aws.amazon.com/fsx/latest/LustreGuide/autoimport-data-repo.html
  auto_import_policy = "NEW_CHANGED"

  #---------------------------------------
  # バックアップ設定
  #---------------------------------------

  # backup_id
  # 設定内容: ファイルシステム作成元のソースバックアップID
  # 用途: 既存バックアップからファイルシステムを復元
  backup_id = "backup-12345678"

  # automatic_backup_retention_days
  # 設定内容: 自動バックアップの保持日数
  # 設定可能な値: 0～90（0で自動バックアップ無効）
  # 制約事項: PERSISTENT_1/PERSISTENT_2のみサポート
  automatic_backup_retention_days = 7

  # daily_automatic_backup_start_time
  # 設定内容: 日次自動バックアップの開始時刻（UTC）
  # 形式: HH:MM（例: 05:00 = UTC午前5時）
  # 必須条件: automatic_backup_retention_daysが1以上の場合
  # 制約事項: PERSISTENT_1/PERSISTENT_2のみサポート
  daily_automatic_backup_start_time = "05:00"

  # copy_tags_to_backups
  # 設定内容: ファイルシステムのタグをバックアップにコピーするか
  # 省略時: false
  # 制約事項: PERSISTENT_1/PERSISTENT_2のみサポート
  copy_tags_to_backups = true

  # skip_final_backup
  # 設定内容: ファイルシステム削除時の最終バックアップをスキップするか
  # 省略時: true
  # 注意点:
  # - SCRATCHデプロイメントタイプは常にスキップされる
  # - falseに設定する場合は削除前に適用が必要
  skip_final_backup = false

  # final_backup_tags
  # 設定内容: 最終バックアップに適用するタグのマップ
  # 注意点: SCRATCHデプロイメントタイプでは無視される
  final_backup_tags = {
    Environment = "production"
    Backup      = "final"
  }

  #---------------------------------------
  # 圧縮・パフォーマンス設定
  #---------------------------------------

  # data_compression_type
  # 設定内容: ファイルシステムのデータ圧縮方式
  # 設定可能な値:
  # - LZ4: 高速圧縮アルゴリズム（CPU使用量とストレージをトレードオフ）
  # - NONE: 圧縮なし
  # 省略時: NONE
  # 注意点: 設定解除するとNONEに戻る
  data_compression_type = "LZ4"

  # file_system_type_version
  # 設定内容: Lustreファイルシステムのバージョン
  # 設定可能な値:
  # - 2.10: SCRATCH_1/SCRATCH_2/PERSISTENT_1で利用可能
  # - 2.12: 全デプロイメントタイプで利用可能
  file_system_type_version = "2.12"

  # efa_enabled
  # 設定内容: Elastic Fabric Adapter（EFA）とGPUDirect Storage（GDS）のサポート
  # 制約事項:
  # - PERSISTENT_2デプロイメントタイプのみ
  # - metadata_configuration必須
  # - EFA対応セキュリティグループ必須
  # 注意点: 作成時のみ設定可能、後から変更不可（per_unit_storage_throughputも固定）
  efa_enabled = true

  #---------------------------------------
  # ネットワーク設定
  #---------------------------------------

  # security_group_ids
  # 設定内容: ファイルシステムアクセス用のENIに適用するセキュリティグループIDリスト
  # 注意点: 全ネットワークインターフェースに適用される
  security_group_ids = ["sg-12345678"]

  #---------------------------------------
  # 暗号化設定
  #---------------------------------------

  # kms_key_id
  # 設定内容: 保存時暗号化に使用するKMSキーのARN
  # 対象: PERSISTENT_1/PERSISTENT_2デプロイメントタイプ
  # 省略時: AWS管理のKMSキー
  kms_key_id = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"

  #---------------------------------------
  # メンテナンス設定
  #---------------------------------------

  # weekly_maintenance_start_time
  # 設定内容: 週次メンテナンスの優先開始時刻（UTC）
  # 形式: d:HH:MM（d=曜日 1=月曜～7=日曜、例: 1:03:00 = 月曜午前3時）
  weekly_maintenance_start_time = "1:03:00"

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # tags
  # 設定内容: ファイルシステムに割り当てるタグ
  tags = {
    Name        = "my-fsx-lustre"
    Environment = "production"
    Workload    = "ml-training"
  }

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # region
  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-west-2"
}

#---------------------------------------
# ネストされたブロック: data_read_cache_configuration
#---------------------------------------
# INTELLIGENT_TIERINGストレージタイプ使用時の
# SSD読み取りキャッシュ設定

# resource "aws_fsx_lustre_file_system" "intelligent_tiering_example" {
#   subnet_ids                    = ["subnet-12345678"]
#   deployment_type               = "PERSISTENT_2"
#   storage_type                  = "INTELLIGENT_TIERING"
#   storage_capacity              = 1200
#   per_unit_storage_throughput   = 125
#   throughput_capacity           = 4000
#
#   data_read_cache_configuration {
#     # sizing_mode - 必須
#     # 設定内容: キャッシュサイズの決定方式
#     # 設定可能な値:
#     # - NO_CACHE: キャッシュなし
#     # - USER_PROVISIONED: ユーザー指定サイズ
#     # - PROPORTIONAL_TO_THROUGHPUT_CAPACITY: スループット容量に比例
#     sizing_mode = "USER_PROVISIONED"
#
#     # size
#     # 設定内容: SSD読み取りキャッシュのサイズ（GiB）
#     # 必須条件: sizing_mode = "USER_PROVISIONED"の場合
#     size = 1000
#   }
#
#   metadata_configuration {
#     mode = "USER_PROVISIONED"
#     iops = 6000
#   }
# }

#---------------------------------------
# ネストされたブロック: log_configuration
#---------------------------------------
# Amazon CloudWatch Logsへのログ出力設定

# resource "aws_fsx_lustre_file_system" "logging_example" {
#   subnet_ids       = ["subnet-12345678"]
#   storage_capacity = 1200
#
#   log_configuration {
#     # level
#     # 設定内容: ログに記録するイベントレベル
#     # 設定可能な値:
#     # - DISABLED: ログ無効（デフォルト）
#     # - WARN_ONLY: 警告のみ
#     # - ERROR_ONLY: エラーのみ
#     # - FAILURE_ONLY: 失敗のみ
#     # - WARN_ERROR: 警告とエラー
#     # 省略時: DISABLED
#     level = "WARN_ERROR"
#
#     # destination
#     # 設定内容: ログの送信先CloudWatch LogsグループのARN
#     # 制約事項: ロググループ名は/aws/fsxプレフィックス必須
#     # 省略時: /aws/fsx/lustreに自動作成されるログストリーム
#     destination = "arn:aws:logs:us-west-2:123456789012:log-group:/aws/fsx/my-lustre-logs"
#   }
# }

#---------------------------------------
# ネストされたブロック: metadata_configuration
#---------------------------------------
# Lustreメタデータの設定（PERSISTENT_2のみ）

# resource "aws_fsx_lustre_file_system" "metadata_example" {
#   subnet_ids                  = ["subnet-12345678"]
#   deployment_type             = "PERSISTENT_2"
#   storage_capacity            = 1200
#   per_unit_storage_throughput = 125
#
#   metadata_configuration {
#     # mode
#     # 設定内容: メタデータIOPSの設定モード
#     # 設定可能な値:
#     # - AUTOMATIC: 自動設定
#     # - USER_PROVISIONED: ユーザー指定（INTELLIGENT_TIERING必須）
#     # 注意点: INTELLIGENT_TIERINGはUSER_PROVISIONED必須
#     mode = "USER_PROVISIONED"
#
#     # iops
#     # 設定内容: メタデータ用にプロビジョニングするIOPS
#     # 設定可能な値:
#     # - 1500, 3000, 6000
#     # - 12000～192000（12000刻み）
#     # - INTELLIGENT_TIERING: 6000または12000のみ
#     # 必須条件: mode = "USER_PROVISIONED"の場合
#     # 警告: 高い値から低い値への変更はリソース再作成（データ消失）
#     iops = 12000
#   }
# }

#---------------------------------------
# ネストされたブロック: root_squash_configuration
#---------------------------------------
# ルートスクワッシュ設定（ルートレベルアクセス制限）

# resource "aws_fsx_lustre_file_system" "root_squash_example" {
#   subnet_ids       = ["subnet-12345678"]
#   storage_capacity = 1200
#
#   root_squash_configuration {
#     # root_squash
#     # 設定内容: ファイルシステムのルートスクワッシュ用UID:GID
#     # 形式: UID:GID（例: 65534:65534）
#     # 設定可能な値: 0～4294967294
#     # 用途: rootユーザーのアクセスを指定したUID/GIDにマッピング
#     root_squash = "65534:65534"
#
#     # no_squash_nids
#     # 設定内容: ルートスクワッシュを適用しないクライアントのNID配列
#     # 形式:
#     # - 単一アドレス: 10.0.1.6@tcp
#     # - アドレス範囲: 10.0.[2-10].[1-255]@tcp
#     # 用途: 特定のクライアントのみrootアクセスを許可
#     no_squash_nids = ["10.0.1.0@tcp", "10.0.2.[1-255]@tcp"]
#   }
# }

#---------------------------------------
# ネストされたブロック: timeouts
#---------------------------------------

# resource "aws_fsx_lustre_file_system" "timeouts_example" {
#   subnet_ids       = ["subnet-12345678"]
#   storage_capacity = 1200
#
#   timeouts {
#     # create
#     # 設定内容: 作成時のタイムアウト時間
#     create = "60m"
#
#     # update
#     # 設定内容: 更新時のタイムアウト時間
#     update = "60m"
#
#     # delete
#     # 設定内容: 削除時のタイムアウト時間
#     delete = "60m"
#   }
# }

#---------------------------------------
# Attributes Reference（参照専用の出力値）
#---------------------------------------
# このリソース作成後に参照可能な属性

# 出力例:
# output "fsx_details" {
#   value = {
#     arn                    = aws_fsx_lustre_file_system.example.arn
#     dns_name               = aws_fsx_lustre_file_system.example.dns_name
#     id                     = aws_fsx_lustre_file_system.example.id
#     mount_name             = aws_fsx_lustre_file_system.example.mount_name
#     network_interface_ids  = aws_fsx_lustre_file_system.example.network_interface_ids
#     owner_id               = aws_fsx_lustre_file_system.example.owner_id
#     vpc_id                 = aws_fsx_lustre_file_system.example.vpc_id
#   }
# }
