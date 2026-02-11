#---------------------------------------------------------------
# AWS Lightsail Domain Entry
#---------------------------------------------------------------
#
# AWS Lightsailドメインエントリ（DNSレコード）を管理するリソースです。
# このリソースを使用して、ドメインに対するDNSクエリの処理方法を定義します。
# Lightsailドメイン内に各種DNSレコード（A、AAAA、CNAME、MX、NS、SOA、SRV、TXT）を
# 作成し、ドメイン名をIPアドレスやその他のターゲットにマッピングできます。
#
# AWS公式ドキュメント:
#   - Lightsailドメイン概要: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-routing-to-instance.html
#   - DomainEntry API: https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_DomainEntry.html
#   - CreateDomainEntry: https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_CreateDomainEntry.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_domain_entry
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_domain_entry" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須項目）
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: エントリを作成するLightsailドメインの名前を指定します。
  # 設定可能な値: 有効なドメイン名（例: example.com）
  # 注意: 事前にaws_lightsail_domainリソースでドメインを作成しておく必要があります
  # 関連機能: Lightsailドメイン管理
  #   Lightsailでは最大6つのDNSゾーンを管理できます。それ以上のドメインや
  #   サポートされていないレコードタイプを使用する場合は、Amazon Route 53の使用を推奨します。
  #   - https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-routing-to-instance.html
  domain_name = "example.com"

  # name (Required)
  # 設定内容: エントリレコードの名前を指定します。
  # 設定可能な値:
  #   - サブドメイン名（例: "www", "mail", "api"）
  #   - "@"（ルートドメインを表す）
  #   - 空文字列（ルートドメインを表す）
  # オプション設定
  #-------------------------------------------------------------

  # is_alias (Optional)
  # 設定内容: エントリをエイリアスにするかどうかを指定します。
  # 設定可能な値: true または false
  # デフォルト値: false
  # 関連機能: AWSリソースへのエイリアス
  #   trueに設定すると、このドメインエントリはLightsailロードバランサー、
  #   コンテナサービス、またはCDNディストリビューションなどのAWSリソースへの
  #   エイリアスとして機能します。エイリアスレコードはCNAMEレコードと似ていますが、
  #   ルートドメイン（ゾーンAPEX）でも使用できるという利点があります。
  #   - https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_DomainEntry.html
  is_alias = false

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: Lightsailはすべてのリージョンで利用できるわけではありません。
  #       利用可能なリージョンについては公式ドキュメントを確認してください。
  region = null
}

#---------------------------------------------------------------

# 例1: ルートドメインのAレコード
resource "aws_lightsail_domain_entry" "root" {
  domain_name = "example.com"
  name        = "@"  # または空文字列 ""
  type        = "A"
  target      = "192.0.2.1"
}

# 例2: wwwサブドメインのCNAMEレコード
resource "aws_lightsail_domain_entry" "www_cname" {
  domain_name = "example.com"
  name        = "www"
  type        = "CNAME"
  target      = "example.com"
}

# 例3: メールサーバーのMXレコード
resource "aws_lightsail_domain_entry" "mail" {
  domain_name = "example.com"
  name        = "@"
  type        = "MX"
  target      = "10 mail.example.com"  # 優先度とホスト名
}

# 例4: SPFレコード（TXT）
resource "aws_lightsail_domain_entry" "spf" {
  domain_name = "example.com"
  name        = "@"
  type        = "TXT"
  target      = "v=spf1 include:_spf.example.com ~all"
}

# 例5: Lightsailロードバランサーへのエイリアス
resource "aws_lightsail_domain_entry" "lb_alias" {
  domain_name = "example.com"
  name        = "app"
  type        = "A"
  target      = "lb-1234567890.us-east-1.elb.amazonaws.com"
  is_alias    = true
}

# 例6: IPv6アドレスのAAAAレコード
resource "aws_lightsail_domain_entry" "ipv6" {
  domain_name = "example.com"
  name        = "www"
  type        = "AAAA"
  target      = "2001:0db8:85a3::8a2e:0370:7334"
}

#---------------------------------------------------------------

resource "aws_lightsail_domain" "example" {
  domain_name = "example.com"
}

resource "aws_lightsail_instance" "web" {
  name              = "web-server"
  availability_zone = "us-east-1a"
  blueprint_id      = "wordpress"
  bundle_id         = "nano_3_0"
}

resource "aws_lightsail_static_ip" "web" {
  name = "web-static-ip"
}

resource "aws_lightsail_static_ip_attachment" "web" {
  static_ip_name = aws_lightsail_static_ip.web.name
  instance_name  = aws_lightsail_instance.web.name
}

resource "aws_lightsail_domain_entry" "web" {
  domain_name = aws_lightsail_domain.example.domain_name
  name        = "www"
  type        = "A"
  target      = aws_lightsail_static_ip.web.ip_address
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ドメインエントリの一意の識別子
#       形式: `name,domain_name,type,target`
#       例: "www,example.com,A,192.0.2.1"
#
# 注意: idフィールドの形式について
#   インポートを簡素化するため、このリソースのidフィールドは標準的な
#   リソースIDセパレーター（カンマ `,`）に更新されました。
#   後方互換性のため、以前のセパレーター（アンダースコア `_`）も
#   既存のリソースの読み取りとインポートに使用できます。
#   ステートがリフレッシュされると、idは新しい標準セパレーターを使用するように
#   更新されます。以前のセパレーターは将来のメジャーリリースで非推奨になります。
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import (既存リソースのインポート)
#---------------------------------------------------------------
# 既存のLightsailドメインエントリは以下の形式でインポートできます:
#
# terraform import aws_lightsail_domain_entry.example "name,domain_name,type,target"
#
#---------------------------------------------------------------
