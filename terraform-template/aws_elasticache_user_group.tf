#---------------------------------------------------------------
# ElastiCache User Group
#---------------------------------------------------------------
#
# ElastiCacheのユーザーグループを管理するリソースです。
# ユーザーグループは、Redis/Valkeyクラスターにアクセスできる複数のユーザーをまとめて管理するための機能です。
# ユーザーグループを使用することで、アクセス制御を一元管理し、複数のユーザーに同じアクセス権限を付与できます。
# ロールベースアクセスコントロール(RBAC)の実装に活用できます。
#
# AWS公式ドキュメント:
#   - ElastiCache User Groups: https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Clusters.RBAC.html
#   - Role-Based Access Control: https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Clusters.RBAC.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_user_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticache_user_group" "example" {
  #-------------------------------------------------------------
  # 基本設定 (必須)
  #-------------------------------------------------------------

  # user_group_id (Required)
  # 設定内容: ユーザーグループの一意な識別子を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 注意: 作成後は変更できません。変更する場合はリソースの再作成が必要です。
  # 参考: https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Clusters.RBAC.html
  user_group_id = "my-user-group"

  # engine (Required)
  # 設定内容: ユーザーグループが対象とするキャッシュエンジンのタイプを指定します。
  # 設定可能な値:
  #   - redis: Redis エンジン
  #   - valkey: Valkey エンジン
  # 注意: 大文字小文字は区別されません（case insensitive）
  #       作成後は変更できません。変更する場合はリソースの再作成が必要です。
  # 参考: https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/WhatIs.html
  engine = "redis"

  #-------------------------------------------------------------
  # ユーザー管理 (オプション)
  #-------------------------------------------------------------

  # user_ids (Optional)
  # 設定内容: このユーザーグループに所属するユーザーIDのリストを指定します。
  # 設定可能な値: ElastiCacheユーザーリソース(aws_elasticache_user)のuser_idの配列
  # 省略時: ユーザーが所属していない空のグループが作成されます
  # 注意: 指定するユーザーは同じエンジンタイプ(redis/valkey)である必要があります。
  #       ユーザーグループにはデフォルトユーザーも含めることができます。
  # 参考: https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Clusters.RBAC.html
  user_ids = []

  #-------------------------------------------------------------
  # リージョン設定 (オプション)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを明示的に指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 注意: マルチリージョン環境でのリソース管理時に有用です。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定 (オプション)
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグのキーと値のマップを指定します。
  # 設定可能な値: キー・バリューペアのマップ
  # 省略時: タグは付与されません
  # 注意: プロバイダーレベルでdefault_tagsが設定されている場合、
  #       同じキーのタグはリソースレベルの値で上書きされます。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-user-group"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ユーザーグループの識別子（user_group_idと同じ値）
#
# - arn: ユーザーグループを一意に識別するAmazon Resource Name (ARN)
#   形式: arn:aws:elasticache:region:account-id:usergroup:user-group-id
#
# - tags_all: リソースに割り当てられたすべてのタグ
#   プロバイダーのdefault_tagsから継承されたタグを含みます
#   参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
#---------------------------------------------------------------
