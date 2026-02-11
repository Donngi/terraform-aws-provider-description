################################################################################
# aws_ec2_transit_gateway_prefix_list_reference
################################################################################
# Terraform Resource: aws_ec2_transit_gateway_prefix_list_reference
# Provider Version: 6.28.0
# Generated: 2026-01-22
#
# このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については、公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_prefix_list_reference
################################################################################

################################################################################
# AWS公式ドキュメント
################################################################################
# CreateTransitGatewayPrefixListReference API:
# https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateTransitGatewayPrefixListReference.html
#
# Transit Gateway Prefix List Reference (コンソール操作):
# https://docs.aws.amazon.com/vpc/latest/tgw/create-prefix-list-reference.html
#
# Prefix List Reference の変更:
# https://docs.aws.amazon.com/vpc/latest/tgw/modify-prefix-list-reference.html
################################################################################

resource "aws_ec2_transit_gateway_prefix_list_reference" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # prefix_list_id - (必須) EC2 Managed Prefix ListのID
  # 宛先マッチングに使用されるPrefix ListのID。
  # Prefix Listに含まれる各CIDRブロックがTransit Gatewayルートテーブルの
  # ルートとして表現されます。
  # 型: string
  # 例: "pl-12345678", "pl-0abcdef1234567890"
  prefix_list_id = "pl-12345678"

  # transit_gateway_route_table_id - (必須) Transit Gateway Route TableのID
  # Prefix List Referenceを作成するTransit Gatewayルートテーブルの識別子。
  # 型: string
  # 例: "tgw-rtb-12345678", "tgw-rtb-0abcdef1234567890"
  transit_gateway_route_table_id = "tgw-rtb-12345678"

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # blackhole - (オプション) ブラックホールルーティングの有効化
  # trueの場合、Prefix Listにマッチするトラフィックをドロップ（破棄）します。
  # falseまたは未指定の場合、トラフィックは指定されたアタッチメントにルーティングされます。
  # デフォルト: false
  # 型: bool
  # 注意: blackhole = true の場合、transit_gateway_attachment_id は不要です
  # blackhole = true

  # transit_gateway_attachment_id - (オプション) Transit Gateway AttachmentのID
  # トラフィックのルーティング先となるTransit Gateway Attachmentの識別子。
  # VPCアタッチメント、VPNアタッチメント、Direct Connect Gateway アタッチメントなどが指定可能。
  # blackhole = true の場合は指定不要（指定しても無視されます）。
  # 型: string
  # 例: "tgw-attach-12345678", "tgw-attach-0abcdef1234567890"
  # transit_gateway_attachment_id = "tgw-attach-12345678"

  # id - (オプション) リソースID
  # Terraformによる管理用のID。通常は指定不要。
  # 指定しない場合、自動的に生成されます。
  # フォーマット: {transit_gateway_route_table_id}_{prefix_list_id}
  # 型: string
  # Computed: true (自動生成される)
  # id = "tgw-rtb-12345678_pl-12345678"

  # region - (オプション) リソースを管理するAWSリージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # マルチリージョン構成の場合に明示的に指定することができます。
  # 型: string
  # Computed: true (プロバイダーのリージョン設定から自動取得)
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

################################################################################
# 出力例（Computed Attributes）
################################################################################
# 以下の属性は、リソース作成後に参照可能です（入力はできません）
#
# - id: Transit Gateway Route Table IDとPrefix List IDを
#       アンダースコア(_)で結合した識別子
#       例: "tgw-rtb-12345678_pl-12345678"
#
# - prefix_list_owner_id: Prefix Listの所有者のAWSアカウントID
#       例: "123456789012"
################################################################################

################################################################################
# 使用例1: アタッチメントルーティング
################################################################################
# resource "aws_ec2_transit_gateway_prefix_list_reference" "attachment_routing" {
#   prefix_list_id                 = aws_ec2_managed_prefix_list.example.id
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.example.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway.example.association_default_route_table_id
# }

################################################################################
# 使用例2: ブラックホールルーティング
################################################################################
# resource "aws_ec2_transit_gateway_prefix_list_reference" "blackhole_routing" {
#   blackhole                      = true
#   prefix_list_id                 = aws_ec2_managed_prefix_list.example.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway.example.association_default_route_table_id
# }

################################################################################
# 重要な注意事項
################################################################################
# 1. blackhole と transit_gateway_attachment_id は排他的な関係です
#    - blackhole = true の場合: transit_gateway_attachment_id は不要
#    - blackhole = false または未指定の場合: transit_gateway_attachment_id が必要
#
# 2. Prefix Listの各エントリ（CIDRブロック）は、個別のルートとして
#    Transit Gatewayルートテーブルに表現されます
#
# 3. Prefix List Referenceは、ルートテーブルの「Routes」タブでは
#    個別に変更できません。変更は「Managed Prefix Lists」画面または
#    このリソースを通して行う必要があります
#
# 4. リソース削除時、関連するすべてのルートが自動的に削除されます
################################################################################
