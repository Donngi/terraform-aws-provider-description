#---------------------------------------------------------------
# AWS Network Manager Attachment Accepter
#---------------------------------------------------------------
#
# AWS Network Managerでクロスアカウントアタッチメントを承認するためのリソース。
# あるアカウントで作成されたアタッチメント（VPC、Site-to-Site VPN、Connect、
# Transit Gateway Route Table、Direct Connect Gateway）を、コアネットワークを
# 所有する別のアカウントで承認する際に使用する。
#
# AWS公式ドキュメント:
#   - Accept or reject an AWS Cloud WAN core network attachment:
#     https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-attachments-acceptance.html
#   - AcceptAttachment API Reference:
#     https://docs.aws.amazon.com/networkmanager/latest/APIReference/API_AcceptAttachment.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_attachment_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_attachment_accepter" "example" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # attachment_id (必須)
  # ----------
  # 承認対象のアタッチメントID。
  # VPC、Site-to-Site VPN、Connect、Transit Gateway Route Table、
  # Direct Connect Gatewayアタッチメントの作成時に生成されるIDを指定する。
  #
  # 例: VPCアタッチメントの場合
  #   aws_networkmanager_vpc_attachment.example.id
  # 例: Site-to-Site VPNアタッチメントの場合
  #   aws_networkmanager_site_to_site_vpn_attachment.example.id
  # 例: Connectアタッチメントの場合
  #   aws_networkmanager_connect_attachment.example.id
  # 例: Transit Gateway Route Tableアタッチメントの場合
  #   aws_networkmanager_transit_gateway_route_table_attachment.example.id
  # 例: Direct Connect Gatewayアタッチメントの場合
  #   aws_networkmanager_dx_gateway_attachment.example.id
  attachment_id = "attachment-xxxxxxxxxxxxxxxxx"

  # attachment_type (必須)
  # ----------
  # アタッチメントの種類を指定する。
  #
  # 有効な値:
  #   - "VPC"                         : VPCアタッチメント
  #   - "SITE_TO_SITE_VPN"            : Site-to-Site VPNアタッチメント
  #   - "CONNECT"                     : Connectアタッチメント
  #   - "TRANSIT_GATEWAY_ROUTE_TABLE" : Transit Gateway Route Tableアタッチメント
  #   - "DIRECT_CONNECT_GATEWAY"      : Direct Connect Gatewayアタッチメント
  #
  # 通常、対応するアタッチメントリソースのattachment_type属性を参照する。
  # 例: aws_networkmanager_vpc_attachment.example.attachment_type
  attachment_type = "VPC"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # id (オプション)
  # ----------
  # リソースの識別子。
  # Terraformが自動的に設定するため、通常は明示的に指定する必要はない。
  # インポート時などの特殊なケースで使用される。
  # id = "attachment-xxxxxxxxxxxxxxxxx"

  #---------------------------------------------------------------
  # timeouts ブロック (オプション)
  #---------------------------------------------------------------
  # アタッチメント承認操作のタイムアウト設定。
  # デフォルトのタイムアウトを変更する場合に使用する。

  timeouts {
    # create (オプション)
    # ----------
    # アタッチメント承認操作のタイムアウト時間。
    # アタッチメントが承認されて"Available"状態になるまでの最大待機時間。
    #
    # 形式: "10m"（10分）、"1h"（1時間）など
    # デフォルト: プロバイダーのデフォルト値に依存
    #
    # 大規模なネットワーク環境や、承認処理に時間がかかる場合は
    # より長いタイムアウトを設定することを推奨。
    create = "15m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは上記の引数に加えて、以下の属性がエクスポートされます:
#
# attachment_policy_rule_number
#   - アタッチメントに関連付けられたポリシールール番号。
#   - コアネットワークポリシーで定義されたルール番号を返す。
#
# core_network_arn
#   - コアネットワークのARN。
#   - 形式: arn:aws:networkmanager::ACCOUNT_ID:core-network/core-network-id
#
# core_network_id
#   - コアネットワークのID。
#   - 形式: core-network-xxxxxxxxx
#
# edge_location
#   - エッジが配置されているリージョン。
#   - Direct Connect Gateway以外のすべてのアタッチメントタイプで返される。
#   - 例: "us-east-1", "ap-northeast-1"
#
# edge_locations
#   - Direct Connect Gatewayが関連付けられているエッジロケーションのリスト。
#   - Direct Connect Gatewayアタッチメントでのみ返される。
#   - 他のアタッチメントタイプではedge_locationが返される。
#
# owner_account_id
#   - アタッチメント所有者のAWSアカウントID。
#   - クロスアカウントアタッチメントの場合、作成元のアカウントID。
#
# resource_arn
#   - アタッチメントに関連付けられたリソースのARN。
#   - VPCアタッチメントの場合はVPCのARN、VPNの場合はVPN接続のARN等。
#
# segment_name
#   - アタッチメントが関連付けられているセグメントの名前。
#   - コアネットワークポリシーで定義されたセグメント名。
#
# state
#   - アタッチメントの状態。
#   - 可能な値: "CREATING", "PENDING_ATTACHMENT_ACCEPTANCE", "PENDING_TAG_ACCEPTANCE",
#               "PENDING_NETWORK_UPDATE", "AVAILABLE", "DELETING", "FAILED", "REJECTED"
#   - 承認後、通常は"AVAILABLE"に遷移する。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: VPCアタッチメントの承認
# resource "aws_networkmanager_attachment_accepter" "vpc_example" {
#   attachment_id   = aws_networkmanager_vpc_attachment.example.id
#   attachment_type = aws_networkmanager_vpc_attachment.example.attachment_type
# }

# 例2: Site-to-Site VPNアタッチメントの承認
# resource "aws_networkmanager_attachment_accepter" "vpn_example" {
#   attachment_id   = aws_networkmanager_site_to_site_vpn_attachment.example.id
#   attachment_type = aws_networkmanager_site_to_site_vpn_attachment.example.attachment_type
# }

# 例3: Connectアタッチメントの承認
# resource "aws_networkmanager_attachment_accepter" "connect_example" {
#   attachment_id   = aws_networkmanager_connect_attachment.example.id
#   attachment_type = aws_networkmanager_connect_attachment.example.attachment_type
# }

# 例4: Transit Gateway Route Tableアタッチメントの承認
# resource "aws_networkmanager_attachment_accepter" "tgw_rt_example" {
#   attachment_id   = aws_networkmanager_transit_gateway_route_table_attachment.example.id
#   attachment_type = aws_networkmanager_transit_gateway_route_table_attachment.example.attachment_type
# }

# 例5: Direct Connect Gatewayアタッチメントの承認
# resource "aws_networkmanager_attachment_accepter" "dxgw_example" {
#   attachment_id   = aws_networkmanager_dx_gateway_attachment.example.id
#   attachment_type = aws_networkmanager_dx_gateway_attachment.example.attachment_type
# }

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
# 1. このリソースはクロスアカウントアタッチメントの承認に使用する。
#    同一アカウント内でアタッチメントを作成する場合は通常不要。
#
# 2. アタッチメントを承認するには、コアネットワークポリシーで
#    "require-attachment-acceptance": true が設定されている必要がある。
#
# 3. 承認後、アタッチメントは"Available"状態に遷移し、
#    ネットワーク接続が有効になる。
#
# 4. 承認を拒否する場合は、このリソースではなく、
#    AWS CLIまたはコンソールで"reject"アクションを実行する。
#
# 5. アタッチメントの状態遷移:
#    PENDING_ATTACHMENT_ACCEPTANCE -> (承認) -> AVAILABLE
#    PENDING_ATTACHMENT_ACCEPTANCE -> (拒否) -> REJECTED
#---------------------------------------------------------------
