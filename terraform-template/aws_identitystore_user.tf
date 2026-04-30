#---------------------------------------------------------------
# AWS IAM Identity Center Identity Store User
#---------------------------------------------------------------
#
# AWS IAM Identity Centerのアイデンティティストアにユーザーをプロビジョニングする
# リソースです。IAM Identity Centerのディレクトリ内でユーザーを作成・管理します。
# 外部IDプロバイダーやActive Directoryを使用する場合は、アウトバウンド同期が
# サポートされないため、このリソースによる変更が外部ソースに反映されない点に注意が
# 必要です。
#
# AWS公式ドキュメント:
#   - ユーザーの追加: https://docs.aws.amazon.com/singlesignon/latest/userguide/addusers.html
#   - ユーザーとグループのプロビジョニング: https://docs.aws.amazon.com/singlesignon/latest/userguide/users-groups-provisioning.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_user
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_identitystore_user" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # identity_store_id (Required, Forces new resource)
  # 設定内容: このユーザーが所属するアイデンティティストアのグローバル一意識別子を指定します。
  # 設定可能な値: 有効なIdentity Store IDの文字列（例: d-1234567890）
  # 参考: https://docs.aws.amazon.com/singlesignon/latest/userguide/manage-your-identity-source-sso.html
  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]

  # display_name (Required)
  # 設定内容: ユーザーを参照する際に通常表示される名前を指定します。
  # 設定可能な値: 最大1024文字の文字列
  display_name = "John Doe"

  # user_name (Required, Forces new resource)
  # 設定内容: ユーザーを識別するための一意な文字列を指定します。
  # 設定可能な値: 最大128文字の文字列。文字、アクセント文字、記号、数字、句読点が使用可能
  # 注意: ユーザー作成時に指定され、アイデンティティストア内のユーザーオブジェクトの
  #       属性として保存されます。
  user_name = "johndoe"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # プロフィール設定
  #-------------------------------------------------------------

  # locale (Optional)
  # 設定内容: ユーザーの地理的リージョンまたは所在地を指定します。
  # 設定可能な値: 最大1024文字の文字列（例: "ja-JP", "en-US"）
  # 省略時: 設定なし
  locale = null

  # nickname (Optional)
  # 設定内容: ユーザーの別名（ニックネーム）を指定します。
  # 設定可能な値: 最大1024文字の文字列
  # 省略時: 設定なし
  nickname = null

  # preferred_language (Optional)
  # 設定内容: ユーザーの優先言語を指定します。
  # 設定可能な値: 最大1024文字の文字列（例: "ja", "en"）
  # 省略時: 設定なし
  preferred_language = null

  # profile_url (Optional)
  # 設定内容: ユーザーに関連付けるURLを指定します。
  # 設定可能な値: 最大1024文字のURL文字列
  # 省略時: 設定なし
  profile_url = null

  # timezone (Optional)
  # 設定内容: ユーザーのタイムゾーンを指定します。
  # 設定可能な値: 最大1024文字の文字列（例: "Asia/Tokyo", "America/New_York"）
  # 省略時: 設定なし
  timezone = null

  # title (Optional)
  # 設定内容: ユーザーの役職・肩書きを指定します。
  # 設定可能な値: 最大1024文字の文字列（例: "Manager", "Engineer"）
  # 省略時: 設定なし
  title = null

  # user_type (Optional)
  # 設定内容: ユーザーの種別を指定します。
  # 設定可能な値: 最大1024文字の文字列（例: "Employee", "Contractor"）
  # 省略時: 設定なし
  user_type = null

  #-------------------------------------------------------------
  # 氏名設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ユーザーのフルネームの詳細を指定する設定ブロックです。
  # 注意: このブロックは必須です（min_items = 1）。
  name {

    # given_name (Required)
    # 設定内容: ユーザーのファーストネーム（名）を指定します。
    # 設定可能な値: 最大1024文字の文字列
    given_name = "John"

    # family_name (Required)
    # 設定内容: ユーザーのファミリーネーム（姓）を指定します。
    # 設定可能な値: 最大1024文字の文字列
    family_name = "Doe"

    # formatted (Optional)
    # 設定内容: 表示用にフォーマットされたフルネームを指定します。
    # 設定可能な値: 最大1024文字の文字列
    # 省略時: 設定なし
    formatted = null

    # honorific_prefix (Optional)
    # 設定内容: ユーザーの敬称プレフィックスを指定します。
    # 設定可能な値: 最大1024文字の文字列（例: "Mr.", "Dr.", "Prof."）
    # 省略時: 設定なし
    honorific_prefix = null

    # honorific_suffix (Optional)
    # 設定内容: ユーザーの敬称サフィックスを指定します。
    # 設定可能な値: 最大1024文字の文字列（例: "Jr.", "Sr.", "PhD"）
    # 省略時: 設定なし
    honorific_suffix = null

    # middle_name (Optional)
    # 設定内容: ユーザーのミドルネームを指定します。
    # 設定可能な値: 最大1024文字の文字列
    # 省略時: 設定なし
    middle_name = null
  }

  #-------------------------------------------------------------
  # メールアドレス設定
  #-------------------------------------------------------------

  # emails (Optional)
  # 設定内容: ユーザーのメールアドレスの詳細を指定する設定ブロックです。
  # 注意: 最大1件のメールアドレスを設定できます（max_items = 1）。
  emails {

    # value (Optional)
    # 設定内容: メールアドレスを指定します。
    # 設定可能な値: アイデンティティストア内で一意なメールアドレス文字列
    # 注意: この値はアイデンティティストア内で一意である必要があります。
    value = "john@example.com"

    # type (Optional)
    # 設定内容: メールアドレスの種別を指定します。
    # 設定可能な値: 最大1024文字の文字列（例: "work", "home", "other"）
    # 省略時: 設定なし
    type = null

    # primary (Optional)
    # 設定内容: このメールアドレスがユーザーのプライマリメールアドレスかどうかを指定します。
    # 設定可能な値:
    #   - true: プライマリメールアドレスとして設定
    #   - false: プライマリ以外のメールアドレスとして設定
    # 省略時: false
    primary = true
  }

  #-------------------------------------------------------------
  # 電話番号設定
  #-------------------------------------------------------------

  # phone_numbers (Optional)
  # 設定内容: ユーザーの電話番号の詳細を指定する設定ブロックです。
  # 注意: 最大1件の電話番号を設定できます（max_items = 1）。
  phone_numbers {

    # value (Optional)
    # 設定内容: 電話番号を指定します。
    # 設定可能な値: 最大1024文字の文字列
    # 省略時: 設定なし
    value = "+81-3-1234-5678"

    # type (Optional)
    # 設定内容: 電話番号の種別を指定します。
    # 設定可能な値: 最大1024文字の文字列（例: "work", "mobile", "home"）
    # 省略時: 設定なし
    type = null

    # primary (Optional)
    # 設定内容: この電話番号がユーザーのプライマリ電話番号かどうかを指定します。
    # 設定可能な値:
    #   - true: プライマリ電話番号として設定
    #   - false: プライマリ以外の電話番号として設定
    # 省略時: false
    primary = true
  }

  #-------------------------------------------------------------
  # 住所設定
  #-------------------------------------------------------------

  # addresses (Optional)
  # 設定内容: ユーザーの住所の詳細を指定する設定ブロックです。
  # 注意: 最大1件の住所を設定できます（max_items = 1）。
  addresses {

    # street_address (Optional)
    # 設定内容: 住所の番地・通り名を指定します。
    # 設定可能な値: 最大1024文字の文字列
    # 省略時: 設定なし
    street_address = null

    # locality (Optional)
    # 設定内容: 住所の市区町村を指定します。
    # 設定可能な値: 最大1024文字の文字列
    # 省略時: 設定なし
    locality = null

    # region (Optional)
    # 設定内容: 住所の都道府県・州・地域を指定します。
    # 設定可能な値: 最大1024文字の文字列
    # 省略時: 設定なし
    region = null

    # postal_code (Optional)
    # 設定内容: 住所の郵便番号を指定します。
    # 設定可能な値: 最大1024文字の文字列
    # 省略時: 設定なし
    postal_code = null

    # country (Optional)
    # 設定内容: 住所の国名を指定します。
    # 設定可能な値: 最大1024文字の文字列（例: "Japan", "US"）
    # 省略時: 設定なし
    country = null

    # formatted (Optional)
    # 設定内容: 表示用にフォーマットされた住所の完全な文字列を指定します。
    # 設定可能な値: 最大1024文字の文字列
    # 省略時: 設定なし
    formatted = null

    # type (Optional)
    # 設定内容: 住所の種別を指定します。
    # 設定可能な値: 最大1024文字の文字列（例: "work", "home", "other"）
    # 省略時: 設定なし
    type = null

    # primary (Optional)
    # 設定内容: この住所がユーザーのプライマリ住所かどうかを指定します。
    # 設定可能な値:
    #   - true: プライマリ住所として設定
    #   - false: プライマリ以外の住所として設定
    # 省略時: false
    primary = false
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - user_id: アイデンティティストア内でのユーザーの識別子
#
# - external_ids: 外部アイデンティティプロバイダーが発行した識別子のリスト
#   - id: 外部アイデンティティプロバイダーが発行した識別子
#   - issuer: 外部識別子の発行者
#---------------------------------------------------------------
