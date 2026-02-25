#---------------------------------------------------------------
# Amazon SNS SMS Preferences
#---------------------------------------------------------------
#
# Amazon Simple Notification Service (SNS) のSMSメッセージング設定を管理するリソースです。
# AWSアカウント全体のSMS送信に関するデフォルト設定（送信者ID、SMSタイプ、
# 月次支出上限、配信ステータスログ、使用状況レポートなど）を一元管理します。
# このリソースはアカウントレベルの設定であり、1リージョンにつき1つのみ存在します。
#
# AWS公式ドキュメント:
#   - SNS SMS設定: https://docs.aws.amazon.com/sns/latest/dg/sms_preferences.html
#   - SMSメッセージ送信: https://docs.aws.amazon.com/sns/latest/dg/sns-mobile-phone-number-as-subscriber.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_sms_preferences
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sns_sms_preferences" "example" {
  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # SMS送信者設定
  #-------------------------------------------------------------

  # default_sender_id (Optional)
  # 設定内容: SMSメッセージのデフォルト送信者IDを指定します。
  # 設定可能な値: 英数字・スペースを含む最大11文字の文字列（英字で始まる必要があります）
  # 省略時: 送信者IDは設定されません（デバイスによっては送信者番号が表示されます）。
  # 注意: 送信者IDをサポートしていない国・キャリアでは番号が表示されます。
  #      すべての国で送信者IDがサポートされているわけではありません。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sms_preferences.html
  default_sender_id = null

  # default_sms_type (Optional)
  # 設定内容: SMSメッセージのデフォルトタイプを指定します。
  # 設定可能な値:
  #   - "Promotional": プロモーションメッセージ（低コスト、配信保証なし）
  #   - "Transactional": トランザクションメッセージ（高信頼性、重要通知向け）
  # 省略時: "Promotional" が使用されます。
  # 注意: Transactionalはコストが高くなりますが、重要なメッセージ（OTP等）に適しています。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sms_preferences.html
  default_sms_type = "Transactional"

  #-------------------------------------------------------------
  # 支出管理設定
  #-------------------------------------------------------------

  # monthly_spend_limit (Optional)
  # 設定内容: SMS送信に対して月次で支出する上限金額をUSD（米ドル）で指定します。
  # 設定可能な値: 正の数値（USD）
  # 省略時: AWSがデフォルトの支出上限を適用します（新規アカウントでは1 USD）。
  # 注意: 上限に達すると、その月の残りの期間はSMSが送信されなくなります。
  #      上限を超えて送信が必要な場合は、AWSサポートへ申請が必要です。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sms_preferences.html
  monthly_spend_limit = 10

  #-------------------------------------------------------------
  # 配信ステータスログ設定
  #-------------------------------------------------------------

  # delivery_status_iam_role_arn (Optional)
  # 設定内容: SMS配信ステータスをCloudWatch Logsに記録するために使用するIAMロールのARNを指定します。
  # 設定可能な値: CloudWatch Logsへの書き込み権限を持つIAMロールのARN
  # 省略時: 配信ステータスのログ記録は行われません。
  # 注意: delivery_status_success_sampling_rateと合わせて設定することで
  #      SMS配信のモニタリングが可能になります。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sms_stats_cloudwatch.html
  delivery_status_iam_role_arn = null

  # delivery_status_success_sampling_rate (Optional)
  # 設定内容: CloudWatch Logsへの成功した配信ステータスのサンプリング率を文字列で指定します。
  # 設定可能な値: "0"〜"100" の数値を表す文字列（パーセンテージ）
  # 省略時: 成功した配信のサンプリングは行われません。
  # 注意: delivery_status_iam_role_arnが設定されている場合のみ有効です。
  #      "100" に設定するとすべての成功メッセージがログに記録されます。
  delivery_status_success_sampling_rate = null

  #-------------------------------------------------------------
  # 使用状況レポート設定
  #-------------------------------------------------------------

  # usage_report_s3_bucket (Optional)
  # 設定内容: SMS使用状況レポートを保存するAmazon S3バケット名を指定します。
  # 設定可能な値: 有効なS3バケット名
  # 省略時: 使用状況レポートはS3に保存されません。
  # 注意: 指定したS3バケットはSNSサービスからの書き込みを許可するバケットポリシーが
  #      必要です。レポートはUTCタイムゾーンに基づき毎日生成されます。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sms_stats_usage.html
  usage_report_s3_bucket = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アカウントおよびリージョンを表す固定の識別子
#       （通常は "sns-sms-preferences" などの固定値）
#
# - monthly_spend_limit: 設定された月次支出上限（computed属性として反映される）
#
# - region: このリソースが管理されているリージョン
#---------------------------------------------------------------
