#---------------------------------------------------------------
# Amazon FSx for NetApp ONTAP Storage Virtual Machine (SVM)
#---------------------------------------------------------------
#
# FSx for ONTAP では、ストレージ仮想マシン（SVM）と呼ばれる仮想ファイルサーバー上でボリュームがホストされます。
# SVM は、独自の管理クレデンシャルとエンドポイントを持つ分離されたファイルサーバーです。
# クライアントとワークステーションは、SVM のエンドポイント（IP アドレス）を使用して、
# SVM 上でホストされているボリューム、SMB 共有、または iSCSI LUN にアクセスします。
#
# AWS公式ドキュメント:
#   - Managing FSx for ONTAP storage virtual machines: https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/managing-svms.html
#   - Creating storage virtual machines: https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/creating-svms.html
#   - StorageVirtualMachine API Reference: https://docs.aws.amazon.com/fsx/latest/APIReference/API_StorageVirtualMachine.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_ontap_storage_virtual_machine
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_fsx_ontap_storage_virtual_machine" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # file_system_id - (必須) この SVM を作成する Amazon FSx ONTAP ファイルシステムの ID
  # FSx ONTAP ファイルシステムのリソースID（例: fs-0123456789abcdef0）を指定します。
  file_system_id = "fs-0123456789abcdef0"

  # name - (必須) SVM の名前
  # 最大 47 文字の英数字とアンダースコア（_）を使用できます。
  # この名前は DNS 名や管理エンドポイントのアクセスに使用されます。
  name = "example-svm"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # region - (オプション) このリソースが管理されるリージョン
  # デフォルトではプロバイダー設定のリージョンが使用されます。
  # 特定のリージョンでリソースを明示的に管理したい場合に指定します。
  # region = "us-west-2"

  # root_volume_security_style - (オプション) ルートボリュームのセキュリティスタイル
  # 有効な値: UNIX、NTFS、MIXED
  # この SVM 配下に作成される全てのボリュームは、ボリューム作成時に明示的に
  # 指定しない限り、このルートセキュリティスタイルを継承します。
  # - UNIX: UNIX/Linux クライアント、NFS アクセス、Unix ユーザーを使用する
  #         アプリケーションに適しています。UNIX パーミッション（mode bits）を使用します。
  # - NTFS: Windows クライアント、SMB アクセス、Windows ユーザーを使用する
  #         アプリケーションに適しています。NTFS ACL を使用します。
  # - MIXED: NFS と SMB の両方のアクセスをサポートします。
  # デフォルト値: UNIX
  # root_volume_security_style = "UNIX"

  # svm_admin_password - (オプション) SVM 管理エンドポイントへの SSH 接続時に使用するパスワード
  # このパスワードを指定すると、SSH 経由で SVM に接続し、NetApp ONTAP CLI または
  # REST API を使用して SVM を管理できます。
  # パスワードを指定しない場合でも、ファイルシステムの fsxadmin ユーザーを
  # 使用して SVM を管理できます。
  # 注: このパラメータは sensitive として扱われ、Terraform の出力では表示されません。
  # svm_admin_password = "YourSecurePassword123!"

  # tags - (オプション) ストレージ仮想マシンに割り当てるタグのマップ
  # プロバイダーレベルで default_tags 設定ブロックが存在する場合、
  # 同じキーを持つタグはここで定義した値で上書きされます。
  # tags = {
  #   Name        = "example-svm"
  #   Environment = "production"
  #   ManagedBy   = "terraform"
  # }

  # tags_all - (オプション) リソースに割り当てられた全てのタグ
  # プロバイダーの default_tags から継承されたタグを含みます。
  # 通常、このパラメータは明示的に設定する必要はありません。
  # Terraform がプロバイダー設定と tags パラメータから自動的に管理します。
  # tags_all = {}

  # id - (オプション) Terraform によって自動生成されるリソース識別子
  # 通常、このパラメータを明示的に設定する必要はありません。
  # SVM の ID（例: svm-0123456789abcdef0）は作成後に自動的に割り当てられます。
  # id = null

  #---------------------------------------------------------------
  # ネストブロック: active_directory_configuration
  #---------------------------------------------------------------
  # Microsoft Active Directory に SVM を参加させるための設定
  # このブロックを指定することで、SVM を既存の Active Directory ドメインに
  # 参加させ、ファイルアクセスの認証と承認を行うことができます。
  # SMB プロトコルを使用する場合に必要です。

  # active_directory_configuration {
  #   # netbios_name - (オプション) Active Directory に作成されるコンピュータオブジェクトの NetBIOS 名
  #   # 多くの場合、これは SVM 名と同じですが、異なる名前を設定することも可能です。
  #   # AWS では、標準的な NetBIOS 命名の制限により、15 文字に制限されています。
  #   netbios_name = "EXAMPLESVM"
  #
  #   # self_managed_active_directory_configuration - (オプション) セルフマネージド AD への参加設定
  #   # Amazon FSx が、オンプレミスを含む、お客様が管理する Microsoft Active Directory に
  #   # SVM を参加させるために使用する設定です。
  #   self_managed_active_directory_configuration {
  #     # dns_ips - (必須) セルフマネージド AD 内の DNS サーバーまたはドメインコントローラーの IP アドレス
  #     # 最大 3 つまで指定できます。
  #     dns_ips = ["10.0.1.10", "10.0.2.10"]
  #
  #     # domain_name - (必須) セルフマネージド AD ドメインの完全修飾ドメイン名（FQDN）
  #     # 例: corp.example.com
  #     domain_name = "corp.example.com"
  #
  #     # password - (必須) Amazon FSx が AD ドメインに参加する際に使用するサービスアカウントのパスワード
  #     # 注: このパラメータは sensitive として扱われます。
  #     # AWS Secrets Manager を使用して資格情報を管理することが推奨されます。
  #     password = "YourServiceAccountPassword"
  #
  #     # username - (必須) Amazon FSx が AD ドメインに参加する際に使用するサービスアカウントのユーザー名
  #     username = "FSxServiceAccount"
  #
  #     # file_system_administrators_group - (オプション) SVM の管理権限を付与されるドメイングループの名前
  #     # 指定するグループは AD ドメイン内に既に存在している必要があります。
  #     # デフォルト: Domain Admins
  #     # file_system_administrators_group = "FSxAdmins"
  #
  #     # organizational_unit_distinguished_name - (オプション) SVM が参加する組織単位（OU）の完全修飾識別名
  #     # 例: OU=FSx,DC=yourdomain,DC=corp,DC=com
  #     # OU のみを SVM の直接の親として受け入れます。
  #     # 指定しない場合、SVM はセルフマネージド AD のデフォルトの場所に作成されます。
  #     # 詳細については RFC 2253 を参照してください。
  #     # organizational_unit_distinguished_name = "OU=FSx,DC=corp,DC=example,DC=com"
  #   }
  # }

  #---------------------------------------------------------------
  # ネストブロック: timeouts
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定

  # timeouts {
  #   # create - (オプション) リソースの作成タイムアウト
  #   # デフォルト: 60m（60分）
  #   # create = "60m"
  #
  #   # delete - (オプション) リソースの削除タイムアウト
  #   # デフォルト: 60m（60分）
  #   # delete = "60m"
  #
  #   # update - (オプション) リソースの更新タイムアウト
  #   # デフォルト: 60m（60分）
  #   # update = "60m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Computed Only - 読み取り専用)
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に Terraform によって自動的に設定されます。
# これらの属性は output ブロックや他のリソースの参照として使用できます。
#
# - arn
#   説明: ストレージ仮想マシンの Amazon リソース名
#   例: "arn:aws:fsx:us-west-2:123456789012:storage-virtual-machine/fs-0123456789abcdef0/svm-0123456789abcdef0"
#
# - endpoints
#   説明: データアクセスまたは NetApp ONTAP CLI、REST API、NetApp SnapMirror を使用した
#        SVM 管理に使用されるエンドポイント
#   サブ属性:
#   - iscsi: iSCSI プロトコル経由でデータにアクセスするためのエンドポイント
#   - management: NetApp ONTAP CLI および API を使用した管理用エンドポイント
#   - nfs: NFS プロトコル経由でデータにアクセスするためのエンドポイント
#   - smb: SMB プロトコル経由でデータにアクセスするためのエンドポイント
#        （active_directory_configuration が設定されている場合のみ）
#   各エンドポイントには以下の属性が含まれます:
#   - dns_name: ストレージ仮想マシンの DNS 名
#   - ip_addresses: エンドポイントの IP アドレスのセット
#
# - id
#   説明: ストレージ仮想マシンの識別子
#   例: "svm-0123456789abcdef0"
#
# - subtype
#   説明: SVM のサブタイプ
#   有効な値: DEFAULT、DP_DESTINATION、SYNC_DESTINATION、SYNC_SOURCE
#   例: "DEFAULT"
#
# - tags_all
#   説明: リソースに割り当てられた全てのタグ（プロバイダーの default_tags から継承されたタグを含む）
#   例: { "Name" = "example-svm", "ManagedBy" = "terraform", "Environment" = "production" }
#
# - uuid
#   説明: SVM の UUID（汎用一意識別子）
#   例: "01234567-89ab-cdef-0123-456789abcdef"
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# output "svm_id" {
#   description = "The ID of the FSx ONTAP Storage Virtual Machine"
#   value       = aws_fsx_ontap_storage_virtual_machine.example.id
# }
#
# output "svm_endpoints" {
#   description = "The endpoints for the FSx ONTAP Storage Virtual Machine"
#   value       = aws_fsx_ontap_storage_virtual_machine.example.endpoints
# }
#
# output "svm_management_endpoint" {
#   description = "The management endpoint DNS name"
#   value       = try(aws_fsx_ontap_storage_virtual_machine.example.endpoints[0].management[0].dns_name, null)
# }
#
# output "svm_nfs_endpoint" {
#   description = "The NFS endpoint DNS name"
#   value       = try(aws_fsx_ontap_storage_virtual_machine.example.endpoints[0].nfs[0].dns_name, null)
# }
#---------------------------------------------------------------
