###############################################################################
# Terraform AWS Provider Resource Template
# Resource: aws_prometheus_query_logging_configuration
# Provider Version: 6.28.0
# Generated: 2026-02-04
###############################################################################

# Resource: aws_prometheus_query_logging_configuration
# Description: Manages an Amazon Managed Service for Prometheus (AMP) Query Logging Configuration
#
# Amazon Managed Service for Prometheus (AMP) の Query Logging Configuration を管理します。
# このリソースを使用して、Prometheus ワークスペースのクエリログを CloudWatch Logs に送信する設定を行います。
#
# Use cases:
# - Prometheus クエリの監視とデバッグ
# - クエリパフォーマンスの分析とトラブルシューティング
# - コンプライアンスとセキュリティ監査のためのログ記録
# - クエリパターンの最適化と使用状況の追跡
#
# 制約事項:
# - CloudWatch Logs のロググループ ARN は `:*` で終わる必要があります
# - QSP (Query Samples Processed) のしきい値を超えるクエリのみがログに記録されます
# - 適切な IAM 権限が必要です（AMP から CloudWatch Logs への書き込み権限）
#
# Reference:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/prometheus_query_logging_configuration
###############################################################################

resource "aws_prometheus_query_logging_configuration" "example" {
  ###############################################################################
  # Required Arguments
  ###############################################################################

  # workspace_id
  # Type: string
  # Required: Yes
  # Description: The ID of the AMP workspace for which to configure query logging
  #
  # Query Logging を有効化する AMP ワークスペースの ID を指定します。
  # 既存の aws_prometheus_workspace リソースの ID を参照することが一般的です。
  #
  # Example:
  #   workspace_id = aws_prometheus_workspace.example.id
  #   workspace_id = "ws-1234abcd-5678-90ef-ghij-klmnopqrstuv"
  workspace_id = aws_prometheus_workspace.example.id

  ###############################################################################
  # destination Block (Required)
  #
  # クエリログの送信先設定を定義します。現在は CloudWatch Logs のみがサポートされています。
  ###############################################################################
  destination {
    ###############################################################################
    # cloudwatch_logs Block (Required)
    #
    # CloudWatch Logs の送信先設定を定義します。
    ###############################################################################
    cloudwatch_logs {
      # log_group_arn
      # Type: string
      # Required: Yes
      # Description: The ARN of the CloudWatch log group to which query logs will be sent
      #
      # クエリログを送信する CloudWatch Logs ロググループの ARN を指定します。
      # ARN は必ず `:*` で終わる必要があります。
      #
      # Format: arn:aws:logs:region:account-id:log-group:/aws/prometheus/query-logs/workspace-name:*
      #
      # Example:
      #   log_group_arn = "${aws_cloudwatch_log_group.example.arn}:*"
      #   log_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/prometheus/query-logs/example:*"
      log_group_arn = "${aws_cloudwatch_log_group.example.arn}:*"
    }

    ###############################################################################
    # filters Block (Required)
    #
    # ログに記録するクエリを決定するフィルタ設定を定義します。
    ###############################################################################
    filters {
      # qsp_threshold
      # Type: number
      # Required: Yes
      # Description: The Query Samples Processed (QSP) threshold above which queries will be logged
      #
      # QSP (Query Samples Processed) のしきい値を指定します。
      # この値を超えるサンプル数を処理したクエリのみがログに記録されます。
      #
      # QSP とは、クエリが処理したデータポイント（サンプル）の総数を示します。
      # 値が大きいほど、より重いクエリのみがログに記録されます。
      #
      # Recommendations:
      # - 開発/検証環境: 1000-10000 （詳細なデバッグ用）
      # - 本番環境: 10000-100000 （パフォーマンス問題の検出用）
      # - 大規模環境: 100000+ （重大な問題のみを追跡）
      #
      # Example:
      #   qsp_threshold = 1000    # 1000サンプル以上を処理したクエリを記録
      #   qsp_threshold = 50000   # 50000サンプル以上を処理したクエリを記録
      qsp_threshold = 1000
    }
  }

  ###############################################################################
  # Optional Arguments
  ###############################################################################

  # region
  # Type: string
  # Required: No
  # Default: Provider の設定値
  # Description: Region where this resource will be managed
  #
  # このリソースを管理するリージョンを指定します。
  # 指定しない場合、Provider の設定値が使用されます。
  #
  # マルチリージョン構成や特定のリージョンで管理する必要がある場合に使用します。
  #
  # Example:
  #   region = "us-east-1"
  #   region = "ap-northeast-1"
  # region = "us-east-1"

  ###############################################################################
  # Lifecycle Configuration
  ###############################################################################

  # lifecycle {
  #   # ロググループの変更時に再作成を防ぐ
  #   ignore_changes = [
  #     destination[0].cloudwatch_logs[0].log_group_arn
  #   ]
  #
  #   # 削除時に設定を保持
  #   prevent_destroy = true
  # }

  ###############################################################################
  # Tags (Computed)
  ###############################################################################
  # 注意: このリソースは tags 属性をサポートしていません
  # タグ付けが必要な場合は、関連する aws_prometheus_workspace にタグを設定してください
}

