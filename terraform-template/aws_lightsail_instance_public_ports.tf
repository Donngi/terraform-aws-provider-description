#---------------------------------------------------------------
# Lightsail Instance Public Ports
#---------------------------------------------------------------
#
# Amazon Lightsail インスタンスのパブリックポート（ファイアウォールルール）を管理するリソースです。
# 特定の Lightsail インスタンスに対してポートを開放し、接続を許可する IP アドレスとプロトコルを指定できます。
#
# このリソースで指定されていない既存のポートは全て閉じられます（置き換え動作）。
#
# 注意: Lightsail は一部の AWS リージョンでのみ利用可能です。
#
# AWS公式ドキュメント:
#   - What is Amazon Lightsail?: https://lightsail.aws.amazon.com/ls/docs/getting-started/article/what-is-amazon-lightsail
#   - Regions and Availability Zones: https://lightsail.aws.amazon.com/ls/docs/overview/article/understanding-regions-and-availability-zones-in-amazon-lightsail
#   - PortInfo API Reference: https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_PortInfo.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lightsail_instance_public_ports
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_instance_public_ports" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ポートを開放する Lightsail インスタンスの名前
  # 例: "my-lightsail-instance"
  instance_name = "example-instance"

  #---------------------------------------------------------------
  # ポート情報の設定（必須・最低1つ必要）
  #---------------------------------------------------------------

  # 開放するポートの情報を定義するブロック
  # 複数の port_info ブロックを定義して複数のポート/プロトコルを開放可能
  # このリソースで指定されていないポートは全て閉じられます
  port_info {
    # 開放するポート範囲の開始ポート番号（必須）
    # 単一ポートの場合は to_port と同じ値を指定
    # 例: 80（HTTP）、443（HTTPS）、22（SSH）
    from_port = 80

    # 開放するポート範囲の終了ポート番号（必須）
    # 単一ポートの場合は from_port と同じ値を指定
    # 例: 80（HTTP）、443（HTTPS）、22（SSH）
    to_port = 80

    # 使用するプロトコル（必須）
    # 有効な値: "tcp", "udp", "icmp", "icmpv6", "all"
    # 例: "tcp" - HTTP/HTTPS/SSH等で使用
    #     "udp" - DNS/VPN等で使用
    #     "icmp" - ping等で使用
    #     "all" - 全てのプロトコル
    protocol = "tcp"

    # 接続を許可する IPv4 CIDR ブロックのセット（オプション）
    # 指定しない場合は全ての IPv4 アドレスからの接続が許可されます
    # 例: ["192.168.1.0/24", "10.0.0.0/16"]
    #     ["0.0.0.0/0"] - 全ての IPv4 アドレスを許可
    # cidrs = []

    # 接続を許可する IPv6 CIDR ブロックのセット（オプション）
    # 指定しない場合は全ての IPv6 アドレスからの接続が許可されます
    # 例: ["2001:db8::/32"]
    #     ["::/0"] - 全ての IPv6 アドレスを許可
    # ipv6_cidrs = []

    # 事前定義された IP アドレス範囲へのアクセスを定義する CIDR エイリアスのセット（オプション）
    # Lightsail で事前に定義された IP 範囲を参照する場合に使用
    # cidr_list_aliases = []
  }

  # 追加のポートを開放する場合の例
  # port_info {
  #   from_port = 443
  #   to_port   = 443
  #   protocol  = "tcp"
  #   cidrs     = ["192.168.1.0/24"]
  # }

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # このリソースを管理する AWS リージョン（オプション）
  # 指定しない場合はプロバイダー設定のリージョンが使用されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 例: "us-east-1", "ap-northeast-1"
  # region = null

  # リソース ID（オプション・Computed）
  # Terraform によって自動的に設定されます
  # 明示的に指定する必要はありません
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの ID
#
# これらの属性は Terraform によって自動的に設定され、
# 他のリソースやモジュールから参照できます。
#
# 使用例:
#   output "instance_public_ports_id" {
#     value = aws_lightsail_instance_public_ports.example.id
#   }
#
#---------------------------------------------------------------
