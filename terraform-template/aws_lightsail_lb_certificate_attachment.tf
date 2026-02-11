#---------------------------------------------------------------
# Lightsail ロードバランサー証明書アタッチメント
#---------------------------------------------------------------
#
# 検証済みのSSL/TLS証明書をLightsailロードバランサーにアタッチして
# HTTPS通信を有効化するためのリソース。
#
# 証明書は事前に検証済みである必要があります。
# Lightsailロードバランサーでは最大2つの証明書をサポートしますが、
# 同時に使用できるのは1つのみです。
#
# AWS公式ドキュメント:
#   - AttachLoadBalancerTlsCertificate API: https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_AttachLoadBalancerTlsCertificate.html
#   - 検証済み証明書のアタッチ手順: https://docs.aws.amazon.com/lightsail/latest/userguide/attach-validated-certificate-to-load-balancer.html
#   - SSL/TLS証明書の概要: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-tls-ssl-certificates-in-lightsail-https.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_lb_certificate_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_lb_certificate_attachment" "example" {
  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # certificate_name (Required)
  # 設定内容: アタッチするSSL/TLS証明書の名前を指定します。
  # 設定可能な値: aws_lightsail_lb_certificate リソースで作成した証明書の名前
  # 注意: 証明書のステータスが "Valid"（検証済み）である必要があります。
  #       証明書は同じリージョン内のロードバランサーにのみアタッチ可能です。
  # 関連機能: Lightsail SSL/TLS証明書
  #   証明書を使用することでHTTPSトラフィック（ポート443）が有効化されます。
  #   Lightsailロードバランサーは最大2つの証明書をサポートしますが、
  #   同時に使用できるのは1つのみです。
  #   - https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-tls-ssl-certificates-in-lightsail-https.html
  certificate_name = "example-certificate"

  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------

  # lb_name (Required)
  # 設定内容: 証明書をアタッチするロードバランサーの名前を指定します。
  # 設定可能な値: aws_lightsail_lb リソースで作成したロードバランサーの名前
  # 関連機能: Lightsail Load Balancer
  #   証明書をアタッチすることで、ロードバランサーでHTTPSトラフィック（ポート443）が
  #   有効化され、安全な通信が可能になります。
  #   - https://docs.aws.amazon.com/lightsail/latest/userguide/attach-validated-certificate-to-load-balancer.html
  lb_name = "example-load-balancer"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンが使用されます。
  # 注意: 証明書とロードバランサーは同じリージョンに存在する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの一意識別子
#       形式: "lb_name,certificate_name" の組み合わせ
#       例: "example-load-balancer,example-certificate"
#
#---------------------------------------------------------------
