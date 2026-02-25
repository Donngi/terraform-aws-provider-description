#---------------------------------------
# Amazon FSx for NetApp ONTAP Storage Virtual Machine
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/fsx_ontap_storage_virtual_machine
#
# NOTE:
# ユースケース:
# - NetApp ONTAPファイルシステム上に論理的なストレージ境界を作成
# - マルチプロトコルファイル共有（NFS、SMB、iSCSI）の管理単位として使用
# - Active Directoryと統合したSMBアクセス制御の実装
# - 複数のアプリケーションやテナント間でのストレージの分離
#
# 注意事項:
# - 各SVMは独立した管理エンドポイントとネットワークインターフェースを持つ
# - ファイルシステムあたりのSVM数はスループット容量とネットワークタイプに依存
# - SVMの削除には全てのボリュームの事前削除が必要
# - root_volume_security_style は作成後の変更不可
# - svm_admin_password は機密情報として扱い、Secrets Manager等での管理を推奨
#
# 参考ドキュメント:
# - https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/managing-svms.html
# - https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/creating-svms.html

#---------------------------------------
# 基本設定
#---------------------------------------
resource "aws_fsx_ontap_storage_virtual_machine" "example" {
  # 設定内容: Storage Virtual Machineの名前（英数字とハイフンのみ使用可能）
  # 省略時: 省略不可（必須パラメータ）
  name = "svm-example"

  # 設定内容: SVMを作成するFSx for ONTAPファイルシステムのID
  # 省略時: 省略不可（必須パラメータ）
  file_system_id = aws_fsx_ontap_file_system.example.id

  #---------------------------------------
  # セキュリティとアクセス制御
  #---------------------------------------
  # 設定内容: SVMのルートボリュームに適用するセキュリティスタイル
  # 設定可能な値: UNIX / NTFS / MIXED
  # 省略時: UNIX（作成後の変更不可）
  root_volume_security_style = "UNIX"

  # 設定内容: SVM管理者（vsadmin）アカウントのパスワード（8文字以上、大文字・小文字・数字を含む）
  # 省略時: ランダムなパスワードが自動生成される
  svm_admin_password = "YourSecurePassword123!"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: このリソースを管理するAWSリージョンコード
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "ap-northeast-1"

  #---------------------------------------
  # Active Directory統合（SMBアクセス用）
  #---------------------------------------
  # active_directory_configuration {
  #   # 設定内容: Active DirectoryにおけるSVMのNetBIOS名（最大15文字）
  #   # 省略時: SVMの名前から自動生成される
  #   netbios_name = "SVM-EXAMPLE"

  #   self_managed_active_directory_configuration {
  #     # 設定内容: Active DirectoryのDNSサーバーIPアドレスのセット
  #     # 省略時: 省略不可（self_managed_active_directory_configuration使用時は必須）
  #     dns_ips = ["10.0.1.10", "10.0.2.10"]

  #     # 設定内容: Active Directoryのドメイン名（FQDN形式）
  #     # 省略時: 省略不可（self_managed_active_directory_configuration使用時は必須）
  #     domain_name = "example.com"

  #     # 設定内容: ドメイン参加用のサービスアカウントのユーザー名
  #     # 省略時: 省略不可（self_managed_active_directory_configuration使用時は必須）
  #     username = "admin"

  #     # 設定内容: ドメイン参加用のサービスアカウントのパスワード
  #     # 省略時: 省略不可（self_managed_active_directory_configuration使用時は必須）
  #     password = "YourDomainPassword123!"

  #     # 設定内容: SVMのコンピュータオブジェクトを配置するOrganizational Unit（OU）の識別名
  #     # 省略時: CN=Computers（デフォルトのコンピュータコンテナ）
  #     # organizational_unit_distinguished_name = "OU=Computers,DC=example,DC=com"

  #     # 設定内容: ファイルシステム管理者権限を持つActive Directoryグループ名
  #     # 省略時: "Domain Admins"グループが使用される
  #     # file_system_administrators_group = "FSx Admins"
  #   }
  # }

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: SVMに付与するタグのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-svm"
    Environment = "production"
    Workload    = "file-storage"
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------
  # timeouts {
  #   # 設定内容: SVMの作成完了を待つ最大時間
  #   # 省略時: 60分
  #   # create = "60m"

  #   # 設定内容: SVMの更新完了を待つ最大時間
  #   # 省略時: 60分
  #   # update = "60m"

  #   # 設定内容: SVMの削除完了を待つ最大時間
  #   # 省略時: 60分
  #   # delete = "60m"
  # }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# arn                     - SVMのAmazon Resource Name（ARN）
# id                      - SVMの一意な識別子（ファイルシステムID/SVMのID形式）
# uuid                    - SVMのUUID（Universally Unique Identifier）
# subtype                 - SVMのサブタイプ（"DEFAULT"等）
# tags_all                - デフォルトタグを含む全てのタグのマップ
# region                  - SVMが作成されるリージョン（デフォルトはプロバイダー設定のリージョン）
# endpoints               - SVMのプロトコル別エンドポイント情報のリスト
#   endpoints[0].iscsi[0].dns_name      - iSCSIプロトコル用のDNS名
#   endpoints[0].iscsi[0].ip_addresses  - iSCSIプロトコル用のIPアドレスセット
#   endpoints[0].management[0].dns_name      - 管理用のDNS名
#   endpoints[0].management[0].ip_addresses  - 管理用のIPアドレスセット
#   endpoints[0].nfs[0].dns_name      - NFSプロトコル用のDNS名
#   endpoints[0].nfs[0].ip_addresses  - NFSプロトコル用のIPアドレスセット
#   endpoints[0].smb[0].dns_name      - SMBプロトコル用のDNS名
#   endpoints[0].smb[0].ip_addresses  - SMBプロトコル用のIPアドレスセット
#
# 出力例:
# output "svm_id" {
#   value = aws_fsx_ontap_storage_virtual_machine.example.id
# }
# output "management_endpoint" {
#   value = aws_fsx_ontap_storage_virtual_machine.example.endpoints[0].management[0].dns_name
# }
