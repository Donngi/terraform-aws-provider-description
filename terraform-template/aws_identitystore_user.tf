#---------------------------------------------------------------
# AWS IAM Identity Center User (Identity Store User)
#---------------------------------------------------------------
#
# AWS IAM Identity CenterのIdentity Store内にユーザーを作成・管理します。
# このリソースはSCIM (System for Cross-Domain Identity Management) 仕様に基づき、
# ユーザーの基本情報、名前、メールアドレス、電話番号、住所などの属性を設定できます。
#
# 【重要な注意事項】
# 外部IdP（Identity Provider）やActive Directoryを使用している場合、
# このリソースの使用には注意が必要です。IAM Identity Centerはアウトバウンド同期を
# サポートしていないため、このリソースで行った変更は外部の識別ソースには
# 自動的に反映されません。
#
# AWS公式ドキュメント:
#   - IAM Identity Center Users and Groups: https://docs.aws.amazon.com/singlesignon/latest/userguide/users-groups-provisioning.html
#   - Identity Store API - CreateUser: https://docs.aws.amazon.com/singlesignon/latest/IdentityStoreAPIReference/API_CreateUser.html
#   - Supported User Attributes: https://docs.aws.amazon.com/singlesignon/latest/userguide/manage-your-identity-source-attribute-use.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_user
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_identitystore_user" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # Identity StoreのグローバルID
  # 通常はSSO管理インスタンスから取得します
  # 例: tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
  # Forces new resource: 変更すると再作成されます
  identity_store_id = "d-1234567890"

  # ユーザー表示名
  # UIやリストに表示されるユーザーの名前
  # 例: "John Doe", "山田 太郎"
  # 最大1024文字まで指定可能
  display_name = "John Doe"

  # ユーザー名
  # ユーザーを一意に識別する文字列
  # 文字、アクセント付き文字、記号、数字、句読点を含めることができます
  # Forces new resource: 変更すると再作成されます
  # 最大128文字まで指定可能
  user_name = "johndoe"

  #---------------------------------------------------------------
  # ユーザー名情報（必須ブロック）
  #---------------------------------------------------------------

  # ユーザーのフルネーム詳細
  # 最小1個、最大1個のブロックが必要
  name {
    # 名（名前）- 必須
    # 例: "John", "太郎"
    given_name = "John"

    # 姓（苗字）- 必須
    # 例: "Doe", "山田"
    family_name = "Doe"

    # フォーマット済み氏名
    # 表示用にフォーマットされた完全な名前
    # 例: "Mr. John M. Doe Jr."
    # 最大1024文字まで指定可能
    formatted = null

    # ミドルネーム
    # 例: "Michael", "M."
    # 最大1024文字まで指定可能
    middle_name = null

    # 敬称（接頭辞）
    # 例: "Mr.", "Dr.", "Prof."
    # 最大1024文字まで指定可能
    honorific_prefix = null

    # 敬称（接尾辞）
    # 例: "Jr.", "Sr.", "III"
    # 最大1024文字まで指定可能
    honorific_suffix = null
  }

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # ロケール（地域設定）
  # ユーザーの地理的な地域や場所
  # 例: "en_US", "ja_JP", "en-US"
  # 最大1024文字まで指定可能
  locale = null

  # ニックネーム
  # ユーザーの別名や愛称
  # 例: "Johnny", "太郎ちゃん"
  # 最大1024文字まで指定可能
  nickname = null

  # 優先言語
  # ユーザーが希望する言語
  # 例: "en", "ja", "en-US"
  # 最大1024文字まで指定可能
  preferred_language = null

  # プロフィールURL
  # ユーザーに関連付けられるURL
  # 例: "https://example.com/profiles/johndoe"
  # 最大1024文字まで指定可能
  profile_url = null

  # タイムゾーン
  # ユーザーのタイムゾーン
  # 例: "America/New_York", "Asia/Tokyo", "UTC"
  # 最大1024文字まで指定可能
  timezone = null

  # 役職・肩書き
  # ユーザーの職務上の肩書き
  # 例: "Software Engineer", "Manager", "エンジニア"
  # 最大1024文字まで指定可能
  title = null

  # ユーザータイプ
  # ユーザーの種類を示す文字列
  # 例: "Employee", "Contractor", "Partner"
  # 最大1024文字まで指定可能
  user_type = null

  # リージョン指定
  # このリソースが管理されるAWSリージョン
  # 指定しない場合はプロバイダー設定のリージョンが使用されます
  # 例: "us-east-1", "ap-northeast-1"
  region = null

  #---------------------------------------------------------------
  # オプションブロック - メールアドレス
  #---------------------------------------------------------------

  # ユーザーのメールアドレス情報
  # 最大1個のブロックまで指定可能
  # SCIM仕様では複数のメールアドレスをサポートしていますが、
  # IAM Identity Centerでは1つのみに制限されています
  emails {
    # メールアドレス
    # Identity Store全体で一意である必要があります
    # 例: "john.doe@example.com"
    value = "john@example.com"

    # メールアドレスの種類
    # 例: "work", "home", "other"
    type = null

    # プライマリフラグ
    # trueの場合、これが主要なメールアドレスとして扱われます
    # SCIMでメールアドレスを指定する場合、primaryをtrueにする必要があります
    primary = null
  }

  #---------------------------------------------------------------
  # オプションブロック - 電話番号
  #---------------------------------------------------------------

  # ユーザーの電話番号情報
  # 最大1個のブロックまで指定可能
  # SCIM仕様では複数の電話番号をサポートしていますが、
  # IAM Identity Centerでは1つのみに制限されています
  # phone_numbers {
  #   # 電話番号
  #   # 例: "+1-555-1234", "+81-3-1234-5678"
  #   value = null
  #
  #   # 電話番号の種類
  #   # 例: "work", "home", "mobile", "fax"
  #   type = null
  #
  #   # プライマリフラグ
  #   # trueの場合、これが主要な電話番号として扱われます
  #   primary = null
  # }

  #---------------------------------------------------------------
  # オプションブロック - 住所
  #---------------------------------------------------------------

  # ユーザーの住所情報
  # 最大1個のブロックまで指定可能
  # SCIM仕様では複数の住所をサポートしていますが、
  # IAM Identity Centerでは1つのみに制限されています
  # addresses {
  #   # フォーマット済み住所
  #   # 表示用にフォーマットされた完全な住所
  #   # 例: "100 Universal City Plaza, Hollywood, CA 91608 USA"
  #   # 文字、アクセント付き文字、記号、数字、句読点、スペースを含めることができます
  #   formatted = null
  #
  #   # 番地・町名
  #   # 例: "100 Universal City Plaza", "1-1-1 Marunouchi"
  #   street_address = null
  #
  #   # 市区町村
  #   # 例: "Hollywood", "Chiyoda-ku"
  #   locality = null
  #
  #   # 都道府県・州
  #   # 例: "California", "Tokyo", "CA"
  #   region = null
  #
  #   # 郵便番号
  #   # 例: "91608", "100-0005"
  #   postal_code = null
  #
  #   # 国
  #   # 例: "USA", "Japan", "US"
  #   country = null
  #
  #   # 住所の種類
  #   # 例: "work", "home", "other"
  #   type = null
  #
  #   # プライマリフラグ
  #   # trueの場合、これが主要な住所として扱われます
  #   primary = null
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定されます（computed-only）:
#
# - id (string)
#   リソースの識別子。通常は "{identity_store_id}/{user_id}" の形式
#
# - user_id (string)
#   Identity Store内でこのユーザーに割り当てられた一意の識別子
#   他のリソース（グループメンバーシップ等）で参照する際に使用
#
# - external_ids (list of objects)
#   外部IdPによって発行された識別子のリスト
#   各オブジェクトには以下が含まれます:
#     - id (string): 外部IdPが発行した識別子
#     - issuer (string): 識別子の発行者
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例とベストプラクティス
#---------------------------------------------------------------
#
# 1. SSO管理インスタンスからIdentity Store IDを取得:
#
#    data "aws_ssoadmin_instances" "example" {}
#
#    resource "aws_identitystore_user" "example" {
#      identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
#      ...
#    }
#
# 2. ユーザー名とメールアドレスは一意である必要があります
#    - user_name: Identity Store内で一意
#    - emails.value: Identity Store全体で一意
#
# 3. 外部IdPとの同期に注意:
#    - 外部IdP使用時はこのリソースでの変更が外部に反映されません
#    - できるだけ外部IdP側で管理することを推奨します
#
# 4. 文字数制限:
#    - user_name: 最大128文字
#    - その他のテキストフィールド: 最大1024文字（特記なき限り）
#
# 5. SCIM制約:
#    - メールアドレス、電話番号、住所は各1個まで
#    - 複数値属性は現在サポートされていません
#
#---------------------------------------------------------------
