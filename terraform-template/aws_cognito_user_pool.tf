#-----------------------------------------------------------------------
# Cognito User Pool
#-----------------------------------------------------------------------
# Amazon Cognito ユーザープールを作成し、認証・認可機能を提供します。
# ユーザーのサインアップ・サインイン、MFA、パスワードポリシー、アカウント復旧などを一元管理します。
#
# 主な機能:
# - ユーザー認証（メール/電話番号/ユーザー名）
# - 多要素認証（SMS、TOTP、WebAuthn）
# - パスワードポリシー設定
# - Lambda トリガー統合
# - カスタム属性定義
# - デバイス記憶機能
# - アカウント復旧メカニズム
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# NOTE: このファイルは自動生成されたテンプレートです。実際の環境に合わせて調整してください。
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cognito_user_pool
#-----------------------------------------------------------------------

resource "aws_cognito_user_pool" "example" {
  #-----------------------------------------------------------------------
  # 基本設定
  #-----------------------------------------------------------------------
  # 設定内容: ユーザープール名（変更不可）
  name = "my-user-pool"

  # 設定内容: 削除保護の有効化
  # 設定可能な値: ACTIVE（保護有効）、INACTIVE（保護無効）
  # 省略時: INACTIVE
  deletion_protection = "INACTIVE"

  #-----------------------------------------------------------------------
  # ユーザー名・エイリアス設定
  #-----------------------------------------------------------------------
  # 設定内容: サインイン時にユーザー名として使用できる属性
  # 設定可能な値: phone_number、email、preferred_username
  # 注意: alias_attributes と同時指定不可
  username_attributes = ["email"]

  # 設定内容: ユーザー名の代わりに使用できるエイリアス属性
  # 設定可能な値: phone_number、email、preferred_username
  # 注意: username_attributes と同時指定不可、username_attributes を使用する場合は null に設定
  alias_attributes = null

  #-----------------------------------------------------------------------
  # 自動検証設定
  #-----------------------------------------------------------------------
  # 設定内容: 自動的に検証する属性
  # 設定可能な値: email、phone_number
  auto_verified_attributes = ["email"]

  #-----------------------------------------------------------------------
  # MFA 設定
  #-----------------------------------------------------------------------
  # 設定内容: 多要素認証の要求レベル
  # 設定可能な値: OFF（無効）、ON（必須）、OPTIONAL（ユーザー選択）
  # 省略時: OFF
  mfa_configuration = "OPTIONAL"

  #-----------------------------------------------------------------------
  # 検証メッセージ設定（レガシー、verification_message_template 推奨）
  #-----------------------------------------------------------------------
  # 設定内容: メール検証メッセージ
  # 注意: {####} プレースホルダーを含める必要があります
  # 省略時: verification_message_template で設定、または Cognito のデフォルトを使用
  email_verification_message = null

  # 設定内容: メール検証件名
  # 省略時: verification_message_template で設定、または Cognito のデフォルトを使用
  email_verification_subject = null

  # 設定内容: SMS 検証メッセージ
  # 注意: {####} プレースホルダーを含める必要があります
  # 省略時: verification_message_template で設定、または Cognito のデフォルトを使用
  sms_verification_message = null

  #-----------------------------------------------------------------------
  # SMS 認証メッセージ設定
  #-----------------------------------------------------------------------
  # 設定内容: SMS による MFA 認証時のメッセージテンプレート
  # 注意: {####} プレースホルダーを含める必要があります
  sms_authentication_message = "Your authentication code is {####}"

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------
  # 設定内容: ユーザープールを作成するリージョン
  # 省略時: プロバイダー設定のリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-----------------------------------------------------------------------
  # ユーザープールティア設定
  #-----------------------------------------------------------------------
  # 設定内容: ユーザープールのティア
  # 設定可能な値: ESSENTIALS（推奨）、LITE（基本機能のみ）
  # 省略時: AWS が自動的に割り当て（通常は ESSENTIALS）
  # 注意: ティアによって利用可能な機能が異なります
  user_pool_tier = null

  #-----------------------------------------------------------------------
  # タグ
  #-----------------------------------------------------------------------
  # 設定内容: リソースタグ
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-----------------------------------------------------------------------
  # アカウント復旧設定
  #-----------------------------------------------------------------------
  account_recovery_setting {
    # 設定内容: アカウント復旧メカニズム（優先順位順に最大2つ）
    recovery_mechanism {
      # 設定内容: 復旧方法の種類
      # 設定可能な値: verified_email、verified_phone_number、admin_only
      name = "verified_email"

      # 設定内容: 優先度（1が最優先）
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  #-----------------------------------------------------------------------
  # 管理者によるユーザー作成設定
  #-----------------------------------------------------------------------
  admin_create_user_config {
    # 設定内容: ユーザーが自己サインアップ可能か
    # 省略時: false（管理者のみ作成可能）
    # allow_admin_create_user_only = false

    # 設定内容: 招待メッセージのカスタマイズ
    invite_message_template {
      # 設定内容: メール本文テンプレート
      # 注意: {username}、{####} プレースホルダーが使用可能
      # email_message = "Your username is {username} and temporary password is {####}"

      # 設定内容: メール件名
      # email_subject = "Your temporary password"

      # 設定内容: SMS メッセージテンプレート
      # sms_message = "Your username is {username} and temporary password is {####}"
    }
  }

  #-----------------------------------------------------------------------
  # デバイス設定
  #-----------------------------------------------------------------------
  device_configuration {
    # 設定内容: デバイスの記憶をユーザーに促すか
    # 省略時: false
    # challenge_required_on_new_device = true

    # 設定内容: 記憶されたデバイスのみサインイン許可するか
    # 省略時: false
    # device_only_remembered_on_user_prompt = false
  }

  #-----------------------------------------------------------------------
  # メール設定
  #-----------------------------------------------------------------------
  email_configuration {
    # 設定内容: メール送信元アカウント
    # 設定可能な値: COGNITO_DEFAULT（Cognito のデフォルト）、DEVELOPER（SES 使用）
    # 省略時: COGNITO_DEFAULT
    # email_sending_account = "DEVELOPER"

    # 設定内容: SES 送信元 ARN（email_sending_account=DEVELOPER 時に必要）
    # source_arn = "arn:aws:ses:us-east-1:123456789012:identity/example.com"

    # 設定内容: From メールアドレス
    # from_email_address = "no-reply@example.com"

    # 設定内容: Reply-To メールアドレス
    # reply_to_email_address = "support@example.com"

    # 設定内容: SES Configuration Set 名
    # configuration_set = "my-configuration-set"
  }

  #-----------------------------------------------------------------------
  # メール MFA 設定
  #-----------------------------------------------------------------------
  email_mfa_configuration {
    # 設定内容: メール MFA のメッセージ
    # 注意: {####} プレースホルダーを含める必要があります
    # message = "Your verification code is {####}"

    # 設定内容: メール件名
    # subject = "Your verification code"
  }

  #-----------------------------------------------------------------------
  # Lambda トリガー設定
  #-----------------------------------------------------------------------
  lambda_config {
    # 設定内容: カスタム認証チャレンジ作成 Lambda
    # create_auth_challenge = "arn:aws:lambda:us-east-1:123456789012:function:create-auth-challenge"

    # 設定内容: カスタムメッセージ生成 Lambda
    # custom_message = "arn:aws:lambda:us-east-1:123456789012:function:custom-message"

    # 設定内容: 認証チャレンジ定義 Lambda
    # define_auth_challenge = "arn:aws:lambda:us-east-1:123456789012:function:define-auth-challenge"

    # 設定内容: Lambda トリガーの暗号化に使用する KMS キー ARN
    # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

    # 設定内容: 認証後トリガー Lambda
    # post_authentication = "arn:aws:lambda:us-east-1:123456789012:function:post-authentication"

    # 設定内容: 確認後トリガー Lambda
    # post_confirmation = "arn:aws:lambda:us-east-1:123456789012:function:post-confirmation"

    # 設定内容: 認証前トリガー Lambda
    # pre_authentication = "arn:aws:lambda:us-east-1:123456789012:function:pre-authentication"

    # 設定内容: サインアップ前トリガー Lambda
    # pre_sign_up = "arn:aws:lambda:us-east-1:123456789012:function:pre-sign-up"

    # 設定内容: トークン生成前トリガー Lambda（レガシー）
    # pre_token_generation = "arn:aws:lambda:us-east-1:123456789012:function:pre-token-generation"

    # 設定内容: ユーザー移行トリガー Lambda
    # user_migration = "arn:aws:lambda:us-east-1:123456789012:function:user-migration"

    # 設定内容: 認証チャレンジ検証 Lambda
    # verify_auth_challenge_response = "arn:aws:lambda:us-east-1:123456789012:function:verify-auth-challenge"

    # 設定内容: カスタムメール送信者設定
    custom_email_sender {
      # 設定内容: Lambda 関数 ARN
      lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:custom-email-sender"

      # 設定内容: Lambda のバージョン
      # 設定可能な値: V1_0
      lambda_version = "V1_0"
    }

    # 設定内容: カスタム SMS 送信者設定
    custom_sms_sender {
      # 設定内容: Lambda 関数 ARN
      lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:custom-sms-sender"

      # 設定内容: Lambda のバージョン
      # 設定可能な値: V1_0
      lambda_version = "V1_0"
    }

    # 設定内容: トークン生成前設定（V2）
    pre_token_generation_config {
      # 設定内容: Lambda 関数 ARN
      lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:pre-token-generation-v2"

      # 設定内容: Lambda のバージョン
      # 設定可能な値: V2_0
      lambda_version = "V2_0"
    }
  }

  #-----------------------------------------------------------------------
  # パスワードポリシー
  #-----------------------------------------------------------------------
  password_policy {
    # 設定内容: パスワードの最小文字数
    # 省略時: 8
    minimum_length = 12

    # 設定内容: パスワード履歴の記憶数（再利用防止）
    # 設定可能な値: 0-24
    # 省略時: 0（履歴チェックなし）
    # password_history_size = 5

    # 設定内容: 小文字の要求
    # 省略時: false
    # require_lowercase = true

    # 設定内容: 数字の要求
    # 省略時: false
    # require_numbers = true

    # 設定内容: 記号の要求
    # 省略時: false
    # require_symbols = true

    # 設定内容: 大文字の要求
    # 省略時: false
    # require_uppercase = true

    # 設定内容: 一時パスワードの有効期限（日数）
    # 設定可能な値: 1-365
    # 省略時: 7
    # temporary_password_validity_days = 3
  }

  #-----------------------------------------------------------------------
  # カスタム属性スキーマ（最大50個）
  #-----------------------------------------------------------------------
  schema {
    # 設定内容: 属性名
    name = "department"

    # 設定内容: 属性のデータ型
    # 設定可能な値: String、Number、DateTime、Boolean
    attribute_data_type = "String"

    # 設定内容: ユーザーによる変更可否
    # 省略時: true
    # 注意: false に設定すると作成後変更不可
    # mutable = true

    # 設定内容: サインアップ時の必須項目か
    # 省略時: false
    # required = false

    # 設定内容: 開発者専用属性か（ユーザーは読み書き不可）
    # 省略時: false
    # developer_only_attribute = false

    # 設定内容: String 型属性の制約
    string_attribute_constraints {
      # 設定内容: 最小文字数
      # 設定可能な値: 0-2048
      # min_length = "0"

      # 設定内容: 最大文字数
      # 設定可能な値: 0-2048
      # max_length = "256"
    }
  }

  schema {
    name                = "employee_id"
    attribute_data_type = "Number"

    # 設定内容: Number 型属性の制約
    number_attribute_constraints {
      # 設定内容: 最小値
      # min_value = "0"

      # 設定内容: 最大値
      # max_value = "999999"
    }
  }

  #-----------------------------------------------------------------------
  # サインインポリシー（新機能）
  #-----------------------------------------------------------------------
  sign_in_policy {
    # 設定内容: サインインに使用可能な識別子
    # サブブロック形式で設定
    identifier {
      # 設定内容: メールアドレスでのサインイン許可
      # 省略時: false
      # email = true

      # 設定内容: 電話番号でのサインイン許可
      # 省略時: false
      # phone_number = false

      # 設定内容: ユーザー名でのサインイン許可
      # 省略時: false
      # username = true

      # 設定内容: 優先ユーザー名でのサインイン許可
      # 省略時: false
      # preferred_username = false
    }
  }

  #-----------------------------------------------------------------------
  # SMS 設定
  #-----------------------------------------------------------------------
  sms_configuration {
    # 設定内容: SNS Caller ARN（SMS 送信用 IAM ロール）
    external_id = "example-external-id"

    # 設定内容: SMS 送信に使用する SNS Caller ARN
    sns_caller_arn = "arn:aws:iam::123456789012:role/service-role/cognito-sns-role"

    # 設定内容: SNS リージョン
    # 省略時: ユーザープールと同じリージョン
    # sns_region = "us-east-1"
  }

  #-----------------------------------------------------------------------
  # ソフトウェアトークン MFA 設定
  #-----------------------------------------------------------------------
  software_token_mfa_configuration {
    # 設定内容: TOTP の有効化
    # 省略時: false
    enabled = true
  }

  #-----------------------------------------------------------------------
  # ユーザー属性更新設定
  #-----------------------------------------------------------------------
  user_attribute_update_settings {
    # 設定内容: 更新時に再検証が必要な属性
    # 設定可能な値: email、phone_number
    attributes_require_verification_before_update = ["email"]
  }

  #-----------------------------------------------------------------------
  # 高度なセキュリティモード
  #-----------------------------------------------------------------------
  user_pool_add_ons {
    # 設定内容: 高度なセキュリティモード
    # 設定可能な値: OFF（無効）、AUDIT（監査モード）、ENFORCED（強制モード）
    # 省略時: OFF
    advanced_security_mode = "AUDIT"

    # 設定内容: 高度なセキュリティ機能に使用する KMS キー ID
    # advanced_security_additional_flows {
    #   custom_auth_mode = "USER_AUTH"
    # }
  }

  #-----------------------------------------------------------------------
  # ユーザー名設定
  #-----------------------------------------------------------------------
  username_configuration {
    # 設定内容: ユーザー名の大文字小文字を区別しない
    # 省略時: false
    case_sensitive = false
  }

  #-----------------------------------------------------------------------
  # 検証メッセージテンプレート
  #-----------------------------------------------------------------------
  verification_message_template {
    # 設定内容: デフォルトのメール送信オプション
    # 設定可能な値: CONFIRM_WITH_LINK（リンク確認）、CONFIRM_WITH_CODE（コード確認）
    # 省略時: CONFIRM_WITH_CODE
    default_email_option = "CONFIRM_WITH_CODE"

    # 設定内容: メール確認メッセージ（CONFIRM_WITH_CODE 時）
    # 注意: {####} プレースホルダーを含める必要があります
    # email_message = "Your verification code is {####}"

    # 設定内容: メール確認メッセージ（リンク形式）
    # 注意: {##Click Here##} プレースホルダーを含める必要があります
    # email_message_by_link = "Please click the link below to verify your email address. {##Click Here##}"

    # 設定内容: メール件名
    # email_subject = "Your verification code"

    # 設定内容: メール件名（リンク形式）
    # email_subject_by_link = "Your verification link"

    # 設定内容: SMS 確認メッセージ
    # 注意: {####} プレースホルダーを含める必要があります
    # sms_message = "Your verification code is {####}"
  }

  #-----------------------------------------------------------------------
  # WebAuthn 設定（パスキー対応）
  #-----------------------------------------------------------------------
  web_authn_configuration {
    # 設定内容: Relying Party ID（通常はドメイン名）
    relying_party_id = "example.com"

    # 設定内容: ユーザー検証の要求レベル
    # 設定可能な値: required（必須）、preferred（推奨）、discouraged（非推奨）
    # 省略時: preferred
    # user_verification = "preferred"
  }
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# arn - ユーザープールの ARN
# id - ユーザープールの ID
# endpoint - ユーザープールのエンドポイント URL
# creation_date - ユーザープール作成日時（RFC3339 形式）
# last_modified_date - 最終更新日時（RFC3339 形式）
# domain - Cognito ドメイン（aws_cognito_user_pool_domain で設定されている場合）
# custom_domain - カスタムドメイン（設定されている場合）
# estimated_number_of_users - ユーザープール内の推定ユーザー数
# tags_all - デフォルトタグを含む全タグのマップ
