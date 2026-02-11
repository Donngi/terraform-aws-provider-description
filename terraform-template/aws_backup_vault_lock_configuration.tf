#---------------------------------------------------------------
# AWS Backup Vault Lock Configuration
#---------------------------------------------------------------
#
# AWS Backupバックアップボールトにロック設定を適用するリソースです。
# Vault Lockは、バックアップボールト内のリカバリーポイントの削除や変更を
# 防止するためのセキュリティ機能です。GovernanceモードとComplianceモードの
# 2つのモードがあり、データ保護要件に応じて選択できます。
#
# AWS公式ドキュメント:
#   - AWS Backup Vault Lock: https://docs.aws.amazon.com/aws-backup/latest/devguide/vault-lock.html
#   - PutBackupVaultLockConfiguration API: https://docs.aws.amazon.com/aws-backup/latest/devguide/API_PutBackupVaultLockConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_lock_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_backup_vault_lock_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # backup_vault_name (Required)
  # 設定内容: ロック設定を追加するバックアップボールトの名前を指定します。
  # 設定可能な値: 既存のバックアップボールト名
  # 注意: ボールトが存在している必要があります
  backup_vault_name = "example_backup_vault"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Vault Lockモード設定
  #-------------------------------------------------------------

  # changeable_for_days (Optional)
  # 設定内容: ロックが不変になるまでの猶予期間（クーリングオフ期間）を日数で指定します。
  # 設定可能な値: 3以上の整数（日数）
  # 省略時: Governanceモードでボールトをロック
  # 関連機能: AWS Backup Vault Lock モード
  #   - Governanceモード: changeable_for_daysを省略した場合に適用。
  #     十分なIAM権限を持つユーザーがボールトのロックを管理・削除可能。
  #   - Complianceモード: changeable_for_daysを指定した場合に適用。
  #     猶予期間中はロックを解除可能。期間終了後はボールトが不変になり、
  #     AWS含め誰もリカバリーポイントを削除・変更できなくなります。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/vault-lock.html
  changeable_for_days = 3

  #-------------------------------------------------------------
  # 保持期間制約設定
  #-------------------------------------------------------------

  # max_retention_days (Optional)
  # 設定内容: ボールトがリカバリーポイントを保持する最大期間を日数で指定します。
  # 設定可能な値: 正の整数（日数）
  # 省略時: 最大保持期間の制約なし
  # 関連機能: 保持期間の強制
  #   この値を設定すると、バックアッププランでこの値を超える保持期間を
  #   指定しても、この最大値が適用されます。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/vault-lock.html
  max_retention_days = 1200

  # min_retention_days (Optional)
  # 設定内容: ボールトがリカバリーポイントを保持する最小期間を日数で指定します。
  # 設定可能な値: 正の整数（日数）
  # 省略時: 最小保持期間の制約なし
  # 関連機能: 保持期間の強制
  #   この値を設定すると、リカバリーポイントは最小期間が経過するまで
  #   削除できません。WORMストレージ設定としても機能します。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/vault-lock.html
  min_retention_days = 7
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: バックアップボールト名
#
# - backup_vault_arn: バックアップボールトのAmazon Resource Name (ARN)
#---------------------------------------------------------------
