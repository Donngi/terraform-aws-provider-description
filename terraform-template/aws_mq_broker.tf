#---------------------------------------------------------------
# Amazon MQ Broker
#---------------------------------------------------------------
#
# Amazon MQのメッセージブローカーをプロビジョニングするリソースです。
# ActiveMQおよびRabbitMQエンジンに対応し、マネージドメッセージブローカーを
# 提供します。シングルインスタンス、アクティブ/スタンバイ、クラスター構成を
# サポートします。
#
# AWS公式ドキュメント:
#   - Amazon MQ 概要: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/welcome.html
#   - ActiveMQ デプロイオプション: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/amazon-mq-broker-architecture.html
#   - RabbitMQ デプロイオプション: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/rabbitmq-broker-architecture.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker
#
# Provider Version: 6.38.0
# Generated: 2026-03-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_mq_broker" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # broker_name (Required)
  # 設定内容: ブローカーの名前を指定します。
  # 設定可能な値: 1-50文字の英数字、ハイフンを含む文字列
  broker_name = "example-broker"

  # engine_type (Required)
  # 設定内容: ブローカーエンジンの種類を指定します。
  # 設定可能な値:
  #   - "ActiveMQ": Apache ActiveMQエンジン
  #   - "RabbitMQ": RabbitMQエンジン
  engine_type = "ActiveMQ"

  # engine_version (Required)
  # 設定内容: ブローカーエンジンのバージョンを指定します。
  # 設定可能な値: エンジンタイプに対応したバージョン文字列（例: "5.17.6"）
  # 参考: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/activemq-version-management.html
  engine_version = "5.17.6"

  # host_instance_type (Required)
  # 設定内容: ブローカーのインスタンスタイプを指定します。
  # 設定可能な値: 例: "mq.t3.micro", "mq.m5.large", "mq.m5.xlarge"
  # 注意: storage_typeに"ebs"を使用する場合はmq.m5ファミリーのみサポート
  host_instance_type = "mq.t3.micro"

  #-------------------------------------------------------------
  # デプロイメント設定
  #-------------------------------------------------------------

  # deployment_mode (Optional)
  # 設定内容: ブローカーのデプロイモードを指定します。
  # 設定可能な値:
  #   - "SINGLE_INSTANCE": シングルインスタンス（デフォルト）。1つのAZに1つのブローカー
  #   - "ACTIVE_STANDBY_MULTI_AZ": アクティブ/スタンバイ構成。2つのAZに高可用性を提供（ActiveMQ専用）
  #   - "CLUSTER_MULTI_AZ": クラスター構成。複数AZに分散（RabbitMQ専用）
  # 省略時: "SINGLE_INSTANCE"
  deployment_mode = "SINGLE_INSTANCE"

  # apply_immediately (Optional)
  # 設定内容: ブローカーの変更を即座に適用するかを指定します。
  # 設定可能な値:
  #   - true: 変更を即座に適用（ブローカーの再起動が発生する場合があります）
  #   - false: 次のメンテナンスウィンドウに適用
  # 省略時: false
  # 注意: trueに設定すると短時間のダウンタイムが発生する場合があります
  apply_immediately = false

  # auto_minor_version_upgrade (Optional)
  # 設定内容: Amazon MQがマイナーバージョンを自動的にアップグレードするかを指定します。
  # 設定可能な値:
  #   - true: 自動アップグレードを有効化
  #   - false: 自動アップグレードを無効化
  auto_minor_version_upgrade = false

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # authentication_strategy (Optional)
  # 設定内容: ブローカー接続の認証・認可に使用するストラテジーを指定します。
  # 設定可能な値:
  #   - "simple": シンプル認証（ユーザー名/パスワード）
  #   - "ldap": LDAP認証（ActiveMQのみサポート。RabbitMQは非対応）
  # 省略時: エンジンタイプにより自動決定
  authentication_strategy = "simple"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # publicly_accessible (Optional)
  # 設定内容: VPC外部のアプリケーションからの接続を許可するかを指定します。
  # 設定可能な値:
  #   - true: パブリックアクセスを有効化
  #   - false: VPC内からのアクセスのみ許可
  publicly_accessible = false

  # security_groups (Optional)
  # 設定内容: ブローカーに割り当てるセキュリティグループIDのリストを指定します。
  # 設定可能な値: 有効なセキュリティグループIDのセット
  security_groups = ["sg-12345678"]

  # subnet_ids (Optional)
  # 設定内容: ブローカーを起動するサブネットIDのリストを指定します。
  # 設定可能な値: 有効なサブネットIDのセット
  # 注意: SINGLE_INSTANCEは1つのサブネット、ACTIVE_STANDBY_MULTI_AZは複数のサブネットが必要
  subnet_ids = ["subnet-12345678"]

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # storage_type (Optional)
  # 設定内容: ブローカーのストレージタイプを指定します。
  # 設定可能な値:
  #   - "efs": Amazon EFS（ActiveMQのデフォルト）。高耐久性・高可用性。複数AZにデータ分散
  #   - "ebs": Amazon EBS。低レイテンシ・高スループット最適化。mq.m5インスタンスファミリーのみ対応
  # 注意: RabbitMQは"ebs"のみサポート
  storage_type = "efs"

  #-------------------------------------------------------------
  # データレプリケーション設定
  #-------------------------------------------------------------

  # data_replication_mode (Optional)
  # 設定内容: クロスリージョンデータレプリケーション（CRDR）の設定を指定します。
  # 設定可能な値:
  #   - "CRDR": クロスリージョンデータレプリケーションを有効化
  #   - "NONE": レプリケーションなし
  # 省略時: エンジンタイプにより自動決定
  # 参考: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/active-mq-cross-region-data-replication.html
  data_replication_mode = "NONE"

  # data_replication_primary_broker_arn (Optional)
  # 設定内容: データレプリケーションペアのプライマリブローカーのARNを指定します。
  # 設定可能な値: 有効なAmazon MQブローカーのARN
  # 注意: data_replication_modeが"CRDR"の場合に必須
  data_replication_primary_broker_arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ブローカー設定
  #-------------------------------------------------------------

  # configuration (Optional)
  # 設定内容: ブローカーの設定を指定するブロックです。ActiveMQおよびRabbitMQに適用されます。
  # 参考: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/amazon-mq-broker-configuration-parameters.html
  configuration {

    # id (Optional)
    # 設定内容: ブローカーに適用する設定のIDを指定します。
    # 設定可能な値: 有効なAmazon MQ設定ID
    id = "c-12345678-1234-1234-1234-123456789012"

    # revision (Optional)
    # 設定内容: ブローカーに適用する設定のリビジョン番号を指定します。
    # 設定可能な値: 正の整数
    revision = 1
  }

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_options (Optional)
  # 設定内容: 保存データの暗号化オプションを指定するブロックです。
  # 参考: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/data-protection.html
  encryption_options {

    # kms_key_id (Optional)
    # 設定内容: 保存データの暗号化に使用するKMS CMKのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    # 注意: use_aws_owned_keyをfalseに設定する必要があります
    kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

    # use_aws_owned_key (Optional)
    # 設定内容: AWSが所有するKMS CMK（アカウント外）を使用するかを指定します。
    # 設定可能な値:
    #   - true: AWS所有のKMS CMKを使用（デフォルト）
    #   - false: カスタムKMS CMKを使用。kms_key_idを指定しない場合はaws/mqのAWS管理CMKを使用
    # 省略時: true
    use_aws_owned_key = false
  }

  #-------------------------------------------------------------
  # LDAP認証設定
  #-------------------------------------------------------------

  # ldap_server_metadata (Optional)
  # 設定内容: LDAP認証の設定を指定するブロックです。RabbitMQはサポートしていません。
  # 参考: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/security-authentication-authorization.html
  ldap_server_metadata {

    # hosts (Optional)
    # 設定内容: LDAPサーバーおよびフェイルオーバーサーバーの完全修飾ドメイン名のリストを指定します。
    # 設定可能な値: 有効なFQDNのリスト
    hosts = ["ldap.example.com"]

    # role_base (Optional)
    # 設定内容: ユーザーのグループを検索するディレクトリの完全修飾名を指定します。
    # 設定可能な値: 有効なLDAP DN（識別名）文字列
    role_base = "ou=groups,dc=example,dc=com"

    # role_name (Optional)
    # 設定内容: グループメンバーシップクエリから返されるオブジェクトのグループ名属性を識別するLDAP属性を指定します。
    # 設定可能な値: 文字列
    role_name = "cn"

    # role_search_matching (Optional)
    # 設定内容: グループの検索基準を指定します。
    # 設定可能な値: LDAP検索フィルター文字列
    role_search_matching = "(member=uid={0},ou=users,dc=example,dc=com)"

    # role_search_subtree (Optional)
    # 設定内容: ディレクトリ検索スコープをサブツリー全体にするかを指定します。
    # 設定可能な値:
    #   - true: サブツリー全体を検索
    #   - false: 指定のディレクトリのみ検索
    role_search_subtree = false

    # service_account_password (Optional)
    # 設定内容: LDAPサーバーへの接続に使用するサービスアカウントのパスワードを指定します。
    # 設定可能な値: 文字列（機密情報としてstateに平文保存される）
    service_account_password = "service-account-password"

    # service_account_username (Optional)
    # 設定内容: LDAPサーバーへの接続に使用するサービスアカウントのユーザー名を指定します。
    # 設定可能な値: 文字列
    service_account_username = "cn=service-account,ou=users,dc=example,dc=com"

    # user_base (Optional)
    # 設定内容: ユーザーを検索するディレクトリの完全修飾名を指定します。
    # 設定可能な値: 有効なLDAP DN（識別名）文字列
    user_base = "ou=users,dc=example,dc=com"

    # user_role_name (Optional)
    # 設定内容: ユーザーグループメンバーシップのLDAP属性名を指定します。
    # 設定可能な値: 文字列
    user_role_name = "memberOf"

    # user_search_matching (Optional)
    # 設定内容: ユーザーの検索基準を指定します。
    # 設定可能な値: LDAP検索フィルター文字列
    user_search_matching = "(uid={0})"

    # user_search_subtree (Optional)
    # 設定内容: ユーザー検索においてディレクトリ検索スコープをサブツリー全体にするかを指定します。
    # 設定可能な値:
    #   - true: サブツリー全体を検索
    #   - false: 指定のディレクトリのみ検索
    user_search_subtree = false
  }

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # logs (Optional)
  # 設定内容: CloudWatch Logsへのロギング設定を指定するブロックです。
  # 参考: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/security-logging-monitoring.html
  logs {

    # audit (Optional)
    # 設定内容: 監査ログを有効にするかを指定します。ActiveMQのみ対応。JMXまたはActiveMQ Webコンソール経由のユーザー管理操作を記録します。
    # 設定可能な値: "true" または "false" の文字列
    # 省略時: false
    audit = "false"

    # general (Optional)
    # 設定内容: CloudWatch経由の一般ログを有効にするかを指定します。
    # 設定可能な値:
    #   - true: 一般ログを有効化
    #   - false: 一般ログを無効化
    # 省略時: false
    general = false
  }

  #-------------------------------------------------------------
  # メンテナンスウィンドウ設定
  #-------------------------------------------------------------

  # maintenance_window_start_time (Optional)
  # 設定内容: メンテナンスウィンドウの開始時刻を指定するブロックです。
  # 参考: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/maintaining-brokers.html
  maintenance_window_start_time {

    # day_of_week (Required)
    # 設定内容: メンテナンスウィンドウの曜日を指定します。
    # 設定可能な値: "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"
    day_of_week = "SUNDAY"

    # time_of_day (Required)
    # 設定内容: メンテナンスウィンドウの開始時刻を24時間形式で指定します。
    # 設定可能な値: "HH:MM"形式の文字列（例: "02:00"）
    time_of_day = "02:00"

    # time_zone (Required)
    # 設定内容: メンテナンスウィンドウのタイムゾーンを指定します。
    # 設定可能な値: Country/City形式またはUTCオフセット形式（例: "UTC", "CET", "US/Eastern"）
    time_zone = "UTC"
  }

  #-------------------------------------------------------------
  # ユーザー設定
  #-------------------------------------------------------------

  # user (Required)
  # 設定内容: ブローカーのユーザーを設定するブロックです（最低1つ必須）。
  # 注意:
  #   - RabbitMQの場合、ブローカー作成時に管理ユーザーを1つのみ作成可能
  #   - RabbitMQのユーザー情報はAPIで返されないため、ドリフト検出は不可
  #   - userブロックへの変更はブローカーの再作成をトリガーします
  #   - ユーザー名・パスワードはstateに平文で保存されます
  user {

    # username (Required)
    # 設定内容: ユーザーのユーザー名を指定します。
    # 設定可能な値: 文字列
    username = "admin"

    # password (Required)
    # 設定内容: ユーザーのパスワードを指定します。
    # 設定可能な値: 12-250文字の文字列。4つ以上のユニーク文字を含み、カンマを含まないこと
    # 注意: パスワードはstateに平文で保存されます
    password = "SecurePassword123!"

    # console_access (Optional)
    # 設定内容: ActiveMQ Webコンソールへのアクセスを有効にするかを指定します。ActiveMQのみ適用。
    # 設定可能な値:
    #   - true: Webコンソールアクセスを許可
    #   - false: Webコンソールアクセスを禁止
    console_access = false

    # groups (Optional)
    # 設定内容: ActiveMQユーザーが属するグループのリストを指定します。ActiveMQのみ適用。
    # 設定可能な値: 最大20のグループ名のセット
    groups = []

    # replication_user (Optional)
    # 設定内容: このユーザーをレプリケーションユーザーとして設定するかを指定します。
    # 設定可能な値:
    #   - true: レプリケーションユーザーとして設定（CRDRを使用する場合に必要）
    #   - false: 通常ユーザーとして設定
    # 省略時: false
    replication_user = false
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などのGoのtime.Duration形式の文字列
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などのGoのtime.Duration形式の文字列
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などのGoのtime.Duration形式の文字列
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
  tags = {
    Name        = "example-broker"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ブローカーのAmazon Resource Name (ARN)
# - id: Amazon MQがブローカーに割り当てる一意のID
# - instances: ブローカーインスタンス情報のリスト（アクティブ・スタンバイ両方を含む）
#              instances.0.console_url: ActiveMQ WebコンソールまたはRabbitMQ管理UIのURL
#              instances.0.ip_address: ブローカーのIPアドレス
#              instances.0.endpoints: ブローカーのワイヤーレベルプロトコルエンドポイントのリスト
# - pending_data_replication_mode: 再起動後に適用されるデータレプリケーションモード
# - tags_all: プロバイダーのdefault_tags設定から継承されたタグを含む全タグマップ
#---------------------------------------------------------------
