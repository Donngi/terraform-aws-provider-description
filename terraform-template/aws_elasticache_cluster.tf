#---------------------------------------------------------------
# Amazon ElastiCache Cluster
#---------------------------------------------------------------
#
# ElastiCacheクラスターをプロビジョニングします。このリソースは、
# Memcachedクラスター、単一ノードのRedisインスタンス、または
# Redis（クラスターモード有効）レプリケーショングループの読み取りレプリカを管理します。
#
# ユースケース:
#   - Memcachedクラスター: シンプルなキャッシュレイヤー
#   - Redisインスタンス: 単一ノードのデータストア
#   - 読み取りレプリカ: レプリケーショングループのスケールアウト
#
# AWS公式ドキュメント:
#   - What is Amazon ElastiCache?: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/WhatIs.html
#   - ElastiCache Components: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/WhatIs.Components.html
#   - Managing Clusters: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Clusters.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/elasticache_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticache_cluster" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # クラスター識別子（必須）
  # ElastiCacheは自動的に小文字に変換します。
  # 変更するとリソースが再作成されます。
  cluster_id = "my-cluster"

  #---------------------------------------------------------------
  # 基本設定（エンジン・ノード）
  #---------------------------------------------------------------

  # キャッシュエンジン名
  # replication_group_idが指定されていない場合は必須です。
  # 有効な値: "memcached", "redis", "valkey"
  # 参考: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/engine-versions.html
  engine = "redis"

  # エンジンバージョン
  # 未指定の場合、最新バージョンがデフォルトで使用されます。
  # Redis 7以降: メジャー・マイナーバージョンを指定（例: "7.2"）
  # Redis 6: メジャー・マイナーバージョンを指定可能、またはマイナーバージョン省略で最新を使用（例: "6.x"）
  # それ以外: 完全バージョンを指定（例: "5.0.6"）
  # 実際に使用されているバージョンは engine_version_actual 属性で取得できます。
  # replication_group_idと併用不可。
  # 参考: https://docs.aws.amazon.com/cli/latest/reference/elasticache/describe-cache-engine-versions.html
  engine_version = "7.2"

  # ノードタイプ（インスタンスクラス）
  # replication_group_idが指定されていない場合は必須です。
  # Redisの場合の参考: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/CacheNodes.SupportedTypes.html#CacheNodes.CurrentGen
  # Memcachedの場合、変更するとリソースが再作成されます。
  node_type = "cache.t3.micro"

  # キャッシュノードの初期数
  # replication_group_idが指定されていない場合は必須です。
  # Redis: 値は1である必要があります
  # Memcached: 1〜40の範囲で指定可能
  # 後続の実行で値を減らすと、番号の大きいノードから削除されます。
  num_cache_nodes = 1

  # パラメータグループ名
  # replication_group_idが指定されていない場合は必須です。
  # すべてのノードが同じ設定で構成されるように、クラスターに関連付けるパラメータグループの名前。
  parameter_group_name = "default.redis7"

  #---------------------------------------------------------------
  # ネットワーク設定
  #---------------------------------------------------------------

  # アベイラビリティーゾーン
  # マルチAZでキャッシュノードを作成する場合は、代わりに preferred_availability_zones を使用してください。
  # デフォルト: システムが選択したアベイラビリティーゾーン
  # 変更するとリソースが再作成されます。
  # availability_zone = "us-east-1a"

  # AZモード（Memcachedのみ）
  # このMemcachedノードグループのノードが単一のアベイラビリティーゾーンに作成されるか、
  # クラスターのリージョン内の複数のアベイラビリティーゾーンにまたがって作成されるかを指定します。
  # 有効な値: "single-az" または "cross-az"（デフォルト: "single-az"）
  # "cross-az"を選択する場合、num_cache_nodesは1より大きい必要があります。
  # az_mode = "single-az"

  # 優先アベイラビリティーゾーン（Memcachedのみ）
  # キャッシュノードが作成されるアベイラビリティーゾーンのリスト。
  # VPC内でクラスターを作成する場合、選択したサブネットグループのサブネットに
  # 関連付けられているアベイラビリティーゾーンにのみノードを配置できます。
  # リストに指定するアベイラビリティーゾーンの数は num_cache_nodes の値と等しい必要があります。
  # すべてのノードを同じアベイラビリティーゾーンに配置する場合は、代わりに availability_zone を使用するか、
  # リスト内でアベイラビリティーゾーンを複数回繰り返してください。
  # デフォルト: システムが選択したアベイラビリティーゾーン
  # 既存ノードのアベイラビリティーゾーンのドリフト検出は現在サポートされていません。
  # preferred_availability_zones = ["us-east-1a", "us-east-1b"]

  # IPバージョン検出
  # ディスカバリープロトコルでアドバタイズするIPバージョン。
  # 有効な値: "ipv4" または "ipv6"
  # ip_discovery = "ipv4"

  # ネットワークタイプ
  # キャッシュクラスター接続のIPバージョン。
  # IPv6は、すべてのNitroシステムインスタンスでRedisエンジン6.2以降または
  # Memcachedバージョン1.6.6でサポートされています。
  # 有効な値: "ipv4", "ipv6", "dual_stack"
  # network_type = "ipv4"

  # ポート番号
  # 各キャッシュノードが接続を受け入れるポート番号。
  # Memcachedのデフォルトは11211、Redisのデフォルトは6379です。
  # replication_group_idと併用不可。
  # 変更するとリソースが再作成されます。
  # port = 6379

  # VPCセキュリティグループID（VPCのみ）
  # キャッシュクラスターに関連付けられた1つ以上のVPCセキュリティグループ。
  # replication_group_idと併用不可。
  # security_group_ids = ["sg-12345678"]

  # サブネットグループ名（VPCのみ）
  # キャッシュクラスターに使用するサブネットグループの名前。
  # 変更するとリソースが再作成されます。
  # replication_group_idと併用不可。
  # subnet_group_name = "my-subnet-group"

  #---------------------------------------------------------------
  # レプリケーション設定
  #---------------------------------------------------------------

  # レプリケーショングループID
  # このクラスターが属するレプリケーショングループのID。
  # このパラメータが指定されている場合、クラスターは指定されたレプリケーショングループに
  # 読み取りレプリカとして追加されます。それ以外の場合、クラスターはレプリケーショングループの
  # 一部ではないスタンドアロンプライマリです。
  # engineが指定されていない場合は必須です。
  # replication_group_id = "my-replication-group"

  #---------------------------------------------------------------
  # メンテナンス・アップグレード設定
  #---------------------------------------------------------------

  # 即座に適用
  # データベースの変更を即座に適用するか、次のメンテナンスウィンドウ中に適用するか。
  # デフォルト: false
  # 使用すると、サーバーの再起動により短時間のダウンタイムが発生する可能性があります。
  # 参考: https://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_ModifyCacheCluster.html
  # apply_immediately = false

  # 自動マイナーバージョンアップグレード
  # メンテナンスウィンドウ中に、マイナーバージョンエンジンのアップグレードが
  # 基礎となるキャッシュクラスターインスタンスに自動的に適用されるかどうかを指定します。
  # エンジンタイプが "redis" でエンジンバージョンが6以降の場合のみサポートされています。
  # デフォルト: true
  # auto_minor_version_upgrade = "true"

  # メンテナンスウィンドウ
  # キャッシュクラスターのメンテナンスが実行される週次時間範囲を指定します。
  # 形式: ddd:hh24:mi-ddd:hh24:mi（24時間制UTC）
  # 最小メンテナンスウィンドウは60分間です。
  # 例: "sun:05:00-sun:09:00"
  # maintenance_window = "sun:05:00-sun:09:00"

  #---------------------------------------------------------------
  # スナップショット・バックアップ設定（Redisのみ）
  #---------------------------------------------------------------

  # 最終スナップショット識別子（Redisのみ）
  # 最終クラスタースナップショットの名前。
  # 省略すると、最終スナップショットは作成されません。
  # final_snapshot_identifier = "my-final-snapshot"

  # スナップショットARN（Redisのみ）
  # Amazon S3に保存されているRedis RDBスナップショットファイルのAmazon Resource Name（ARN）を
  # 含む単一要素の文字列リスト。
  # オブジェクト名にカンマを含めることはできません。
  # snapshot_arnsを変更すると、新しいリソースが強制されます。
  # snapshot_arns = ["arn:aws:s3:::my-bucket/snapshot.rdb"]

  # スナップショット名（Redisのみ）
  # 新しいノードグループにデータを復元するスナップショットの名前。
  # snapshot_nameを変更すると、新しいリソースが強制されます。
  # snapshot_name = "my-snapshot"

  # スナップショット保持期限（Redisのみ）
  # ElastiCacheが自動キャッシュクラスタースナップショットを削除するまでに保持する日数。
  # 例えば、5に設定すると、今日取得したスナップショットは削除される前に5日間保持されます。
  # 値が0に設定されている場合、バックアップは無効になります。
  # cache.t1.microキャッシュノードではsnapshot_retention_limitの設定はサポートされていません。
  # snapshot_retention_limit = 5

  # スナップショットウィンドウ（Redisのみ）
  # ElastiCacheがキャッシュクラスターの日次スナップショットの取得を開始する
  # 日次時間範囲（UTC）。
  # 例: "05:00-09:00"
  # snapshot_window = "05:00-09:00"

  #---------------------------------------------------------------
  # 通知設定
  #---------------------------------------------------------------

  # 通知トピックARN
  # ElastiCache通知を送信するSNSトピックのARN。
  # 例: "arn:aws:sns:us-east-1:012345678999:my_sns_topic"
  # notification_topic_arn = "arn:aws:sns:us-east-1:123456789012:elasticache-notifications"

  #---------------------------------------------------------------
  # Outpost設定
  #---------------------------------------------------------------

  # Outpostモード
  # キャッシュクラスター作成に適用されるOutpostモードを指定します。
  # 有効な値: "single-outpost" および "cross-outpost"
  # ただし、AWSは現在 "single-outpost" モードのみをサポートしています。
  # outpost_mode = "single-outpost"

  # 優先OutpostARN
  # outpost_modeが指定されている場合は必須です。
  # キャッシュクラスターが作成されるOutpostのARN。
  # preferred_outpost_arn = "arn:aws:outposts:us-east-1:123456789012:outpost/op-1234567890abcdef0"

  #---------------------------------------------------------------
  # セキュリティ設定
  #---------------------------------------------------------------

  # 転送中の暗号化を有効化
  # 転送中の暗号化を有効にします。
  # Memcachedバージョン1.6.12以降、Valkey 7.2以降、
  # Redis OSSバージョン3.2.6、4.0.10以降でVPC内で実行されている場合にサポートされます。
  # 参考: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/in-transit-encryption.html
  # transit_encryption_enabled = false

  #---------------------------------------------------------------
  # タグ
  #---------------------------------------------------------------

  # タグ
  # リソースに割り当てるタグのマップ。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-elasticache-cluster"
    Environment = "production"
  }

  # tags_all（オプション・計算済み）
  # プロバイダーのdefault_tagsを含む、リソースに割り当てられたすべてのタグ。
  # 通常は指定不要（計算済み属性）
  # tags_all = {}

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # リージョン
  # このリソースが管理されるリージョン。
  # プロバイダー設定で設定されたリージョンがデフォルトです。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # ログ配信設定（Redisのみ）
  #---------------------------------------------------------------

  # ログ配信設定ブロック（最大2つ）
  # Redis SLOWLOGまたはRedis Engine Logの送信先と形式を指定します。
  # 参考: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Log_Delivery.html
  #
  # log_delivery_configuration {
  #   # 送信先名（必須）
  #   # CloudWatch LogsのLogGroup名またはKinesis Data Firehoseリソース名
  #   destination = "my-log-group"
  #
  #   # 送信先タイプ（必須）
  #   # CloudWatch Logsの場合: "cloudwatch-logs"
  #   # Kinesis Data Firehoseの場合: "kinesis-firehose"
  #   destination_type = "cloudwatch-logs"
  #
  #   # ログフォーマット（必須）
  #   # 有効な値: "json" または "text"
  #   log_format = "json"
  #
  #   # ログタイプ（必須）
  #   # 有効な値: "slow-log" または "engine-log"
  #   # それぞれ最大1つまで
  #   log_type = "slow-log"
  # }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # タイムアウトブロック
  # リソース作成・更新・削除のタイムアウト時間をカスタマイズできます。
  #
  # timeouts {
  #   create = "60m"
  #   update = "60m"
  #   delete = "60m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（読み取り専用属性）
#---------------------------------------------------------------
#
# このリソースは以下の読み取り専用属性をエクスポートします:
#
# - arn
#   作成されたElastiCacheクラスターのARN
#
# - cache_nodes
#   id、address、port、availability_zoneを含むノードオブジェクトのリスト
#
# - cluster_address（Memcachedのみ）
#   ポートが付加されていないキャッシュクラスターのDNS名
#
# - configuration_endpoint（Memcachedのみ）
#   ホスト検出を可能にする構成エンドポイント
#
# - engine_version_actual
#   ElastiCacheはバージョンの最新のマイナーまたはパッチを取得するため、
#   この属性はキャッシュエンジンの実行中のバージョンを返します
#
# - tags_all
#   プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたタグのマップ
#
#---------------------------------------------------------------

