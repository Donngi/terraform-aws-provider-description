#---------------------------------------
# ElastiCache予約ノードの購入
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/elasticache_reserved_cache_node
#
# ElastiCacheの予約ノードを購入して管理します。
# 予約ノードは1年または3年の期間で前払いまたは分割払いにより、
# オンデマンドよりも大幅にコストを削減できます。
#
# NOTE:
# - 一度作成した予約は、指定した期間中は有効であり削除できません
# - Terraformのdestroyを実行しても、実際の予約は削除されず状態から削除されるのみです
# - 予約の購入は高額なため、本番環境での使用前に十分な検証を行ってください
#
# 公式ドキュメント: https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/reserved-nodes.html
#---------------------------------------

#---------------------------------------
# 予約ノードオファリングの検索
#---------------------------------------
# 購入可能な予約ノードオファリングを検索します。
# このデータソースを使用して、offering_idを取得します。
data "aws_elasticache_reserved_cache_node_offering" "example" {
  cache_node_type     = "cache.t4g.small"
  duration            = "P1Y"
  offering_type       = "No Upfront"
  product_description = "redis"
}

#---------------------------------------
# 予約ノードの購入
#---------------------------------------
resource "aws_elasticache_reserved_cache_node" "example" {
  #---------------------------------------
  # 必須設定
  #---------------------------------------

  # 設定内容: 購入する予約キャッシュノードオファリングのID
  # 設定可能な値: aws_elasticache_reserved_cache_node_offeringデータソースから取得したoffering_id
  # 注意事項: このIDにより、ノードタイプ、期間、料金体系が決定されます
  reserved_cache_nodes_offering_id = data.aws_elasticache_reserved_cache_node_offering.example.offering_id

  #---------------------------------------
  # 予約設定
  #---------------------------------------

  # 設定内容: 予約を識別するためのカスタマー指定の識別子
  # 設定可能な値: 任意の文字列（英数字、ハイフン、アンダースコア）
  # 省略時: AWSが自動的にランダムなIDを割り当てます
  # 注意事項: 予約の管理と追跡を容易にするため、わかりやすい名前を指定することを推奨します
  id = "redis-prod-reservation-2026"

  # 設定内容: 予約するキャッシュノードインスタンスの数
  # 設定可能な値: 1以上の整数
  # 省略時: 1
  # 注意事項: 複数のノードを予約する場合、すべて同じノードタイプである必要があります
  cache_node_count = 3

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: このリソースが管理されるAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（us-east-1、ap-northeast-1など）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意事項: 予約はリージョン固有のため、適切なリージョンを選択してください
  region = "ap-northeast-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # 設定内容: 予約に割り当てるタグのマップ
  # 設定可能な値: キーと値のペアのマップ（最大50個）
  # 省略時: タグなし
  # 注意事項: コスト管理や組織的な分類のためにタグを使用することを推奨します
  tags = {
    Name        = "redis-prod-reservation"
    Environment = "production"
    CostCenter  = "engineering"
    ManagedBy   = "terraform"
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  timeouts {
    # 設定内容: リソース作成時のタイムアウト時間
    # 設定可能な値: 時間文字列（例: "30m"、"1h"、"2h30m"）
    # 省略時: デフォルトのタイムアウト時間を使用
    # 注意事項: 予約ノードの購入処理には時間がかかる場合があります
    create = "30m"

    # 設定内容: リソース更新時のタイムアウト時間
    # 設定可能な値: 時間文字列（例: "30m"、"1h"、"2h30m"）
    # 省略時: デフォルトのタイムアウト時間を使用
    update = "30m"

    # 設定内容: リソース削除時のタイムアウト時間
    # 設定可能な値: 時間文字列（例: "30m"、"1h"、"2h30m"）
    # 省略時: デフォルトのタイムアウト時間を使用
    # 注意事項: 実際の予約は削除されず、状態からのみ削除されます
    delete = "10m"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# 以下の属性は、リソース作成後に参照できます:
#
# arn                  - 予約キャッシュノードのARN
# cache_node_type      - 予約されたキャッシュノードのノードタイプ
# duration             - RFC3339形式での予約期間（例: P1Y、P3Y）
# fixed_price          - この予約ノードに対して請求される固定料金
# offering_type        - この予約ノードのオファリングタイプ（No Upfront、Partial Upfront、All Upfront）
# product_description  - 予約されたキャッシュノードのエンジンタイプ（redis、memcached）
# recurring_charges    - この予約ノードに対して請求される定期的な料金（リスト形式）
# start_time           - 予約が開始された時刻（RFC3339形式）
# state                - 予約キャッシュノードの状態（active、payment-pending、retiredなど）
# usage_price          - この予約ノードに対して請求される時間単位の料金
# tags_all             - プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、リソースに割り当てられた全タグのマップ
#
# 参照例:
# output "reservation_arn" {
#   value = aws_elasticache_reserved_cache_node.example.arn
# }
