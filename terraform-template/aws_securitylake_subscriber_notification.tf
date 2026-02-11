#---------------------------------------------------------------
# AWS Security Lake Subscriber Notification
#---------------------------------------------------------------
#
# Amazon Security Lakeのサブスクライバー通知をプロビジョニングするリソースです。
# サブスクライバーに対して、購読しているデータソースに新しいデータが書き込まれた
# 際に通知を送信する設定を定義します。通知方法はHTTPSエンドポイントまたは
# Amazon SQSキューの2種類から選択できます。
#
# AWS公式ドキュメント:
#   - NotificationConfiguration API: https://docs.aws.amazon.com/security-lake/latest/APIReference/API_NotificationConfiguration.html
#   - サブスクライバーのデータアクセス管理: https://docs.aws.amazon.com/security-lake/latest/userguide/subscriber-data-access.html
#   - HttpsNotificationConfiguration: https://docs.aws.amazon.com/security-lake/latest/APIReference/API_HttpsNotificationConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securitylake_subscriber_notification
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securitylake_subscriber_notification" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # subscriber_id (Required)
  # 設定内容: 通知サブスクリプションのサブスクライバーIDを指定します。
  # 設定可能な値: 既存のSecurity Lakeサブスクライバーのリソース識別子
  # 注意: aws_securitylake_subscriberリソースのidを使用します。
  # 参考: https://docs.aws.amazon.com/security-lake/latest/userguide/subscriber-management.html
  subscriber_id = aws_securitylake_subscriber.example.id

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: サブスクライバーは作成されたリージョンのデータへのみアクセス可能です。
  #       複数リージョンのデータにアクセスするには、ロールアップリージョンに
  #       サブスクライバーを作成する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 通知設定
  #-------------------------------------------------------------

  # configuration (Required)
  # 設定内容: サブスクライバー通知の作成に使用する設定を指定します。
  # 注意: https_notification_configurationとsqs_notification_configurationは
  #       排他的です（どちらか一方のみ指定可能）。これはAWS APIの
  #       UNION型データ構造に基づいています。
  # 参考: https://docs.aws.amazon.com/security-lake/latest/APIReference/API_NotificationConfiguration.html
  configuration {

    # https_notification_configuration (Optional)
    # 設定内容: HTTPSサブスクライバー通知の設定を指定します。
    # 設定可能な値: httpsNotificationConfigurationブロック
    # 注意: sqs_notification_configurationと排他的（どちらか一方のみ指定可能）
    # 用途: HTTPS APIエンドポイント経由で通知を受信する場合に使用
    # 関連機能: EventBridge API Destinations
    #   Amazon EventBridgeのAPI Destinationsを使用してHTTPSエンドポイントに
    #   イベントを配信します。カスタムの認証ヘッダーやHTTPメソッドの指定が可能。
    #   - https://docs.aws.amazon.com/security-lake/latest/APIReference/API_HttpsNotificationConfiguration.html
    https_notification_configuration {

      # endpoint (Required)
      # 設定内容: Security Lakeのサブスクリプションエンドポイントを指定します。
      # 設定可能な値: HTTPS形式のURL
      # 用途: HTTPSエンドポイント経由での通知を希望する場合に設定
      # 注意: EventBridge API DestinationsまたはAPI Gatewayのエンドポイントを
      #       指定することが一般的です。
      endpoint = "https://example.com/api/notifications"

      # target_role_arn (Required)
      # 設定内容: EventBridge API DestinationsのIAMロールのARNを指定します。
      # 設定可能な値: IAMロールのARN形式の文字列
      # 注意: このロールには、EventBridgeがHTTPSエンドポイントを呼び出すための
      #       適切な権限が必要です。
      # 関連機能: IAMロールとポリシー
      #   Security Lakeのデータアクセスとイベント配信に関する権限管理について、
      #   Amazon Security Lake User Guideの「Managing data access」および
      #   「AWS Managed Policies」を参照してください。
      #   - https://docs.aws.amazon.com/security-lake/latest/userguide/subscriber-data-access.html
      target_role_arn = "arn:aws:iam::123456789012:role/SecurityLakeEventBridgeRole"

      # authorization_api_key_name (Optional)
      # 設定内容: 通知サブスクリプションのAPIキー名を指定します。
      # 設定可能な値: 文字列（カスタムの認証ヘッダー名）
      # 省略時: カスタム認証ヘッダーは設定されません
      # 用途: HTTPSエンドポイントでカスタム認証が必要な場合に、
      #       authorization_api_key_valueと組み合わせて使用
      authorization_api_key_name = null

      # authorization_api_key_value (Optional, Sensitive)
      # 設定内容: 通知サブスクリプションのAPIキー値を指定します。
      # 設定可能な値: 文字列（カスタムの認証ヘッダー値）
      # 省略時: カスタム認証ヘッダーは設定されません
      # 注意: この値は機密情報としてマークされており、Terraformの出力や
      #       ログに表示されません。
      # 用途: HTTPSエンドポイントでカスタム認証が必要な場合に、
      #       authorization_api_key_nameと組み合わせて使用
      authorization_api_key_value = null

      # http_method (Optional)
      # 設定内容: 通知サブスクリプションに使用するHTTPメソッドを指定します。
      # 設定可能な値:
      #   - "POST": POSTメソッドを使用（一般的）
      #   - "PUT": PUTメソッドを使用
      # 省略時: デフォルトのHTTPメソッドが使用されます
      # 用途: HTTPSエンドポイントのAPI仕様に合わせてメソッドを選択
      http_method = "POST"
    }

    # sqs_notification_configuration (Optional)
    # 設定内容: SQS（Simple Queue Service）サブスクライバー通知の設定を指定します。
    # 設定可能な値: 空のブロック（パラメータなし）
    # 注意: https_notification_configurationと排他的（どちらか一方のみ指定可能）
    # 用途: Amazon SQSキュー経由で通知を受信する場合に使用
    # 関連機能: Amazon SQS通知
    #   SQS通知を使用する場合、Security Lakeは自動的にSQSキューを作成し、
    #   新しいデータが利用可能になったときにメッセージを送信します。
    #   sqs_notification_configurationブロック内にパラメータはありません。
    #   - https://docs.aws.amazon.com/security-lake/latest/userguide/subscriber-data-access.html
    # sqs_notification_configuration {}
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サブスクライバー通知のリソース識別子
#
# - subscriber_endpoint: 例外メッセージが送信されるサブスクライバーエンドポイント
#
# - endpoint_id: (非推奨) 例外メッセージが送信されるサブスクライバーエンドポイント
#                subscriber_endpointの使用が推奨されます
#---------------------------------------------------------------
