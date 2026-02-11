#---------------------------------------------------------------
# RDS DB Subnet Group
#---------------------------------------------------------------
#
# Amazon RDS データベースインスタンスを配置するサブネットグループをプロビジョニングするリソースです。
# DB subnet groupは、VPC内の複数のサブネット（通常はプライベートサブネット）をグループ化し、
# RDS/Aurora DBインスタンスまたはクラスターの配置場所を定義します。
# 最低2つの異なるAvailability Zone（AZ）にサブネットが必要です。
#
# AWS公式ドキュメント:
#   - VPCでのDB instanceの操作: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html
#   - VPCでのDB clusterの操作: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_db_subnet_group" "example" {
  #-------------------------------------------------------------
  # サブネットグループ名の設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: DB subnet groupの名前を指定します。
  # 設定可能な値: 1-255文字の文字列（小文字、数字、ハイフンのみ）
  # 省略時: Terraformがランダムな一意の名前を自動生成します
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）。変更するとリソースが再作成されます
  # 関連機能: RDS DB Subnet Group
  #   複数のサブネットをグループ化し、DBインスタンスの配置先を定義します。
  #   同じVPCに属する最低2つの異なるAZのサブネットが必要です。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html
  name = "main-db-subnet-group"

  # name_prefix (Optional, Computed, Forces new resource)
  # 設定内容: DB subnet group名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します
  # 注意: nameと排他的（どちらか一方のみ指定可能）。変更するとリソースが再作成されます
  name_prefix = null

  #-------------------------------------------------------------
  # サブネット設定
  #-------------------------------------------------------------

  # subnet_ids (Required)
  # 設定内容: DB subnet groupに含めるVPCサブネットのIDリストを指定します。
  # 設定可能な値: サブネットIDの文字列セット
  # 要件:
  #   - 最低2つの異なるAvailability Zoneにサブネットが必要
  #   - すべてのサブネットは同じVPCに属している必要がある
  #   - 各サブネットには十分なIPアドレス空間が必要（予備IPアドレス用）
  # 関連機能: RDS Multi-AZ配置
  #   複数AZのサブネットを指定することで、Multi-AZ構成を実現できます。
  #   RDSは自動的にプライマリとスタンバイを異なるAZに配置します。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html
  # 注意: セキュリティベストプラクティスとして、本番環境ではprivate subnetを使用してください
  subnet_ids = [
    "subnet-12345678",
    "subnet-87654321",
  ]

  #-------------------------------------------------------------
  # 説明
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: DB subnet groupの用途や目的を説明するテキストを指定します。
  # 設定可能な値: 文字列
  # 省略時: "Managed by Terraform" が自動設定されます
  description = "Database subnet group for production RDS instances"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
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
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Tagging.html
  tags = {
    Name        = "Main DB Subnet Group"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。DB subnet group名と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DB subnet group名（nameと同じ値）
#
# - arn: DB subnet groupのAmazon Resource Name (ARN)
#   形式: arn:aws:rds:<region>:<account-id>:subgrp:<name>
#
# - vpc_id: サブネットが属するVPCのID
#
# - supported_network_types: サポートされるネットワークタイプ
#   通常は ["IPV4"] または ["IPV4", "IPV6"]（dual-stack mode）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