###############################################################################
# Output Values
###############################################################################

# output "prometheus_query_logging_configuration_id" {
#   description = "The ID of the query logging configuration (same as workspace_id)"
#   value       = aws_prometheus_query_logging_configuration.example.id
# }
#
# output "prometheus_query_logging_configuration_workspace_id" {
#   description = "The workspace ID for which query logging is configured"
#   value       = aws_prometheus_query_logging_configuration.example.workspace_id
# }

###############################################################################
# Required Dependencies Example
###############################################################################

# # Prometheus Workspace
# resource "aws_prometheus_workspace" "example" {
#   alias = "example-workspace"
#
#   tags = {
#     Name        = "example-prometheus-workspace"
#     Environment = "production"
#     Purpose     = "query-logging"
#   }
# }
#
# # CloudWatch Log Group
# resource "aws_cloudwatch_log_group" "example" {
#   name              = "/aws/prometheus/query-logs/example"
#   retention_in_days = 7
#
#   tags = {
#     Name        = "example-prometheus-query-logs"
#     Environment = "production"
#   }
# }
#
# # IAM Role for Prometheus to write to CloudWatch Logs
# resource "aws_iam_role" "prometheus_logs" {
#   name = "prometheus-query-logs-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "aps.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }
#
# resource "aws_iam_role_policy" "prometheus_logs" {
#   name = "prometheus-query-logs-policy"
#   role = aws_iam_role.prometheus_logs.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ]
#         Resource = "${aws_cloudwatch_log_group.example.arn}:*"
#       }
#     ]
#   })
# }

###############################################################################
# Advanced Configuration Examples
###############################################################################

# # Example 1: Multiple workspaces with different thresholds
# resource "aws_prometheus_query_logging_configuration" "development" {
#   workspace_id = aws_prometheus_workspace.development.id
#
#   destination {
#     cloudwatch_logs {
#       log_group_arn = "${aws_cloudwatch_log_group.development.arn}:*"
#     }
#
#     filters {
#       qsp_threshold = 1000  # 開発環境では低いしきい値で詳細なログを取得
#     }
#   }
# }
#
# resource "aws_prometheus_query_logging_configuration" "production" {
#   workspace_id = aws_prometheus_workspace.production.id
#
#   destination {
#     cloudwatch_logs {
#       log_group_arn = "${aws_cloudwatch_log_group.production.arn}:*"
#     }
#
#     filters {
#       qsp_threshold = 50000  # 本番環境では高いしきい値で重要なログのみ取得
#     }
#   }
# }

# # Example 2: Cross-region configuration
# resource "aws_prometheus_query_logging_configuration" "cross_region" {
#   workspace_id = aws_prometheus_workspace.us_west.id
#   region       = "us-west-2"
#
#   destination {
#     cloudwatch_logs {
#       log_group_arn = "${aws_cloudwatch_log_group.us_west.arn}:*"
#     }
#
#     filters {
#       qsp_threshold = 10000
#     }
#   }
# }

