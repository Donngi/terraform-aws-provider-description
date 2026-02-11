################################################################################
# Route 53 Resolver DNS Firewall Configuration
################################################################################
# Purpose:
# - VPCに対するDNS Firewall設定を管理
# - DNS Firewallの障害時の動作（fail open/fail closed）を制御
# - VPC Resolverを通過するDNSクエリのフィルタリング動作を設定
#
# Use Cases:
# - VPCからの送信DNS通信にDNS Firewallによる保護を適用
# - DNS Firewall障害時のセキュリティとアベイラビリティのバランス調整
# - DNS Firewallルールグループとの関連付けと併用してDNSレベルの脅威対策を実装
#
# Related Resources:
# - aws_vpc: DNS Firewallを適用する対象VPC
# - aws_route53_resolver_firewall_rule_group: フィルタリングルールを定義
# - aws_route53_resolver_firewall_rule_group_association: VPCとルールグループの関連付け
#
# AWS Documentation:
# - DNS Firewall VPC Configuration: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-vpc-configuration.html
# - DNS Firewall Overview: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-overview.html
################################################################################

resource "aws_route53_resolver_firewall_config" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # resource_id - (Required) The ID of the VPC that the configuration is for
  # Type: string
  #
  # Description:
  # - DNS Firewall設定を適用する対象VPCのID
  # - このVPCを通過するDNSクエリがDNS Firewallによってフィルタリング対象となる
  # - VPC Resolverが有効なVPCである必要がある
  #
  # Example Values:
  # - "vpc-0123456789abcdef0"
  # - aws_vpc.main.id
  #
  # Notes:
  # - VPCごとに1つのDNS Firewall設定のみ作成可能
  # - VPCはDNSサポート（enable_dns_support=true）が有効である必要がある
  ################################################################################
  resource_id = aws_vpc.example.id

  ################################################################################
  # Optional Arguments
  ################################################################################

  # firewall_fail_open - (Optional) Determines how Route 53 Resolver handles queries during failures
  # Type: string
  # Default: "DISABLED" (fail closed mode)
  #
  # Description:
  # - DNS Firewallが応答できない場合のクエリ処理方法を決定
  # - DISABLED (fail closed): DNS Firewallが評価できないクエリをブロック（セキュリティ優先）
  # - ENABLED (fail open): DNS Firewallが評価できないクエリを許可（可用性優先）
  #
  # Valid Values:
  # - "ENABLED": Fail open mode - DNS Firewall障害時にクエリを許可
  # - "DISABLED": Fail closed mode - DNS Firewall障害時にクエリをブロック
  #
  # Example Values:
  # - "ENABLED"
  # - "DISABLED"
  #
  # Notes:
  # - デフォルトはDISABLED（fail closed）でセキュリティを優先
  # - 本番環境では可用性要件に応じて慎重に選択する
  # - DNS Firewallが正常動作している場合はこの設定は影響しない
  # - Fail openを有効にすると障害時にセキュリティ制御がバイパスされる
  ################################################################################
  firewall_fail_open = "ENABLED"

  # region - (Optional) Region where this resource will be managed
  # Type: string
  # Default: Provider configuration region
  #
  # Description:
  # - このリソースが管理されるAWSリージョン
  # - 通常はプロバイダー設定のリージョンが使用される
  # - 明示的に指定することで特定リージョンでの管理が可能
  #
  # Example Values:
  # - "us-east-1"
  # - "ap-northeast-1"
  # - "eu-west-1"
  #
  # Notes:
  # - DNS FirewallはRegionalサービスのため各リージョンで設定が必要
  # - 通常は明示的な指定は不要（provider regionが使用される）
  # - マルチリージョン構成では各リージョンごとに設定を作成
  ################################################################################
  # region = "us-east-1"

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################
  # These attributes are exported by the resource and can be referenced in other resources
  #
  # - id: The ID of the firewall configuration
  #   - VPC IDと同じ値が返される
  #   - 例: "vpc-0123456789abcdef0"
  #
  # - owner_id: The AWS account ID of the owner of the VPC that this firewall configuration applies to
  #   - この設定が適用されているVPCの所有者AWSアカウントID
  #   - 例: "123456789012"
  #
  # Usage Example:
  # - output "firewall_config_id" {
  #     value = aws_route53_resolver_firewall_config.example.id
  #   }
  # - output "vpc_owner" {
  #     value = aws_route53_resolver_firewall_config.example.owner_id
  #   }
  ################################################################################
}

