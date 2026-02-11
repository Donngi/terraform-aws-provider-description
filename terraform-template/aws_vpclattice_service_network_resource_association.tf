#---------------------------------------------------------------
# AWS VPC Lattice Service Network Resource Association
#---------------------------------------------------------------
#
# Amazon VPC Latticeのサービスネットワークリソースアソシエーションを
# プロビジョニングするリソースです。
# リソース設定（Resource Configuration）をサービスネットワークに関連付けることで、
# サービスネットワークに接続されたVPC内のクライアントがリソースにアクセスできるようになります。
#
# AWS公式ドキュメント:
#   - VPC Lattice サービスネットワーク: https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-networks.html
#   - サービスネットワークのアソシエーション管理: https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-network-associations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_service_network_resource_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpclattice_service_network_resource_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # resource_configuration_identifier (Required)
  # 設定内容: サービスネットワークに関連付けるリソース設定の識別子を指定します。
  # 設定可能な値: リソース設定のIDまたはARN
  # 関連機能: VPC Lattice リソース設定
  #   リソース設定は、VPC内のリソース（単一リソースまたはリソースグループ）を表現し、
  #   他のVPCやアカウントと共有できます。リソースゲートウェイと関連付けられ、
  #   カスタムドメイン名を持つことができます。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/resource-configuration.html
  resource_configuration_identifier = "rcfg-0123456789abcdef0"

  # service_network_identifier (Required)
  # 設定内容: リソースを関連付けるサービスネットワークの識別子を指定します。
  # 設定可能な値: サービスネットワークのIDまたはARN
  # 関連機能: VPC Lattice サービスネットワーク
  #   サービスネットワークは、サービスとリソース設定のコレクションの論理的な境界です。
  #   ネットワーク内のサービスとリソース設定は、検出、接続、アクセス、
  #   オブザーバビリティの認可を行うことができます。
  #   - https://docs.aws.amazon.com/vpc-lattice/latest/ug/service-networks.html
  service_network_identifier = "sn-0123456789abcdef0"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # DNS設定
  #-------------------------------------------------------------

  # private_dns_enabled (Optional)
  # 設定内容: サービスネットワークリソースアソシエーションでプライベートDNSを有効にするかを指定します。
  # 設定可能な値:
  #   - true: プライベートDNSを有効化。resource_configuration_identifierで指定された
  #           リソース設定には、カスタムドメイン名またはグループドメインが必要です。
  #   - false (デフォルト): プライベートDNSを無効化
  # 関連機能: VPC Lattice プライベートDNS
  #   プライベートDNSを有効にすると、VPC Latticeがリソースコンシューマーに代わって
  #   プライベートホストゾーンをプロビジョニングします。これにより、カスタムドメイン名を
  #   使用してリソースにアクセスできるようになります。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/resource-configuration.html
  # 注意: trueに設定する場合、リソース設定にカスタムドメイン名またはグループドメインが
  #       設定されている必要があります。
  private_dns_enabled = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-resource-association"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: サービスネットワークリソースアソシエーションのAmazon Resource Name (ARN)
#
# - id: アソシエーションのID
#
# - dns_entry: サービスネットワーク内のアソシエーションのDNSエントリ
#     - domain_name: サービスネットワーク内のアソシエーションのドメイン名
#     - hosted_zone_id: ドメイン名を含むホストゾーンのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
