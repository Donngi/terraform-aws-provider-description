#---------------------------------------------------------------
# VPC Security Group Egress Rule
#---------------------------------------------------------------
# セキュリティグループのアウトバウンド（送信）ルールを管理するリソース
# VPC内のセキュリティグループに対して、特定の宛先への送信トラフィックを
# 許可するルールを設定します。
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/vpc/latest/userguide/security-group-rules.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpc_security_group_egress_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
#
# NOTE: このファイルは自動生成されたテンプレートです。
# 実際の使用前に、環境に応じた適切な値への変更と検証が必要です。
#
# BEST PRACTICE: aws_vpc_security_group_egress_ruleと
# aws_vpc_security_group_ingress_ruleの使用が現在の推奨方法です。
# aws_security_group_ruleリソースやaws_security_groupリソースの
# ingressおよびegress引数との併用は避けてください。
#
# WARNING: aws_security_groupリソースのインラインルール（ingressや
# egress引数）やaws_security_group_ruleリソースと併用すると、
# ルールの競合や永続的な差分、ルールの上書きが発生します。
#---------------------------------------------------------------

resource "aws_vpc_security_group_egress_rule" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # security_group_id (Required)
  # 設定内容: ルールを追加するセキュリティグループのID
  # 設定可能な値: 有効なセキュリティグループID（sg-で始まる）
  # 関連機能: Security Groups
  #   VPCのインスタンスレベルのファイアウォール機能
  #   https://docs.aws.amazon.com/vpc/latest/userguide/security-groups.html
  security_group_id = "sg-0123456789abcdef0"

  # ip_protocol (Required)
  # 設定内容: IPプロトコルの名前または番号
  # 設定可能な値: tcp, udp, icmp, icmpv6, または-1（全プロトコル）、
  #              あるいはIANAプロトコル番号（0-255）
  # NOTE: -1を指定すると全プロトコル・全ポート範囲を意味し、
  #       from_portとto_portは定義不要（定義すべきでない）
  # 関連機能: IANA Protocol Numbers
  #   標準化されたプロトコル番号の一覧
  #   https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
  ip_protocol = "tcp"

  #-------------------------------------------------------------
  # 送信先設定（いずれか1つ必須）
  #-------------------------------------------------------------

  # cidr_ipv4 (Optional)
  # 設定内容: 送信先のIPv4 CIDR範囲
  # 設定可能な値: 有効なIPv4 CIDR表記（例: "10.0.0.0/8", "203.0.113.0/24"）
  # NOTE: cidr_ipv4, cidr_ipv6, prefix_list_id, referenced_security_group_id
  #       のいずれか1つを必ず指定する必要があります
  cidr_ipv4 = "10.0.0.0/8"

  # cidr_ipv6 (Optional)
  # 設定内容: 送信先のIPv6 CIDR範囲
  # 設定可能な値: 有効なIPv6 CIDR表記（例: "::/0", "2001:db8::/32"）
  # NOTE: IPv6トラフィックを許可する場合に使用
  # cidr_ipv6 = "::/0"

  # prefix_list_id (Optional)
  # 設定内容: 送信先のプレフィックスリストID
  # 設定可能な値: 有効なプレフィックスリストID（pl-で始まる）
  # NOTE: AWSサービス（S3、CloudFrontなど）やカスタムプレフィックスリストを
  #       送信先として指定する場合に使用
  # 関連機能: Prefix Lists
  #   IPアドレス範囲のセットを管理
  #   https://docs.aws.amazon.com/vpc/latest/userguide/managed-prefix-lists.html
  # prefix_list_id = "pl-0123456789abcdef0"

  # referenced_security_group_id (Optional)
  # 設定内容: 送信先として参照するセキュリティグループID
  # 設定可能な値: 有効なセキュリティグループID（sg-で始まる）
  # NOTE: 特定のセキュリティグループに関連付けられたインスタンスへの
  #       トラフィックを許可する場合に使用。参照するセキュリティグループの
  #       サイズに関わらず、1つのルールとしてカウントされます
  # referenced_security_group_id = "sg-9876543210fedcba0"

  #-------------------------------------------------------------
  # ポート範囲設定
  #-------------------------------------------------------------

  # from_port (Optional)
  # 設定内容: TCP/UDPプロトコルのポート範囲の開始、またはICMP/ICMPv6のタイプ
  # 設定可能な値: 0-65535（TCP/UDP）、ICMP/ICMPv6タイプ番号
  # 省略時: ip_protocolが-1またはicmpv6の場合は不要
  # NOTE: ip_protocolがtcpまたはudpの場合、ポート範囲の指定が必要
  from_port = 80

  # to_port (Optional)
  # 設定内容: TCP/UDPプロトコルのポート範囲の終了、またはICMP/ICMPv6のコード
  # 設定可能な値: 0-65535（TCP/UDP）、ICMP/ICMPv6コード番号
  # 省略時: ip_protocolが-1またはicmpv6の場合は不要
  # NOTE: from_portと同じ値を設定すると単一ポートを意味します
  to_port = 80

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: セキュリティグループルールの説明
  # 設定可能な値: 任意の文字列（最大255文字）
  # 省略時: 説明なし
  # NOTE: ルールの目的を明確にするため記載を強く推奨
  description = "Allow HTTP traffic to internal services"

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # NOTE: プロバイダーのdefault_tags設定ブロックで定義されたタグと
  #       キーが一致する場合、こちらの設定が優先されます
  # 関連機能: Resource Tagging
  #   AWSリソースの整理と管理
  #   https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "http-egress-to-internal"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョン
  # 関連機能: リージョナルエンドポイント
  #   リージョン固有のリソース管理
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（設定不可）:
#
# - arn: セキュリティグループルールのAmazon Resource Name (ARN)
#   output "rule_arn" {
#     value = aws_vpc_security_group_egress_rule.example.arn
#   }
#
# - security_group_rule_id: セキュリティグループルールのID
#   output "rule_id" {
#     value = aws_vpc_security_group_egress_rule.example.security_group_rule_id
#   }
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承された
#            タグを含む、リソースに割り当てられたすべてのタグのマップ
#   output "all_tags" {
#     value = aws_vpc_security_group_egress_rule.example.tags_all
#   }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 各種送信先タイプ
#---------------------------------------------------------------

