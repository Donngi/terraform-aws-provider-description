#---------------------------------------------------------------
# Amazon SES Domain MAIL FROM
#---------------------------------------------------------------
#
# Amazon Simple Email Service (SES) のカスタム MAIL FROM ドメインを設定するリソースです。
# MAIL FROM ドメインとは、メール配信時に使用される RFC 5321 の MAIL FROM コマンドに
# 使用されるドメインであり、通常は送信元ドメインのサブドメインとして設定します。
#
# 主な機能:
#   - カスタム MAIL FROM ドメインを指定し、バウンスメールの送信先を制御
#   - MXレコード検証失敗時の動作ポリシーを設定
#   - SPF 認証を強化し、メール配信性を向上
#
# AWS公式ドキュメント:
#   - SES MAIL FROM ドメイン設定: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/mail-from.html
#   - SES SPF 認証: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-email-authentication-spf.html
#   - SES バウンス管理: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/notifications-via-email.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_mail_from
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_domain_mail_from" "example" {
  #-------------------------------------------------------------
  # ドメイン設定
  #-------------------------------------------------------------

  # domain (Required)
  # 設定内容: MAIL FROM ドメインを関連付ける検証済みの SES ドメインアイデンティティを指定します。
  # 設定可能な値: 完全修飾ドメイン名 (FQDN)。例: example.com
  # 注意事項:
  #   - 事前に aws_ses_domain_identity リソースで検証済みのドメインを指定する必要があります
  #   - このドメインが SES に登録済みで検証されていることが前提です
  # 関連機能: SES ドメインアイデンティティ
  #   aws_ses_domain_identity リソースと組み合わせて使用します。
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-domains.html
  domain = "example.com"

  # mail_from_domain (Required)
  # 設定内容: メール配信で使用するカスタム MAIL FROM ドメインを指定します。
  # 設定可能な値: domain のサブドメインとして設定する完全修飾ドメイン名。例: bounce.example.com
  # 注意事項:
  #   - domain の直接サブドメインである必要があります (例: domain が example.com の場合、bounce.example.com を使用)
  #   - このドメインの DNS に MX レコードと SPF TXT レコードを追加する必要があります
  #   - MX レコードは feedback-smtp.<region>.amazonses.com を指定します
  #   - SPF TXT レコードには "v=spf1 include:amazonses.com ~all" を設定します
  # 関連機能: カスタム MAIL FROM ドメイン
  #   SPF 認証を強化し、メール配信性を向上させるためにバウンスドメインを専用化します。
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/mail-from-set.html
  mail_from_domain = "bounce.example.com"

  #-------------------------------------------------------------
  # 動作設定
  #-------------------------------------------------------------

  # behavior_on_mx_failure (Optional)
  # 設定内容: MAIL FROM ドメインの MX レコード検証に失敗した場合の動作を指定します。
  # 設定可能な値:
  #   - "UseDefaultValue": 検証失敗時に SES のデフォルトの MAIL FROM ドメインを使用 (省略時のデフォルト)
  #   - "RejectMessage":   検証失敗時にメッセージを拒否し、エラーを返す
  # 省略時: "UseDefaultValue" が使用されます
  # 用途: 厳格な MAIL FROM 設定を適用したい場合に "RejectMessage" を使用
  # 注意事項:
  #   - "RejectMessage" を設定すると MX レコードが正しく設定されていない場合にメール送信が失敗します
  #   - 本番環境では DNS 設定が完了してから "RejectMessage" に変更することを推奨します
  # 関連機能: SES 送信失敗ポリシー
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/mail-from.html#mail-from-set
  behavior_on_mx_failure = "UseDefaultValue"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1, eu-west-1)
  # 省略時: プロバイダー設定で指定されたリージョンを使用
  # 用途: 複数リージョンで SES を使用する場合に明示的にリージョンを指定
  # 注意事項:
  #   - domain に指定したドメインアイデンティティと同じリージョンを指定する必要があります
  #   - SES は各リージョンで独立して動作します
  # 関連機能: SES リージョン管理
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子。domain 属性の値と同じになります
#
#---------------------------------------------------------------
