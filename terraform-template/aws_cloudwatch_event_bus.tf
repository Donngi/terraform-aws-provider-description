#---------------------------------------------------------------
# AWS CloudWatch Event Bus (Amazon EventBridge Event Bus)
#---------------------------------------------------------------
#
# Amazon EventBridgeのイベントバスをプロビジョニングするリソースです。
# イベントバスは、AWSサービス、カスタムアプリケーション、SaaSアプリケーションから
# イベントを受信するためのパイプラインです。
#
# NOTE: EventBridgeは以前はCloudWatch Eventsとして知られていました。機能は同一です。
#
# AWS公式ドキュメント:
#   - EventBridge概要: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html
#   - イベントバス: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-event-bus.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_event_bus" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 新しいイベントバスの名前を指定します。
  # 設定可能な値: カスタムイベントバスの名前には / 文字を含めることができません。
  # 注意: パートナーイベントバスを作成する場合は、event_source_name と一致させる必要があります。
  name = "my-custom-event-bus"

  # description (Optional)
  # 設定内容: イベントバスの説明を指定します。
  # 設定可能な値: 任意の文字列
  description = "My custom event bus for application events"

  # event_source_name (Optional)
  # 設定内容: 新しいイベントバスと関連付けるパートナーイベントソースを指定します。
  # 設定可能な値: パートナーイベントソース名（パートナーイベントバスを作成する場合に必要）
  # 注意: name と一致する必要があります。
  # 関連機能: SaaSパートナー統合
  #   AWS EventBridgeはZendesk、Datadog、PagerDutyなどのSaaSパートナーからの
  #   イベントを受信できます。
  #   - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-saas.html
  event_source_name = null

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
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_identifier (Optional)
  # 設定内容: イベントバス上のイベントを暗号化するために使用するAWS KMSカスタマーマネージドキーの識別子を指定します。
  # 設定可能な値: キーARN、KeyId、キーエイリアス、またはキーエイリアスARN
  # 関連機能: EventBridge暗号化
  #   AWS KMSを使用してイベントデータを暗号化し、セキュリティを強化できます。
  #   - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-encryption-at-rest-cmk.html
  kms_key_identifier = null

  #-------------------------------------------------------------
  # デッドレターキュー設定
  #-------------------------------------------------------------

  # dead_letter_config (Optional)
  # 設定内容: イベントバスのデッドレターキュー（DLQ）としてEventBridgeが使用するAmazon SQSキューの設定を指定します。
  # 関連機能: EventBridgeデッドレターキュー
  #   配信に失敗したイベントをDLQに送信して、後で再処理できます。
  #   - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-rule-dlq.html
  dead_letter_config {
    # arn (Optional)
    # 設定内容: デッドレターキューのターゲットとして指定するSQSキューのARNを指定します。
    # 設定可能な値: 有効なSQSキューARN
    arn = "arn:aws:sqs:ap-northeast-1:123456789012:my-dlq"
  }

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # log_config (Optional)
  # 設定内容: イベントバスのロギング設定を指定します。
  # 関連機能: EventBridgeイベントバスロギング
  #   イベントバス経由で送信されるイベントの詳細情報をログとして記録できます。
  #   CloudWatch Logs、S3、Firehoseへの配信が可能です。
  log_config {
    # include_detail (Optional)
    # 設定内容: EventBridgeが生成するレコードに詳細なイベント情報を含めるかどうかを指定します。
    # 設定可能な値:
    #   - "NONE": 詳細情報を含めない
    #   - "FULL": 完全な詳細情報を含める
    include_detail = "FULL"

    # level (Optional)
    # 設定内容: 含めるロギング詳細のレベルを指定します。
    # 設定可能な値:
    #   - "OFF": ロギングを無効化
    #   - "ERROR": エラーのみをログに記録
    #   - "INFO": 情報レベルのイベントをログに記録
    #   - "TRACE": 全てのイベントを詳細にログに記録
    level = "INFO"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-custom-event-bus"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: イベントバスのAmazon Resource Name (ARN)
#
# - id: イベントバスの名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
