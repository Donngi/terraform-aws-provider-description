#---------------------------------------------------------------
# Neptune Global Cluster
#---------------------------------------------------------------
#
# Amazon Neptune グローバルデータベースを作成します。
# グローバルデータベースは、1つのプライマリリージョンと最大5つの
# 読み取り専用セカンダリリージョンで構成されます。
# 書き込み操作はプライマリクラスターに対して行い、
# Amazon Neptuneが専用インフラストラクチャを使用して
# セカンダリリージョンに自動的にデータを複製します。
#
# AWS公式ドキュメント:
#   - Neptune グローバルデータベース: https://docs.aws.amazon.com/neptune/latest/userguide/neptune-global-database.html
#   - グローバルデータベースのセットアップ: https://docs.aws.amazon.com/neptune/latest/userguide/neptune-gdb-setup.html
#   - CreateGlobalCluster API: https://docs.aws.amazon.com/neptune/latest/apiref/API_CreateGlobalCluster.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_global_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_global_cluster" "this" {
  #---------------------------------------------------------------
  # 必須引数
  #---------------------------------------------------------------

  # グローバルクラスター識別子
  # - グローバルデータベースを一意に識別する名前
  # - 英小文字、数字、ハイフンのみ使用可能
  # - 1〜63文字
  # - リージョン内で一意である必要がある
  # - 変更すると新しいリソースが作成される（Forces new resource）
  global_cluster_identifier = "example-global-cluster"

  #---------------------------------------------------------------
  # 任意引数
  #---------------------------------------------------------------

  # 削除保護の有効化
  # - trueの場合、グローバルクラスターの削除がブロックされる
  # - 本番環境では有効にすることを推奨
  # - デフォルト: false
  deletion_protection = false

  # データベースエンジン名
  # - 使用するデータベースエンジンを指定
  # - 有効値: "neptune"
  # - source_db_cluster_identifier と併用不可
  # - 変更すると新しいリソースが作成される（Forces new resource）
  engine = "neptune"

  # エンジンバージョン
  # - グローバルデータベースのエンジンバージョン
  # - 例: "1.2.0.0", "1.2.1.0", "1.3.0.0"
  # - エンジンバージョンをアップグレードすると、
  #   すべてのクラスターメンバーが即座に更新される
  engine_version = "1.2.0.0"

  # ソースDBクラスター識別子
  # - 既存のNeptune DBクラスターをプライマリクラスターとして
  #   グローバルデータベースを作成する場合に指定
  # - DBクラスターのARNを指定
  # - 新規グローバルクラスターを作成する場合は指定しない
  # - engine と併用不可
  # - Terraformはこの値のドリフト検出を行わない
  # source_db_cluster_identifier = "arn:aws:rds:us-east-2:123456789012:cluster:example-cluster"

  # ストレージ暗号化
  # - DBクラスターが暗号化されているかどうか
  # - 暗号化されたクラスターのみをグローバルデータベースに追加可能
  # - source_db_cluster_identifier が指定され、そのクラスターが
  #   暗号化されている場合、デフォルトで true になる
  # - 変更すると新しいリソースが作成される（Forces new resource）
  # - デフォルト: false（source_db_cluster_identifier が暗号化されていない場合）
  storage_encrypted = false

  # リージョン
  # - このリソースが管理されるAWSリージョン
  # - 指定しない場合、プロバイダー設定のリージョンが使用される
  # - グローバルデータベースはプライマリリージョンに作成される
  # region = "us-east-1"

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # グローバルクラスター作成時のタイムアウト
    # - デフォルト: 5分
    create = "5m"

    # グローバルクラスター更新時のタイムアウト
    # - クラスターメンバーの更新時間（メンバーごと）
    # - デフォルト: 120分
    update = "120m"

    # グローバルクラスター削除時のタイムアウト
    # - クラスターメンバーの削除時間（メンバーごと）
    # - デフォルト: 5分
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能ですが、
# 直接設定することはできません（computed only）。
#
# arn
#   - グローバルクラスターのARN
#   - 例: "arn:aws:rds::123456789012:global-cluster:example-global-cluster"
#
# global_cluster_members
#   - グローバルクラスターのメンバー情報のセット
#   - 各メンバーは以下の属性を持つ:
#     - db_cluster_arn: メンバーDBクラスターのARN
#     - is_writer: プライマリDBクラスターかどうか（true/false）
#
# global_cluster_resource_id
#   - グローバルデータベースクラスターのAWSリージョン固有の不変識別子
#   - DBクラスターのAWS KMSキーがアクセスされるたびに
#     AWS CloudTrailログエントリに記録される
#
# id
#   - Neptune グローバルクラスターの識別子
#   - global_cluster_identifier と同じ値
#
# status
#   - グローバルクラスターの現在のステータス
#   - 例: "available", "creating", "deleting"
#
#---------------------------------------------------------------
