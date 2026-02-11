#================================================================================
# AWS CloudWatch Evidently Project
#================================================================================
# CloudWatch Evidentlyプロジェクト - 機能フラグとA/Bテストの実験環境
#
# 【重要な非推奨警告】
# このリソースは非推奨（deprecated）です。
# AWS AppConfig Feature Flagsの使用が推奨されています。
# https://aws.amazon.com/blogs/mt/using-aws-appconfig-feature-flags/
#
# 【サービス終了予定】
# Amazon CloudWatch Evidentlyは2025年10月17日にサービス終了予定です。
# 新規プロジェクトはAWS Systems Manager AppConfigへの移行を推奨します。
#
# 【用途】
# - 機能フラグを使用した段階的な機能リリース
# - A/Bテストによるユーザーエクスペリエンスの向上
# - 実験結果の評価と分析
#
# 【主な機能】
# - Feature Flags: 機能の動的な有効化/無効化
# - Experiments: A/Bテストの実行と結果分析
# - Launches: 段階的な機能リリース
# - Event Storage: CloudWatch LogsまたはS3への評価イベント保存
#
# 【関連サービス】
# - AWS AppConfig: 推奨される代替サービス（機能フラグ）
# - Amazon CloudWatch Logs: 評価イベントの保存先
# - Amazon S3: 評価イベントの長期保存先
# - Amazon Personalize: レコメンデーションのA/Bテスト連携
#
# 【プロジェクトの構成要素】
# - Features: 機能フラグの定義
# - Experiments: A/Bテストの実験設定
# - Launches: 段階的リリースの設定
#
# Provider Version: 6.28.0
# AWS Documentation: https://docs.aws.amazon.com/cloudwatch/latest/monitoring/CloudWatch-Evidently.html
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/evidently_project
#================================================================================

