#---------------------------------------------------------------
# AWS Chime Voice Connector Streaming
#---------------------------------------------------------------
#
# Amazon Chime Voice Connectorのストリーミング設定を構成するリソースです。
# ストリーミング設定では、Amazon Kinesis Video Streamsへのメディアストリーミングの
# 有効化・無効化、データ保持期間（時間単位）、通知ターゲットの設定を行います。
#
# AWS公式ドキュメント:
#   - Voice Connector ストリーミング概要: https://docs.aws.amazon.com/chime-sdk/latest/ag/start-kinesis-vc.html
#   - Voice Connector 設定編集: https://docs.aws.amazon.com/chime-sdk/latest/ag/edit-voicecon.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chime_voice_connector_streaming
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_chime_voice_connector_streaming" "example" {
  #-------------------------------------------------------------
  # Voice Connector識別子
  #-------------------------------------------------------------

  # voice_connector_id (Required)
  # 設定内容: ストリーミング設定を適用するAmazon Chime Voice ConnectorのIDを指定します。
  # 設定可能な値: 有効なVoice Connector ID
  # 注意: aws_chime_voice_connectorリソースの出力から取得できます
  voice_connector_id = aws_chime_voice_connector.example.id

  #-------------------------------------------------------------
  # データ保持期間設定
  #-------------------------------------------------------------

  # data_retention (Required)
  # 設定内容: Amazon Kinesis Video Streamsでのデータ保持期間を時間単位で指定します。
  # 設定可能な値: 0-87600（時間）
  #   - 0: 保持しない
  #   - 任意の正の整数: 指定した時間保持
  # 関連機能: Amazon Kinesis Video Streams データ保持
  #   ストリーミングされた音声データはKinesis Video Streamsに保存され、
  #   指定した保持期間が経過すると自動的に削除されます。
  #   - https://docs.aws.amazon.com/chime-sdk/latest/ag/start-kinesis-vc.html
  data_retention = 7

  #-------------------------------------------------------------
  # ストリーミング有効化設定
  #-------------------------------------------------------------

  # disabled (Optional)
  # 設定内容: Amazon Kinesisへのメディアストリーミングを無効化するかを指定します。
  # 設定可能な値:
  #   - true: メディアストリーミングを無効化
  #   - false (デフォルト): メディアストリーミングを有効化
  # 用途: 一時的にストリーミングを停止したい場合に使用
  disabled = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, eu-west-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ストリーミング通知ターゲット設定
  #-------------------------------------------------------------

  # streaming_notification_targets (Optional)
  # 設定内容: ストリーミングイベントの通知先を指定します。
  # 設定可能な値:
  #   - "EventBridge": Amazon EventBridgeに通知
  #   - "SNS": Amazon Simple Notification Serviceに通知
  #   - "SQS": Amazon Simple Queue Serviceに通知
  # 省略時: 通知なし
  # 関連機能: Voice Connector ストリーミング通知
  #   ストリーミングイベント（開始・終了など）を指定した
  #   AWSサービスに通知できます。
  streaming_notification_targets = ["SQS"]

  #-------------------------------------------------------------
  # Media Insights設定
  #-------------------------------------------------------------

  # media_insights_configuration (Optional)
  # 設定内容: メディアインサイトパイプライン設定を指定します。
  # Voice Connectorからのメディアストリームに対して、
  # 音声分析（トランスクリプト、コールアナリティクス等）を実行できます。
  # 関連機能: Amazon Chime SDK Media Insights
  #   リアルタイムの音声分析機能を提供します。
  #   Amazon Transcribe Call Analyticsなどと連携可能です。

  media_insights_configuration {
    # disabled (Optional)
    # 設定内容: メディアインサイト設定を無効化するかを指定します。
    # 設定可能な値:
    #   - true: メディアインサイトを無効化
    #   - false (デフォルト): メディアインサイトを有効化
    disabled = false

    # configuration_arn (Optional)
    # 設定内容: Voice Connectorで呼び出すメディアインサイト設定のARNを指定します。
    # 設定可能な値: 有効なaws_chimesdkmediapipelines_media_insights_pipeline_configurationリソースのARN
    # 注意: メディアインサイト機能を使用する場合は必須
    configuration_arn = aws_chimesdkmediapipelines_media_insights_pipeline_configuration.example.arn
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Amazon Chime Voice Connector ID
#       voice_connector_idと同じ値がエクスポートされます。
#---------------------------------------------------------------
