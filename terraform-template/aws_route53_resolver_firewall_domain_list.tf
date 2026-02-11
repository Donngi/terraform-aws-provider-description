#---------------------------------------------------------------
# Route 53 Resolver DNS Firewall Domain List
#---------------------------------------------------------------
#
# Amazon Route 53 Resolver DNS Firewallのドメインリストをプロビジョニングするリソースです。
# ドメインリストは、DNS Firewallルール内で使用される、再利用可能なドメイン仕様のセットです。
# ルールグループがVPCに関連付けられると、DNS Firewallはクエリをルール内のドメインリストと
# 比較し、一致した場合に対応するルールのアクション（許可、ブロック、アラート）を適用します。
#
# AWS公式ドキュメント:
#   - Resolver DNS Firewallドメインリスト: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-domain-lists.html
#   - カスタムドメインリストの管理: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-user-managed-domain-lists.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_domain_list
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_resolver_firewall_domain_list" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ドメインリストを識別するための名前を指定します。
  # 設定可能な値: 1-64文字の文字列
  # 用途: ドメインリストの管理と使用時の識別に使用
  # 関連機能: Route 53 Resolver DNS Firewall Domain List
  #   ドメインリストはDNS Firewallルール内で参照され、VPCに対するDNSクエリの
  #   フィルタリングに使用されます。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-domain-lists.html
  name = "example-domain-list"

  #-------------------------------------------------------------
  # ドメイン設定
  #-------------------------------------------------------------

  # domains (Optional)
  # 設定内容: ファイアウォールドメインリストに含めるドメインの配列を指定します。
  # 設定可能な値: ドメイン仕様の文字列のセット
  #   - 完全修飾ドメイン名（FQDN）: "example.com"
  #   - ワイルドカードドメイン: "*.example.com"（オプションのアスタリスクで開始）
  # ドメイン仕様の要件:
  #   - オプションのアスタリスク（*）で開始可能
  #   - 英数字、ハイフン（-）、ピリオド（.）のみ含む
  #   - 最大255文字
  # 省略時: 空のドメインリストが作成されます（後で更新可能）
  # 関連機能: DNS Firewallドメイン仕様
  #   各ドメイン仕様は特定の要件を満たす必要があり、リストは本番環境で使用する前に
  #   非本番環境でテストすることが推奨されます。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-user-managed-domain-lists.html
  # 注意: ドメインリストはS3バケットからバルクアップロードすることも可能です（コンソール経由）
  domains = [
    "example.com",
    "*.malicious-domain.com",
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-domain-lists.html
  tags = {
    Name        = "example-domain-list"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ドメインリストのAmazon Resource Name (ARN)
#
# - id: ドメインリストのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
