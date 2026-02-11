#---------------------------------------------------------------
# AWS Account Alternate Contact
#---------------------------------------------------------------
#
# AWSアカウントに関連付けられた代替連絡先をプロビジョニングするリソースです。
# 代替連絡先を設定することで、AWS側から請求、運用、セキュリティに関する
# 通知をルートユーザーのメールアドレスとは別の連絡先に送信できます。
#
# AWS公式ドキュメント:
#   - 代替連絡先の更新: https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-update-contact-alternate.html
#   - AlternateContact API: https://docs.aws.amazon.com/accounts/latest/reference/API_AlternateContact.html
#   - PutAlternateContact API: https://docs.aws.amazon.com/accounts/latest/reference/API_PutAlternateContact.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_account_alternate_contact" "example" {
  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: メンバーアカウントを管理する際のターゲットアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 現在のユーザーのアカウントをデフォルトで管理します。
  # 用途: AWS Organizations環境で管理アカウントまたは委任管理者アカウントから
  #       メンバーアカウントの代替連絡先を一元管理する場合に使用します。
  # 参考: https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-update-contact-alternate.html
  account_id = null

  #-------------------------------------------------------------
  # 連絡先タイプ設定 (Required)
  #-------------------------------------------------------------

  # alternate_contact_type (Required)
  # 設定内容: 代替連絡先のタイプを指定します。
  # 設定可能な値:
  #   - "BILLING": 請求関連の通知を受け取る連絡先
  #   - "OPERATIONS": 運用関連の通知を受け取る連絡先
  #   - "SECURITY": セキュリティ関連の通知を受け取る連絡先
  # 関連機能: AWS Account Alternate Contacts
  #   AWSアカウントに最大3つの代替連絡先（請求、運用、セキュリティ用）を
  #   設定することで、ルートユーザーに加えて個人またはメール配信リストに
  #   通知を送信できます。
  #   - https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-update-contact-alternate.html
  alternate_contact_type = "OPERATIONS"

  #-------------------------------------------------------------
  # 連絡先情報 (Required)
  #-------------------------------------------------------------

  # email_address (Required)
  # 設定内容: 代替連絡先のメールアドレスを指定します。
  # 設定可能な値: 有効なメールアドレス形式の文字列
  # 推奨事項: 個人のメールアドレスではなく、メール配信リスト（例: ops-team@example.com）を
  #           使用することで、特定の個人への依存を避けることができます。
  # 参考: https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-update-contact-alternate.html
  email_address = "ops-team@example.com"

  # name (Required)
  # 設定内容: 代替連絡先の名前を指定します。
  # 設定可能な値: 文字列（個人名またはチーム名）
  # 文字制限: 詳細は公式ドキュメントを参照してください
  name = "Operations Team"

  # phone_number (Required)
  # 設定内容: 代替連絡先の電話番号を指定します。
  # 設定可能な値: 国際電話番号形式（例: +1234567890）
  # 文字制限: 使用可能な特殊文字や文字数制限の詳細は公式ドキュメントを参照してください
  # 参考: https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-update-contact-alternate.html
  phone_number = "+1234567890"

  # title (Required)
  # 設定内容: 代替連絡先の役職またはタイトルを指定します。
  # 設定可能な値: 文字列（例: "Operations Manager", "Security Lead"）
  # 文字制限: 詳細は公式ドキュメントを参照してください
  title = "Operations Manager"

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間を設定します。
  # 用途: デフォルトのタイムアウト時間を変更する必要がある場合に使用します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    create = null

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    update = null

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 代替連絡先の識別子
#       形式: {account_id}/{alternate_contact_type}
#---------------------------------------------------------------
