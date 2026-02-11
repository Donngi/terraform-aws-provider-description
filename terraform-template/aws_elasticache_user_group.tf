#---------------------------------------------------------------
# ElastiCache User Group
#---------------------------------------------------------------
#
# ElastiCache User Groupは、ElastiCacheクラスター（ValkeyまたはRedis OSS）に対する
# Role-Based Access Control（RBAC）を実現するためのユーザーグループを定義します。
# ユーザーグループは複数のユーザーをまとめ、クラスターへのアクセス制御を管理します。
#
# ユースケース:
#   - ElastiCacheクラスターへの細粒度なアクセス制御
#   - ユーザーごとの異なる権限設定（読み取り専用、管理者など）
#   - ServerlessキャッシュまたはReplication Groupへのアクセス管理
#
# AWS公式ドキュメント:
#   - Role-Based Access Control (RBAC): https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Clusters.RBAC.html
#   - User Group API Reference: https://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_UserGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_user_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticache_user_group" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (必須) キャッシュエンジンの種類
  # 指定可能な値: "redis", "valkey" (大文字小文字を区別しない)
  #
  # - ValkeyユーザーグループはValkeyクラスターのみに使用可能
  # - Redisユーザーグループは、Redis OSSクラスターのみに使用可能
  # - Valkeyクラスターでは、engine="VALKEY"とengine="REDIS"の両方の
  #   ユーザーグループを関連付け可能
  engine = "redis"

  # (必須) ユーザーグループのID
  # 英字で始まり、英数字とハイフンのみを含む一意の識別子
  #
  # このIDはユーザーグループを識別するために使用され、
  # クラスターやサーバーレスキャッシュに関連付ける際に参照されます
  user_group_id = "example-user-group"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (オプション) ユーザーグループに所属するユーザーIDのリスト
  #
  # - 最大100ユーザーまでグループに追加可能
  # - 各ユーザーは事前にaws_elasticache_userリソースで作成する必要があります
  # - ValkeyユーザーグループにはValkeyユーザー、およびパスワード保護または
  #   IAM認証が有効なRedisユーザーを含めることができます
  # - Valkeyユーザーはパスワード保護またはIAM認証が必須
  # - 空のリストも指定可能（後で追加する場合）
  #
  # 例: user_ids = [aws_elasticache_user.app.user_id, aws_elasticache_user.admin.user_id]
  user_ids = []

  # (オプション) リソースのタグ（キー・バリューのマップ）
  #
  # provider default_tagsブロックで定義されたタグとマージされます。
  # 同じキーがある場合、このtagsの値が優先されます。
  #
  # 例:
  # tags = {
  #   Environment = "production"
  #   Team        = "backend"
  #   ManagedBy   = "terraform"
  # }
  tags = {}

  # (オプション) 全てのタグのマップ（リソースタグ + プロバイダーのdefault_tags）
  #
  # 通常は明示的に指定する必要はありません。
  # Terraformがprovider default_tagsとリソースtagsを自動的にマージします。
  #
  # NOTE: このパラメータを直接設定すると、Terraformの自動マージが
  #       上書きされる可能性があるため、通常はtagsのみを使用してください。
  # tags_all = {}

  # (オプション) リソースを管理するAWSリージョン
  #
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # マルチリージョン構成で特定のリソースのみ異なるリージョンに
  # 配置したい場合に使用します。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # 例: region = "us-west-2"
  # region = null

  # (オプション) Terraformリソースの識別子
  #
  # 通常は指定不要。Terraformが自動的にuser_group_idを使用します。
  # カスタムインポート時などの特殊なケースでのみ使用します。
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference (Read-Only)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed属性）

# arn
#   - ユーザーグループのARN（Amazon Resource Name）
#   - 形式: arn:aws:elasticache:<region>:<account-id>:usergroup:<user-group-id>
#   - 例: aws_elasticache_user_group.example.arn

# id
#   - ユーザーグループの識別子（user_group_idと同じ値）
#   - 例: aws_elasticache_user_group.example.id

# tags_all
#   - リソースに割り当てられた全タグのマップ
#   - provider default_tagsとリソースtagsがマージされた結果
#   - 例: aws_elasticache_user_group.example.tags_all

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: 基本的なRedis用ユーザーグループ
# resource "aws_elasticache_user" "app_user" {
#   user_id       = "app-user"
#   user_name     = "appuser"
#   access_string = "on ~app::* -@all +@read +@hash +@bitmap +@geo"
#   engine        = "redis"
#   passwords     = ["YourSecurePassword123!"]
# }
#
# resource "aws_elasticache_user_group" "app" {
#   engine        = "redis"
#   user_group_id = "app-user-group"
#   user_ids      = [aws_elasticache_user.app_user.user_id]
#
#   tags = {
#     Name        = "Application User Group"
#     Environment = "production"
#   }
# }

# 例2: Valkey用ユーザーグループ（複数ユーザー）
# resource "aws_elasticache_user" "admin" {
#   user_id       = "admin-user"
#   user_name     = "adminuser"
#   access_string = "on ~* +@all"
#   engine        = "valkey"
#   passwords     = ["AdminPassword123!"]
# }
#
# resource "aws_elasticache_user" "readonly" {
#   user_id       = "readonly-user"
#   user_name     = "readonlyuser"
#   access_string = "on ~* -@all +@read"
#   engine        = "valkey"
#   passwords     = ["ReadonlyPassword123!"]
# }
#
# resource "aws_elasticache_user_group" "valkey_group" {
#   engine        = "valkey"
#   user_group_id = "valkey-user-group"
#   user_ids      = [
#     aws_elasticache_user.admin.user_id,
#     aws_elasticache_user.readonly.user_id
#   ]
#
#   tags = {
#     Name   = "Valkey User Group"
#     Access = "Mixed"
#   }
# }

# 例3: Replication Groupへの関連付け
# resource "aws_elasticache_replication_group" "example" {
#   replication_group_id       = "example-rg"
#   replication_group_description = "Example replication group"
#   engine                     = "redis"
#   engine_version             = "7.0"
#   node_type                  = "cache.t3.micro"
#   num_cache_clusters         = 2
#   transit_encryption_enabled = true  # RBACにはTLSが必須
#   user_group_ids             = [aws_elasticache_user_group.app.id]
# }

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
# 1. RBACの要件:
#    - ユーザーグループを使用するには、クラスターでin-transit encryption
#      （TLS）を有効にする必要があります
#
# 2. エンジンの互換性:
#    - RBAC機能はValkeyとRedis OSS 6.0以降でのみ利用可能
#    - Serverlessキャッシュでは、RBACが唯一のアクセス制御方法
#
# 3. ユーザー数の制限:
#    - 1つのユーザーグループあたり最大100ユーザー
#    - アカウント全体で最大1000ユーザー
#    - アカウント全体で最大100ユーザーグループ
#
# 4. Valkeyの特徴:
#    - Valkeyユーザーグループにはデフォルトユーザーが不要
#    - Valkeyユーザーは必ずパスワード保護またはIAM認証を使用
#    - ValkeyユーザーグループはValkeyクラスターのみに関連付け可能
#
# 5. タグの管理:
#    - tags_allはTerraformが自動管理するため、通常は設定不要
#    - provider default_tagsを活用することで、タグ管理を一元化可能
