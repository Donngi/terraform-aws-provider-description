#---------------------------------------------------------------
# Amazon RDS Global Cluster (Aurora Global Database)
#---------------------------------------------------------------
#
# Amazon Aurora Global Databaseを構成するRDSグローバルクラスターを
# プロビジョニングするリソースです。
# 複数のAWSリージョンにまたがる単一のAuroraデータベースを管理し、
# プライマリクラスター（読み書き可能）と最大10のセカンダリクラスター（読み取り専用）で
# 構成されます。Auroraストレージサブシステムによる高速レプリケーションにより、
# 典型的に1秒未満のレイテンシーでデータをセカンダリリージョンへ同期します。
#
# AWS公式ドキュメント:
#   - Aurora Global Database概要: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database.html
#   - Aurora Global Database作成: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-creating.html
#   - Aurora Global Database管理: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-managing.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_global_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # global_cluster_identifier (Required, Forces new resource)
  # 設定内容: グローバルクラスターの一意な識別子を指定します。
  # 設定可能な値: 1-63文字の英数字またはハイフン。先頭は英字のみ
  global_cluster_identifier = "my-global-cluster"

  #-------------------------------------------------------------
  # エンジン設定
  #-------------------------------------------------------------

  # engine (Optional, Forces new resource)
  # 設定内容: グローバルクラスターで使用するデータベースエンジンを指定します。
  # 設定可能な値:
  #   - "aurora": Aurora MySQL互換（デフォルト）
  #   - "aurora-mysql": Aurora MySQL互換
  #   - "aurora-postgresql": Aurora PostgreSQL互換
  # 省略時: "aurora" が使用されます
  # 注意: source_db_cluster_identifier と同時に指定できません。
  #       Terraformは設定値が提供された場合のみドリフト検出を実行します。
  engine = "aurora-mysql"

  # engine_version (Optional)
  # 設定内容: Aurora グローバルデータベースのエンジンバージョンを指定します。
  # 設定可能な値: エンジンに対応した有効なバージョン文字列
  #   Aurora MySQL 例: "5.7.mysql_aurora.2.07.5", "8.0.mysql_aurora.3.04.0"
  #   Aurora PostgreSQL 例: "11.9", "14.6", "15.2"
  # 注意: engine、engine_version、インスタンスクラス（aws_rds_cluster_instanceのinstance_class）
  #       の組み合わせがグローバルデータベースをサポートする必要があります。
  #       バージョンアップグレード時はaws_rds_clusterリソースのlifecycle ignore_changes
  #       でengine_versionを無視する設定を推奨します。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database.html
  engine_version = "8.0.mysql_aurora.3.04.0"

  # engine_lifecycle_support (Optional)
  # 設定内容: DBインスタンスのライフサイクルタイプを指定します。Aurora PostgreSQLベースの
  #           グローバルデータベースのみに適用されます。
  # 設定可能な値:
  #   - "open-source-rds-extended-support" (デフォルト): RDS拡張サポートを使用
  #   - "open-source-rds-extended-support-disabled": RDS拡張サポートを無効化
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/extended-support.html
  engine_lifecycle_support = "open-source-rds-extended-support"

  #-------------------------------------------------------------
  # データベース設定
  #-------------------------------------------------------------

  # database_name (Optional, Forces new resource)
  # 設定内容: クラスター作成時に自動作成するデータベース名を指定します。
  # 設定可能な値: 有効なデータベース名の文字列
  # 注意: Terraformは設定値が提供された場合のみドリフト検出を実行します。
  database_name = "mydb"

  #-------------------------------------------------------------
  # ソースクラスター設定
  #-------------------------------------------------------------

  # source_db_cluster_identifier (Optional)
  # 設定内容: グローバルクラスターの作成時にプライマリDBクラスターとして使用する
  #           既存Aurora DBクラスターのARNを指定します。
  # 設定可能な値: 既存Aurora DBクラスターの有効なARN
  # 省略時: null（新規グローバルクラスターとして作成）
  # 注意: Terraformはこの値のドリフト検出を実行しません。
  #       初回作成後はこの引数を削除してengineとengine_versionで置き換え可能です。
  #       engineやengine_versionと同時に指定した場合、作成時はエンジン関連の値は無視され、
  #       グローバルクラスターはソースクラスターのengineとengine_versionを継承します。
  source_db_cluster_identifier = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # storage_encrypted (Optional, Forces new resource)
  # 設定内容: DBクラスターのストレージ暗号化を有効にするかを指定します。
  # 設定可能な値:
  #   - true: ストレージを暗号化する
  #   - false (デフォルト): ストレージを暗号化しない
  # 省略時: false。ただし source_db_cluster_identifier が指定され、かつそのクラスターが
  #         暗号化済みの場合はデフォルトで true になります。
  # 注意: Terraformは設定値が提供された場合のみドリフト検出を実行します。
  storage_encrypted = true

  #-------------------------------------------------------------
  # 削除保護設定
  #-------------------------------------------------------------

  # deletion_protection (Optional)
  # 設定内容: グローバルクラスターの削除保護を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 削除保護を有効化。この値が true の場合はデータベースを削除できません
  #   - false (デフォルト): 削除保護を無効化
  deletion_protection = false

  # force_destroy (Optional)
  # 設定内容: destroyの実行時にグローバルクラスターからDBクラスターメンバーを削除するかを
  #           指定します。
  # 設定可能な値:
  #   - true: destroy時にDBクラスターメンバーをグローバルクラスターから除外して削除を実行
  #   - false (デフォルト): メンバーが存在する場合は削除に失敗
  # 注意: source_db_cluster_identifier を使用する場合は true の設定が必要です。
  force_destroy = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: DBクラスターに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-global-cluster"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: グローバルクラスター作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: グローバルクラスター更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: グローバルクラスター削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: RDS グローバルクラスターのAmazon Resource Name (ARN)
# - endpoint: グローバルデータベースクラスターのライターエンドポイント。
#             常に現在のプライマリクラスターのライターDBインスタンスを指します。
# - engine_version_actual: 実際に使用されているエンジンバージョン
# - global_cluster_members: グローバルクラスターメンバーのセット。
#   各メンバーには以下の属性があります:
#   - db_cluster_arn: メンバーDBクラスターのARN
#   - is_writer: プライマリDBクラスターかどうか
# - global_cluster_resource_id: グローバルデータベースクラスターのリージョン固有の
#                                イミュータブルな識別子。CloudTrailログでKMSキーが
#                                アクセスされた際にこの識別子が記録されます。
# - id: RDS グローバルクラスター識別子
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
