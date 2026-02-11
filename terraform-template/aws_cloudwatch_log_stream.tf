################################################################################
# Terraform AWS Resource Template: aws_cloudwatch_log_stream
################################################################################
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-19)の AWS Provider 6.28.0 の仕様に基づいています
# - 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream
################################################################################

################################################################################
# CloudWatch Log Stream Resource
#
# CloudWatch Logs のログストリームを作成します。
# ログストリームは、同じソースから発生する一連のログイベントを表します。
# ログストリームはロググループに属し、ロググループの保持期間、監視、
# アクセス制御設定を継承します。
#
# AWS公式ドキュメント:
# - CloudWatch Logs の概念: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogsConcepts.html
# - LogStream API リファレンス: https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_LogStream.html
# - ログストリームの操作: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Working-with-log-groups-and-streams.html
################################################################################

resource "aws_cloudwatch_log_stream" "example" {
  ################################################################################
  # 必須パラメータ (Required Parameters)
  ################################################################################

  # ログストリーム名
  # - ログストリームの名前を指定します
  # - 512文字以内である必要があります
  # - コロン(:)を含めることはできません
  # - 同じロググループ内でログストリーム名は一意である必要があります
  # - 例: "application-logs-2026-01-19", "webserver-instance-i-1234567890abcdef0"
  #
  # Type: string
  # Required: Yes
  # AWS Docs: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogsConcepts.html
  name = "SampleLogStream1234"

  # ロググループ名
  # - このログストリームが所属するロググループの名前を指定します
  # - 指定されたロググループは事前に存在している必要があります
  # - ログストリームは、所属するロググループの保持期間設定を継承します
  # - ログストリームは、所属するロググループのメトリクスフィルタ設定を継承します
  #
  # Type: string
  # Required: Yes
  # AWS Docs: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogsConcepts.html
  log_group_name = aws_cloudwatch_log_group.example.name

  ################################################################################
  # オプションパラメータ (Optional Parameters)
  ################################################################################

  # リージョン指定
  # - このリソースを管理するAWSリージョンを指定します
  # - 省略した場合は、プロバイダー設定で指定されたリージョンが使用されます
  # - マルチリージョン構成で特定のリソースを別リージョンに配置する場合に使用します
  #
  # Type: string
  # Default: プロバイダー設定のリージョン
  # AWS Docs: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # リソースID (通常は指定不要)
  # - Terraformが管理するリソースのIDを明示的に指定します
  # - 通常は自動的に計算されるため、明示的な指定は不要です
  # - 既存リソースのインポート時やカスタムID管理が必要な場合のみ使用します
  #
  # Type: string
  # Computed: Yes (指定しない場合は自動計算)
  # id = "custom-resource-id"
}

################################################################################
# 出力値 (Outputs)
################################################################################
# このリソースから取得可能な主要な属性:
#
# - arn: ログストリームのAmazon Resource Name (ARN)
#   例: aws_cloudwatch_log_stream.example.arn
#   用途: IAMポリシーでのアクセス制御、他のAWSサービスとの統合
#
# - id: リソースのID (log_group_name:name の形式)
#   例: aws_cloudwatch_log_stream.example.id
################################################################################

################################################################################
# 使用例とベストプラクティス
################################################################################
# 1. ログストリーム名の命名規則:
#    - アプリケーション名やインスタンスIDなど、ログソースを識別できる名前を使用
#    - タイムスタンプを含めることで、時系列での管理が容易になります
#    - 例: "${var.application_name}-${var.environment}-${formatdate("YYYY-MM-DD", timestamp())}"
#
# 2. ロググループとの関係:
#    - ログストリームは必ずロググループに属します
#    - ログストリームは、所属するロググループの保持期間やメトリクスフィルタを継承します
#    - 1つのロググループに含められるログストリーム数に制限はありません
#
# 3. ログイベントの送信:
#    - CloudWatch Logs エージェントを使用してEC2インスタンスからログを送信
#    - AWS SDK/CLI の PutLogEvents API を使用してプログラマティックにログを送信
#    - Lambda関数は自動的にログストリームを作成してログを送信します
#
# 4. セキュリティ考慮事項:
#    - ログストリームへのアクセスは、所属するロググループのアクセス制御設定で管理されます
#    - 機密情報を含むログは、KMS暗号化を有効にしたロググループに配置することを推奨
#    - IAMポリシーでログストリームへの書き込み権限を適切に制限してください
#
# 5. コスト最適化:
#    - 不要になったログストリームは削除してストレージコストを削減
#    - ロググループレベルで適切な保持期間を設定
#    - アクセス頻度の低いログには Infrequent Access ログクラスの使用を検討
#
# 6. モニタリングと運用:
#    - メトリクスフィルタを使用して、ログデータから CloudWatch メトリクスを抽出
#    - サブスクリプションフィルタを使用して、リアルタイムでログデータを他のサービスに転送
#    - CloudWatch Logs Insights を使用して、ログデータのクエリと分析を実行
################################################################################
