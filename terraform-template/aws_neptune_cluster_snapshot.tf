#---------------------------------------------------------------
# Neptune Cluster Snapshot
#---------------------------------------------------------------
#
# Amazon Neptune DBクラスタースナップショットを管理します。
# Neptune DBクラスターの手動スナップショットを作成し、
# データのバックアップやクラスターの複製に使用できます。
#
# AWS公式ドキュメント:
#   - Neptune スナップショットの概要: https://docs.aws.amazon.com/neptune/latest/userguide/backup-restore-overview.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster_snapshot
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_cluster_snapshot" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # db_cluster_identifier (Required, string)
  # スナップショットを取得するNeptune DBクラスターの識別子。
  # aws_neptune_cluster リソースのIDまたはcluster_identifierを指定します。
  # 指定されたクラスターが存在し、利用可能な状態である必要があります。
  db_cluster_identifier = null # 例: aws_neptune_cluster.example.id

  # db_cluster_snapshot_identifier (Required, string)
  # 作成するスナップショットの識別子。
  # AWS全体で一意である必要はありませんが、リージョン内で一意である必要があります。
  # 制約:
  #   - 1〜63文字の英数字またはハイフン
  #   - 最初の文字は英字
  #   - ハイフンを連続して使用不可
  #   - ハイフンで終了不可
  db_cluster_snapshot_identifier = null # 例: "my-neptune-snapshot-20260129"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # region (Optional, string)
  # このリソースが管理されるAWSリージョン。
  # 指定しない場合、プロバイダー設定で指定されたリージョンが使用されます。
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #---------------------------------------------------------------
  # timeouts ブロック (Optional)
  #---------------------------------------------------------------
  # Terraformがリソースの作成を待機する時間を設定します。
  # スナップショットのサイズによっては作成に時間がかかる場合があるため、
  # 必要に応じてタイムアウト値を調整してください。

  # timeouts {
  #   # create (Optional, string)
  #   # スナップショット作成のタイムアウト時間。
  #   # デフォルトは20分です。大規模なクラスターの場合は延長が必要な場合があります。
  #   # フォーマット: "30m" (30分), "1h" (1時間) など
  #   create = "20m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# 以下の属性はリソース作成後にTerraformによって設定されます。
# terraform state show や output で参照できます。
#
# allocated_storage           - スナップショットの割り当てストレージサイズ（GB）
# availability_zones          - DBクラスターインスタンスを復元可能なAZのリスト
# db_cluster_snapshot_arn     - スナップショットのAmazon Resource Name (ARN)
# engine                      - データベースエンジン名（例: "neptune"）
# engine_version              - DBクラスタースナップショットのエンジンバージョン
# id                          - リソースID（db_cluster_snapshot_identifierと同じ）
# kms_key_id                  - 暗号化されている場合のKMSキーID
# license_model               - ライセンスモデル情報
# port                        - スナップショット取得時にクラスターがリッスンしていたポート
# snapshot_type               - スナップショットタイプ（"manual"など）
# source_db_cluster_snapshot_arn - コピー元のスナップショットARN（コピーの場合のみ）
# status                      - スナップショットのステータス（"available"など）
# storage_encrypted           - ストレージが暗号化されているかどうか（bool）
# vpc_id                      - スナップショットに関連付けられたVPC ID
#---------------------------------------------------------------
