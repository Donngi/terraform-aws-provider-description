#---------------------------------------------------------------
# AWS IoT ドメイン設定
#---------------------------------------------------------------
#
# AWS IoT Core のカスタムドメイン設定をプロビジョニングするリソースです。
# カスタムドメインを使用することで、デバイスが独自のドメイン名で
# AWS IoT Core エンドポイントに接続できるようになります。
# TLS 設定やカスタムオーソライザーの構成、サービスタイプの指定が可能です。
#
# AWS公式ドキュメント:
#   - カスタムドメインの設定: https://docs.aws.amazon.com/iot/latest/developerguide/iot-custom-endpoints-configurable.html
#   - ドメイン設定: https://docs.aws.amazon.com/iot/latest/developerguide/iot-custom-endpoints-configurable-aws.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_domain_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_domain_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ドメイン設定の名前を指定します。
  # 設定可能な値: 1〜128文字の文字列
  name = "example-domain-configuration"

  #-------------------------------------------------------------
  # ドメイン設定
  #-------------------------------------------------------------

  # domain_name (Optional)
  # 設定内容: ドメイン設定に使用するカスタムドメイン名を指定します。
  # 設定可能な値: 有効なドメイン名文字列
  # 省略時: AWS が管理するデフォルトドメインを使用します。
  domain_name = "example.iot.example.com"

  # server_certificate_arns (Optional)
  # 設定内容: カスタムドメインのサーバー証明書 ARN のセットを指定します。
  # 設定可能な値: ACM 証明書の ARN を最大 1 つ含むセット
  # 省略時: AWS 管理のデフォルト証明書を使用します。
  server_certificate_arns = [
    "arn:aws:acm:ap-northeast-1:123456789012:certificate/example-certificate-id"
  ]

  # validation_certificate_arn (Optional)
  # 設定内容: ドメイン検証に使用する ACM 証明書の ARN を指定します。
  # 設定可能な値: 有効な ACM 証明書の ARN
  # 省略時: 検証証明書を使用しません。
  validation_certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/validation-certificate-id"

  #-------------------------------------------------------------
  # プロトコル・認証設定
  #-------------------------------------------------------------

  # application_protocol (Optional)
  # 設定内容: デバイスとの通信に使用するアプリケーションプロトコルを指定します。
  # 設定可能な値:
  #   - "SECURE_MQTT": 安全な MQTT プロトコル（ポート 443 または 8883）
  #   - "MQTT_WSS": WebSocket 経由の MQTT
  #   - "HTTPS": HTTPS プロトコル
  #   - "DEFAULT": デフォルトプロトコル
  # 省略時: プロバイダーまたは AWS のデフォルト値が使用されます。
  application_protocol = "SECURE_MQTT"

  # authentication_type (Optional)
  # 設定内容: デバイス接続時の認証タイプを指定します。
  # 設定可能な値:
  #   - "AWS_X509": X.509 クライアント証明書による認証
  #   - "CUSTOM_AUTH": カスタムオーソライザーによる認証
  #   - "AWS_SIGV4": AWS Signature Version 4 による認証
  #   - "CUSTOM_AUTH_COGNITO": Cognito を使用したカスタム認証
  #   - "DEFAULT": デフォルトの認証タイプ
  # 省略時: プロバイダーまたは AWS のデフォルト値が使用されます。
  authentication_type = "AWS_X509"

  # service_type (Optional)
  # 設定内容: ドメイン設定のサービスタイプを指定します。
  # 設定可能な値:
  #   - "DATA": デバイスデータ通信用のサービスタイプ
  #   - "CREDENTIAL_PROVIDER": 認証情報プロバイダーサービスタイプ
  #   - "JOBS": AWS IoT Jobs サービスタイプ
  # 省略時: "DATA" として扱われます。
  service_type = "DATA"

  # status (Optional)
  # 設定内容: ドメイン設定の状態を指定します。
  # 設定可能な値:
  #   - "ENABLED": ドメイン設定を有効化します
  #   - "DISABLED": ドメイン設定を無効化します
  # 省略時: "ENABLED" として扱われます。
  status = "ENABLED"

  #-------------------------------------------------------------
  # カスタムオーソライザー設定
  #-------------------------------------------------------------

  # authorizer_config ブロック (Optional)
  # 設定内容: カスタムオーソライザーの設定を指定します。
  # 注意: authentication_type が "CUSTOM_AUTH" または "CUSTOM_AUTH_COGNITO" の場合に使用します。
  authorizer_config {
    # allow_authorizer_override (Optional)
    # 設定内容: デバイスが接続時にデフォルトオーソライザーを上書きできるかを指定します。
    # 設定可能な値:
    #   - false (デフォルト): オーソライザーの上書きを禁止します
    #   - true: デバイスが接続リクエストでオーソライザーを指定できます
    allow_authorizer_override = false

    # default_authorizer_name (Optional)
    # 設定内容: このドメイン設定で使用するデフォルトのカスタムオーソライザー名を指定します。
    # 設定可能な値: 既存のカスタムオーソライザーの名前
    # 省略時: デフォルトオーソライザーを使用しません。
    default_authorizer_name = "example-authorizer"
  }

  #-------------------------------------------------------------
  # TLS 設定
  #-------------------------------------------------------------

  # tls_config ブロック (Optional)
  # 設定内容: TLS（Transport Layer Security）の設定を指定します。
  tls_config {
    # security_policy (Optional)
    # 設定内容: TLS 接続に適用するセキュリティポリシーを指定します。
    # 設定可能な値: 有効な TLS セキュリティポリシー名
    #   例: "IoTSecurityPolicy_TLS13_1_2_2022_10", "IoTSecurityPolicy_TLS13_1_3_2022_10"
    # 省略時: AWS のデフォルトセキュリティポリシーを使用します。
    security_policy = "IoTSecurityPolicy_TLS13_1_2_2022_10"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値の文字列ペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルのタグを上書きします。
  tags = {
    Name        = "example-domain-configuration"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ドメイン設定の Amazon Resource Name (ARN)
#
# - domain_type: ドメインのタイプ。AWS_MANAGED（AWS 管理）または CUSTOMER_MANAGED（顧客管理）。
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
