#---------------------------------------------------------------
# Amazon RDS Cluster
#---------------------------------------------------------------
#
# Amazon RDS Aurora ClusterまたはRDS Multi-AZ DB Clusterを管理するリソースです。
# Aurora MySQL、Aurora PostgreSQL、MySQL、PostgreSQLエンジンをサポートします。
# serverlessエンジンモードでのクラスター構成には対応していません（provisioned/serverlessv2を利用）。
#
# AWS公式ドキュメント:
#   - Aurora Serverless v2: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html
#   - Multi-AZ DB Clusters: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/multi-az-db-clusters-concepts.html
#   - Amazon Aurora概要: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_AuroraOverview.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # cluster_identifier (Optional, Forces new resource)
  # 設定内容: クラスター識別子を指定します。
  # 設定可能な値: 1-63文字の小文字英数字とハイフンの組み合わせ
  # 省略時: Terraformがランダムで一意の識別子を生成します。
  # 注意: cluster_identifier_prefixと排他的（どちらか一方のみ指定可能）
  cluster_identifier = "my-aurora-cluster"

  # cluster_identifier_prefix (Optional, Forces new resource)
  # 設定内容: クラスター識別子のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: cluster_identifierと排他的（どちらか一方のみ指定可能）
  cluster_identifier_prefix = null

  # engine (Required)
  # 設定内容: 使用するデータベースエンジンを指定します。
  # 設定可能な値:
  #   - "aurora-mysql": Aurora MySQL互換エンジン
  #   - "aurora-postgresql": Aurora PostgreSQL互換エンジン
  #   - "mysql": Multi-AZ RDS MySQL
  #   - "postgres": Multi-AZ RDS PostgreSQL
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_AuroraOverview.html
  engine = "aurora-mysql"

  # engine_version (Optional)
  # 設定内容: データベースエンジンのバージョンを指定します。
  # 設定可能な値: エンジンごとに利用可能なバージョンが異なります
  # 省略時: AWSが提供するデフォルトバージョンが使用されます
  # 注意: バージョンアップデートは停止時間が発生します
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Updates.html
  engine_version = "8.0.mysql_aurora.3.05.2"

  # engine_mode (Optional)
  # 設定内容: データベースエンジンモードを指定します。
  # 設定可能な値:
  #   - "provisioned" (デフォルト): 通常のプロビジョンドクラスター
  #   - "serverless": Aurora Serverless v1（廃止予定）
  #   - "parallelquery": 並列クエリ機能を有効化
  #   - "global": グローバルデータベースモード（Aurora MySQL 1.21以前のみ）
  #   - "" (空文字): エンジンモードなし
  # 省略時: "provisioned"
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.html
  engine_mode = "provisioned"

  # engine_lifecycle_support (Optional)
  # 設定内容: DBインスタンスのライフサイクルタイプを指定します。
  # 設定可能な値:
  #   - "open-source-rds-extended-support": 拡張サポートを有効化
  #   - "open-source-rds-extended-support-disabled": 拡張サポートを無効化
  # 省略時: "open-source-rds-extended-support"
  # 関連機能: Amazon RDS Extended Support
  #   標準サポート終了後もDBエンジンバージョンのサポートを継続する機能。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/extended-support.html
  engine_lifecycle_support = "open-source-rds-extended-support"

  # database_name (Optional)
  # 設定内容: クラスター作成時に自動作成するデータベース名を指定します。
  # 設定可能な値: エンジンごとの命名規則に従う文字列
  # 省略時: データベースは作成されません
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Limits.html#RDS_Limits.Constraints
  database_name = "mydb"

  # master_username (Optional)
  # 設定内容: マスターユーザー名を指定します。
  # 設定可能な値: 1-16文字の英数字（エンジンにより制約が異なる）
  # 省略時: スナップショットまたはレプリケーションソース、グローバルクラスターから復元する場合は不要
  # 注意: スナップショットからの復元時は、この引数によるインプレース更新はサポートされません
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Limits.html#RDS_Limits.Constraints
  master_username = "admin"

  # master_password (Optional)
  # 設定内容: マスターユーザーのパスワードを指定します。
  # 設定可能な値: 8文字以上の文字列（エンジンにより制約が異なる）
  # 省略時: manage_master_user_passwordがtrueの場合、master_password_wo、snapshot_identifier、replication_source_identifier、global_cluster_identifierのいずれかが必要
  # 注意: ログに表示され、stateファイルに平文で保存されます。manage_master_user_passwordの使用を推奨
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Limits.html#RDS_Limits.Constraints
  master_password = "must_be_eight_characters"

  # master_password_wo (Optional, Write-Only)
  # 設定内容: マスターユーザーのパスワードを指定します（書き込み専用）。
  # 設定可能な値: 8文字以上の文字列
  # 注意: Terraform 1.11.0以降で利用可能。stateファイルに保存されません
  # 参考: https://developer.hashicorp.com/terraform/language/resources/ephemeral#write-only-arguments
  master_password_wo = null

  # master_password_wo_version (Optional)
  # 設定内容: master_password_woの更新トリガー用バージョン番号を指定します。
  # 設定可能な値: 数値。master_password_woを更新する際にインクリメントします
  # 省略時: master_password_woと併せて使用
  master_password_wo_version = null

  # manage_master_user_password (Optional)
  # 設定内容: Secrets Managerでマスターユーザーパスワードを管理するかを指定します。
  # 設定可能な値:
  #   - true: Secrets Managerで自動管理（推奨）
  #   - false (デフォルト): 手動でmaster_passwordを指定
  # 注意: master_passwordと排他的（どちらか一方のみ指定可能）
  manage_master_user_password = false

  # master_user_secret_kms_key_id (Optional)
  # 設定内容: Secrets Managerのシークレット暗号化に使用するKMSキーを指定します。
  # 設定可能な値: KMSキーのARN、キーID、エイリアスARN、またはエイリアス名
  # 省略時: アカウントのデフォルトKMSキーが使用されます
  # 注意: manage_master_user_passwordがtrueの場合のみ有効
  master_user_secret_kms_key_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # availability_zones (Optional)
  # 設定内容: DBクラスターストレージで使用するEC2アベイラビリティゾーンのリストを指定します。
  # 設定可能な値: 最大3つのAZ（例: ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]）
  # 省略時: RDSが自動的に3つのAZを割り当てます
  # 注意: 3つ未満を指定した場合、RDSが自動的に3つに補完し、リソース再作成が必要な差分として表示されます。
  #       lifecycleのignore_changes引数の使用を推奨
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]

  # db_subnet_group_name (Optional)
  # 設定内容: DBサブネットグループを指定します。
  # 設定可能な値: 既存のDBサブネットグループ名
  # 省略時: デフォルトのサブネットグループが使用されます
  # 注意: aws_rds_cluster_instanceで指定するdb_subnet_group_nameと一致させる必要があります
  db_subnet_group_name = "my-db-subnet-group"

  # vpc_security_group_ids (Optional)
  # 設定内容: クラスターに関連付けるVPCセキュリティグループIDのリストを指定します。
  # 設定可能な値: セキュリティグループIDのリスト
  # 省略時: デフォルトのVPCセキュリティグループが使用されます
  vpc_security_group_ids = ["sg-12345678"]

  # network_type (Optional)
  # 設定内容: クラスターのネットワークタイプを指定します。
  # 設定可能な値:
  #   - "IPV4": IPv4のみ
  #   - "DUAL": IPv4とIPv6のデュアルスタック
  # 省略時: "IPV4"
  network_type = "IPV4"

  # port (Optional)
  # 設定内容: データベースが接続を受け入れるポート番号を指定します。
  # 設定可能な値:
  #   - Aurora MySQL: 3306（デフォルト）
  #   - Aurora PostgreSQL: 5432（デフォルト）
  # 省略時: エンジンのデフォルトポートが使用されます
  port = 3306

  #-------------------------------------------------------------
  # Multi-AZ DB Cluster設定
  #-------------------------------------------------------------

  # db_cluster_instance_class (Optional)
  # 設定内容: Multi-AZ DBクラスター内の各DBインスタンスのコンピュートとメモリ容量を指定します。
  # 設定可能な値: db.m6g.xlarge、db.r6gd.xlarge等のインスタンスクラス
  # 省略時: Auroraクラスターでは不要（Multi-AZ DBクラスターでは必須）
  # 関連機能: Multi-AZ DB Clusters
  #   MySQL、PostgreSQLエンジンでのみサポート。高可用性と読み取りスケーリングを提供。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/multi-az-db-clusters-concepts.html
  db_cluster_instance_class = null

  # allocated_storage (Optional)
  # 設定内容: Multi-AZ DBクラスターの各DBインスタンスに割り当てるストレージ容量（GiB）を指定します。
  # 設定可能な値: 数値（GiB単位）
  # 省略時: Auroraクラスターでは不要（Multi-AZ DBクラスターでは必須）
  # 注意: Multi-AZ DBクラスターでのみ使用
  allocated_storage = null

  # storage_type (Optional)
  # 設定内容: DBクラスターに関連付けるストレージタイプを指定します。
  # 設定可能な値:
  #   - "" (空文字、デフォルト): Auroraクラスター用
  #   - "aurora-iopt1": Aurora最適化ストレージ（Auroraのみ）
  #   - "io1": プロビジョンドIOPS（Multi-AZ DBクラスター、デフォルト）
  #   - "io2": プロビジョンドIOPS SSD（Multi-AZ DBクラスター）
  # 省略時: Auroraは""、Multi-AZは"io1"
  # 注意: Multi-AZ DBクラスターでは新規作成時のみ指定可能（Forces new resource）。Auroraはインプレース変更可能
  storage_type = ""

  # iops (Optional)
  # 設定内容: Multi-AZ DBクラスターの各DBインスタンスに割り当てる初期プロビジョンドIOPS値を指定します。
  # 設定可能な値: ストレージ容量の0.5〜50倍の間の数値
  # 省略時: Multi-AZ DBクラスターでは必須
  # 注意: Multi-AZ DBクラスターでのみ使用
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html#USER_PIOPS
  iops = null

  #-------------------------------------------------------------
  # Cluster Scalability設定
  #-------------------------------------------------------------

  # cluster_scalability_type (Optional, Forces new resource)
  # 設定内容: Aurora DBクラスターのスケーラビリティモードを指定します。
  # 設定可能な値:
  #   - "standard" (デフォルト): 通常のDBインスタンス作成を使用
  #   - "limitless": Aurora Limitless Databaseとして動作
  # 省略時: "standard"
  cluster_scalability_type = "standard"

  #-------------------------------------------------------------
  # DBパラメータ設定
  #-------------------------------------------------------------

  # db_cluster_parameter_group_name (Optional)
  # 設定内容: クラスターに関連付けるクラスターパラメータグループを指定します。
  # 設定可能な値: 既存のDBクラスターパラメータグループ名
  # 省略時: エンジンのデフォルトパラメータグループが使用されます
  # 関連機能: DB Cluster Parameter Groups
  #   クラスター内の全DBインスタンスに適用されるエンジン設定値のコンテナ。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_WorkingWithDBClusterParamGroups.html
  db_cluster_parameter_group_name = "default.aurora-mysql8.0"

  # db_instance_parameter_group_name (Optional)
  # 設定内容: DBクラスターの全インスタンスに関連付けるインスタンスパラメータグループを指定します。
  # 設定可能な値: 既存のDBパラメータグループ名
  # 省略時: 各インスタンスのデフォルトパラメータグループが使用されます
  # 注意: allow_major_version_upgradeパラメータと組み合わせた場合のみ有効
  db_instance_parameter_group_name = null

  #-------------------------------------------------------------
  # バックアップ設定
  #-------------------------------------------------------------

  # backup_retention_period (Optional)
  # 設定内容: 自動バックアップを保持する日数を指定します。
  # 設定可能な値: 0〜35の整数
  # 省略時: 1日
  # 注意: 0に設定すると自動バックアップが無効化されます
  backup_retention_period = 7

  # preferred_backup_window (Optional)
  # 設定内容: 自動バックアップが作成される日次時間範囲を指定します（UTC）。
  # 設定可能な値: "hh24:mi-hh24:mi"形式（例: "03:00-04:00"）
  # 省略時: リージョンごとの8時間ブロックからランダムに30分の枠が選択されます
  # 注意: preferred_maintenance_windowと重複しないようにしてください
  preferred_backup_window = "03:00-04:00"

  # backtrack_window (Optional)
  # 設定内容: ターゲットバックトラックウィンドウを秒単位で指定します。
  # 設定可能な値: 0〜259200（72時間）の整数
  # 省略時: 0（バックトラック無効）
  # 注意: auroraおよびaurora-mysqlエンジンでのみ利用可能
  backtrack_window = 0

  # delete_automated_backups (Optional)
  # 設定内容: DBクラスター削除後、自動バックアップを即座に削除するかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 即座に削除
  #   - false: 保持期間に従って保持
  # 省略時: true
  delete_automated_backups = true

  #-------------------------------------------------------------
  # スナップショット設定
  #-------------------------------------------------------------

  # snapshot_identifier (Optional)
  # 設定内容: スナップショットからクラスターを作成する際のスナップショット識別子を指定します。
  # 設定可能な値: DBクラスタースナップショット名またはARN、DBスナップショットARN
  # 省略時: 新規クラスターとして作成されます
  # 注意: global_cluster_identifierと排他的。スナップショットからの復元とグローバルクラスターへの参加は同時に実行不可
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-getting-started.html#aurora-global-database.use-snapshot
  snapshot_identifier = null

  # final_snapshot_identifier (Optional)
  # 設定内容: DBクラスター削除時に作成する最終スナップショットの名前を指定します。
  # 設定可能な値: 有効なスナップショット識別子文字列
  # 省略時: 最終スナップショットは作成されません
  # 注意: skip_final_snapshotがfalseの場合は必須
  final_snapshot_identifier = "my-cluster-final-snapshot"

  # skip_final_snapshot (Optional)
  # 設定内容: DBクラスター削除時に最終スナップショットを作成しないかを指定します。
  # 設定可能な値:
  #   - true: 最終スナップショットを作成しない
  #   - false (デフォルト): 最終スナップショットを作成
  # 省略時: false
  skip_final_snapshot = false

  # copy_tags_to_snapshot (Optional)
  # 設定内容: クラスターのタグをスナップショットにコピーするかを指定します。
  # 設定可能な値:
  #   - true: タグをコピー
  #   - false (デフォルト): タグをコピーしない
  # 省略時: false
  copy_tags_to_snapshot = false

  #-------------------------------------------------------------
  # メンテナンスウィンドウ設定
  #-------------------------------------------------------------

  # preferred_maintenance_window (Optional)
  # 設定内容: システムメンテナンスが実行される週次時間範囲を指定します（UTC）。
  # 設定可能な値: "ddd:hh24:mi-ddd:hh24:mi"形式（例: "mon:03:00-mon:04:00"）
  # 省略時: リージョンごとの8時間ブロックからランダムに30分の枠が選択されます
  # 注意: preferred_backup_windowと重複しないようにしてください
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_UpgradeDBInstance.Maintenance.html
  preferred_maintenance_window = "mon:03:00-mon:04:00"

  # apply_immediately (Optional)
  # 設定内容: クラスターの変更を即座に適用するか、次のメンテナンスウィンドウで適用するかを指定します。
  # 設定可能な値:
  #   - true: 即座に適用
  #   - false (デフォルト): 次のメンテナンスウィンドウで適用
  # 省略時: false
  # 注意: 即座に適用すると、サーバー再起動により短時間のダウンタイムが発生する可能性があります
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.DBInstance.Modifying.html
  apply_immediately = false

  # allow_major_version_upgrade (Optional)
  # 設定内容: エンジンバージョン変更時にメジャーバージョンアップグレードを許可するかを指定します。
  # 設定可能な値:
  #   - true: メジャーバージョンアップグレードを許可
  #   - false (デフォルト): マイナーバージョンアップグレードのみ許可
  # 省略時: false
  allow_major_version_upgrade = false

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # storage_encrypted (Optional)
  # 設定内容: DBクラスターを暗号化するかを指定します。
  # 設定可能な値:
  #   - true: 暗号化を有効化
  #   - false: 暗号化を無効化
  # 省略時: provisionedエンジンモードではfalse、serverlessエンジンモードではtrue
  # 注意: 暗号化されていないsnapshot_identifierから復元する場合は、kms_key_id引数も必要
  storage_encrypted = true

  # kms_key_id (Optional)
  # 設定内容: 暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: アカウントのデフォルトKMSキーが使用されます
  # 注意: storage_encryptedがtrueの場合に指定
  kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # CA証明書設定
  #-------------------------------------------------------------

  # ca_certificate_identifier (Optional)
  # 設定内容: DBクラスターのサーバー証明書に使用するCA証明書識別子を指定します。
  # 設定可能な値: 有効なCA証明書識別子
  # 省略時: リージョンのデフォルトCA証明書が使用されます
  # 注意: Multi-AZ DBクラスターでのみサポート
  ca_certificate_identifier = null

  #-------------------------------------------------------------
  # IAM認証設定
  #-------------------------------------------------------------

  # iam_database_authentication_enabled (Optional)
  # 設定内容: IAMアカウントからデータベースアカウントへのマッピングを有効化するかを指定します。
  # 設定可能な値:
  #   - true: IAM認証を有効化
  #   - false (デフォルト): IAM認証を無効化
  # 省略時: false
  # 関連機能: IAM Database Authentication
  #   IAMロールを使用してデータベースに接続できる機能。パスワード管理が不要になります。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/UsingWithRDS.IAMDBAuth.html
  iam_database_authentication_enabled = false

  # iam_roles (Optional)
  # 設定内容: RDS Clusterに関連付けるIAMロールのARNリストを指定します。
  # 設定可能な値: IAMロールARNのリスト
  # 省略時: IAMロールは関連付けられません
  # 注意: aws_rds_cluster_role_associationリソースとの併用は推奨されません（競合が発生）
  iam_roles = []

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # enabled_cloudwatch_logs_exports (Optional)
  # 設定内容: CloudWatch Logsにエクスポートするログタイプのセットを指定します。
  # 設定可能な値:
  #   - Aurora MySQL/MySQL: "audit", "error", "general", "slowquery"
  #   - Aurora PostgreSQL/PostgreSQL: "postgresql"
  #   - 共通: "iam-db-auth-error", "instance"
  # 省略時: ログはエクスポートされません
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  #-------------------------------------------------------------
  # Performance Insights設定
  #-------------------------------------------------------------

  # performance_insights_enabled (Optional)
  # 設定内容: Performance Insightsを有効化するかを指定します。
  # 設定可能な値:
  #   - true: Performance Insightsを有効化
  #   - false (デフォルト): Performance Insightsを無効化
  # 省略時: false
  # 関連機能: Performance Insights
  #   データベースのパフォーマンスを監視・分析する機能。負荷の可視化やボトルネックの特定に役立ちます。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PerfInsights.Overview.html
  performance_insights_enabled = false

  # performance_insights_kms_key_id (Optional)
  # 設定内容: Performance Insightsデータの暗号化に使用するKMSキーIDを指定します。
  # 設定可能な値: KMSキーID
  # 省略時: デフォルトのRDS KMSキー（aws/rds）が使用されます
  # 注意: performance_insights_enabledがtrueの場合のみ有効
  performance_insights_kms_key_id = null

  # performance_insights_retention_period (Optional)
  # 設定内容: Performance Insightsデータの保持期間を指定します。
  # 設定可能な値:
  #   - 7: 7日間（無料）
  #   - month * 31（monthは1-23の数値）: 月単位の保持期間
  #   - 731: 2年間
  # 省略時: Performance Insights有効時は7日間
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PerfInsights.Overview.cost.html
  performance_insights_retention_period = 7

  #-------------------------------------------------------------
  # 監視設定
  #-------------------------------------------------------------

  # monitoring_interval (Optional)
  # 設定内容: 拡張モニタリングメトリクスが収集される間隔を秒単位で指定します。
  # 設定可能な値: 0, 1, 5, 10, 15, 30, 60
  # 省略時: 0（拡張モニタリングを無効化）
  # 注意: 0を指定すると拡張モニタリングが無効になります
  monitoring_interval = 0

  # monitoring_role_arn (Optional)
  # 設定内容: RDSが拡張モニタリングメトリクスをCloudWatch Logsに送信するためのIAMロールARNを指定します。
  # 設定可能な値: IAMロールARN
  # 省略時: 拡張モニタリングが無効の場合は不要
  # 注意: monitoring_intervalが0より大きい場合は必須
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Monitoring.html#USER_Monitoring.OS.IAMRole.html
  monitoring_role_arn = null

  #-------------------------------------------------------------
  # Database Insights設定
  #-------------------------------------------------------------

  # database_insights_mode (Optional)
  # 設定内容: DBクラスターで有効化するDatabase Insightsのモードを指定します。
  # 設定可能な値:
  #   - "standard": 標準モード
  #   - "advanced": 詳細モード
  # 省略時: Database Insightsは無効
  database_insights_mode = null

  #-------------------------------------------------------------
  # HTTP Endpoint設定
  #-------------------------------------------------------------

  # enable_http_endpoint (Optional)
  # 設定内容: HTTPエンドポイント（Data API）を有効化するかを指定します。
  # 設定可能な値:
  #   - true: Data APIを有効化
  #   - false (デフォルト): Data APIを無効化
  # 省略時: false
  # 注意: engine_mode、engine、engine_versionの特定の組み合わせでのみ有効。
  #       snapshot_identifier、replication_source_identifier、s3_importとは併用不可
  # 関連機能: Data API
  #   SQLステートメントをHTTP APIで実行できる機能。接続管理が不要になります。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/data-api.html
  enable_http_endpoint = false

  #-------------------------------------------------------------
  # Write Forwarding設定
  #-------------------------------------------------------------

  # enable_global_write_forwarding (Optional)
  # 設定内容: グローバルクラスターへの書き込み転送を有効化するかを指定します。
  # 設定可能な値:
  #   - true: 書き込み転送を有効化
  #   - false (デフォルト): 書き込み転送を無効化
  # 省略時: false
  # 注意: セカンダリクラスターに適用し、グローバルクラスターのプライマリクラスターへ書き込みを転送します
  # 関連機能: Global Write Forwarding
  #   セカンダリリージョンからプライマリリージョンへ書き込みを転送する機能。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-write-forwarding.html
  enable_global_write_forwarding = false

  # enable_local_write_forwarding (Optional)
  # 設定内容: リーダーDBインスタンスからライターDBインスタンスへの書き込み転送を有効化するかを指定します。
  # 設定可能な値:
  #   - true: ローカル書き込み転送を有効化
  #   - false (デフォルト): ローカル書き込み転送を無効化
  # 省略時: false
  # 注意: Aurora MySQL 3.04以降でのみ利用可能
  # 関連機能: Local Write Forwarding
  #   リーダーインスタンスでの書き込みオペレーションをライターへ転送する機能。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-mysql-write-forwarding.html
  enable_local_write_forwarding = false

  #-------------------------------------------------------------
  # グローバルクラスター設定
  #-------------------------------------------------------------

  # global_cluster_identifier (Optional)
  # 設定内容: aws_rds_global_clusterで指定されたグローバルクラスター識別子を指定します。
  # 設定可能な値: グローバルクラスターの識別子
  # 省略時: グローバルクラスターには参加しません
  # 注意: snapshot_identifierと排他的
  global_cluster_identifier = null

  #-------------------------------------------------------------
  # レプリケーション設定
  #-------------------------------------------------------------

  # replication_source_identifier (Optional)
  # 設定内容: このDBクラスターをリードレプリカとして作成する場合のソースDBクラスターまたはDBインスタンスのARNを指定します。
  # 設定可能な値: ソースDBクラスターまたはDBインスタンスのARN
  # 省略時: 通常のクラスターとして作成されます
  # 注意: この属性を削除すると、リードレプリカがスタンドアロンクラスターに昇格します。
  #       グローバルクラスターの一部の場合は、lifecycleのignore_changesを使用してください
  replication_source_identifier = null

  # source_region (Optional)
  # 設定内容: 暗号化されたレプリカDBクラスターのソースリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード
  # 省略時: ソースリージョンと同じリージョンとみなされます
  source_region = null

  #-------------------------------------------------------------
  # 削除保護設定
  #-------------------------------------------------------------

  # deletion_protection (Optional)
  # 設定内容: DBクラスターの削除保護を有効化するかを指定します。
  # 設定可能な値:
  #   - true: 削除保護を有効化
  #   - false (デフォルト): 削除保護を無効化
  # 省略時: false
  # 注意: trueに設定すると、データベースを削除できなくなります
  deletion_protection = false

  #-------------------------------------------------------------
  # Active Directory設定
  #-------------------------------------------------------------

  # domain (Optional)
  # 設定内容: クラスターを作成するDirectory Service Active DirectoryドメインのIDを指定します。
  # 設定可能な値: Directory Service ディレクトリID
  # 省略時: Active Directory統合は行われません
  domain = null

  # domain_iam_role_name (Optional)
  # 設定内容: Directory ServiceへのAPI呼び出し時に使用するIAMロール名を指定します。
  # 設定可能な値: IAMロール名
  # 省略時: domainが指定されている場合は必須
  # 注意: domainと併せて指定する必要があります
  domain_iam_role_name = null

  #-------------------------------------------------------------
  # RDS Custom設定
  #-------------------------------------------------------------

  # db_system_id (Optional)
  # 設定内容: RDS Customで使用するためのシステムIDを指定します。
  # 設定可能な値: システムID文字列
  # 省略時: RDS Customは使用されません
  db_system_id = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: DBクラスターに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-aurora-cluster"
    Environment = "production"
  }

  # cluster_members (Optional)
  # 設定内容: クラスターのメンバーとなるRDSインスタンスのリストを指定します。
  # 設定可能な値: RDSインスタンス識別子のリスト
  # 省略時: aws_rds_cluster_instanceリソースで自動的に管理されます
  # 注意: 通常はaws_rds_cluster_instanceリソースで管理されるため、明示的な指定は不要
  cluster_members = null

  #-------------------------------------------------------------
  # ネストブロック: restore_to_point_in_time
  #-------------------------------------------------------------
  # ポイントインタイムリストア設定
  # ソースクラスターから特定の時点にクラスターを復元します。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-pitr.html

  # restore_to_point_in_time {
  #   # source_cluster_identifier (Optional)
  #   # 設定内容: 復元元のソースデータベースクラスターの識別子を指定します。
  #   # 設定可能な値: クラスター識別子。他のAWSアカウントのクラスターの場合はARN
  #   # 注意: source_cluster_resource_idと排他的
  #   source_cluster_identifier = "source-cluster-id"
  #
  #   # source_cluster_resource_id (Optional)
  #   # 設定内容: 復元元のソースデータベースクラスターのクラスターリソースIDを指定します。
  #   # 設定可能な値: クラスターリソースID
  #   # 注意: 削除されたクラスターで保持された自動バックアップから復元する場合に使用
  #   source_cluster_resource_id = null
  #
  #   # restore_type (Optional)
  #   # 設定内容: 実行する復元のタイプを指定します。
  #   # 設定可能な値:
  #   #   - "full-copy" (デフォルト): 完全コピー
  #   #   - "copy-on-write": コピーオンライト
  #   # 省略時: "full-copy"
  #   restore_type = "full-copy"
  #
  #   # use_latest_restorable_time (Optional)
  #   # 設定内容: 最新の復元可能なバックアップ時刻に復元するかを指定します。
  #   # 設定可能な値:
  #   #   - true: 最新の復元可能な時刻に復元
  #   #   - false (デフォルト): restore_to_timeで指定した時刻に復元
  #   # 注意: restore_to_timeと排他的
  #   use_latest_restorable_time = false
  #
  #   # restore_to_time (Optional)
  #   # 設定内容: データベースクラスターを復元する日時をUTC形式で指定します。
  #   # 設定可能な値: RFC3339形式の日時文字列（例: "2023-01-01T12:00:00Z"）
  #   # 注意: use_latest_restorable_timeと排他的
  #   restore_to_time = "2023-01-01T12:00:00Z"
  # }

  #-------------------------------------------------------------
  # ネストブロック: s3_import
  #-------------------------------------------------------------
  # S3からのデータインポート設定
  # S3バケットに保存されたバックアップからクラスターを初期化します。
  # 注意: Auroraエンジンでのみ動作します。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Migrating.ExtMySQL.html#AuroraMySQL.Migrating.ExtMySQL.S3

  # s3_import {
  #   # bucket_name (Required)
  #   # 設定内容: バックアップが保存されているS3バケット名を指定します。
  #   # 設定可能な値: 既存のS3バケット名
  #   bucket_name = "my-backup-bucket"
  #
  #   # bucket_prefix (Optional)
  #   # 設定内容: バックアップへのS3パスを指定します。
  #   # 設定可能な値: S3オブジェクトキープレフィックス
  #   # 省略時: バケットのルートが使用されます
  #   bucket_prefix = "backups/mysql/"
  #
  #   # ingestion_role (Required)
  #   # 設定内容: データをロードするために適用されるIAMロールARNを指定します。
  #   # 設定可能な値: IAMロールARN
  #   ingestion_role = "arn:aws:iam::123456789012:role/S3ImportRole"
  #
  #   # source_engine (Required)
  #   # 設定内容: バックアップのソースエンジンを指定します。
  #   # 設定可能な値: "mysql"
  #   source_engine = "mysql"
  #
  #   # source_engine_version (Required)
  #   # 設定内容: バックアップの作成に使用されたソースエンジンバージョンを指定します。
  #   # 設定可能な値: MySQLのバージョン文字列（例: "5.7.44"）
  #   source_engine_version = "5.7.44"
  # }

  #-------------------------------------------------------------
  # ネストブロック: scaling_configuration
  #-------------------------------------------------------------
  # Aurora Serverless v1スケーリング設定
  # engine_modeが"serverless"の場合のみ有効です。
  # 注意: Aurora Serverless v1は2025年3月31日にサポート終了予定です。v2への移行を推奨します。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.html

  # scaling_configuration {
  #   # auto_pause (Optional)
  #   # 設定内容: 自動ポーズを有効化するかを指定します。
  #   # 設定可能な値:
  #   #   - true (デフォルト): 自動ポーズを有効化
  #   #   - false: 自動ポーズを無効化
  #   # 省略時: true
  #   # 注意: アイドル状態（接続なし）の場合のみポーズ可能。7日以上ポーズするとスナップショットバックアップされる場合があります
  #   auto_pause = true
  #
  #   # max_capacity (Optional)
  #   # 設定内容: serverlessエンジンモードでのAurora DBクラスターの最大キャパシティを指定します。
  #   # 設定可能な値:
  #   #   - Aurora MySQL: 1, 2, 4, 8, 16, 32, 64, 128, 256
  #   #   - Aurora PostgreSQL: 2, 4, 8, 16, 32, 64, 192, 384
  #   # 省略時: 16
  #   max_capacity = 16
  #
  #   # min_capacity (Optional)
  #   # 設定内容: serverlessエンジンモードでのAurora DBクラスターの最小キャパシティを指定します。
  #   # 設定可能な値:
  #   #   - Aurora MySQL: 1, 2, 4, 8, 16, 32, 64, 128, 256
  #   #   - Aurora PostgreSQL: 2, 4, 8, 16, 32, 64, 192, 384
  #   # 省略時: 1
  #   min_capacity = 1
  #
  #   # seconds_before_timeout (Optional)
  #   # 設定内容: Aurora Serverless v1がタイムアウトアクションを実行する前にシームレスなスケーリングポイントを見つけようとする時間（秒）を指定します。
  #   # 設定可能な値: 60〜600の整数
  #   # 省略時: 300
  #   seconds_before_timeout = 300
  #
  #   # seconds_until_auto_pause (Optional)
  #   # 設定内容: serverlessモードのAurora DBクラスターがポーズされるまでの時間（秒）を指定します。
  #   # 設定可能な値: 300〜86400の整数
  #   # 省略時: 300
  #   seconds_until_auto_pause = 300
  #
  #   # timeout_action (Optional)
  #   # 設定内容: タイムアウト到達時に実行するアクションを指定します。
  #   # 設定可能な値:
  #   #   - "ForceApplyCapacityChange": キャパシティ変更を強制適用
  #   #   - "RollbackCapacityChange" (デフォルト): キャパシティ変更をロールバック
  #   # 省略時: "RollbackCapacityChange"
  #   # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v1.how-it-works.html#aurora-serverless.how-it-works.timeout-action
  #   timeout_action = "RollbackCapacityChange"
  # }

  #-------------------------------------------------------------
  # ネストブロック: serverlessv2_scaling_configuration
  #-------------------------------------------------------------
  # Aurora Serverless v2スケーリング設定
  # provisionedエンジンモードでのAurora Serverless v2の自動スケーリングを設定します。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html

  serverlessv2_scaling_configuration {
    # max_capacity (Required)
    # 設定内容: provisionedエンジンモードでのAurora DBクラスターの最大キャパシティを指定します。
    # 設定可能な値: 0〜256の範囲で0.5刻みの数値
    # 注意: min_capacity以上である必要があります
    max_capacity = 1.0

    # min_capacity (Required)
    # 設定内容: provisionedエンジンモードでのAurora DBクラスターの最小キャパシティを指定します。
    # 設定可能な値: 0〜256の範囲で0.5刻みの数値
    # 注意: max_capacity以下である必要があります
    min_capacity = 0.5

    # seconds_until_auto_pause (Optional)
    # 設定内容: provisionedエンジンモードのAurora DBクラスターがポーズされるまでの時間（秒）を指定します。
    # 設定可能な値: 300〜86400の整数
    # 省略時: 設定されません（自動ポーズなし）
    seconds_until_auto_pause = null
  }

  #-------------------------------------------------------------
  # ネストブロック: timeouts
  #-------------------------------------------------------------
  # Terraformのリソース操作タイムアウト設定

  # timeouts {
  #   # create (Optional)
  #   # 設定内容: クラスター作成のタイムアウト時間を指定します。
  #   # 設定可能な値: Go duration文字列（例: "120m", "2h"）
  #   # 省略時: デフォルトのタイムアウト値が使用されます
  #   create = "120m"
  #
  #   # update (Optional)
  #   # 設定内容: クラスター更新のタイムアウト時間を指定します。
  #   # 設定可能な値: Go duration文字列（例: "120m", "2h"）
  #   # 省略時: デフォルトのタイムアウト値が使用されます
  #   update = "120m"
  #
  #   # delete (Optional)
  #   # 設定内容: クラスター削除のタイムアウト時間を指定します。
  #   # 設定可能な値: Go duration文字列（例: "120m", "2h"）
  #   # 省略時: デフォルトのタイムアウト値が使用されます
  #   delete = "120m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: クラスターのAmazon Resource Name (ARN)
#
# - id: RDSクラスター識別子
#
# - cluster_identifier: RDSクラスター識別子
#
# - cluster_resource_id: RDSクラスターリソースID
#
# - cluster_members: このクラスターの一部であるRDSインスタンスのリスト
#
# - availability_zones: インスタンスのアベイラビリティゾーン
#
# - ca_certificate_valid_till: DBインスタンスのサーバー証明書の有効期限
#
# - endpoint: RDSインスタンスのDNSアドレス
#
# - reader_endpoint: Auroraクラスターの読み取り専用エンドポイント。
#                    レプリカ間で自動的に負荷分散されます
#
# - engine_version_actual: 実行中のデータベースのバージョン
#---------------------------------------------------------------
