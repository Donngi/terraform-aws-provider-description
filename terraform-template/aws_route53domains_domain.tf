#---------------------------------------------------------------
# AWS Route 53 Domains - ドメイン登録
#---------------------------------------------------------------
#
# Amazon Route 53 Domainsを使用してドメイン名を登録・管理するリソースです。
# ドメインの登録、更新、登録解除を行います。
# ドメインのライフサイクルをTerraform外で管理する場合は
# aws_route53domains_registered_domain リソースを使用してください。
#
# AWS公式ドキュメント:
#   - Route 53 Domainsの概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/registrar.html
#   - ドメイン登録の仕組み: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/welcome-domain-registration.html
#   - RegisterDomain API: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_RegisterDomain.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53domains_domain
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53domains_domain" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: 登録するドメイン名を指定します。
  # 設定可能な値: 有効なドメイン名文字列（例: example.com）
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/registrar-tld-list.html
  domain_name = "example.com"

  # duration_in_years (Optional)
  # 設定内容: ドメインを登録する年数を指定します。年数を増やすとドメインが更新されます。
  # 設定可能な値: 1以上の整数（最小1年）
  # 省略時: レジストラのデフォルト値が使用されます。
  duration_in_years = 1

  # auto_renew (Optional)
  # 設定内容: ドメイン登録を自動更新するかどうかを指定します。
  # 設定可能な値:
  #   - true: 有効期限前にドメインを自動的に更新する
  #   - false: 自動更新しない
  # 省略時: true
  auto_renew = true

  # transfer_lock (Optional)
  # 設定内容: ドメインの転送ロックを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: ドメイン転送をロックする（不正転送防止）
  #   - false: 転送ロックを無効にする
  # 省略時: true
  # 注意: admin_privacy、registrant_privacy、tech_privacy は同一の値を指定する必要があります。
  transfer_lock = true

  #-------------------------------------------------------------
  # プライバシー保護設定
  #-------------------------------------------------------------

  # admin_privacy (Optional)
  # 設定内容: WHOISクエリで管理者の連絡先情報を非表示にするかどうかを指定します。
  # 設定可能な値:
  #   - true: 管理者の連絡先情報を非表示にする
  #   - false: 管理者の連絡先情報を公開する
  # 省略時: true
  # 注意: admin_privacy、registrant_privacy、tech_privacy は同一の値を指定する必要があります。
  admin_privacy = true

  # registrant_privacy (Optional)
  # 設定内容: WHOISクエリで登録者の連絡先情報を非表示にするかどうかを指定します。
  # 設定可能な値:
  #   - true: 登録者の連絡先情報を非表示にする
  #   - false: 登録者の連絡先情報を公開する
  # 省略時: true
  # 注意: admin_privacy、registrant_privacy、tech_privacy は同一の値を指定する必要があります。
  registrant_privacy = true

  # tech_privacy (Optional)
  # 設定内容: WHOISクエリで技術担当者の連絡先情報を非表示にするかどうかを指定します。
  # 設定可能な値:
  #   - true: 技術担当者の連絡先情報を非表示にする
  #   - false: 技術担当者の連絡先情報を公開する
  # 省略時: true
  # 注意: admin_privacy、registrant_privacy、tech_privacy は同一の値を指定する必要があります。
  tech_privacy = true

  # billing_privacy (Optional)
  # 設定内容: WHOISクエリで請求担当者の連絡先情報を非表示にするかどうかを指定します。
  # 設定可能な値:
  #   - true: 請求担当者の連絡先情報を非表示にする
  #   - false: 請求担当者の連絡先情報を公開する
  # 省略時: true
  billing_privacy = true

  #-------------------------------------------------------------
  # ネームサーバー設定
  #-------------------------------------------------------------

  # name_server (Optional)
  # 設定内容: ドメインのネームサーバーリストを指定します。
  # 省略時: Route 53 が自動的にネームサーバーを割り当てます。
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register-update.html
  name_server {

    # name (Required)
    # 設定内容: ネームサーバーの完全修飾ホスト名を指定します。
    # 設定可能な値: 有効なFQDN文字列（例: ns1.example.com）
    name = "ns-1.awsdns-01.com"

    # glue_ips (Optional)
    # 設定内容: ネームサーバーのグルーIPアドレスを指定します。
    # 設定可能な値: IPv4アドレス1つとIPv6アドレス1つまでのセット
    # 省略時: グルーIPなし
    glue_ips = []
  }

  #-------------------------------------------------------------
  # 管理者連絡先設定
  #-------------------------------------------------------------

  # admin_contact (Optional)
  # 設定内容: ドメイン管理者の連絡先情報を指定するブロックです。
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html
  admin_contact {

    # first_name (Optional)
    # 設定内容: 管理者の名（ファーストネーム）を指定します。
    # 設定可能な値: 文字列
    first_name = "Taro"

    # last_name (Optional)
    # 設定内容: 管理者の姓（ラストネーム）を指定します。
    # 設定可能な値: 文字列
    last_name = "Yamada"

    # organization_name (Optional)
    # 設定内容: PERSON以外のcontact_typeの場合の組織名を指定します。
    # 設定可能な値: 文字列
    organization_name = "Example Corp"

    # contact_type (Optional)
    # 設定内容: 連絡先が個人、会社、団体、または公共機関のいずれかを指定します。
    # 設定可能な値:
    #   - "PERSON": 個人
    #   - "COMPANY": 会社
    #   - "ASSOCIATION": 団体
    #   - "PUBLIC_BODY": 公共機関
    #   - "RESELLER": 再販業者
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html#Route53Domains-Type-domains_ContactDetail-ContactType
    contact_type = "COMPANY"

    # address_line_1 (Optional)
    # 設定内容: 連絡先住所の1行目を指定します。
    # 設定可能な値: 文字列
    address_line_1 = "1-1-1 Example Street"

    # address_line_2 (Optional)
    # 設定内容: 連絡先住所の2行目を指定します（任意）。
    # 設定可能な値: 文字列
    address_line_2 = null

    # city (Optional)
    # 設定内容: 連絡先住所の都市名を指定します。
    # 設定可能な値: 文字列
    city = "Tokyo"

    # state (Optional)
    # 設定内容: 連絡先住所の都道府県または州を指定します。
    # 設定可能な値: 文字列
    state = "Tokyo"

    # country_code (Optional)
    # 設定内容: 連絡先住所の国コードを指定します。
    # 設定可能な値: ISO 3166-1 alpha-2国コード（例: JP, US, GB）
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html#Route53Domains-Type-domains_ContactDetail-CountryCode
    country_code = "JP"

    # zip_code (Optional)
    # 設定内容: 連絡先住所の郵便番号を指定します。
    # 設定可能な値: 文字列
    zip_code = "100-0001"

    # phone_number (Optional)
    # 設定内容: 連絡先の電話番号を指定します。
    # 設定可能な値: "+[国番号].[市外局番を含む番号]" 形式の文字列（例: +81.312345678）
    phone_number = "+81.312345678"

    # fax (Optional)
    # 設定内容: 連絡先のFAX番号を指定します。
    # 設定可能な値: "+[国番号].[市外局番を含む番号]" 形式の文字列
    fax = null

    # email (Optional)
    # 設定内容: 連絡先のメールアドレスを指定します。
    # 設定可能な値: 有効なメールアドレス文字列
    email = "admin@example.com"

    # extra_param (Optional)
    # 設定内容: 特定のトップレベルドメインで必要な追加パラメーターを指定するブロックです。
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ExtraParam.html
    extra_param {

      # name (Required)
      # 設定内容: 追加パラメーターの名前を指定します。
      # 設定可能な値: TLDが要求する有効なパラメーター名
      name = "EXTRA_PARAM_NAME"

      # value (Required)
      # 設定内容: 追加パラメーターに対応する値を指定します。
      # 設定可能な値: パラメーター名に対応する文字列値
      value = "extra-param-value"
    }
  }

  #-------------------------------------------------------------
  # 登録者連絡先設定
  #-------------------------------------------------------------

  # registrant_contact (Optional)
  # 設定内容: ドメイン登録者の連絡先情報を指定するブロックです。
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html
  registrant_contact {

    # first_name (Optional)
    # 設定内容: 登録者の名（ファーストネーム）を指定します。
    # 設定可能な値: 文字列
    first_name = "Taro"

    # last_name (Optional)
    # 設定内容: 登録者の姓（ラストネーム）を指定します。
    # 設定可能な値: 文字列
    last_name = "Yamada"

    # organization_name (Optional)
    # 設定内容: PERSON以外のcontact_typeの場合の組織名を指定します。
    # 設定可能な値: 文字列
    organization_name = "Example Corp"

    # contact_type (Optional)
    # 設定内容: 連絡先が個人、会社、団体、または公共機関のいずれかを指定します。
    # 設定可能な値:
    #   - "PERSON": 個人
    #   - "COMPANY": 会社
    #   - "ASSOCIATION": 団体
    #   - "PUBLIC_BODY": 公共機関
    #   - "RESELLER": 再販業者
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html#Route53Domains-Type-domains_ContactDetail-ContactType
    contact_type = "COMPANY"

    # address_line_1 (Optional)
    # 設定内容: 連絡先住所の1行目を指定します。
    # 設定可能な値: 文字列
    address_line_1 = "1-1-1 Example Street"

    # address_line_2 (Optional)
    # 設定内容: 連絡先住所の2行目を指定します（任意）。
    # 設定可能な値: 文字列
    address_line_2 = null

    # city (Optional)
    # 設定内容: 連絡先住所の都市名を指定します。
    # 設定可能な値: 文字列
    city = "Tokyo"

    # state (Optional)
    # 設定内容: 連絡先住所の都道府県または州を指定します。
    # 設定可能な値: 文字列
    state = "Tokyo"

    # country_code (Optional)
    # 設定内容: 連絡先住所の国コードを指定します。
    # 設定可能な値: ISO 3166-1 alpha-2国コード（例: JP, US, GB）
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html#Route53Domains-Type-domains_ContactDetail-CountryCode
    country_code = "JP"

    # zip_code (Optional)
    # 設定内容: 連絡先住所の郵便番号を指定します。
    # 設定可能な値: 文字列
    zip_code = "100-0001"

    # phone_number (Optional)
    # 設定内容: 連絡先の電話番号を指定します。
    # 設定可能な値: "+[国番号].[市外局番を含む番号]" 形式の文字列
    phone_number = "+81.312345678"

    # fax (Optional)
    # 設定内容: 連絡先のFAX番号を指定します。
    # 設定可能な値: "+[国番号].[市外局番を含む番号]" 形式の文字列
    fax = null

    # email (Optional)
    # 設定内容: 連絡先のメールアドレスを指定します。
    # 設定可能な値: 有効なメールアドレス文字列
    email = "registrant@example.com"

    # extra_param (Optional)
    # 設定内容: 特定のトップレベルドメインで必要な追加パラメーターを指定するブロックです。
    extra_param {

      # name (Required)
      # 設定内容: 追加パラメーターの名前を指定します。
      # 設定可能な値: TLDが要求する有効なパラメーター名
      name = "EXTRA_PARAM_NAME"

      # value (Required)
      # 設定内容: 追加パラメーターに対応する値を指定します。
      # 設定可能な値: パラメーター名に対応する文字列値
      value = "extra-param-value"
    }
  }

  #-------------------------------------------------------------
  # 技術担当者連絡先設定
  #-------------------------------------------------------------

  # tech_contact (Optional)
  # 設定内容: ドメインの技術担当者の連絡先情報を指定するブロックです。
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html
  tech_contact {

    # first_name (Optional)
    # 設定内容: 技術担当者の名（ファーストネーム）を指定します。
    # 設定可能な値: 文字列
    first_name = "Taro"

    # last_name (Optional)
    # 設定内容: 技術担当者の姓（ラストネーム）を指定します。
    # 設定可能な値: 文字列
    last_name = "Yamada"

    # organization_name (Optional)
    # 設定内容: PERSON以外のcontact_typeの場合の組織名を指定します。
    # 設定可能な値: 文字列
    organization_name = "Example Corp"

    # contact_type (Optional)
    # 設定内容: 連絡先が個人、会社、団体、または公共機関のいずれかを指定します。
    # 設定可能な値:
    #   - "PERSON": 個人
    #   - "COMPANY": 会社
    #   - "ASSOCIATION": 団体
    #   - "PUBLIC_BODY": 公共機関
    #   - "RESELLER": 再販業者
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html#Route53Domains-Type-domains_ContactDetail-ContactType
    contact_type = "COMPANY"

    # address_line_1 (Optional)
    # 設定内容: 連絡先住所の1行目を指定します。
    # 設定可能な値: 文字列
    address_line_1 = "1-1-1 Example Street"

    # address_line_2 (Optional)
    # 設定内容: 連絡先住所の2行目を指定します（任意）。
    # 設定可能な値: 文字列
    address_line_2 = null

    # city (Optional)
    # 設定内容: 連絡先住所の都市名を指定します。
    # 設定可能な値: 文字列
    city = "Tokyo"

    # state (Optional)
    # 設定内容: 連絡先住所の都道府県または州を指定します。
    # 設定可能な値: 文字列
    state = "Tokyo"

    # country_code (Optional)
    # 設定内容: 連絡先住所の国コードを指定します。
    # 設定可能な値: ISO 3166-1 alpha-2国コード（例: JP, US, GB）
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html#Route53Domains-Type-domains_ContactDetail-CountryCode
    country_code = "JP"

    # zip_code (Optional)
    # 設定内容: 連絡先住所の郵便番号を指定します。
    # 設定可能な値: 文字列
    zip_code = "100-0001"

    # phone_number (Optional)
    # 設定内容: 連絡先の電話番号を指定します。
    # 設定可能な値: "+[国番号].[市外局番を含む番号]" 形式の文字列
    phone_number = "+81.312345678"

    # fax (Optional)
    # 設定内容: 連絡先のFAX番号を指定します。
    # 設定可能な値: "+[国番号].[市外局番を含む番号]" 形式の文字列
    fax = null

    # email (Optional)
    # 設定内容: 連絡先のメールアドレスを指定します。
    # 設定可能な値: 有効なメールアドレス文字列
    email = "tech@example.com"

    # extra_param (Optional)
    # 設定内容: 特定のトップレベルドメインで必要な追加パラメーターを指定するブロックです。
    extra_param {

      # name (Required)
      # 設定内容: 追加パラメーターの名前を指定します。
      # 設定可能な値: TLDが要求する有効なパラメーター名
      name = "EXTRA_PARAM_NAME"

      # value (Required)
      # 設定内容: 追加パラメーターに対応する値を指定します。
      # 設定可能な値: パラメーター名に対応する文字列値
      value = "extra-param-value"
    }
  }

  #-------------------------------------------------------------
  # 請求担当者連絡先設定
  #-------------------------------------------------------------

  # billing_contact (Optional)
  # 設定内容: ドメインの請求担当者の連絡先情報を指定します（list型のobject）。
  # 省略時: 他の連絡先情報が使用される場合があります。
  # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html
  billing_contact = [
    {
      # 設定内容: 請求担当者の名（ファーストネーム）
      first_name = "Taro"
      # 設定内容: 請求担当者の姓（ラストネーム）
      last_name = "Yamada"
      # 設定内容: PERSON以外のcontact_typeの場合の組織名
      organization_name = "Example Corp"
      # 設定内容: 連絡先種別（PERSON, COMPANY, ASSOCIATION, PUBLIC_BODY, RESELLER）
      contact_type = "COMPANY"
      # 設定内容: 住所1行目
      address_line_1 = "1-1-1 Example Street"
      # 設定内容: 住所2行目（任意）
      address_line_2 = null
      # 設定内容: 都市名
      city = "Tokyo"
      # 設定内容: 都道府県または州
      state = "Tokyo"
      # 設定内容: ISO 3166-1 alpha-2国コード
      country_code = "JP"
      # 設定内容: 郵便番号
      zip_code = "100-0001"
      # 設定内容: 電話番号（+[国番号].[番号] 形式）
      phone_number = "+81.312345678"
      # 設定内容: FAX番号（任意）
      fax = null
      # 設定内容: メールアドレス
      email = "billing@example.com"
      # 設定内容: TLD固有の追加パラメーター（不要な場合は空リスト）
      extra_param = []
    }
  ]

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" 等の期間文字列（s=秒, m=分, h=時間）
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" 等の期間文字列
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" 等の期間文字列
    delete = "30m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 参考: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/registrar.html
  tags = {
    Name        = "example-domain"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - abuse_contact_email: ドメインの不正使用を報告するための連絡先メールアドレス
# - abuse_contact_phone: ドメインの不正使用を報告するための連絡先電話番号
# - creation_date: WHOISクエリで取得されたドメインの作成日
# - expiration_date: ドメイン登録の有効期限日
# - hosted_zone_id: ドメインのために作成されたRoute 53パブリックホストゾーンのID
# - registrar_name: レジストリで特定されたドメインのレジストラ名
# - registrar_url: レジストラのWebアドレス
# - status_list: ドメイン名のステータスコードのリスト
# - updated_date: WHOISクエリで取得されたドメインの最終更新日
# - whois_server: ドメインのWHOISクエリに応答できるWHOISサーバーの完全修飾名
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
