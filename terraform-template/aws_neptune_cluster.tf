#---------------------------------------------------------------
# Amazon Neptune Cluster
#---------------------------------------------------------------
#
# Amazon Neptuneクラスターをプロビジョニングする。
# Neptuneは、グラフデータベースサービスであり、高度に接続された
# データセットを扱うアプリケーション向けに設計されている。
# クラスターは1つのプライマリDBインスタンスと最大15の
# リードレプリカインスタンスで構成される。
#
# AWS公式ドキュメント:
#   - Amazon Neptune DB Clusters and Instances: https://docs.aws.amazon.com/neptune/latest/userguide/feature-overview-db-clusters.html
#   - Setting up Amazon Neptune: https://docs.aws.amazon.com/neptune/latest/userguide/neptune-setup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_cluster" "this" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # cluster_identifier (任意)
  # クラスターの識別子。省略した場合、Terraformがランダムで一意な識別子を割り当てる。
  # この値を変更すると、新しいリソースが強制的に作成される。
  # cluster_identifier_prefixと競合するため、どちらか一方のみ指定可能。
  # 型: string
  cluster_identifier = "example-neptune-cluster"

  # cluster_identifier_prefix (任意)
  # 指定したプレフィックスで始まる一意のクラスター識別子を作成する。
  # cluster_identifierと競合するため、どちらか一方のみ指定可能。
  # この値を変更すると、新しいリソースが強制的に作成される。
  # 型: string
  # cluster_identifier_prefix = "example-"

  # engine (任意)
  # このNeptuneクラスターに使用するデータベースエンジンの名前。
  # デフォルト: "neptune"
  # 型: string
  engine = "neptune"

  # engine_version (任意)
  # データベースエンジンのバージョン。
  # 省略した場合、AWSが適切なバージョンを選択する。
  # 型: string
  # engine_version = "1.3.0.0"

  # port (任意)
  # Neptuneが接続を受け付けるポート番号。
  # デフォルト: 8182
  # 型: number
  # port = 8182

  #---------------------------------------------------------------
  # ネットワーク設定
  #---------------------------------------------------------------

  # availability_zones (任意)
  # Neptuneクラスター内のインスタンスを作成できるEC2アベイラビリティゾーンのリスト。
  # 高可用性のために複数のAZを指定することを推奨。
  # 型: set(string)
  # availability_zones = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]

  # neptune_subnet_group_name (任意)
  # このNeptuneインスタンスに関連付けるNeptuneサブネットグループの名前。
  # VPC内でNeptuneを起動する際に必須。
  # 型: string
  # neptune_subnet_group_name = "example-neptune-subnet-group"

  # vpc_security_group_ids (任意)
  # クラスターに関連付けるVPCセキュリティグループIDのリスト。
  # 型: set(string)
  # vpc_security_group_ids = ["sg-12345678"]

  #---------------------------------------------------------------
  # バックアップ設定
  #---------------------------------------------------------------

  # backup_retention_period (任意)
  # バックアップを保持する日数。
  # デフォルト: 1
  # 型: number
  # backup_retention_period = 7

  # preferred_backup_window (任意)
  # 自動バックアップが有効な場合に、自動バックアップが作成される日次の時間範囲（UTC）。
  # 例: "07:00-09:00"
  # 省略した場合、リージョンごとに8時間のブロックからランダムに30分のウィンドウが選択される。
  # 型: string
  # preferred_backup_window = "03:00-04:00"

  # copy_tags_to_snapshot (任意)
  # trueに設定すると、作成されるDBクラスタースナップショットにタグがコピーされる。
  # 型: bool
  # copy_tags_to_snapshot = true

  # skip_final_snapshot (任意)
  # Neptuneクラスター削除前に最終スナップショットを作成するかどうか。
  # true: 最終スナップショットを作成しない
  # false: 最終スナップショットを作成する（final_snapshot_identifierの値を使用）
  # デフォルト: false
  # 本番環境では必ずfalseにし、final_snapshot_identifierを指定すること。
  # 型: bool
  skip_final_snapshot = true

  # final_snapshot_identifier (任意)
  # Neptuneクラスター削除時に作成される最終スナップショットの名前。
  # skip_final_snapshotがfalseの場合に使用される。
  # 省略した場合、最終スナップショットは作成されない。
  # 型: string
  # final_snapshot_identifier = "example-final-snapshot"

  # snapshot_identifier (任意)
  # このクラスターをスナップショットから作成するかどうか。
  # Neptuneクラスタースナップショットの名前またはARN、
  # またはNeptuneスナップショットのARNを指定。
  # 自動スナップショットはリソース置換時にクラスター削除で削除されるため、
  # 別のクラスターからのものでない限り使用しないこと。
  # 型: string
  # snapshot_identifier = "example-snapshot"

  #---------------------------------------------------------------
  # メンテナンス設定
  #---------------------------------------------------------------

  # preferred_maintenance_window (任意)
  # システムメンテナンスが実行される週次の時間範囲（UTC）。
  # 例: "wed:04:00-wed:04:30"
  # 型: string
  # preferred_maintenance_window = "sun:05:00-sun:06:00"

  # apply_immediately (任意)
  # クラスターの変更を即座に適用するか、次のメンテナンスウィンドウ中に適用するか。
  # true: 即座に適用
  # false: 次のメンテナンスウィンドウで適用
  # デフォルト: false
  # 型: bool
  # apply_immediately = true

  # allow_major_version_upgrade (任意)
  # 異なるメジャーバージョン間のアップグレードを許可するかどうか。
  # DBクラスターの現在のバージョンと異なるメジャーバージョンを使用する
  # engine_versionパラメータを指定する場合は、trueに設定する必要がある。
  # デフォルト: false
  # 型: bool
  # allow_major_version_upgrade = false

  #---------------------------------------------------------------
  # セキュリティ設定
  #---------------------------------------------------------------

  # storage_encrypted (任意)
  # Neptuneクラスターを暗号化するかどうか。
  # デフォルト: false
  # 本番環境では必ずtrueにすることを推奨。
  # 型: bool
  # storage_encrypted = true

  # kms_key_arn (任意)
  # KMS暗号化キーのARN。
  # kms_key_arnを指定する場合、storage_encryptedをtrueに設定する必要がある。
  # 型: string
  # kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # iam_database_authentication_enabled (任意)
  # AWS IAMアカウントからデータベースアカウントへのマッピングを有効にするかどうか。
  # 型: bool
  # iam_database_authentication_enabled = true

  # deletion_protection (任意)
  # DBクラスターの削除保護が有効かどうか。
  # 有効にすると、データベースを削除できなくなる。
  # デフォルト: 無効
  # 本番環境では有効にすることを推奨。
  # 型: bool
  # deletion_protection = true

  #---------------------------------------------------------------
  # IAMロール設定
  #---------------------------------------------------------------

  # iam_roles (任意)
  # Neptuneクラスターに関連付けるIAMロールのARNのリスト。
  # S3からのデータロードなど、他のAWSサービスとの連携に使用。
  # 型: set(string)
  # iam_roles = ["arn:aws:iam::123456789012:role/NeptuneLoadFromS3"]

  #---------------------------------------------------------------
  # パラメータグループ設定
  #---------------------------------------------------------------

  # neptune_cluster_parameter_group_name (任意)
  # クラスターに関連付けるクラスターパラメータグループの名前。
  # 型: string
  # neptune_cluster_parameter_group_name = "default.neptune1.3"

  # neptune_instance_parameter_group_name (任意)
  # メジャーバージョンアップグレード時に使用するインスタンスパラメータグループの名前。
  # 型: string
  # neptune_instance_parameter_group_name = "default.neptune1.3"

  #---------------------------------------------------------------
  # CloudWatch Logs設定
  #---------------------------------------------------------------

  # enable_cloudwatch_logs_exports (任意)
  # CloudWatch Logsにエクスポートするログタイプのリスト。
  # 現在サポートされているのは "audit" と "slowquery"。
  # 型: set(string)
  # enable_cloudwatch_logs_exports = ["audit", "slowquery"]

  #---------------------------------------------------------------
  # ストレージ設定
  #---------------------------------------------------------------

  # storage_type (任意)
  # クラスターに関連付けるストレージタイプ。
  # 設定可能な値:
  #   - "standard": 標準ストレージ（デフォルト）
  #   - "iopt1": I/O最適化ストレージ
  # 型: string
  # storage_type = "standard"

  #---------------------------------------------------------------
  # グローバルデータベース設定
  #---------------------------------------------------------------

  # global_cluster_identifier (任意)
  # aws_neptune_global_clusterで指定されたグローバルクラスター識別子。
  # グローバルデータベースの一部としてこのクラスターを作成する場合に使用。
  # 型: string
  # global_cluster_identifier = "example-global-cluster"

  #---------------------------------------------------------------
  # レプリケーション設定
  #---------------------------------------------------------------

  # replication_source_identifier (任意)
  # このNeptuneクラスターをリードレプリカとして作成する場合の
  # ソースNeptuneクラスターまたはNeptuneインスタンスのARN。
  # 型: string
  # replication_source_identifier = "arn:aws:rds:ap-northeast-1:123456789012:cluster:source-cluster"

  #---------------------------------------------------------------
  # Serverless V2設定
  #---------------------------------------------------------------

  # serverless_v2_scaling_configuration (任意)
  # NeptuneクラスターをServerlessとして作成する場合のスケーリング設定。
  # max_items: 1

  # serverless_v2_scaling_configuration {
  #   # min_capacity (任意)
  #   # Serverless V2のAurora Capacity Units (ACUs)の最小値。
  #   # 型: number
  #   min_capacity = 1.0
  #
  #   # max_capacity (任意)
  #   # Serverless V2のAurora Capacity Units (ACUs)の最大値。
  #   # 型: number
  #   max_capacity = 128.0
  # }

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (任意)
  # このリソースが管理されるリージョン。
  # 省略した場合、プロバイダー設定のリージョンがデフォルトで使用される。
  # 型: string
  # region = "ap-northeast-1"

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (任意)
  # Neptuneクラスターに割り当てるタグのマップ。
  # プロバイダーレベルのdefault_tags設定ブロックが存在する場合、
  # 同じキーを持つタグはプロバイダーレベルで定義されたものを上書きする。
  # 型: map(string)
  # tags = {
  #   Name        = "example-neptune-cluster"
  #   Environment = "production"
  # }

  # tags_all (任意/Computed)
  # プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  # リソースに割り当てられたすべてのタグのマップ。
  # 通常は明示的に設定せず、tagsとdefault_tagsの組み合わせで自動計算される。
  # 型: map(string)
  # tags_all = {}

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts (任意)
  # リソースの作成、更新、削除操作のタイムアウト設定。

  # timeouts {
  #   # create (任意)
  #   # 作成操作のタイムアウト。
  #   # 型: string
  #   create = "120m"
  #
  #   # update (任意)
  #   # 更新操作のタイムアウト。
  #   # 型: string
  #   update = "120m"
  #
  #   # delete (任意)
  #   # 削除操作のタイムアウト。
  #   # 型: string
  #   delete = "120m"
  # }

  #---------------------------------------------------------------
  # その他
  #---------------------------------------------------------------

  # id (任意/Computed)
  # Neptuneクラスター識別子。通常は明示的に設定しない。
  # 型: string
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
#
# 以下の属性はTerraformによって自動的に計算され、
# 他のリソースやoutputで参照可能。
#
# arn:
#   Neptune ClusterのARN。
#   例: arn:aws:rds:ap-northeast-1:123456789012:cluster:example-neptune-cluster
#
# cluster_resource_id:
#   Neptune ClusterのリソースID。
#   AWSリソースの一意識別に使用される。
#
# cluster_members:
#   このクラスターに属するNeptuneインスタンスのリスト。
#
# endpoint:
#   NeptuneインスタンスのDNSアドレス（クラスターエンドポイント）。
#   書き込み操作に使用。
#
# hosted_zone_id:
#   エンドポイントのRoute53ホストゾーンID。
#
# reader_endpoint:
#   Neptuneクラスターの読み取り専用エンドポイント。
#   レプリカ間で自動的にロードバランシングされる。
#   読み取り操作に使用。
#
#---------------------------------------------------------------
