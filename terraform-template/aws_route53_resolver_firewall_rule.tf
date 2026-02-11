#---------------------------------------------------------------
# Route 53 Resolver DNS Firewall Rule
#---------------------------------------------------------------
#
# Route 53 ResolverのDNS Firewallルールを管理するリソースです。
# DNS Firewallルールは、VPC内のDNSクエリをフィルタリングし、
# ドメインリストまたはDNS脅威検出機能に基づいてアクセス制御を実行します。
#
# AWS公式ドキュメント:
#   - Route 53 Resolver DNS Firewall: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall.html
#   - DNS Firewallルールの設定: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/gr-configure-manage-firewall-rules.html
#   - DNS Firewall動作: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-overview.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_resolver_firewall_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定 (Required)
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: DNSファイアウォールルールの識別名を指定します。
  # 設定可能な値: 文字列
  # 用途: ルールの管理と識別を容易にするための名前です。
  #       複数のルールを管理する場合は、目的が明確にわかる名前を付けることを推奨します。
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/gr-configure-manage-firewall-rules.html
  name = "example-firewall-rule"

  # firewall_rule_group_id (Required)
  # 設定内容: このルールを追加するファイアウォールルールグループのIDを指定します。
  # 設定可能な値: aws_route53_resolver_firewall_rule_groupリソースのID
  # 用途: DNS Firewallルールはルールグループに所属し、VPCに関連付けられます。
  #       1つのルールグループに複数のルールを定義できます。
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall.html
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.example.id

  # priority (Required)
  # 設定内容: ルールグループ内でのルール処理順序を決定する優先度を指定します。
  # 設定可能な値: 数値（最小値から順に処理されます）
  # 用途: DNSクエリは優先度の低い順（数値が小さい順）に評価されます。
  # ベストプラクティス:
  #   - 100-999: 高優先度の許可ルール
  #   - 1000-4999: ブロックルール
  #   - 5000-9999: アラートルール
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/gr-configure-manage-firewall-rules.html
  priority = 100

  # action (Required)
  # 設定内容: DNSクエリがルールに一致した場合のアクションを指定します。
  # 設定可能な値:
  #   - "ALLOW": クエリを許可します（DNS Firewall Advancedルールでは無効）
  #   - "BLOCK": クエリをブロックし、block_responseに基づいた応答を返します
  #   - "ALERT": クエリを許可しますが、ログにアラートを記録します
  # 用途: ドメインリストまたは脅威検出に一致したクエリの処理方法を制御します。
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/gr-configure-manage-firewall-rules.html
  action = "BLOCK"

  #-------------------------------------------------------------
  # ルールタイプ設定 (Optional - 排他的)
  #-------------------------------------------------------------
  # 注意: firewall_domain_list_id、dns_threat_protection、confidence_thresholdは
  #       相互に排他的な設定です。標準ルールとDNS Firewall Advancedルールの
  #       どちらか一方を選択してください。

  # firewall_domain_list_id (Optional)
  # 設定内容: 標準ルールで使用するドメインリストのIDを指定します。
  # 設定可能な値: aws_route53_resolver_firewall_domain_listリソースのID
  # 用途: 特定のドメイン名のリストに基づいてDNSクエリをフィルタリングします。
  # 制約: dns_threat_protectionおよびconfidence_thresholdと併用不可
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall.html
  firewall_domain_list_id = aws_route53_resolver_firewall_domain_list.example.id

  # dns_threat_protection (Optional)
  # 設定内容: DNS Firewall Advancedルールで検出する脅威のタイプを指定します。
  # 設定可能な値:
  #   - "DGA": Domain Generation Algorithm（ドメイン生成アルゴリズム）ベースの脅威を検出
  #   - "DNS_TUNNELING": DNSトンネリング攻撃を検出
  # 用途: マルウェアやデータ流出（DNS Exfiltration）などの高度な脅威を検出します。
  # 制約: firewall_domain_list_idと併用不可。confidence_thresholdの指定が必要です。
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-overview.html
  # dns_threat_protection = "DGA"

  # confidence_threshold (Optional)
  # 設定内容: DNS Firewall Advancedルールの検出信頼度しきい値を指定します。
  # 設定可能な値:
  #   - "LOW": 低信頼度しきい値（偽陽性が多くなる可能性あり）
  #   - "MEDIUM": 中信頼度しきい値（バランス重視）
  #   - "HIGH": 高信頼度しきい値（偽陽性を最小化）
  # 用途: DNS Firewall Advancedルールでの脅威検出精度を調整します。
  # 制約: firewall_domain_list_idと併用不可。dns_threat_protectionの指定が必要です。
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-overview.html
  # confidence_threshold = "HIGH"

  #-------------------------------------------------------------
  # ブロック応答設定 (Optional)
  #-------------------------------------------------------------

  # block_response (Optional - actionがBLOCKの場合は必須)
  # 設定内容: アクションがBLOCKの場合、ブロックされたクエリに対する応答タイプを指定します。
  # 設定可能な値:
  #   - "NODATA": クエリは成功したがデータなしの応答を返します
  #   - "NXDOMAIN": ドメインが存在しないことを示す応答を返します
  #   - "OVERRIDE": カスタムDNSレコードで応答をオーバーライドします
  # 用途: ブロックされたドメインに対する振る舞いを制御します。
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/gr-configure-manage-firewall-rules.html
  block_response = "OVERRIDE"

  # block_override_domain (Optional - block_responseがOVERRIDEの場合は必須)
  # 設定内容: OVERRIDEレスポンスで返すカスタムDNSレコードのドメイン名を指定します。
  # 設定可能な値: 有効なドメイン名（FQDN形式）
  # 用途: ブロックされたクエリを特定のドメイン（例: ブロック通知ページ）にリダイレクトします。
  # 制約: block_responseがOVERRIDEの場合にのみ有効
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/gr-configure-manage-firewall-rules.html
  block_override_domain = "blocked.example.com"

  # block_override_dns_type (Optional - block_responseがOVERRIDEの場合は必須)
  # 設定内容: OVERRIDEレスポンスで返すDNSレコードのタイプを指定します。
  # 設定可能な値:
  #   - "CNAME": CNAMEレコード（現時点で唯一サポートされている値）
  # 用途: block_override_domainで指定したドメインのレコードタイプを定義します。
  # 制約: block_responseがOVERRIDEの場合にのみ有効
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/gr-configure-manage-firewall-rules.html
  block_override_dns_type = "CNAME"

  # block_override_ttl (Optional - block_responseがOVERRIDEの場合は必須)
  # 設定内容: OVERRIDEレスポンスで返すDNSレコードのTTL（Time To Live）を秒単位で指定します。
  # 設定可能な値: 0～604800（秒）
  # 用途: クライアントやDNSリゾルバがオーバーライドレコードをキャッシュする時間を制御します。
  # 推奨値: 短めのTTL（60～300秒程度）を設定することで、ポリシー変更時の反映を早めます。
  # 制約: block_responseがOVERRIDEの場合にのみ有効
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/gr-configure-manage-firewall-rules.html
  block_override_ttl = 60

  #-------------------------------------------------------------
  # 高度な設定 (Optional)
  #-------------------------------------------------------------

  # firewall_domain_redirection_action (Optional)
  # 設定内容: DNSリダイレクションチェーン（CNAME、DNAME、ALIAS）の評価方法を指定します。
  # 設定可能な値:
  #   - "INSPECT_REDIRECTION_DOMAIN": リダイレクト先ドメインもルールで評価します（デフォルト）
  #   - "TRUST_REDIRECTION_DOMAIN": リダイレクト先ドメインは信頼し、評価をスキップします
  # 用途: CNAME等のリダイレクションを含むDNSクエリのセキュリティ検査範囲を制御します。
  # デフォルト値: "INSPECT_REDIRECTION_DOMAIN"
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_rule
  firewall_domain_redirection_action = "INSPECT_REDIRECTION_DOMAIN"

  # q_type (Optional)
  # 設定内容: ルールが評価対象とするDNSクエリタイプを指定します。
  # 設定可能な値: DNSレコードタイプ（例: A、AAAA、CNAME、MX、TXT等）
  # 用途: 特定のクエリタイプのみにルールを適用したい場合に使用します。
  #       省略時は全てのクエリタイプが対象となります。
  # 参考: https://en.wikipedia.org/wiki/List_of_DNS_record_types
  # q_type = "A"

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: us-east-1、ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンを使用します。
  # 用途: マルチリージョン環境で特定のリージョンにリソースを配置する場合に使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ルールのID
# - firewall_threat_protection_id: DNS Firewall AdvancedルールのID
#       （DNS Firewall Advancedルールの場合のみ設定されます）
#---------------------------------------------------------------
