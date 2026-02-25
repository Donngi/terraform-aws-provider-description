#---------------------------------------------------------------
# Amazon SES Email Identity
#---------------------------------------------------------------
#
# Amazon Simple Email Service (SES) のメールアドレスアイデンティティを作成・管理するリソースです。
# SESからメールを送信するには、送信元のメールアドレスまたはドメインの所有権を検証する必要があります。
# このリソースを使用することで、特定のメールアドレスをSESで使用可能にし、
# そのアドレスからメールを送信できるようになります。
#
# 主な機能:
#   - 個別のメールアドレスをSESのアイデンティティとして登録
#   - 指定したメールアドレスへ確認メールを送信して所有権を検証
#   - 特定のリージョンでメールアドレスアイデンティティを管理
#
# AWS公式ドキュメント:
#   - SES メールアドレスアイデンティティの検証: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-email-addresses.html
#   - SES アイデンティティ管理: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-addresses-and-domains.html
#   - SES API リファレンス: https://docs.aws.amazon.com/ses/latest/APIReference/API_VerifyEmailIdentity.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_email_identity
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_email_identity" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # email (Required)
  # 設定内容: SESに登録するメールアドレスを指定します。
  # 設定可能な値: 有効なメールアドレス形式の文字列。例: user@example.com
  # 用途: SESでメールを送信するために検証するメールアドレスを指定
  # 注意事項:
  #   - 指定したメールアドレス宛に確認メールが送信されます
  #   - メールアドレスの所有者がリンクをクリックするまで検証が完了しません
  #   - 一度作成したアイデンティティのメールアドレスは変更できません（再作成が必要）
  # 関連機能: SES メールアドレスアイデンティティ検証
  #   メールアドレス所有権を証明することで、そのアドレスからメールを送信可能になります。
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-email-address-procedure.html
  email = "user@example.com"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1, eu-west-1)
  # 省略時: プロバイダー設定で指定されたリージョンを使用
  # 用途: 複数リージョンでSESを使用する場合に明示的にリージョンを指定
  # 注意事項:
  #   - SESはリージョンごとに独立して動作するため、使用するリージョンごとに検証が必要です
  #   - SESが提供されていないリージョンを指定した場合はエラーになります
  # 関連機能: SES リージョン管理
  #   各リージョンで個別にメールアドレスアイデンティティを設定する必要があります。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: メールアドレスアイデンティティのAmazon Resource Name (ARN)
#   例: arn:aws:ses:us-east-1:123456789012:identity/user@example.com
#
#---------------------------------------------------------------
