#-------------------------------------------------------------------------------
# Terraform AWS ElastiCache Replication Group 完全リファレンステンプレート
# Provider Version: 6.28.0
# Resource: aws_elasticache_replication_group
# Generated: 2026-02-17
#
# 概要:
#   ElastiCacheレプリケーショングループを作成します。
#   RedisまたはValkeyの高可用性クラスタを構築でき、
#   クラスタモード有効/無効の両方に対応します。
#
# 主な用途:
#   - Redis/Valkeyの高可用性クラスタ構築
#   - 読み取りレプリカによる負荷分散
#   - クラスタモード有効での水平スケーリング
#   - マルチAZ構成による障害対応
#   - 保管時/転送時の暗号化
#
# NOTE:
#   - クラスタモード有効化にはパラメータグループで cluster-enabled=true が必要
#   - automatic_failover_enabled を有効化する場合は num_cache_clusters >= 2
#   - transit_encryption_enabled を変更する場合、エンジンバージョン 7.0.5 未満では再作成
#   - apply_immediately=false の場合、変更は次のメンテナンスウィンドウで適用
#   - num_cache_clusters と num_node_groups は併用不可
#
# 参考ドキュメント:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/elasticache_replication_group
#   - https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Replication.html
#-------------------------------------------------------------------------------

