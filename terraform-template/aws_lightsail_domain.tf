#---------------------------------------------------------------
# Amazon Lightsail Domain
#---------------------------------------------------------------
#
# Lightsail DNS管理用のドメインを管理します。既にドメインレジストラで
# 登録済みのドメインに対してDNSレコードを管理するために使用します。
#
# 注意事項:
# - Lightsailを使用して新しいドメイン名を登録することはできません。
#   このリソースを使用する前に、Amazon Route 53または他のドメイン
#   レジストラでドメインを登録してください。
# - Lightsailは現在、一部のAWSリージョンでのみサポートされています。
#   詳細は公式ドキュメントを参照してください。
#
# AWS公式ドキュメント:
#   - Register and manage domains for your website in Lightsail:
#     https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-domain-registration.html
#   - Create a DNS zone to manage domain records for Lightsail instances:
#     https://docs.aws.amazon.com/lightsail/latest/userguide/lightsail-how-to-create-dns-entry.html
#   - Route domain traffic to a Lightsail instance:
#     https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-routing-to-instance.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lightsail_domain
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_domain" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # domain_name - (Required) Lightsailで管理するドメイン名
  #
  # Lightsailで管理するドメインの完全修飾ドメイン名(FQDN)を指定します。
  # このドメインは既にドメインレジストラで登録されている必要があります。
  # Lightsailはこのドメインに対するDNSレコード管理を提供します。
  #
  # Example:
  #   domain_name = "example.com"
  #   domain_name = "subdomain.example.com"
  #
  domain_name = "example.com"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # region - (Optional) リソースが管理されるリージョン
  #
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定で設定されたリージョンが
  # デフォルトとして使用されます。
  #
  # Lightsailは現在、限られた数のAWSリージョンでのみサポートされています。
  # 利用可能なリージョンについては、以下のドキュメントを参照してください:
  # https://lightsail.aws.amazon.com/ls/docs/overview/article/understanding-regions-and-availability-zones-in-amazon-lightsail
  #
  # Example:
  #   region = "us-east-1"
  #   region = "ap-northeast-1"
  #
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします（読み取り専用）:
#
# - arn - Lightsailドメインのアマゾンリソース名(ARN)
#   他のAWSサービスでこのドメインを参照する際に使用します。
#
# - id - このドメインに使用される名前
#   通常、domain_nameと同じ値になります。
#
#---------------------------------------------------------------
