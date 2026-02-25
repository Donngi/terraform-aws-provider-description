#---------------------------------------------------------------
# AWS Lightsail Load Balancer Certificate Attachment
#---------------------------------------------------------------
#
# Amazon LightsailロードバランサーにSSL/TLS証明書をアタッチするリソースです。
# 検証済みのSSL/TLS証明書をLightsailロードバランサーに関連付けることで、
# HTTPSトラフィック（ポート443）を有効化します。
# 証明書はアタッチ前にドメイン所有権の検証が完了している必要があります。
# ロードバランサーあたり最大2つのSSL/TLS証明書をサポートしますが、
# 同時に使用できる証明書は1つのみです。
#
# AWS公式ドキュメント:
#   - SSL/TLS証明書のアタッチ: https://docs.aws.amazon.com/lightsail/latest/userguide/attach-validated-certificate-to-load-balancer.html
#   - Lightsail SSL/TLS証明書の概要: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-tls-ssl-certificates-in-lightsail-https.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_lb_certificate_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_lb_certificate_attachment" "example" {
  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------

  # lb_name (Required)
  # 設定内容: SSL/TLS証明書をアタッチするLightsailロードバランサーの名前を指定します。
  # 設定可能な値: 既存のLightsailロードバランサーの名前
  # 注意: 対象のロードバランサーは事前に作成されている必要があります。
  lb_name = "example-load-balancer"

  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # certificate_name (Required)
  # 設定内容: ロードバランサーにアタッチするSSL/TLS証明書の名前を指定します。
  # 設定可能な値: 既存のLightsailロードバランサー証明書の名前
  # 注意: 証明書はアタッチ前にドメイン所有権の検証が完了している必要があります。
  #       未検証の証明書はアタッチできません。
  # 参考: https://docs.aws.amazon.com/lightsail/latest/userguide/verify-tls-ssl-certificate-using-dns-cname-https.html
  certificate_name = "example-load-balancer-certificate"

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
# - id: リソースの一意識別子。lb_nameとcertificate_nameを組み合わせた値
#---------------------------------------------------------------
