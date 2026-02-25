#---------------------------------------
# Amazon FSx Backup
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: file_system_idとvolume_idは排他的で、どちらか一方のみ指定可能
#
# Amazon FSxファイルシステムまたはボリュームのバックアップを管理するリソース
# LustreおよびWindowsファイルシステムのバックアップ、またはONTAPボリュームのバックアップに対応
# バックアップは暗号化され、複数のアベイラビリティーゾーンに冗長保存される
#
# 主な機能:
# - Lustre / Windowsファイルシステムの手動バックアップ作成
# - ONTAP個別ボリュームの手動バックアップ作成
# - バックアップへのタグ付けによる管理・分類
# - KMSによるバックアップデータの暗号化
# - クロスリージョンバックアップ管理
#
# ユースケース:
# - 定期的なデータ保護とディザスタリカバリ準備
# - システムメンテナンス前の状態保存
# - 長期保管が必要なデータのバックアップ取得
# - 別リージョンへの移行準備としてのバックアップ作成
# - ONTAPボリューム単位での細かい復旧ポイント作成
#
# 制約事項:
# - file_system_idとvolume_idは排他的で、どちらか一方のみ指定可能
# - file_system_idはLustreまたはWindowsファイルシステム用
# - volume_idはONTAPボリューム用
# - バックアップの削除には時間がかかる場合がある
# - Data Protection (DP)ボリュームなど一部ボリュームタイプはバックアップ対象外
#
# 参考資料:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_backup
# - https://docs.aws.amazon.com/fsx/latest/APIReference/API_Backup.html
# - https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/using-backups.html

#---------------------------------------
# Terraform設定
#---------------------------------------
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28.0"
    }
  }
}

#---------------------------------------
# Provider設定
#---------------------------------------
provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Environment = "production"
      ManagedBy   = "terraform"
    }
  }
}

#---------------------------------------
# FSx Backup基本設定
#---------------------------------------

# Lustre / WindowsファイルシステムのバックアップExample
resource "aws_fsx_backup" "example_filesystem" {
  # バックアップ対象設定
  # 設定内容: LustreまたはWindowsファイルシステムのID（file_system_idとvolume_idは排他）
  # 設定可能な値: 既存のFSx LustreまたはWindowsファイルシステムID (fs-xxxxxxxxxxxxxxxxx形式)
  # 省略時: 未設定（volume_idを指定する場合）
  file_system_id = "fs-0123456789abcdef0"

  # タグ設定
  # 設定内容: バックアップに付与するタグ（リソース管理・コスト配分用）
  # 設定可能な値: キーと値のペアを持つマップ
  # 省略時: タグなし（プロバイダーdefault_tagsは適用される）
  tags = {
    Name        = "fsx-lustre-backup"
    Purpose     = "disaster-recovery"
    Frequency   = "manual"
    RetainUntil = "2026-12-31"
  }
}

# ONTAPボリュームのバックアップExample
resource "aws_fsx_backup" "example_volume" {
  # ボリュームバックアップ対象設定
  # 設定内容: ONTAPボリュームのID（file_system_idとvolume_idは排他）
  # 設定可能な値: 既存のFSx ONTAP VolumeのID (fsvol-xxxxxxxxxxxxxxxxx形式)
  # 省略時: 未設定（file_system_idを指定する場合）
  volume_id = "fsvol-0123456789abcdef0"

  tags = {
    Name     = "ontap-volume-backup"
    VolumeId = "fsvol-0123456789abcdef0"
    Type     = "manual"
  }
}

#---------------------------------------
# リージョン管理設定
#---------------------------------------

# 特定リージョンで管理するバックアップ
resource "aws_fsx_backup" "cross_region" {
  file_system_id = "fs-0123456789abcdef0"

  # リージョン設定
  # 設定内容: バックアップを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード (us-east-1, ap-northeast-1など)
  # 省略時: プロバイダー設定のリージョン
  region = "us-west-2"

  tags = {
    Name          = "cross-region-backup"
    SourceRegion  = "ap-northeast-1"
    TargetRegion  = "us-west-2"
    BackupPurpose = "disaster-recovery"
  }
}

#---------------------------------------
# タイムアウト設定
#---------------------------------------

# タイムアウトカスタマイズExample
resource "aws_fsx_backup" "with_timeouts" {
  file_system_id = "fs-0123456789abcdef0"

  # タイムアウト設定
  timeouts {
    # 作成タイムアウト
    # 設定内容: バックアップ作成の最大待機時間
    # 設定可能な値: Go duration形式 (例: 30m, 1h, 90m)
    # 省略時: デフォルトタイムアウト値（大容量データの場合は長めに設定推奨）
    create = "90m"

    # 削除タイムアウト
    # 設定内容: バックアップ削除の最大待機時間
    # 設定可能な値: Go duration形式 (例: 10m, 30m)
    # 省略時: デフォルトタイムアウト値
    delete = "30m"
  }

  tags = {
    Name = "fsx-backup-with-timeouts"
  }
}

#---------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------
# このセクションの属性は読み取り専用で、リソース作成後に参照可能

# arn: バックアップのAmazon Resource Name (ARN)
output "backup_arn" {
  description = "FSxバックアップのARN"
  value       = aws_fsx_backup.example_filesystem.arn
}

# id: バックアップの一意識別子 (fs-xxxxxxxxxxxxxxxxx形式)
output "backup_id" {
  description = "バックアップID"
  value       = aws_fsx_backup.example_filesystem.id
}

# kms_key_id: バックアップデータ暗号化に使用されたKMSキーID
output "backup_kms_key_id" {
  description = "バックアップ暗号化に使用されたKMSキーID"
  value       = aws_fsx_backup.example_filesystem.kms_key_id
}

# owner_id: バックアップを作成したAWSアカウントID
output "backup_owner_id" {
  description = "バックアップ所有者のAWSアカウントID"
  value       = aws_fsx_backup.example_filesystem.owner_id
}

# tags_all: リソースに割り当てられた全タグ（プロバイダーdefault_tags含む）
output "backup_tags_all" {
  description = "バックアップの全タグ（default_tags含む）"
  value       = aws_fsx_backup.example_filesystem.tags_all
}

# type: バックアップのタイプ（USER_INITIATED, AUTOMATIC, AWS_BACKUPなど）
output "backup_type" {
  description = "バックアップのタイプ"
  value       = aws_fsx_backup.example_filesystem.type
}
