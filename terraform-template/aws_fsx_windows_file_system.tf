#---------------------------------------------------------------
# Amazon FSx for Windows File Server
#---------------------------------------------------------------
#
# Amazon FSx for Windows File Serverファイルシステムを作成します。
# Windows Serverベースのフルマネージドファイルストレージサービスであり、
# SMBプロトコルでアクセス可能な共有ファイルストレージを提供します。
#
# Active Directory統合が必須であり、AWS Directory Serviceまたは
# セルフマネージドActive Directoryのいずれかを使用する必要があります。
#
# AWS公式ドキュメント:
#   - FSx for Windows File Server User Guide: https://docs.aws.amazon.com/fsx/latest/WindowsGuide/what-is.html
#   - Performance: https://docs.aws.amazon.com/fsx/latest/WindowsGuide/performance.html
#   - Working with DNS Aliases: https://docs.aws.amazon.com/fsx/latest/WindowsGuide/managing-dns-aliases.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_windows_file_system
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_fsx_windows_file_system" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (Required) ファイルシステムがアクセス可能なサブネットのIDリスト
  # MULTI_AZ_1デプロイメントタイプの場合、複数のサブネットを指定する必要があります
  # SINGLE_AZ_1またはSINGLE_AZ_2の場合は単一のサブネットを指定します
  subnet_ids = ["subnet-12345678"]

  # (Required) ファイルシステムのスループット容量（メガバイト/秒）
  # 有効な値についてはAWSドキュメントを参照してください
  # https://docs.aws.amazon.com/fsx/latest/WindowsGuide/performance.html
  # 例: 8, 16, 32, 64, 128, 256, 512, 1024, 2048
  throughput_capacity = 32

  #---------------------------------------------------------------
  # Active Directory設定（いずれかが必須）
  #---------------------------------------------------------------

  # (Optional) AWS Directory ServiceのディレクトリID
  # self_managed_active_directoryとは相互排他的です
  # AWS Managed Microsoft ADまたはAD Connectorのディレクトリを指定します
  active_directory_id = null

  # (Optional) セルフマネージドActive Directory設定
  # active_directory_idとは相互排他的です
  # オンプレミスまたはEC2上のActive Directoryと統合する場合に使用します
  # self_managed_active_directory {
  #   # (Required) DNSサーバーまたはドメインコントローラーのIPアドレスリスト（最大2つ）
  #   # VPCのCIDR範囲内、またはRFC 1918のプライベートIPv4アドレス範囲内である必要があります
  #   dns_ips = ["10.0.0.111", "10.0.0.222"]
  #
  #   # (Required) セルフマネージドADディレクトリの完全修飾ドメイン名（FQDN）
  #   # 例: corp.example.com
  #   domain_name = "corp.example.com"
  #
  #   # (Optional) サービスアカウントのユーザー名
  #   # domain_join_service_account_secretと相互排他的です
  #   username = "Admin"
  #
  #   # (Optional) サービスアカウントのパスワード
  #   # domain_join_service_account_secretと相互排他的です
  #   # 機密情報のため、変数やSecrets Managerの使用を推奨します
  #   password = "avoid-plaintext-passwords"
  #
  #   # (Optional) サービスアカウント認証情報を含むSecrets ManagerシークレットのARN
  #   # usernameおよびpasswordと相互排他的です
  #   # domain_join_service_account_secret = "arn:aws:secretsmanager:region:account-id:secret:secret-name"
  #
  #   # (Optional) ファイルシステムの管理者権限を持つドメイングループ名
  #   # デフォルトは "Domain Admins"
  #   file_system_administrators_group = "Domain Admins"
  #
  #   # (Optional) ファイルシステムが参加する組織単位（OU）の識別名（DN）
  #   # 例: OU=FSx,DC=yourdomain,DC=corp,DC=com
  #   # OUはファイルシステムの直接の親である必要があります
  #   # RFC 2253形式で指定します
  #   organizational_unit_distinguished_name = null
  # }

  #---------------------------------------------------------------
  # ストレージ設定
  #---------------------------------------------------------------

  # (Optional) ストレージ容量（GiB）
  # SSDの場合: 最小32、最大65536
  # HDDの場合: 最小2000、最大65536
  # バックアップから作成する場合以外は必須です
  storage_capacity = 32

  # (Optional) ストレージタイプ
  # 有効な値: SSD（デフォルト）、HDD
  # HDDはSINGLE_AZ_2およびMULTI_AZ_1デプロイメントタイプでサポートされます
  storage_type = "SSD"

  #---------------------------------------------------------------
  # デプロイメント設定
  #---------------------------------------------------------------

  # (Optional) デプロイメントタイプ
  # 有効な値: SINGLE_AZ_1（デフォルト）、SINGLE_AZ_2、MULTI_AZ_1
  # MULTI_AZ_1は高可用性のため複数のアベイラビリティゾーンにデプロイします
  deployment_type = "SINGLE_AZ_1"

  # (Optional) 優先ファイルサーバーを配置するサブネットID
  # MULTI_AZ_1デプロイメントタイプの場合は必須です
  # subnet_idsで指定したサブネットのいずれかである必要があります
  preferred_subnet_id = null

  #---------------------------------------------------------------
  # ネットワーク設定
  #---------------------------------------------------------------

  # (Optional) ファイルシステムアクセス用に作成されるネットワークインターフェースに
  # 適用するセキュリティグループIDのリスト
  # 指定しない場合、VPCのデフォルトセキュリティグループが使用されます
  security_group_ids = null

  # (Optional) DNS Aliasの配列
  # Amazon FSxファイルシステムに関連付けるDNSエイリアス名のリスト
  # https://docs.aws.amazon.com/fsx/latest/WindowsGuide/managing-dns-aliases.html
  aliases = null

  #---------------------------------------------------------------
  # 暗号化設定
  #---------------------------------------------------------------

  # (Optional) ファイルシステムの保存時暗号化に使用するKMSキーのARN
  # 指定しない場合、AWS管理のKMSキーが使用されます
  kms_key_id = null

  #---------------------------------------------------------------
  # バックアップ設定
  #---------------------------------------------------------------

  # (Optional) ソースバックアップのID
  # バックアップからファイルシステムを作成する場合に指定します
  backup_id = null

  # (Optional) 自動バックアップの保持日数
  # 最小0、最大90、デフォルト7
  # 0を設定すると自動バックアップが無効になります
  automatic_backup_retention_days = 7

  # (Optional) 日次自動バックアップの開始時刻（HH:MM形式、UTC）
  # 例: "07:00"
  # 指定しない場合、AWSが自動的に設定します
  daily_automatic_backup_start_time = null

  # (Optional) 週次メンテナンスの開始時刻（d:HH:MM形式、UTC）
  # dは曜日（1=月曜日、7=日曜日）、HH:MMは時刻
  # 例: "1:07:00"（月曜日の午前7時UTC）
  weekly_maintenance_start_time = null

  # (Optional) ファイルシステムのタグをバックアップにコピーするかどうか
  # デフォルトはfalse
  copy_tags_to_backups = false

  # (Optional) ファイルシステム削除時の最終バックアップに適用するタグのマップ
  final_backup_tags = null

  # (Optional) ファイルシステム削除時にデフォルトの最終バックアップをスキップするかどうか
  # デフォルトはfalse
  # この設定はリソース削除前に個別に適用する必要があります
  skip_final_backup = false

  #---------------------------------------------------------------
  # ディスクIOPS設定
  #---------------------------------------------------------------

  # (Optional) SSD IOPSの設定
  # disk_iops_configuration {
  #   # (Optional) プロビジョニングされるSSD IOPSの合計数
  #   # modeがUSER_PROVISIONEDの場合に指定します
  #   iops = null
  #
  #   # (Optional) IOPSのモード
  #   # 有効な値: AUTOMATIC（デフォルト）、USER_PROVISIONED
  #   # AUTOMATICの場合、ストレージ容量に基づいてIOPSが自動的に設定されます
  #   mode = "AUTOMATIC"
  # }

  #---------------------------------------------------------------
  # 監査ログ設定
  #---------------------------------------------------------------

  # (Optional) ファイルとフォルダーのアクセス監査設定
  # audit_log_configuration {
  #   # (Optional) 監査ログの送信先ARN
  #   # CloudWatch LogsロググループARNまたはKinesis Data Firehose配信ストリームARN
  #   # CloudWatch Logsの場合: /aws/fsx で始まる名前
  #   # Kinesis Firehoseの場合: aws-fsx で始まる名前
  #   # 指定しない場合、/aws/fsx/windowsロググループが自動作成されます
  #   audit_log_destination = null
  #
  #   # (Optional) ファイルおよびフォルダーアクセスのログレベル
  #   # 有効な値: SUCCESS_ONLY, FAILURE_ONLY, SUCCESS_AND_FAILURE, DISABLED（デフォルト）
  #   file_access_audit_log_level = "DISABLED"
  #
  #   # (Optional) ファイル共有アクセスのログレベル
  #   # 有効な値: SUCCESS_ONLY, FAILURE_ONLY, SUCCESS_AND_FAILURE, DISABLED（デフォルト）
  #   file_share_access_audit_log_level = "DISABLED"
  # }

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # (Optional) リソースを管理するリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # タグ
  #---------------------------------------------------------------

  # (Optional) ファイルシステムに割り当てるタグのマップ
  # プロバイダーのdefault_tags設定がある場合、マージされます
  tags = {
    Name        = "example-fsx-windows"
    Environment = "production"
  }

  # (Optional) プロバイダーのdefault_tagsを含むすべてのタグ
  # 通常は明示的に設定する必要はありません（computed属性）
  tags_all = null

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts {
  #   # (Optional) ファイルシステム作成のタイムアウト
  #   # デフォルト: 45分
  #   create = "45m"
  #
  #   # (Optional) ファイルシステム更新のタイムアウト
  #   # デフォルト: 45分
  #   update = "45m"
  #
  #   # (Optional) ファイルシステム削除のタイムアウト
  #   # デフォルト: 30分
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed-only属性）:
#
# - arn - ファイルシステムのAmazon Resource Name
# - dns_name - ファイルシステムのDNS名（例: fs-12345678.corp.example.com）
#              Active Directoryドメイン名に一致するドメイン名
# - id - ファイルシステムの識別子（例: fs-12345678）
# - network_interface_ids - ファイルシステムにアクセス可能なElastic Network InterfaceのIDセット
# - owner_id - ファイルシステムを作成したAWSアカウント識別子
# - preferred_file_server_ip - プライマリ（優先）ファイルサーバーのIPアドレス
# - remote_administration_endpoint - MULTI_AZ_1デプロイメントタイプの場合の管理エンドポイント
#                                    Amazon FSx Remote PowerShellで管理タスクを実行する際に使用
#                                    SINGLE_AZ_1の場合はファイルシステムのDNS名
# - vpc_id - ファイルシステムのVirtual Private Cloud識別子
#
# 使用例:
# output "fsx_dns_name" {
#   value = aws_fsx_windows_file_system.example.dns_name
# }
#---------------------------------------------------------------
