# ==============================================================================
# Terraform Resource Template: aws_ec2_transit_gateway_policy_table_association
# ==============================================================================
#
# Generated: 2026-01-22
# Provider Version: hashicorp/aws 6.28.0
#
# このテンプレートは生成時点の情報に基づいています。
# 最新の仕様や詳細は公式ドキュメントを確認してください。
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_transit_gateway_policy_table_association
#
# ==============================================================================

# ------------------------------------------------------------------------------
# Resource: aws_ec2_transit_gateway_policy_table_association
# ------------------------------------------------------------------------------
# EC2 Transit Gateway Policy Table Associationを管理します。
# Transit Gateway Policy Tableを使用すると、Transit Gatewayアタッチメントに
# ポリシーベースのルーティングを適用できます。
#
# このリソースは、Transit Gateway Policy TableとTransit Gateway Attachmentの
# 関連付けを作成します。
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_policy_table_association" "example" {
  # ----------------------------------------------------------------------------
  # Required Arguments
  # ----------------------------------------------------------------------------

  # transit_gateway_attachment_id - (必須) EC2 Transit Gateway AttachmentのID
  # Transit Gateway Attachmentは、VPC、VPN、Direct Connect Gateway、
  # Transit Gateway Peering、またはConnect Attachmentなどを指定できます。
  # 型: string
  transit_gateway_attachment_id = "tgw-attach-0123456789abcdef0"

  # transit_gateway_policy_table_id - (必須) EC2 Transit Gateway Policy TableのID
  # 関連付けるポリシーテーブルを指定します。
  # ポリシーテーブルには、トラフィックのフィルタリングやルーティングのための
  # ポリシールールが含まれています。
  # 型: string
  transit_gateway_policy_table_id = "tgw-ptb-0123456789abcdef0"

  # ----------------------------------------------------------------------------
  # Optional Arguments
  # ----------------------------------------------------------------------------

  # id - (オプション) リソースのID
  # Terraform内部で使用される識別子です。
  # 通常は明示的に指定する必要はありません。Terraformが自動的に管理します。
  # 型: string
  # デフォルト: computed
  # id = "tgw-ptb-0123456789abcdef0:tgw-attach-0123456789abcdef0"

  # region - (オプション) リソースが管理されるAWSリージョン
  # このリソースを作成するリージョンを明示的に指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"
}

# ==============================================================================
# Computed Attributes (読み取り専用)
# ==============================================================================
# 以下の属性はTerraformによって自動的に計算され、読み取り専用です。
# これらは output 値として参照できます。
#
# - id (string)
#   EC2 Transit Gateway Policy TableのIDとEC2 Transit Gateway AttachmentのIDを
#   組み合わせた識別子（形式: "{policy_table_id}:{attachment_id}"）
#
# - resource_id (string)
#   リソースの識別子（Transit Gateway AttachmentのID）
#
# - resource_type (string)
#   リソースのタイプ（例: "vpc", "vpn", "direct-connect-gateway", "peering", "connect"）
#
# ==============================================================================

# ==============================================================================
# 使用例
# ==============================================================================
# output "association_id" {
#   description = "Transit Gateway Policy Table Associationの識別子"
#   value       = aws_ec2_transit_gateway_policy_table_association.example.id
# }
#
# output "resource_type" {
#   description = "関連付けられたリソースのタイプ"
#   value       = aws_ec2_transit_gateway_policy_table_association.example.resource_type
# }
# ==============================================================================
