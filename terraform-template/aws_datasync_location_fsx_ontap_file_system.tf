# ================================================================
# AWS DataSync Location FSx ONTAP File System
# Terraform Resource: aws_datasync_location_fsx_ontap_file_system
# ================================================================
#
# 生成日: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点の AWS Provider 仕様に基づいています。
#       最新の仕様については公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_fsx_ontap_file_system
# ================================================================

resource "aws_datasync_location_fsx_ontap_file_system" "example" {
  # ================================================================
  # Required Arguments
  # ================================================================

  # security_group_arns - (Required) セキュリティグループのARNのセット
  # ファイルシステムの優先サブネットへのアクセスを提供するセキュリティグループ
  # セキュリティグループは使用するプロトコルに応じて以下のポートへのアウトバウンドトラフィックを許可する必要があります:
  #   - Network File System (NFS): TCP ポート 111, 635, 2049
  #   - Server Message Block (SMB): TCP ポート 445
  # 型: set(string)
  # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/create-ontap-location.html
  security_group_arns = ["arn:aws:ec2:us-east-1:123456789012:security-group/sg-12345678"]

  # storage_virtual_machine_arn - (Required) Storage Virtual Machine (SVM) の ARN
  # データのコピー元またはコピー先となる、ファイルシステム内の SVM の ARN を指定します
  # 型: string
  # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationFsxOntap.html
  storage_virtual_machine_arn = "arn:aws:fsx:us-east-1:123456789012:storage-virtual-machine/fs-0123456789abcdef0/svm-0123456789abcdef0"

  # ================================================================
  # Required Block: protocol
  # ================================================================
  # DataSync が Amazon FSx ファイルシステムにアクセスするために使用するデータ転送プロトコル
  # NFS または SMB のいずれかを指定します（両方を指定することはできません）
  # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/API_FsxProtocol.html

  protocol {
    # ----------------------------------------------------------------
    # NFS Protocol Configuration (NFSまたはSMBのいずれか一方を選択)
    # ----------------------------------------------------------------
    # Network File System (NFS) プロトコル
    # DataSync が FSx ONTAP ファイルシステムにアクセスするために使用します
    # DataSync は AUTH_SYS セキュリティメカニズムを使用し、UID と GID を 0 として認証します
    # 注意: DataSync は NFS バージョン 3 のみをサポートしており、作成後は変更できません
    # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/create-ontap-location.html
    nfs {
      # mount_options - (Required) NFS ロケーションにアクセスするためのマウントオプション
      mount_options {
        # version - (Optional) NFS 共有のマウントに使用する特定の NFS バージョン
        # 有効な値: "NFS3"
        # デフォルト: "NFS3"
        # 型: string
        # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/API_NfsMountOptions.html
        version = "NFS3"
      }
    }

    # ----------------------------------------------------------------
    # SMB Protocol Configuration (NFSまたはSMBのいずれか一方を選択)
    # ----------------------------------------------------------------
    # Server Message Block (SMB) プロトコル
    # DataSync が FSx ONTAP ファイルシステムにアクセスするために使用します
    # DataSync は SMB バージョン 2.1, 3.0.2, 3.1.1 をサポートしています
    # セキュリティ上の理由から、バージョン 3.0.2 以降を推奨します
    # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/create-ontap-location.html
    # smb {
    #   # user - (Required) SVM をマウントし、必要なファイル、フォルダ、メタデータにアクセスできるユーザー名
    #   # 型: string
    #   user = "admin"
    #
    #   # password - (Required) SVM へのアクセス権限を持つユーザーのパスワード
    #   # センシティブな値として扱われます
    #   # 型: string (sensitive)
    #   password = "YourPassword123!"
    #
    #   # domain - (Optional) Storage Virtual Machine が属する Microsoft Active Directory (AD) の完全修飾ドメイン名
    #   # 型: string
    #   # domain = "corp.example.com"
    #
    #   # mount_options - (Required) SMB ロケーションにアクセスするためのマウントオプション
    #   mount_options {
    #     # version - (Optional) SMB 共有のマウントに使用する SMB バージョン
    #     # 有効な値: "AUTOMATIC", "SMB3", "SMB2", "SMB2_0"
    #     # デフォルト: "AUTOMATIC"
    #     # 型: string
    #     # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/API_SmbMountOptions.html
    #     version = "AUTOMATIC"
    #   }
    # }
  }

  # ================================================================
  # Optional Arguments
  # ================================================================

  # subdirectory - (Optional) データをコピーする SVM 内のファイル共有へのパス
  # 以下のいずれかを指定できます:
  #   - ジャンクションパス（マウントポイント）: "/vol1"
  #   - qtree パス（NFS ファイル共有の場合）: "/vol1/tree1"
  #   - 共有名（SMB ファイル共有の場合）: "share1"
  # 注意: SVM のルートボリューム内のジャンクションパスは指定できません
  # 型: string
  # デフォルト: "/"
  # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationFsxOntap.html
  subdirectory = "/vol1"

  # id - (Optional) リソースの一意の識別子
  # 通常は Terraform によって自動的に生成されるため、明示的に設定する必要はありません
  # 型: string
  # id = "datasync-location-12345678"

  # region - (Optional) このリソースが管理されるリージョン
  # 指定しない場合、プロバイダー設定で設定されたリージョンがデフォルトとして使用されます
  # 型: string
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - (Optional) DataSync ロケーションに割り当てるリソースタグのキーと値のペア
  # プロバイダーの default_tags 設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします
  # 型: map(string)
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-datasync-fsx-ontap-location"
    Environment = "production"
  }

  # tags_all - (Optional) デフォルトタグを含む、リソースに割り当てられたすべてのタグのマップ
  # 通常は明示的に設定する必要はなく、プロバイダーの default_tags と tags を組み合わせたものが自動的に管理されます
  # 型: map(string)
  # tags_all = {}

  # ================================================================
  # Computed Attributes (Read-Only)
  # ================================================================
  # 以下の属性は Terraform によって自動的に計算され、参照のみ可能です:
  #
  # - arn (string)
  #     DataSync Location for FSx ONTAP File System の ARN
  #
  # - creation_time (string)
  #     ロケーションの作成日時（タイムスタンプ）
  #
  # - fsx_filesystem_arn (string)
  #     FSx ONTAP File System の ARN
  #
  # - uri (string)
  #     FSx ONTAP ファイルシステムロケーションの URI
  #     例: "fsxn://svm-0123456789abcdef0.fs-0123456789abcdef0.fsx.us-east-1.amazonaws.com/vol1"
  # ================================================================
}

# ================================================================
# Output Examples
# ================================================================

output "datasync_location_arn" {
  description = "DataSync FSx ONTAP ロケーションの ARN"
  value       = aws_datasync_location_fsx_ontap_file_system.example.arn
}

output "datasync_location_uri" {
  description = "DataSync FSx ONTAP ロケーションの URI"
  value       = aws_datasync_location_fsx_ontap_file_system.example.uri
}

output "fsx_filesystem_arn" {
  description = "関連付けられた FSx ONTAP ファイルシステムの ARN"
  value       = aws_datasync_location_fsx_ontap_file_system.example.fsx_filesystem_arn
}
