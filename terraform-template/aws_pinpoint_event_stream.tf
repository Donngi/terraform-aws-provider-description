#---------------------------------------------------------------
# AWS Pinpoint Event Stream
#---------------------------------------------------------------
#
# Amazon Pinpointアプリケーションのイベントストリームを設定するリソースです。
# ユーザーのアプリケーション利用状況、カスタムイベント、メッセージ配信データを
# Amazon Kinesis Data StreamsまたはAmazon Data Firehose配信ストリームに
# リアルタイムでストリーミングすることができます。
#
# ユースケース:
#   - アプリケーションイベントのリアルタイム分析
#   - カスタムダッシュボードでのイベントデータ可視化
#   - イベントベースのアラート生成
#   - Amazon S3へのイベントデータのバックアップと長期保存
#   - Amazon Redshift、Amazon OpenSearch Serviceへのデータ配信
#   - 複数アプリケーションのイベントデータの統合分析
#
# 注意事項:
#   - イベントストリームは各アプリケーションに1つのみ設定可能
#   - 複数のアプリケーションに同じKinesisストリームを割り当て可能
#   - Amazon Pinpointはイベントデータを受信すると同時にストリームに送信
#   - イベントデータはAmazon Pinpointで90日間保持されるが、
#     ストリーミングにより無期限に保存可能
#   - トランザクションプッシュ通知や音声メッセージはストリーミング対象外
#
# AWS公式ドキュメント:
#   - イベントストリーム概要: https://docs.aws.amazon.com/pinpoint/latest/developerguide/event-streams.html
#   - イベントストリームの設定: https://docs.aws.amazon.com/pinpoint/latest/developerguide/event-streams-setup.html
#   - ストリーミングイベント: https://docs.aws.amazon.com/pinpoint/latest/userguide/analytics-streaming.html
#   - APIリファレンス: https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-eventstream.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_event_stream
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pinpoint_event_stream" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # application_id (Required)
  # 設定内容: イベントストリームを設定するAmazon PinpointアプリケーションのIDを指定します。
  # 設定可能な値: 有効なPinpointアプリケーションID
  # 取得方法: aws_pinpoint_appリソースのapplication_id属性から取得
  application_id = aws_pinpoint_app.app.application_id

  # destination_stream_arn (Required)
  # 設定内容: イベントを送信するAmazon Kinesis Data Streamsまたは
  #           Amazon Data Firehose配信ストリームのARNを指定します。
  # 設定可能な値:
  #   - Amazon Kinesis Data StreamのARN
  #     例: arn:aws:kinesis:us-east-1:123456789012:stream/pinpoint-events
  #   - Amazon Data Firehose配信ストリームのARN
  #     例: arn:aws:firehose:us-east-1:123456789012:deliverystream/pinpoint-events
  # 用途:
  #   - Kinesis Data Streams: リアルタイム処理とカスタムアプリケーション分析
  #   - Firehose: S3、Redshift、OpenSearch Serviceへのデータ配信
  destination_stream_arn = aws_kinesis_stream.test_stream.arn

  # role_arn (Required)
  # 設定内容: Amazon Pinpointがストリームにイベントを公開することを
  #           認可するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 必要な権限:
  #   - Kinesis Data Streams使用時:
  #     * kinesis:PutRecords
  #     * kinesis:DescribeStream
  #   - Firehose使用時:
  #     * firehose:PutRecordBatch
  #     * firehose:DescribeDeliveryStream
  #   - 信頼関係で許可するサービス:
  #     * pinpoint.amazonaws.com（リージョンによってはpinpoint.{region}.amazonaws.com）
  role_arn = aws_iam_role.test_role.arn

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# 関連リソース例 - Kinesis Data Streams
#---------------------------------------------------------------

# Pinpointアプリケーション
resource "aws_pinpoint_app" "app" {
  # name (Optional)
  # 設定内容: Pinpointアプリケーションの名前を指定します。
  # name = "my-pinpoint-app"
}

# Kinesis Data Streamの例
resource "aws_kinesis_stream" "test_stream" {
  name        = "pinpoint-kinesis-test"
  shard_count = 1

  # stream_mode_details (Optional)
  # ストリームモードを設定する場合
  # stream_mode_details {
  #   stream_mode = "PROVISIONED" # または "ON_DEMAND"
  # }

  # retention_period (Optional)
  # データ保持期間（時間単位、デフォルト24時間）
  # retention_period = 24

  # shard_level_metrics (Optional)
  # シャードレベルメトリクスの有効化
  # shard_level_metrics = [
  #   "IncomingBytes",
  #   "IncomingRecords",
  #   "OutgoingBytes",
  #   "OutgoingRecords",
  # ]

  # tags (Optional)
  # tags = {
  #   Name        = "pinpoint-event-stream"
  #   Environment = "production"
  # }
}

# IAMロールの信頼関係ポリシー
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      # 注意: リージョンによってサービスプリンシパルが異なる場合があります
      # 例: pinpoint.us-east-1.amazonaws.com
      identifiers = ["pinpoint.us-east-1.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# IAMロール
resource "aws_iam_role" "test_role" {
  name               = "pinpoint-event-stream-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  # tags (Optional)
  # tags = {
  #   Name = "pinpoint-event-stream-role"
  # }
}

# Kinesis Data Streams用のIAMポリシー
data "aws_iam_policy_document" "test_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "kinesis:PutRecords",
      "kinesis:DescribeStream",
    ]

    # リソースはKinesisストリームのARNに制限することを推奨
    # 例: resources = [aws_kinesis_stream.test_stream.arn]
    resources = ["arn:aws:kinesis:us-east-1:*:*/*"]
  }
}

