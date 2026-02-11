# ================================================================================
# Terraform Template: aws_cloudwatch_metric_stream
# ================================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意:
# - このテンプレートは生成時点のAWS Provider仕様に基づいています
# - 最新の仕様については公式ドキュメントを確認してください
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_stream
# ================================================================================

# CloudWatch Metric Streamリソース
# CloudWatchメトリクスを継続的にストリーミングして、ほぼリアルタイムで
# Kinesis Data Firehoseに配信するためのリソースです。
# 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Metric-Streams.html
resource "aws_cloudwatch_metric_stream" "example" {
  # ================================================================================
  # 必須パラメータ (Required)
  # ================================================================================

  # Amazon Kinesis Data Firehose配信ストリームのARN (必須)
  # このメトリクスストリームで使用するFirehose配信ストリームを指定します。
  # メトリクスデータはこのFirehoseストリームを通じて最終的な宛先(S3、サードパーティなど)に配信されます。
  # 例: "arn:aws:firehose:us-east-1:123456789012:deliverystream/my-metric-stream"
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_PutMetricStream.html
  firehose_arn = "arn:aws:firehose:us-east-1:123456789012:deliverystream/example-stream"

  # IAMロールのARN (必須)
  # メトリクスストリームがKinesis Firehoseリソースにアクセスするために使用するIAMロールのARN。
  # CloudWatchとKinesis Data Firehose間の信頼関係を確立する必要があります。
  # 必要な権限: firehose:PutRecord, firehose:PutRecordBatch
  # 例: "arn:aws:iam::123456789012:role/CloudWatchMetricStreamRole"
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-metric-streams-trustpolicy.html
  role_arn = "arn:aws:iam::123456789012:role/example-metric-stream-role"

  # 出力フォーマット (必須)
  # ストリームの出力フォーマットを指定します。
  # 指定可能な値:
  #   - "json": JSON形式 (AWS GlueやAmazon Athenaと互換性あり)
  #   - "opentelemetry0.7": OpenTelemetry 0.7.0形式
  #   - "opentelemetry1.0": OpenTelemetry 1.0.0形式
  # 注: フォーマットはいつでも編集可能です。
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-metric-streams-formats.html
  output_format = "json"

  # ================================================================================
  # オプションパラメータ (Optional)
  # ================================================================================

  # メトリクスストリームの名前 (オプション、リソース再作成が必要)
  # メトリクスストリームのわかりやすい名前。
  # 省略した場合、Terraformがランダムで一意な名前を割り当てます。
  # name_prefixとの併用は不可。
  # 最小長: 1文字、最大長: 255文字
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_PutMetricStream.html
  name = "example-metric-stream"

  # 名前のプレフィックス (オプション、リソース再作成が必要)
  # 指定されたプレフィックスで始まる一意な名前を作成します。
  # nameとの併用は不可。
  # 例: "prod-metrics-" → "prod-metrics-20240101123456"
  # name_prefix = "example-"

  # リンクされたアカウントのメトリクスを含める (オプション)
  # モニタリングアカウントがリンクされたソースアカウントからのメトリクスを
  # 含めるかどうかを指定します。
  # true: リンクアカウントのメトリクスも含める
  # false: 現在のアカウントのメトリクスのみ
  # デフォルト: false
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_PutMetricStream.html
  # include_linked_accounts_metrics = false

  # リージョン (オプション)
  # このリソースが管理されるAWSリージョン。
  # 省略した場合、プロバイダー設定で指定されたリージョンがデフォルトとして使用されます。
  # 例: "us-east-1", "ap-northeast-1"
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # タグ (オプション)
  # リソースに割り当てるタグのマップ。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたタグを上書きします。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # ================================================================================
  # ネストブロック: exclude_filter (オプション)
  # ================================================================================
  # 除外メトリクスフィルターのリスト
  # このパラメータを指定すると、ここで指定したメトリクス名前空間と
  # 条件付きメトリクス名を除く全てのメトリクス名前空間からメトリクスが送信されます。
  # メトリクス名を指定しないか空のメトリクス名を提供すると、
  # メトリクス名前空間全体が除外されます。
  # include_filterとの併用は不可。
  # 注: 最大1000個のフィルターを指定可能
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Metric-Streams.html

  # exclude_filter {
  #   # メトリクス名前空間 (必須)
  #   # フィルター内のメトリクス名前空間の名前
  #   # 例: "AWS/EC2", "AWS/Lambda", "AWS/RDS"
  #   namespace = "AWS/EC2"
  #
  #   # メトリクス名の配列 (オプション)
  #   # このメトリクス名前空間で除外するメトリクスを定義する配列
  #   # 空の配列または省略した場合、名前空間全体が除外されます
  #   # 例: ["CPUUtilization", "NetworkIn"]
  #   metric_names = []
  # }

  # ================================================================================
  # ネストブロック: include_filter (オプション)
  # ================================================================================
  # 包含メトリクスフィルターのリスト
  # このパラメータを指定すると、ここで指定したメトリクス名前空間の
  # 条件付きメトリクス名のみが送信されます。
  # メトリクス名を指定しないか空のメトリクス名を提供すると、
  # メトリクス名前空間全体が含まれます。
  # exclude_filterとの併用は不可。
  # 注: 最大1000個のフィルターを指定可能
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Metric-Streams.html

  include_filter {
    # メトリクス名前空間 (必須)
    # フィルター内のメトリクス名前空間の名前
    # 例: "AWS/EC2", "AWS/Lambda", "AWS/S3"
    namespace = "AWS/EC2"

    # メトリクス名の配列 (オプション)
    # このメトリクス名前空間で含めるメトリクスを定義する配列
    # 空の配列または省略した場合、名前空間全体が含まれます
    # 例: ["CPUUtilization", "NetworkOut"]
    metric_names = ["CPUUtilization", "NetworkOut"]
  }

  include_filter {
    namespace    = "AWS/EBS"
    metric_names = [] # 空の場合、EBS名前空間の全メトリクスが含まれる
  }

  # ================================================================================
  # ネストブロック: statistics_configuration (オプション)
  # ================================================================================
  # 追加統計の設定
  # この配列の各エントリで、1つ以上のメトリクスと、それらのメトリクスに対して
  # ストリーミングする追加統計のリストを指定します。
  # ストリーミングできる追加統計は、ストリームのoutput_formatに依存します:
  #   - json: CloudWatchがサポートする任意の追加統計 (p1, p99, tm99など)
  #   - opentelemetry0.7 または opentelemetry1.0: パーセンタイル統計 (p99など)
  # 注: 追加統計のストリーミングには追加コストが発生します
  # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Statistics-definitions.html

  # statistics_configuration {
  #   # 追加統計のリスト (必須)
  #   # include_metricsにリストされたメトリクスに対してストリーミングする追加統計
  #   # 例: ["p1", "p99", "tm99", "TS(50.5:)"]
  #   additional_statistics = ["p1", "tm99"]
  #
  #   # 追加統計をストリーミングするメトリクス (必須、最小1個)
  #   # 追加統計をストリーミングするメトリクスを定義する配列
  #   include_metric {
  #     # メトリクス名 (必須)
  #     # メトリクスの名前
  #     # 例: "CPUUtilization", "NetworkIn"
  #     metric_name = "CPUUtilization"
  #
  #     # メトリクスの名前空間 (必須)
  #     # メトリクスの名前空間
  #     # 例: "AWS/EC2", "AWS/Lambda"
  #     namespace = "AWS/EC2"
  #   }
  # }

  # ================================================================================
  # ネストブロック: timeouts (オプション)
  # ================================================================================
  # タイムアウト設定
  # リソースの作成、更新、削除操作のタイムアウトをカスタマイズします

  # timeouts {
  #   # 作成タイムアウト (オプション)
  #   # リソース作成操作のタイムアウト時間
  #   # 例: "10m", "1h"
  #   create = "1m"
  #
  #   # 更新タイムアウト (オプション)
  #   # リソース更新操作のタイムアウト時間
  #   # 例: "10m", "1h"
  #   update = "1m"
  #
  #   # 削除タイムアウト (オプション)
  #   # リソース削除操作のタイムアウト時間
  #   # 例: "10m", "1h"
  #   delete = "1m"
  # }
}

# ================================================================================
# 出力属性 (Computed Attributes)
# ================================================================================
# 以下の属性はTerraformによって自動的に計算され、参照可能です:
#
# - arn: メトリクスストリームのARN
#   例: aws_cloudwatch_metric_stream.example.arn
#
# - creation_date: メトリクスストリームが作成された日時 (RFC3339形式)
#   例: "2024-01-15T10:30:00Z"
#
# - last_update_date: メトリクスストリームが最後に更新された日時 (RFC3339形式)
#   例: "2024-01-16T14:20:00Z"
#
# - state: メトリクスストリームの状態
#   指定可能な値: "running", "stopped"
#
# - tags_all: リソースに割り当てられたタグのマップ
#   (プロバイダーのdefault_tags設定ブロックから継承されたタグを含む)
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_stream#attributes-reference
# ================================================================================
