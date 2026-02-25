#---------------------------------------------------------------
# AWS Security Group Rule
#---------------------------------------------------------------
#
# Amazon VPCセキュリティグループに対してインバウンド（ingress）または
# アウトバウンド（egress）の単一ルールをプロビジョニングするリソースです。
# セキュリティグループルールは、関連付けられたリソースへの通信を制御する
# 仮想ファイアウォールルールを定義します。
#
# 注意: aws_security_group_rule は複数CIDRブロックの管理に課題があります。
#       現在のベストプラクティスは aws_vpc_security_group_ingress_rule および
#       aws_vpc_security_group_egress_rule リソースを使用することです（1ルールにつき1CIDRブロック）。
#       また、aws_vpc_security_group_egress_rule / aws_vpc_security_group_ingress_rule や
#       インラインルールを持つ aws_security_group と同時に使用するとルールの競合が発生します。
#
# AWS公式ドキュメント:
#   - セキュリティグループルール: https://docs.aws.amazon.com/vpc/latest/userguide/security-group-rules.html
#   - セキュリティグループルールの設定: https://docs.aws.amazon.com/vpc/latest/userguide/working-with-security-group-rules.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_security_group_rule" "example" {
  #-------------------------------------------------------------
  # ルール種別設定
  #-------------------------------------------------------------

  # type (Required)
  # 設定内容: セキュリティグループルールの方向を指定します。
  # 設定可能な値:
  #   - "ingress": インバウンドルール（外部からこのリソースへのトラフィックを制御）
  #   - "egress": アウトバウンドルール（このリソースから外部へのトラフィックを制御）
  type = "ingress"

  #-------------------------------------------------------------
  # 対象セキュリティグループ設定
  #-------------------------------------------------------------

  # security_group_id (Required)
  # 設定内容: このルールを適用するセキュリティグループのIDを指定します。
  # 設定可能な値: 有効なセキュリティグループID（例: "sg-12345678"）
  security_group_id = "sg-12345678"

  #-------------------------------------------------------------
  # プロトコル・ポート設定
  #-------------------------------------------------------------

  # protocol (Required)
  # 設定内容: ルールに適用するプロトコルを指定します。
  # 設定可能な値:
  #   - "tcp": TCPプロトコル
  #   - "udp": UDPプロトコル
  #   - "icmp": ICMPプロトコル
  #   - "icmpv6": ICMPv6プロトコル
  #   - "all" または "-1": 全プロトコル（from_port, to_portは0を指定。全ポートが開放されます）
  #   - プロトコル番号（文字列形式）: IANAプロトコル番号表の値
  # 参考: https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
  protocol = "tcp"

  # from_port (Required)
  # 設定内容: 許可するポート範囲の開始ポート番号を指定します。
  #           プロトコルが "icmp" または "icmpv6" の場合はICMPタイプ番号を指定します。
  # 設定可能な値: 0〜65535の整数。protocol が "all"/-1 の場合は 0 を指定
  from_port = 443

  # to_port (Required)
  # 設定内容: 許可するポート範囲の終了ポート番号を指定します。
  #           プロトコルが "icmp" の場合はICMPコードを指定します。
  # 設定可能な値: 0〜65535の整数。protocol が "all"/-1 の場合は 0 を指定
  to_port = 443

  #-------------------------------------------------------------
  # トラフィック送信元・送信先設定
  #-------------------------------------------------------------
  # 注意: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, source_security_group_id, self
  #       はすべてオプションですが、いずれか1つは必須です。
  #       また、self と cidr_blocks, ipv6_cidr_blocks, source_security_group_id は排他的です。
  #       source_security_group_id は cidr_blocks, ipv6_cidr_blocks, self と排他的です。

  # cidr_blocks (Optional)
  # 設定内容: 送信元（ingressの場合）または送信先（egressの場合）のIPv4 CIDRブロックのリストを指定します。
  # 設定可能な値: 有効なIPv4 CIDRブロックのリスト（例: ["10.0.0.0/8", "203.0.113.0/24"]）
  # 注意: source_security_group_id または self と同時に指定できません。
  cidr_blocks = ["0.0.0.0/0"]

  # ipv6_cidr_blocks (Optional)
  # 設定内容: 送信元（ingressの場合）または送信先（egressの場合）のIPv6 CIDRブロックのリストを指定します。
  # 設定可能な値: 有効なIPv6 CIDRブロックのリスト（例: ["::/0", "2001:db8::/32"]）
  # 注意: source_security_group_id または self と同時に指定できません。
  ipv6_cidr_blocks = null

  # prefix_list_ids (Optional)
  # 設定内容: 送信元または送信先として使用するAWSマネージドプレフィックスリストのIDのリストを指定します。
  # 設定可能な値: 有効なプレフィックスリストIDのリスト（例: ["pl-12345678"]）
  # 用途: VPCエンドポイントサービスへのアクセス許可等に使用
  prefix_list_ids = null

  # source_security_group_id (Optional)
  # 設定内容: アクセスを許可するセキュリティグループのIDを指定します。
  #           type が "ingress" の場合は送信元、"egress" の場合は送信先となります。
  # 設定可能な値: 有効なセキュリティグループID
  # 注意: cidr_blocks, ipv6_cidr_blocks, self と同時に指定できません。
  #       VPCピアリング越しのセキュリティグループ参照には制限があります。
  # 参考: https://docs.aws.amazon.com/vpc/latest/peering/vpc-peering-security-groups.html
  source_security_group_id = null

  # self (Optional)
  # 設定内容: セキュリティグループ自身を送信元または送信先として追加するかを指定します。
  #           trueを指定すると、同じセキュリティグループに属するリソース間の通信が許可されます。
  # 設定可能な値:
  #   - true: セキュリティグループ自身を送信元・送信先として追加
  #   - false (省略時の動作): 追加しない
  # 省略時: false
  # 注意: cidr_blocks, ipv6_cidr_blocks, source_security_group_id と同時に指定できません。
  self = null

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: セキュリティグループルールの説明を指定します。
  # 設定可能な値: 255文字以内の文字列
  # 省略時: 説明なし
  description = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: "ap-northeast-1", "us-east-1"）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "10m", "1h30m"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: セキュリティグループルールのID。
#       セキュリティグループID、ルール種別、プロトコル、ポート範囲、
#       送信元・送信先情報を組み合わせた一意の識別子。
#
# - security_group_rule_id: AWSのセキュリティグループルールリソースID。
#       単一の送信元・送信先を持つルールの場合のみ設定されます。
#       複数のCIDRブロックを指定した場合は空になります。
#---------------------------------------------------------------
