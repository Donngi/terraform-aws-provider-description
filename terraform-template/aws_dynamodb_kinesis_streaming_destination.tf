#---------------------------------------------------------------
# AWS DynamoDB Kinesis Streaming Destination
#---------------------------------------------------------------
#
# DynamoDB テーブルの変更データを Kinesis Data Streams にリアルタイムで
# レプリケートする機能を有効化するリソースです。
# DynamoDB Streams の代替として、より長いデータ保持期間と複数のコンシューマー
# への同時配信（ファンアウト）が必要な場合に使用します。
#
# 主な特徴:
#   - リアルタイムでのアイテムレベルの変更データキャプチャ
#   - Kinesis Data Streams の長期データ保持（最大365日）
#   - 複数のコンシューマーへの同時配信が可能
#   - Amazon Data Firehose や Apache Flink との統合
#   - テーブルパフォーマンスへの影響なし
#
# AWS公式ドキュメント:
#   - DynamoDB Kinesis Streaming: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/kds.html
#   - EnableKinesisStreamingDestination API: https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_EnableKinesisStreamingDestination.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_kinesis_streaming_destination
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dynamodb_kinesis_streaming_destination" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # table_name (Required)
  # 設定内容: Kinesis ストリーミングを有効化する DynamoDB テーブルの名前を指定します。
  # 設定可能な値: 既存の DynamoDB テーブル名
  # 注意: 1つの DynamoDB テーブルにつき1つの Kinesis ストリーミング先のみ設定可能
  # 関連機能: DynamoDB Kinesis Data Streams 統合
  #   テーブルのアイテムレベルの変更をキャプチャしてストリームに送信。
  #   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/kds.html
  table_name = "example-table"

  # stream_arn (Required)
  # 設定内容: 変更データを送信する先の Kinesis Data Stream の ARN を指定します。
  # 設定可能な値: 有効な Kinesis Data Stream の ARN
  # 注意: DynamoDB テーブルと同じ AWS アカウント・リージョンに存在する必要があります
  # 関連機能: Kinesis Data Streams
  #   リアルタイムデータストリーミングサービス。複数のコンシューマーへのファンアウトをサポート。
  #   - https://docs.aws.amazon.com/streams/latest/dev/introduction.html
  stream_arn = "arn:aws:kinesis:ap-northeast-1:123456789012:stream/example-stream"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # approximate_creation_date_time_precision (Optional, Computed)
  # 設定内容: Kinesis データストリームのタイムスタンプ精度を指定します。
  # 設定可能な値:
  #   - "MILLISECOND": ミリ秒精度 (デフォルト)
  #   - "MICROSECOND": マイクロ秒精度
  # 省略時: MILLISECOND
  # 用途: ApproximateCreationDateTime 属性の精度を制御
  # 関連機能: DynamoDB 変更データキャプチャのタイムスタンプ
  #   アイテムの作成・更新・削除の時刻を高精度で記録可能。
  #   順序の特定や重複排除に使用できます。
  #   - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/kds.html
  approximate_creation_date_time_precision = "MICROSECOND"

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: リソースの識別子
  # 形式: table_name と stream_arn をカンマ (,) で区切った文字列
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  id = null
}

#---------------------------------------------------------------
#
# resource "aws_dynamodb_table" "example" {
#   name     = "orders"
#   hash_key = "id"
#
#   attribute {
#     name = "id"
#     type = "S"
#   }
#
#   billing_mode = "PAY_PER_REQUEST"
# }
#
# resource "aws_kinesis_stream" "example" {
#   name        = "order_item_changes"
#   shard_count = 1
# }
#
# resource "aws_dynamodb_kinesis_streaming_destination" "example" {
#   stream_arn                               = aws_kinesis_stream.example.arn
#   table_name                               = aws_dynamodb_table.example.name
#   approximate_creation_date_time_precision = "MICROSECOND"
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: table_name と stream_arn をカンマ (,) で区切った文字列
#   例: "orders,arn:aws:kinesis:ap-northeast-1:123456789012:stream/order_item_changes"
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のリソースは以下の形式でインポートできます:
#
# terraform import aws_dynamodb_kinesis_streaming_destination.example table_name,stream_arn
#
# 例:
# terraform import aws_dynamodb_kinesis_streaming_destination.example orders,arn:aws:kinesis:ap-northeast-1:123456789012:stream/order_item_changes
#---------------------------------------------------------------