# 例1: HTTPS通信を全インターネットに許可
# resource "aws_vpc_security_group_egress_rule" "https_to_internet" {
#   security_group_id = aws_security_group.example.id
#   ip_protocol       = "tcp"
#   from_port         = 443
#   to_port           = 443
#   cidr_ipv4         = "0.0.0.0/0"
#   description       = "Allow HTTPS to internet"
# }

# 例2: S3プレフィックスリストへのHTTPS通信を許可
# resource "aws_vpc_security_group_egress_rule" "https_to_s3" {
#   security_group_id = aws_security_group.example.id
#   ip_protocol       = "tcp"
#   from_port         = 443
#   to_port           = 443
#   prefix_list_id    = data.aws_prefix_list.s3.id
#   description       = "Allow HTTPS to S3"
# }

# 例3: 別のセキュリティグループへのMySQL接続を許可
# resource "aws_vpc_security_group_egress_rule" "mysql_to_db" {
#   security_group_id            = aws_security_group.app.id
#   ip_protocol                  = "tcp"
#   from_port                    = 3306
#   to_port                      = 3306
#   referenced_security_group_id = aws_security_group.database.id
#   description                  = "Allow MySQL to database security group"
# }

# 例4: 全プロトコル・全ポートを許可（デフォルトの送信ルール）
# resource "aws_vpc_security_group_egress_rule" "allow_all" {
#   security_group_id = aws_security_group.example.id
#   ip_protocol       = "-1"
#   cidr_ipv4         = "0.0.0.0/0"
#   description       = "Allow all outbound traffic"
# }

# 例5: ICMPエコー（ping）を許可
# resource "aws_vpc_security_group_egress_rule" "ping" {
#   security_group_id = aws_security_group.example.id
#   ip_protocol       = "icmp"
#   from_port         = 8   # Echo request
#   to_port           = -1  # Any code
#   cidr_ipv4         = "10.0.0.0/8"
#   description       = "Allow ping to internal network"
# }
#---------------------------------------------------------------
