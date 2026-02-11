#---------------------------------------------------------------
# AWS Backup Global Settings
#---------------------------------------------------------------
#
# AWS Backupのグローバル設定を管理するリソースです。
# クロスアカウントバックアップ、マルチパーティ承認、委任管理者などの
# アカウント全体の設定を構成します。
#
# 注意: このリソースはAWS Organizations管理アカウントでのみ使用可能です。
#
# AWS公式ドキュメント:
#   - AWS Backup クロスアカウントバックアップ: https://docs.aws.amazon.com/aws-backup/latest/devguide/create-cross-account-backup.html
#   - UpdateGlobalSettings API: https://docs.aws.amazon.com/aws-backup/latest/devguide/API_UpdateGlobalSettings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_global_settings
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_backup_global_settings" "example" {
  #-------------------------------------------------------------
  # グローバル設定
  #-------------------------------------------------------------

  # global_settings (Required)
  # 設定内容: AWS Backupのアカウントレベルのグローバル設定をマップ形式で指定します。
  # 設定可能な値: 以下のキーと値のペアを含むマップ
  #   - "isCrossAccountBackupEnabled": クロスアカウントバックアップの有効化
  #     - "true": 有効（AWS Organizations内の他のアカウントへバックアップをコピー可能）
  #     - "false": 無効
  #   - "isMpaEnabled": マルチパーティ承認（Multi-Party Approval）の有効化
  #     - "true": 有効（重要な操作に複数の承認者が必要）
  #     - "false": 無効
  #   - "isDelegatedAdministratorEnabled": 委任管理者の有効化
  #     - "true": 有効（メンバーアカウントにバックアップ管理を委任可能）
  #     - "false": 無効
  # 関連機能: AWS Backup クロスアカウント管理
  #   AWS Organizations内でアカウント間のバックアップコピーを可能にし、
  #   災害復旧やデータ保護のシナリオに対応します。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/create-cross-account-backup.html
  # 注意: global_settingsに明示的に設定されていないサポート対象の設定は、
  #       perpetual differences（永続的な差分）が表示されます。
  #       これを避けるには、すべてのサポート対象オプションをデフォルト値
  #       （通常は"false"）で明示的に指定してください。
  global_settings = {
    "isCrossAccountBackupEnabled"     = "true"
    "isMpaEnabled"                    = "false"
    "isDelegatedAdministratorEnabled" = "false"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSアカウントID
#---------------------------------------------------------------
