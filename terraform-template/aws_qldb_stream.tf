#---------------------------------------------------------------
# AWS QLDB Journal Stream (QLDB Kinesis ストリーム)
#---------------------------------------------------------------
#
# Amazon QLDB のジャーナルストリームをプロビジョニングするリソースです。
# レジャーのジャーナルにコミットされたすべてのドキュメントリビジョンをキャプチャし、
# Amazon Kinesis Data Streams にリアルタイムで配信します。
# QLDBストリームは、レジャーのジャーナルから Kinesis データストリームリソースへの
# 継続的なデータフローです。
#
# AWS公式ドキュメント:
#   - QLDB Streamsの概要: https://docs.aws.amazon.com/streams/latest/dev/using-other-services-quantum-ledger.html
#   - Amazon QLDB エンドポイントとクォータ: https://docs.aws.amazon.com/general/latest/gr/qldb.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/qldb_stream
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_qldb_stream" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # ledger_name (Required)
  # 設定内容: ジャーナルストリームを作成する対象のQLDBレジャー名を指定します。
  # 設定可能な値: 既存のQLDBレジャー名（1-32文字、英数字とハイフンが使用可能）
  ledger_name = "existing-ledger-name"

  # stream_name (Required)
  # 設定内容: QLDBジャーナルストリームに割り当てる名前を指定します。
  # 設定可能な値: レジャー内のアクティブなストリーム間で一意の名前。
  #   命名規則はレジャー名と同一（英数字、ハイフン等）
  # 注意: 同一レジャーの他のアクティブストリーム間で一意である必要があります。
  # 参考: https://docs.aws.amazon.com/qldb/latest/developerguide/limits.html#limits.naming
  stream_name = "sample-ledger-stream"

  # role_arn (Required)
  # 設定内容: QLDBがジャーナルストリームのデータレコードをKinesis Data Streamsに
  #   書き込むための権限を付与するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  role_arn = "arn:aws:iam::123456789012:role/qldb-kinesis-stream-role"

  #-------------------------------------------------------------
  # ストリーム期間設定
  #-------------------------------------------------------------

  # inclusive_start_time (Required)
  # 設定内容: ジャーナルデータのストリーミングを開始する日時（含む）を指定します。
  # 設定可能な値: ISO 8601形式のUTC日時文字列（例: "2021-01-01T00:00:00Z"）
  # 注意: 未来の日時は指定できません。また exclusive_end_time より前である必要があります。
  #   レジャーの CreationDateTime より前の値を指定した場合、QLDB は自動的に
  #   レジャーの CreationDateTime を使用します。
  inclusive_start_time = "2021-01-01T00:00:00Z"

  # exclusive_end_time (Optional)
  # 設定内容: ストリームが終了する日時（含まない）を指定します。
  # 設定可能な値: ISO 8601形式のUTC日時文字列（例: "2024-12-31T23:59:59Z"）
  # 省略時: ストリームはキャンセルされるまで無期限に実行されます。
  exclusive_end_time = null

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
  # Kinesis設定
  #-------------------------------------------------------------

  # kinesis_configuration (Required)
  # 設定内容: ストリームリクエストの送信先となるKinesis Data Streamsの設定ブロックです。
  # 関連機能: Amazon Kinesis Data Streams 連携
  #   QLDBジャーナルのデータをKinesisストリームにリアルタイム配信します。
  #   配信されるレコードタイプ: control、block summary、revision details
  #   - https://docs.aws.amazon.com/streams/latest/dev/using-other-services-quantum-ledger.html
  kinesis_configuration {

    # stream_arn (Required)
    # 設定内容: データの送信先となるKinesis Data StreamsリソースのARNを指定します。
    # 設定可能な値: 有効なKinesis Data StreamsリソースARN
    stream_arn = "arn:aws:kinesis:ap-northeast-1:123456789012:stream/example-kinesis-stream"

    # aggregation_enabled (Optional)
    # 設定内容: QLDBが複数のデータレコードを1つのKinesis Data Streamsレコードにまとめて
    #   送信するアグリゲーション機能を有効にするかどうかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): アグリゲーションを有効化。APIコールあたりのレコード送信数が増加します
    #   - false: アグリゲーションを無効化。Kinesis Consumer Library未使用の場合に推奨
    # 省略時: true
    aggregation_enabled = false
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-qldb-stream"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: QLDBストリームのID
# - arn: QLDBストリームのAmazon Resource Name (ARN)
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