# IAMロールポリシー
resource "aws_iam_role_policy" "test_role_policy" {
  name   = "pinpoint-event-stream-policy"
  role   = aws_iam_role.test_role.id
  policy = data.aws_iam_policy_document.test_role_policy.json
}

#---------------------------------------------------------------
# Firehoseを使用する場合の例
#---------------------------------------------------------------

# # S3バケット（Firehoseの配信先）
# resource "aws_s3_bucket" "pinpoint_events" {
#   bucket = "my-pinpoint-events-bucket"
#
#   # tags (Optional)
#   # tags = {
#   #   Name = "pinpoint-events"
#   # }
# }
#
# # Firehose配信ストリーム
# resource "aws_kinesis_firehose_delivery_stream" "pinpoint_events" {
#   name        = "pinpoint-events-firehose"
#   destination = "extended_s3"
#
#   extended_s3_configuration {
#     role_arn   = aws_iam_role.firehose_role.arn
#     bucket_arn = aws_s3_bucket.pinpoint_events.arn
#
#     # データの圧縮
#     compression_format = "GZIP"
#
#     # プレフィックスパターン（日付ベースのパーティショニング）
#     prefix              = "pinpoint-events/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
#     error_output_prefix = "pinpoint-events-errors/"
#
#     # バッファリング設定
#     buffering_size     = 5   # MB
#     buffering_interval = 300 # 秒
#
#     # データ変換（Lambda関数を使用する場合）
#     # processing_configuration {
#     #   enabled = true
#     #   processors {
#     #     type = "Lambda"
#     #     parameters {
#     #       parameter_name  = "LambdaArn"
#     #       parameter_value = aws_lambda_function.transform.arn
#     #     }
#     #   }
#     # }
#   }
# }
#
# # Firehose用のIAMロール
# resource "aws_iam_role" "firehose_role" {
#   name = "pinpoint-firehose-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "firehose.amazonaws.com"
#         }
#       }
#     ]
#   })
# }
#
# # Firehose用のIAMポリシー（S3書き込み権限）
# data "aws_iam_policy_document" "firehose_s3_policy" {
#   statement {
#     effect = "Allow"
#
#     actions = [
#       "s3:AbortMultipartUpload",
#       "s3:GetBucketLocation",
#       "s3:GetObject",
#       "s3:ListBucket",
#       "s3:ListBucketMultipartUploads",
#       "s3:PutObject",
#     ]
#
#     resources = [
#       aws_s3_bucket.pinpoint_events.arn,
#       "${aws_s3_bucket.pinpoint_events.arn}/*",
#     ]
#   }
# }
#
# resource "aws_iam_role_policy" "firehose_s3_policy" {
#   name   = "firehose-s3-policy"
#   role   = aws_iam_role.firehose_role.id
#   policy = data.aws_iam_policy_document.firehose_s3_policy.json
# }
#
# # Pinpoint用のIAMポリシー（Firehose版）
# data "aws_iam_policy_document" "firehose_policy" {
#   statement {
#     effect = "Allow"
#
#     actions = [
#       "firehose:PutRecordBatch",
#       "firehose:DescribeDeliveryStream",
#     ]
#
#     resources = [aws_kinesis_firehose_delivery_stream.pinpoint_events.arn]
#   }
# }
#
# resource "aws_iam_role_policy" "firehose_role_policy" {
#   name   = "pinpoint-firehose-policy"
#   role   = aws_iam_role.test_role.id
#   policy = data.aws_iam_policy_document.firehose_policy.json
# }

#---------------------------------------------------------------
# イベントデータの種類
#---------------------------------------------------------------
# ストリーミングされるイベントデータの種類:
#
# 1. アプリケーションイベント:
#    - ユーザーのアプリケーション利用状況
#    - カスタムイベント
#    - セッション情報
#    - デバイス情報
#
# 2. キャンペーンイベント:
#    - メッセージ送信イベント
#    - 配信状態（送信、配信、開封、クリックなど）
#    - セグメント評価結果
#
# 3. ジャーニーイベント:
#    - ジャーニーアクティビティの実行状態
#    - パスの分岐情報
#
# 4. トランザクションメッセージイベント:
#    - Email送信イベント
#    - SMS送信イベント
#
# イベントスキーマ詳細:
#   - アプリイベント: https://docs.aws.amazon.com/pinpoint/latest/developerguide/event-streams-data-app.html
#   - キャンペーンイベント: https://docs.aws.amazon.com/pinpoint/latest/developerguide/event-streams-data-campaign.html
#   - ジャーニーイベント: https://docs.aws.amazon.com/pinpoint/latest/developerguide/event-streams-data-journey.html
#   - Emailイベント: https://docs.aws.amazon.com/pinpoint/latest/developerguide/event-streams-data-email.html
#   - SMSイベント: https://docs.aws.amazon.com/pinpoint/latest/developerguide/event-streams-data-sms.html
#
# 注意: トランザクションプッシュ通知と音声メッセージは
#       イベントストリームに含まれません。

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: イベントストリームのID（application_idと同じ値）
#
# - application_id: Pinpointアプリケーションのユニークな識別子
#
# - destination_stream_arn: イベントを受信するストリームのARN
#
# - role_arn: Pinpointがストリームにイベントを公開する権限を持つIAMロールのARN
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1. IAMロール権限:
#    - 最小権限の原則に従い、必要な権限のみを付与してください
#    - 本番環境ではワイルドカード(*)の使用を避け、特定のリソースARNを指定
#
# 2. Kinesisストリーム設定:
#    - イベント量に応じて適切なシャード数を設定してください
#    - 予測可能なワークロードにはプロビジョニングモード、
#      変動が大きい場合はオンデマンドモードを選択
#
# 3. データ保持:
#---------------------------------------------------------------
