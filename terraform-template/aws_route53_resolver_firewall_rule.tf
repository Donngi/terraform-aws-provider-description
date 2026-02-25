#---------------------------------------------------------------
# Route 53 Resolver DNS Firewall Rule
#---------------------------------------------------------------
#
# Amazon Route 53 Resolver DNS Firewallのルールをプロビジョニングするリソースです。
# ルールは、DNSクエリをドメインリストまたはDNS Firewall Advanced設定と照合し、
# 一致した場合にALLOW（許可）・BLOCK（ブロック）・ALERT（アラート）のいずれかの
# アクションを適用します。
# ルールグループ（aws_route53_resolver_firewall_rule_group）に紐付けて使用し、
# そのグループをVPCに関連付けることで機能します。
#
# AWS公式ドキュメント:
#   - Resolver DNS Firewallルール: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-rules.html
#   - DNS Firewall Advancedルール: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-advanced-rules.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_resolver_firewall_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ルールを識別するための名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "example-firewall-rule"

  # firewall_rule_group_id (Required)
  # 設定内容: このルールを作成するファイアウォールルールグループのIDを指定します。
  # 設定可能な値: aws_route53_resolver_firewall_rule_groupリソースのIDを参照
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.example.id

  # priority (Required)
  # 設定内容: ルールグループ内でのルールの処理順序を決定する値を指定します。
  # 設定可能な値: 整数値（小さい値ほど優先度が高い）
  # 関連機能: DNS Firewallはルールグループ内のルールを優先度順（低い値から）に処理します。
  priority = 100

  # action (Required)
  # 設定内容: ルールのドメインリストまたは脅威に一致するDNSクエリに対するアクションを指定します。
  # 設定可能な値:
  #   - "ALLOW"  : クエリを通過させる（DNS Firewall Advancedルールでは使用不可）
  #   - "BLOCK"  : クエリをブロックする
  #   - "ALERT"  : クエリを通過させつつアラートを発する
  action = "BLOCK"

  #-------------------------------------------------------------
  # ブロック設定
  #-------------------------------------------------------------

  # block_response (Optional)
  # 設定内容: action が "BLOCK" の場合のブロック方法を指定します。
  # 設定可能な値:
  #   - "NODATA"   : クエリに対してデータなし応答を返す
  #   - "NXDOMAIN" : クエリに対してドメインが存在しない応答を返す
  #   - "OVERRIDE" : カスタムDNSレコードを返す（block_override_* の設定が必要）
  # 省略時: actionがBLOCKの場合は必須
  block_response = "OVERRIDE"

  # block_override_dns_type (Optional)
  # 設定内容: block_response が "OVERRIDE" の場合のDNSレコードタイプを指定します。
  # 設定可能な値: "CNAME"
  # 省略時: block_responseがOVERRIDEの場合は必須
  block_override_dns_type = "CNAME"

  # block_override_domain (Optional)
  # 設定内容: block_response が "OVERRIDE" の場合に返すカスタムDNSレコードを指定します。
  # 設定可能な値: 有効なドメイン名文字列
  # 省略時: block_responseがOVERRIDEの場合は必須
  block_override_domain = "override.example.com"

  # block_override_ttl (Optional)
  # 設定内容: block_response が "OVERRIDE" の場合のオーバーライドレコードのTTL（秒）を指定します。
  # 設定可能な値: 0〜604800の整数
  # 省略時: block_responseがOVERRIDEの場合は必須
  block_override_ttl = 300

  #-------------------------------------------------------------
  # ドメインリスト設定
  #-------------------------------------------------------------

  # firewall_domain_list_id (Optional)
  # 設定内容: ルールで使用するドメインリストのIDを指定します。標準ルールで必須です。
  # 設定可能な値: aws_route53_resolver_firewall_domain_listリソースのIDを参照
  # 省略時: dns_threat_protectionおよびconfidence_thresholdと競合（同時指定不可）
  firewall_domain_list_id = aws_route53_resolver_firewall_domain_list.example.id

  # firewall_domain_redirection_action (Optional)
  # 設定内容: CNAME・DNAME・ALIASなどのDNSリダイレクションチェーン内のリダイレクションを
  #           評価する方法を指定します。
  # 設定可能な値:
  #   - "INSPECT_REDIRECTION_DOMAIN" : リダイレクション先ドメインもルールで検査する
  #   - "TRUST_REDIRECTION_DOMAIN"   : リダイレクション先ドメインを信頼し検査しない
  # 省略時: "INSPECT_REDIRECTION_DOMAIN"
  firewall_domain_redirection_action = "INSPECT_REDIRECTION_DOMAIN"

  # q_type (Optional)
  # 設定内容: ルールが評価するDNSクエリタイプ（レコードタイプ）を指定します。
  # 設定可能な値: DNSレコードタイプを表す文字列（例: "A", "AAAA", "MX", "TXT" など）
  #   詳細: https://en.wikipedia.org/wiki/List_of_DNS_record_types
  # 省略時: 全てのクエリタイプに対してルールを適用
  q_type = null

  #-------------------------------------------------------------
  # DNS Firewall Advanced設定
  #-------------------------------------------------------------

  # dns_threat_protection (Optional)
  # 設定内容: DNS Firewall Advancedルールの脅威保護タイプを指定します。
  #           DNS Firewall Advancedルールを作成する場合は必須です。
  # 設定可能な値:
  #   - "DGA"           : Domain Generation Algorithm（ドメイン生成アルゴリズム）による
  #                       マルウェアのC2通信を検出
  #   - "DNS_TUNNELING" : DNSトンネリングによるデータ漏洩・C2通信を検出
  # 省略時: firewall_domain_list_idと競合（同時指定不可）
  dns_threat_protection = null

  # confidence_threshold (Optional)
  # 設定内容: DNS Firewall Advancedルールの信頼度しきい値を指定します。
  #           DNS Firewall Advancedルールを作成する場合は必須です。
  # 設定可能な値:
  #   - "LOW"    : 低い信頼度でも脅威として検出（検出率高・誤検知多）
  #   - "MEDIUM" : 中程度の信頼度で脅威として検出
  #   - "HIGH"   : 高い信頼度のみ脅威として検出（検出率低・誤検知少）
  # 省略時: firewall_domain_list_idと競合（同時指定不可）
  confidence_threshold = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ルールのID（firewall_rule_group_id と name の組み合わせ）
#
# - firewall_threat_protection_id: DNS Firewall Advancedルールに設定されたIDです。
#                                  DNS Firewall Advancedルールでのみ設定されます。
#---------------------------------------------------------------
