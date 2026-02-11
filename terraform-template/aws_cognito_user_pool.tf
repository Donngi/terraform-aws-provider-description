# ================================================================================
# Terraform AWS Provider Resource Template
# ================================================================================
# Resource: aws_cognito_user_pool
# Provider Version: 6.28.0
# Generated: 2026-01-19
#
# このテンプレートは生成時点でのAWS Provider仕様に基づいています。
# 最新の仕様については公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool
# ================================================================================

resource "aws_cognito_user_pool" "example" {
  # ================================================================================
  # Required Attributes
  # ================================================================================

  # (必須) ユーザープールの名前
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings.html
  name = "example-user-pool"

  # ================================================================================
  # Optional Attributes
  # ================================================================================

  # (オプション) ユーザープールのエイリアス属性として使用可能な属性
  # 有効な値: "phone_number", "email", "preferred_username"
  # username_attributesと競合するため、どちらか一方のみを指定すること
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-attributes.html
  alias_attributes = ["email", "preferred_username"]

  # (オプション) 自動検証される属性
  # 有効な値: "email", "phone_number"
  # ユーザーがこれらの属性を追加すると、Cognitoが自動的に検証コードを送信する
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-attributes.html
  auto_verified_attributes = ["email"]

  # (オプション) 削除保護の設定
  # 有効な値: "ACTIVE" (削除保護有効), "INACTIVE" (削除保護無効、デフォルト)
  # ACTIVEに設定すると、誤ってユーザープールを削除することを防ぐ
  # https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pool-deletion-protection.html
  deletion_protection = "INACTIVE"

  # (オプション) メール検証メッセージのテンプレート
  # メッセージには {####} プレースホルダーを含める必要があり、検証コードに置き換えられる
  # verification_message_template ブロックの email_message 引数と競合する
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-email-phone-verification.html
  email_verification_message = "Your verification code is {####}"

  # (オプション) メール検証の件名
  # verification_message_template ブロックの email_subject 引数と競合する
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-email-phone-verification.html
  email_verification_subject = "Your verification code"

  # (オプション) Multi-Factor Authentication (MFA) の設定
  # 有効な値:
  #   - "OFF": MFAトークンは不要（デフォルト）
  #   - "ON": すべてのユーザーにMFAが必須（email_mfa_configuration, sms_configuration, software_token_mfa_configurationのいずれか1つ以上の設定が必要）
  #   - "OPTIONAL": MFAを有効にした個別ユーザーのみにMFAが要求される（email_mfa_configuration, sms_configuration, software_token_mfa_configurationのいずれか1つ以上の設定が必要）
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-mfa.html
  mfa_configuration = "OFF"

  # (オプション) このリソースが管理されるリージョン
  # デフォルトはプロバイダー設定のリージョンが使用される
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # (オプション) SMS認証メッセージのテンプレート
  # メッセージには {####} プレースホルダーを含める必要があり、認証コードに置き換えられる
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-mfa-sms-text-message.html
  sms_authentication_message = "Your authentication code is {####}"

  # (オプション) SMS検証メッセージのテンプレート
  # verification_message_template ブロックの sms_message 引数と競合する
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-email-phone-verification.html
  sms_verification_message = "Your verification code is {####}"

  # (オプション) ユーザープールに割り当てるタグのマップ
  # プロバイダーのdefault_tags設定ブロックがある場合、一致するキーのタグは上書きされる
  # https://docs.aws.amazon.com/cognito/latest/developerguide/tagging.html
  tags = {
    Environment = "production"
    Project     = "example"
  }

  # (オプション) すべてのタグのマップ（プロバイダーのdefault_tagsから継承されたタグを含む）
  # 通常、このフィールドは明示的に設定する必要はない
  tags_all = {}

  # (オプション) ユーザープールの機能プラン（tier）
  # 有効な値: "LITE", "ESSENTIALS", "PLUS"
  # https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-sign-in-feature-plans.html
  user_pool_tier = null

  # (オプション) ユーザーがサインアップする際にユーザー名として指定できる属性
  # 有効な値: "email", "phone_number"
  # alias_attributesと競合するため、どちらか一方のみを指定すること
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-attributes.html
  username_attributes = []

  # ================================================================================
  # Optional Nested Blocks
  # ================================================================================

  # (オプション) アカウントリカバリ設定
  # ユーザーがパスワードを忘れた場合の復旧方法を定義する
  # https://docs.aws.amazon.com/cognito/latest/developerguide/how-to-recover-a-user-account.html
  account_recovery_setting {
    # recovery_mechanism ブロックのリスト
    # 各メカニズムには name と priority が必要
    recovery_mechanism {
      # (必須) ユーザーの復旧方法
      # 有効な値: "verified_email", "verified_phone_number", "admin_only"
      name = "verified_email"

      # (必須) 方法の優先度を指定する正の整数（1が最高優先度）
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  # (オプション) 管理者によるユーザー作成の設定
  # https://docs.aws.amazon.com/cognito/latest/developerguide/how-to-create-user-accounts.html
  admin_create_user_config {
    # (オプション) 管理者のみがユーザープロフィールを作成できるかどうか
    # true: 管理者のみがユーザーを作成可能
    # false: ユーザーがアプリ経由で自分自身をサインアップ可能（デフォルト）
    allow_admin_create_user_only = false

    # (オプション) 招待メッセージのテンプレート設定
    invite_message_template {
      # (オプション) メールメッセージのテンプレート
      # {username} と {####} のプレースホルダーを含める必要がある
      email_message = "Your username is {username} and temporary password is {####}."

      # (オプション) メールの件名
      email_subject = "Your temporary password"

      # (オプション) SMSメッセージのテンプレート
      # {username} と {####} のプレースホルダーを含める必要がある
      sms_message = "Your username is {username} and temporary password is {####}."
    }
  }

  # (オプション) デバイストラッキングの設定
  # https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-device-tracking.html
  device_configuration {
    # (オプション) 新しいデバイスでチャレンジが必要かどうか
    # 新しいデバイスにのみ適用される
    challenge_required_on_new_device = false

    # (オプション) デバイスがユーザープロンプト時のみ記憶されるかどうか
    # false: "Always" 記憶する（デフォルト）
    # true: "User Opt In"（ユーザーが選択）
    # device_configuration ブロックを使用しない場合は "No"
    device_only_remembered_on_user_prompt = false
  }

  # (オプション) メール設定
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-email.html
  email_configuration {
    # (オプション) SESのメール設定セット名
    configuration_set = null

    # (オプション) メール配信方法
    # 有効な値:
    #   - "COGNITO_DEFAULT": Cognitoに組み込まれたデフォルトのメール機能
    #   - "DEVELOPER": Amazon SES設定を使用（from_email_addressを設定する場合は必須）
    email_sending_account = "COGNITO_DEFAULT"

    # (オプション) 送信者のメールアドレスまたは表示名付きメールアドレス
    # 例: "john@example.com", "John Smith <john@example.com>", "\"John Smith Ph.D.\" <john@example.com>"
    # RFC 5322に従って、特定の文字を含む表示名にはエスケープされた二重引用符が必要
    # email_sending_accountがDEVELOPERの場合に設定可能
    from_email_address = null

    # (オプション) REPLY-TOメールアドレス
    reply_to_email_address = null

    # (オプション) SES検証済みメールIDのARN
    # email_sending_accountがDEVELOPERに設定されている場合は必須
    source_arn = null
  }

  # (オプション) メールMFAの設定
  # email_configurationブロックが必要
  # account_recovery_settingに少なくとも2つのエントリが必要
  # mfa_configurationがONまたはOPTIONALの場合のみ有効
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-mfa.html
  email_mfa_configuration {
    # (オプション) MFAおよびメールOTPでのサインイン用のメールメッセージテンプレート
    # メッセージには {####} プレースホルダーを含める必要がある
    message = "Your verification code is {####}"

    # (オプション) メールの件名
    subject = "Your verification code"
  }

  # (オプション) ユーザープールに関連付けられたAWS Lambdaトリガーの設定
  # https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-identity-pools-working-with-aws-lambda-triggers.html
  lambda_config {
    # (オプション) 認証チャレンジを作成するLambdaのARN
    create_auth_challenge = null

    # (オプション) カスタムメッセージLambdaトリガーのARN
    custom_message = null

    # (オプション) 認証チャレンジを定義するLambdaのARN
    define_auth_challenge = null

    # (オプション) 認証後のLambdaトリガーのARN
    post_authentication = null

    # (オプション) 確認後のLambdaトリガーのARN
    post_confirmation = null

    # (オプション) 認証前のLambdaトリガーのARN
    pre_authentication = null

    # (オプション) 登録前のLambdaトリガーのARN
    pre_sign_up = null

    # (オプション) トークン生成前にIDトークンクレームをカスタマイズできるようにする（レガシー用途）
    # 新しいインスタンスの場合は、pre_token_generation_config の lambda_arn を設定すること
    pre_token_generation = null

    # (オプション) ユーザー移行Lambdaトリガーのタイプ
    user_migration = null

    # (オプション) 認証チャレンジレスポンスを検証するLambdaのARN
    verify_auth_challenge_response = null

    # (オプション) Key Management ServiceカスタマーマスターキーのARN
    # CognitoはこのキーでCustomEmailSenderとCustomSMSSenderに送信されるコードと一時パスワードを暗号化する
    kms_key_id = null

    # (オプション) カスタムメール送信者のLambdaトリガー
    custom_email_sender {
      # (必須) ユーザーにメール通知を送信するためにCognitoがトリガーするLambda関数のARN
      lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:custom-email-sender"

      # (必須) Lambdaバージョン（"event"情報の"request"属性の署名を表す）
      # サポートされる値: "V1_0"
      lambda_version = "V1_0"
    }

    # (オプション) カスタムSMS送信者のLambdaトリガー
    custom_sms_sender {
      # (必須) ユーザーにSMS通知を送信するためにCognitoがトリガーするLambda関数のARN
      lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:custom-sms-sender"

      # (必須) Lambdaバージョン（"event"情報の"request"属性の署名を表す）
      # サポートされる値: "V1_0"
      lambda_version = "V1_0"
    }

    # (オプション) アクセストークンをカスタマイズするためのトークン生成前の設定
    pre_token_generation_config {
      # (必須) アクセストークンをカスタマイズするためにCognitoがトリガーするLambda関数のARN
      # pre_token_generationにもARNを設定する場合、この値と同一である必要がある
      lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:pre-token-generation"

      # (必須) Lambdaバージョン（"event"情報の"version"属性の署名を表す）
      # サポートされる値: "V1_0", "V2_0", "V3_0"
      lambda_version = "V2_0"
    }
  }

  # (オプション) パスワードポリシーの設定
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-policies.html
  password_policy {
    # (オプション) パスワードの最小文字数
    # デフォルト: 8
    minimum_length = 8

    # (オプション) ユーザーが再利用できないようにする過去のパスワードの数
    # 0: パスワード履歴は強制されない
    # 有効な値: 0〜24
    # 注意: この引数には、ユーザープールで高度なセキュリティ機能がアクティブである必要がある
    password_history_size = 0

    # (オプション) パスワードに少なくとも1つの小文字を含めることを要求するかどうか
    require_lowercase = true

    # (オプション) パスワードに少なくとも1つの数字を含めることを要求するかどうか
    require_numbers = true

    # (オプション) パスワードに少なくとも1つの記号を含めることを要求するかどうか
    require_symbols = true

    # (オプション) パスワードに少なくとも1つの大文字を含めることを要求するかどうか
    require_uppercase = true

    # (オプション) 一時パスワードが有効な日数
    # この期間内にユーザーがサインインしない場合、管理者によってパスワードをリセットする必要がある
    temporary_password_validity_days = 7
  }

  # (オプション) スキーマ属性の設定
  # 標準属性セットのスキーマ属性は、デフォルト設定と異なる場合のみ指定する必要がある
  # 属性は追加できるが、変更または削除はできない
  # 最大50属性
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-attributes.html
  schema {
    # (必須) 属性のデータ型
    # 有効な値: "Boolean", "Number", "String", "DateTime"
    attribute_data_type = "String"

    # (オプション) 属性タイプが開発者専用かどうか
    developer_only_attribute = false

    # (オプション) 属性が作成後に変更可能かどうか
    mutable = true

    # (必須) 属性の名前
    name = "email"

    # (オプション) ユーザープール属性が必須かどうか
    # 属性が必須でユーザーが値を提供しない場合、登録またはサインインは失敗する
    required = false

    # (attribute_data_type が "String" の場合は必須) 文字列型の属性の制約
    string_attribute_constraints {
      # (オプション) 文字列型の属性値の最大長
      max_length = "2048"

      # (オプション) 文字列型の属性値の最小長
      min_length = "0"
    }
  }

  # 数値型の属性の例
  schema {
    attribute_data_type = "Number"
    mutable             = true
    name                = "age"
    required            = false

    # (attribute_data_type が "Number" の場合は必須) 数値型の属性の制約
    number_attribute_constraints {
      # (オプション) 数値データ型の属性の最大値
      max_value = "120"

      # (オプション) 数値データ型の属性の最小値
      min_value = "0"
    }
  }

  # (オプション) サインインポリシーの設定
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-sign-in-options.html
  sign_in_policy {
    # (オプション) 許可される最初の認証要素のリスト
    # 有効な値: "PASSWORD", "EMAIL_OTP", "SMS_OTP", "WEB_AUTHN"
    # https://docs.aws.amazon.com/cognito/latest/developerguide/sign-in-with-passwordless.html
    allowed_first_auth_factors = ["PASSWORD"]
  }

  # (オプション) SMS設定（SMS検証およびSMS MFAに適用される）
  # SMS MFAは、mfa_configurationがONまたはOPTIONALに設定され、このブロックが存在する場合にのみアクティブになる
  # Cognito APIの制限により、ユーザープールを再作成せずにSMS設定を削除することはできない
  # ユーザーデータの安全性のため、このリソースはドリフト検出を無効にすることでこの設定の削除を無視する
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-sms-settings.html
  sms_configuration {
    # (必須) IAMロール信頼関係で使用される外部ID
    # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user_externalid.html
    external_id = "example-external-id"

    # (必須) Amazon SNS呼び出し元のARN（通常、Cognitoに権限を与えたIAMロール）
    sns_caller_arn = "arn:aws:iam::123456789012:role/service-role/CognitoSNSRole"

    # (オプション) Amazon SNS統合で使用するAWSリージョン
    # ユーザープールと同じリージョン、またはサポートされているレガシーAmazon SNS代替リージョンを選択できる
    # Asia Pacific (Seoul) リージョンのリソースは、Asia Pacific (Tokyo) リージョンのSNS設定を使用する必要がある
    # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-sms-settings.html
    sns_region = "us-east-1"
  }

  # (オプション) ソフトウェアトークンMFA設定
  # mfa_configurationがONまたはOPTIONALの場合のみ有効
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-mfa-totp.html
  software_token_mfa_configuration {
    # (必須) Time-based One-Time Password (TOTP) などのソフトウェアトークンMFAトークンを有効にするかどうか
    # sms_configurationが存在しない状態でソフトウェアトークンMFAを無効にするには、
    # mfa_configuration引数をOFFに設定し、software_token_mfa_configuration設定ブロックを完全に削除する必要がある
    enabled = true
  }

  # (オプション) ユーザー属性更新設定
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-attributes.html
  user_attribute_update_settings {
    # (必須) 更新前に検証が必要な属性のリスト
    # 設定する場合、指定された値はauto_verified_attributesにも設定されている必要がある
    # 有効な値: "email", "phone_number"
    attributes_require_verification_before_update = ["email"]
  }

  # (オプション) ユーザープールの高度なセキュリティモード機能を有効にするためのアドオン設定
  # https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pool-settings-advanced-security.html
  user_pool_add_ons {
    # (必須) 高度なセキュリティのモード
    # 有効な値: "OFF", "AUDIT", "ENFORCED"
    #   - OFF: 高度なセキュリティ機能を無効化
    #   - AUDIT: 脅威を検出してログに記録するが、ブロックはしない
    #   - ENFORCED: 脅威を検出してブロックする
    advanced_security_mode = "OFF"

    # (オプション) カスタム認証を含む、ユーザープール内の追加の認証タイプの脅威保護設定オプション
    advanced_security_additional_flows {
      # (オプション) カスタム認証での脅威保護操作モード
      # 有効な値: "AUDIT", "ENFORCED"
      # デフォルト: "AUDIT"
      custom_auth_mode = "AUDIT"
    }
  }

  # (オプション) ユーザー名の設定
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-attributes.html
  username_configuration {
    # (オプション) Cognito API経由でユーザープール内のすべてのユーザーに対して
    # ユーザー名の大文字小文字の区別を適用するかどうか
    case_sensitive = false
  }

  # (オプション) 検証メッセージテンプレートの設定
  # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-email-phone-verification.html
  verification_message_template {
    # (オプション) デフォルトのメール検証オプション
    # 有効な値: "CONFIRM_WITH_CODE" (デフォルト), "CONFIRM_WITH_LINK"
    default_email_option = "CONFIRM_WITH_CODE"

    # (オプション) メールメッセージテンプレート（CONFIRM_WITH_CODE用）
    # メッセージには {####} プレースホルダーを含める必要がある
    # トップレベルのemail_verification_messageと競合する
    email_message = "Your verification code is {####}"

    # (オプション) リンク付きメールメッセージテンプレート（CONFIRM_WITH_LINK用）
    # メッセージには {##Click Here##} プレースホルダーを含める必要がある
    email_message_by_link = "Please click the link below to verify your email address. {##Verify Email##}"

    # (オプション) メールの件名（CONFIRM_WITH_CODE用）
    # トップレベルのemail_verification_subjectと競合する
    email_subject = "Your verification code"

    # (オプション) リンク付きメールの件名（CONFIRM_WITH_LINK用）
    email_subject_by_link = "Your verification link"

    # (オプション) SMSメッセージテンプレート
    # メッセージには {####} プレースホルダーを含める必要がある
    # トップレベルのsms_verification_messageと競合する
    sms_message = "Your verification code is {####}"
  }

  # (オプション) Web認証（WebAuthn）の設定
  # パスキープロバイダーが依拠当事者として使用する認証ドメインを設定する
  # https://docs.aws.amazon.com/cognito/latest/developerguide/passkeys.html
  web_authn_configuration {
    # (オプション) パスキープロバイダーが依拠当事者として使用する認証ドメイン
    relying_party_id = "example.com"

    # (オプション) ユーザープールがパスキーを要求するかどうか
    # 有効な値: "required", "preferred"
    user_verification = "preferred"
  }

  # ================================================================================
  # Computed Attributes (Read-Only)
  # ================================================================================
  # 以下の属性は自動的に計算され、参照のみ可能です（設定不可）:
  #
  # - arn                           : ユーザープールのARN
  # - creation_date                 : ユーザープールが作成された日付
  # - custom_domain                 : カスタムドメイン名
  # - domain                        : ユーザープールに関連付けられたドメインプレフィックス
  # - endpoint                      : ユーザープールのエンドポイント名（例: cognito-idp.REGION.amazonaws.com/xxxx_yyyyy）
  # - estimated_number_of_users     : ユーザープールのサイズを推定する数値
  # - id                            : ユーザープールのID
  # - last_modified_date            : ユーザープールが最後に変更された日付
  # ================================================================================
}