resource "aws_evidently_project" "example" {
  #==============================================================================
  # 必須パラメータ (Required Parameters)
  #==============================================================================

  # name - プロジェクト名
  # 説明: Evidentlyプロジェクトの一意な名前
  # タイプ: string
  # 必須: Yes
  # 更新: 変更時は再作成が必要
  #
  # 命名規則:
  # - 英数字、ハイフン、アンダースコアが使用可能
  # - アカウント内で一意である必要があります
  #
  # 例:
  # - "my-feature-flags"
  # - "ab-testing-project"
  # - "gradual-rollout-features"
  name = "example-evidently-project"

  #==============================================================================
  # オプションパラメータ (Optional Parameters)
  #==============================================================================

  # description - プロジェクトの説明
  # 説明: プロジェクトの目的や用途を説明するテキスト
  # タイプ: string
  # デフォルト: null
  #
  # ベストプラクティス:
  # - プロジェクトの目的を明確に記述
  # - 管理する機能の概要を含める
  # - チーム名や担当者情報を含めることも推奨
  #
  # 例:
  # - "モバイルアプリの新機能A/Bテスト"
  # - "Web UIの段階的リリース管理"
  # - "推奨エンジンの実験環境"
  description = "Example CloudWatch Evidently project for feature flags and A/B testing"

  # region - リージョン指定
  # 説明: リソースを管理するAWSリージョン
  # タイプ: string
  # デフォルト: プロバイダー設定のリージョン
  #
  # 注意:
  # - 通常はプロバイダー設定のリージョンが使用されます
  # - 明示的に指定する場合のみ設定します
  # - 変更時は再作成が必要です
  #
  # 例: "us-east-1", "ap-northeast-1", "eu-west-1"
  # region = "us-east-1"

  # tags - リソースタグ
  # 説明: プロジェクトに付与するタグ（キー・バリューペア）
  # タイプ: map(string)
  # デフォルト: {}
  #
  # タグ付けのベストプラクティス:
  # - Environment: 環境識別（dev, staging, prod）
  # - Owner: 所有者やチーム名
  # - Project: プロジェクト名
  # - CostCenter: コスト管理用
  # - ManagedBy: Terraformなど管理ツール
  #
  # 注意:
  # - プロバイダーのdefault_tagsと統合されます
  # - tags_allには全てのタグが含まれます（computed）
  tags = {
    Environment = "development"
    Project     = "feature-testing"
    ManagedBy   = "terraform"
    Owner       = "platform-team"
    Service     = "evidently"
  }

  #==============================================================================
  # データ配信設定 (Data Delivery Configuration)
  #==============================================================================
  #
  # data_delivery - 評価イベントの保存設定
  # 説明: Evidentlyが評価イベントを長期保存する場所の設定
  # タイプ: list(object)
  # 最大個数: 1
  # デフォルト: null（設定しない場合、イベントはメトリクス生成後に削除）
  #
  # 評価イベントとは:
  # - ユーザーがどの機能バリエーションを受け取ったか
  # - 実験結果に関するデータ
  # - A/Bテストの評価データ
  #
  # 保存先の選択肢:
  # 1. CloudWatch Logs: リアルタイム分析、短期保存に適している
  # 2. S3 Bucket: 長期保存、コスト効率が良い
  #
  # 重要な制約:
  # - cloudwatch_logsとs3_destinationは同時に指定できません
  # - どちらか一方のみ設定可能です

  # 例1: CloudWatch Logsへの配信
  # リアルタイム分析や短期間の保存に適しています
  data_delivery {
    cloudwatch_logs {
      # log_group - CloudWatch Logsのロググループ名
      # 説明: 評価イベントを保存するロググループ
      # タイプ: string
      #
      # 要件:
      # - ロググループは事前に作成されている必要があります
      # - Evidentlyがログを書き込む権限が必要です
      #
      # ベストプラクティス:
      # - プロジェクト名を含めた命名
      # - ログの保持期間を適切に設定
      # - CloudWatch Logs Insightsでの分析を考慮
      #
      # 例: "/aws/evidently/my-project"
      log_group = "/aws/evidently/example-project"
    }
  }

  # 例2: S3への配信（上記のCloudWatch Logsの代わりに使用）
  # 長期保存やコスト効率を重視する場合に適しています
  #
  # data_delivery {
  #   s3_destination {
  #     # bucket - S3バケット名
  #     # 説明: 評価イベントを保存するS3バケット
  #     # タイプ: string
  #     #
  #     # 要件:
  #     # - バケットは事前に作成されている必要があります
  #     # - Evidentlyがオブジェクトを書き込む権限が必要です
  #     # - バケットポリシーで適切な権限設定が必要
  #     #
  #     # ベストプラクティス:
  #     # - バージョニングの有効化
  #     # - ライフサイクルポリシーの設定
  #     # - 暗号化の有効化（SSE-S3またはSSE-KMS）
  #     # - アクセスログの有効化
  #     #
  #     # 例: "my-evidently-events-bucket"
  #     bucket = "example-evidently-events"
  #
  #     # prefix - S3オブジェクトキーのプレフィックス
  #     # 説明: バケット内のオブジェクトキーに付加されるプレフィックス
  #     # タイプ: string
  #     # デフォルト: null
  #     #
  #     # 用途:
  #     # - バケット内での整理
  #     # - プロジェクトや環境ごとの分離
  #     # - S3のライフサイクルルール適用
  #     #
  #     # 命名例:
  #     # - "evidently/project-name/"
  #     # - "experiments/production/"
  #     # - "feature-flags/2024/"
  #     #
  #     # 例: "evidently/example-project/"
  #     prefix = "evidently/example/"
  #   }
  # }

  #==============================================================================
  # タイムアウト設定 (Timeouts)
  #==============================================================================
  #
  # 説明: Terraformの操作タイムアウト時間の設定
  # 用途: リソース作成、更新、削除の最大待機時間を制御
  #
  # デフォルトのタイムアウト値:
  # - create: 2分
  # - update: 2分
  # - delete: 2分
  #
  # タイムアウトが必要なケース:
  # - 大規模なプロジェクト（多数のfeatureやexperiment）
  # - ネットワーク遅延がある環境
  # - APIレート制限の影響を受ける場合

  # timeouts {
  #   # create - 作成時のタイムアウト
  #   # 説明: プロジェクト作成の最大待機時間
  #   # 形式: "Xm" (分) または "Xh" (時間)
  #   # デフォルト: "2m"
  #   #
  #   # 例: "5m", "10m"
  #   create = "5m"
  #
  #   # update - 更新時のタイムアウト
  #   # 説明: プロジェクト更新の最大待機時間
  #   # 形式: "Xm" (分) または "Xh" (時間)
  #   # デフォルト: "2m"
  #   #
  #   # 例: "5m", "10m"
  #   update = "5m"
  #
  #   # delete - 削除時のタイムアウト
  #   # 説明: プロジェクト削除の最大待機時間
  #   # 形式: "Xm" (分) または "Xh" (時間)
  #   # デフォルト: "2m"
  #   #
  #   # 注意:
  #   # - 削除前に全てのfeature、experiment、launchを削除する必要があります
  #   # - 依存リソースが多い場合は長めに設定
  #   #
  #   # 例: "5m", "10m"
  #   delete = "5m"
  # }
}

