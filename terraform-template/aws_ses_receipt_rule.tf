#---------------------------------------------------------------
# Amazon SES Receipt Rule (受信ルール)
#---------------------------------------------------------------
#
# Amazon Simple Email Service (SES) の受信ルールをプロビジョニングするリソースです。
# 受信ルールは、指定した受信者に届いたメールに対してSESが実行するアクションを定義します。
# 各ルールには複数のアクション（S3保存、Lambda実行、SNS通知など）を設定できます。
#
# 受信ルールの主な用途:
#   - 特定の受信者アドレスへのメールをS3バケットに保存
#   - 受信メールのトリガーとしてLambda関数を実行
#   - 受信メールの内容をSNSトピックに通知
#   - スパム・ウイルスのスキャン
#   - メール本文にカスタムヘッダーを追加
#
# 前提条件:
#   - 送信先ドメインがSESで検証済みであること
#   - 受信ルールセット (aws_ses_receipt_rule_set) が作成済みであること
#   - SESの受信機能が有効なリージョンで使用すること
#
# AWS公式ドキュメント:
#   - SES受信ルールの管理: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-managing-receipt-rules.html
#   - SES受信ルールのアクション: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-action.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_receipt_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_receipt_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 受信ルールの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列（最大64文字）
  # 注意: 同一ルールセット内で一意である必要があります
  # 関連機能: SES受信ルール識別子
  #   ルールセット内でルールを識別するための一意の名前。
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-managing-receipt-rules.html
  name = "example-receipt-rule"

  # rule_set_name (Required)
  # 設定内容: このルールを追加する受信ルールセットの名前を指定します。
  # 設定可能な値: 既存の受信ルールセット名（aws_ses_receipt_rule_setで作成したもの）
  # 関連機能: SES受信ルールセット
  #   受信ルールは必ずいずれかのルールセットに属する必要があります。
  #   ルールセットはaws_ses_active_receipt_rule_setでアクティブ化します。
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-receipt-rule-set.html
  rule_set_name = "primary-rules"

  #-------------------------------------------------------------
  # ルール順序設定
  #-------------------------------------------------------------

  # after (Optional)
  # 設定内容: このルールを挿入するルール名を指定します。
  #          指定したルールの「後に」このルールが実行されます。
  # 設定可能な値: 同一ルールセット内の既存ルール名。空の場合はリストの先頭に配置
  # 省略時: ルールセット内の最初のルールとして追加
  # 注意: ルールの順序はメール処理の優先度に直接影響します
  # 関連機能: SES受信ルール実行順序
  #   ルールセット内のルールは順番に評価され、条件に一致した最初のルールが適用されます。
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-managing-receipt-rules.html
  after = null

  #-------------------------------------------------------------
  # フィルター設定
  #-------------------------------------------------------------

  # recipients (Optional)
  # 設定内容: このルールを適用する受信者のメールアドレスまたはドメインを指定します。
  # 設定可能な値: メールアドレス（例: user@example.com）またはドメイン（例: example.com）のセット
  # 省略時: ルールセットが設定されている全ドメインへのメールに適用
  # 注意: 空のリストは全受信者にマッチします
  # 関連機能: SES受信フィルター
  #   特定の受信者アドレスやドメインにのみルールを適用することで、
  #   柔軟なメール振り分けが可能になります。
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-managing-receipt-rules.html
  recipients = ["user@example.com"]

  #-------------------------------------------------------------
  # スキャン設定
  #-------------------------------------------------------------

  # scan_enabled (Optional)
  # 設定内容: 受信メールに対してスパム・ウイルスのスキャンを有効にするかを指定します。
  # 設定可能な値:
  #   - true: スパム・ウイルスのスキャンを有効化
  #   - false: スキャンを無効化
  # 省略時: false
  # 推奨: セキュリティのため true を設定することを推奨
  # 関連機能: SES スパム・ウイルスフィルタリング
  #   受信メールのスキャン結果はメールヘッダーに追加されます。
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-managing-receipt-rules.html
  scan_enabled = false

  #-------------------------------------------------------------
  # TLSポリシー設定
  #-------------------------------------------------------------

  # tls_policy (Optional, Computed)
  # 設定内容: 受信メールのTLS接続要件を指定します。
  # 設定可能な値:
  #   - "Optional": TLS接続が利用可能な場合は使用するが、必須ではない
  #   - "Require": TLS接続を必須とし、TLSなしのメールは拒否する
  # 省略時: "Optional"
  # 推奨: セキュリティ要件に応じて "Require" を設定
  # 関連機能: SES TLSポリシー
  #   受信メールの暗号化を強制することで、転送中のデータを保護します。
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-managing-receipt-rules.html
  tls_policy = "Optional"

  #-------------------------------------------------------------
  # ルール有効化設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: 受信ルールの有効/無効を指定します。
  # 設定可能な値:
  #   - true: ルールを有効化（メール受信時に評価される）
  #   - false: ルールを無効化（メール受信時にスキップされる）
  # 省略時: true（ルールは有効）
  # 用途: テスト時や一時停止時にルールを無効化できます
  enabled = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, eu-west-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Amazon SESのメール受信機能は一部のリージョンでのみ利用可能です
  #       サポートリージョン: us-east-1, us-west-2, eu-west-1 など
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ヘッダー追加アクション
  #-------------------------------------------------------------

  # add_header_action (Optional)
  # 設定内容: 受信メールのヘッダーにカスタム情報を追加するアクションを指定します。
  # 用途: メールにカスタムメタデータを付加して下流の処理で利用する場合
  # 注意: このブロックは複数指定可能（setタイプ）
  add_header_action {
    # header_name (Required)
    # 設定内容: 追加するヘッダーの名前を指定します。
    # 設定可能な値: RFC 5321に準拠したヘッダー名（英数字とハイフン）
    header_name = "X-SES-Spam-Score"

    # header_value (Required)
    # 設定内容: 追加するヘッダーの値を指定します。
    # 設定可能な値: 任意の文字列（2048文字以内）
    header_value = "Low"

    # position (Required)
    # 設定内容: ルール内でのアクションの実行順序を指定します。
    # 設定可能な値: 正の整数（1以上）。小さい数値ほど先に実行されます
    position = 1
  }

  #-------------------------------------------------------------
  # バウンスアクション
  #-------------------------------------------------------------

  # bounce_action (Optional)
  # 設定内容: 受信メールをバウンス（返送）するアクションを指定します。
  # 用途: 特定の受信者への配信を拒否してバウンス通知を送信する場合
  # 注意: このブロックは複数指定可能（setタイプ）
  bounce_action {
    # message (Required)
    # 設定内容: バウンスメッセージのテキストを指定します。
    # 設定可能な値: 任意のテキスト文字列
    message = "Mailbox does not exist"

    # sender (Required)
    # 設定内容: バウンスメールの送信元アドレスを指定します。
    # 設定可能な値: SESで検証済みのメールアドレスまたはドメインのアドレス
    sender = "noreply@example.com"

    # smtp_reply_code (Required)
    # 設定内容: バウンス時のSMTP応答コードを指定します。
    # 設定可能な値: 有効なSMTPエラーコード（例: "550"）
    #   - "550": メールボックスが存在しない
    #   - "554": トランザクション失敗
    smtp_reply_code = "550"

    # status_code (Optional)
    # 設定内容: SMTPのEnhanced Status Code（拡張ステータスコード）を指定します。
    # 設定可能な値: RFC 3463形式のコード（例: "5.1.1"）
    # 省略時: 空文字列
    status_code = "5.1.1"

    # topic_arn (Optional)
    # 設定内容: バウンスイベントを通知するSNSトピックのARNを指定します。
    # 設定可能な値: 有効なSNSトピックARN
    # 省略時: 通知なし
    topic_arn = null

    # position (Required)
    # 設定内容: ルール内でのアクションの実行順序を指定します。
    # 設定可能な値: 正の整数（1以上）
    position = 2
  }

  #-------------------------------------------------------------
  # Lambda実行アクション
  #-------------------------------------------------------------

  # lambda_action (Optional)
  # 設定内容: 受信メールをトリガーとしてLambda関数を実行するアクションを指定します。
  # 用途: メールの内容を処理・変換するカスタムロジックを実行する場合
  # 前提条件: LambdaにSESからの呼び出しを許可するIAMポリシーが必要
  # 注意: このブロックは複数指定可能（setタイプ）
  lambda_action {
    # function_arn (Required)
    # 設定内容: 呼び出すLambda関数のARNを指定します。
    # 設定可能な値: 有効なLambda関数ARN
    function_arn = "arn:aws:lambda:us-east-1:123456789012:function:process-ses-email"

    # invocation_type (Optional)
    # 設定内容: Lambda関数の呼び出しタイプを指定します。
    # 設定可能な値:
    #   - "Event": 非同期呼び出し（Lambda関数の完了を待たずに続行）
    #   - "RequestResponse": 同期呼び出し（Lambda関数の応答を待つ）
    # 省略時: "Event"
    invocation_type = "Event"

    # topic_arn (Optional)
    # 設定内容: Lambda実行イベントを通知するSNSトピックのARNを指定します。
    # 設定可能な値: 有効なSNSトピックARN
    # 省略時: 通知なし
    topic_arn = null

    # position (Required)
    # 設定内容: ルール内でのアクションの実行順序を指定します。
    # 設定可能な値: 正の整数（1以上）
    position = 3
  }

  #-------------------------------------------------------------
  # S3保存アクション
  #-------------------------------------------------------------

  # s3_action (Optional)
  # 設定内容: 受信メールをS3バケットに保存するアクションを指定します。
  # 用途: メールのアーカイブや後続のバッチ処理に使用する場合
  # 前提条件: S3バケットにSESからの書き込みを許可するバケットポリシーが必要
  # 注意: このブロックは複数指定可能（setタイプ）
  s3_action {
    # bucket_name (Required)
    # 設定内容: メールを保存するS3バケット名を指定します。
    # 設定可能な値: 既存のS3バケット名
    bucket_name = "my-ses-email-bucket"

    # object_key_prefix (Optional)
    # 設定内容: S3オブジェクトキーのプレフィックスを指定します。
    # 設定可能な値: 任意のプレフィックス文字列（例: "emails/incoming/"）
    # 省略時: プレフィックスなし
    object_key_prefix = "emails/incoming/"

    # kms_key_arn (Optional)
    # 設定内容: S3に保存する際のサーバーサイド暗号化に使用するKMSキーのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    # 省略時: SSE-S3（S3管理キー）で暗号化
    kms_key_arn = null

    # iam_role_arn (Optional)
    # 設定内容: SESがS3にオブジェクトを書き込む際に使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 省略時: SESがデフォルトの権限を使用
    iam_role_arn = null

    # topic_arn (Optional)
    # 設定内容: S3保存完了イベントを通知するSNSトピックのARNを指定します。
    # 設定可能な値: 有効なSNSトピックARN
    # 省略時: 通知なし
    topic_arn = null

    # position (Required)
    # 設定内容: ルール内でのアクションの実行順序を指定します。
    # 設定可能な値: 正の整数（1以上）
    position = 4
  }

  #-------------------------------------------------------------
  # SNS通知アクション
  #-------------------------------------------------------------

  # sns_action (Optional)
  # 設定内容: 受信メールをSNSトピックに通知するアクションを指定します。
  # 用途: リアルタイムのメール受信通知や、他のサービスとの連携に使用する場合
  # 注意: このブロックは複数指定可能（setタイプ）
  sns_action {
    # topic_arn (Required)
    # 設定内容: 通知先のSNSトピックのARNを指定します。
    # 設定可能な値: 有効なSNSトピックARN
    topic_arn = "arn:aws:sns:us-east-1:123456789012:ses-email-notifications"

    # encoding (Optional)
    # 設定内容: SNSメッセージのエンコーディング形式を指定します。
    # 設定可能な値:
    #   - "UTF-8": UTF-8エンコーディング（テキストコンテンツ向け）
    #   - "Base64": Base64エンコーディング（バイナリコンテンツ向け）
    # 省略時: "UTF-8"
    encoding = "UTF-8"

    # position (Required)
    # 設定内容: ルール内でのアクションの実行順序を指定します。
    # 設定可能な値: 正の整数（1以上）
    position = 5
  }

  #-------------------------------------------------------------
  # 処理停止アクション
  #-------------------------------------------------------------

  # stop_action (Optional)
  # 設定内容: ルールセット内のルール評価を停止するアクションを指定します。
  # 用途: 特定の条件でそれ以降のルールを評価しないようにする場合
  # 注意: このブロックは複数指定可能（setタイプ）
  stop_action {
    # scope (Required)
    # 設定内容: 停止の適用範囲を指定します。
    # 設定可能な値:
    #   - "RuleSet": ルールセット全体の評価を停止する
    scope = "RuleSet"

    # topic_arn (Optional)
    # 設定内容: 停止イベントを通知するSNSトピックのARNを指定します。
    # 設定可能な値: 有効なSNSトピックARN
    # 省略時: 通知なし
    topic_arn = null

    # position (Required)
    # 設定内容: ルール内でのアクションの実行順序を指定します。
    # 設定可能な値: 正の整数（1以上）
    position = 6
  }

  #-------------------------------------------------------------
  # WorkMailアクション
  #-------------------------------------------------------------

  # workmail_action (Optional)
  # 設定内容: 受信メールをAmazon WorkMailに転送するアクションを指定します。
  # 用途: SESで受信したメールをWorkMailオーガナイゼーションに配信する場合
  # 前提条件: WorkMailオーガナイゼーションが設定済みであること
  # 注意: このブロックは複数指定可能（setタイプ）
  workmail_action {
    # organization_arn (Required)
    # 設定内容: 転送先のAmazon WorkMailオーガナイゼーションのARNを指定します。
    # 設定可能な値: 有効なWorkMailオーガナイゼーションARN
    organization_arn = "arn:aws:workmail:us-east-1:123456789012:organization/m-abc123"

    # topic_arn (Optional)
    # 設定内容: WorkMail転送イベントを通知するSNSトピックのARNを指定します。
    # 設定可能な値: 有効なSNSトピックARN
    # 省略時: 通知なし
    topic_arn = null

    # position (Required)
    # 設定内容: ルール内でのアクションの実行順序を指定します。
    # 設定可能な値: 正の整数（1以上）
    position = 7
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: SES受信ルールのAmazon Resource Name (ARN)
#        形式: arn:aws:ses:region:account-id:receipt-rule/rule-set-name/rule-name
#
# - id: SES受信ルール名（nameと同じ値）
#---------------------------------------------------------------
