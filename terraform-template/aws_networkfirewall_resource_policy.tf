#---------------------------------------------------------------
# AWS Network Firewall Resource Policy
#---------------------------------------------------------------
#
# Network Firewallのルールグループまたはファイアウォールポリシーに
# リソースベースのポリシーをアタッチするリソースです。
# RAM（Resource Access Manager）を使用せずに、他のAWSアカウントと
# ルールグループやファイアウォールポリシーを共有する際に使用します。
#
# AWS公式ドキュメント:
#   - Network Firewall リソースポリシー:
#     https://docs.aws.amazon.com/network-firewall/latest/developerguide/resource-policy.html
#   - PutResourcePolicy API:
#     https://docs.aws.amazon.com/network-firewall/latest/APIReference/API_PutResourcePolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/networkfirewall_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_resource_policy" "example" {
  #---------------------------------------------------------------
  # リソース識別設定
  #---------------------------------------------------------------

  # resource_arn (Required, Forces new resource)
  # 設定内容: ポリシーを適用するルールグループまたはファイアウォールポリシーのARNを指定します。
  # 設定可能な値: Network FirewallのルールグループまたはファイアウォールポリシーのARN文字列
  # 注意: 値を変更するとリソースが再作成されます（Forces new resource）
  resource_arn = aws_networkfirewall_firewall_policy.example.arn

  #---------------------------------------------------------------
  # ポリシードキュメント設定
  #---------------------------------------------------------------

  # policy (Required)
  # 設定内容: Network Firewallリソースへのアクセスを制御するIAMポリシードキュメントを
  #   JSON文字列形式で指定します。空白を含まない形式で指定する必要があります。
  # 設定可能な値: 有効なIAMポリシードキュメントのJSON文字列（空白なし）
  # 注意: jsonencode() 関数の使用を強く推奨します。
  #   ファイアウォールポリシーに適用する場合、Actionには以下のすべてが必要です:
  #     network-firewall:ListFirewallPolicies
  #     network-firewall:CreateFirewall
  #     network-firewall:UpdateFirewall
  #     network-firewall:AssociateFirewallPolicy
  #   ルールグループに適用する場合、Actionには以下のすべてが必要です:
  #     network-firewall:ListRuleGroups
  #     network-firewall:CreateFirewallPolicy
  #     network-firewall:UpdateFirewallPolicy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "network-firewall:ListFirewallPolicies",
          "network-firewall:CreateFirewall",
          "network-firewall:UpdateFirewall",
          "network-firewall:AssociateFirewallPolicy",
        ]
        Effect   = "Allow"
        Resource = aws_networkfirewall_firewall_policy.example.arn
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
      },
    ]
  })

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョンを使用します。
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースポリシーに関連付けられたルールグループまたは
#       ファイアウォールポリシーのARN（resource_arn と同じ値）
#---------------------------------------------------------------
