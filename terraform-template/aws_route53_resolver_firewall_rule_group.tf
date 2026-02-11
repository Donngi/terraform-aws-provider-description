################################################################################
# AWS Route 53 Resolver DNS Firewall Rule Group
################################################################################

# Route 53 Resolver DNS Firewallは、VPCからのアウトバウンドDNSトラフィックを
# フィルタリングおよび制御するための機能です。ルールグループは、DNSクエリに
# 適用されるルールのコレクションで、複数のVPCに関連付けることができます。
#
# 主な用途:
# - DNSデータ流出の防止（悪意のあるドメインへのクエリをブロック）
# - 組織のDNSポリシーの一元管理と適用
# - プライベートホストゾーンやEC2インスタンス名の解決制御
# - AWS Organizations全体でのDNSセキュリティポリシーの統一
#
# 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall.html

resource "aws_route53_resolver_firewall_rule_group" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # name - ルールグループの名前
  # タイプ: string
  # 必須: Yes
  #
  # ルールグループを識別し、管理するための名前を指定します。
  # この名前は、VPCとの関連付けやルールの管理時に使用されます。
  #
  # 例: "corporate-dns-firewall", "production-dns-filter"
  name = "example-dns-firewall-rule-group"

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # region - リソースを管理するAWSリージョン
  # タイプ: string
  # オプション: Yes
  # デフォルト: プロバイダー設定のリージョン
  # 計算値: Yes（指定しない場合）
  #
  # このリソースが作成・管理されるリージョンを指定します。
  # 明示的に指定しない場合は、プロバイダー設定のリージョンが使用されます。
  # VPCと同じリージョンに作成する必要があります。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # 例:
  # region = "us-east-1"
  # region = "ap-northeast-1"

  # tags - リソースに割り当てるタグ
  # タイプ: map(string)
  # オプション: Yes
  #
  # ルールグループにタグを付けて、リソースの分類、コスト配分、アクセス制御を
  # 行うことができます。プロバイダーレベルで default_tags が設定されている場合、
  # ここで指定したタグは default_tags とマージされます。
  #
  # 例:
  # tags = {
  #   Environment = "production"
  #   Team        = "security"
  #   Purpose     = "dns-exfiltration-prevention"
  #   ManagedBy   = "terraform"
  # }
  tags = {
    Name        = "example-dns-firewall-rule-group"
    Environment = "development"
  }

  ################################################################################
  # 読み取り専用属性（計算値）
  ################################################################################

  # 以下の属性は、Terraformによって自動的に計算され、参照可能です:
  #
  # id - ルールグループのID
  # 例: "rslvr-frg-1234567890abcdef0"
  #
  # arn - ルールグループのARN（Amazon Resource Name）
  # 例: "arn:aws:route53resolver:us-east-1:123456789012:firewall-rule-group/rslvr-frg-1234567890abcdef0"
  # 用途: IAMポリシー、AWS RAM共有、クロスアカウントアクセスなどで使用
  #
  # owner_id - ルールグループを作成したAWSアカウントID
  # 例: "123456789012"
  # 用途: ルールグループが共有されている場合、元のアカウントを識別
  #
  # share_status - ルールグループの共有ステータス
  # 可能な値:
  #   - "NOT_SHARED": 共有されていない（自アカウント専用）
  #   - "SHARED_BY_ME": 自分が他のアカウントと共有している
  #   - "SHARED_WITH_ME": 他のアカウントから共有されている
  # 用途: AWS Resource Access Manager (RAM) による共有管理
  #
  # tags_all - すべてのタグ（プロバイダーのdefault_tagsを含む）
  # 例: { Name = "example", Environment = "dev", ManagedBy = "terraform" }
}

################################################################################
# 使用例と関連リソース
################################################################################

# 1. DNS Firewallルールの追加
#
# ルールグループを作成した後、aws_route53_resolver_firewall_rule リソースを
# 使用して、具体的なフィルタリングルールを追加します。
#
# resource "aws_route53_resolver_firewall_rule" "block_malicious" {
#   name                    = "block-malicious-domains"
#   firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.example.id
#   firewall_domain_list_id = aws_route53_resolver_firewall_domain_list.malicious.id
#   priority                = 100
#   action                  = "BLOCK"
#   block_response          = "NODATA"
# }

