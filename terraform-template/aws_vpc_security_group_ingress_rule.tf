#---------------------------------------------------------------
# AWS VPC Security Group Ingress Rule
#---------------------------------------------------------------
#
# VPCセキュリティグループのインバウンド（受信）ルールをプロビジョニングするリソースです。
# セキュリティグループに関連付けられたリソースへの受信トラフィックを制御します。
#
# AWS公式ドキュメント:
#   - セキュリティグループルール: https://docs.aws.amazon.com/vpc/latest/userguide/security-group-rules.html
#   - セキュリティグループルールの設定: https://docs.aws.amazon.com/vpc/latest/userguide/working-with-security-group-rules.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # security_group_id (Required)
  # 設定内容: ルールを追加するセキュリティグループのIDを指定します。
  # 設定可能な値: 有効なセキュリティグループID（例: sg-12345678, sg-0123456789abcdef0）
  security_group_id = aws_security_group.example.id

  #-------------------------------------------------------------
  # プロトコル・ポート設定
  #-------------------------------------------------------------

  # ip_protocol (Required)
  # 設定内容: IPプロトコル名または番号を指定します。
  # 設定可能な値:
  #   - "tcp": TCPプロトコル
  #   - "udp": UDPプロトコル
  #   - "icmp": ICMPプロトコル（IPv4）
  #   - "icmpv6": ICMPv6プロトコル（IPv6）
  #   - "-1": すべてのプロトコル
  #   - プロトコル番号（例: "6" = TCP, "17" = UDP）
  # 注意: "-1"を指定した場合、すべてのプロトコル・すべてのポート範囲となり、
  #       from_portとto_portは指定しないでください。
  ip_protocol = "tcp"

  # from_port (Optional)
  # 設定内容: TCPおよびUDPプロトコルのポート範囲の開始ポート、
  #          またはICMP/ICMPv6のタイプを指定します。
  # 設定可能な値:
  #   - TCP/UDP: 0-65535の範囲のポート番号
  #   - ICMP/ICMPv6: ICMPタイプ番号（例: 8 = Echo Request）
  # 注意: ip_protocolが"-1"または"icmpv6"の場合は指定不要です。
  from_port = 443

  # to_port (Optional)
  # 設定内容: TCPおよびUDPプロトコルのポート範囲の終了ポート、
  #          またはICMP/ICMPv6のコードを指定します。
  # 設定可能な値:
  #   - TCP/UDP: 0-65535の範囲のポート番号
  #   - ICMP/ICMPv6: ICMPコード番号（例: -1 = すべてのコード）
  # 注意: ip_protocolが"-1"または"icmpv6"の場合は指定不要です。
  to_port = 443

  #-------------------------------------------------------------
  # トラフィックソース設定
  #-------------------------------------------------------------
  # 以下の4つのソース指定オプションのうち、いずれか1つを必ず指定してください。

  # cidr_ipv4 (Optional)
  # 設定内容: 許可するトラフィックの送信元IPv4 CIDRブロックを指定します。
  # 設定可能な値: 有効なIPv4 CIDRブロック（例: 10.0.0.0/8, 192.168.1.0/24, 0.0.0.0/0）
  # 注意: cidr_ipv6、prefix_list_id、referenced_security_group_idと排他的です。
  #       セキュリティ上の理由から、0.0.0.0/0（すべてのIPv4アドレス）の使用は
  #       可能な限り避け、特定のIPアドレス範囲のみを許可することを推奨します。
  cidr_ipv4 = "10.0.0.0/8"

  # cidr_ipv6 (Optional)
  # 設定内容: 許可するトラフィックの送信元IPv6 CIDRブロックを指定します。
  # 設定可能な値: 有効なIPv6 CIDRブロック（例: 2001:db8::/32, ::/0）
  # 注意: cidr_ipv4、prefix_list_id、referenced_security_group_idと排他的です。
  #       セキュリティ上の理由から、::/0（すべてのIPv6アドレス）の使用は
  #       可能な限り避けることを推奨します。
  cidr_ipv6 = null

  # prefix_list_id (Optional)
  # 設定内容: 許可するトラフィックの送信元プレフィックスリストのIDを指定します。
  # 設定可能な値: 有効なプレフィックスリストID（例: pl-12345678）
  # 関連機能: マネージドプレフィックスリスト
  #   複数のCIDRブロックを1つのリストにまとめて管理できます。
  #   AWSマネージドプレフィックスリスト（例: S3、DynamoDB用）も利用可能です。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/managed-prefix-lists.html
  # 注意: cidr_ipv4、cidr_ipv6、referenced_security_group_idと排他的です。
  prefix_list_id = null

  # referenced_security_group_id (Optional)
  # 設定内容: 許可するトラフィックの送信元セキュリティグループのIDを指定します。
  # 設定可能な値: 有効なセキュリティグループID（例: sg-12345678）
  # 関連機能: セキュリティグループ参照
  #   他のセキュリティグループに関連付けられたリソースからのトラフィックを許可します。
  #   同一VPC内のセキュリティグループ、VPCピアリング接続先のセキュリティグループ、
  #   または共有VPCのセキュリティグループを指定できます。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/security-group-rules.html
  # 注意: cidr_ipv4、cidr_ipv6、prefix_list_idと排他的です。
  referenced_security_group_id = null

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: セキュリティグループルールの説明を指定します。
  # 設定可能な値: 最大255文字の文字列
  # 用途: ルールの目的や用途を記録し、管理を容易にします。
  description = "Allow HTTPS traffic from internal network"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
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
  tags = {
    Name        = "allow-https-internal"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: セキュリティグループルールのAmazon Resource Name (ARN)
#
# - security_group_rule_id: セキュリティグループルールのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用上の注意
#---------------------------------------------------------------
#
# 1. aws_vpc_security_group_ingress_rule と aws_vpc_security_group_egress_rule の
#    使用が現在のベストプラクティスです。aws_security_group_rule リソースや
#    aws_security_group リソースのインラインルール（ingress/egress引数）の
#    使用は避けてください。
#
# 2. aws_security_group のインラインルールと併用しないでください。
#    ルールの競合、永続的な差分、ルールの上書きが発生する可能性があります。
#
# 3. トラフィックソースは cidr_ipv4、cidr_ipv6、prefix_list_id、
#    referenced_security_group_id のいずれか1つを必ず指定してください。
#
#---------------------------------------------------------------
