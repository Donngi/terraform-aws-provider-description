#---------------------------------------------------------------
# AWS IoT CA 証明書
#---------------------------------------------------------------
#
# AWS IoT Core に CA（認証局）証明書を登録するリソースです。
# CA 証明書を登録することで、その CA が署名したデバイス証明書を
# AWS IoT Core に自動登録（Just-In-Time Registration: JITR）するか、
# または手動登録で使用できるようになります。
# デバイスが初めて接続した際に証明書を自動的にプロビジョニングする
# フリートプロビジョニングのユースケースで主に使用されます。
#
# AWS公式ドキュメント:
#   - CA 証明書の管理: https://docs.aws.amazon.com/iot/latest/developerguide/manage-your-CA-certs.html
#   - デバイス証明書の自動登録: https://docs.aws.amazon.com/iot/latest/developerguide/auto-register-device-cert.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_ca_certificate
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_ca_certificate" "example" {
  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # ca_certificate_pem (Required)
  # 設定内容: PEM 形式の CA 証明書の内容を指定します。
  # 設定可能な値: PEM 形式の X.509 CA 証明書文字列
  # 注意: このフィールドはセンシティブ属性として扱われます（Terraform state に保存されますが表示は秘匿化）。
  ca_certificate_pem = file("path/to/ca-certificate.pem")

  # verification_certificate_pem (Optional)
  # 設定内容: CA 証明書の所有権を証明するための検証証明書の PEM 形式の内容を指定します。
  # 設定可能な値: PEM 形式の X.509 検証証明書文字列
  # 注意: certificate_mode が "DEFAULT" の場合に必要です。
  #       AWS IoT コンソールで生成した登録コード（registration code）を使用して署名した証明書を指定します。
  #       このフィールドはセンシティブ属性として扱われます（Terraform state に保存されますが表示は秘匿化）。
  verification_certificate_pem = file("path/to/verification-certificate.pem")

  # certificate_mode (Optional)
  # 設定内容: CA 証明書の登録モードを指定します。
  # 設定可能な値:
  #   - "DEFAULT": 標準の CA 証明書登録モード。所有権証明のための検証証明書が必要
  #   - "SNI_ONLY": SNI（Server Name Indication）のみを使用する登録モード。検証証明書不要
  # 省略時: "DEFAULT" が使用されます。
  certificate_mode = "DEFAULT"

  #-------------------------------------------------------------
  # 動作設定
  #-------------------------------------------------------------

  # active (Required)
  # 設定内容: CA 証明書をアクティブ状態にするかを指定します。
  # 設定可能な値:
  #   - true: CA 証明書をアクティブ化し、デバイス証明書の登録・認証に使用可能にします
  #   - false: CA 証明書を非アクティブ化します
  active = true

  # allow_auto_registration (Required)
  # 設定内容: この CA 証明書が署名したデバイス証明書の自動登録（JITR）を許可するかを指定します。
  # 設定可能な値:
  #   - true: デバイスが初めて接続した際にデバイス証明書を自動登録します（JITR を有効化）
  #   - false: デバイス証明書の自動登録を無効化します
  # 注意: true に設定する場合、registration_config ブロックでプロビジョニング設定を行うことを推奨します。
  allow_auto_registration = true

  #-------------------------------------------------------------
  # 自動登録設定
  #-------------------------------------------------------------

  # registration_config (Optional)
  # 設定内容: デバイス証明書の自動登録（JITR）時に使用するプロビジョニング設定を指定します。
  # 注意: allow_auto_registration が true の場合にのみ有効です。
  registration_config {
    # role_arn (Optional)
    # 設定内容: AWS IoT がデバイス証明書の自動登録時に使用する IAM ロールの ARN を指定します。
    # 設定可能な値: 有効な IAM ロールの ARN
    # 注意: AWS IoT がデバイスのプロビジョニングに必要な権限を持つロールを指定します。
    role_arn = "arn:aws:iam::123456789012:role/iot-ca-registration-role"

    # template_body (Optional)
    # 設定内容: デバイス証明書の自動登録時に使用するプロビジョニングテンプレートの本文（JSON 形式）を指定します。
    # 設定可能な値: JSON 形式のプロビジョニングテンプレート文字列
    # 注意: template_name を指定する場合は省略できます。
    template_body = null

    # template_name (Optional)
    # 設定内容: デバイス証明書の自動登録時に使用するプロビジョニングテンプレートの名前を指定します。
    # 設定可能な値: 既存の AWS IoT プロビジョニングテンプレートの名前
    # 注意: template_body を指定する場合は省略できます。
    template_name = null
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
    Name        = "example-iot-ca-certificate"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: CA 証明書の ID（証明書識別子）
#
# - arn: CA 証明書の Amazon Resource Name (ARN)
#
# - customer_version: CA 証明書のカスタマーバージョン番号
#
# - generation_id: CA 証明書の世代 ID
#
# - validity: CA 証明書の有効期間を表すオブジェクトのリスト。
#             各オブジェクトには not_before（有効期間開始日時）と
#             not_after（有効期間終了日時）が含まれます。
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