# 2. VPCへの関連付け
#
# ルールグループをVPCに関連付けて、DNSクエリのフィルタリングを有効化します。
#
# resource "aws_route53_resolver_firewall_rule_group_association" "example" {
#   name                   = "example-vpc-association"
#   firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.example.id
#   vpc_id                 = aws_vpc.example.id
#   priority               = 101
# }

# 3. AWS RAM経由での共有
#
# AWS Resource Access Managerを使用して、他のAWSアカウントとルールグループを
# 共有することができます。これにより、組織全体で一貫したDNSポリシーを適用できます。
#
# resource "aws_ram_resource_share" "dns_firewall" {
#   name                      = "dns-firewall-rule-group-share"
#   allow_external_principals = false
# }
#
# resource "aws_ram_resource_association" "dns_firewall" {
#   resource_arn       = aws_route53_resolver_firewall_rule_group.example.arn
#   resource_share_arn = aws_ram_resource_share.dns_firewall.arn
# }

# 4. AWS Firewall Managerとの統合
#
# AWS Organizationsを使用している場合、AWS Firewall Managerを通じて
# ルールグループを一元管理し、組織全体のアカウントに自動適用できます。
# これにより、セキュリティポリシーの一貫性と管理効率が向上します。

################################################################################
# 出力例
################################################################################

# output "firewall_rule_group_id" {
#   description = "DNS Firewall ルールグループのID"
#   value       = aws_route53_resolver_firewall_rule_group.example.id
# }
#
# output "firewall_rule_group_arn" {
#   description = "DNS Firewall ルールグループのARN"
#   value       = aws_route53_resolver_firewall_rule_group.example.arn
# }
#
# output "firewall_rule_group_share_status" {
#   description = "ルールグループの共有ステータス"
#   value       = aws_route53_resolver_firewall_rule_group.example.share_status
# }

################################################################################
# 注意事項とベストプラクティス
################################################################################

# 1. ルールグループの設計
#    - 目的別にルールグループを分割（例: マルウェア対策、データ流出防止、コンプライアンス）
#    - 1つのルールグループで最大100個のルールまで設定可能
#    - ルールグループは再利用可能なため、複数のVPCで共有することを検討
#
# 2. リージョン考慮事項
#    - ルールグループはリージョナルリソースです
#    - VPCと同じリージョンに作成する必要があります
#    - マルチリージョン構成の場合、各リージョンでルールグループを作成
#
# 3. 共有とアクセス管理
#    - AWS RAMを使用して組織内の他のアカウントと共有可能
#    - 共有されたルールグループは読み取り専用（共有元でのみ編集可能）
#    - IAMポリシーでルールグループへのアクセスを制御
#
# 4. コストの最適化
#    - ルールグループ自体に料金は発生しません
#    - VPCとの関連付けごとに月額料金が発生
#    - ルールグループ内のルール数に応じて追加料金が発生
#    - 参考: https://aws.amazon.com/route53/pricing/
#
# 5. 監視とロギング
#    - CloudWatch Logsでクエリログを有効化し、ブロックされたクエリを監視
#    - CloudWatch Metricsでルールグループのメトリクスを追跡
#    - AWS Configでルールグループの設定変更を記録
#
# 6. セキュリティのベストプラクティス
#    - AWS Managed Domain Listsを活用（マルウェア、ボットネットなど）
#    - 定期的にルールを見直し、新しい脅威に対応
#    - アラートアクションを使用して、疑わしいクエリをログに記録
#    - Network Firewallと組み合わせて多層防御を実現
#
# 7. テストと検証
#    - 本番環境に適用する前に、開発環境でルールをテスト
#    - ALERT アクションで影響を確認してから BLOCK に変更
#    - ログを監視して誤検知（false positive）を確認
#
# 8. 削除保護
#    - 削除する前に、すべてのVPC関連付けを解除する必要があります
#    - 共有されているルールグループは、共有を解除してから削除
#    - Terraformのライフサイクルルールで誤削除を防止することを検討
