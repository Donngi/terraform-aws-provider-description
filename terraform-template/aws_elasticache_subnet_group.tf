################################################################################
# ElastiCache Subnet Group
################################################################################
# ElastiCacheクラスター用のサブネットグループリソース
# Redis/Memcachedクラスターを配置するVPCサブネットのコレクションを定義
#
# Generated: 2026-02-17
# NOTE: このテンプレートはAWS Provider v6.28.0のスキーマから自動生成されています
#
# リソース仕様:
#   - プロバイダー: AWS (hashicorp/aws)
#   - API: ElastiCache CreateCacheSubnetGroup
#   - リソースタイプ: aws_elasticache_subnet_group
#   - Terraform Version: >= 0.12
#   - AWS Provider Version: 6.28.0
#
# 主な用途:
#   - ElastiCacheクラスター（Redis/Memcached）のネットワーク配置定義
#   - マルチAZ構成のためのサブネットグルーピング
#   - VPC内でのElastiCacheノード配置制御
#   - プライベートサブネット内でのキャッシュクラスター展開
#
# 関連リソース:
#   - aws_elasticache_cluster: このサブネットグループを使用するキャッシュクラスター
#   - aws_elasticache_replication_group: Redisレプリケーショングループ
#   - aws_subnet: サブネットグループに含めるサブネット
#   - aws_vpc: サブネットグループが属するVPC
#
# 公式ドキュメント:
#   - Resource: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/elasticache_subnet_group
#   - AWS API: https://docs.aws.amazon.com/AmazonElastiCache/latest/APIReference/API_CreateCacheSubnetGroup.html
################################################################################

resource "aws_elasticache_subnet_group" "example" {
  #-------
  # 基本設定
  #-------

  # name - サブネットグループ名（必須）
  # 設定内容: ElastiCacheサブネットグループの一意な名前（AWS側で自動的に小文字化される）
  # 制約事項:
  #   - 最大255文字
  #   - 英数字とハイフンのみ使用可能
  #   - AWS側で小文字に変換されるため大文字は無視される
  # 命名規則: "${環境}-${アプリ名}-elasticache-subnet" 推奨（例: prod-myapp-elasticache-subnet）
  # 更新時の影響: 変更時は強制置換（新規作成・旧リソース削除）
  name = "example-elasticache-subnet-group"

  # description - サブネットグループの説明（オプション）
  # 設定内容: このサブネットグループの用途や目的を説明するテキスト
  # 省略時: "Managed by Terraform" が自動設定される
  # 最大長: 255文字
  # 推奨設定: 環境やアプリケーション名を含む説明（例: "Production Redis cluster subnet group"）
  description = "ElastiCache subnet group for example application"

  #-------
  # ネットワーク設定
  #-------

  # subnet_ids - サブネットIDリスト（必須）
  # 設定内容: ElastiCacheノードを配置可能なVPCサブネットのIDリスト
  # 設定要件:
  #   - 最低1つ以上のサブネットIDが必要
  #   - 全サブネットが同一VPC内に存在する必要あり
  #   - 異なるアベイラビリティゾーンのサブネットを指定することでMulti-AZ構成が可能
  # 高可用性設計: 本番環境では最低2つ以上の異なるAZのサブネットを推奨
  # セキュリティ考慮: プライベートサブネットの使用を強く推奨
  # 参照方法: aws_subnet.example.id または data.aws_subnets で動的取得
  subnet_ids = [
    "subnet-12345678",  # AZ-a: プライベートサブネット
    "subnet-87654321",  # AZ-b: プライベートサブネット
  ]

  # region - リソース管理リージョン（オプション・計算値）
  # 設定内容: このリソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  # 設定可能な値: ap-northeast-1, us-east-1, eu-west-1 など全AWSリージョン
  # 使用シーン: マルチリージョン構成や特定リージョンへの明示的配置が必要な場合
  # 備考: 計算値としても使用されるため、明示的に設定しない場合はプロバイダーから自動設定
  region = "ap-northeast-1"

  #-------
  # タグ設定
  #-------

  # tags - リソースタグ（オプション）
  # 設定内容: サブネットグループに付与するキー・バリュー形式のメタデータ
  # 用途:
  #   - コスト配分タグによる課金管理
  #   - 環境識別（Environment, Project等）
  #   - 運用管理タグ（ManagedBy, Owner等）
  # 継承動作: provider の default_tags と自動マージされる
  # ベストプラクティス: Name, Environment, Project タグの設定を推奨
  tags = {
    Name        = "example-elasticache-subnet-group"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  # tags_all - 全タグの統合マップ（読み取り専用・計算値）
  # 設定内容: リソース固有のtagsとプロバイダーのdefault_tagsを統合したマップ
  # 用途: 実際にAWSリソースに適用される全タグの確認
  # 設定方法: 自動計算されるため明示的な設定は不要
  # tags_all は computed 属性のため設定不要
}

################################################################################
# Attributes Reference（参照可能な属性）
################################################################################
# このリソースから参照可能な属性:
#
# - arn
#   サブネットグループのARN
#   形式: arn:aws:elasticache:region:account-id:subnetgroup:name
#
# - id
#   サブネットグループのID（name と同値）
#
# - vpc_id
#   サブネットグループが属するVPCのID（自動検出される計算値）
#
# - tags_all
#   リソースに適用された全タグのマップ（tagsとdefault_tagsの統合結果）
#
# - region
#   リソースが管理されているAWSリージョン
################################################################################
