#---------------------------------------------------------------
# AWS Simple Email Service (SES) Template
#---------------------------------------------------------------
#
# AWS SES Template リソースです。
# SES Template は、HTMLおよびテキスト形式のメール本文と件名を
# テンプレートとして定義し、SendTemplatedEmail API から再利用するための
# リソースです。Handlebars 構文で変数を埋め込むことができます。
#
# 主な機能:
#   - HTMLメール本文のテンプレート定義
#   - テキストメール本文のテンプレート定義
#   - 件名のテンプレート定義
#   - Handlebars 変数置換によるパーソナライズ
#
# AWS公式ドキュメント:
#   - SES テンプレート概要: https://docs.aws.amazon.com/ses/latest/dg/send-personalized-email-api.html
#   - CreateTemplate API: https://docs.aws.amazon.com/ses/latest/APIReference/API_CreateTemplate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_template
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_template" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: テンプレートの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列 (最大64文字)
  # 制約: 同一リージョン内で一意である必要があります。
  #       一度作成すると変更できません (変更すると再作成されます)
  # 関連機能: SendTemplatedEmail API でテンプレートを指定する際に使用
  #   - https://docs.aws.amazon.com/ses/latest/APIReference/API_SendTemplatedEmail.html
  name = "example-ses-template"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: SES リージョナルエンドポイント
  #   SES はリージョンごとにエンドポイントが異なります。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#ses_region
  region = null

  #-------------------------------------------------------------
  # メール件名
  #-------------------------------------------------------------

  # subject (Optional)
  # 設定内容: メールの件名テンプレートを指定します。
  # 設定可能な値: 任意の文字列。Handlebars 構文で変数を埋め込み可能
  # 省略時: 件名なし
  # 例: "{{name}}様、ご注文の確認"
  # 関連機能: SES テンプレートパーソナライズ
  #   受信者ごとに変数を置換してパーソナライズされた件名を生成。
  #   - https://docs.aws.amazon.com/ses/latest/dg/send-personalized-email-api.html
  subject = "こんにちは、{{name}}さん"

  #-------------------------------------------------------------
  # HTMLメール本文
  #-------------------------------------------------------------

  # html (Optional)
  # 設定内容: HTMLメール本文のテンプレートを指定します。
  # 設定可能な値: 有効なHTML文字列。Handlebars 構文で変数を埋め込み可能
  # 省略時: HTMLパートなし (テキストのみのメールになります)
  # 注意: html または text のどちらか少なくとも一方を指定する必要があります
  # 例: "<h1>{{name}}様へ</h1><p>お知らせがあります。</p>"
  # 関連機能: SES HTMLメール
  #   HTML対応のメールクライアントに対してリッチなコンテンツを送信。
  #   - https://docs.aws.amazon.com/ses/latest/dg/send-personalized-email-api.html
  html = "<h1>こんにちは、{{name}}さん</h1><p>このメールはテンプレートから送信されました。</p>"

  #-------------------------------------------------------------
  # テキストメール本文
  #-------------------------------------------------------------

  # text (Optional)
  # 設定内容: テキスト形式のメール本文テンプレートを指定します。
  # 設定可能な値: 任意のプレーンテキスト文字列。Handlebars 構文で変数を埋め込み可能
  # 省略時: テキストパートなし (HTMLのみのメールになります)
  # 注意: html または text のどちらか少なくとも一方を指定する必要があります
  # 例: "{{name}}様へ\n\nお知らせがあります。"
  # 関連機能: SES テキストメール
  #   HTMLを表示できないメールクライアントへのフォールバックとして機能。
  #   - https://docs.aws.amazon.com/ses/latest/dg/send-personalized-email-api.html
  text = "こんにちは、{{name}}さん\n\nこのメールはテンプレートから送信されました。"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: SES Template の Amazon Resource Name (ARN)
#   形式: arn:aws:ses:region:account-id:template/name
#
# - id: SES Template の名前
#   通常は name 属性と同じ値
#
#---------------------------------------------------------------
