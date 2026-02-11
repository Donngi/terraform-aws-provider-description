#---------------------------------------------------------------
# AWS Route 53 Resolver Firewall Rule Group Association
# (aws_route53_resolver_firewall_rule_group_association)
#---------------------------------------------------------------
#
# Route 53 Resolver DNS FirewallルールグループをVPCに関連付けるリソースです。
# DNS Firewallは、VPCからRoute 53 Resolverを通過する送信DNSクエリを
# フィルタリングし、DNSレベルの脅威からVPCを保護します。
#
# 主な機能:
# - ルールグループとVPCの関連付けによるDNSフィルタリング
# - 複数のルールグループの優先度制御
# - VPCごとのDNS Firewall保護設定
# - 変更保護機能によるセキュリティ強化
#
# ユースケース:
# - マルウェアドメインへのアクセスブロック
# - DNS exfiltration攻撃の防止
# - DNS tunneling対策
# - Domain Generation Algorithm (DGA) ベース脅威の検出と防止
# - 組織全体でのDNSトラフィックの集中管理
# - プライベートホストゾーンやEC2インスタンス名の解決リクエスト制御
#
# AWS公式ドキュメント:
#   - DNS Firewall概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall.html
#   - DNS Firewallの動作: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-overview.html
#   - VPCとルールグループの関連付け: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-vpc-associating-rule-group.html
#   - VPC保護の有効化: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-vpc-protections.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_rule_group_association
#
# Provider Version: 6.28.0
# Generated: 2025-02-03
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
  # 設定可能な値: 任意の識別可能な文字列
  # 用途: 管理と使用を容易にするための識別名
  # 注意: この名前は関連付けの管理とAWSコンソールでの表示に使用されます。
  name = "example-firewall-association"

  # firewall_rule_group_id (Required)
  # 設定内容: VPCに関連付けるファイアウォールルールグループの一意識別子を指定します。
  # 設定可能な値: 有効なファイアウォールルールグループID
  # 形式: rslvr-frg-xxxxxxxxxxxxxxxxx
  # 注意: ルールグループは同じリージョンに存在する必要があります。
  #       共有されたルールグループのIDも指定可能です。
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.example.id

  # vpc_id (Required)
  # 設定内容: ルールグループを関連付けるVPCの一意識別子を指定します。
  # 設定可能な値: 有効なVPC ID
  # 形式: vpc-xxxxxxxxxxxxxxxxx
  # 注意: VPCは同じリージョンに存在する必要があります。
  #       1つのVPCに複数のルールグループを関連付けることができます。
  vpc_id = aws_vpc.example.id

  # priority (Required)
  # 設定内容: VPCに関連付けられたルールグループの処理順序を決定する設定を指定します。
  # 設定可能な値: 0〜65535の整数
  # 動作:
  #   - DNS Firewallは最も小さい優先度番号のルールグループから順に処理します
  #   - 同じVPC内で同じ優先度を持つ複数の関連付けは作成できません
  #   - ルールグループ内でマッチするルールが見つかると、そのアクションが適用され
  #     処理は終了します（それ以降のルールグループは評価されません）
  # セキュリティ設定
  #-------------------------------------------------------------

  # mutation_protection (Optional, Computed)
  # 設定内容: この関連付けの変更または削除を防ぐ保護設定を指定します。
  # 設定可能な値:
  #   - "ENABLED": 変更保護が有効（変更・削除が制限されます）
  #   - "DISABLED": 変更保護が無効（デフォルト）
  # 省略時: "DISABLED"
  # 用途: DNS Firewall保護が誤って変更または削除されるのを防ぎます。
  # 注意:
  #   - ENABLEDに設定すると、関連付けを変更または削除する前に
  #     mutation_protectionをDISABLEDに変更する必要があります
  #   - 本番環境では"ENABLED"に設定することを推奨します
  mutation_protection = "DISABLED"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意:
  #   - DNS Firewallはリージョナルサービスです
  #   - 複数リージョンで使用する場合は、各リージョンでルールグループを
  #     作成または共有する必要があります
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途:
  #   - リソースの整理と分類
  #   - コスト配分トラッキング
  #   - アクセス制御
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-firewall-association"
    Environment = "production"
    Purpose     = "dns-security"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ファイアウォールルールグループ関連付けの識別子
#       形式: rslvr-frgassoc-xxxxxxxxxxxxxxxxx
#       用途: 他のリソースで参照する際に使用
#
# - arn: ファイアウォールルールグループ関連付けのAmazon Resource Name (ARN)
#        形式: arn:aws:route53resolver:region:account-id:firewall-rule-group-association/rslvr-frgassoc-xxxxxxxxxxxxxxxxx
#        用途: IAMポリシーやリソースベースのポリシーで使用
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1つのVPCに複数のルールグループを優先度順に関連付ける例

# resource "aws_route53_resolver_firewall_rule_group_association" "blocklist" {
#   name                   = "blocklist-association"
#   firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.blocklist.id
#   vpc_id                 = aws_vpc.example.id
#   priority               = 100
#---------------------------------------------------------------
