#---------------------------------------------------------------
# Amazon Route 53 Domains 登録済みドメイン
#---------------------------------------------------------------
#
# Route 53 Domainsサービスで登録済みのドメインをTerraformで管理するリソースです。
# 既存の登録済みドメインをTerraform管理下に取り込んで、連絡先情報・
# ネームサーバー・自動更新・転送ロックなどの設定を宣言的に管理できます。
# 新規ドメイン登録はAWSコンソール等で行い、その後このリソースでインポートして管理します。
#
# AWS公式ドキュメント:
#   - Route 53 Domainsの概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/registrar.html
#   - ドメイン連絡先情報の更新: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-update-contacts.html
#   - ドメインのネームサーバー変更: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-name-servers-glue-records.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53domains_registered_domain
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53domains_registered_domain" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: 管理対象の登録済みドメイン名を指定します。
  # 設定可能な値: 完全修飾ドメイン名（例: example.com）
  # 注意: このリソースは新規ドメイン登録には使用できません。
  #       AWSコンソールまたはAPIで登録済みのドメインを管理するためのリソースです。
  domain_name = "example.com"

  #-------------------------------------------------------------
  # 自動更新・転送ロック設定
  #-------------------------------------------------------------

  # auto_renew (Optional)
  # 設定内容: ドメインの有効期限が近づいた際に自動的に更新するかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 有効期限前に自動更新を実行
  #   - false: 自動更新を無効化（手動更新が必要）
  # 省略時: true が設定されます。
  # 注意: 自動更新を無効にすると、ドメインが期限切れになる場合があります。
  auto_renew = true

  # transfer_lock (Optional)
  # 設定内容: ドメインの不正転送を防ぐ転送ロックを有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 転送ロックを有効化（推奨）
  #   - false: 転送ロックを無効化
  # 省略時: true が設定されます。
  # 注意: セキュリティ上の理由から、特別な理由がない限りtrue推奨です。
  #       転送を行う場合は一時的にfalseに設定し、完了後にtrueへ戻してください。
  transfer_lock = true

  #-------------------------------------------------------------
  # プライバシー保護設定
  #-------------------------------------------------------------

  # admin_privacy (Optional)
  # 設定内容: 管理者連絡先情報のWHOISプライバシー保護を有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): WHOIS情報を非公開にする
  #   - false: WHOIS情報を公開する
  # 省略時: true が設定されます。
  admin_privacy = true

  # billing_privacy (Optional)
  # 設定内容: 請求担当者連絡先情報のWHOISプライバシー保護を有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): WHOIS情報を非公開にする
  #   - false: WHOIS情報を公開する
  # 省略時: true が設定されます。
  billing_privacy = true

  # registrant_privacy (Optional)
  # 設定内容: 登録者連絡先情報のWHOISプライバシー保護を有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): WHOIS情報を非公開にする
  #   - false: WHOIS情報を公開する
  # 省略時: true が設定されます。
  registrant_privacy = true

  # tech_privacy (Optional)
  # 設定内容: 技術担当者連絡先情報のWHOISプライバシー保護を有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): WHOIS情報を非公開にする
  #   - false: WHOIS情報を公開する
  # 省略時: true が設定されます。
  tech_privacy = true

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: ドメインリソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されません。
  tags = {
    Name        = "example-domain"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # 管理者連絡先設定
  #-------------------------------------------------------------

  # admin_contact (Optional)
  # 設定内容: ドメインの管理者連絡先情報を指定します。
  # 注意: 省略した場合、既存の登録済み連絡先情報が引き継がれます。
  #       連絡先情報の変更はドメインレジストラへの申請が必要になる場合があります。
  admin_contact {
    # first_name (Optional)
    # 設定内容: 管理者の名（ファーストネーム）を指定します。
    # 設定可能な値: 任意の文字列
    first_name = "John"

    # last_name (Optional)
    # 設定内容: 管理者の姓（ラストネーム）を指定します。
    # 設定可能な値: 任意の文字列
    last_name = "Doe"

    # organization_name (Optional)
    # 設定内容: 管理者の所属組織名を指定します。
    # 設定可能な値: 任意の文字列
    organization_name = "Example Corp"

    # email (Optional)
    # 設定内容: 管理者のメールアドレスを指定します。
    # 設定可能な値: 有効なメールアドレス形式の文字列
    email = "admin@example.com"

    # phone_number (Optional)
    # 設定内容: 管理者の電話番号を指定します。
    # 設定可能な値: 国際電話番号形式（例: +81.312345678）
    phone_number = "+1.4085551234"

    # fax (Optional)
    # 設定内容: 管理者のFAX番号を指定します。
    # 設定可能な値: 国際電話番号形式（例: +81.312345678）
    fax = null

    # contact_type (Optional)
    # 設定内容: 管理者の連絡先種別を指定します。
    # 設定可能な値:
    #   - "PERSON": 個人
    #   - "COMPANY": 会社
    #   - "ASSOCIATION": 団体
    #   - "PUBLIC_BODY": 公共機関
    #   - "RESELLER": リセラー
    contact_type = "COMPANY"

    # address_line_1 (Optional)
    # 設定内容: 管理者の住所（1行目）を指定します。
    # 設定可能な値: 任意の文字列
    address_line_1 = "123 Main Street"

    # address_line_2 (Optional)
    # 設定内容: 管理者の住所（2行目）を指定します。
    # 設定可能な値: 任意の文字列（アパート番号・フロアなど）
    address_line_2 = null

    # city (Optional)
    # 設定内容: 管理者の所在都市名を指定します。
    # 設定可能な値: 任意の文字列
    city = "San Francisco"

    # state (Optional)
    # 設定内容: 管理者の所在州・都道府県を指定します。
    # 設定可能な値: 州コードまたは都道府県名（例: CA, Tokyo）
    state = "CA"

    # zip_code (Optional)
    # 設定内容: 管理者の郵便番号を指定します。
    # 設定可能な値: 任意の文字列
    zip_code = "94105"

    # country_code (Optional)
    # 設定内容: 管理者の所在国コードを指定します。
    # 設定可能な値: ISO 3166-1 alpha-2形式の国コード（例: US, JP, GB）
    #   - https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html
    country_code = "US"

    # extra_params (Optional)
    # 設定内容: TLDによっては必須となる追加パラメータのマップを指定します。
    # 設定可能な値: キーと値のペアのマップ
    # 省略時: 追加パラメータなし
    # 注意: 一部のTLD（.ca, .uk等）では法的な登録に追加情報が必要な場合があります。
    #   - https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ExtraParam.html
    extra_params = {}
  }

  #-------------------------------------------------------------
  # 請求担当者連絡先設定
  #-------------------------------------------------------------

  # billing_contact (Optional)
  # 設定内容: ドメインの請求担当者連絡先情報を指定します。
  # 省略時: 既存の登録済み連絡先情報が引き継がれます。
  billing_contact {
    # first_name (Optional)
    # 設定内容: 請求担当者の名（ファーストネーム）を指定します。
    first_name = "John"

    # last_name (Optional)
    # 設定内容: 請求担当者の姓（ラストネーム）を指定します。
    last_name = "Doe"

    # organization_name (Optional)
    # 設定内容: 請求担当者の所属組織名を指定します。
    organization_name = "Example Corp"

    # email (Optional)
    # 設定内容: 請求担当者のメールアドレスを指定します。
    email = "billing@example.com"

    # phone_number (Optional)
    # 設定内容: 請求担当者の電話番号を指定します。
    # 設定可能な値: 国際電話番号形式（例: +81.312345678）
    phone_number = "+1.4085551234"

    # fax (Optional)
    # 設定内容: 請求担当者のFAX番号を指定します。
    fax = null

    # contact_type (Optional)
    # 設定内容: 請求担当者の連絡先種別を指定します。
    # 設定可能な値: PERSON / COMPANY / ASSOCIATION / PUBLIC_BODY / RESELLER
    contact_type = "COMPANY"

    # address_line_1 (Optional)
    # 設定内容: 請求担当者の住所（1行目）を指定します。
    address_line_1 = "123 Main Street"

    # address_line_2 (Optional)
    # 設定内容: 請求担当者の住所（2行目）を指定します。
    address_line_2 = null

    # city (Optional)
    # 設定内容: 請求担当者の所在都市名を指定します。
    city = "San Francisco"

    # state (Optional)
    # 設定内容: 請求担当者の所在州・都道府県を指定します。
    state = "CA"

    # zip_code (Optional)
    # 設定内容: 請求担当者の郵便番号を指定します。
    zip_code = "94105"

    # country_code (Optional)
    # 設定内容: 請求担当者の所在国コードを指定します。
    # 設定可能な値: ISO 3166-1 alpha-2形式の国コード（例: US, JP, GB）
    country_code = "US"

    # extra_params (Optional)
    # 設定内容: TLDによっては必須となる追加パラメータのマップを指定します。
    extra_params = {}
  }

  #-------------------------------------------------------------
  # 登録者連絡先設定
  #-------------------------------------------------------------

  # registrant_contact (Optional)
  # 設定内容: ドメインの登録者連絡先情報を指定します。
  # 省略時: 既存の登録済み連絡先情報が引き継がれます。
  # 注意: 登録者情報の変更はレジストラへの確認メールが送信される場合があります。
  registrant_contact {
    # first_name (Optional)
    # 設定内容: 登録者の名（ファーストネーム）を指定します。
    first_name = "John"

    # last_name (Optional)
    # 設定内容: 登録者の姓（ラストネーム）を指定します。
    last_name = "Doe"

    # organization_name (Optional)
    # 設定内容: 登録者の所属組織名を指定します。
    organization_name = "Example Corp"

    # email (Optional)
    # 設定内容: 登録者のメールアドレスを指定します。
    email = "registrant@example.com"

    # phone_number (Optional)
    # 設定内容: 登録者の電話番号を指定します。
    # 設定可能な値: 国際電話番号形式（例: +81.312345678）
    phone_number = "+1.4085551234"

    # fax (Optional)
    # 設定内容: 登録者のFAX番号を指定します。
    fax = null

    # contact_type (Optional)
    # 設定内容: 登録者の連絡先種別を指定します。
    # 設定可能な値: PERSON / COMPANY / ASSOCIATION / PUBLIC_BODY / RESELLER
    contact_type = "COMPANY"

    # address_line_1 (Optional)
    # 設定内容: 登録者の住所（1行目）を指定します。
    address_line_1 = "123 Main Street"

    # address_line_2 (Optional)
    # 設定内容: 登録者の住所（2行目）を指定します。
    address_line_2 = null

    # city (Optional)
    # 設定内容: 登録者の所在都市名を指定します。
    city = "San Francisco"

    # state (Optional)
    # 設定内容: 登録者の所在州・都道府県を指定します。
    state = "CA"

    # zip_code (Optional)
    # 設定内容: 登録者の郵便番号を指定します。
    zip_code = "94105"

    # country_code (Optional)
    # 設定内容: 登録者の所在国コードを指定します。
    # 設定可能な値: ISO 3166-1 alpha-2形式の国コード（例: US, JP, GB）
    country_code = "US"

    # extra_params (Optional)
    # 設定内容: TLDによっては必須となる追加パラメータのマップを指定します。
    extra_params = {}
  }

  #-------------------------------------------------------------
  # 技術担当者連絡先設定
  #-------------------------------------------------------------

  # tech_contact (Optional)
  # 設定内容: ドメインの技術担当者連絡先情報を指定します。
  # 省略時: 既存の登録済み連絡先情報が引き継がれます。
  tech_contact {
    # first_name (Optional)
    # 設定内容: 技術担当者の名（ファーストネーム）を指定します。
    first_name = "Jane"

    # last_name (Optional)
    # 設定内容: 技術担当者の姓（ラストネーム）を指定します。
    last_name = "Doe"

    # organization_name (Optional)
    # 設定内容: 技術担当者の所属組織名を指定します。
    organization_name = "Example Corp"

    # email (Optional)
    # 設定内容: 技術担当者のメールアドレスを指定します。
    email = "tech@example.com"

    # phone_number (Optional)
    # 設定内容: 技術担当者の電話番号を指定します。
    # 設定可能な値: 国際電話番号形式（例: +81.312345678）
    phone_number = "+1.4085551234"

    # fax (Optional)
    # 設定内容: 技術担当者のFAX番号を指定します。
    fax = null

    # contact_type (Optional)
    # 設定内容: 技術担当者の連絡先種別を指定します。
    # 設定可能な値: PERSON / COMPANY / ASSOCIATION / PUBLIC_BODY / RESELLER
    contact_type = "COMPANY"

    # address_line_1 (Optional)
    # 設定内容: 技術担当者の住所（1行目）を指定します。
    address_line_1 = "123 Main Street"

    # address_line_2 (Optional)
    # 設定内容: 技術担当者の住所（2行目）を指定します。
    address_line_2 = null

    # city (Optional)
    # 設定内容: 技術担当者の所在都市名を指定します。
    city = "San Francisco"

    # state (Optional)
    # 設定内容: 技術担当者の所在州・都道府県を指定します。
    state = "CA"

    # zip_code (Optional)
    # 設定内容: 技術担当者の郵便番号を指定します。
    zip_code = "94105"

    # country_code (Optional)
    # 設定内容: 技術担当者の所在国コードを指定します。
    # 設定可能な値: ISO 3166-1 alpha-2形式の国コード（例: US, JP, GB）
    country_code = "US"

    # extra_params (Optional)
    # 設定内容: TLDによっては必須となる追加パラメータのマップを指定します。
    extra_params = {}
  }

  #-------------------------------------------------------------
  # ネームサーバー設定
  #-------------------------------------------------------------

  # name_server (Optional)
  # 設定内容: ドメインに割り当てるネームサーバーを指定します。
  # 省略時: 既存のネームサーバー設定が引き継がれます。
  # 注意: 最大6つのname_serverブロックを設定可能です。
  #       ネームサーバー変更後、DNS伝播には最大48時間かかる場合があります。
  name_server {
    # name (Required)
    # 設定内容: ネームサーバーのFQDNを指定します。
    # 設定可能な値: 完全修飾ドメイン名（例: ns-1.awsdns-01.org）
    name = "ns-1.awsdns-01.org"

    # glue_ips (Optional)
    # 設定内容: グルーレコードとして設定するIPアドレスのセットを指定します。
    # 設定可能な値: IPアドレス（IPv4またはIPv6）のセット
    # 省略時: グルーレコードなし
    # 注意: ネームサーバーがドメイン自身のサブドメインである場合（例: ns1.example.com）に
    #       グルーレコードの設定が必要です。
    glue_ips = []
  }

  name_server {
    # name (Required)
    # 設定内容: ネームサーバーのFQDNを指定します。
    name = "ns-2.awsdns-02.co.uk"

    # glue_ips (Optional)
    # 設定内容: グルーレコードとして設定するIPアドレスのセットを指定します。
    glue_ips = []
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 用途: デフォルトのタイムアウト時間では不十分な場合に調整します。
  timeouts {
    # create (Optional)
    # 設定内容: ドメインリソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    create = null

    # update (Optional)
    # 設定内容: ドメインリソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 登録済みドメイン名（domain_nameと同値）
# - abuse_contact_email: 不正利用の報告先メールアドレス（IANAが定義）
# - abuse_contact_phone: 不正利用の報告先電話番号（IANAが定義）
# - creation_date: ドメインが作成された日時（ISO 8601形式）
# - expiration_date: ドメインが期限切れになる日時（ISO 8601形式）
# - registrar_name: ドメインを登録したレジストラの名前
# - registrar_url: ドメインを登録したレジストラのWebサイトURL
# - reseller: ドメインを販売したリセラーの名前（存在する場合）
# - status_list: ドメインに適用されているEPPステータスコードのリスト
# - updated_date: ドメイン情報が最後に更新された日時（ISO 8601形式）
# - whois_server: ドメインのWHOIS情報を提供するサーバーのホスト名
# - tags_all: プロバイダーのdefault_tags設定を含む全タグのマップ
#---------------------------------------------------------------
