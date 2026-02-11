# ============================================================
# CloudWatch RUM Metrics Destination
# ============================================================
# CloudWatch RUM（Real User Monitoring）のメトリクスを送信する宛先を設定するリソース
#
# 主な用途:
# - RUMアプリモニターから収集したメトリクスをCloudWatchまたはEvidentlyに送信
# - 拡張メトリクスやカスタムメトリクスの送信先を定義
# - A/Bテストや機能フラグ検証のためにEvidentlyへメトリクスを転送
#
# 料金への影響:
# - CloudWatch送信: カスタムメトリクスとして課金
# - Evidently送信: Evidentlyの料金体系に従う
# - 拡張メトリクスはCloudWatchカスタムメトリクスとして課金
#
# 注意事項:
# - 送信先がEvidentlyの場合、destination_arnとiam_role_arnが必須
# - 送信先がCloudWatchの場合、iam_role_arnは不要
# - 1つのアプリモニターに複数の送信先を設定可能
# - メトリクス定義は最大2000件まで設定可能
#
# 参考:
# - https://docs.aws.amazon.com/cloudwatchrum/latest/APIReference/API_PutRumMetricsDestination.html
# - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-metrics.html
# ============================================================

resource "aws_rum_metrics_destination" "example" {
  # ------------------------------------------------------------
  # 必須パラメータ
  # ------------------------------------------------------------

  # app_monitor_name (必須)
  # メトリクスを送信するCloudWatch RUMアプリモニターの名前
  #
  # 設定のポイント:
  # - aws_rum_app_monitorリソースのnameを参照
  # - アプリモニターは事前に作成されている必要がある
  # - 名前の変更は新しいリソースの作成を伴う
  #
  # 例:
  # - "my-web-app-monitor"
  # - "mobile-app-production"
  # - aws_rum_app_monitor.example.name
  app_monitor_name = "my-app-monitor"

  # destination (必須)
  # メトリクスの送信先を指定
  #
  # 有効な値:
  # - "CloudWatch": CloudWatchにメトリクスを送信
  # - "Evidently": CloudWatch Evidentlyにメトリクスを送信
  #
  # 選択基準:
  # - CloudWatch: 通常のメトリクス監視、アラート設定、ダッシュボード作成
  # - Evidently: A/Bテスト、機能フラグ、実験的機能の評価
  #
  # 注意:
  # - Evidentlyを選択する場合、destination_arnとiam_role_arnが必須
  # - CloudWatchを選択する場合、iam_role_arnは不要
  destination = "CloudWatch"

  # ------------------------------------------------------------
  # オプションパラメータ
  # ------------------------------------------------------------

  # destination_arn (オプション)
  # Evidentlyの実験ARNを指定（destinationがEvidentlyの場合のみ必須）
  #
  # 設定のポイント:
  # - destinationが"Evidently"の場合のみ指定
  # - Evidentlyの実験リソースのARNを指定
  # - CloudWatchを宛先とする場合は省略
  #
  # ARN形式:
  # - arn:aws:evidently:region:account-id:project/project-name/experiment/experiment-name
  #
  # 例:
  # - arn:aws:evidently:us-east-1:123456789012:project/my-project/experiment/my-experiment
  # - aws_evidently_experiment.example.arn
  #
  # destination = "Evidently"の場合の設定例:
  # destination_arn = "arn:aws:evidently:us-east-1:123456789012:project/my-project/experiment/my-experiment"

  # iam_role_arn (オプション)
  # Evidentlyへの書き込み権限を持つIAMロールのARN（destinationがEvidentlyの場合のみ必須）
  #
  # 設定のポイント:
  # - destinationが"Evidently"の場合のみ指定
  # - Evidentlyの実験への書き込み権限が必要
  # - CloudWatchを宛先とする場合は省略または使用しない
  #
  # 必要な権限:
  # - evidently:PutProjectEvents
  # - evidently:EvaluateFeature（機能フラグ評価の場合）
  #
  # 信頼ポリシー:
  # - Service: rum.amazonaws.com
  #
  # ARN形式:
  # - arn:aws:iam::account-id:role/role-name
  #
  # 例:
  # - arn:aws:iam::123456789012:role/CloudWatchRUMEvidentlyRole
  # - aws_iam_role.rum_evidently_role.arn
  #
  # セキュリティのベストプラクティス:
  # - 最小権限の原則に従う
  # - 特定の実験リソースへのアクセスのみ許可
  # - ロールのセッション期間を適切に設定
  #
  # destination = "Evidently"の場合の設定例:
  # iam_role_arn = "arn:aws:iam::123456789012:role/CloudWatchRUMEvidentlyRole"

  # region (オプション)
  # このリソースを管理するAWSリージョンを指定
  #
  # 設定のポイント:
  # - 省略した場合、プロバイダー設定のリージョンが使用される
  # - マルチリージョン構成の場合に明示的に指定
  # - アプリモニターと同じリージョンに作成することを推奨
  #
  # 例:
  # - "us-east-1"
  # - "ap-northeast-1"
  # - "eu-west-1"
  #
  # 注意:
  # - リージョン変更は新しいリソースの作成を伴う
  # - Evidentlyの実験も同じリージョンに存在する必要がある
  #
  # region = "us-east-1"

  # ------------------------------------------------------------
  # タグ設定
  # ------------------------------------------------------------
  # 注意: このリソースはタグをサポートしていません
  # タグ管理が必要な場合は、アプリモニターリソースにタグを設定してください
}

