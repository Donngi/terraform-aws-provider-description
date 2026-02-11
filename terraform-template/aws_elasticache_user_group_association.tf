#---------------------------------------------------------------
# ElastiCache User Group Association
#---------------------------------------------------------------
#
# ElastiCache User Group Associationリソースは、既存のElastiCacheユーザーと
# 既存のユーザーグループを関連付けるために使用します。
#
# このリソースは、Role-Based Access Control (RBAC)を使用してElastiCacheの
# アクセス制御を管理する際に、個別のユーザーをユーザーグループに追加する
# 際に使用します。
#
# 注意: Terraformはこのリソースによる変更をaws_elasticache_user_groupで
# 検出します。lifecycleのignore_changesメタ引数でuser_idsの変更を
# 無視することを推奨します。
#
# AWS公式ドキュメント:
#   - Role-Based Access Control (RBAC): https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Clusters.RBAC.html
#   - UserGroup API Reference: https://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_UserGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_user_group_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticache_user_group_association" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # ユーザーグループのID
  # 既存のElastiCacheユーザーグループのIDを指定します。
  # このユーザーグループにユーザーが追加されます。
  #
  # Example: "my-user-group"
  user_group_id = "example-user-group-id"

  # ユーザーのID
  # 既存のElastiCacheユーザーのIDを指定します。
  # このユーザーがユーザーグループに関連付けられます。
  #
  # Example: "example-user-id"
  user_id = "example-user-id"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # リソースID
  # リソースの一意識別子。通常は自動生成されるため、設定不要です。
  # ユーザーグループIDとユーザーIDの組み合わせから自動生成されます。
  #
  # 注意: 通常は設定しません（computed属性として自動設定されます）
  # id = null

  # リージョン
  # このリソースを管理するAWSリージョンを指定します。
  # 未指定の場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  #
  # Example: "us-east-1"
  # region = null

  #---------------------------------------------------------------
  # Timeouts Configuration
  #---------------------------------------------------------------

  # リソース操作のタイムアウト設定
  # 各操作の最大待機時間を指定できます。
  timeouts {
    # 作成操作のタイムアウト
    # ユーザーとユーザーグループの関連付け作成時の最大待機時間
    #
    # デフォルト値やレコメンデーション: 通常は数分以内に完了
    # Example: "5m"
    # create = null

    # 削除操作のタイムアウト
    # ユーザーとユーザーグループの関連付け削除時の最大待機時間
    #
    # デフォルト値やレコメンデーション: 通常は数分以内に完了
    # Example: "5m"
    # delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - id: リソースのID（computed）
#   ユーザーグループIDとユーザーIDの組み合わせから生成されます。

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# ElastiCache User Group Associationは以下の形式でインポート可能です:
#
# terraform import aws_elasticache_user_group_association.example user_group_id,user_id
#
# Example:
# terraform import aws_elasticache_user_group_association.example my-user-group,my-user-id

#---------------------------------------------------------------
# Usage Example
#---------------------------------------------------------------
# 以下は、デフォルトユーザー、ユーザーグループ、追加ユーザーを作成し、
# ユーザーグループ関連付けを使用する完全な例です:
#
# resource "aws_elasticache_user" "default" {
#   user_id       = "defaultUserID"
#   user_name     = "default"
#   access_string = "on ~app::* -@all +@read +@hash +@bitmap +@geo -setbit -bitfield -hset -hsetnx -hmset -hincrby -hincrbyfloat -hdel -bitop -geoadd -georadius -georadiusbymember"
#   engine        = "REDIS"
#   passwords     = ["password123456789"]
# }
#
# resource "aws_elasticache_user_group" "example" {
#   engine        = "REDIS"
#   user_group_id = "userGroupId"
#   user_ids      = [aws_elasticache_user.default.user_id]
#
#   lifecycle {
#     ignore_changes = [user_ids]
#   }
# }
#
# resource "aws_elasticache_user" "example" {
#   user_id       = "exampleUserID"
#   user_name     = "exampleuser"
#   access_string = "on ~app::* -@all +@read +@hash +@bitmap +@geo -setbit -bitfield -hset -hsetnx -hmset -hincrby -hincrbyfloat -hdel -bitop -geoadd -georadius -georadiusbymember"
#   engine        = "REDIS"
#   passwords     = ["password123456789"]
# }
#
# resource "aws_elasticache_user_group_association" "example" {
#   user_group_id = aws_elasticache_user_group.example.user_group_id
#   user_id       = aws_elasticache_user.example.user_id
# }

#---------------------------------------------------------------
# Notes
#---------------------------------------------------------------
# - このリソースを使用すると、aws_elasticache_user_groupのuser_idsに変更が
#   検出されます。lifecycleブロックでignore_changes = [user_ids]を
#   設定することを推奨します。
#
# - RBAC (Role-Based Access Control)はValkey 7.2以降、Redis OSS 6.0～7.2で
#   利用可能です。
#
# - ユーザーグループあたり最大100ユーザーまで関連付け可能です。
#
# - 合計で最大1000ユーザー、100ユーザーグループまで作成可能です。
