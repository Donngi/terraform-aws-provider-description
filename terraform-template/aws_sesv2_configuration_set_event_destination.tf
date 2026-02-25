#---------------------------------------------------------------
# AWS SESv2 Configuration Set Event Destination
#---------------------------------------------------------------
#
# Amazon SES (Simple Email Service) v2のコンフィギュレーションセットに
# イベント送信先を追加するリソースです。
# イベント送信先とは、SESがメール送信イベント（送信、バウンス、クリック等）を
# 通知するAWSサービスの設定です。CloudWatch、Kinesis Firehose、SNS、
# EventBridge、Amazon Pinpointを送信先として指定できます。
#
# AWS公式ドキュメント:
#   - イベント送信先の概要: https://docs.aws.amazon.com/ses/latest/dg/monitor-sending-activity.html
#   - コンフィギュレーションセット: https://docs.aws.amazon.com/ses/latest/dg/using-configuration-sets.html
#   - CreateConfigurationSetEventDestination API:
#     https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_CreateConfigurationSetEventDestination.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_configuration_set_event_destination
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sesv2_configuration_set_event_destination" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # configuration_set_name (Required)
  # 設定内容: イベント送信先を追加するコンフィギュレーションセットの名前を指定します。
  # 設定可能な値: 既存のコンフィギュレーションセット名
  configuration_set_name = "my-configuration-set"

  # event_destination_name (Required)
  # 設定内容: イベント送信先の名前を指定します。
  # 設定可能な値: 一意の文字列（コンフィギュレーションセット内で一意）
  event_destination_name = "my-event-destination"

  #-------------------------------------------------------------
  # イベント送信先設定
  #-------------------------------------------------------------

  # event_destination (Required)
  # 設定内容: イベント送信先の詳細設定を指定するブロックです。
  # 注意: 以下のサブブロックのうち、いずれか1つを指定する必要があります。
  event_destination {
    # enabled (Optional)
    # 設定内容: イベント送信先を有効にするかどうかを指定します。
    # 設定可能な値: true（有効）, false（無効）
    # 省略時: false（送信先は無効化された状態で作成されます）
    enabled = true

    # matching_event_types (Required)
    # 設定内容: この送信先に転送するメールイベントの種類を指定します。
    # 設定可能な値:
    #   - "SEND": メール送信の試行
    #   - "REJECT": SESがメール送信を拒否（例: メールがウイルスを含む場合）
    #   - "BOUNCE": 配信不能（バウンス）
    #   - "COMPLAINT": スパム報告（苦情）
    #   - "DELIVERY": 配信成功
    #   - "OPEN": 受信者がメールを開封（オープントラッキング有効時）
    #   - "CLICK": 受信者がメール内のリンクをクリック（クリックトラッキング有効時）
    #   - "RENDERING_FAILURE": テンプレートのレンダリング失敗
    #   - "DELIVERY_DELAY": 配信遅延
    #   - "SUBSCRIPTION": 受信者がメーリングリストへの登録・解除を行った
    matching_event_types = ["SEND", "REJECT", "BOUNCE", "COMPLAINT", "DELIVERY"]

    #-----------------------------------------------------------
    # CloudWatch送信先設定
    #-----------------------------------------------------------

    # cloud_watch_destination (Optional)
    # 設定内容: CloudWatchにイベントを送信する設定を指定するブロックです。
    # 注意: cloud_watch_destination、event_bridge_destination、
    #       kinesis_firehose_destination、pinpoint_destination、
    #       sns_destination のうち、いずれか1つのみ指定できます。
    cloud_watch_destination {
      # dimension_configuration (Required, 1件以上)
      # 設定内容: CloudWatchメトリクスのディメンション設定を指定するブロックです。
      dimension_configuration {
        # default_dimension_value (Required)
        # 設定内容: ディメンション値がメールヘッダーや送信タグに含まれない場合に
        #           使用するデフォルト値を指定します。
        # 設定可能な値: 任意の文字列
        default_dimension_value = "none"

        # dimension_name (Required)
        # 設定内容: CloudWatchメトリクスのディメンション名を指定します。
        # 設定可能な値: 任意の文字列（ASCII文字、ハイフン、アンダースコア）
        dimension_name = "ses:from-domain"

        # dimension_value_source (Required)
        # 設定内容: ディメンション値の取得元を指定します。
        # 設定可能な値:
        #   - "MESSAGE_TAG": SES送信APIリクエストに含まれるメッセージタグから取得
        #   - "EMAIL_HEADER": メールヘッダーから取得
        #   - "LINK_TAG": リンクタグから取得
        dimension_value_source = "EMAIL_HEADER"
      }
    }

    #-----------------------------------------------------------
    # EventBridge送信先設定（cloud_watch_destinationと排他）
    #-----------------------------------------------------------

    # event_bridge_destination (Optional)
    # 設定内容: EventBridgeにイベントを送信する設定を指定するブロックです。
    # event_bridge_destination {
    #   # event_bus_arn (Required)
    #   # 設定内容: イベントを送信するEventBridgeバスのARNを指定します。
    #   # 設定可能な値: EventBridgeバスのARN
    #   event_bus_arn = "arn:aws:events:us-east-1:123456789012:event-bus/my-event-bus"
    # }

    #-----------------------------------------------------------
    # Kinesis Firehose送信先設定（cloud_watch_destinationと排他）
    #-----------------------------------------------------------

    # kinesis_firehose_destination (Optional)
    # 設定内容: Kinesis Data Firehoseにイベントを送信する設定を指定するブロックです。
    # kinesis_firehose_destination {
    #   # delivery_stream_arn (Required)
    #   # 設定内容: イベントを送信するFirehose配信ストリームのARNを指定します。
    #   # 設定可能な値: Kinesis Firehose配信ストリームのARN
    #   delivery_stream_arn = "arn:aws:firehose:us-east-1:123456789012:deliverystream/my-stream"
    #
    #   # iam_role_arn (Required)
    #   # 設定内容: SESがFirehoseにイベントを書き込むために使用するIAMロールのARNを指定します。
    #   # 設定可能な値: IAMロールのARN（Firehoseへの書き込み権限が必要）
    #   iam_role_arn = "arn:aws:iam::123456789012:role/ses-firehose-role"
    # }

    #-----------------------------------------------------------
    # Pinpoint送信先設定（cloud_watch_destinationと排他）
    #-----------------------------------------------------------

    # pinpoint_destination (Optional)
    # 設定内容: Amazon Pinpointにイベントを送信する設定を指定するブロックです。
    # pinpoint_destination {
    #   # application_arn (Required)
    #   # 設定内容: イベントを送信するPinpointアプリケーションのARNを指定します。
    #   # 設定可能な値: Pinpointアプリケーションのus-east-1リージョンのARN
    #   application_arn = "arn:aws:mobiletargeting:us-east-1:123456789012:apps/abcdef123456"
    # }

    #-----------------------------------------------------------
    # SNS送信先設定（cloud_watch_destinationと排他）
    #-----------------------------------------------------------

    # sns_destination (Optional)
    # 設定内容: Amazon SNSにイベントを送信する設定を指定するブロックです。
    # sns_destination {
    #   # topic_arn (Required)
    #   # 設定内容: イベントを送信するSNSトピックのARNを指定します。
    #   # 設定可能な値: SNSトピックのARN
    #   topic_arn = "arn:aws:sns:us-east-1:123456789012:my-topic"
    # }
  }

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
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: コンフィギュレーションセット名とイベント送信先名をコロンで
#       結合した文字列（configuration_set_name:event_destination_name）
#---------------------------------------------------------------