# ============================================================
# CloudWatch送信の設定例
# ============================================================
# 最もシンプルな構成 - CloudWatchにメトリクスを送信
#
# resource "aws_rum_metrics_destination" "cloudwatch" {
#   app_monitor_name = aws_rum_app_monitor.example.name
#   destination      = "CloudWatch"
# }

# ============================================================
# Evidently送信の設定例
# ============================================================
# Evidentlyの実験にメトリクスを送信する完全な構成
#
# # IAMロールの作成
# resource "aws_iam_role" "rum_evidently" {
#   name = "CloudWatchRUMEvidentlyRole"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "rum.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }
#
# # IAMポリシーの作成
# resource "aws_iam_role_policy" "rum_evidently" {
#   name = "CloudWatchRUMEvidentlyPolicy"
#   role = aws_iam_role.rum_evidently.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "evidently:PutProjectEvents"
#         ]
#         Resource = aws_evidently_experiment.example.arn
#       }
#     ]
#   })
# }
#
# # Evidentlyへのメトリクス送信先設定
# resource "aws_rum_metrics_destination" "evidently" {
#   app_monitor_name = aws_rum_app_monitor.example.name
#   destination      = "Evidently"
#   destination_arn  = aws_evidently_experiment.example.arn
#   iam_role_arn     = aws_iam_role.rum_evidently.arn
# }

# ============================================================
# 複数送信先の設定例
# ============================================================
# 1つのアプリモニターから複数の宛先にメトリクスを送信
#
# # CloudWatchへの送信
# resource "aws_rum_metrics_destination" "cloudwatch" {
#   app_monitor_name = aws_rum_app_monitor.example.name
#   destination      = "CloudWatch"
# }
#
# # Evidentlyへの送信（A/Bテスト用）
# resource "aws_rum_metrics_destination" "evidently_ab_test" {
#   app_monitor_name = aws_rum_app_monitor.example.name
#   destination      = "Evidently"
#   destination_arn  = aws_evidently_experiment.ab_test.arn
#   iam_role_arn     = aws_iam_role.rum_evidently.arn
# }
#
# # Evidentlyへの送信（機能フラグ検証用）
# resource "aws_rum_metrics_destination" "evidently_feature_flag" {
#   app_monitor_name = aws_rum_app_monitor.example.name
#   destination      = "Evidently"
#   destination_arn  = aws_evidently_experiment.feature_flag.arn
#   iam_role_arn     = aws_iam_role.rum_evidently.arn
# }