#================================================================================
# 出力値 (Outputs) - Computed Attributes
#================================================================================
#
# 以下の属性は、リソース作成後にAWSから返される値です。
# 他のリソースで参照したり、出力として利用できます。

output "evidently_project_id" {
  description = "プロジェクトID（ARNと同じ値）"
  value       = aws_evidently_project.example.id
  # 例: "arn:aws:evidently:us-east-1:123456789012:project/example-evidently-project"
}

output "evidently_project_arn" {
  description = "プロジェクトのARN"
  value       = aws_evidently_project.example.arn
  # 例: "arn:aws:evidently:us-east-1:123456789012:project/example-evidently-project"
}

output "evidently_project_status" {
  description = "プロジェクトの現在の状態"
  value       = aws_evidently_project.example.status
  # 値: "AVAILABLE" または "UPDATING"
  #
  # AVAILABLE: プロジェクトは使用可能
  # UPDATING: プロジェクトは更新中
}

output "evidently_project_created_time" {
  description = "プロジェクトの作成日時"
  value       = aws_evidently_project.example.created_time
  # 形式: ISO 8601形式のタイムスタンプ
  # 例: "2024-01-15T10:30:00Z"
}

output "evidently_project_last_updated_time" {
  description = "プロジェクトの最終更新日時"
  value       = aws_evidently_project.example.last_updated_time
  # 形式: ISO 8601形式のタイムスタンプ
  # 例: "2024-01-20T14:45:00Z"
}

output "evidently_project_feature_count" {
  description = "プロジェクト内の機能（Feature）の総数"
  value       = aws_evidently_project.example.feature_count
  # 説明: 削除されていない全ての機能の数
  # タイプ: number
}

output "evidently_project_experiment_count" {
  description = "プロジェクト内の実験（Experiment）の総数"
  value       = aws_evidently_project.example.experiment_count
  # 説明: 実施中、終了済み含む全ての実験の数（削除済みは除く）
  # タイプ: number
}

output "evidently_project_active_experiment_count" {
  description = "現在実施中の実験数"
  value       = aws_evidently_project.example.active_experiment_count
  # 説明: 現在アクティブな実験の数
  # タイプ: number
  #
  # 用途:
  # - 実験のリソース使用状況の監視
  # - 同時実験数の制限管理
}

output "evidently_project_launch_count" {
  description = "プロジェクト内のローンチ（Launch）の総数"
  value       = aws_evidently_project.example.launch_count
  # 説明: 実施中、終了済み含む全てのローンチの数（削除済みは除く）
  # タイプ: number
}

output "evidently_project_active_launch_count" {
  description = "現在実施中のローンチ数"
  value       = aws_evidently_project.example.active_launch_count
  # 説明: 現在アクティブなローンチの数
  # タイプ: number
  #
  # 用途:
  # - 段階的リリースの進行状況監視
  # - 同時ローンチ数の管理
}

output "evidently_project_tags_all" {
  description = "プロジェクトに適用された全タグ（プロバイダーのdefault_tags含む）"
  value       = aws_evidently_project.example.tags_all
  # 説明: tagsとプロバイダーのdefault_tagsが統合された完全なタグマップ
  # タイプ: map(string)
}

