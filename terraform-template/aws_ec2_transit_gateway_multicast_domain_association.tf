#----------------------------------------------------------------------------------------------------
# aws_ec2_transit_gateway_multicast_domain_association
# Associates a subnet and transit gateway attachment with a transit gateway multicast domain.
#
# Provider Version: 6.28.0
# Generated: 2026-02-15
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_multicast_domain_association
#
# リソース: AWS::EC2::TransitGatewayMulticastDomainAssociation
# 用途: Transit Gatewayマルチキャストドメインに、VPCアタッチメントとサブネットを関連付け
#      複数のサブネット間でマルチキャストトラフィックをルーティング可能にする
#
# NOTE: アタッチメントはavailable状態である必要があります
#       サブネットはVPCアタッチメントに属するVPC内に存在する必要があります
#----------------------------------------------------------------------------------------------------

#-------
# 基本設定
#-------
resource "aws_ec2_transit_gateway_multicast_domain_association" "example" {
  # 設定内容: 関連付けるマルチキャストドメインのID
  # 補足: Transit Gatewayマルチキャストドメインの識別子
  transit_gateway_multicast_domain_id = "tgw-mcast-domain-0c4905cef79d6e597"

  # 設定内容: マルチキャストドメインに関連付けるVPCアタッチメントのID
  # 補足: アタッチメントはavailable状態である必要があります
  transit_gateway_attachment_id = "tgw-attach-028c1dd0f8f5cbe8e"

  # 設定内容: マルチキャストドメインに関連付けるサブネットのID
  # 補足: サブネットはVPCアタッチメントに属するVPC内に存在する必要があります
  subnet_id = "subnet-000de86e3b49c932a"

  #-------
  # リージョン設定
  #-------
  # 設定内容: このリソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-east-1"

  #-------
  # タイムアウト設定
  #-------
  # timeouts {
  #   # 設定内容: リソース作成時の最大待機時間
  #   # 省略時: デフォルトのタイムアウト値が使用される
  #   create = "10m"
  #
  #   # 設定内容: リソース削除時の最大待機時間
  #   # 省略時: デフォルトのタイムアウト値が使用される
  #   delete = "10m"
  # }
}

#----------------------------------------------------------------------------------------------------
# Attributes Reference
#----------------------------------------------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id
#   リソースの一意識別子
#
# - region
#   リソースが管理されているAWSリージョン
#
# - transit_gateway_multicast_domain_id
#   マルチキャストドメインID
#
# - transit_gateway_attachment_id
#   VPCアタッチメントID
#
# - subnet_id
#   関連付けられたサブネットID
