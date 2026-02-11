#---------------------------------------------------------------
# Amazon MQ Broker
#---------------------------------------------------------------
#
# Amazon MQブローカーをプロビジョニングするリソース。
# ActiveMQおよびRabbitMQエンジン用のマネージドメッセージブローカーを作成・管理する。
#
# AWS公式ドキュメント:
#   - Amazon MQ Developer Guide: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/welcome.html
#   - Amazon MQ for ActiveMQ configurations: https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/amazon-mq-broker-configuration-parameters.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_mq_broker" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # broker_name (必須・作成後変更不可)
  # ブローカーの名前。
  # 一意である必要があり、作成後に変更すると再作成される。
  broker_name = "example-broker"

  # engine_type (必須・作成後変更不可)
  # ブローカーエンジンのタイプ。
  # 有効な値: "ActiveMQ", "RabbitMQ"
  engine_type = "ActiveMQ"

  # engine_version (必須)
  # ブローカーエンジンのバージョン。
  # ActiveMQの例: "5.17.6", "5.16.7"
  # RabbitMQの例: "3.11.20", "3.10.25"
  engine_version = "5.17.6"

  # host_instance_type (必須)
  # ブローカーのインスタンスタイプ。
  # 例: "mq.t3.micro", "mq.t2.micro", "mq.m5.large", "mq.m5.xlarge"
  # RabbitMQでebs storage_typeを使用する場合はmq.m5ファミリーのみサポート。
  host_instance_type = "mq.t3.micro"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # apply_immediately (オプション)
  # ブローカーの変更を即座に適用するかどうか。
  # デフォルト: false（次のメンテナンスウィンドウで適用）
  # trueに設定すると即座に適用されるが、ブローカーの再起動により短時間のダウンタイムが発生する可能性がある。
  apply_immediately = false

  # authentication_strategy (オプション)
  # ブローカーを保護するための認証戦略。
  # 有効な値: "simple", "ldap"
  # "ldap"はRabbitMQではサポートされていない。
  # authentication_strategy = "simple"

  # auto_minor_version_upgrade (オプション)
  # Amazon MQがリリースした新しいマイナーバージョンに自動的にアップグレードするかどうか。
  # auto_minor_version_upgrade = true

  # data_replication_mode (オプション)
  # このブローカーがデータレプリケーションペアの一部であるかどうか。
  # 有効な値: "CRDR" (Cross-Region Data Replication), "NONE"
  # data_replication_mode = "NONE"

  # data_replication_primary_broker_arn (オプション)
  # データレプリケーションペアでデータを複製するために使用されるプライマリブローカーのARN。
  # data_replication_modeが"CRDR"の場合に必須。
  # data_replication_primary_broker_arn = "arn:aws:mq:us-west-2:123456789012:broker:example-primary:b-12345678-1234-1234-1234-123456789012"

  # deployment_mode (オプション・作成後変更不可)
  # ブローカーのデプロイメントモード。
  # 有効な値:
  #   - "SINGLE_INSTANCE": 単一インスタンス（開発・テスト向け）
  #   - "ACTIVE_STANDBY_MULTI_AZ": アクティブ/スタンバイ構成（本番向け、高可用性）
  #   - "CLUSTER_MULTI_AZ": クラスター構成（RabbitMQのみ）
  # デフォルト: "SINGLE_INSTANCE"
  deployment_mode = "SINGLE_INSTANCE"

  # publicly_accessible (オプション・作成後変更不可)
  # ブローカーのサブネットをホストするVPC外部からの接続を有効にするかどうか。
  # trueの場合、パブリックIPアドレスが割り当てられる。
  # publicly_accessible = false

  # region (オプション)
  # このリソースが管理されるリージョン。
  # プロバイダー設定のリージョンがデフォルト値となる。
  # region = "ap-northeast-1"

  # security_groups (オプション)
  # ブローカーに割り当てるセキュリティグループIDのリスト。
  security_groups = []

  # storage_type (オプション)
  # ブローカーのストレージタイプ。
  # ActiveMQの有効な値: "efs" (デフォルト), "ebs"
  # RabbitMQでは"ebs"のみサポート。
  # "ebs"を使用する場合はmq.m5インスタンスタイプファミリーのみサポート。
  # storage_type = "efs"

  # subnet_ids (オプション)
  # ブローカーを起動するサブネットIDのリスト。
  # SINGLE_INSTANCEデプロイメントには1つのサブネットが必要。
  # ACTIVE_STANDBY_MULTI_AZデプロイメントには複数のサブネットが必要。
  subnet_ids = []

  # tags (オプション)
  # ブローカーに割り当てるタグのマップ。
  # プロバイダーレベルのdefault_tags設定がある場合、同じキーのタグは上書きされる。
  tags = {
    Environment = "development"
  }

  #---------------------------------------------------------------
  # userブロック (必須・最低1つ)
  #---------------------------------------------------------------
  # ブローカーユーザーの設定。
  # RabbitMQエンジンの場合、Amazon MQはブローカーユーザー情報を返さないため、
  # ドリフト検出ができない点に注意。

  user {
    # username (必須)
    # ユーザーのユーザー名。
    username = "admin"

    # password (必須・機密情報)
    # ユーザーのパスワード。
    # 12〜250文字で、最低4つの異なる文字を含み、カンマを含まないこと。
    # 警告: ステートファイルにプレーンテキストで保存される。
    password = "your-secure-password"

    # console_access (オプション)
    # ActiveMQ Web Consoleへのアクセスを有効にするかどうか。
    # ActiveMQエンジンにのみ適用。RabbitMQではサポートされていない。
    # console_access = false

    # groups (オプション)
    # ActiveMQユーザーが所属するグループのリスト（最大20個）。
    # ActiveMQエンジンにのみ適用。RabbitMQではサポートされていない。
    # groups = ["admin", "users"]

    # replication_user (オプション)
    # レプリケーションユーザーとして設定するかどうか。
    # データレプリケーション（CRDR）を使用する場合に必要。
    # デフォルト: false
    # replication_user = false
  }

  #---------------------------------------------------------------
  # configurationブロック (オプション)
  #---------------------------------------------------------------
  # ブローカー設定の構成。
  # ActiveMQとRabbitMQの両方のエンジンタイプに適用。

  # configuration {
  #   # id (オプション)
  #   # 構成ID。aws_mq_configurationリソースのIDを参照。
  #   id = aws_mq_configuration.example.id
  #
  #   # revision (オプション)
  #   # 構成のリビジョン番号。
  #   revision = aws_mq_configuration.example.latest_revision
  # }

  #---------------------------------------------------------------
  # encryption_optionsブロック (オプション)
  #---------------------------------------------------------------
  # 暗号化オプションの設定。

  # encryption_options {
  #   # kms_key_id (オプション)
  #   # 保存時の暗号化に使用するKMS CMKのARN。
  #   # use_aws_owned_keyをfalseに設定する必要がある。
  #   # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  #
  #   # use_aws_owned_key (オプション)
  #   # アカウント内にないAWS所有のKMS CMKを有効にするかどうか。
  #   # デフォルト: true
  #   # falseに設定しkms_key_idを指定しない場合、アカウント内にaws/mqエイリアスの
  #   # AWSマネージドCMKが作成される。
  #   use_aws_owned_key = true
  # }

  #---------------------------------------------------------------
  # ldap_server_metadataブロック (オプション)
  #---------------------------------------------------------------
  # LDAP認証・認可の設定。
  # 接続の認証と認可に使用されるLDAPサーバーの設定。
  # RabbitMQエンジンではサポートされていない。

  # ldap_server_metadata {
  #   # hosts (オプション)
  #   # LDAPサーバーとオプションのフェイルオーバーサーバーの完全修飾ドメイン名のリスト。
  #   hosts = ["ldap.example.com"]
  #
  #   # role_base (オプション)
  #   # ユーザーのグループを検索するディレクトリの完全修飾名。
  #   role_base = "ou=groups,dc=example,dc=com"
  #
  #   # role_name (オプション)
  #   # グループメンバーシップクエリから返されるオブジェクト内のグループ名属性を識別するLDAP属性。
  #   role_name = "cn"
  #
  #   # role_search_matching (オプション)
  #   # グループの検索条件。
  #   role_search_matching = "(member=uid={0})"
  #
  #   # role_search_subtree (オプション)
  #   # ディレクトリ検索スコープがサブツリー全体かどうか。
  #   role_search_subtree = false
  #
  #   # service_account_password (オプション・機密情報)
  #   # サービスアカウントのパスワード。
  #   service_account_password = "ldap-password"
  #
  #   # service_account_username (オプション)
  #   # サービスアカウントのユーザー名。
  #   service_account_username = "cn=admin,dc=example,dc=com"
  #
  #   # user_base (オプション)
  #   # ユーザーを検索するディレクトリの完全修飾名。
  #   user_base = "ou=users,dc=example,dc=com"
  #
  #   # user_role_name (オプション)
  #   # ユーザーグループメンバーシップのLDAP属性名。
  #   user_role_name = "memberOf"
  #
  #   # user_search_matching (オプション)
  #   # ユーザーの検索条件。
  #   user_search_matching = "(uid={0})"
  #
  #   # user_search_subtree (オプション)
  #   # ディレクトリ検索スコープがサブツリー全体かどうか。
  #   user_search_subtree = false
  # }

  #---------------------------------------------------------------
  # logsブロック (オプション)
  #---------------------------------------------------------------
  # ロギング設定。

  # logs {
  #   # audit (オプション)
  #   # 監査ログを有効にするかどうか。
  #   # ActiveMQエンジンのみ可能。JMXまたはActiveMQ Web Consoleを介したユーザー管理アクションをログに記録。
  #   # デフォルト: false (文字列型)
  #   audit = "false"
  #
  #   # general (オプション)
  #   # CloudWatchを介した一般ログを有効にするかどうか。
  #   # デフォルト: false
  #   general = false
  # }

  #---------------------------------------------------------------
  # maintenance_window_start_timeブロック (オプション)
  #---------------------------------------------------------------
  # メンテナンスウィンドウの開始時間の設定。

  # maintenance_window_start_time {
  #   # day_of_week (必須)
  #   # 曜日。
  #   # 有効な値: "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"
  #   day_of_week = "SUNDAY"
  #
  #   # time_of_day (必須)
  #   # 24時間形式の時刻。例: "02:00"
  #   time_of_day = "03:00"
  #
  #   # time_zone (必須)
  #   # タイムゾーン。Country/City形式またはUTCオフセット形式。
  #   # 例: "Asia/Tokyo", "UTC", "CET"
  #   time_zone = "Asia/Tokyo"
  # }

  #---------------------------------------------------------------
  # timeoutsブロック (オプション)
  #---------------------------------------------------------------
  # 操作のタイムアウト設定。

  # timeouts {
  #   # create (オプション)
  #   # 作成操作のタイムアウト。
  #   # デフォルト: 30m
  #   create = "30m"
  #
  #   # update (オプション)
  #   # 更新操作のタイムアウト。
  #   # デフォルト: 30m
  #   update = "30m"
  #
  #   # delete (オプション)
  #   # 削除操作のタイムアウト。
  #   # デフォルト: 30m
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、他のリソースから参照可能。
# テンプレートには含めないが、output等で参照する際に使用する。
#
# arn                           - ブローカーのARN
# id                            - Amazon MQが生成するブローカーの一意のID
# instances                     - 割り当てられたブローカー（アクティブおよびスタンバイ）の情報リスト
#   instances.*.console_url     - ActiveMQ Web ConsoleまたはRabbitMQ Management UIのURL
#   instances.*.ip_address      - ブローカーのIPアドレス
#   instances.*.endpoints       - ブローカーのワイヤレベルプロトコルエンドポイント
# pending_data_replication_mode - 再起動後に適用されるデータレプリケーションモード
# tags_all                      - プロバイダーのdefault_tagsから継承されたタグを含む、リソースに割り当てられたタグのマップ
#---------------------------------------------------------------
