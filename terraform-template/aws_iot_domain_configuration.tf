#---------------------------------------------------------------
# AWS IoT Domain Configuration
#---------------------------------------------------------------
#
# AWS IoT ドメイン設定を作成および管理します。
# ドメイン設定により、データエンドポイントの動作を管理し、カスタマイズできます。
# 複数のデータエンドポイントを作成し、それぞれに独自のFQDN、サーバー証明書、
# カスタムオーソライザーを関連付けることができます。
#
# AWS公式ドキュメント:
#   - Domain configurations: https://docs.aws.amazon.com/iot/latest/developerguide/iot-custom-endpoints-configurable.html
#   - What is a domain configuration?: https://docs.aws.amazon.com/iot/latest/developerguide/iot-domain-configuration-what-is.html
#   - Creating and configuring AWS managed domains: https://docs.aws.amazon.com/iot/latest/developerguide/iot-custom-endpoints-configurable-aws.html
#   - Creating and configuring customer managed domains: https://docs.aws.amazon.com/iot/latest/developerguide/iot-custom-endpoints-configurable-custom.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_domain_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_domain_configuration" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # name - (Required) ドメイン設定の名前
  # リージョン内で一意である必要があります。
  # 例: "my-iot-domain-config"
  name = "example-domain-config"

  #---------------------------------------------------------------
  # オプションパラメータ - 基本設定
  #---------------------------------------------------------------

  # domain_name - (Optional) 完全修飾ドメイン名（FQDN）
  # カスタムドメインを使用する場合に指定します。
  # 例: "iot.example.com"
  domain_name = null

  # service_type - (Optional) エンドポイントが提供するサービスのタイプ
  # 注: AWS IoT Core は現在 DATA サービスタイプのみをサポートしています。
  # 有効な値: "DATA"
  service_type = null

  # status - (Optional) ドメイン設定を設定する必要があるステータス
  # 有効な値: "ENABLED", "DISABLED"
  # デフォルト: "ENABLED"
  status = null

  #---------------------------------------------------------------
  # オプションパラメータ - 認証とプロトコル
  #---------------------------------------------------------------

  # application_protocol - (Optional) アプリケーション層プロトコルを指定する列挙文字列
  # 有効な値: "SECURE_MQTT", "MQTT_WSS", "HTTPS", "DEFAULT"
  # DEFAULT を指定すると、IoT Core はデバイスが接続するために使用するプロトコルを
  # 自動的に選択します。
  application_protocol = null

  # authentication_type - (Optional) 認証タイプを指定する列挙文字列
  # 有効な値: "CUSTOM_AUTH_X509", "CUSTOM_AUTH", "AWS_X509", "AWS_SIGV4", "DEFAULT"
  # - CUSTOM_AUTH_X509: X.509 証明書を使用したカスタム認証
  # - CUSTOM_AUTH: カスタムオーソライザーを使用した認証
  # - AWS_X509: AWS IoT の X.509 証明書認証
  # - AWS_SIGV4: AWS Signature Version 4 認証
  # - DEFAULT: デフォルトの認証方法
  authentication_type = null

  #---------------------------------------------------------------
  # オプションパラメータ - 証明書設定
  #---------------------------------------------------------------

  # server_certificate_arns - (Optional) IoT がデバイスへの TLS ハンドシェイク中に渡す証明書の ARN
  # 現在、指定できる証明書 ARN は 1 つのみです。
  # この値は AWS 管理ドメインには不要です。
  # カスタム domain_name を使用する場合、証明書にそれを含める必要があります。
  # 例: ["arn:aws:acm:us-east-1:123456789012:certificate/abcd1234-..."]
  server_certificate_arns = null

  # validation_certificate_arn - (Optional) サーバー証明書を検証し、ドメイン名の所有権を証明するために使用される証明書
  # この証明書は公開認証局によって署名されている必要があります。
  # この値は AWS 管理ドメインには不要です。
  # 例: "arn:aws:acm:us-east-1:123456789012:certificate/efgh5678-..."
  validation_certificate_arn = null

  #---------------------------------------------------------------
  # オプションパラメータ - リージョン設定
  #---------------------------------------------------------------

  # region - (Optional) このリソースが管理されるリージョン
  # デフォルトでは、プロバイダー設定で設定されたリージョンに設定されます。
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # オプションパラメータ - タグ
  #---------------------------------------------------------------

  # tags - (Optional) このリソースに割り当てるタグのマップ
  # プロバイダーの default_tags 設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-iot-domain-config"
    Environment = "production"
  }

  # tags_all - (Optional) プロバイダーの default_tags を含む、リソースに割り当てられたすべてのタグのマップ
  # 通常は Terraform によって自動的に管理されます。
  tags_all = null

  # id - (Optional) リソースの識別子
  # 通常は自動的に生成されます。明示的に設定する必要はほとんどありません。
  id = null

  #---------------------------------------------------------------
  # ネストブロック - authorizer_config
  #---------------------------------------------------------------
  # ドメインの承認サービスを指定するオブジェクト

  authorizer_config {
    # allow_authorizer_override - (Optional) ドメイン設定の承認サービスを上書きできるかどうかを指定するブール値
    # true の場合、接続時にデバイスは異なるオーソライザーを指定できます。
    allow_authorizer_override = null

    # default_authorizer_name - (Optional) ドメイン設定の承認サービスの名前
    # カスタムオーソライザーの名前を指定します。
    default_authorizer_name = null
  }

  #---------------------------------------------------------------
  # ネストブロック - tls_config
  #---------------------------------------------------------------
  # ドメインの TLS 設定を指定するオブジェクト

  tls_config {
    # security_policy - (Optional) ドメイン設定のセキュリティポリシー
    # TLS バージョンと暗号スイートを制御します。
    # 利用可能なセキュリティポリシーの詳細については、AWS IoT Core のドキュメントを参照してください。
    security_policy = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です (computed)
#
# - arn: ドメイン設定の ARN
#   例: "arn:aws:iot:us-east-1:123456789012:domainconfiguration/example-domain-config"
#
# - domain_type: ドメインのタイプ
#   例: "CUSTOMER_MANAGED" または "AWS_MANAGED"
#
# - id: 作成されたドメイン設定の名前
#   name と同じ値が設定されます
#
# - tags_all: プロバイダーの default_tags を含む、リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# 以下は基本的な使用例です:
#
# # AWS 管理ドメインの例
# resource "aws_iot_domain_configuration" "aws_managed" {
#   name                  = "my-aws-managed-domain"
#   service_type          = "DATA"
#   authentication_type   = "DEFAULT"
#   application_protocol  = "DEFAULT"
# }
#
# # カスタマー管理ドメインの例
# resource "aws_iot_domain_configuration" "customer_managed" {
#   name                       = "my-custom-domain"
#   domain_name                = "iot.example.com"
#   service_type               = "DATA"
#   server_certificate_arns    = [aws_acm_certificate.iot_cert.arn]
#   validation_certificate_arn = aws_acm_certificate.validation_cert.arn
#   authentication_type        = "AWS_X509"
#   application_protocol       = "SECURE_MQTT"
#
#   tls_config {
#     security_policy = "IoTSecurityPolicy_TLS13_1_2_2022_10"
#   }
#
#   tags = {
#     Name        = "custom-iot-domain"
#     Environment = "production"
#   }
# }
#
# # カスタムオーソライザーを使用する例
# resource "aws_iot_domain_configuration" "with_authorizer" {
#   name                 = "domain-with-authorizer"
#   service_type         = "DATA"
#   authentication_type  = "CUSTOM_AUTH"
#   application_protocol = "HTTPS"
#
#   authorizer_config {
#     default_authorizer_name   = aws_iot_authorizer.custom.name
#     allow_authorizer_override = true
#   }
# }
#
#---------------------------------------------------------------
