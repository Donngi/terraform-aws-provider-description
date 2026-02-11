# ==============================================================================
# Terraform AWS Provider Resource Template
# ==============================================================================
# Resource: aws_cloudfront_realtime_log_config
# Provider Version: 6.28.0
# Generated: 2026-01-18
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-18)の情報に基づいています
# - 最新の仕様や詳細については、必ず公式ドキュメントを確認してください
# - AWS Provider公式ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
# ==============================================================================

# CloudFront リアルタイムログ設定
# CloudFrontディストリビューションへのリクエストに関するリアルタイムログデータを
# Amazon Kinesis Data Streamsに送信するための設定を提供します
#
# AWS公式ドキュメント: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/real-time-logs.html
# Terraform公式ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_realtime_log_config

resource "aws_cloudfront_realtime_log_config" "example" {
  # ============================================================================
  # 必須パラメータ
  # ============================================================================

  # リアルタイムログ設定を識別するための一意の名前
  # この名前はAWSアカウント内で一意である必要があります
  # 参考: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_CreateRealtimeLogConfig.html
  name = "example-realtime-log-config"

  # リアルタイムログに含めるフィールドのリスト
  # ビューアリクエストに関する各種情報（タイムスタンプ、IPアドレス、ステータスコードなど）を指定します
  # サポートされているフィールドの一覧:
  # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/real-time-logs.html#understand-real-time-log-config-fields
  #
  # 主なフィールド例:
  # - timestamp: リクエストのタイムスタンプ
  # - c-ip: クライアントのIPアドレス
  # - cs-method: HTTPメソッド (GET, POST等)
  # - cs-uri-stem: リクエストされたURIパス
  # - sc-status: レスポンスステータスコード
  # - sc-bytes: レスポンスサイズ（バイト）
  # - time-taken: リクエスト処理時間（秒）
  # - x-edge-location: エッジロケーション
  # - x-edge-result-type: キャッシュヒット/ミスの結果
  fields = [
    "timestamp",
    "c-ip",
    "cs-method",
    "cs-uri-stem",
    "sc-status",
    "sc-bytes",
    "time-taken",
    "x-edge-location",
    "x-edge-result-type"
  ]

  # サンプリングレート（1～100の整数）
  # ビューアリクエストの何パーセントをリアルタイムログデータに含めるかを決定します
  # 例: 75 の場合、75%のリクエストがログに記録されます
  # 高いサンプリングレートはより詳細なログを提供しますが、Kinesis Data Streamsの
  # コストとデータ処理負荷が増加します
  # 参考: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_CreateRealtimeLogConfig.html
  sampling_rate = 75

  # ============================================================================
  # オプションパラメータ
  # ============================================================================

  # リソースID（通常は自動生成されるため、明示的に指定する必要はありません）
  # 特定のIDを使用したい場合のみ指定します
  # id = "custom-id"

  # ============================================================================
  # ネストブロック: endpoint
  # ============================================================================

  # リアルタイムログデータの送信先となるAmazon Kinesis Data Streamsの設定
  # 必須ブロック: 1つのみ指定可能
  # 参考: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/real-time-logs.html
  endpoint {
    # データストリームのタイプ（現在は "Kinesis" のみサポート）
    # 必須項目
    stream_type = "Kinesis"

    # ----------------------------------------------------------------------------
    # ネストブロック: kinesis_stream_config
    # ----------------------------------------------------------------------------

    # Amazon Kinesis Data Streamの設定
    # 必須ブロック: 1つのみ指定可能
    kinesis_stream_config {
      # CloudFrontがKinesis Data Streamにリアルタイムログデータを送信するために使用するIAMロールのARN
      # このロールには以下の権限が必要です:
      # - kinesis:DescribeStreamSummary
      # - kinesis:DescribeStream
      # - kinesis:PutRecord
      # - kinesis:PutRecords
      #
      # IAMロールの設定詳細:
      # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/real-time-logs.html#understand-real-time-log-config-iam-role
      #
      # 必須項目
      role_arn = "arn:aws:iam::123456789012:role/cloudfront-realtime-log-role"

      # リアルタイムログデータの送信先となるKinesis Data StreamのARN
      # ストリームは事前に作成しておく必要があります
      # 必須項目
      # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream
      stream_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/cloudfront-realtime-logs"
    }
  }
}

# ==============================================================================
# 出力値（Computed Attributes）
# ==============================================================================
# 以下の属性は自動的に計算され、他のリソースで参照可能です:
#
# - id: CloudFrontリアルタイムログ設定のID
#   例: aws_cloudfront_realtime_log_config.example.id
#
# - arn: CloudFrontリアルタイムログ設定のARN（Amazon Resource Name）
#   例: aws_cloudfront_realtime_log_config.example.arn
#   形式: arn:aws:cloudfront::123456789012:realtime-log-config/EXAMPLE1234567890
#
# ==============================================================================

# ==============================================================================
# 使用例: IAMロールとKinesis Streamとの連携
# ==============================================================================
#
# # CloudFront用のIAMロール（AssumeRole設定）
# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"
#
#     principals {
#       type        = "Service"
#       identifiers = ["cloudfront.amazonaws.com"]
#     }
#
#     actions = ["sts:AssumeRole"]
#   }
# }
#
# resource "aws_iam_role" "cloudfront_realtime_log" {
#   name               = "cloudfront-realtime-log-role"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }
#
# # CloudFrontがKinesisにログを書き込むための権限
# data "aws_iam_policy_document" "cloudfront_kinesis_policy" {
#   statement {
#     effect = "Allow"
#
#     actions = [
#       "kinesis:DescribeStreamSummary",
#       "kinesis:DescribeStream",
#       "kinesis:PutRecord",
#       "kinesis:PutRecords",
#     ]
#
#     resources = [aws_kinesis_stream.realtime_logs.arn]
#   }
# }
#
# resource "aws_iam_role_policy" "cloudfront_kinesis" {
#   name   = "cloudfront-kinesis-policy"
#   role   = aws_iam_role.cloudfront_realtime_log.id
#   policy = data.aws_iam_policy_document.cloudfront_kinesis_policy.json
# }
#
# # Kinesis Data Stream
# resource "aws_kinesis_stream" "realtime_logs" {
#   name             = "cloudfront-realtime-logs"
#   shard_count      = 1
#   retention_period = 24
# }
#
# # depends_onを使用してIAMポリシーが適用されてからリアルタイムログ設定を作成
# resource "aws_cloudfront_realtime_log_config" "example" {
#   # ... 上記の設定 ...
#
#   depends_on = [aws_iam_role_policy.cloudfront_kinesis]
# }
#
# ==============================================================================
