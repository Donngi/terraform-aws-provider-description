#---------------------------------------------------------------
# AWS Direct Connect Gateway Association Proposal
#---------------------------------------------------------------
#
# Direct Connect Gatewayの関連付け提案を管理するリソースです。
# 主にクロスアカウント関連付けを有効にするために使用されます。
#
# このリソースは、異なるAWSアカウント間でDirect Connect Gatewayを
# Virtual Private Gateway (VGW) やTransit Gatewayと関連付ける際に使用します。
# 提案は、Direct Connect Gatewayの所有者によって承認される必要があります。
#
# 同一アカウント内での関連付けには、代わりに aws_dx_gateway_association
# リソースを使用してください。
#
# AWS公式ドキュメント:
#   - Direct Connect Gateway 概要: https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-gateways-intro.html
#   - クロスアカウント VGW 関連付け: https://docs.aws.amazon.com/directconnect/latest/UserGuide/multi-account-associate-vgw.html
#   - Transit Gateway 関連付け: https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-transit-gateways.html
#   - API リファレンス: https://docs.aws.amazon.com/directconnect/latest/APIReference/API_CreateDirectConnectGatewayAssociationProposal.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dx_gateway_association_proposal
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dx_gateway_association_proposal" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # dx_gateway_id (Required)
  # 設定内容: 関連付け先のDirect Connect GatewayのIDを指定します。
  # 設定可能な値: 有効なDirect Connect Gateway ID
  # 用途: クロスアカウント関連付けを行うDirect Connect Gatewayを特定
  # 関連機能: Direct Connect Gateway
  #   グローバルに利用可能なリソースで、異なるリージョンのVPCへの接続を可能にします。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-gateways-intro.html
  dx_gateway_id = aws_dx_gateway.example.id

  # dx_gateway_owner_account_id (Required)
  # 設定内容: Direct Connect Gatewayを所有するAWSアカウントIDを指定します。
  # 設定可能な値: 有効な12桁のAWSアカウントID
  # 用途: クロスアカウント関連付けにおいて、提案を承認するアカウントを特定
  # 注意: 提案はこのアカウントの所有者によって承認される必要があります
  # 関連機能: クロスアカウント関連付け
  #   異なるアカウント間でDirect Connect Gatewayを共有するための仕組みです。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/multi-account-associate-vgw.html
  dx_gateway_owner_account_id = aws_dx_gateway.example.owner_account_id

  # associated_gateway_id (Required)
  # 設定内容: Direct Connect Gatewayに関連付けるVGWまたはTransit GatewayのIDを指定します。
  # 設定可能な値: 有効なVirtual Private Gateway ID または Transit Gateway ID
  # 用途: オンプレミスネットワークからVPCまたはTransit Gatewayへのルーティングを確立
  # 関連機能: Gateway 関連付け
  #   VGWはVPCへの直接接続を提供し、Transit Gatewayは複数のVPCへの接続を提供します。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/direct-connect-transit-gateways.html
  associated_gateway_id = aws_vpn_gateway.example.id

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # allowed_prefixes (Optional, Computed)
  # 設定内容: Direct Connect Gatewayにアドバタイズ(広報)するVPCプレフィックス(CIDR)を指定します。
  # 設定可能な値: CIDR形式のプレフィックスのセット (例: ["10.0.0.0/16", "192.168.0.0/24"])
  # 省略時: 関連付けられたVirtual Gatewayに紐づくVPCのCIDRブロックがデフォルトで使用されます
  # 用途: オンプレミスネットワークにアドバタイズするプレフィックスをカスタマイズ
  # 注意:
  #   - 設定するプレフィックスはVPC CIDRと同じか、より広い範囲である必要があります
  #   - AWSはVPC全体のCIDRをVirtual Private Gatewayにプロビジョニングします
  #   - ドリフト検出を有効にするには、このフィールドを明示的に設定する必要があります
  # 関連機能: BGPルートアドバタイズ
  #   Direct Connect経由でオンプレミスネットワークにルーティング情報を伝播します。
  #   - https://docs.aws.amazon.com/directconnect/latest/UserGuide/multi-account-associate-vgw.html
  allowed_prefixes = ["10.0.0.0/16"]

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1, eu-west-1)
  # 省略時: プロバイダー設定で指定されたリージョンが使用されます
  # 用途: 特定のリージョンでリソースを管理する場合に指定
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: Direct Connect Gateway Association Proposal の識別子
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Direct Connect Gateway Association Proposal の識別子
#
# - associated_gateway_owner_account_id: VGWまたはTransit Gatewayを所有する
#   AWSアカウントのID
#
# - associated_gateway_type: 関連付けられたゲートウェイのタイプ
#   設定可能な値:
#   - "transitGateway": Transit Gatewayとの関連付け
#   - "virtualPrivateGateway": Virtual Private Gatewayとの関連付け
#---------------------------------------------------------------

#---------------------------------------------------------------
# 以下は典型的なクロスアカウント関連付けの設定例です:
#
# # アカウントA (VGW所有者) での設定
# resource "aws_vpn_gateway" "example" {
#   vpc_id = aws_vpc.example.id
#
#   tags = {
#     Name = "example-vgw"
#---------------------------------------------------------------
