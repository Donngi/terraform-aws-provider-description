#---------------------------------------------------------------
# AWS DocumentDB Subnet Group
#---------------------------------------------------------------
#
# Amazon DocumentDBのサブネットグループをプロビジョニングするリソースです。
# サブネットグループは、VPC内のDocumentDBクラスターが使用するサブネットを
# 定義するために使用されます。これにより、クラスターの高可用性を確保するため
# 複数のアベイラビリティゾーンにまたがるサブネットを指定できます。
#
# AWS公式ドキュメント:
#   - Amazon DocumentDB概要: https://docs.aws.amazon.com/documentdb/latest/developerguide/what-is.html
#   - サブネットグループ: https://docs.aws.amazon.com/documentdb/latest/developerguide/subnets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_subnet_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_docdb_subnet_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: DocDBサブネットグループの名前を指定します。
  # 設定可能な値: 小文字の英数字とハイフンのみ。1-255文字。
  # 省略時: Terraformがランダムなユニーク名を自動生成します。
  # 注意: name_prefixと競合するため、どちらか一方のみ指定してください。
  name = "example-docdb-subnet-group"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: 指定されたプレフィックスで始まるユニーク名を作成します。
  # 設定可能な値: 小文字の英数字とハイフン。プレフィックスは短くすることを推奨。
  # 省略時: nameが使用されます。
  # 注意: nameと競合するため、どちらか一方のみ指定してください。
  # name_prefix = "example-"

  # description (Optional)
  # 設定内容: DocDBサブネットグループの説明を指定します。
  # 設定可能な値: 任意の文字列（最大255文字）
  # 省略時: "Managed by Terraform" が設定されます。
  description = "Example DocumentDB subnet group for production workloads"

  # subnet_ids (Required)
  # 設定内容: VPCサブネットIDのリストを指定します。
  # 設定可能な値: 有効なVPCサブネットIDの配列
  # 注意: 高可用性のため、複数のアベイラビリティゾーンにまたがるサブネットを
  #       指定することを推奨します。少なくとも2つのサブネットが必要です。
  # 関連機能: VPCサブネット
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html
  subnet_ids = [
    "subnet-xxxxxxxxxxxxxxxxx",
    "subnet-yyyyyyyyyyyyyyyyy",
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-docdb-subnet-group"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DocDBサブネットグループ名
#
# - arn: DocDBサブネットグループのAmazon Resource Name (ARN)
#
# - supported_network_types: DocDBサブネットグループのネットワークタイプ
#                            （"IPV4" または "DUAL"）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
