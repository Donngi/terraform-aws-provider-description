# ================================================================================
# Terraform AWS Resource Template: aws_customer_gateway
# ================================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# NOTE: このテンプレートは生成時点の情報です。
#       最新の仕様については公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway
# ================================================================================

resource "aws_customer_gateway" "example" {
  # ================================================================================
  # Required Parameters
  # ================================================================================

  # type - (Required) カスタマーゲートウェイのタイプ
  # AWSが現在サポートしているタイプは "ipsec.1" のみです。
  # これはIPsec VPN接続を使用することを示します。
  # 参考: https://docs.aws.amazon.com/vpn/latest/s2svpn/cgw-options.html
  type = "ipsec.1"

  # ================================================================================
  # Optional Parameters
  # ================================================================================

  # bgp_asn - (Optional) Border Gateway Protocol (BGP) Autonomous System Number (ASN)
  # ゲートウェイのBGP ASNを指定します。
  # 有効な値は 1 から 2147483647 の範囲です。
  # 動的ルーティングを使用する場合に必要です。
  # パブリックASNがない場合、64512-65534 または 4200000000-4294967294 の
  # プライベートASN範囲を使用できます。
  # bgp_asn_extended と競合します（どちらか一方のみ指定可能）。
  # Forces new resource（変更時に再作成が必要）
  # 参考: https://docs.aws.amazon.com/vpn/latest/s2svpn/cgw-options.html
  # bgp_asn = "65000"

  # bgp_asn_extended - (Optional) 拡張BGP ASN
  # ゲートウェイのBGP ASNを指定します（拡張範囲用）。
  # 有効な値は 2147483648 から 4294967295 の範囲です。
  # bgp_asn と競合します（どちらか一方のみ指定可能）。
  # Forces new resource（変更時に再作成が必要）
  # 参考: https://docs.aws.amazon.com/vpn/latest/s2svpn/cgw-options.html
  # bgp_asn_extended = "2147483648"

  # certificate_arn - (Optional) カスタマーゲートウェイ証明書のARN
  # 証明書ベースの認証を使用する場合、AWS Certificate Manager (ACM) の
  # 下位CA証明書のARNを指定します。
  # 参考: https://docs.aws.amazon.com/vpn/latest/s2svpn/cgw-options.html
  # certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  # device_name - (Optional) カスタマーゲートウェイデバイスの名前
  # このカスタマーゲートウェイに関連付けられているデバイスの名前を指定します。
  # 管理や識別を容易にするための任意の名前です。
  # 参考: https://docs.aws.amazon.com/vpn/latest/s2svpn/cgw-options.html
  # device_name = "my-customer-gateway-device"

  # ip_address - (Optional) カスタマーゲートウェイデバイスの外部インターフェースのIPv4アドレス
  # カスタマーゲートウェイデバイスの外部向けインターフェースの静的IPv4アドレスです。
  # ゲートウェイがNATデバイスの背後にある場合は、NATデバイスのIPアドレスを使用し、
  # UDPパケット（ポート500および4500）がネットワーク間で通過できるようにする必要があります。
  # 参考: https://docs.aws.amazon.com/vpn/latest/s2svpn/cgw-options.html
  # ip_address = "172.83.124.10"

  # region - (Optional) このリソースが管理されるリージョン
  # リソースを管理するAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定で設定されたリージョンがデフォルトとして使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - (Optional) リソースに適用するタグ
  # カスタマーゲートウェイに適用するタグのマップです。
  # プロバイダーの default_tags 設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags = {
  #   Name        = "main-customer-gateway"
  #   Environment = "production"
  # }
}

# ================================================================================
# Computed Attributes (Read-Only)
# ================================================================================
# 以下の属性はTerraformによって自動的に計算され、参照のみ可能です:
#
# - id: ゲートウェイのAmazonが割り当てたID
# - arn: カスタマーゲートウェイのARN
# - tags_all: プロバイダーの default_tags から継承されたタグを含む、
#             リソースに割り当てられたタグのマップ
# ================================================================================

# ================================================================================
# 使用例
# ================================================================================
# output "customer_gateway_id" {
#   description = "カスタマーゲートウェイのID"
#   value       = aws_customer_gateway.example.id
# }
#
# output "customer_gateway_arn" {
#   description = "カスタマーゲートウェイのARN"
#   value       = aws_customer_gateway.example.arn
# }
# ================================================================================
