#---------------------------------------------------------------
# Kinesis Data Analytics v2 Application Snapshot
#---------------------------------------------------------------
#
# Kinesis Data Analytics v2 Application Snapshotを管理するリソース。
# スナップショットは、Apache Flinkのセーブポイント機能のAWS実装であり、
# アプリケーションの状態のバックアップとして機能します。
# スナップショットを作成するには、対象のKinesis Data Analyticsアプリケーションが
# 実行中である必要があります。
#
# AWS公式ドキュメント:
#   - Manage application backups using snapshots: https://docs.aws.amazon.com/managed-flink/latest/java/how-snapshots.html
#   - SnapshotDetails API Reference: https://docs.aws.amazon.com/managed-flink/latest/apiv2/API_SnapshotDetails.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesisanalyticsv2_application_snapshot
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesisanalyticsv2_application_snapshot" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # application_name - (Required) 既存のKinesis Analytics v2アプリケーションの名前。
  # スナップショットを作成するには、アプリケーションが実行中である必要があります。
  # 型: string
  # 参照: aws_kinesisanalyticsv2_application.example.name
  application_name = "example-application"

  # snapshot_name - (Required) アプリケーションスナップショットの名前。
  # 1〜256文字の文字列で、英数字、ハイフン(-)、アンダースコア(_)、
  # ピリオド(.)を使用できます。
  # 型: string
  # パターン: [a-zA-Z0-9_.-]+
  # 最小長: 1
  # 最大長: 256
  snapshot_name = "example-snapshot"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # region - (Optional) このリソースが管理されるリージョン。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 型: string
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Timeouts Block (Optional)
  #---------------------------------------------------------------
  # Terraformのタイムアウト設定を制御します。
  # 実際のAPIリクエストには影響しません。

  # timeouts {
  #   # create - (Optional) リソース作成のタイムアウト時間。
  #   # デフォルト値が設定されています。
  #   # 型: string (例: "10m", "1h")
  #   create = "10m"
  #
  #   # delete - (Optional) リソース削除のタイムアウト時間。
  #   # デフォルト値が設定されています。
  #   # 型: string (例: "10m", "1h")
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Computed - Read Only)
#---------------------------------------------------------------
# これらの属性はリソース作成後に参照可能になります。
# Terraformコード内で設定することはできません。
#
# - id
#   アプリケーションスナップショットの識別子。
#   型: string
#
# - application_version_id
#   スナップショット作成時の現在のアプリケーションバージョンID。
#   型: number
#   範囲: 1〜999999999
#
# - snapshot_creation_timestamp
#   アプリケーションスナップショットのタイムスタンプ。
#   型: string (ISO 8601形式)
#
#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# output "snapshot_id" {
#   description = "スナップショットのID"
#   value       = aws_kinesisanalyticsv2_application_snapshot.example.id
# }
#
# output "snapshot_version" {
#   description = "スナップショット作成時のアプリケーションバージョン"
#   value       = aws_kinesisanalyticsv2_application_snapshot.example.application_version_id
# }
#
# output "snapshot_timestamp" {
#   description = "スナップショット作成タイムスタンプ"
#   value       = aws_kinesisanalyticsv2_application_snapshot.example.snapshot_creation_timestamp
# }
#
#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
# 1. スナップショットを作成するには、Kinesis Data Analyticsアプリケーションが
#    実行中(RUNNING状態)である必要があります。
#
# 2. スナップショットは、Apache Flinkのセーブポイント機能のAWS実装です。
#    アプリケーションの状態を特定の時点から復元する際に使用できます。
#
# 3. Amazon Managed Service for Apache Flinkは、アプリケーションの更新、
#    スケーリング、または停止時に自動的にスナップショットを作成します。
#    ただし、手動で作成されたスナップショットは、サービスによって
#    自動削除されることはなく、ユーザーが明示的に削除する必要があります。
#
# 4. アプリケーションごとにスナップショット数の制限があります。
#    制限に達すると、手動スナップショットの作成は失敗しますが、
#    サービスは引き続き自動スナップショットを作成します。
#
# 5. 互換性のない状態データを含むスナップショットからアプリケーションを
#    復元すると、予期しない動作が発生する可能性があります。
#
# 6. Amazon Kinesis Data Analytics for SQLアプリケーションは段階的に
#    廃止されます（2026年1月27日以降、アプリケーションは削除されます）。
#    新規開発にはManaged Service for Apache Flinkの使用を推奨します。
#
#---------------------------------------------------------------
