#---------------------------------------------------------------
# AWS RDS DB Instance
#---------------------------------------------------------------
#
# Amazon RDS の DB インスタンスをプロビジョニングするリソースです。
# DB インスタンスはクラウド内の分離されたデータベース環境であり、
# 複数のユーザー作成データベースを含むことができます。
#
# DB インスタンスへの変更は、allocated_storage などのパラメータを手動で変更した場合に発生し、
# 次のメンテナンスウィンドウで反映されます。apply_immediately フラグを使用すると
# 変更を即座に適用できます（ただし、サーバーの再起動により短時間のダウンタイムが発生する可能性があります）。
#
# AWS公式ドキュメント:
#   - RDS ユーザーガイド: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html
#   - RDS API リファレンス: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_db_instance" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # instance_class (Required)
  # 設定内容: RDS インスタンスのインスタンスタイプを指定します。
  # 設定可能な値: 有効な RDS インスタンスクラス（例: db.t3.micro, db.r5.large）
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
  instance_class = "db.t3.micro"

  #-------------------------------------------------------------
  # 識別子設定
  #-------------------------------------------------------------

  # identifier (Optional)
  # 設定内容: RDS インスタンスの名前を指定します。
  # 省略時: Terraform がランダムな一意の識別子を割り当てます。
  # 注意: restore_to_point_in_time を指定する場合は必須。
  #       identifier_prefix と排他的。
  identifier = "my-db-instance"

  # identifier_prefix (Optional)
  # 設定内容: 識別子のプレフィックスを指定します。
  # 省略時: Terraform が一意のプレフィックスを自動生成します。
  # 注意: identifier と排他的
  identifier_prefix = null

  #-------------------------------------------------------------
  # エンジン設定
  #-------------------------------------------------------------

  # engine (Required unless snapshot_identifier or replicate_source_db is provided)
  # 設定内容: 使用するデータベースエンジンを指定します。
  # 設定可能な値: mysql, postgres, mariadb, oracle-ee, oracle-se2, sqlserver-ee,
  #               sqlserver-se, sqlserver-ex, sqlserver-web, aurora, aurora-mysql,
  #               aurora-postgresql, custom-oracle-ee, custom-sqlserver-ee,
  #               custom-sqlserver-se, custom-sqlserver-web, db2-se, db2-ae など
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
  engine = "mysql"

  # engine_version (Optional)
  # 設定内容: 使用するエンジンのバージョンを指定します。
  # auto_minor_version_upgrade が有効な場合、バージョンのプレフィックス（例: 8.0）を指定できます。
  # 実際に使用されるバージョンは engine_version_actual 属性で確認できます。
  engine_version = "8.0"

  # engine_lifecycle_support (Optional)
  # 設定内容: この DB インスタンスのライフサイクルタイプを指定します。
  # 設定可能な値:
  #   - "open-source-rds-extended-support" (デフォルト): 拡張サポートを使用
  #   - "open-source-rds-extended-support-disabled": 拡張サポートを無効化
  # 対象: RDS for MySQL および RDS for PostgreSQL のみ
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/extended-support.html
  engine_lifecycle_support = "open-source-rds-extended-support"

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # username (Required unless snapshot_identifier or replicate_source_db is provided)
  # 設定内容: マスター DB ユーザーのユーザー名を指定します。
  # 注意: レプリカでは指定できません。
  username = "admin"

  # password (Optional)
  # 設定内容: マスター DB ユーザーのパスワードを指定します。
  # 注意:
  #   - manage_master_user_password が true の場合、または snapshot_identifier、
  #     replicate_source_db、password_wo が指定されている場合は不要。
  #   - ログやステートファイルに平文で保存される可能性があります。
  password = "your-secure-password"

  # password_wo (Optional, Write-Only)
  # 設定内容: マスター DB ユーザーのパスワードを指定します（Write-Only 版）。
  # 注意:
  #   - Terraform 1.11.0 以降でサポートされる Write-Only 引数です。
  #   - manage_master_user_password が true の場合は使用できません。
  # 参考: https://developer.hashicorp.com/terraform/language/resources/ephemeral#write-only-arguments
  password_wo = null

  # password_wo_version (Optional)
  # 設定内容: password_wo の更新をトリガーするために使用します。
  # password_wo の更新が必要な場合、この値をインクリメントします。
  password_wo_version = null

  # manage_master_user_password (Optional)
  # 設定内容: RDS が Secrets Manager でマスターユーザーパスワードを管理するかを指定します。
  # 設定可能な値:
  #   - true: Secrets Manager でパスワードを管理
  #   - false: 手動でパスワードを管理
  # 注意: password または password_wo が設定されている場合は使用できません。
  manage_master_user_password = false

  # master_user_secret_kms_key_id (Optional)
  # 設定内容: Secrets Manager でマスターユーザーシークレットを暗号化するための KMS キー ID を指定します。
  # 設定可能な値: KMS キー ARN、キー ID、エイリアス ARN、またはエイリアス名
  # 省略時: AWS アカウントのデフォルト KMS キーを使用
  master_user_secret_kms_key_id = null

  # iam_database_authentication_enabled (Optional)
  # 設定内容: AWS IAM アカウントとデータベースアカウントのマッピングを有効にするかを指定します。
  # 設定可能な値: true または false
  iam_database_authentication_enabled = false

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # allocated_storage (Required unless snapshot_identifier or replicate_source_db is provided)
  # 設定内容: 割り当てるストレージ容量（GiB）を指定します。
  # max_allocated_storage が設定されている場合、この値は初期ストレージ割り当てを表し、
  # Storage Autoscaling による変更は自動的に無視されます。
  # 注意: replicate_source_db が設定されている場合、作成時はこの値は無視されます。
  allocated_storage = 20

  # max_allocated_storage (Optional)
  # 設定内容: Amazon RDS が自動スケーリングできる最大ストレージ（GiB）を指定します。
  # Storage Autoscaling を有効にするには、allocated_storage 以上の値を設定します。
  # 設定可能な値: 0（無効）または allocated_storage 以上の値
  # 省略時: Storage Autoscaling は無効
  max_allocated_storage = 100

  # storage_type (Optional)
  # 設定内容: ストレージのタイプを指定します。
  # 設定可能な値:
  #   - "standard": マグネティック
  #   - "gp2": 汎用 SSD
  #   - "gp3": 汎用 SSD（IOPS を独立して設定可能）
  #   - "io1": プロビジョンド IOPS SSD
  #   - "io2": プロビジョンド IOPS SSD（Block Express ストレージ）
  # 省略時: iops が指定されていれば "io1"、そうでなければ "gp2"
  storage_type = "gp2"

  # iops (Optional)
  # 設定内容: プロビジョンド IOPS の量を指定します。
  # この設定は storage_type が "io1"、"io2"、または "gp3" の場合にのみ有効です。
  # 注意: gp3 の場合、allocated_storage がエンジンごとのしきい値を下回ると指定できません。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html#gp3-storage
  iops = null

  # storage_throughput (Optional)
  # 設定内容: DB インスタンスのストレージスループット値を指定します。
  # storage_type が "gp3" の場合のみ設定可能です。
  # 注意: allocated_storage がエンジンごとのしきい値を下回ると指定できません。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html#gp3-storage
  storage_throughput = null

  # storage_encrypted (Optional)
  # 設定内容: DB インスタンスを暗号化するかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  # 注意: クロスリージョンリードレプリカを作成する場合、この設定は無視され、
  #       代わりに kms_key_id に有効な ARN を指定する必要があります。
  storage_encrypted = true

  # dedicated_log_volume (Optional)
  # 設定内容: DB インスタンスに専用ログボリューム（DLV）を使用するかを指定します。
  # 設定可能な値: true または false
  # 注意: プロビジョンド IOPS が必要です。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIOPS.StorageTypes.html#USER_PIOPS.dlv
  dedicated_log_volume = false

  # upgrade_storage_config (Optional)
  # 設定内容: リードレプリカのストレージファイルシステム設定をアップグレードするかを指定します。
  # replicate_source_db と共にのみ設定可能です。
  upgrade_storage_config = null

  #-------------------------------------------------------------
  # データベース設定
  #-------------------------------------------------------------

  # db_name (Optional)
  # 設定内容: DB インスタンス作成時に作成するデータベースの名前を指定します。
  # 注意:
  #   - パラメータを指定しない場合、DB インスタンスにデータベースは作成されません。
  #   - Oracle や SQL Server エンジンには適用されません。
  #   - Oracle の場合、db_name は全て大文字である必要があります。
  #   - レプリカでは指定できません。
  db_name = "mydb"

  # character_set_name (Optional)
  # 設定内容: Oracle および Microsoft SQL インスタンスのデータベースエンコーディングに使用する
  #           文字セット名（照合順序）を指定します。
  # 注意: 変更できません。replicate_source_db、restore_to_point_in_time、
  #       s3_import、snapshot_identifier と共には設定できません。
  # 参考:
  #   - Oracle: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.OracleCharacterSets.html
  #   - SQL Server: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.SQLServer.CommonDBATasks.Collation.html
  character_set_name = null

  # nchar_character_set_name (Optional, Forces new resource)
  # 設定内容: Oracle インスタンスの NCHAR、NVARCHAR2、NCLOB データ型で使用する
  #           国際文字セットを指定します。
  # 注意: 変更できません。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.OracleCharacterSets.html
  nchar_character_set_name = null

  # timezone (Optional)
  # 設定内容: DB インスタンスのタイムゾーンを指定します。
  # 注意:
  #   - 現在は Microsoft SQL Server でのみサポートされています。
  #   - タイムゾーンは作成時にのみ設定できます。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_SQLServer.html#SQLServer.Concepts.General.TimeZone
  timezone = null

  # license_model (Optional)
  # 設定内容: この DB インスタンスのライセンスモデル情報を指定します。
  # 設定可能な値:
  #   - RDS for MariaDB: general-public-license
  #   - RDS for Microsoft SQL Server: license-included
  #   - RDS for MySQL: general-public-license
  #   - RDS for Oracle: bring-your-own-license | license-included
  #   - RDS for PostgreSQL: postgresql-license
  license_model = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # db_subnet_group_name (Optional)
  # 設定内容: DB サブネットグループの名前を指定します。
  # DB インスタンスは DB サブネットグループに関連付けられた VPC に作成されます。
  # 省略時: default サブネットグループに作成されます。
  # 注意:
  #   - 同一リージョンのリードレプリカでは、デフォルトでソース DB のサブネットグループ名を使用。
  #   - 異なるリージョンのリードレプリカでは、デフォルトで default サブネットグループを使用。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstanceReadReplica.html
  db_subnet_group_name = "my-db-subnet-group"

  # vpc_security_group_ids (Optional)
  # 設定内容: 関連付ける VPC セキュリティグループ ID のリストを指定します。
  vpc_security_group_ids = ["sg-xxxxxxxxxxxxxxxxx"]

  # availability_zone (Optional)
  # 設定内容: RDS インスタンスのアベイラビリティーゾーンを指定します。
  availability_zone = null

  # multi_az (Optional)
  # 設定内容: RDS インスタンスをマルチ AZ 構成にするかを指定します。
  # 設定可能な値: true または false
  multi_az = false

  # publicly_accessible (Optional)
  # 設定内容: インスタンスをパブリックアクセス可能にするかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  publicly_accessible = false

  # port (Optional)
  # 設定内容: DB が接続を受け付けるポートを指定します。
  # 省略時: エンジンごとのデフォルトポート（MySQL: 3306、PostgreSQL: 5432 など）
  port = null

  # network_type (Optional)
  # 設定内容: DB インスタンスのネットワークタイプを指定します。
  # 設定可能な値:
  #   - "IPV4": IPv4 のみ
  #   - "DUAL": IPv4 と IPv6 の両方
  network_type = "IPV4"

  # customer_owned_ip_enabled (Optional)
  # 設定内容: RDS on Outposts DB インスタンスでカスタマー所有 IP アドレス（CoIP）を
  #           有効にするかを指定します。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-on-outposts.html#rds-on-outposts.coip
  customer_owned_ip_enabled = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # バックアップ設定
  #-------------------------------------------------------------

  # backup_retention_period (Optional)
  # 設定内容: バックアップを保持する日数を指定します。
  # 設定可能な値: 0〜35
  # 省略時: 0
  # 注意:
  #   - リードレプリカのソースとして使用する場合、0 より大きい値が必要です。
  #   - ローダウンタイム更新を使用する場合、0 より大きい値が必要です。
  #   - RDS Blue/Green デプロイメントを使用する場合、0 より大きい値が必要です。
  backup_retention_period = 7

  # backup_window (Optional)
  # 設定内容: 自動バックアップが作成される毎日の時間範囲（UTC）を指定します。
  # 形式: "HH:MM-HH:MM"（例: "09:46-10:16"）
  # 注意: maintenance_window と重複してはいけません。
  backup_window = "03:00-04:00"

  # backup_target (Optional, Forces new resource)
  # 設定内容: 自動バックアップと手動スナップショットの保存場所を指定します。
  # 設定可能な値:
  #   - "region" (デフォルト): リージョン内
  #   - "outposts": Outposts 上
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-on-outposts.html
  backup_target = "region"

  # delete_automated_backups (Optional)
  # 設定内容: DB インスタンス削除後に自動バックアップを即座に削除するかを指定します。
  # 設定可能な値: true（デフォルト）または false
  delete_automated_backups = true

  # skip_final_snapshot (Optional)
  # 設定内容: DB インスタンス削除前に最終 DB スナップショットを作成するかを指定します。
  # 設定可能な値:
  #   - true: 最終スナップショットを作成しない
  #   - false (デフォルト): 最終スナップショットを作成
  # 注意: false の場合、final_snapshot_identifier を指定する必要があります。
  skip_final_snapshot = false

  # final_snapshot_identifier (Optional)
  # 設定内容: DB インスタンス削除時に作成する最終 DB スナップショットの名前を指定します。
  # skip_final_snapshot が false の場合は必須です。
  # 設定可能な値: 文字で始まり、英数字とハイフンのみを含み、ハイフンで終わらず、
  #               連続するハイフンを含まない文字列
  # 注意: リードレプリカを削除する場合は指定してはいけません。
  final_snapshot_identifier = "my-db-final-snapshot"

  # snapshot_identifier (Optional)
  # 設定内容: スナップショットからデータベースを作成するかを指定します。
  # RDS コンソールで確認できるスナップショット ID に対応します（例: rds:production-2015-06-26-06-05）。
  snapshot_identifier = null

  #-------------------------------------------------------------
  # メンテナンス設定
  #-------------------------------------------------------------

  # maintenance_window (Optional)
  # 設定内容: メンテナンスを実行するウィンドウを指定します。
  # 形式: "ddd:hh24:mi-ddd:hh24:mi"（例: "Mon:00:00-Mon:03:00"）
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.Maintenance.html#AdjustingTheMaintenanceWindow
  maintenance_window = "Sun:05:00-Sun:06:00"

  # auto_minor_version_upgrade (Optional)
  # 設定内容: メンテナンスウィンドウ中にマイナーエンジンのアップグレードを
  #           自動的に適用するかを指定します。
  # 設定可能な値: true（デフォルト）または false
  auto_minor_version_upgrade = true

  # allow_major_version_upgrade (Optional)
  # 設定内容: メジャーバージョンアップグレードを許可するかを指定します。
  # このパラメータの変更はアウテージを引き起こさず、できるだけ早く非同期的に適用されます。
  # 注意: エンジンのメジャーバージョンをアップグレードする場合は true に設定する必要があります。
  allow_major_version_upgrade = false

  # apply_immediately (Optional)
  # 設定内容: データベースの変更を即座に適用するか、次のメンテナンスウィンドウで適用するかを指定します。
  # 設定可能な値:
  #   - true: 即座に適用（短時間のダウンタイムが発生する可能性があります）
  #   - false (デフォルト): 次のメンテナンスウィンドウで適用
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.DBInstance.Modifying.html
  apply_immediately = false

  # ca_cert_identifier (Optional)
  # 設定内容: DB インスタンスの CA 証明書の識別子を指定します。
  ca_cert_identifier = null

  #-------------------------------------------------------------
  # 削除保護設定
  #-------------------------------------------------------------

  # deletion_protection (Optional)
  # 設定内容: DB インスタンスの削除保護を有効にするかを指定します。
  # この値が true の場合、データベースは削除できません。
  # 設定可能な値: true または false（デフォルト）
  deletion_protection = false

  #-------------------------------------------------------------
  # 監視設定
  #-------------------------------------------------------------

  # monitoring_interval (Optional)
  # 設定内容: 拡張モニタリングメトリクスを収集する間隔（秒）を指定します。
  # 設定可能な値: 0（無効）、1、5、10、15、30、60
  # 省略時: 0
  monitoring_interval = 0

  # monitoring_role_arn (Optional)
  # 設定内容: RDS が拡張モニタリングメトリクスを CloudWatch Logs に送信するための
  #           IAM ロールの ARN を指定します。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Monitoring.html
  monitoring_role_arn = null

  # enabled_cloudwatch_logs_exports (Optional)
  # 設定内容: CloudWatch Logs へエクスポートするログタイプのセットを指定します。
  # 省略時: ログはエクスポートされません。
  # 設定可能な値（エンジンによって異なります）:
  #   - MySQL: audit, error, general, slowquery
  #   - PostgreSQL: postgresql, upgrade
  #   - SQL Server: agent, error
  #   - Oracle: alert, audit, listener, trace, oemagent
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
  enabled_cloudwatch_logs_exports = []

  # database_insights_mode (Optional)
  # 設定内容: インスタンスで有効にする Database Insights のモードを指定します。
  # 設定可能な値:
  #   - "standard": 標準モード
  #   - "advanced": アドバンスドモード
  database_insights_mode = null

  #-------------------------------------------------------------
  # Performance Insights 設定
  #-------------------------------------------------------------

  # performance_insights_enabled (Optional)
  # 設定内容: Performance Insights を有効にするかを指定します。
  # 設定可能な値: true または false（デフォルト）
  performance_insights_enabled = false

  # performance_insights_kms_key_id (Optional)
  # 設定内容: Performance Insights データを暗号化するための KMS キーの ARN を指定します。
  # 注意: performance_insights_enabled が true の場合に使用します。
  #       一度設定すると変更できません。
  performance_insights_kms_key_id = null

  # performance_insights_retention_period (Optional)
  # 設定内容: Performance Insights データを保持する期間（日数）を指定します。
  # 設定可能な値: 7、731（2年）、または 31 の倍数
  # 省略時: 7
  # 注意: performance_insights_enabled が true の場合に使用します。
  performance_insights_retention_period = 7

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: KMS 暗号化キーの ARN を指定します。
  # 暗号化されたレプリカを作成する場合は、宛先 KMS ARN を設定します。
  kms_key_id = null

  #-------------------------------------------------------------
  # パラメータグループ・オプショングループ設定
  #-------------------------------------------------------------

  # parameter_group_name (Optional)
  # 設定内容: 関連付ける DB パラメータグループの名前を指定します。
  parameter_group_name = "default.mysql8.0"

  # option_group_name (Optional)
  # 設定内容: 関連付ける DB オプショングループの名前を指定します。
  option_group_name = null

  #-------------------------------------------------------------
  # レプリケーション設定
  #-------------------------------------------------------------

  # replicate_source_db (Optional)
  # 設定内容: このリソースがレプリカデータベースであり、この値をソースデータベースとして
  #           使用することを指定します。
  # 設定可能な値:
  #   - 同一リージョンでレプリケートする場合: ソース DB の identifier（db_subnet_group_name も
  #     指定する場合は arn）
  #   - 異なるリージョンでレプリケートする場合: ソース DB の arn
  # 注意: クロスリージョンの暗号化データベースのレプリカを作成する場合は kms_key_id の指定も必要です。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html
  replicate_source_db = null

  # replica_mode (Optional)
  # 設定内容: レプリカが mounted モードか open-read-only モードかを指定します。
  # 設定可能な値:
  #   - "mounted": マウントモード
  #   - "open-read-only": オープンリードオンリーモード（Oracle のデフォルト）
  # 対象: Oracle インスタンスのみ
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/oracle-read-replicas.html
  replica_mode = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  # 一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-db-instance"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されたタグを含む全タグのマップです。
  # 注意: 通常は明示的に設定せず、Terraform が自動計算します。
  # tags_all = {}

  # copy_tags_to_snapshot (Optional)
  # 設定内容: インスタンスのすべてのタグをスナップショットにコピーするかを指定します。
  # 設定可能な値: true または false（デフォルト）
  copy_tags_to_snapshot = true

  #-------------------------------------------------------------
  # Active Directory 設定
  #-------------------------------------------------------------

  # domain (Optional)
  # 設定内容: インスタンスを作成する Directory Service Active Directory ドメインの ID を指定します。
  # 注意: domain_fqdn、domain_ou、domain_auth_secret_arn、domain_dns_ips と競合します。
  domain = null

  # domain_iam_role_name (Optional)
  # 設定内容: Directory Service への API 呼び出し時に使用する IAM ロールの名前を指定します。
  # 注意: domain が指定されている場合は必須です。
  #       domain_fqdn、domain_ou、domain_auth_secret_arn、domain_dns_ips と競合します。
  domain_iam_role_name = null

  # domain_fqdn (Optional)
  # 設定内容: 自己管理 Active Directory ドメインの完全修飾ドメイン名（FQDN）を指定します。
  # 注意: domain および domain_iam_role_name と競合します。
  domain_fqdn = null

  # domain_ou (Optional)
  # 設定内容: DB インスタンスが参加する自己管理 Active Directory の組織単位を指定します。
  # 注意: domain_fqdn が指定されている場合は必須です。
  #       domain および domain_iam_role_name と競合します。
  domain_ou = null

  # domain_auth_secret_arn (Optional)
  # 設定内容: ドメインに参加するユーザーの自己管理 Active Directory 認証情報を含む
  #           Secrets Manager シークレットの ARN を指定します。
  # 注意: domain_fqdn が指定されている場合は必須です。
  #       domain および domain_iam_role_name と競合します。
  domain_auth_secret_arn = null

  # domain_dns_ips (Optional)
  # 設定内容: プライマリおよびセカンダリの自己管理 Active Directory ドメインコントローラーの
  #           IPv4 DNS IP アドレスを指定します。
  # 設定可能な値: 2 つの IP アドレスのリスト。セカンダリがない場合はプライマリの IP を両方に使用。
  # 注意: domain_fqdn が指定されている場合は必須です。
  #       domain および domain_iam_role_name と競合します。
  domain_dns_ips = null

  #-------------------------------------------------------------
  # RDS Custom 設定
  #-------------------------------------------------------------

  # custom_iam_instance_profile (Optional)
  # 設定内容: RDS Custom DB インスタンスの基盤となる Amazon EC2 インスタンスに
  #           関連付けるインスタンスプロファイルを指定します。
  # 参考:
  #   - Oracle: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-setup-orcl.html#custom-setup-orcl.iam-vpc
  #   - SQL Server: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-setup-sqlserver.html#custom-setup-sqlserver.iam
  custom_iam_instance_profile = null

  #-------------------------------------------------------------
  # Blue/Green Update 設定
  #-------------------------------------------------------------

  # blue_green_update (Optional)
  # 設定内容: RDS Blue/Green デプロイメントを使用したローダウンタイム更新を有効にします。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/blue-green-deployments.html
  blue_green_update {
    # enabled (Optional)
    # 設定内容: ローダウンタイム更新を有効にするかを指定します。
    # 設定可能な値: true または false（デフォルト）
    enabled = false
  }

  #-------------------------------------------------------------
  # ポイントインタイムリストア設定
  #-------------------------------------------------------------

  # restore_to_point_in_time (Optional, Forces new resource)
  # 設定内容: DB インスタンスを任意の時点にリストアするための設定ブロックです。
  # identifier 引数に新しい DB インスタンスの名前を設定する必要があります。
  # restore_to_point_in_time {
  #   # restore_time (Optional)
  #   # 設定内容: リストア先の日時を指定します。
  #   # 形式: UTC 形式の値で、DB インスタンスの最新のリストア可能時刻より前である必要があります。
  #   # 注意: use_latest_restorable_time と同時に指定できません。
  #   restore_time = null
  #
  #   # source_db_instance_identifier (Optional)
  #   # 設定内容: リストア元の DB インスタンスの識別子を指定します。
  #   # 既存の DB インスタンスの識別子と一致する必要があります。
  #   # 注意: source_db_instance_automated_backups_arn または source_dbi_resource_id が
  #   #       指定されていない場合は必須です。
  #   source_db_instance_identifier = null
  #
  #   # source_db_instance_automated_backups_arn (Optional)
  #   # 設定内容: リストア元の自動バックアップの ARN を指定します。
  #   # 注意: source_db_instance_identifier または source_dbi_resource_id が
  #   #       指定されていない場合は必須です。
  #   source_db_instance_automated_backups_arn = null
  #
  #   # source_dbi_resource_id (Optional)
  #   # 設定内容: リストア元の DB インスタンスのリソース ID を指定します。
  #   # 注意: source_db_instance_identifier または source_db_instance_automated_backups_arn が
  #   #       指定されていない場合は必須です。
  #   source_dbi_resource_id = null
  #
  #   # use_latest_restorable_time (Optional)
  #   # 設定内容: DB インスタンスを最新のバックアップ時刻からリストアするかを指定します。
  #   # 設定可能な値: true または false（デフォルト）
  #   # 注意: restore_time と同時に指定できません。
  #   use_latest_restorable_time = false
  # }

  #-------------------------------------------------------------
  # S3 インポート設定
  #-------------------------------------------------------------

  # s3_import (Optional)
  # 設定内容: S3 の Percona Xtrabackup からリストアするための設定です。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Procedural.Importing.html
  # s3_import {
  #   # bucket_name (Required)
  #   # 設定内容: バックアップが保存されているバケット名を指定します。
  #   bucket_name = "my-backup-bucket"
  #
  #   # bucket_prefix (Optional)
  #   # 設定内容: バックアップへのパスを指定します。空白も可能です。
  #   bucket_prefix = ""
  #
  #   # ingestion_role (Required)
  #   # 設定内容: データをロードするために適用されるロールを指定します。
  #   ingestion_role = "arn:aws:iam::123456789012:role/rds-s3-import-role"
  #
  #   # source_engine (Required)
  #   # 設定内容: バックアップのソースエンジンを指定します。
  #   # 2018年2月時点では 'mysql' のみサポート
  #   source_engine = "mysql"
  #
  #   # source_engine_version (Required)
  #   # 設定内容: バックアップの作成に使用されたソースエンジンのバージョンを指定します。
  #   # 2018年2月時点では '5.6' のみサポート
  #   source_engine_version = "5.6"
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 省略時: 40分
    create = "40m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウトを指定します。
    # 省略時: 80分
    update = "80m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 省略時: 60分
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - address: RDS インスタンスのホスト名。endpoint と port も参照してください。
#
# - arn: RDS インスタンスの Amazon Resource Name (ARN)
#
# - endpoint: "address:port" 形式の接続エンドポイント
#
# - engine_version_actual: 実行中のデータベースのバージョン
#
# - hosted_zone_id: DB インスタンスの正規ホストゾーン ID
#                   （Route 53 エイリアスレコードで使用）
#
# - id: RDS DBI リソース ID
#
# - latest_restorable_time: ポイントインタイムリストアで DB をリストアできる
#                           最新時刻（UTC RFC3339 形式）
#
# - listener_endpoint: SQL Server Always On のリスナー接続エンドポイント
#   - address: リスナーの DNS アドレス
#   - hosted_zone_id: ホストゾーン ID
#   - port: リスナーのポート
#---------------------------------------------------------------