# ============================================================
# マルチリージョン構成の例
# ============================================================
# 複数のリージョンでRUMメトリクスを収集
#
# # us-east-1リージョンの設定
# resource "aws_rum_metrics_destination" "us_east_1" {
#   app_monitor_name = aws_rum_app_monitor.us_east_1.name
#   destination      = "CloudWatch"
#   region           = "us-east-1"
# }
#
# # ap-northeast-1リージョンの設定
# resource "aws_rum_metrics_destination" "ap_northeast_1" {
#   app_monitor_name = aws_rum_app_monitor.ap_northeast_1.name
#   destination      = "CloudWatch"
#   region           = "ap-northeast-1"
# }

# ============================================================
# 出力値の定義
# ============================================================
# メトリクス送信先の識別子を出力
#
# output "rum_metrics_destination_id" {
#   description = "The CloudWatch RUM app monitor name"
#   value       = aws_rum_metrics_destination.example.id
# }

# ============================================================
# 関連リソースとの統合
# ============================================================
# CloudWatch RUMの完全なセットアップ例
#
# # アプリモニターの作成
# resource "aws_rum_app_monitor" "example" {
#   name   = "my-web-app"
#   domain = "example.com"
#
#   app_monitor_configuration {
#     allow_cookies        = true
#     enable_xray          = true
#     session_sample_rate  = 0.1
#     telemetries          = ["errors", "performance", "http"]
#   }
# }
#
# # メトリクス送信先の設定（CloudWatch）
# resource "aws_rum_metrics_destination" "cloudwatch" {
#   app_monitor_name = aws_rum_app_monitor.example.name
#   destination      = "CloudWatch"
# }
#
# # CloudWatchアラームの設定
# resource "aws_cloudwatch_metric_alarm" "high_error_rate" {
#   alarm_name          = "rum-high-error-rate"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = 2
#   metric_name         = "JsErrorCount"
#   namespace           = "AWS/RUM"
#   period              = 300
#   statistic           = "Sum"
#   threshold           = 100
#
#   dimensions = {
#     application_name = aws_rum_app_monitor.example.name
#   }
# }

# ============================================================
# ベストプラクティス
# ============================================================
# 1. 送信先の選択
#    - 通常の監視: CloudWatchを使用
#    - A/Bテスト・実験: Evidentlyを使用
#    - 両方の用途: 複数の送信先リソースを作成
#
# 2. IAMロールの設定（Evidently使用時）
#    - 最小権限の原則を適用
#    - 特定の実験リソースのみへのアクセス許可
#    - 信頼ポリシーでrum.amazonaws.comのみを許可
#
# 3. メトリクスの管理
#    - 拡張メトリクスはカスタムメトリクスとして課金されることに注意
#    - 不要なメトリクスは無効化してコストを最適化
#    - メトリクス定義の上限（2000件）を考慮
#
# 4. リージョン管理
#    - アプリモニターと同じリージョンに配置
#    - マルチリージョン構成の場合は各リージョンで設定
#    - Evidentlyの実験も同じリージョンに作成
#
# 5. 監視とアラート
#    - CloudWatch送信先でメトリクスベースのアラームを設定
#    - エラー率、パフォーマンス指標を継続的に監視
#    - ダッシュボードで可視化
#
# 6. セキュリティ
#    - IAMロールの権限は定期的に見直し
#    - CloudTrailでAPI呼び出しを監査
#    - 実験データへのアクセスを適切に制限

# ============================================================
# トラブルシューティング
# ============================================================
# 問題: メトリクスがEvidentlyに送信されない
# 解決策:
# - IAMロールの権限を確認
# - destination_arnが正しい実験を指しているか確認
# - 実験がアクティブ状態か確認
#
# 問題: "AccessDenied" エラーが発生
# 解決策:
# - IAMロールの信頼ポリシーでrum.amazonaws.comが許可されているか確認
# - IAMポリシーでevidently:PutProjectEvents権限があるか確認
# - リソースARNが正しく指定されているか確認
#
# 問題: メトリクスの課金が予想より高い
# 解決策:
# - 拡張メトリクスの使用状況を確認
# - 不要な次元（dimension）を削減
# - サンプリングレートを調整
# - メトリクス定義の数を最適化
