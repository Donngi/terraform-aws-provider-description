###############################################################################################
# Terraform Template: aws_cognito_risk_configuration
#
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-19)の情報に基づいています
# - 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください
# - AWS公式: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_SetRiskConfiguration.html
# - Terraform公式: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_risk_configuration
#
# 概要:
# Amazon Cognito User Poolの脅威保護設定を管理するリソース。
# アダプティブ認証による不正アクセスの検出とブロック、漏洩認証情報の検出、
# リスクのあるアクティビティに対する通知、IPアドレスベースの例外設定などが可能。
# このリソースの利用にはCognito Plus tierが必要です。
###############################################################################################

resource "aws_cognito_risk_configuration" "example" {
  # ============================================================================
  # 必須パラメータ
  # ============================================================================

  # (Required) ユーザープールID
  # リスク設定を適用するCognito User PoolのID
  # https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_SetRiskConfiguration.html
  user_pool_id = "us-east-1_example"

  # ============================================================================
  # オプションパラメータ
  # ============================================================================

  # (Optional) アプリクライアントID
  # 指定すると、そのアプリクライアントにのみリスク設定が適用される
  # 未指定の場合は、User Pool内の全クライアントに同じリスク設定が適用される
  # https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_SetRiskConfiguration.html
  client_id = "example_client_id"

  # (Optional) リージョン指定
  # このリソースを管理するAWSリージョン
  # 未指定の場合はプロバイダー設定のリージョンがデフォルトで使用される
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # ============================================================================
  # アカウント乗っ取りリスク設定
  # ============================================================================

  # (Optional) アカウント乗っ取りのリスク設定
  # アダプティブ認証により、不審なサインイン試行を検出し、
  # リスクレベル（High/Medium/Low）に応じた自動応答を設定
  # https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pool-settings-adaptive-authentication.html
  account_takeover_risk_configuration {

    # (Required) アカウント乗っ取りリスクに対するアクション設定
    actions {

      # (Optional) 高リスク時のアクション
      high_action {
        # (Required) 実行するアクション
        # 有効な値: BLOCK, MFA_IF_CONFIGURED, MFA_REQUIRED, NO_ACTION
        # BLOCK: 認証をブロック
        # MFA_IF_CONFIGURED: MFAが設定されている場合はMFAを要求
        # MFA_REQUIRED: MFAを必須とする
        # NO_ACTION: 何もしない（監査のみ）
        event_action = "BLOCK"

        # (Required) 通知を送信するかどうか
        # true: ユーザーに通知メールを送信
        # false: 通知しない
        notify = true
      }

      # (Optional) 中リスク時のアクション
      medium_action {
        # (Required) 実行するアクション
        # 有効な値: BLOCK, MFA_IF_CONFIGURED, MFA_REQUIRED, NO_ACTION
        event_action = "MFA_IF_CONFIGURED"

        # (Required) 通知を送信するかどうか
        notify = true
      }

      # (Optional) 低リスク時のアクション
      low_action {
        # (Required) 実行するアクション
        # 有効な値: BLOCK, MFA_IF_CONFIGURED, MFA_REQUIRED, NO_ACTION
        event_action = "NO_ACTION"

        # (Required) 通知を送信するかどうか
        notify = false
      }
    }

    # (Optional) 通知設定
    # リスクのある活動が検出された際にユーザーに送信するメール通知の設定
    notify_configuration {

      # (Required) 送信元ARN
      # メール送信に使用するSES (Simple Email Service) のID ARN
      # この送信元は事前にSESで検証済みである必要がある
      # https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_NotifyConfigurationType.html
      source_arn = "arn:aws:ses:us-east-1:123456789012:identity/example.com"

      # (Optional) 送信元メールアドレス
      # メールの送信元アドレス
      # このアドレスは個別にSESで検証済みであるか、検証済みドメインのものである必要がある
      from = "no-reply@example.com"

      # (Optional) 返信先メールアドレス
      # メールの受信者が返信する際の宛先アドレス
      reply_to = "support@example.com"

      # (Optional) ブロック時のメールテンプレート
      # リスクイベントがブロックされた際に送信するメール
      block_email {
        # (Required) メールの件名
        subject = "Suspicious Sign-In Attempt Blocked"

        # (Required) HTMLメール本文
        html_body = "<html><body><h1>Your account was accessed from a suspicious location</h1><p>We blocked this sign-in attempt to protect your account.</p></body></html>"

        # (Required) テキストメール本文
        text_body = "Your account was accessed from a suspicious location. We blocked this sign-in attempt to protect your account."
      }

      # (Optional) MFA要求時のメールテンプレート
      # MFAがチャレンジとして要求された際に送信するメール
      mfa_email {
        # (Required) メールの件名
        subject = "MFA Required for Suspicious Sign-In"

        # (Required) HTMLメール本文
        html_body = "<html><body><h1>Multi-Factor Authentication Required</h1><p>We detected a suspicious sign-in attempt. Please complete MFA to access your account.</p></body></html>"

        # (Required) テキストメール本文
        text_body = "We detected a suspicious sign-in attempt. Please complete MFA to access your account."
      }

      # (Optional) アクションなし時のメールテンプレート
      # リスクイベントが検出されたが許可された場合に送信するメール
      no_action_email {
        # (Required) メールの件名
        subject = "New Sign-In Detected"

        # (Required) HTMLメール本文
        html_body = "<html><body><h1>New Sign-In to Your Account</h1><p>We detected a sign-in from a new location. If this wasn't you, please secure your account.</p></body></html>"

        # (Required) テキストメール本文
        text_body = "We detected a sign-in from a new location. If this wasn't you, please secure your account."
      }
    }
  }

  # ============================================================================
  # 漏洩認証情報リスク設定
  # ============================================================================

  # (Optional) 漏洩認証情報のリスク設定
  # パスワードデータベースと照合し、既知の漏洩パスワードを検出
  # https://docs.aws.amazon.com/cognito/latest/developerguide/feature-plans-features-plus.html
  compromised_credentials_risk_configuration {

    # (Optional) イベントフィルター
    # アクションを実行する対象イベント
    # 有効な値: SIGN_IN, PASSWORD_CHANGE, SIGN_UP
    # 未指定の場合は全イベントが対象
    event_filter = ["SIGN_IN", "PASSWORD_CHANGE"]

    # (Required) 漏洩認証情報検出時のアクション設定
    actions {
      # (Required) 実行するアクション
      # 有効な値: BLOCK, NO_ACTION
      # BLOCK: 認証をブロックしパスワードリセットを要求
      # NO_ACTION: 監査ログに記録するのみ
      event_action = "BLOCK"
    }
  }

  # ============================================================================
  # リスク例外設定
  # ============================================================================

  # (Optional) リスク判定の例外設定
  # IPアドレスベースでリスク評価を上書き
  # https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_RiskExceptionConfigurationType.html
  risk_exception_configuration {

    # (Optional) ブロックIPレンジリスト
    # このリストに含まれるIPアドレスからのリクエストは常にブロック
    # CIDR表記で指定（例: 10.10.10.10/32）
    # 最大200項目まで設定可能
    blocked_ip_range_list = [
      "192.0.2.0/24",
      "198.51.100.0/24"
    ]

    # (Optional) スキップIPレンジリスト
    # このリストに含まれるIPアドレスからのリクエストはリスク検出をスキップ
    # CIDR表記で指定
    # 最大200項目まで設定可能
    # 信頼できる社内ネットワークなどを指定
    skipped_ip_range_list = [
      "203.0.113.0/24"
    ]
  }
}

###############################################################################################
# 出力値（Computed Attributes）
###############################################################################################

# 以下の属性はリソース作成後に参照可能:
# - id: User Pool IDまたはUser Pool IDとClient IDを":"で結合した文字列
#       client_id指定時: "{user_pool_id}:{client_id}"
#       client_id未指定時: "{user_pool_id}"
