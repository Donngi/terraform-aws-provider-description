################################################################################
# DataSync - Azure Blob Storage ロケーション
################################################################################
# AWS DataSyncでAzure Blob Storageをデータ転送元・転送先として利用するための
# ロケーション設定。DataSyncエージェント経由でAzureとAWS間のデータ移行や
# 同期を実行可能。SAS（Shared Access Signature）トークンによる認証をサポート。
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_azure_blob
#
# NOTE: SASトークンは機密情報のため、変数やSecrets Managerの使用を推奨

resource "aws_datasync_location_azure_blob" "example" {
  #-----------------------------------------------------------------------
  # 必須パラメータ
  #-----------------------------------------------------------------------
  # 設定内容: DataSyncエージェントのARNリスト
  # 設定可能な値: 有効なDataSyncエージェントARN（Azure Blob Storageへのアクセスが可能なエージェント）
  # 制約事項: 最低1つのエージェントが必要、複数指定で冗長性を確保
  agent_arns = [
    "arn:aws:datasync:us-east-1:123456789012:agent/agent-0123456789abcdef0",
  ]

  # 設定内容: 認証タイプ
  # 設定可能な値: SAS（Shared Access Signatureトークンを使用）
  # 制約事項: 現在はSASのみサポート
  authentication_type = "SAS"

  # 設定内容: Azure Blob StorageコンテナのURL
  # 設定可能な値: https://<storage-account>.blob.core.windows.net/<container> 形式
  # 制約事項: 有効なAzure Blob StorageコンテナURLが必要
  container_url = "https://mystorageaccount.blob.core.windows.net/mycontainer"

  #-----------------------------------------------------------------------
  # アクセス設定
  #-----------------------------------------------------------------------
  # sas_configuration {
  #   # 設定内容: Azure SAS（Shared Access Signature）トークン
  #   # 設定可能な値: 有効なSASトークン文字列（コンテナへのアクセス権限を持つ）
  #   # 制約事項: 読み取り/書き込み権限が必要、有効期限に注意
  #   # セキュリティ: 機密情報のため変数化推奨（var.azure_sas_token等）
  #   token = "sp=racwdl&st=2024-01-01T00:00:00Z&se=2024-12-31T23:59:59Z&spr=https&sv=2021-06-08&sr=c&sig=..."
  # }

  #-----------------------------------------------------------------------
  # Blob設定
  #-----------------------------------------------------------------------
  # 設定内容: Azure Blobアクセス層
  # 設定可能な値: HOT（頻繁アクセス）、COOL（低頻度アクセス）、ARCHIVE（アーカイブ）
  # 省略時: Azureストレージアカウントのデフォルト設定を使用
  access_tier = "HOT"

  # 設定内容: Azure Blobタイプ
  # 設定可能な値: BLOCK（ブロックBlob）
  # 省略時: BLOCKが使用される
  blob_type = "BLOCK"

  #-----------------------------------------------------------------------
  # パス設定
  #-----------------------------------------------------------------------
  # 設定内容: コンテナ内のサブディレクトリパス
  # 設定可能な値: 相対パス（例: data/imports、logs/2024）
  # 省略時: コンテナのルートディレクトリを使用
  subdirectory = "data/imports"

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------
  # 設定内容: リソース管理リージョン
  # 設定可能な値: AWSリージョンコード（us-east-1、ap-northeast-1等）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------
  # 設定内容: リソース識別用タグ
  # 設定可能な値: キー・バリューペアのマップ（最大50タグ）
  tags = {
    Name        = "azure-blob-location"
    Environment = "production"
    Purpose     = "data-migration"
  }
}

################################################################################
# Attributes Reference（参照専用属性）
################################################################################
# このリソースは以下の属性をエクスポートします:
#
# - arn
#   説明: DataSyncロケーションのARN
#   形式: arn:aws:datasync:region:account-id:location/location-id
#
# - id
#   説明: リソースID（ARNと同じ値）
#
# - uri
#   説明: ロケーションのURI
#   形式: azure-blob://<container-url>/<subdirectory>
#
# - tags_all
#   説明: デフォルトタグを含む全タグのマップ
#
# これらの属性は他リソースから参照可能:
#   aws_datasync_location_azure_blob.example.arn
#   aws_datasync_location_azure_blob.example.uri
