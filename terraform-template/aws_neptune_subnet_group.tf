#---------------------------------------------------------------
# Amazon Neptune サブネットグループ
#---------------------------------------------------------------
#
# Amazon Neptuneデータベースクラスターで使用するVPCサブネットのグループを定義します。
# Neptune DB クラスターは、指定されたサブネットグループ内のサブネット内に作成されます。
# サブネットグループには、少なくとも2つの異なるアベイラビリティーゾーンのサブネットを
# 含める必要があります。
#
# AWS公式ドキュメント:
#   - Amazon Neptune DBサブネットグループ: https://docs.aws.amazon.com/neptune/latest/userguide/neptune-db-subnet-groups.html
#   - CreateDBSubnetGroup API: https://docs.aws.amazon.com/neptune/latest/userguide/api-subnet-groups.html#CreateDBSubnetGroup
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/neptune_subnet_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptune_subnet_group" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # subnet_ids (必須)
  # タイプ: set(string)
  # Neptune DBクラスターを配置するVPCサブネットIDのリスト。
  # 少なくとも2つの異なるアベイラビリティーゾーンのサブネットを指定する必要があります。
  # これにより、Neptune DBクラスターの高可用性が確保されます。
  subnet_ids = [
    # aws_subnet.private_subnet_1.id,
    # aws_subnet.private_subnet_2.id,
  ]

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # name (オプション)
  # タイプ: string
  # Neptuneサブネットグループの名前。
  # 省略した場合、Terraformがランダムでユニークな名前を自動的に割り当てます。
  # このパラメータを変更すると、リソースの再作成が強制されます（Forces new resource）。
  # name_prefixとの併用はできません。
  # 例: "neptune-subnet-group-prod"
  name = null

  # name_prefix (オプション)
  # タイプ: string
  # 指定されたプレフィックスで始まるユニークな名前を作成します。
  # nameパラメータと競合するため、どちらか一方のみ使用してください。
  # このパラメータを変更すると、リソースの再作成が強制されます（Forces new resource）。
  # 例: "neptune-" → "neptune-20240131123456789012345678"のような名前が生成されます
  name_prefix = null

  # description (オプション)
  # タイプ: string
  # Neptuneサブネットグループの説明。
  # 指定しない場合、デフォルトで "Managed by Terraform" が設定されます。
  # この説明は、AWSコンソールやCLI出力でサブネットグループを識別する際に役立ちます。
  # 例: "Production Neptune cluster subnet group"
  description = null

  # region (オプション)
  # タイプ: string
  # このリソースが管理されるAWSリージョン。
  # 指定しない場合、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # 通常はプロバイダーレベルでリージョンを設定するため、このパラメータは省略されることが多いです。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 例: "us-east-1", "ap-northeast-1"
  region = null

  # id (オプション、通常は指定不要)
  # タイプ: string
  # Neptuneサブネットグループの識別子。
  # 通常はTerraformが自動的に管理するため、明示的に指定する必要はありません。
  # 省略した場合、リソース作成後に自動的に計算されます（computed）。
  # 特別な理由がない限り、このパラメータは設定しないことを推奨します。
  id = null

  # tags (オプション)
  # タイプ: map(string)
  # リソースに割り当てるタグのマップ。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # キーが一致するタグはプロバイダーレベルで定義されたものを上書きします。
  # タグを使用することで、リソースの整理、コスト配分、アクセス制御などが可能になります。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    # Name        = "neptune-subnet-group-example"
    # Environment = "production"
    # Project     = "my-project"
    # ManagedBy   = "terraform"
  }

  # tags_all (オプション、通常は指定不要)
  # タイプ: map(string)
  # リソースに割り当てられる全てのタグのマップ（プロバイダーのdefault_tagsを含む）。
  # 通常はTerraformが自動的に管理するため、明示的に指定する必要はありません。
  # プロバイダーのdefault_tags設定ブロックから継承されたタグも含めた完全なタグセットが
  # 自動的に計算されます（computed）。
  # 特別な理由がない限り、このパラメータは設定せず、tagsパラメータのみを使用することを推奨します。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference (参照専用の属性)
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です（computed）。
#
# - arn
#   タイプ: string
#   Neptuneサブネットグループのアマゾンリソースネーム（ARN）。
#   IAMポリシーやリソースベースのアクセス制御で使用されます。
#   形式: arn:aws:neptune:{region}:{account-id}:subgrp:{subnet-group-name}
#   例: aws_neptune_subnet_group.example.arn
#---------------------------------------------------------------
