# AWS CloudTrail リソース設定
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudtrail
#
# 最終更新: 2025-02-12 (Provider Version: 6.28.0)
# Generated: 2026-02-12
#
# AWS CloudTrail は、AWS アカウントのガバナンス、コンプライアンス、運用監査、およびリスク監査を有効にするサービスです。
# API 呼び出しを含む AWS アカウントのアクティビティをイベントとして記録し、S3 バケットに保存します。
#
# NOTE: event_selector と advanced_event_selector は同時に使用できません。
#       用途に応じていずれか一方を選択してください。

#---------------------------------------
# 基本設定
#---------------------------------------
resource "aws_cloudtrail" "example" {
  # 設定内容: CloudTrail の名前
  # 設定可能な値: 任意の文字列（最大128文字）
  # 省略時: 必須パラメータのため指定が必要
  name = "example-trail"

  # 設定内容: CloudTrail ログを保存する S3 バケット名
  # 設定可能な値: 既存の S3 バケット名
  # 省略時: 必須パラメータのため指定が必要
  s3_bucket_name = "my-cloudtrail-bucket"

  # 設定内容: S3 バケット内のログファイルのプレフィックス
  # 設定可能な値: 任意の文字列（S3 キープレフィックス形式）
  # 省略時: プレフィックスなしでルートディレクトリに保存
  s3_key_prefix = "cloudtrail-logs"

  #---------------------------------------
  # ログ記録設定
  #---------------------------------------

  # 設定内容: CloudTrail のログ記録を有効化するかどうか
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: true
  enable_logging = true

  # 設定内容: ログファイルの整合性検証を有効化するかどうか
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: false
  enable_log_file_validation = true

  #---------------------------------------
  # マルチリージョン・組織設定
  #---------------------------------------

  # 設定内容: マルチリージョンの証跡として設定するかどうか
  # 設定可能な値: true（全リージョンのイベントを記録）, false（単一リージョンのみ）
  # 省略時: false
  is_multi_region_trail = true

  # 設定内容: AWS Organizations の組織証跡として設定するかどうか
  # 設定可能な値: true（組織全体のイベントを記録）, false（単一アカウントのみ）
  # 省略時: false
  is_organization_trail = false

  # 設定内容: グローバルサービスのイベントを含めるかどうか
  # 設定可能な値: true（IAM、STS などのグローバルサービスイベントを含む）, false（含まない）
  # 省略時: true（is_multi_region_trail が true の場合は自動的に true）
  include_global_service_events = true

  #---------------------------------------
  # 暗号化設定
  #---------------------------------------

  # 設定内容: ログファイルの暗号化に使用する KMS キーの ARN
  # 設定可能な値: KMS キーの ARN（arn:aws:kms:region:account-id:key/key-id）
  # 省略時: S3 のデフォルト暗号化を使用
  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #---------------------------------------
  # CloudWatch Logs 統合
  #---------------------------------------

  # 設定内容: CloudWatch Logs にログを送信する CloudWatch Logs グループの ARN
  # 設定可能な値: CloudWatch Logs グループの ARN
  # 省略時: CloudWatch Logs への送信なし
  cloud_watch_logs_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs:*"

  # 設定内容: CloudWatch Logs にログを送信するための IAM ロールの ARN
  # 設定可能な値: IAM ロールの ARN
  # 省略時: CloudWatch Logs への送信なし（cloud_watch_logs_group_arn と併せて設定が必要）
  cloud_watch_logs_role_arn = "arn:aws:iam::123456789012:role/CloudTrailRole"

  #---------------------------------------
  # SNS 通知設定
  #---------------------------------------

  # 設定内容: ログファイル配信時に通知を送信する SNS トピック名
  # 設定可能な値: 既存の SNS トピック名
  # 省略時: SNS 通知なし
  sns_topic_name = "cloudtrail-notifications"

  #---------------------------------------
  # イベントセレクター（基本）
  #---------------------------------------

  # 設定内容: 記録するイベントを選択する基本的なイベントセレクター（最大5つ）
  # 注意: advanced_event_selector と同時に使用不可
  event_selector {
    # 設定内容: 管理イベントを含めるかどうか
    # 設定可能な値: true（含む）, false（含まない）
    # 省略時: true
    include_management_events = true

    # 設定内容: 記録するイベントの読み取り/書き込みタイプ
    # 設定可能な値: All（すべて）, ReadOnly（読み取り専用）, WriteOnly（書き込み専用）
    # 省略時: All
    read_write_type = "All"

    # 設定内容: 除外する管理イベントソース
    # 設定可能な値: サービス名のリスト（例: kms.amazonaws.com, rdsdata.amazonaws.com）
    # 省略時: すべての管理イベントを記録
    exclude_management_event_sources = ["kms.amazonaws.com"]

    # 設定内容: 記録するデータイベントのリソース
    data_resource {
      # 設定内容: データリソースのタイプ
      # 設定可能な値: AWS::S3::Object, AWS::Lambda::Function, AWS::DynamoDB::Table など
      # 省略時: 必須パラメータのため指定が必要
      type = "AWS::S3::Object"

      # 設定内容: 記録するリソースの ARN リスト
      # 設定可能な値: リソースの ARN のリスト（ワイルドカード使用可能）
      # 省略時: 必須パラメータのため指定が必要
      values = ["arn:aws:s3:::my-bucket/"]
    }

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda:*:*:function/*"]
    }
  }

  #---------------------------------------
  # イベントセレクター（高度）
  #---------------------------------------

  # 設定内容: より詳細な条件でイベントを選択する高度なイベントセレクター
  # 注意: event_selector と同時に使用不可
  # advanced_event_selector {
  #   # 設定内容: イベントセレクターの名前
  #   # 設定可能な値: 任意の文字列
  #   # 省略時: 名前なし
  #   name = "Log all S3 PutObject events"
  #
  #   # 設定内容: イベントを選択するフィールド条件（最低1つ必要）
  #   field_selector {
  #     # 設定内容: フィルタリングするフィールド名
  #     # 設定可能な値: eventCategory, eventName, readOnly, resources.type, resources.ARN など
  #     # 省略時: 必須パラメータのため指定が必要
  #     field = "eventCategory"
  #
  #     # 設定内容: フィールド値が一致する条件
  #     # 設定可能な値: 文字列のリスト
  #     # 省略時: 条件なし
  #     equals = ["Data"]
  #   }
  #
  #   field_selector {
  #     field  = "resources.type"
  #     equals = ["AWS::S3::Object"]
  #   }
  #
  #   field_selector {
  #     field       = "eventName"
  #     # 設定内容: フィールド値が指定文字列で始まる条件
  #     # 設定可能な値: 文字列のリスト
  #     # 省略時: 条件なし
  #     starts_with = ["PutObject"]
  #   }
  #
  #   # その他の条件演算子:
  #   # - ends_with: 指定文字列で終わる
  #   # - not_equals: 一致しない
  #   # - not_starts_with: 指定文字列で始まらない
  #   # - not_ends_with: 指定文字列で終わらない
  # }

  #---------------------------------------
  # Insights セレクター
  #---------------------------------------

  # 設定内容: CloudTrail Insights を有効化してアカウント内の異常なアクティビティを検出
  insight_selector {
    # 設定内容: Insights のタイプ
    # 設定可能な値: ApiCallRateInsight（API 呼び出し率の異常）, ApiErrorRateInsight（API エラー率の異常）
    # 省略時: 必須パラメータのため指定が必要
    insight_type = "ApiCallRateInsight"
  }

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: このリソースを管理する AWS リージョン
  # 設定可能な値: AWS リージョンコード（us-east-1, ap-northeast-1 など）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-trail"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースから参照可能な属性:
#
# - arn                   : CloudTrail の ARN
# - home_region          : CloudTrail のホームリージョン
# - id                   : CloudTrail の名前（Terraform リソース ID）
# - sns_topic_arn        : 設定された SNS トピックの ARN
# - tags_all             : デフォルトタグを含むすべてのタグ

#---------------------------------------
# 出力例
#---------------------------------------
# output "cloudtrail_arn" {
#   description = "CloudTrail の ARN"
#   value       = aws_cloudtrail.example.arn
# }
#
# output "cloudtrail_home_region" {
#   description = "CloudTrail のホームリージョン"
#   value       = aws_cloudtrail.example.home_region
# }
