#---------------------------------------------------------------
# Amazon Kinesis Data Streams ストリーム
#---------------------------------------------------------------
#
# Amazon Kinesis Data Streams のストリームをプロビジョニングするリソースです。
# Kinesis Data Streams はリアルタイムデータストリーミングサービスで、大規模な
# データを継続的にキャプチャ、処理、保存することができます。
# オンデマンドモードとプロビジョニングモードの2種類のスループットモードをサポートします。
#
# AWS公式ドキュメント:
#   - Amazon Kinesis Data Streams: https://docs.aws.amazon.com/streams/latest/dev/introduction.html
#   - ストリームの管理: https://docs.aws.amazon.com/streams/latest/dev/working-with-streams.html
#   - 暗号化: https://docs.aws.amazon.com/streams/latest/dev/server-side-encryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesis_stream" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ストリームの名前を指定します。
  # 設定可能な値: 最大128文字の英字、数字、ハイフン、アンダースコア、ピリオド
  name = "example-stream"

  # arn (Optional, Computed)
  # 設定内容: ストリームのARNを指定します。
  # 設定可能な値: 有効なAmazon リソースネーム (ARN)
  # 省略時: AWSが自動的に生成したARNを使用
  # 注意: 通常は省略し、AWSが自動生成する値を使用します
  arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # スループット設定
  #-------------------------------------------------------------

  # shard_count (Optional)
  # 設定内容: プロビジョニングモード時のシャード数を指定します。
  # 設定可能な値: 1以上の整数
  # 省略時: stream_mode_details で ON_DEMAND を指定する場合は省略可能
  # 注意: stream_mode_details を指定しない場合（PROVISIONED モード）は必須です。
  #       ON_DEMAND モードでは指定不要です。
  #       各シャードは最大1MB/秒の書き込み、2MB/秒の読み込みをサポートします。
  shard_count = 1

  # max_record_size_in_kib (Optional, Computed)
  # 設定内容: ストリームに書き込む1レコードの最大サイズをKiB単位で指定します。
  # 設定可能な値: 1〜1024 (KiB)
  # 省略時: AWSのデフォルト値（1024 KiB = 1 MiB）を使用
  # 注意: この値を変更するとストリームの更新が行われます
  max_record_size_in_kib = 1024

  #-------------------------------------------------------------
  # データ保持設定
  #-------------------------------------------------------------

  # retention_period (Optional)
  # 設定内容: ストリームにデータを保持する時間数を指定します。
  # 設定可能な値: 24〜8760（時間）
  #   - 24: 最小（デフォルト）
  #   - 168: 7日間
  #   - 8760: 365日間（最大）
  # 省略時: 24（24時間）
  # 注意: 保持期間を延長すると追加のコストが発生します
  retention_period = 24

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_type (Optional)
  # 設定内容: ストリームの暗号化タイプを指定します。
  # 設定可能な値:
  #   - "NONE": 暗号化なし
  #   - "KMS": AWS Key Management Service (KMS) を使用した暗号化
  # 省略時: "NONE"（暗号化なし）
  # 注意: "KMS" を指定する場合は kms_key_id の設定が必要です
  encryption_type = "NONE"

  # kms_key_id (Optional)
  # 設定内容: ストリームの暗号化に使用するKMSキーのIDまたはARNを指定します。
  # 設定可能な値: KMSキーのID、ARN、またはエイリアス名
  #   - "alias/aws/kinesis": AWSマネージドKMSキー（Kinesisサービス用）
  #   - "arn:aws:kms:...": カスタマー管理のKMSキーARN
  # 省略時: null（encryption_type が "NONE" の場合）
  # 注意: encryption_type が "KMS" の場合に必須です
  kms_key_id = null

  #-------------------------------------------------------------
  # シャードレベルメトリクス設定
  #-------------------------------------------------------------

  # shard_level_metrics (Optional)
  # 設定内容: 有効化するシャードレベルのCloudWatchメトリクスの一覧を指定します。
  # 設定可能な値（セット形式で複数指定可能）:
  #   - "IncomingBytes": シャードへの書き込みバイト数
  #   - "IncomingRecords": シャードへの書き込みレコード数
  #   - "OutgoingBytes": シャードからの読み取りバイト数
  #   - "OutgoingRecords": シャードからの読み取りレコード数
  #   - "WriteProvisionedThroughputExceeded": 書き込みスループット超過の回数
  #   - "ReadProvisionedThroughputExceeded": 読み取りスループット超過の回数
  #   - "IteratorAgeMilliseconds": レコードの反復処理の遅延（ミリ秒）
  # 省略時: シャードレベルメトリクスは無効（ストリームレベルのメトリクスのみ有効）
  # 注意: シャードレベルメトリクスを有効化すると追加のCloudWatchコストが発生します
  shard_level_metrics = []

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-stream"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # ストリームモード設定
  #-------------------------------------------------------------

  # stream_mode_details (Optional)
  # 設定内容: ストリームのスループットモードを指定するブロックです。
  # 注意: このブロックを省略するとデフォルトで PROVISIONED モードになります。
  #       PROVISIONED モードを使用する場合は shard_count の指定が必要です。
  # 参考: https://docs.aws.amazon.com/streams/latest/dev/how-do-i-size-a-stream.html
  stream_mode_details {
    # stream_mode (Required)
    # 設定内容: ストリームのスループットモードを指定します。
    # 設定可能な値:
    #   - "PROVISIONED": シャード数を手動でプロビジョニングするモード
    #                    shard_count の指定が必要
    #   - "ON_DEMAND": 自動スケーリングモード
    #                  shard_count の指定は不要
    #                  トラフィックに応じて自動的にスケールアップ/ダウン
    stream_mode = "PROVISIONED"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: ストリームの作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Goの時間パース形式（例: "5m", "1h"）
    # 省略時: Terraformのデフォルトタイムアウトを使用
    create = "5m"

    # update (Optional)
    # 設定内容: ストリームの更新操作のタイムアウト時間を指定します。
    # 設定可能な値: Goの時間パース形式（例: "5m", "1h"）
    # 省略時: Terraformのデフォルトタイムアウトを使用
    update = "120m"

    # delete (Optional)
    # 設定内容: ストリームの削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Goの時間パース形式（例: "5m", "1h"）
    # 省略時: Terraformのデフォルトタイムアウトを使用
    delete = "120m"
  }

  #-------------------------------------------------------------
  # コンシューマー削除設定
  #-------------------------------------------------------------

  # enforce_consumer_deletion (Optional)
  # 設定内容: ストリームにアクティブなコンシューマーが存在する場合に、
  #          強制的にコンシューマーを削除してからストリームを削除するかどうかを指定します。
  # 設定可能な値: true, false
  #   - true: コンシューマーを強制削除してからストリームを削除
  #   - false: コンシューマーが存在する場合はエラーで削除を中止
  # 省略時: false
  # 注意: 本番環境ではデータ損失を防ぐため、false を推奨します
  enforce_consumer_deletion = false
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ストリームを識別するARN
#
# - id: ストリームの名前
#
# - name: ストリームの名前
#
# - region: ストリームが存在するリージョン
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
