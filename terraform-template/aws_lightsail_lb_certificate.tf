#---------------------------------------------------------------
# Amazon Lightsail Load Balancer SSL/TLS Certificate
#---------------------------------------------------------------
#
# Amazon LightsailロードバランサーにアタッチするSSL/TLS証明書を
# プロビジョニングするリソースです。
# 証明書はロードバランサーでHTTPSトラフィックを有効化するために使用され、
# ドメイン検証を経て有効化されます。
#
# AWS公式ドキュメント:
#   - Lightsail SSL/TLS証明書概要: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-tls-ssl-certificates-in-lightsail-https.html
#   - 証明書の作成とアタッチ: https://docs.aws.amazon.com/lightsail/latest/userguide/create-tls-ssl-certificate-and-attach-to-lightsail-load-balancer-https.html
#   - CreateLoadBalancerTlsCertificate API: https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_CreateLoadBalancerTlsCertificate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_lb_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_lb_certificate" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: SSL/TLS証明書の名前を指定します。
  # 設定可能な値: 一意の文字列。証明書を識別するために使用されます。
  # 注意: Lightsailリソース内で一意である必要があります。
  name = "example-certificate"

  # lb_name (Required)
  # 設定内容: SSL/TLS証明書を作成するロードバランサーの名前を指定します。
  # 設定可能な値: 既存のLightsailロードバランサーのID/名前
  # 注意: 証明書を作成する前にロードバランサーが存在している必要があります。
  #       Lightsailロードバランサーは最大2つの証明書をサポートしますが、
  #       一度に使用できるのは1つのみです。
  # 参考: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-faq-certificates.html
  lb_name = "example-load-balancer"

  #-------------------------------------------------------------
  # ドメイン設定
  #-------------------------------------------------------------

  # domain_name (Optional, Computed)
  # 設定内容: SSL/TLS証明書のプライマリドメイン名を指定します。
  # 設定可能な値: 有効なドメイン名（例: example.com, www.example.com）
  # 省略時: 自動的に計算されます。
  # 注意: ドメインの所有権を検証する必要があります。
  #       検証には、DNS設定にCNAMEレコードを追加する必要があります。
  #       検証完了までに72時間の猶予期間があります。
  # 関連機能: SSL/TLS証明書のドメイン検証
  #   Lightsailは自動的に検証を試みますが、失敗した場合は手動で
  #   CNAMEレコードをDNSゾーンに追加する必要があります。
  #   - https://docs.aws.amazon.com/lightsail/latest/userguide/create-tls-ssl-certificate-and-attach-to-lightsail-load-balancer-https.html
  domain_name = "example.com"

  # subject_alternative_names (Optional, Computed)
  # 設定内容: 証明書に含める追加のドメイン名またはサブドメイン名のセットを指定します。
  # 設定可能な値: ドメイン名の配列（最大9個のドメイン/サブドメイン）
  # 省略時: domain_name属性が自動的にSANとして追加されます。
  # 注意: ワイルドカードドメイン（*.example.com）はサポートされていません。
  #       証明書1つにつき最大10個のドメイン/サブドメインをサポート。
  #       SANsを変更するには、証明書を再提出して再検証する必要があります。
  # 関連機能: Subject Alternative Names (SANs)
  #   1つの証明書で複数のドメインやサブドメインを保護できる機能。
  #   各ドメイン/サブドメインは個別に検証が必要です。
  #   - https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-faq-certificates.html
  subject_alternative_names = [
    "www.example.com",
    "blog.example.com"
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ID設定（通常は自動生成）
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 通常は自動生成される値（lb_name と name の組み合わせ）
  # 省略時: 自動的に生成されます。
  # 注意: 通常は明示的に設定する必要はありません。
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Lightsail証明書のAmazon Resource Name (ARN)
#
# - created_at: 証明書が作成されたタイムスタンプ
#
# - domain_validation_records: 証明書の検証を完了するために使用できる
#        ドメイン検証オブジェクトのセット。SANsが定義されている場合は
#        複数の要素を持つことができます。
#        各オブジェクトには以下のフィールドが含まれます:
#        - domain_name: 検証対象のドメイン名
#        - resource_record_name: DNSに追加するレコード名
#        - resource_record_type: レコードタイプ（通常はCNAME）
#        - resource_record_value: レコードの値
#
# - id: リソースの一意識別子。lb_name と name の組み合わせ
#
# - support_code: 証明書のサポートコード。AWSサポートに問い合わせる際に
#        使用できます。
#---------------------------------------------------------------
