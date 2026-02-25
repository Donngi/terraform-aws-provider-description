#---------------------------------------------------------------
# Amazon SES Identity Notification Topic
#---------------------------------------------------------------
#
# Amazon Simple Email Service (SES) アイデンティティの通知トピックを設定・管理するリソースです。
# バウンス (Bounce)、苦情 (Complaint)、配信 (Delivery) などのイベントが発生した際に
# 指定した Amazon SNS トピックに通知を送信する設定を行います。
#
# 主な機能:
#   - SES アイデンティティ (ドメインまたはメールアドレス) に対する SNS 通知の設定
#   - バウンス、苦情、配信の各通知タイプごとに異なる SNS トピックを指定可能
#   - 通知メッセージにオリジナルメールヘッダーを含めるかどうかの制御
#
# AWS公式ドキュメント:
#   - SES 通知の設定: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/configure-sns-notifications.html
#   - SES バウンス・苦情の通知: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/notifications-via-sns.html
#   - SES API リファレンス: https://docs.aws.amazon.com/ses/latest/APIReference/API_SetIdentityNotificationTopic.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_identity_notification_topic
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_identity_notification_topic" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # identity (Required)
  # 設定内容: SNS トピックを設定する対象の SES アイデンティティを指定します。
  # 設定可能な値: ドメイン名 (例: example.com) またはメールアドレス (例: user@example.com)、
  #               あるいは SES アイデンティティの ARN
  # 用途: どの SES アイデンティティに対して通知設定を適用するかを指定
  # 注意事項:
  #   - 指定するアイデンティティが SES に登録されている必要があります
  #   - ドメインアイデンティティの場合は aws_ses_domain_identity リソースで作成したドメインを参照
  #   - メールアドレスアイデンティティの場合は aws_ses_email_identity リソースで作成したアドレスを参照
  # 関連機能: SES アイデンティティ管理
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-addresses-and-domains.html
  identity = "example.com"

  # notification_type (Required)
  # 設定内容: SNS トピックに公開する通知のタイプを指定します。
  # 設定可能な値:
  #   - "Bounce"    : バウンスメール通知 (メール配信に失敗した場合)
  #   - "Complaint" : 苦情通知 (受信者がスパムとして報告した場合)
  #   - "Delivery"  : 配信成功通知 (メールが正常に配信された場合)
  # 用途: 特定の通知タイプをモニタリングし、適切なアクションを実行するために使用
  # 注意事項:
  #   - バウンスと苦情は配信品質に影響するため、特に監視が重要
  #   - 高バウンス率・苦情率は SES アカウントの停止につながる可能性があります
  # 関連機能: SES 通知管理
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/configure-sns-notifications.html
  notification_type = "Bounce"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # topic_arn (Optional)
  # 設定内容: 通知を送信する Amazon SNS トピックの ARN を指定します。
  # 設定可能な値: 有効な SNS トピックの ARN (例: arn:aws:sns:us-east-1:123456789012:ses-notifications)
  #               空文字列 ("") を指定すると通知の送信先を無効化できます
  # 省略時: 通知設定が削除され、通知は送信されません
  # 用途: SES イベントを SNS 経由で Lambda、SQS、HTTP エンドポイントなどに転送
  # 注意事項:
  #   - SNS トピックは SES と同一リージョンに存在する必要があります
  #   - SES に対して SNS トピックへの publish 権限が必要です
  #   - 空文字列 "" を指定することで既存の通知設定を削除できます
  # 関連機能: SES → SNS 連携
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/configure-sns-notifications.html
  topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:ses-bounce-notifications"

  # include_original_headers (Optional)
  # 設定内容: SNS 通知にオリジナルメールのヘッダーを含めるかどうかを指定します。
  # 設定可能な値:
  #   - true  : SNS 通知のペイロードにオリジナルメールのヘッダー情報を含める
  #   - false : ヘッダー情報を含めない
  # 省略時: false (ヘッダー情報は含まれません)
  # 用途: バウンスや苦情の詳細な診断、メールのルーティング情報の確認に使用
  # 注意事項:
  #   - ヘッダーを含めることで SNS メッセージのサイズが増加します
  #   - ヘッダーには送信元 IP、受信経路などの詳細情報が含まれます
  # 関連機能: SES 通知カスタマイズ
  #   - https://docs.aws.amazon.com/ses/latest/DeveloperGuide/configure-sns-notifications.html
  include_original_headers = false

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1, eu-west-1)
  # 省略時: プロバイダー設定で指定されたリージョンを使用
  # 用途: 複数リージョンで SES を使用する場合に明示的にリージョンを指定
  # 注意事項:
  #   - 指定するリージョンはアイデンティティが登録されているリージョンと一致する必要があります
  #   - SNS トピックも同一リージョンに存在する必要があります
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子。アイデンティティと通知タイプを組み合わせた値
#   形式: {identity}|{notification_type}
#   例: example.com|Bounce
#
#---------------------------------------------------------------
