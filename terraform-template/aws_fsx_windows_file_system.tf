#---------------------------------------------------------------
# Amazon FSx for Windows File Server
#---------------------------------------------------------------
#
# Amazon FSx for Windows File Serverファイルシステムをプロビジョニングするリソースです。
# フルマネージドのWindowsファイルサービスを提供し、SMBプロトコルを使用して
# WindowsおよびLinuxクライアントからアクセス可能なネットワークファイルストレージを提供します。
# Active Directory（AWS管理またはセルフマネージド）との統合が必須です。
#
# AWS公式ドキュメント:
#   - FSx for Windows File Server ガイド: https://docs.aws.amazon.com/fsx/latest/WindowsGuide/what-is.html
#   - パフォーマンス: https://docs.aws.amazon.com/fsx/latest/WindowsGuide/performance.html
#   - Active Directory統合: https://docs.aws.amazon.com/fsx/latest/WindowsGuide/aws-ad-integration-fsxW.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_windows_file_system
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_fsx_windows_file_system" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # subnet_ids (Required)
  # 設定内容: ファイルシステムにアクセス可能なサブネットIDのリストを指定します。
  # 設定可能な値: 有効なサブネットIDのリスト
  # 注意: 複数のサブネットを指定する場合は deployment_type を MULTI_AZ_1 に設定する必要があります。
  #       SINGLE_AZ_1 および SINGLE_AZ_2 では1つのサブネットのみ指定可能。
  subnet_ids = ["subnet-12345678"]

  # throughput_capacity (Required)
  # 設定内容: ファイルシステムのスループット容量（MB/秒）を指定します。
  # 設定可能な値: 8〜2048の整数。有効な値の詳細はAWSドキュメントを参照
  # 参考: https://docs.aws.amazon.com/fsx/latest/WindowsGuide/performance.html
  throughput_capacity = 32

  #-------------------------------------------------------------
  # Active Directory設定
  #-------------------------------------------------------------

  # active_directory_id (Optional)
  # 設定内容: ファイルシステムが参加するAWS Managed Microsoft Active DirectoryのIDを指定します。
  # 設定可能な値: AWS Directory ServiceのディレクトリID（d-xxxxxxxxxx形式）
  # 注意: self_managed_active_directory と排他的（どちらか一方のみ指定可能）。
  #       どちらか一方を必ず指定する必要があります。
  active_directory_id = "d-1234567890"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # security_group_ids (Optional)
  # 設定内容: ファイルシステムアクセス用に作成されたネットワークインターフェースに適用する
  #           セキュリティグループIDのリストを指定します。
  # 設定可能な値: 有効なセキュリティグループIDのリスト
  # 注意: これらのセキュリティグループはすべてのネットワークインターフェースに適用されます。
  security_group_ids = ["sg-12345678"]

  # preferred_subnet_id (Optional)
  # 設定内容: 優先ファイルサーバーを配置するサブネットのIDを指定します。
  # 設定可能な値: 有効なサブネットID
  # 注意: deployment_type が MULTI_AZ_1 の場合は必須です。
  preferred_subnet_id = null

  #-------------------------------------------------------------
  # デプロイメント設定
  #-------------------------------------------------------------

  # deployment_type (Optional)
  # 設定内容: ファイルシステムのデプロイメントタイプを指定します。
  # 設定可能な値:
  #   - "SINGLE_AZ_1": 単一AZ構成（第1世代）。SSDストレージのみ対応
  #   - "SINGLE_AZ_2": 単一AZ構成（第2世代）。SSDおよびHDDストレージに対応
  #   - "MULTI_AZ_1": マルチAZ構成。高可用性が必要な場合に使用。SSDおよびHDDストレージに対応
  # 省略時: "SINGLE_AZ_1"
  deployment_type = "SINGLE_AZ_1"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # storage_capacity (Optional)
  # 設定内容: ファイルシステムのストレージ容量（GiB）を指定します。
  # 設定可能な値:
  #   - SSDストレージ: 最小32 GiB、最大65536 GiB
  #   - HDDストレージ: 最小2000 GiB、最大65536 GiB
  # 省略時: バックアップからファイルシステムを作成する場合以外は必須です。
  storage_capacity = 32

  # storage_type (Optional)
  # 設定内容: ストレージタイプを指定します。
  # 設定可能な値:
  #   - "SSD": 高パフォーマンス・低レイテンシーなワークロード向け
  #   - "HDD": 幅広いワークロード向けのコスト最適化オプション。
  #             SINGLE_AZ_2 および MULTI_AZ_1 でのみ使用可能
  # 省略時: "SSD"
  storage_type = "SSD"

  #-------------------------------------------------------------
  # バックアップ設定
  #-------------------------------------------------------------

  # backup_id (Optional)
  # 設定内容: ファイルシステムの作成元となるバックアップのIDを指定します。
  # 設定可能な値: 有効なFSxバックアップID
  # 省略時: 既存バックアップからではなく新規ファイルシステムを作成します。
  backup_id = null

  # automatic_backup_retention_days (Optional)
  # 設定内容: 自動バックアップを保持する日数を指定します。
  # 設定可能な値: 0〜90の整数
  #   - 0: 自動バックアップを無効化
  # 省略時: 7（日）
  automatic_backup_retention_days = 7

  # daily_automatic_backup_start_time (Optional)
  # 設定内容: 日次自動バックアップを開始する優先時刻をHH:MM形式（UTC）で指定します。
  # 設定可能な値: "HH:MM"形式の文字列（例: "02:00"）
  # 省略時: AWSが自動的に設定します。
  daily_automatic_backup_start_time = "02:00"

  # copy_tags_to_backups (Optional)
  # 設定内容: ファイルシステムのタグをバックアップにコピーするかを指定します。
  # 設定可能な値:
  #   - true: タグをバックアップにコピーする
  #   - false: タグをバックアップにコピーしない
  # 省略時: false
  copy_tags_to_backups = false

  # skip_final_backup (Optional)
  # 設定内容: ファイルシステム削除時にデフォルトの最終バックアップをスキップするかを指定します。
  # 設定可能な値:
  #   - true: 最終バックアップをスキップする
  #   - false: 削除時に最終バックアップを取得する
  # 省略時: false
  # 注意: この設定はリソースを削除する前に別途適用する必要があります。
  skip_final_backup = false

  # final_backup_tags (Optional)
  # 設定内容: ファイルシステムの最終バックアップに適用するタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  final_backup_tags = {
    FinalBackup = "true"
  }

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: 保存データの暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWSマネージドKMSキーを使用して暗号化されます。
  kms_key_id = null

  #-------------------------------------------------------------
  # DNS エイリアス設定
  #-------------------------------------------------------------

  # aliases (Optional)
  # 設定内容: Amazon FSxファイルシステムに関連付けるDNSエイリアス名の配列を指定します。
  # 設定可能な値: 有効なDNS名の文字列セット（最大50件）
  # 参考: https://docs.aws.amazon.com/fsx/latest/WindowsGuide/managing-dns-aliases.html
  aliases = []

  #-------------------------------------------------------------
  # メンテナンス設定
  #-------------------------------------------------------------

  # weekly_maintenance_start_time (Optional)
  # 設定内容: 週次メンテナンスを開始する優先時刻をd:HH:MM形式（UTC）で指定します。
  # 設定可能な値: "d:HH:MM"形式の文字列
  #   - d: 曜日（1=月曜日〜7=日曜日）
  #   - HH: 時（00〜23）
  #   - MM: 分（00〜59）
  #   例: "1:02:00"（月曜日 02:00 UTC）
  # 省略時: AWSが自動的に設定します。
  weekly_maintenance_start_time = "1:02:00"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-fsx-windows"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # 監査ログ設定
  #-------------------------------------------------------------

  # audit_log_configuration (Optional)
  # 設定内容: Amazon FSx for Windows File Serverのファイル、フォルダ、ファイル共有への
  #           ユーザーアクセスを監査・ログに記録する設定ブロックです。
  # 参考: https://docs.aws.amazon.com/fsx/latest/APIReference/API_WindowsAuditLogConfiguration.html
  audit_log_configuration {

    # audit_log_destination (Optional)
    # 設定内容: 監査ログの送信先ARNを指定します。
    # 設定可能な値:
    #   - Amazon CloudWatch Logsのロググループ ARN（名前は /aws/fsx で始まる必要があります）
    #   - Amazon Kinesis Data Firehoseの配信ストリーム ARN（名前は aws-fsx で始まる必要があります）
    # 省略時: /aws/fsx/windows ロググループのログストリームが自動作成・使用されます。
    # 注意: file_access_audit_log_level および file_share_access_audit_log_level が
    #       DISABLED 以外に設定されている場合に指定可能です。
    audit_log_destination = null

    # file_access_audit_log_level (Optional)
    # 設定内容: ファイルおよびフォルダへのアクセスに対してAmazon FSxがログに記録する
    #           試行タイプを指定します。
    # 設定可能な値:
    #   - "DISABLED": ログを記録しない（デフォルト）
    #   - "SUCCESS_ONLY": 成功したアクセスのみを記録
    #   - "FAILURE_ONLY": 失敗したアクセスのみを記録
    #   - "SUCCESS_AND_FAILURE": 成功・失敗の両方を記録
    # 省略時: "DISABLED"
    file_access_audit_log_level = "DISABLED"

    # file_share_access_audit_log_level (Optional)
    # 設定内容: ファイル共有へのアクセスに対してAmazon FSxがログに記録する
    #           試行タイプを指定します。
    # 設定可能な値:
    #   - "DISABLED": ログを記録しない（デフォルト）
    #   - "SUCCESS_ONLY": 成功したアクセスのみを記録
    #   - "FAILURE_ONLY": 失敗したアクセスのみを記録
    #   - "SUCCESS_AND_FAILURE": 成功・失敗の両方を記録
    # 省略時: "DISABLED"
    file_share_access_audit_log_level = "DISABLED"
  }

  #-------------------------------------------------------------
  # ディスクIOPS設定
  #-------------------------------------------------------------

  # disk_iops_configuration (Optional)
  # 設定内容: Amazon FSx for Windows File ServerのSSD IOPSを設定するブロックです。
  # 参考: https://docs.aws.amazon.com/fsx/latest/WindowsGuide/managing-storage-configuration.html
  disk_iops_configuration {

    # mode (Optional)
    # 設定内容: ファイルシステムのIOPS数の指定方法を選択します。
    # 設定可能な値:
    #   - "AUTOMATIC": ストレージ容量に基づいてIOPSを自動設定（1 GiBあたり3 IOPS）
    #   - "USER_PROVISIONED": iops パラメータで指定した値を使用
    # 省略時: "AUTOMATIC"
    mode = "AUTOMATIC"

    # iops (Optional)
    # 設定内容: ファイルシステムに対してプロビジョニングするSSD IOPSの合計数を指定します。
    # 設定可能な値: 有効な整数値
    # 省略時: mode が AUTOMATIC の場合は自動計算されます。
    # 注意: mode が USER_PROVISIONED の場合に設定します。
    iops = null
  }

  #-------------------------------------------------------------
  # セルフマネージドActive Directory設定
  #-------------------------------------------------------------

  # self_managed_active_directory (Optional)
  # 設定内容: セルフマネージド（オンプレミス含む）Microsoft Active Directory（AD）への
  #           参加設定ブロックです。
  # 注意: active_directory_id と排他的（どちらか一方のみ指定可能）。
  #       どちらか一方を必ず指定する必要があります。
  # 参考: https://docs.aws.amazon.com/fsx/latest/WindowsGuide/aws-ad-integration-fsxW.html
  #
  # self_managed_active_directory {
  #
  #   # dns_ips (Required)
  #   # 設定内容: セルフマネージドADディレクトリのDNSサーバーまたはドメインコントローラーの
  #   #           IPアドレスを最大2つ指定します。
  #   # 設定可能な値: IPアドレスの文字列セット
  #   # 注意: IPアドレスはファイルシステムと同じVPC CIDRレンジ内、または
  #   #       RFC 1918で規定されたプライベートIPv4アドレスレンジ内である必要があります。
  #   dns_ips = ["10.0.0.111", "10.0.0.222"]
  #
  #   # domain_name (Required)
  #   # 設定内容: セルフマネージドADディレクトリの完全修飾ドメイン名（FQDN）を指定します。
  #   # 設定可能な値: FQDNの文字列（例: corp.example.com）
  #   domain_name = "corp.example.com"
  #
  #   # username (Required)
  #   # 設定内容: Amazon FSxがADドメインに参加するために使用するサービスアカウントの
  #   #           ユーザー名を指定します。
  #   # 設定可能な値: 有効なADユーザー名の文字列
  #   username = "Admin"
  #
  #   # password (Required, Sensitive)
  #   # 設定内容: Amazon FSxがADドメインに参加するために使用するサービスアカウントの
  #   #           パスワードを指定します。
  #   # 設定可能な値: パスワード文字列
  #   # 注意: センシティブな値です。プレーンテキストでの記述は避け、変数または
  #   #       Secrets Managerを利用することを推奨します。
  #   password = var.ad_password
  #
  #   # file_system_administrators_group (Optional)
  #   # 設定内容: ファイルシステムの管理者権限を持つドメイングループの名前を指定します。
  #   #           管理者権限には、ファイル・フォルダの所有権取得および監査ACL設定が含まれます。
  #   # 設定可能な値: 既存のADグループ名の文字列
  #   # 省略時: "Domain Admins"
  #   file_system_administrators_group = "Domain Admins"
  #
  #   # organizational_unit_distinguished_name (Optional)
  #   # 設定内容: Windows File Serverインスタンスが参加するセルフマネージドADディレクトリ内の
  #   #           組織単位（OU）の完全修飾識別名（DN）を指定します。
  #   # 設定可能な値: RFC 2253形式のDN文字列（例: OU=FSx,DC=corp,DC=example,DC=com）
  #   # 省略時: セルフマネージドADディレクトリのデフォルトの場所にFSxが作成されます。
  #   # 参考: https://tools.ietf.org/html/rfc2253
  #   organizational_unit_distinguished_name = "OU=FSx,DC=corp,DC=example,DC=com"
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration文字列（例: "60m", "2h"）
    # 省略時: プロバイダーのデフォルト値を使用
    create = "45m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration文字列（例: "60m", "2h"）
    # 省略時: プロバイダーのデフォルト値を使用
    update = "45m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration文字列（例: "60m", "2h"）
    # 省略時: プロバイダーのデフォルト値を使用
    delete = "45m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ファイルシステムのAmazon Resource Name (ARN)
# - dns_name: ファイルシステムのDNS名（例: fs-12345678.corp.example.com）
# - id: ファイルシステムの識別子（例: fs-12345678）
# - network_interface_ids: ファイルシステムにアクセス可能なElastic Network InterfaceのIDセット
# - owner_id: ファイルシステムを作成したAWSアカウントID
# - preferred_file_server_ip: プライマリファイルサーバーのIPアドレス
# - remote_administration_endpoint: MULTI_AZ_1 では管理タスク用エンドポイント。
#                                   SINGLE_AZ_1 ではファイルシステムのDNS名
# - vpc_id: ファイルシステムが属するVPCの識別子
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