# # Example 3: Organized log group with retention
# resource "aws_cloudwatch_log_group" "organized" {
#   name              = "/aws/prometheus/query-logs/${var.environment}/${var.application}"
#   retention_in_days = var.environment == "production" ? 30 : 7
#   kms_key_id        = var.enable_encryption ? aws_kms_key.logs.arn : null
#
#   tags = {
#     Name        = "${var.application}-prometheus-query-logs"
#     Environment = var.environment
#     ManagedBy   = "terraform"
#   }
# }
#
# resource "aws_prometheus_query_logging_configuration" "organized" {
#   workspace_id = aws_prometheus_workspace.organized.id
#
#   destination {
#     cloudwatch_logs {
#       log_group_arn = "${aws_cloudwatch_log_group.organized.arn}:*"
#     }
#
#     filters {
#       qsp_threshold = var.query_log_threshold
#     }
#   }
# }

###############################################################################
# Import Example
###############################################################################

# Query Logging Configuration can be imported using the workspace ID
#
# Example:
#   terraform import aws_prometheus_query_logging_configuration.example ws-1234abcd-5678-90ef-ghij-klmnopqrstuv
#
# Note: Import コマンドはワークスペース ID を使用して既存の Query Logging Configuration をインポートします

###############################################################################
# Best Practices and Recommendations
###############################################################################

# 1. ロググループの命名規則
#    - 一貫性のある命名規則を使用（例: /aws/prometheus/query-logs/{environment}/{workspace-name}）
#    - 環境やアプリケーションで識別しやすい名前を付ける
#
# 2. ログ保持期間
#    - 開発環境: 7日間
#    - ステージング環境: 14日間
#    - 本番環境: 30-90日間（コンプライアンス要件に応じて）
#
# 3. QSP しきい値の設定
#    - 環境に応じて適切な値を設定
#    - 初期は低めの値で設定し、ログ量を確認しながら調整
#    - CloudWatch Logs のコストを考慮
#
# 4. IAM 権限
#    - 最小権限の原則に従う
#    - ロググループへの書き込み権限のみを付与
#    - リソースベースのポリシーで特定のロググループに制限
#
# 5. 暗号化
#    - 機密性の高いログの場合、KMS キーでロググループを暗号化
#    - 適切なキーポリシーを設定
#
# 6. モニタリング
#    - CloudWatch Logs Insights でクエリパフォーマンスを分析
#    - メトリクスフィルタでアラートを設定
#    - コスト異常検知アラームを設定
#
# 7. マルチリージョン
#    - 各リージョンで独立した設定を管理
#    - リージョン固有の命名規則を使用
#
# 8. コスト最適化
#    - 適切な QSP しきい値でログ量を制御
#    - S3 へのエクスポートを検討（長期保存が必要な場合）
#    - 不要になったロググループは削除

###############################################################################
# Troubleshooting
###############################################################################

# Issue: Query logs are not appearing in CloudWatch Logs
# Solution:
#   1. IAM ロールと権限を確認
#   2. ロググループ ARN が `:*` で終わっているか確認
#   3. QSP しきい値を超えるクエリが実行されているか確認
#   4. CloudWatch Logs のクォータ制限を確認
#
# Issue: AccessDeniedException when creating the configuration
# Solution:
#   1. Terraform 実行ユーザーに `aps:CreateLoggingConfiguration` 権限があるか確認
#   2. CloudWatch Logs への書き込み権限を Prometheus サービスロールに付与
#   3. KMS キーポリシー（暗号化使用時）を確認
#
# Issue: High CloudWatch Logs costs
# Solution:
#   1. QSP しきい値を引き上げる
#   2. ロググループの保持期間を短縮
#   3. S3 へのアーカイブを設定
#   4. 不要なワークスペースのログ設定を削除

###############################################################################
# Related Resources
###############################################################################

# - aws_prometheus_workspace: Prometheus ワークスペース
# - aws_cloudwatch_log_group: CloudWatch Logs ロググループ
# - aws_iam_role: IAM ロール
# - aws_iam_role_policy: IAM ロールポリシー
# - aws_kms_key: KMS 暗号化キー

###############################################################################
# Change Log
###############################################################################

# Provider Version 6.28.0:
#   - Query Logging Configuration のサポート追加
#   - CloudWatch Logs への送信機能
#   - QSP しきい値ベースのフィルタリング
