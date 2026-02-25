#---------------------------------------
# AWS EC2 Transit Gateway Route Table Association
#---------------------------------------
# Transit Gatewayアタッチメントをルートテーブルに関連付けるリソース
#
# ユースケース:
# - VPCアタッチメントのルーティング制御
# - Direct Connect Gatewayアタッチメントの関連付け
# - VPNアタッチメントのルートテーブル割り当て
# - マルチアカウント環境でのアタッチメント管理
#
# 前提条件:
# - Transit Gatewayが作成済みであること
# - Transit Gateway Route Tableが作成済みであること
# - 関連付け対象のAttachment（VPC/VPN/DXなど）が作成済みであること
#
# 制約事項:
# - 1つのアタッチメントは同時に1つのルートテーブルにのみ関連付け可能
# - デフォルトルートテーブルとの関連付けは自動で行われる（明示的な管理が必要な場合のみこのリソースを使用）
# - 共有されたTransit Gatewayの場合、replace_existing_associationオプションの利用が必要になる場合がある
#
# 関連リソース:
# - aws_ec2_transit_gateway
# - aws_ec2_transit_gateway_route_table
# - aws_ec2_transit_gateway_vpc_attachment
# - aws_dx_gateway_association
# - aws_vpn_connection
#
# Provider Version: 6.28.0
# Generated: 2026-02-16
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association
#
# NOTE: このリソースは明示的なアソシエーション管理が必要な場合にのみ使用。
#       通常はaws_ec2_transit_gateway_vpc_attachmentのtransit_gateway_default_route_table_association引数で制御可能。
#
# 参考: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html

resource "aws_ec2_transit_gateway_route_table_association" "example" {
  #------- Transit Gateway設定
  # Transit Gatewayアタッチメントとルートテーブルの関連付け

  # 設定内容: 関連付けるTransit GatewayアタッチメントのID
  # 設定可能な値:
  #   - aws_ec2_transit_gateway_vpc_attachment.example.id（VPCアタッチメント）
  #   - aws_dx_gateway_association.example.transit_gateway_attachment_id（DX Gatewayアタッチメント）
  #   - aws_vpn_connection.example.transit_gateway_attachment_id（VPNアタッチメント）
  #   - aws_ec2_transit_gateway_peering_attachment.example.id（ピアリングアタッチメント）
  #   - aws_ec2_transit_gateway_connect.example.id（Connectアタッチメント）
  transit_gateway_attachment_id = "tgw-attach-1234567890abcdef0"

  # 設定内容: 関連付け先のTransit Gateway Route TableのID
  # 設定可能な値: 既存のTransit Gateway Route TableのID（tgw-rtb-xxxxxxxxxxxxxxxxx形式）
  transit_gateway_route_table_id = "tgw-rtb-1234567890abcdef0"

  #------- オプションパラメータ

  #------- リージョン設定
  # リソース管理リージョンの指定

  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョン名（us-east-1、ap-northeast-1など）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: 通常は指定不要（プロバイダーのリージョン設定を使用）
  region = "ap-northeast-1"

  #------- アソシエーション制御
  # 既存の関連付けを置き換える場合の設定

  # 設定内容: 既存のRoute Table関連付けを削除してから新しい関連付けを作成するかどうか
  # 設定可能な値: true（既存関連付けを削除）、false（既存関連付けを保持・エラー）
  # 省略時: false
  # 注意:
  #   - マルチアカウント環境で共有されたTransit Gatewayを使用する場合に有用
  #   - 自アカウント管理のVPCアタッチメントの場合は、aws_ec2_transit_gateway_vpc_attachmentリソースの
  #     transit_gateway_default_route_table_association引数を使用することを推奨
  replace_existing_association = false
}

#---------------------------------------
# Outputs
#---------------------------------------

# 設定内容: Transit Gateway Route Table Association ID
# 形式: {transit_gateway_route_table_id}_{transit_gateway_attachment_id}
output "transit_gateway_route_table_association_id" {
  description = "Transit Gateway Route Table AssociationのID"
  value       = aws_ec2_transit_gateway_route_table_association.example.id
}

# 設定内容: 関連付けられたリソースのID
# 値: VPC ID、VPN Connection ID、Direct Connect Gateway IDなど
output "resource_id" {
  description = "関連付けられたリソースのID"
  value       = aws_ec2_transit_gateway_route_table_association.example.resource_id
}

# 設定内容: 関連付けられたリソースのタイプ
# 設定可能な値: vpc、vpn、vpn-concentrator、direct-connect-gateway、connect、peering、tgw-peering
output "resource_type" {
  description = "関連付けられたリソースのタイプ"
  value       = aws_ec2_transit_gateway_route_table_association.example.resource_type
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースでは以下の属性が参照可能:
#
# - id: Transit Gateway Route Table Association ID（tgw-rtb-xxx_tgw-attach-xxx形式）
# - resource_id: 関連付けられたリソースの識別子（VPC ID、VPN IDなど）
# - resource_type: リソースタイプ（vpc/vpn/direct-connect-gateway/peering/connectなど）
#
# 属性参照方法:
# - aws_ec2_transit_gateway_route_table_association.example.id
# - aws_ec2_transit_gateway_route_table_association.example.resource_type
