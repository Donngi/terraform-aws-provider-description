#---------------------------------------------------------------
# Amazon DocumentDB Cluster Snapshot
#---------------------------------------------------------------
#
# Amazon DocumentDB クラスタースナップショットを管理するリソースです。
# DocumentDB クラスターの手動スナップショットを作成し、バックアップとして保存できます。
#
# スナップショットの用途:
#   - ポイントインタイムリカバリ用の手動バックアップ
#   - クラスターの複製 (同一リージョンまたはクロスリージョン)
#   - テスト環境やステージング環境へのデータ移行
#   - 長期保存用アーカイブ (自動バックアップの保持期間を超える場合)
#
# AWS公式ドキュメント:
#   - DocumentDB スナップショット概要: https://docs.aws.amazon.com/documentdb/latest/developerguide/backup-restore.html
#   - DocumentDB クラスタースナップショットの作成: https://docs.aws.amazon.com/documentdb/latest/developerguide/backup_snapshot-create.html
#   - DocumentDB API CreateDBClusterSnapshot: https://docs.aws.amazon.com/documentdb/latest/developerguide/API_CreateDBClusterSnapshot.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_snapshot
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_docdb_cluster_snapshot" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # db_cluster_identifier (Required)
  # 設定内容: スナップショットを取得する元のDocumentDBクラスター識別子を指定します。
  # 設定可能な値: 既存のDocumentDBクラスター識別子
  # 用途: どのクラスターからスナップショットを作成するかを指定
  # 関連機能: DocumentDB クラスター識別子
  #   クラスター識別子はAWSアカウント内で一意である必要があります。
  #   - https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-manage.html
  db_cluster_identifier = aws_docdb_cluster.example.id

  # db_cluster_snapshot_identifier (Required)
  # 設定内容: 作成するスナップショットの識別子を指定します。
  # 設定可能な値: 文字列 (1-63文字、英数字とハイフンのみ、先頭は英字)
  # 用途: スナップショットを一意に識別するための名前
  # 注意: リージョン内で一意である必要があります
  # 関連機能: DocumentDB スナップショット識別子
  #   スナップショットを復元やコピーする際に使用される識別子です。
  #   - https://docs.aws.amazon.com/documentdb/latest/developerguide/backup_snapshot-create.html
  db_cluster_snapshot_identifier = "example-docdb-snapshot"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はdb_cluster_snapshot_identifierと同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定します。
  # 用途: スナップショット作成に時間がかかる場合にタイムアウトを延長
  timeouts {
    # create (Optional)
    # 設定内容: スナップショット作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "30m", "1h", "2h30m")
    # 省略時: デフォルトのタイムアウト値 (約20分)
    # 注意: 大規模なクラスターの場合、スナップショット作成に時間がかかる可能性があります
    create = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: スナップショット識別子 (db_cluster_snapshot_identifier と同じ)
#
# - availability_zones: DocumentDBクラスタースナップショット内のインスタンスを
#   復元できるEC2アベイラビリティゾーンのリスト
#
# - db_cluster_snapshot_arn: DocumentDBクラスタースナップショットの
#   Amazon Resource Name (ARN)
#
# - engine: データベースエンジンの名前 (例: "docdb")
#
# - engine_version: このDocumentDBクラスタースナップショットの
#   データベースエンジンバージョン (例: "5.0.0")
#
# - kms_key_id: storage_encrypted が true の場合、
#   暗号化されたDocumentDBクラスタースナップショットの AWS KMS キー識別子
#
# - port: スナップショット取得時にDocumentDBクラスターがリッスンしていたポート
#   (デフォルト: 27017)
#
# - snapshot_type: スナップショットのタイプ (例: "manual", "automated")
#---------------------------------------------------------------