################################################################################
# Additional Configuration Examples
################################################################################

# Example 1: Fail Closed Configuration (Maximum Security)
# DNS Firewall障害時にクエリをブロックする設定
resource "aws_route53_resolver_firewall_config" "secure" {
  resource_id        = aws_vpc.production.id
  firewall_fail_open = "DISABLED" # Fail closed - セキュリティ優先
}

# Example 2: Fail Open Configuration (High Availability)
# DNS Firewall障害時にクエリを許可する設定
resource "aws_route53_resolver_firewall_config" "available" {
  resource_id        = aws_vpc.development.id
  firewall_fail_open = "ENABLED" # Fail open - 可用性優先
}

# Example 3: Complete VPC DNS Firewall Setup
# VPC、DNS Firewall設定、ルールグループの完全な構成例
resource "aws_vpc" "protected" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true # DNS Firewallに必須
  enable_dns_hostnames = true

  tags = {
    Name = "protected-vpc"
  }
}

resource "aws_route53_resolver_firewall_config" "protected" {
  resource_id        = aws_vpc.protected.id
  firewall_fail_open = "DISABLED"
}

# DNS Firewallルールグループとの関連付け例
# resource "aws_route53_resolver_firewall_rule_group_association" "protected" {
#   name                   = "protected-vpc-firewall"
#   firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.example.id
#   vpc_id                 = aws_vpc.protected.id
#   priority               = 100
# }

################################################################################
# Best Practices
################################################################################
# 1. Fail Mode Selection:
#    - 本番環境: セキュリティ要件に基づいてfail modeを選択
#    - 開発環境: fail openで可用性を優先することも検討
#    - 金融・医療など高セキュリティ環境: fail closed推奨
#
# 2. VPC Configuration:
#    - enable_dns_support = true が必須
#    - enable_dns_hostnames も有効化推奨
#
# 3. Monitoring:
#    - CloudWatchでDNS Firewallメトリクスを監視
#    - EventBridgeでfailure eventを検知
#    - fail openを使用する場合は特に障害検知の仕組みが重要
#
# 4. Multi-Region Setup:
#    - DNS FirewallはRegionalサービス
#    - 各リージョンで個別に設定が必要
#    - リージョン間で一貫したポリシーを適用
#
# 5. Testing:
#    - fail modeの動作をテスト環境で事前検証
#    - DNS Firewallルールとfail modeの組み合わせを確認
#
################################################################################
# Important Notes
################################################################################
# - DNS Firewall設定はVPCごとに1つのみ作成可能
# - 既存VPCに追加する場合、既存のDNS通信への影響を考慮
# - ルールグループとの関連付けがない場合、この設定のみでは効果なし
# - fail openは障害時のみ動作し、通常時はルールに従って評価
# - VPC削除時は自動的にこの設定も削除される
################################################################################

################################################################################
# Troubleshooting
################################################################################
# Common Issues:
# 1. "VPC does not have DNS support enabled"
#    - Solution: VPCのenable_dns_supportをtrueに設定
#
# 2. "Firewall configuration already exists for this VPC"
#    - Solution: VPCごとに1つのみ作成可能。既存設定をimportまたは削除
#
# 3. DNS queries not being filtered
#    - Solution: ルールグループとの関連付けを確認
#    - aws_route53_resolver_firewall_rule_group_associationが必要
#
# 4. Unexpected query blocking during failures
#    - Solution: firewall_fail_openの設定を確認
#    - ENABLEDにすることで可用性を優先
################################################################################
