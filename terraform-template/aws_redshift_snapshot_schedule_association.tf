#---------------------------------------------------------------
# Amazon Redshift Snapshot Schedule Association
#---------------------------------------------------------------
#
# Amazon Redshift クラスターとスナップショットスケジュールを関連付けるリソースです。
# スナップショットスケジュールを使用することで、Redshiftクラスターの自動スナップショット取得を
# スケジュール管理できます。
#
# 主な用途:
#   - 定期的な自動バックアップのスケジューリング
#   - クラスターのポイントインタイム復旧の設定
#   - 複数のクラスターに対する統一されたバックアップポリシーの適用
#
# AWS公式ドキュメント:
#   - Redshift スナップショットスケジュール: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshots.html
#   - Redshift 自動スナップショット: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshot-scheduling.html
#   - Redshift API リファレンス: https://docs.aws.amazon.com/redshift/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_snapshot_schedule_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_snapshot_schedule_association" "example" {
  #-------------------------------------------------------------
  # 必須パラメーター
  #-------------------------------------------------------------

  # cluster_identifier (Required, Forces new resource)
  # 設定内容: スナップショットスケジュールに関連付けるRedshiftクラスターの識別子を指定します。
  # 設定可能な値: 既存のRedshiftクラスターの識別子 (小文字英数字とハイフン)
  # 注意:
  #   - この値を変更すると、リソースが破棄され、新しいリソースが作成されます (Forces new resource)
  #   - クラスター識別子は作成済みのRedshiftクラスターを参照する必要があります
  # 関連機能: Amazon Redshift クラスター管理
  #   クラスター識別子は aws_redshift_cluster リソースで定義されたものを使用します。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-clusters.html
  cluster_identifier = "tf-redshift-cluster"

  # schedule_identifier (Required, Forces new resource)
  # 設定内容: クラスターに関連付けるスナップショットスケジュールの識別子を指定します。
  # 設定可能な値: 既存のスナップショットスケジュールの識別子
  # 注意:
  #   - この値を変更すると、リソースが破棄され、新しいリソースが作成されます (Forces new resource)
  #   - スケジュール識別子は aws_redshift_snapshot_schedule リソースで定義されたものを使用します
  # 用途: クラスターのスナップショット取得頻度と保持期間を制御
  # 関連機能: Amazon Redshift スナップショットスケジュール
  #   スケジュールには、スナップショットの取得頻度 (rate式またはcron式) を定義します。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshot-scheduling.html
  schedule_identifier = "tf-redshift-snapshot-schedule"

  #-------------------------------------------------------------
  # オプションパラメーター
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意:
  #   - Redshiftクラスターとスナップショットスケジュールは同じリージョンに存在する必要があります
  #   - クラスターのスナップショットは指定されたリージョンに保存されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常は "cluster_identifier/schedule_identifier" の形式
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# 以下は、Redshiftクラスター、スナップショットスケジュール、および
# それらの関連付けを作成する完全な例です:
#
# resource "aws_redshift_cluster" "example" {
#   cluster_identifier = "tf-redshift-cluster"
#   database_name      = "mydb"
#   master_username    = "admin"
#   master_password    = "MustBe8Characters"
#   node_type          = "dc2.large"
#   cluster_type       = "single-node"
# }
#
# resource "aws_redshift_snapshot_schedule" "example" {
#   identifier = "tf-redshift-snapshot-schedule"
#
#   # 12時間ごとにスナップショットを取得
#   definitions = [
#     "rate(12 hours)",
#   ]
#
#   # または、特定の時刻にスナップショットを取得 (UTC時間)
#   # definitions = [
#   #   "cron(0 0 * * ? *)",  # 毎日0時 (UTC)
#   # ]
# }
#
# resource "aws_redshift_snapshot_schedule_association" "example" {
#   cluster_identifier  = aws_redshift_cluster.example.id
#   schedule_identifier = aws_redshift_snapshot_schedule.example.id
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子。形式: "cluster_identifier/schedule_identifier"
#
# - cluster_identifier: 関連付けられたRedshiftクラスターの識別子
#
# - schedule_identifier: 関連付けられたスナップショットスケジュールの識別子
#
# - region: このリソースが管理されているAWSリージョン
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のスナップショットスケジュール関連付けは、以下のコマンドでインポートできます:
#
# terraform import aws_redshift_snapshot_schedule_association.example cluster_identifier/schedule_identifier
#
# 例:
# terraform import aws_redshift_snapshot_schedule_association.example tf-redshift-cluster/tf-redshift-snapshot-schedule
#---------------------------------------------------------------
