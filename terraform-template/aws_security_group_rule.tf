#---------------------------------------------------------------
# AWS Security Group Rule
#---------------------------------------------------------------
#
# セキュリティグループに単一の ingress (インバウンド) または egress (アウトバウンド)
# ルールを追加するリソースです。外部のセキュリティグループにルールを追加する際に使用します。
#
# 重要な注意事項:
# - aws_security_group_rule リソースは、複数の CIDR ブロックの管理や、固有 ID、
#   タグ、説明の歴史的な欠如により問題を抱えています。
# - これらの問題を回避するため、現在のベストプラクティスは aws_vpc_security_group_egress_rule
#   および aws_vpc_security_group_ingress_rule リソースを使用し、1つのルールに1つの
#   CIDR ブロックを割り当てることです。
#
# 警告:
# - aws_security_group_rule リソースを aws_vpc_security_group_egress_rule および
#   aws_vpc_security_group_ingress_rule リソース、またはインラインルールを持つ
#   aws_security_group リソースと併用しないでください。ルールの競合や永続的な差異、
#   ルールの上書きが発生する可能性があります。
#
# 注意:
# - protocol = "all" または protocol = -1 を from_port および to_port と設定すると、
#   EC2 API はすべてのポートが開いたセキュリティグループルールを作成します。
#   この API の動作は Terraform では制御できず、将来的に警告が生成される可能性があります。
# - VPC ピアリング経由でのセキュリティグループ参照には特定の制限があります。
#
# AWS公式ドキュメント:
#   - セキュリティグループルール: https://docs.aws.amazon.com/vpc/latest/userguide/security-group-rules.html
#   - VPC ピアリングでのセキュリティグループ: https://docs.aws.amazon.com/vpc/latest/peering/vpc-peering-security-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_security_group_rule" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # type (Required)
  # 設定内容: 作成するルールのタイプを指定します。
  # 設定可能な値:
  #   - "ingress": インバウンドルール（外部からリソースへの接続）
  #   - "egress": アウトバウンドルール（リソースから外部への接続）
  type = "ingress"

  # security_group_id (Required)
  # 設定内容: このルールを適用するセキュリティグループの ID を指定します。
  # 設定可能な値: セキュリティグループ ID（例: sg-12345678）
  security_group_id = "sg-xxxxxxxxxxxxxxxxx"

  # from_port (Required)
  # 設定内容: 開始ポート番号を指定します。
  # 設定可能な値:
  #   - TCP/UDP の場合: ポート番号（0-65535）
  #   - ICMP の場合: ICMP タイプ番号
  #   - protocol が "-1" (all) の場合: 0
  # 注意: ICMP の場合、タイプ番号を指定します（例: echo request は 8）
  from_port = 443

  # to_port (Required)
  # 設定内容: 終了ポート番号を指定します。
  # 設定可能な値:
  #   - TCP/UDP の場合: ポート番号（0-65535）
  #   - ICMP の場合: ICMP コード番号
  #   - protocol が "-1" (all) の場合: 0
  # 注意: 単一ポートの場合、from_port と同じ値を指定します
  to_port = 443

  # protocol (Required)
  # 設定内容: 通信プロトコルを指定します。
  # 設定可能な値:
  #   - "tcp": TCP プロトコル
  #   - "udp": UDP プロトコル
  #   - "icmp": ICMP プロトコル（IPv4）
  #   - "icmpv6": ICMPv6 プロトコル（IPv6）
  #   - "all" または "-1": すべてのプロトコル
  #   - プロトコル番号: IANA プロトコル番号（例: 6 for TCP, 17 for UDP）
  # 参考: https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
  protocol = "tcp"

  #-------------------------------------------------------------
  # トラフィックソース/デスティネーション設定
  # 注意: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, source_security_group_id
  #       のいずれか1つを指定する必要があります。
  #-------------------------------------------------------------

  # cidr_blocks (Optional)
  # 設定内容: トラフィックを許可する IPv4 CIDR ブロックのリストを指定します。
  # 設定可能な値: IPv4 CIDR 表記のリスト（例: ["10.0.0.0/16", "192.168.1.0/24"]）
  # 注意: source_security_group_id または self と併用不可
  # 推奨: 複数の CIDR ブロックがある場合、各 CIDR に対して個別のルールを作成することを推奨
  cidr_blocks = ["0.0.0.0/0"]

  # ipv6_cidr_blocks (Optional)
  # 設定内容: トラフィックを許可する IPv6 CIDR ブロックのリストを指定します。
  # 設定可能な値: IPv6 CIDR 表記のリスト（例: ["::/0"]）
  # 注意: source_security_group_id または self と併用不可
  ipv6_cidr_blocks = null

  # prefix_list_ids (Optional)
  # 設定内容: トラフィックを許可するプレフィックスリスト ID のリストを指定します。
  # 設定可能な値: AWS マネージドまたはカスタマーマネージドプレフィックスリスト ID
  # 関連機能: VPC エンドポイント、AWS サービスの IP アドレス範囲の管理
  # 例: S3 や DynamoDB などの AWS サービスへのアクセスを許可する際に使用
  prefix_list_ids = null

  # source_security_group_id (Optional)
  # 設定内容: トラフィックを許可するソースセキュリティグループの ID を指定します。
  # 設定可能な値: セキュリティグループ ID（例: sg-12345678）
  # 注意: cidr_blocks, ipv6_cidr_blocks, self と併用不可
  # 用途:
  #   - type が "ingress" の場合: このセキュリティグループからのアクセスを許可
  #   - type が "egress" の場合: このセキュリティグループへのアクセスを許可
  source_security_group_id = null

  # self (Optional)
  # 設定内容: セキュリティグループ自身をソースとして追加するかを指定します。
  # 設定可能な値:
  #   - true: セキュリティグループ自身を参照ソースとして追加
  #   - false (デフォルト): セキュリティグループ自身を参照しない
  # 注意: cidr_blocks, ipv6_cidr_blocks, source_security_group_id と併用不可
  # 用途: 同じセキュリティグループに属するリソース間の通信を許可
  self = false

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ルールの説明を指定します。
  # 設定可能な値: 文字列（最大255文字）
  # 推奨: ルールの目的を明確に記述することで、管理性が向上します
  description = "Allow HTTPS inbound traffic"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: "5m" などの duration 文字列
    # 省略時: 5分
    create = "5m"
  }
}

