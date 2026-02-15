#-----------------------------------------------
# DataSync FSx Windows File System Location
#-----------------------------------------------
# 用途: DataSyncでFSx for Windows File Serverファイルシステムへのデータ転送ロケーションを作成
# 機能: WindowsファイルシステムをDataSyncタスクの転送元または転送先として構成
#
# 主な機能:
#   - FSx Windows File Serverロケーション定義
#   - Active Directory統合によるアクセス制御
#   - セキュリティグループによるネットワーク制御
#   - サブディレクトリ指定による転送範囲制御
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_fsx_windows_file_system
# AWS Documentation: https://docs.aws.amazon.com/datasync/latest/userguide/create-fsx-location.html
# Generated: 2026-02-14
#
# NOTE: このテンプレートは必要に応じてカスタマイズしてください

#-----------------------------------------------
# 必須設定
#-----------------------------------------------

# 設定内容: DataSyncがアクセスするFSx for Windows File SystemのARN
# 補足: FSx Windows File Serverファイルシステムを転送元または転送先として使用
fsx_filesystem_arn = "arn:aws:fsx:ap-northeast-1:123456789012:file-system/fs-0123456789abcdef0"

# 設定内容: FSxファイルシステムへのアクセスに使用するActive Directoryユーザー名
# 補足: ファイルシステムへの読み取り/書き込み権限を持つドメインユーザー
# 注意: バックスラッシュまたはフォワードスラッシュでドメイン名を含める（例: DOMAIN\user または user@domain.com）
user = "CORP\\datasync-user"

# 設定内容: Active Directoryユーザーのパスワード
# 補足: Terraformステートファイルで暗号化されて保存される機密情報
# 注意: 変数またはシークレット管理サービスからの参照を推奨
password = "changeme-secure-password"

# 設定内容: DataSyncがFSxファイルシステムにアクセスするために使用するセキュリティグループのARNリスト
# 補足: FSxファイルシステムが存在するVPC内のセキュリティグループを指定
# 必須ポート: インバウンドTCP 445（SMB）、TCP 135（RPC）、TCP 49152-65535（動的RPCポート）
security_group_arns = [
  "arn:aws:ec2:ap-northeast-1:123456789012:security-group/sg-0123456789abcdef0"
]

#-----------------------------------------------
# Active Directory統合
#-----------------------------------------------

# 設定内容: FSxファイルシステムが参加しているActive DirectoryのFQDN
# 補足: FSxファイルシステムがActive Directoryに参加している場合に指定
# 省略時: FSxファイルシステムの設定から自動検出を試みる
domain = "corp.example.com"

#-----------------------------------------------
# 転送範囲制御
#-----------------------------------------------

# 設定内容: FSxファイルシステム内の転送対象サブディレクトリ
# 補足: バックスラッシュ（\）で区切られたWindowsパス形式で指定
# 省略時: ファイルシステムのルートディレクトリ
# 形式: \share\folder または空文字列でルート
subdirectory = "\\share\\data"

#-----------------------------------------------
# リージョン設定
#-----------------------------------------------

# 設定内容: このロケーションを管理するAWSリージョン
# 補足: FSxファイルシステムと同じリージョンを指定する必要がある
# 省略時: プロバイダー設定のリージョンを使用
region = "ap-northeast-1"

#-----------------------------------------------
# タグ設定
#-----------------------------------------------

# 設定内容: ロケーションに付与するタグ
# 補足: リソース管理、コスト配分、アクセス制御に使用
tags = {
  Name        = "datasync-fsx-windows-location"
  Environment = "production"
  ManagedBy   = "terraform"
}

#-----------------------------------------------
# Terraform設定ブロック
#-----------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28.0"
    }
  }
}

#-----------------------------------------------
# リソース定義
#-----------------------------------------------

resource "aws_datasync_location_fsx_windows_file_system" "example" {
  fsx_filesystem_arn  = var.fsx_filesystem_arn
  user                = var.user
  password            = var.password
  security_group_arns = var.security_group_arns

  domain       = var.domain
  subdirectory = var.subdirectory
  region       = var.region
  tags         = var.tags
}

#-----------------------------------------------
# 変数定義
#-----------------------------------------------

variable "fsx_filesystem_arn" {
  description = "FSx for Windows File SystemのARN"
  type        = string
}

variable "user" {
  description = "FSxファイルシステムへのアクセスに使用するActive Directoryユーザー名"
  type        = string
}

variable "password" {
  description = "Active Directoryユーザーのパスワード"
  type        = string
  sensitive   = true
}

variable "security_group_arns" {
  description = "DataSyncがFSxファイルシステムにアクセスするために使用するセキュリティグループのARNリスト"
  type        = set(string)
}

variable "domain" {
  description = "Active DirectoryのFQDN"
  type        = string
  default     = null
}

variable "subdirectory" {
  description = "転送対象サブディレクトリ"
  type        = string
  default     = null
}

variable "region" {
  description = "ロケーションを管理するAWSリージョン"
  type        = string
  default     = null
}

variable "tags" {
  description = "リソースタグ"
  type        = map(string)
  default     = {}
}

#-----------------------------------------------
# 出力値
#-----------------------------------------------

output "datasync_location_arn" {
  description = "DataSyncロケーションのARN"
  value       = aws_datasync_location_fsx_windows_file_system.example.arn
}

output "datasync_location_uri" {
  description = "DataSyncロケーションのURI"
  value       = aws_datasync_location_fsx_windows_file_system.example.uri
}

output "datasync_location_creation_time" {
  description = "ロケーションの作成日時"
  value       = aws_datasync_location_fsx_windows_file_system.example.creation_time
}

#-----------------------------------------------
# Attributes Reference
#-----------------------------------------------
# arn           - DataSyncロケーションのARN
# uri           - ロケーションのURI（smb://形式）
# creation_time - ロケーションの作成日時（RFC3339形式）
# id            - ロケーションのARN（arnと同じ）
# tags_all      - デフォルトタグを含む全てのタグ
