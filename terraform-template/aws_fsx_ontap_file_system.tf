#---------------------------------------------------------------
# Amazon FSx for NetApp ONTAP File System
#---------------------------------------------------------------
#
# Amazon FSx for NetApp ONTAPの完全マネージド型ファイルシステムを作成します。
# NetAppの人気の高いONTAPファイルシステム上に構築された、高い信頼性、
# スケーラビリティ、パフォーマンス、豊富な機能を持つファイルストレージを提供します。
#
# FSx for ONTAPは、SSDストレージでサブミリ秒のレイテンシを実現し、
# Linux、Windows、macOSから幅広くアクセス可能な共有ファイルストレージを提供します。
# スナップショット、クローン、レプリケーション、データの自動階層化、
# 圧縮、重複排除などの機能により、データ管理を容易にします。
#
# デプロイメントタイプ:
# - MULTI_AZ_1: 第1世代Multi-AZ (1 HA pair)
# - MULTI_AZ_2: 第2世代Multi-AZ (1 HA pair)
# - SINGLE_AZ_1: 第1世代Single-AZ (1 HA pair)
# - SINGLE_AZ_2: 第2世代Single-AZ (1-12 HA pairs)
#
# AWS公式ドキュメント:
#   - What is Amazon FSx for NetApp ONTAP?: https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/what-is-fsx-ontap.html
#   - FSx for ONTAP User Guide: https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/
#   - Managing FSx for ONTAP file systems: https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/managing-file-systems.html
#   - Performance: https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/performance.html
#   - HA pairs: https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/HA-pairs.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_ontap_file_system
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_fsx_ontap_file_system" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # デプロイメントタイプ
  # MULTI_AZ_1: 第1世代Multi-AZ (1 HA pair, 最大4 GBps, 160,000 IOPS)
  # MULTI_AZ_2: 第2世代Multi-AZ (1 HA pair, 最大6 GBps, 200,000 IOPS)
  # SINGLE_AZ_1: 第1世代Single-AZ (1 HA pair)
  # SINGLE_AZ_2: 第2世代Single-AZ (1-12 HA pairs, 最大72 GBps, 2.4M IOPS)
  deployment_type = "MULTI_AZ_1"

  # プライマリサブネットID
  # ファイルシステムがアクセス可能となるサブネットのIDを指定します。
  # Multi-AZの場合、preferred_subnet_idとsubnet_ids[1]で指定した
  # 2つのサブネットが異なるAZに配置されている必要があります。
  preferred_subnet_id = "subnet-12345678"

  # ストレージ容量 (GiB)
  # SINGLE_AZ_1/MULTI_AZ_1: 1024-196608 GiB
  # MULTI_AZ_2: 1024-524288 GiB
  # SINGLE_AZ_2: 1024-1048576 GiB (1PBは2+ HA pairs時のみ、1 HA pairは最大512TB)
  storage_capacity = 1024

  # サブネットID (最大2つ)
  # ファイルシステムがアクセス可能となるサブネットのIDリスト。
  # Multi-AZデプロイメントでは2つのサブネットを異なるAZに指定する必要があります。
  # Single-AZデプロイメントでは1つのサブネットを指定します。
  subnet_ids = ["subnet-12345678", "subnet-87654321"]

  #---------------------------------------------------------------
  # Optional Parameters - Capacity & Performance
  #---------------------------------------------------------------

  # HA pair数 (SINGLE_AZ_2/MULTI_AZ_2で指定可能)
  # SINGLE_AZ_1/MULTI_AZ_1: 1 (固定)
  # SINGLE_AZ_2: 1-12
  # MULTI_AZ_2: 1 (固定)
  # 各HA pairには独立したアグリゲート(ストレージプール)が含まれます。
  # ha_pairs = 1

  # スループット容量 (MBps)
  # ha_pairsを使用しない場合に指定します。
  # 有効値: 128, 256, 512, 1024, 2048, 4096
  # throughput_capacityまたはthroughput_capacity_per_ha_pairのいずれかを指定。
  # throughput_capacity = 512

  # HA pairあたりのスループット容量 (MBps)
  # ha_pairsを使用する場合に指定します。
  # MULTI_AZ_1/SINGLE_AZ_1: 128, 256, 512, 1024, 2048, 4096
  # MULTI_AZ_2/SINGLE_AZ_2 (ha_pairs=1): 384, 768, 1536, 3072, 6144
  # SINGLE_AZ_2 (ha_pairs>1): 1536, 3072, 6144
  # throughput_capacityまたはthroughput_capacity_per_ha_pairのいずれかを指定。
  # throughput_capacity_per_ha_pair = 128

  # ストレージタイプ
  # 現在サポートされている値: SSD (デフォルト)
  # storage_type = "SSD"

  #---------------------------------------------------------------
  # Optional Parameters - Backup
  #---------------------------------------------------------------

  # 自動バックアップ保持日数
  # 0を設定すると自動バックアップが無効になります。
  # 最大90日まで保持可能です。
  # automatic_backup_retention_days = 0

  # 日次自動バックアップ開始時刻
  # HH:MM形式 (UTC)。例: "05:00"は午前5時を意味します。
  # automatic_backup_retention_daysの設定が必要です。
  # daily_automatic_backup_start_time = "05:00"

  #---------------------------------------------------------------
  # Optional Parameters - Network
  #---------------------------------------------------------------

  # エンドポイントIPアドレス範囲
  # ファイルシステムへのアクセスエンドポイントが作成されるIP範囲を指定します。
  # デフォルトでは、Amazonが198.19.*範囲から未使用のIP範囲を選択します。
  # 注意: 198.19.*範囲はWorkSpacesやAppStream 2.0などのAWSサービスでも
  # 管理ネットワークインターフェースに使用されます。
  # endpoint_ip_address_range = "198.19.0.0/16"

  # ルートテーブルID
  # ファイルシステムのエンドポイントが作成されるVPCルートテーブルを指定します。
  # クライアントが配置されているサブネットに関連付けられた全てのVPCルートテーブルを
  # 指定する必要があります。デフォルトではVPCのデフォルトルートテーブルが選択されます。
  # route_table_ids = ["rtb-12345678"]

  # セキュリティグループID
  # ファイルシステムアクセス用に作成されるネットワークインターフェースに
  # 適用されるセキュリティグループのIDリスト。
  # 全てのネットワークインターフェースに適用されます。
  # security_group_ids = ["sg-12345678"]

  #---------------------------------------------------------------
  # Optional Parameters - Encryption & Security
  #---------------------------------------------------------------

  # ONTAP管理者パスワード
  # fsxadminユーザーのパスワード。
  # ONTAP CLIおよびREST APIを使用してファイルシステムを管理する際に使用します。
  # 機密情報のため、変数やシークレット管理サービスから取得することを推奨します。
  # fsx_admin_password = "YourSecurePassword123!"

  # KMSキーID
  # 保管時の暗号化に使用するKMSキーのARN。
  # 未指定の場合、AWSマネージドKMSキーがデフォルトで使用されます。
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #---------------------------------------------------------------
  # Optional Parameters - Maintenance
  #---------------------------------------------------------------

  # 週次メンテナンス開始時刻
  # d:HH:MM形式 (UTC)。dは曜日 (1=月曜日, 7=日曜日)。
  # 例: "1:05:00"は月曜日午前5時を意味します。
  # weekly_maintenance_start_time = "1:05:00"

  #---------------------------------------------------------------
  # Optional Parameters - Disk IOPS Configuration
  #---------------------------------------------------------------

  # SSD IOPS設定
  # ファイルシステムのSSD IOPSを設定します。
  disk_iops_configuration {
    # IOPSモード
    # AUTOMATIC: システムが自動的にIOPSを管理 (デフォルト)
    # USER_PROVISIONED: ユーザーがIOPSを指定
    # mode = "AUTOMATIC"

    # プロビジョニングするSSD IOPSの合計数
    # mode="USER_PROVISIONED"の場合に指定します。
    # デフォルトでは、FSx for ONTAPはストレージ容量1TiBあたり
    # 最大3,072 IOPSを提供します。
    # iops = 3000
  }

  #---------------------------------------------------------------
  # Optional Parameters - Timeouts
  #---------------------------------------------------------------

  # タイムアウト設定
  timeouts {
    # 作成タイムアウト (デフォルト: 60分)
    # create = "60m"

    # 更新タイムアウト (デフォルト: 60分)
    # update = "60m"

    # 削除タイムアウト (デフォルト: 60分)
    # delete = "60m"
  }

  #---------------------------------------------------------------
  # Optional Parameters - Tags
  #---------------------------------------------------------------

  # タグ
  # ファイルシステムに割り当てるタグのマップ。
  # プロバイダーのdefault_tagsと重複するキーは、ここで定義した値で上書きされます。
  tags = {
    Name        = "example-fsx-ontap"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # 全てのタグ (通常は使用しない)
  # プロバイダーレベルのdefault_tagsを含む全てのタグ。
  # 通常はTerraformが自動的に管理するため、明示的な指定は不要です。
  # tags_all = {}

  #---------------------------------------------------------------
  # Optional Parameters - Advanced
  #---------------------------------------------------------------

  # ID (通常は使用しない)
  # Terraformリソース識別子。通常は自動生成されるため指定不要です。
  # id = ""

  # リージョン (通常は使用しない)
  # リソースが管理されるリージョン。
  # デフォルトではプロバイダー設定のリージョンが使用されます。
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference (Read-Only)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です (computed属性)。
# Terraformコード内でこれらを設定することはできません。
#
# - arn: ファイルシステムのAmazon Resource Name
# - dns_name: ファイルシステムのDNS名
#            (FSx for ONTAPではSVMのDNS名またはIPアドレスを経由してアクセス)
# - endpoints: データアクセスまたはNetApp ONTAP CLI/REST API/SnapMirror管理用エンドポイント
#   - intercluster: NetApp SnapMirrorで他のONTAPシステムとの連携用エンドポイント
#     - dns_name: DNS名
#     - ip_addresses: IPアドレスのセット
#   - management: NetApp ONTAP CLI/APIを使用した管理用エンドポイント
#     - dns_name: DNS名
#     - ip_addresses: IPアドレスのセット
# - id: ファイルシステムの識別子 (例: fs-12345678)
# - network_interface_ids: ファイルシステムアクセス用に作成されたElastic Network InterfaceのIDセット
#                          最初のネットワークインターフェースがプライマリです
# - owner_id: ファイルシステムを作成したAWSアカウント識別子
# - vpc_id: ファイルシステムのVirtual Private Cloud識別子
#
# 使用例:
# output "fsx_ontap_arn" {
#   value = aws_fsx_ontap_file_system.example.arn
# }
#
# output "fsx_ontap_management_endpoint" {
#   value = aws_fsx_ontap_file_system.example.endpoints[0].management[0].dns_name
# }
