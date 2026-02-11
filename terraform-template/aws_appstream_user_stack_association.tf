#---------------------------------------------------------------
# AWS AppStream User Stack Association
#---------------------------------------------------------------
#
# Amazon AppStream 2.0のユーザーとスタックの関連付けを管理するリソースです。
# ユーザープール内のユーザーを特定のAppStreamスタックに関連付けることで、
# そのユーザーがスタック上のアプリケーションにアクセスできるようになります。
#
# AWS公式ドキュメント:
#   - AppStream 2.0 ユーザープール管理: https://docs.aws.amazon.com/appstream2/latest/developerguide/user-pool-admin.html
#   - UserStackAssociation API Reference: https://docs.aws.amazon.com/appstream2/latest/APIReference/API_UserStackAssociation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_user_stack_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appstream_user_stack_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # authentication_type (Required)
  # 設定内容: ユーザーの認証タイプを指定します。
  # 設定可能な値:
  #   - "API": APIベースの認証
  #   - "SAML": SAMLベースのフェデレーション認証
  #   - "USERPOOL": AppStreamユーザープールを使用した認証
  #   - "AWS_AD": AWS Managed Microsoft ADを使用した認証
  # 関連機能: AppStream 2.0 認証
  #   ユーザーがAppStreamスタックにアクセスする際の認証方式を決定します。
  #   - https://docs.aws.amazon.com/appstream2/latest/developerguide/user-pool-admin.html
  authentication_type = "USERPOOL"

  # stack_name (Required)
  # 設定内容: 関連付けるAppStreamスタックの名前を指定します。
  # 設定可能な値: 1文字以上の文字列（既存のスタック名）
  # 注意: 指定したスタックが存在している必要があります。
  stack_name = "example-stack"

  # user_name (Required)
  # 設定内容: 関連付けるユーザーの識別子を指定します。
  # 設定可能な値: 1-128文字の文字列
  # 注意: ユーザープール認証の場合はメールアドレス形式。
  #       ユーザーのメールアドレスは大文字と小文字が区別されます。
  user_name = "user@example.com"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # send_email_notification (Optional)
  # 設定内容: ユーザープールにユーザーが作成された後にウェルカムメールを
  #           送信するかどうかを指定します。
  # 設定可能な値:
  #   - true: ウェルカムメールを送信
  #   - false: ウェルカムメールを送信しない
  # 省略時: 送信されません
  # 注意: メールはno-reply@accounts.{aws-region}.amazonappstream.comから送信されます。
  #       ユーザーに届かない場合は、迷惑メールフォルダを確認するか、
  #       このアドレスを許可リストに追加してください。
  send_email_notification = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AppStreamユーザースタック関連付けの一意のID
#---------------------------------------------------------------
