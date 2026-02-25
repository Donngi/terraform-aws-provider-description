#---------------------------------------------------------------
# Route 53 Resolver DNS Firewall Config
#---------------------------------------------------------------
#
# Amazon Route 53 Resolver DNS Firewallの設定をVPC単位で管理するリソースです。
# DNS Firewallがクエリ評価に失敗した場合の動作（フェイルオープン/フェイルクローズ）を
# VPCごとに制御します。デフォルトはフェイルクローズ（セキュリティ優先）で、
# DNS Firewallが評価できないクエリをブロックします。フェイルオープンを有効にすると
# 可用性優先となり、評価できないクエリを通過させます。
#
# AWS公式ドキュメント:
#   - Route 53 Resolver DNS Firewall設定: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-overview.html
#   - フェイルオープン動作: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-behavior.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_config
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_resolver_firewall_config" "example" {
  #-------------------------------------------------------------
  # 対象VPC設定
  #-------------------------------------------------------------

  # resource_id (Required)
  # 設定内容: DNS Firewall設定を適用するVPCのIDを指定します。
  # 設定可能な値: 既存VPCのID（例: "vpc-0123456789abcdef0"）
  # 用途: どのVPCのDNS Firewall動作を設定するかを識別するために使用します。
  # 関連機能: Route 53 Resolver DNS Firewall
  #   DNS FirewallはVPC単位で有効化され、そのVPC内のDNSクエリをフィルタリングします。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-overview.html
  resource_id = aws_vpc.example.id

  #-------------------------------------------------------------
  # フェイルオープン設定
  #-------------------------------------------------------------

  # firewall_fail_open (Optional)
  # 設定内容: DNS Firewallが障害時（全トラフィックへの応答がない場合等）に
  #           クエリをどのように処理するかを決定します。
  # 設定可能な値:
  #   - "ENABLED"  : フェイルオープン（可用性優先）。Firewallが評価できない場合にクエリを通過させる。
  #   - "DISABLED" : フェイルクローズ（セキュリティ優先）。Firewallが評価できない場合にクエリをブロックする。
  # 省略時: "DISABLED"（フェイルクローズ）
  # 補足: 本番環境ではセキュリティ要件に応じて適切な値を選択してください。
  #   セキュリティ重視の環境では "DISABLED"（デフォルト）を推奨します。
  #   可用性が最優先の環境では "ENABLED" を検討してください。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-behavior.html
  firewall_fail_open = "DISABLED"

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
# - id: ファイアウォール設定のID
#
# - owner_id: このファイアウォール設定が適用されるVPCを所有するAWSアカウントID
#---------------------------------------------------------------
