#---------------------------------------------------------------
# MemoryDB Subnet Group
#---------------------------------------------------------------
#
# Amazon MemoryDBクラスターが使用するサブネットグループを作成する。
# サブネットグループは、MemoryDBクラスターをデプロイするVPC内のサブネットの
# コレクションを定義する。通常、プライベートサブネットを指定してクラスターを
# VPC環境内に配置する。
#
# AWS公式ドキュメント:
#   - Subnets and subnet groups: https://docs.aws.amazon.com/memorydb/latest/devguide/subnetgroups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_subnet_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_memorydb_subnet_group" "this" {
  #---------------------------------------------------------------
  # 必須引数
  #---------------------------------------------------------------

  # subnet_ids (Required, set of string)
  # サブネットグループに含めるVPCサブネットIDのセット。
  # 少なくとも1つのサブネットを指定する必要がある。
  # 高可用性を確保するため、複数のアベイラビリティゾーンにまたがる
  # サブネットを指定することが推奨される。
  subnet_ids = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]

  #---------------------------------------------------------------
  # オプション引数
  #---------------------------------------------------------------

  # name (Optional, string)
  # サブネットグループの名前。
  # 省略した場合、Terraformがランダムでユニークな名前を自動生成する。
  # name_prefixと競合するため、どちらか一方のみ指定可能。
  # 変更時はリソースの再作成が発生する。
  # name = "my-memorydb-subnet-group"

  # name_prefix (Optional, string)
  # 指定したプレフィックスで始まるユニークな名前を自動生成する。
  # nameと競合するため、どちらか一方のみ指定可能。
  # 変更時はリソースの再作成が発生する。
  # name_prefix = "my-memorydb-"

  # description (Optional, string)
  # サブネットグループの説明文。
  # 省略した場合、デフォルトで "Managed by Terraform" が設定される。
  # description = "Subnet group for MemoryDB cluster"

  # region (Optional, string)
  # このリソースを管理するAWSリージョン。
  # 省略した場合、プロバイダー設定のリージョンが使用される。
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  # tags (Optional, map of string)
  # リソースに割り当てるタグのマップ。
  # プロバイダーレベルでdefault_tagsが設定されている場合、
  # 同じキーを持つタグはここでの指定が優先される。
  # tags = {
  #   Name        = "my-memorydb-subnet-group"
  #   Environment = "production"
  # }

  # tags_all (Optional, computed, map of string)
  # プロバイダーレベルのdefault_tagsを含む、リソースに割り当てられた
  # すべてのタグのマップ。通常は明示的に設定せず、Terraformが自動計算する。
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
# 以下の属性はリソース作成後にのみ参照可能。
#---------------------------------------------------------------
#
# id - サブネットグループの名前。
#
# arn - サブネットグループのAmazon Resource Name (ARN)。
#   例: arn:aws:memorydb:us-east-1:123456789012:subnetgroup/my-subnet-group
#
# vpc_id - サブネットグループが存在するVPCのID。
#
#---------------------------------------------------------------
