#---------------------------------------------------------------
# Route 53 Domains - Domain Registration
#---------------------------------------------------------------
#
# Amazon Route 53のドメイン登録サービスを使用してドメインを登録・管理するリソースです。
# このリソースはドメインの新規登録、更新、登録解除を行います。
# ドメインのライフサイクルをTerraform外で管理する場合は、
# aws_route53domains_registered_domainリソースを使用してください。
#
# 主な機能:
#   - ドメインの新規登録とホストゾーンの自動作成
#   - 自動更新設定とトランスファーロックの管理
#   - 管理者、技術、請求、登録者の連絡先情報の管理
#   - WHOIS情報のプライバシー保護設定
#   - カスタムネームサーバーの設定
#
# AWS公式ドキュメント:
#   - Route 53 ドメイン登録の概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/registrar.html
#   - 新しいドメインの登録: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html
#   - RegisterDomain API: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_RegisterDomain.html
#   - サポートされるTLD: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/registrar-tld-list.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53domains_domain
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
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
  # 設定可能な値: 有効なドメイン名（例: example.com）
  # 注意:
  #   - ドメインが利用可能かどうかは事前に確認が必要です
  #   - サポートされるTLDのリストは上記のAWSドキュメントを参照
  #   - 一部のプレミアムドメインは登録できません
  # 関連機能: Route 53 ドメイン登録
  #   ドメイン名は一意である必要があり、登録後はホストゾーンが自動作成されます。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html
  domain_name = "example.com"

  # duration_in_years (Optional)
  # 設定内容: ドメインを登録する年数を指定します。
  # 設定可能な値: 1～10の整数（最小1年）
  # 省略時: 1年で登録されます
  # 注意:
  #   - 値を増やすとドメインが更新されます
  #   - TLDによって最大登録期間が異なる場合があります
  # 関連機能: ドメイン登録期間
  #   複数年登録することで、ドメインの有効期限を延長できます。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html
  duration_in_years = 1

  # auto_renew (Optional)
  # 設定内容: ドメインの自動更新を有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 有効期限前に自動更新
  #   - false: 自動更新を無効化（手動更新が必要）
  # 省略時: true（自動更新が有効）
  # 関連機能: ドメイン自動更新
  #   自動更新を有効にすることで、ドメインの失効を防ぎます。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-renew.html
  auto_renew = true

  # transfer_lock (Optional)
  # 設定内容: ドメインのトランスファーロックを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): トランスファーロックを有効化（不正な転送を防止）
  #   - false: トランスファーロックを無効化（ドメイン転送が可能）
  # 省略時: true（ロックが有効）
  # 関連機能: ドメイントランスファーロック
  #   不正なドメイン転送を防ぐためのセキュリティ機能。転送時は一時的に無効化が必要。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-transfer-between-aws-accounts.html
  transfer_lock = true

  #-------------------------------------------------------------
  # 連絡先情報設定（管理者）
  #-------------------------------------------------------------

  # admin_contact (Required)
  # 設定内容: ドメインの管理者連絡先の詳細を指定します。
  # 注意: 全ての連絡先（admin, registrant, tech）のプライバシー設定は同じである必要があります
  # 関連機能: ドメイン連絡先情報
  #   ドメインレジストリに登録される連絡先情報。WHOIS照会で表示される場合があります。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register-values-specify.html
  admin_contact {
    # address_line_1 (Optional)
    # 設定内容: 連絡先の住所（1行目）を指定します。
    # 設定可能な値: 住所文字列
    address_line_1 = "101 Main Street"

    # address_line_2 (Optional)
    # 設定内容: 連絡先の住所（2行目）を指定します。
    # 設定可能な値: 住所文字列（アパート番号や建物名など）
    address_line_2 = null

    # city (Optional)
    # 設定内容: 連絡先の市区町村を指定します。
    # 設定可能な値: 市区町村名
    city = "San Francisco"

    # state (Optional)
    # 設定内容: 連絡先の都道府県または州を指定します。
    # 設定可能な値: 都道府県名または州の略称
    state = "CA"

    # country_code (Optional)
    # 設定内容: 連絡先の国コードを指定します。
    # 設定可能な値: ISO 3166-1 alpha-2国コード（例: US, JP, UK）
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html#Route53Domains-Type-domains_ContactDetail-CountryCode
    country_code = "US"

    # zip_code (Optional)
    # 設定内容: 連絡先の郵便番号を指定します。
    # 設定可能な値: 郵便番号文字列
    zip_code = "94105"

    # phone_number (Optional)
    # 設定内容: 連絡先の電話番号を指定します。
    # 設定可能な値: "+[国コード].[市外局番を含む番号]" 形式（例: +1.4155551234）
    # 注意: 国際形式で指定する必要があります
    phone_number = "+1.4155551234"

    # fax (Optional)
    # 設定内容: 連絡先のFAX番号を指定します。
    # 設定可能な値: "+[国コード].[市外局番を含む番号]" 形式
    fax = "+1.4155551234"

    # email (Optional)
    # 設定内容: 連絡先のメールアドレスを指定します。
    # 設定可能な値: 有効なメールアドレス
    # 注意: ドメイン登録確認メールがこのアドレスに送信されます
    email = "terraform-acctest@example.com"

    # first_name (Optional)
    # 設定内容: 連絡先の名を指定します。
    # 設定可能な値: 名前文字列
    first_name = "Terraform"

    # last_name (Optional)
    # 設定内容: 連絡先の姓を指定します。
    # 設定可能な値: 姓名文字列
    last_name = "Team"

    # organization_name (Optional)
    # 設定内容: 連絡先の組織名を指定します。
    # 設定可能な値: 組織名文字列
    # 用途: contact_typeがPERSON以外の場合に使用
    organization_name = "HashiCorp"

    # contact_type (Optional)
    # 設定内容: 連絡先のタイプを指定します。
    # 設定可能な値:
    #   - PERSON: 個人
    #   - COMPANY: 企業
    #   - ASSOCIATION: 協会
    #   - PUBLIC_BODY: 公的機関
    #   - RESELLER: リセラー
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html#Route53Domains-Type-domains_ContactDetail-ContactType
    contact_type = "COMPANY"

    # extra_param (Optional)
    # 設定内容: 特定のトップレベルドメイン（TLD）で必要な追加パラメータのリストを指定します。
    # 用途: 一部のTLDでは追加情報が必要です（例: .ukドメインの登録者タイプ）
    # dynamic "extra_param" {
    #   for_each = []
    #   content {
    #     # name (Required)
    #     # 設定内容: 追加パラメータの名前を指定します。
    #     name = extra_param.value.name
    #
    #     # value (Required)
    #     # 設定内容: パラメータに対応する値を指定します。
    #     value = extra_param.value.value
    #   }
    # }
  }

  # admin_privacy (Optional)
  # 設定内容: 管理者連絡先情報をWHOIS照会から隠すかどうかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 連絡先情報を隠す
  #   - false: 連絡先情報を公開
  # 省略時: true（プライバシー保護が有効）
  # 注意: admin_privacy、registrant_privacy、tech_privacyは同じ値である必要があります
  # 関連機能: WHOISプライバシー保護
  #   個人情報をWHOISデータベースから隠すことでプライバシーを保護します。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-privacy-protection.html
  admin_privacy = true

  #-------------------------------------------------------------
  # 連絡先情報設定（登録者）
  #-------------------------------------------------------------

  # registrant_contact (Required)
  # 設定内容: ドメインの登録者連絡先の詳細を指定します。
  # 注意: 登録者は法的にドメインの所有者となります
  # 関連機能: ドメイン登録者情報
  #   ドメインの正式な所有者として記録される情報。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register-values-specify.html
  registrant_contact {
    address_line_1    = "101 Main Street"
    address_line_2    = null
    city              = "San Francisco"
    state             = "CA"
    country_code      = "US"
    zip_code          = "94105"
    phone_number      = "+1.4155551234"
    fax               = "+1.4155551234"
    email             = "terraform-acctest@example.com"
    first_name        = "Terraform"
    last_name         = "Team"
    organization_name = "HashiCorp"
    contact_type      = "COMPANY"
  }

  # registrant_privacy (Optional)
  # 設定内容: 登録者連絡先情報をWHOIS照会から隠すかどうかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 連絡先情報を隠す
  #   - false: 連絡先情報を公開
  # 省略時: true（プライバシー保護が有効）
  # 注意: admin_privacy、registrant_privacy、tech_privacyは同じ値である必要があります
  registrant_privacy = true

  #-------------------------------------------------------------
  # 連絡先情報設定（技術担当者）
  #-------------------------------------------------------------

  # tech_contact (Required)
  # 設定内容: ドメインの技術担当者連絡先の詳細を指定します。
  # 注意: 技術的な問題について連絡を受ける担当者の情報
  # 関連機能: 技術担当者情報
  #   DNS設定やドメインの技術的な問題に対応する担当者の情報。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register-values-specify.html
  tech_contact {
    address_line_1    = "101 Main Street"
    address_line_2    = null
    city              = "San Francisco"
    state             = "CA"
    country_code      = "US"
    zip_code          = "94105"
    phone_number      = "+1.4155551234"
    fax               = "+1.4155551234"
    email             = "terraform-acctest@example.com"
    first_name        = "Terraform"
    last_name         = "Team"
    organization_name = "HashiCorp"
    contact_type      = "COMPANY"
  }

  # tech_privacy (Optional)
  # 設定内容: 技術担当者連絡先情報をWHOIS照会から隠すかどうかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 連絡先情報を隠す
  #   - false: 連絡先情報を公開
  # 省略時: true（プライバシー保護が有効）
  # 注意: admin_privacy、registrant_privacy、tech_privacyは同じ値である必要があります
  tech_privacy = true

  #-------------------------------------------------------------
  # 連絡先情報設定（請求担当者）- オプション
  #-------------------------------------------------------------

  # billing_contact (Optional)
  # 設定内容: ドメインの請求担当者連絡先の詳細を指定します。
  # 省略時: 請求担当者情報は設定されません
  # 注意: 請求に関する連絡を受ける担当者の情報
  # billing_contact {
  #   address_line_1    = "101 Main Street"
  #   city              = "San Francisco"
  #   state             = "CA"
  #   country_code      = "US"
  #   zip_code          = "94105"
  #   phone_number      = "+1.4155551234"
  #   email             = "billing@example.com"
  #   first_name        = "Billing"
  #   last_name         = "Department"
  #   organization_name = "HashiCorp"
  #   contact_type      = "COMPANY"
  # }

  # billing_privacy (Optional)
  # 設定内容: 請求担当者連絡先情報をWHOIS照会から隠すかどうかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 連絡先情報を隠す
  #   - false: 連絡先情報を公開
  # 省略時: true（プライバシー保護が有効）
  billing_privacy = true

  #-------------------------------------------------------------
  # ネームサーバー設定
  #-------------------------------------------------------------

  # name_server (Optional)
  # 設定内容: ドメインのネームサーバーのリストを指定します。
  # 省略時: Route 53が自動作成するホストゾーンのネームサーバーが使用されます
  # 注意:
  #   - カスタムネームサーバーを使用する場合にのみ指定
  #   - 通常は省略して、Route 53のデフォルトネームサーバーを使用することを推奨
  # 関連機能: ドメインネームサーバー設定
  #   ドメインのDNSクエリを処理するネームサーバーを指定します。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-name-servers-glue-records.html
  # dynamic "name_server" {
  #   for_each = []
  #   content {
  #     # name (Required)
  #     # 設定内容: ネームサーバーの完全修飾ホスト名を指定します。
  #     # 設定可能な値: FQDN形式のネームサーバー名（例: ns-123.awsdns-12.com）
  #     name = name_server.value.name
  #
  #     # glue_ips (Optional)
  #     # 設定内容: ネームサーバーのGlue IPアドレスを指定します。
  #     # 設定可能な値: IPv4またはIPv6アドレスのリスト（最大1つずつ）
  #     # 用途: ネームサーバーが登録中のドメイン内にある場合に必要（Glueレコード）
  #     # 注意: IPv4とIPv6を1つずつ指定可能
  #     glue_ips = name_server.value.glue_ips
  #   }
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/tagging-resources.html
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
# - abuse_contact_email: ドメインに関する不正使用を報告するためのメールアドレス。
#   誤った連絡先情報、スパム送信、サイバースクワッティング、その他の不正使用を
#   報告するために使用されます。
#
# - abuse_contact_phone: 不正使用を報告するための電話番号。
#
# - creation_date: WHOISクエリの応答で見つかった、ドメインが作成された日付。
#
# - expiration_date: ドメインの登録が失効する予定日。
#
# - hosted_zone_id: ドメイン用に作成されたパブリックRoute 53ホストゾーンのID。
#   このホストゾーンはドメインの登録解除時に削除されます。
#
# - id: リソースの一意の識別子。
#
# - registrar_name: レジストリで識別されるドメインのレジストラ名。
#
# - registrar_url: レジストラのWebアドレス。
#
# - status_list: ドメイン名ステータスコードのリスト。
#   EPPステータスコード（clientTransferProhibited、serverHoldなど）が含まれます。
#   参考: https://www.icann.org/resources/pages/epp-status-codes-2014-06-16-en
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ。
#
# - updated_date: WHOISクエリの応答で見つかった、ドメインが最後に更新された日付。
#
# - whois_server: ドメインのWHOISクエリに応答できるWHOISサーバーの完全修飾名。
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# このリソースは `terraform import` コマンドを使用してインポートできます:
#
# $ terraform import aws_route53domains_domain.example example.com
#
# 注意: インポート時はドメイン名を使用します。
#---------------------------------------------------------------
