# ================================================================================
# Amazon DocumentDB Cluster Resource
# ================================================================================
# Terraform AWS Provider Version: 6.28.0
# Resource: aws_docdb_cluster
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster
# AWS Documentation: https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-create.html
#
# Amazon DocumentDB (with MongoDB compatibility) は、MongoDB ワークロード向けの
# フルマネージド型ドキュメントデータベースサービスです。
# クラスターは、プライマリインスタンス1つと最大15個のレプリカインスタンスで構成され、
# データは3つのアベイラビリティゾーンにわたって6重にレプリケートされます。
# ================================================================================

resource "aws_docdb_cluster" "example" {
  # ============================================================
  # 基本設定 (Basic Configuration)
  # ============================================================

  # クラスター識別子
  # 用途: クラスターを一意に識別するための名前
  # 制約:
  #   - 長さ: 1～63文字（英数字またはハイフン）
  #   - 先頭文字は英字である必要がある
  #   - 末尾にハイフンを含めない、連続したハイフンを使用しない
  #   - リージョン内のAWS アカウントごとに一意である必要がある
  #   - Amazon RDS、Neptune、DocumentDB間で一意である必要がある
  # 変更時の影響: Forces new resource (新規リソース作成)
  cluster_identifier = "my-docdb-cluster"

  # クラスター識別子プレフィックス
  # 用途: 指定されたプレフィックスで始まる一意のクラスター識別子を自動生成
  # 注意: cluster_identifier と競合するため、どちらか一方のみを使用
  # 変更時の影響: Forces new resource
  # cluster_identifier_prefix = "docdb-"

  # ============================================================
  # エンジン設定 (Engine Configuration)
  # ============================================================

  # データベースエンジン
  # 用途: 使用するデータベースエンジンを指定
  # 有効な値: docdb（デフォルト）
  # デフォルト: docdb
  engine = "docdb"

  # エンジンバージョン
  # 用途: 使用するデータベースエンジンのバージョンを指定
  # 利用可能なバージョン: 3.6.0, 4.0.0, 5.0.0
  # 注意: バージョンの更新は停止時間が発生する可能性がある
  # ベストプラクティス: 本番環境では最新の安定バージョンを使用
  # engine_version = "5.0.0"

  # メジャーバージョンアップグレードの許可
  # 用途: メジャーバージョンのアップグレードを許可するかどうか
  # デフォルト: false
  # 注意: engine_version でメジャーバージョンを指定する場合は true に設定する必要がある
  # allow_major_version_upgrade = false

  # ============================================================
  # 認証設定 (Authentication Configuration)
  # ============================================================

  # マスターユーザー名
  # 用途: クラスターのマスターユーザー名を指定
  # 制約:
  #   - 長さ: 1～63文字の英数字
  #   - 先頭文字は英字である必要がある
  #   - データベースエンジンの予約語は使用不可
  # 注意: snapshot_identifier または global_cluster_identifier を使用する場合は不要
  master_username = "docdbadmin"

  # マスターユーザーパスワード
  # 用途: マスターユーザーのパスワードを指定
  # セキュリティ上の注意:
  #   - このパスワードはログに表示され、ステートファイルに平文で保存される
  #   - 機密情報の管理について: https://www.terraform.io/docs/state/sensitive-data.html
  # 制約: DocumentDB の命名規則に従う必要がある
  # 競合: master_password_wo、manage_master_user_password と競合
  # 注意: snapshot_identifier または global_cluster_identifier を使用する場合は不要
  master_password = "Must-Be-At-Least-8-Characters"

  # マスターユーザーパスワード（書き込み専用）
  # 用途: 書き込み専用のマスターユーザーパスワード（Terraform 1.11.0以降）
  # 利点: ステートファイルに保存されないため、セキュリティが向上
  # 競合: master_password、manage_master_user_password と競合
  # 参考: https://developer.hashicorp.com/terraform/language/resources/ephemeral#write-only-arguments
  # master_password_wo = "Must-Be-At-Least-8-Characters"

  # マスターユーザーパスワード（書き込み専用）のバージョン
  # 用途: master_password_wo と併用して更新をトリガー
  # 使い方: パスワードの更新が必要な場合、この値をインクリメント
  # master_password_wo_version = 1

  # マスターユーザーパスワードの管理
  # 用途: AWS Secrets Manager でマスターユーザーパスワードを管理するかどうか
  # デフォルト: false
  # 利点: パスワードローテーションの自動化、セキュアな保管
  # 競合: master_password、master_password_wo と競合
  # manage_master_user_password = false

  # ============================================================
  # ネットワーク設定 (Network Configuration)
  # ============================================================

  # アベイラビリティゾーン
  # 用途: クラスター内のインスタンスを作成できるAZのリスト
  # 重要な注意:
  #   - 3つ未満のAZを指定した場合、DocumentDBが自動的に3つのAZを割り当てる
  #   - これにより、次回のTerraform適用時にリソースの再作成が必要になる可能性がある
  # ベストプラクティス:
  #   - 3つのAZを明示的に指定するか、lifecycle の ignore_changes を使用
  #   - 高可用性のため、複数のAZにインスタンスを分散させる
  # availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # DBサブネットグループ名
  # 用途: クラスターに関連付けるDBサブネットグループ
  # 注意: サブネットグループには少なくとも2つのAZに1つずつサブネットが必要
  # db_subnet_group_name = "my-docdb-subnet-group"

  # VPCセキュリティグループID
  # 用途: クラスターに関連付けるVPCセキュリティグループのリスト
  # ベストプラクティス: 必要最小限のインバウンドルールのみを許可
  # vpc_security_group_ids = ["sg-12345678"]

  # ポート
  # 用途: データベース接続を受け付けるポート番号
  # デフォルト: 27017（MongoDBのデフォルトポート）
  # 注意: 企業のファイアウォールでデフォルトポートがブロックされている場合は変更
  # port = 27017

  # ネットワークタイプ
  # 用途: DBクラスターのネットワークタイプを指定
  # 有効な値: IPV4、DUAL（IPv4とIPv6の両方）
  # デフォルト: IPV4
  # network_type = "IPV4"

  # ============================================================
  # ストレージ設定 (Storage Configuration)
  # ============================================================

  # ストレージタイプ
  # 用途: DBクラスターに関連付けるストレージタイプを指定
  # 有効な値:
  #   - standard: 標準ストレージ（I/O使用量が少～中程度の場合に適している）
  #   - iopt1: I/O最適化ストレージ（I/O集約型アプリケーションに適している）
  # 選択基準:
  #   - I/Oコストが総コストの25%未満の場合: standard を推奨
  #   - I/Oコストが総コストの25%以上の場合: iopt1 を推奨
  # 注意:
  #   - iopt1 はエンジンバージョン 5.0.0 以降で利用可能
  #   - ストレージタイプの変更は30日に1回のみ可能（standardへの変更はいつでも可能）
  #   - 変更時にダウンタイムや再起動は不要
  # storage_type = "standard"

  # ストレージの暗号化
  # 用途: DBクラスターを暗号化するかどうか
  # デフォルト: false
  # ベストプラクティス: 本番環境では true に設定することを強く推奨
  # 注意: 暗号化を有効にする場合は、クラスター作成時に指定する必要がある
  storage_encrypted = true

  # KMSキーID
  # 用途: 暗号化に使用するKMSキーのARN
  # 注意: storage_encrypted = true の場合に指定
  # 省略した場合: デフォルトのKMSキーが使用される
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # ============================================================
  # バックアップ設定 (Backup Configuration)
  # ============================================================

  # バックアップ保持期間
  # 用途: バックアップを保持する日数
  # 範囲: 1～35日
  # デフォルト: 1日
  # ベストプラクティス: 本番環境では7日以上を推奨
  backup_retention_period = 7

  # 優先バックアップウィンドウ
  # 用途: 自動バックアップが作成される毎日の時間範囲（UTC）
  # 形式: hh24:mi-hh24:mi（例: 07:00-09:00）
  # デフォルト: リージョンごとに8時間のブロックからランダムに選択された30分のウィンドウ
  # 注意: 優先メンテナンスウィンドウと重複しないようにする
  preferred_backup_window = "07:00-09:00"

  # 最終スナップショット識別子
  # 用途: クラスター削除時に作成される最終DBスナップショットの名前
  # 注意: skip_final_snapshot = false の場合は必須
  # final_snapshot_identifier = "my-docdb-cluster-final-snapshot"

  # 最終スナップショットのスキップ
  # 用途: クラスター削除時に最終DBスナップショットを作成するかどうか
  # デフォルト: false
  # 注意: true を指定すると、クラスター削除時にスナップショットが作成されない
  # ベストプラクティス: 本番環境では false に設定し、final_snapshot_identifier を指定
  skip_final_snapshot = true

  # スナップショット識別子
  # 用途: スナップショットからクラスターを作成する場合のスナップショット名またはARN
  # 注意:
  #   - 自動スナップショットは使用しない（別のクラスターからの場合を除く）
  #   - 自動スナップショットはリソース置換時にクラスター削除の一部として削除される
  # snapshot_identifier = "my-docdb-cluster-snapshot"

  # ============================================================
  # メンテナンス設定 (Maintenance Configuration)
  # ============================================================

  # 優先メンテナンスウィンドウ
  # 用途: システムメンテナンスが実行される週次の時間範囲（UTC）
  # 形式: ddd:hh24:mi-ddd:hh24:mi（例: wed:04:00-wed:04:30）
  # 注意: 優先バックアップウィンドウと重複しないようにする
  # preferred_maintenance_window = "mon:03:00-mon:04:00"

  # 即座に適用
  # 用途: クラスターの変更を即座に適用するか、次のメンテナンスウィンドウで適用するか
  # デフォルト: false
  # 注意: true を指定すると、サーバーの再起動により短時間のダウンタイムが発生する可能性がある
  # ベストプラクティス: 本番環境では false に設定し、計画的なメンテナンスウィンドウで適用
  apply_immediately = false

  # ============================================================
  # クラスターパラメータ設定 (Cluster Parameter Configuration)
  # ============================================================

  # DBクラスターパラメータグループ名
  # 用途: クラスターに関連付けるクラスターパラメータグループ
  # 注意: カスタムパラメータが必要な場合は、独自のパラメータグループを作成して指定
  # db_cluster_parameter_group_name = "default.docdb5.0"

  # ============================================================
  # ログ設定 (Log Configuration)
  # ============================================================

  # CloudWatch Logsへのエクスポートを有効にするログタイプ
  # 用途: CloudWatch Logsにエクスポートするログタイプのリスト
  # サポートされるログタイプ: audit、profiler
  # 注意: 省略した場合、ログはエクスポートされない
  # ベストプラクティス: 監査とパフォーマンス分析のため、両方のログを有効化
  # enabled_cloudwatch_logs_exports = ["audit", "profiler"]

  # ============================================================
  # 削除保護設定 (Deletion Protection Configuration)
  # ============================================================

  # 削除保護
  # 用途: DBクラスターに削除保護を有効にするかどうか
  # デフォルト: false
  # 注意: 削除保護が有効な場合、クラスターを削除できない
  # ベストプラクティス: 本番環境では true に設定することを強く推奨
  deletion_protection = false

  # ============================================================
  # グローバルクラスター設定 (Global Cluster Configuration)
  # ============================================================

  # グローバルクラスター識別子
  # 用途: aws_docdb_global_cluster で指定されたグローバルクラスター識別子
  # 注意: グローバルクラスターのセカンダリクラスターとして使用する場合に指定
  # global_cluster_identifier = "my-global-cluster"

  # ============================================================
  # Serverless V2設定 (Serverless V2 Configuration)
  # ============================================================

  # Serverless V2スケーリング設定
  # 用途: Amazon DocumentDB Serverlessクラスターのスケーリング設定
  # 注意: Serverless V2を使用する場合のみ指定
  # serverless_v2_scaling_configuration {
  #   # 最小容量
  #   # 範囲: 0.5～256 DCU（0.5単位）
  #   # min_capacity = 0.5
  #
  #   # 最大容量
  #   # 範囲: 1～256 DCU（0.5単位）
  #   # max_capacity = 1.0
  # }

  # ============================================================
  # ポイントインタイムリストア設定 (Point-in-Time Restore Configuration)
  # ============================================================

  # ポイントインタイムリストア
  # 用途: DBインスタンスを任意の時点にリストアする設定
  # 注意:
  #   - cluster_identifier 引数を新しいDBインスタンス名で設定する必要がある
  #   - Forces new resource
  # restore_to_point_in_time {
  #   # ソースクラスター識別子
  #   # 必須: リストア元のソースDBクラスターの識別子
  #   # source_cluster_identifier = "source-cluster-id"
  #
  #   # リストア時刻
  #   # 用途: リストアする日時（UTC形式）
  #   # 注意:
  #   #   - DBインスタンスの最新のリストア可能時刻より前である必要がある
  #   #   - use_latest_restorable_time と併用不可
  #   # restore_to_time = "2024-01-01T12:00:00Z"
  #
  #   # 最新のリストア可能時刻を使用
  #   # デフォルト: false
  #   # 注意: restore_to_time と併用不可
  #   # use_latest_restorable_time = false
  #
  #   # リストアタイプ
  #   # 有効な値: full-copy、copy-on-write
  #   # restore_type = "full-copy"
  # }

  # ============================================================
  # タグ設定 (Tags Configuration)
  # ============================================================

  # タグ
  # 用途: DBクラスターに割り当てるタグのマップ
  # 注意: プロバイダーの default_tags 設定ブロックと一致するキーを持つタグは上書きされる
  # ベストプラクティス: 環境、コスト配分、所有者などの情報を含める
  tags = {
    Name        = "my-docdb-cluster"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# ================================================================================
# 出力例 (Output Examples)
# ================================================================================

# クラスターのARN
output "cluster_arn" {
  description = "Amazon DocumentDB クラスターのARN"
  value       = aws_docdb_cluster.example.arn
}

# クラスターのエンドポイント
output "cluster_endpoint" {
  description = "DocumentDB クラスターの書き込みエンドポイント"
  value       = aws_docdb_cluster.example.endpoint
}

# リーダーエンドポイント
output "cluster_reader_endpoint" {
  description = "DocumentDB クラスターの読み取り専用エンドポイント（レプリカ間で自動ロードバランシング）"
  value       = aws_docdb_cluster.example.reader_endpoint
}

# クラスターリソースID
output "cluster_resource_id" {
  description = "DocumentDB クラスターのリソースID"
  value       = aws_docdb_cluster.example.cluster_resource_id
}

# クラスターメンバー
output "cluster_members" {
  description = "クラスターに属するDocumentDB インスタンスのリスト"
  value       = aws_docdb_cluster.example.cluster_members
}

# ホストゾーンID
output "hosted_zone_id" {
  description = "エンドポイントのRoute53 ホストゾーンID"
  value       = aws_docdb_cluster.example.hosted_zone_id
}

# ================================================================================
# 使用例とベストプラクティス
# ================================================================================
#
# 1. 基本的なクラスター作成:
#    - cluster_identifier、master_username、master_password を必須で指定
#    - storage_encrypted = true でデータ暗号化を有効化
#    - backup_retention_period を7日以上に設定
#
# 2. 高可用性構成:
#    - availability_zones で3つのAZを明示的に指定
#    - 複数のインスタンスを異なるAZに配置
#    - deletion_protection = true で誤削除を防止
#
# 3. セキュリティのベストプラクティス:
#    - VPCサブネットグループとセキュリティグループを適切に設定
#    - storage_encrypted = true でデータを暗号化
#    - KMSキーを使用してカスタム暗号化キーを管理
#    - manage_master_user_password = true でパスワードをSecrets Managerで管理
#
# 4. バックアップとリカバリ:
#    - backup_retention_period を適切に設定（7～35日）
#    - preferred_backup_window でバックアップ時間を指定
#    - skip_final_snapshot = false で最終スナップショットを作成
#
# 5. パフォーマンス最適化:
#    - I/O集約型ワークロードには storage_type = "iopt1" を使用
#    - enabled_cloudwatch_logs_exports でログを有効化して監視
#    - Serverless V2を使用する場合は適切なスケーリング設定を行う
#
# 6. コスト最適化:
#    - I/Oコストが総コストの25%未満の場合は standard ストレージを使用
#    - I/Oコストが総コストの25%以上の場合は iopt1 ストレージを使用
#    - タグを使用してコスト配分を追跡
#
# 7. メンテナンス:
#    - preferred_maintenance_window でメンテナンス時間を指定
#    - apply_immediately = false で変更を次のメンテナンスウィンドウで適用
#    - allow_major_version_upgrade でバージョンアップグレード戦略を管理
#
# 8. グローバルクラスター:
#    - global_cluster_identifier を使用してマルチリージョンクラスターを構成
#    - セカンダリリージョンでの災害復旧を実現
#
# ================================================================================
# 参考リンク (References)
# ================================================================================
#
# Terraform AWS Provider Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster
#
# AWS DocumentDB Documentation:
# https://docs.aws.amazon.com/documentdb/latest/developerguide/what-is.html
#
# AWS CLI Reference:
# https://docs.aws.amazon.com/cli/latest/reference/docdb/create-db-cluster.html
#
# Storage Configuration:
# https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-storage-configs.html
#
# Global Clusters:
# https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.html
#
# ================================================================================
