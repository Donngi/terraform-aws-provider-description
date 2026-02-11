#---------------------------------------------------------------
# Amazon Kinesis Video Streams
#---------------------------------------------------------------
#
# 接続されたデバイスから安全にビデオをAWSにストリーミングするためのマネージドサービス。
# スマートフォン、ドローン、ダッシュカム、セキュリティカメラなどのデバイスから
# リアルタイムおよび録画済みのビデオデータを取り込み、分析、機械学習、
# 再生などの処理に利用できます。
#
# 主な特徴:
# - デバイスからのリアルタイムビデオストリーミング
# - データの永続化とタイムインデックス生成
# - サーバーレスで自動スケーリング
# - AWS KMSによる暗号化（保存時および転送時）
# - WebRTCサポートによる双方向リアルタイム通信
#
# AWS公式ドキュメント:
#   - Kinesis Video Streamsとは: https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/what-is-kinesis-video.html
#   - メリット: https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/benefits.html
#   - データ保護: https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/how-kms.html
#   - API操作: https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/API_Operations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_video_stream
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesis_video_stream" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ストリーム名
  # AWSアカウントおよびリージョン内で一意である必要があります
  # 命名規則に従って、わかりやすい名前を設定してください
  name = "terraform-kinesis-video-stream"

  #---------------------------------------------------------------
  # データ保持設定
  #---------------------------------------------------------------

  # データ保持期間（時間単位）
  # ストリームに関連付けられたデータストアにデータを保持する時間数
  # デフォルト: 0（データを永続化しない）
  # 最小値: 0時間
  # 最大値: 87600時間（10年間）
  # 注意: データ保持を有効にすると、保存容量に対する料金が発生します
  # https://aws.amazon.com/kinesis/video-streams/pricing/
  data_retention_in_hours = 1

  #---------------------------------------------------------------
  # デバイス設定
  #---------------------------------------------------------------

  # デバイス名
  # ストリームに書き込むデバイスの名前
  # 注意: 現在の実装では、Kinesis Video Streamsはこの名前を使用しません
  # メタデータとして保存されますが、ストリームの動作には影響しません
  device_name = "kinesis-video-device-name"

  #---------------------------------------------------------------
  # メディアタイプ設定
  #---------------------------------------------------------------

  # メディアタイプ
  # ストリームのメディアタイプを指定
  # ストリームのコンシューマーは、この情報を使用して処理を行います
  # 一般的な値:
  # - video/h264: H.264ビデオコーデック
  # - video/h265: H.265 (HEVC)ビデオコーデック
  # - video/x-matroska: Matroskaコンテナ形式
  # - audio/aac: AACオーディオコーデック
  # メディアタイプの命名規則については公式ドキュメントを参照してください
  # https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/producer-reference-structures-producer.html
  media_type = "video/h264"

  #---------------------------------------------------------------
  # 暗号化設定
  #---------------------------------------------------------------

  # KMSキーID
  # Kinesis Video Streamsがストリームデータの暗号化に使用する
  # AWS Key Management Service (AWS KMS)キーのID
  # 指定しない場合、デフォルトのKinesis Video管理キー（aws/kinesisvideo）が使用されます
  # カスタマーマネージドキーを使用する場合、キーIDまたはARNを指定してください
  # 注意: AWS KMSの利用には追加料金が発生します（デフォルトキーは無料）
  # https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/how-kms.html
  # kms_key_id = "alias/aws/kinesisvideo"

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # リソースを管理するAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  # Kinesis Video Streamsは特定のリージョンでのみ利用可能です
  # 利用可能なリージョンについては以下を参照してください:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # https://docs.aws.amazon.com/general/latest/gr/kvs.html
  # region = "us-east-1"

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # リソースに割り当てるタグのマップ
  # ストリームの識別、コスト配分、アクセス制御に使用できます
  # プロバイダーのdefault_tags設定ブロックと組み合わせて使用できます
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "terraform-kinesis-video-stream"
    Environment = "production"
    Purpose     = "video-analytics"
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # 各操作のタイムアウト時間を設定
  # ストリームの作成、更新、削除には時間がかかる場合があります
  # ネットワーク状況や他のリソースとの依存関係によって調整してください
  # timeouts {
  #   create = "5m"
  #   update = "5m"
  #   delete = "5m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed属性）:
