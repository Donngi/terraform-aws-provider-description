#---------------------------------------------------------------
# Amazon FinSpace Kx Volume
#---------------------------------------------------------------
#
# AWS FinSpace Kx Volumeリソースを管理します。
# FinSpace Kxクラスター用のネットワークアタッチストレージ（NAS）ボリュームを
# プロビジョニングし、環境内のクラスターからアタッチ可能なストレージを提供します。
#
# 【重要】Amazon FinSpaceは2025年10月7日以降、新規顧客の受け入れを停止し、
# 2026年10月7日にサポートが終了します。既存のお客様は引き続きご利用いただけます。
#
# AWS公式ドキュメント:
#   - CreateKxVolume API: https://docs.aws.amazon.com/finspace/latest/management-api/API_CreateKxVolume.html
#   - KxVolume: https://docs.aws.amazon.com/finspace/latest/management-api/API_KxVolume.html
#   - KxNAS1Configuration: https://docs.aws.amazon.com/finspace/latest/management-api/API_KxNAS1Configuration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/finspace_kx_volume
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_finspace_kx_volume" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # ボリュームの一意な名前
  # - FinSpace環境内で一意である必要があります
  # - ボリューム識別子として使用されます
  name = "my-kx-volume"

  # このボリュームがアタッチできるKdb環境の一意な識別子
  # - aws_finspace_kx_environmentリソースのIDを指定します
  # - この環境内のクラスターがこのボリュームをアタッチできます
  environment_id = "example-kx-environment-id"

  # ボリュームに割り当てるアベイラビリティーゾーンのIDリスト
  # - 例: ["use1-az2"]
  # - AZ IDの形式で指定する必要があります（AZ名ではありません）
  # - az_modeがSINGLEの場合、1つのAZのみを指定します
  availability_zones = ["use1-az2"]

  # ボリュームごとに割り当てるアベイラビリティーゾーンの数
  # - 現在、FinSpaceは「SINGLE」のみサポートしています
  # - SINGLE: ボリュームごとに1つのアベイラビリティーゾーンを割り当てます
  az_mode = "SINGLE"

  # ファイルシステムボリュームのタイプ
  # - 現在、FinSpaceは「NAS_1」タイプのみサポートしています
  # - NAS_1を選択した場合、nas1_configurationブロックも指定する必要があります
  type = "NAS_1"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # ボリュームの説明
  # - ユーザー定義の説明文
  # - 管理や識別を容易にするために使用します
  description = "My FinSpace Kx volume for data storage"

  # このリソースを管理するAWSリージョン
  # - 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # - 明示的にリージョンを指定する場合に使用します
  # region = "us-east-1"

  # ボリュームに付けるタグのマップ
  # - 最大50個のタグを追加できます
  # - リソースの分類、課金管理、アクセス制御などに使用します
  tags = {
    Name        = "example-kx-volume"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # Terraform管理用の内部ID
  # - 通常は指定不要です
  # - Terraform importや特殊なケースでのみ使用します
  # id = null

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # NAS_1タイプのファイルシステムボリューム設定
  # - volume_typeがNAS_1の場合に必須です
  # - ネットワークアタッチストレージの容量とタイプを定義します
  nas1_configuration {
    # ネットワークアタッチストレージのサイズ（GB単位）
    # - ストレージタイプに応じて最小サイズと増分単位が異なります：
    #   - SSD_1000, SSD_250: 最小1200GB、2400GBの倍数で増分
    #   - HDD_12: 最小6000GB、6000GBの倍数で増分
    size = 1200

    # ネットワークアタッチストレージのタイプ
    # - 選択可能な値:
    #   - SSD_1000: 高性能SSD（1000 MB/s スループット）
    #   - SSD_250: 標準SSD（250 MB/s スループット）
    #   - HDD_12: HDD（12 MB/s スループット）
    type = "SSD_250"
  }

  # リソース操作のタイムアウト設定
  # - Terraform操作がタイムアウトするまでの時間を指定します
  # - 大規模な環境や複雑な設定の場合に調整が必要な場合があります
  # timeouts {
  #   create = "30m"
  #   update = "30m"
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースからは以下の属性が参照可能です（Computed属性）:
#
# - arn
#   - ボリュームのAmazon Resource Name (ARN)
#   - 例: arn:aws:finspace:us-east-1:123456789012:kx-environment/env-id/kx-volume/volume-name
#
# - attached_clusters
#   - このボリュームにアタッチされているクラスターのリスト
#   - 各要素には以下が含まれます:
#     - cluster_name: クラスター名
#     - cluster_status: クラスターのステータス
#     - cluster_type: クラスターのタイプ
#
# - created_timestamp
#   - ボリュームがFinSpaceで作成されたタイムスタンプ
#   - エポック時刻（ミリ秒）で表されます
#   - 例: 1635768000000（2021年11月1日 12:00:00 PM UTC）
#
# - last_modified_timestamp
#   - ボリュームがFinSpaceで最後に更新されたタイムスタンプ
#   - エポック時刻（秒）で表されます
#   - 例: 1635768000（2021年11月1日 12:00:00 PM UTC）
#
# - status
#   - ボリューム作成のステータス
#   - 可能な値:
#     - CREATING: ボリューム作成が進行中
#     - CREATE_FAILED: ボリューム作成が失敗
#     - ACTIVE: ボリュームがアクティブ
#     - UPDATING: ボリュームが更新中
#     - UPDATE_FAILED: 更新アクションが失敗
#     - UPDATED: ボリュームが正常に更新された
#     - DELETING: ボリュームが削除中
#     - DELETE_FAILED: システムがボリュームの削除に失敗
#     - DELETED: ボリュームが正常に削除された
#
# - status_reason
#   - 失敗状態が発生した場合のエラーメッセージ
#   - トラブルシューティングに使用します
#
#---------------------------------------------------------------
# 使用例:
#
# output "volume_arn" {
#   description = "The ARN of the FinSpace Kx volume"
#   value       = aws_finspace_kx_volume.example.arn
# }
#
# output "volume_status" {
#   description = "The status of the FinSpace Kx volume"
#   value       = aws_finspace_kx_volume.example.status
# }
#
# output "attached_clusters" {
#   description = "List of clusters attached to this volume"
#   value       = aws_finspace_kx_volume.example.attached_clusters
# }
#---------------------------------------------------------------
