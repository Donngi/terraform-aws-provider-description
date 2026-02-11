#---------------------------------------------------------------
# VPC Endpoint Private DNS
#---------------------------------------------------------------
#
# VPCエンドポイントのプライベートDNSを有効化するリソースです。
# InterfaceタイプのVPCエンドポイントに対してプライベートホストゾーンを
# 関連付けることで、サービスへのアクセスにプライベートDNS名を使用できます。
#
# AWS公式ドキュメント:
#   - VPC エンドポイント: https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html
#   - インターフェイスエンドポイント: https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-interface.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_private_dns
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_endpoint_private_dns" "example" {
  #-------------------------------------------------------------
  # VPCエンドポイント設定
  #-------------------------------------------------------------

  # vpc_endpoint_id (Required)
  # 設定内容: プライベートDNSを設定するVPCエンドポイントのIDを指定します。
  # 設定可能な値: 有効なVPCエンドポイントID（例: vpce-1234567890abcdef0）
  # 注意: 親リソースの aws_vpc_endpoint で private_dns_enabled 引数を設定している場合は、
  #       このリソースを使用する際に親リソース側の設定を省略してください。
  #       両方で設定すると意図しない動作や永続的な差分が発生する可能性があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-interface.html
  vpc_endpoint_id = "vpce-1234567890abcdef0"

  #-------------------------------------------------------------
  # プライベートDNS設定
  #-------------------------------------------------------------

  # private_dns_enabled (Required)
  # 設定内容: VPCにプライベートホストゾーンを関連付けるかを指定します。
  # 設定可能な値:
  #   - true: プライベートホストゾーンを関連付け、プライベートDNS名を有効化
  #   - false: プライベートホストゾーンを関連付けない
  # 関連機能: VPCエンドポイントのプライベートDNS名
  #   Interfaceエンドポイントのみで利用可能な機能。プライベートDNS名を有効にすると、
  #   サービスのデフォルトDNS名に対するリクエストがVPCエンドポイントにルーティングされます。
  #   - https://docs.aws.amazon.com/vpc/latest/privatelink/vpce-interface.html#vpce-private-dns
  # 注意: この機能はInterfaceタイプのVPCエンドポイントにのみ適用されます。
  private_dns_enabled = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは標準的な読み取り専用属性をエクスポートします。
# 特に、以下の属性が利用可能です:
#
# - id: リソースの識別子（VPCエンドポイントIDと同じ）
#---------------------------------------------------------------