#
# - id: ストリームの一意ID（ARNと同じ値）
# - arn: ストリームのAmazon Resource Name (ARN)
#        形式: arn:aws:kinesisvideo:region:account-id:stream/stream-name/creation-time
# - creation_time: ストリームが作成された日時のタイムスタンプ
#                  形式: YYYY-MM-DDTHH:MM:SS.sssZ (ISO 8601形式)
# - version: ストリームのバージョン
#            ストリームのメタデータが更新されるたびにインクリメントされます
# - tags_all: リソースに割り当てられたすべてのタグのマップ
#             プロバイダーのdefault_tagsから継承したタグを含む
#
# 使用例:
# output "kinesis_video_stream_arn" {
#   description = "The ARN of the Kinesis Video Stream"
#   value       = aws_kinesis_video_stream.example.arn
# }
#
# output "kinesis_video_stream_creation_time" {
#   description = "The creation timestamp of the stream"
#   value       = aws_kinesis_video_stream.example.creation_time
# }
#
# output "kinesis_video_stream_version" {
#   description = "The version of the stream"
#   value       = aws_kinesis_video_stream.example.version
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: プロデューサーとコンシューマー
#---------------------------------------------------------------
#
# Kinesis Video Streamsにデータを送信するには、以下のプロデューサーSDKを使用できます:
#
# 1. Producer SDK (C++, Java, Android):
#    - C++: https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/producer-sdk-cpp.html
#    - Java: https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/producer-sdk-javaapi.html
#    - Android: https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/producer-sdk-android.html
#
# 2. GStreamerプラグイン:
#    - GStreamerパイプラインを使用してビデオをストリーミング
#    - ラズベリーパイやその他のLinuxデバイスで使用可能
#    - 例: gst-launch-1.0 videotestsrc ! kvssink stream-name="stream-name"
#
# 3. WebRTC SDK:
#    - ブラウザやモバイルアプリからの双方向リアルタイム通信
#    - https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/kvswebrtc-sdk.html
#
# ストリームからデータを読み取るには、以下のAPIを使用できます:
#
# 1. GetMedia API: リアルタイムでストリーミングデータを取得
# 2. GetMediaForFragmentList API: 特定のフラグメントを取得
# 3. GetHLSStreamingSessionURL API: HLSプロトコルで再生用URLを取得
# 4. GetDASHStreamingSessionURL API: DASHプロトコルで再生用URLを取得
#
# Amazon Rekognition Videoとの統合:
# - ストリームからリアルタイムでビデオ分析を実行
# - 顔認識、物体検出、アクティビティ認識などが可能
# - https://docs.aws.amazon.com/rekognition/latest/dg/streaming-video.html
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# セキュリティのベストプラクティス
#---------------------------------------------------------------
#
# 1. 暗号化の有効化:
#    - カスタマーマネージドKMSキーを使用して暗号化を有効化
#    - kms_key_idパラメータでキーIDを指定
#
# 2. IAMポリシーによるアクセス制御:
#    - 最小権限の原則に従い、必要な操作のみを許可
#    - ストリームレベルでのきめ細かいアクセス制御を実装
#
# 3. VPCエンドポイントの使用:
#    - プライベートネットワーク経由でKinesis Video Streamsにアクセス
#    - インターネットを経由せずに安全に通信
#
# 4. CloudTrailによる監査:
#    - すべてのAPI呼び出しをCloudTrailでログ記録
#    - セキュリティインシデントの検出と調査に活用
#
# 5. タグベースのアクセス制御:
#    - IAMポリシーでタグを使用してリソースへのアクセスを制限
#    - 環境やプロジェクト単位での権限管理が可能
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# コスト最適化のヒント
#---------------------------------------------------------------
#
# 1. データ保持期間の最適化:
#    - 必要最小限の保持期間を設定
#    - 長期保存が必要な場合はS3へのアーカイブを検討
#
# 2. ストレージティアの活用:
#    - ウォームストレージティアを使用して長期保存コストを削減
#    - アクセス頻度の低いデータに適用
#    - https://aws.amazon.com/blogs/iot/optimize-long-term-video-storage-costs-with-amazon-kinesis-video-streams-warm-storage-tier/
#
# 3. 不要なストリームの削除:
#    - 使用していないストリームは削除してコストを節約
#    - Terraformのライフサイクルポリシーで管理
#
# 4. モニタリングとアラート:
#    - CloudWatchメトリクスで使用状況を監視
#    - 予期しないコスト増加を早期に検出
#
# 5. フラグメント長の調整:
#    - ウォームティアではフラグメントベースの課金
#    - フラグメント長を調整して取り込みコストを削減
#
#---------------------------------------------------------------
