################################################################################
# Resource: aws_elasticache_parameter_group
# Provider Version: 6.28.0
# Last Updated: 2026-01-28
################################################################################

# ElastiCache パラメータグループリソース
# Provides an ElastiCache parameter group resource.
#
# パラメータグループは、エンジンソフトウェア起動時のパラメータ値の組み合わせを定義し、
# 実行時のノード動作に影響を与えます。デフォルトパラメータグループは変更できないため、
# カスタム値が必要な場合は新しいパラメータグループを作成する必要があります。
#
# AWS Documentation: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/ParameterGroups.html
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group

resource "aws_elasticache_parameter_group" "example" {

  ################################################################################
  # Required Arguments
  ################################################################################

  # name - (Required) String
  # ElastiCache パラメータグループの名前
  # The name of the ElastiCache parameter group.
  #
  # 命名制約:
  # - ASCII文字で始まる必要があります
  # - ASCII文字、数字、ハイフンのみ使用可能
  # - 1～255文字の長さ
  # - 連続する2つのハイフンは使用不可
  # - ハイフンで終わることはできません
  #
  # 使用例:
  # - "my-redis-params"
  # - "production-memcached-params"
  # - "redis-high-performance"
  name = "cache-params"

  # family - (Required) String
  # ElastiCache パラメータグループのファミリー
  # The family of the ElastiCache parameter group.
  #
  # パラメータグループファミリーは、エンジンとバージョンを定義し、
  # パラメータグループ内の実際のパラメータとその初期値を決定します。
  # クラスタのエンジンとバージョンと一致している必要があります。
  #
  # Redis/Valkey ファミリーの例:
  # - "redis2.6"
  # - "redis2.8"
  # - "redis3.2"
  # - "redis4.0"
  # - "redis5.0"
  # - "redis6.x"
  # - "redis7"
  # - "valkey7"
  # - "valkey8"
  #
  # Memcached ファミリーの例:
  # - "memcached1.4"
  # - "memcached1.5"
  # - "memcached1.6"
  #
  # 注意: redis2.6またはredis2.8でreserved-memoryパラメータを削除しようとすると、
  # ElastiCache APIの制限により、Terraformで永続的な差分が表示される場合があります。
  # この問題を回避するには、そのパラメータを任意の値で設定したままにしてください。
  family = "redis2.8"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # description - (Optional) String
  # ElastiCache パラメータグループの説明
  # The description of the ElastiCache parameter group.
  #
  # デフォルト: "Managed by Terraform"
  #
  # 使用例:
  # - "Production Redis parameter group with optimized settings"
  # - "Development environment Memcached parameters"
  # - "High-memory configuration for Redis cluster"
  # description = "Managed by Terraform"

  # parameter - (Optional) List of Objects
  # 適用するElastiCacheパラメータのリスト
  # A list of ElastiCache parameters to apply.
  #
  # パラメータの変更動作:
  # - Memcached: 変更は即座に反映されます
  # - Redis/Valkey: 一部のパラメータ変更にはノードの再起動が必要です
  # - activerehashing、databasesなどのパラメータ: クラスタモード有効時は
  #   手動バックアップ作成→クラスタ削除→変更したパラメータグループでリストアが必要
  #
  # Redis/Valkey パラメータの例:
  # - activerehashing: ハッシュテーブルの再ハッシュを制御 (yes/no)
  # - timeout: アイドル接続のタイムアウト秒数 (0=無効)
  # - maxmemory-policy: メモリ上限到達時の削除ポリシー
  #   (volatile-lru, allkeys-lru, volatile-random, allkeys-random,
  #    volatile-ttl, noeviction)
  # - min-slaves-to-write: 書き込み許可に必要な最小スレーブ数
  # - reserved-memory-percent: 非データ用途のメモリ予約率
  # - slowlog-log-slower-than: スローログ記録の閾値（マイクロ秒）
  # - notify-keyspace-events: キースペース通知の設定
  #
  # Memcached パラメータの例:
  # - chunk_size: チャンクの初期サイズ（バイト）
  # - chunk_size_growth_factor: チャンクサイズの増加係数
  # - max_item_size: 最大アイテムサイズ（バイト）
  # - error_on_memory_exhausted: メモリ不足時のエラー動作
  #
  # Nested Block: parameter
  # - name (Required): ElastiCache パラメータの名前
  # - value (Required): ElastiCache パラメータの値
  parameter {
    name  = "activerehashing"
    value = "yes"
  }

  parameter {
    name  = "min-slaves-to-write"
    value = "2"
  }

  # その他の Redis パラメータ例（コメントアウト）
  # parameter {
  #   name  = "timeout"
  #   value = "300"
  # }
  #
  # parameter {
  #   name  = "maxmemory-policy"
  #   value = "allkeys-lru"
  # }
  #
  # parameter {
  #   name  = "reserved-memory-percent"
  #   value = "25"
  # }
  #
  # parameter {
  #   name  = "slowlog-log-slower-than"
  #   value = "10000"
  # }
  #
  # parameter {
  #   name  = "notify-keyspace-events"
  #   value = "Ex"
  # }

  # region - (Optional) String
  # このリソースが管理されるリージョン
  # Region where this resource will be managed.
  #
  # デフォルト: プロバイダー設定のリージョン
  #
  # AWS リージョナルエンドポイント:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # 使用例:
  # - "us-east-1"
  # - "eu-west-1"
  # - "ap-northeast-1"
  # region = "us-east-1"

  # tags - (Optional) Map of Strings
  # リソースタグのキーバリューマッピング
  # Key-value mapping of resource tags.
  #
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  #
  # 使用例:
  # tags = {
  #   Environment = "production"
  #   Application = "web-cache"
  #   Team        = "platform"
  #   ManagedBy   = "terraform"
  #   CostCenter  = "engineering"
  #   Purpose     = "redis-parameter-optimization"
  # }
  tags = {
    Name = "example-elasticache-parameter-group"
  }

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################

  # 以下の属性はTerraformによって自動的に計算され、読み取り専用です:
  #
  # id - String
  # ElastiCache パラメータグループ名
  # The ElastiCache parameter group name.
  #
  # arn - String
  # パラメータグループに関連付けられた AWS ARN
  # The AWS ARN associated with the parameter group.
  # 形式: arn:aws:elasticache:region:account-id:parametergroup:parameter-group-name
  #
  # tags_all - Map of Strings
  # リソースに割り当てられたタグのマップ
  # プロバイダーのdefault_tags設定ブロックから継承されたタグを含む
  # A map of tags assigned to the resource, including those inherited from the
  # provider default_tags configuration block.
}

