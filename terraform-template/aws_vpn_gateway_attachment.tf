#---------------------------------------------------------------
# AWS VPN Gateway Attachment
#---------------------------------------------------------------
#
# 既存のVirtual Private Gateway（仮想プライベートゲートウェイ）を
# VPCにアタッチ/デタッチするためのリソースです。
# ハードウェアVPN接続を使用してオンプレミスネットワークとVPCを
# 接続する際に使用します。
#
# AWS公式ドキュメント:
#   - Site-to-Site VPN 仮想プライベートゲートウェイ: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNGateway.html
#   - VPNトンネルのオプション: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNTunnels.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpn_gateway_attachment" "example" {
  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: Virtual Private Gatewayをアタッチする対象のVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-12345678, vpc-0123456789abcdef0）
  # 注意: VPCは1つのVirtual Private Gatewayにのみアタッチできます。
  #       1つのVirtual Private Gatewayも1つのVPCにのみアタッチできます。
  vpc_id = "vpc-0123456789abcdef0"

  #-------------------------------------------------------------
  # VPN Gateway設定
  #-------------------------------------------------------------

  # vpn_gateway_id (Required)
  # 設定内容: VPCにアタッチするVirtual Private GatewayのIDを指定します。
  # 設定可能な値: 有効なVirtual Private Gateway ID（例: vgw-12345678, vgw-0123456789abcdef0）
  # 関連機能: Virtual Private Gateway
  #   Virtual Private Gateway（VGW）は、Site-to-Site VPN接続のAWS側のエンドポイントです。
  #   オンプレミスネットワークとAWS VPCを接続するためのVPN接続を確立します。
  #   - https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNGateway.html
  # 注意: aws_vpn_gatewayリソースでvpc_id属性を指定することで、
  #       このリソースを使用せずに自動的にVPCにアタッチすることも可能です。
  vpn_gateway_id = "vgw-0123456789abcdef0"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1, eu-west-1）
  # 省略時: プロバイダー設定で指定されたリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPN Gateway Attachmentの識別子。
#       "vpn-gateway:vpc" の形式（例: "vgw-12345678:vpc-12345678"）
#
# - vpc_id: Virtual Private GatewayがアタッチされているVPCのID
#
# - vpn_gateway_id: アタッチされているVirtual Private GatewayのID
#---------------------------------------------------------------
