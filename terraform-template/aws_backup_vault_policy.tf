#---------------------------------------------------------------
# AWS Backup Vault Policy
#---------------------------------------------------------------
#
# AWS Backupのバックアップボルトにリソースベースのアクセスポリシーを
# 設定するリソースです。ボルトアクセスポリシーを使用することで、
# バックアップボルトおよびその中のリカバリポイントへのアクセス制御が可能です。
#
# AWS公式ドキュメント:
#   - Vault access policies: https://docs.aws.amazon.com/aws-backup/latest/devguide/create-a-vault-access-policy.html
#   - Access control: https://docs.aws.amazon.com/aws-backup/latest/devguide/access-control.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_backup_vault_policy" "example" {
  #-------------------------------------------------------------
  # ボルト設定
  #-------------------------------------------------------------

  # backup_vault_name (Required)
  # 設定内容: ポリシーを設定するバックアップボルトの名前を指定します。
  # 設定可能な値: 既存のバックアップボルト名
  # 注意: バックアップボルト名はAWSアカウントおよびリージョン内で一意である必要があります。
  backup_vault_name = aws_backup_vault.example.name

  #-------------------------------------------------------------
  # アクセスポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: バックアップボルトのアクセスポリシードキュメントをJSON形式で指定します。
  # 設定可能な値: 有効なIAMポリシードキュメント（JSON形式）
  # 関連機能: AWS Backup Vault Access Policy
  #   リソースベースのポリシーを使用してバックアップボルトへのアクセスを制御します。
  #   バックアッププランの作成、オンデマンドバックアップの作成権限を付与しつつ、
  #   リカバリポイントの削除を制限するなどの制御が可能です。
  #   - https://docs.aws.amazon.com/aws-backup/latest/devguide/create-a-vault-access-policy.html
  # 注意:
  #   - AWS Backupアクセスポリシーでは、Actionキーにワイルドカードを使用できません。
  #   - クロスアカウントアクセスでは、backup:CopyIntoBackupVault以外のアクションは拒否されます。
  #   - EBSやRDSスナップショットなど一部のバックアップタイプは、それぞれのサービスAPIでも
  #     アクセス可能なため、完全なアクセス制御にはIAMポリシーも別途設定が必要です。
  policy = data.aws_iam_policy_document.example.json

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
# 関連リソース（参考）
#---------------------------------------------------------------

# バックアップボルト
resource "aws_backup_vault" "example" {
  name = "example-vault"
}

# 現在のAWSアカウント情報
data "aws_caller_identity" "current" {}

# ボルトアクセスポリシードキュメント
data "aws_iam_policy_document" "example" {
  # 例: 特定のアカウントにバックアップボルトへのアクセスを許可
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    actions = [
      "backup:DescribeBackupVault",
      "backup:DeleteBackupVault",
      "backup:PutBackupVaultAccessPolicy",
      "backup:DeleteBackupVaultAccessPolicy",
      "backup:GetBackupVaultAccessPolicy",
      "backup:StartBackupJob",
      "backup:GetBackupVaultNotifications",
      "backup:PutBackupVaultNotifications",
    ]

    resources = [aws_backup_vault.example.arn]
  }

  # 例: リカバリポイントの削除を拒否（特定のユーザーを除く）
  # statement {
  #   effect = "Deny"
  #
  #   principals {
  #     type        = "*"
  #     identifiers = ["*"]
  #   }
  #
  #   actions = [
  #     "backup:DeleteRecoveryPoint",
  #   ]
  #
  #   resources = ["*"]
  #
  #   condition {
  #     test     = "StringNotEquals"
  #     variable = "aws:userId"
  #     values   = ["AIDA1234567890EXAMPLE"]
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: バックアップボルトの名前
#
# - backup_vault_arn: バックアップボルトのAmazon Resource Name (ARN)
#
#---------------------------------------------------------------
