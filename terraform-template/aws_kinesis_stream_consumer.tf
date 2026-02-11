#---------------------------------------------------------------
# Amazon Kinesis Stream Consumer
#---------------------------------------------------------------
#
# Kinesis Data Streamsのストリームコンシューマーを作成します。
# コンシューマーは拡張ファンアウト（Enhanced Fan-Out）機能を使用し、
# 専有スループット（最大2MB/秒/シャード）でストリームからデータを受信します。
# 1つのストリームに最大20個のコンシューマーを登録できます。
#
# AWS公式ドキュメント:
#   - Enhanced Fan-Out Consumers: https://docs.aws.amazon.com/streams/latest/dev/enhanced-consumers.html
#   - Building Enhanced Fan-Out Consumers: https://docs.aws.amazon.com/streams/latest/dev/building-enhanced-consumers-api.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream_consumer
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kinesis_stream_consumer" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # ストリームコンシューマーの名前
  # - 1つのストリーム内で一意である必要があります
  # - 変更するとリソースが再作成されます（Forces new resource）
  # - 例: "example-consumer", "analytics-consumer"
  name = "example-consumer"

  # コンシューマーが登録されるKinesis Data StreamのARN
  # - 変更するとリソースが再作成されます（Forces new resource）
  # - 例: "arn:aws:kinesis:us-east-1:123456789012:stream/example-stream"
  # - aws_kinesis_stream.example.arn のように参照することが推奨されます
  stream_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/example-stream"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # リソースを管理するAWSリージョン
  # - 指定しない場合、プロバイダー設定のリージョンが使用されます
  # - リージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  # リソースに付与するタグ
  # - Key-Valueペアのマップ形式で指定します
  # - コスト配分タグやリソース管理に使用できます
  # - 例: { Environment = "production", Application = "analytics" }
  # tags = {
  #   Environment = "production"
  #   Application = "analytics"
  # }

  # プロバイダーとTerraformが自動的に設定するタグを含む全てのタグ
  # - default_tagsで設定されたタグとtagsで設定されたタグの両方を含みます
  # - 通常は明示的に設定する必要はありません
  # - 計算される値（computed）ですが、必要に応じて上書き可能です
  # tags_all = {}

  # リソース識別子（ID）
  # - 指定しない場合、ストリームコンシューマーのARNが自動的に割り当てられます
  # - 通常は明示的に設定する必要はありません
  # - 計算される値（computed）ですが、カスタムIDが必要な場合は指定可能です
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（読み取り専用）:
#
# - arn
#   ストリームコンシューマーのAmazon Resource Name (ARN)
#   例: "arn:aws:kinesis:us-east-1:123456789012:stream/example-stream/consumer/example-consumer:1234567890"
#
# - creation_timestamp
#   ストリームコンシューマーが作成された日時（RFC3339形式）
#   例: "2024-01-28T12:34:56Z"
#
# - id
#   ストリームコンシューマーのAmazon Resource Name (ARN)
#   arnと同じ値が設定されます
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# resource "aws_kinesis_stream" "example" {
#   name        = "example-stream"
#   shard_count = 1
#
#   tags = {
#     Environment = "production"
#   }
# }
#
# resource "aws_kinesis_stream_consumer" "example" {
#   name       = "example-consumer"
#   stream_arn = aws_kinesis_stream.example.arn
#
#   tags = {
#     Environment = "production"
#     Application = "analytics"
#   }
# }
#
# # コンシューマーのARNを出力
# output "consumer_arn" {
#   value = aws_kinesis_stream_consumer.example.arn
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
# 1. コンシューマー数の制限
#    - 1つのストリームに最大20個のコンシューマーを登録できます
#    - On-demand Advantageモードでは最大50個のコンシューマーをサポートします
#
# 2. 拡張ファンアウト（Enhanced Fan-Out）
#    - 各コンシューマーは専有スループット（最大2MB/秒/シャード）を受け取ります
#    - HTTP/2経由でKinesis Data Streamsがレコードをプッシュします
#    - 平均メッセージ伝播遅延は約70msです
#
# 3. コスト
#    - 拡張ファンアウトにはデータ取得コストとコンシューマー・シャード時間コストが発生します
#    - 通常の共有スループットコンシューマーと比較してコストが高くなります
#
# 4. リソースの再作成
#    - nameまたはstream_arnを変更するとリソースが再作成されます
#    - 既存のコンシューマーアプリケーションへの影響を考慮してください
#
# 5. 登録解除
#    - リソースを削除すると、コンシューマーは自動的に登録解除されます
#    - アプリケーション側でSubscribeToShardの購読を適切に終了してください
#---------------------------------------------------------------
