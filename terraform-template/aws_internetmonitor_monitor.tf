################################################################################
# AWS Internet Monitor - Monitor
################################################################################
# Internet Monitor は Amazon CloudWatch の機能で、AWS 上でホストされている
# アプリケーションのインターネットトラフィックのパフォーマンスと可用性を
# エンドユーザーの観点から監視します。
#
# 主な機能:
# - グローバルネットワーキングインフラストラクチャのデータを使用して
#   インターネットトラフィックのベースラインを確立
# - パフォーマンスと可用性スコアを計算し、問題が発生した場合にヘルスイベントを生成
# - 地理的な場所やネットワークプロバイダー（ASN）ごとの測定データを提供
# - CloudWatch Logs、Metrics、S3 へのデータ公開をサポート
# - EventBridge を通じてヘルスイベントの通知を送信
#
# ユースケース:
# - VPC、NLB、CloudFront ディストリビューション、WorkSpaces などの
#   インターネット向けアプリケーションのパフォーマンス監視
# - エンドユーザーエクスペリエンスの問題の特定とトラブルシューティング
# - レイテンシ削減のための AWS リージョンやサービスの最適化提案
#
# 料金: データボリュームとモニター数に基づいて課金されます
#
# 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-InternetMonitor.what-is-cwim.html
################################################################################

