#---------------------------------------------------------------
# ElastiCache Reserved Cache Node
#---------------------------------------------------------------
#
# ElastiCache予約キャッシュノードを購入・管理するリソース。
# 予約ノードは1年または3年の期間で事前に購入することで、
# オンデマンドノードと比較してコストを大幅に削減できます。
#
# 重要な注意事項:
# - 一度購入した予約は、指定された期間（duration）中は有効であり、削除できません
# - Terraformでdestroyを実行しても、予約自体は解除されず、stateから削除されるのみです
# - 予約ノードは、同じインスタンスファミリー内でサイズ柔軟性があります（例: r7g.xlarge → r7g.2xlarge）
# - Redis OSSの予約ノードは、Valkeyエンジンにも適用可能（20%の追加割引）
#
# AWS公式ドキュメント:
#   - Reserved nodes: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/CacheNodes.Reserved.html
#   - PurchaseReservedCacheNodesOffering API: https://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_PurchaseReservedCacheNodesOffering.html
#   - Reserved Cache Nodes: https://aws.amazon.com/elasticache/reserved-cache-nodes/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_reserved_cache_node
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticache_reserved_cache_node" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) 予約キャッシュノードオファリングのID。
  # このIDは、aws_elasticache_reserved_cache_node_offering データソースから取得できます。
  # オファリングIDには、ノードタイプ、期間、支払いタイプ、製品説明（エンジン）の情報が含まれます。
  #
  # 例:
  #   data "aws_elasticache_reserved_cache_node_offering" "example" {
  #     cache_node_type     = "cache.t4g.small"
  #     duration            = "P1Y"  # 1年間
  #     offering_type       = "No Upfront"
  #     product_description = "redis"
  #   }
  #   reserved_cache_nodes_offering_id = data.aws_elasticache_reserved_cache_node_offering.example.offering_id
  reserved_cache_nodes_offering_id = "438012d3-4052-4cc7-b2e4-9da5b879a209"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) 予約するキャッシュノードインスタンスの数。
  # デフォルト値は 1 です。
  # 複数のノードを予約する場合、コストはノード数に応じて倍増します。
  # サイズ柔軟性により、予約した正規化ユニット（normalized units）を
  # 同じインスタンスファミリー内の異なるサイズのノードに適用できます。
  cache_node_count = 1

  # (Optional) この予約を追跡するためのカスタマー指定の識別子。
  # 指定しない場合、AWSがランダムなIDを割り当てます。
  # この識別子は予約の管理や請求の追跡に使用できます。
  # 一度設定すると、後から変更することはできません。
  #
  # 例: "production-redis-reservation-2026"
  id = null

  # (Optional) このリソースが管理されるリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  #
  # 重要: 予約ノードはリージョン固有です。予約したリージョン内のノードにのみ適用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # (Optional) この予約に割り当てるタグのマップ。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # キーが一致するタグはプロバイダーレベルで定義されたものを上書きします。
  #
  # 例:
  #   tags = {
  #     Environment = "production"
  #     CostCenter  = "engineering"
  #     ManagedBy   = "terraform"
  #   }
  tags = {}

  #---------------------------------------------------------------
  # Timeouts Configuration (Optional)
  #---------------------------------------------------------------

  # (Optional) リソース操作のタイムアウト設定。
  # 各タイムアウトは "30s" や "2h45m" のような形式で指定します。
  # 有効な時間単位: "s" (秒), "m" (分), "h" (時間)
  timeouts {
    # (Optional) 予約ノードの作成操作のタイムアウト。
    # デフォルト: 30分
    # 予約ノードの購入処理には通常数分かかります。
    create = null

    # (Optional) 予約ノードの削除操作のタイムアウト。
    # デフォルト: 10分
    # 注意: 削除操作はstateからリソースを削除するだけで、実際の予約は解除されません。
    delete = null

    # (Optional) 予約ノードの更新操作のタイムアウト。
    # デフォルト: 30分
    # タグの更新などの操作に適用されます。
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (Computed Only - Read-Only)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能ですが、設定することはできません。
# これらは computed-only 属性として、Terraformによって自動的に取得されます。

# arn - 予約キャッシュノードのARN（Amazon Resource Name）
#   例: "arn:aws:elasticache:us-east-1:123456789012:reserved-instance:ri-2017-03-27-08-33-25-582"

# cache_node_type - 予約されたキャッシュノードのノードタイプ
#   例: "cache.r7g.xlarge", "cache.t4g.small"
#   ノードタイプは、メモリ、CPU、ネットワークパフォーマンスを定義します。
#   現行世代: M7g, M6g, M5, T4g, T3, R7g, R6g, R5など
#   詳細: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/CacheNodes.SupportedTypes.html

# duration - 予約期間をRFC3339 duration形式で表現したもの
#   例: "P1Y" (1年), "P3Y" (3年)

# fixed_price - この予約ノードに対して請求される固定価格（初期費用）
#   支払いタイプによって異なります:
#   - All Upfront: 全額を前払い
#   - Partial Upfront: 一部を前払い
#   - No Upfront: 前払いなし（0）

# offering_type - この予約ノードのオファリングタイプ
#   値: "No Upfront", "Partial Upfront", "All Upfront"
#   各タイプは前払い金額と時間単位の料金のバランスが異なります

# product_description - 予約キャッシュノードのエンジンタイプ
#   値: "redis", "memcached", "valkey"

# recurring_charges - この予約ノードを実行するために請求される定期料金
#   構造:
#     - recurring_charge_amount: 定期料金の金額
#     - recurring_charge_frequency: 料金の頻度（通常は "Hourly"）

# start_time - 予約が開始された時刻（タイムスタンプ）

# state - 予約キャッシュノードの状態
#   値: "payment-pending", "active", "payment-failed", "retired"

# tags_all - プロバイダーのdefault_tags設定ブロックから継承されたものを含む、
#            リソースに割り当てられたすべてのタグのマップ

# usage_price - この予約ノードに対して請求される時間単価
#   No Upfrontの場合は割引された時間単価、
#   All Upfrontの場合は通常0、
#   Partial Upfrontの場合は割引された時間単価となります
