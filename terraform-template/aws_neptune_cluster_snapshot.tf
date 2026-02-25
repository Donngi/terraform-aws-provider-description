#---------------------------------------------------------------
# AWS Neptune Cluster Snapshot
#---------------------------------------------------------------
#
# Amazon Neptune クラスタースナップショットリソースです。
# 既存の Neptune クラスターの手動スナップショットを作成・管理します。
# スナップショットはクラスターのポイントインタイムコピーであり、
# バックアップや別リージョンへの復元に利用できます。
#
# AWS公式ドキュメント:
#   - Neptune ユーザーガイド: https://docs.aws.amazon.com/neptune/latest/userguide/
#   - Neptune API リファレンス: https://docs.aws.amazon.com/neptune/latest/apiref/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster_snapshot
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_cluster_snapshot" "example" {
  #-------------------------------------------------------------
  # 識別子設定
  #-------------------------------------------------------------

  # db_cluster_identifier (Required)
  # 設定内容: スナップショットを作成する対象の Neptune クラスター識別子を指定します。
  db_cluster_identifier = "my-neptune-cluster"

  # db_cluster_snapshot_identifier (Required)
  # 設定内容: 作成するスナップショットの一意識別子を指定します。
  # 設定可能な値: 1〜63文字の英数字またはハイフン。先頭は英字のみ。大文字使用不可。
  db_cluster_snapshot_identifier = "my-neptune-cluster-snapshot"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 省略時: 20分
    create = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - allocated_storage: スナップショットのストレージ割り当て量（GiB）
# - availability_zones: スナップショットを復元できる EC2 アベイラビリティーゾーンのリスト
# - db_cluster_snapshot_arn: スナップショットの ARN
# - engine: スナップショット作成時のデータベースエンジン名
# - engine_version: スナップショット作成時のエンジンバージョン
# - id: スナップショットの識別子（db_cluster_snapshot_identifier と同じ）
# - kms_key_id: 暗号化されたスナップショットの KMS キー ID
# - license_model: ライセンスモデル情報
# - port: スナップショット作成時のクラスターのポート番号
# - snapshot_type: スナップショットのタイプ
# - source_db_cluster_snapshot_arn: コピー元スナップショットの ARN
# - status: スナップショットのステータス
# - storage_encrypted: スナップショットが暗号化されているかどうか
# - vpc_id: スナップショットに関連付けられた VPC の ID
#---------------------------------------------------------------