resource "aws_internetmonitor_monitor" "example" {
  #-----------------------------------------------------------------------------
  # 必須パラメータ
  #-----------------------------------------------------------------------------

  # monitor_name (Required)
  # モニターの名前
  # - 一意である必要があります
  # - モニターのリソースを識別するために使用されます
  # - 命名規則に従って、アプリケーションやサービスを識別しやすい名前を設定
  monitor_name = "example-monitor"

  #-----------------------------------------------------------------------------
  # オプションパラメータ
  #-----------------------------------------------------------------------------

  # region (Optional, Computed)
  # このリソースを管理するリージョン
  # - 省略した場合、プロバイダー設定のリージョンが使用されます
  # - 監視対象のリソースがあるリージョンを指定するのが一般的です
  # - クロスリージョン監視も可能です
  # region = "us-east-1"

  # status (Optional)
  # モニターのステータス
  # - 有効な値: "ACTIVE"（アクティブ）、"INACTIVE"（非アクティブ）
  # - INACTIVE に設定すると、モニターはデータ収集を停止しますが、削除されません
  # - 一時的に監視を停止したい場合に便利です
  # status = "ACTIVE"

  # resources (Optional)
  # 監視するリソースの ARN のセット
  # - サポートされるリソース:
  #   * VPC (vpc-xxxxxx)
  #   * Network Load Balancer
  #   * CloudFront ディストリビューション
  #   * WorkSpaces ディレクトリ
  # - Internet Monitor はこれらのリソースのトラフィックを分析して、
  #   クライアントの場所と ASN を特定します
  # - 複数のリソースを指定可能
  # resources = [
  #   "arn:aws:ec2:us-east-1:123456789012:vpc/vpc-12345678",
  #   "arn:aws:cloudfront::123456789012:distribution/E1234567890ABC"
  # ]

  # max_city_networks_to_monitor (Optional)
  # 監視する都市ネットワークの最大数
  # - 都市ネットワークは、クライアントがアプリケーションにアクセスする場所（都市）と
  #   ネットワーク（ISP などの ASN）の組み合わせです
  # - この制限は課金コストの管理に役立ちます
  # - デフォルト値を使用する場合は省略可能
  # max_city_networks_to_monitor = 100

  # traffic_percentage_to_monitor (Optional)
  # 監視するインターネット向けトラフィックの割合（パーセント）
  # - 1 から 100 の値を指定
  # - 100% を監視すると最も正確なデータが得られますが、コストが高くなります
  # - トラフィックが多い場合は、サンプリングを検討してください
  # traffic_percentage_to_monitor = 100

  # tags (Optional)
  # リソースに割り当てるタグのマップ
  # - プロバイダーの default_tags 設定ブロックで定義されたタグは、
  #   ここで定義されたキーに一致する場合に上書きされます
  # - タグは、リソースの整理、コスト配分、アクセス制御に使用できます
  # tags = {
  #   Environment = "production"
  #   Application = "web-app"
  #   Team        = "platform"
  # }

  #-----------------------------------------------------------------------------
  # ヘルスイベント設定
  #-----------------------------------------------------------------------------

  # health_events_config (Optional)
  # ヘルスイベントのしきい値設定
  # - パフォーマンスと可用性のスコアがこのしきい値を下回ると、
  #   Internet Monitor はヘルスイベントを作成します
  # - しきい値はパーセンテージで指定（0-100）
  # - 両方のしきい値は独立して設定可能
  # health_events_config {
  #   # availability_score_threshold (Optional)
  #   # 可用性スコアのヘルスイベントしきい値（パーセント）
  #   # - デフォルト値を使用する場合は省略可能
  #   # - 可用性の問題を検出する感度を調整できます
  #   # availability_score_threshold = 95.0
  #
  #   # performance_score_threshold (Optional)
  #   # パフォーマンススコアのヘルスイベントしきい値（パーセント）
  #   # - デフォルト値を使用する場合は省略可能
  #   # - パフォーマンスの問題を検出する感度を調整できます
  #   # performance_score_threshold = 95.0
  # }

  #-----------------------------------------------------------------------------
  # インターネット測定ログ配信設定
  #-----------------------------------------------------------------------------

  # internet_measurements_log_delivery (Optional)
  # CloudWatch Logs に加えて、Amazon S3 バケットに測定データを公開する設定
  # - 長期保存や分析のためにデータを S3 に保存する場合に使用
  # - S3 へのログ配信を有効にすると、追加の S3 ストレージコストが発生します
  # internet_measurements_log_delivery {
  #   # s3_config (Optional)
  #   # S3 バケットへのログ配信設定
  #   s3_config {
  #     # bucket_name (Required)
  #     # ログを配信する S3 バケット名
  #     # - バケットは事前に作成されている必要があります
  #     # - Internet Monitor がバケットに書き込むための適切な権限が必要です
  #     bucket_name = "my-internetmonitor-logs"
  #
  #     # bucket_prefix (Optional)
  #     # S3 バケット内のプレフィックス（ディレクトリパス）
  #     # - ログファイルを整理するために使用
  #     # - 複数のモニターのログを同じバケットに保存する場合に便利です
  #     # bucket_prefix = "internetmonitor/example-monitor/"
  #
  #     # log_delivery_status (Optional)
  #     # ログ配信のステータス
  #     # - 有効な値: "ENABLED"、"DISABLED"
  #     # - ENABLED に設定すると、S3 へのログ配信が開始されます
  #     # log_delivery_status = "ENABLED"
  #   }
  # }
}

################################################################################
# 出力値（Attributes Reference）
################################################################################
# このリソースは以下の属性をエクスポートします:
#
# - arn: モニターの ARN
#   使用例: aws_internetmonitor_monitor.example.arn
#
# - id: モニターの名前（monitor_name と同じ値）
#   使用例: aws_internetmonitor_monitor.example.id
#
# - tags_all: リソースに割り当てられたすべてのタグのマップ
#   （プロバイダーの default_tags 設定ブロックから継承されたタグを含む）
#   使用例: aws_internetmonitor_monitor.example.tags_all

################################################################################
# 使用例
################################################################################

# 例1: 基本的な設定（CloudFront ディストリビューションを監視）
# resource "aws_internetmonitor_monitor" "cloudfront_monitor" {
#   monitor_name = "cloudfront-app-monitor"
#   status       = "ACTIVE"
#
#   resources = [
#     aws_cloudfront_distribution.main.arn
#   ]
#
#   traffic_percentage_to_monitor = 100
#
#   tags = {
#     Environment = "production"
#     Service     = "cdn"
#   }
# }

