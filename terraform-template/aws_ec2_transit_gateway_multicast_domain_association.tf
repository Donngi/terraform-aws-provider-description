# ========================================
# AWS EC2 Transit Gateway Multicast Domain Association
# ========================================
# Terraform Resource: aws_ec2_transit_gateway_multicast_domain_association
# AWS Provider Version: 6.28.0
# Generated: 2026-01-22
#
# このテンプレートは生成時点の情報です。
# 最新の仕様については公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_multicast_domain_association
# ========================================

# 概要:
# Transit Gateway Multicast Domain Associationリソースは、指定されたサブネットと
# Transit Gateway AttachmentをTransit Gateway Multicast Domainに関連付けます。
# これにより、マルチキャストトラフィックがサブネット内のインスタンスに配信されるようになります。
#
# AWS公式ドキュメント:
# - Transit Gateway Multicast: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-multicast-overview.html
# - API Reference: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AssociateTransitGatewayMulticastDomain.html

resource "aws_ec2_transit_gateway_multicast_domain_association" "example" {
  # ========================================
  # Required Parameters
  # ========================================

  # subnet_id - (必須) マルチキャストドメインに関連付けるサブネットのID
  # Transit Gateway VPC Attachmentに含まれているサブネットである必要があります。
  # 関連付けを行う前に、Transit Gateway Attachmentがavailable状態である必要があります。
  #
  # 型: string
  # 例: "subnet-12345678"
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/vpc/latest/tgw/associate-attachment-to-domain.html
  subnet_id = "subnet-12345678"

  # transit_gateway_attachment_id - (必須) Transit Gateway AttachmentのID
  # このアタッチメントは、関連付けるサブネットを含むVPCアタッチメントである必要があります。
  # アタッチメントはavailable状態である必要があります。
  #
  # 型: string
  # 例: "tgw-attach-0123456789abcdef0"
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/vpc/latest/tgw/tgw-vpc-attachments.html
  transit_gateway_attachment_id = "tgw-attach-0123456789abcdef0"

  # transit_gateway_multicast_domain_id - (必須) Transit Gateway Multicast DomainのID
  # サブネットとアタッチメントを関連付ける先のマルチキャストドメインIDを指定します。
  # このドメインは、マルチキャストサポートが有効なTransit Gatewayに属している必要があります。
  #
  # 型: string
  # 例: "tgw-mcast-domain-0123456789abcdef0"
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/vpc/latest/tgw/tgw-multicast-overview.html
  transit_gateway_multicast_domain_id = "tgw-mcast-domain-0123456789abcdef0"

  # ========================================
  # Optional Parameters
  # ========================================

  # id - (オプション) リソースの識別子
  # 通常はTerraformによって自動的に生成されるため、明示的に設定する必要はありません。
  # 設定した場合、リソースのインポート時などに使用されます。
  #
  # 型: string
  # デフォルト: 自動生成
  # Computed: true
  #
  # 注意: このパラメータは通常、設定する必要はありません。
  # id = "tgw-mcast-domain-assoc-0123456789abcdef0"

  # region - (オプション) このリソースが管理されるAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # マルチリージョン構成で特定のリージョンを明示的に指定したい場合に使用します。
  #
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # Computed: true
  #
  # 例: "us-east-1", "ap-northeast-1"
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ========================================
  # Timeouts
  # ========================================
  # リソースの作成・削除操作のタイムアウト設定
  # 大規模な環境や高負荷時に操作が完了するまでの待機時間を調整できます。

  timeouts {
    # create - (オプション) 関連付けの作成タイムアウト
    # 型: string (duration format: "10m", "1h" など)
    # デフォルト: 10m
    # create = "10m"

    # delete - (オプション) 関連付けの削除タイムアウト
    # 型: string (duration format: "10m", "1h" など)
    # デフォルト: 10m
    # delete = "10m"
  }
}

# ========================================
# Attributes Reference (Computed)
# ========================================
# このリソースが作成された後、以下の属性が参照可能になります:
#
# - id: EC2 Transit Gateway Multicast Domain Association識別子
#   出力例: "tgw-mcast-domain-0123456789abcdef0_tgw-attach-0123456789abcdef0_subnet-12345678"
#
# 使用例:
# output "association_id" {
#   value = aws_ec2_transit_gateway_multicast_domain_association.example.id
# }

# ========================================
# Import
# ========================================
# 既存のTransit Gateway Multicast Domain Associationは以下の形式でインポートできます:
#
# terraform import aws_ec2_transit_gateway_multicast_domain_association.example #   tgw-mcast-domain-0123456789abcdef0_tgw-attach-0123456789abcdef0_subnet-12345678
#
# 形式: {transit-gateway-multicast-domain-id}_{transit-gateway-attachment-id}_{subnet-id}

# ========================================
# 使用例
# ========================================
# 以下は、マルチキャスト対応のTransit Gatewayを作成し、
# VPCアタッチメント、マルチキャストドメイン、およびドメイン関連付けを
# 設定する完全な例です。

# Transit Gateway (マルチキャストサポート有効)
# resource "aws_ec2_transit_gateway" "example" {
#   description       = "Example Transit Gateway with Multicast"
#   multicast_support = "enable"
#
#   tags = {
#     Name = "example-tgw"
#   }
# }

# VPC Attachment
# resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
#   subnet_ids         = [aws_subnet.example.id]
#   transit_gateway_id = aws_ec2_transit_gateway.example.id
#   vpc_id             = aws_vpc.example.id
#
#   tags = {
#     Name = "example-tgw-attachment"
#   }
# }

# Multicast Domain
# resource "aws_ec2_transit_gateway_multicast_domain" "example" {
#   transit_gateway_id = aws_ec2_transit_gateway.example.id
#
#   tags = {
#     Name = "example-multicast-domain"
#   }
# }

# Multicast Domain Association
# resource "aws_ec2_transit_gateway_multicast_domain_association" "example" {
#   subnet_id                           = aws_subnet.example.id
#   transit_gateway_attachment_id       = aws_ec2_transit_gateway_vpc_attachment.example.id
#   transit_gateway_multicast_domain_id = aws_ec2_transit_gateway_multicast_domain.example.id
# }

# ========================================
# 注意事項
# ========================================
# 1. Transit Gatewayは作成時にmulticast_supportを"enable"に設定する必要があります
# 2. Transit Gateway Attachmentはavailable状態である必要があります
# 3. サブネットはTransit Gateway VPC Attachmentに含まれている必要があります
# 4. 1つのサブネットは1つのマルチキャストドメインにのみ関連付けできます
# 5. マルチキャスト機能は追加料金が発生する場合があります
#
# 参考リンク:
# - Transit Gateway Multicast Overview: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-multicast-overview.html
# - Associating VPC attachments: https://docs.aws.amazon.com/vpc/latest/tgw/associate-attachment-to-domain.html
