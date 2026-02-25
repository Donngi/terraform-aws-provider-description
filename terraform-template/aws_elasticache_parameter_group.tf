#---------------------------------------------------------------
# ElastiCache パラメータグループ
#---------------------------------------------------------------
#
# ElastiCacheクラスタの動作を制御するパラメータの集合を定義します。
# Redis/Memcachedエンジン固有のパラメータをカスタマイズできます。
#
# AWS公式ドキュメント:
#   - ElastiCacheパラメータグループ: https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/ParameterGroups.html
#   - Redisパラメータ: https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/ParameterGroups.Redis.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 注意事項:
#   - familyにredis2.6またはredis2.8を指定した場合、reserved-memoryパラメータの削除は
#     ElastiCache APIの制限により永続的な差分を引き起こす可能性があります
#
#---------------------------------------------------------------

resource "aws_elasticache_parameter_group" "example" {
  #---------------------------------------
  # 必須項目
  #---------------------------------------

  # パラメータグループ名
  # 設定内容: ElastiCacheパラメータグループの一意の識別子
  # 設定可能な値: 英数字とハイフン（最大255文字）
  name = "cache-params"

  # エンジンファミリー
  # 設定内容: パラメータグループが対応するキャッシュエンジンのバージョンファミリー
  # 設定可能な値: redis2.6, redis2.8, redis3.2, redis4.0, redis5.0, redis6.x, redis7.x, memcached1.4, memcached1.5, memcached1.6等
  family = "redis7.1"

  #---------------------------------------
  # 基本設定
  #---------------------------------------

  # 説明
  # 設定内容: パラメータグループの用途や設定内容の説明
  # 省略時: "Managed by Terraform"
  description = "本番環境用Redisパラメータグループ"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # リソース管理リージョン
  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: us-east-1, ap-northeast-1等の有効なリージョンコード
  # 省略時: プロバイダー設定のリージョン
  region = "ap-northeast-1"

  #---------------------------------------
  # パラメータ定義
  #---------------------------------------

  # カスタムパラメータ
  # 設定内容: エンジン固有のパラメータとその値を定義
  # 設定可能な値: 選択したfamilyで利用可能なパラメータ名と値のペア
  parameter {
    # パラメータ名
    # 設定内容: 設定対象のElastiCacheパラメータ識別子
    # 設定可能な値: エンジンファミリーでサポートされるパラメータ名
    name = "activerehashing"

    # パラメータ値
    # 設定内容: パラメータに設定する具体的な値
    # 設定可能な値: パラメータごとに定義された有効な値（文字列形式）
    value = "yes"
  }

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }

  parameter {
    name  = "timeout"
    value = "300"
  }

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # リソースタグ
  # 設定内容: パラメータグループに付与するメタデータタグ
  # 設定可能な値: キーと値の文字列ペアのマップ
  # 省略時: タグなし（プロバイダーのdefault_tagsは適用される）
  tags = {
    Name        = "example-parameter-group"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースから参照可能な属性:
#
# - id              : パラメータグループ名（nameと同値）
# - arn             : パラメータグループのARN（例: arn:aws:elasticache:region:account-id:parametergroup:name）
# - tags_all        : リソースに付与された全タグ（default_tags含む）
