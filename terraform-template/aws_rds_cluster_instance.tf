#---------------------------------------------------------------
# AWS RDS Cluster Instance
#---------------------------------------------------------------
#
# RDS クラスターインスタンスを定義するリソースです。
# Amazon Aurora クラスター内の個々のインスタンスを管理します。
#
# クラスターインスタンスリソースは、RDS クラスター内の単一のインスタンスに
# 固有の属性を定義します。特にAmazon Auroraを実行する場合に使用されます。
#
# 他のレプリケーションをサポートするRDSリソースと異なり、Amazon Auroraでは
# プライマリと後続のレプリカを明示的に指定せず、単にRDSインスタンスを追加すると
# Auroraがレプリケーションを管理します。
#
# AWS公式ドキュメント:
#   - Amazon Aurora の概要: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_AuroraOverview.html
#   - Aurora クラスターの作成: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.CreateInstance.html
#   - DB インスタンスクラス: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_cluster_instance" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # cluster_identifier (Required, Forces new resource)
  # 設定内容: このインスタンスを起動するRDSクラスターのIDを指定します。
  # 設定可能な値: 有効な aws_rds_cluster リソースのID
  # 用途: インスタンスが所属するクラスターを特定するために必須
  # 注意: 変更すると新しいリソースが作成されます
  # 関連機能: RDS Cluster
  #   Aurora クラスターの識別子。このクラスター内にインスタンスが作成されます。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.CreateInstance.html
  cluster_identifier = "aurora-cluster-demo"

  # engine (Required, Forces new resource)
  # 設定内容: RDSクラスターインスタンスに使用するデータベースエンジンの名前を指定します。
  # 設定可能な値:
  #   - "aurora-mysql": Aurora MySQL互換エンジン
  #   - "aurora-postgresql": Aurora PostgreSQL互換エンジン
  #   - "mysql": マルチAZ RDS クラスター用のMySQL
  #   - "postgres": マルチAZ RDS クラスター用のPostgreSQL
  # 注意:
  #   - "aurora" は Amazon Aurora MySQL-Compatible Edition v1 の終了により無効
  #   - 変更すると新しいリソースが作成されます
  # 関連機能: RDS Engine Type
  #   使用するデータベースエンジンを定義。通常はクラスターのエンジンと一致させる必要があります。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_AuroraOverview.html
  engine = "aurora-mysql"

  # instance_class (Required)
  # 設定内容: 使用するインスタンスクラスを指定します。
  # 設定可能な値:
  #   - Aurora Serverless v2: "db.serverless"
  #   - Aurora プロビジョンド: "db.t4g.medium", "db.r5.large", "db.r6g.xlarge" など
  # 用途: CPUとメモリのリソース割り当てを決定
  # 参考:
  #   - Aurora DBインスタンスのスケーリング: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Managing.Performance.html
  #   - 利用可能なインスタンスクラス: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html
  instance_class = "db.r5.large"

  #-------------------------------------------------------------
  # インスタンス識別設定
  #-------------------------------------------------------------

  # identifier (Optional, Computed, Forces new resource)
  # 設定内容: RDSインスタンスの識別子を指定します。
  # 設定可能な値: 英数字とハイフンを含む一意の文字列
  # 省略時: Terraformがランダムな一意の識別子を自動的に割り当てます
  # 注意:
  #   - identifier_prefix との競合があります (どちらか一方のみ指定可能)
  #   - 変更すると新しいリソースが作成されます
  identifier = "aurora-cluster-demo-instance-1"

  # identifier_prefix (Optional, Computed, Forces new resource)
  # 設定内容: 指定されたプレフィックスで始まる一意の識別子を作成します。
  # 設定可能な値: 識別子のプレフィックス文字列
  # 用途: 複数のインスタンスを作成する際に一貫した命名規則を適用
  # 注意:
  #   - identifier との競合があります (どちらか一方のみ指定可能)
  #   - 変更すると新しいリソースが作成されます
  identifier_prefix = null

  #-------------------------------------------------------------
  # ネットワーク・配置設定
  #-------------------------------------------------------------

  # availability_zone (Optional, Computed, Forces new resource)
  # 設定内容: DBインスタンスを作成するEC2アベイラビリティーゾーンを指定します。
  # 設定可能な値: 有効なAWSアベイラビリティーゾーン (例: us-west-2a, ap-northeast-1a)
  # 省略時: AWSが自動的にアベイラビリティーゾーンを選択します
  # 注意: 変更すると新しいリソースが作成されます
  # 関連機能: High Availability
  #   複数のAZにインスタンスを分散させることで可用性を向上。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.RegionsAndAvailabilityZones.html
  availability_zone = null

  # db_subnet_group_name (Optional, Computed, Forces new resource)
  # 設定内容: このDBインスタンスに関連付けるDBサブネットグループを指定します。
  # 設定可能な値: 有効なDBサブネットグループ名
  # 注意:
  #   - アタッチされた aws_rds_cluster の db_subnet_group_name と一致する必要があります
  #   - publicly_accessible パラメータと組み合わせてインスタンスの動作に影響
  #   - 変更すると新しいリソースが作成されます
  # 参考: https://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
  db_subnet_group_name = null

  # publicly_accessible (Optional, Computed)
  # 設定内容: インスタンスがパブリックにアクセス可能かどうかを制御します。
  # 設定可能な値: true または false
  # デフォルト: false
  # 用途: インターネットからのアクセス可否を制御
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html#USER_VPC.Hiding
  publicly_accessible = false

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # エンジン・バージョン設定
  #-------------------------------------------------------------

  # engine_version (Optional, Computed)
  # 設定内容: データベースエンジンのバージョンを指定します。
  # 設定可能な値: 有効なエンジンバージョン文字列 (例: "8.0.mysql_aurora.3.04.0")
  # 重要: インスタンスの engine_version をアップグレードするには、
  #       aws_rds_cluster の engine_version で実行する必要があります。
  #       aws_cluster_instance でアップグレードしても engine_version は更新されません。
  # 関連機能: Engine Version Management
  #   エンジンバージョンはクラスターレベルで管理されます。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Updates.html
  engine_version = null

  #-------------------------------------------------------------
  # バックアップ・メンテナンス設定
  #-------------------------------------------------------------

  # preferred_backup_window (Optional, Computed)
  # 設定内容: 自動バックアップが有効な場合に作成される日次時間範囲を指定します。
  # 設定可能な値: "hh24:mi-hh24:mi" 形式 (例: "03:00-06:00")
  # 重要: preferred_backup_window がクラスターレベルで設定されている場合、
  #       この引数は省略する必要があります
  # 関連機能: Automated Backups
  #   自動バックアップのタイミングを制御。メンテナンスウィンドウと重複しないよう設定。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Managing.Backups.html
  preferred_backup_window = null

  # preferred_maintenance_window (Optional, Computed)
  # 設定内容: メンテナンスを実行するウィンドウを指定します。
  # 設定可能な値: "ddd:hh24:mi-ddd:hh24:mi" 形式 (例: "Mon:00:00-Mon:03:00")
  # 用途: システムメンテナンスやパッチ適用の時間帯を制御
  # 関連機能: Maintenance Windows
  #   メンテナンス作業の実施時間を業務への影響が少ない時間帯に設定。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_UpgradeDBInstance.Maintenance.html
  preferred_maintenance_window = null

  #-------------------------------------------------------------
  # 自動アップグレード・適用設定
  #-------------------------------------------------------------

  # auto_minor_version_upgrade (Optional)
  # 設定内容: マイナーエンジンアップグレードをメンテナンスウィンドウ中に自動適用するかを指定します。
  # 設定可能な値: true または false
  # デフォルト: true
  # 用途: セキュリティパッチやバグ修正の自動適用を制御
  # 関連機能: Automatic Minor Version Upgrades
  #   セキュリティと安定性の向上のため、通常は有効化を推奨。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_UpgradeDBInstance.Upgrading.html
  auto_minor_version_upgrade = true

  # apply_immediately (Optional, Computed)
  # 設定内容: データベースの変更を即座に適用するか、次のメンテナンスウィンドウで適用するかを指定します。
  # 設定可能な値: true または false
  # デフォルト: false
  # 注意: 即座に適用するとダウンタイムが発生する可能性があります
  # 関連機能: Apply Changes Immediately
  #   変更の適用タイミングを制御。本番環境ではfalseを推奨。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Overview.DBInstance.Modifying.html
  apply_immediately = false

  #-------------------------------------------------------------
  # パラメータグループ設定
  #-------------------------------------------------------------

  # db_parameter_group_name (Optional, Computed)
  # 設定内容: このインスタンスに関連付けるDBパラメータグループの名前を指定します。
  # 設定可能な値: 有効なDBパラメータグループ名
  # 省略時: デフォルトのパラメータグループが使用されます
  # 関連機能: DB Parameter Groups
  #   データベースエンジンの設定をカスタマイズ。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_WorkingWithParamGroups.html
  db_parameter_group_name = null

  #-------------------------------------------------------------
  # モニタリング設定
  #-------------------------------------------------------------

  # monitoring_interval (Optional)
  # 設定内容: 拡張モニタリングメトリクスをDBインスタンスから収集する間隔を秒単位で指定します。
  # 設定可能な値: 0, 1, 5, 10, 15, 30, 60
  # デフォルト: 0 (拡張モニタリングを無効化)
  # 用途: より詳細なパフォーマンスメトリクスの収集
  # 関連機能: Enhanced Monitoring
  #   OSレベルのメトリクスをCloudWatch Logsに送信。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_Monitoring.OS.html
  monitoring_interval = 0

  # monitoring_role_arn (Optional, Computed)
  # 設定内容: RDSが拡張モニタリングメトリクスをCloudWatch Logsに送信するためのIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 必須条件: monitoring_interval が 0 より大きい場合に必要
  # 参考: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Monitoring.html
  monitoring_role_arn = null

  # performance_insights_enabled (Optional, Computed)
  # 設定内容: Performance Insights を有効にするかどうかを指定します。
  # 設定可能な値: true または false
  # 重要: Performance Insights がクラスターレベルで aws_rds_cluster を通じて設定されている場合、
  #       この引数はクラスターの設定と競合する値に設定できません
  # 関連機能: Performance Insights
  #   データベースのパフォーマンス問題を特定し、診断するためのツール。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_PerfInsights.html
  performance_insights_enabled = false

  # performance_insights_kms_key_id (Optional, Computed)
  # 設定内容: Performance Insights データを暗号化するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 必須条件: performance_insights_kms_key_id を指定する場合、
  #           performance_insights_enabled を true に設定する必要があります
  # 関連機能: Performance Insights Encryption
  #   パフォーマンスデータの暗号化保護。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_PerfInsights.Enabling.html
  performance_insights_kms_key_id = null

  # performance_insights_retention_period (Optional, Computed)
  # 設定内容: Performance Insights データを保持する日数を指定します。
  # 設定可能な値:
  #   - 7: 7日間 (デフォルト、無料)
  #   - 731: 2年間
  #   - 31の倍数 (例: 62, 93, 124...)
  # 必須条件: performance_insights_retention_period を指定する場合、
  #           performance_insights_enabled を true に設定する必要があります
  # デフォルト: 7
  performance_insights_retention_period = 7

  #-------------------------------------------------------------
  # 可用性・フェイルオーバー設定
  #-------------------------------------------------------------

  # promotion_tier (Optional)
  # 設定内容: インスタンスレベルでのフェイルオーバー優先度を設定します。
  # 設定可能な値: 0 から 15 までの整数
  # デフォルト: 0
  # 用途: 低い値のリーダーがライターに昇格する際の優先度が高くなります
  # 関連機能: Failover Priority
  #   フェイルオーバー時にどのリーダーをライターに昇格させるかを制御。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Managing.Backups.html
  promotion_tier = 0

  # force_destroy (Optional)
  # 設定内容: リードレプリカクラスターの一部であるインスタンスを強制的に削除します。
  # 設定可能な値: true または false
  # 注意: リードレプリカをスタンドアロンクラスターに昇格させてからインスタンスを削除します
  # 用途: リードレプリカクラスターのインスタンスを削除する際に使用
  force_destroy = false

  #-------------------------------------------------------------
  # セキュリティ・証明書設定
  #-------------------------------------------------------------

  # ca_cert_identifier (Optional, Computed)
  # 設定内容: DBインスタンスのCA証明書の識別子を指定します。
  # 設定可能な値: 有効なCA証明書識別子
  # 用途: SSL/TLS接続時に使用する証明書を指定
  # 関連機能: SSL/TLS Certificates
  #   データベースへの暗号化接続を確立するための証明書。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/UsingWithRDS.SSL.html
  ca_cert_identifier = null

  #-------------------------------------------------------------
  # RDS Custom 設定
  #-------------------------------------------------------------

  # custom_iam_instance_profile (Optional)
  # 設定内容: RDS Custom DBインスタンスの基盤となるAmazon EC2インスタンスに関連付けるインスタンスプロファイルを指定します。
  # 設定可能な値: 有効なIAMインスタンスプロファイル名
  # 用途: RDS Custom for Oracle や RDS Custom for SQL Server で使用
  # 関連機能: RDS Custom
  #   OSとデータベース環境へのアクセスを必要とするアプリケーション向け。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-custom.html
  custom_iam_instance_profile = null

  #-------------------------------------------------------------
  # スナップショット設定
  #-------------------------------------------------------------

  # copy_tags_to_snapshot (Optional)
  # 設定内容: DBインスタンスからスナップショットにユーザー定義タグをコピーするかを指定します。
  # 設定可能な値: true または false
  # デフォルト: false
  # 用途: スナップショットに自動的にタグを継承させる
  # 関連機能: Tag Propagation
  #   スナップショットの管理とコスト追跡を容易にします。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_Tagging.html
  copy_tags_to_snapshot = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_Tagging.html
  tags = {
    Name        = "aurora-instance-1"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はインスタンス識別子と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: インスタンス作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "90m", "2h")
    # デフォルト: 90分
    create = null

    # update (Optional)
    # 設定内容: インスタンス更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "90m", "2h")
    # デフォルト: 90分
    update = null

    # delete (Optional)
    # 設定内容: インスタンス削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "90m", "2h")
    # デフォルト: 90分
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: クラスターインスタンスのAmazon Resource Name (ARN)
#
# - cluster_identifier: RDSクラスター識別子
#
# - identifier: インスタンス識別子
#
# - id: インスタンス識別子
#
# - writer: このインスタンスが書き込み可能かどうかを示すブール値。
#   False の場合、このインスタンスはリードレプリカです。
#
# - availability_zone: インスタンスのアベイラビリティーゾーン
#
# - endpoint: このインスタンスのDNSアドレス。書き込み可能でない場合があります。
#
# - engine: データベースエンジン
#
# - engine_version_actual: データベースエンジンのバージョン
#
# - port: データベースポート
#---------------------------------------------------------------
