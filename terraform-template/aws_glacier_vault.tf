################################################################################
# AWS Glacier Vault
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glacier_vault
#
# Glacier Vaultは、AWSのアーカイブストレージサービスであるAmazon Glacierで
# データを保存するためのコンテナです。長期保存が必要なデータを低コストで
# 保管でき、データの取得には数時間を要します。
#
# 重要な注意事項:
# - Vaultを削除する際は、事前にVault内のすべてのアーカイブを削除する必要があります
# - Amazon Glacierは新規顧客を受け付けておらず、既存顧客向けのサービスです
# - 新しいアーカイブストレージのニーズには、Amazon S3 Glacierストレージクラスの使用が推奨されます
################################################################################

resource "aws_glacier_vault" "example" {
  #--------------------------------------------------------------
  # 必須パラメータ
  #--------------------------------------------------------------

  # name - (必須) Vaultの名前
  # 1〜255文字で、使用可能な文字は a-z, A-Z, 0-9, '_' (アンダースコア),
  # '-' (ハイフン), '.' (ピリオド) です
  # 例: "MyArchiveVault", "company-archive-2024"
  name = "example-glacier-vault"

  #--------------------------------------------------------------
  # オプションパラメータ
  #--------------------------------------------------------------

  # region - (オプション) このリソースを管理するリージョン
  # デフォルトはプロバイダー設定のリージョンです
  # 例: "us-east-1", "eu-west-1"
  # region = "us-east-1"

  # access_policy - (オプション) VaultのアクセスポリシードキュメントをJSON形式で指定
  # Vaultへのアクセス権限を制御するために使用します
  # heredoc構文やfile関数を使用すると便利です
  # 参考: https://docs.aws.amazon.com/amazonglacier/latest/dev/vault-access-policy.html
  #
  # 例: 特定のアカウントからの読み取りアクセスを許可
  # access_policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Sid    = "add-read-only-perm"
  #       Effect = "Allow"
  #       Principal = {
  #         AWS = "*"
  #       }
  #       Action = [
  #         "glacier:InitiateJob",
  #         "glacier:GetJobOutput"
  #       ]
  #       Resource = "arn:aws:glacier:us-east-1:123456789012:vaults/MyArchive"
  #     }
  #   ]
  # })
  # access_policy = data.aws_iam_policy_document.glacier_vault.json

  # notification - (オプション) Vaultの通知設定
  # アーカイブの取得完了やインベントリの取得完了時にSNS通知を送信します
  #
  # notification {
  #   # sns_topic - (必須) 通知を送信するSNSトピックのARN
  #   # 例: "arn:aws:sns:us-east-1:123456789012:glacier-notifications"
  #   sns_topic = aws_sns_topic.glacier_notifications.arn
  #
  #   # events - (必須) 通知するイベントのリスト
  #   # 有効な値:
  #   # - "ArchiveRetrievalCompleted" : アーカイブの取得が完了したとき
  #   # - "InventoryRetrievalCompleted" : インベントリの取得が完了したとき
  #   events = [
  #     "ArchiveRetrievalCompleted",
  #     "InventoryRetrievalCompleted"
  #   ]
  # }

  # tags - (オプション) リソースに割り当てるタグのマップ
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグは上書きされます
  tags = {
    Name        = "example-glacier-vault"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

################################################################################
# Outputs (参照用の出力値)
################################################################################

# location - 作成されたVaultのURI
# 例: "/123456789012/vaults/example-glacier-vault"
output "glacier_vault_location" {
  description = "The URI of the vault that was created"
  value       = aws_glacier_vault.example.location
}

# arn - VaultのARN
# 例: "arn:aws:glacier:us-east-1:123456789012:vaults/example-glacier-vault"
output "glacier_vault_arn" {
  description = "The ARN of the vault"
  value       = aws_glacier_vault.example.arn
}

# tags_all - プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
# リソースに割り当てられたすべてのタグのマップ
output "glacier_vault_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_glacier_vault.example.tags_all
}

################################################################################
# 使用例とベストプラクティス
################################################################################

# 1. 通知設定付きのVault
#
# resource "aws_sns_topic" "glacier_notifications" {
#   name = "glacier-notifications"
# }
#
# resource "aws_glacier_vault" "with_notifications" {
#   name = "my-archive-vault"
#
#   notification {
#     sns_topic = aws_sns_topic.glacier_notifications.arn
#     events    = ["ArchiveRetrievalCompleted", "InventoryRetrievalCompleted"]
#   }
#
#   tags = {
#     Name = "my-archive-vault"
#   }
# }

# 2. アクセスポリシー付きのVault
#
# data "aws_iam_policy_document" "glacier_vault_policy" {
#   statement {
#     sid    = "cross-account-upload"
#     effect = "Allow"
#
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::111122223333:root"]
#     }
#
#     actions = [
#       "glacier:UploadArchive",
#       "glacier:InitiateMultipartUpload",
#       "glacier:AbortMultipartUpload",
#       "glacier:CompleteMultipartUpload"
#     ]
#
#     resources = ["arn:aws:glacier:us-east-1:123456789012:vaults/MyArchive"]
#   }
# }
#
# resource "aws_glacier_vault" "with_policy" {
#   name          = "shared-archive-vault"
#   access_policy = data.aws_iam_policy_document.glacier_vault_policy.json
#
#   tags = {
#     Name = "shared-archive-vault"
#   }
# }

################################################################################
# 追加情報とドキュメント
################################################################################

# Amazon Glacier Vault機能の詳細:
# - データ取得ポリシー: https://docs.aws.amazon.com/amazonglacier/latest/dev/data-retrieval-policy.html
# - Vaultインベントリ: https://docs.aws.amazon.com/amazonglacier/latest/dev/vault-inventory.html
# - アーカイブ取得オプション:
#   * Expedited: 1-5分 (追加料金、プロビジョニング容量の購入可能)
#   * Standard: 3-5時間 (標準オプション)
#   * Bulk: 5-12時間 (最も低コスト)
#
# 重要な考慮事項:
# - Vaultの削除前に、すべてのアーカイブを削除する必要があります
# - データ取得ポリシーにより、取得コストを制御できます:
#   * No Retrieval Limit: すべての有効な取得リクエストを許可(デフォルト)
#   * Free Tier Only: 無料枠内の取得に制限
#   * Max Retrieval Rate: 時間あたりのバイト数で取得レートを制限
# - Vaultインベントリは少なくとも1日1回更新されます
# - SNS通知を設定することで、取得ジョブの完了を監視できます
