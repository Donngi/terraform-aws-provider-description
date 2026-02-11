#---------------------------------------------------------------
# Amazon Kinesis Data Stream
#---------------------------------------------------------------
#
# リアルタイムストリーミングデータを収集・処理するためのマネージドサービス。
# ウェブサイトのクリックストリーム、データベースイベントストリーム、
# 金融取引、ソーシャルメディアフィード、ITログ、位置情報追跡イベントなど、
# 大量のデータをリアルタイムで取り込み、複数のコンシューマーアプリケーションで
# 並行して処理することができます。
#
# AWS公式ドキュメント:
#   - Amazon Kinesis Data Streams とは: https://docs.aws.amazon.com/streams/latest/dev/introduction.html
#   - 用語と概念: https://docs.aws.amazon.com/streams/latest/dev/key-concepts.html
#   - 容量モードの選択: https://docs.aws.amazon.com/streams/latest/dev/how-do-i-size-a-stream.html
#   - サーバー側暗号化: https://docs.aws.amazon.com/streams/latest/dev/server-side-encryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesis_stream" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ストリーム名
  # AWSアカウントとリージョン内で一意である必要があります
  name = "example-stream"

  #---------------------------------------------------------------
  # 容量モード設定
  #---------------------------------------------------------------

  # ストリームモードの詳細設定
  # stream_mode: "PROVISIONED" または "ON_DEMAND" を指定
  # - PROVISIONED: shard_countで明示的にシャード数を指定
  # - ON_DEMAND: 自動的にスループットに応じてスケール（Standard/Advantageモード）
  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  # シャード数
  # stream_modeが "PROVISIONED" の場合は必須
  # 各シャードは以下の容量を提供します:
  # - 読み取り: 最大2MB/秒、最大5トランザクション/秒
  # - 書き込み: 最大1MB/秒、最大1000レコード/秒
  # データレートに応じて適切なシャード数を設定してください
  shard_count = 1

  #---------------------------------------------------------------
  # データ保持設定
  #---------------------------------------------------------------

  # データ保持期間（時間単位）
  # デフォルト: 24時間
  # 最小値: 24時間
  # 最大値: 8760時間（365日）
  # 24時間を超える保持期間には追加料金が発生します
  # https://aws.amazon.com/kinesis/pricing/
  retention_period = 24

  #---------------------------------------------------------------
  # 暗号化設定
  #---------------------------------------------------------------

  # 暗号化タイプ
  # "NONE" または "KMS" を指定
  # デフォルト: "NONE"
  # KMSを使用する場合、AWS KMSの利用料金が発生します
  encryption_type = "NONE"

  # KMSキーID
  # encryption_typeが "KMS" の場合に指定
  # カスタマーマネージドキーのGUIDまたはARNを指定
  # または Kinesis所有のマスターキーを使用する場合は "alias/aws/kinesis" を指定
  # プロデューサーとコンシューマーアプリケーションには、
  # マスターキーへのアクセス許可が必要です
  # kms_key_id = "alias/aws/kinesis"

  #---------------------------------------------------------------
  # モニタリング設定
  #---------------------------------------------------------------

  # シャードレベルのCloudWatchメトリクス
  # 有効化するメトリクスのリスト
  # 注意: "ALL" は使用せず、明示的にメトリクス名を指定してください
  # 利用可能なメトリクス:
  # - IncomingBytes: 受信バイト数
  # - IncomingRecords: 受信レコード数
  # - OutgoingBytes: 送信バイト数
  # - OutgoingRecords: 送信レコード数
  # - WriteProvisionedThroughputExceeded: 書き込みスループット超過
  # - ReadProvisionedThroughputExceeded: 読み取りスループット超過
  # - IteratorAgeMilliseconds: イテレーターの経過時間
  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  #---------------------------------------------------------------
  # データレコードサイズ設定
  #---------------------------------------------------------------

  # 単一データレコードの最大サイズ（KiB単位）
  # 最小値: 1024 KiB (1 MB)
  # 最大値: 10240 KiB (10 MB)
  # デフォルト: 1024 KiB
  # 大きなレコードを扱う場合に設定します
  # max_record_size_in_kib = 1024

  #---------------------------------------------------------------
  # コンシューマー管理
  #---------------------------------------------------------------

  # コンシューマー削除の強制
  # trueの場合、ストリーム削除時に登録されたすべてのコンシューマーが
  # 自動的に登録解除されます
  # デフォルト: false
  # enhanced fan-outコンシューマーが登録されている場合、
  # trueに設定することでストリーム削除時のエラーを回避できます
  enforce_consumer_deletion = false

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # リソースを管理するAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # リソースに割り当てるタグのマップ
  # プロバイダーのdefault_tags設定ブロックと組み合わせて使用できます
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-stream"
    Environment = "production"
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # 各操作のタイムアウト時間を設定
  # timeouts {
  #   create = "5m"
  #   update = "120m"
  #   delete = "120m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed属性）:
#
# - id: ストリームの一意ID（arnと同じ値）
# - name: ストリーム名
# - shard_count: シャード数
# - arn: ストリームのAmazon Resource Name（ARN）
# - tags_all: リソースに割り当てられたすべてのタグのマップ
#             プロバイダーのdefault_tagsから継承したタグを含む
#
# 使用例:
# output "kinesis_stream_arn" {
#   value = aws_kinesis_stream.example.arn
# }
#---------------------------------------------------------------
