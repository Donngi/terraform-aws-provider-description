#---------------------------------------------------------------
# AWS User Notifications Contacts Email Contact
#---------------------------------------------------------------
#
# AWS User Notifications Contacts のメール連絡先をプロビジョニングするリソースです。
# メール連絡先は、AWSからの通知（アクティベーションメール・サブスクリプションメール等）を
# 受信するメールアドレスを指定します。作成後にアクティベーションコードによる
# メールアドレスの有効化が必要です。有効化されたメール連絡先のみ通知を受信できます。
#
# AWS公式ドキュメント:
#   - AWS User Notifications Contacts APIリファレンス: https://docs.aws.amazon.com/notificationscontacts/latest/APIReference/index.html
#   - CreateEmailContact API: https://docs.aws.amazon.com/notificationscontacts/latest/APIReference/API_CreateEmailContact.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/notificationscontacts_email_contact
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_notificationscontacts_email_contact" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: メール連絡先の表示名を指定します。
  # 設定可能な値: 1〜64文字の文字列。英数字・アンダースコア・チルダ・ピリオド・ハイフンが使用可能
  name = "example-contact"

  # email_address (Required)
  # 設定内容: 通知先のメールアドレスを指定します。
  # 設定可能な値: 6〜254文字の有効なメールアドレス形式の文字列
  # 注意: 作成後にアクティベーションコードによる有効化が必要です。
  #       有効化されるまでステータスは "inactive" となり、通知メールは受信されません。
  # 参考: https://docs.aws.amazon.com/notificationscontacts/latest/APIReference/API_ActivateEmailContact.html
  email_address = "example@example.com"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-contact"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: メール連絡先のAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
