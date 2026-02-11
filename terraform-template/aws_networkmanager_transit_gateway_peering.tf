#---------------------------------------------------------------
# AWS Network Manager Transit Gateway Peering
#---------------------------------------------------------------
#
# AWS Cloud WAN Core NetworkとAWS Transit Gateway間のピアリング接続を管理します。
# Cloud WANのコアネットワークとTransit Gatewayを接続することで、
# グローバルネットワークとリージョナルなTransit Gateway間の通信を可能にします。
#
# AWS公式ドキュメント:
#   - AWS Cloud WAN: https://docs.aws.amazon.com/vpc/latest/cloudwan/what-is-cloudwan.html
#   - Transit Gateway: https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html
#   - Cloud WAN Core Network: https://docs.aws.amazon.com/vpc/latest/cloudwan/cloudwan-core-networks.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_transit_gateway_peering
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_transit_gateway_peering" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # core_network_id (Required)
  # 設定内容: ピアリング接続を確立するCloud WANコアネットワークのIDを指定します。
  # 設定可能な値: 有効なコアネットワークID
  # 関連機能: AWS Cloud WAN Core Network
  #   Cloud WANの中心となるグローバルネットワークのバックボーン。
  #   複数のリージョンにまたがるネットワークを統合管理します。
  #   - https://docs.aws.amazon.com/vpc/latest/cloudwan/cloudwan-core-networks.html
  core_network_id = "core-network-0123456789abcdef0"

  # transit_gateway_arn (Required)
  # 設定内容: ピアリング接続を確立するTransit GatewayのARNを指定します。
  # 設定可能な値: 有効なTransit Gateway ARN
  # 関連機能: AWS Transit Gateway
  #   VPC、VPN、AWS Direct Connectを接続するネットワークハブ。
  #   Cloud WANとのピアリングにより、既存のTransit Gatewayベースの
  #   ネットワークをCloud WANに統合できます。
  #   - https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html
  transit_gateway_arn = "arn:aws:ec2:ap-northeast-1:123456789012:transit-gateway/tgw-0123456789abcdef0"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: ピアリング接続に割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "core-network-to-tgw-peering"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # 依存関係の考慮事項
  #-------------------------------------------------------------
  # 注意: このリソースは、以下のリソースに依存する場合があります：
  #   - aws_ec2_transit_gateway_policy_table: Transit Gatewayポリシーテーブル
  #   - aws_networkmanager_core_network_policy_attachment: コアネットワークポリシーアタッチメント
  #
  # ピアリング接続を確立する前に、必要なポリシーとルートテーブルが
  # 適切に設定されていることを確認してください。
  #
  # depends_on = [
  #   aws_ec2_transit_gateway_policy_table.example,
  #   aws_networkmanager_core_network_policy_attachment.example,
  # ]
}

#---------------------------------------------------------------
# Timeouts設定
#---------------------------------------------------------------
# このリソースは以下のタイムアウト設定をサポートします:
#
# timeouts {
#   create = "30m"  # デフォルト: 30分
#   delete = "30m"  # デフォルト: 30分
# }
#
# ピアリング接続の確立には時間がかかる場合があるため、
# 必要に応じてタイムアウト値を調整してください。
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ピアリング接続のAmazon Resource Name (ARN)
#
# - core_network_arn: コアネットワークのARN
#
# - edge_location: ピアのエッジロケーション
#        コアネットワークがTransit Gatewayに接続されるAWSリージョンを示します。
#
# - id: ピアリング接続のID
#
# - owner_account_id: アカウントオーナーのID
#
# - peering_type: ピアリングのタイプ。この値は常に "TRANSIT_GATEWAY" です。
#
# - resource_arn: ピアのリソースARN
#        Transit GatewayのARNが設定されます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#
# - transit_gateway_peering_attachment_id: Transit GatewayピアリングアタッチメントのID
#---------------------------------------------------------------
