#---------------------------------------------------------------
# ElastiCache Subnet Group
#---------------------------------------------------------------
#
# ElastiCacheサブネットグループをプロビジョニングします。
# サブネットグループは、VPC環境でElastiCacheクラスター（Redis/Memcached）を起動する際に
# 使用されるサブネットのコレクションです。クラスターのノードはこのサブネットグループから
# IPアドレスが割り当てられます。
#
# AWS公式ドキュメント:
#   - Subnets and subnet groups: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/SubnetGroups.html
#   - Creating a subnet group: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/SubnetGroups.Creating.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/elasticache_subnet_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticache_subnet_group" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # name - (必須) サブネットグループの名前
  # ElastiCacheはこの名前を小文字に変換します。
  # 例: "my-cache-subnet-group"
  name = "example-cache-subnet-group"

  # subnet_ids - (必須) サブネットグループに含めるVPCサブネットIDのリスト
  # ElastiCacheクラスターはこれらのサブネットからIPアドレスを割り当てられます。
  # 高可用性を確保するため、複数のアベイラビリティーゾーンにまたがる
  # サブネットを指定することを推奨します。
  # 例: ["subnet-12345678", "subnet-87654321"]
  subnet_ids = []

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # description - (オプション) サブネットグループの説明
  # 指定しない場合のデフォルト: "Managed by Terraform"
  # 例: "ElastiCache subnet group for production environment"
  description = "Managed by Terraform"

  # region - (オプション) このリソースを管理するリージョン
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  # 通常は明示的に指定する必要はありません。
  # 例: "us-west-2"
  # region = null

  # tags - (オプション) リソースに付与するタグのキー・バリューマップ
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーを持つタグはここで指定した値で上書きされます。
  # 例: {
  #   Environment = "production"
  #   Project     = "my-app"
  #   ManagedBy   = "terraform"
  # }
  tags = {}
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（読み取り専用）:
#
# - arn
#   サブネットグループのARN
#
# - tags_all
#   リソースに割り当てられたすべてのタグのマップ。
#   プロバイダーの default_tags から継承されたタグも含まれます。
#
# - vpc_id
#   サブネットグループが属するVPCのID
#
# 使用例:
#   aws_elasticache_subnet_group.example.vpc_id
#   aws_elasticache_subnet_group.example.arn
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用上の注意事項
#---------------------------------------------------------------
# 1. サブネットの選択:
#    - 複数のアベイラビリティーゾーンにまたがるサブネットを含めることで
#      高可用性を実現できます
#    - ElastiCacheはメンテナンス時に予備のIPアドレスを必要とするため、
#      十分な空きIPアドレスを持つサブネットを選択してください
#
# 2. サブネットグループの変更:
#    - 既存のクラスターが使用しているサブネットはサブネットグループから
#      削除できません
#    - サブネットグループの変更後、クラスターの再起動が必要な場合があります
#
# 3. 名前の制約:
#    - ElastiCacheは指定された名前を自動的に小文字に変換します
#    - 名前は一意である必要があります
#
# 4. Local Zonesのサポート:
#    - Local Zonesでサブネットグループを使用する場合は、
#      Local Zone用のサブネットを作成し、そのサブネットをグループに追加します
#    - 対応ノードタイプ: M5, R5, T3の現行世代
#
# 5. ElastiCache Serverlessとの違い:
#    - ElastiCache Serverlessはサブネットグループリソースを使用しません
#    - このリソースはノードベースのクラスター（Redis/Memcached）専用です
#---------------------------------------------------------------
