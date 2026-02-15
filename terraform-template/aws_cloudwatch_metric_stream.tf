#---------------------------------------------------------------
# CloudWatch Metric Stream
#---------------------------------------------------------------
#
# CloudWatchメトリクスをリアルタイムでストリーミング配信するリソースです。
# Kinesis Data Firehose経由でS3やサードパーティの監視サービスにメトリクスを送信し、
# リアルタイム分析、長期保存、外部監視ツールとの統合を実現します。
#
# AWS公式ドキュメント:
#   - CloudWatch Metric Streams概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Metric-Streams.html
#   - 出力フォーマット: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-metric-streams-formats.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_stream
#
# Provider Version: 6.28.0
# Generated: 2026-02-12
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_metric_stream" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Computed)
  # 設定内容: ストリームの識別名を指定します。
  # 設定可能な値: 1-255文字の英数字、ハイフン、アンダースコア
  # 省略時: name_prefixと組み合わせて自動生成されます。
  name = "example-metric-stream"

  # name_prefix (Optional, Computed)
  # 設定内容: 名前のプレフィックスを指定します（name自動生成時）。
  # 設定可能な値: 1-255文字の英数字、ハイフン、アンダースコア
  # 省略時: nameが使用されます。
  name_prefix = null

  #-------------------------------------------------------------
  # 配信先設定
  #-------------------------------------------------------------

  # firehose_arn (Required)
  # 設定内容: 配信先のKinesis Data Firehose ARNを指定します。
  # 設定可能な値: 有効なKinesis Data Firehose配信ストリームのARN
  firehose_arn = "arn:aws:firehose:us-east-1:123456789012:deliverystream/example-stream"

  # role_arn (Required)
  # 設定内容: Firehoseへの書き込み権限を持つIAMロールARNを指定します。
  # 設定可能な値: 有効なIAMロールARN（firehose:PutRecord/PutRecordBatch権限が必要）
  role_arn = "arn:aws:iam::123456789012:role/CloudWatchMetricStreamRole"

  # output_format (Required)
  # 設定内容: メトリクスの出力フォーマットを指定します。
  # 設定可能な値:
  #   - "json": JSON形式
  #   - "opentelemetry0.7": OpenTelemetry 0.7形式
  #   - "opentelemetry1.0": OpenTelemetry 1.0形式
  output_format = "json"

  #-------------------------------------------------------------
  # フィルタリング設定
  #-------------------------------------------------------------

  # exclude_filter (Optional)
  # 設定内容: ストリームから除外するメトリクスの名前空間を指定します。
  # 設定可能な値: 複数のフィルタブロックを設定可能
  # 注意: include_filterと同時には使用できません（排他的）。
  # exclude_filter {
  #   # namespace (Required)
  #   # 設定内容: 除外する名前空間を指定します。
  #   # 設定可能な値: CloudWatchメトリクスの名前空間（例: AWS/EC2, AWS/Lambda）
  #   namespace = "AWS/EC2"
  #
  #   # metric_names (Optional)
  #   # 設定内容: 特定のメトリクス名のみを除外します。
  #   # 設定可能な値: メトリクス名のリスト
  #   # 省略時: 名前空間内のすべてのメトリクスが除外されます。
  #   metric_names = ["CPUUtilization", "NetworkIn"]
  # }

  # include_filter (Optional)
  # 設定内容: ストリームに含めるメトリクスの名前空間を指定します。
  # 設定可能な値: 複数のフィルタブロックを設定可能
  # 注意: exclude_filterと同時には使用できません（排他的）。
  # include_filter {
  #   # namespace (Required)
  #   # 設定内容: 含める名前空間を指定します。
  #   # 設定可能な値: CloudWatchメトリクスの名前空間（例: AWS/Lambda, AWS/RDS）
  #   namespace = "AWS/Lambda"
  #
  #   # metric_names (Optional)
  #   # 設定内容: 特定のメトリクス名のみを含めます。
  #   # 設定可能な値: メトリクス名のリスト
  #   # 省略時: 名前空間内のすべてのメトリクスが含まれます。
  #   metric_names = ["Invocations", "Duration", "Errors"]
  # }

  #-------------------------------------------------------------
  # 統計設定
  #-------------------------------------------------------------

  # statistics_configuration (Optional)
  # 設定内容: 特定メトリクスに対する追加統計情報を設定します。
  # 設定可能な値: 複数の統計設定ブロックを設定可能
  # 省略時: デフォルトの統計のみ（Sum, Average, SampleCount, Minimum, Maximum）
  # statistics_configuration {
  #   # additional_statistics (Required)
  #   # 設定内容: 追加で出力する統計情報を指定します。
  #   # 設定可能な値: パーセンタイル統計（p0, p0.5, p10, p50, p90, p95, p99, p100など）
  #   additional_statistics = ["p99", "p95", "p90"]
  #
  #   # include_metric (Required, Min Items: 1)
  #   # 設定内容: 統計を適用するメトリクスを指定します。
  #   include_metric {
  #     # metric_name (Required)
  #     # 設定内容: メトリクス名を指定します。
  #     metric_name = "Duration"
  #
  #     # namespace (Required)
  #     # 設定内容: メトリクスの名前空間を指定します。
  #     namespace = "AWS/Lambda"
  #   }
  # }

  #-------------------------------------------------------------
  # マルチアカウント設定
  #-------------------------------------------------------------

  # include_linked_accounts_metrics (Optional)
  # 設定内容: AWS Organizationsでリンクされたアカウントのメトリクスを含めるかを指定します。
  # 設定可能な値:
  #   - true: リンクされたアカウントのメトリクスも含める
  #   - false: 自アカウントのメトリクスのみ
  # 省略時: false
  include_linked_accounts_metrics = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: リソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（us-east-1, ap-northeast-1など）
  # 省略時: プロバイダーのデフォルトリージョンが使用されます。
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグを指定します。
  # 設定可能な値: キーと値のペア（最大50個）
  # 省略時: タグなし
  tags = {
    Name        = "example-metric-stream"
    Environment = "production"
    Service     = "monitoring"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsとマージされたすべてのタグです。
  # 設定可能な値: キーと値のペア
  # 省略時: tagsとdefault_tagsが自動的にマージされます。
  # tags_all = {}

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定します。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: ストリーム作成のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "10m", "1h"）
  #   # 省略時: デフォルトのタイムアウト
  #   create = "10m"
  #
  #   # update (Optional)
  #   # 設定内容: ストリーム更新のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "10m", "1h"）
  #   # 省略時: デフォルトのタイムアウト
  #   update = "10m"
  #
  #   # delete (Optional)
  #   # 設定内容: ストリーム削除のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "10m", "1h"）
  #   # 省略時: デフォルトのタイムアウト
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# arn              - ストリームのARN
# id               - ストリーム名（nameと同じ）
# creation_date    - ストリームの作成日時（RFC3339形式）
# last_update_date - ストリームの最終更新日時（RFC3339形式）
# state            - ストリームの状態（running, stopped）
# tags_all         - tagsとdefault_tagsをマージしたすべてのタグ