################################################################################
# 使用例: Redis パラメータグループ（詳細設定）
################################################################################

# resource "aws_elasticache_parameter_group" "redis_optimized" {
#   name        = "redis-optimized-params"
#   family      = "redis7"
#   description = "Optimized parameter group for Redis 7.x with high-performance settings"
#
#   # メモリ管理
#   parameter {
#     name  = "maxmemory-policy"
#     value = "allkeys-lru"
#   }
#
#   parameter {
#     name  = "reserved-memory-percent"
#     value = "25"
#   }
#
#   # パフォーマンスチューニング
#   parameter {
#     name  = "activerehashing"
#     value = "yes"
#   }
#
#   parameter {
#     name  = "timeout"
#     value = "300"
#   }
#
#   # スローログ設定
#   parameter {
#     name  = "slowlog-log-slower-than"
#     value = "10000"
#   }
#
#   parameter {
#     name  = "slowlog-max-len"
#     value = "128"
#   }
#
#   # レプリケーション設定
#   parameter {
#     name  = "min-replicas-to-write"
#     value = "1"
#   }
#
#   parameter {
#     name  = "min-replicas-max-lag"
#     value = "10"
#   }
#
#   # キースペース通知
#   parameter {
#     name  = "notify-keyspace-events"
#     value = "Ex"
#   }
#
#   tags = {
#     Environment = "production"
#     Engine      = "redis"
#     Version     = "7.x"
#     Purpose     = "high-performance-cache"
#   }
# }

################################################################################
# 使用例: Memcached パラメータグループ
################################################################################

# resource "aws_elasticache_parameter_group" "memcached_custom" {
#   name        = "memcached-custom-params"
#   family      = "memcached1.6"
#   description = "Custom parameter group for Memcached 1.6"
#
#   # メモリ設定
#   parameter {
#     name  = "chunk_size"
#     value = "96"
#   }
#
#   parameter {
#     name  = "chunk_size_growth_factor"
#     value = "1.25"
#   }
#
#   parameter {
#     name  = "max_item_size"
#     value = "10485760" # 10MB
#   }
#
#   # エラー処理
#   parameter {
#     name  = "error_on_memory_exhausted"
#     value = "1"
#   }
#
#   # 接続設定
#   parameter {
#     name  = "max_simultaneous_connections"
#     value = "65000"
#   }
#
#   tags = {
#     Environment = "production"
#     Engine      = "memcached"
#     Version     = "1.6"
#   }
# }

################################################################################
# 使用例: ElastiCache クラスタとの統合
################################################################################

