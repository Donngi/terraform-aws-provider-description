#---------------------------------------------------------------
# AWS Neptune Cluster
#---------------------------------------------------------------
#
# Amazon Neptune クラスターリソースです。
# Neptune クラスターは Neptune インスタンス全体に適用される属性を定義し、
# グラフデータベースのクラスター全体の構成を管理します。
#
# backup_retention_period などのパラメータを手動で変更すると変更が発生し、
# 次のメンテナンスウィンドウで反映されます。apply_immediately フラグを使用すると
# 変更を即座に適用できます。
#
# AWS公式ドキュメント:
#   - Neptune ユーザーガイド: https://docs.aws.amazon.com/neptune/latest/userguide/
#   - Neptune API リファレンス: https://docs.aws.amazon.com/neptune/latest/apiref/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_cluster" "example" {
  #-------------------------------------------------------------
  # 識別子設定
  #-------------------------------------------------------------

  # cluster_identifier (Optional)
  # 設定内容: クラスターの一意識別子を指定します。
  # 省略時: Terraform がランダムな一意の識別子を割り当てます。
  # 注意: cluster_identifier_prefix と排他的。
  cluster_identifier = "my-neptune-cluster"

  # cluster_identifier_prefix (Optional)
  # 設定内容: 一意のクラスター識別子のプレフィックスを指定します。
  # 省略時: Terraform が一意のプレフィックスを自動生成します。
  # 注意: cluster_identifier と排他的。新しいリソースを強制します。
  cluster_identifier_prefix = null

  #-------------------------------------------------------------
  # エンジン設定
  #-------------------------------------------------------------

  # engine (Optional)
  # 設定内容: クラスターで使用するデータベースエンジン名を指定します。
  # 設定可能な値: "neptune"
  # 省略時: "neptune"
  engine = "neptune"

  # engine_version (Optional)
  # 設定内容: データベースエンジンのバージョンを指定します。
  # 設定可能な値: 有効な Neptune エンジンバージョン（例: "1.3.2.1"）
  # 省略時: Neptune の最新エンジンバージョンを使用
  engine_version = null

  # allow_major_version_upgrade (Optional)
  # 設定内容: 異なるメジャーバージョン間のアップグレードを許可するかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  # 注意: 異なるメジャーバージョンの engine_version を指定する場合は true に設定する必要があります。
  allow_major_version_upgrade = false

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # neptune_subnet_group_name (Optional)
  # 設定内容: この Neptune インスタンスに関連付けるサブネットグループを指定します。
  # 省略時: デフォルトのサブネットグループを使用
  neptune_subnet_group_name = null

  # vpc_security_group_ids (Optional)
  # 設定内容: クラスターに関連付ける VPC セキュリティグループ ID のリストを指定します。
  vpc_security_group_ids = []

  # availability_zones (Optional)
  # 設定内容: Neptune クラスターのインスタンスを作成できる EC2 アベイラビリティーゾーンのリストを指定します。
  # 省略時: AWS がアベイラビリティーゾーンを自動選択します。
  availability_zones = null

  # port (Optional)
  # 設定内容: Neptune が接続を受け付けるポート番号を指定します。
  # 設定可能な値: 有効なポート番号
  # 省略時: 8182
  port = 8182

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
  # 設定可能な値: 1〜35
  # 省略時: 1
  backup_retention_period = 7

  # preferred_backup_window (Optional)
  # 設定内容: 自動バックアップが作成される毎日の時間範囲（UTC）を指定します。
  # 設定可能な値: "HH:MM-HH:MM" 形式（例: "07:00-09:00"）
  # 省略時: リージョンごとの 8 時間ブロックからランダムに選択された 30 分のウィンドウ
  preferred_backup_window = "03:00-04:00"

  # skip_final_snapshot (Optional)
  # 設定内容: Neptune クラスター削除前に最終スナップショットを作成するかを指定します。
  # 設定可能な値:
  #   - true: 最終スナップショットを作成しない
  #   - false (デフォルト): 最終スナップショットを作成
  # 注意: false の場合、final_snapshot_identifier を指定する必要があります。
  skip_final_snapshot = false

  # final_snapshot_identifier (Optional)
  # 設定内容: Neptune クラスター削除時に作成する最終 Neptune スナップショットの名前を指定します。
  # skip_final_snapshot が false の場合は必須です。
  # 省略時: 最終スナップショットは作成されません。
  final_snapshot_identifier = "my-neptune-final-snapshot"

  # snapshot_identifier (Optional)
  # 設定内容: スナップショットからクラスターを作成するかを指定します。
  # 設定可能な値: Neptune クラスタースナップショット名または ARN
  # 注意: 自動スナップショットは使用しないでください。自動スナップショットはリソースの
  #       置き換え時にクラスター破棄の一部として削除されます。
  snapshot_identifier = null

  #-------------------------------------------------------------
  # メンテナンス設定
  #-------------------------------------------------------------

  # preferred_maintenance_window (Optional)
  # 設定内容: システムメンテナンスを実行できる週次の時間範囲（UTC）を指定します。
  # 設定可能な値: "ddd:hh24:mi-ddd:hh24:mi" 形式（例: "wed:04:00-wed:04:30"）
  preferred_maintenance_window = "sun:05:00-sun:06:00"

  # apply_immediately (Optional)
  # 設定内容: クラスターへの変更を即座に適用するか、次のメンテナンスウィンドウで適用するかを指定します。
  # 設定可能な値:
  #   - true: 即座に適用
  #   - false (デフォルト): 次のメンテナンスウィンドウで適用
  apply_immediately = false

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # storage_encrypted (Optional)
  # 設定内容: Neptune クラスターを暗号化するかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  storage_encrypted = true

  # kms_key_arn (Optional)
  # 設定内容: KMS 暗号化キーの ARN を指定します。
  # 省略時: デフォルトの KMS キーを使用
  # 注意: storage_encrypted が true の場合に設定できます。
  kms_key_arn = null

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # storage_type (Optional)
  # 設定内容: クラスターに関連付けるストレージタイプを指定します。
  # 設定可能な値:
  #   - "standard": 標準ストレージ（デフォルト）
  #   - "iopt1": I/O 最適化ストレージ
  # 省略時: "standard"
  storage_type = "standard"

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # iam_database_authentication_enabled (Optional)
  # 設定内容: AWS IAM アカウントとデータベースアカウントのマッピングを有効にするかを指定します。
  # 設定可能な値: true または false
  iam_database_authentication_enabled = false

  # iam_roles (Optional)
  # 設定内容: Neptune クラスターに関連付ける IAM ロールの ARN のリストを指定します。
  iam_roles = []

  #-------------------------------------------------------------
  # パラメータグループ設定
  #-------------------------------------------------------------

  # neptune_cluster_parameter_group_name (Optional)
  # 設定内容: クラスターに関連付けるクラスターパラメータグループを指定します。
  # 省略時: デフォルトのクラスターパラメータグループを使用
  neptune_cluster_parameter_group_name = null

  # neptune_instance_parameter_group_name (Optional)
  # 設定内容: クラスター内のインスタンスに適用するインスタンスパラメータグループを指定します。
  neptune_instance_parameter_group_name = null

  #-------------------------------------------------------------
  # グローバルクラスター設定
  #-------------------------------------------------------------

  # global_cluster_identifier (Optional)
  # 設定内容: このクラスターに指定するグローバルクラスター識別子を指定します。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_global_cluster
  global_cluster_identifier = null

  #-------------------------------------------------------------
  # レプリケーション設定
  #-------------------------------------------------------------

  # replication_source_identifier (Optional)
  # 設定内容: Read Replica として作成する場合のソース Neptune クラスターまたは
  #           Neptune インスタンスの ARN を指定します。
  replication_source_identifier = null

  #-------------------------------------------------------------
  # ログ設定
  #-------------------------------------------------------------

  # enable_cloudwatch_logs_exports (Optional)
  # 設定内容: CloudWatch Logs にエクスポートするログタイプのリストを指定します。
  # 設定可能な値: "audit"、"slowquery"
  enable_cloudwatch_logs_exports = []

  #-------------------------------------------------------------
  # 削除保護設定
  #-------------------------------------------------------------

  # deletion_protection (Optional)
  # 設定内容: DB クラスターの削除保護を有効にするかを指定します。
  # 設定可能な値: true または false
  # 省略時: false
  # 注意: この値が true の場合、データベースは削除できません。
  deletion_protection = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # copy_tags_to_snapshot (Optional)
  # 設定内容: DB クラスターのすべてのタグを作成されたスナップショットにコピーするかを指定します。
  # 設定可能な値: true または false
  copy_tags_to_snapshot = true

  # tags (Optional)
  # 設定内容: Neptune クラスターに割り当てるタグのマップを指定します。
  # プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  # 一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-neptune-cluster"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # サーバーレス設定
  #-------------------------------------------------------------

  # serverless_v2_scaling_configuration (Optional)
  # 設定内容: Neptune クラスターをサーバーレスとして作成する場合のスケーリング設定を指定します。
  serverless_v2_scaling_configuration {
    # min_capacity (Optional)
    # 設定内容: Neptune サーバーレスクラスターの最小キャパシティ（NCU）を指定します。
    # 設定可能な値: 1.0〜128.0（0.5 刻み）
    min_capacity = 1.0

    # max_capacity (Optional)
    # 設定内容: Neptune サーバーレスクラスターの最大キャパシティ（NCU）を指定します。
    # 設定可能な値: 1.0〜128.0（0.5 刻み）
    max_capacity = 128.0
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 省略時: 120分
    create = "120m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウトを指定します。
    # 省略時: 120分
    update = "120m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 省略時: 120分
    delete = "120m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Neptune クラスターの ARN
#
# - cluster_resource_id: Neptune クラスターリソース ID
#
# - cluster_members: クラスターのメンバーである Neptune インスタンスのリスト
#
# - endpoint: Neptune インスタンスの DNS アドレス
#
# - hosted_zone_id: エンドポイントの Route53 ホストゾーン ID
#
# - id: Neptune クラスター識別子
#
# - reader_endpoint: Neptune クラスターの読み取り専用エンドポイント（レプリカ間で自動負荷分散）
#
# - status: Neptune インスタンスのステータス
#
# - tags_all: プロバイダーの default_tags から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
