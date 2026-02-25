#---------------------------------------------------------------
# AWS Lightsail Instance Public Ports
#---------------------------------------------------------------
#
# Amazon Lightsail インスタンスのパブリックポート設定を管理するリソースです。
# インスタンスで許可するプロトコル、ポート範囲、アクセス元CIDRを定義します。
# このリソースはインスタンスのファイアウォール（ポートルール）をまとめて管理し、
# 既存のポートルールをすべて上書きします。
#
# 注意: このリソースを使用すると、インスタンスに設定済みのすべてのポートルールが
#       このリソースで定義した内容に置き換えられます。
#
# AWS公式ドキュメント:
#   - Lightsailインスタンスのファイアウォール: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-firewall-and-port-mappings-in-amazon-lightsail.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance_public_ports
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_instance_public_ports" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # instance_name (Required)
  # 設定内容: パブリックポートを設定するLightsailインスタンスの名前を指定します。
  # 設定可能な値: 有効なLightsailインスタンス名文字列
  instance_name = "example-instance"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ポート情報設定
  #-------------------------------------------------------------

  # port_info (Required, min_items=1)
  # 設定内容: インスタンスで許可するポートルールを定義するブロックです。
  # 注意: 少なくとも1つの port_info ブロックを指定する必要があります。
  #       複数のブロックを指定することで複数のポートルールを定義できます。
  port_info {

    # from_port (Required)
    # 設定内容: 許可するポート範囲の開始ポート番号を指定します。
    # 設定可能な値: 0 〜 65535 の整数
    from_port = 80

    # to_port (Required)
    # 設定内容: 許可するポート範囲の終了ポート番号を指定します。
    # 設定可能な値: 0 〜 65535 の整数。単一ポートの場合は from_port と同じ値を指定します。
    to_port = 80

    # protocol (Required)
    # 設定内容: 許可するネットワークプロトコルを指定します。
    # 設定可能な値:
    #   - "tcp": TCPプロトコル
    #   - "udp": UDPプロトコル
    #   - "icmp": ICMPプロトコル
    #   - "all": すべてのプロトコル
    protocol = "tcp"

    # cidrs (Optional)
    # 設定内容: アクセスを許可する送信元IPv4 CIDRブロックのリストを指定します。
    # 設定可能な値: IPv4 CIDR表記の文字列セット（例: "0.0.0.0/0", "192.168.1.0/24"）
    # 省略時: AWSが適切なデフォルト値を設定します。
    cidrs = ["0.0.0.0/0"]

    # ipv6_cidrs (Optional)
    # 設定内容: アクセスを許可する送信元IPv6 CIDRブロックのリストを指定します。
    # 設定可能な値: IPv6 CIDR表記の文字列セット（例: "::/0", "2001:db8::/32"）
    # 省略時: AWSが適切なデフォルト値を設定します。
    ipv6_cidrs = ["::/0"]

    # cidr_list_aliases (Optional)
    # 設定内容: CIDRエイリアスリストの名前のセットを指定します。
    # 設定可能な値: LightsailがサポートするCIDRエイリアスリスト名の文字列セット
    #               （例: "cloudfront-global", "cloudfront-us-east-1"）
    # 省略時: AWSが適切なデフォルト値を設定します。
    cidr_list_aliases = []
  }

  port_info {
    from_port          = 443
    to_port            = 443
    protocol           = "tcp"
    cidrs              = ["0.0.0.0/0"]
    ipv6_cidrs         = ["::/0"]
    cidr_list_aliases  = []
  }

  port_info {
    from_port          = 22
    to_port            = 22
    protocol           = "tcp"
    cidrs              = ["203.0.113.0/24"]
    ipv6_cidrs         = []
    cidr_list_aliases  = []
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子（インスタンス名を元に生成）
#---------------------------------------------------------------
