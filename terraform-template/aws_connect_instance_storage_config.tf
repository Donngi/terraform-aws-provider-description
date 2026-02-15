# Resource: aws_connect_instance_storage_config
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/connect_instance_storage_config
# NOTE: このテンプレートは手動での確認と調整が必要な場合があります

#-----------------------------------------------------------------------
# 概要
#-----------------------------------------------------------------------
# Amazon Connectインスタンスのストレージ設定を管理するリソースです。
# 通話録音、チャット記録、メディアストリーム、レポート等のデータを、
# S3、Kinesis Stream、Kinesis Firehose、Kinesis Video Streamに保存する設定を行います。
# リソースタイプごとに異なるストレージタイプが使用可能です。

#-----------------------------------------------------------------------
# 基本構成
#-----------------------------------------------------------------------

resource "aws_connect_instance_storage_config" "example" {
  # 必須パラメータ
  instance_id   = "arn:aws:connect:ap-northeast-1:123456789012:instance/12345678-1234-1234-1234-123456789012"
  resource_type = "CHAT_TRANSCRIPTS"

  storage_config {
    storage_type = "S3"

    s3_config {
      bucket_name   = "connect-transcripts-bucket"
      bucket_prefix = "chat-logs"

      encryption_config {
        encryption_type = "KMS"
        key_id          = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
      }
    }
  }

  # 省略可能パラメータ
  region = null
}

#-----------------------------------------------------------------------
# パラメータ詳細
#-----------------------------------------------------------------------

#---------------------------------------
# 基本設定
#---------------------------------------

# instance_id
# 設定内容: Amazon ConnectインスタンスのID（ARN形式）
# 必須: はい
# 型: string
# 補足: インスタンスARNを指定します

# resource_type
# 設定内容: ストレージを設定するリソースタイプ
# 必須: はい
# 型: string
# 設定可能な値:
#   - CALL_RECORDINGS: 通話録音
#   - CHAT_TRANSCRIPTS: チャット記録
#   - SCHEDULED_REPORTS: スケジュールレポート
#   - MEDIA_STREAMS: メディアストリーム
#   - CONTACT_TRACE_RECORDS: コンタクトトレースレコード
#   - AGENT_EVENTS: エージェントイベント
#   - REAL_TIME_CONTACT_ANALYSIS_SEGMENTS: リアルタイム連絡分析セグメント
#   - ATTACHMENTS: 添付ファイル
#   - CONTACT_EVALUATIONS: コンタクト評価
#   - SCREEN_RECORDINGS: 画面録画

#---------------------------------------
# リージョン設定
#---------------------------------------

# region
# 設定内容: リソースの管理リージョン
# 必須: いいえ
# 型: string
# 省略時: プロバイダー設定のリージョンを使用

#---------------------------------------
# ストレージ設定
#---------------------------------------

# storage_config
# 設定内容: ストレージの詳細設定
# 必須: はい
# 型: block
# 最大個数: 1
# 補足: storage_typeに応じて適切な設定ブロックを含める必要があります

# storage_config.storage_type
# 設定内容: 使用するストレージサービスのタイプ
# 必須: はい
# 型: string
# 設定可能な値:
#   - S3: Amazon S3バケット
#   - KINESIS_STREAM: Amazon Kinesis Data Stream
#   - KINESIS_FIREHOSE: Amazon Kinesis Data Firehose
#   - KINESIS_VIDEO_STREAM: Amazon Kinesis Video Stream

#---------------------------------------
# S3設定
#---------------------------------------

# storage_config.s3_config
# 設定内容: S3ストレージの設定
# 必須: storage_typeがS3の場合は必須
# 型: block
# 最大個数: 1

# storage_config.s3_config.bucket_name
# 設定内容: データを保存するS3バケット名
# 必須: はい
# 型: string

# storage_config.s3_config.bucket_prefix
# 設定内容: バケット内のオブジェクトキープレフィックス
# 必須: はい
# 型: string
# 補足: データの保存先パスを指定します

# storage_config.s3_config.encryption_config
# 設定内容: S3暗号化設定
# 必須: いいえ
# 型: block
# 最大個数: 1

# storage_config.s3_config.encryption_config.encryption_type
# 設定内容: 暗号化タイプ
# 必須: はい
# 型: string
# 設定可能な値: KMS

# storage_config.s3_config.encryption_config.key_id
# 設定内容: KMS暗号化キーのARN
# 必須: はい
# 型: string

#---------------------------------------
# Kinesis Stream設定
#---------------------------------------

# storage_config.kinesis_stream_config
# 設定内容: Kinesis Data Streamストレージの設定
# 必須: storage_typeがKINESIS_STREAMの場合は必須
# 型: block
# 最大個数: 1

# storage_config.kinesis_stream_config.stream_arn
# 設定内容: Kinesis Data StreamのARN
# 必須: はい
# 型: string

#---------------------------------------
# Kinesis Firehose設定
#---------------------------------------

# storage_config.kinesis_firehose_config
# 設定内容: Kinesis Firehoseストレージの設定
# 必須: storage_typeがKINESIS_FIREHOSEの場合は必須
# 型: block
# 最大個数: 1

# storage_config.kinesis_firehose_config.firehose_arn
# 設定内容: Kinesis FirehoseのARN
# 必須: はい
# 型: string

#---------------------------------------
# Kinesis Video Stream設定
#---------------------------------------

# storage_config.kinesis_video_stream_config
# 設定内容: Kinesis Video Streamストレージの設定
# 必須: storage_typeがKINESIS_VIDEO_STREAMの場合は必須
# 型: block
# 最大個数: 1
# 補足: 通話録音のビデオストリーミングに使用されます

# storage_config.kinesis_video_stream_config.prefix
# 設定内容: Kinesis Video Streamの名前プレフィックス
# 必須: はい
# 型: string

# storage_config.kinesis_video_stream_config.retention_period_hours
# 設定内容: データ保持期間（時間単位）
# 必須: はい
# 型: number
# 補足: ストリームにデータを保持する時間を指定します

# storage_config.kinesis_video_stream_config.encryption_config
# 設定内容: Kinesis Video Stream暗号化設定
# 必須: はい
# 型: block
# 最小個数: 1
# 最大個数: 1

# storage_config.kinesis_video_stream_config.encryption_config.encryption_type
# 設定内容: 暗号化タイプ
# 必須: はい
# 型: string
# 設定可能な値: KMS

# storage_config.kinesis_video_stream_config.encryption_config.key_id
# 設定内容: KMS暗号化キーのARN
# 必須: はい
# 型: string

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------

# id: ConnectインスタンスIDとアソシエーションIDの連結形式
# association_id: ストレージ設定のアソシエーションID
