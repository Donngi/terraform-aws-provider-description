#---------------------------------------------------------------
# AWS Redshift Subnet Group
#---------------------------------------------------------------
#
# Amazon Redshift のサブネットグループをプロビジョニングするリソースです。
# サブネットグループは、Redshift クラスターを起動する VPC サブネットの
# 集合を定義します。クラスターの作成時に指定することで、適切な
# ネットワーク配置が可能になります。
#
# AWS公式ドキュメント:
#   - Redshift サブネットグループの作成: https://docs.aws.amazon.com/redshift/latest/mgmt/create-cluster-subnet-group.html
#   - Redshift リソースの VPC 設定: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-cluster-subnet-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_subnet_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_subnet_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: Redshift サブネットグループの名前を指定します。
  # 設定可能な値: 255文字以内の英数字またはハイフン。"Default" は使用不可。
  # 注意: 作成後の変更はリソースの再作成になります。
  name = "my-redshift-subnet-group"

  # description (Optional)
  # 設定内容: Redshift サブネットグループの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: "Managed by Terraform" が設定されます。
  description = "My Redshift subnet group"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnet_ids (Required)
  # 設定内容: サブネットグループに含める VPC サブネット ID のセットを指定します。
  # 設定可能な値: 有効な VPC サブネット ID の集合（1つ以上）
  # 注意: サブネットグループ内のすべてのサブネットは、同一の Network ACL および
  #       ルートテーブル設定を持つことが推奨されます。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-cluster-subnet-groups.html
  subnet_ids = [
    "subnet-12345678",
    "subnet-87654321",
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定と同一キーのタグは
  #       プロバイダーレベルの定義を上書きします。
  tags = {
    Name        = "my-redshift-subnet-group"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Redshift サブネットグループの Amazon Resource Name (ARN)
#
# - id: Redshift サブネットグループの ID（name と同一）
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