#---------------------------------------------------------------
# 使用例: Prefix List を使用した Egress ルール
#---------------------------------------------------------------
# resource "aws_security_group_rule" "allow_vpc_endpoint" {
#   type              = "egress"
#   to_port           = 0
#   protocol          = "-1"
#   prefix_list_ids   = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
#   from_port         = 0
#   security_group_id = "sg-123456"
#   description       = "Allow traffic to VPC endpoint"
# }

#---------------------------------------------------------------
# 使用例: セキュリティグループ間の参照
#---------------------------------------------------------------
# resource "aws_security_group_rule" "allow_from_alb" {
#   type                     = "ingress"
#   from_port                = 80
#   to_port                  = 80
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.alb.id
#   security_group_id        = aws_security_group.web.id
#   description              = "Allow HTTP from ALB security group"
# }

#---------------------------------------------------------------
# 使用例: 同じセキュリティグループ内の通信許可
#---------------------------------------------------------------
# resource "aws_security_group_rule" "allow_internal" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"
#   self              = true
#   security_group_id = aws_security_group.cluster.id
#   description       = "Allow all TCP traffic within the security group"
# }

#---------------------------------------------------------------
# 使用例: ICMP ルール
#---------------------------------------------------------------
# resource "aws_security_group_rule" "allow_icmp" {
#   type              = "ingress"
#   from_port         = 8  # ICMP type (echo request)
#   to_port           = 0  # ICMP code
#   protocol          = "icmp"
#   cidr_blocks       = ["10.0.0.0/16"]
#   security_group_id = aws_security_group.example.id
#   description       = "Allow ICMP echo request from VPC"
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: セキュリティグループルールの ID
#
# - security_group_rule_id: aws_security_group_rule リソースが単一のソースまたは
#                           デスティネーションを持つ場合、AWS セキュリティグループ
#                           ルールリソース ID。それ以外の場合は空。
#---------------------------------------------------------------