resource "aws_elasticache_replication_group" "example" {
  #-------
  # 必須パラメータ
  #-------

  # 設定内容: レプリケーショングループの一意識別子
  # 設定可能な値: 1-40文字の英数字とハイフン（小文字で保存される）
  # 備考: 作成後の変更は不可（再作成が必要）
  replication_group_id = "my-redis-cluster"

  # 設定内容: レプリケーショングループの説明文
  # 設定可能な値: 空でない任意の文字列
  # 備考: 必須項目
  description = "Production Redis cluster for session management"

  #-------
  # エンジン設定
  #-------

  # 設定内容: キャッシュエンジンの種類
  # 設定可能な値: redis | valkey
  # 省略時: redis
  engine = "redis"

  # 設定内容: エンジンのバージョン番号
  # 設定可能な値: 5.0.6, 6.x, 7.2 など
  # 省略時: 最新のマイナーバージョン
  # 備考: バージョン7以降はメジャー.マイナーを指定（例: 7.2）
  #       バージョン6は 6.x または 6.2 形式で指定可能
  #       実際のバージョンは engine_version_actual 属性で取得可能
  engine_version = "7.2"

  # 設定内容: マイナーバージョンの自動アップグレード有効化
  # 設定可能な値: true | false | stable
  # 省略時: true
  # 備考: redis と valkey のバージョン6以降でのみサポート
  auto_minor_version_upgrade = "true"

  #-------
  # ノード構成（クラスタモード無効）
  #-------

  # 設定内容: インスタンスクラス
  # 設定可能な値: cache.t2.micro, cache.m5.large, cache.r6g.xlarge など
  # 備考: global_replication_group_id 指定時は設定不可
  #       サポートされるノードタイプは AWS ドキュメント参照
  node_type = "cache.r6g.large"

  # 設定内容: クラスタ内のキャッシュノード数（プライマリ + レプリカ）
  # 設定可能な値: 1以上の整数
  # 省略時: 1
  # 備考: automatic_failover_enabled または multi_az_enabled が true の場合は 2 以上必須
  #       num_node_groups / replicas_per_node_group とは併用不可
  num_cache_clusters = 2

  # 設定内容: キャッシュクラスタを配置するAZのリスト
  # 設定可能な値: AZの文字列リスト（例: ["us-east-1a", "us-east-1b"]）
  # 備考: リストの最初の項目がプライマリノードのAZとなる
  #       更新時は無視される
  #       node_group_configuration とは併用不可
  preferred_cache_cluster_azs = ["ap-northeast-1a", "ap-northeast-1c"]

  #-------
  # ノード構成（クラスタモード有効）
  #-------

  # 設定内容: ノードグループ（シャード）の数
  # 設定可能な値: 1以上の整数
  # 備考: num_cache_clusters とは併用不可
  #       global_replication_group_id 指定時は設定不可
  #       変更時は他の設定変更より先にリサイズが実行される
  num_node_groups = 2

  # 設定内容: 各ノードグループのレプリカノード数
  # 設定可能な値: 0-5
  # 備考: num_node_groups が設定されている場合のみ指定可能
  #       num_cache_clusters とは併用不可
  replicas_per_node_group = 1

  #-------
  # クラスタモード設定
  #-------

  # 設定内容: クラスタモードの有効/無効
  # 設定可能な値: enabled | disabled | compatible
  # 省略時: パラメータグループの cluster-enabled 設定に基づいて自動判定
  # 備考: クラスタモード有効化には cluster-enabled=true のパラメータグループが必要
  cluster_mode = "disabled"

  #-------
  # 高可用性設定
  #-------

  # 設定内容: 自動フェイルオーバーの有効化
  # 設定可能な値: true | false
  # 省略時: false
  # 備考: 有効化する場合は num_cache_clusters >= 2 が必須
  #       クラスタモード有効時は必須
  automatic_failover_enabled = true

  # 設定内容: マルチAZサポートの有効化
  # 設定可能な値: true | false
  # 省略時: false
  # 備考: true の場合は automatic_failover_enabled も有効化が必要
  multi_az_enabled = true

  #-------
  # ネットワーク設定
  #-------

  # 設定内容: 接続に使用するIPバージョン
  # 設定可能な値: ipv4 | ipv6 | dual_stack
  # 省略時: ipv4
  network_type = "ipv4"

  # 設定内容: IPディスカバリプロトコルでアドバタイズするIPバージョン
  # 設定可能な値: ipv4 | ipv6
  # 省略時: ipv4
  ip_discovery = "ipv4"

  # 設定内容: キャッシュノードが接続を受け入れるポート番号
  # 設定可能な値: 1024-65535
  # 省略時: Redis/Valkey は 6379、Memcache は 11211
  port = 6379

  # 設定内容: サブネットグループの名前
  # 設定可能な値: 既存のサブネットグループ名
  # 省略時: デフォルトサブネットグループ
  # 備考: VPC内でレプリケーショングループを作成する場合に使用
  subnet_group_name = "my-elasticache-subnet-group"

  # 設定内容: VPCセキュリティグループID
  # 設定可能な値: セキュリティグループIDのセット
  # 備考: VPC内でレプリケーショングループを作成する場合に使用
  security_group_ids = ["sg-12345678"]

  # 設定内容: VPCセキュリティグループ名
  # 設定可能な値: セキュリティグループ名のセット
  # 備考: EC2-Classic環境でのみ使用（非推奨）
  security_group_names = []

  #-------
  # パラメータ設定
  #-------

  # 設定内容: パラメータグループの名前
  # 設定可能な値: 既存のパラメータグループ名
  # 省略時: 指定されたエンジンのデフォルトパラメータグループ
  # 備考: クラスタモード有効化には cluster-enabled=true のパラメータグループが必要
  #       （例: default.redis7.cluster.on）
  parameter_group_name = "default.redis7"

  #-------
  # 暗号化設定
  #-------

  # 設定内容: 保管時の暗号化有効化
  # 設定可能な値: true | false
  # 省略時: redis エンジンは false、valkey エンジンは true
  # 備考: 作成後の変更は不可（再作成が必要）
  at_rest_encryption_enabled = "true"

  # 設定内容: 暗号化に使用するKMSキーのARN
  # 設定可能な値: KMSキーのARN
  # 備考: at_rest_encryption_enabled = true の場合のみ指定可能
  #       省略時はサービス管理の暗号化キーを使用
  kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # 設定内容: 転送時の暗号化有効化
  # 設定可能な値: true | false
  # 省略時: false
  # 備考: エンジンバージョン 7.0.5 未満で変更すると再作成が必要
  transit_encryption_enabled = true

  # 設定内容: 転送時暗号化の移行モード
  # 設定可能な値: preferred | required
  # 備考: 既存レプリケーショングループで暗号化を有効化する際に使用
  #       まず preferred を設定し、次の apply で required に変更する
  transit_encryption_mode = "preferred"

  # 設定内容: パスワード保護されたサーバーへのアクセスパスワード
  # 設定可能な値: 16-128文字の英数字と記号
  # 備考: transit_encryption_enabled = true の場合のみ指定可能
  #       機密情報のため sensitive 属性が設定される
  auth_token = "YourSecureAuthToken123!"

  # 設定内容: auth_token 変更時の更新戦略
  # 設定可能な値: SET | ROTATE | DELETE
  # 省略時: AWS デフォルトで ROTATE
  # 備考: 初回作成時は使用されない
  #       DELETE を指定する場合は auth_token を省略する
  auth_token_update_strategy = "ROTATE"

  #-------
  # データ階層化設定
  #-------

  # 設定内容: データ階層化の有効化
  # 設定可能な値: true | false
  # 省略時: false
  # 備考: r6gd ノードタイプを使用する場合のみサポート
  #       r6gd ノード使用時は true 設定が必須
  data_tiering_enabled = false

  #-------
  # メンテナンスとバックアップ
  #-------

  # 設定内容: メンテナンスウィンドウの時間帯
  # 設定可能な値: ddd:hh24:mi-ddd:hh24:mi 形式（UTC、24時間表記）
  # 省略時: AWS が自動設定
  # 備考: 最小60分の期間が必要（例: sun:05:00-sun:09:00）
  maintenance_window = "sun:18:00-sun:19:00"

  # 設定内容: 変更を即座に適用するかどうか
  # 設定可能な値: true | false
  # 省略時: false
  # 備考: false の場合は次のメンテナンスウィンドウで適用
  #       true の場合はサーバー再起動により短時間のダウンタイムが発生する可能性あり
  apply_immediately = false

  # 設定内容: スナップショット保持期間（日数）
  # 設定可能な値: 0-35（0 は無効化）
  # 備考: Redis のみサポート
  #       cache.t1.micro ノードではサポート外
  snapshot_retention_limit = 5

  # 設定内容: 日次スナップショットの時間帯
  # 設定可能な値: hh24:mi-hh24:mi 形式（UTC）
  # 省略時: AWS が自動設定
  # 備考: Redis のみサポート
  #       最小60分の期間が必要（例: 05:00-09:00）
  snapshot_window = "17:00-18:00"

  # 設定内容: スナップショットから復元する際のスナップショット名
  # 設定可能な値: 既存のスナップショット名
  # 備考: 変更すると新しいリソースが作成される
  snapshot_name = "my-snapshot"

  # 設定内容: S3に保存されたRedis RDBスナップショットファイルのARNリスト
  # 設定可能な値: S3オブジェクトのARNのセット
  # 備考: オブジェクト名にカンマを含めることはできない
  snapshot_arns = []

  # 設定内容: 削除時に作成する最終スナップショットの名前
  # 設定可能な値: スナップショット名として有効な文字列
  # 備考: 省略時は最終スナップショットを作成しない
  final_snapshot_identifier = "my-final-snapshot"

  #-------
  # 通知設定
  #-------

  # 設定内容: ElastiCache通知の送信先SNSトピックARN
  # 設定可能な値: SNSトピックのARN
  # 備考: キャッシュクラスタのイベント通知を受信
  notification_topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:elasticache-notifications"

  #-------
  # ユーザーグループ設定
  #-------

  # 設定内容: レプリケーショングループに関連付けるユーザーグループID
  # 設定可能な値: ユーザーグループIDのセット（最大1つ）
  # 備考: AWS仕様では複数IDをサポートしているが、実際には最大1つまで
  user_group_ids = ["my-user-group"]

  #-------
  # グローバルレプリケーショングループ設定
  #-------

  # 設定内容: このレプリケーショングループが属するグローバルレプリケーショングループのID
  # 設定可能な値: 既存のグローバルレプリケーショングループID
  # 備考: 指定するとセカンダリレプリケーショングループとして追加される
  #       指定時は num_node_groups を設定できない
  #       指定時は node_type を設定できない
  global_replication_group_id = "global-replication-group-id"

  #-------
  # リージョン設定
  #-------

  # 設定内容: このリソースが管理されるリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1）
  # 省略時: プロバイダー設定のリージョン
  region = "ap-northeast-1"

  #-------
  # タグ設定
  #-------

  # 設定内容: リソースに割り当てるタグ
  # 設定可能な値: キー・バリューペアのマップ
  # 備考: レプリケーショングループ自体ではなく、グループ内のクラスタにタグが適用される
  tags = {
    Name        = "production-redis-cluster"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------
  # ログ配信設定（Redis のみ）
  #-------

  # 設定内容: Redis SLOWLOG のログ配信設定
  # 備考: 最大2つまで設定可能
  #       log_type は slow-log と engine-log でそれぞれ最大1つ
  log_delivery_configuration {
    # 設定内容: ログの配信先名
    # 設定可能な値: CloudWatch LogsグループまたはKinesis Data Firehoseリソース名
    destination = "my-cloudwatch-log-group"

    # 設定内容: 配信先のタイプ
    # 設定可能な値: cloudwatch-logs | kinesis-firehose
    destination_type = "cloudwatch-logs"

    # 設定内容: ログのフォーマット
    # 設定可能な値: json | text
    log_format = "json"

    # 設定内容: ログのタイプ
    # 設定可能な値: slow-log | engine-log
    # 備考: 各タイプにつき最大1つまで
    log_type = "slow-log"
  }

  # 設定内容: Redis Engine Log のログ配信設定
  log_delivery_configuration {
    destination      = "my-firehose-stream"
    destination_type = "kinesis-firehose"
    log_format       = "json"
    log_type         = "engine-log"
  }

  #-------
  # ノードグループ設定（クラスタモード有効時）
  #-------

  # 設定内容: ノードグループ（シャード）の個別設定
  # 備考: num_node_groups が設定されている場合のみ指定可能
  #       preferred_cache_cluster_azs とは併用不可
  # node_group_configuration {
  #   # 設定内容: ノードグループのID
  #   # 設定可能な値: 1-4文字の英数字
  #   # 備考: クラスタモード無効時は無視される
  #   node_group_id = "0001"

  #   # 設定内容: プライマリノードのアベイラビリティゾーン
  #   # 設定可能な値: AZ名（例: us-east-1a）
  #   primary_availability_zone = "ap-northeast-1a"

  #   # 設定内容: レプリカノードのアベイラビリティゾーンリスト
  #   # 設定可能な値: AZ名のリスト
  #   replica_availability_zones = ["ap-northeast-1c"]

  #   # 設定内容: このノードグループのレプリカノード数
  #   # 設定可能な値: 0-5
  #   replica_count = 1

  #   # 設定内容: このノードグループのキースペース
  #   # 設定可能な値: start-end 形式（例: 0-8191）
  #   # 備考: クラスタモード無効時は無視される
  #   slots = "0-8191"

  #   # 設定内容: プライマリノードのOutpost ARN
  #   # 設定可能な値: Outpost ARN
  #   # primary_outpost_arn = ""

  #   # 設定内容: レプリカノードのOutpost ARNリスト
  #   # 設定可能な値: Outpost ARNのリスト
  #   # replica_outpost_arns = []
  # }

  #-------
  # タイムアウト設定
  #-------

  timeouts {
    # 設定内容: 作成時のタイムアウト
    # 設定可能な値: 時間文字列（例: 60m, 2h）
    # 省略時: 60m
    create = "60m"

    # 設定内容: 更新時のタイムアウト
    # 設定可能な値: 時間文字列（例: 60m, 2h）
    # 省略時: 40m
    update = "40m"

    # 設定内容: 削除時のタイムアウト
    # 設定可能な値: 時間文字列（例: 60m, 2h）
    # 省略時: 40m
    delete = "40m"
  }
}

#-------------------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-------------------------------------------------------------------------------
# このリソース作成後、以下の属性を参照できます:
#
# arn                              - レプリケーショングループのARN
# engine_version_actual            - 実際に動作しているエンジンバージョン
# cluster_enabled                  - クラスタモードが有効かどうか
# configuration_endpoint_address   - クラスタモード有効時の構成エンドポイントアドレス
# id                              - レプリケーショングループのID
# member_clusters                  - レプリケーショングループに含まれる全ノードの識別子
# primary_endpoint_address         - プライマリノードのエンドポイントアドレス（クラスタモード無効時）
# reader_endpoint_address          - リーダーノードのエンドポイントアドレス（クラスタモード無効時）
# tags_all                         - プロバイダーのdefault_tagsを含む全てのタグ
#-------------------------------------------------------------------------------
