#---------------------------------------------------------------
# Route 53 Resolver DNS Firewall ルールグループ関連付け
#---------------------------------------------------------------
#
# Amazon Route 53 Resolver DNS Firewallのルールグループを特定のVPCに
# 関連付けるリソースです。関連付けにより、ルールグループ内のDNSファイアウォール
# ルールが対象VPCのDNSトラフィックに適用されます。
# 複数のルールグループを同一VPCに関連付ける場合は、priorityにより処理順序を制御します。
#
# AWS公式ドキュメント:
#   - Resolver DNS Firewallルールグループ: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-rule-groups.html
#   - VPCへのルールグループ関連付け: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-vpc-associating-rule-group.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_rule_group_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_resolver_firewall_rule_group_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ルールグループ関連付けを識別するための名前を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: 関連付けの管理と使用時の識別に使用
  name = "example-rule-group-association"

  # firewall_rule_group_id (Required)
  # 設定内容: 関連付けるファイアウォールルールグループの一意の識別子を指定します。
  # 設定可能な値: 既存の aws_route53_resolver_firewall_rule_group リソースのID
  # 関連機能: Route 53 Resolver DNS Firewallルールグループ
  #   ルールグループには、DNSクエリをフィルタリングするためのルールセットが含まれます。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-rule-groups.html
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.example.id

  # vpc_id (Required)
  # 設定内容: ルールグループを関連付けるVPCの一意の識別子を指定します。
  # 設定可能な値: 既存のVPCのID（例: "vpc-xxxxxxxx"）
  # 関連機能: Amazon VPC
  #   指定したVPCに対するDNSクエリにルールグループのルールが適用されます。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
  vpc_id = aws_vpc.example.id

  #-------------------------------------------------------------
  # 処理順序設定
  #-------------------------------------------------------------

  # priority (Required)
  # 設定内容: 指定したVPCに関連付けられたルールグループ間での処理順序を決定する設定値を指定します。
  # 設定可能な値: 整数値（数値が小さいほど優先度が高い）
  #   - DNS Firewallは最も低い数値のルールグループから順にVPCトラフィックをフィルタリングします。
  #   - 同一VPCに複数のルールグループを関連付ける場合は、それぞれ異なる値を設定します。
  # 省略時: 設定必須のため省略不可
  # 注意: 優先度の値は同一VPC内で一意である必要があります。
  priority = 100

  #-------------------------------------------------------------
  # 保護設定
  #-------------------------------------------------------------

  # mutation_protection (Optional)
  # 設定内容: 関連付けの変更または削除を防止するかどうかを指定します。
  # 設定可能な値:
  #   - "ENABLED"  - 関連付けの変更・削除を禁止し、誤った変更からDNSファイアウォール保護を守ります。
  #   - "DISABLED" - 関連付けの変更・削除を許可します。
  # 省略時: AWSデフォルト値が使用されます（通常は "DISABLED"）
  # 注意: ENABLED に設定した場合、Terraformによる変更や destroy が失敗する可能性があります。
  mutation_protection = "DISABLED"

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
  # 設定内容: リソースに割り当てるタグのキーと値のマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-rule-group-association"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ファイアウォールルールグループ関連付けのAmazon Resource Name (ARN)
#
# - id: 関連付けの識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
