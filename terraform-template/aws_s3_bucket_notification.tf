#---------------------------------------------------------------
# Amazon S3 Bucket Notification Configuration
#---------------------------------------------------------------
#
# S3バケットのイベント通知設定をプロビジョニングするリソースです。
# S3バケット上で発生するイベント（オブジェクトの作成・削除など）を
# Lambda関数、SQSキュー、SNSトピック、またはAmazon EventBridgeへ
# 通知する設定を管理します。
#
# 注意事項:
# - S3バケットは通知設定リソースを1つしかサポートしません。
#   同一バケットに複数の aws_s3_bucket_notification リソースを宣言すると
#   設定の差分が永続的に発生します。
# - このリソースは、関連するS3バケットに既存のイベント通知設定が
#   あった場合、上書きします。
# - このリソースはS3ディレクトリバケットでは使用できません。
#
# AWS公式ドキュメント:
#   - S3イベント通知: https://docs.aws.amazon.com/AmazonS3/latest/dev/NotificationHowTo.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_notification" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: 通知設定を適用するバケットの名前を指定します。
  # 設定可能な値: 既存のS3バケット名
  bucket = "example-bucket"

  #-------------------------------------------------------------
  # EventBridge連携設定
  #-------------------------------------------------------------

  # eventbridge (Optional)
  # 設定内容: Amazon EventBridgeへの通知を有効にするかどうかを指定します。
  # 設定可能な値: true（有効）/ false（無効）
  # 省略時: false（無効）
  # 用途: EventBridgeルールでS3イベントをフィルタリング・ルーティングする場合に使用します。
  eventbridge = false

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
  # Lambda関数通知設定（複数指定可能）
  #-------------------------------------------------------------

  # lambda_function (Optional, 複数指定可能)
  # 設定内容: Lambda関数への通知設定を定義するブロックです。
  # 注意: Lambda関数にS3からの実行許可を与える aws_lambda_permission リソースが別途必要です。
  lambda_function {
    # lambda_function_arn (Optional)
    # 設定内容: 通知先のLambda関数のARNを指定します。
    # 設定可能な値: Lambda関数のARN
    lambda_function_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:example-function"

    # events (Required)
    # 設定内容: 通知をトリガーするS3イベントの種類を指定します。
    # 設定可能な値: "s3:ObjectCreated:*", "s3:ObjectCreated:Put", "s3:ObjectCreated:Post",
    #   "s3:ObjectCreated:Copy", "s3:ObjectCreated:CompleteMultipartUpload",
    #   "s3:ObjectRemoved:*", "s3:ObjectRemoved:Delete", "s3:ObjectRemoved:DeleteMarkerCreated",
    #   "s3:ObjectRestore:*", "s3:ObjectRestore:Post", "s3:ObjectRestore:Completed",
    #   "s3:ReducedRedundancyLostObject", "s3:Replication:*", など
    # 参考: http://docs.aws.amazon.com/AmazonS3/latest/dev/NotificationHowTo.html#notification-how-to-event-types-and-destinations
    events = ["s3:ObjectCreated:*"]

    # filter_prefix (Optional)
    # 設定内容: 通知をトリガーするオブジェクトキーのプレフィックスを指定します。
    # 設定可能な値: 任意の文字列（例: "logs/", "images/"）
    # 省略時: プレフィックスによるフィルタリングは行いません
    filter_prefix = "AWSLogs/"

    # filter_suffix (Optional)
    # 設定内容: 通知をトリガーするオブジェクトキーのサフィックスを指定します。
    # 設定可能な値: 任意の文字列（例: ".log", ".jpg"）
    # 省略時: サフィックスによるフィルタリングは行いません
    filter_suffix = ".log"

    # id (Optional)
    # 設定内容: 各通知設定を一意に識別するIDを指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: AWSが自動生成します
    id = "lambda-notification-1"
  }

  #-------------------------------------------------------------
  # SQSキュー通知設定（複数指定可能）
  #-------------------------------------------------------------

  # queue (Optional, 複数指定可能)
  # 設定内容: SQSキューへの通知設定を定義するブロックです。
  # 注意: SQSキューポリシーでS3からのメッセージ送信を許可する設定が別途必要です。
  queue {
    # queue_arn (Required)
    # 設定内容: 通知先のSQSキューのARNを指定します。
    # 設定可能な値: SQSキューのARN
    queue_arn = "arn:aws:sqs:ap-northeast-1:123456789012:example-queue"

    # events (Required)
    # 設定内容: 通知をトリガーするS3イベントの種類を指定します。
    # 設定可能な値: "s3:ObjectCreated:*", "s3:ObjectRemoved:*" など
    # 参考: http://docs.aws.amazon.com/AmazonS3/latest/dev/NotificationHowTo.html#notification-how-to-event-types-and-destinations
    events = ["s3:ObjectCreated:*"]

    # filter_prefix (Optional)
    # 設定内容: 通知をトリガーするオブジェクトキーのプレフィックスを指定します。
    # 設定可能な値: 任意の文字列（例: "images/"）
    # 省略時: プレフィックスによるフィルタリングは行いません
    filter_prefix = "images/"

    # filter_suffix (Optional)
    # 設定内容: 通知をトリガーするオブジェクトキーのサフィックスを指定します。
    # 設定可能な値: 任意の文字列（例: ".jpg"）
    # 省略時: サフィックスによるフィルタリングは行いません
    filter_suffix = null

    # id (Optional)
    # 設定内容: 各通知設定を一意に識別するIDを指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: AWSが自動生成します
    id = "queue-notification-1"
  }

  #-------------------------------------------------------------
  # SNSトピック通知設定（複数指定可能）
  #-------------------------------------------------------------

  # topic (Optional, 複数指定可能)
  # 設定内容: SNSトピックへの通知設定を定義するブロックです。
  # 注意: SNSトピックポリシーでS3からのメッセージ発行を許可する設定が別途必要です。
  topic {
    # topic_arn (Required)
    # 設定内容: 通知先のSNSトピックのARNを指定します。
    # 設定可能な値: SNSトピックのARN
    topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:example-topic"

    # events (Required)
    # 設定内容: 通知をトリガーするS3イベントの種類を指定します。
    # 設定可能な値: "s3:ObjectCreated:*", "s3:ObjectRemoved:*" など
    # 参考: http://docs.aws.amazon.com/AmazonS3/latest/dev/NotificationHowTo.html#notification-how-to-event-types-and-destinations
    events = ["s3:ObjectCreated:*"]

    # filter_prefix (Optional)
    # 設定内容: 通知をトリガーするオブジェクトキーのプレフィックスを指定します。
    # 設定可能な値: 任意の文字列（例: "docs/"）
    # 省略時: プレフィックスによるフィルタリングは行いません
    filter_prefix = null

    # filter_suffix (Optional)
    # 設定内容: 通知をトリガーするオブジェクトキーのサフィックスを指定します。
    # 設定可能な値: 任意の文字列（例: ".log"）
    # 省略時: サフィックスによるフィルタリングは行いません
    filter_suffix = ".log"

    # id (Optional)
    # 設定内容: 各通知設定を一意に識別するIDを指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: AWSが自動生成します
    id = "topic-notification-1"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 通知設定が適用されているS3バケット名
#
#---------------------------------------------------------------
