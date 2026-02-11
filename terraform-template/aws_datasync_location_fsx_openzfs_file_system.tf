#---------------------------------------------------------------
# AWS DataSync FSx for OpenZFS ロケーション
#---------------------------------------------------------------
#
# AWS DataSync用のAmazon FSx for OpenZFSファイルシステムの転送ロケーションを管理します。
# DataSyncは、データ転送のソースまたはデスティネーションとしてこのロケーションを使用できます。
# FSx for OpenZFSファイルシステムには、NFSクライアントとしてアクセスし、
# ファイルシステムメタデータ（所有権、タイムスタンプ、アクセス許可）を含むデータを転送できます。
#
# AWS公式ドキュメント:
#   - Configuring DataSync transfers with Amazon FSx for OpenZFS: https://docs.aws.amazon.com/datasync/latest/userguide/create-openzfs-location.html
#   - CreateLocationFsxOpenZfs API: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationFsxOpenZfs.html
#   - Migrating files to FSx for OpenZFS using DataSync: https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/migrate-files-to-fsx-datasync.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_fsx_openzfs_file_system
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_datasync_location_fsx_openzfs_file_system" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # FSx for OpenZFSファイルシステムのARN
  # - 転送ロケーションとして使用するFSx for OpenZFSファイルシステムを指定します
  # - 形式: arn:aws:fsx:region:account-id:file-system/filesystem-id
  # - DataSyncはこのファイルシステムにNFSクライアントとしてアクセスします
  fsx_filesystem_arn = "arn:aws:fsx:us-east-1:123456789012:file-system/fs-0123456789abcdef0"

  # セキュリティグループのARN
  # - FSx for OpenZFSファイルシステムへのネットワークアクセスを提供するセキュリティグループを指定します
  # - 最大5つまで指定可能
  # - DataSyncが作成するネットワークインターフェースに適用されます
  # - FSx for OpenZFSファイルシステムが使用するネットワークポートへのアクセスを許可する必要があります
  security_group_arns = ["arn:aws:ec2:us-east-1:123456789012:security-group/sg-0123456789abcdef0"]

  # プロトコル設定
  # - DataSyncがファイルシステムへのアクセスに使用するプロトコルを指定します
  # - 現在はNFSのみサポートされています
  protocol {
    nfs {
      # NFSマウントオプション
      # - DataSyncがNFSロケーションにアクセスする際のマウントオプションを設定します
      mount_options {
        # NFSバージョン
        # - DataSyncが使用するNFSバージョンを指定します
        # - 指定可能な値: AUTOMATIC（デフォルト）, NFS3, NFS4_0, NFS4_1
        # - AUTOMATIC: DataSyncが最適なNFSバージョンを自動選択（デフォルトはNFS4.1）
        # - NFS3: NFSバージョン3を使用（レイテンシー改善に有効な場合があります）
        # - NFS4_0: NFSバージョン4.0を使用
        # - NFS4_1: NFSバージョン4.1を使用
        version = "AUTOMATIC"
      }
    }
  }

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # サブディレクトリ
  # - ロケーションのパス内のサブディレクトリを指定します
  # - /fsxで始まる必要があります
  # - ソースとして使用される場合、DataSyncはこのマウントパスからデータを読み取ります
  # - デスティネーションとして使用される場合、DataSyncはすべてのデータをこのマウントパスに書き込みます
  # - 指定しない場合、DataSyncはルートボリュームディレクトリ（/fsx）を使用します
  # subdirectory = "/fsx/data"

  # リージョン
  # - このリソースを管理するAWSリージョンを指定します
  # - 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # region = "us-east-1"

  # タグ
  # - DataSyncロケーションに割り当てるリソースタグを指定します
  # - キー/値のペアで管理、フィルタリング、検索に使用できます
  # - プロバイダーのdefault_tags設定ブロックが存在する場合、
  #   キーが一致するタグは上書きされます
  tags = {
    Name        = "example-datasync-openzfs-location"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（設定不可）:
#
# - id: DataSyncロケーションのAmazon Resource Name (ARN)
# - arn: DataSyncロケーションのAmazon Resource Name (ARN)
# - uri: 記述されたFSx for OpenZFSロケーションのURL
# - creation_time: FSx for OpenZFSロケーションが作成された時刻
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# 使用例:
# output "datasync_location_arn" {
#   value = aws_datasync_location_fsx_openzfs_file_system.example.arn
# }
# output "datasync_location_uri" {
#   value = aws_datasync_location_fsx_openzfs_file_system.example.uri
# }
#---------------------------------------------------------------
