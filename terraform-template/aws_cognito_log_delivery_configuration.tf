#################################################
# aws_cognito_log_delivery_configuration
#################################################
# 生成日: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_log_delivery_configuration
#
# Amazon Cognito Log Delivery Configurationは、Cognito User Poolのログ配信設定を管理します。
# ユーザー通知エラー(userNotification)とユーザー認証イベント(userAuthEvents)の2種類のログを
# CloudWatch Logs、Kinesis Data Firehose、またはS3に配信できます。
#
# 公式ドキュメント:
# - Exporting logs: https://docs.aws.amazon.com/cognito/latest/developerguide/exporting-quotas-and-usage.html
# - API Reference: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_SetLogDeliveryConfiguration.html
#################################################

resource "aws_cognito_log_delivery_configuration" "example" {
  #================================================
  # Required Parameters
  #================================================

  # user_pool_id - (Required) Cognito User PoolのID
  # ログ配信設定を適用するUser Poolを指定します。
  # 例: "us-west-2_EXAMPLE"
  user_pool_id = "us-west-2_EXAMPLE"

  #================================================
  # Optional Parameters
  #================================================

  # region - (Optional) このリソースが管理されるAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトとして使用されます。
  # 通常は明示的に指定する必要はありません。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 例: "us-west-2"
  # region = "us-west-2"

  #================================================
  # Block: log_configurations
  #================================================
  # ログ配信の設定を定義するブロックです。
  # 最大2つの設定を指定可能です（userNotification用とuserAuthEvents用を各1つ）。
  #
  # 制約事項:
  # - userNotification: CloudWatch Logsのみサポート、エラーレベル(ERROR)のみ
  # - userAuthEvents: CloudWatch Logs、Firehose、S3をサポート、情報レベル(INFO)のみ
  #                   Plus feature planとThreat Protectionの有効化が必要
  #
  # 各log_configurationsブロックには、以下の配信先の設定を1つ指定する必要があります:
  # - cloud_watch_logs_configuration
  # - firehose_configuration
  # - s3_configuration

  # Example 1: CloudWatch LogsへのuserNotificationログ配信
  log_configurations {
    # event_source - (Required) ログのイベントソース
    # 有効な値:
    # - "userNotification": メール/SMS配信エラーログ (ERROR level)
    # - "userAuthEvents": ユーザー認証イベントログ (INFO level、Plus plan + Threat Protection必須)
    event_source = "userNotification"

    # log_level - (Required) ログレベル
    # 有効な値:
    # - "ERROR": エラーレベルのログ (userNotification用)
    # - "INFO": 情報レベルのログ (userAuthEvents用)
    log_level = "ERROR"

    # cloud_watch_logs_configuration - (Optional) CloudWatch Logs配信設定
    # userNotificationとuserAuthEventsの両方で使用可能
    cloud_watch_logs_configuration {
      # log_group_arn - (Optional) CloudWatch LogsのLog Group ARN
      # ログを配信するLog Groupを指定します。
      # 大きなリソースベースポリシー(5120文字以上)を持つLog Groupの場合、
      # パスを "/aws/vendedlogs" で始める必要があります。
      # 例: "arn:aws:logs:us-west-2:123456789012:log-group:/aws/vendedlogs/cognito-user-pool"
      log_group_arn = "arn:aws:logs:us-west-2:123456789012:log-group:example-user-pool-logs"
    }

    # firehose_configuration - (Optional) Kinesis Data Firehose配信設定
    # userAuthEventsでのみ使用可能（userNotificationでは使用不可）
    # cloud_watch_logs_configurationと同時に指定することはできません
    # firehose_configuration {
    #   # stream_arn - (Optional) Kinesis Data Firehose Delivery StreamのARN
    #   # ログを配信するFirehose Streamを指定します。
    #   # 例: "arn:aws:firehose:us-west-2:123456789012:deliverystream/cognito-logs-stream"
    #   stream_arn = "arn:aws:firehose:us-west-2:123456789012:deliverystream/example-stream"
    # }

    # s3_configuration - (Optional) S3配信設定
    # userAuthEventsでのみ使用可能（userNotificationでは使用不可）
    # cloud_watch_logs_configurationと同時に指定することはできません
    # Amazon CognitoはバケットにAWSLogsフォルダを自動作成する場合があります
    # s3_configuration {
    #   # bucket_arn - (Optional) S3 BucketのARN
    #   # ログを配信するS3 Bucketを指定します。
    #   # 例: "arn:aws:s3:::my-cognito-logs-bucket"
    #   bucket_arn = "arn:aws:s3:::example-cognito-logs-bucket"
    # }
  }

  # Example 2: Firehoseへのユーザー認証イベントログ配信（Plus plan + Threat Protection必須）
  # log_configurations {
  #   event_source = "userAuthEvents"
  #   log_level    = "INFO"
  #
  #   firehose_configuration {
  #     stream_arn = "arn:aws:firehose:us-west-2:123456789012:deliverystream/auth-events-stream"
  #   }
  # }

  # Example 3: S3へのユーザー認証イベントログ配信（Plus plan + Threat Protection必須）
  # log_configurations {
  #   event_source = "userAuthEvents"
  #   log_level    = "INFO"
  #
  #   s3_configuration {
  #     bucket_arn = "arn:aws:s3:::cognito-auth-logs"
  #   }
  # }
}

#================================================
# 補足情報
#================================================
#
# 必要なIAM権限:
# - cognito-idp:SetLogDeliveryConfiguration
# - cognito-idp:GetLogDeliveryConfiguration
# - logs:CreateLogDelivery
# - logs:GetLogDelivery
# - logs:UpdateLogDelivery
# - logs:DeleteLogDelivery
# - logs:ListLogDeliveries
# - logs:PutResourcePolicy (CloudWatch Logs使用時)
# - logs:DescribeResourcePolicies (CloudWatch Logs使用時)
# - logs:DescribeLogGroups (CloudWatch Logs使用時)
#
# サービスリンクロール:
# Amazon Cognitoは自動的にサービスリンクロールを作成し、
# そのロールを使用してログを配信先リソースに送信します。
#
# コスト影響:
# CloudWatch Logs、Kinesis Data Firehose、S3へのデータ取り込みと取得には
# 料金が発生します。詳細は各サービスの料金ページをご確認ください。
#
# ベストエフォート配信:
# ログの配信はベストエフォートであり、ログの量やサービスクォータに
# 応じて配信に影響が出る場合があります。
#
# ログタイプの詳細:
# 1. userNotification:
#    - メール/SMS配信エラーのみ
#    - ERRORレベルのみ
#    - CloudWatch Logsのみサポート
#    - Plus planは不要
#
# 2. userAuthEvents:
#    - ユーザーのサインイン活動とセキュリティ評価
#    - INFOレベルのみ
#    - CloudWatch Logs、Firehose、S3をサポート
#    - Plus feature planとThreat Protection (Audit-only or Full-function) が必須
#
# 参考リンク:
# - CloudWatch Logs Configuration: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_CloudWatchLogsConfigurationType.html
# - Log Configuration Type: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_LogConfigurationType.html
# - Threat Protection: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pool-settings-threat-protection.html
#================================================
