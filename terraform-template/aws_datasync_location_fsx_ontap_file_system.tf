#---------------------------------------
# AWS DataSync FSx for ONTAP ファイルシステムロケーション
#---------------------------------------
# DataSyncタスクのソースまたはターゲットとして使用するFSx for ONTAPファイル
# システムのロケーションを定義します。NFSまたはSMBプロトコルに対応し、
# Storage Virtual Machine（SVM）経由でデータ転送を実行します。
#
# 主な用途:
#   - FSx for ONTAPとS3/EFS間のデータ同期
#   - オンプレミスストレージからFSx for ONTAPへの移行
#   - マルチプロトコル環境でのデータ転送
#
# 制限事項:
#   - NFSまたはSMBいずれか一方のプロトコルのみ指定可能
#   - セキュリティグループは同一VPC内のENI用に設定が必要
#   - SMB使用時はドメイン参加済みSVMが必要
#
# Provider Version: 6.28.0
# Generated: 2026-02-14
#
# NOTE:
#   - プロトコル設定（protocol）は必須で、nfsまたはsmbいずれか一方を選択
#   - SMB使用時はpasswordがsensitive属性のため、Terraformステートに暗号化保存される
#   - セキュリティグループはFSx for ONTAPと同じVPCに配置し、必要なポートを許可すること
#
# 関連ドキュメント:
#   https://docs.aws.amazon.com/ja_jp/datasync/latest/userguide/create-ontap-location.html
#   https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/datasync_location_fsx_ontap_file_system
#---------------------------------------

#---------------------------------------
# リソース定義
#---------------------------------------
resource "aws_datasync_location_fsx_ontap_file_system" "example" {
  #---------------------------------------
  # Storage Virtual Machine設定
  #---------------------------------------
  # 設定内容: DataSync接続先となるFSx for ONTAP Storage Virtual Machine（SVM）のARN
  # 形式: arn:aws:fsx:region:account-id:storage-virtual-machine/fs-xxxxx/svm-xxxxx
  # 備考: SVMは事前に作成され、NFSまたはSMB用に構成されている必要がある
  storage_virtual_machine_arn = "arn:aws:fsx:ap-northeast-1:123456789012:storage-virtual-machine/fs-0123456789abcdef0/svm-0123456789abcdef0"

  #---------------------------------------
  # ネットワーク設定
  #---------------------------------------
  # 設定内容: DataSyncがFSx for ONTAPへの接続に使用するElastic Network Interface（ENI）用セキュリティグループのARN
  # 形式: 1個以上のARNを指定（set形式）
  # 必須条件: FSx for ONTAPファイルシステムと同じVPC内のセキュリティグループ
  # ポート要件:
  #   - NFS: TCP 111, 635, 2049, 4045, 4046
  #   - SMB: TCP 139, 445
  security_group_arns = [
    "arn:aws:ec2:ap-northeast-1:123456789012:security-group/sg-0123456789abcdef0"
  ]

  #---------------------------------------
  # プロトコル設定（NFSまたはSMB）
  #---------------------------------------
  protocol {
    #---------------------------------------
    # NFS設定（NFSプロトコル使用時）
    #---------------------------------------
    # 備考: NFSとSMBは排他的で、いずれか一方のみ設定可能
    nfs {
      mount_options {
        # 設定内容: NFSプロトコルバージョン
        # 設定可能な値:
        #   - AUTOMATIC（推奨）: DataSyncが自動的にバージョンを選択
        #   - NFS3: NFSv3を使用
        #   - NFS4_0: NFSv4.0を使用
        #   - NFS4_1: NFSv4.1を使用
        # 省略時: AUTOMATIC
        # 備考: ONTAPはNFSv3/v4.0/v4.1をサポート
        version = "AUTOMATIC"
      }
    }

    #---------------------------------------
    # SMB設定（SMBプロトコル使用時）
    #---------------------------------------
    # 備考: Active Directoryドメインに参加済みのSVMが必要
    # smb {
    #   # 設定内容: SMB共有へのアクセスに使用するユーザー名
    #   # 形式: domain\username または username@domain.com
    #   # 権限: 共有への読み取り/書き込み権限が必要
    #   user = "DOMAIN\\datasync-user"
    #
    #   # 設定内容: SMBユーザーのパスワード
    #   # セキュリティ: Terraformステートに暗号化されて保存（sensitive属性）
    #   # 推奨: AWS Secrets Managerやvault経由で管理
    #   password = "YourSecurePassword123!"
    #
    #   # 設定内容: SMBユーザーが所属するActive Directoryドメイン名（FQDN）
    #   # 形式: example.com
    #   # 省略時: SVMのドメイン設定を使用
    #   # 備考: SVMが既にドメイン参加済みの場合は省略可能
    #   domain = "example.com"
    #
    #   mount_options {
    #     # 設定内容: SMBプロトコルバージョン
    #     # 設定可能な値:
    #     #   - AUTOMATIC（推奨）: DataSyncが自動選択
    #     #   - SMB2: SMB 2.xを使用
    #     #   - SMB3: SMB 3.xを使用
    #     # 省略時: AUTOMATIC
    #     # 備考: セキュリティ要件に応じてSMB3推奨
    #     version = "AUTOMATIC"
    #   }
    # }
  }

  #---------------------------------------
  # パス設定
  #---------------------------------------
  # 設定内容: SVMボリューム内のサブディレクトリパス
  # 形式: /path/to/directory（先頭スラッシュ必須）
  # 省略時: SVMのルートパス（/）
  # 用途: ボリューム内の特定ディレクトリのみを同期対象にする場合
  subdirectory = "/data/sync"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: DataSyncロケーションを管理するAWSリージョン
  # 省略時: プロバイダーのリージョン設定を使用
  # 用途: クロスリージョンでのDataSync実行時に明示的指定
  region = "ap-northeast-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: DataSyncロケーションに付与するタグ（キー/値ペア）
  # 用途: コスト配分、リソース管理、アクセス制御
  tags = {
    Name        = "datasync-ontap-location"
    Environment = "production"
    DataSource  = "fsx-ontap"
    Protocol    = "nfs"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースから参照可能な主要属性:
#
# arn                    : DataSyncロケーションのARN（DataSyncタスク定義で使用）
# uri                    : ロケーションのURI（形式: fsxn://svm-id.fs-id.fsx.region.amazonaws.com/path）
# fsx_filesystem_arn     : 親FSx for ONTAPファイルシステムのARN
# creation_time          : ロケーション作成日時（RFC3339形式）
# tags_all               : デフォルトタグとリソースタグをマージした全タグ
#---------------------------------------