#================================================================================
# 使用例とベストプラクティス
#================================================================================
#
# 【基本的な使用例】
#
# 1. シンプルなプロジェクト（データ配信なし）
# resource "aws_evidently_project" "simple" {
#   name        = "simple-project"
#   description = "Basic feature flag project"
#   tags = {
#     Environment = "development"
#   }
# }
#
# 2. CloudWatch Logsへの配信設定
# resource "aws_cloudwatch_log_group" "evidently" {
#   name              = "/aws/evidently/my-project"
#   retention_in_days = 7
# }
#
# resource "aws_evidently_project" "with_logs" {
#   name        = "project-with-logs"
#   description = "Project with CloudWatch Logs delivery"
#
#   data_delivery {
#     cloudwatch_logs {
#       log_group = aws_cloudwatch_log_group.evidently.name
#     }
#   }
#
#   tags = {
#     Environment = "production"
#   }
# }
#
# 3. S3への配信設定
# resource "aws_s3_bucket" "evidently_events" {
#   bucket = "my-evidently-events-bucket"
# }
#
# resource "aws_s3_bucket_versioning" "evidently_events" {
#   bucket = aws_s3_bucket.evidently_events.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }
#
# resource "aws_evidently_project" "with_s3" {
#   name        = "project-with-s3"
#   description = "Project with S3 delivery"
#
#   data_delivery {
#     s3_destination {
#       bucket = aws_s3_bucket.evidently_events.bucket
#       prefix = "evidently/experiments/"
#     }
#   }
#
#   tags = {
#     Environment = "production"
#   }
# }
#
# 【IAMポリシー例】
#
# CloudWatch Logsへの書き込み権限:
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "evidently.amazonaws.com"
#       },
#       "Action": [
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ],
#       "Resource": "arn:aws:logs:*:*:log-group:/aws/evidently/*"
#     }
#   ]
# }
#
# S3への書き込み権限:
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "evidently.amazonaws.com"
#       },
#       "Action": [
#         "s3:PutObject",
#         "s3:PutObjectAcl"
#       ],
#       "Resource": "arn:aws:s3:::my-evidently-events-bucket/*"
#     }
#   ]
# }
#
# 【移行に関する注意事項】
#
# CloudWatch Evidentlyは2025年10月17日にサービス終了予定です。
# 以下のステップで AWS AppConfig Feature Flags への移行を推奨します：
#
# 1. 現在のEvidentlyプロジェクトの機能フラグを確認
# 2. AWS AppConfigで新しい機能フラグ環境を作成
# 3. 機能フラグの定義をAppConfigに移行
# 4. アプリケーションコードをAppConfig SDKに更新
# 5. 段階的にトラフィックをAppConfigに移行
# 6. Evidentlyプロジェクトの削除
#
# AppConfig Feature Flags のリソース:
# - resource "aws_appconfig_application"
# - resource "aws_appconfig_environment"
# - resource "aws_appconfig_configuration_profile"
#
# 参考:
# - https://aws.amazon.com/blogs/mt/using-aws-appconfig-feature-flags/
# - https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-feature-flags.html
#
# 【関連リソース】
#
# - aws_evidently_feature: 機能フラグの定義
# - aws_evidently_launch: 段階的リリースの設定
# - aws_evidently_experiment: A/Bテストの実験設定
# - aws_cloudwatch_log_group: CloudWatch Logsのロググループ
# - aws_s3_bucket: S3バケット
# - aws_appconfig_application: AppConfig（移行先）
#
# 【制限事項】
#
# - プロジェクト名はアカウント・リージョン内で一意である必要があります
# - cloudwatch_logsとs3_destinationは同時に設定できません
# - 削除前に全てのfeature、experiment、launchを削除する必要があります
# - 一部のリージョンでは利用できない場合があります
#
# 【コスト考慮事項】
#
# - CloudWatch Evidentlyの使用料金
#   - 評価イベント数に基づく課金
#   - 機能とバリエーションの数による課金
# - CloudWatch Logsのストレージとデータ転送
# - S3ストレージとリクエスト料金
# - APIコール数による課金
#
# 【セキュリティのベストプラクティス】
#
# 1. データ配信先のアクセス制御
#    - S3バケットポリシーの適切な設定
#    - CloudWatch Logsのアクセス権限管理
# 2. 暗号化
#    - S3バケットの暗号化有効化
#    - CloudWatch Logsの暗号化設定
# 3. タグ付けによる管理
#    - コスト配分タグの活用
#    - アクセス制御ポリシーでのタグ利用
# 4. 最小権限の原則
#    - Evidentlyに必要最小限の権限のみ付与
#    - IAMロールとポリシーの適切な設定
#
# 【モニタリングとログ】
#
# - CloudWatch メトリクス:
#   - 評価イベント数
#   - 実験の統計データ
# - CloudWatch Logs:
#   - 評価イベントの詳細ログ
#   - APIコールログ（CloudTrail）
# - AWS CloudTrail:
#   - プロジェクト作成・更新・削除の監査ログ
#   - 設定変更の追跡
#
#================================================================================
