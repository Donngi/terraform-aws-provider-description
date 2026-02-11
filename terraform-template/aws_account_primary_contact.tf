#---------------------------------------------------------------
# AWS Account Primary Contact
#---------------------------------------------------------------
#
# AWS アカウントに関連付けられたプライマリ連絡先情報を管理するリソースです。
# プライマリ連絡先は、アカウントの主要な連絡先情報を定義します。
#
# AWS公式ドキュメント:
#   - Update the primary contact: https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-update-contact-primary.html
#   - ContactInformation API: https://docs.aws.amazon.com/accounts/latest/reference/API_ContactInformation.html
#   - PutContactInformation API: https://docs.aws.amazon.com/accounts/latest/reference/API_PutContactInformation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_primary_contact
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_account_primary_contact" "example" {
  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: メンバーアカウントを管理する際のターゲットアカウントのIDを指定します。
  # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  # 省略時: 現在のユーザーのアカウントを管理します
  # 用途: AWS Organizationsのメンバーアカウントの連絡先情報を管理する場合に使用
  account_id = null

  #-------------------------------------------------------------
  # 必須項目: 住所情報
  #-------------------------------------------------------------

  # address_line_1 (Required)
  # 設定内容: プライマリ連絡先住所の1行目を指定します。
  # 設定可能な値: 1-60文字の文字列
  # 関連機能: ContactInformation API
  #   - https://docs.aws.amazon.com/accounts/latest/reference/API_ContactInformation.html
  address_line_1 = "123 Any Street"

  # address_line_2 (Optional)
  # 設定内容: プライマリ連絡先住所の2行目を指定します。
  # 設定可能な値: 1-60文字の文字列
  # 省略時: 設定されません
  address_line_2 = null

  # address_line_3 (Optional)
  # 設定内容: プライマリ連絡先住所の3行目を指定します。
  # 設定可能な値: 1-60文字の文字列
  # 省略時: 設定されません
  address_line_3 = null

  # city (Required)
  # 設定内容: プライマリ連絡先住所の市区町村を指定します。
  # 設定可能な値: 1-50文字の文字列
  city = "Seattle"

  # country_code (Required)
  # 設定内容: プライマリ連絡先住所の国コードを指定します。
  # 設定可能な値: ISO-3166 2文字国コード（例: US, JP, GB）
  # 文字数: 固定長2文字
  # 参考: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
  country_code = "US"

  # district_or_county (Optional)
  # 設定内容: プライマリ連絡先住所の地区または郡を指定します。
  # 設定可能な値: 1-50文字の文字列
  # 省略時: 設定されません
  district_or_county = "King"

  # postal_code (Required)
  # 設定内容: プライマリ連絡先住所の郵便番号を指定します。
  # 設定可能な値: 1-20文字の文字列
  postal_code = "98101"

  # state_or_region (Optional)
  # 設定内容: プライマリ連絡先住所の州または地域を指定します。
  # 設定可能な値: 文字列（米国の場合は2文字の州コードまたは完全な州名）
  # 注意: 一部の国では必須となります
  # 関連機能: ContactInformation API
  #   米国のアドレスでは、2文字の州コード（例: WA）または完全な州名が使用可能。
  #   - https://docs.aws.amazon.com/accounts/latest/reference/API_ContactInformation.html
  state_or_region = "WA"

  #-------------------------------------------------------------
  # 必須項目: 連絡先情報
  #-------------------------------------------------------------

  # full_name (Required)
  # 設定内容: プライマリ連絡先のフルネームを指定します。
  # 設定可能な値: 1-50文字の文字列
  full_name = "My Name"

  # phone_number (Required)
  # 設定内容: プライマリ連絡先の電話番号を指定します。
  # 設定可能な値: 1-20文字、パターン: [+][\s0-9()-]+
  # 形式: 国コードから始まる必要があり、数字のみを含み、ハイフンやスペースを含まない
  # 注意: 番号は検証され、一部の国では有効化チェックが行われます
  # 関連機能: ContactInformation API
  #   電話番号は検証され、一部の国では有効化がチェックされます。
  #   - https://docs.aws.amazon.com/accounts/latest/reference/API_ContactInformation.html
  phone_number = "+64211111111"

  #-------------------------------------------------------------
  # オプション項目: 会社・ウェブサイト情報
  #-------------------------------------------------------------

  # company_name (Optional)
  # 設定内容: プライマリ連絡先情報に関連付ける会社名を指定します。
  # 設定可能な値: 1-50文字の文字列
  # 省略時: 設定されません
  company_name = "Example Corp, Inc."

  # website_url (Optional)
  # 設定内容: プライマリ連絡先情報に関連付けるウェブサイトのURLを指定します。
  # 設定可能な値: 1-256文字の文字列
  # 省略時: 設定されません
  website_url = "https://www.examplecorp.com"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アカウントID。設定されていない場合は現在のアカウントIDが使用されます。
#---------------------------------------------------------------
