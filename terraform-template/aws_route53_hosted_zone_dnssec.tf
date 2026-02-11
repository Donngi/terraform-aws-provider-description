#---------------------------------------------------------------
# AWS Route 53 Hosted Zone DNSSEC
#---------------------------------------------------------------
#
# Route 53 ホストゾーンのDNSSEC（Domain Name System Security Extensions）を
# 管理するリソースです。DNSSECは、DNSレスポンスの改ざんやなりすましを防ぐ
# セキュリティ機能で、公開鍵暗号を使用してDNSデータの真正性と整合性を保証します。
#
# 警告: ホストゾーンのDNSSEC署名を無効化する前に、DNS変更が完全に反映されるのを
# 待たずに実行すると、ドメインがインターネット上でアクセス不可能になる可能性があります。
# DSレコードを削除する際は、削除したDSレコードの最長TTLが期限切れになるまで待機
# してから、DNSSEC署名の無効化を完了してください。
#
# 注意: Route 53ホストゾーンはグローバルリソースであり、署名キーの一部として
# 使用するaws_kms_keyは必ずus-east-1リージョンに配置する必要があります。
#
# AWS公式ドキュメント:
#   - Route 53でのDNSSEC設定: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec.html
#   - DNSSEC安全な無効化: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec-disable.html
#   - DNSSEC署名の仕組み: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec-how-it-works.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_hosted_zone_dnssec
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_hosted_zone_dnssec" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # hosted_zone_id (Required)
  # 設定内容: Route 53ホストゾーンの識別子を指定します。
  # 設定可能な値: 有効なホストゾーンID文字列
  # 注意: DNSSECを有効化する前に、aws_route53_key_signing_keyリソースで
  #       KSK（Key Signing Key）を作成する必要があります。
  # 関連リソース: aws_route53_zone, aws_route53_key_signing_key
  hosted_zone_id = aws_route53_key_signing_key.example.hosted_zone_id

  #-------------------------------------------------------------
  # DNSSEC署名ステータス
  #-------------------------------------------------------------

  # signing_status (Optional)
  # 設定内容: ホストゾーンのDNSSEC署名ステータスを指定します。
  # 設定可能な値:
  #   - "SIGNING" (デフォルト): DNSSEC署名を有効化
  #   - "NOT_SIGNING": DNSSEC署名を無効化
  # 省略時: "SIGNING"
  # 警告: DNSSEC署名を無効化する場合は、DNS変更の完全な反映を待ってから実行してください。
  #       急いで無効化すると、ドメインがアクセス不可能になる可能性があります。
  # 関連機能: Route 53 DNSSEC署名
  #   DNSSECを有効化すると、Route 53はDNS応答に署名を追加し、
  #   DNSリゾルバーがそれらを検証できるようにします。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec.html
  signing_status = "SIGNING"

  #-------------------------------------------------------------
  # 依存関係
  #-------------------------------------------------------------
  # DNSSECを有効化する前に、Key Signing Key (KSK)が作成されている必要があります。
  # aws_route53_key_signing_keyリソースでKSKを作成してから、このリソースで
  # DNSSECを有効化してください。
  depends_on = [
    aws_route53_key_signing_key.example
  ]

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成操作のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウトが適用されます
  #   create = "30m"
  #
  #   # update (Optional)
  #   # 設定内容: リソース更新操作のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウトが適用されます
  #   update = "30m"
  #
  #   # delete (Optional)
  #   # 設定内容: リソース削除操作のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウトが適用されます
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Route 53ホストゾーンの識別子
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 以下は、DNSSECを有効化するための完全な構成例です。
# この例では、us-east-1リージョンでKMSキーを作成し、ホストゾーン、
# Key Signing Key、DNSSEC設定を順に作成します。
#---------------------------------------------------------------

# データソース: 現在のAWSアカウントIDを取得
# data "aws_caller_identity" "current" {}

# KMSキー: DNSSEC署名用（必ずus-east-1リージョンに作成）
# resource "aws_kms_key" "example" {
#   customer_master_key_spec = "ECC_NIST_P256"
#   deletion_window_in_days  = 7
#   key_usage                = "SIGN_VERIFY"
#
#   # Route 53 DNSSECサービスがキーを使用できるようにするポリシー
#---------------------------------------------------------------
