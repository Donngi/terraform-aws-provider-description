#---------------------------------------------------------------
# AWS Simple Email Service (SES) Event Destination
#---------------------------------------------------------------
#
# AWS SES Event Destination リソースです。
# SES Configuration Set に関連付けられたイベント送信先を定義します。
# バウンス、苦情、配信などのSESイベントをCloudWatch、Kinesis、SNSに転送します。
#
# 主な機能:
#   - SESイベントのCloudWatchメトリクス送信
#   - SESイベントのKinesis Data Streamsへのストリーミング
#   - SESイベントのSNSトピックへの通知
#   - 複数イベントタイプのフィルタリング
#
# AWS公式ドキュメント:
#   - SES Event Destinations 概要: https://docs.aws.amazon.com/ses/latest/dg/monitor-sending-activity-using-notifications.html
#   - Configuration Set イベント送信先: https://docs.aws.amazon.com/ses/latest/dg/event-publishing-add-event-destination.html
#   - SES API リファレンス: https://docs.aws.amazon.com/ses/latest/APIReference/API_CreateConfigurationSetEventDestination.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_event_destination
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ses_event_destination" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # configuration_set_name (Required)
  # 設定内容: イベント送信先を関連付けるConfiguration Setの名前を指定します。
  # 設定可能な値: 既存のaws_ses_configuration_setリソースのname属性
  # 関連機能: SES Configuration Set
  #   このイベント送信先が属するConfiguration Setを識別します。
  #   - https://docs.aws.amazon.com/ses/latest/dg/using-configuration-sets.html
  configuration_set_name = aws_ses_configuration_set.example.name

  # name (Required)
  # 設定内容: イベント送信先の名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列 (最大64文字)
  # 制約: Configuration Set 内で一意である必要があります
  name = "example-event-destination"

  # matching_types (Required)
  # 設定内容: この送信先に転送するSESイベントタイプのセットを指定します。
  # 設定可能な値:
  #   - "send": メール送信イベント
  #   - "reject": メール拒否イベント (SESによるウイルス検出等)
  #   - "bounce": バウンスイベント (恒久的・一時的バウンスの両方)
  #   - "complaint": 苦情イベント (受信者がスパム報告した場合)
  #   - "delivery": 配信成功イベント
  #   - "open": メール開封イベント (開封追跡が有効な場合)
  #   - "click": リンククリックイベント (クリック追跡が有効な場合)
  #   - "renderingFailure": テンプレートレンダリング失敗イベント
  # 省略時: 省略不可 (必須属性)
  # 注意: 1つ以上のイベントタイプを指定する必要があります
  matching_types = [
    "bounce",
    "complaint",
    "delivery",
  ]

  #-------------------------------------------------------------
  # 有効化設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: このイベント送信先を有効化するかどうかを指定します。
  # 設定可能な値:
  #   - true: イベント送信先を有効化 (デフォルト)
  #   - false: イベント送信先を無効化
  # 省略時: false
  # 用途: デバッグ時や一時的な無効化に使用
  enabled = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: SES リージョナルエンドポイント
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#ses_region
  region = null

  #-------------------------------------------------------------
  # CloudWatch送信先 (Optional)
  #-------------------------------------------------------------

  # cloudwatch_destination (Optional)
  # 設定内容: SESイベントをCloudWatchカスタムメトリクスとして送信する設定ブロックです。
  # 用途: SESイベントに基づくCloudWatchメトリクスの記録と監視
  # 注意: cloudwatch_destination、kinesis_destination、sns_destinationのいずれか1つのみ指定可能
  # 注意: このブロックは複数指定可能 (各ブロックが1つのCloudWatchディメンションに対応)
  cloudwatch_destination {
    # default_value (Required)
    # 設定内容: ディメンション値がメールに含まれない場合に使用するデフォルト値を指定します。
    # 設定可能な値: 任意の文字列
    default_value = "default"

    # dimension_name (Required)
    # 設定内容: CloudWatchメトリクスのディメンション名を指定します。
    # 設定可能な値: 任意の文字列 (例: "ses:source-ip", "ses:caller-identity")
    dimension_name = "dimension"

    # value_source (Required)
    # 設定内容: ディメンションの値を取得するソースを指定します。
    # 設定可能な値:
    #   - "messageTag": メールに付与されたタグから値を取得
    #   - "emailHeader": メールヘッダーから値を取得
    #   - "linkTag": リンクタグから値を取得 (クリックイベント専用)
    value_source = "messageTag"
  }

  #-------------------------------------------------------------
  # Kinesis Data Streams送信先 (Optional)
  #-------------------------------------------------------------

  # kinesis_destination (Optional)
  # 設定内容: SESイベントをKinesis Data Streamsに転送する設定ブロックです。
  # 用途: SESイベントのリアルタイムストリーミング処理
  # 注意: cloudwatch_destination、kinesis_destination、sns_destinationのいずれか1つのみ指定可能
  # 注意: このブロックは1つまで指定可能
  # kinesis_destination {
  #   # role_arn (Required)
  #   # 設定内容: Kinesisストリームへの書き込み権限を持つIAMロールのARNを指定します。
  #   # 設定可能な値: IAMロールのARN文字列
  #   # 前提条件: kinesis:PutRecord権限を持つIAMロールが必要
  #   role_arn = aws_iam_role.example.arn
  #
  #   # stream_arn (Required)
  #   # 設定内容: イベントデータを送信するKinesis Data StreamのARNを指定します。
  #   # 設定可能な値: Kinesis Data StreamのARN文字列
  #   stream_arn = aws_kinesis_stream.example.arn
  # }

  #-------------------------------------------------------------
  # SNS送信先 (Optional)
  #-------------------------------------------------------------

  # sns_destination (Optional)
  # 設定内容: SESイベントをSNSトピックに通知する設定ブロックです。
  # 用途: SESイベントに基づくSNS通知の送信 (Lambda連携、メール通知など)
  # 注意: cloudwatch_destination、kinesis_destination、sns_destinationのいずれか1つのみ指定可能
  # 注意: このブロックは1つまで指定可能
  # sns_destination {
  #   # topic_arn (Required)
  #   # 設定内容: イベント通知を送信するSNSトピックのARNを指定します。
  #   # 設定可能な値: SNSトピックのARN文字列
  #   # 前提条件: SESがSNSトピックにメッセージを発行できるポリシーが必要
  #   topic_arn = aws_sns_topic.example.arn
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: SES Event Destination の Amazon Resource Name (ARN)
#   形式: arn:aws:ses:region:account-id:configuration-set/config-set-name/event-destination/name
#
# - id: リソースのID (name と同じ値)
#
#---------------------------------------------------------------
