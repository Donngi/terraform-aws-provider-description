#---------------------------------------------------------------
# ElastiCache Global Replication Group
#---------------------------------------------------------------
#
# ElastiCache Global Replication Groupは、異なるAWSリージョン間で
# ElastiCacheクラスタのレプリケーションを管理するためのリソースです。
# Global Datastore機能を使用して、複数リージョンにまたがる
# フルマネージド、高速、信頼性の高いクラスタレプリケーションを実現します。
#
# 主な用途:
# - 地理的に分散したアプリケーションでの低レイテンシーな読み取り
# - リージョン間でのディザスタリカバリ
# - グローバルなデータ同期
#
# Global Datastoreの構成:
# - Primary (active) cluster: 書き込みを受け付け、全てのクラスタにレプリケート
# - Secondary (passive) cluster: 読み取り専用で、プライマリから更新を受信
#
# AWS公式ドキュメント:
#   - Global Datastore概要: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Redis-Global-Datastore.html
#   - CreateGlobalReplicationGroup API: https://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_CreateGlobalReplicationGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_global_replication_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticache_global_replication_group" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # Global DatastoreのIDサフィックス
  # このサフィックスは自動的にプレフィックスと組み合わされて
  # 完全なGlobal Replication Group IDを形成します
  # 変更すると新しいリソースが作成されます
  # 例: "my-global-cache"
  global_replication_group_id_suffix = "example-suffix"

  # プライマリレプリケーショングループのID
  # 書き込みを受け付け、セカンダリクラスタに更新をレプリケートする
  # プライマリクラスタのIDを指定します
  # 変更すると新しいリソースが作成されます
  # 例: aws_elasticache_replication_group.primary.id
  primary_replication_group_id = "primary-replication-group-id"

  #---------------------------------------------------------------
  # Optional Parameters - Failover & High Availability
  #---------------------------------------------------------------

  # 自動フェイルオーバーの有効化
  # 既存のプライマリが障害を起こした場合、読み取り専用レプリカを
  # 自動的に読み書きプライマリに昇格させるかどうかを指定します
  # 作成時、デフォルトではプライマリレプリケーショングループの
  # 自動フェイルオーバー設定を継承します
  # Type: bool
  # Default: プライマリレプリケーショングループの設定を継承
  # automatic_failover_enabled = true

  #---------------------------------------------------------------
  # Optional Parameters - Engine Configuration
  #---------------------------------------------------------------

  # キャッシュエンジン名
  # このGlobal Replication Groupのクラスタで使用するキャッシュエンジンの名前
  # エンジンを指定すると、Global Replication Groupと全てのメンバー
  # レプリケーショングループがこのエンジンにアップグレードされます
  # 作成時、デフォルトではプライマリレプリケーショングループの
  # エンジンを継承します
  # Type: string
  # Valid values: "redis" or "valkey"
  # Default: engine_versionが指定されている場合は"redis"
  # engine = "redis"

  # エンジンバージョン
  # Global Replication Groupで使用するエンジンバージョン
  # バージョンを指定すると、Global Replication Groupと全てのメンバー
  # レプリケーショングループがこのバージョンにアップグレードされます
  # ダウングレードはGlobal Replication Groupと全てのメンバーを
  # 置き換えずには実行できません
  #
  # バージョン指定ルール:
  # - バージョン7以上: メジャーとマイナーバージョンを指定 (例: "7.2")
  # - バージョン6: メジャーとマイナーを指定可能 (例: "6.2")
  #              またはマイナーを未指定にして最新版を使用 (例: "6.x")
  #
  # 実際に使用されるエンジンバージョンはengine_version_actual属性で確認できます
  # Type: string
  # Default: プライマリレプリケーショングループのバージョンを継承
  # engine_version = "7.2"

  #---------------------------------------------------------------
  # Optional Parameters - Compute & Capacity
  #---------------------------------------------------------------

  # ノードタイプ（インスタンスクラス）
  # 使用するインスタンスクラスを指定します
  # サポートされるノードタイプと選択ガイダンスについては
  # AWS公式ドキュメントを参照してください
  #
  # 参考:
  # - サポートされるノードタイプ: https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/CacheNodes.SupportedTypes.html
  # - ノードタイプ選択ガイド: https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/nodes-select-size.html
  #
  # 作成時、デフォルトではプライマリレプリケーショングループの
  # ノードタイプを継承します
  # Type: string
  # Examples: "cache.m5.large", "cache.r5.xlarge"
  # cache_node_type = "cache.m5.large"

  # ノードグループ（シャード）数
  # Global Replication Groupのノードグループ（シャード）の数を指定します
  # クラスタモードが有効な場合に使用します
  # Type: number
  # Default: プライマリレプリケーショングループの設定を継承
  # num_node_groups = 2

  #---------------------------------------------------------------
  # Optional Parameters - Parameter Groups
  #---------------------------------------------------------------

  # パラメータグループ名
  # Global Replication Groupで使用するElastiCacheパラメータグループ
  #
  # 使用ケース:
  # - エンジンまたはメジャーエンジンバージョンをアップグレードする際に必須
  # - アップグレード完了後は設定されていても無視されます
  # - メジャーバージョンアップグレード以外で指定すると失敗します
  #
  # 注意: ElastiCacheは各メンバーレプリケーショングループに対して
  # このパラメータグループのコピーを作成します
  # Type: string
  # parameter_group_name = "default.redis7"

  #---------------------------------------------------------------
  # Optional Parameters - Description
  #---------------------------------------------------------------

  # Global Replication Groupの説明
  # ユーザーが作成するGlobal Replication Groupの説明文
  # Type: string
  # global_replication_group_description = "My global replication group for multi-region deployment"

  #---------------------------------------------------------------
  # Optional Parameters - Advanced
  #---------------------------------------------------------------

  # ID (Terraform管理用)
  # このパラメータはTerraform内部で使用されます
  # 通常は設定不要です
  # Type: string
  # Computed: true
  # id = null

  # リージョン指定
  # このリソースが管理されるリージョンを指定します
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトとなります
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Type: string
  # Default: プロバイダー設定のリージョン
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------
  # リソースのCreate/Update/Delete操作のタイムアウト設定
  # Global Replication Groupの作成や削除には時間がかかる場合があるため
  # 必要に応じてタイムアウト値を調整します

  timeouts {
    # 作成タイムアウト
    # Default: 適切なデフォルト値が設定されています
    # create = "60m"

    # 更新タイムアウト
    # Default: 適切なデフォルト値が設定されています
    # update = "60m"

    # 削除タイムアウト
    # Default: 適切なデフォルト値が設定されています
    # delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (Computed - Read Only)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed属性）
#
# arn
#   Type: string
#   Description: ElastiCache Global Replication GroupのARN
#   Example: output "arn" { value = aws_elasticache_global_replication_group.example.arn }
#
# at_rest_encryption_enabled
#   Type: bool
#   Description: 保存時の暗号化が有効かどうかを示すフラグ
#   Example: output "at_rest_encryption_enabled" { value = aws_elasticache_global_replication_group.example.at_rest_encryption_enabled }
#
# auth_token_enabled
#   Type: bool
#   Description: AuthToken (パスワード) が有効かどうかを示すフラグ
#   Example: output "auth_token_enabled" { value = aws_elasticache_global_replication_group.example.auth_token_enabled }
#
# cluster_enabled
#   Type: bool
#   Description: Global Datastoreがクラスタモードで有効かどうかを示す
#   Example: output "cluster_enabled" { value = aws_elasticache_global_replication_group.example.cluster_enabled }
#
# engine_version_actual
#   Type: string
#   Description: このGlobal Replication Groupのメンバーで実行されている
#              キャッシュエンジンの完全なバージョン番号
#   Example: output "engine_version_actual" { value = aws_elasticache_global_replication_group.example.engine_version_actual }
#
# global_node_groups
#   Type: set of objects
#   Description: Global Replication Groupのノードグループ（シャード）のセット
#   Structure:
#     - global_node_group_id: グローバルノードグループのID
#     - slots: このノードグループのキースペース
#   Example: output "global_node_groups" { value = aws_elasticache_global_replication_group.example.global_node_groups }
#
# global_replication_group_id
#   Type: string
#   Description: Global Replication Groupの完全なID
#              (global_replication_group_id_suffixにプレフィックスが付加されたもの)
#   Example: output "global_replication_group_id" { value = aws_elasticache_global_replication_group.example.global_replication_group_id }
#
# transit_encryption_enabled
#   Type: bool
#   Description: 転送時の暗号化が有効かどうかを示すフラグ
#   Example: output "transit_encryption_enabled" { value = aws_elasticache_global_replication_group.example.transit_encryption_enabled }
#
#---------------------------------------------------------------
