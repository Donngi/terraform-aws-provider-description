#---------------------------------------------------------------
# AWS Backup Vault Notifications
#---------------------------------------------------------------
#
# AWS Backupボルトの通知設定をプロビジョニングするリソースです。
# Amazon SNSを使用して、バックアップジョブ、コピージョブ、復元ジョブなどの
# イベント通知を受信するための設定を行います。
#
# AWS公式ドキュメント:
#   - AWS Backup通知オプション: https://docs.aws.amazon.com/aws-backup/latest/devguide/backup-notifications.html
#   - PutBackupVaultNotifications API: https://docs.aws.amazon.com/aws-backup/latest/devguide/API_PutBackupVaultNotifications.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_notifications
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_backup_vault_notifications" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # backup_vault_name (Required)
  # 設定内容: 通知を追加するバックアップボルトの名前を指定します。
  # 設定可能な値: 既存のバックアップボルト名
  backup_vault_name = "example_backup_vault"

  # sns_topic_arn (Required)
  # 設定内容: バックアップボルトのイベントを受信するSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックARN
  # 注意: SNSトピックには、AWS Backupからの発行を許可するアクセスポリシーが必要です。
  #       backup.amazonaws.comサービスプリンシパルにSNS:Publish権限を付与してください。
  sns_topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:backup-vault-events"

  # backup_vault_events (Required)
  # 設定内容: バックアップボルトへのリソースバックアップジョブのステータスを示すイベントの配列を指定します。
  # 設定可能な値:
  #   バックアップジョブ関連:
  #     - "BACKUP_JOB_STARTED": バックアップジョブが開始された
  #     - "BACKUP_JOB_COMPLETED": バックアップジョブが完了した
  #     - "CONTINUOUS_BACKUP_INTERRUPTED": 継続的バックアップが中断された
  #   コピージョブ関連:
  #     - "COPY_JOB_STARTED": コピージョブが開始された
  #     - "COPY_JOB_SUCCESSFUL": コピージョブが成功した
  #     - "COPY_JOB_FAILED": コピージョブが失敗した
  #   復元ジョブ関連:
  #     - "RESTORE_JOB_STARTED": 復元ジョブが開始された
  #     - "RESTORE_JOB_COMPLETED": 復元ジョブが完了した
  #   リカバリポイント関連:
  #     - "RECOVERY_POINT_MODIFIED": リカバリポイントが変更された
  #   リカバリポイントインデックス関連:
  #     - "RECOVERY_POINT_INDEX_COMPLETED": リカバリポイントのインデックス作成が完了した
  #     - "RECOVERY_POINT_INDEX_DELETED": リカバリポイントのインデックスが削除された
  #     - "RECOVERY_POINT_INDEXING_FAILED": リカバリポイントのインデックス作成が失敗した
  #   S3固有イベント:
  #     - "S3_BACKUP_OBJECT_FAILED": S3オブジェクトのバックアップに失敗した
  #     - "S3_RESTORE_OBJECT_FAILED": S3オブジェクトの復元に失敗した
  #   EKS固有イベント:
  #     - "EKS_RESTORE_OBJECT_FAILED": EKSオブジェクトの復元に失敗した
  #     - "EKS_RESTORE_OBJECT_SKIPPED": EKSオブジェクトが復元時にスキップされた
  # 関連機能: AWS Backup イベント通知
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/backup-notifications.html
  backup_vault_events = ["BACKUP_JOB_STARTED", "BACKUP_JOB_COMPLETED", "RESTORE_JOB_COMPLETED"]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ボルトの名前
#
# - backup_vault_arn: ボルトのAmazon Resource Name (ARN)
#---------------------------------------------------------------

#---------------------------------------------------------------
# SNSトピックポリシーの例
#---------------------------------------------------------------
# AWS Backupからの通知を受信するには、SNSトピックに適切なアクセスポリシーが必要です。
# 以下は推奨されるポリシー設定の例です:
#
# resource "aws_sns_topic" "backup_notifications" {
#   name = "backup-vault-events"
# }
#
# data "aws_iam_policy_document" "backup_notifications" {
#   statement {
#     actions   = ["SNS:Publish"]
#     effect    = "Allow"
#     resources = [aws_sns_topic.backup_notifications.arn]
#---------------------------------------------------------------
