#---------------------------------------------------------------
# AWS Pinpoint Email Template
#---------------------------------------------------------------
#
# Amazon Pinpointのメールテンプレートを定義するリソースです。
# メールメッセージの送信に再利用可能なコンテンツと設定を保存できます。
# メールのテンプレートパーツには、件名、メッセージ本文（HTMLまたはテキスト）、
# カスタムヘッダーなどが含まれます。
#
# AWS公式ドキュメント:
#   - Email Template API: https://docs.aws.amazon.com/pinpoint/latest/apireference/templates-template-name-email.html
#   - メールテンプレートの作成: https://docs.aws.amazon.com/pinpoint/latest/userguide/message-templates-creating-email.html
#   - Pinpoint Email Service Template: https://docs.aws.amazon.com/pinpoint-email/latest/APIReference/API_Template.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_email_template
#
# Provider Version: 6.28.0
# Generated: 2025-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pinpoint_email_template" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # template_name (Required)
  # 設定内容: メッセージテンプレートの名前を指定します。
  # 設定可能な値: 英数字、アンダースコア(_)、ハイフン(-)を含む最大128文字の文字列
  # 注意: テンプレート名は英数字で開始する必要があり、大文字小文字を区別します。
  #       作成後に変更すると、リソースの再作成が必要になります。
  template_name = "my-email-template"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: テンプレートはリージョン固有のリソースです。
  #       Pinpointアプリケーションと同じリージョンに作成する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: 2023年5月22日以降、tagsは更新操作で非推奨となっています。
  #       この日付以降、tagsの値は処理されずエラーコードも返されません。
  #       プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-email-template"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # email_template ブロック (Required)
  #-------------------------------------------------------------
  # メールチャネル経由で送信されるメッセージに使用できる
  # メッセージテンプレートのコンテンツと設定を指定します。

  email_template {
    # subject (Optional)
    # 設定内容: メッセージテンプレートに基づくメールメッセージで使用する件名を指定します。
    # 設定可能な値: 文字列
    # 注意: メッセージ変数を含めることができます（例: {{.Name}}）
    #       モバイル表示を考慮して50文字以下に保つことを推奨します。
    subject = "Welcome {{.Name}}, check out our latest offers!"

    # html_part (Optional)
    # 設定内容: メッセージテンプレートに基づくメールメッセージで使用する
    #           HTML形式のメッセージ本文を指定します。
    # 設定可能な値: HTML形式の文字列
    # 推奨: HTMLコンテンツをレンダリングするメールクライアント向けにHTML形式を使用することを推奨します。
    #       HTMLメッセージには、リンク、書式付きテキストなどを含めることができます。
    # header ブロック (Optional, 複数指定可能)
    #-------------------------------------------------------------
    # メールのメッセージヘッダーのリストを定義します。
    # 最大15個のヘッダーを設定できます。
    # 用途: トラッキング、ルーティング、カスタムメタデータに使用します。
    # 参考: https://docs.aws.amazon.com/pinpoint/latest/apireference/templates-template-name-email.html#templates-template-name-email-model-messageheader

    # カスタムヘッダーの例1: X-Entity-Ref-ID
    header {
      # name (Optional)
      # 設定内容: メッセージヘッダーの名前を指定します。
      # 設定可能な値: 最大126文字のヘッダー名文字列
      # 注意: カスタムヘッダーには通常X-プレフィックスを使用します。
      name = "X-Entity-Ref-ID"

      # value (Optional)
      # 設定内容: メッセージヘッダーの値を指定します。
      # 設定可能な値: 最大870文字のヘッダー値文字列
      # 注意: レンダリングされた属性の長さを含みます。
      #       例えば、{CreationDate}属性を追加すると、YYYY-MM-DDTHH:MM:SS.SSSZとして
      #       レンダリングされ、長さは24文字になります。
      #       メッセージ変数を使用できます。
      value = "{{.EntityId}}"
    }

    # カスタムヘッダーの例2: X-SES-CONFIGURATION-SET
    # Amazon SES設定セットを指定するために使用します。
    header {
      name  = "X-SES-CONFIGURATION-SET"
      value = "my-configuration-set"
    }

    # カスタムヘッダーの例3: List-Unsubscribe（購読解除リンク）
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: メッセージテンプレートのAmazon Resource Name (ARN)
#        形式: arn:aws:mobiletargeting:region:account-id:templates/template-name/EMAIL
#
# - id: テンプレート名
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------

# 例1: シンプルなテキストのみのメールテンプレート
# resource "aws_pinpoint_email_template" "simple" {
#   template_name = "simple-notification"
#
#   email_template {
#     subject   = "Notification"
#     text_part = "This is a simple notification message."
#   }
# }
#---------------------------------------------------------------

# メッセージ変数:
# - subject、html_part、text_partで{{.VariableName}}構文を使用します
# - 変数はメッセージ送信時に上書き可能です
# - default_substitutionsで定義されたデフォルト値がフォールバックとして使用されます
# - 変数名は大文字小文字を区別します

# メールコンテンツのベストプラクティス:
# - より良い互換性のために、常にhtml_partとtext_partの両方を提供してください
# - 異なるメールクライアントでのメール表示をテストしてください
# - スパムフィルターを回避するためにHTMLをシンプルに保ってください
# - HTMLスタイリングにはインラインCSSを使用してください
# - モバイル表示のために件名を簡潔に保ってください（50文字以下）

# ヘッダー:
# - テンプレートごとに最大15個のヘッダーが許可されます
# - ヘッダーはトラッキングとカテゴリ化に便利です
# - カスタムヘッダー（X-*）は標準的なメールヘッダーと干渉しません
# - レンダリングされた属性を使用する際はヘッダー値の長さに注意してください

# テンプレート管理:
# - テンプレート名は作成後に変更できません（変更すると再作成が必要）
# - テンプレートを削除しても、以前に送信されたメッセージには影響しません
# - テンプレートはPinpointキャンペーンとジャーニーで参照できます
# - 頻繁に更新する場合は、テンプレート名にバージョニング戦略を検討してください

# リージョンに関する考慮事項:
# - テンプレートはリージョン固有です
# - Pinpointアプリケーションと同じリージョンに存在する必要があります
# - リージョンを明示的に設定するにはregionパラメータを使用してください
# - クロスリージョンのテンプレートレプリケーションには別のリソースが必要です

# タグに関する注意:
# - tags引数は2023年5月22日時点で非推奨となっています
# - 一貫したタグ付けにはプロバイダーレベルのdefault_tagsを使用してください
# - 非推奨化前に作成されたテンプレートの既存のタグは変更されません
# - tagsを提供してもエラーは返されませんが、処理されません
