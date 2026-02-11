#---------------------------------------------------------------
# AWS DMS (Database Migration Service) Replication Instance
#---------------------------------------------------------------
#
# AWS Database Migration Service (DMS) のレプリケーションインスタンスリソースです。
# レプリケーションインスタンスは、ソースとターゲット間のデータ移行タスクを実行する
# コンピューティングリソースとして機能します。
#
# DMSレプリケーションインスタンスを作成する前に、以下のIAMロールが必要です:
#   - dms-vpc-role
#   - dms-cloudwatch-logs-role
#   - dms-access-for-endpoint
#
# AWS公式ドキュメント:
#   - DMS 概要: https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html
#   - レプリケーションインスタンス: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.html
#   - インスタンスタイプ: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.Types.html
#   - IAMロール設定: https://docs.aws.amazon.com/dms/latest/userguide/security-iam.html#CHAP_Security.APIRole
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_instance
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dms_replication_instance" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # replication_instance_id (Required)
  # 設定内容: レプリケーションインスタンスの識別子を指定します。
  # 設定可能な値: 英数字、ハイフンを含む文字列。小文字として保存されます。
  # 用途: AWSアカウント内でレプリケーションインスタンスを一意に識別
  # 関連機能: DMS レプリケーションインスタンスの命名
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.html
  replication_instance_id = "my-dms-replication-instance"

  # replication_instance_class (Required)
  # 設定内容: レプリケーションインスタンスのコンピューティングおよびメモリ容量を指定します。
  # 設定可能な値:
  #   - dms.t3.micro: 1 vCPU, 1 GB RAM (開発/テスト用)
  #   - dms.t3.small: 1 vCPU, 2 GB RAM
  #   - dms.t3.medium: 2 vCPU, 4 GB RAM
  #   - dms.t3.large: 2 vCPU, 8 GB RAM
  #   - dms.c5.large: 2 vCPU, 4 GB RAM (本番ワークロード向け)
  #   - dms.c5.xlarge: 4 vCPU, 8 GB RAM
  #   - dms.c5.2xlarge: 8 vCPU, 16 GB RAM
  #   - dms.c5.4xlarge: 16 vCPU, 32 GB RAM
  #   - dms.r5.large: 2 vCPU, 16 GB RAM (メモリ最適化)
  #   - dms.r5.xlarge: 4 vCPU, 32 GB RAM
  #   - その他多数
  # 用途: 移行タスクの規模と要件に応じて適切なインスタンスサイズを選択
  # 関連機能: DMS レプリケーションインスタンスタイプ
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.Types.html
  replication_instance_class = "dms.t3.micro"

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # allocated_storage (Optional, Computed)
  # 設定内容: レプリケーションインスタンスに割り当てるストレージ容量 (GB) を指定します。
  # 設定可能な値: 5 から 6144 の整数
  # デフォルト: 50 GB
  # 用途: 移行データのキャッシュや変更データキャプチャ用の一時ストレージ
  # 関連機能: DMS ストレージ要件
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.html
  allocated_storage = 50

  #-------------------------------------------------------------
  # バージョン設定
  #-------------------------------------------------------------

  # engine_version (Optional, Computed)
  # 設定内容: レプリケーションインスタンスのエンジンバージョンを指定します。
  # 設定可能な値: 有効なDMSエンジンバージョン (例: "3.5.2", "3.5.1", "3.4.7")
  # 省略時: 最新の安定バージョンが使用されます
  # 用途: 特定のDMS機能やバグ修正が必要な場合にバージョンを固定
  # 関連機能: DMS リリースノート
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReleaseNotes.html
  engine_version = "3.5.2"

  # allow_major_version_upgrade (Optional)
  # 設定内容: メジャーバージョンのアップグレードを許可するかを指定します。
  # 設定可能な値: true | false
  # デフォルト: false
  # 用途: メンテナンスウィンドウ中のメジャーバージョンアップグレード制御
  # 注意: メジャーバージョンアップグレードは後方互換性がない可能性があります
  allow_major_version_upgrade = false

  # auto_minor_version_upgrade (Optional, Computed)
  # 設定内容: マイナーバージョンの自動アップグレードを有効にするかを指定します。
  # 設定可能な値: true | false
  # デフォルト: false
  # 用途: セキュリティパッチやバグ修正の自動適用
  # 関連機能: メンテナンスウィンドウ中に自動アップグレードが実行されます
  auto_minor_version_upgrade = true

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # availability_zone (Optional, Computed)
  # 設定内容: レプリケーションインスタンスを作成するEC2アベイラビリティゾーンを指定します。
  # 設定可能な値: 有効なAZコード (例: "us-east-1a", "ap-northeast-1a")
  # 省略時: AWSが自動的に選択
  # 注意: multi_azがtrueの場合、この設定は使用できません
  # 関連機能: DMS アベイラビリティゾーン
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.html
  availability_zone = "ap-northeast-1a"

  # multi_az (Optional, Computed)
  # 設定内容: マルチAZ配置を有効にするかを指定します。
  # 設定可能な値: true | false
  # デフォルト: false
  # 用途: 高可用性要件がある本番環境でのフェイルオーバー機能
  # 注意: trueの場合、availability_zoneパラメータは設定できません
  # 関連機能: DMS マルチAZ
  #   スタンバイレプリカが別のAZに自動作成され、障害時に自動フェイルオーバー
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.html
  multi_az = false

  # replication_subnet_group_id (Optional, Computed)
  # 設定内容: レプリケーションインスタンスに関連付けるサブネットグループを指定します。
  # 設定可能な値: 有効なDMSレプリケーションサブネットグループID
  # 省略時: デフォルトのサブネットグループが使用されます
  # 用途: レプリケーションインスタンスを配置するVPCサブネットを制御
  # 関連機能: aws_dms_replication_subnet_group リソース
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.VPC.html
  replication_subnet_group_id = null

  # vpc_security_group_ids (Optional, Computed)
  # 設定内容: レプリケーションインスタンスに適用するVPCセキュリティグループIDのリストを指定します。
  # 設定可能な値: 有効なセキュリティグループIDのリスト
  # 省略時: デフォルトのVPCセキュリティグループが使用されます
  # 用途: ソースおよびターゲットデータベースへのネットワークアクセス制御
  # 関連機能: セキュリティグループでポート(通常1433, 3306, 5432等)の許可が必要
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.VPC.html
  vpc_security_group_ids = [
    "sg-12345678",
  ]

  # network_type (Optional, Computed)
  # 設定内容: レプリケーションインスタンスで使用するIPアドレスプロトコルタイプを指定します。
  # 設定可能な値:
  #   - "IPV4": IPv4のみをサポート
  #   - "DUAL": IPv4とIPv6の両方をサポート (デュアルスタック)
  # 省略時: IPV4
  # 用途: IPv6対応が必要な環境でのネットワーク構成
  network_type = "IPV4"

  # publicly_accessible (Optional, Computed)
  # 設定内容: レプリケーションインスタンスにパブリックIPアドレスを割り当てるかを指定します。
  # 設定可能な値: true | false
  # デフォルト: false
  # 用途:
  #   - true: パブリックサブネットに配置し、インターネット経由でアクセス可能
  #   - false: プライベートサブネットに配置し、VPC内からのみアクセス可能
  # 注意: オンプレミスデータベースへの接続にはVPNまたはDirect Connectが推奨
  # 関連機能: DMS ネットワーク設定
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.PublicPrivate.html
  publicly_accessible = false

  # dns_name_servers (Optional)
  # 設定内容: オンプレミスのソースまたはターゲットデータベースにアクセスするためのカスタムDNSネームサーバーを指定します。
  # 設定可能な値: 最大4つのDNSサーバーアドレス (カンマ区切り)
  # 省略時: レプリケーションインスタンスがサポートするデフォルトのネームサーバーを使用
  # 用途: オンプレミス環境のプライベートDNSを使用してホスト名を解決する必要がある場合
  # 例: "192.168.1.10,192.168.1.11"
  dns_name_servers = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_arn (Optional, Computed)
  # 設定内容: 接続パラメータの暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWSアカウントのデフォルト暗号化キーが使用されます
  # 用途: 保存時の暗号化にカスタムKMSキーを使用する場合
  # 注意: 各AWSリージョンに異なるデフォルト暗号化キーがあります
  # 関連機能: DMS 暗号化
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html
  kms_key_arn = null

  #-------------------------------------------------------------
  # メンテナンス設定
  #-------------------------------------------------------------

  # preferred_maintenance_window (Optional, Computed)
  # 設定内容: システムメンテナンスを実行できる週次の時間枠を指定します (UTC)。
  # 設定可能な値: "ddd:hh24:mi-ddd:hh24:mi" 形式
  #   - 例: "sun:10:30-sun:14:30"
  #   - 最低30分のウィンドウが必要
  # 省略時: AWSが自動的にメンテナンスウィンドウを割り当て
  # 用途: メンテナンスによるダウンタイムを業務影響の少ない時間帯に制御
  # 関連機能: DMS メンテナンスウィンドウ
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.html
  preferred_maintenance_window = "sun:10:30-sun:14:30"

  # apply_immediately (Optional)
  # 設定内容: 変更を即座に適用するか、次のメンテナンスウィンドウで適用するかを指定します。
  # 設定可能な値: true | false
  # デフォルト: false
  # 用途: 既存リソースの更新時に使用
  # 注意:
  #   - true: 変更を即座に適用 (一時的な中断が発生する可能性あり)
  #   - false: 次のメンテナンスウィンドウで変更を適用
  apply_immediately = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Kerberos認証設定
  #-------------------------------------------------------------

  # kerberos_authentication_settings (Optional)
  # 設定内容: Kerberos認証に必要な設定を構成します。
  # 用途: Active Directory統合認証を使用してソースまたはターゲットデータベースに接続する場合
  # 関連機能: DMS Kerberos認証
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html
  kerberos_authentication_settings {
    # key_cache_secret_iam_arn (Required)
    # 設定内容: キーキャッシュシークレットにアクセスするためのIAMロールARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 用途: DMSがSecrets Managerからキータブファイルを取得するための権限
    key_cache_secret_iam_arn = "arn:aws:iam::123456789012:role/dms-kerberos-role"

    # key_cache_secret_id (Required)
    # 設定内容: Kerberosキータブファイルを格納するSecrets ManagerシークレットのIDを指定します。
    # 設定可能な値: 有効なSecrets ManagerシークレットID
    # 用途: Kerberos認証に使用するキータブファイルの保存場所
    key_cache_secret_id = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:dms/kerberos-keytab"

    # krb5_file_contents (Required)
    # 設定内容: Kerberos構成ファイル (krb5.conf) の内容を指定します。
    # 設定可能な値: krb5.confファイルの内容をBase64エンコードした文字列、または直接の内容
    # 用途: Kerberosレルム、KDC情報などの認証設定
    krb5_file_contents = <<-EOT
[libdefaults]
    default_realm = EXAMPLE.COM
    dns_lookup_realm = false
    dns_lookup_kdc = false

[realms]
    EXAMPLE.COM = {
        kdc = kdc.example.com
        admin_server = kdc.example.com
    }

[domain_realm]
    .example.com = EXAMPLE.COM
    example.com = EXAMPLE.COM
EOT
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 用途: 大規模なインスタンスや複雑な設定で標準タイムアウトでは不十分な場合
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "30m", "1h")
    # デフォルト: 30分
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "30m", "1h")
    # デフォルト: 30分
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "30m", "1h")
    # デフォルト: 30分
    delete = "30m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tagging.html
  tags = {
    Name        = "my-dms-replication-instance"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はreplication_instance_idと同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # 依存関係の設定例
  #-------------------------------------------------------------
  # DMSはIAMロールの作成後に使用可能になるため、以下のような依存関係を設定することを推奨:
  #
  # depends_on = [
  #   aws_iam_role_policy_attachment.dms-access-for-endpoint-AmazonDMSRedshiftS3Role,
  #   aws_iam_role_policy_attachment.dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole,
  #   aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole
  # ]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - replication_instance_arn: レプリケーションインスタンスのAmazon Resource Name (ARN)
#
# - replication_instance_private_ips: レプリケーションインスタンスのプライベートIPアドレスのリスト
#
# - replication_instance_public_ips: レプリケーションインスタンスのパブリックIPアドレスのリスト
#   (publicly_accessibleがtrueの場合のみ)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
