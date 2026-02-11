#---------------------------------------------------------------
# VPC Lattice Resource Configuration
#
# VPC Lattice リソース設定を管理します。
# リソースゲートウェイを通じてアクセス可能なTCPリソース（RDSデータベース、
# IPアドレス、ドメイン名など）を定義します。複数のVPCやアカウントから
# プライベートかつセキュアにリソースへのアクセスを提供します。
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-configuration.html
#
# Terraform AWS Provider Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpclattice_resource_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
#
# NOTE: このテンプレートはリソースの理解を助けるためのものです。
# 実際の使用時は、環境に応じて適切な値を設定してください。
#---------------------------------------------------------------

resource "aws_vpclattice_resource_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: リソース設定の名前
  # 設定可能な値: 任意の文字列（リソースを識別するための名前）
  # 省略時: 省略不可
  # 関連機能: VPC Lattice Resource Gateway - https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-gateway.html
  name = "database-config"

  # resource_gateway_identifier (Optional)
  # 設定内容: リソースゲートウェイのID
  # 設定可能な値: VPC Lattice リソースゲートウェイのID
  # 省略時: resource_configuration_group_idが指定されている場合は省略可能
  # 関連機能: Resource Gateway - https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-gateway.html
  resource_gateway_identifier = "rgw-0a1b2c3d4e5f6g7h8"

  # port_ranges (Required)
  # 設定内容: リソースへのアクセスに使用するポートまたはポート範囲
  # 設定可能な値: 単一ポート（例: "80"）またはポート範囲（例: "80-81"）のリスト
  # 省略時: 省略不可
  # 関連機能: TCP Protocol Support - https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-configuration.html
  port_ranges = ["3306"]

  # protocol (Optional)
  # 設定内容: リソースアクセスに使用するプロトコル
  # 設定可能な値: TCP（現在はTCPのみサポート）
  # 省略時: resource_configuration_group_idが指定されていない場合は必須
  # 関連機能: TCP Resource Connectivity - https://aws.amazon.com/blogs/networking-and-content-delivery/use-amazon-vpc-lattice-to-streamline-and-secure-tcp-resource-connectivity-across-multiple-aws-accounts/
  protocol = "TCP"

  #-------------------------------------------------------------
  # リソース定義
  #-------------------------------------------------------------

  # resource_configuration_definition (Required)
  # 設定内容: リソース設定の詳細定義
  # 設定可能な値: dns_resource、ip_resource、またはarn_resourceブロック
  # 省略時: 省略不可
  resource_configuration_definition {
    # dns_resource (Optional)
    # 設定内容: DNS名によるリソース定義
    # 設定可能な値: dns_resourceブロック
    # 省略時: dns_resource、ip_resource、arn_resourceのいずれかを指定
    dns_resource {
      # domain_name (Required)
      # 設定内容: リソースのホスト名（FQDN）
      # 設定可能な値: 有効なドメイン名
      # 省略時: 省略不可
      # 関連機能: DNS Resolution - https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-configuration.html
      domain_name = "database.example.internal"

      # ip_address_type (Required)
      # 設定内容: リソースのIPアドレスタイプ
      # 設定可能な値: IPV4、IPV6
      # 省略時: 省略不可
      ip_address_type = "IPV4"
    }

    # ip_resource (Optional)
    # 設定内容: IPアドレスによるリソース定義
    # 設定可能な値: ip_resourceブロック
    # 省略時: dns_resource、ip_resource、arn_resourceのいずれかを指定
    # ip_resource {
    #   # ip_address (Required)
    #   # 設定内容: リソースのIPアドレス
    #   # 設定可能な値: 有効なIPv4またはIPv6アドレス
    #   # 省略時: 省略不可
    #   ip_address = "10.0.1.100"
    # }

    # arn_resource (Optional)
    # 設定内容: ARNによるリソース定義（RDSなど）
    # 設定可能な値: arn_resourceブロック
    # 省略時: dns_resource、ip_resource、arn_resourceのいずれかを指定
    # 関連機能: RDS Integration - https://aws.amazon.com/blogs/networking-and-content-delivery/use-amazon-vpc-lattice-to-streamline-and-secure-tcp-resource-connectivity-across-multiple-aws-accounts/
    # arn_resource {
    #   # arn (Required)
    #   # 設定内容: リソースのARN
    #   # 設定可能な値: 有効なAWS ARN（例: RDSクラスターARN）
    #   # 省略時: 省略不可
    #   arn = "arn:aws:rds:us-east-1:123456789012:cluster:database-cluster"
    # }

    # region (Optional)
    # 設定内容: リソース定義を管理するAWSリージョン
    # 設定可能な値: 有効なAWSリージョンコード
    # 省略時: プロバイダー設定のリージョン
    # region = "us-east-1"
  }

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # type (Optional)
  # 設定内容: リソース設定のタイプ
  # 設定可能な値: GROUP、CHILD、SINGLE、ARN
  # 省略時: SINGLE（デフォルト）
  # 関連機能: Resource Configuration Types - https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-configuration.html
  type = "SINGLE"

  # custom_domain_name (Optional)
  # 設定内容: カスタムドメイン名
  # 設定可能な値: 検証済みのカスタムドメイン名
  # 省略時: カスタムドメイン名なし
  # 関連機能: Custom Domain Verification - https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-configuration.html
  # custom_domain_name = "custom.example.com"

  # domain_verification_id (Optional)
  # 設定内容: ドメイン検証ID（カスタムドメイン名を使用する場合）
  # 設定可能な値: aws_vpclattice_domain_verificationリソースのID
  # 省略時: DNS設定を手動で構成する必要がある
  # 関連機能: Domain Verification - https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-configuration.html
  # domain_verification_id = "dv-0a1b2c3d4e5f6g7h8"

  # tags (Optional)
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のマップ
  # 省略時: タグなし
  # 関連機能: Tagging AWS Resources - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "database-config"
    Environment = "production"
    ResourceType = "database"
    ManagedBy   = "terraform"
  }

  # region (Optional)
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョン
  # 関連機能: AWS Regions - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です:
#
# arn
#   リソース設定のARN
#   例: arn:aws:vpc-lattice:us-east-1:123456789012:resourceconfiguration/rc-0a1b2c3d4e5f6g7h8
#
# id
#   リソース設定のID
#   例: rc-0a1b2c3d4e5f6g7h8
#
# domain_verification_arn
#   ドメイン検証のARN（custom_domain_nameが設定されている場合）
#   例: arn:aws:vpc-lattice:us-east-1:123456789012:domainverification/dv-0a1b2c3d4e5f6g7h8
#
# domain_verification_status
#   ドメイン検証のステータス（custom_domain_nameが設定されている場合）
#   例: VERIFIED、PENDING、FAILED
#
# tags_all
#   プロバイダーのdefault_tagsとリソースのtagsをマージしたすべてのタグ
#---------------------------------------------------------------
