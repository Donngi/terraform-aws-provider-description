#---------------------------------------------------------------
# AWS Pinpoint Email Channel
#---------------------------------------------------------------
#
# Amazon Pinpointアプリケーションにメールチャネルを追加するためのリソースです。
# Amazon SES（Simple Email Service）と統合して、Pinpointキャンペーンや
# ジャーニーからメールメッセージを送信できるようにします。
#
# AWS公式ドキュメント:
#   - Amazon Pinpoint概要: https://docs.aws.amazon.com/pinpoint/latest/userguide/welcome.html
#   - メールチャネル設定: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-email.html
#   - Amazon SES統合: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-email-setup.html
#   - SES Identity検証: https://docs.aws.amazon.com/ses/latest/dg/verify-addresses-and-domains.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_email_channel
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pinpoint_email_channel" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # application_id (Required)
  # 設定内容: メールチャネルを追加するPinpointアプリケーションIDを指定します。
  # 設定可能な値: 有効なPinpointアプリケーションID
  # 注意: aws_pinpoint_appリソースのapplication_id属性を参照
  # 関連リソース: aws_pinpoint_app
  application_id = "your-pinpoint-app-id"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # チャネル有効化設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: メールチャネルの有効/無効を指定します。
  # 設定可能な値:
  #   - true: メールチャネルを有効化（デフォルト）
  #   - false: メールチャネルを無効化
  # 用途: チャネルを一時的に無効化する場合に使用
  # 注意: 無効化すると、このチャネルを使用したメール送信ができなくなります
  enabled = true

  #-------------------------------------------------------------
  # 送信元メールアドレス設定
  #-------------------------------------------------------------

  # from_address (Required)
  # 設定内容: メール送信に使用するFromアドレスを指定します。
  # 設定可能な値:
  #   - メールアドレスのみ: "user@example.com"
  #   - 表示名付き: "Example User <user@example.com>"
  # 準拠規格: RFC 5322
  # 注意: Amazon SESで検証済みのドメインまたはメールアドレスである必要があります
  # 参考: https://www.ietf.org/rfc/rfc5322.txt
  from_address = "noreply@example.com"

  #-------------------------------------------------------------
  # SESアイデンティ設定
  #-------------------------------------------------------------

  # identity (Required)
  # 設定内容: Amazon SESで検証済みのアイデンティティARNを指定します。
  # 設定可能な値: 有効なSESドメインアイデンティティまたはメールアドレスアイデンティティのARN
  # 注意:
  #   - 事前にSESでドメインまたはメールアドレスを検証する必要があります
  #   - from_addressは、identityで指定したドメインまたはメールアドレスと一致する必要があります
  # 関連リソース: aws_ses_domain_identity, aws_ses_email_identity
  # 用途: Pinpointがこのアイデンティティを使用してメールを送信
  identity = "arn:aws:ses:us-east-1:123456789012:identity/example.com"

  #-------------------------------------------------------------
  # SES設定セット（オプション）
  #-------------------------------------------------------------

  # configuration_set (Optional)
  # 設定内容: メール送信時に適用するAmazon SES設定セットのARNを指定します。
  # 設定可能な値: 有効なSES設定セットのARN
  # 用途:
  #   - メール送信のトラッキング
  #   - イベント公開（バウンス、苦情、配信、開封、クリックなど）
  #   - 送信設定（IPプール、カスタムDKIM設定など）
  # 関連リソース: aws_ses_configuration_set
  # 参考: https://docs.aws.amazon.com/ses/latest/dg/using-configuration-sets.html
  configuration_set = null

  #-------------------------------------------------------------
  # IAMロール設定（オーケストレーション用）
  #-------------------------------------------------------------

  # orchestration_sending_role_arn (Optional)
  # 設定内容: Amazon Pinpointがキャンペーンやジャーニーから
  #           Amazon SES経由でメールを送信するために使用するIAMロールARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 必要な権限:
  #   - ses:SendEmail
  #   - ses:SendRawEmail
  # 用途: Pinpointキャンペーンやジャーニーからのメール送信に使用
  # 関連リソース: aws_iam_role
  # 注意: 推奨される方法（role_arnは非推奨）
  orchestration_sending_role_arn = null

  #-------------------------------------------------------------
  # IAMロール設定（非推奨）
  #-------------------------------------------------------------

  # role_arn (Optional, Deprecated)
  # 設定内容: Mobile Analyticsのイベント取り込みサービスに
  #           イベントを送信するために使用するIAMロールARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 必要な権限:
  #   - mobileanalytics:PutEvents
  #   - mobileanalytics:PutItems
  # 注意: この属性は非推奨です。代わりにorchestration_sending_role_arnを使用してください。
  # 関連リソース: aws_iam_role
  role_arn = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Pinpointアプリケーション名（application_idと同じ）
#
# - messages_per_second: メールチャネルが1秒あたりに送信できるメッセージ数
#   注意:
#   - この値はAmazon SESの送信制限に基づいて決定されます
#   - SESの送信制限を増やす必要がある場合は、AWSサポートにリクエスト
#   - 参考: https://docs.aws.amazon.com/ses/latest/dg/manage-sending-quotas.html
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 以下は、Pinpointアプリケーション、SESドメイン検証、IAMロールを含む
# 完全な構成例です。

# Pinpointアプリケーションの作成
# resource "aws_pinpoint_app" "example" {
#   name = "example-pinpoint-app"
#
#   tags = {
#     Name        = "example-pinpoint-app"
#---------------------------------------------------------------
