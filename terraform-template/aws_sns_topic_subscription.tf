#---------------------------------------------------------------
# AWS SNS Topic Subscription
#---------------------------------------------------------------
#
# Amazon SNSトピックへのサブスクリプションをプロビジョニングするリソースです。
# SNSトピックに送信されたメッセージをSQSキュー、Lambda関数、HTTPSエンドポイント、
# メールアドレス、SMS、モバイルアプリなどの様々なエンドポイントに配信します。
#
# AWS公式ドキュメント:
#   - Amazon SNS概要: https://docs.aws.amazon.com/sns/latest/dg/welcome.html
#   - サブスクリプションの作成: https://docs.aws.amazon.com/sns/latest/dg/sns-create-subscribe-endpoint-to-topic.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sns_topic_subscription" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # topic_arn (Required)
  # 設定内容: サブスクライブ対象のSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックARN（例: arn:aws:sns:ap-northeast-1:123456789012:my-topic）
  # 注意: SNSトピックとSQSキューが異なるリージョンにある場合、サブスクリプションは
  #       SNSトピックと同じリージョンのプロバイダーを使用する必要があります。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sns-create-subscribe-endpoint-to-topic.html
  topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:my-topic"

  # protocol (Required)
  # 設定内容: メッセージ配信に使用するプロトコルを指定します。
  # 設定可能な値:
  #   - "sqs": Amazon SQSキューへの配信（JSON形式）
  #   - "lambda": AWS Lambda関数への配信（JSON形式）
  #   - "firehose": Amazon Kinesis Data Firehose配信ストリームへの配信（JSON形式）
  #   - "application": モバイルアプリとデバイスへの配信（JSON形式）
  #   - "sms": SMS経由でのテキストメッセージ配信
  #   - "email": SMTP経由でのメール配信（部分サポート、要確認）
  #   - "email-json": SMTP経由でのJSON形式メール配信（部分サポート、要確認）
  #   - "http": HTTPエンドポイントへの配信（部分サポート、要確認）
  #   - "https": HTTPSエンドポイントへの配信（部分サポート、要確認）
  # 注意: email、email-json、http、httpsは部分サポートのため、未確認のサブスクリプションを
  #       Terraformで削除/アンサブスクライブできません。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sns-subscription-protocols.html
  protocol = "sqs"

  # endpoint (Required)
  # 設定内容: メッセージを送信する宛先エンドポイントを指定します。
  # 設定可能な値: プロトコルに応じて異なる形式
  #   - sqs: SQSキューのARN（例: arn:aws:sqs:ap-northeast-1:123456789012:my-queue）
  #   - lambda: Lambda関数のARN
  #   - firehose: Kinesis Data Firehose配信ストリームのARN
  #   - application: モバイルアプリとデバイスのエンドポイントARN
  #   - sms: SMS対応デバイスの電話番号
  #   - email: メールアドレス
  #   - email-json: メールアドレス
  #   - http: HTTPエンドポイントURL
  #   - https: HTTPSエンドポイントURL
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sns-create-subscribe-endpoint-to-topic.html
  endpoint = "arn:aws:sqs:ap-northeast-1:123456789012:my-queue"

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
  # サブスクリプション確認設定
  #-------------------------------------------------------------

  # confirmation_timeout_in_minutes (Optional)
  # 設定内容: サブスクリプションARNの取得を失敗とみなすまでの再試行待機時間（分）を指定します。
  # 設定可能な値: 正の整数（分単位）
  # 省略時: 1（1分）
  # 注意: HTTP/HTTPSプロトコルのみに適用されます。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/SendMessageToHttp.confirm.html
  confirmation_timeout_in_minutes = 1

  # endpoint_auto_confirms (Optional)
  # 設定内容: エンドポイントがサブスクリプションを自動確認できるかどうかを指定します。
  # 設定可能な値:
  #   - true: エンドポイントが自動確認可能（例: PagerDuty）
  #   - false (デフォルト): 手動確認が必要
  # 省略時: false
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/SendMessageToHttp.html#SendMessageToHttp.prepare
  endpoint_auto_confirms = false

  #-------------------------------------------------------------
  # メッセージフィルタリング設定
  #-------------------------------------------------------------

  # filter_policy (Optional)
  # 設定内容: サブスクリプションに適用するメッセージフィルタポリシーをJSON形式で指定します。
  # 設定可能な値: JSON形式の文字列。メッセージ属性または本文に基づいてフィルタ条件を定義
  # 省略時: フィルタなし（すべてのメッセージを受信）
  # 関連機能: Amazon SNS メッセージフィルタリング
  #   サブスクリプションがトピックに公開されたメッセージのサブセットのみを受信できるようにします。
  #   フィルタポリシーを使用することで、不要なメッセージの配信を防ぎ、コストを削減できます。
  #   - https://docs.aws.amazon.com/sns/latest/dg/sns-message-filtering.html
  filter_policy = jsonencode({
    event_type = ["order_placed", "order_cancelled"]
    price      = [{ numeric = [">=", 100] }]
  })

  # filter_policy_scope (Optional)
  # 設定内容: フィルタポリシーの適用範囲を指定します。
  # 設定可能な値:
  #   - "MessageAttributes" (デフォルト): メッセージ属性に対してフィルタを適用
  #   - "MessageBody": メッセージ本文に対してフィルタを適用
  # 省略時: "MessageAttributes"
  # 関連機能: Amazon SNS メッセージフィルタリング
  #   フィルタポリシーをメッセージ属性またはメッセージ本文に適用できます。
  #   - https://docs.aws.amazon.com/sns/latest/dg/message-filtering-apply.html
  filter_policy_scope = "MessageAttributes"

  #-------------------------------------------------------------
  # メッセージ配信設定
  #-------------------------------------------------------------

  # raw_message_delivery (Optional)
  # 設定内容: 生メッセージ配信を有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: 元のメッセージを直接配信（JSONでラップしない）
  #   - false (デフォルト): SNSメタデータを含むJSON形式でラップして配信
  # 省略時: false
  # 注意: SQS、Lambda、Firehose、HTTPSエンドポイントで使用可能
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sns-large-payload-raw-message-delivery.html
  raw_message_delivery = false

  # delivery_policy (Optional)
  # 設定内容: 配信ポリシー（再試行、バックオフなど）をJSON形式で指定します。
  # 設定可能な値: JSON形式の文字列。再試行ポリシーやスロットルポリシーを定義
  # 省略時: デフォルトの配信ポリシーを使用
  # 注意: HTTP/HTTPSサブスクリプションのみに適用されます。
  # 関連機能: Amazon SNS 配信ポリシー
  #   メッセージ配信の再試行動作をカスタマイズできます。
  #   健全な再試行ポリシーと病的な再試行ポリシーを定義できます。
  #   - https://docs.aws.amazon.com/sns/latest/dg/DeliveryPolicies.html
  delivery_policy = jsonencode({
    healthyRetryPolicy = {
      minDelayTarget     = 20
      maxDelayTarget     = 20
      numRetries         = 3
      numMaxDelayRetries = 0
      numNoDelayRetries  = 0
      numMinDelayRetries = 0
      backoffFunction    = "linear"
    }
  })

  #-------------------------------------------------------------
  # エラーハンドリング設定
  #-------------------------------------------------------------

  # redrive_policy (Optional)
  # 設定内容: デッドレターキュー（DLQ）へのリダイレクトポリシーをJSON形式で指定します。
  # 設定可能な値: JSON形式の文字列。DLQとして使用するSQSキューのARNを指定
  # 省略時: リダイブポリシーなし（配信失敗時にメッセージは破棄）
  # 関連機能: Amazon SNS デッドレターキュー
  #   クライアントエラーまたはサーバーエラーによりサブスクライバーに配信できなかった
  #   メッセージを保持するためのSQSキューです。配信失敗の調査に役立ちます。
  #   - https://docs.aws.amazon.com/sns/latest/dg/sns-dead-letter-queues.html
  redrive_policy = jsonencode({
    deadLetterTargetArn = "arn:aws:sqs:ap-northeast-1:123456789012:my-dlq"
  })

  #-------------------------------------------------------------
  # メッセージアーカイブ・リプレイ設定
  #-------------------------------------------------------------

  # replay_policy (Optional)
  # 設定内容: アーカイブされたメッセージのリプレイポリシーをJSON形式で指定します。
  # 設定可能な値: JSON形式の文字列。リプレイ設定を定義
  # 省略時: リプレイポリシーなし
  # 関連機能: Amazon SNS メッセージアーカイブとリプレイ
  #   過去に配信されたメッセージをアーカイブし、後から再配信（リプレイ）できます。
  #   - https://docs.aws.amazon.com/sns/latest/dg/message-archiving-and-replay-subscriber.html
  replay_policy = null

  #-------------------------------------------------------------
  # IAMロール設定（Firehose専用）
  #-------------------------------------------------------------

  # subscription_role_arn (Optional)
  # 設定内容: Kinesis Data Firehose配信ストリームに公開するためのIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: プロトコルが "firehose" の場合は必須です。
  # 関連機能: Amazon SNS から Kinesis Data Firehose への配信
  #   SNSがFirehoseにメッセージを配信するための適切な権限を持つIAMロールが必要です。
  #   - https://docs.aws.amazon.com/sns/latest/dg/sns-firehose-as-subscriber.html
  subscription_role_arn = null

  #-------------------------------------------------------------
  # リソース識別子
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: サブスクリプションのARNが自動的に割り当てられます。
  # 注意: 通常は指定不要です。Terraformが自動的に管理します。
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: サブスクリプションのAmazon Resource Name (ARN)
#
# - confirmation_was_authenticated: サブスクリプション確認リクエストが
#                                    認証されたかどうかを示すブール値
#
# - owner_id: サブスクリプションの所有者のAWSアカウントID
#
# - pending_confirmation: サブスクリプションがまだ確認されていないかどうかを
#                          示すブール値。email、email-json、http/httpsプロトコルでは、
#                          確認されるまでtrueのままです。
#---------------------------------------------------------------
