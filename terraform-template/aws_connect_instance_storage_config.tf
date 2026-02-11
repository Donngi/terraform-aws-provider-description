# ================================================================================
# Terraform AWS Provider Resource Template
# ================================================================================
# Resource: aws_connect_instance_storage_config
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# NOTICE:
# このテンプレートは生成時点の AWS Provider 仕様に基づいています。
# 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_instance_storage_config
# ================================================================================

# Amazon Connect Instance Storage Config
# Amazon Connectインスタンスのストレージ設定を管理するリソース
# コンタクトトレースレコード、通話録音、チャットトランスクリプトなどのデータを
# S3、Kinesis Stream、Kinesis Firehose、Kinesis Video Streamに保存する設定を行います
#
# AWS公式ドキュメント:
# - InstanceStorageConfig API: https://docs.aws.amazon.com/connect/latest/APIReference/API_InstanceStorageConfig.html
# - AssociateInstanceStorageConfig API: https://docs.aws.amazon.com/connect/latest/APIReference/API_AssociateInstanceStorageConfig.html
# - Amazon Connect Getting Started: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html

resource "aws_connect_instance_storage_config" "example" {
  # ================================================================================
  # 必須パラメータ
  # ================================================================================

  # instance_id - (必須) Amazon Connectインスタンスの識別子
  # Amazon Connectインスタンスを指定します
  # 例: "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
  instance_id = "your-connect-instance-id"

  # resource_type - (必須) ストレージを設定するリソースタイプ
  # 保存するデータの種類を指定します
  #
  # 有効な値:
  # - AGENT_EVENTS: エージェントイベント
  # - ATTACHMENTS: 添付ファイル
  # - CALL_RECORDINGS: 通話録音
  # - CHAT_TRANSCRIPTS: チャットトランスクリプト
  # - CONTACT_EVALUATIONS: コンタクト評価
  # - CONTACT_TRACE_RECORDS: コンタクトトレースレコード（CTR）
  # - EMAIL_MESSAGES: Eメールメッセージ
  # - MEDIA_STREAMS: メディアストリーム
  # - REAL_TIME_CONTACT_ANALYSIS_CHAT_SEGMENTS: リアルタイムコンタクト分析チャットセグメント
  # - REAL_TIME_CONTACT_ANALYSIS_SEGMENTS: リアルタイムコンタクト分析セグメント
  # - REAL_TIME_CONTACT_ANALYSIS_VOICE_SEGMENTS: リアルタイムコンタクト分析音声セグメント
  # - SCHEDULED_REPORTS: スケジュールレポート
  # - SCREEN_RECORDINGS: 画面録画
  resource_type = "CONTACT_TRACE_RECORDS"

  # ================================================================================
  # オプションパラメータ
  # ================================================================================

  # id - (オプション) リソースの識別子
  # 形式: <instance_id>:<association_id>:<resource_type>
  # 通常は自動生成されるため、指定不要です
  # id = "auto-generated"

  # region - (オプション) このリソースが管理されるリージョン
  # 未指定の場合、プロバイダー設定のリージョンが使用されます
  #
  # AWS リージョナルエンドポイント:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  # ================================================================================
  # storage_config ブロック（必須、最大1つ）
  # ストレージの設定を定義します
  # ================================================================================
  storage_config {
    # storage_type - (必須) ストレージのタイプ
    #
    # 有効な値:
    # - S3: Amazon S3バケット
    # - KINESIS_VIDEO_STREAM: Kinesis Video Stream
    # - KINESIS_STREAM: Kinesis Data Stream
    # - KINESIS_FIREHOSE: Kinesis Data Firehose
    storage_type = "S3"

    # ================================================================================
    # kinesis_firehose_config ブロック（オプション、最大1つ）
    # storage_type が "KINESIS_FIREHOSE" の場合に必須
    # Kinesis Firehose配信ストリームの設定
    # ================================================================================
    # kinesis_firehose_config {
    #   # firehose_arn - (必須) Kinesis Firehose配信ストリームのARN
    #   # データを配信するKinesis Firehoseストリームを指定します
    #   # 例: "arn:aws:firehose:us-west-2:123456789012:deliverystream/my-stream"
    #   firehose_arn = "arn:aws:firehose:REGION:ACCOUNT_ID:deliverystream/STREAM_NAME"
    # }

    # ================================================================================
    # kinesis_stream_config ブロック（オプション、最大1つ）
    # storage_type が "KINESIS_STREAM" の場合に必須
    # Kinesis Data Streamの設定
    # ================================================================================
    # kinesis_stream_config {
    #   # stream_arn - (必須) Kinesis Data StreamのARN
    #   # データをストリーミングするKinesis Streamを指定します
    #   # 例: "arn:aws:kinesis:us-west-2:123456789012:stream/my-stream"
    #   stream_arn = "arn:aws:kinesis:REGION:ACCOUNT_ID:stream/STREAM_NAME"
    # }

    # ================================================================================
    # kinesis_video_stream_config ブロック（オプション、最大1つ）
    # storage_type が "KINESIS_VIDEO_STREAM" の場合に必須
    # Kinesis Video Streamの設定（主にMEDIA_STREAMSで使用）
    # ================================================================================
    # kinesis_video_stream_config {
    #   # prefix - (必須) ビデオストリームのプレフィックス
    #   # 最小長: 1、最大長: 128
    #   # 注意: APIは追加の詳細を付加するため、stateから読み込む際は
    #   # "<prefix>-connect-<connect_instance_alias>-contact-" の形式になります
    #   prefix = "my-video-stream"
    #
    #   # retention_period_hours - (必須) データ保持時間（時間単位）
    #   # Kinesis Video Streamがデータを保持する時間を指定します
    #   # 最小値: 0（データを保持しない）
    #   # 最大値: 87600（10年）
    #   retention_period_hours = 24
    #
    #   # ================================================================================
    #   # encryption_config ブロック（必須、最大1つ）
    #   # Kinesis Video Stream用の暗号化設定
    #   # ================================================================================
    #   encryption_config {
    #     # encryption_type - (必須) 暗号化タイプ
    #     # 有効な値: KMS
    #     encryption_type = "KMS"
    #
    #     # key_id - (必須) 暗号化キーの完全なARN
    #     # AWS KMSキーのIDではなく、完全なARNを指定してください
    #     # 例: "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
    #     key_id = "arn:aws:kms:REGION:ACCOUNT_ID:key/KEY_ID"
    #   }
    # }

    # ================================================================================
    # s3_config ブロック（オプション、最大1つ）
    # storage_type が "S3" の場合に必須
    # Amazon S3バケットの設定
    # ================================================================================
    s3_config {
      # bucket_name - (必須) S3バケット名
      # データを保存するS3バケットを指定します
      # 例: "my-connect-recordings"
      bucket_name = "your-s3-bucket-name"

      # bucket_prefix - (必須) S3バケットのプレフィックス
      # S3バケット内でデータを保存するプレフィックス（フォルダパス）を指定します
      # 例: "connect/recordings/"
      bucket_prefix = "your-prefix/"

      # ================================================================================
      # encryption_config ブロック（オプション、最大1つ）
      # S3用の暗号化設定
      # ================================================================================
      # encryption_config {
      #   # encryption_type - (必須) 暗号化タイプ
      #   # 有効な値: KMS
      #   encryption_type = "KMS"
      #
      #   # key_id - (必須) 暗号化キーの完全なARN
      #   # AWS KMSキーのIDではなく、完全なARNを指定してください
      #   # 例: "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
      #   key_id = "arn:aws:kms:REGION:ACCOUNT_ID:key/KEY_ID"
      # }
    }
  }
}

# ================================================================================
# 出力例
# ================================================================================
# output "association_id" {
#   description = "ストレージ設定の関連付けID"
#   value       = aws_connect_instance_storage_config.example.association_id
# }
#
# output "id" {
#   description = "リソースの識別子 (instance_id:association_id:resource_type)"
#   value       = aws_connect_instance_storage_config.example.id
# }
