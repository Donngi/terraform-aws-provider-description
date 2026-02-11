#---------------------------------------------------------------
# AWS EC2 Client VPN Authorization Rule
#---------------------------------------------------------------
#
# Client VPN authorization rules を管理するリソース。
# Client VPN エンドポイントに接続するユーザーやグループに対して、
# 特定のネットワーク (CIDR) へのアクセスを許可するルールを定義します。
#
# AWS公式ドキュメント:
#   - AWS Client VPN: https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/what-is.html
#   - Authorization Rules: https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-working-rules.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_client_vpn_authorization_rule
#
# Provider Version: 6.28.0
# Generated: 2026-01-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_client_vpn_authorization_rule" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # client_vpn_endpoint_id - (必須) string
  # Client VPN エンドポイントの ID。
  # この認証ルールを適用する Client VPN エンドポイントを指定します。
  # 例: "cvpn-endpoint-0123456789abcdef0"
  client_vpn_endpoint_id = "cvpn-endpoint-example"

  # target_network_cidr - (必須) string
  # アクセスを許可するターゲットネットワークの CIDR ブロック。
  # ユーザーがアクセスできるネットワーク範囲を指定します。
  # 例: "10.0.0.0/16", "192.168.1.0/24"
  target_network_cidr = "10.0.0.0/16"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # access_group_id - (オプション) string
  # アクセスを許可する Active Directory グループまたは Identity Provider (IdP) グループの ID。
  # authorize_all_groups が false の場合に使用します。
  # 特定のグループにのみアクセスを許可する場合に指定します。
  # 例: "S-1-5-21-..."
  # デフォルト: null
  access_group_id = null

  # authorize_all_groups - (オプション) bool
  # すべてのユーザーにアクセスを許可するかどうか。
  # true: すべてのユーザーにアクセスを許可
  # false: access_group_id で指定されたグループのみアクセスを許可
  # デフォルト: false
  authorize_all_groups = false

  # description - (オプション) string
  # 認証ルールの説明。
  # このルールの目的や用途を記述します。
  # 例: "Allow access to production VPC"
  # デフォルト: null
  description = "Example authorization rule"

  # id - (オプション/Computed) string
  # Terraform によって自動的に割り当てられるリソース ID。
  # 通常は指定不要です。インポート時や特定の用途で使用します。
  # デフォルト: 自動生成
  # id = null

  # region - (オプション/Computed) string
  # リソースが作成されるリージョン。
  # 通常は provider の region 設定が使用されます。
  # 明示的に異なるリージョンを指定する場合に使用します。
  # デフォルト: provider の region 設定
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Timeouts Block (Optional)
  #---------------------------------------------------------------
  # リソースの作成・削除のタイムアウト時間を設定します。

  # timeouts {
  #   # create - 作成時のタイムアウト (デフォルト: 10m)
  #   create = "10m"
  #
  #   # delete - 削除時のタイムアウト (デフォルト: 10m)
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性を提供します (computed のみ):
#
# - id: Client VPN authorization rule の一意の識別子
#       形式: "${client_vpn_endpoint_id},${target_network_cidr}"
#
# - region: リソースが作成されたリージョン
#
# これらの属性は output ブロックや他のリソースから参照できます:
#
# output "authorization_rule_id" {
#   value = aws_ec2_client_vpn_authorization_rule.example.id
# }
#---------------------------------------------------------------
