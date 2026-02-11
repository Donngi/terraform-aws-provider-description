#---------------------------------------------------------------
# Amazon ElastiCache Replication Group
#---------------------------------------------------------------
#
# ElastiCache Replication Groupを作成・管理するリソース。
# Redis/Valkeyクラスター（クラスターモード有効/無効）の高可用性構成を提供します。
# プライマリノードと最大5つのリードレプリカで構成され、自動フェイルオーバーや
# Multi-AZ配置をサポートします。
#
# AWS公式ドキュメント:
#   - Replication Groups: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Replication.html
#   - CreateReplicationGroup API: https://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_CreateReplicationGroup.html
#   - Modifying Cache Clusters: https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Clusters.Modify.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/elasticache_replication_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticache_replication_group" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) レプリケーショングループの識別子
  # 小文字で保存されます。英数字とハイフンのみ使用可能。
  replication_group_id = "my-redis-cluster"

  # (Required) レプリケーショングループの説明
  # 空文字列は不可。ユーザーが作成する説明文。
  description = "Example Redis replication group"

  #---------------------------------------------------------------
  # Cluster Configuration
  #---------------------------------------------------------------

  # (Optional) ノードタイプ（インスタンスクラス）
  # global_replication_group_idを設定している場合は設定不可。
  # 未設定の場合はglobal_replication_group_idが必須。
  # 例: cache.t3.micro, cache.m5.large, cache.r6g.xlarge
  # サポートされるノードタイプ: https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/CacheNodes.SupportedTypes.html
  node_type = "cache.t3.medium"

  # (Optional) キャッシュエンジン名
  # 有効な値: "redis" または "valkey"
  # デフォルト: "redis"
  engine = "redis"

  # (Optional) キャッシュエンジンのバージョン番号
  # バージョン7以上: メジャー・マイナーバージョンを指定（例: "7.2"）
  # バージョン6: メジャー・マイナーを指定可能（例: "6.2"）または"6.x"で最新を使用
  # それ以外: フルバージョン指定（例: "5.0.6"）
  # 実際に使用されるバージョンはengine_version_actual属性で取得可能
  engine_version = "7.2"

  # (Optional) パラメータグループ名
  # 未指定時は指定エンジンのデフォルトパラメータグループを使用。
  # クラスターモードを有効化するには、cluster-enabledパラメータがtrueの
  # パラメータグループを指定（例: default.redis7.cluster.on）
  parameter_group_name = "default.redis7.x"

  # (Optional) ポート番号
  # 各キャッシュノードが接続を受け付けるポート。
  # Redisのデフォルト: 6379、Memcachedのデフォルト: 11211
  port = 6379

  #---------------------------------------------------------------
  # Cluster Mode Configuration
  #---------------------------------------------------------------

  # (Optional) クラスターモードの設定
  # 有効な値: "enabled", "disabled", "compatible"
  # クラスターモード有効時はデータシャーディングが有効化されます
  cluster_mode = "disabled"

  # (Optional) キャッシュクラスター数（プライマリ + レプリカ）
  # automatic_failover_enabledまたはmulti_az_enabledがtrueの場合は2以上必須。
  # num_node_groups, replicas_per_node_groupと競合。
  # デフォルト: 1
  num_cache_clusters = 2

  # (Optional) ノードグループ（シャード）数
  # Redisレプリケーショングループ用。
  # 変更するとリサイズ操作が他の設定変更より先にトリガーされます。
  # num_cache_clustersと競合。
  # num_node_groups = 2

  # (Optional) ノードグループあたりのレプリカ数
  # 有効な値: 0〜5
  # 変更するとリサイズ操作が他の設定変更より先にトリガーされます。
  # num_cache_clustersと競合。
  # num_node_groupsが設定されている場合のみ設定可能。
  # replicas_per_node_group = 1

  #---------------------------------------------------------------
  # High Availability
  #---------------------------------------------------------------

  # (Optional) 自動フェイルオーバーの有効化
  # 既存のプライマリに障害が発生した場合、リードオンリーレプリカを
  # 自動的にリード/ライトプライマリに昇格させるか指定。
  # 有効化する場合はnum_cache_clustersが1より大きい必要があります。
  # Redis（クラスターモード有効）では必須で有効化。
  # デフォルト: false
  automatic_failover_enabled = true

  # (Optional) Multi-AZサポートの有効化
  # trueの場合、automatic_failover_enabledも有効化する必要があります。
  # デフォルト: false
  multi_az_enabled = false

  # (Optional) EC2アベイラビリティーゾーンのリスト
  # レプリケーショングループのキャッシュクラスターが作成されるAZ。
  # リストの順序が考慮され、最初の項目がプライマリノードになります。
  # 更新時は無視されます。preferred_cache_cluster_azsと競合。
  preferred_cache_cluster_azs = ["us-west-2a", "us-west-2b"]

  #---------------------------------------------------------------
  # Security & Encryption
  #---------------------------------------------------------------

  # (Optional) 保管時の暗号化を有効化
  # engineが"redis"の場合のデフォルト: false
  # engineが"valkey"の場合のデフォルト: true
  at_rest_encryption_enabled = true

  # (Optional) 転送中の暗号化を有効化
  # engine_version < 7.0.5の場合、この引数を変更するとリソース再作成が発生。
  # 7.0.5未満のエンジンバージョンでは作成時のみ設定可能。
  transit_encryption_enabled = true

  # (Optional) 転送中の暗号化モード
  # 有効な値: "preferred", "required"
  # 既存レプリケーショングループで暗号化を有効化する場合、
  # 最初に"preferred"に設定し、次のapplyで"required"に設定する必要があります。
  # transit_encryption_mode = "preferred"

  # (Optional) 保管時の暗号化に使用するKMSキーのARN
  # 未指定の場合はサービスマネージド暗号化を使用。
  # at_rest_encryption_enabled = trueの場合のみ指定可能。
  # kms_key_id = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"

  # (Optional) パスワード保護されたサーバーへのアクセスに使用するパスワード
  # transit_encryption_enabled = trueの場合のみ指定可能。
  # 機密情報のため、変数やシークレット管理システムから取得することを推奨。
  # auth_token = var.redis_auth_token

  # (Optional) 既存レプリケーショングループでauth_tokenを変更する際の戦略
  # 初回作成時には使用されません。
  # 有効な値: "SET", "ROTATE", "DELETE"
  # 未指定の場合、AWSは"ROTATE"をデフォルトとします。
  # auth_token_update_strategy = "ROTATE"

  #---------------------------------------------------------------
  # Network Configuration
  #---------------------------------------------------------------

  # (Optional) キャッシュサブネットグループ名
  # レプリケーショングループで使用するサブネットグループ。
  subnet_group_name = "my-cache-subnet-group"

  # (Optional) VPCセキュリティグループID
  # Amazon VPCでレプリケーショングループを作成する場合のみ使用。
  security_group_ids = ["sg-12345678"]

  # (Optional) VPCセキュリティグループ名
  # Amazon VPCでレプリケーショングループを作成する場合のみ使用。
  # security_group_names = ["my-security-group"]

  # (Optional) ネットワークタイプ
  # 有効な値: "ipv4", "ipv6", "dual_stack"
  # network_type = "ipv4"

  # (Optional) ディスカバリープロトコルでアドバタイズするIPバージョン
  # 有効な値: "ipv4", "ipv6"
  # ip_discovery = "ipv4"

  #---------------------------------------------------------------
  # Maintenance & Updates
  #---------------------------------------------------------------

  # (Optional) 変更を即座に適用するか、次のメンテナンスウィンドウで適用するか
  # デフォルト: false（次のメンテナンスウィンドウで適用）
  # trueの場合、サーバー再起動により短時間のダウンタイムが発生する可能性があります。
  # リソース再作成を伴う変更は、この値に関係なく即座に適用されます。
  apply_immediately = false

  # (Optional) マイナーバージョンの自動アップグレード
  # メンテナンスウィンドウ中にマイナーバージョンのエンジンアップグレードを
  # 自動的に適用するか指定。
  # エンジンタイプ"redis"/"valkey"でエンジンバージョン6以上の場合のみサポート。
  # デフォルト: true
  auto_minor_version_upgrade = true

  # (Optional) メンテナンスウィンドウ
  # キャッシュクラスターのメンテナンスが実行される週次の時間範囲。
  # フォーマット: ddd:hh24:mi-ddd:hh24:mi（24時間表記UTC）
  # 最小メンテナンスウィンドウは60分。
  # 例: "sun:05:00-sun:09:00"
  maintenance_window = "sun:05:00-sun:09:00"

  #---------------------------------------------------------------
  # Backup & Snapshots
  #---------------------------------------------------------------

  # (Optional) スナップショット保持期間（日数）
  # Redis専用。ElastiCacheが自動スナップショットを削除するまでの日数。
  # 0に設定するとバックアップが無効化されます。
  # cache.t1.microノードタイプでは設定不可。
  snapshot_retention_limit = 5

  # (Optional) スナップショットウィンドウ
  # Redis専用。ElastiCacheが日次スナップショットを開始する時間範囲（UTC）。
  # 最小スナップショットウィンドウは60分。
  # 例: "05:00-09:00"
  snapshot_window = "03:00-05:00"

  # (Optional) 最終スナップショット識別子
  # 最終ノードグループ（シャード）スナップショットの名前。
  # ElastiCacheはクラスターのプライマリノードからスナップショットを作成。
  # 未指定の場合、最終スナップショットは作成されません。
  # final_snapshot_identifier = "my-final-snapshot"

  # (Optional) スナップショットARNのリスト
  # Amazon S3に保存されているRedis RDBスナップショットファイルを識別するARN。
  # オブジェクト名にカンマを含めることはできません。
  # snapshot_arns = ["arn:aws:s3:::my-bucket/snapshot1.rdb"]

  # (Optional) スナップショット名
  # 新しいノードグループにデータを復元するスナップショットの名前。
  # snapshot_nameを変更するとリソースが強制的に再作成されます。
  # snapshot_name = "my-snapshot"

  #---------------------------------------------------------------
  # Data Tiering
  #---------------------------------------------------------------

  # (Optional) データティアリングの有効化
  # データティアリングはr6gdノードタイプを使用するレプリケーショングループ
  # でのみサポートされます。r6gdノード使用時はtrueに設定する必要があります。
  # data_tiering_enabled = true

  #---------------------------------------------------------------
  # Global Replication
  #---------------------------------------------------------------

  # (Optional) グローバルレプリケーショングループID
  # このレプリケーショングループが所属すべきグローバルレプリケーショングループのID。
  # 指定すると、レプリケーショングループはセカンダリとして追加されます。
  # global_replication_group_idが設定されている場合、num_node_groupsは設定不可。
  # global_replication_group_id = "my-global-replication-group"

  #---------------------------------------------------------------
  # Notifications
  #---------------------------------------------------------------

  # (Optional) SNSトピックARN
  # ElastiCache通知を送信するSNSトピックのARN。
  # 例: "arn:aws:sns:us-east-1:012345678999:my_sns_topic"
  # notification_topic_arn = "arn:aws:sns:us-west-2:123456789012:elasticache-notifications"

  #---------------------------------------------------------------
  # User Groups & Access Control
  #---------------------------------------------------------------

  # (Optional) ユーザーグループIDのセット
  # レプリケーショングループに関連付けるユーザーグループID。
  # AWS仕様では複数IDを許可していますが、実際には最大1つのみ有効。
  # user_group_ids = ["my-user-group"]

  #---------------------------------------------------------------
  # Region Configuration
  #---------------------------------------------------------------

  # (Optional) リソースを管理するリージョン
  # プロバイダー設定で設定されたリージョンがデフォルト。
  # region = "us-west-2"

  #---------------------------------------------------------------
  # Tags
  #---------------------------------------------------------------

  # (Optional) リソースに割り当てるタグのマップ
  # このリソースにタグを追加すると、レプリケーショングループ内のクラスターに
  # タグが追加/上書きされ、グループ自体には適用されません。
  tags = {
    Name        = "example-replication-group"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # (Optional) プロバイダーのdefault_tagsで定義されたタグを含む全タグ
  # プロバイダーレベルで定義されたタグとマージされます。
  # tags_all は通常、明示的に設定する必要はありません（計算値）
  # tags_all = {}

  #---------------------------------------------------------------
  # Deprecated/Alternative Parameters
  #---------------------------------------------------------------

  # (Optional) リソースID
  # 通常は明示的に設定せず、Terraformによって管理されます。
  # 互換性のために存在しますが、replication_group_idを使用することを推奨。
  # id = "my-redis-cluster"

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # log_delivery_configuration - ログ配信設定（Redis専用、最大2つ）
  # Redis SLOWLOG または Engine Log の配信先とフォーマットを指定。
  # https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Log_Delivery.html
  #
  # log_delivery_configuration {
  #   # (Required) CloudWatch Logs LogGroupまたはKinesis Data Firehoseリソース名
  #   destination = "my-log-group"
  #
  #   # (Required) 配信先タイプ
  #   # CloudWatch Logsの場合: "cloudwatch-logs"
  #   # Kinesis Data Firehoseの場合: "kinesis-firehose"
  #   destination_type = "cloudwatch-logs"
  #
  #   # (Required) ログフォーマット
  #   # 有効な値: "json" または "text"
  #   log_format = "json"
  #
  #   # (Required) ログタイプ
  #   # 有効な値: "slow-log" または "engine-log"
  #   # それぞれ最大1つまで設定可能
  #   log_type = "slow-log"
  # }
  #
  # log_delivery_configuration {
  #   destination      = "my-firehose-stream"
  #   destination_type = "kinesis-firehose"
  #   log_format       = "json"
  #   log_type         = "engine-log"
  # }

  # node_group_configuration - ノードグループ（シャード）設定
  # num_node_groupsが設定されている場合のみ指定可能。
  # preferred_cache_cluster_azsと競合。
  #
  # node_group_configuration {
  #   # (Optional) ノードグループID
  #   # Redis（クラスターモード無効）では無視されます。
  #   # Redis（クラスターモード有効）では1〜4文字の英数字。
  #   node_group_id = "0001"
  #
  #   # (Optional) プライマリノードのアベイラビリティーゾーン
  #   primary_availability_zone = "us-west-2a"
  #
  #   # (Optional) プライマリノードのOutpost ARN
  #   # primary_outpost_arn = "arn:aws:outposts:us-west-2:123456789012:outpost/op-1234567890abcdef0"
  #
  #   # (Optional) レプリカノードのアベイラビリティーゾーンリスト
  #   replica_availability_zones = ["us-west-2b", "us-west-2c"]
  #
  #   # (Optional) このノードグループのレプリカ数
  #   replica_count = 2
  #
  #   # (Optional) レプリカノードのOutpost ARNリスト
  #   # replica_outpost_arns = ["arn:aws:outposts:us-west-2:123456789012:outpost/op-abcdefghijklmnop0"]
  #
  #   # (Optional) このノードグループのキースペース
  #   # フォーマット: start-end（例: "0-5460"）
  #   # Redis（クラスターモード無効）では無視されます。
  #   slots = "0-8191"
  # }

  # timeouts - タイムアウト設定
  # Terraformがリソース操作を待機する時間を指定。
  #
  # timeouts {
  #   # (Optional) 作成タイムアウト（デフォルト: 60m）
  #   create = "60m"
  #
  #   # (Optional) 更新タイムアウト（デフォルト: 40m）
  #   update = "40m"
  #
  #   # (Optional) 削除タイムアウト（デフォルト: 40m）
  #   delete = "40m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Read-Only)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed-only属性）。
# Terraformコード内で明示的に設定することはできません。
#
# - arn
#     作成されたElastiCache Replication GroupのARN
#
# - engine_version_actual
#     ElastiCacheが最新のマイナー/パッチバージョンを取得するため、
#     この属性はキャッシュエンジンの実行バージョンを返します
#
# - cluster_enabled
#     クラスターモードが有効かどうかを示します
#
# - configuration_endpoint_address
#     クラスターモード有効時のレプリケーショングループ設定エンドポイントアドレス
#
# - id
#     ElastiCache Replication GroupのID
#
# - member_clusters
#     このレプリケーショングループの一部である全ノードの識別子
#
# - primary_endpoint_address
#     （Redis専用）クラスターモード無効時のプライマリノードエンドポイントアドレス
#
# - reader_endpoint_address
#     （Redis専用）クラスターモード無効時のリーダーノードエンドポイントアドレス
#
# - tags_all
#     リソースに割り当てられた全タグのマップ
#     プロバイダーのdefault_tagsから継承されたタグを含む
#
# - region (computed)
#     リソースが実際にデプロイされているリージョン
#
#---------------------------------------------------------------
# 使用例の参照
#---------------------------------------------------------------
#
# output "primary_endpoint" {
#   description = "Primary endpoint address"
#   value       = aws_elasticache_replication_group.example.primary_endpoint_address
# }
#
# output "reader_endpoint" {
#   description = "Reader endpoint address"
#   value       = aws_elasticache_replication_group.example.reader_endpoint_address
# }
#
# output "configuration_endpoint" {
#   description = "Configuration endpoint address (cluster mode enabled)"
#   value       = aws_elasticache_replication_group.example.configuration_endpoint_address
# }
#
#---------------------------------------------------------------
