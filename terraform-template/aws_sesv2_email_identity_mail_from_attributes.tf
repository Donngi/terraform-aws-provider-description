#---------------------------------------------------------------
# AWS SESv2 Email Identity Mail From Attributes
#---------------------------------------------------------------
#
# Amazon SES (Simple Email Service) v2の検証済みメールID（ドメインまたは
# メールアドレス）に対して、カスタムMAIL FROMドメインを設定するリソースです。
# カスタムMAIL FROMドメインを使用することで、SPFによるDMARC準拠を実現し、
# メールの認証性と配信性を向上させることができます。
#
# AWS公式ドキュメント:
#   - カスタムMAIL FROMドメインの使用: https://docs.aws.amazon.com/ses/latest/dg/mail-from.html
#   - PutEmailIdentityMailFromAttributes API: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_PutEmailIdentityMailFromAttributes.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity_mail_from_attributes
#
# Provider Version: 6.28.0
# Generated: 2026-02-08
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sesv2_email_identity_mail_from_attributes" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # email_identity (Required)
  # 設定内容: カスタムMAIL FROMドメインを設定する対象の検証済みメールIDを指定します。
  # 設定可能な値: SESで検証済みのドメイン名またはメールアドレス
  # 注意: 事前にaws_sesv2_email_identityリソースで検証済みである必要があります。
  email_identity = "example.com"

  #-------------------------------------------------------------
  # MAIL FROMドメイン設定
  #-------------------------------------------------------------

  # mail_from_domain (Optional)
  # 設定内容: 検証済みIDが使用するカスタムMAIL FROMドメインを指定します。
  # 設定可能な値: 検証済みIDの親ドメインのサブドメイン（例: mail.example.com）
  # 省略時: AmazonSESのデフォルトMAIL FROMドメイン（amazonses.com のサブドメイン）が使用されます。
  # 関連機能: カスタムMAIL FROMドメイン
  #   カスタムMAIL FROMドメインを設定すると、SPFによるDMARC準拠を実現できます。
  #   設定にはMXレコードとSPF（TXT）レコードのDNS設定が必要です。
  #   MAIL FROMドメインは検証済みIDのサブドメインである必要があり、
  #   メール送信元やメール受信に使用していないサブドメインを選択してください。
  #   - https://docs.aws.amazon.com/ses/latest/dg/mail-from.html
  # 注意: behavior_on_mx_failureが"REJECT_MESSAGE"の場合、この設定は必須です。
  #       nullを設定するとカスタムMAIL FROM設定が無効化されます。
  mail_from_domain = "mail.example.com"

  # behavior_on_mx_failure (Optional)
  # 設定内容: メール送信時にカスタムMAIL FROMドメインの必要なMXレコードが
  #           見つからない場合の動作を指定します。
  # 設定可能な値:
  #   - "USE_DEFAULT_VALUE": amazonses.comをMAIL FROMドメインとして使用してメールを送信します。
  #                          MXレコードが正しく設定されていない場合でもメール送信が継続されます。
  #   - "REJECT_MESSAGE": Amazon SES APIがMailFromDomainNotVerifiedエラーを返し、
  #                        メール送信を試行しません。
  # 省略時: "USE_DEFAULT_VALUE"
  # 関連機能: カスタムMAIL FROMドメインのMX障害時動作
  #   カスタムMAIL FROMドメインのセットアップ状態がPending、Failed、TemporaryFailureの場合に
  #   この設定が適用されます。本番環境ではREJECT_MESSAGEを推奨します。
  #   - https://docs.aws.amazon.com/ses/latest/dg/mail-from.html
  behavior_on_mx_failure = "USE_DEFAULT_VALUE"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: SESはリージョンサービスのため、IDはリージョンごとに管理されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: メールIDの識別子（email_identityと同じ値）
#---------------------------------------------------------------
