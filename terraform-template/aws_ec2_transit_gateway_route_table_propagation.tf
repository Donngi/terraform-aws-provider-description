#---------------------------------------------------------------
# AWS EC2 Transit Gateway Route Table Propagation
#---------------------------------------------------------------
#
# Transit Gateway ルートテーブルへのルート伝播（プロパゲーション）を
# 管理するリソースです。
#
# ルート伝播を有効にすると、アタッチメント（VPC、VPN、Direct Connect Gateway等）の
# ルートが自動的にTransit Gatewayルートテーブルに伝播されます。
# これにより、手動でスタティックルートを設定することなく、
# アタッチされたネットワークへの到達性を確保できます。
#
# AWS公式ドキュメント:
#   - Transit Gateway ルートテーブル: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html
#   - ルート伝播の有効化: https://docs.aws.amazon.com/vpc/latest/tgw/enable-tgw-route-propagation.html
#   - API リファレンス: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_EnableTransitGatewayRouteTablePropagation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation
#
# Provider Version: 6.28.0
# Generated: 2026-01-23
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_transit_gateway_route_table_propagation" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # transit_gateway_attachment_id (Required)
  # 設定内容: ルート伝播を有効にするTransit Gatewayアタッチメントの識別子を指定します。
  # 設定可能な値: 有効なTransit Gatewayアタッチメント ID
  #   - VPCアタッチメント: tgw-attach-xxxxxxxxxxxxxxxxx
  #   - VPNアタッチメント: tgw-attach-xxxxxxxxxxxxxxxxx
  #   - Direct Connect Gatewayアタッチメント: tgw-attach-xxxxxxxxxxxxxxxxx
  #   - Peeringアタッチメント: tgw-attach-xxxxxxxxxxxxxxxxx
  #   - Connectアタッチメント: tgw-attach-xxxxxxxxxxxxxxxxx
  # 注意: アタッチメントの種類によって取得方法が異なります
  #   - VPCアタッチメント: aws_ec2_transit_gateway_vpc_attachment.example.id
  #   - Direct Connect: aws_dx_gateway_association.example.transit_gateway_attachment_id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.example.id

  # transit_gateway_route_table_id (Required)
  # 設定内容: ルートを伝播させる先のTransit Gatewayルートテーブルの識別子を指定します。
  # 設定可能な値: 有効なTransit Gatewayルートテーブル ID（例: tgw-rtb-xxxxxxxxxxxxxxxxx）
  # 注意: 1つのアタッチメントは複数のルートテーブルにルートを伝播できます。
  #       ただし、各ルートテーブルへの伝播は個別のリソースとして定義する必要があります。
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
# }
#
# resource "aws_subnet" "example" {
#   vpc_id     = aws_vpc.example.id
#   cidr_block = "10.0.1.0/24"
# }
#
# resource "aws_ec2_transit_gateway" "example" {
#   description = "example"
# }
#
# resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
#   subnet_ids         = [aws_subnet.example.id]
#   transit_gateway_id = aws_ec2_transit_gateway.example.id
#   vpc_id             = aws_vpc.example.id
# }
#
# resource "aws_ec2_transit_gateway_route_table" "example" {
#   transit_gateway_id = aws_ec2_transit_gateway.example.id
# }
#
# resource "aws_ec2_transit_gateway_route_table_propagation" "example" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.example.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
# }

#---------------------------------------------------------------
# resource "aws_dx_gateway" "example" {
#   name            = "example"
#   amazon_side_asn = 64512
# }
#
# resource "aws_ec2_transit_gateway" "example" {
#   description = "example"
# }
#
# resource "aws_dx_gateway_association" "example" {
#   dx_gateway_id         = aws_dx_gateway.example.id
#   associated_gateway_id = aws_ec2_transit_gateway.example.id
#
#   allowed_prefixes = [
#     "10.0.0.0/16",
#   ]
# }
#
# resource "aws_ec2_transit_gateway_route_table" "example" {
#   transit_gateway_id = aws_ec2_transit_gateway.example.id
# }
#
# # Direct Connect Gatewayの場合は、associationからattachment IDを取得
# resource "aws_ec2_transit_gateway_route_table_propagation" "example" {
#   transit_gateway_attachment_id  = aws_dx_gateway_association.example.transit_gateway_attachment_id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Transit GatewayルートテーブルIDとTransit Gatewayアタッチメント IDを
#       組み合わせた一意識別子
# - resource_id: ルート伝播元となるリソースの識別子
#       （例: VPCアタッチメントの場合はVPC ID）
# - resource_type: ルート伝播元となるリソースの種類
#       （例: "vpc", "vpn", "direct-connect-gateway", "peering", "connect"）
#---------------------------------------------------------------
