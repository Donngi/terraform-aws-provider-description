#---------------------------------------------------------------
# AWS Network ACL Rule
#---------------------------------------------------------------
#
# VPCのネットワークACL（アクセスコントロールリスト）にルールを追加する。
# ネットワークACLはサブネットレベルでのトラフィック制御を提供し、
# インバウンド（受信）およびアウトバウンド（送信）トラフィックに対して
# 許可/拒否ルールを定義する。セキュリティグループと異なりステートレスである。
#
# AWS公式ドキュメント:
#   - Network ACLs: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html
#   - Network ACL rules: https://docs.aws.amazon.com/vpc/latest/userguide/nacl-rules.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------
#
# 重要な注意事項:
#   - aws_network_acl リソースでインラインルールを定義している場合、
#     aws_network_acl_rule リソースと併用するとルール設定の競合が発生し、
#     ルールが上書きされる。どちらか一方の方式を選択すること。
#   - ルールは rule_number の昇順で評価され、最初にマッチしたルールが適用される。
#   - ネットワークACLはステートレスなため、インバウンドとアウトバウンドの
#     両方のルールを適切に設定する必要がある。
#   - エフェメラルポート（1024-65535）を考慮したルール設計が重要。
#
#---------------------------------------------------------------

resource "aws_network_acl_rule" "example" {

  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # network_acl_id (Required, string)
  # このルールを追加するネットワークACLのID。
  # aws_network_aclリソースまたはdata sourceから取得する。
  network_acl_id = aws_network_acl.example.id

  # rule_number (Required, number)
  # ルール番号（例: 100）。ACLエントリはルール番号の昇順で処理される。
  # 1〜32766の範囲で指定可能。小さい番号が優先される。
  # 後からルールを追加しやすいよう、100単位での番号付けが推奨される。
  # 32767は暗黙の拒否ルール（*）として予約されている。
  rule_number = 100

  # protocol (Required, string)
  # プロトコル。プロトコル番号または名前で指定する。
  # "-1" または "all" で全プロトコルを指定。
  # 主な値:
  #   - "tcp" または "6" : TCP
  #   - "udp" または "17" : UDP
  #   - "icmp" または "1" : ICMP
  #   - "icmpv6" または "58" : ICMPv6
  #   - "-1" または "all" : 全プロトコル
  # NOTE: "-1" を指定した場合、from_port と to_port は無視され、
  #       全ポートに対してルールが適用される。
  protocol = "tcp"

  # rule_action (Required, string)
  # トラフィックを許可するか拒否するかを指定する。
  # 設定可能な値:
  #   - "allow" : トラフィックを許可
  #   - "deny" : トラフィックを拒否
  rule_action = "allow"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # egress (Optional, bool)
  # このルールがEgress（送信）ルールかどうかを指定する。
  # true の場合、サブネットから外向きのトラフィックに適用される。
  # false の場合、サブネットへの内向きトラフィックに適用される。
  # Default: false（Ingressルール）
  egress = false

  # cidr_block (Optional, string)
  # 許可または拒否するネットワーク範囲をCIDR表記で指定する（IPv4）。
  # 例: "10.0.0.0/8", "172.16.0.0/12", "0.0.0.0/0"（全IPv4）
  # cidr_block または ipv6_cidr_block のいずれかを指定する必要がある。
  # NOTE: CIDR範囲を指定すると、自動的に正規形式に変換される。
  cidr_block = "10.0.0.0/8"

  # ipv6_cidr_block (Optional, string)
  # 許可または拒否するネットワーク範囲をCIDR表記で指定する（IPv6）。
  # 例: "2001:db8::/32", "::/0"（全IPv6）
  # cidr_block または ipv6_cidr_block のいずれかを指定する必要がある。
  # ipv6_cidr_block = "2001:db8::/32"

  # from_port (Optional, number)
  # ポート範囲の開始ポート番号。TCP/UDPプロトコルで使用する。
  # 単一ポートを指定する場合は from_port と to_port に同じ値を設定する。
  # NOTE: protocol が "-1"（全プロトコル）の場合、この値は無視される。
  from_port = 443

  # to_port (Optional, number)
  # ポート範囲の終了ポート番号。TCP/UDPプロトコルで使用する。
  # 単一ポートを指定する場合は from_port と to_port に同じ値を設定する。
  # NOTE: protocol が "-1"（全プロトコル）の場合、この値は無視される。
  to_port = 443

  # icmp_type (Optional, number)
  # ICMPプロトコルのタイプ。protocol が "icmp" または "icmpv6" の場合に必須。
  # 主な値:
  #   - 0 : Echo Reply
  #   - 3 : Destination Unreachable
  #   - 8 : Echo Request
  #   - -1 : 全ICMPタイプ（ワイルドカード）
  # NOTE: -1（ワイルドカード）を指定した場合、icmp_code も -1 にする必要がある。
  # 参考: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
  # icmp_type = -1

  # icmp_code (Optional, number)
  # ICMPプロトコルのコード。protocol が "icmp" または "icmpv6" の場合に必須。
  # 主な値:
  #   - 0 : No Code（Echo Request/Reply等）
  #   - -1 : 全ICMPコード（ワイルドカード）
  # NOTE: icmp_type が -1（ワイルドカード）の場合、icmp_code も -1 にする必要がある。
  # icmp_code = -1

  # region (Optional, string)
  # このリソースを管理するAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用される。
  # 通常はプロバイダーレベルで設定するため、リソースレベルでの指定は不要。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートする。
#
# id (string)
#   ネットワークACLルールのID。
#   形式: nacl-xxxxxxxxxxxxxxxxx:rule_number:protocol:egress
#   例: "nacl-0123456789abcdef0:100:6:false"
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 基本的なインバウンドルール
#---------------------------------------------------------------
#
# resource "aws_network_acl_rule" "allow_https_inbound" {
#   network_acl_id = aws_network_acl.main.id
#   rule_number    = 100
#   egress         = false
#   protocol       = "tcp"
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 443
#   to_port        = 443
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 基本的なアウトバウンドルール（エフェメラルポート）
#---------------------------------------------------------------
#
# resource "aws_network_acl_rule" "allow_ephemeral_outbound" {
#   network_acl_id = aws_network_acl.main.id
#   rule_number    = 100
#   egress         = true
#   protocol       = "tcp"
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 1024
#   to_port        = 65535
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 全トラフィック許可
#---------------------------------------------------------------
#
# resource "aws_network_acl_rule" "allow_all" {
#   network_acl_id = aws_network_acl.main.id
#   rule_number    = 100
#   egress         = false
#   protocol       = "-1"
#   rule_action    = "allow"
#   cidr_block     = "10.0.0.0/8"
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: ICMPルール（Ping許可）
#---------------------------------------------------------------
#
# resource "aws_network_acl_rule" "allow_icmp_echo" {
#   network_acl_id = aws_network_acl.main.id
#   rule_number    = 100
#   egress         = false
#   protocol       = "icmp"
#   rule_action    = "allow"
#   cidr_block     = "10.0.0.0/8"
#   icmp_type      = 8  # Echo Request
#   icmp_code      = 0
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 特定IPアドレスからのSSH拒否
#---------------------------------------------------------------
#
# resource "aws_network_acl_rule" "deny_ssh_from_specific_ip" {
#   network_acl_id = aws_network_acl.main.id
#   rule_number    = 50  # 許可ルールより低い番号で優先
#   egress         = false
#   protocol       = "tcp"
#   rule_action    = "deny"
#   cidr_block     = "192.0.2.100/32"
#   from_port      = 22
#   to_port        = 22
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: IPv6ルール
#---------------------------------------------------------------
#
# resource "aws_network_acl_rule" "allow_https_ipv6" {
#   network_acl_id   = aws_network_acl.main.id
#   rule_number      = 110
#   egress           = false
#   protocol         = "tcp"
#   rule_action      = "allow"
#   ipv6_cidr_block  = "::/0"
#   from_port        = 443
#   to_port          = 443
# }
#
#---------------------------------------------------------------
