# Terraform AWS Provider Resource Template
# リソース: aws_cognito_log_delivery_configuration
# AWS Provider Version: 6.28.0
# Generated: 2026-02-13
#
# 概要:
# Amazon Cognito User PoolのログをCloudWatch Logs、Kinesis Data Firehose、
# またはS3に配信するための設定を管理します。
#
# 主な機能:
# - ログイベントソースの指定（userNotification、tokenGenerationなど）
# - CloudWatch Logsへのログ配信設定
# - Kinesis Data Firehoseへのログ配信設定
# - S3バケットへのログ配信設定
# - ログレベルの設定（ERROR、INFO、DEBUGなど）
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_log_delivery_configuration
#
# NOTE:
# このテンプレートは学習・参照用です。実際の使用時は環境に応じて適切に調整してください。

#------------------------------------------------------------------------
# 基本設定
#------------------------------------------------------------------------

resource "aws_cognito_log_delivery_configuration" "example" {
  # ユーザープールID（必須）
  # 設定内容: ログ配信を設定するCognito User PoolのID
  # 設定可能な値: 有効なCognito User Pool ID（例: us-east-1_XXXXXXXXX）
  user_pool_id = "us-east-1_XXXXXXXXX"

  # リージョン（オプション）
  # 設定内容: このリソースを管理するリージョン
  # 設定可能な値: 有効なAWSリージョン（例: us-east-1、ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  #------------------------------------------------------------------------
  # ログ配信設定
  #------------------------------------------------------------------------

  log_configurations {
    # イベントソース（必須）
    # 設定内容: ログを記録するCognitoイベントのタイプ
    # 設定可能な値:
    #   - userNotification: ユーザー通知イベント
    #   - tokenGeneration: トークン生成イベント
    #   - userAuthEvents: ユーザー認証イベント
    event_source = "userNotification"

    # ログレベル（必須）
    # 設定内容: 記録するログの詳細度
    # 設定可能な値:
    #   - ERROR: エラーのみ記録
    #   - INFO: 情報レベル以上を記録
    #   - DEBUG: デバッグレベルを含むすべてを記録
    log_level = "ERROR"

    # CloudWatch Logs設定（オプション）
    # 設定内容: CloudWatch Logsへのログ配信設定
    cloud_watch_logs_configuration {
      # ロググループARN（オプション）
      # 設定内容: ログを配信するCloudWatch LogsのロググループARN
      # 設定可能な値: 有効なCloudWatch Logs グループARN
      # 省略時: ログはCloudWatch Logsに配信されない
      log_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/cognito/userpools/example"
    }

    # Kinesis Data Firehose設定（オプション）
    # 設定内容: Kinesis Data Firehoseへのログ配信設定
    # firehose_configuration {
    #   # 配信ストリームARN（オプション）
    #   # 設定内容: ログを配信するKinesis Data Firehose配信ストリームのARN
    #   # 設定可能な値: 有効なKinesis Data Firehose配信ストリームARN
    #   # 省略時: ログはFirehoseに配信されない
    #   stream_arn = "arn:aws:firehose:us-east-1:123456789012:deliverystream/cognito-logs"
    # }

    # S3設定（オプション）
    # 設定内容: S3バケットへのログ配信設定
    # s3_configuration {
    #   # バケットARN（オプション）
    #   # 設定内容: ログを配信するS3バケットのARN
    #   # 設定可能な値: 有効なS3バケットARN
    #   # 省略時: ログはS3に配信されない
    #   bucket_arn = "arn:aws:s3:::cognito-logs-bucket"
    # }
  }

  # 複数のログ配信設定（例）
  # log_configurations {
  #   event_source = "tokenGeneration"
  #   log_level    = "INFO"
  #
  #   s3_configuration {
  #     bucket_arn = "arn:aws:s3:::cognito-token-logs"
  #   }
  # }
}

#------------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#------------------------------------------------------------------------

# このリソースは、設定した属性のみを参照可能です。
# 追加の computed 属性はありません。
#
# 参照方法:
# - aws_cognito_log_delivery_configuration.example.user_pool_id
# - aws_cognito_log_delivery_configuration.example.log_configurations
#
# region属性は、プロバイダー設定値または明示的に指定した値が設定されます。
# - aws_cognito_log_delivery_configuration.example.region
