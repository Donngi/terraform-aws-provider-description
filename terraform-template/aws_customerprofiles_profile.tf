#---------------------------------------------------------------
# AWS Customer Profiles Profile
#---------------------------------------------------------------
#
# Amazon Connect Customer Profilesのプロファイルを作成するリソースです。
# プロファイルはドメイン内の顧客に関するさまざまな属性を表す標準的な
# プロファイルを作成します。顧客の連絡先情報、住所、属性などを管理できます。
#
# AWS公式ドキュメント:
#   - CreateProfile API: https://docs.aws.amazon.com/customerprofiles/latest/APIReference/API_CreateProfile.html
#   - Customer Profiles概要: https://docs.aws.amazon.com/connect/latest/adminguide/customer-profiles.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customerprofiles_profile
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_customerprofiles_profile" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: Customer Profileドメインの名前を指定します。
  # 設定可能な値: AWSアカウント内で一意のドメイン名
  # 参考: 事前にaws_customerprofiles_domainリソースでドメインを作成する必要があります
  domain_name = "example-domain"

  #-------------------------------------------------------------
  # 識別子設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: プロファイルの識別子を指定します。
  # 設定可能な値: 文字列
  # 省略時: AWSが自動的に一意の識別子を生成します
  # 注意: 通常は省略してAWSに自動生成させることを推奨します
  id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # アカウント情報
  #-------------------------------------------------------------

  # account_number (Optional)
  # 設定内容: 顧客に付与した一意のアカウント番号を指定します。
  # 設定可能な値: 文字列
  # 用途: 顧客を識別するための独自のアカウント番号
  account_number = null

  #-------------------------------------------------------------
  # 基本情報
  #-------------------------------------------------------------

  # first_name (Optional)
  # 設定内容: 顧客の名（ファーストネーム）を指定します。
  # 設定可能な値: 文字列
  first_name = null

  # middle_name (Optional)
  # 設定内容: 顧客のミドルネームを指定します。
  # 設定可能な値: 文字列
  middle_name = null

  # last_name (Optional)
  # 設定内容: 顧客の姓（ラストネーム）を指定します。
  # 設定可能な値: 文字列
  last_name = null

  # birth_date (Optional)
  # 設定内容: 顧客の生年月日を指定します。
  # 設定可能な値: 文字列（日付形式）
  birth_date = null

  # gender_string (Optional)
  # 設定内容: 顧客が認識する性別を指定します。
  # 設定可能な値: 文字列
  gender_string = null

  #-------------------------------------------------------------
  # ビジネス情報
  #-------------------------------------------------------------

  # business_name (Optional)
  # 設定内容: 顧客のビジネス名（会社名）を指定します。
  # 設定可能な値: 文字列
  business_name = null

  # party_type_string (Optional)
  # 設定内容: 顧客を説明するために使用されるプロファイルのタイプを指定します。
  # 設定可能な値: 文字列（例: "INDIVIDUAL", "BUSINESS"など）
  party_type_string = null

  #-------------------------------------------------------------
  # 連絡先情報 - メールアドレス
  #-------------------------------------------------------------

  # email_address (Optional)
  # 設定内容: 顧客のメールアドレスを指定します（個人用またはビジネス用として指定されていないもの）。
  # 設定可能な値: 有効なメールアドレス形式の文字列
  email_address = null

  # personal_email_address (Optional)
  # 設定内容: 顧客の個人用メールアドレスを指定します。
  # 設定可能な値: 有効なメールアドレス形式の文字列
  personal_email_address = null

  # business_email_address (Optional)
  # 設定内容: 顧客のビジネス用メールアドレスを指定します。
  # 設定可能な値: 有効なメールアドレス形式の文字列
  business_email_address = null

  #-------------------------------------------------------------
  # 連絡先情報 - 電話番号
  #-------------------------------------------------------------

  # phone_number (Optional)
  # 設定内容: 顧客の電話番号を指定します（モバイル、自宅、ビジネスとして指定されていないもの）。
  # 設定可能な値: 電話番号形式の文字列
  phone_number = null

  # mobile_phone_number (Optional)
  # 設定内容: 顧客の携帯電話番号を指定します。
  # 設定可能な値: 電話番号形式の文字列
  mobile_phone_number = null

  # home_phone_number (Optional)
  # 設定内容: 顧客の自宅電話番号を指定します。
  # 設定可能な値: 電話番号形式の文字列
  home_phone_number = null

  # business_phone_number (Optional)
  # 設定内容: 顧客のビジネス用電話番号を指定します。
  # 設定可能な値: 電話番号形式の文字列
  business_phone_number = null

  #-------------------------------------------------------------
  # 追加情報
  #-------------------------------------------------------------

  # additional_information (Optional)
  # 設定内容: 顧客のプロファイルに関連する追加情報を指定します。
  # 設定可能な値: 文字列
  additional_information = null

  # attributes (Optional)
  # 設定内容: 顧客プロファイルの属性をキーと値のペアで指定します。
  # 設定可能な値: キーと値のペアのマップ（map(string)）
  # 用途: カスタム属性を追加する場合に使用
  attributes = null

  #-------------------------------------------------------------
  # 住所情報 - 一般住所
  #-------------------------------------------------------------

  # address (Optional)
  # 設定内容: 顧客に関連付けられた一般的な住所（郵送、配送、請求用ではない）を指定します。
  # 参考: 最大1つのaddressブロックを指定可能
  address {
    # address_1 (Optional)
    # 設定内容: 住所の1行目を指定します。
    # 設定可能な値: 文字列
    address_1 = null

    # address_2 (Optional)
    # 設定内容: 住所の2行目を指定します。
    # 設定可能な値: 文字列
    address_2 = null

    # address_3 (Optional)
    # 設定内容: 住所の3行目を指定します。
    # 設定可能な値: 文字列
    address_3 = null

    # address_4 (Optional)
    # 設定内容: 住所の4行目を指定します。
    # 設定可能な値: 文字列
    address_4 = null

    # city (Optional)
    # 設定内容: 顧客が住んでいる市区町村を指定します。
    # 設定可能な値: 文字列
    city = null

    # county (Optional)
    # 設定内容: 顧客が住んでいる郡を指定します。
    # 設定可能な値: 文字列
    county = null

    # state (Optional)
    # 設定内容: 顧客が住んでいる州を指定します。
    # 設定可能な値: 文字列
    state = null

    # province (Optional)
    # 設定内容: 顧客が住んでいる省を指定します。
    # 設定可能な値: 文字列
    province = null

    # country (Optional)
    # 設定内容: 顧客が住んでいる国を指定します。
    # 設定可能な値: 文字列（ISO国コード推奨）
    country = null

    # postal_code (Optional)
    # 設定内容: 顧客の住所の郵便番号を指定します。
    # 設定可能な値: 文字列
    postal_code = null
  }

  #-------------------------------------------------------------
  # 住所情報 - 郵送先住所
  #-------------------------------------------------------------

  # mailing_address (Optional)
  # 設定内容: 顧客の郵送先住所を指定します。
  # 参考: 最大1つのmailing_addressブロックを指定可能
  mailing_address {
    # address_1 (Optional)
    # 設定内容: 郵送先住所の1行目を指定します。
    # 設定可能な値: 文字列
    address_1 = null

    # address_2 (Optional)
    # 設定内容: 郵送先住所の2行目を指定します。
    # 設定可能な値: 文字列
    address_2 = null

    # address_3 (Optional)
    # 設定内容: 郵送先住所の3行目を指定します。
    # 設定可能な値: 文字列
    address_3 = null

    # address_4 (Optional)
    # 設定内容: 郵送先住所の4行目を指定します。
    # 設定可能な値: 文字列
    address_4 = null

    # city (Optional)
    # 設定内容: 郵送先住所の市区町村を指定します。
    # 設定可能な値: 文字列
    city = null

    # county (Optional)
    # 設定内容: 郵送先住所の郡を指定します。
    # 設定可能な値: 文字列
    county = null

    # state (Optional)
    # 設定内容: 郵送先住所の州を指定します。
    # 設定可能な値: 文字列
    state = null

    # province (Optional)
    # 設定内容: 郵送先住所の省を指定します。
    # 設定可能な値: 文字列
    province = null

    # country (Optional)
    # 設定内容: 郵送先住所の国を指定します。
    # 設定可能な値: 文字列（ISO国コード推奨）
    country = null

    # postal_code (Optional)
    # 設定内容: 郵送先住所の郵便番号を指定します。
    # 設定可能な値: 文字列
    postal_code = null
  }

  #-------------------------------------------------------------
  # 住所情報 - 配送先住所
  #-------------------------------------------------------------

  # shipping_address (Optional)
  # 設定内容: 顧客の配送先住所を指定します。
  # 参考: 最大1つのshipping_addressブロックを指定可能
  shipping_address {
    # address_1 (Optional)
    # 設定内容: 配送先住所の1行目を指定します。
    # 設定可能な値: 文字列
    address_1 = null

    # address_2 (Optional)
    # 設定内容: 配送先住所の2行目を指定します。
    # 設定可能な値: 文字列
    address_2 = null

    # address_3 (Optional)
    # 設定内容: 配送先住所の3行目を指定します。
    # 設定可能な値: 文字列
    address_3 = null

    # address_4 (Optional)
    # 設定内容: 配送先住所の4行目を指定します。
    # 設定可能な値: 文字列
    address_4 = null

    # city (Optional)
    # 設定内容: 配送先住所の市区町村を指定します。
    # 設定可能な値: 文字列
    city = null

    # county (Optional)
    # 設定内容: 配送先住所の郡を指定します。
    # 設定可能な値: 文字列
    county = null

    # state (Optional)
    # 設定内容: 配送先住所の州を指定します。
    # 設定可能な値: 文字列
    state = null

    # province (Optional)
    # 設定内容: 配送先住所の省を指定します。
    # 設定可能な値: 文字列
    province = null

    # country (Optional)
    # 設定内容: 配送先住所の国を指定します。
    # 設定可能な値: 文字列（ISO国コード推奨）
    country = null

    # postal_code (Optional)
    # 設定内容: 配送先住所の郵便番号を指定します。
    # 設定可能な値: 文字列
    postal_code = null
  }

  #-------------------------------------------------------------
  # 住所情報 - 請求先住所
  #-------------------------------------------------------------

  # billing_address (Optional)
  # 設定内容: 顧客の請求先住所を指定します。
  # 参考: 最大1つのbilling_addressブロックを指定可能
  billing_address {
    # address_1 (Optional)
    # 設定内容: 請求先住所の1行目を指定します。
    # 設定可能な値: 文字列
    address_1 = null

    # address_2 (Optional)
    # 設定内容: 請求先住所の2行目を指定します。
    # 設定可能な値: 文字列
    address_2 = null

    # address_3 (Optional)
    # 設定内容: 請求先住所の3行目を指定します。
    # 設定可能な値: 文字列
    address_3 = null

    # address_4 (Optional)
    # 設定内容: 請求先住所の4行目を指定します。
    # 設定可能な値: 文字列
    address_4 = null

    # city (Optional)
    # 設定内容: 請求先住所の市区町村を指定します。
    # 設定可能な値: 文字列
    city = null

    # county (Optional)
    # 設定内容: 請求先住所の郡を指定します。
    # 設定可能な値: 文字列
    county = null

    # state (Optional)
    # 設定内容: 請求先住所の州を指定します。
    # 設定可能な値: 文字列
    state = null

    # province (Optional)
    # 設定内容: 請求先住所の省を指定します。
    # 設定可能な値: 文字列
    province = null

    # country (Optional)
    # 設定内容: 請求先住所の国を指定します。
    # 設定可能な値: 文字列（ISO国コード推奨）
    country = null

    # postal_code (Optional)
    # 設定内容: 請求先住所の郵便番号を指定します。
    # 設定可能な値: 文字列
    postal_code = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Customer Profiles Profileの識別子
#---------------------------------------------------------------
