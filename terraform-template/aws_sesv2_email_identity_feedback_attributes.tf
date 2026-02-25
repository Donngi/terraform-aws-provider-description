#---------------------------------------------------------------
# AWS SESv2 Email Identity Feedback Attributes
#---------------------------------------------------------------
#
# Amazon SES (Simple Email Service) v2の検証済みメールID（ドメインまたは
# メールアドレス）に対して、メールフォワーディング（フィードバック転送）の
# 有効化・無効化を設定するリソースです。
# バウンスおよびクレームの通知をメール転送で受け取るかどうかを制御します。
#
# AWS公式ドキュメント:
#   - フィードバック転送の設定: https://docs.aws.amazon.com/ses/latest/dg/send-email-notifications-email.html
#   - PutEmailIdentityFeedbackAttributes API: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_PutEmailIdentityFeedbackAttributes.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity_feedback_attributes
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sesv2_email_identity_feedback_attributes" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # email_identity (Required)
  # 設定内容: フィードバック転送を設定する対象の検証済みメールIDを指定します。
  # 設定可能な値: SESで検証済みのドメイン名またはメールアドレス
  # 注意: 事前にaws_sesv2_email_identityリソースで検証済みである必要があります。
  email_identity = "example.com"

  #-------------------------------------------------------------
  # フィードバック転送設定
  #-------------------------------------------------------------

  # email_forwarding_enabled (Optional)
  # 設定内容: バウンスおよびクレームの通知をメールで転送するかどうかを指定します。
  # 設定可能な値:
  #   - true : バウンス・クレーム通知をメール転送で受け取ります。
  #            フィードバック通知用メールアドレスへ通知が届きます。
  #   - false: メール転送を無効化します。
  #            SNSなど他の通知方法を使用する場合はfalseに設定してください。
  # 省略時: false
  # 関連機能: フィードバック通知
  #   Amazon SESはメール送信後のバウンスやクレームを検知するためにフィードバック
  #   ループを利用します。メール転送を有効化するとSESが自動的に通知を転送しますが、
  #   高トラフィック環境ではSNSトピックへの通知が推奨されます。
  #   - https://docs.aws.amazon.com/ses/latest/dg/send-email-notifications-email.html
  email_forwarding_enabled = true

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
