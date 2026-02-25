#---------------------------------------------------------------
# Route 53 Resolver DNS Firewall Rule Group
#---------------------------------------------------------------
#
# Amazon Route 53 Resolver DNS Firewallのルールグループをプロビジョニングするリソースです。
# ルールグループは、DNSクエリをフィルタリングするための一連のルールをまとめたコンテナです。
# ルールグループをVPCに関連付けることで、そのVPC内のDNSクエリに対して
# 許可・ブロック・アラートのアクションを適用できます。
#
# AWS公式ドキュメント:
#   - Resolver DNS Firewallルールグループ: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-rule-groups.html
#   - DNS Firewallのルール管理: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-rules.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_rule_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_resolver_firewall_rule_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ルールグループを識別するための名前を指定します。
  # 設定可能な値: 任意の文字列（一意である必要はありませんが、識別しやすい名前を推奨）
  # 関連機能: Route 53 Resolver DNS Firewall Rule Group
  #   ルールグループは、aws_route53_resolver_firewall_rule リソースを使用して
  #   個別のルールを追加し、VPCに関連付けることで機能します。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-rule-groups.html
  name = "example-firewall-rule-group"

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
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-firewall-rule-group"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ルールグループのAmazon Resource Name (ARN)
#
# - id: ルールグループのID
#
# - owner_id: ルールグループを作成したAWSアカウントID。
#             他のアカウントと共有されている場合、共有元のアカウントIDが表示されます。
#
# - share_status: ルールグループの共有状態。
#                 設定可能な値: NOT_SHARED, SHARED_BY_ME, SHARED_WITH_ME
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
