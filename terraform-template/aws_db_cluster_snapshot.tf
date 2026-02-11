#---------------------------------------------------------------
# AWS RDS DB Cluster Snapshot
#---------------------------------------------------------------
#
# Amazon Aurora DB クラスターの手動スナップショットを管理するリソースです。
# DB クラスタースナップショットは、DB クラスター全体のストレージボリュームスナップショットを作成し、
# 個別のデータベースではなくクラスター全体をバックアップします。
#
# 主な特徴:
#   - 手動スナップショットはバックアップ保持期間の対象外で、有効期限はありません
#   - スナップショット作成時、DB クラスターは available 状態である必要があります
#   - 他の AWS アカウントとスナップショットを共有可能
#
# AWS公式ドキュメント:
#   - DB クラスタースナップショットの作成: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_CreateSnapshotCluster.html
#   - スナップショットの共有: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-share-snapshot.html
#   - CreateDBClusterSnapshot API: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBClusterSnapshot.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_cluster_snapshot
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_db_cluster_snapshot" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # db_cluster_identifier (Required)
  # 設定内容: スナップショットを取得する DB クラスターの識別子を指定します。
  # 設定可能な値: 既存の DB クラスター識別子 (例: "my-aurora-cluster")
  # 用途: バックアップ対象の Aurora クラスターを特定
  # 関連機能: Amazon Aurora DB クラスター
  #   スナップショットを作成するには、DB クラスターが available 状態である必要があります。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_CreateSnapshotCluster.html
  db_cluster_identifier = "my-aurora-cluster"

  # db_cluster_snapshot_identifier (Required)
  # 設定内容: 作成するスナップショットの識別子を指定します。
  # 設定可能な値: 英数字とハイフンで構成される一意の名前 (例: "my-cluster-snapshot-2024")
  # 制約:
  #   - 1-255 文字
  #   - 英字で始まる必要があります
  #   - 連続したハイフンは使用不可
  # 用途: スナップショットを識別し、復元時に参照するための名前
  # 関連機能: DB クラスタースナップショットの命名
  #   識別子はリージョン内で一意である必要があります。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_CreateSnapshotCluster.html
  db_cluster_snapshot_identifier = "my-cluster-snapshot-2024"

  #-------------------------------------------------------------
  # スナップショット共有設定
  #-------------------------------------------------------------

  # shared_accounts (Optional)
  # 設定内容: スナップショットを共有する AWS アカウント ID のリストを指定します。
  # 設定可能な値:
  #   - AWS アカウント ID のリスト (例: ["123456789012", "234567890123"])
  #   - "all" を指定するとスナップショットを公開 (暗号化されていないスナップショットのみ)
  # 省略時: スナップショットは作成者のアカウントのみがアクセス可能
  # 用途: 他の AWS アカウントとスナップショットを共有してクロスアカウント復元を可能にする
  # 注意:
  #   - 暗号化されたスナップショットは公開 ("all") できません
  #   - 暗号化されたスナップショットを共有する場合、KMS キーへのアクセス権も必要
  #   - 最大 20 アカウントまで共有可能
  # 関連機能: DB クラスタースナップショットの共有
  #   共有されたスナップショットから、認可されたアカウントは DB クラスターを復元可能。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-share-snapshot.html
  shared_accounts = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-cluster-snapshot"
    Environment = "production"
    Purpose     = "manual-backup"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースの ID。通常は db_cluster_snapshot_identifier と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: スナップショット作成操作のタイムアウト時間
    # 設定可能な値: 時間文字列 (例: "20m", "1h")
    # 省略時: デフォルトのタイムアウトが適用されます
    # 注意: スナップショット作成にかかる時間はデータベースサイズに依存します
    create = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - allocated_storage: 割り当てられたストレージサイズ (GB)
#
# - availability_zones: DB クラスタースナップショットからインスタンスを
#   復元可能な EC2 アベイラビリティゾーンのリスト
#
# - db_cluster_snapshot_arn: DB クラスタースナップショットの
#   Amazon Resource Name (ARN)
#
# - engine: データベースエンジン名 (例: "aurora-mysql", "aurora-postgresql")
#
# - engine_version: DB クラスタースナップショットのデータベースエンジンバージョン
#
# - kms_key_id: storage_encrypted が true の場合、
#   暗号化された DB クラスタースナップショットの AWS KMS キー識別子
#
# - license_model: 復元された DB クラスターのライセンスモデル情報
#
# - port: スナップショット取得時に DB クラスターがリッスンしていたポート番号
#
# - source_db_cluster_snapshot_arn: DB クラスタースナップショットのコピー元の ARN
#---------------------------------------------------------------
