#---------------------------------------------------------------
# SES Email Template
#---------------------------------------------------------------
#
# Amazon SES（Simple Email Service）のメールテンプレートをプロビジョニングします。
# メールテンプレートを使用すると、パーソナライズされたメールを複数の宛先に
# 効率的に送信できます。テンプレートには件名、HTML本文、テキスト本文を定義し、
# {{変数名}}形式のプレースホルダーを使用して動的コンテンツを挿入できます。
#
# AWS公式ドキュメント:
#   - CreateEmailTemplate API: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_CreateEmailTemplate.html
#   - テンプレートを使用したメール送信: https://docs.aws.amazon.com/ses/latest/dg/send-personalized-email-api.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ses_template
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_template" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # テンプレート名
  # メール送信時にこの名前を参照します。
  # 最大64文字まで指定可能です。
  name = "MyTemplate"


  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # HTML本文
  # HTMLをサポートするメールクライアント向けのメール本文です。
  # テキスト部分とHTML部分を合わせて500KB未満である必要があります。
  # {{変数名}}形式のプレースホルダーを使用して動的コンテンツを挿入できます。
  # 例: "<h1>Hello {{name}},</h1><p>Your favorite animal is {{favoriteanimal}}.</p>"
  html = "<h1>Hello {{name}},</h1><p>Your favorite animal is {{favoriteanimal}}.</p>"

  # メールの件名
  # メールの件名行を指定します。
  # {{変数名}}形式のプレースホルダーを使用して動的コンテンツを挿入できます。
  # 例: "Greetings, {{name}}!"
  subject = "Greetings, {{name}}!"

  # テキスト本文
  # HTMLを表示しないメールクライアント向けのメール本文です。
  # テキスト部分とHTML部分を合わせて500KB未満である必要があります。
  # {{変数名}}形式のプレースホルダーを使用して動的コンテンツを挿入できます。
  # 例: "Hello {{name}},\r\nYour favorite animal is {{favoriteanimal}}."
  text = "Hello {{name}},\\r\\nYour favorite animal is {{favoriteanimal}}."

  # リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # リソースID
  # Terraformが管理するリソースの一意の識別子です。
  # 通常は指定不要で、Terraformが自動的に設定します（テンプレート名と同じ値になります）。
  # 明示的に指定することも可能ですが、一般的には省略します。
  # id = "MyTemplate"
}


#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（読み取り専用）:
#
# - arn    : SESテンプレートのARN（Amazon Resource Name）
# - id     : SESテンプレートのID（テンプレート名と同じ値）
#
# 使用例:
# output "ses_template_arn" {
#   value = aws_ses_template.example.arn
# }
#---------------------------------------------------------------
