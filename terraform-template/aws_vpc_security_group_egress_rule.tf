#---------------------------------------------------------------
# AWS VPC Security Group Egress Rule
#---------------------------------------------------------------
#
# VPCセキュリティグループのアウトバウンド（送信）ルールを管理するリソースです。
# aws_security_group_rule リソースのより新しい代替として提供されており、
# セキュリティグループルールを個別リソースとして管理できます。
# 1つのルールにつき1つのリソースを作成するため、ルールの変更が
# 他のルールに影響を与えることなく安全に行えます。
#
# 注意: このリソースは aws_security_group の egress ブロックと
#       混在して使用すると競合が発生します。
#       どちらか一方のみを使用してください。
#
# AWS公式ドキュメント:
#   - Security Group Rules: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/security-group-rules.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_security_group_egress_rule" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # security_group_id (Required)
  # 設定内容: ルールを追加するセキュリティグループのIDを指定します。
  # 設定可能な値: 有効なセキュリティグループID（例: sg-xxxxxxxxxxxxxxxxx）
  security_group_id = "sg-05f1f54ab49bb39a3"

  # ip_protocol (Required)
  # 設定内容: 許可するIPプロトコルを指定します。
  # 設定可能な値:
  #   - "tcp"  : TCPプロトコル
  #   - "udp"  : UDPプロトコル
  #   - "icmp" : ICMPプロトコル（IPv4）
  #   - "icmpv6": ICMPv6プロトコル（IPv6）
  #   - "-1"   : 全プロトコル（all traffic）。from_port/to_port は指定不要
  #   - プロトコル番号の文字列（例: "6" = TCP, "17" = UDP）
  ip_protocol = "tcp"

  #-------------------------------------------------------------
  # 送信先設定（いずれか1つを指定）
  #-------------------------------------------------------------

  # cidr_ipv4 (Optional)
  # 設定内容: 送信先のIPv4 CIDRブロックを指定します。
  # 設定可能な値: 有効なIPv4 CIDR表記（例: "0.0.0.0/0", "10.0.0.0/8"）
  # 省略時: null（cidr_ipv6, prefix_list_id, referenced_security_group_id のいずれかを指定）
  cidr_ipv4 = "0.0.0.0/0"

  # cidr_ipv6 (Optional)
  # 設定内容: 送信先のIPv6 CIDRブロックを指定します。
  # 設定可能な値: 有効なIPv6 CIDR表記（例: "::/0", "2001:db8::/32"）
  # 省略時: null
  cidr_ipv6 = null

  # prefix_list_id (Optional)
  # 設定内容: 送信先のプレフィックスリストIDを指定します。
  # 設定可能な値: 有効なプレフィックスリストID（例: pl-xxxxxxxxxx）
  # 省略時: null
  prefix_list_id = null

  # referenced_security_group_id (Optional)
  # 設定内容: 送信先として参照するセキュリティグループのIDを指定します。
  # 設定可能な値: 有効なセキュリティグループID（例: sg-xxxxxxxxxxxxxxxxx）
  # 注意: 同一VPC内のセキュリティグループ、またはVPCピアリングで
  #       接続されたセキュリティグループを指定できます。
  # 省略時: null
  referenced_security_group_id = null

  #-------------------------------------------------------------
  # ポート設定
  #-------------------------------------------------------------

  # from_port (Optional)
  # 設定内容: 許可するポート範囲の開始ポート番号を指定します。
  # 設定可能な値: 0〜65535 の整数
  # 省略時: ip_protocol が "-1"（全プロトコル）の場合は指定不要
  from_port = 443

  # to_port (Optional)
  # 設定内容: 許可するポート範囲の終了ポート番号を指定します。
  # 設定可能な値: 0〜65535 の整数（from_port 以上の値）
  # 省略時: ip_protocol が "-1"（全プロトコル）の場合は指定不要
  to_port = 443

  #-------------------------------------------------------------
  # 説明・タグ設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: セキュリティグループルールの説明を指定します。
  # 設定可能な値: 最大255文字の文字列
  # 省略時: null（説明なし）
  description = null

  # tags (Optional)
  # 設定内容: リソースに付与するタグのマップを指定します。
  # 設定可能な値: キーと値がともに文字列のマップ
  # 省略時: タグなし
  tags = {
    # Name  = "example-egress-rule"
    # Env   = "production"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id                    : セキュリティグループルールの一意識別子
# - arn                   : セキュリティグループルールのARN
# - security_group_rule_id: AWSが割り当てるセキュリティグループルールのID
# - tags_all              : プロバイダーのデフォルトタグを含む全タグのマップ
#---------------------------------------------------------------
