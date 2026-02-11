#---------------------------------------------------------------
# EC2 Transit Gateway Multicast Group Member
#---------------------------------------------------------------
#
# Transit Gateway マルチキャストドメインにグループメンバー (ネットワークインターフェース) を
# 登録するリソースです。メンバーは、マルチキャストトラフィックを受信するサポート対象の
# EC2インスタンスに関連付けられたネットワークインターフェースです。
#
# マルチキャストグループメンバーは、Transit Gatewayのマルチキャストドメインにおいて
# マルチキャストトラフィックを受信するレシーバーとして機能します。これにより、
# VPC間でのマルチキャストトラフィックの配信が可能になります。
#
# AWS公式ドキュメント:
#   - Transit Gateway マルチキャスト: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-multicast-overview.html
#   - グループメンバーの登録: https://docs.aws.amazon.com/vpc/latest/tgw/add-members-multicast-group.html
#   - RegisterTransitGatewayMulticastGroupMembers API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_RegisterTransitGatewayMulticastGroupMembers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_multicast_group_member
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_transit_gateway_multicast_group_member" "example" {
  #-------------------------------------------------------------
  # グループメンバー設定
  #-------------------------------------------------------------

  # group_ip_address (Required)
  # 設定内容: Transit Gatewayマルチキャストグループに割り当てられたIPアドレスを指定します。
  # 設定可能な値: IPv4マルチキャストアドレス (224.0.0.0 ~ 239.255.255.255)
  # 用途: マルチキャストグループを識別するためのIPアドレス
  # 関連機能: マルチキャストグループアドレッシング
  #   標準的なマルチキャストアドレス範囲を使用。各グループは一意のIPアドレスで識別されます。
  #   - https://docs.aws.amazon.com/vpc/latest/tgw/tgw-multicast-overview.html
  group_ip_address = "224.0.0.1"

  # network_interface_id (Required)
  # 設定内容: Transit Gatewayマルチキャストグループに登録するグループメンバーの
  #           ネットワークインターフェースIDを指定します。
  # 設定可能な値: 有効なEC2ネットワークインターフェースID (eni-xxxxxxxxxxxxxxxxx)
  # 用途: マルチキャストトラフィックを受信するネットワークインターフェースを指定
  # 制約: ネットワークインターフェースは、マルチキャストドメインに関連付けられた
  #       Transit Gateway アタッチメントのサブネット内に存在する必要があります
  # 関連機能: マルチキャストグループメンバー
  #   メンバーはマルチキャストトラフィックのレシーバーとして機能します。
  #   - https://docs.aws.amazon.com/vpc/latest/tgw/add-members-multicast-group.html
  network_interface_id = "eni-1234567890abcdef0"

  # transit_gateway_multicast_domain_id (Required)
  # 設定内容: Transit Gateway マルチキャストドメインのIDを指定します。
  # 設定可能な値: 有効なTransit Gateway マルチキャストドメインID (tgw-mcast-domain-xxxxxxxxxxxxxxxxx)
  # 用途: グループメンバーを登録するマルチキャストドメインを指定
  # 関連機能: Transit Gateway マルチキャストドメイン
  #   マルチキャストドメインは、マルチキャストルーティングとフォワーディングを管理します。
  #   - https://docs.aws.amazon.com/vpc/latest/tgw/manage-domain.html
  transit_gateway_multicast_domain_id = "tgw-mcast-domain-0a1b2c3d4e5f6g7h8"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: リソースの識別子
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: EC2 Transit Gateway マルチキャストグループメンバーの識別子
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 静的グループメンバー構成の例:
#
# resource "aws_ec2_transit_gateway" "example" {
#   description                     = "Example Transit Gateway"
#   multicast_support               = "enable"
#   default_route_table_association = "disable"
#   default_route_table_propagation = "disable"
# }
#
# resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
#   subnet_ids         = [aws_subnet.example.id]
#   transit_gateway_id = aws_ec2_transit_gateway.example.id
#   vpc_id             = aws_vpc.example.id
# }
#
#---------------------------------------------------------------
