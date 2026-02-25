#---------------------------------------------------------------
# AWS Lightsail Domain
#---------------------------------------------------------------
#
# Amazon LightsailのDNS管理ドメインをプロビジョニングするリソースです。
# すでにドメインレジストラで登録済みのドメインに対してLightsailのDNS管理を
# 設定します。このリソースはDNSゾーンを作成し、Lightsail上でDNSレコードを
# 管理できるようにします。
#
# 注意: 新しいドメイン名の登録はできません。Amazon Route 53または
#       他のドメインレジストラで事前に登録したドメインを指定してください。
# 注意: Lightsailは限られたAWSリージョンでのみサポートされています。
#
# AWS公式ドキュメント:
#   - Lightsailでのドメイン登録と管理: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-domain-registration.html
#   - LightsailのDNSドメイン: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-faq-domains.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_domain
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_domain" "example" {
  #-------------------------------------------------------------
  # ドメイン設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: 管理するLightsailドメインの名前を指定します。
  # 設定可能な値: 有効なドメイン名文字列（例: "example.com"）
  # 注意: このリソースは既存のドメイン名をLightsailのDNS管理に登録するものです。
  #       新しいドメイン名の登録には使用できません。
  #       ドメインはAmazon Route 53または他のドメインレジストラで
  #       事前に登録しておく必要があります。
  domain_name = "example.com"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 注意: Lightsailは限られたリージョンでのみサポートされています。
  # 参考: https://lightsail.aws.amazon.com/ls/docs/overview/article/understanding-regions-and-availability-zones-in-amazon-lightsail
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: LightsailドメインのARN（Amazon Resource Name）
#
# - id: このドメインに使用されている名前（domain_nameと同じ値）
#---------------------------------------------------------------