# 例2: ヘルスイベントしきい値のカスタマイズ
# resource "aws_internetmonitor_monitor" "custom_threshold_monitor" {
#   monitor_name = "api-monitor"
#   status       = "ACTIVE"
#
#   resources = [
#     aws_lb.api_nlb.arn
#   ]
#
#   health_events_config {
#     availability_score_threshold = 90.0
#     performance_score_threshold  = 85.0
#   }
#
#   tags = {
#     Environment = "production"
#     Service     = "api"
#   }
# }

# 例3: S3 へのログ配信を有効化
# resource "aws_internetmonitor_monitor" "with_s3_logging" {
#   monitor_name = "web-app-monitor"
#   status       = "ACTIVE"
#
#   resources = [
#     aws_vpc.main.arn
#   ]
#
#   internet_measurements_log_delivery {
#     s3_config {
#       bucket_name         = aws_s3_bucket.monitoring_logs.id
#       bucket_prefix       = "internetmonitor/web-app/"
#       log_delivery_status = "ENABLED"
#     }
#   }
#
#   tags = {
#     Environment = "production"
#     Application = "web-app"
#   }
# }

# 例4: VPC とサンプリング監視
# resource "aws_internetmonitor_monitor" "vpc_sampling_monitor" {
#   monitor_name = "vpc-sampling-monitor"
#   status       = "ACTIVE"
#
#   resources = [
#     aws_vpc.main.arn
#   ]
#
#   # トラフィックの 50% のみを監視してコストを削減
#   traffic_percentage_to_monitor = 50
#
#   # 監視する都市ネットワークの数を制限
#   max_city_networks_to_monitor = 50
#
#   tags = {
#     Environment = "development"
#     CostCenter  = "engineering"
#   }
# }

################################################################################
# ベストプラクティスと注意事項
################################################################################
# 1. リソースの選択
#    - 監視対象のリソースは、インターネット向けトラフィックを処理する
#      リソースを選択してください
#    - VPC を選択すると、その VPC 内のすべてのインターネット向けトラフィックが
#      監視対象になります
#
# 2. トラフィックサンプリング
#    - トラフィックが非常に多い場合は、traffic_percentage_to_monitor を調整して
#      コストを管理してください
#    - サンプリング率を下げると精度が低下する可能性があります
#
# 3. ヘルスイベントのしきい値
#    - しきい値はアプリケーションの要件に応じて調整してください
#    - しきい値を低く設定すると、より多くのヘルスイベントが生成されます
#    - しきい値を高く設定すると、重大な問題のみが検出されます
#
# 4. S3 ログ配信
#    - 長期的なトレンド分析や監査目的で S3 へのログ配信を検討してください
#    - S3 バケットには適切なライフサイクルポリシーを設定することを推奨します
#    - バケットポリシーで Internet Monitor からの書き込みアクセスを許可してください
#
# 5. EventBridge 統合
#    - Internet Monitor は自動的にヘルスイベントを EventBridge に送信します
#    - EventBridge ルールを作成して、SNS、Lambda などに通知を送信できます
#
# 6. コスト管理
#    - max_city_networks_to_monitor を設定してコストを管理してください
#    - 不要なモニターは INACTIVE に設定するか削除してください
#    - トラフィックボリュームに基づいて課金されることを理解してください
#
# 7. クロスアカウント監視
#    - Internet Monitor はクロスアカウント観測可能性をサポートしています
#    - CloudWatch のクロスアカウント機能と組み合わせて使用できます
#
# 8. リージョンの考慮事項
#    - region パラメータは、モニターリソース自体が管理されるリージョンを指定します
#    - 監視対象のアプリケーションリソースは、異なるリージョンにあっても構いません
#    - Internet Monitor がサポートされているリージョンで作成してください
#
# 9. データの保持
#    - CloudWatch Logs のデータ保持期間を設定して、コストを管理してください
#    - S3 に保存する場合は、S3 Intelligent-Tiering や Glacier への移行を検討してください
#
# 10. パフォーマンス最適化
#     - Internet Monitor の提案を確認して、別の AWS リージョンやサービスを
#       使用することでレイテンシを削減できるかを検討してください
#     - CloudFront との組み合わせで、グローバルなパフォーマンス向上を実現できます
