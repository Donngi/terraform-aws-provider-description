#---------------------------------------------------------------
# AWS Kinesis Video Stream
#---------------------------------------------------------------
#
# Amazon Kinesis Video Streamsのビデオストリームをプロビジョニングするリソースです。
# Kinesis Video Streamsは、接続されたデバイスからAWSへのビデオのセキュアなストリーミングを
# 簡単に実現し、分析・機械学習・再生・その他の処理に活用できます。
#
# AWS公式ドキュメント:
#   - Amazon Kinesis Video Streams概要: https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/what-is-kinesis-video.html
#   - ストリームの作成: https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/API_CreateStream.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_video_stream
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesis_video_stream" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: ビデオストリームの名前を指定します。
  # 設定可能な値: AWSアカウントとリージョン内で一意の文字列
  # 注意: 同一AWSアカウント・リージョン内で一意である必要があります。
  name = "my-kinesis-video-stream"

  # media_type (Optional)
  # 設定内容: ストリームのメディアタイプを指定します。ストリームのコンシューマーが
  #           ストリームを処理する際にこの情報を参照します。
  # 設定可能な値: MIMEタイプ形式の文字列。例: "video/h264", "video/h265", "audio/aac"
  #   メディアタイプの詳細: https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/API_CreateStream.html
  # 省略時: メディアタイプなしでストリームが作成されます。
  media_type = "video/h264"

  # device_name (Optional)
  # 設定内容: ストリームへ書き込むデバイスの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: デバイス名なしでストリームが作成されます。
  # 注意: 現在の実装では、Kinesis Video Streamsはこの名前を実際には使用しません。
  device_name = "my-video-device"

  #-------------------------------------------------------------
  # データ保持設定
  #-------------------------------------------------------------

  # data_retention_in_hours (Optional)
  # 設定内容: ストリーム内のデータを保持する時間数を指定します。
  #           Kinesis Video Streamsはストリームに関連付けられたデータストアにデータを保持します。
  # 設定可能な値: 0以上の整数（時間単位）
  #   - 0: データを永続化しない（デフォルト）
  #   - 1以上: 指定した時間数だけデータを保持
  # 省略時: 0（ストリームはデータを永続化しません）
  data_retention_in_hours = 1

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: ストリームデータの暗号化に使用するAWS KMSキーのIDを指定します。
  # 設定可能な値: 有効なAWS KMSキーID
  # 省略時: Kinesis Video管理のデフォルトキー（aws/kinesisvideo）が使用されます。
  # 参考: https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/how-kms.html
  kms_key_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-kinesis-video-stream"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソースの作成完了を待機する最大時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" などGoのDuration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    create = "5m"

    # update (Optional)
    # 設定内容: リソースの更新完了を待機する最大時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" などGoのDuration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    update = "5m"

    # delete (Optional)
    # 設定内容: リソースの削除完了を待機する最大時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" などGoのDuration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ストリームの一意ID（ARNと同じ値）
# - arn: ストリームのAmazon Resource Name (ARN)
# - creation_time: ストリームが作成された日時のタイムスタンプ
# - version: ストリームのバージョン
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
