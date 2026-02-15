#---------------------------------------
# CloudFront リアルタイムログ設定
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-12
#
# CloudFrontディストリビューションへのビューワーリクエストに関するリアルタイムログを設定します。
# ログデータはKinesis Data Streamsエンドポイントに配信され、リアルタイム分析やモニタリングに使用できます。
#
# 主な用途:
# - ビューワーリクエストのリアルタイム監視とアラート
# - セキュリティ分析やトラフィック異常の即座の検知
# - パフォーマンス最適化のためのライブメトリクス収集
# - A/Bテストやカナリアデプロイのモニタリング
#
# NOTE:
# - リアルタイムログには追加料金が発生します（Kinesis Data Streams利用料含む）
# - サンプリングレートを調整してコストとデータ量のバランスを最適化できます
# - CloudFrontがKinesisストリームに書き込むためのIAMロールが必要です
# - 標準ログ（アクセスログ）との併用が可能です
#
# 関連ドキュメント:
# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/real-time-logs.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_realtime_log_config

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_cloudfront_realtime_log_config" "example" {
  # リアルタイムログ設定の識別名
  # 設定内容: リアルタイムログ設定を識別するための一意の名前
  # 制約: AWS アカウント内で一意である必要があります
  # 用途: CloudFrontディストリビューションでこの設定を参照する際に使用
  name = "cloudfront-realtime-logs"

  # サンプリングレート（1〜100の整数）
  # 設定内容: リアルタイムログデータに含まれるビューワーリクエストの割合（パーセンテージ）
  # 設定可能な値: 1〜100の整数値
  # - 100: すべてのリクエストをログに記録（最も詳細だがコストも最大）
  # - 75: リクエストの75%をサンプリング（バランスの取れた設定）
  # - 50: リクエストの50%をサンプリング
  # - 1: リクエストの1%のみサンプリング（コスト最小化）
  # 推奨設定: 本番環境では10〜50程度から開始し、必要に応じて調整
  sampling_rate = 75

  # ログレコードに含めるフィールド
  # 設定内容: 各リアルタイムログレコードに含める情報フィールドのリスト
  # 設定可能な値: 以下のフィールドから必要なものを選択
  # - timestamp: リクエストのタイムスタンプ
  # - c-ip: クライアントのIPアドレス
  # - time-to-first-byte: 最初のバイトまでの時間
  # - sc-status: HTTPステータスコード
  # - sc-bytes: レスポンスのバイト数
  # - cs-method: HTTPメソッド（GET、POST等）
  # - cs-protocol: クライアントからのプロトコル（HTTP/1.1、HTTP/2等）
  # - cs-uri-stem: URIパス
  # - cs-uri-query: クエリ文字列
  # - cs-host: Hostヘッダー値
  # - cs-user-agent: User-Agentヘッダー値
  # - cs-referer: Refererヘッダー値
  # - cs-cookie: Cookieヘッダー値
  # - x-edge-location: エッジロケーション
  # - x-edge-request-id: リクエストID
  # - x-host-header: オリジンに転送されたHostヘッダー
  # - time-taken: リクエスト処理時間（秒）
  # - cs-protocol-version: クライアントプロトコルバージョン
  # - c-ip-version: IPバージョン（IPv4またはIPv6）
  # - cs-headers: リクエストヘッダー
  # - c-country: クライアントの国コード
  # - cs-accept-encoding: Accept-Encodingヘッダー
  # - cs-accept: Acceptヘッダー
  # - cache-behavior-path-pattern: マッチしたキャッシュビヘイビアのパスパターン
  # - x-edge-response-result-type: レスポンス結果タイプ（Hit、Miss、Error等）
  # - x-edge-result-type: リクエスト処理結果タイプ
  # - sc-content-type: Content-Typeヘッダー
  # - sc-content-len: Content-Lengthヘッダー
  # - sc-range-start: Rangeリクエストの開始バイト
  # - sc-range-end: Rangeリクエストの終了バイト
  # - asn: クライアントの自律システム番号
  # - ssl-protocol: SSL/TLSプロトコルバージョン
  # - ssl-cipher: SSL/TLS暗号スイート
  # 推奨設定: 最低限として timestamp、c-ip、sc-status、cs-uri-stem を含める
  fields = [
    "timestamp",
    "c-ip",
    "time-to-first-byte",
    "sc-status",
    "sc-bytes",
    "cs-method",
    "cs-protocol",
    "cs-uri-stem",
    "cs-uri-query",
    "cs-host",
    "x-edge-location",
    "x-edge-request-id",
    "x-edge-response-result-type",
    "time-taken"
  ]

  #---------------------------------------
  # ログ配信エンドポイント設定
  #---------------------------------------

  endpoint {
    # ストリームタイプ
    # 設定内容: リアルタイムログデータの送信先ストリームのタイプ
    # 設定可能な値: "Kinesis"（現在サポートされている唯一の値）
    # 注意: 将来的に他のストリームタイプがサポートされる可能性があります
    stream_type = "Kinesis"

    # Kinesis Data Streams設定
    kinesis_stream_config {
      # IAMロールARN
      # 設定内容: CloudFrontがKinesis Data Streamsにログデータを書き込む際に使用するIAMロールのARN
      # 必要な権限:
      # - kinesis:DescribeStreamSummary
      # - kinesis:DescribeStream
      # - kinesis:PutRecord
      # - kinesis:PutRecords
      # 信頼ポリシー: cloudfront.amazonaws.com サービスプリンシパルを許可する必要があります
      # 例: arn:aws:iam::123456789012:role/cloudfront-realtime-logs-role
      role_arn = "arn:aws:iam::123456789012:role/cloudfront-realtime-logs-role"

      # Kinesis Data Stream ARN
      # 設定内容: ログデータの配信先となるKinesis Data StreamのARN
      # 注意事項:
      # - ストリームは事前に作成されている必要があります
      # - シャード数は予想されるログボリュームに応じて適切に設定してください
      # - CloudFrontディストリビューションとKinesisストリームは同じAWSアカウントである必要があります
      # シャード数の目安:
      # - 小規模（〜1000 RPS）: 1〜2シャード
      # - 中規模（1000〜10000 RPS）: 3〜10シャード
      # - 大規模（10000+ RPS）: 10+シャード
      # 例: arn:aws:kinesis:us-east-1:123456789012:stream/cloudfront-realtime-logs
      stream_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/cloudfront-realtime-logs"
    }
  }

  # 依存関係の明示
  # CloudFrontがKinesisストリームへのアクセス権限を持つまで待機
  # depends_on = [aws_iam_role_policy.cloudfront_realtime_logs]
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースの作成後に参照可能な属性:
#
# - id: リアルタイムログ設定のID（nameと同じ値）
# - arn: リアルタイムログ設定のARN
#       形式: arn:aws:cloudfront::123456789012:realtime-log-config/設定名
#       用途: IAMポリシーやCloudFormationスタックでの参照
#
# 参照例:
# output "log_config_arn" {
#   value = aws_cloudfront_realtime_log_config.example.arn
# }
