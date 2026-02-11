#---------------------------------------------------------------
# AWS Network Firewall Resource Policy
#---------------------------------------------------------------
#
# AWS Network Firewall のファイアウォールポリシーまたはルールグループに対して
# リソースポリシーを設定するリソース。これにより、AWS Resource Access Manager (RAM)
# を使用して他の AWS アカウントとリソースを共有できる。
#
# 主なユースケース:
#   - ファイアウォールポリシーを他のアカウントと共有
#   - ルールグループを他のアカウントと共有
#   - 組織内での Network Firewall リソースの一元管理
#
# AWS公式ドキュメント:
#   - Sharing AWS Network Firewall resources:
#     https://docs.aws.amazon.com/network-firewall/latest/developerguide/sharing.html
#   - PutResourcePolicy API Reference:
#     https://docs.aws.amazon.com/network-firewall/latest/APIReference/API_PutResourcePolicy.html
#   - Resource-based policy examples:
#     https://docs.aws.amazon.com/network-firewall/latest/developerguide/security_iam_resource-based-policy-examples.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_resource_policy" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # resource_arn (Required, Forces new resource)
  # リソースポリシーを適用するルールグループまたはファイアウォールポリシーの ARN。
  # 以下のいずれかを指定:
  #   - aws_networkfirewall_firewall_policy の ARN
  #   - aws_networkfirewall_rule_group の ARN
  # この値を変更すると、リソースが再作成される。
  resource_arn = aws_networkfirewall_firewall_policy.example.arn

  # policy (Required)
  # Network Firewall リソースへのアクセスを制御する JSON 形式のポリシードキュメント。
  # 重要: ポリシーは空白なしで提供する必要がある（jsonencode の使用を推奨）。
  #
  # ファイアウォールポリシーを共有する場合、以下の Action が必要:
  #   - network-firewall:ListFirewallPolicies
  #   - network-firewall:CreateFirewall
  #   - network-firewall:UpdateFirewall
  #   - network-firewall:AssociateFirewallPolicy
  #
  # ルールグループを共有する場合、以下の Action が必要:
  #   - network-firewall:ListRuleGroups
  #   - network-firewall:CreateFirewallPolicy
  #   - network-firewall:UpdateFirewallPolicy
  #
  # Principal には共有先の AWS アカウント、組織単位、または組織全体を指定可能。
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::123456789012:root"
      }
      Action = [
        "network-firewall:ListFirewallPolicies",
        "network-firewall:CreateFirewall",
        "network-firewall:UpdateFirewall",
        "network-firewall:AssociateFirewallPolicy"
      ]
      Resource = aws_networkfirewall_firewall_policy.example.arn
    }]
  })

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional)
  # このリソースを管理するAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用される。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"
}

#---------------------------------------------------------------
# ルールグループに対するリソースポリシーの例
#---------------------------------------------------------------
# resource "aws_networkfirewall_resource_policy" "rule_group_example" {
#   resource_arn = aws_networkfirewall_rule_group.example.arn
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         AWS = "arn:aws:iam::123456789012:root"
#       }
#       Action = [
#         "network-firewall:ListRuleGroups",
#         "network-firewall:CreateFirewallPolicy",
#         "network-firewall:UpdateFirewallPolicy"
#       ]
#       Resource = aws_networkfirewall_rule_group.example.arn
#     }]
#   })
# }

#---------------------------------------------------------------
# 組織全体への共有の例
#---------------------------------------------------------------
# resource "aws_networkfirewall_resource_policy" "org_example" {
#   resource_arn = aws_networkfirewall_firewall_policy.example.arn
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = "*"
#       Action = [
#         "network-firewall:ListFirewallPolicies",
#         "network-firewall:CreateFirewall",
#         "network-firewall:UpdateFirewall",
#         "network-firewall:AssociateFirewallPolicy"
#       ]
#       Resource = aws_networkfirewall_firewall_policy.example.arn
#       Condition = {
#         StringEquals = {
#           "aws:PrincipalOrgID" = "o-xxxxxxxxxx"
#         }
#       }
#     }]
#   })
# }

#---------------------------------------------------------------
# Attributes Reference (自動生成される属性)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に自動的に設定される。
#
# id
#   リソースポリシーに関連付けられたルールグループまたはファイアウォールポリシーの ARN。
#   resource_arn と同じ値になる。

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のリソースポリシーをインポートするには、ルールグループまたは
# ファイアウォールポリシーの ARN を使用する:
#
# terraform import aws_networkfirewall_resource_policy.example \
#   arn:aws:network-firewall:us-east-1:123456789012:firewall-policy/example

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
# 1. TLS インスペクションが設定されたファイアウォールポリシーは共有できない
#
# 2. リソースグループを参照するルールグループを共有することは可能だが、
#    リソースグループ自体は共有できない
#
# 3. 共有されたリソースを受け入れるには、共有先アカウントで AWS RAM の
#    リソース共有への参加を承諾する必要がある
#
# 4. 組織内で共有が有効化されている場合、組織メンバーは自動的に
#    共有リソースにアクセスできる
