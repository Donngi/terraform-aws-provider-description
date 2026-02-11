#---------------------------------------------------------------
# AWS DMS Replication Subnet Group
#---------------------------------------------------------------
#
# AWS Database Migration Service (DMS) のレプリケーションサブネットグループを
# プロビジョニングするリソースです。レプリケーションサブネットグループは、
# DMS レプリケーションインスタンスが使用するサブネットを定義します。
#
# NOTE: このリソースを使用する場合、AWS では「dms-vpc-role」という特別な
#       IAM ロールが必要です。下記の例を参考に設定してください。
#
# AWS公式ドキュメント:
#   - DMS 概要: https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html
#   - VPC でのレプリケーションインスタンス: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.VPC.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_subnet_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 前提条件: DMS VPC ロールの作成
#---------------------------------------------------------------
# DMS がレプリケーションサブネットグループを使用するには、
# dms-vpc-role という名前の IAM ロールが必要です。
#
# resource "aws_iam_role" "dms_vpc_role" {
#   name        = "dms-vpc-role"
#   description = "Allows DMS to manage VPC"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "dms.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       },
#     ]
#   })
# }
#
# resource "aws_iam_role_policy_attachment" "dms_vpc_role_attachment" {
#   role       = aws_iam_role.dms_vpc_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
# }
#---------------------------------------------------------------

resource "aws_dms_replication_subnet_group" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # replication_subnet_group_id (Required)
  # 設定内容: レプリケーションサブネットグループの名前（識別子）を指定します。
  # 設定可能な値: 最大255文字の英数字、ピリオド、スペース、アンダースコア、
  #              ハイフンを使用可能。「default」は使用不可。
  # 注意: この値は小文字で保存されます。
  replication_subnet_group_id = "example-dms-replication-subnet-group"

  # replication_subnet_group_description (Required)
  # 設定内容: サブネットグループの説明を指定します。
  # 設定可能な値: 文字列
  replication_subnet_group_description = "Example DMS replication subnet group for database migration"

  # subnet_ids (Required)
  # 設定内容: サブネットグループに含める EC2 サブネット ID のリストを指定します。
  # 設定可能な値: サブネット ID のセット
  # 注意:
  #   - 少なくとも2つのサブネットを指定する必要があります。
  #   - サブネットは少なくとも2つのアベイラビリティーゾーンをカバーする必要があります。
  #   - すべてのサブネットは同じ VPC 内に存在する必要があります。
  subnet_ids = [
    "subnet-xxxxxxxxxxxxxxxxx",
    "subnet-yyyyyyyyyyyyyyyyy",
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-dms-replication-subnet-group"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されたタグを含む全タグのマップです。
  # 注意: 通常は明示的に設定せず、Terraform が自動計算します。
  # tags_all = {}

  #-------------------------------------------------------------
  # 依存関係
  #-------------------------------------------------------------
  # dms-vpc-role が作成されている場合は、明示的な依存関係を設定してください。
  # depends_on = [aws_iam_role_policy_attachment.dms_vpc_role_attachment]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - replication_subnet_group_arn: レプリケーションサブネットグループの
#                                  Amazon Resource Name (ARN)
#
# - vpc_id: サブネットグループが属する VPC の ID
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