# resource "aws_elasticache_cluster" "example" {
#   cluster_id           = "my-redis-cluster"
#   engine               = "redis"
#   node_type            = "cache.t3.micro"
#   num_cache_nodes      = 1
#   parameter_group_name = aws_elasticache_parameter_group.example.name
#   port                 = 6379
#   subnet_group_name    = aws_elasticache_subnet_group.example.name
#   security_group_ids   = [aws_security_group.redis.id]
#
#   tags = {
#     Environment = "production"
#   }
# }

################################################################################
# 使用例: グローバルデータストアでのパラメータグループ
################################################################################

# resource "aws_elasticache_parameter_group" "global" {
#   name        = "global-redis-params"
#   family      = "redis7"
#   description = "Parameter group for global datastore"
#
#   # グローバルデータストアに関連付けられたパラメータグループの変更は、
#   # データストア内のすべてのクラスタに複製されます
#
#   parameter {
#     name  = "maxmemory-policy"
#     value = "volatile-lru"
#   }
#
#   parameter {
#     name  = "reserved-memory-percent"
#     value = "30"
#   }
#
#   tags = {
#     Environment = "production"
#     Scope       = "global"
#   }
# }

################################################################################
# 出力例
################################################################################

# output "parameter_group_id" {
#   description = "The ElastiCache parameter group name"
#   value       = aws_elasticache_parameter_group.example.id
# }
#
# output "parameter_group_arn" {
#   description = "The ARN of the ElastiCache parameter group"
#   value       = aws_elasticache_parameter_group.example.arn
# }

################################################################################
# 重要な注意事項
################################################################################

# 1. パラメータグループファミリー
#    - パラメータグループファミリーは、クラスタのエンジンとバージョンと一致する必要があります
#    - ファミリーを変更すると新しいリソースが作成されます（破壊的変更）
#
# 2. パラメータ変更の影響
#    - Memcached: すべてのパラメータ変更は即座に反映されます
#    - Redis/Valkey: 一部のパラメータは再起動が必要です
#    - activerehashing、databases: クラスタモード有効時は特別な手順が必要
#
# 3. reserved-memory パラメータ（Redis 2.6/2.8）
#    - redis2.6またはredis2.8でreserved-memoryを削除すると、APIの制限により
#      Terraformで永続的な差分が発生する可能性があります
#    - この問題を回避するため、パラメータを設定したままにすることを推奨します
#
# 4. デフォルトパラメータグループ
#    - デフォルトパラメータグループは変更・削除できません
#    - カスタム値が必要な場合は、新しいパラメータグループを作成してください
#
# 5. パラメータグループの変更
#    - クラスタのパラメータグループを変更する場合、条件付き変更可能なパラメータは
#      現在のパラメータグループと新しいパラメータグループで同じ値である必要があります
#
# 6. グローバルデータストア
#    - パラメータグループをグローバルデータストアに関連付けることができます
#    - 変更はデータストア内のすべてのクラスタに複製されます
#    - コンソールの"Global"属性またはAPIのIsGlobalプロパティで確認可能
#
# 7. メモリ管理（Redis/Valkey）
#    - reserved-memory: 2017年3月16日以前の方式（ノードタイプごとに特定の値）
#    - reserved-memory-percent: 2017年3月16日以降の方式（メモリの割合で指定）
#    - これらのパラメータは相互排他的です
#
# 8. パラメータ値の検証
#    - パラメータ名と値は、選択したファミリーで有効である必要があります
#    - 無効なパラメータはエラーとなります
#    - 詳細はAWSドキュメントのエンジン固有パラメータを参照してください

################################################################################
# 関連リソース
################################################################################

# - aws_elasticache_cluster: ElastiCache クラスタ
# - aws_elasticache_replication_group: ElastiCache レプリケーショングループ
# - aws_elasticache_global_replication_group: ElastiCache グローバルレプリケーショングループ
# - aws_elasticache_subnet_group: ElastiCache サブネットグループ
# - aws_elasticache_security_group: ElastiCache セキュリティグループ
# - aws_security_group: VPC セキュリティグループ

################################################################################
# 参考リンク
################################################################################

# AWS Documentation:
# - Parameter Groups: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/ParameterGroups.html
# - Creating Parameter Groups: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/ParameterGroups.Creating.html
# - Modifying Parameter Groups: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/ParameterGroups.Modifying.html
# - Redis Parameters: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/ParameterGroups.Redis.html
# - Memcached Parameters: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/ParameterGroups.Memcached.html
# - Memory Management: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/redis-memory-management.html
#
# Terraform Registry:
# - Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group
