#---------------------------------------------------------------
# Amazon Neptune Cluster Instance
#---------------------------------------------------------------
#
# Amazon Neptune クラスター内の個別のDBインスタンスを定義するリソース。
# Neptune クラスターは1つのプライマリ（書き込み）インスタンスと
# 最大15のリードレプリカインスタンスで構成される。
# countメタパラメータを使用して複数のインスタンスを作成し、
# 同一クラスターに参加させることが可能。
#
# AWS公式ドキュメント:
#   - Amazon Neptune DB Clusters and Instances: https://docs.aws.amazon.com/neptune/latest/userguide/feature-overview-db-clusters.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster_instance
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_cluster_instance" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # cluster_identifier (必須, string)
  # このインスタンスが属するNeptuneクラスターの識別子。
  # aws_neptune_clusterリソースのidを参照する形で指定する。
  cluster_identifier = "neptune-cluster-demo"

  # instance_class (必須, string)
  # インスタンスクラス。CPUとメモリの容量を決定する。
  # 利用可能なクラス: db.r5.large, db.r5.xlarge, db.r5.2xlarge, db.r5.4xlarge,
  # db.r5.8xlarge, db.r5.12xlarge, db.r6g.large, db.r6g.xlarge, db.r6g.2xlarge,
  # db.r6g.4xlarge, db.r6g.8xlarge, db.r6g.12xlarge, db.r6g.16xlarge,
  # db.r8g系（Graviton4）, db.t3.medium（開発・テスト用）など
  # 各インスタンスのクエリスレッド数 = 2 x vCPU数
  instance_class = "db.r5.large"

  #---------------------------------------------------------------
  # オプションパラメータ - 識別子
  #---------------------------------------------------------------

  # identifier (オプション, string)
  # インスタンスの識別子。省略時はTerraformがランダムな一意の識別子を割り当てる。
  # 変更すると新しいリソースが作成される（Forces new resource）。
  # identifier_prefixと競合するため、どちらか一方のみ指定可能。
  # identifier = "neptune-instance-1"

  # identifier_prefix (オプション, string)
  # 指定したプレフィックスで始まる一意の識別子を生成する。
  # 変更すると新しいリソースが作成される（Forces new resource）。
  # identifierと競合するため、どちらか一方のみ指定可能。
  # identifier_prefix = "neptune-"

  #---------------------------------------------------------------
  # オプションパラメータ - エンジン設定
  #---------------------------------------------------------------

  # engine (オプション, string)
  # データベースエンジン名。デフォルトは "neptune"。
  # 有効な値: "neptune"
  # engine = "neptune"

  # engine_version (オプション, string)
  # Neptuneエンジンのバージョン。
  # 注意: 現在、この引数を設定しても効果がないとドキュメントに記載あり。
  # engine_version = "1.2.0.0"

  #---------------------------------------------------------------
  # オプションパラメータ - ネットワーク・可用性
  #---------------------------------------------------------------

  # availability_zone (オプション, string)
  # インスタンスを作成するEC2アベイラビリティゾーン。
  # 高可用性のため、リードレプリカは異なるAZに配置することを推奨。
  # フェイルオーバー時にリードレプリカがプライマリに昇格可能。
  # availability_zone = "ap-northeast-1a"

  # neptune_subnet_group_name (オプション/条件付き必須, string)
  # このインスタンスに関連付けるサブネットグループ名。
  # publicly_accessible = false の場合は必須。
  # 注意: aws_neptune_clusterのneptune_subnet_group_nameと一致する必要がある。
  # neptune_subnet_group_name = "my-neptune-subnet-group"

  # port (オプション, number)
  # DBが接続を受け付けるポート番号。デフォルトは8182。
  # port = 8182

  # publicly_accessible (オプション, bool)
  # インスタンスにパブリックアクセスを許可するかどうか。
  # デフォルトはfalse。セキュリティ上、本番環境ではfalseを推奨。
  # publicly_accessible = false

  # region (オプション, string)
  # このリソースを管理するAWSリージョン。
  # 省略時はプロバイダー設定のリージョンを使用。
  # region = "ap-northeast-1"

  #---------------------------------------------------------------
  # オプションパラメータ - パラメータグループ
  #---------------------------------------------------------------

  # neptune_parameter_group_name (オプション, string)
  # このインスタンスに関連付けるNeptuneパラメータグループ名。
  # インスタンスレベルの設定をカスタマイズする場合に使用。
  # neptune_parameter_group_name = "my-neptune-parameter-group"

  #---------------------------------------------------------------
  # オプションパラメータ - メンテナンス・バックアップ
  #---------------------------------------------------------------

  # apply_immediately (オプション, bool)
  # インスタンスの変更を即座に適用するかどうか。
  # falseの場合、次のメンテナンスウィンドウで適用される。
  # デフォルトはfalse。本番環境では計画的なメンテナンス時に適用することを推奨。
  # apply_immediately = false

  # auto_minor_version_upgrade (オプション, bool)
  # メンテナンスウィンドウ中にマイナーエンジンアップグレードを
  # 自動的に適用するかどうか。デフォルトはtrue。
  # auto_minor_version_upgrade = true

  # preferred_backup_window (オプション, string)
  # 自動バックアップが有効な場合の日次バックアップ時間帯（UTC）。
  # 形式: "hh24:mi-hh24:mi"（例: "04:00-09:00"）
  # preferred_backup_window = "04:00-05:00"

  # preferred_maintenance_window (オプション, string)
  # メンテナンスを実行する時間帯（UTC）。
  # 形式: "ddd:hh24:mi-ddd:hh24:mi"（例: "Mon:00:00-Mon:03:00"）
  # preferred_maintenance_window = "Sun:03:00-Sun:04:00"

  #---------------------------------------------------------------
  # オプションパラメータ - フェイルオーバー・スナップショット
  #---------------------------------------------------------------

  # promotion_tier (オプション, number)
  # フェイルオーバー時の昇格優先度。0-15の値で、低い値ほど優先度が高い。
  # デフォルトは0。同じ優先度のリードレプリカ間では
  # 最も最近のデータを持つものが選択される。
  # promotion_tier = 0

  # skip_final_snapshot (オプション, bool)
  # インスタンス削除時にファイナルスナップショットをスキップするかどうか。
  # 本番環境ではfalseを推奨（スナップショットを取得）。
  # skip_final_snapshot = false

  #---------------------------------------------------------------
  # オプションパラメータ - タグ
  #---------------------------------------------------------------

  # tags (オプション, map(string))
  # インスタンスに割り当てるタグ。
  # プロバイダーレベルのdefault_tags設定がある場合、
  # 同じキーのタグはここで定義した値で上書きされる。
  # tags = {
  #   Name        = "neptune-instance-1"
  #   Environment = "production"
  # }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts {
  #   # create (オプション, string)
  #   # インスタンス作成のタイムアウト。
  #   # 形式: "60m", "1h30m" など（Go duration形式）
  #   # create = "90m"
  #
  #   # update (オプション, string)
  #   # インスタンス更新のタイムアウト。
  #   # update = "90m"
  #
  #   # delete (オプション, string)
  #   # インスタンス削除のタイムアウト。
  #   # delete = "90m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、
# 他のリソースから参照可能。terraform applyには設定不要。
#
# address        - インスタンスのホスト名。endpointとportも参照。
# arn            - インスタンスのAmazon Resource Name (ARN)
# dbi_resource_id - リージョン固有の不変なインスタンス識別子
# endpoint       - 接続エンドポイント（"address:port" 形式）
# id             - インスタンス識別子
# kms_key_arn    - クラスターに設定されているKMS暗号化キーのARN
# storage_encrypted - クラスターが暗号化されているかどうか
# storage_type   - クラスターに関連付けられたストレージタイプ（standard/iopt1）
# tags_all       - プロバイダーのdefault_tagsから継承したタグを含む全タグ
# writer         - このインスタンスが書き込み可能かどうか。
#                  falseの場合はリードレプリカ。
#---------------------------------------------------------------
