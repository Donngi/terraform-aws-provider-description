#---------------------------------------------------------------
# AWS User Notifications Contacts Email Contact
#---------------------------------------------------------------
#
# AWS User Notifications Contacts のメール連絡先を管理するリソース。
# 通知の送信先となるメールアドレスを登録し、AWS サービスからの
# 通知（アクティベーションメール、サブスクリプションメールなど）を
# 受け取るための連絡先を設定する。
#
# 作成後、メールアドレスはアクティベーションが必要で、
# アクティブ状態になるまで通知を受信できない。
#
# AWS公式ドキュメント:
#   - AWS User Notifications Contacts API Reference: https://docs.aws.amazon.com/notificationscontacts/latest/APIReference/index.html
#   - CreateEmailContact API: https://docs.aws.amazon.com/notificationscontacts/latest/APIReference/API_CreateEmailContact.html
#   - EmailContact Data Type: https://docs.aws.amazon.com/notificationscontacts/latest/APIReference/API_EmailContact.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/notificationscontacts_email_contact
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_notificationscontacts_email_contact" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # name - (必須)
  # メール連絡先の名前。
  # 1～64文字で指定し、英数字、アンダースコア、チルダ、ピリオド、
  # ハイフンを使用可能。
  #
  # 例: "production-alerts", "ops_team_contact"
  name = ""

  # email_address - (必須)
  # 通知を受け取るメールアドレス。
  # 有効なメールアドレス形式で、6～254文字で指定。
  # 作成後、このアドレスにアクティベーションメールが送信され、
  # アクティベーションが完了するまで通知を受信できない。
  #
  # 例: "alerts@example.com"
  email_address = ""

  #---------------------------------------------------------------
  # 任意引数 (Optional Arguments)
  #---------------------------------------------------------------

  # tags - (任意)
  # リソースに割り当てるタグのマップ。
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーを持つタグはこちらで定義した値で上書きされる。
  #
  # 例:
  # tags = {
  #   Environment = "Production"
  #   Team        = "Operations"
  # }
  tags = {}
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能（設定不可）:
#
# arn - メール連絡先の Amazon Resource Name (ARN)。
#       形式: arn:aws:notificationscontacts:<region>:<account-id>:emailcontact/<id>
#
# tags_all - プロバイダーの default_tags で設定されたタグを含む、
#            リソースに割り当てられた全タグのマップ。
#
#---------------------------------------------------------------
